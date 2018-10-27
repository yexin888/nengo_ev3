import time

import nengo
import numpy as np

import ctn_benchmark
import ctn_benchmark.control as ctrl
from scipy import signal as sig
from nengo_extras.plot_spikes import (
    cluster, merge, plot_spikes, preprocess_spikes, sample_by_variance)
import system2 as system2
import matplotlib.pyplot as plt
import argparse


class ZeroDecoder(nengo.solvers.Solver):
    weights = False
    def __call__(self, A, Y, rng=None, E=None):
        return np.zeros((A.shape[1], Y.shape[1]), dtype=float), []

class AdaptiveBias(ctn_benchmark.Benchmark):
    def __init__(self):
        self.adapt = 1
        self.Kp=1.0
        self.Kd=1.0
        self.Ki=0.0
        self.tau_d=0.001
        self.T= 40
        self.period=5.0
        self.adapt=True
        #self.adapt=False
        self.n_neurons=5000
        self.learning_rate=1e-4
        self.max_freq=1.0
        self.synapse=0.001
        self.radius=1.0
        #debug! test control
        self.D=1
        self.D_in=3
        self.scale_add=1
        self.noise=0.001
        self.filter=0.01
        self.delay=0.001
        self.seed = 1
        self.dt = 0.001
        self.parser = argparse.ArgumentParser(
                            description='Nengo benchmark: %s' %
                                 self.__class__.__name__)
        super(AdaptiveBias, self).__init__()
    def params(self):
        self.default('Kp', Kp=self.Kp)
        self.default('Kd', Kd=self.Kd)
        self.default('Ki', Ki=self.Ki)
        self.default('tau_d', tau_d=self.tau_d)
        self.default('T', T=self.T)
        self.default('period', period=self.period)
        self.default('use adaptation', adapt=self.adapt)
        self.default('n_neurons', n_neurons=self.n_neurons)
        self.default('learning rate', learning_rate=self.learning_rate)
        self.default('max_freq', max_freq=self.max_freq)
        self.default('synapse', synapse=self.synapse)
        self.default('radius', radius=self.radius)
        self.default('number of dimensions', D=self.D)
        self.default('scale_add', scale_add=self.scale_add)
        self.default('noise', noise=self.noise)
        self.default('filter', filter=self.filter)
        self.default('delay', delay=self.delay)

    def model(self,p=None ):

        model = nengo.Network()
        with model:

            system = ctrl.System(self.D, self.D, dt=self.dt, seed=self.seed,
                    motor_noise=self.noise, sense_noise=self.noise,
                    scale_add=self.scale_add,
                    motor_scale=10,
                    motor_delay=self.delay, sensor_delay=self.delay,
                    motor_filter=self.filter, sensor_filter=self.filter)

            self.system = system

            self.system_state = []
            self.system_desired = []
            self.system_t = []
            self.system_control = []
            def minsim_system(t, x):
                self.system_control.append(x)
                self.system_desired.append(np.array([square_signal1(t)]))
                self.system_t.append(t)
                self.system_state.append(system.state)
                return system.step(x)
            
            def square_signal1(t):
                return 2*np.arctan(np.sin(2*np.pi*t*0.1)/.01)/np.pi
                #return sig.square(1 / self.period * np.pi *   t)*1
            desired = nengo.Node(square_signal1, label='desired')

            minsim = nengo.Node(minsim_system, size_in=self.D, size_out=self.D,
                                label='minsim')

            state_node = nengo.Node(lambda t: system.state, label='state')

            pid = ctrl.PID(self.Kp, self.Kd, self.Ki, tau_d=self.tau_d)
            control = nengo.Node(lambda t, x: pid.step(x[:self.D], x[self.D:]),
                                 size_in=self.D*2, label='control')
            nengo.Connection(minsim, control[:self.D], synapse=1e-9)
            nengo.Connection(control, minsim, synapse=None)

            if self.adapt:



                adapt0 = nengo.Ensemble(self.n_neurons, dimensions=self.D_in,
                                       radius=self.radius, label='adapt', seed= self.seed)
                #adapt1 = nengo.Ensemble(self.n_neurons, dimensions=self.D_in,
                #                       radius=self.radius, label='adapt', seed= self.seed+1)
                #adapt2 = nengo.Ensemble(self.n_neurons, dimensions=self.D_in,
                #                       radius=self.radius, label='adapt', seed= self.seed+2)
                #debug! test control
                '''
                desired_ens= nengo.Ensemble(self.n_neurons, dimensions=self.D,
                                       radius=self.radius, label='desired', seed= self.seed)
                minsim_ens = nengo.Ensemble(self.n_neurons, dimensions=self.D,
                                       radius=self.radius, label='minsim', seed= self.seed)
                '''
                nengo.Connection(minsim, adapt0[0], synapse=None)
                nengo.Connection(minsim, adapt0[1], synapse=1e-3)
                nengo.Connection(minsim, adapt0[2], synapse=1e-6)
                #nengo.Connection(desired, adapt0[1], synapse=None)
                '''
                nengo.Connection(minsim, adapt1, synapse=None)
                nengo.Connection(minsim, adapt2, synapse=None)
                '''
                '''
                conn0=nengo.Connection(desired, desired_ens, synapse = None)
                conn1=nengo.Connection(minsim, minsim_ens, synapse = None)
                conn2=nengo.Connection(desired_ens, adapt0[0], synapse=1e-9,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                #nengo.Connection(desired, adapt1[0], synapse=None)
                #nengo.Connection(desired, adapt2[0], synapse=None)
                conn3=nengo.Connection(minsim_ens, adapt0[1], synapse=1e-9,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                #nengo.Connection(minsim, adapt1[1], synapse=None)
                #nengo.Connection(minsim, adapt2[1], synapse=None)
                conn4=nengo.Connection(minsim_ens, adapt0[2], synapse=0.001,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                #nengo.Connection(minsim, adapt1[2], synapse=0.001)
                #nengo.Connection(minsim, adapt2[2], synapse=0.001)
                conn5=nengo.Connection(desired_ens, adapt0[3], synapse=0.001,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                '''
                '''
                nengo.Connection(desired_ens, adapt0[3], synapse=0.001,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                '''
                #nengo.Connection(desired, adapt1[3], synapse=0.001)
                #nengo.Connection(desired, adapt2[3], synapse=0.001)
                #nengo.Connection(control, adapt0[4], synapse=None)
                #nengo.Connection(control, adapt1[4], synapse=None)
                #nengo.Connection(control, adapt2[4], synapse=None)
                #nengo.Connection(control, adapt0[5], synapse=0.001)
                #nengo.Connection(control, adapt1[5], synapse=0.001)
                #nengo.Connection(control, adapt2[5], synapse=0.001)
                #nengo.Connection(adapt0[0], adapt0[5], synapse=0.001)
                #nengo.Connection(adapt1[0], adapt1[5], synapse=0.001)
                #nengo.Connection(adapt2[0], adapt2[5], synapse=0.001)
                conn6 = nengo.Connection(adapt0[0], minsim, synapse=self.synapse,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                '''
                conn7 = nengo.Connection(adapt0[0], adapt0[4], synapse=1e-9,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                conn8=nengo.Connection(desired_ens, adapt0[5], synapse=1e-6,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                conn9=nengo.Connection(minsim_ens, adapt0[6], synapse=1e-6,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                conn10 = nengo.Connection(adapt0[0], adapt0[7], synapse=1e-3,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                conn11 = nengo.Connection(adapt0[0], adapt0[8], synapse=1e-6,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate ))
                '''
                '''
                conn1 = nengo.Connection(adapt1, minsim, synapse=self.synapse,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate/3 ))
                conn2 = nengo.Connection(adapt2, minsim, synapse=self.synapse,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate/3 ))
                '''

                '''
                nengo.Connection(control, conn2.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn3.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn4.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn5.learning_rule, synapse=None,
                        transform=-1)
                '''
                nengo.Connection(control, conn6.learning_rule, synapse=None,
                        transform=-1)
                '''
                nengo.Connection(control, conn7.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn8.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn9.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn10.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn11.learning_rule, synapse=None,
                        transform=-1)
                '''
                '''
                nengo.Connection(control, conn1.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn2.learning_rule, synapse=None,
                        transform=-1)
                '''

            nengo.Connection(desired, control[self.D:], synapse=None)
                
            self.p_desired = nengo.Probe(desired, synapse=None)
            self.p_u = nengo.Probe(control, synapse=None)
            #if self.adapt:
            #    self.decoder_probe = nengo.Probe( conn2, 'weights')
            #    self.decoder_probe0 = nengo.Probe( conn2.learning_rule, 'error')
            #    self.decoder_probe1 = nengo.Probe( conn2.learning_rule, 'activities')
            #    self.decoder_probe2 = nengo.Probe( adapt2.neurons, 'spikes')
            #    self.decoder_probe3 = nengo.Probe( conn2, 'input')
            #    self.decoder_probe4 = nengo.Probe( adapt2.neurons, 'output')
        return model

    def evaluate(self, p, sim, plt):
        sim.run(p.T)

        data_p_q = np.array(self.system_state)
        data_p_desired = np.array(self.system_desired)
        t = np.array(self.system_t)

        np.save('nengo_q',data_p_q)
        np.save('nengo_qd',data_p_desired)
        np.save('nengo_u_all',self.system_control)

        q = data_p_q[:,0]
        d = data_p_desired[:,0]

        N = len(q) / 2

        offsets = []
        for i in range(p.D):
            q = data_p_q[:,i]
            d = data_p_desired[:,i]
            offset = ctn_benchmark.stats.find_offset(q[N:], d[N:])
            if offset == 0:
                offset = 1
            offsets.append(offset)
        offset = int(np.mean(offsets))
        delay = np.mean(t[1:] - t[:-1]) * offset

        if plt is not None:
            plt.plot(t[offset:], d[:-offset], label='$q_d$')
            plt.plot(t[offset:], q[offset:], label='$q$')
            plt.legend(loc='upper left')
            plt.figure()
            plt.plot(self.system_control)
            plt.title('u all')
            plt.legend(loc=0)

        diff = data_p_desired[:-offset] - data_p_q[offset:]
        diff = diff[N:]
        rmse = np.sqrt(np.mean(diff.flatten()**2))


        return dict(delay=delay, rmse=rmse)

class CoreRobot():
    def __init__(self):
        self.adaptivebias = AdaptiveBias() 
        self.model = self.adaptivebias.model()
        self.sim = nengo.Simulator(self.model, dt=self.adaptivebias.dt)
        self.s = system2.System(self.model, self.sim)
        self.motor_synapse_scale =0.9048374180359595
        self.motor_synpase_scale_value = 0  
        self.pid = ctrl.PID(self.adaptivebias.Kp, self.adaptivebias.Kd, self.adaptivebias.Ki, tau_d=self.adaptivebias.tau_d)
        self.data_stim = []
        self.u_a = [0]
        self.u = [0]
        self.u_all = []
        self.q = []
        self.qd = []
        self.output_values = {}
    
    def square_signal1(self,t):
        return sig.square(1 / self.adaptivebias.period * np.pi *   t)*1

    def step(self,para):

        #print (q[0])
        #print (q[1])
        #print (q)
        #print(para[0])
        t = (para[0]+1) * self.adaptivebias.dt
        #print(t)
        #print(t)
        #self.q.append( self.adaptivebias.system.step(np.array(u_all[-1]))[0] )
        self.q.append(para[1])
        self.qd.append(self.square_signal1(t))
        self.u.append(self.pid.step(np.array([self.q[-1]]),np.array([self.qd[-1]]))[0])

        outputs = [c.step(np.array([self.q[-1]]), error=np.array([-self.u[-1]])) for c in self.s.ens2core.values()]
        output = np.sum(outputs, axis=0)
        self.motor_synpase_scale_value = (1-self.motor_synapse_scale)*self.motor_synpase_scale_value +self.motor_synapse_scale * output
        nengo_result = self.motor_synpase_scale_value
        self.u_a.append(nengo_result)
        self.u_all.append( self.u_a[-1]  + self.u[-1])
        return [self.u_all[-1],self.qd[-1]]


if __name__ == '__main__':
    
    AdaptiveBias().run()
    '''
    adaptivebias = AdaptiveBias() 
    model = adaptivebias.model()
    sim = nengo.Simulator(model, dt=adaptivebias.dt)
    s = system2.System(model, sim)
    motor_synapse_scale =0.9048374180359595
    motor_synpase_scale_value = 0  
    
    steps = int(adaptivebias.T / adaptivebias.dt)
    data_stim = []
    u_a = [0]
    u = [0]
    u_all = []
    q = []
    qd = []
    output_values = {}
    pid = ctrl.PID(adaptivebias.Kp, adaptivebias.Kd, adaptivebias.Ki, tau_d=adaptivebias.tau_d)
    def square_signal1(t):
        return sig.square(1 / adaptivebias.period * np.pi *   t)*1

    for i in range(steps):
        t = (i+1) * adaptivebias.dt
        u_all.append( u_a[-1]  + u[-1])
        q.append( adaptivebias.system.step(np.array(u_all[-1]))[0] )
        qd.append(square_signal1(t))
        u.append(pid.step(np.array([q[-1]]),np.array([qd[-1]]))[0])

        outputs = [c.step(np.array([q[-1]]), error=np.array([-u[-1]])) for c in s.ens2core.values()]
        output = np.sum(outputs, axis=0)
        motor_synpase_scale_value = (1-motor_synapse_scale)*motor_synpase_scale_value + motor_synapse_scale * output;
	nengo_result = motor_synpase_scale_value
        u_a.append(nengo_result)


    np.save('python_u_all',u_all)
    np.save('python_q',q)
    np.save('python_qd',qd)
    '''
    nengo_u_all = np.load('nengo_u_all.npy')
    nengo_q = np.load('nengo_q.npy')
    nengo_qd = np.load('nengo_qd.npy')

    plt.figure()
    #plt.plot(q, 'r', label = 'core.py q')
    #plt.plot(qd, 'g', label = 'core.py qd')
    plt.plot(nengo_qd, 'g', label = 'core.py qd')
    plt.plot(nengo_q, 'b', label = 'nengo q')
    #plt.xlim(0,adaptivebias.T*1000)
    plt.ylim(-1.5,1.5)
    plt.legend(loc=0)
    '''
    plt.figure()
    plt.plot(u_all , 'r', label = 'core.py u all')
    plt.plot(nengo_u_all, 'b', label = 'nengo u all')
    plt.xlim(0,adaptivebias.T*1000)
    plt.ylim(-5,15)
    plt.legend(loc=0)
    '''
    plt.show()


