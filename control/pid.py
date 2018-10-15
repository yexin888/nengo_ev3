import numpy as np
import nengo
import time

class PID(object):
    def __init__(self, Kp, Kd=0, Ki=0, J=None, tau_d=0.1, dt=0.001):
        self.Kp = Kp
        self.Kd = Kd
        self.Ki = Ki

        self.start_time = time.time()
        self.record_data = 0
        self.real_times = []
        self.pid_input_states = []
        self.pid_desired_states = []
        self.pid_ps = []
        self.pid_ds = []


        if J is not None:
            x = np.dot(J.T, J)
            scale = np.linalg.det(x) ** (1.0 / x.shape[0])
            self.JT = J.T / scale
        else:
            self.JT = None

        self.scale = np.exp(-dt / tau_d)
        self.dt = dt
        self.reset()

    def reset(self):
        self.prev_state = None
        self.dstate = None
        self.istate = None

    def step(self, state, desired_state, desired_dstate=0):
        if self.prev_state is None:
            self.prev_state = state
            self.dstate = np.zeros_like(state)
            self.istate = np.zeros_like(state)
        else:
            d = state - self.prev_state
            self.dstate = self.dstate * self.scale + d * (1.0 - self.scale)
            self.istate += self.dt * (desired_state - state)

        self.prev_state = state[:]

        pid_p = self.Kp * (desired_state - state)
        pid_d = self.Kd * (desired_dstate - self.dstate)

        self.real_times.append(time.time()-self.start_time)
        self.pid_input_states.append(state[0])
        self.pid_desired_states.append(desired_state[0])
        self.pid_ps.append(pid_p)
        self.pid_ds.append(pid_d)

        if time.time()-self.start_time > 30 and self.record_data == 0:
            np.save('pid_real_times',self.real_times)
            np.save('pid_input_states',self.pid_input_states)
            np.save('pid_desired_states',self.pid_desired_states)
            np.save('pid_ps',self.pid_ps)
            np.save('pid_ds',self.pid_ds)
            self.record_data = 1

        v = (self.Kp * (desired_state - state) +
             self.Kd * (desired_dstate - self.dstate) +
             self.Ki * self.istate)
        if self.JT is not None:
            v = np.dot(v, self.JT)
        time.sleep(0.001)
        return v

class PDAdapt(PID):
    def __init__(self, dim, Kp, Kd=0, tau_d=0.1, dt=0.001, synapse=0.01,
                 n_neurons=500, learning_rate=1.0):
        self.dim = dim
        self.synapse = synapse
        self.n_neurons = n_neurons
        self.learning_rate = learning_rate
        super(PDAdapt, self).__init__(Kp=Kp, Kd=Kd, tau_d=tau_d, dt=dt)

    def reset(self):
        super(PDAdapt, self).reset()
        self.model = nengo.Network()
        with self.model:
            stim_state = nengo.Node(self.stim_state, 
                                    size_in=0, size_out=self.dim)
            stim_control = nengo.Node(self.stim_control,
                                      size_in=0, size_out=self.dim)
            adapt = nengo.Ensemble(self.n_neurons, self.dim)
            response = nengo.Node(self.response, size_in=self.dim, size_out=0)
            nengo.Connection(stim_state, adapt, synapse=None)
            conn = nengo.Connection(adapt, response, synapse=self.synapse,
                    function=lambda x: [0] * self.dim,
                    learning_rule_type=nengo.PES())
            conn.learning_rule_type.learning_rate *= self.learning_rate
            nengo.Connection(stim_control, conn.learning_rule, synapse=None,
                             transform=-1)
        self.sim = nengo.Simulator(self.model)

    def stim_state(self, t):
        return self.prev_state

    def stim_control(self, t):
        return self.control

    def response(self, t, x):
        self.result = x

    def step(self, state, desired_state, desired_dstate=0):
        self.control = super(PDAdapt, self).step(state, desired_state, desired_dstate)
        self.sim.run(self.dt, progress_bar=False)
        return self.control + self.result


