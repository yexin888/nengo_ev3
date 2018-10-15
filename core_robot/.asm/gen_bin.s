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
  17              		.file	"gen_bin.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.write_neuron_params,"ax",%progbits
  22              		.align	2
  23              		.global	write_neuron_params
  24              		.thumb
  25              		.thumb_func
  27              	write_neuron_params:
  28              	.LFB186:
  29              		.file 1 "spinnaker_src/gen_bin.c"
   1:spinnaker_src/gen_bin.c **** 
   2:spinnaker_src/gen_bin.c **** #include "gen_bin.h"
   3:spinnaker_src/gen_bin.c **** 
   4:spinnaker_src/gen_bin.c **** uint32_t params_addr;
   5:spinnaker_src/gen_bin.c **** uint32_t params_addr2;
   6:spinnaker_src/gen_bin.c **** 
   7:spinnaker_src/gen_bin.c **** 
   8:spinnaker_src/gen_bin.c **** uint32_t table_count;
   9:spinnaker_src/gen_bin.c **** 
  10:spinnaker_src/gen_bin.c **** //uint32_t n_neurons[N_CORES] ;
  11:spinnaker_src/gen_bin.c **** 
  12:spinnaker_src/gen_bin.c **** global_neuron_params_t global_neuron_params ;
  13:spinnaker_src/gen_bin.c **** 
  14:spinnaker_src/gen_bin.c **** master_population_table_entry master_population_table[MASTER_TABLE_LENGTH] ;
  15:spinnaker_src/gen_bin.c **** //population_table_info pop_table_info[N_CORES] ;
  16:spinnaker_src/gen_bin.c **** //neuron_t neuron_array[N_NEURONS]; 
  17:spinnaker_src/gen_bin.c **** input_type_t input_type_array ;
  18:spinnaker_src/gen_bin.c **** synapse_param_t neuron_synapse_shaping_params ;
  19:spinnaker_src/gen_bin.c **** uint32_t synapse_row_array[SYNAPSE_ROW_ARRAY_MAX_LENGTH];
  20:spinnaker_src/gen_bin.c **** uint32_t synapse_row_array_count=0;
  21:spinnaker_src/gen_bin.c **** 
  22:spinnaker_src/gen_bin.c **** void write_neuron_params(){
  30              		.loc 1 22 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  35 0000 7047     		bx	lr
  36              		.cfi_endproc
  37              	.LFE186:
  39 0002 00BF     		.section	.text.gen_bin,"ax",%progbits
  40              		.align	2
  41              		.global	gen_bin
  42              		.thumb
  43              		.thumb_func
  45              	gen_bin:
  46              	.LFB187:
  23:spinnaker_src/gen_bin.c **** 
  24:spinnaker_src/gen_bin.c **** 	//configure neuron parameters
  25:spinnaker_src/gen_bin.c **** 	/*
  26:spinnaker_src/gen_bin.c ****     for (int j=0; j<N_CORES;j++){
  27:spinnaker_src/gen_bin.c ****         n_neurons[j]=N_NEURONS;
  28:spinnaker_src/gen_bin.c ****     }
  29:spinnaker_src/gen_bin.c **** 	*/
  30:spinnaker_src/gen_bin.c **** 
  31:spinnaker_src/gen_bin.c **** 	//REAL v_membrane_init=0;
  32:spinnaker_src/gen_bin.c **** 	/*
  33:spinnaker_src/gen_bin.c **** 	REAL v_rest=0;
  34:spinnaker_src/gen_bin.c **** 	REAL v_reset=0;
  35:spinnaker_src/gen_bin.c **** 	REAL v_th=1;
  36:spinnaker_src/gen_bin.c **** 	REAL c_mem = 0.29;
  37:spinnaker_src/gen_bin.c **** 
  38:spinnaker_src/gen_bin.c **** 	global_neuron_params.T_refract   = TAU_REF ;
  39:spinnaker_src/gen_bin.c **** 	global_neuron_params.T_rc        = TAU_RC ;
  40:spinnaker_src/gen_bin.c **** 	global_neuron_params.n_inputs    = N_INPUTS;
  41:spinnaker_src/gen_bin.c **** 	global_neuron_params.n_outputs    = N_OUTPUTS;
  42:spinnaker_src/gen_bin.c **** 	global_neuron_params.exp_TC      = 0.904837;
  43:spinnaker_src/gen_bin.c **** 	global_neuron_params.R_membrane  = 1./29.;
  44:spinnaker_src/gen_bin.c **** 	global_neuron_params.g_membrane  = 29;
  45:spinnaker_src/gen_bin.c **** 	global_neuron_params.c_membrane  = c_mem;
  46:spinnaker_src/gen_bin.c **** 	global_neuron_params.V_rest      = v_rest;
  47:spinnaker_src/gen_bin.c **** 	global_neuron_params.V_reset     = v_reset;
  48:spinnaker_src/gen_bin.c **** 	global_neuron_params.threshold   = v_th;
  49:spinnaker_src/gen_bin.c **** 	global_neuron_params.pop_info1   =  6 << 0 | 7 << 3;
  50:spinnaker_src/gen_bin.c **** 	*/
  51:spinnaker_src/gen_bin.c **** 
  52:spinnaker_src/gen_bin.c **** 	//moved to neuron.c
  53:spinnaker_src/gen_bin.c **** 	/*
  54:spinnaker_src/gen_bin.c **** 	for (uint32_t i = 0 ; i < n_ensembles; i++){
  55:spinnaker_src/gen_bin.c **** 		for(uint32_t j = 0 ; j < ensembles[i].n_neurons; j++){
  56:spinnaker_src/gen_bin.c **** 			ensembles[i].neurons[j].V_membrane=v_membrane_init;
  57:spinnaker_src/gen_bin.c **** 			ensembles[i].neurons[j].refract_timer=0;
  58:spinnaker_src/gen_bin.c **** 		}
  59:spinnaker_src/gen_bin.c **** 	}	
  60:spinnaker_src/gen_bin.c **** 	*/
  61:spinnaker_src/gen_bin.c **** 
  62:spinnaker_src/gen_bin.c **** 	//configure input type arrays
  63:spinnaker_src/gen_bin.c **** 
  64:spinnaker_src/gen_bin.c **** 	/*
  65:spinnaker_src/gen_bin.c **** 	input_type_array.V_rev_E=0;
  66:spinnaker_src/gen_bin.c **** 	input_type_array.V_rev_I=-75;
  67:spinnaker_src/gen_bin.c **** 
  68:spinnaker_src/gen_bin.c **** 	//REAL tau_ampa=1.5;//ms
  69:spinnaker_src/gen_bin.c **** 	REAL exc_decay=0.513417119;
  70:spinnaker_src/gen_bin.c **** 
  71:spinnaker_src/gen_bin.c **** 	//REAL tau_gaba=10;//ms
  72:spinnaker_src/gen_bin.c **** 	REAL inh_decay=0.367879441;
  73:spinnaker_src/gen_bin.c ****         
  74:spinnaker_src/gen_bin.c **** 	REAL exc_init=0.78554*0.925500993;
  75:spinnaker_src/gen_bin.c **** 	REAL inh_init=0.78554*1.2025984172;
  76:spinnaker_src/gen_bin.c **** 
  77:spinnaker_src/gen_bin.c **** 	neuron_synapse_shaping_params.exc_decay=exc_decay;
  78:spinnaker_src/gen_bin.c **** 	neuron_synapse_shaping_params.exc_init=exc_init;
  79:spinnaker_src/gen_bin.c **** 	neuron_synapse_shaping_params.inh_decay=inh_decay;
  80:spinnaker_src/gen_bin.c **** 	neuron_synapse_shaping_params.inh_init=inh_init;
  81:spinnaker_src/gen_bin.c **** 	*/
  82:spinnaker_src/gen_bin.c **** 
  83:spinnaker_src/gen_bin.c **** }		
  84:spinnaker_src/gen_bin.c **** /*
  85:spinnaker_src/gen_bin.c **** void calc_row_table(master_population_table_entry* master_population_table, 
  86:spinnaker_src/gen_bin.c **** 		uint32_t  *synapse_row_offset, 
  87:spinnaker_src/gen_bin.c **** 		matrix_column*  connection_matrix, uint32_t * synapse_rows, int32_t core_id, 
  88:spinnaker_src/gen_bin.c **** 		uint32_t synapse_type, uint32_t delay, uint32_t weight){
  89:spinnaker_src/gen_bin.c **** 
  90:spinnaker_src/gen_bin.c **** 	uint32_t neuron_id_pre;
  91:spinnaker_src/gen_bin.c **** 	uint32_t neuron_id_post;
  92:spinnaker_src/gen_bin.c **** 	uint32_t row_count ;
  93:spinnaker_src/gen_bin.c **** 	uint32_t i;
  94:spinnaker_src/gen_bin.c **** 	//synapse_row_array_count = 0;
  95:spinnaker_src/gen_bin.c **** 
  96:spinnaker_src/gen_bin.c **** 	for (neuron_id_pre = 0 ; neuron_id_pre < N_NEURONS ; neuron_id_pre ++){
  97:spinnaker_src/gen_bin.c **** 		
  98:spinnaker_src/gen_bin.c **** 		for (i = 0 ; i < SYNAPSE_ROW_LENGTH; i++){
  99:spinnaker_src/gen_bin.c **** 			synapse_rows[i]=0;
 100:spinnaker_src/gen_bin.c **** 		}
 101:spinnaker_src/gen_bin.c **** 
 102:spinnaker_src/gen_bin.c **** 
 103:spinnaker_src/gen_bin.c **** 		row_count=0;
 104:spinnaker_src/gen_bin.c **** 
 105:spinnaker_src/gen_bin.c **** 		//debug!
 106:spinnaker_src/gen_bin.c **** 		master_population_table[table_count].key = core_id << 28 | (neuron_id_pre );
 107:spinnaker_src/gen_bin.c **** 
 108:spinnaker_src/gen_bin.c **** 		master_population_table[table_count].mask = 0xffffffff;
 109:spinnaker_src/gen_bin.c **** 
 110:spinnaker_src/gen_bin.c **** 		master_population_table[table_count].address_and_row_length = synapse_row_array_count  << 8;
 111:spinnaker_src/gen_bin.c **** 		uint32_t odd=0;
 112:spinnaker_src/gen_bin.c **** 		for (neuron_id_post = 0 ; neuron_id_post < N_NEURONS ; neuron_id_post ++){
 113:spinnaker_src/gen_bin.c **** 		
 114:spinnaker_src/gen_bin.c **** 			if ((connection_matrix[neuron_id_pre][neuron_id_post/32] & (1 << (neuron_id_post - neuron_id_pos
 115:spinnaker_src/gen_bin.c **** 				if(odd == 0){
 116:spinnaker_src/gen_bin.c **** 					synapse_rows[row_count+3] = (neuron_id_post << 0)|
 117:spinnaker_src/gen_bin.c **** 											   (synapse_type << SYNAPSE_INDEX_BITS)|
 118:spinnaker_src/gen_bin.c **** 											   (delay<<(SYNAPSE_INDEX_BITS+SYNAPSE_TYPE_BITS))|
 119:spinnaker_src/gen_bin.c **** 											   (weight<<(SYNAPSE_INDEX_BITS+SYNAPSE_TYPE_BITS+SYNAPSE_DELAY_BITS));
 120:spinnaker_src/gen_bin.c **** 					odd = 1;
 121:spinnaker_src/gen_bin.c **** 				}
 122:spinnaker_src/gen_bin.c **** 				else{
 123:spinnaker_src/gen_bin.c **** 				
 124:spinnaker_src/gen_bin.c **** 					synapse_rows[row_count+3] |= ((neuron_id_post << 0)|
 125:spinnaker_src/gen_bin.c **** 											   (synapse_type << SYNAPSE_INDEX_BITS)|
 126:spinnaker_src/gen_bin.c **** 											   (delay<<(SYNAPSE_INDEX_BITS+SYNAPSE_TYPE_BITS))|
 127:spinnaker_src/gen_bin.c **** 											   (weight<<(SYNAPSE_INDEX_BITS+SYNAPSE_TYPE_BITS+SYNAPSE_DELAY_BITS)))<<16;
 128:spinnaker_src/gen_bin.c **** 
 129:spinnaker_src/gen_bin.c **** 					odd = 0;
 130:spinnaker_src/gen_bin.c **** 					row_count ++;
 131:spinnaker_src/gen_bin.c **** 				}
 132:spinnaker_src/gen_bin.c **** 			}
 133:spinnaker_src/gen_bin.c **** 		}
 134:spinnaker_src/gen_bin.c **** 		synapse_rows[0]=0;
 135:spinnaker_src/gen_bin.c **** 		synapse_rows[1]=row_count*2+odd;
 136:spinnaker_src/gen_bin.c **** 		synapse_rows[2]=0;
 137:spinnaker_src/gen_bin.c **** 
 138:spinnaker_src/gen_bin.c **** 		uint32_t row_not_empty=0;
 139:spinnaker_src/gen_bin.c **** 		if(row_count*2+odd> 0){
 140:spinnaker_src/gen_bin.c **** 			row_not_empty=1;
 141:spinnaker_src/gen_bin.c **** 		}
 142:spinnaker_src/gen_bin.c **** 
 143:spinnaker_src/gen_bin.c **** 		row_count +=3;
 144:spinnaker_src/gen_bin.c **** 		if ((odd) ==1){
 145:spinnaker_src/gen_bin.c **** 			(row_count) ++;
 146:spinnaker_src/gen_bin.c **** 		}
 147:spinnaker_src/gen_bin.c **** 
 148:spinnaker_src/gen_bin.c **** 		master_population_table[table_count].address_and_row_length |= row_count  ;
 149:spinnaker_src/gen_bin.c **** 
 150:spinnaker_src/gen_bin.c **** 		if (row_not_empty){
 151:spinnaker_src/gen_bin.c **** 			(table_count) ++;
 152:spinnaker_src/gen_bin.c **** 		}
 153:spinnaker_src/gen_bin.c **** 
 154:spinnaker_src/gen_bin.c **** 		if(row_not_empty){
 155:spinnaker_src/gen_bin.c **** 
 156:spinnaker_src/gen_bin.c **** 			for (uint32_t i = 0; i < row_count ; i ++ ){
 157:spinnaker_src/gen_bin.c **** 				synapse_row_array[synapse_row_array_count]=synapse_rows[i];
 158:spinnaker_src/gen_bin.c **** 				synapse_row_array_count++;
 159:spinnaker_src/gen_bin.c **** 
 160:spinnaker_src/gen_bin.c **** 			}
 161:spinnaker_src/gen_bin.c **** 
 162:spinnaker_src/gen_bin.c **** 		}
 163:spinnaker_src/gen_bin.c **** 
 164:spinnaker_src/gen_bin.c **** 	}
 165:spinnaker_src/gen_bin.c **** }	
 166:spinnaker_src/gen_bin.c **** 
 167:spinnaker_src/gen_bin.c **** void clear_connection_matrix(matrix_column* connection_matrix){
 168:spinnaker_src/gen_bin.c ****     for (uint32_t neuron_id_pre = 0 ; neuron_id_pre < N_NEURONS ; neuron_id_pre ++){
 169:spinnaker_src/gen_bin.c **** 		for (uint32_t neuron_id_post = 0 ; neuron_id_post < MATRIX_WIDTH ; neuron_id_post ++){
 170:spinnaker_src/gen_bin.c **** 				connection_matrix[neuron_id_pre][neuron_id_post] = 0;
 171:spinnaker_src/gen_bin.c **** 		//set_gp_reg(2,neuron_id_post);
 172:spinnaker_src/gen_bin.c **** 		}
 173:spinnaker_src/gen_bin.c **** 	}
 174:spinnaker_src/gen_bin.c **** }		
 175:spinnaker_src/gen_bin.c **** 
 176:spinnaker_src/gen_bin.c **** void clear_population_table(master_population_table_entry* master_population_table){
 177:spinnaker_src/gen_bin.c **** 	for (uint32_t i = 0 ; i < MASTER_TABLE_LENGTH; i++){
 178:spinnaker_src/gen_bin.c **** 		master_population_table[i].key=0;
 179:spinnaker_src/gen_bin.c **** 		master_population_table[i].mask=0;
 180:spinnaker_src/gen_bin.c **** 		master_population_table[i].address_and_row_length=0;
 181:spinnaker_src/gen_bin.c **** 	}
 182:spinnaker_src/gen_bin.c **** }		
 183:spinnaker_src/gen_bin.c **** 
 184:spinnaker_src/gen_bin.c **** 
 185:spinnaker_src/gen_bin.c **** void connection_matrix_fix_number_pre(uint32_t pre_number, 
 186:spinnaker_src/gen_bin.c **** 		                              uint32_t pre_start, uint32_t pre_end,
 187:spinnaker_src/gen_bin.c **** 									  uint32_t post_start, uint32_t post_end,
 188:spinnaker_src/gen_bin.c **** 									  matrix_column * connection_matrix ){
 189:spinnaker_src/gen_bin.c **** 
 190:spinnaker_src/gen_bin.c **** 	uint32_t neuron_id_post;
 191:spinnaker_src/gen_bin.c **** 	
 192:spinnaker_src/gen_bin.c **** 	for ( neuron_id_post = post_start ; neuron_id_post < post_end ; neuron_id_post ++){
 193:spinnaker_src/gen_bin.c **** 		uint32_t pre_count=0;
 194:spinnaker_src/gen_bin.c **** 
 195:spinnaker_src/gen_bin.c **** 		while (pre_count < pre_number){
 196:spinnaker_src/gen_bin.c **** 		
 197:spinnaker_src/gen_bin.c **** 			uint32_t neuron_id_pre;
 198:spinnaker_src/gen_bin.c **** 			neuron_id_pre = (uint32_t)( uni_randf() * (REAL) (pre_end - pre_start)) + pre_start;
 199:spinnaker_src/gen_bin.c **** 			if ((connection_matrix[neuron_id_pre][neuron_id_post/32] & (1 << (neuron_id_post - neuron_id_pos
 200:spinnaker_src/gen_bin.c **** 				(connection_matrix[neuron_id_pre][neuron_id_post/32]) |= (1 <<( neuron_id_post - neuron_id_post
 201:spinnaker_src/gen_bin.c **** 
 202:spinnaker_src/gen_bin.c **** 				pre_count ++;
 203:spinnaker_src/gen_bin.c **** 			}
 204:spinnaker_src/gen_bin.c **** 		}
 205:spinnaker_src/gen_bin.c **** 	}
 206:spinnaker_src/gen_bin.c **** }
 207:spinnaker_src/gen_bin.c **** 
 208:spinnaker_src/gen_bin.c **** void connection_matrix_all_to_all(uint32_t pre_start, uint32_t pre_end, 
 209:spinnaker_src/gen_bin.c **** 		                          uint32_t post_start, uint32_t post_end, 
 210:spinnaker_src/gen_bin.c **** 								  matrix_column * connection_matrix){
 211:spinnaker_src/gen_bin.c **** 		for (uint32_t neuron_id_pre = pre_start ; neuron_id_pre < pre_end ; neuron_id_pre ++){
 212:spinnaker_src/gen_bin.c **** 			for (uint32_t neuron_id_post = post_start ; neuron_id_post < post_end ; neuron_id_post ++){
 213:spinnaker_src/gen_bin.c **** 				connection_matrix[neuron_id_pre][neuron_id_post/32] |= (1 << (neuron_id_post - neuron_id_post/3
 214:spinnaker_src/gen_bin.c **** 			}
 215:spinnaker_src/gen_bin.c **** 		}
 216:spinnaker_src/gen_bin.c **** }
 217:spinnaker_src/gen_bin.c **** */
 218:spinnaker_src/gen_bin.c **** void gen_bin(void)
 219:spinnaker_src/gen_bin.c **** {
  47              		.loc 1 219 0
  48              		.cfi_startproc
  49              		@ args = 0, pretend = 0, frame = 0
  50              		@ frame_needed = 0, uses_anonymous_args = 0
  51              		@ link register save eliminated.
  52 0000 7047     		bx	lr
  53              		.cfi_endproc
  54              	.LFE187:
  56              		.global	synapse_row_array_count
  57              		.comm	synapse_row_array,44000,4
  58              		.comm	neuron_synapse_shaping_params,16,4
  59              		.comm	input_type_array,8,4
  60              		.comm	master_population_table,360,4
  61              		.comm	global_neuron_params,16,4
  62              		.comm	table_count,4,4
  63              		.comm	params_addr2,4,4
  64              		.comm	params_addr,4,4
  65 0002 00BF     		.section	.bss.synapse_row_array_count,"aw",%nobits
  66              		.align	2
  69              	synapse_row_array_count:
  70 0000 00000000 		.space	4
  71              		.text
  72              	.Letext0:
  73              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
  74              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
  75              		.file 4 "spinnaker_src/common/maths-util.h"
  76              		.file 5 "spinnaker_src/input_types/input_type_conductance.h"
  77              		.file 6 "spinnaker_src/synapse_types/../decay.h"
  78              		.file 7 "spinnaker_src/synapse_types/synapse_types_exponential_impl.h"
  79              		.file 8 "spinnaker_src/neuron_model_lif_impl.h"
  80              		.file 9 "spinnaker_src/population_table.h"
  81              		.file 10 "spinnaker_src/synapse_types/../param_defs.h"
  82              		.file 11 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
  83              		.file 12 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
  84              		.file 13 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
