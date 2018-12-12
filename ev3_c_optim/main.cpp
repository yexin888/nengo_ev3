#if !defined(_WIN32)
#include <unistd.h>
#include <signal.h>
#endif

#ifdef _WIN32
#define strcasecmp _stricmp
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <cmath>
#endif

#include <sys/socket.h>
#include <netinet/in.h>
#include <jtag_logger.hpp>
#include <jtag_lib.hpp>
#include <jtag_stdint.h>
#include <eth_noc_stim.hpp>
#include <sys/time.h>
extern "C"{
#include "ev3_link_optim.h"
}
extern "C"{
#include <Python.h> 
}

//#include "poisson_source.hpp"
#include "if_curr_exp_neuron.hpp"

#define IF_CURR_EXP_EXT_BASE 0x00016000

#ifndef FPGA_DEFAULT_IP
#define FPGA_DEFAULT_IP "192.168.1.1"
#endif

#define EV3_IP "10.42.0.120"
#define PC_IP "10.42.0.1"

using namespace logging;

bool ctrl_c = false;
eth_noc_stim *global_stim;

typedef union {
  uint32_t i;
  float f;
} conv_i_f;

typedef struct {
	int16_t a;
	int16_t b;
} two_16;

typedef union {
  uint32_t i;
  two_16 t;
} conv_i_t;

void my_handler(int s){
    std::cerr << "CTRL-C Received" << std::endl;
    ctrl_c = true;
    global_stim->cancel();
}

#include <iostream>
#include <fstream>
void read_mem(eth_noc_stim &stim, int pe, std::string filename) {
    std::cerr << "Reading all memory from PE " << pe << std::endl;

    std::ofstream file;
    file.open(filename);

    for (uint32_t i = IF_CURR_EXP_REAL_START; i < IF_CURR_EXP_REAL_START +5000*4; i += 4) {
        uint32_t data;
        stim.read_pe_mem(QPE_X, QPE_Y, pe, i, data);
		conv_i_f conv;
		conv.i = data;

		file << conv.f << std::endl;
    }

    file.close();
}

			/*
bool RF_ACCESS_CLASS::read_pe_mem(uint8_t quad_x, uint8_t quad_y, uint8_t pe, uint32_t address,  uint32_t & rdata, uint8_t noc){
    uint16_t module_dest_addr = get_dst_modid(quad_x,quad_y, pe, noc);
    return this->read_noc (module_dest_addr, address, rdata);
}

bool eth_noc_stim::read_noc_long(uint16_t modid_dst, uint32_t pld_addr,
    uint64_t &pld_data_l, uint64_t &pld_data_h) {
	*/

void read_pe_mem_long(uint8_t quad_x, uint8_t quad_y, uint8_t pe, uint32_t address,  uint64_t & pld_data_l, uint64_t & pld_data_h, eth_noc_stim &stim ){

	
    uint16_t module_dest_addr = stim.get_dst_modid(quad_x,quad_y, pe);
    stim.read_noc_long (module_dest_addr, address, pld_data_l, pld_data_h);

}


#define N_TIME_STEPS 100000
//#define N_TIME_STEPS 1000

