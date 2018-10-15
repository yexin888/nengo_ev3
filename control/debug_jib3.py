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
        self.Kp=2.0
        self.Kd=1.0
        self.Ki=0.0
        self.tau_d=0.001
        self.T=4
        self.period=2.0
        self.adapt=True
        #self.adapt=False
        self.n_neurons=150
        self.learning_rate=1e-4
        self.max_freq=1.0
        self.synapse=0.01
        self.radius=1.0
        self.D=1
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
                #self.system_desired.append(signal.value(t))
                self.system_desired.append(np.array([square_signal1(t)]))
                self.system_t.append(t)
                self.system_state.append(system.state)
                return system.step(x)

            minsim = nengo.Node(minsim_system, size_in=self.D, size_out=self.D,
                                label='minsim')

            state_node = nengo.Node(lambda t: system.state, label='state')

            pid = ctrl.PID(self.Kp, self.Kd, self.Ki, tau_d=self.tau_d)
            control = nengo.Node(lambda t, x: pid.step(x[:self.D], x[self.D:]),
                                 size_in=self.D*2, label='control')
            nengo.Connection(minsim, control[:self.D], synapse=1e-9)
            #nengo.Connection(minsim, control[:p.D], synapse=0)
            nengo.Connection(control, minsim, synapse=None)
            #self.control_probe=nengo.Probe(control)

            if self.adapt:


                adapt0 = nengo.Ensemble(self.n_neurons, dimensions=self.D,
                                       radius=self.radius, label='adapt', seed= self.seed)
                adapt1 = nengo.Ensemble(self.n_neurons, dimensions=self.D,
                                       radius=self.radius, label='adapt', seed= self.seed+1)
                adapt2 = nengo.Ensemble(self.n_neurons, dimensions=self.D,
                                       radius=self.radius, label='adapt', seed= self.seed+2)
                nengo.Connection(minsim, adapt0, synapse=None)
                nengo.Connection(minsim, adapt1, synapse=None)
                nengo.Connection(minsim, adapt2, synapse=None)
                conn0 = nengo.Connection(adapt0, minsim, synapse=self.synapse,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate/3 ))
                conn1 = nengo.Connection(adapt1, minsim, synapse=self.synapse,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate/3 ))
                conn2 = nengo.Connection(adapt2, minsim, synapse=self.synapse,
                        function=lambda x: [0]*self.D,
                        solver=ZeroDecoder(),
                        learning_rule_type=nengo.PES(learning_rate = self.learning_rate/3 ))
                #conn.learning_rule_type.learning_rate *= p.learning_rate
                nengo.Connection(control, conn0.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn1.learning_rule, synapse=None,
                        transform=-1)
                nengo.Connection(control, conn2.learning_rule, synapse=None,
                        transform=-1)

            def square_signal1(t):
                return sig.square(1 / self.period * np.pi *   t)*1
            #signal = ctrl.Signal(self.D, self.period, dt=self.dt, max_freq=self.max_freq, seed=self.seed)
            #desired = nengo.Node(signal.value, label='desired')
            desired = nengo.Node(square_signal1, label='desired')
            nengo.Connection(desired, control[self.D:], synapse=None)
                
            self.p_desired = nengo.Probe(desired, synapse=None)
            # TODO: why doesn't this probe work on nengo_spinnaker?
            #self.p_q = nengo.Probe(state_node, synapse=None)
            self.p_u = nengo.Probe(control, synapse=None)
            if self.adapt:
                self.decoder_probe = nengo.Probe( conn2, 'weights')
                self.decoder_probe0 = nengo.Probe( conn2.learning_rule, 'error')
                self.decoder_probe1 = nengo.Probe( conn2.learning_rule, 'activities')
                self.decoder_probe2 = nengo.Probe( adapt2.neurons, 'spikes')
                self.decoder_probe3 = nengo.Probe( conn2, 'input')
                self.decoder_probe4 = nengo.Probe( adapt2.neurons, 'output')
                #print(conn2.learning_rule.probeable)
                #print(adapt2.neurons.probeable)
                #print(conn2.probeable)
        return model

    def evaluate(self, p, sim, plt):
        #start_time = time.time()
        #while time.time() - start_time < p.T:
        #    sim.run(p.dt, progress_bar=False)
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

        # find an offset that lines up the data best (this is the delay)
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
            #plt.plot(t[offset:], d[offset:])
            plt.plot(t[offset:], q[offset:], label='$q$')
            plt.legend(loc='upper left')
            plt.figure()
            plt.plot(self.system_control)
            plt.title('u all')
            if p.adapt:
                '''
                plt.figure()
                #print(sim.data[self.decoder_probe0])
                #print(sim.data[self.decoder_probe1])
                plt.plot(sim.data[self.decoder_probe0])
                plt.title('error')
                plt.figure()
                plt.plot(sim.data[self.decoder_probe1][:,10])
                plt.title('activities')
                plt.figure()
                plt.plot(sim.data[self.decoder_probe][:,0,10])
                plt.title('weights')
                plt.figure()
                plot_spikes(sim.trange(), sim.data[self.decoder_probe2])
                #plt.plot(sim.data[self.decoder_probe2][:,0,10])
                plt.title('spikes')
                #print(sim.data[self.decoder_probe3])
                plt.figure()
                plt.plot(sim.data[self.decoder_probe3][:,10])
                plt.title('conn input')
                print(sim.data[self.decoder_probe4])
                plt.figure()
                plt.plot(sim.data[self.decoder_probe4][:,10])
                plt.title('neuron output')
                '''
            #print(sim.data[self.decoder_probe])
            #plt.plot(sim.data[self.control_probe],label='pd control output')
            #if p.adapt:
            #    plt.plot(sim.data[self.adapt_probe], label='adapt output')
            plt.legend(loc=0)

            #plt.plot(np.correlate(d, q, 'full')[len(q):])


        diff = data_p_desired[:-offset] - data_p_q[offset:]
        diff = diff[N:]
        rmse = np.sqrt(np.mean(diff.flatten()**2))


        return dict(delay=delay, rmse=rmse)

