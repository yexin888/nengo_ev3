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

#include <iostream>
#include <fstream>

#include <sys/time.h>
//#include <stdint.h>
extern "C"{
#include "ev3_link.h"
}
extern "C"{
#include <Python.h> 
}


#define EV3_IP "10.42.0.120"

//#define MINSIM
#define CORE


bool ctrl_c = false;

typedef union {
  uint32_t i;
  float f;
} conv_i_f;

void my_handler(int s){
    std::cerr << "CTRL-C Received" << std::endl;
    ctrl_c = true;
    //global_stim->cancel();
}

#include <iostream>
#include <fstream>

#define N_TIME_STEPS 40000

int main(int argc, char**argv) {
#ifdef MINSIM
	float u_all_record[N_TIME_STEPS];
#else
	int u_all_record[N_TIME_STEPS];
#endif
	float pd_record[N_TIME_STEPS];
	float p_record[N_TIME_STEPS];
	float real_time_record[N_TIME_STEPS];
	struct timeval tp;
    
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = my_handler;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
    sigaction(SIGINT, &sigIntHandler, NULL);
	
	char buffer[10];
	char data[20];
	int sz;
	sz = 5;
	char ev3_ip[] = EV3_IP;
	char ev3_motor1_position[] = "/sys/class/tacho-motor/motor1/position";
	char ev3_motor1_command[] = "/sys/class/tacho-motor/motor1/command";
	char ev3_motor1_duty_cycle_sp [] = "/sys/class/tacho-motor/motor1/duty_cycle_sp";
	char ev3_command_run_direct [] = "run-direct";
	
	uint32_t n_time_steps = N_TIME_STEPS;
	
	//connect to ev3
	udp_ev3_open(ev3_ip, 8800);
	udp_ev3_write(ev3_motor1_command, ev3_command_run_direct, 10);

	
#ifdef MINSIM
	//=============   minsim init =================
	PyObject *pName, *pModule, *pDict, *pClass, *pInstance, *pArgs, *pFunc_step, *pValue;

	
	Py_Initialize();
	
	char cName[] = "minsim";

	pName = PyString_FromString(cName);
	
	pModule = PyImport_Import(pName);

	PyErr_Print();
	
	pDict = PyModule_GetDict(pModule);
	
	char cName2[] = "System";
	pClass= PyDict_GetItemString(pDict, cName2);
	
	pArgs= PyTuple_New(16);
	
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
		std::cerr << "minsim instance initiated." << std::endl;
	}
	
	char  method[] = "step";
	char  format[] = "[f]";
#endif	
#ifdef CORE 
	//=============  core init =================
	PyObject *pName, *pModule, *pDict, *pClass, *pInstance, *pArgs, *pFunc_step, *pValue, *pValue0, *pValue1;

	
	Py_Initialize();
	
	char cName[] = "main";

	pName = PyString_FromString(cName);
	//PyErr_Print();
	
	pModule = PyImport_Import(pName);
	PyErr_Print();

	
	pDict = PyModule_GetDict(pModule);
	
	char cName2[] = "CoreRobot";
	pClass= PyDict_GetItemString(pDict, cName2);
	

	if (PyCallable_Check(pClass)){
	
		pInstance = PyObject_CallObject(pClass, NULL);
		std::cerr << "core instance initiated." << std::endl;
	}
	
	char  core_method[] = "step";
	char  core_format[] = "[If]";
