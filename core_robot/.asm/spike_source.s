   1              		.syntax unified
   2              		.cpu cortex-m4
   3              		.eabi_attribute 27, 1
   4              		.eabi_attribute 28, 1
   5              		.fpu fpv4-sp-d16
   6              		.eabi_attribute 20, 1
   7              		.eabi_attribute 21, 1
   8              		.eabi_attribute 23, 3
   9              		.eabi_attribute 24, 1
  10              		.eabi_attribute 25, 1
  11              		.eabi_attribute 26, 1
  12              		.eabi_attribute 30, 2
  13              		.eabi_attribute 34, 1
  14              		.eabi_attribute 38, 1
  15              		.eabi_attribute 18, 4
  16              		.thumb
  17              		.file	"spike_source.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.generate_pd,"ax",%progbits
  22              		.align	2
  23              		.global	generate_pd
  24              		.thumb
  25              		.thumb_func
  27              	generate_pd:
  28              	.LFB188:
  29              		.file 1 "spinnaker_src/spike_source.c"
   1:spinnaker_src/spike_source.c **** #include "spike_source.h"
   2:spinnaker_src/spike_source.c **** #include "neuron.h"
   3:spinnaker_src/spike_source.c **** 
   4:spinnaker_src/spike_source.c **** extern uint32_t systicks;
   5:spinnaker_src/spike_source.c **** 
   6:spinnaker_src/spike_source.c **** uint32_t* address0 ;
   7:spinnaker_src/spike_source.c **** uint32_t* address1 ;
   8:spinnaker_src/spike_source.c **** uint32_t key;
   9:spinnaker_src/spike_source.c **** uint32_t payload;
  10:spinnaker_src/spike_source.c **** conv_i_f conv;
  11:spinnaker_src/spike_source.c **** uint32_t core_id ;
  12:spinnaker_src/spike_source.c **** uint32_t ens_id;
  13:spinnaker_src/spike_source.c **** uint32_t value_id;
  14:spinnaker_src/spike_source.c **** uint32_t p;
  15:spinnaker_src/spike_source.c **** REAL pid_result;
  16:spinnaker_src/spike_source.c **** REAL pd;
  17:spinnaker_src/spike_source.c **** REAL u_all;
  18:spinnaker_src/spike_source.c **** uint32_t pid_result_int_neg; 
  19:spinnaker_src/spike_source.c **** REAL nengo_result;
  20:spinnaker_src/spike_source.c **** 
  21:spinnaker_src/spike_source.c **** REAL kp ;
  22:spinnaker_src/spike_source.c **** REAL ki ;
  23:spinnaker_src/spike_source.c **** REAL kd ;
  24:spinnaker_src/spike_source.c **** 
  25:spinnaker_src/spike_source.c **** REAL tau_d;
  26:spinnaker_src/spike_source.c **** REAL scale;
  27:spinnaker_src/spike_source.c **** REAL prev_state = 0;
  28:spinnaker_src/spike_source.c **** REAL dstate = 0;
  29:spinnaker_src/spike_source.c **** REAL istate = 0;
  30:spinnaker_src/spike_source.c **** REAL dt = 0.001;
  31:spinnaker_src/spike_source.c **** REAL desired_dstate=0;
  32:spinnaker_src/spike_source.c **** REAL desired_signal_period = 4;
  33:spinnaker_src/spike_source.c **** //debug! minsim
  34:spinnaker_src/spike_source.c **** REAL motor_synapse_scale =0.9048374180359595 ;
  35:spinnaker_src/spike_source.c **** REAL motor_synpase_scale_value;
  36:spinnaker_src/spike_source.c **** 
  37:spinnaker_src/spike_source.c **** uint32_t record_count = 0;
  38:spinnaker_src/spike_source.c **** 
  39:spinnaker_src/spike_source.c **** #ifdef SOURCE_CORE
  40:spinnaker_src/spike_source.c **** //extern REAL * nengo_output_record;
  41:spinnaker_src/spike_source.c **** #endif
  42:spinnaker_src/spike_source.c **** 
  43:spinnaker_src/spike_source.c **** extern uint32_t n_packets_received ;
  44:spinnaker_src/spike_source.c **** extern REAL ensemble_results[N_ENSEMBLE_CORES];
  45:spinnaker_src/spike_source.c **** uint32_t pc_time=0;
  46:spinnaker_src/spike_source.c **** 
  47:spinnaker_src/spike_source.c **** void send_source_spikes(){
  48:spinnaker_src/spike_source.c **** 	
  49:spinnaker_src/spike_source.c **** 	address0 =(uint32_t*) (IF_CURR_EXP_EXT_BASE); 
  50:spinnaker_src/spike_source.c **** 	address1 =(uint32_t*) (IF_CURR_EXP_EXT_BASE+8); 
  51:spinnaker_src/spike_source.c **** 
  52:spinnaker_src/spike_source.c **** 
  53:spinnaker_src/spike_source.c **** 	//read p from sram
  54:spinnaker_src/spike_source.c **** 	p = *address1;
  55:spinnaker_src/spike_source.c **** 	
  56:spinnaker_src/spike_source.c **** 	//sum up ensemble results
  57:spinnaker_src/spike_source.c **** 	if(n_packets_received!=0){
  58:spinnaker_src/spike_source.c **** 		nengo_result = 0;
  59:spinnaker_src/spike_source.c **** 		for (uint32_t i = 0 ; i < N_ENSEMBLE_CORES ; i++){
  60:spinnaker_src/spike_source.c **** 			nengo_result += ensemble_results[i];
  61:spinnaker_src/spike_source.c **** 		}
  62:spinnaker_src/spike_source.c **** 	}	
  63:spinnaker_src/spike_source.c **** 	//process p in pid
  64:spinnaker_src/spike_source.c **** 	uint32_t record_output = 0;
  65:spinnaker_src/spike_source.c **** 	if (*(address1+1) > pc_time){
  66:spinnaker_src/spike_source.c **** 		//debug! minsim
  67:spinnaker_src/spike_source.c **** 		pd = generate_pd(desired_signal_period, *(address1+1));
  68:spinnaker_src/spike_source.c **** 		//pd = generate_pd(desired_signal_period, systicks);
  69:spinnaker_src/spike_source.c **** 		pid_result = pid(p,pd);
  70:spinnaker_src/spike_source.c **** 		record_output = 1;
  71:spinnaker_src/spike_source.c **** 
  72:spinnaker_src/spike_source.c **** 		//debug! if no new value from outside, no value(scalar value and error) sent to ensembles. 
  73:spinnaker_src/spike_source.c **** 		conv.f = -pid_result;
  74:spinnaker_src/spike_source.c **** 		pid_result_int_neg = conv.i;
  75:spinnaker_src/spike_source.c **** 	
  76:spinnaker_src/spike_source.c **** 		//send u to ensembles
  77:spinnaker_src/spike_source.c **** 		//debug! minsim
  78:spinnaker_src/spike_source.c **** 		
  79:spinnaker_src/spike_source.c **** 		core_id = 0;
  80:spinnaker_src/spike_source.c **** 		ens_id = 0; 
  81:spinnaker_src/spike_source.c **** 		value_id = 0;
  82:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
  83:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
  84:spinnaker_src/spike_source.c **** 		router_spike_a(key,payload);
  85:spinnaker_src/spike_source.c **** 		
  86:spinnaker_src/spike_source.c **** 		core_id = 0;
  87:spinnaker_src/spike_source.c **** 		ens_id = 1; 
  88:spinnaker_src/spike_source.c **** 		value_id = 0;
  89:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
  90:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
  91:spinnaker_src/spike_source.c **** 		router_spike_b(key,payload);
  92:spinnaker_src/spike_source.c **** 
  93:spinnaker_src/spike_source.c **** 		core_id = 0;
  94:spinnaker_src/spike_source.c **** 		ens_id = 2; 
  95:spinnaker_src/spike_source.c **** 		value_id = 0;
  96:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
  97:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
  98:spinnaker_src/spike_source.c **** 		router_spike_c(key,payload);
  99:spinnaker_src/spike_source.c **** 		
 100:spinnaker_src/spike_source.c **** 		//send p to ensembles 
 101:spinnaker_src/spike_source.c **** 		core_id = 0;
 102:spinnaker_src/spike_source.c **** 		ens_id = 3; 
 103:spinnaker_src/spike_source.c **** 		value_id = 0;
 104:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id;
 105:spinnaker_src/spike_source.c **** 		payload = p;
 106:spinnaker_src/spike_source.c **** 		//debug! system
 107:spinnaker_src/spike_source.c **** 		router_spike_d(key,payload);
 108:spinnaker_src/spike_source.c **** 		
 109:spinnaker_src/spike_source.c **** 
 110:spinnaker_src/spike_source.c **** 		//write combined u to sram
 111:spinnaker_src/spike_source.c **** 		//low pass 
 112:spinnaker_src/spike_source.c **** 		
 113:spinnaker_src/spike_source.c **** 		motor_synpase_scale_value = (1-motor_synapse_scale)*motor_synpase_scale_value + motor_synapse_sca
 114:spinnaker_src/spike_source.c **** 		nengo_result = motor_synpase_scale_value; 
 115:spinnaker_src/spike_source.c **** 
 116:spinnaker_src/spike_source.c **** 		
 117:spinnaker_src/spike_source.c **** 		pc_time =  *(address1+1);
 118:spinnaker_src/spike_source.c **** 		//debug! system, minsim
 119:spinnaker_src/spike_source.c **** 		//u_all = pid_result*100;
 120:spinnaker_src/spike_source.c **** 		//u_all = (pid_result + nengo_result)*100;
 121:spinnaker_src/spike_source.c **** 		u_all = (pid_result + nengo_result);
 122:spinnaker_src/spike_source.c **** 		//u_all = (pid_result );
 123:spinnaker_src/spike_source.c **** 
 124:spinnaker_src/spike_source.c **** 		//debug! minsim
 125:spinnaker_src/spike_source.c **** 		
 126:spinnaker_src/spike_source.c **** 		//clamp motor speed
 127:spinnaker_src/spike_source.c **** 		/*
 128:spinnaker_src/spike_source.c **** 		if(u_all > U_ALL_HIGH){
 129:spinnaker_src/spike_source.c **** 		
 130:spinnaker_src/spike_source.c **** 			u_all = U_ALL_HIGH;
 131:spinnaker_src/spike_source.c **** 		}
 132:spinnaker_src/spike_source.c **** 		else if(u_all < U_ALL_LOW){
 133:spinnaker_src/spike_source.c **** 		
 134:spinnaker_src/spike_source.c **** 			u_all = U_ALL_LOW;
 135:spinnaker_src/spike_source.c **** 		}
 136:spinnaker_src/spike_source.c **** 		*/
 137:spinnaker_src/spike_source.c **** 		
 138:spinnaker_src/spike_source.c **** 
 139:spinnaker_src/spike_source.c **** 		conv.f = u_all;
 140:spinnaker_src/spike_source.c **** 		
 141:spinnaker_src/spike_source.c **** 
 142:spinnaker_src/spike_source.c **** 		//debug! system 
 143:spinnaker_src/spike_source.c **** 		*address0 = conv.i;
 144:spinnaker_src/spike_source.c **** 	
 145:spinnaker_src/spike_source.c **** 	
 146:spinnaker_src/spike_source.c **** 
 147:spinnaker_src/spike_source.c **** #ifdef SOURCE_CORE
 148:spinnaker_src/spike_source.c **** 	
 149:spinnaker_src/spike_source.c **** 	
 150:spinnaker_src/spike_source.c **** 		//if(record_output == 1 && record_count< RECORD_LEN){
 151:spinnaker_src/spike_source.c **** 		/*
 152:spinnaker_src/spike_source.c **** 		if( record_count< RECORD_LEN){
 153:spinnaker_src/spike_source.c **** 			nengo_output_record[record_count]=u_all;
 154:spinnaker_src/spike_source.c **** 			record_count++;
 155:spinnaker_src/spike_source.c **** 		}
 156:spinnaker_src/spike_source.c **** 		*/
 157:spinnaker_src/spike_source.c **** 	
 158:spinnaker_src/spike_source.c **** 	
 159:spinnaker_src/spike_source.c **** #endif
 160:spinnaker_src/spike_source.c **** 	
 161:spinnaker_src/spike_source.c **** 		//log_info("time: %d\n",systicks);
 162:spinnaker_src/spike_source.c **** 		
 163:spinnaker_src/spike_source.c **** 		//log_info("%d\n",p);
 164:spinnaker_src/spike_source.c **** 		conv.f = pd;
 165:spinnaker_src/spike_source.c **** 
 166:spinnaker_src/spike_source.c **** 
 167:spinnaker_src/spike_source.c **** 		//debug! system
 168:spinnaker_src/spike_source.c **** 		*(address0+1) = conv.i;
 169:spinnaker_src/spike_source.c **** 	}	
 170:spinnaker_src/spike_source.c **** 
 171:spinnaker_src/spike_source.c **** 
 172:spinnaker_src/spike_source.c **** 	//log_info("%d\n",conv.i);
 173:spinnaker_src/spike_source.c **** 	//conv.f = pid_result;
 174:spinnaker_src/spike_source.c **** 	//log_info("%d\n",conv.i);
 175:spinnaker_src/spike_source.c **** 	//conv.f = nengo_result;
 176:spinnaker_src/spike_source.c **** 	//log_info("%d\n",conv.i);
 177:spinnaker_src/spike_source.c **** 
 178:spinnaker_src/spike_source.c **** 	
 179:spinnaker_src/spike_source.c **** 
 180:spinnaker_src/spike_source.c **** 	
 181:spinnaker_src/spike_source.c **** 	/*
 182:spinnaker_src/spike_source.c **** 	log_info("control signal: %.8g\n", u_all);
 183:spinnaker_src/spike_source.c **** 	conv.i = p;
 184:spinnaker_src/spike_source.c **** 	log_info("ev3 position: %.8g\n", conv.f );
 185:spinnaker_src/spike_source.c **** 	conv.i = pd;
 186:spinnaker_src/spike_source.c **** 	log_info("desired position: %.8g\n", conv.f );
 187:spinnaker_src/spike_source.c **** 	*/
 188:spinnaker_src/spike_source.c **** 	
 189:spinnaker_src/spike_source.c **** }
 190:spinnaker_src/spike_source.c **** REAL generate_pd(uint32_t period, uint32_t time){
  30              		.loc 1 190 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  35              	.LVL0:
 191:spinnaker_src/spike_source.c **** 
 192:spinnaker_src/spike_source.c **** 	REAL pd;
 193:spinnaker_src/spike_source.c **** 	//if(((systicks/1000)%period)>=period/2){
 194:spinnaker_src/spike_source.c **** 	if(((time/1000)%period)>=period/2){
  36              		.loc 1 194 0
  37 0000 084B     		ldr	r3, .L4
  38 0002 A3FB0131 		umull	r3, r1, r3, r1
  39              	.LVL1:
  40 0006 8909     		lsrs	r1, r1, #6
  41 0008 B1FBF0F3 		udiv	r3, r1, r0
  42 000c 00FB1311 		mls	r1, r0, r3, r1
  43 0010 B1EB500F 		cmp	r1, r0, lsr #1
 195:spinnaker_src/spike_source.c **** 	
 196:spinnaker_src/spike_source.c **** 		pd = -1;
 197:spinnaker_src/spike_source.c **** 	}
 198:spinnaker_src/spike_source.c **** 	else{
 199:spinnaker_src/spike_source.c **** 	
 200:spinnaker_src/spike_source.c **** 		pd = 1;
  44              		.loc 1 200 0
  45 0014 F7EE007A 		fconsts	s15, #112
  46 0018 BFEE000A 		fconsts	s0, #240
  47              	.LVL2:
 201:spinnaker_src/spike_source.c **** 	}
 202:spinnaker_src/spike_source.c **** 	return pd;
 203:spinnaker_src/spike_source.c **** }
  48              		.loc 1 203 0
  49 001c 38BF     		it	cc
  50 001e B0EE670A 		fcpyscc	s0, s15
  51              	.LVL3:
  52 0022 7047     		bx	lr
  53              	.L5:
  54              		.align	2
  55              	.L4:
  56 0024 D34D6210 		.word	274877907
  57              		.cfi_endproc
  58              	.LFE188:
  60              		.section	.text.pid_init,"ax",%progbits
  61              		.align	2
  62              		.global	pid_init
  63              		.thumb
  64              		.thumb_func
  66              	pid_init:
  67              	.LFB189:
 204:spinnaker_src/spike_source.c **** 
 205:spinnaker_src/spike_source.c **** void pid_init(REAL kp, REAL ki, REAL kd, REAL tau_d){
  68              		.loc 1 205 0
  69              		.cfi_startproc
  70              		@ args = 0, pretend = 0, frame = 0
  71              		@ frame_needed = 0, uses_anonymous_args = 0
  72              	.LVL4:
  73 0000 08B5     		push	{r3, lr}
  74              		.cfi_def_cfa_offset 8
  75              		.cfi_offset 3, -8
  76              		.cfi_offset 14, -4
 206:spinnaker_src/spike_source.c **** 
 207:spinnaker_src/spike_source.c **** 	kp= kp;
 208:spinnaker_src/spike_source.c **** 	ki= ki;
 209:spinnaker_src/spike_source.c **** 	kd= kd;
 210:spinnaker_src/spike_source.c **** 	tau_d = tau_d;
 211:spinnaker_src/spike_source.c **** 	scale = expf(-dt / TAU_D);
  77              		.loc 1 211 0
  78 0002 074B     		ldr	r3, .L8
  79 0004 9FED070A 		flds	s0, .L8+4
  80              	.LVL5:
  81 0008 D3ED007A 		flds	s15, [r3]
  82 000c F1EE677A 		fnegs	s15, s15
  83 0010 87EE800A 		fdivs	s0, s15, s0
  84 0014 FFF7FEFF 		bl	expf
  85              	.LVL6:
  86 0018 034B     		ldr	r3, .L8+8
  87 001a 83ED000A 		fsts	s0, [r3]
  88 001e 08BD     		pop	{r3, pc}
  89              	.L9:
  90              		.align	2
  91              	.L8:
  92 0020 00000000 		.word	.LANCHOR0
  93 0024 6F12833A 		.word	981668463
  94 0028 00000000 		.word	scale
  95              		.cfi_endproc
  96              	.LFE189:
  98              		.section	.text.pid,"ax",%progbits
  99              		.align	2
 100              		.global	pid
 101              		.thumb
 102              		.thumb_func
 104              	pid:
 105              	.LFB190:
 212:spinnaker_src/spike_source.c **** //	log_info("%#010x\n",*(uint32_t*)&scale);
 213:spinnaker_src/spike_source.c **** 
 214:spinnaker_src/spike_source.c **** }
 215:spinnaker_src/spike_source.c **** 
 216:spinnaker_src/spike_source.c **** REAL pid(uint32_t p, REAL desired_state){
 106              		.loc 1 216 0
 107              		.cfi_startproc
 108              		@ args = 0, pretend = 0, frame = 0
 109              		@ frame_needed = 0, uses_anonymous_args = 0
 110              		@ link register save eliminated.
 111              	.LVL7:
 217:spinnaker_src/spike_source.c **** 
 218:spinnaker_src/spike_source.c **** 	REAL state;
 219:spinnaker_src/spike_source.c **** 	REAL pid_output;
 220:spinnaker_src/spike_source.c **** 
 221:spinnaker_src/spike_source.c **** 
 222:spinnaker_src/spike_source.c **** 	conv.i = p;
 223:spinnaker_src/spike_source.c **** 	state = conv.f;
 224:spinnaker_src/spike_source.c **** 
 225:spinnaker_src/spike_source.c **** 	REAL d;
 226:spinnaker_src/spike_source.c **** 
 227:spinnaker_src/spike_source.c ****     d = state - prev_state;
 112              		.loc 1 227 0
 113 0000 1A4A     		ldr	r2, .L12
 228:spinnaker_src/spike_source.c ****     dstate = dstate * scale + d * (1.0 - scale);
 114              		.loc 1 228 0
 115 0002 1B4B     		ldr	r3, .L12+4
 227:spinnaker_src/spike_source.c ****     dstate = dstate * scale + d * (1.0 - scale);
 116              		.loc 1 227 0
 117 0004 D2ED005A 		flds	s11, [r2]
 118              		.loc 1 228 0
 119 0008 D3ED004A 		flds	s9, [r3]
 120 000c 194B     		ldr	r3, .L12+8
 229:spinnaker_src/spike_source.c ****     istate += dt * (desired_state - state);
 121              		.loc 1 229 0
 122 000e 1A49     		ldr	r1, .L12+12
 228:spinnaker_src/spike_source.c ****     dstate = dstate * scale + d * (1.0 - scale);
 123              		.loc 1 228 0
 124 0010 93ED003A 		flds	s6, [r3]
 125              		.loc 1 229 0
 126 0014 D1ED006A 		flds	s13, [r1]
 230:spinnaker_src/spike_source.c **** 
 231:spinnaker_src/spike_source.c **** 	
 232:spinnaker_src/spike_source.c **** 
 233:spinnaker_src/spike_source.c ****     prev_state = state;
 234:spinnaker_src/spike_source.c **** 
 235:spinnaker_src/spike_source.c **** 	/*
 236:spinnaker_src/spike_source.c **** 	pid_output = (kp * (desired_state - state) +
 237:spinnaker_src/spike_source.c **** 		 kd * (desired_dstate - dstate) +
 238:spinnaker_src/spike_source.c **** 		 ki * istate);
 239:spinnaker_src/spike_source.c **** 		 */
 240:spinnaker_src/spike_source.c **** 	pid_output = (KP * (desired_state - state) +
 127              		.loc 1 240 0
 128 0018 9FED184A 		flds	s8, .L12+16
 129 001c 06EE100A 		fmsr	s12, r0
 130              	.LVL8:
 228:spinnaker_src/spike_source.c ****     istate += dt * (desired_state - state);
 131              		.loc 1 228 0
 132 0020 F7EE007A 		fconsts	s15, #112
 227:spinnaker_src/spike_source.c ****     dstate = dstate * scale + d * (1.0 - scale);
 133              		.loc 1 227 0
 134 0024 76EE655A 		fsubs	s11, s12, s11
 135              	.LVL9:
 228:spinnaker_src/spike_source.c ****     istate += dt * (desired_state - state);
 136              		.loc 1 228 0
 137 0028 77EEE47A 		fsubs	s15, s15, s9
 216:spinnaker_src/spike_source.c **** 
 138              		.loc 1 216 0
 139 002c 30B4     		push	{r4, r5}
 140              		.cfi_def_cfa_offset 8
 141              		.cfi_offset 4, -8
 142              		.cfi_offset 5, -4
 228:spinnaker_src/spike_source.c ****     istate += dt * (desired_state - state);
 143              		.loc 1 228 0
 144 002e 67EEA57A 		fmuls	s15, s15, s11
 241:spinnaker_src/spike_source.c **** 		 KD * (desired_dstate - dstate) +
 145              		.loc 1 241 0
 146 0032 134D     		ldr	r5, .L12+20
 229:spinnaker_src/spike_source.c **** 
 147              		.loc 1 229 0
 148 0034 134C     		ldr	r4, .L12+24
 149              		.loc 1 241 0
 150 0036 95ED007A 		flds	s14, [r5]
 229:spinnaker_src/spike_source.c **** 
 151              		.loc 1 229 0
 152 003a D4ED003A 		flds	s7, [r4]
 222:spinnaker_src/spike_source.c **** 	state = conv.f;
 153              		.loc 1 222 0
 154 003e 124C     		ldr	r4, .L12+28
 233:spinnaker_src/spike_source.c **** 
 155              		.loc 1 233 0
 156 0040 1060     		str	r0, [r2]	@ float
 228:spinnaker_src/spike_source.c ****     istate += dt * (desired_state - state);
 157              		.loc 1 228 0
 158 0042 E3EE247A 		vfma.f32	s15, s6, s9
 222:spinnaker_src/spike_source.c **** 	state = conv.f;
 159              		.loc 1 222 0
 160 0046 2060     		str	r0, [r4]
 242:spinnaker_src/spike_source.c **** 		 KI * istate);
 243:spinnaker_src/spike_source.c **** 
 244:spinnaker_src/spike_source.c **** #ifdef SOURCE_CORE
 245:spinnaker_src/spike_source.c **** 	//debug!
 246:spinnaker_src/spike_source.c **** 	/*
 247:spinnaker_src/spike_source.c **** 	if(record_count < RECORD_LEN){
 248:spinnaker_src/spike_source.c **** 		nengo_output_record[record_count]=KP * (desired_state - state);
 249:spinnaker_src/spike_source.c **** 		record_count++;
 250:spinnaker_src/spike_source.c **** 		nengo_output_record[record_count]=KD * (desired_dstate - dstate);
 251:spinnaker_src/spike_source.c **** 		record_count++;
 252:spinnaker_src/spike_source.c **** 	}
 253:spinnaker_src/spike_source.c **** 	*/
 254:spinnaker_src/spike_source.c **** #endif
 255:spinnaker_src/spike_source.c **** 	/*
 256:spinnaker_src/spike_source.c **** 	conv.f = (desired_state );
 257:spinnaker_src/spike_source.c **** 	log_info("%#010x\n",conv.i);
 258:spinnaker_src/spike_source.c **** 	conv.f = (state);
 259:spinnaker_src/spike_source.c **** 	log_info("%#010x\n",conv.i);
 260:spinnaker_src/spike_source.c **** 	conv.f = KP * (desired_state - state);
 261:spinnaker_src/spike_source.c **** 	log_info("%#010x\n",conv.i);
 262:spinnaker_src/spike_source.c **** 	conv.f = KD * (desired_dstate - dstate);
 263:spinnaker_src/spike_source.c **** 	log_info("%#010x\n",conv.i);
 264:spinnaker_src/spike_source.c **** 	conv.f = pid_output;
 265:spinnaker_src/spike_source.c **** 	log_info("%#010x\n",conv.i);
 266:spinnaker_src/spike_source.c **** 	*/
 267:spinnaker_src/spike_source.c **** 
 268:spinnaker_src/spike_source.c **** 	return pid_output;
 269:spinnaker_src/spike_source.c **** }
 161              		.loc 1 269 0
 162 0048 30BC     		pop	{r4, r5}
 163              		.cfi_restore 5
 164              		.cfi_restore 4
 165              		.cfi_def_cfa_offset 0
 229:spinnaker_src/spike_source.c **** 
 166              		.loc 1 229 0
 167 004a 30EE465A 		fsubs	s10, s0, s12
 241:spinnaker_src/spike_source.c **** 		 KI * istate);
 168              		.loc 1 241 0
 169 004e 37EE670A 		fsubs	s0, s14, s15
 170              	.LVL10:
 240:spinnaker_src/spike_source.c **** 		 KD * (desired_dstate - dstate) +
 171              		.loc 1 240 0
 172 0052 F0EE005A 		fconsts	s11, #0
 229:spinnaker_src/spike_source.c **** 
 173              		.loc 1 229 0
 174 0056 E5EE236A 		vfma.f32	s13, s10, s7
 240:spinnaker_src/spike_source.c **** 		 KD * (desired_dstate - dstate) +
 175              		.loc 1 240 0
 176 005a A5EE250A 		vfma.f32	s0, s10, s11
 229:spinnaker_src/spike_source.c **** 
 177              		.loc 1 229 0
 178 005e C1ED006A 		fsts	s13, [r1]
 179              	.LVL11:
 180              		.loc 1 269 0
 181 0062 A6EE840A 		vfma.f32	s0, s13, s8
 228:spinnaker_src/spike_source.c ****     istate += dt * (desired_state - state);
 182              		.loc 1 228 0
 183 0066 C3ED007A 		fsts	s15, [r3]
 184              		.loc 1 269 0
 185 006a 7047     		bx	lr
 186              	.L13:
 187              		.align	2
 188              	.L12:
 189 006c 00000000 		.word	.LANCHOR2
 190 0070 00000000 		.word	scale
 191 0074 00000000 		.word	.LANCHOR1
 192 0078 00000000 		.word	.LANCHOR3
 193 007c 00000000 		.word	0
 194 0080 00000000 		.word	.LANCHOR4
 195 0084 00000000 		.word	.LANCHOR0
 196 0088 00000000 		.word	conv
 197              		.cfi_endproc
 198              	.LFE190:
 200              		.section	.text.send_source_spikes,"ax",%progbits
 201              		.align	2
 202              		.global	send_source_spikes
 203              		.thumb
 204              		.thumb_func
 206              	send_source_spikes:
 207              	.LFB187:
  47:spinnaker_src/spike_source.c **** 	
 208              		.loc 1 47 0
 209              		.cfi_startproc
 210              		@ args = 0, pretend = 0, frame = 16
 211              		@ frame_needed = 0, uses_anonymous_args = 0
 212 0000 2DE9F04F 		push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
 213              		.cfi_def_cfa_offset 36
 214              		.cfi_offset 4, -36
 215              		.cfi_offset 5, -32
 216              		.cfi_offset 6, -28
 217              		.cfi_offset 7, -24
 218              		.cfi_offset 8, -20
 219              		.cfi_offset 9, -16
 220              		.cfi_offset 10, -12
 221              		.cfi_offset 11, -8
 222              		.cfi_offset 14, -4
  57:spinnaker_src/spike_source.c **** 		nengo_result = 0;
 223              		.loc 1 57 0
 224 0004 6E48     		ldr	r0, .L23
  49:spinnaker_src/spike_source.c **** 	address1 =(uint32_t*) (IF_CURR_EXP_EXT_BASE+8); 
 225              		.loc 1 49 0
 226 0006 6F4B     		ldr	r3, .L23+4
  50:spinnaker_src/spike_source.c **** 
 227              		.loc 1 50 0
 228 0008 6F49     		ldr	r1, .L23+8
 229 000a 704A     		ldr	r2, .L23+12
  54:spinnaker_src/spike_source.c **** 	
 230              		.loc 1 54 0
 231 000c DFF8F4C1 		ldr	ip, .L23+68
  47:spinnaker_src/spike_source.c **** 	
 232              		.loc 1 47 0
 233 0010 2DED028B 		fstmfdd	sp!, {d8}
 234              		.cfi_def_cfa_offset 44
 235              		.cfi_offset 80, -44
 236              		.cfi_offset 81, -40
  49:spinnaker_src/spike_source.c **** 	address1 =(uint32_t*) (IF_CURR_EXP_EXT_BASE+8); 
 237              		.loc 1 49 0
 238 0014 4FF4B034 		mov	r4, #90112
 239 0018 1C60     		str	r4, [r3]
  57:spinnaker_src/spike_source.c **** 		nengo_result = 0;
 240              		.loc 1 57 0
 241 001a 0468     		ldr	r4, [r0]
  54:spinnaker_src/spike_source.c **** 	
 242              		.loc 1 54 0
 243 001c 0868     		ldr	r0, [r1]
  50:spinnaker_src/spike_source.c **** 
 244              		.loc 1 50 0
 245 001e 1160     		str	r1, [r2]
  47:spinnaker_src/spike_source.c **** 	
 246              		.loc 1 47 0
 247 0020 85B0     		sub	sp, sp, #20
 248              		.cfi_def_cfa_offset 64
  54:spinnaker_src/spike_source.c **** 	
 249              		.loc 1 54 0
 250 0022 CCF80000 		str	r0, [ip]
  57:spinnaker_src/spike_source.c **** 		nengo_result = 0;
 251              		.loc 1 57 0
 252 0026 8CB1     		cbz	r4, .L18
 253              	.LVL12:
 254              	.LBB5:
  60:spinnaker_src/spike_source.c **** 		}
 255              		.loc 1 60 0
 256 0028 6949     		ldr	r1, .L23+16
 257 002a DFED6A7A 		flds	s15, .L23+20
 258 002e 91ED007A 		flds	s14, [r1]
 259 0032 91ED016A 		flds	s12, [r1, #4]
 260 0036 D1ED026A 		flds	s13, [r1, #8]
 261 003a 6749     		ldr	r1, .L23+24
 262 003c 37EE277A 		fadds	s14, s14, s15
 263 0040 77EE067A 		fadds	s15, s14, s12
 264 0044 76EEA77A 		fadds	s15, s13, s15
 265 0048 C1ED007A 		fsts	s15, [r1]
 266              	.LVL13:
 267              	.L18:
 268              	.LBE5:
  65:spinnaker_src/spike_source.c **** 		//debug! minsim
 269              		.loc 1 65 0
 270 004c 5E49     		ldr	r1, .L23+8
 271 004e DFF8B8A1 		ldr	r10, .L23+72
 272 0052 4968     		ldr	r1, [r1, #4]
 273 0054 DAF80040 		ldr	r4, [r10]
 274 0058 A142     		cmp	r1, r4
 275 005a 40F2AB80 		bls	.L14
  67:spinnaker_src/spike_source.c **** 		//pd = generate_pd(desired_signal_period, systicks);
 276              		.loc 1 67 0
 277 005e 5F4C     		ldr	r4, .L23+28
 278              	.LBB6:
 279              	.LBB7:
 194:spinnaker_src/spike_source.c **** 	
 280              		.loc 1 194 0
 281 0060 DFF8A8E1 		ldr	lr, .L23+76
 282              	.LBE7:
 283              	.LBE6:
  67:spinnaker_src/spike_source.c **** 		//pd = generate_pd(desired_signal_period, systicks);
 284              		.loc 1 67 0
 285 0064 D4ED007A 		flds	s15, [r4]
 286 0068 0193     		str	r3, [sp, #4]
 287 006a FCEEE77A 		ftouizs	s15, s15
 288              	.LBB10:
 289              	.LBB8:
 194:spinnaker_src/spike_source.c **** 	
 290              		.loc 1 194 0
 291 006e AEFB0131 		umull	r3, r1, lr, r1
 292              	.LBE8:
 293              	.LBE10:
  67:spinnaker_src/spike_source.c **** 		//pd = generate_pd(desired_signal_period, systicks);
 294              		.loc 1 67 0
 295 0072 17EE904A 		fmrs	r4, s15	@ int
 296              	.LVL14:
 297              	.LBB11:
 298              	.LBB9:
 194:spinnaker_src/spike_source.c **** 	
 299              		.loc 1 194 0
 300 0076 8909     		lsrs	r1, r1, #6
 301 0078 B1FBF4FE 		udiv	lr, r1, r4
 302 007c 04FB1E11 		mls	r1, r4, lr, r1
 200:spinnaker_src/spike_source.c **** 	}
 303              		.loc 1 200 0
 304 0080 B1EB540F 		cmp	r1, r4, lsr #1
 305 0084 B7EE008A 		fconsts	s16, #112
 306 0088 FFEE007A 		fconsts	s15, #240
 307 008c 38BF     		it	cc
 308 008e F0EE487A 		fcpyscc	s15, s16
 309              	.LVL15:
 310              	.LBE9:
 311              	.LBE11:
  67:spinnaker_src/spike_source.c **** 		//pd = generate_pd(desired_signal_period, systicks);
 312              		.loc 1 67 0
 313 0092 534B     		ldr	r3, .L23+32
 314 0094 0292     		str	r2, [sp, #8]
  69:spinnaker_src/spike_source.c **** 		record_output = 1;
 315              		.loc 1 69 0
 316 0096 B0EE670A 		fcpys	s0, s15
 317 009a CDF80CC0 		str	ip, [sp, #12]
  67:spinnaker_src/spike_source.c **** 		//pd = generate_pd(desired_signal_period, systicks);
 318              		.loc 1 67 0
 319 009e C3ED007A 		fsts	s15, [r3]
  69:spinnaker_src/spike_source.c **** 		record_output = 1;
 320              		.loc 1 69 0
 321 00a2 FFF7FEFF 		bl	pid
 322              	.LVL16:
 323 00a6 4F4B     		ldr	r3, .L23+36
  79:spinnaker_src/spike_source.c **** 		ens_id = 0; 
 324              		.loc 1 79 0
 325 00a8 DFF86491 		ldr	r9, .L23+80
  69:spinnaker_src/spike_source.c **** 		record_output = 1;
 326              		.loc 1 69 0
 327 00ac 83ED000A 		fsts	s0, [r3]
 328              	.LVL17:
  73:spinnaker_src/spike_source.c **** 		pid_result_int_neg = conv.i;
 329              		.loc 1 73 0
 330 00b0 F1EE407A 		fnegs	s15, s0
 331 00b4 17EE904A 		fmrs	r4, s15
 332              	.LVL18:
 333 00b8 4B4B     		ldr	r3, .L23+40
  82:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 334              		.loc 1 82 0
 335 00ba 4C4D     		ldr	r5, .L23+44
  74:spinnaker_src/spike_source.c **** 	
 336              		.loc 1 74 0
 337 00bc DFF854B1 		ldr	fp, .L23+84
  83:spinnaker_src/spike_source.c **** 		router_spike_a(key,payload);
 338              		.loc 1 83 0
 339 00c0 4B4F     		ldr	r7, .L23+48
  80:spinnaker_src/spike_source.c **** 		value_id = 0;
 340              		.loc 1 80 0
 341 00c2 4C4E     		ldr	r6, .L23+52
  81:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
 342              		.loc 1 81 0
 343 00c4 DFF85081 		ldr	r8, .L23+88
  73:spinnaker_src/spike_source.c **** 		pid_result_int_neg = conv.i;
 344              		.loc 1 73 0
 345 00c8 C3ED007A 		fsts	s15, [r3]
  82:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 346              		.loc 1 82 0
 347 00cc 4FF0004E 		mov	lr, #-2147483648
  84:spinnaker_src/spike_source.c **** 		
 348              		.loc 1 84 0
 349 00d0 2146     		mov	r1, r4
 350 00d2 7046     		mov	r0, lr
  79:spinnaker_src/spike_source.c **** 		ens_id = 0; 
 351              		.loc 1 79 0
 352 00d4 0024     		movs	r4, #0
  74:spinnaker_src/spike_source.c **** 	
 353              		.loc 1 74 0
 354 00d6 CBED007A 		fsts	s15, [fp]	@ int
  83:spinnaker_src/spike_source.c **** 		router_spike_a(key,payload);
 355              		.loc 1 83 0
 356 00da C7ED007A 		fsts	s15, [r7]	@ int
  79:spinnaker_src/spike_source.c **** 		ens_id = 0; 
 357              		.loc 1 79 0
 358 00de C9F80040 		str	r4, [r9]
  82:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 359              		.loc 1 82 0
 360 00e2 C5F800E0 		str	lr, [r5]
  80:spinnaker_src/spike_source.c **** 		value_id = 0;
 361              		.loc 1 80 0
 362 00e6 3460     		str	r4, [r6]
  81:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
 363              		.loc 1 81 0
 364 00e8 C8F80040 		str	r4, [r8]
  84:spinnaker_src/spike_source.c **** 		
 365              		.loc 1 84 0
 366 00ec FFF7FEFF 		bl	router_spike_a
 367              	.LVL19:
  90:spinnaker_src/spike_source.c **** 		router_spike_b(key,payload);
 368              		.loc 1 90 0
 369 00f0 DBF80000 		ldr	r0, [fp]
  89:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 370              		.loc 1 89 0
 371 00f4 DFF824E1 		ldr	lr, .L23+92
  90:spinnaker_src/spike_source.c **** 		router_spike_b(key,payload);
 372              		.loc 1 90 0
 373 00f8 3860     		str	r0, [r7]
  87:spinnaker_src/spike_source.c **** 		value_id = 0;
 374              		.loc 1 87 0
 375 00fa 0121     		movs	r1, #1
 376 00fc 3160     		str	r1, [r6]
  91:spinnaker_src/spike_source.c **** 
 377              		.loc 1 91 0
 378 00fe 0146     		mov	r1, r0
 379 0100 7046     		mov	r0, lr
  86:spinnaker_src/spike_source.c **** 		ens_id = 1; 
 380              		.loc 1 86 0
 381 0102 C9F80040 		str	r4, [r9]
  89:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 382              		.loc 1 89 0
 383 0106 C5F800E0 		str	lr, [r5]
  88:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
 384              		.loc 1 88 0
 385 010a C8F80040 		str	r4, [r8]
  91:spinnaker_src/spike_source.c **** 
 386              		.loc 1 91 0
 387 010e FFF7FEFF 		bl	router_spike_b
 388              	.LVL20:
  96:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 389              		.loc 1 96 0
 390 0112 DFF80CE1 		ldr	lr, .L23+96
  97:spinnaker_src/spike_source.c **** 		router_spike_c(key,payload);
 391              		.loc 1 97 0
 392 0116 DBF80010 		ldr	r1, [fp]
  93:spinnaker_src/spike_source.c **** 		ens_id = 2; 
 393              		.loc 1 93 0
 394 011a C9F80040 		str	r4, [r9]
  98:spinnaker_src/spike_source.c **** 		
 395              		.loc 1 98 0
 396 011e 7046     		mov	r0, lr
  94:spinnaker_src/spike_source.c **** 		value_id = 0;
 397              		.loc 1 94 0
 398 0120 4FF0020B 		mov	fp, #2
  96:spinnaker_src/spike_source.c **** 		payload = pid_result_int_neg;
 399              		.loc 1 96 0
 400 0124 C5F800E0 		str	lr, [r5]
  97:spinnaker_src/spike_source.c **** 		router_spike_c(key,payload);
 401              		.loc 1 97 0
 402 0128 3960     		str	r1, [r7]
  95:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id | (1<<31);
 403              		.loc 1 95 0
 404 012a C8F80040 		str	r4, [r8]
  94:spinnaker_src/spike_source.c **** 		value_id = 0;
 405              		.loc 1 94 0
 406 012e C6F800B0 		str	fp, [r6]
  98:spinnaker_src/spike_source.c **** 		
 407              		.loc 1 98 0
 408 0132 FFF7FEFF 		bl	router_spike_c
 409              	.LVL21:
 105:spinnaker_src/spike_source.c **** 		//debug! system
 410              		.loc 1 105 0
 411 0136 DDF80CC0 		ldr	ip, [sp, #12]
 101:spinnaker_src/spike_source.c **** 		ens_id = 3; 
 412              		.loc 1 101 0
 413 013a C9F80040 		str	r4, [r9]
 105:spinnaker_src/spike_source.c **** 		//debug! system
 414              		.loc 1 105 0
 415 013e DCF800C0 		ldr	ip, [ip]
 103:spinnaker_src/spike_source.c **** 		key = (core_id << CORE_ID_SHIFT ) | (ens_id << ENS_ID_SHIFT) | value_id;
 416              		.loc 1 103 0
 417 0142 C8F80040 		str	r4, [r8]
 104:spinnaker_src/spike_source.c **** 		payload = p;
 418              		.loc 1 104 0
 419 0146 4FF0300E 		mov	lr, #48
 107:spinnaker_src/spike_source.c **** 		
 420              		.loc 1 107 0
 421 014a 6146     		mov	r1, ip
 422 014c 7046     		mov	r0, lr
 102:spinnaker_src/spike_source.c **** 		value_id = 0;
 423              		.loc 1 102 0
 424 014e 4FF00309 		mov	r9, #3
 104:spinnaker_src/spike_source.c **** 		payload = p;
 425              		.loc 1 104 0
 426 0152 C5F800E0 		str	lr, [r5]
 105:spinnaker_src/spike_source.c **** 		//debug! system
 427              		.loc 1 105 0
 428 0156 C7F800C0 		str	ip, [r7]
 102:spinnaker_src/spike_source.c **** 		value_id = 0;
 429              		.loc 1 102 0
 430 015a C6F80090 		str	r9, [r6]
 107:spinnaker_src/spike_source.c **** 		
 431              		.loc 1 107 0
 432 015e FFF7FEFF 		bl	router_spike_d
 433              	.LVL22:
 113:spinnaker_src/spike_source.c **** 		nengo_result = motor_synpase_scale_value; 
 434              		.loc 1 113 0
 435 0162 2548     		ldr	r0, .L23+56
 436 0164 1C49     		ldr	r1, .L23+24
 437 0166 D0ED007A 		flds	s15, [r0]
 438 016a 91ED006A 		flds	s12, [r1]
 439 016e 2348     		ldr	r0, .L23+60
 121:spinnaker_src/spike_source.c **** 		//u_all = (pid_result );
 440              		.loc 1 121 0
 441 0170 1C4B     		ldr	r3, .L23+36
 113:spinnaker_src/spike_source.c **** 		nengo_result = motor_synpase_scale_value; 
 442              		.loc 1 113 0
 443 0172 D0ED006A 		flds	s13, [r0]
 121:spinnaker_src/spike_source.c **** 		//u_all = (pid_result );
 444              		.loc 1 121 0
 445 0176 93ED007A 		flds	s14, [r3]
 117:spinnaker_src/spike_source.c **** 		//debug! system, minsim
 446              		.loc 1 117 0
 447 017a 029A     		ldr	r2, [sp, #8]
 164:spinnaker_src/spike_source.c **** 
 448              		.loc 1 164 0
 449 017c 184B     		ldr	r3, .L23+32
 117:spinnaker_src/spike_source.c **** 		//debug! system, minsim
 450              		.loc 1 117 0
 451 017e 1568     		ldr	r5, [r2]
 164:spinnaker_src/spike_source.c **** 
 452              		.loc 1 164 0
 453 0180 1A68     		ldr	r2, [r3]	@ float
 143:spinnaker_src/spike_source.c **** 	
 454              		.loc 1 143 0
 455 0182 019B     		ldr	r3, [sp, #4]
 121:spinnaker_src/spike_source.c **** 		//u_all = (pid_result );
 456              		.loc 1 121 0
 457 0184 1E4C     		ldr	r4, .L23+64
 143:spinnaker_src/spike_source.c **** 	
 458              		.loc 1 143 0
 459 0186 1B68     		ldr	r3, [r3]
 117:spinnaker_src/spike_source.c **** 		//debug! system, minsim
 460              		.loc 1 117 0
 461 0188 6D68     		ldr	r5, [r5, #4]
 462 018a CAF80050 		str	r5, [r10]
 113:spinnaker_src/spike_source.c **** 		nengo_result = motor_synpase_scale_value; 
 463              		.loc 1 113 0
 464 018e 38EE678A 		fsubs	s16, s16, s15
 465 0192 67EE867A 		fmuls	s15, s15, s12
 168:spinnaker_src/spike_source.c **** 	}	
 466              		.loc 1 168 0
 467 0196 5A60     		str	r2, [r3, #4]
 113:spinnaker_src/spike_source.c **** 		nengo_result = motor_synpase_scale_value; 
 468              		.loc 1 113 0
 469 0198 E8EE267A 		vfma.f32	s15, s16, s13
 121:spinnaker_src/spike_source.c **** 		//u_all = (pid_result );
 470              		.loc 1 121 0
 471 019c 37EE877A 		fadds	s14, s15, s14
 113:spinnaker_src/spike_source.c **** 		nengo_result = motor_synpase_scale_value; 
 472              		.loc 1 113 0
 473 01a0 C0ED007A 		fsts	s15, [r0]
 114:spinnaker_src/spike_source.c **** 
 474              		.loc 1 114 0
 475 01a4 C1ED007A 		fsts	s15, [r1]
 121:spinnaker_src/spike_source.c **** 		//u_all = (pid_result );
 476              		.loc 1 121 0
 477 01a8 84ED007A 		fsts	s14, [r4]
 143:spinnaker_src/spike_source.c **** 	
 478              		.loc 1 143 0
 479 01ac 83ED007A 		fsts	s14, [r3]	@ int
 164:spinnaker_src/spike_source.c **** 
 480              		.loc 1 164 0
 481 01b0 0D4B     		ldr	r3, .L23+40
 482 01b2 1A60     		str	r2, [r3]	@ float
 483              	.LVL23:
 484              	.L14:
 189:spinnaker_src/spike_source.c **** REAL generate_pd(uint32_t period, uint32_t time){
 485              		.loc 1 189 0
 486 01b4 05B0     		add	sp, sp, #20
 487              		.cfi_def_cfa_offset 44
 488              		@ sp needed
 489 01b6 BDEC028B 		fldmfdd	sp!, {d8}
 490              		.cfi_restore 80
 491              		.cfi_restore 81
 492              		.cfi_def_cfa_offset 36
 493 01ba BDE8F08F 		pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
 494              	.L24:
 495 01be 00BF     		.align	2
 496              	.L23:
 497 01c0 00000000 		.word	n_packets_received
 498 01c4 00000000 		.word	address0
 499 01c8 08600100 		.word	90120
 500 01cc 00000000 		.word	address1
 501 01d0 00000000 		.word	ensemble_results
 502 01d4 00000000 		.word	0
 503 01d8 00000000 		.word	nengo_result
 504 01dc 00000000 		.word	.LANCHOR6
 505 01e0 00000000 		.word	pd
 506 01e4 00000000 		.word	pid_result
 507 01e8 00000000 		.word	conv
 508 01ec 00000000 		.word	key
 509 01f0 00000000 		.word	payload
 510 01f4 00000000 		.word	ens_id
 511 01f8 00000000 		.word	.LANCHOR7
 512 01fc 00000000 		.word	motor_synpase_scale_value
 513 0200 00000000 		.word	u_all
 514 0204 00000000 		.word	p
 515 0208 00000000 		.word	.LANCHOR5
 516 020c D34D6210 		.word	274877907
 517 0210 00000000 		.word	core_id
 518 0214 00000000 		.word	pid_result_int_neg
 519 0218 00000000 		.word	value_id
 520 021c 10000080 		.word	-2147483632
 521 0220 20000080 		.word	-2147483616
 522              		.cfi_endproc
 523              	.LFE187:
 525              		.global	pc_time
 526              		.global	record_count
 527              		.comm	motor_synpase_scale_value,4,4
 528              		.global	motor_synapse_scale
 529              		.global	desired_signal_period
 530              		.global	desired_dstate
 531              		.global	dt
 532              		.global	istate
 533              		.global	dstate
 534              		.global	prev_state
 535              		.comm	scale,4,4
 536              		.comm	tau_d,4,4
 537              		.comm	kd,4,4
 538              		.comm	ki,4,4
 539              		.comm	kp,4,4
 540              		.comm	nengo_result,4,4
 541              		.comm	pid_result_int_neg,4,4
 542              		.comm	u_all,4,4
 543              		.comm	pd,4,4
 544              		.comm	pid_result,4,4
 545              		.comm	p,4,4
 546              		.comm	value_id,4,4
 547              		.comm	ens_id,4,4
 548              		.comm	core_id,4,4
 549              		.comm	conv,4,4
 550              		.comm	payload,4,4
 551              		.comm	key,4,4
 552              		.comm	address1,4,4
 553              		.comm	address0,4,4
 554              		.comm	API_BURST_FINISHED,1,1
 555              		.section	.bss.dstate,"aw",%nobits
 556              		.align	2
 557              		.set	.LANCHOR1,. + 0
 560              	dstate:
 561 0000 00000000 		.space	4
 562              		.section	.bss.desired_dstate,"aw",%nobits
 563              		.align	2
 564              		.set	.LANCHOR4,. + 0
 567              	desired_dstate:
 568 0000 00000000 		.space	4
 569              		.section	.data.dt,"aw",%progbits
 570              		.align	2
 571              		.set	.LANCHOR0,. + 0
 574              	dt:
 575 0000 6F12833A 		.word	981668463
 576              		.section	.bss.record_count,"aw",%nobits
 577              		.align	2
 580              	record_count:
 581 0000 00000000 		.space	4
 582              		.section	.bss.pc_time,"aw",%nobits
 583              		.align	2
 584              		.set	.LANCHOR5,. + 0
 587              	pc_time:
 588 0000 00000000 		.space	4
 589              		.section	.data.desired_signal_period,"aw",%progbits
 590              		.align	2
 591              		.set	.LANCHOR6,. + 0
 594              	desired_signal_period:
 595 0000 00008040 		.word	1082130432
 596              		.section	.data.motor_synapse_scale,"aw",%progbits
 597              		.align	2
 598              		.set	.LANCHOR7,. + 0
 601              	motor_synapse_scale:
 602 0000 6DA3673F 		.word	1063756653
 603              		.section	.bss.prev_state,"aw",%nobits
 604              		.align	2
 605              		.set	.LANCHOR2,. + 0
 608              	prev_state:
 609 0000 00000000 		.space	4
 610              		.section	.bss.istate,"aw",%nobits
 611              		.align	2
 612              		.set	.LANCHOR3,. + 0
 615              	istate:
 616 0000 00000000 		.space	4
 617              		.text
 618              	.Letext0:
 619              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 620              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 621              		.file 4 "spinnaker_src/common/maths-util.h"
 622              		.file 5 "spinnaker_src/param_defs.h"
 623              		.file 6 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 624              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 625              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
 626              		.file 9 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
 627              		.file 10 "/home/yexin/projects/JIB1Tests/float-libm/include/math.h"
 628              		.file 11 "spinnaker_src/neuron.h"