if __name__ == '__main__':
    
    AdaptiveBias().run()

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
        # generate some input to give the model
        t = (i+1) * adaptivebias.dt
        #stim = [np.sin(t*2*np.pi), np.cos(t*2*np.pi)]
        u_all.append( u_a[-1]  + u[-1])
        #print(u_all[-1])
        #print(u_a[-1]  + u[-1])
        q.append( adaptivebias.system.step(np.array(u_all[-1]))[0] )
        qd.append(square_signal1(t))
        u.append(pid.step(np.array([q[-1]]),np.array([qd[-1]]))[0])

        # run the model one time step
        outputs = [c.step(np.array([q[-1]]), error=np.array([-u[-1]])) for c in s.ens2core.values()]
        output = np.sum(outputs, axis=0)
        motor_synpase_scale_value = (1-motor_synapse_scale)*motor_synpase_scale_value + motor_synapse_scale * output;
	nengo_result = motor_synpase_scale_value
        #print(nengo_result)
        u_a.append(nengo_result)


    np.save('python_u_all',u_all)
    np.save('python_q',q)
    np.save('python_qd',qd)

    nengo_u_all = np.load('nengo_u_all.npy')
    nengo_q = np.load('nengo_q.npy')
    nengo_qd = np.load('nengo_qd.npy')

    plt.figure()
    plt.plot(q, 'r', label = 'core.py q')
    plt.plot(qd, 'g', label = 'core.py qd')
    plt.plot(nengo_q, 'b', label = 'nengo q')
    plt.xlim(0,4000)
    plt.ylim(-1.5,1.5)
    plt.legend(loc=0)
    plt.figure()
    #plt.title('python u all')
    plt.plot(u_all , 'r', label = 'core.py u all')
    plt.plot(nengo_u_all, 'b', label = 'nengo u all')
    plt.xlim(0,4000)
    plt.ylim(-5,15)
    plt.legend(loc=0)
    '''
    plt.figure()
    plt.title('python u ')
    plt.plot(u)
    plt.xlim(0,100)
    plt.ylim(-5,15)
    plt.figure()
    plt.title('python u a ')
    plt.plot(u_a)
    plt.xlim(0,100)
    plt.ylim(-5,15)
    '''
    plt.show()