int main(int argc, char**argv) {
    static enum log_level debug_level = LOGLEVEL_INFO;
    log_setlevel(debug_level);

    const char *fpga_ip_address = FPGA_DEFAULT_IP;

    const char *quadpe_fpga_ip_address_env = getenv("QUADPE_FPGA_IP");
    if (quadpe_fpga_ip_address_env != NULL) {
        fpga_ip_address = quadpe_fpga_ip_address_env;
    }

	//debug!
	
	char dir_files[1000];
	char dir2read[]="/home/yexin/projects/JIB1Tests";
	//ev3_listdir( dir2read , dir_files, 1000);
    //std::cerr << dir_files << std::endl;


    eth_noc_stim stim(fpga_ip_address);
    global_stim = &stim;


    // Create the network
    uint32_t duration = 10;
    float timestep = 0.1;
    uint32_t systick = 500;
    uint32_t n_exc = 160;
    uint32_t n_inh = 40;
    //float rate_exc = 1000.0f;
    //float rate_inh = 1000.0f;
    //uint32_t seed_exc = 0;
    //uint32_t seed_inh = 1000;
    uint32_t seed_n_exc = 2000;
    uint32_t seed_n_inh = 3000;
	uint32_t pe0 = 0;
	uint32_t pe1 = 1;
    uint32_t pe2 = 2;
    uint32_t pe3 = 3;
    uint32_t dest_exc = (8 >> pe2) | (8 >> pe3);
    uint32_t dest_inh = (8 >> pe2) | (8 >> pe3);
    //uint32_t mask = 0xFFFFFC00;
    uint32_t neuron_exc_key = 0x800;
    uint32_t neuron_inh_key = 0xC00;
    float v_rest = -65.0;
    float v_reset = -65.0;
    float v_thresh = -50.0;
    float c_m = 1.0;
    float tau_m = 20.0;
    float tau_refract = 1.0;
    float tau_exc = 5.0;
    float tau_inh = 5.0;
    float i_offset = 0.0;
    float v_init = -65.0;
    float v_init_min = -65.0;
    float v_init_max = -55.0;
    bool random_v_init = true;
	uint32_t n_time_steps = N_TIME_STEPS;
	//debug! minsim
	int u_all_record[N_TIME_STEPS];
	//float u_all_record[N_TIME_STEPS];
	float pd_record[N_TIME_STEPS];
	float p_record[N_TIME_STEPS];
	float error_record[N_TIME_STEPS];
	float input1_record[N_TIME_STEPS];
	float input2_record[N_TIME_STEPS];
	float nengo_record[N_TIME_STEPS];
	float real_time_record[N_TIME_STEPS];
	struct timeval tp;
	int32_t pick_last=-1;
    
	IFCurrExpNeuron neuron0(
            QPE_X, QPE_Y, pe0, n_exc, systick, duration, QPE_X, QPE_Y,
            dest_exc, neuron_exc_key, timestep, v_rest, v_reset, v_thresh, c_m,
            tau_m, tau_refract, tau_exc, tau_inh, i_offset, v_init,
            v_init_min, v_init_max, random_v_init, seed_n_exc);
    IFCurrExpNeuron neuron1(
            QPE_X, QPE_Y, pe1, n_inh, systick, duration, QPE_X, QPE_Y,
            dest_inh, neuron_inh_key, timestep, v_rest, v_reset, v_thresh, c_m,
            tau_m, tau_refract, tau_exc, tau_inh, i_offset, v_init,
            v_init_min, v_init_max, random_v_init, seed_n_inh);
    IFCurrExpNeuron neuron2(
            QPE_X, QPE_Y, pe2, n_exc, systick, duration, QPE_X, QPE_Y,
            dest_exc, neuron_exc_key, timestep, v_rest, v_reset, v_thresh, c_m,
            tau_m, tau_refract, tau_exc, tau_inh, i_offset, v_init,
            v_init_min, v_init_max, random_v_init, seed_n_exc);
    IFCurrExpNeuron neuron3(
            QPE_X, QPE_Y, pe3, n_inh, systick, duration, QPE_X, QPE_Y,
            dest_inh, neuron_inh_key, timestep, v_rest, v_reset, v_thresh, c_m,
            tau_m, tau_refract, tau_exc, tau_inh, i_offset, v_init,
            v_init_min, v_init_max, random_v_init, seed_n_inh);

    // Write the parameters
    std::cerr << "Writing Data\n";
    neuron0.write_data(stim);
    neuron1.write_data(stim);
    neuron2.write_data(stim);
    neuron3.write_data(stim);

    // Write the executable
	// debug! minsim
	
    std::cerr << "Loading program\n";

    std::cerr << "Loading program 0\n";
    neuron0.load_program(stim,"core0.mem");
    std::cerr << "Loading program 1\n";
    neuron1.load_program(stim,"core1.mem");
	//debug!
    std::cerr << "Loading program 2\n";
    neuron2.load_program(stim,"core2.mem");
    std::cerr << "Loading program 3\n";
    neuron3.load_program(stim,"core3.mem");

    // startup
    std::cerr << "Starting cores\n";
    stim.rf_quadpe_cmgmt_clksource(QPE_X, QPE_Y, 0); // refclk
    stim.rf_quadpe_cmgmt_clkdiv(QPE_X, QPE_Y, 1, 2, 3, 4); // 1, 1/2, 1/3 and 1/4
    stim.rf_quadpe_cmgmt_dnoc(QPE_X, QPE_Y, 0, true); // dnoc clock start
    stim.rf_quadpe_cmgmt_share(QPE_X, QPE_Y, 0, 0xf); // share clock
    stim.rf_quadpe_pmgt_command(QPE_X, QPE_Y, 0, true, 0);
    stim.rf_quadpe_memshare(QPE_X, QPE_Y, true, true, true, true);
    stim.rf_quadpe_arm_clk_rst(QPE_X, QPE_Y, 0xf, 0x0);
    stim.rf_quadpe_arm_clk_rst(QPE_X, QPE_Y, 0xf, 0xf);

	
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = my_handler;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
    sigaction(SIGINT, &sigIntHandler, NULL);

	//connect to ev3
	
	char* buffer;
	char* buffer1;

	char data[20];
	int sz;
	sz = 5;
	char ev3_ip[] = EV3_IP;
	uint32_t motor_vertical=1;
	uint32_t motor_pick=0;
	uint32_t motor_horizontal=2;
	char ev3_motor1_position[] = "/sys/class/tacho-motor/motor0/position";
	char ev3_motor1_command[] = "/sys/class/tacho-motor/motor0/command";
	char ev3_motor1_duty_cycle_sp [] = "/sys/class/tacho-motor/motor0/duty_cycle_sp";
	char ev3_motor2_position[] = "/sys/class/tacho-motor/motor1/position";
	char ev3_motor2_command[] = "/sys/class/tacho-motor/motor1/command";
	char ev3_motor2_duty_cycle_sp [] = "/sys/class/tacho-motor/motor1/duty_cycle_sp";
	char ev3_motor0_position_sp [] = "/sys/class/tacho-motor/motor2/position_sp";
	char ev3_motor0_command [] = "/sys/class/tacho-motor/motor2/command";
	char ev3_command_run_direct [] = "run-direct";
	//debug! minsim
	
	
	//debug! bypass ev3link
	udp_ev3_open(ev3_ip, 8800);
	//udp_ev3_write(ev3_motor1_command, ev3_command_run_direct, 10);
	
	//send
	int send_socket;
	send_socket = socket(AF_INET, SOCK_DGRAM, 0);

	struct sockaddr_in ev3_addr;
	memset(&ev3_addr , 0, sizeof(ev3_addr));
	ev3_addr.sin_family = AF_INET;
	ev3_addr.sin_port = htons(8500);

    const char *ev3_ip2 = EV3_IP;
	inet_aton (ev3_ip2, &(ev3_addr.sin_addr));

	//receive
	int recv_socket;
	recv_socket = socket(AF_INET, SOCK_DGRAM,0);
	struct sockaddr_in pc_addr;
	memset(&pc_addr, 0 , sizeof(pc_addr));
	pc_addr.sin_family = AF_INET;
	pc_addr.sin_port = htons(8500);
	
    const char *pc_ip = PC_IP;
	inet_aton (pc_ip, &(pc_addr.sin_addr));
	
	bind(recv_socket, (struct sockaddr *)&pc_addr, sizeof(pc_addr));
	

	//=============   python init =================
	
	PyObject *pName, *pModule, *pDict, *pClass, *pInstance, *pArgs, *pFunc_step, *pValue;

	/*
		d_state, d_motor, dt=0.001, seed=None,
            scale_mult=1, scale_add=1, diagonal=True,
            sense_noise=0.1, motor_noise=0.1,
            motor_delay=0, motor_filter=None,
            scale_inertia=0, motor_scale=1.0,
            sensor_delay=0, sensor_filter=None,
            nonlinear=True

		def params(self):
        self.default('Kp', Kp=2.0)
        self.default('Kd', Kd=1.0)
        self.default('Ki', Ki=0.0)
        self.default('tau_d', tau_d=0.001)
        self.default('T', T=30.0)
        self.default('period', period=4.0)
        self.default('use adaptation', adapt=False)
        self.default('n_neurons', n_neurons=150)
        self.default('learning rate', learning_rate=1e-4)
        self.default('max_freq', max_freq=1.0)
        self.default('synapse', synapse=0.01)
        self.default('radius', radius=1.0)
        self.default('number of dimensions', D=1)
        self.default('scale_add', scale_add=1)
        self.default('noise', noise=0.001)
        self.default('filter', filter=0.01)
        self.default('delay', delay=0.001)

    def model(self, p):

        model = nengo.Network()
        with model:

            system = ctrl.System(p.D, p.D, dt=p.dt, seed=p.seed,
                    motor_noise=p.noise, sense_noise=p.noise,
                    scale_add=p.scale_add,
                    motor_scale=10,
                    motor_delay=p.delay, sensor_delay=p.delay,
                    motor_filter=p.filter, sensor_filter=p.filter)

	*/
	

	//std::cerr << "1" << std::endl;
	
	Py_Initialize();
	
	//std::cerr << "2" << std::endl;
	
	char cName[] = "minsim";
	//char cName[] = "test2";

	pName = PyString_FromString(cName);

	//std::cerr << PyString_Check(pName) << std::endl;
	//std::cerr << "3" << std::endl;
	
	pModule = PyImport_Import(pName);

	PyErr_Print();

	//std::cerr << PyModule_Check(pModule) << std::endl;

	//std::cerr << "4" << std::endl;
	
	pDict = PyModule_GetDict(pModule);

	//std::cerr << "5" << std::endl;
	
	char cName2[] = "System";
	//char cName2[] = "Test";
	pClass= PyDict_GetItemString(pDict, cName2);

	//std::cerr << "6" << std::endl;
	
	pArgs= PyTuple_New(16);

	//std::cerr << "7" << std::endl;
	
	long int D = 1;
	double dt = 0.001;
	long int seed = 1;
	double scale_add = 1;
	double noise = 0.001;
	double delay = 0.001;
	double filter = 0.01;
	double motor_scale = 10;
	
	//d_state
	pValue = PyInt_FromLong(D); 
	PyTuple_SetItem(pArgs, 0, pValue );
	//d_motor
	pValue = PyInt_FromLong(D); 
	PyTuple_SetItem(pArgs, 1, pValue );
	//dt
	pValue = PyFloat_FromDouble(dt) ;
	PyTuple_SetItem(pArgs, 2, pValue );
	//seed
	pValue = PyInt_FromLong(seed); 
	PyTuple_SetItem(pArgs, 3, pValue );
	//scale_mult
	pValue = PyFloat_FromDouble(1) ;
	PyTuple_SetItem(pArgs, 4, pValue );
	//scale_add
	pValue = PyFloat_FromDouble(scale_add) ;
	PyTuple_SetItem(pArgs, 5, pValue );
	//diagonal
	pValue = PyBool_FromLong(1) ;
	PyTuple_SetItem(pArgs, 6, pValue );
	//sense_noise
	pValue = PyFloat_FromDouble(noise) ;
	PyTuple_SetItem(pArgs, 7, pValue );
	//motor_noise
	pValue = PyFloat_FromDouble(noise) ;
	PyTuple_SetItem(pArgs, 8, pValue );
	//motor_delay
	pValue = PyFloat_FromDouble(delay) ;
	PyTuple_SetItem(pArgs, 9, pValue );
	//motor_filter
	pValue = PyFloat_FromDouble(filter) ;
	PyTuple_SetItem(pArgs, 10, pValue );
	//scale_inertia
	pValue = PyFloat_FromDouble(0) ;
	PyTuple_SetItem(pArgs, 11, pValue );
	//motor_scale
	pValue = PyFloat_FromDouble(motor_scale) ;
	PyTuple_SetItem(pArgs, 12, pValue );
	//sensor_delay
	pValue = PyFloat_FromDouble(delay) ;
	PyTuple_SetItem(pArgs, 13, pValue );
	//sensor_filter
	pValue = PyFloat_FromDouble(filter) ;
	PyTuple_SetItem(pArgs, 14, pValue );
	//nonlinear
	pValue = PyBool_FromLong(1) ;
	PyTuple_SetItem(pArgs, 15, pValue );

	if (PyCallable_Check(pClass)){
	
		pInstance = PyObject_CallObject(pClass, pArgs);
		std::cerr << "python instance initiated." << std::endl;
	}
	
	char  method[] = "step";
	char  format[] = "[f]";
	


	/*
	pValue = PyObject_CallMethod(pInstance, method, format, 3.1);

	pValue = PyList_GetItem(pValue,0);

	double return_value ;
	return_value = PyFloat_AsDouble(pValue);
	*/
	/*
	if(pValue != NULL){
		Py_DECREF(pValue);
	}

	//std::cerr << "return " << return_value << std::endl ; 

	Py_DECREF(pName);
	Py_DECREF(pModule);
	Py_DECREF(pClass);
	Py_DECREF(pArgs);
	Py_Finalize();
	*/
	//return 0;
//==============================================================



	int32_t p_motor ;
	int32_t p_motor_h ;
	conv_i_f conv;
	conv_i_t conv_t;

    // Wait for cores to be ready
    std::cerr << "Waiting for program to be ready to start\n";
    bool ready = false;
    do {
        ready = 1
            && neuron0.is_ready(stim)
            && neuron1.is_ready(stim)
            && neuron2.is_ready(stim)
            && neuron3.is_ready(stim)
            ;
        usleep(100000);
    } while (!ready && !ctrl_c);

    // Send start message
    if (ready) {
        std::cerr << "Sending start message\n";
        uint32_t pld_data_list[4] = {0, 0, 0, 0};
        uint32_t pld_header = (5 << 14);
        uint32_t modid_dst = 0
            | stim.get_dst_modid(QPE_X, QPE_Y, neuron0.get_pe())
            | stim.get_dst_modid(QPE_X, QPE_Y, neuron1.get_pe())
            | stim.get_dst_modid(QPE_X, QPE_Y, neuron2.get_pe())
            | stim.get_dst_modid(QPE_X, QPE_Y, neuron3.get_pe())
            ;
        stim.send_noc_packet(0, modid_dst, false, pld_header, 1, pld_data_list);

		
		uint32_t read_results[10];
		read_results[0]=0;

		gettimeofday(&tp, NULL);

		std::cout << "INIT COMPLETE" << std::endl;
		long int ms = tp.tv_sec * 1000 + tp.tv_usec / 1000;
		
		//debug! system
		//return 0;

		__ev3_udp_init();

		for(uint32_t time = 0; time < n_time_steps ; time++){
		
			//printf("time: %d\n",time);

			uint32_t address=IF_CURR_EXP_EXT_BASE;
			uint32_t pld_data_list1[4] = {time, 2, 3, 4};
			uint32_t pld_header1 = (5 << 14);

			//============================    read p from ev3    ==================================
			
			//std::cout << "a" ;

			//motor vertical 
			//debug! comm optim
			//udp_ev3_read(ev3_motor1_position, buffer, sz);

			//std::cout << "b" ;
			//recvfrom(recv_socket, buffer, sizeof(buffer) -1, 0 , NULL,0 );
			//recvfrom(recv_socket, buffer, 4 , 0 , NULL,0 );

			char * positions;
			char * value;
			const char  s[2] = " ";

			positions = udp_ev3_receive();

			if(positions !=NULL){
				//printf("positions: %s\n", positions);


				value = strtok(positions,s );

				buffer = value;

				value = strtok(NULL,s );

				buffer1 = value;

				p_motor = atoi(buffer);
				//debug! comm optim
				//udp_ev3_read(ev3_motor2_position, buffer1, sz);

				p_motor_h = atoi(buffer1);

				//printf("pos1: %d, pos2: %d\n", p_motor,p_motor_h);
			}
			else{
			
				printf("did not receive!\n");
			}
			conv.f = ((float) p_motor) /180*3.14;
			p_record[time] =conv.f ;
			conv.f = ((float) p_motor_h) /180*3.14;
			conv_t.t.a = (int16_t) p_motor;
			conv_t.t.b = (int16_t) p_motor_h;
    		stim.write_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+8, conv_t.i );
			//std::cout << "d" ;
    		//stim.write_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+40, conv.i);
			//conv.f = minsim_read();

			/*	
			pValue = PyObject_CallMethod(pInstance, method, format, conv.f );
			pValue = PyList_GetItem(pValue,0);
			double minsim_result;
			minsim_result = PyFloat_AsDouble(pValue);
			conv.f = minsim_result;
			*/	


			//===========================     send p to nengo   ================================
			
			//debug! system
			//std::cerr<< "ev3: " << conv.f<< std::endl;
			//debug! udp loop
			
    		//stim.write_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+8, conv.i);
    		stim.write_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+12, time);


			//============================   read u from nengo ====================================
			//debug! system
			/*
bool RF_ACCESS_CLASS::read_pe_mem(uint8_t quad_x, uint8_t quad_y, uint8_t pe, uint32_t address,  uint32_t & rdata, uint8_t noc){
    uint16_t module_dest_addr = get_dst_modid(quad_x,quad_y, pe, noc);
    return this->read_noc (module_dest_addr, address, rdata);
}

bool eth_noc_stim::read_noc_long(uint16_t modid_dst, uint32_t pld_addr,
    uint64_t &pld_data_l, uint64_t &pld_data_h) {
	*/
			
			
			/*
			stim.read_pe_mem_long(QPE_X, QPE_Y, neuron3.get_pe(), address,*((uint64_t*) read_results), *((uint64_t*) (&read_results[2])));
			
			stim.read_pe_mem_long(QPE_X, QPE_Y, neuron3.get_pe(), address+16,*((uint64_t*) (&read_results[4])), *((uint64_t*) (&read_results[6])));
			*/
			

			
			
			
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address, read_results[0]);//u_all
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+4, read_results[1]); //debug, pd
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+32, read_results[8]); //pd pick
    		//stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+36, read_results[9]); //u_h 
			
			/*
			uint8_t buff[24];
			stim.recv_noc_packet(buff,24,0);
  			struct noc_packet packet_out;
  			packet_out.from_buffer(buff);

			read_results[0] =packet_out.data[0];
			read_results[1] =packet_out.data[1];
			read_results[4] =packet_out.data[2];
			read_results[5] =packet_out.data[3];
			*/
			
			/*
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+16, read_results[4]);//debug, error
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+20, read_results[5]);//debug, input1 
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+24, read_results[6]);//debug, input2
    		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+28, read_results[7]);//debug, nengo 
			*/
			
			
			
			//std::cout << "e" ;
			
			
			//===========================    send u to ev3   =====================================
			uint32_t send_len;
			uint32_t send_len_total=0;
			
			conv_t.i = read_results[0];
			u_all_record[time] = (int)(conv_t.t.a) ;

			//debug! comm optim
			//u_all_record[time] = time%1000;

			conv.f = (float) u_all_record[time];
			//udp_ev3_write(ev3_motor1_duty_cycle_sp, data, send_len);
			int send_values[3];
			send_values[0] = (int) conv.f;



			//conv.i = read_results[9];
			conv.f = (float) conv_t.t.b;


			//debug! comm optim
		
			//conv.f = time%1000+1;
		
			send_values[1] = (int) conv.f;
			//udp_ev3_write(ev3_motor2_duty_cycle_sp, data, send_len);
			conv.i = read_results[8];
			//debug! comm optim

			//conv.f = time%1000+2;


			send_values[2] = (int) conv.f;
			sprintf(data, "%d %d %d",send_values[0],send_values[1],send_values[2] );
			send_len_total = strlen(data);
			//printf("data to send : %s, size: %d\n", data, send_len_total);
			//printf("sending data: %s, send len total: %d\n", data, send_len_total);
			udp_ev3_write_optim(data, send_len_total+1);


			conv.i = read_results[1];
			pd_record[time] = conv.f ;
			gettimeofday(&tp, NULL);
			long int ms2 = tp.tv_sec * 1000 + tp.tv_usec / 1000;
			real_time_record[time] =((float) (ms2 - ms))/1000;	


			conv.i = read_results[4];
			error_record[time] = conv.f;

			conv.i = read_results[5];
			input1_record[time] = conv.f; 
			conv.i = read_results[6];
			input2_record[time] = conv.f; 
			conv.i = read_results[7];
			nengo_record[time] = conv.f; 



			if(time % 5 == 0 && time > 0){
				std::cout << "time: " << real_time_record[time] << " p: " << p_record[time] << " pd: " << pd_record[time] << " u: " << u_all_record[time] << " error:  "<< error_record[time] << " input1:  " << input1_record[time] << " input2: " << input2_record[time] << " nengo: " << nengo_record[time] << std::endl;
			}
        	usleep(2000);

		}
		



		//python finalization
		if(pValue != NULL){
			Py_DECREF(pValue);
		}

		//std::cerr << "return " << return_value << std::endl ; 

		Py_DECREF(pName);
		Py_DECREF(pModule);
		Py_DECREF(pClass);
		Py_DECREF(pArgs);
		Py_Finalize();



		std::cout << "SIM END" << std::endl;
    
		//log pid signals 
		std::ofstream file;
		std::stringstream filename0;
		std::stringstream filename1;
		std::stringstream filename2;
		std::stringstream filename3;
		std::stringstream filename4;
		std::stringstream filename5;
		std::stringstream filename6;
		std::stringstream filename7;
		filename0 << "u_all_record.txt" ;
		file.open(filename0.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << u_all_record[i] << std::endl;
			//std::cerr << u_all_record[i] << std::endl;
		}
		file.close();
		
		filename1 << "pd_record.txt" ;
		file.open(filename1.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << pd_record[i] << std::endl;
		}
		file.close();

		filename2 << "p_record.txt" ;
		file.open(filename2.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << p_record[i] << std::endl;
		}
		file.close();

		filename3 << "real_time_record.txt" ;
		file.open(filename3.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << real_time_record[i] << std::endl;
		}
		file.close();

		filename4 << "error_record.txt" ;
		file.open(filename4.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << error_record[i] << std::endl;
		}
		file.close();

		filename5 << "input1_record.txt" ;
		file.open(filename5.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << input1_record[i] << std::endl;
		}
		file.close();

		filename6 << "input2_record.txt" ;
		file.open(filename6.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << input2_record[i] << std::endl;
		}
		file.close();

		filename7 << "nengo_record.txt" ;
		file.open(filename7.str());
		for (uint32_t i = 0; i < n_time_steps; i += 1) {

        	file << nengo_record[i] << std::endl;
		}
		file.close();


        std::cerr << "timer sending finished\n";

		
        std::cerr << "Waiting for program to finish\n";

        bool finished = false;
        do {
            finished = 1
                && neuron0.is_finished(stim)
                && neuron1.is_finished(stim)
                && neuron2.is_finished(stim)
                && neuron3.is_finished(stim)
                ;
            usleep(1000000);
        } while (!finished && !ctrl_c);

        if (finished) {
            std::cerr << "Getting results\n";
            //neuron2.read_spikes(stim, "neuron_exc.csv");
            //neuron3.read_v(stim, "neuron_exc_v.csv");
        }
    }

    neuron0.read_log(stim);
    neuron1.read_log(stim);
    neuron2.read_log(stim);
    neuron3.read_log(stim);

	
    read_mem(stim, neuron0.get_pe(), "p.data");
    read_mem(stim, neuron1.get_pe(), "t.data");
    read_mem(stim, neuron2.get_pe(), "decoder.data");
	
    read_mem(stim, neuron3.get_pe(), "pid.data");

    log_closefile();
    //debug! reset arm
	stim.rf_quadpe_arm_clk_rst(QPE_X, QPE_Y, 0xf, 0x0);
    return 0;
}