#endif	

	//============================== start simulation ================================



	int32_t p_motor ;
	conv_i_f conv;

	std::cout << "INIT COMPLETE" << std::endl;
	gettimeofday(&tp, NULL);
	long int ms = tp.tv_sec * 1000 + tp.tv_usec / 1000;

	for(uint32_t time = 1; time < n_time_steps ; time++){
	

#ifdef MINSIM

		//============================   read u from nengo ====================================
		//debug! system
		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address, read_results[0]);
		stim.read_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+4, read_results[1]);
		
		
		//===========================    send u to ev3   =====================================
		uint32_t send_len;
		
		//debug! udp loop
		conv.i = read_results[0];
		//conv.i = 0;

		//debug! minsim
		//u_all_record[time] =(int) conv.f ;
		u_all_record[time] = conv.f ;
		//sprintf(data, "%d",(int) conv.f);

		//std::cerr << (int)conv.f << std::endl;

		if((int)conv.f >= 10 ){
			send_len = 2;
		}
		else if ( (int)conv.f>= 0){
			send_len = 1;
		}
		else if( (int)conv.f>-10)
		{
			send_len = 2;
		}
		
		else{
			send_len = 3;
		}
		
		//============================    read p from ev3    ==================================

			
		pValue = PyObject_CallMethod(pInstance, method, format, conv.f );
		pValue = PyList_GetItem(pValue,0);
		double minsim_result;
		minsim_result = PyFloat_AsDouble(pValue);
		conv.f = minsim_result;
			


		p_record[time] =conv.f ;
		//===========================     send p to nengo   ================================
		
		
		stim.write_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+8, conv.i);
		stim.write_pe_mem(QPE_X, QPE_Y, neuron3.get_pe(), address+12, time);

		usleep(1500);

		conv.i = read_results[1];
		pd_record[time] = conv.f ;
#endif
#ifdef CORE
		//============================    read p from ev3    ==================================
		//===========================     send p to nengo   ================================
		//============================   read u from nengo ====================================
		
		
		udp_ev3_read(ev3_motor1_position, buffer, sz);
		p_motor = atoi(buffer);
		conv.f = ((float) p_motor) /180*3.14;
		p_record[time] =conv.f ;

			
		pValue = PyObject_CallMethod(pInstance, core_method, core_format,time, conv.f );
	PyErr_Print();
		pValue0 = PyList_GetItem(pValue,0);
	PyErr_Print();
		pValue1 = PyList_GetItem(pValue,1);
	PyErr_Print();
		double core_result;
		core_result = PyFloat_AsDouble(pValue0);
		pd_record[time] =(float) PyFloat_AsDouble(pValue1) ;

		conv.f = core_result*100;

		if(conv.f> 60){
		
			conv.f = 60;
		}
		else if(conv.f < -60){
		
			conv.f = -60;
		}
			
		u_all_record[time] =(int) (conv.f) ;


		
		//===========================    send u to ev3   =====================================
		uint32_t send_len;
		
		//debug! udp loop
		//conv.i = read_results[0];
		//conv.i = 0;

		//debug! minsim
		//u_all_record[time] = conv.f ;
		sprintf(data, "%d",(int) (conv.f));

		//std::cerr << (int)conv.f << std::endl;

		if((int)conv.f >= 10 ){
			send_len = 2;
		}
		else if ( (int)conv.f>= 0){
			send_len = 1;
		}
		else if( (int)conv.f>-10)
		{
			send_len = 2;
		}
		
		else{
			send_len = 3;
		}
		//debug! minsim , udp loop
		
		udp_ev3_write(ev3_motor1_duty_cycle_sp, data, send_len);
#endif





		gettimeofday(&tp, NULL);
		long int ms2 = tp.tv_sec * 1000 + tp.tv_usec / 1000;
		real_time_record[time] =((float) (ms2 - ms))/1000;	


		if(time % 5 == 0){
			std::cout << "time: " << real_time_record[time] << " p: " << p_record[time] << " pd: " << pd_record[time] << " u: " << u_all_record[time] << std::endl;
		}

		//usleep(1000);

	}
	

#ifdef MINSIM

	//minsim finalization
	if(pValue != NULL){
		Py_DECREF(pValue);
	}

	Py_DECREF(pName);
	Py_DECREF(pModule);
	Py_DECREF(pClass);
	Py_DECREF(pArgs);
	Py_Finalize();
#endif


	std::cout << "SIM END" << std::endl;

	//log pid signals 
	
	/*
	std::ofstream file;
	std::stringstream filename0;
	std::stringstream filename1;
	std::stringstream filename2;
	std::stringstream filename3;
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
	*/
	

    return 0;
}
