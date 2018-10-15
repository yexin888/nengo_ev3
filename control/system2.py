import nengo
import numpy as np

import core

class Message(object):
    def __init__(self, 
                 pre_obj, pre_start, pre_len, 
                 post_obj, post_start, post_len,
                 matrix, synapse, dt, mess_id=0):
        self.pre_obj = pre_obj        # object to read from
        self.pre_start = pre_start    # index to start reading from
        self.pre_len = pre_len        # number of values to read
        self.post_obj = post_obj      # object to send to
        self.post_start = post_start  # index to start sending to
        self.post_len = post_len      # number of values to send
        self.matrix = matrix          # matrix multiply to apply (or scalar)
        self.mess_id = mess_id
        self.matrix_is_scalar = 0

        # optional low-pass filter to apply
        if synapse is None:
            self.synapse_scale = None
        else:
            self.synapse_scale = np.exp(-dt/synapse)
        self.value = np.zeros(post_len)

    def apply(self, input_values, output_values):
        # grab the full output
        v = output_values[self.pre_obj]
        # just grab the slice we need
        v = v[self.pre_start:self.pre_start+self.pre_len]

        # apply the matrix multiply (note this may just be a scalar or even 1)
        v = np.dot(self.matrix, v)

        # apply the low-pass filter
        if self.synapse_scale is not None:
            self.value = (1-self.synapse_scale)*self.value + self.synapse_scale*v
            v = self.value

        # set the result
        target = input_values[self.post_obj]
        target[self.post_start:self.post_start+self.post_len] += v


class Intermediate(object):
    def __init__(self, size,inter_id=0):#debug! inter_id for hardware
        self.size = size
        #debug! for hardware
        self.obj_id = inter_id

    def step(self, input):
        if self.obj_id == 19:
            print(input[0])

        return input.copy()


