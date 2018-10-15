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
  17              		.file	"synapses.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.sort_input_value,"ax",%progbits
  22              		.align	2
  23              		.global	sort_input_value
  24              		.thumb
  25              		.thumb_func
  27              	sort_input_value:
  28              	.LFB187:
  29              		.file 1 "spinnaker_src/synapses.c"
   1:spinnaker_src/synapses.c **** #include <stdint.h>
   2:spinnaker_src/synapses.c **** #include "qpe.h"
   3:spinnaker_src/synapses.c **** #include "synapses.h"
   4:spinnaker_src/synapses.c **** #include "spike_processing.h"
   5:spinnaker_src/synapses.c **** #include "param_defs.h"
   6:spinnaker_src/synapses.c **** #include "neuron.h"
   7:spinnaker_src/synapses.c **** 
   8:spinnaker_src/synapses.c **** 
   9:spinnaker_src/synapses.c **** //input_t input_buffers[INPUT_BUFFER_SIZE];
  10:spinnaker_src/synapses.c **** 
  11:spinnaker_src/synapses.c **** extern synapse_param_t neuron_synapse_shaping_params ;
  12:spinnaker_src/synapses.c **** 
  13:spinnaker_src/synapses.c **** extern uint32_t _heap_base, _heap_top;
  14:spinnaker_src/synapses.c **** 
  15:spinnaker_src/synapses.c **** extern uint32_t n_neurons;
  16:spinnaker_src/synapses.c **** 
  17:spinnaker_src/synapses.c **** uint32_t debug_count19=0;
  18:spinnaker_src/synapses.c **** 
  19:spinnaker_src/synapses.c **** extern uint32_t systicks;
  20:spinnaker_src/synapses.c **** 
  21:spinnaker_src/synapses.c **** extern uint32_t work_load;
  22:spinnaker_src/synapses.c **** 
  23:spinnaker_src/synapses.c **** extern int mc_packet_callback_priority;
  24:spinnaker_src/synapses.c **** 
  25:spinnaker_src/synapses.c **** uint32_t input_time_stamp;
  26:spinnaker_src/synapses.c **** 
  27:spinnaker_src/synapses.c **** extern uint32_t systicks_pm;
  28:spinnaker_src/synapses.c **** 
  29:spinnaker_src/synapses.c **** extern uint32_t pm_levels ;
  30:spinnaker_src/synapses.c **** extern uint32_t fill_level;
  31:spinnaker_src/synapses.c **** 
  32:spinnaker_src/synapses.c **** extern uint32_t time_done;
  33:spinnaker_src/synapses.c **** 
  34:spinnaker_src/synapses.c **** extern uint32_t n_packets_received;
  35:spinnaker_src/synapses.c **** 
  36:spinnaker_src/synapses.c **** extern uint32_t self_spikes[SELF_SPIKES_LENGTH];
  37:spinnaker_src/synapses.c **** extern uint32_t read_pos ;
  38:spinnaker_src/synapses.c **** extern volatile uint32_t packet_buffer[PACKET_BUFFER_LENGTH+1] __attribute__((aligned(0x10)));
  39:spinnaker_src/synapses.c **** 
  40:spinnaker_src/synapses.c **** extern uint32_t self_spike_counter;
  41:spinnaker_src/synapses.c **** 
  42:spinnaker_src/synapses.c **** 
  43:spinnaker_src/synapses.c **** //TODO learning with ens
  44:spinnaker_src/synapses.c **** //REAL error[N_OUTPUTS];
  45:spinnaker_src/synapses.c **** //REAL learning_activity[N_NEURONS];
  46:spinnaker_src/synapses.c **** //REAL delta[N_OUTPUTS*N_NEURONS];
  47:spinnaker_src/synapses.c **** //uint32_t error_not_none ;
  48:spinnaker_src/synapses.c **** extern uint32_t pe_id;
  49:spinnaker_src/synapses.c **** //TODO unroll code gen according to N_INPUTS 
  50:spinnaker_src/synapses.c **** //TODO check if the functions for matrix multiply etc still work after unroll is not defined. 
  51:spinnaker_src/synapses.c **** 
  52:spinnaker_src/synapses.c **** //extern REAL * nengo_output_record;
  53:spinnaker_src/synapses.c **** extern uint32_t record_count ;
  54:spinnaker_src/synapses.c **** void sort_input_value(uint32_t * input){
  30              		.loc 1 54 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  35              	.LVL0:
  36 0000 7047     		bx	lr
  37              		.cfi_endproc
  38              	.LFE187:
  40 0002 00BF     		.section	.text.read_input_packets,"ax",%progbits
  41              		.align	2
  42              		.global	read_input_packets
  43              		.thumb
  44              		.thumb_func
  46              	read_input_packets:
  47              	.LFB188:
  55:spinnaker_src/synapses.c **** 
  56:spinnaker_src/synapses.c **** 	uint32_t  key;
  57:spinnaker_src/synapses.c **** 	uint32_t  payload;
  58:spinnaker_src/synapses.c **** 	key =*(input+1);
  59:spinnaker_src/synapses.c **** 	payload = *(input);
  60:spinnaker_src/synapses.c **** 	/*
  61:spinnaker_src/synapses.c **** #ifdef ENS_CORE
  62:spinnaker_src/synapses.c **** 	for (uint32_t i = 0 ; i < n_ensembles; i++){
  63:spinnaker_src/synapses.c **** 	
  64:spinnaker_src/synapses.c **** 		if(ensembles[i].obj_id == (((key)>>ENS_ID_SHIFT)&ENS_ID_MASK)){
  65:spinnaker_src/synapses.c **** 		
  66:spinnaker_src/synapses.c **** 			conv_i_f conv;
  67:spinnaker_src/synapses.c **** 			conv.i = payload;
  68:spinnaker_src/synapses.c **** 			ensembles[i].inputs[(key&VALUE_ID_MASK)] += conv.f; 
  69:spinnaker_src/synapses.c **** 				
  70:spinnaker_src/synapses.c **** 			break;
  71:spinnaker_src/synapses.c **** 		}
  72:spinnaker_src/synapses.c **** 
  73:spinnaker_src/synapses.c **** 	}
  74:spinnaker_src/synapses.c **** #endif
  75:spinnaker_src/synapses.c **** */
  76:spinnaker_src/synapses.c **** #ifdef INTER_CORE
  77:spinnaker_src/synapses.c **** 
  78:spinnaker_src/synapses.c **** 	for (uint32_t i = 0 ; i < n_inters; i++){
  79:spinnaker_src/synapses.c **** 	
  80:spinnaker_src/synapses.c **** 		if(inters[i].obj_id == (((key)>>ENS_ID_SHIFT)&ENS_ID_MASK)){
  81:spinnaker_src/synapses.c **** 		
  82:spinnaker_src/synapses.c **** 			conv_i_f conv;
  83:spinnaker_src/synapses.c **** 			conv.i = payload;
  84:spinnaker_src/synapses.c **** 			inters[i].inputs[(key&VALUE_ID_MASK)] += conv.f; 
  85:spinnaker_src/synapses.c **** 			//debug! topology specific
  86:spinnaker_src/synapses.c **** 			
  87:spinnaker_src/synapses.c **** 			/*
  88:spinnaker_src/synapses.c **** 			if(inters[i].obj_id == 16){
  89:spinnaker_src/synapses.c **** 				log_info("time: %d , %#010x\n",systicks, payload);
  90:spinnaker_src/synapses.c **** 			}
  91:spinnaker_src/synapses.c **** 			*/
  92:spinnaker_src/synapses.c **** 			
  93:spinnaker_src/synapses.c **** 			/*
  94:spinnaker_src/synapses.c **** 			if(inters[i].obj_id == 15){
  95:spinnaker_src/synapses.c **** 				//A
  96:spinnaker_src/synapses.c **** 				log_info("%#010x\n",payload);
  97:spinnaker_src/synapses.c **** 			}
  98:spinnaker_src/synapses.c **** 			*/
  99:spinnaker_src/synapses.c **** 			/*
 100:spinnaker_src/synapses.c **** 			if(inters[i].obj_id == 17){
 101:spinnaker_src/synapses.c **** 				//B
 102:spinnaker_src/synapses.c **** 				log_info("%#010x\n",payload);
 103:spinnaker_src/synapses.c **** 			}
 104:spinnaker_src/synapses.c **** 			*/
 105:spinnaker_src/synapses.c **** 			
 106:spinnaker_src/synapses.c **** 			/*
 107:spinnaker_src/synapses.c **** 			if(inters[i].obj_id == 19){
 108:spinnaker_src/synapses.c **** 				//C
 109:spinnaker_src/synapses.c **** 				log_info("%#010x\n",payload);
 110:spinnaker_src/synapses.c **** 			}
 111:spinnaker_src/synapses.c **** 			*/
 112:spinnaker_src/synapses.c **** 				
 113:spinnaker_src/synapses.c **** 		/*	
 114:spinnaker_src/synapses.c **** 			if(inters[i].obj_id == 24 ){
 115:spinnaker_src/synapses.c **** 				log_info("time: %d, ID: %d, %#010x\n",systicks, (key&VALUE_ID_MASK), payload);
 116:spinnaker_src/synapses.c **** 			}
 117:spinnaker_src/synapses.c **** 		*/	
 118:spinnaker_src/synapses.c **** 			
 119:spinnaker_src/synapses.c **** 			//log_info("%#010x\n",payload);
 120:spinnaker_src/synapses.c **** 			break;
 121:spinnaker_src/synapses.c **** 		}
 122:spinnaker_src/synapses.c **** 
 123:spinnaker_src/synapses.c **** 	}
 124:spinnaker_src/synapses.c **** 
 125:spinnaker_src/synapses.c **** #endif
 126:spinnaker_src/synapses.c **** #ifdef ENS_CORE 
 127:spinnaker_src/synapses.c **** 	//TODO maybe this can be optimized. sort the messages according to pre obj id.
 128:spinnaker_src/synapses.c **** 	for (uint32_t i = 0 ; i < n_mess; i++){
 129:spinnaker_src/synapses.c **** 		uint32_t ens_id;
 130:spinnaker_src/synapses.c **** 		uint32_t value_id;
 131:spinnaker_src/synapses.c **** 		ens_id= (((key)>>ENS_ID_SHIFT)&ENS_ID_MASK);
 132:spinnaker_src/synapses.c **** 		//TODO for optimization, a message can receive input from different ensembles, if the low pass fi
 133:spinnaker_src/synapses.c **** 		if(mess[i].pre_obj_id == ens_id ){
 134:spinnaker_src/synapses.c **** 			value_id = (((key)>>VALUE_ID_SHIFT)&VALUE_ID_MASK) ;
 135:spinnaker_src/synapses.c **** 			if(mess[i].pre_start <= value_id && (mess[i].pre_start+mess[i].pre_len)> value_id){
 136:spinnaker_src/synapses.c **** 				conv_i_f conv;
 137:spinnaker_src/synapses.c **** 				conv.i = payload;
 138:spinnaker_src/synapses.c **** 				mess[i].pre_values[value_id-mess[i].pre_start] =(precision_t) conv.f; 
 139:spinnaker_src/synapses.c **** 				
 140:spinnaker_src/synapses.c **** 				//debug! system
 141:spinnaker_src/synapses.c **** 				
 142:spinnaker_src/synapses.c **** 				
 143:spinnaker_src/synapses.c **** 				/*
 144:spinnaker_src/synapses.c **** 				if(record_count < RECORD_LEN){
 145:spinnaker_src/synapses.c **** 				
 146:spinnaker_src/synapses.c **** 					if(pe_id == 0){
 147:spinnaker_src/synapses.c **** 						nengo_output_record[record_count]=conv.f;
 148:spinnaker_src/synapses.c **** 						record_count ++;
 149:spinnaker_src/synapses.c **** 					}
 150:spinnaker_src/synapses.c **** 					else if(pe_id == 1){
 151:spinnaker_src/synapses.c **** 						nengo_output_record[record_count]=systicks;
 152:spinnaker_src/synapses.c **** 						record_count ++;
 153:spinnaker_src/synapses.c **** 
 154:spinnaker_src/synapses.c **** 					}
 155:spinnaker_src/synapses.c **** 				}
 156:spinnaker_src/synapses.c **** 				*/
 157:spinnaker_src/synapses.c **** 				
 158:spinnaker_src/synapses.c **** 				
 159:spinnaker_src/synapses.c **** 				//log_info("%d\n", conv.i);
 160:spinnaker_src/synapses.c **** 				
 161:spinnaker_src/synapses.c **** 				/*		
 162:spinnaker_src/synapses.c **** 				if(mess[i].mess_id == 18){
 163:spinnaker_src/synapses.c **** 					log_info("time: %d , received %#010x\n",systicks, payload);
 164:spinnaker_src/synapses.c **** 				}
 165:spinnaker_src/synapses.c **** 				*/	
 166:spinnaker_src/synapses.c **** 				/*
 167:spinnaker_src/synapses.c **** 				if(mess[i].pre_obj_id == 24){
 168:spinnaker_src/synapses.c **** 					log_info("time: %d , received %#010x, post: %#010x\n",systicks, payload);
 169:spinnaker_src/synapses.c **** 				}
 170:spinnaker_src/synapses.c **** 				*/
 171:spinnaker_src/synapses.c **** 				
 172:spinnaker_src/synapses.c **** 
 173:spinnaker_src/synapses.c **** 				//log_info("%#010x\n",payload);
 174:spinnaker_src/synapses.c **** 				//break;
 175:spinnaker_src/synapses.c **** 			}
 176:spinnaker_src/synapses.c **** 		}
 177:spinnaker_src/synapses.c **** 	}
 178:spinnaker_src/synapses.c **** #endif
 179:spinnaker_src/synapses.c **** 
 180:spinnaker_src/synapses.c **** }
 181:spinnaker_src/synapses.c **** 
 182:spinnaker_src/synapses.c **** //debug! real time comm
 183:spinnaker_src/synapses.c **** 
 184:spinnaker_src/synapses.c **** #ifdef ENS_CORE 
 185:spinnaker_src/synapses.c **** //extern uint32_t external_packets[EXTERNAL_PACKETS_LENGTH];
 186:spinnaker_src/synapses.c **** void read_input_packets(){
 187:spinnaker_src/synapses.c **** 
 188:spinnaker_src/synapses.c **** 	uint32_t input_state_counter = 0; 
 189:spinnaker_src/synapses.c **** 	//uint32_t error_counter = 0; 
 190:spinnaker_src/synapses.c **** 	
 191:spinnaker_src/synapses.c **** 	clear_input_state();
 192:spinnaker_src/synapses.c **** 	
 193:spinnaker_src/synapses.c **** 	for (uint32_t i = 0 ; i < n_ensembles; i++){
 194:spinnaker_src/synapses.c **** 		ensembles[i].error_not_none = 0 ;
 195:spinnaker_src/synapses.c **** 	}
 196:spinnaker_src/synapses.c **** 	
 197:spinnaker_src/synapses.c **** 		//log_info("%d\n", n_packets_received );
 198:spinnaker_src/synapses.c **** 		//log_info("time: %d\n", systicks);
 199:spinnaker_src/synapses.c **** 	//TODO read state from packet buffer and self spikes, apply matrix multiplication
 200:spinnaker_src/synapses.c **** 	//read packets from other cores
 201:spinnaker_src/synapses.c **** 	for(uint32_t i = 0; i < n_packets_received/PACKET_IN_WORDS ; i++){
 202:spinnaker_src/synapses.c **** 
 203:spinnaker_src/synapses.c **** 		uint32_t read_pos1;
 204:spinnaker_src/synapses.c **** 		read_pos1 = read_pos +1;
 205:spinnaker_src/synapses.c **** 		if (read_pos1 > PACKET_BUFFER_LENGTH) {
 206:spinnaker_src/synapses.c **** 			read_pos1 = 0;
 207:spinnaker_src/synapses.c **** 		}
 208:spinnaker_src/synapses.c **** 
 209:spinnaker_src/synapses.c **** 		//debug!
 210:spinnaker_src/synapses.c **** 		//log_info("time: %d , received %#010x\n",systicks, packet_buffer[read_pos1]);
 211:spinnaker_src/synapses.c **** 		
 212:spinnaker_src/synapses.c **** 		//log_info("%d\n", packet_buffer[read_pos1]);
 213:spinnaker_src/synapses.c **** 		//log_info("%d\n", packet_buffer[read_pos]);
 214:spinnaker_src/synapses.c **** 		
 215:spinnaker_src/synapses.c **** 		//TODO only expect 1 payload
 216:spinnaker_src/synapses.c **** 		if(((packet_buffer[read_pos1]>>31)&1)==0){
 217:spinnaker_src/synapses.c **** 			//conv_i_f conv;
 218:spinnaker_src/synapses.c **** 			//conv.i = packet_buffer[read_pos];
 219:spinnaker_src/synapses.c **** 			//log_info("%d\n", conv.i);
 220:spinnaker_src/synapses.c **** 			//debug! topology specific
 221:spinnaker_src/synapses.c **** 			sort_input_value(&packet_buffer[read_pos]);
 222:spinnaker_src/synapses.c **** 			input_state_counter++;
 223:spinnaker_src/synapses.c **** 		}
 224:spinnaker_src/synapses.c **** 		else{
 225:spinnaker_src/synapses.c **** 		
 226:spinnaker_src/synapses.c **** 			uint32_t error_value_id;
 227:spinnaker_src/synapses.c **** 			uint32_t error_ens_id;
 228:spinnaker_src/synapses.c **** 			conv_i_f conv;
 229:spinnaker_src/synapses.c **** 			conv.i = packet_buffer[read_pos];
 230:spinnaker_src/synapses.c **** 			//TODO learning with ensemble. the error packet should specify its ens_id and value_id
 231:spinnaker_src/synapses.c **** 			error_value_id = (packet_buffer[read_pos1]>>VALUE_ID_SHIFT)&VALUE_ID_MASK;
 232:spinnaker_src/synapses.c **** 			error_ens_id =(packet_buffer[read_pos1]>>ENS_ID_SHIFT)&ENS_ID_MASK;
 233:spinnaker_src/synapses.c **** 			for (uint32_t j = 0 ; j < n_ensembles; j++){
 234:spinnaker_src/synapses.c **** 				
 235:spinnaker_src/synapses.c **** 				if(ensembles[j].obj_id == error_ens_id){
 236:spinnaker_src/synapses.c **** 				
 237:spinnaker_src/synapses.c **** 					ensembles[j].error[error_value_id] = conv.f;
 238:spinnaker_src/synapses.c **** 					ensembles[j].error_not_none = 1;
 239:spinnaker_src/synapses.c **** 					//log_info("%d\n",conv.i);
 240:spinnaker_src/synapses.c **** 				}
 241:spinnaker_src/synapses.c **** 			}
 242:spinnaker_src/synapses.c **** 
 243:spinnaker_src/synapses.c **** 		}
 244:spinnaker_src/synapses.c **** 		
 245:spinnaker_src/synapses.c **** 		
 246:spinnaker_src/synapses.c **** 		read_pos+=2;
 247:spinnaker_src/synapses.c **** 		if (read_pos > PACKET_BUFFER_LENGTH) {
 248:spinnaker_src/synapses.c **** 			read_pos = read_pos- PACKET_BUFFER_LENGTH - 1;
 249:spinnaker_src/synapses.c **** 		}
 250:spinnaker_src/synapses.c **** 	}
 251:spinnaker_src/synapses.c **** 			
 252:spinnaker_src/synapses.c **** 	//TODO input_state is not used any more!
 253:spinnaker_src/synapses.c **** 	//log_info("%#010x\n",*(uint32_t*)&input_state[0]);
 254:spinnaker_src/synapses.c **** 
 255:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_READ] = (uint32_t) &(packet_buffer[read_pos]);
 256:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 257:spinnaker_src/synapses.c **** 
 258:spinnaker_src/synapses.c **** 	/*
 259:spinnaker_src/synapses.c **** 	//read packets from external sources (pc, dvs, robot etc.)
 260:spinnaker_src/synapses.c **** 	//TODO currently only support 1 key + 1 payload
 261:spinnaker_src/synapses.c **** 	for(uint32_t i = 0; i < (n_external_packets_received-1)/2; i ++){
 262:spinnaker_src/synapses.c **** 	
 263:spinnaker_src/synapses.c **** 		
 264:spinnaker_src/synapses.c **** 
 265:spinnaker_src/synapses.c **** 		if(((external_packets[i*2+1]>>31)&1)==0){
 266:spinnaker_src/synapses.c **** 			//debug! topology specific
 267:spinnaker_src/synapses.c **** 			sort_input_value(&external_packets[i*2]);
 268:spinnaker_src/synapses.c **** 		}
 269:spinnaker_src/synapses.c **** 		else{
 270:spinnaker_src/synapses.c **** 		
 271:spinnaker_src/synapses.c **** 			uint32_t error_value_id;
 272:spinnaker_src/synapses.c **** 			uint32_t error_ens_id;
 273:spinnaker_src/synapses.c **** 			conv_i_f conv;
 274:spinnaker_src/synapses.c **** 			conv.i = external_packets[i*2];
 275:spinnaker_src/synapses.c **** 			//TODO learning with ensemble. the error packet should specify its ens_id and value_id
 276:spinnaker_src/synapses.c **** 			error_value_id = (external_packets[i*2+1]>>VALUE_ID_SHIFT)&VALUE_ID_MASK;
 277:spinnaker_src/synapses.c **** 			error_ens_id =(external_packets[i*2+1]>>ENS_ID_SHIFT)&ENS_ID_MASK;
 278:spinnaker_src/synapses.c **** 			for (uint32_t j = 0 ; j < n_ensembles; j++){
 279:spinnaker_src/synapses.c **** 				
 280:spinnaker_src/synapses.c **** 				if(ensembles[j].obj_id == error_ens_id){
 281:spinnaker_src/synapses.c **** 				
 282:spinnaker_src/synapses.c **** 					ensembles[j].error[error_value_id] = conv.f;
 283:spinnaker_src/synapses.c **** 					ensembles[j].error_not_none = 1;
 284:spinnaker_src/synapses.c **** 				}
 285:spinnaker_src/synapses.c **** 			}
 286:spinnaker_src/synapses.c **** 
 287:spinnaker_src/synapses.c **** 		}
 288:spinnaker_src/synapses.c **** 
 289:spinnaker_src/synapses.c **** 
 290:spinnaker_src/synapses.c **** 
 291:spinnaker_src/synapses.c **** 	}
 292:spinnaker_src/synapses.c **** 	*/
 293:spinnaker_src/synapses.c **** 
 294:spinnaker_src/synapses.c **** }
 295:spinnaker_src/synapses.c **** #endif
 296:spinnaker_src/synapses.c **** #ifdef SOURCE_CORE 
 297:spinnaker_src/synapses.c **** REAL ensemble_results[N_ENSEMBLE_CORES];
 298:spinnaker_src/synapses.c **** void read_input_packets(){
  48              		.loc 1 298 0
  49              		.cfi_startproc
  50              		@ args = 0, pretend = 0, frame = 0
  51              		@ frame_needed = 0, uses_anonymous_args = 0
  52              	.LVL1:
  53              	.LBB8:
 299:spinnaker_src/synapses.c **** 
 300:spinnaker_src/synapses.c **** 	uint32_t input_state_counter = 0; 
 301:spinnaker_src/synapses.c **** 	//uint32_t error_counter = 0; 
 302:spinnaker_src/synapses.c **** 	
 303:spinnaker_src/synapses.c **** 	/*
 304:spinnaker_src/synapses.c **** 	if(n_packets_received != PACKET_IN_WORDS*N_ENSEMBLE_CORES && systicks > 1){
 305:spinnaker_src/synapses.c **** 	
 306:spinnaker_src/synapses.c **** 		log_info("ERROR! time: %d, nr ensemble packets received: %d \n", systicks, n_packets_received);
 307:spinnaker_src/synapses.c **** 	}
 308:spinnaker_src/synapses.c **** 	*/
 309:spinnaker_src/synapses.c **** 	
 310:spinnaker_src/synapses.c **** 	//read packets from other cores
 311:spinnaker_src/synapses.c **** 	for(uint32_t i = 0; i < n_packets_received/PACKET_IN_WORDS ; i++){
  54              		.loc 1 311 0
  55 0000 174B     		ldr	r3, .L14
  56              	.LBE8:
 298:spinnaker_src/synapses.c **** 
  57              		.loc 1 298 0
  58 0002 F0B5     		push	{r4, r5, r6, r7, lr}
  59              		.cfi_def_cfa_offset 20
  60              		.cfi_offset 4, -20
  61              		.cfi_offset 5, -16
  62              		.cfi_offset 6, -12
  63              		.cfi_offset 7, -8
  64              		.cfi_offset 14, -4
  65              	.LBB13:
  66              		.loc 1 311 0
  67 0004 1E68     		ldr	r6, [r3]
  68 0006 7608     		lsrs	r6, r6, #1
  69 0008 26D0     		beq	.L13
  70 000a DFF86CE0 		ldr	lr, .L14+24
  71 000e 154D     		ldr	r5, .L14+4
  72 0010 DEF80020 		ldr	r2, [lr]
  73 0014 1448     		ldr	r0, .L14+8
  74              	.LBB9:
 312:spinnaker_src/synapses.c **** 
 313:spinnaker_src/synapses.c **** 		uint32_t read_pos1;
 314:spinnaker_src/synapses.c **** 		read_pos1 = read_pos +1;
 315:spinnaker_src/synapses.c **** 		if (read_pos1 > PACKET_BUFFER_LENGTH) {
 316:spinnaker_src/synapses.c **** 			read_pos1 = 0;
 317:spinnaker_src/synapses.c **** 		}
 318:spinnaker_src/synapses.c **** 
 319:spinnaker_src/synapses.c **** 		//TODO only expect 1 payload
 320:spinnaker_src/synapses.c **** 		if(((packet_buffer[read_pos1]>>31)&1)==0){
  75              		.loc 1 320 0
  76 0016 2F46     		mov	r7, r5
  77              	.LBE9:
 311:spinnaker_src/synapses.c **** 
  78              		.loc 1 311 0
  79 0018 0021     		movs	r1, #0
  80              	.LVL2:
  81              	.L8:
  82              	.LBB11:
 314:spinnaker_src/synapses.c **** 		if (read_pos1 > PACKET_BUFFER_LENGTH) {
  83              		.loc 1 314 0
  84 001a 531C     		adds	r3, r2, #1
  85              	.LVL3:
 316:spinnaker_src/synapses.c **** 		}
  86              		.loc 1 316 0
  87 001c FC2B     		cmp	r3, #252
  88 001e 28BF     		it	cs
  89 0020 0023     		movcs	r3, #0
  90              	.LVL4:
 321:spinnaker_src/synapses.c **** 			conv_i_f conv;
 322:spinnaker_src/synapses.c **** 			conv.i = packet_buffer[read_pos];
 323:spinnaker_src/synapses.c **** 			ensemble_results[i]=conv.f;
 324:spinnaker_src/synapses.c **** 			//log_info("%d\n",packet_buffer[read_pos]);
 325:spinnaker_src/synapses.c **** 		}
 326:spinnaker_src/synapses.c **** 		/*
 327:spinnaker_src/synapses.c **** 		else{
 328:spinnaker_src/synapses.c **** 		
 329:spinnaker_src/synapses.c **** 			uint32_t error_value_id;
 330:spinnaker_src/synapses.c **** 			uint32_t error_ens_id;
 331:spinnaker_src/synapses.c **** 			conv_i_f conv;
 332:spinnaker_src/synapses.c **** 			conv.i = packet_buffer[read_pos];
 333:spinnaker_src/synapses.c **** 			//TODO learning with ensemble. the error packet should specify its ens_id and value_id
 334:spinnaker_src/synapses.c **** 			error_value_id = (packet_buffer[read_pos1]>>VALUE_ID_SHIFT)&VALUE_ID_MASK;
 335:spinnaker_src/synapses.c **** 			error_ens_id =(packet_buffer[read_pos1]>>ENS_ID_SHIFT)&ENS_ID_MASK;
 336:spinnaker_src/synapses.c **** 			for (uint32_t j = 0 ; j < n_ensembles; j++){
 337:spinnaker_src/synapses.c **** 				
 338:spinnaker_src/synapses.c **** 				if(ensembles[j].obj_id == error_ens_id){
 339:spinnaker_src/synapses.c **** 				
 340:spinnaker_src/synapses.c **** 					ensembles[j].error[error_value_id] = conv.f;
 341:spinnaker_src/synapses.c **** 					ensembles[j].error_not_none = 1;
 342:spinnaker_src/synapses.c **** 					//log_info("%d\n",conv.i);
 343:spinnaker_src/synapses.c **** 				}
 344:spinnaker_src/synapses.c **** 			}
 345:spinnaker_src/synapses.c **** 
 346:spinnaker_src/synapses.c **** 		}
 347:spinnaker_src/synapses.c **** 		*/
 348:spinnaker_src/synapses.c **** 		
 349:spinnaker_src/synapses.c **** 		
 350:spinnaker_src/synapses.c **** 		read_pos+=2;
  91              		.loc 1 350 0
  92 0022 941C     		adds	r4, r2, #2
 320:spinnaker_src/synapses.c **** 			conv_i_f conv;
  93              		.loc 1 320 0
  94 0024 55F82330 		ldr	r3, [r5, r3, lsl #2]
  95              	.LVL5:
  96 0028 002B     		cmp	r3, #0
  97              	.LVL6:
  98              	.LBB10:
 322:spinnaker_src/synapses.c **** 			ensemble_results[i]=conv.f;
  99              		.loc 1 322 0
 100 002a A4BF     		itt	ge
 101 002c 57F82230 		ldrge	r3, [r7, r2, lsl #2]
 102              	.LVL7:
 323:spinnaker_src/synapses.c **** 			//log_info("%d\n",packet_buffer[read_pos]);
 103              		.loc 1 323 0
 104 0030 0360     		strge	r3, [r0]	@ float
 105              	.LBE10:
 106              	.LBE11:
 311:spinnaker_src/synapses.c **** 
 107              		.loc 1 311 0
 108 0032 0131     		adds	r1, r1, #1
 109              	.LVL8:
 110              	.LBB12:
 351:spinnaker_src/synapses.c **** 		if (read_pos > PACKET_BUFFER_LENGTH) {
 111              		.loc 1 351 0
 112 0034 FB2C     		cmp	r4, #251
 352:spinnaker_src/synapses.c **** 			read_pos = read_pos- PACKET_BUFFER_LENGTH - 1;
 113              		.loc 1 352 0
 114 0036 8CBF     		ite	hi
 115 0038 FA3A     		subhi	r2, r2, #250
 116              	.LVL9:
 117 003a 2246     		movls	r2, r4
 118              	.LBE12:
 311:spinnaker_src/synapses.c **** 
 119              		.loc 1 311 0
 120 003c B142     		cmp	r1, r6
 121 003e 00F10400 		add	r0, r0, #4
 122 0042 EAD1     		bne	.L8
 123 0044 CEF80020 		str	r2, [lr]
 124              	.LVL10:
 125              	.L4:
 126              	.LBE13:
 353:spinnaker_src/synapses.c **** 		}
 354:spinnaker_src/synapses.c **** 	}
 355:spinnaker_src/synapses.c **** 			
 356:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_READ] = (uint32_t) &(packet_buffer[read_pos]);
 127              		.loc 1 356 0
 128 0048 0848     		ldr	r0, .L14+12
 357:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 129              		.loc 1 357 0
 130 004a 094B     		ldr	r3, .L14+16
 131 004c 0949     		ldr	r1, .L14+20
 356:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 132              		.loc 1 356 0
 133 004e 05EB8202 		add	r2, r5, r2, lsl #2
 134 0052 0260     		str	r2, [r0]
 135              		.loc 1 357 0
 136 0054 1960     		str	r1, [r3]
 137 0056 F0BD     		pop	{r4, r5, r6, r7, pc}
 138              	.LVL11:
 139              	.L13:
 140 0058 074B     		ldr	r3, .L14+24
 141 005a 024D     		ldr	r5, .L14+4
 142 005c 1A68     		ldr	r2, [r3]
 143 005e F3E7     		b	.L4
 144              	.L15:
 145              		.align	2
 146              	.L14:
 147 0060 00000000 		.word	n_packets_received
 148 0064 00000000 		.word	packet_buffer
 149 0068 00000000 		.word	ensemble_results
 150 006c 0C0100E2 		.word	-503316212
 151 0070 000100E2 		.word	-503316224
 152 0074 41062000 		.word	2098753
 153 0078 00000000 		.word	read_pos
 154              		.cfi_endproc
 155              	.LFE188:
 157              		.section	.text.update_decoder,"ax",%progbits
 158              		.align	2
 159              		.global	update_decoder
 160              		.thumb
 161              		.thumb_func
 163              	update_decoder:
 164              	.LFB189:
 358:spinnaker_src/synapses.c **** 
 359:spinnaker_src/synapses.c **** 	/*
 360:spinnaker_src/synapses.c **** 	//read packets from external sources (pc, dvs, robot etc.)
 361:spinnaker_src/synapses.c **** 	//TODO currently only support 1 key + 1 payload
 362:spinnaker_src/synapses.c **** 	for(uint32_t i = 0; i < (n_external_packets_received-1)/2; i ++){
 363:spinnaker_src/synapses.c **** 	
 364:spinnaker_src/synapses.c **** 		
 365:spinnaker_src/synapses.c **** 
 366:spinnaker_src/synapses.c **** 		if(((external_packets[i*2+1]>>31)&1)==0){
 367:spinnaker_src/synapses.c **** 			//debug! topology specific
 368:spinnaker_src/synapses.c **** 			sort_input_value(&external_packets[i*2]);
 369:spinnaker_src/synapses.c **** 		}
 370:spinnaker_src/synapses.c **** 		else{
 371:spinnaker_src/synapses.c **** 		
 372:spinnaker_src/synapses.c **** 			uint32_t error_value_id;
 373:spinnaker_src/synapses.c **** 			uint32_t error_ens_id;
 374:spinnaker_src/synapses.c **** 			conv_i_f conv;
 375:spinnaker_src/synapses.c **** 			conv.i = external_packets[i*2];
 376:spinnaker_src/synapses.c **** 			//TODO learning with ensemble. the error packet should specify its ens_id and value_id
 377:spinnaker_src/synapses.c **** 			error_value_id = (external_packets[i*2+1]>>VALUE_ID_SHIFT)&VALUE_ID_MASK;
 378:spinnaker_src/synapses.c **** 			error_ens_id =(external_packets[i*2+1]>>ENS_ID_SHIFT)&ENS_ID_MASK;
 379:spinnaker_src/synapses.c **** 			for (uint32_t j = 0 ; j < n_ensembles; j++){
 380:spinnaker_src/synapses.c **** 				
 381:spinnaker_src/synapses.c **** 				if(ensembles[j].obj_id == error_ens_id){
 382:spinnaker_src/synapses.c **** 				
 383:spinnaker_src/synapses.c **** 					ensembles[j].error[error_value_id] = conv.f;
 384:spinnaker_src/synapses.c **** 					ensembles[j].error_not_none = 1;
 385:spinnaker_src/synapses.c **** 				}
 386:spinnaker_src/synapses.c **** 			}
 387:spinnaker_src/synapses.c **** 
 388:spinnaker_src/synapses.c **** 		}
 389:spinnaker_src/synapses.c **** 
 390:spinnaker_src/synapses.c **** 
 391:spinnaker_src/synapses.c **** 
 392:spinnaker_src/synapses.c **** 	}
 393:spinnaker_src/synapses.c **** 	*/
 394:spinnaker_src/synapses.c **** 
 395:spinnaker_src/synapses.c **** }
 396:spinnaker_src/synapses.c **** #endif
 397:spinnaker_src/synapses.c **** /*
 398:spinnaker_src/synapses.c **** extern uint32_t external_packets[N_EXTERNAL_PACKETS];
 399:spinnaker_src/synapses.c **** void read_input_packets(){
 400:spinnaker_src/synapses.c **** 
 401:spinnaker_src/synapses.c **** 	uint32_t input_state_counter = 0; 
 402:spinnaker_src/synapses.c **** 	uint32_t error_counter = 0; 
 403:spinnaker_src/synapses.c **** 	
 404:spinnaker_src/synapses.c **** 	clear_input_state();
 405:spinnaker_src/synapses.c **** 	
 406:spinnaker_src/synapses.c **** 	for (uint32_t i = 0 ; i < n_ensembles; i++){
 407:spinnaker_src/synapses.c **** 		ensembles[i].error_not_none = 0 ;
 408:spinnaker_src/synapses.c **** 	}
 409:spinnaker_src/synapses.c **** 	
 410:spinnaker_src/synapses.c **** 	//TODO read state from packet buffer and self spikes, apply matrix multiplication
 411:spinnaker_src/synapses.c **** 
 412:spinnaker_src/synapses.c **** 			conv_i_f conv;
 413:spinnaker_src/synapses.c **** 			conv.i = external_packets[0];
 414:spinnaker_src/synapses.c **** 			//debug! topology specific
 415:spinnaker_src/synapses.c **** 			ensemble
 416:spinnaker_src/synapses.c **** 			input_state_counter++;
 417:spinnaker_src/synapses.c **** 			
 418:spinnaker_src/synapses.c **** 			uint32_t error_value_id;
 419:spinnaker_src/synapses.c **** 			uint32_t error_ens_id;
 420:spinnaker_src/synapses.c **** 			conv_i_f conv;
 421:spinnaker_src/synapses.c **** 			conv.i = packet_buffer[read_pos];
 422:spinnaker_src/synapses.c **** 			//TODO learning with ensemble. the error packet should specify its ens_id and value_id
 423:spinnaker_src/synapses.c **** 			error_value_id = (packet_buffer[read_pos1]>>VALUE_ID_SHIFT)&VALUE_ID_MASK;
 424:spinnaker_src/synapses.c **** 			error_ens_id =(packet_buffer[read_pos1]>>ENS_ID_SHIFT)&ENS_ID_MASK;
 425:spinnaker_src/synapses.c **** 			for (uint32_t j = 0 ; j < n_ensembles; j++){
 426:spinnaker_src/synapses.c **** 				
 427:spinnaker_src/synapses.c **** 				if(ensembles[j].obj_id == error_ens_id){
 428:spinnaker_src/synapses.c **** 				
 429:spinnaker_src/synapses.c **** 					ensembles[j].error[error_value_id] = conv.f;
 430:spinnaker_src/synapses.c **** 					ensembles[j].error_not_none = 1;
 431:spinnaker_src/synapses.c **** 				}
 432:spinnaker_src/synapses.c **** 			}
 433:spinnaker_src/synapses.c **** 
 434:spinnaker_src/synapses.c **** 
 435:spinnaker_src/synapses.c **** 		
 436:spinnaker_src/synapses.c **** 		
 437:spinnaker_src/synapses.c **** 		read_pos+=2;
 438:spinnaker_src/synapses.c **** 		if (read_pos > PACKET_BUFFER_LENGTH) {
 439:spinnaker_src/synapses.c **** 			read_pos = read_pos- PACKET_BUFFER_LENGTH - 1;
 440:spinnaker_src/synapses.c **** 		}
 441:spinnaker_src/synapses.c **** 	}
 442:spinnaker_src/synapses.c **** 			
 443:spinnaker_src/synapses.c **** 	//TODO input_state is not used any more!
 444:spinnaker_src/synapses.c **** 	//log_info("%#010x\n",*(uint32_t*)&input_state[0]);
 445:spinnaker_src/synapses.c **** 
 446:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_READ] = (uint32_t) &(packet_buffer[read_pos]);
 447:spinnaker_src/synapses.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 448:spinnaker_src/synapses.c **** 
 449:spinnaker_src/synapses.c **** }
 450:spinnaker_src/synapses.c **** */
 451:spinnaker_src/synapses.c **** 
 452:spinnaker_src/synapses.c **** #ifdef ENS_CORE
 453:spinnaker_src/synapses.c **** void calc_input_current(ensemble_t ens){
 454:spinnaker_src/synapses.c **** 
 455:spinnaker_src/synapses.c **** 	//TODO ML acc
 456:spinnaker_src/synapses.c **** 	encode_dot_product(ens.encoders, ens.inputs, ens.input_currents, ens.n_neurons, ens.n_inputs);
 457:spinnaker_src/synapses.c **** 	encode_vec_add(ens.input_currents,ens.bias, ens.n_neurons);
 458:spinnaker_src/synapses.c **** 
 459:spinnaker_src/synapses.c **** 	/*
 460:spinnaker_src/synapses.c **** 	conv_i_f conv;
 461:spinnaker_src/synapses.c **** 	conv.f=ens.input_currents[0];
 462:spinnaker_src/synapses.c **** 	log_info("%d\n", conv.i);
 463:spinnaker_src/synapses.c **** 	*/
 464:spinnaker_src/synapses.c **** 	
 465:spinnaker_src/synapses.c **** 	/*
 466:spinnaker_src/synapses.c **** 	if(ens.obj_id == 0 && systicks == 2){
 467:spinnaker_src/synapses.c **** 	
 468:spinnaker_src/synapses.c **** 		for (uint32_t i = 90 ; i < 100; i++){
 469:spinnaker_src/synapses.c **** 		
 470:spinnaker_src/synapses.c **** 			log_info("%#010x\n",*(uint32_t*)&ens.input_currents[i]);
 471:spinnaker_src/synapses.c **** 		}
 472:spinnaker_src/synapses.c **** 	}
 473:spinnaker_src/synapses.c **** 	*/
 474:spinnaker_src/synapses.c **** 	
 475:spinnaker_src/synapses.c **** 	
 476:spinnaker_src/synapses.c **** 	
 477:spinnaker_src/synapses.c **** }
 478:spinnaker_src/synapses.c **** void tranformation_and_low_pass(message_t mess){
 479:spinnaker_src/synapses.c **** 
 480:spinnaker_src/synapses.c **** 	//TODO ML acc
 481:spinnaker_src/synapses.c **** 	if(mess.matrix_is_scalar==0){
 482:spinnaker_src/synapses.c **** 		encode_dot_product(mess.matrix, mess.pre_values, mess.post_values, mess.post_len, mess.pre_len);
 483:spinnaker_src/synapses.c **** 	}
 484:spinnaker_src/synapses.c **** 	else{
 485:spinnaker_src/synapses.c **** 	
 486:spinnaker_src/synapses.c **** 		//TODO
 487:spinnaker_src/synapses.c **** 		encode_vec_scalar_mul(mess.pre_values, mess.matrix, mess.post_values, mess.post_len);
 488:spinnaker_src/synapses.c **** 	}
 489:spinnaker_src/synapses.c **** 	
 490:spinnaker_src/synapses.c **** 	if(mess.use_synapse_scale == 1){
 491:spinnaker_src/synapses.c **** 	
 492:spinnaker_src/synapses.c **** 		encode_vec_scalar_mul(mess.post_values, &mess.synapse_scale, mess.post_values, mess.post_len );
 493:spinnaker_src/synapses.c **** 		precision_t temp_syn_scale;
 494:spinnaker_src/synapses.c **** 		temp_syn_scale =(precision_t) (1-(REAL) mess.synapse_scale);
 495:spinnaker_src/synapses.c **** 		encode_vec_scalar_mul(mess.synapse_scale_value, &temp_syn_scale, mess.synapse_scale_value, mess.p
 496:spinnaker_src/synapses.c **** 		encode_vec_add(mess.synapse_scale_value,mess.post_values, mess.post_len);
 497:spinnaker_src/synapses.c **** 		encode_vec_copy(mess.synapse_scale_value, mess.post_values, mess.post_len);
 498:spinnaker_src/synapses.c **** 		
 499:spinnaker_src/synapses.c **** 	}
 500:spinnaker_src/synapses.c **** 
 501:spinnaker_src/synapses.c **** 	encode_vec_add(mess.ens_input,mess.post_values, mess.post_len);
 502:spinnaker_src/synapses.c **** 	
 503:spinnaker_src/synapses.c **** 	/*
 504:spinnaker_src/synapses.c **** 	conv_i_f conv;
 505:spinnaker_src/synapses.c **** 	conv.f=mess.ens_input[0];
 506:spinnaker_src/synapses.c **** 	log_info("%d\n", conv.i);
 507:spinnaker_src/synapses.c **** 	conv.f=mess.pre_values[0];
 508:spinnaker_src/synapses.c **** 	log_info("%d\n", conv.i);
 509:spinnaker_src/synapses.c **** 	*/
 510:spinnaker_src/synapses.c **** 
 511:spinnaker_src/synapses.c **** }
 512:spinnaker_src/synapses.c **** #endif
 513:spinnaker_src/synapses.c **** void update_decoder(ensemble_t ens){
 165              		.loc 1 513 0
 166              		.cfi_startproc
 167              		@ args = 80, pretend = 16, frame = 0
 168              		@ frame_needed = 0, uses_anonymous_args = 0
 169 0000 84B0     		sub	sp, sp, #16
 170              		.cfi_def_cfa_offset 16
 171 0002 2DE9F041 		push	{r4, r5, r6, r7, r8, lr}
 172              		.cfi_def_cfa_offset 40
 173              		.cfi_offset 4, -40
 174              		.cfi_offset 5, -36
 175              		.cfi_offset 6, -32
 176              		.cfi_offset 7, -28
 177              		.cfi_offset 8, -24
 178              		.cfi_offset 14, -20
 179 0006 DDF828E0 		ldr	lr, [sp, #40]
 180              	.LVL12:
 181 000a 0B9D     		ldr	r5, [sp, #44]
 182              	.LVL13:
 183 000c 189E     		ldr	r6, [sp, #96]
 514:spinnaker_src/synapses.c **** 
 515:spinnaker_src/synapses.c **** 	//debug! system
 516:spinnaker_src/synapses.c **** //	if(ens.error_not_none){
 517:spinnaker_src/synapses.c **** 		//TODO ml acc
 518:spinnaker_src/synapses.c **** 		//TODO learning with ensembles
 519:spinnaker_src/synapses.c **** 		
 520:spinnaker_src/synapses.c **** 		learning_outer_product(ens.error, ens.learning_activity, ens.delta, ens.n_neurons, ens.n_outputs)
 184              		.loc 1 520 0
 185 000e DDF85CC0 		ldr	ip, [sp, #92]
 186 0012 159C     		ldr	r4, [sp, #84]
 187              	.LVL14:
 513:spinnaker_src/synapses.c **** 
 188              		.loc 1 513 0
 189 0014 06AF     		add	r7, sp, #24
 190 0016 87E80F00 		stmia	r7, {r0, r1, r2, r3}
 191              	.LBB14:
 192              	.LBB15:
 193              	.LBB16:
 194              		.file 2 "spinnaker_src/synapses.h"
   1:spinnaker_src/synapses.h **** #ifndef _SYNAPSES_H_
   2:spinnaker_src/synapses.h **** #define _SYNAPSES_H_
   3:spinnaker_src/synapses.h **** 
   4:spinnaker_src/synapses.h **** //#include "spinn_log.h"
   5:spinnaker_src/synapses.h **** #include "common/neuron-typedefs.h"
   6:spinnaker_src/synapses.h **** #include "synapse_row.h"
   7:spinnaker_src/synapses.h **** #include "param_defs.h"
   8:spinnaker_src/synapses.h **** #include "synapse_types/synapse_types_exponential_impl.h"
   9:spinnaker_src/synapses.h **** 
  10:spinnaker_src/synapses.h **** 
  11:spinnaker_src/synapses.h **** #define INPUT_BUFFER_SIZE (1 << (SYNAPSE_TYPE_BITS + SYNAPSE_INDEX_BITS))
  12:spinnaker_src/synapses.h **** #define RING_BUFFER_SIZE (1 << (SYNAPSE_DELAY_BITS + SYNAPSE_TYPE_BITS\
  13:spinnaker_src/synapses.h ****                                 + SYNAPSE_INDEX_BITS))
  14:spinnaker_src/synapses.h **** static inline index_t synapses_get_ring_buffer_index(
  15:spinnaker_src/synapses.h ****         uint32_t simuation_timestep, uint32_t synapse_type_index,
  16:spinnaker_src/synapses.h ****         uint32_t neuron_index) {
  17:spinnaker_src/synapses.h ****     return (((simuation_timestep & SYNAPSE_DELAY_MASK)
  18:spinnaker_src/synapses.h ****              << SYNAPSE_TYPE_INDEX_BITS)
  19:spinnaker_src/synapses.h ****             | (synapse_type_index << SYNAPSE_INDEX_BITS)
  20:spinnaker_src/synapses.h ****             | neuron_index);
  21:spinnaker_src/synapses.h **** }
  22:spinnaker_src/synapses.h **** 
  23:spinnaker_src/synapses.h **** static inline index_t synapses_get_ring_buffer_index_combined(
  24:spinnaker_src/synapses.h ****         uint32_t simulation_timestep, uint32_t combined_synapse_neuron_index) {
  25:spinnaker_src/synapses.h ****     return (((simulation_timestep & SYNAPSE_DELAY_MASK)
  26:spinnaker_src/synapses.h ****              << SYNAPSE_TYPE_INDEX_BITS)
  27:spinnaker_src/synapses.h ****             | combined_synapse_neuron_index);
  28:spinnaker_src/synapses.h **** }
  29:spinnaker_src/synapses.h **** 
  30:spinnaker_src/synapses.h **** static inline input_t synapses_convert_weight_to_input(weight_t weight,
  31:spinnaker_src/synapses.h ****                                                        uint32_t left_shift) {
  32:spinnaker_src/synapses.h ****     return ((REAL)weight)/((uint32_t)1<<left_shift);
  33:spinnaker_src/synapses.h **** }
  34:spinnaker_src/synapses.h **** bool synapses_initialise();
  35:spinnaker_src/synapses.h **** 
  36:spinnaker_src/synapses.h **** void synapses_reset();
  37:spinnaker_src/synapses.h **** 
  38:spinnaker_src/synapses.h **** void calc_neuron_input();
  39:spinnaker_src/synapses.h **** void synapses_process_spikes(void);
  40:spinnaker_src/synapses.h **** void synapses_do_timestep_update(uint32_t time);
  41:spinnaker_src/synapses.h **** void tranformation_and_low_pass(message_t mess);
  42:spinnaker_src/synapses.h **** void update_decoder(ensemble_t ens);
  43:spinnaker_src/synapses.h **** 
  44:spinnaker_src/synapses.h **** bool synapses_process_synaptic_row(uint32_t time, synaptic_row_t row,
  45:spinnaker_src/synapses.h ****                                    bool write, uint32_t process_id);
  46:spinnaker_src/synapses.h **** 
  47:spinnaker_src/synapses.h **** //void encode_dot_product(REAL * pIn1, REAL * pIn2, REAL * pOut	);
  48:spinnaker_src/synapses.h **** //void learning_outer_product(REAL * pInA, REAL *pInB, REAL *pOut);
  49:spinnaker_src/synapses.h **** //void learning_update_decoders(REAL * pInA,REAL *pInB);
  50:spinnaker_src/synapses.h **** 
  51:spinnaker_src/synapses.h **** inline void encode_vec_add(precision_t * pInA, precision_t * pInB, uint32_t length){
  52:spinnaker_src/synapses.h **** 
  53:spinnaker_src/synapses.h **** 	uint32_t blkCnt;
  54:spinnaker_src/synapses.h **** 	REAL inA1, inA2, inA3, inA4;
  55:spinnaker_src/synapses.h **** 	REAL inB1, inB2, inB3, inB4;
  56:spinnaker_src/synapses.h **** 
  57:spinnaker_src/synapses.h **** 	blkCnt = length>>2u;
  58:spinnaker_src/synapses.h **** 
  59:spinnaker_src/synapses.h **** 	while(blkCnt>0u){
  60:spinnaker_src/synapses.h **** 	
  61:spinnaker_src/synapses.h **** 		inA1 = (REAL)(*pInA);
  62:spinnaker_src/synapses.h **** 		inB1 = (REAL)(*pInB);
  63:spinnaker_src/synapses.h **** 		inA2 = (REAL)(*(pInA+1));
  64:spinnaker_src/synapses.h **** 		inB2 = (REAL)(*(pInB+1));
  65:spinnaker_src/synapses.h **** 		inA3 = (REAL)(*(pInA+2));
  66:spinnaker_src/synapses.h **** 		inB3 = (REAL)(*(pInB+2));
  67:spinnaker_src/synapses.h **** 		inA4 = (REAL)(*(pInA+3));
  68:spinnaker_src/synapses.h **** 		inB4 = (REAL)(*(pInB+3));
  69:spinnaker_src/synapses.h **** 
  70:spinnaker_src/synapses.h **** 		*pInA 	  =(precision_t) (inA1 + inB1);
  71:spinnaker_src/synapses.h **** 		*(pInA+1) =(precision_t) (inA2 + inB2);
  72:spinnaker_src/synapses.h **** 		*(pInA+2) =(precision_t) (inA3 + inB3);
  73:spinnaker_src/synapses.h **** 		*(pInA+3) =(precision_t) (inA4 + inB4);
  74:spinnaker_src/synapses.h **** 
  75:spinnaker_src/synapses.h **** 		pInA += 4u;
  76:spinnaker_src/synapses.h **** 		pInB += 4u;
  77:spinnaker_src/synapses.h **** 
  78:spinnaker_src/synapses.h **** 		blkCnt--;
  79:spinnaker_src/synapses.h **** 	}
  80:spinnaker_src/synapses.h **** 
  81:spinnaker_src/synapses.h **** 	blkCnt = length%0x4u;
  82:spinnaker_src/synapses.h **** 
  83:spinnaker_src/synapses.h **** 	
  84:spinnaker_src/synapses.h **** 	while (blkCnt>0u){
  85:spinnaker_src/synapses.h **** 	
  86:spinnaker_src/synapses.h **** 		inA1 = (REAL)(*pInA);
  87:spinnaker_src/synapses.h **** 		inB1 = (REAL)(*pInB);
  88:spinnaker_src/synapses.h **** 		(*pInA) = (precision_t)(inA1 + inB1);
  89:spinnaker_src/synapses.h **** 		pInA++;
  90:spinnaker_src/synapses.h **** 		pInB++;
  91:spinnaker_src/synapses.h **** 		blkCnt --;
  92:spinnaker_src/synapses.h **** 	}
  93:spinnaker_src/synapses.h **** 
  94:spinnaker_src/synapses.h **** }
  95:spinnaker_src/synapses.h **** /*
  96:spinnaker_src/synapses.h **** inline void encode_vec_add_h_h(REAL * pInA, REAL * pInB, uint32_t length){
  97:spinnaker_src/synapses.h **** 
  98:spinnaker_src/synapses.h **** 	uint32_t blkCnt;
  99:spinnaker_src/synapses.h **** 	REAL inA1, inA2, inA3, inA4;
 100:spinnaker_src/synapses.h **** 	REAL inB1, inB2, inB3, inB4;
 101:spinnaker_src/synapses.h **** 
 102:spinnaker_src/synapses.h **** 	blkCnt = length>>2u;
 103:spinnaker_src/synapses.h **** 
 104:spinnaker_src/synapses.h **** 	while(blkCnt>0u){
 105:spinnaker_src/synapses.h **** 	
 106:spinnaker_src/synapses.h **** 		inA1 = *pInA;
 107:spinnaker_src/synapses.h **** 		inB1 = *pInB;
 108:spinnaker_src/synapses.h **** 		inA2 = *(pInA+1);
 109:spinnaker_src/synapses.h **** 		inB2 = *(pInB+1);
 110:spinnaker_src/synapses.h **** 		inA3 = *(pInA+2);
 111:spinnaker_src/synapses.h **** 		inB3 = *(pInB+2);
 112:spinnaker_src/synapses.h **** 		inA4 = *(pInA+3);
 113:spinnaker_src/synapses.h **** 		inB4 = *(pInB+3);
 114:spinnaker_src/synapses.h **** 
 115:spinnaker_src/synapses.h **** 		*pInA = inA1 + inB1;
 116:spinnaker_src/synapses.h **** 		*(pInA+1) = inA2 + inB2;
 117:spinnaker_src/synapses.h **** 		*(pInA+2) = inA3 + inB3;
 118:spinnaker_src/synapses.h **** 		*(pInA+3) = inA4 + inB4;
 119:spinnaker_src/synapses.h **** 
 120:spinnaker_src/synapses.h **** 		pInA += 4u;
 121:spinnaker_src/synapses.h **** 		pInB += 4u;
 122:spinnaker_src/synapses.h **** 
 123:spinnaker_src/synapses.h **** 		blkCnt--;
 124:spinnaker_src/synapses.h **** 	}
 125:spinnaker_src/synapses.h **** 
 126:spinnaker_src/synapses.h **** 	blkCnt = length%0x4u;
 127:spinnaker_src/synapses.h **** 
 128:spinnaker_src/synapses.h **** 	
 129:spinnaker_src/synapses.h **** 	while (blkCnt>0u){
 130:spinnaker_src/synapses.h **** 	
 131:spinnaker_src/synapses.h **** 		inA1 = *pInA;
 132:spinnaker_src/synapses.h **** 		inB1 = *pInB;
 133:spinnaker_src/synapses.h **** 		(*pInA) = inA1 + inB1;
 134:spinnaker_src/synapses.h **** 		pInA++;
 135:spinnaker_src/synapses.h **** 		pInB++;
 136:spinnaker_src/synapses.h **** 		blkCnt --;
 137:spinnaker_src/synapses.h **** 	}
 138:spinnaker_src/synapses.h **** 
 139:spinnaker_src/synapses.h **** }
 140:spinnaker_src/synapses.h **** inline void encode_vec_add_h_l(REAL * pInA, precision_t * pInB, uint32_t length){
 141:spinnaker_src/synapses.h **** 
 142:spinnaker_src/synapses.h **** 	uint32_t blkCnt;
 143:spinnaker_src/synapses.h **** 	REAL inA1, inA2, inA3, inA4;
 144:spinnaker_src/synapses.h **** 	REAL inB1, inB2, inB3, inB4;
 145:spinnaker_src/synapses.h **** 
 146:spinnaker_src/synapses.h **** 	blkCnt = length>>2u;
 147:spinnaker_src/synapses.h **** 
 148:spinnaker_src/synapses.h **** 	while(blkCnt>0u){
 149:spinnaker_src/synapses.h **** 	
 150:spinnaker_src/synapses.h **** 		inA1 = *pInA;
 151:spinnaker_src/synapses.h **** 		inB1 = *pInB;
 152:spinnaker_src/synapses.h **** 		inA2 = *(pInA+1);
 153:spinnaker_src/synapses.h **** 		inB2 = *(pInB+1);
 154:spinnaker_src/synapses.h **** 		inA3 = *(pInA+2);
 155:spinnaker_src/synapses.h **** 		inB3 = *(pInB+2);
 156:spinnaker_src/synapses.h **** 		inA4 = *(pInA+3);
 157:spinnaker_src/synapses.h **** 		inB4 = *(pInB+3);
 158:spinnaker_src/synapses.h **** 
 159:spinnaker_src/synapses.h **** 		*pInA = inA1 + inB1;
 160:spinnaker_src/synapses.h **** 		*(pInA+1) = inA2 + inB2;
 161:spinnaker_src/synapses.h **** 		*(pInA+2) = inA3 + inB3;
 162:spinnaker_src/synapses.h **** 		*(pInA+3) = inA4 + inB4;
 163:spinnaker_src/synapses.h **** 
 164:spinnaker_src/synapses.h **** 		pInA += 4u;
 165:spinnaker_src/synapses.h **** 		pInB += 4u;
 166:spinnaker_src/synapses.h **** 
 167:spinnaker_src/synapses.h **** 		blkCnt--;
 168:spinnaker_src/synapses.h **** 	}
 169:spinnaker_src/synapses.h **** 
 170:spinnaker_src/synapses.h **** 	blkCnt = length%0x4u;
 171:spinnaker_src/synapses.h **** 
 172:spinnaker_src/synapses.h **** 	
 173:spinnaker_src/synapses.h **** 	while (blkCnt>0u){
 174:spinnaker_src/synapses.h **** 	
 175:spinnaker_src/synapses.h **** 		inA1 = *pInA;
 176:spinnaker_src/synapses.h **** 		inB1 = *pInB;
 177:spinnaker_src/synapses.h **** 		(*pInA) = inA1 + inB1;
 178:spinnaker_src/synapses.h **** 		pInA++;
 179:spinnaker_src/synapses.h **** 		pInB++;
 180:spinnaker_src/synapses.h **** 		blkCnt --;
 181:spinnaker_src/synapses.h **** 	}
 182:spinnaker_src/synapses.h **** 
 183:spinnaker_src/synapses.h **** }
 184:spinnaker_src/synapses.h **** */
 185:spinnaker_src/synapses.h **** inline void encode_vec_copy(precision_t * pInA, precision_t * pInB, uint32_t length){
 186:spinnaker_src/synapses.h **** 	for (uint32_t i = 0; i < length; i++){
 187:spinnaker_src/synapses.h **** 		*pInB ++= *pInA++; 
 188:spinnaker_src/synapses.h **** 	}
 189:spinnaker_src/synapses.h **** }
 190:spinnaker_src/synapses.h **** inline void encode_vec_scalar_mul(precision_t * pInA, precision_t * pInB, precision_t * pOut, uint3
 191:spinnaker_src/synapses.h **** 
 192:spinnaker_src/synapses.h **** 	uint32_t blkCnt;
 193:spinnaker_src/synapses.h **** 	REAL inA1, inA2, inA3, inA4;
 194:spinnaker_src/synapses.h **** 	REAL inB1;
 195:spinnaker_src/synapses.h **** 	inB1 = (REAL)(*pInB);
 196:spinnaker_src/synapses.h **** 
 197:spinnaker_src/synapses.h **** 	blkCnt = length>>2u;
 198:spinnaker_src/synapses.h **** 
 199:spinnaker_src/synapses.h **** 	while(blkCnt>0u){
 200:spinnaker_src/synapses.h **** 	
 201:spinnaker_src/synapses.h **** 		inA1 = (REAL)(*pInA);
 202:spinnaker_src/synapses.h **** 		inA2 = (REAL)(*(pInA+1));
 203:spinnaker_src/synapses.h **** 		inA3 = (REAL)(*(pInA+2));
 204:spinnaker_src/synapses.h **** 		inA4 = (REAL)(*(pInA+3));
 205:spinnaker_src/synapses.h **** 
 206:spinnaker_src/synapses.h **** 		*pOut     = (precision_t)(inA1 * inB1);
 207:spinnaker_src/synapses.h **** 		*(pOut+1) = (precision_t)(inA2 * inB1);
 208:spinnaker_src/synapses.h **** 		*(pOut+2) = (precision_t)(inA3 * inB1);
 209:spinnaker_src/synapses.h **** 		*(pOut+3) = (precision_t)(inA4 * inB1);
 210:spinnaker_src/synapses.h **** 
 211:spinnaker_src/synapses.h **** 		pInA += 4u;
 212:spinnaker_src/synapses.h **** 		pOut += 4u;
 213:spinnaker_src/synapses.h **** 
 214:spinnaker_src/synapses.h **** 		blkCnt--;
 215:spinnaker_src/synapses.h **** 	}
 216:spinnaker_src/synapses.h **** 
 217:spinnaker_src/synapses.h **** 	blkCnt = length%0x4u;
 218:spinnaker_src/synapses.h **** 
 219:spinnaker_src/synapses.h **** 	
 220:spinnaker_src/synapses.h **** 	while (blkCnt>0u){
 221:spinnaker_src/synapses.h **** 	
 222:spinnaker_src/synapses.h **** 		inA1 = (REAL)(*pInA);
 223:spinnaker_src/synapses.h **** 		(*pOut++) = (precision_t)(inA1 * inB1);
 224:spinnaker_src/synapses.h **** 		pInA++;
 225:spinnaker_src/synapses.h **** 		blkCnt --;
 226:spinnaker_src/synapses.h **** 	}
 227:spinnaker_src/synapses.h **** 
 228:spinnaker_src/synapses.h **** }
 229:spinnaker_src/synapses.h **** inline void encode_dot_product(precision_t * pIn1, precision_t * pIn2, precision_t * pOut, uint32_t
 230:spinnaker_src/synapses.h **** 
 231:spinnaker_src/synapses.h **** 
 232:spinnaker_src/synapses.h **** 	if(n_inputs == 1){
 233:spinnaker_src/synapses.h **** 	
 234:spinnaker_src/synapses.h **** 		uint32_t blkCnt;
 235:spinnaker_src/synapses.h **** 		REAL inA1, inA2, inA3, inA4;
 236:spinnaker_src/synapses.h **** 		REAL inB1 ;
 237:spinnaker_src/synapses.h **** 
 238:spinnaker_src/synapses.h **** 		blkCnt = n_neurons>>2u;
 239:spinnaker_src/synapses.h **** 
 240:spinnaker_src/synapses.h **** 		inB1 = (REAL)(*pIn2);
 241:spinnaker_src/synapses.h **** 		while(blkCnt>0u){
 242:spinnaker_src/synapses.h **** 		
 243:spinnaker_src/synapses.h **** 			inA1 = (REAL)(*pIn1);
 244:spinnaker_src/synapses.h **** 			inA2 = (REAL)(*(pIn1+1));
 245:spinnaker_src/synapses.h **** 			inA3 = (REAL)(*(pIn1+2));
 246:spinnaker_src/synapses.h **** 			inA4 = (REAL)(*(pIn1+3));
 247:spinnaker_src/synapses.h **** 
 248:spinnaker_src/synapses.h **** 			*pOut = (precision_t)(inA1 * inB1);
 249:spinnaker_src/synapses.h **** 			*(pOut+1) = (precision_t)(inA2 * inB1);
 250:spinnaker_src/synapses.h **** 			*(pOut+2) = (precision_t)(inA3 * inB1);
 251:spinnaker_src/synapses.h **** 			*(pOut+3) = (precision_t)(inA4 * inB1);
 252:spinnaker_src/synapses.h **** 
 253:spinnaker_src/synapses.h **** 			pIn1 += 4u;
 254:spinnaker_src/synapses.h **** 			pOut += 4u;
 255:spinnaker_src/synapses.h **** 			blkCnt--;
 256:spinnaker_src/synapses.h **** 		}
 257:spinnaker_src/synapses.h **** 
 258:spinnaker_src/synapses.h **** 		blkCnt = n_neurons%0x4u;
 259:spinnaker_src/synapses.h **** 
 260:spinnaker_src/synapses.h **** 		
 261:spinnaker_src/synapses.h **** 		while (blkCnt>0u){
 262:spinnaker_src/synapses.h **** 		
 263:spinnaker_src/synapses.h **** 			inA1 = (REAL)(*pIn1);
 264:spinnaker_src/synapses.h **** 			(*pOut) = (precision_t)(inA1 * inB1);
 265:spinnaker_src/synapses.h **** 			pIn1++;
 266:spinnaker_src/synapses.h **** 			pOut++;
 267:spinnaker_src/synapses.h **** 			blkCnt --;
 268:spinnaker_src/synapses.h **** 		}
 269:spinnaker_src/synapses.h **** 
 270:spinnaker_src/synapses.h **** 	}
 271:spinnaker_src/synapses.h **** 	else if (n_inputs == 2){
 272:spinnaker_src/synapses.h **** 	
 273:spinnaker_src/synapses.h **** 		uint32_t blkCnt;
 274:spinnaker_src/synapses.h **** 		REAL inA1, inA2, inA3, inA4, inA5, inA6, inA7, inA8;
 275:spinnaker_src/synapses.h **** 		REAL inB1, inB2 ;
 276:spinnaker_src/synapses.h **** 
 277:spinnaker_src/synapses.h **** 		blkCnt = n_neurons>>2u;
 278:spinnaker_src/synapses.h **** 
 279:spinnaker_src/synapses.h **** 		inB1 = (REAL)(*pIn2);
 280:spinnaker_src/synapses.h **** 		inB2 = (REAL)(*(pIn2+1));
 281:spinnaker_src/synapses.h **** 		while(blkCnt>0u){
 282:spinnaker_src/synapses.h **** 		
 283:spinnaker_src/synapses.h **** 			inA1 = (REAL)(*pIn1);
 284:spinnaker_src/synapses.h **** 			inA2 = (REAL)(*(pIn1+1));
 285:spinnaker_src/synapses.h **** 			inA3 = (REAL)(*(pIn1+2));
 286:spinnaker_src/synapses.h **** 			inA4 = (REAL)(*(pIn1+3));
 287:spinnaker_src/synapses.h **** 			inA5 = (REAL)(*(pIn1+4));
 288:spinnaker_src/synapses.h **** 			inA6 = (REAL)(*(pIn1+5));
 289:spinnaker_src/synapses.h **** 			inA7 = (REAL)(*(pIn1+6));
 290:spinnaker_src/synapses.h **** 			inA8 = (REAL)(*(pIn1+7));
 291:spinnaker_src/synapses.h **** 
 292:spinnaker_src/synapses.h **** 			*pOut = (precision_t)(inA1 * inB1 + inA2 * inB2);
 293:spinnaker_src/synapses.h **** 			*(pOut+1) = (precision_t)(inA3 * inB1 + inA4 * inB2);
 294:spinnaker_src/synapses.h **** 			*(pOut+2) = (precision_t)(inA5 * inB1 + inA6 * inB2);
 295:spinnaker_src/synapses.h **** 			*(pOut+3) = (precision_t)(inA7 * inB1 + inA8 * inB2);
 296:spinnaker_src/synapses.h **** 
 297:spinnaker_src/synapses.h **** 			pIn1 += 8u;
 298:spinnaker_src/synapses.h **** 			pOut += 4u;
 299:spinnaker_src/synapses.h **** 			blkCnt--;
 300:spinnaker_src/synapses.h **** 		}
 301:spinnaker_src/synapses.h **** 
 302:spinnaker_src/synapses.h **** 		blkCnt = n_neurons%0x4u;
 303:spinnaker_src/synapses.h **** 		
 304:spinnaker_src/synapses.h **** 		while (blkCnt>0u){
 305:spinnaker_src/synapses.h **** 		
 306:spinnaker_src/synapses.h **** 			inA1 = (REAL)(*pIn1);
 307:spinnaker_src/synapses.h **** 			inA2 = (REAL)(*(pIn1+1));
 308:spinnaker_src/synapses.h **** 			(*pOut) = (precision_t)(inA1 * inB1 + inA2 * inB2);
 309:spinnaker_src/synapses.h **** 			pIn1+=2;
 310:spinnaker_src/synapses.h **** 			pOut++;
 311:spinnaker_src/synapses.h **** 			blkCnt --;
 312:spinnaker_src/synapses.h **** 		}
 313:spinnaker_src/synapses.h **** 
 314:spinnaker_src/synapses.h **** 	}
 315:spinnaker_src/synapses.h **** 	else if (n_inputs == 3){
 316:spinnaker_src/synapses.h **** 		REAL inA1, inA2, inA3;
 317:spinnaker_src/synapses.h **** 		REAL inB1, inB2, inB3;
 318:spinnaker_src/synapses.h **** 		inB1 = (REAL)(*pIn2);
 319:spinnaker_src/synapses.h **** 		inB2 = (REAL)(*(pIn2+1));
 320:spinnaker_src/synapses.h **** 		inB3 = (REAL)(*(pIn2+2));
 321:spinnaker_src/synapses.h **** 		for(uint32_t i = 0; i < n_neurons; i++){
 322:spinnaker_src/synapses.h **** 		
 323:spinnaker_src/synapses.h **** 			inA1 = (REAL)(*pIn1);
 324:spinnaker_src/synapses.h **** 			inA2 = (REAL)(*(pIn1+1));
 325:spinnaker_src/synapses.h **** 			inA3 = (REAL)(*(pIn1+2));
 326:spinnaker_src/synapses.h **** 
 327:spinnaker_src/synapses.h **** 			*pOut = (precision_t)(inA1 * inB1 + inA2 * inB2 + inA3 * inB3);
 328:spinnaker_src/synapses.h **** 			pIn1+=3;
 329:spinnaker_src/synapses.h **** 			pOut++;
 330:spinnaker_src/synapses.h **** 		}
 331:spinnaker_src/synapses.h **** 	}
 332:spinnaker_src/synapses.h **** 	
 333:spinnaker_src/synapses.h **** 	else {
 334:spinnaker_src/synapses.h **** 		REAL inA1, inA2, inA3, inA4;
 335:spinnaker_src/synapses.h **** 		REAL inB1, inB2, inB3, inB4;
 336:spinnaker_src/synapses.h **** 		precision_t* pIn1_;
 337:spinnaker_src/synapses.h **** 		pIn1_ = pIn1;
 338:spinnaker_src/synapses.h **** 		for(uint32_t i = 0; i < n_neurons; i++){
 339:spinnaker_src/synapses.h **** 		
 340:spinnaker_src/synapses.h **** 			REAL sum;
 341:spinnaker_src/synapses.h **** 			precision_t* pIn2_;
 342:spinnaker_src/synapses.h **** 			uint32_t blkCnt;
 343:spinnaker_src/synapses.h **** 			blkCnt = n_inputs>>2u;
 344:spinnaker_src/synapses.h **** 			pIn2_ = pIn2;
 345:spinnaker_src/synapses.h **** 
 346:spinnaker_src/synapses.h **** 			sum = 0;
 347:spinnaker_src/synapses.h **** 
 348:spinnaker_src/synapses.h **** 			while(blkCnt>0u){
 349:spinnaker_src/synapses.h **** 			
 350:spinnaker_src/synapses.h **** 				inA1 = (REAL)(*pIn1_);
 351:spinnaker_src/synapses.h **** 				inA2 = (REAL)(*(pIn1_+1));
 352:spinnaker_src/synapses.h **** 				inA3 = (REAL)(*(pIn1_+2));
 353:spinnaker_src/synapses.h **** 				inA4 = (REAL)(*(pIn1_+3));
 354:spinnaker_src/synapses.h **** 				inB1 = (REAL)(*pIn2_);
 355:spinnaker_src/synapses.h **** 				inB2 = (REAL)(*(pIn2_+1));
 356:spinnaker_src/synapses.h **** 				inB3 = (REAL)(*(pIn2_+2));
 357:spinnaker_src/synapses.h **** 				inB4 = (REAL)(*(pIn2_+3));
 358:spinnaker_src/synapses.h **** 
 359:spinnaker_src/synapses.h **** 				sum += (inA1 * inB1 + inA2 * inB2 + inA3 * inB3 + inA4 * inB4);
 360:spinnaker_src/synapses.h **** 
 361:spinnaker_src/synapses.h **** 				pIn1_ += 4u;
 362:spinnaker_src/synapses.h **** 				pIn2_ += 4u;
 363:spinnaker_src/synapses.h **** 				blkCnt--;
 364:spinnaker_src/synapses.h **** 			}
 365:spinnaker_src/synapses.h **** 
 366:spinnaker_src/synapses.h **** 			blkCnt = n_inputs%0x4u;
 367:spinnaker_src/synapses.h **** 
 368:spinnaker_src/synapses.h **** 			
 369:spinnaker_src/synapses.h **** 			while (blkCnt>0u){
 370:spinnaker_src/synapses.h **** 			
 371:spinnaker_src/synapses.h **** 				inA1 = (REAL)(*pIn1_);
 372:spinnaker_src/synapses.h **** 				inB1 = (REAL)(*pIn2_);
 373:spinnaker_src/synapses.h **** 				sum += (inA1 * inB1);
 374:spinnaker_src/synapses.h **** 				pIn1_++;
 375:spinnaker_src/synapses.h **** 				pIn2_++;
 376:spinnaker_src/synapses.h **** 				//pOut++;
 377:spinnaker_src/synapses.h **** 				blkCnt --;
 378:spinnaker_src/synapses.h **** 			}
 379:spinnaker_src/synapses.h **** 			*pOut ++ =(precision_t) sum ;
 380:spinnaker_src/synapses.h **** 
 381:spinnaker_src/synapses.h **** 
 382:spinnaker_src/synapses.h **** 		}
 383:spinnaker_src/synapses.h **** 	
 384:spinnaker_src/synapses.h **** 	}
 385:spinnaker_src/synapses.h **** 	
 386:spinnaker_src/synapses.h **** }
 387:spinnaker_src/synapses.h **** 
 388:spinnaker_src/synapses.h **** /*
 389:spinnaker_src/synapses.h **** inline void learning_outer_product(REAL * pInA, REAL *pInB, REAL *pOut){
 390:spinnaker_src/synapses.h **** 
 391:spinnaker_src/synapses.h **** 	uint32_t blkCnt;
 392:spinnaker_src/synapses.h **** 	REAL* pInA1;
 393:spinnaker_src/synapses.h **** 	REAL* pInB1;
 394:spinnaker_src/synapses.h **** 	pInA1 = pInA;
 395:spinnaker_src/synapses.h **** 	for(uint32_t i = 0 ; i < N_OUTPUTS; i ++){
 396:spinnaker_src/synapses.h **** 		blkCnt = N_NEURONS>>2u;
 397:spinnaker_src/synapses.h **** 		pInB1 = pInB;
 398:spinnaker_src/synapses.h **** 		while(blkCnt>0u){
 399:spinnaker_src/synapses.h **** 			*pOut =(*pInA1) * (*pInB1);
 400:spinnaker_src/synapses.h **** 			*(pOut++) =(*pInA1) * (*pInB1++);
 401:spinnaker_src/synapses.h **** 			*(pOut++) =(*pInA1) * (*pInB1++);
 402:spinnaker_src/synapses.h **** 			*(pOut++) =(*pInA1) * (*pInB1++);
 403:spinnaker_src/synapses.h **** 
 404:spinnaker_src/synapses.h **** 			blkCnt--;
 405:spinnaker_src/synapses.h **** 		}
 406:spinnaker_src/synapses.h **** 
 407:spinnaker_src/synapses.h **** 		blkCnt = N_NEURONS%0x4u;
 408:spinnaker_src/synapses.h **** 
 409:spinnaker_src/synapses.h **** 		
 410:spinnaker_src/synapses.h **** 		while (blkCnt>0u){
 411:spinnaker_src/synapses.h **** 		
 412:spinnaker_src/synapses.h **** 			(*pOut++) = *pInA1 * (*pInB1++);
 413:spinnaker_src/synapses.h **** 			blkCnt --;
 414:spinnaker_src/synapses.h **** 		}
 415:spinnaker_src/synapses.h **** 		pInA1++;
 416:spinnaker_src/synapses.h **** 	}
 417:spinnaker_src/synapses.h **** 
 418:spinnaker_src/synapses.h **** 
 419:spinnaker_src/synapses.h **** }
 420:spinnaker_src/synapses.h **** */
 421:spinnaker_src/synapses.h **** #ifdef LEARNING_UNROLL_2
 422:spinnaker_src/synapses.h **** inline void learning_outer_product(REAL * pInA, REAL *pInB, REAL *pOut, uint32_t n_neurons){
 423:spinnaker_src/synapses.h **** 
 424:spinnaker_src/synapses.h **** 	REAL* pInA1;
 425:spinnaker_src/synapses.h **** 	REAL* pInB1;
 426:spinnaker_src/synapses.h **** 	pInB1 = pInB;
 427:spinnaker_src/synapses.h **** 	for(uint32_t i = 0 ; i < n_neurons; i ++){
 428:spinnaker_src/synapses.h **** 		pInA1 = pInA;
 429:spinnaker_src/synapses.h **** 		(*pOut++) = (*pInA1++) * (*pInB1);
 430:spinnaker_src/synapses.h **** 		(*pOut++) = (*pInA1)* (*pInB1++);
 431:spinnaker_src/synapses.h **** 	}
 432:spinnaker_src/synapses.h **** 
 433:spinnaker_src/synapses.h **** }
 434:spinnaker_src/synapses.h **** #else
 435:spinnaker_src/synapses.h **** inline void learning_outer_product(REAL * pInA, REAL *pInB, REAL *pOut, uint32_t n_neurons, uint32_
 436:spinnaker_src/synapses.h **** 
 437:spinnaker_src/synapses.h **** 	REAL* pInA1;
 438:spinnaker_src/synapses.h **** 	REAL* pInB1;
 439:spinnaker_src/synapses.h **** 	pInB1 = pInB;
 440:spinnaker_src/synapses.h **** 	for(uint32_t i = 0 ; i < n_neurons; i ++){
 195              		.loc 2 440 0
 196 001a BEF1000F 		cmp	lr, #0
 197 001e 5ED0     		beq	.L16
 198 0020 4FEA8508 		lsl	r8, r5, #2
 199 0024 3746     		mov	r7, r6
 200 0026 0020     		movs	r0, #0
 201              	.LVL15:
 202              	.L18:
 203              	.LBB17:
 441:spinnaker_src/synapses.h **** 		pInA1 = pInA;
 442:spinnaker_src/synapses.h **** 		for (uint32_t j = 0; j < n_outputs; j++){
 204              		.loc 2 442 0
 205 0028 75B1     		cbz	r5, .L21
 206 002a 3946     		mov	r1, r7
 207 002c 6246     		mov	r2, ip
 208 002e 0023     		movs	r3, #0
 209              	.LVL16:
 210              	.L19:
 443:spinnaker_src/synapses.h **** 			(*pOut++) = (*pInA1++) * (*pInB1);
 211              		.loc 2 443 0
 212 0030 F2EC017A 		fldmias	r2!, {s15}
 213              	.LVL17:
 214 0034 94ED007A 		flds	s14, [r4]
 442:spinnaker_src/synapses.h **** 			(*pOut++) = (*pInA1++) * (*pInB1);
 215              		.loc 2 442 0
 216 0038 0133     		adds	r3, r3, #1
 217              	.LVL18:
 218              		.loc 2 443 0
 219 003a 67EE877A 		fmuls	s15, s15, s14
 442:spinnaker_src/synapses.h **** 			(*pOut++) = (*pInA1++) * (*pInB1);
 220              		.loc 2 442 0
 221 003e AB42     		cmp	r3, r5
 222              		.loc 2 443 0
 223 0040 E1EC017A 		fstmias	r1!, {s15}
 442:spinnaker_src/synapses.h **** 			(*pOut++) = (*pInA1++) * (*pInB1);
 224              		.loc 2 442 0
 225 0044 F4D1     		bne	.L19
 226 0046 4744     		add	r7, r7, r8
 227              	.LVL19:
 228              	.L21:
 229              	.LBE17:
 440:spinnaker_src/synapses.h **** 		pInA1 = pInA;
 230              		.loc 2 440 0
 231 0048 0130     		adds	r0, r0, #1
 232              	.LVL20:
 233 004a 7045     		cmp	r0, lr
 444:spinnaker_src/synapses.h **** 		}
 445:spinnaker_src/synapses.h **** 		pInB1++;
 234              		.loc 2 445 0
 235 004c 04F10404 		add	r4, r4, #4
 236              	.LVL21:
 440:spinnaker_src/synapses.h **** 		pInA1 = pInA;
 237              		.loc 2 440 0
 238 0050 EAD1     		bne	.L18
 239              	.LBE16:
 240              	.LBE15:
 241              	.LBE14:
 242              	.LBB18:
 243              	.LBB19:
 446:spinnaker_src/synapses.h **** 		//pInA1++;
 447:spinnaker_src/synapses.h **** 	}
 448:spinnaker_src/synapses.h **** 
 449:spinnaker_src/synapses.h **** 
 450:spinnaker_src/synapses.h **** 
 451:spinnaker_src/synapses.h **** }
 452:spinnaker_src/synapses.h **** #endif
 453:spinnaker_src/synapses.h **** 
 454:spinnaker_src/synapses.h **** 
 455:spinnaker_src/synapses.h **** inline void learning_update_decoders(precision_t* pInA,REAL *pInB, uint32_t n_neurons, uint32_t n_o
 456:spinnaker_src/synapses.h **** 
 457:spinnaker_src/synapses.h **** 	uint32_t blkCnt;
 458:spinnaker_src/synapses.h **** 	REAL inA1, inA2, inA3, inA4;
 459:spinnaker_src/synapses.h **** 	REAL inB1, inB2, inB3, inB4;
 460:spinnaker_src/synapses.h **** 
 461:spinnaker_src/synapses.h **** 	blkCnt = (n_outputs*n_neurons)>>2u;
 244              		.loc 2 461 0
 245 0052 00FB05F0 		mul	r0, r0, r5
 246              	.LVL22:
 462:spinnaker_src/synapses.h **** 
 463:spinnaker_src/synapses.h **** 	while(blkCnt>0u){
 247              		.loc 2 463 0
 248 0056 8508     		lsrs	r5, r0, #2
 249              	.LVL23:
 250              	.LBE19:
 251              	.LBE18:
 521:spinnaker_src/synapses.c **** 		learning_update_decoders(ens.decoders, ens.delta, ens.n_neurons, ens.n_outputs, ens.learning_rate
 252              		.loc 1 521 0
 253 0058 0899     		ldr	r1, [sp, #32]
 254 005a 9DED133A 		flds	s6, [sp, #76]
 255              	.LVL24:
 256              	.LBB21:
 257              	.LBB20:
 258              		.loc 2 463 0
 259 005e 2FD0     		beq	.L22
 260 0060 01F11003 		add	r3, r1, #16
 261 0064 06F11002 		add	r2, r6, #16
 262 0068 2C46     		mov	r4, r5
 263              	.LVL25:
 264 006a F1EE437A 		fnegs	s15, s6
 265              	.LVL26:
 266              	.L23:
 464:spinnaker_src/synapses.h **** 	
 465:spinnaker_src/synapses.h **** 		inA1 = *pInA;
 466:spinnaker_src/synapses.h **** 		inB1 = *pInB;
 467:spinnaker_src/synapses.h **** 		inA2 = *(pInA+1);
 468:spinnaker_src/synapses.h **** 		inB2 = *(pInB+1);
 267              		.loc 2 468 0
 268 006e 52ED033A 		flds	s7, [r2, #-12]
 469:spinnaker_src/synapses.h **** 		inA3 = *(pInA+2);
 470:spinnaker_src/synapses.h **** 		inB3 = *(pInB+2);
 269              		.loc 2 470 0
 270 0072 52ED024A 		flds	s9, [r2, #-8]
 471:spinnaker_src/synapses.h **** 		inA4 = *(pInA+3);
 472:spinnaker_src/synapses.h **** 		inB4 = *(pInB+3);
 271              		.loc 2 472 0
 272 0076 12ED015A 		flds	s10, [r2, #-4]
 473:spinnaker_src/synapses.h **** 
 474:spinnaker_src/synapses.h **** 		*pInA = inA1 - inB1*learning_rate;
 273              		.loc 2 474 0
 274 007a 12ED044A 		flds	s8, [r2, #-16]
 467:spinnaker_src/synapses.h **** 		inB2 = *(pInB+1);
 275              		.loc 2 467 0
 276 007e 53ED035A 		flds	s11, [r3, #-12]
 277              	.LVL27:
 278              		.loc 2 474 0
 279 0082 13ED046A 		flds	s12, [r3, #-16]
 469:spinnaker_src/synapses.h **** 		inB3 = *(pInB+2);
 280              		.loc 2 469 0
 281 0086 53ED026A 		flds	s13, [r3, #-8]
 282              	.LVL28:
 471:spinnaker_src/synapses.h **** 		inB4 = *(pInB+3);
 283              		.loc 2 471 0
 284 008a 13ED017A 		flds	s14, [r3, #-4]
 285              	.LVL29:
 475:spinnaker_src/synapses.h **** 		*(pInA+1) = inA2 - inB2*learning_rate;
 286              		.loc 2 475 0
 287 008e E7EEA35A 		vfma.f32	s11, s15, s7
 288              	.LVL30:
 463:spinnaker_src/synapses.h **** 	
 289              		.loc 2 463 0
 290 0092 013C     		subs	r4, r4, #1
 291              	.LVL31:
 292 0094 02F11002 		add	r2, r2, #16
 293              	.LVL32:
 474:spinnaker_src/synapses.h **** 		*(pInA+1) = inA2 - inB2*learning_rate;
 294              		.loc 2 474 0
 295 0098 A7EE846A 		vfma.f32	s12, s15, s8
 296 009c 03F11003 		add	r3, r3, #16
 297              	.LVL33:
 476:spinnaker_src/synapses.h **** 		*(pInA+2) = inA3 - inB3*learning_rate;
 298              		.loc 2 476 0
 299 00a0 E7EEA46A 		vfma.f32	s13, s15, s9
 300              	.LVL34:
 477:spinnaker_src/synapses.h **** 		*(pInA+3) = inA4 - inB4*learning_rate;
 301              		.loc 2 477 0
 302 00a4 A7EE857A 		vfma.f32	s14, s15, s10
 303              	.LVL35:
 475:spinnaker_src/synapses.h **** 		*(pInA+2) = inA3 - inB3*learning_rate;
 304              		.loc 2 475 0
 305 00a8 43ED075A 		fsts	s11, [r3, #-28]
 306              	.LVL36:
 474:spinnaker_src/synapses.h **** 		*(pInA+1) = inA2 - inB2*learning_rate;
 307              		.loc 2 474 0
 308 00ac 03ED086A 		fsts	s12, [r3, #-32]
 309              	.LVL37:
 476:spinnaker_src/synapses.h **** 		*(pInA+3) = inA4 - inB4*learning_rate;
 310              		.loc 2 476 0
 311 00b0 43ED066A 		fsts	s13, [r3, #-24]
 312              	.LVL38:
 313              		.loc 2 477 0
 314 00b4 03ED057A 		fsts	s14, [r3, #-20]
 315              	.LVL39:
 463:spinnaker_src/synapses.h **** 	
 316              		.loc 2 463 0
 317 00b8 D9D1     		bne	.L23
 318 00ba 2B01     		lsls	r3, r5, #4
 319 00bc 1944     		add	r1, r1, r3
 320 00be 1E44     		add	r6, r6, r3
 321              	.LVL40:
 322              	.L22:
 478:spinnaker_src/synapses.h **** 
 479:spinnaker_src/synapses.h **** 		pInA += 4u;
 480:spinnaker_src/synapses.h **** 		pInB += 4u;
 481:spinnaker_src/synapses.h **** 
 482:spinnaker_src/synapses.h **** 		blkCnt--;
 483:spinnaker_src/synapses.h **** 	}
 484:spinnaker_src/synapses.h **** 
 485:spinnaker_src/synapses.h **** 	blkCnt = (n_outputs*n_neurons)%0x4u;
 486:spinnaker_src/synapses.h **** 
 487:spinnaker_src/synapses.h **** 	
 488:spinnaker_src/synapses.h **** 	while (blkCnt>0u){
 323              		.loc 2 488 0
 324 00c0 10F00303 		ands	r3, r0, #3
 325              	.LVL41:
 326 00c4 0BD0     		beq	.L16
 327 00c6 F1EE437A 		fnegs	s15, s6
 328              	.LVL42:
 329              	.L25:
 489:spinnaker_src/synapses.h **** 	
 490:spinnaker_src/synapses.h **** 		inA1 = *pInA;
 491:spinnaker_src/synapses.h **** 		inB1 = *pInB;
 330              		.loc 2 491 0
 331 00ca F6EC016A 		fldmias	r6!, {s13}
 332              	.LVL43:
 492:spinnaker_src/synapses.h **** 		(*pInA) = inA1 - inB1*learning_rate;
 333              		.loc 2 492 0
 334 00ce 91ED007A 		flds	s14, [r1]
 335 00d2 A7EEA67A 		vfma.f32	s14, s15, s13
 488:spinnaker_src/synapses.h **** 	
 336              		.loc 2 488 0
 337 00d6 013B     		subs	r3, r3, #1
 338              	.LVL44:
 339              		.loc 2 492 0
 340 00d8 A1EC017A 		fstmias	r1!, {s14}
 341              	.LVL45:
 488:spinnaker_src/synapses.h **** 	
 342              		.loc 2 488 0
 343 00dc F5D1     		bne	.L25
 344              	.LVL46:
 345              	.L16:
 346              	.LBE20:
 347              	.LBE21:
 522:spinnaker_src/synapses.c **** 		
 523:spinnaker_src/synapses.c **** 
 524:spinnaker_src/synapses.c **** 		/*
 525:spinnaker_src/synapses.c **** 		if(record_count < RECORD_LEN){
 526:spinnaker_src/synapses.c **** 		
 527:spinnaker_src/synapses.c **** 			if(pe_id == 2){
 528:spinnaker_src/synapses.c **** 				nengo_output_record[record_count]=ens.decoders[10];
 529:spinnaker_src/synapses.c **** 				//nengo_output_record[record_count]=ens.error[0];
 530:spinnaker_src/synapses.c **** 				//nengo_output_record[record_count]=ens.learning_activity[10];
 531:spinnaker_src/synapses.c **** 				record_count ++;
 532:spinnaker_src/synapses.c **** 			}
 533:spinnaker_src/synapses.c **** 		}
 534:spinnaker_src/synapses.c **** 		*/
 535:spinnaker_src/synapses.c **** 		//if(systicks ==2){
 536:spinnaker_src/synapses.c **** 
 537:spinnaker_src/synapses.c **** 			/*
 538:spinnaker_src/synapses.c **** 			for(uint32_t i = 0; i < N_OUTPUTS; i ++){
 539:spinnaker_src/synapses.c **** 				log_info("%#010x\n",*(uint32_t*)&error[i]);
 540:spinnaker_src/synapses.c **** 			}
 541:spinnaker_src/synapses.c **** 			*/
 542:spinnaker_src/synapses.c **** 			/*
 543:spinnaker_src/synapses.c **** 			for(uint32_t i = 0; i < N_OUTPUTS*N_NEURONS; i ++){
 544:spinnaker_src/synapses.c **** 				log_info("%#010x\n",*(uint32_t*)&decoders[i]);
 545:spinnaker_src/synapses.c **** 			}
 546:spinnaker_src/synapses.c **** 			*/
 547:spinnaker_src/synapses.c **** 			
 548:spinnaker_src/synapses.c **** 			
 549:spinnaker_src/synapses.c **** 			/*
 550:spinnaker_src/synapses.c **** 			for(uint32_t i = 0; i < N_NEURONS; i ++){
 551:spinnaker_src/synapses.c **** 				log_info("%#010x\n",*(uint32_t*)&learning_activity[i]);
 552:spinnaker_src/synapses.c **** 			}
 553:spinnaker_src/synapses.c **** 			
 554:spinnaker_src/synapses.c **** 			
 555:spinnaker_src/synapses.c **** 			log_info("===================\n");
 556:spinnaker_src/synapses.c **** 			*/
 557:spinnaker_src/synapses.c **** 			/*
 558:spinnaker_src/synapses.c **** 			for(uint32_t i = 0; i < N_OUTPUTS*N_NEURONS; i ++){
 559:spinnaker_src/synapses.c **** 				log_info("%#010x\n",*(uint32_t*)&delta[i]);
 560:spinnaker_src/synapses.c **** 			}
 561:spinnaker_src/synapses.c **** 			*/
 562:spinnaker_src/synapses.c **** 			
 563:spinnaker_src/synapses.c **** 			
 564:spinnaker_src/synapses.c **** 		//}
 565:spinnaker_src/synapses.c **** //	}
 566:spinnaker_src/synapses.c **** }
 348              		.loc 1 566 0
 349 00de BDE8F041 		pop	{r4, r5, r6, r7, r8, lr}
 350              		.cfi_restore 14
 351              		.cfi_restore 8
 352              		.cfi_restore 7
 353              		.cfi_restore 6
 354              		.cfi_restore 5
 355              		.cfi_restore 4
 356              		.cfi_def_cfa_offset 16
 357              	.LVL47:
 358 00e2 04B0     		add	sp, sp, #16
 359              		.cfi_def_cfa_offset 0
 360              	.LVL48:
 361 00e4 7047     		bx	lr
 362              		.cfi_endproc
 363              	.LFE189:
 365              		.comm	ensemble_results,12,4
 366              		.comm	input_time_stamp,4,4
 367              		.global	debug_count19
 368              		.comm	API_BURST_FINISHED,1,1
 369 00e6 00BF     		.section	.bss.debug_count19,"aw",%nobits
 370              		.align	2
 373              	debug_count19:
 374 0000 00000000 		.space	4
 375              		.text
 376              	.Letext0:
 377              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 378              		.file 4 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 379              		.file 5 "spinnaker_src/common/maths-util.h"
 380              		.file 6 "spinnaker_src/param_defs.h"
 381              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 382              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 383              		.file 9 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
 384              		.file 10 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