class System(object):
    def __init__(self, model, sim):
        self.ens2core = {}          # mapping from nengo.Ensembles to Cores
        self.node2inter = {}        # mapping from nengo.Nodes to Intermediate

        self.input_values = {}      # the accumulated input for each Core
                                    #  and Intermediate object

        self.messages = []          # the set of messages that must be sent
                                    #  each time step

        #debug! for hardware
        #self.output_dims = []
        self.pre_starts = []
        self.pre_lens = []
        self.post_starts = []
        self.post_lens = []

        self.learning_enabled=[]

        self.extract_data_from_nengo(model, sim)



    def extract_data_from_nengo(self, model, sim):

        # find all the Connections out of an Ensemble
        conns_out = {}
        for ens in model.all_ensembles:
            conns_out[ens] = []
        for c in model.all_connections:
            if isinstance(c.pre_obj, nengo.Ensemble):
                conns_out[c.pre_obj].append(c)

        conn_dec_range = {}
        #debug! for hardware
        ens_id_dict = {}
        inter_id_dict = {}
        id_counter = 0 

        n_neurons_all=0
        computation_all=0
        memory_all = 0
        print("n_ensembles: "+str(len(model.all_ensembles)))
        for ens in model.all_ensembles:
            funcs = []
            dec = []
            size = 0
            ranges = []
            # build up a decoder for all the computations from this Ensemble
            for conn in conns_out[ens]:
                if conn.function not in funcs:
                    funcs.append(conn.function)
                    dec.append(sim.data[conn].weights)
                    width = sim.data[conn].weights.shape[0]
                    ranges.append((size, size+width))
                    size += width
                index = funcs.index(conn.function)
                conn_dec_range[conn] = ranges[index]
            dec = np.vstack(dec)

            # generate the Core for this Ensemble
            c = core.Core(n_inputs=ens.dimensions,
                          n_neurons=ens.n_neurons,
                          n_outputs=dec.shape[0],
                          encoders = sim.data[ens].scaled_encoders,
                          bias = sim.data[ens].bias,
                          decoders = dec,
                          tau_rc=ens.neuron_type.tau_rc,
                          tau_ref=ens.neuron_type.tau_ref,
                          #tau_ref = 0.003,
                          dt=sim.dt,
                          learning_rate=1e-4,
                          learning_filter = 0.01, 
                          ens_id = id_counter
                          )
            self.ens2core[ens] = c
            #debug! for hardware
            #ens_id_dict[c] = id_counter
            #self.output_dims.append(c.n_outputs)
            id_counter +=1

            self.input_values[c] = np.zeros(c.n_inputs)

            #debug! for hardware
            #print("n_input: "+str(ens.dimensions))
            #print("n_neurons: "+str(ens.n_neurons))
            #print("n_output: "+str(c.n_outputs))
            #profiling
            #memory_all += ens.dimensions*ens.n_neurons #encoders
            #memory_all += c.n_outputs * ens.n_neurons  #decoders
            #memory_all += ens.n_neurons #bias
            #memory_all += ens.n_neurons*2 #neurons, input currents

            #encoder_computation += (ens.dimensions)*ens.n_neurons*9
            #neuron_computation += 61*ens.n_neurons
            #n_neurons_all += ens.n_neurons
            #computation_all += 11*ens.n_neurons*ens.dimensions + 61*ens.n_neurons + 182*ens.dimensions 

        #print("n_neurons_all: "+str(n_neurons_all))
        #print("computation_all: "+str(computation_all))
        #print("memory_all: "+str(memory_all*4/1024.))
        #debug! for hardware

        #self.generate_ensemble_data(self.ens2core.values()[5:11],1, 6)

        #generate Intermediate objects for each Node
        #print("n_connections: "+str(len(model.all_connections)))

        #debug! for hardware     generation of intermediate data skipped
        
        print("n_nodes: "+str(len(model.all_nodes)))
        for n in model.all_nodes:
            #assert n.output is None
            if n.output is not None:
                print (n.output)
            inter = Intermediate(n.size_in,id_counter)
            self.node2inter[n] = inter
            self.input_values[inter] = np.zeros(inter.size)
            #debug! for hardware
            #inter_id_dict[inter] = id_counter
            id_counter +=1

        #debug! for hardware
        #self.generate_inter_data(self.node2inter.values(),2,len(model.all_nodes))
        
        # generate all of the Messages
        print("n_connections: "+str(len(model.all_connections)))
        mess_id_counter = 0 
        for conn in model.all_connections:
            pre_obj = conn.pre_obj
            if conn.function is None:
                pre_indices = np.arange(pre_obj.size_out)[conn.pre_slice]
            else:
                pre_indices = np.arange(conn.size_mid)

            if isinstance(pre_obj, nengo.Ensemble):
                r = conn_dec_range[conn]
                indices = np.arange(self.ens2core[pre_obj].n_outputs)
                indices = indices[r[0]:r[1]]
                pre_indices = indices[pre_indices]

            post_obj = conn.post_obj
            post_indices = np.arange(post_obj.size_in)[conn.post_slice]

            pre_start = pre_indices[0]
            pre_len = pre_indices[-1] - pre_start + 1
            if pre_len != len(pre_indices):
                print(pre_indices)
            assert pre_len == len(pre_indices)

            post_start = post_indices[0]
            post_len = post_indices[-1] - post_start + 1
            assert post_len == len(post_indices)
    
            pre_obj_temp = pre_obj
            post_obj_temp = post_obj

            pre_obj = self.ens2core.get(pre_obj, pre_obj)
            post_obj = self.ens2core.get(post_obj, post_obj)
            pre_obj = self.node2inter.get(pre_obj, pre_obj)
            post_obj = self.node2inter.get(post_obj, post_obj)

            if not ( pre_obj_temp == pre_obj or post_obj_temp == post_obj):# if the message is connecting ensembles or nodes instead of learning rules.
            
                #print('abc')
                m = Message(pre_obj, pre_start, pre_len,
                            post_obj, post_start, post_len,
                            matrix=conn.transform,
                            synapse=(None if conn.synapse is None
                                     else conn.synapse.tau),
                            dt=sim.dt, mess_id = mess_id_counter)
                self.messages.append(m)
                #debug! for hardware
                mess_id_counter +=1

            if conn.learning_rule_type != None:
                self.learning_enabled.append(pre_obj.obj_id)
        #self.generate_mess_data(self.messages,0,[0])
        self.generate_ensemble_and_mess_data(self.ens2core.values(), self.messages,0, [0])
        self.generate_ensemble_and_mess_data(self.ens2core.values(), self.messages,1, [1])
        self.generate_ensemble_and_mess_data(self.ens2core.values(), self.messages,2, [2])

    #debug! for hardware
    def generate_ensemble_and_mess_data(self, cores,messages , core_id, ens_id_range ):
        
        f = open('ensemble_mess_data_core_'+str(core_id)+'.c','w')
        f.write("#include \"qpe.h\"\n")
        f.write("#include \"common/neuron-typedefs.h\"\n")
        f.write("#include \"param_defs.h\"\n")
        
        for core in cores:

            #print(core.obj_id)
            if core.obj_id in ens_id_range:
                #f.write("#define N_NEURONS "+str(ens.n_neurons)+"\n")
                #f.write("#define N_INPUTS "+str(ens.dimensions)+"\n")
                #f.write("#define N_OUTPUTS "+str(output.size_in)+"\n")
                f.write("precision_t encoders"+str(core.obj_id)+"["+str(core.n_inputs)+"*"+str(core.n_neurons)+"]={\n")
                for i in range(core.n_neurons):
                    for j in range(core.n_inputs):
                        if not (i == core.n_neurons -1 and j == core.n_inputs-1):
                            f.write(str(core.encoders[i][j])+",\n")
                        else:
                            f.write(str(core.encoders[i][j])+"\n")
            
                f.write("};\n")
                f.write("precision_t bias"+str(core.obj_id)+"["+str(core.n_neurons)+"]={\n")
                for i in range(core.n_neurons):
                    if not (i == core.n_neurons -1 ):
                        f.write(str(core.bias[i])+",\n")
                    else:
                        f.write(str(core.bias[i])+"\n")
                f.write("};\n")
                f.write("precision_t decoders"+str(core.obj_id)+"["+str(core.n_neurons)+"*"+str(core.n_outputs)+"]={\n")
                for j in range(core.n_neurons):
                    for i in range(core.n_outputs):
                        if not (i == core.n_outputs- 1 and j == core.n_neurons - 1 ):
                            f.write(str(core.decoders[i][j])+",\n")
                        else:
                            f.write(str(core.decoders[i][j])+"\n")
                f.write("};\n")
                
                f.write("precision_t inputs"+str(core.obj_id)+"["+str(core.n_inputs)+"];\n")
                f.write("precision_t outputs"+str(core.obj_id)+"["+str(core.n_outputs)+"];\n")
                f.write("neuron_t neurons"+str(core.obj_id)+"["+str(core.n_neurons)+"];\n")
                f.write("precision_t input_currents"+str(core.obj_id)+"["+str(core.n_neurons)+"];\n")
                if core.obj_id in self.learning_enabled:
                    f.write("REAL learning_activity"+str(core.obj_id)+"["+str(core.n_neurons)+"];\n")
                    f.write("REAL error"+str(core.obj_id)+"["+str(core.n_outputs)+"];\n")
                    f.write("REAL delta"+str(core.obj_id)+"["+str(core.n_outputs*core.n_neurons)+"];\n")

                #f.write("#endif\n")
        
        f.write("ensemble_t ensembles["+str(len(ens_id_range))+"];\n")
        f.write("uint32_t n_ensembles= "+str(len(ens_id_range))+";\n")

        core_count = 0
        input_count = 0
        f.write("void ensemble_init(){\n")
        for core in cores:

            if core.obj_id in ens_id_range:
                
                f.write("ensembles["+str(core_count)+"].encoders = encoders"+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].bias     = bias"+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].decoders = decoders"+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].n_inputs = "+str(core.n_inputs)+";\n")
                f.write("ensembles["+str(core_count)+"].n_neurons= "+str(core.n_neurons)+";\n")
                f.write("ensembles["+str(core_count)+"].n_outputs= "+str(core.n_outputs)+";\n")
                f.write("ensembles["+str(core_count)+"].tau_rc   = "+str(core.tau_rc*1000)+";\n")
                f.write("ensembles["+str(core_count)+"].tau_ref  = "+str(core.tau_ref*1000)+";\n")
                f.write("ensembles["+str(core_count)+"].obj_id   = "+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].inputs   = inputs"+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].outputs  = outputs"+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].neurons  = neurons"+str(core.obj_id)+";\n")
                f.write("ensembles["+str(core_count)+"].input_currents= input_currents"+str(core.obj_id)+";\n")
                if core.obj_id in self.learning_enabled:
                    f.write("ensembles["+str(core_count)+"].learning_activity= learning_activity"+str(core.obj_id)+";\n")
                    f.write("ensembles["+str(core_count)+"].learning_enabled = 1;\n")
                    f.write("ensembles["+str(core_count)+"].learning_rate = "+str(core.learning_rate)+";\n")
                    f.write("ensembles["+str(core_count)+"].learning_scale = "+str(core.learning_scale)+";\n")
                    f.write("ensembles["+str(core_count)+"].error = error"+str(core.obj_id)+";\n")
                    f.write("ensembles["+str(core_count)+"].delta = delta"+str(core.obj_id)+";\n")
                else:
                    f.write("ensembles["+str(core_count)+"].learning_enabled = 0;\n")

                core_count+=1
                input_count += core.n_inputs


        f.write("}\n")
        #f.write("REAL input_state["+str(input_count)+"];\n")
        mess_count=0
        for mess in messages:
            #print(mess.post_obj.obj_id)
            if mess.post_obj.obj_id in ens_id_range:
                mess_count+=1
                f.write("precision_t pre_values"+str(mess.mess_id)+"["+str(mess.pre_len)+"];\n")
                f.write("precision_t post_values"+str(mess.mess_id)+"["+str(mess.post_len)+"];\n")
                if np.array(mess.matrix).shape==():
                    mess.matrix = [[mess.matrix]]
                    mess.matrix_is_scalar = 1
                else:
                    mess.matrix_is_scalar = 0
                matrix_x = np.array(mess.matrix).shape[0]
                matrix_y = np.array(mess.matrix).shape[1]
                #print("message "+str(mess.mess_id))
                #print("x "+str(matrix_x)+" y "+str(matrix_y))
                #print(mess.matrix)
                f.write("precision_t matrix"+str(mess.mess_id)+"["+str(matrix_x)+"*"+str(matrix_y)+"]={\n")
                for i in range(matrix_x):
                    for j in range(matrix_y):
                        if not (i == matrix_x -1 and j == matrix_y -1 ):
                            f.write(str(mess.matrix[i][j])+",\n")
                        else:
                            f.write(str(mess.matrix[i][j])+"\n")
                f.write("};\n")
                if mess.synapse_scale is not None:
                    f.write("precision_t synapse_scale_values"+str(mess.mess_id)+"["+str(mess.post_len)+"];\n")


        
        f.write("message_t mess["+str(mess_count)+"];\n")
        f.write("uint32_t n_mess= "+str(mess_count)+";\n")
        mess_count = 0
        f.write("void mess_init(){\n")
        for mess in messages:
            if mess.post_obj.obj_id in ens_id_range:
                f.write("\n")
                f.write("mess["+str(mess_count)+"].pre_obj_id = "+str(mess.pre_obj.obj_id)+";\n")
                f.write("mess["+str(mess_count)+"].pre_start  = "+str(mess.pre_start)+";\n")
                f.write("mess["+str(mess_count)+"].pre_len    = "+str(mess.pre_len)+";\n")
                f.write("mess["+str(mess_count)+"].post_obj_id= "+str(mess.post_obj.obj_id)+";\n")
                f.write("mess["+str(mess_count)+"].post_start = "+str(mess.post_start)+";\n")
                f.write("mess["+str(mess_count)+"].post_len   = "+str(mess.post_len)+";\n")
                f.write("mess["+str(mess_count)+"].mess_id    = "+str(mess.mess_id)+";\n")
                if mess.synapse_scale is not None:
                    f.write("mess["+str(mess_count)+"].use_synapse_scale= "+str(1)+";\n")
                    f.write("mess["+str(mess_count)+"].synapse_scale= "+str(mess.synapse_scale)+";\n")
                    f.write("mess["+str(mess_count)+"].synapse_scale_value= synapse_scale_values"+str(mess.mess_id)+";\n")
                else:
                    f.write("mess["+str(mess_count)+"].use_synapse_scale= "+str(0)+";\n")
                    f.write("mess["+str(mess_count)+"].synapse_scale= "+str(0)+";\n")
                f.write("mess["+str(mess_count)+"].pre_values = pre_values"+str(mess.mess_id)+";\n")
                #TODO the post values should be a pointer to the pre values of ensembles. 
                f.write("mess["+str(mess_count)+"].post_values = post_values"+str(mess.mess_id)+";\n")
                f.write("mess["+str(mess_count)+"].ens_input = &inputs"+str(mess.post_obj.obj_id)+"["+str(mess.post_start)+"]"+";\n")
                f.write("mess["+str(mess_count)+"].matrix      = matrix"+str(mess.mess_id)+";\n")
                f.write("mess["+str(mess_count)+"].matrix_is_scalar = "+str(mess.matrix_is_scalar)+";\n")

                if mess.matrix_is_scalar == 1:
                    mess.matrix = mess.matrix[0][0]
                mess_count+=1
        f.write("}\n")
        f.close()



    #debug! for hardware
    def generate_inter_data(self, inters, core_id, inter_count):
        f = open('inter_data_core_'+str(core_id)+'.c','w')
        f.write("#include \"qpe.h\"\n")
        f.write("#include \"common/neuron-typedefs.h\"\n")
        f.write("#include \"param_defs.h\"\n")
        for inter in inters:
            f.write("precision_t inputs"+str(inter.obj_id)+"["+str(inter.size)+"];\n")
        
        f.write("intermediate_t inters["+str(inter_count)+"];\n")
        f.write("uint32_t n_inters= "+str(inter_count)+";\n")
        inter_count = 0
        f.write("void inter_init(){\n")
        for inter in inters:
            f.write("inters["+str(inter_count)+"].inputs   = inputs"+str(inter.obj_id)+";\n")
            f.write("inters["+str(inter_count)+"].obj_id   = "+str(inter.obj_id)+";\n")
            f.write("inters["+str(inter_count)+"].size     = "+str(inter.size)+";\n")
            inter_count+=1
        f.write("}\n")
        f.close()

    def generate_mess_data(self, messages, core_id, ens_id_range):
        f = open('mess_data_core_'+str(core_id)+'.c','w')
        f.write("#include \"qpe.h\"\n")
        f.write("#include \"common/neuron-typedefs.h\"\n")
        f.write("#include \"param_defs.h\"\n")
        mess_count=0
        for mess in messages:
            if mess.post_obj.obj_id in ens_id_range:
                mess_count+=1
                f.write("precision_t pre_values"+str(mess.mess_id)+"["+str(mess.pre_len)+"];\n")
                f.write("precision_t post_values"+str(mess.mess_id)+"["+str(mess.post_len)+"];\n")
                if np.array(mess.matrix).shape==():
                    mess.matrix = [[mess.matrix]]
                    mess.matrix_is_scalar = 1
                else:
                    mess.matrix_is_scalar = 0
                matrix_x = np.array(mess.matrix).shape[0]
                matrix_y = np.array(mess.matrix).shape[1]
                #print("message "+str(mess.mess_id))
                #print("x "+str(matrix_x)+" y "+str(matrix_y))
                #print(mess.matrix)
                f.write("precision_t matrix"+str(mess.mess_id)+"["+str(matrix_x)+"*"+str(matrix_y)+"]={\n")
                for i in range(matrix_x):
                    for j in range(matrix_y):
                        if not (i == matrix_x -1 and j == matrix_y -1 ):
                            f.write(str(mess.matrix[i][j])+",\n")
                        else:
                            f.write(str(mess.matrix[i][j])+"\n")
                f.write("};\n")
                if mess.synapse_scale is not None:
                    f.write("precision_t synapse_scale_values"+str(mess.mess_id)+"["+str(mess.post_len)+"];\n")


        
        f.write("message_t mess["+str(mess_count)+"];\n")
        f.write("uint32_t n_mess= "+str(mess_count)+";\n")
        mess_count = 0
        f.write("void mess_init(){\n")
        for mess in messages:
            if mess.post_obj.obj_id in ens_id_range:
                f.write("\n")
                f.write("mess["+str(mess_count)+"].pre_obj_id = "+str(mess.pre_obj.obj_id)+";\n")
                f.write("mess["+str(mess_count)+"].pre_start  = "+str(mess.pre_start)+";\n")
                f.write("mess["+str(mess_count)+"].pre_len    = "+str(mess.pre_len)+";\n")
                f.write("mess["+str(mess_count)+"].post_obj_id= "+str(mess.post_obj.obj_id)+";\n")
                f.write("mess["+str(mess_count)+"].post_start = "+str(mess.post_start)+";\n")
                f.write("mess["+str(mess_count)+"].post_len   = "+str(mess.post_len)+";\n")
                f.write("mess["+str(mess_count)+"].mess_id    = "+str(mess.mess_id)+";\n")
                if mess.synapse_scale is not None:
                    f.write("mess["+str(mess_count)+"].use_synapse_scale= "+str(1)+";\n")
                    f.write("mess["+str(mess_count)+"].synapse_scale= "+str(mess.synapse_scale)+";\n")
                    f.write("mess["+str(mess_count)+"].synapse_scale_value= synapse_scale_values"+str(mess.mess_id)+";\n")
                else:
                    f.write("mess["+str(mess_count)+"].use_synapse_scale= "+str(0)+";\n")
                    f.write("mess["+str(mess_count)+"].synapse_scale= "+str(0)+";\n")
                f.write("mess["+str(mess_count)+"].pre_values = pre_values"+str(mess.mess_id)+";\n")
                #TODO the post values should be a pointer to the pre values of ensembles. 
                f.write("mess["+str(mess_count)+"].post_values = post_values"+str(mess.mess_id)+";\n")
                f.write("mess["+str(mess_count)+"].matrix      = matrix"+str(mess.mess_id)+";\n")
                f.write("mess["+str(mess_count)+"].matrix_is_scalar = "+str(mess.matrix_is_scalar)+";\n")

                if mess.matrix_is_scalar == 1:
                    mess.matrix = mess.matrix[0][0]
                mess_count+=1
        f.write("}\n")
        f.close()



    def step(self):
        output_values = {}

        # Do the core inner loop.  These 3 steps could be done in parallel!

        # process all the Intermediates
        for n in self.node2inter.values():
            output_values[n] = n.step(self.input_values[n])
            self.input_values[n][:] = 0

        # process all the Cores
        for c in self.ens2core.values():
            output_values[c] = c.step(self.input_values[c])
            self.input_values[c][:] = 0

        # send all the Messages
        for m in self.messages:
            m.apply(self.input_values, output_values)

        # return this so we can plot values from it
        return output_values
