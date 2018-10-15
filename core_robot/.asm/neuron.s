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
  17              		.file	"neuron.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.neuron_initialise,"ax",%progbits
  22              		.align	2
  23              		.global	neuron_initialise
  24              		.thumb
  25              		.thumb_func
  27              	neuron_initialise:
  28              	.LFB187:
  29              		.file 1 "spinnaker_src/neuron.c"
   1:spinnaker_src/neuron.c **** #include "neuron.h"
   2:spinnaker_src/neuron.c **** 
   3:spinnaker_src/neuron.c **** uint32_t n_neurons;
   4:spinnaker_src/neuron.c **** 
   5:spinnaker_src/neuron.c **** //extern input_t input_buffers[INPUT_BUFFER_SIZE];
   6:spinnaker_src/neuron.c **** 
   7:spinnaker_src/neuron.c **** extern input_type_t input_type_array ;
   8:spinnaker_src/neuron.c **** 
   9:spinnaker_src/neuron.c **** extern global_neuron_params_t global_neuron_params;
  10:spinnaker_src/neuron.c **** 
  11:spinnaker_src/neuron.c **** extern uint32_t meas_type;
  12:spinnaker_src/neuron.c **** 
  13:spinnaker_src/neuron.c **** extern uint32_t systicks;
  14:spinnaker_src/neuron.c **** 
  15:spinnaker_src/neuron.c **** uint32_t spike_records[SPIKE_RECORD_LENGTH] __attribute__((aligned(0x10)));
  16:spinnaker_src/neuron.c **** uint32_t spike_records_count[SPIKE_RECORD_COUNTER_LENGTH];
  17:spinnaker_src/neuron.c **** 
  18:spinnaker_src/neuron.c **** extern uint32_t self_spike_counter;
  19:spinnaker_src/neuron.c **** extern uint32_t self_spikes[SELF_SPIKES_LENGTH];
  20:spinnaker_src/neuron.c **** 
  21:spinnaker_src/neuron.c **** uint32_t spike_record_offset=0;
  22:spinnaker_src/neuron.c **** uint32_t debug_record_offset=0;
  23:spinnaker_src/neuron.c **** 
  24:spinnaker_src/neuron.c **** extern uint32_t warnings;
  25:spinnaker_src/neuron.c **** 
  26:spinnaker_src/neuron.c **** extern uint32_t  work_load;
  27:spinnaker_src/neuron.c **** 
  28:spinnaker_src/neuron.c **** extern uint32_t do_pm;
  29:spinnaker_src/neuron.c **** 
  30:spinnaker_src/neuron.c **** extern uint32_t  pm_levels;
  31:spinnaker_src/neuron.c **** 
  32:spinnaker_src/neuron.c **** uint32_t debug_count15=0;
  33:spinnaker_src/neuron.c **** 
  34:spinnaker_src/neuron.c **** extern uint32_t fill_level;
  35:spinnaker_src/neuron.c **** uint32_t fill_level2=0;
  36:spinnaker_src/neuron.c **** 
  37:spinnaker_src/neuron.c **** extern uint32_t systicks_pm;
  38:spinnaker_src/neuron.c **** 
  39:spinnaker_src/neuron.c **** uint32_t time_done=0;
  40:spinnaker_src/neuron.c **** 
  41:spinnaker_src/neuron.c **** uint32_t time_done_last_tick=0;
  42:spinnaker_src/neuron.c **** 
  43:spinnaker_src/neuron.c **** uint32_t out_spike_count=0;
  44:spinnaker_src/neuron.c **** 
  45:spinnaker_src/neuron.c **** extern uint32_t pe_id;
  46:spinnaker_src/neuron.c **** extern uint32_t n_spikes_sent ;
  47:spinnaker_src/neuron.c **** #ifdef ENS_CORE
  48:spinnaker_src/neuron.c **** extern ensemble_t ensembles[N_ENSEMBLES];
  49:spinnaker_src/neuron.c **** extern uint32_t n_ensembles;
  50:spinnaker_src/neuron.c **** #endif
  51:spinnaker_src/neuron.c **** #ifdef INTER_CORE
  52:spinnaker_src/neuron.c **** extern intermediate_t inters[N_INTERS];
  53:spinnaker_src/neuron.c **** extern uint32_t n_inters;
  54:spinnaker_src/neuron.c **** #endif
  55:spinnaker_src/neuron.c **** #ifdef MESS_CORE
  56:spinnaker_src/neuron.c **** extern message_t mess[N_MESS];
  57:spinnaker_src/neuron.c **** extern uint32_t n_mess;
  58:spinnaker_src/neuron.c **** #endif
  59:spinnaker_src/neuron.c **** //extern REAL learning_activity[N_NEURONS];
  60:spinnaker_src/neuron.c **** bool neuron_initialise() {
  30              		.loc 1 60 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  61:spinnaker_src/neuron.c **** 
  62:spinnaker_src/neuron.c **** #ifdef ENS_CORE
  63:spinnaker_src/neuron.c **** 	precision_t v_membrane_init=0;
  64:spinnaker_src/neuron.c **** 	for (uint32_t i = 0 ; i < n_ensembles; i++){
  65:spinnaker_src/neuron.c **** 		for(uint32_t j = 0 ; j < ensembles[i].n_neurons; j++){
  66:spinnaker_src/neuron.c **** 			ensembles[i].neurons[j].V_membrane=v_membrane_init;
  67:spinnaker_src/neuron.c **** 			ensembles[i].neurons[j].refract_timer=0;
  68:spinnaker_src/neuron.c **** 		}
  69:spinnaker_src/neuron.c **** 	}	
  70:spinnaker_src/neuron.c **** #endif
  71:spinnaker_src/neuron.c ****     return true;
  72:spinnaker_src/neuron.c **** }
  35              		.loc 1 72 0
  36 0000 0120     		movs	r0, #1
  37 0002 7047     		bx	lr
  38              		.cfi_endproc
  39              	.LFE187:
  41              		.section	.text.router_spike,"ax",%progbits
  42              		.align	2
  43              		.global	router_spike
  44              		.thumb
  45              		.thumb_func
  47              	router_spike:
  48              	.LFB188:
  73:spinnaker_src/neuron.c **** 
  74:spinnaker_src/neuron.c **** void router_spike(uint32_t key, uint32_t payload) {
  49              		.loc 1 74 0
  50              		.cfi_startproc
  51              		@ args = 0, pretend = 0, frame = 0
  52              		@ frame_needed = 0, uses_anonymous_args = 0
  53              		@ link register save eliminated.
  54              	.LVL0:
  75:spinnaker_src/neuron.c ****     while ((comms[COMMS_TCTL] & 0x80000000) == 0) {
  55              		.loc 1 75 0
  56 0000 074A     		ldr	r2, .L7
  57              	.L3:
  58              		.loc 1 75 0 is_stmt 0 discriminator 1
  59 0002 1368     		ldr	r3, [r2]
  60 0004 002B     		cmp	r3, #0
  61 0006 FCDA     		bge	.L3
  74:spinnaker_src/neuron.c ****     while ((comms[COMMS_TCTL] & 0x80000000) == 0) {
  62              		.loc 1 74 0 is_stmt 1
  63 0008 10B4     		push	{r4}
  64              		.cfi_def_cfa_offset 4
  65              		.cfi_offset 4, -4
  76:spinnaker_src/neuron.c ****     }
  77:spinnaker_src/neuron.c ****     comms[COMMS_TDR_A_4] = payload; 
  78:spinnaker_src/neuron.c ****     comms[COMMS_TKR_A] =  key;
  66              		.loc 1 78 0
  67 000a 064B     		ldr	r3, .L7+4
  77:spinnaker_src/neuron.c ****     comms[COMMS_TKR_A] =  key;
  68              		.loc 1 77 0
  69 000c 064C     		ldr	r4, .L7+8
  79:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
  70              		.loc 1 79 0
  71 000e 074A     		ldr	r2, .L7+12
  77:spinnaker_src/neuron.c ****     comms[COMMS_TKR_A] =  key;
  72              		.loc 1 77 0
  73 0010 2160     		str	r1, [r4]
  78:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
  74              		.loc 1 78 0
  75 0012 1860     		str	r0, [r3]
  76              		.loc 1 79 0
  77 0014 1368     		ldr	r3, [r2]
  80:spinnaker_src/neuron.c **** }
  78              		.loc 1 80 0
  79 0016 5DF8044B 		ldr	r4, [sp], #4
  80              		.cfi_restore 4
  81              		.cfi_def_cfa_offset 0
  79:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
  82              		.loc 1 79 0
  83 001a 0133     		adds	r3, r3, #1
  84 001c 1360     		str	r3, [r2]
  85              		.loc 1 80 0
  86 001e 7047     		bx	lr
  87              	.L8:
  88              		.align	2
  89              	.L7:
  90 0020 7C0000E2 		.word	-503316356
  91 0024 140000E2 		.word	-503316460
  92 0028 100000E2 		.word	-503316464
  93 002c 00000000 		.word	n_spikes_sent
  94              		.cfi_endproc
  95              	.LFE188:
  97              		.section	.text.router_spike_a,"ax",%progbits
  98              		.align	2
  99              		.global	router_spike_a
 100              		.thumb
 101              		.thumb_func
 103              	router_spike_a:
 104              	.LFB189:
  81:spinnaker_src/neuron.c **** void router_spike_a(uint32_t key, uint32_t payload) {
 105              		.loc 1 81 0
 106              		.cfi_startproc
 107              		@ args = 0, pretend = 0, frame = 0
 108              		@ frame_needed = 0, uses_anonymous_args = 0
 109              		@ link register save eliminated.
 110              	.LVL1:
  82:spinnaker_src/neuron.c ****     while ((comms[COMMS_TCTL] & 0x80000000) == 0) {
 111              		.loc 1 82 0
 112 0000 074A     		ldr	r2, .L13
 113              	.L10:
 114              		.loc 1 82 0 is_stmt 0 discriminator 1
 115 0002 1368     		ldr	r3, [r2]
 116 0004 002B     		cmp	r3, #0
 117 0006 FCDA     		bge	.L10
  81:spinnaker_src/neuron.c **** void router_spike_a(uint32_t key, uint32_t payload) {
 118              		.loc 1 81 0 is_stmt 1
 119 0008 10B4     		push	{r4}
 120              		.cfi_def_cfa_offset 4
 121              		.cfi_offset 4, -4
  83:spinnaker_src/neuron.c ****     }
  84:spinnaker_src/neuron.c ****     comms[COMMS_TDR_A_4] = payload; 
  85:spinnaker_src/neuron.c ****     comms[COMMS_TKR_A] =  key;
 122              		.loc 1 85 0
 123 000a 064B     		ldr	r3, .L13+4
  84:spinnaker_src/neuron.c ****     comms[COMMS_TKR_A] =  key;
 124              		.loc 1 84 0
 125 000c 064C     		ldr	r4, .L13+8
  86:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 126              		.loc 1 86 0
 127 000e 074A     		ldr	r2, .L13+12
  84:spinnaker_src/neuron.c ****     comms[COMMS_TKR_A] =  key;
 128              		.loc 1 84 0
 129 0010 2160     		str	r1, [r4]
  85:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 130              		.loc 1 85 0
 131 0012 1860     		str	r0, [r3]
 132              		.loc 1 86 0
 133 0014 1368     		ldr	r3, [r2]
  87:spinnaker_src/neuron.c **** }
 134              		.loc 1 87 0
 135 0016 5DF8044B 		ldr	r4, [sp], #4
 136              		.cfi_restore 4
 137              		.cfi_def_cfa_offset 0
  86:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 138              		.loc 1 86 0
 139 001a 0133     		adds	r3, r3, #1
 140 001c 1360     		str	r3, [r2]
 141              		.loc 1 87 0
 142 001e 7047     		bx	lr
 143              	.L14:
 144              		.align	2
 145              	.L13:
 146 0020 7C0000E2 		.word	-503316356
 147 0024 140000E2 		.word	-503316460
 148 0028 100000E2 		.word	-503316464
 149 002c 00000000 		.word	n_spikes_sent
 150              		.cfi_endproc
 151              	.LFE189:
 153              		.section	.text.router_spike_b,"ax",%progbits
 154              		.align	2
 155              		.global	router_spike_b
 156              		.thumb
 157              		.thumb_func
 159              	router_spike_b:
 160              	.LFB190:
  88:spinnaker_src/neuron.c **** void router_spike_b(uint32_t key, uint32_t payload) {
 161              		.loc 1 88 0
 162              		.cfi_startproc
 163              		@ args = 0, pretend = 0, frame = 0
 164              		@ frame_needed = 0, uses_anonymous_args = 0
 165              		@ link register save eliminated.
 166              	.LVL2:
  89:spinnaker_src/neuron.c ****     while ((comms[COMMS_TCTL] & 0x80000000) == 0) {
 167              		.loc 1 89 0
 168 0000 074A     		ldr	r2, .L19
 169              	.L16:
 170              		.loc 1 89 0 is_stmt 0 discriminator 1
 171 0002 1368     		ldr	r3, [r2]
 172 0004 002B     		cmp	r3, #0
 173 0006 FCDA     		bge	.L16
  88:spinnaker_src/neuron.c **** void router_spike_b(uint32_t key, uint32_t payload) {
 174              		.loc 1 88 0 is_stmt 1
 175 0008 10B4     		push	{r4}
 176              		.cfi_def_cfa_offset 4
 177              		.cfi_offset 4, -4
  90:spinnaker_src/neuron.c ****     }
  91:spinnaker_src/neuron.c ****     comms[COMMS_TDR_B_4] = payload; 
  92:spinnaker_src/neuron.c ****     comms[COMMS_TKR_B] =  key;
 178              		.loc 1 92 0
 179 000a 064B     		ldr	r3, .L19+4
  91:spinnaker_src/neuron.c ****     comms[COMMS_TKR_B] =  key;
 180              		.loc 1 91 0
 181 000c 064C     		ldr	r4, .L19+8
  93:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 182              		.loc 1 93 0
 183 000e 074A     		ldr	r2, .L19+12
  91:spinnaker_src/neuron.c ****     comms[COMMS_TKR_B] =  key;
 184              		.loc 1 91 0
 185 0010 2160     		str	r1, [r4]
  92:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 186              		.loc 1 92 0
 187 0012 1860     		str	r0, [r3]
 188              		.loc 1 93 0
 189 0014 1368     		ldr	r3, [r2]
  94:spinnaker_src/neuron.c **** }
 190              		.loc 1 94 0
 191 0016 5DF8044B 		ldr	r4, [sp], #4
 192              		.cfi_restore 4
 193              		.cfi_def_cfa_offset 0
  93:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 194              		.loc 1 93 0
 195 001a 0133     		adds	r3, r3, #1
 196 001c 1360     		str	r3, [r2]
 197              		.loc 1 94 0
 198 001e 7047     		bx	lr
 199              	.L20:
 200              		.align	2
 201              	.L19:
 202 0020 7C0000E2 		.word	-503316356
 203 0024 340000E2 		.word	-503316428
 204 0028 300000E2 		.word	-503316432
 205 002c 00000000 		.word	n_spikes_sent
 206              		.cfi_endproc
 207              	.LFE190:
 209              		.section	.text.router_spike_c,"ax",%progbits
 210              		.align	2
 211              		.global	router_spike_c
 212              		.thumb
 213              		.thumb_func
 215              	router_spike_c:
 216              	.LFB191:
  95:spinnaker_src/neuron.c **** void router_spike_c(uint32_t key, uint32_t payload) {
 217              		.loc 1 95 0
 218              		.cfi_startproc
 219              		@ args = 0, pretend = 0, frame = 0
 220              		@ frame_needed = 0, uses_anonymous_args = 0
 221              		@ link register save eliminated.
 222              	.LVL3:
  96:spinnaker_src/neuron.c ****     while ((comms[COMMS_TCTL] & 0x80000000) == 0) {
 223              		.loc 1 96 0
 224 0000 074A     		ldr	r2, .L25
 225              	.L22:
 226              		.loc 1 96 0 is_stmt 0 discriminator 1
 227 0002 1368     		ldr	r3, [r2]
 228 0004 002B     		cmp	r3, #0
 229 0006 FCDA     		bge	.L22
  95:spinnaker_src/neuron.c **** void router_spike_c(uint32_t key, uint32_t payload) {
 230              		.loc 1 95 0 is_stmt 1
 231 0008 10B4     		push	{r4}
 232              		.cfi_def_cfa_offset 4
 233              		.cfi_offset 4, -4
  97:spinnaker_src/neuron.c ****     }
  98:spinnaker_src/neuron.c ****     comms[COMMS_TDR_C_4] = payload; 
  99:spinnaker_src/neuron.c ****     comms[COMMS_TKR_C] =  key;
 234              		.loc 1 99 0
 235 000a 064B     		ldr	r3, .L25+4
  98:spinnaker_src/neuron.c ****     comms[COMMS_TKR_C] =  key;
 236              		.loc 1 98 0
 237 000c 064C     		ldr	r4, .L25+8
 100:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 238              		.loc 1 100 0
 239 000e 074A     		ldr	r2, .L25+12
  98:spinnaker_src/neuron.c ****     comms[COMMS_TKR_C] =  key;
 240              		.loc 1 98 0
 241 0010 2160     		str	r1, [r4]
  99:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 242              		.loc 1 99 0
 243 0012 1860     		str	r0, [r3]
 244              		.loc 1 100 0
 245 0014 1368     		ldr	r3, [r2]
 101:spinnaker_src/neuron.c **** }
 246              		.loc 1 101 0
 247 0016 5DF8044B 		ldr	r4, [sp], #4
 248              		.cfi_restore 4
 249              		.cfi_def_cfa_offset 0
 100:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 250              		.loc 1 100 0
 251 001a 0133     		adds	r3, r3, #1
 252 001c 1360     		str	r3, [r2]
 253              		.loc 1 101 0
 254 001e 7047     		bx	lr
 255              	.L26:
 256              		.align	2
 257              	.L25:
 258 0020 7C0000E2 		.word	-503316356
 259 0024 540000E2 		.word	-503316396
 260 0028 500000E2 		.word	-503316400
 261 002c 00000000 		.word	n_spikes_sent
 262              		.cfi_endproc
 263              	.LFE191:
 265              		.section	.text.router_spike_d,"ax",%progbits
 266              		.align	2
 267              		.global	router_spike_d
 268              		.thumb
 269              		.thumb_func
 271              	router_spike_d:
 272              	.LFB192:
 102:spinnaker_src/neuron.c **** void router_spike_d(uint32_t key, uint32_t payload) {
 273              		.loc 1 102 0
 274              		.cfi_startproc
 275              		@ args = 0, pretend = 0, frame = 0
 276              		@ frame_needed = 0, uses_anonymous_args = 0
 277              		@ link register save eliminated.
 278              	.LVL4:
 103:spinnaker_src/neuron.c ****     while ((comms[COMMS_TCTL] & 0x80000000) == 0) {
 279              		.loc 1 103 0
 280 0000 074A     		ldr	r2, .L31
 281              	.L28:
 282              		.loc 1 103 0 is_stmt 0 discriminator 1
 283 0002 1368     		ldr	r3, [r2]
 284 0004 002B     		cmp	r3, #0
 285 0006 FCDA     		bge	.L28
 102:spinnaker_src/neuron.c **** void router_spike_d(uint32_t key, uint32_t payload) {
 286              		.loc 1 102 0 is_stmt 1
 287 0008 10B4     		push	{r4}
 288              		.cfi_def_cfa_offset 4
 289              		.cfi_offset 4, -4
 104:spinnaker_src/neuron.c ****     }
 105:spinnaker_src/neuron.c ****     comms[COMMS_TDR_D_4] = payload; 
 106:spinnaker_src/neuron.c ****     comms[COMMS_TKR_D] =  key;
 290              		.loc 1 106 0
 291 000a 064B     		ldr	r3, .L31+4
 105:spinnaker_src/neuron.c ****     comms[COMMS_TKR_D] =  key;
 292              		.loc 1 105 0
 293 000c 064C     		ldr	r4, .L31+8
 107:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 294              		.loc 1 107 0
 295 000e 074A     		ldr	r2, .L31+12
 105:spinnaker_src/neuron.c ****     comms[COMMS_TKR_D] =  key;
 296              		.loc 1 105 0
 297 0010 2160     		str	r1, [r4]
 106:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 298              		.loc 1 106 0
 299 0012 1860     		str	r0, [r3]
 300              		.loc 1 107 0
 301 0014 1368     		ldr	r3, [r2]
 108:spinnaker_src/neuron.c **** }
 302              		.loc 1 108 0
 303 0016 5DF8044B 		ldr	r4, [sp], #4
 304              		.cfi_restore 4
 305              		.cfi_def_cfa_offset 0
 107:spinnaker_src/neuron.c ****     n_spikes_sent += 1;
 306              		.loc 1 107 0
 307 001a 0133     		adds	r3, r3, #1
 308 001c 1360     		str	r3, [r2]
 309              		.loc 1 108 0
 310 001e 7047     		bx	lr
 311              	.L32:
 312              		.align	2
 313              	.L31:
 314 0020 7C0000E2 		.word	-503316356
 315 0024 740000E2 		.word	-503316364
 316 0028 700000E2 		.word	-503316368
 317 002c 00000000 		.word	n_spikes_sent
 318              		.cfi_endproc
 319              	.LFE192:
 321              		.section	.text.self_spike,"ax",%progbits
 322              		.align	2
 323              		.global	self_spike
 324              		.thumb
 325              		.thumb_func
 327              	self_spike:
 328              	.LFB193:
 109:spinnaker_src/neuron.c **** void self_spike(uint32_t key, uint32_t payload){
 329              		.loc 1 109 0
 330              		.cfi_startproc
 331              		@ args = 0, pretend = 0, frame = 0
 332              		@ frame_needed = 0, uses_anonymous_args = 0
 333              		@ link register save eliminated.
 334              	.LVL5:
 335 0000 70B4     		push	{r4, r5, r6}
 336              		.cfi_def_cfa_offset 12
 337              		.cfi_offset 4, -12
 338              		.cfi_offset 5, -8
 339              		.cfi_offset 6, -4
 110:spinnaker_src/neuron.c **** 
 111:spinnaker_src/neuron.c **** 	self_spikes[self_spike_counter] = key;
 340              		.loc 1 111 0
 341 0002 094D     		ldr	r5, .L37
 342 0004 094C     		ldr	r4, .L37+4
 343 0006 2B68     		ldr	r3, [r5]
 112:spinnaker_src/neuron.c **** 	self_spike_counter++;
 113:spinnaker_src/neuron.c **** 	self_spikes[self_spike_counter] = payload;
 114:spinnaker_src/neuron.c **** 	self_spike_counter++;
 344              		.loc 1 114 0
 345 0008 9A1C     		adds	r2, r3, #2
 113:spinnaker_src/neuron.c **** 	self_spike_counter++;
 346              		.loc 1 113 0
 347 000a 5E1C     		adds	r6, r3, #1
 115:spinnaker_src/neuron.c **** 
 116:spinnaker_src/neuron.c **** 	if(self_spike_counter>=SELF_SPIKES_LENGTH){
 348              		.loc 1 116 0
 349 000c 0F2A     		cmp	r2, #15
 111:spinnaker_src/neuron.c **** 	self_spike_counter++;
 350              		.loc 1 111 0
 351 000e 44F82300 		str	r0, [r4, r3, lsl #2]
 114:spinnaker_src/neuron.c **** 
 352              		.loc 1 114 0
 353 0012 2A60     		str	r2, [r5]
 113:spinnaker_src/neuron.c **** 	self_spike_counter++;
 354              		.loc 1 113 0
 355 0014 44F82610 		str	r1, [r4, r6, lsl #2]
 356              		.loc 1 116 0
 357 0018 01D8     		bhi	.L36
 117:spinnaker_src/neuron.c **** 		log_info("ERROR: self spike counter overflow\n");
 118:spinnaker_src/neuron.c **** 	}
 119:spinnaker_src/neuron.c **** }
 358              		.loc 1 119 0
 359 001a 70BC     		pop	{r4, r5, r6}
 360              		.cfi_remember_state
 361              		.cfi_restore 6
 362              		.cfi_restore 5
 363              		.cfi_restore 4
 364              		.cfi_def_cfa_offset 0
 365 001c 7047     		bx	lr
 366              	.L36:
 367              		.cfi_restore_state
 117:spinnaker_src/neuron.c **** 		log_info("ERROR: self spike counter overflow\n");
 368              		.loc 1 117 0
 369 001e 0448     		ldr	r0, .L37+8
 370              	.LVL6:
 371              		.loc 1 119 0
 372 0020 70BC     		pop	{r4, r5, r6}
 373              		.cfi_restore 6
 374              		.cfi_restore 5
 375              		.cfi_restore 4
 376              		.cfi_def_cfa_offset 0
 377              	.LVL7:
 117:spinnaker_src/neuron.c **** 		log_info("ERROR: self spike counter overflow\n");
 378              		.loc 1 117 0
 379 0022 FFF7FEBF 		b	log_info
 380              	.LVL8:
 381              	.L38:
 382 0026 00BF     		.align	2
 383              	.L37:
 384 0028 00000000 		.word	self_spike_counter
 385 002c 00000000 		.word	self_spikes
 386 0030 00000000 		.word	.LC0
 387              		.cfi_endproc
 388              	.LFE193:
 390              		.section	.text.log1p_acc,"ax",%progbits
 391              		.align	2
 392              		.global	log1p_acc
 393              		.thumb
 394              		.thumb_func
 396              	log1p_acc:
 397              	.LFB194:
 120:spinnaker_src/neuron.c **** 
 121:spinnaker_src/neuron.c **** 
 122:spinnaker_src/neuron.c **** REAL log1p_acc(REAL x){
 398              		.loc 1 122 0
 399              		.cfi_startproc
 400              		@ args = 0, pretend = 0, frame = 0
 401              		@ frame_needed = 0, uses_anonymous_args = 0
 402              		@ link register save eliminated.
 403              	.LVL9:
 123:spinnaker_src/neuron.c **** 	nmu_log_calc((fixpt_s1615)((x+1)*((int32_t)(1<<15))));//no unit
 404              		.loc 1 123 0
 405 0000 F7EE007A 		fconsts	s15, #112
 406 0004 30EE270A 		fadds	s0, s0, s15
 407              	.LVL10:
 408              	.LBB6:
 409              	.LBB7:
 410              		.file 2 "/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h"
   1:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
   2:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #ifndef __NMU_H__
   3:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #define __NMU_H__
   4:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
   5:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #ifdef __cplusplus
   6:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****  extern "C" {
   7:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #endif
   8:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
   9:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include <constants.h>
  10:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include <stdint.h>
  11:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include <stdbool.h>
  12:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include "fixedpoint.h"
  13:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include "qpe-types.h"
  14:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include "attributes.h"
  15:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #include "assert.h"
  16:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  17:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #ifndef DOXYGEN
  18:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #define TO_BOOL(x) ((x) ? 1 : 0)
  19:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #endif
  20:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  21:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @ingroup qpe
  22:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @defgroup nmu_wrap Neuromorphic Math Unit (NMU)
  23:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Wrapper Function of Neuromorphic Math Unit (NMU).
  24:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //!
  25:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! Includes:
  26:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //!  - **Hardware Exponential**
  27:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //!  - **Random Number Generator**
  28:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @{
  29:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  30:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** typedef union {
  31:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     float f;
  32:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t w;
  33:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** } float_word_t;
  34:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  35:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Convert floating point value to the fixpoint (s1615) value
  36:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline int32_t float2fxpt (float arg)
  37:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
  38:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #if 1
  39:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     /* faster and simpler one: */
  40:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return (int32_t)(arg*32768.0);
  41:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #else
  42:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     float_word_t a;
  43:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     a.f = arg;
  44:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t exp = ((a.w>>23)&0xff)-127;
  45:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t s = 23-15-exp;
  46:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t fxpt = (0x00800000|(a.w&0x007fffff)) >> s;
  47:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     if (a.w& 0x80000000) {
  48:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         fxpt = -fxpt;
  49:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     }
  50:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return fxpt;
  51:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #endif
  52:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
  53:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  54:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Convert fixpoint (s1615) value to floatingpoint value
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline float fxpt2float (int arg)
  56:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
  57:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #if 1
  58:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     /* faster and simpler one: */
  59:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return ((float)arg)/32768.0;
  60:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #else 
  61:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     float_word_t res;
  62:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     res.w = arg;
  63:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t lz = __CLZ (res.w);
  64:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     if (unlikely (lz < 8)) {
  65:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         /* discard bits */
  66:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w >>= (8-lz);
  67:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w &= 0x007fffff;
  68:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w |= (127+16-lz)<<23;
  69:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         return res.f;
  70:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     } else {
  71:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         /* padding */
  72:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w <<= (lz-8);
  73:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w &= 0x007fffff;
  74:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w |= (127+16-lz)<<23;
  75:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         return res.f;
  76:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     }
  77:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #endif
  78:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
  79:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  80:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @name Exponential acceleration unit
  81:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @{
  82:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Pipelined access to the hardware exponential function accelerator.
  83:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! The pipeline deep is 4.
  84:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //!
  85:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  86:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Push one argument to the exp acceleration.
  87:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //!  @see Globalvariable NMU_EXP
  88:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline void nmu_exp_calc (fixpt_s1615 x)
  89:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
  90:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 	*NMU_EXP = x;
  91:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
  92:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  93:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline void nmu_log_calc (fixpt_s1615 x)
  94:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
  95:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 	*NMU_LOG = x;
 411              		.loc 2 95 0
 412 0008 044B     		ldr	r3, .L40
 413              	.LBE7:
 414              	.LBE6:
 415              		.loc 1 123 0
 416 000a BEEEE80A 		vcvt.s32.f32	s0, s0, #15
 417              	.LVL11:
 418              	.LBB9:
 419              	.LBB8:
 420              		.loc 2 95 0
 421 000e 83ED000A 		fsts	s0, [r3]	@ int
 422              	.LBE8:
 423              	.LBE9:
 424              	.LBB10:
 425              	.LBB11:
  96:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
  97:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
  98:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Fetch argument of the exp acceleration.
  99:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @see Globalvariable NMU_EXP
 100:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline fixpt_s1615 nmu_exp_fetch (void)
 101:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
 102:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return *NMU_EXP;
 103:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
 104:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 105:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline fixpt_s1615 nmu_log_fetch (void)
 106:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
 107:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return *NMU_LOG;
 426              		.loc 2 107 0
 427 0012 93ED000A 		flds	s0, [r3]	@ int
 428              	.LVL12:
 429              	.LBE11:
 430              	.LBE10:
 124:spinnaker_src/neuron.c **** 	return (((REAL)nmu_log_fetch())/(int32_t)(1<<15));
 125:spinnaker_src/neuron.c **** 
 126:spinnaker_src/neuron.c **** }
 431              		.loc 1 126 0
 432 0016 BAEEE80A 		vcvt.f32.s32	s0, s0, #15
 433 001a 7047     		bx	lr
 434              	.L41:
 435              		.align	2
 436              	.L40:
 437 001c 0C0110E0 		.word	-535822068
 438              		.cfi_endproc
 439              	.LFE194:
 441              		.section	.text.record_spike,"ax",%progbits
 442              		.align	2
 443              		.global	record_spike
 444              		.thumb
 445              		.thumb_func
 447              	record_spike:
 448              	.LFB195:
 127:spinnaker_src/neuron.c **** 
 128:spinnaker_src/neuron.c **** 
 129:spinnaker_src/neuron.c **** #ifdef ENS_CORE
 130:spinnaker_src/neuron.c **** void clear_output(ensemble_t ens){
 131:spinnaker_src/neuron.c **** 
 132:spinnaker_src/neuron.c **** 	for (uint32_t i = 0; i < ens.n_outputs; i++){
 133:spinnaker_src/neuron.c **** 		ens.outputs[i]=0;
 134:spinnaker_src/neuron.c **** 	}
 135:spinnaker_src/neuron.c **** }
 136:spinnaker_src/neuron.c **** void neuron_do_timestep_update(ensemble_t ens) {
 137:spinnaker_src/neuron.c **** 
 138:spinnaker_src/neuron.c **** 	clear_output(ens);
 139:spinnaker_src/neuron.c **** 	//log_info("%#010x\n",*(uint32_t*)&ens.outputs[0]);
 140:spinnaker_src/neuron.c ****     for (index_t neuron_index = 0; neuron_index < ens.n_neurons; neuron_index++) {
 141:spinnaker_src/neuron.c ****         
 142:spinnaker_src/neuron.c **** 		neuron_pointer_t neuron = &ens.neurons[neuron_index];
 143:spinnaker_src/neuron.c ****         
 144:spinnaker_src/neuron.c ****         REAL result = neuron_model_state_update(
 145:spinnaker_src/neuron.c ****             (REAL)(ens.input_currents[neuron_index]), neuron,(REAL) ens.tau_rc);
 146:spinnaker_src/neuron.c **** 
 147:spinnaker_src/neuron.c **** 		//if(ens.obj_id == 1 && systicks <= 20 && neuron_index == 90){
 148:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",*(uint32_t*)&(ens.neurons[neuron_index].V_membrane));
 149:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",*(uint32_t*)&(ens.input_currents[neuron_index]));
 150:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",*(uint32_t*)&(neuron->V_membrane));
 151:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",(uint32_t)&(ens.neurons[neuron_index].V_membrane));
 152:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",(uint32_t)&(ens.input_currents[neuron_index]));
 153:spinnaker_src/neuron.c **** 		//}
 154:spinnaker_src/neuron.c **** 		//debug!
 155:spinnaker_src/neuron.c **** 		/*
 156:spinnaker_src/neuron.c **** 		if(systicks==2 && neuron_index == 8){
 157:spinnaker_src/neuron.c **** 		    log_info("voltage 8: %#010x\n",*(uint32_t*)&result);	
 158:spinnaker_src/neuron.c **** 		    log_info("current 8: %#010x\n",*(uint32_t*)&input_current[8]);	
 159:spinnaker_src/neuron.c **** 		}
 160:spinnaker_src/neuron.c **** 		*/
 161:spinnaker_src/neuron.c **** 
 162:spinnaker_src/neuron.c **** 		//TODO learning with ensembles
 163:spinnaker_src/neuron.c **** 		if(ens.learning_enabled){
 164:spinnaker_src/neuron.c **** 			ens.learning_activity[neuron_index]*=(1- ens.learning_scale);
 165:spinnaker_src/neuron.c **** 		}
 166:spinnaker_src/neuron.c ****         
 167:spinnaker_src/neuron.c **** 		/*
 168:spinnaker_src/neuron.c **** 		if(ens.obj_id == 0 && systicks == 10 && neuron_index == 78){
 169:spinnaker_src/neuron.c **** 		
 170:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",*(uint32_t*)&ens.outputs[0]);
 171:spinnaker_src/neuron.c **** 			//log_info("id %d\n",neuron_index);
 172:spinnaker_src/neuron.c **** 			log_info("%#010x\n",*(uint32_t*)&result);
 173:spinnaker_src/neuron.c **** 		}
 174:spinnaker_src/neuron.c **** 		*/
 175:spinnaker_src/neuron.c **** 		if(result>1){
 176:spinnaker_src/neuron.c ****             
 177:spinnaker_src/neuron.c **** 			//TODO log acc
 178:spinnaker_src/neuron.c **** 			REAL log_result = log1pf(-((REAL)neuron->V_membrane-1)/((REAL)ens.input_currents[neuron_index]-1
 179:spinnaker_src/neuron.c **** 			//REAL log_result = log1p_acc(-(neuron->V_membrane-1)/(ens.input_currents[neuron_index]-1));
 180:spinnaker_src/neuron.c **** 			REAL t_spike = 1 + (REAL) ens.tau_rc * log_result ;
 181:spinnaker_src/neuron.c ****             neuron->refract_timer =(precision_t) ((REAL)ens.tau_ref + t_spike );
 182:spinnaker_src/neuron.c **** 
 183:spinnaker_src/neuron.c **** 			neuron->V_membrane = 0;
 184:spinnaker_src/neuron.c **** 
 185:spinnaker_src/neuron.c **** 			//TODO learning with ensembles
 186:spinnaker_src/neuron.c **** 			if(ens.learning_enabled){
 187:spinnaker_src/neuron.c **** 				ens.learning_activity[neuron_index]+=(ens.learning_scale);
 188:spinnaker_src/neuron.c **** 				
 189:spinnaker_src/neuron.c **** 				//log_info("%d\n",neuron_index);
 190:spinnaker_src/neuron.c **** 			}
 191:spinnaker_src/neuron.c **** 			encode_vec_add(ens.outputs, &ens.decoders[neuron_index*ens.n_outputs],ens.n_outputs);
 192:spinnaker_src/neuron.c **** 			
 193:spinnaker_src/neuron.c **** 			//log_info("%#010x\n",*(uint32_t*)&ens.outputs[0]);
 194:spinnaker_src/neuron.c **** 			/*
 195:spinnaker_src/neuron.c **** 			if(ens.obj_id == 1 && systicks <= 20 && neuron_index == 10){
 196:spinnaker_src/neuron.c **** 				//log_info(" v10 %#010x\n",*(uint32_t*)&ens.neurons[10].V_membrane);
 197:spinnaker_src/neuron.c **** 				log_info("time: %d, log_result: %#010x\n",systicks,*(uint32_t*)&(log_result));
 198:spinnaker_src/neuron.c **** 				log_info("time: %d, t_spike: %#010x\n",systicks,*(uint32_t*)&(t_spike));
 199:spinnaker_src/neuron.c **** 			}
 200:spinnaker_src/neuron.c **** 			*/
 201:spinnaker_src/neuron.c ****         }
 202:spinnaker_src/neuron.c **** 	}
 203:spinnaker_src/neuron.c **** 	
 204:spinnaker_src/neuron.c **** 	
 205:spinnaker_src/neuron.c **** 	//debug! all in sram
 206:spinnaker_src/neuron.c ****     //send_spike_record();
 207:spinnaker_src/neuron.c **** 	neuron_send_spikes(ens);
 208:spinnaker_src/neuron.c **** }
 209:spinnaker_src/neuron.c **** 
 210:spinnaker_src/neuron.c **** extern uint32_t n_packets_received ;
 211:spinnaker_src/neuron.c **** void neuron_send_spikes(ensemble_t ens){
 212:spinnaker_src/neuron.c **** 
 213:spinnaker_src/neuron.c **** 	//TODO power management
 214:spinnaker_src/neuron.c **** 	//if(meas_type == ONLY10_SYN || meas_type == ONLY07_SYN || meas_type == DVFS_SYN ){
 215:spinnaker_src/neuron.c **** 		//send_spikes(ens);
 216:spinnaker_src/neuron.c **** 	//}
 217:spinnaker_src/neuron.c **** 	//clear_spike_record();
 218:spinnaker_src/neuron.c **** 
 219:spinnaker_src/neuron.c **** 	/*
 220:spinnaker_src/neuron.c **** 	uint32_t* address ;
 221:spinnaker_src/neuron.c **** 	address =(uint32_t*) IF_CURR_EXP_EXT_BASE; 
 222:spinnaker_src/neuron.c **** 	*/
 223:spinnaker_src/neuron.c **** 	for (uint32_t packet_count = 0; packet_count < ens.n_outputs; packet_count++){
 224:spinnaker_src/neuron.c **** 
 225:spinnaker_src/neuron.c **** 		uint32_t key; 
 226:spinnaker_src/neuron.c **** 		key =( packet_count << VALUE_ID_SHIFT) | (ens.obj_id << ENS_ID_SHIFT) | (pe_id << CORE_ID_SHIFT);
 227:spinnaker_src/neuron.c **** 		uint32_t payload;
 228:spinnaker_src/neuron.c **** 		conv_i_f conv;
 229:spinnaker_src/neuron.c **** 		conv.f=(REAL) ens.outputs[packet_count];
 230:spinnaker_src/neuron.c **** 		payload = conv.i;
 231:spinnaker_src/neuron.c **** 		//log_info("%#010x\n", payload);
 232:spinnaker_src/neuron.c **** 		//debug! real time comm
 233:spinnaker_src/neuron.c **** 		//if(systicks == 1){
 234:spinnaker_src/neuron.c **** 		router_spike(key,payload);
 235:spinnaker_src/neuron.c **** 
 236:spinnaker_src/neuron.c **** 		
 237:spinnaker_src/neuron.c **** 		/*
 238:spinnaker_src/neuron.c **** 		address++;
 239:spinnaker_src/neuron.c **** 		*address = key;
 240:spinnaker_src/neuron.c **** 		address++;
 241:spinnaker_src/neuron.c **** 		*address = payload;
 242:spinnaker_src/neuron.c **** 		address++;
 243:spinnaker_src/neuron.c **** 		*/
 244:spinnaker_src/neuron.c **** 
 245:spinnaker_src/neuron.c **** 		//}
 246:spinnaker_src/neuron.c **** 
 247:spinnaker_src/neuron.c **** 	}
 248:spinnaker_src/neuron.c **** 	/*
 249:spinnaker_src/neuron.c **** 	address =(uint32_t*) IF_CURR_EXP_EXT_BASE; 
 250:spinnaker_src/neuron.c **** 	*address = 1;
 251:spinnaker_src/neuron.c **** 	*/
 252:spinnaker_src/neuron.c **** }
 253:spinnaker_src/neuron.c **** #endif
 254:spinnaker_src/neuron.c **** #ifdef INTER_CORE
 255:spinnaker_src/neuron.c **** 
 256:spinnaker_src/neuron.c **** void inter_do_timestep_update(intermediate_t inter){
 257:spinnaker_src/neuron.c **** 
 258:spinnaker_src/neuron.c **** 	for (uint32_t packet_count = 0; packet_count < inter.size; packet_count++){
 259:spinnaker_src/neuron.c **** 
 260:spinnaker_src/neuron.c **** 		uint32_t key; 
 261:spinnaker_src/neuron.c **** 		key =( packet_count  << VALUE_ID_SHIFT)| (inter.obj_id << ENS_ID_SHIFT) | (pe_id << CORE_ID_SHIFT
 262:spinnaker_src/neuron.c **** 		uint32_t payload;
 263:spinnaker_src/neuron.c **** 		conv_i_f conv;
 264:spinnaker_src/neuron.c **** 		conv.f=(REAL) inter.inputs[packet_count];
 265:spinnaker_src/neuron.c **** 		payload = conv.i;
 266:spinnaker_src/neuron.c **** 		router_spike(key,payload);
 267:spinnaker_src/neuron.c **** 		
 268:spinnaker_src/neuron.c **** 		/*	
 269:spinnaker_src/neuron.c **** 		if(inter.obj_id == 24){
 270:spinnaker_src/neuron.c **** 			//log_info("time: %d , sent %#010x\n",systicks, payload);
 271:spinnaker_src/neuron.c **** 			log_info("%#010x\n",payload);
 272:spinnaker_src/neuron.c **** 		}
 273:spinnaker_src/neuron.c **** 		*/	
 274:spinnaker_src/neuron.c **** 		
 275:spinnaker_src/neuron.c **** 		
 276:spinnaker_src/neuron.c **** 
 277:spinnaker_src/neuron.c **** 	}
 278:spinnaker_src/neuron.c **** 
 279:spinnaker_src/neuron.c **** }
 280:spinnaker_src/neuron.c **** #endif
 281:spinnaker_src/neuron.c **** #ifdef MESS_CORE
 282:spinnaker_src/neuron.c **** 
 283:spinnaker_src/neuron.c **** void mess_do_timestep_update(message_t mess){
 284:spinnaker_src/neuron.c **** 
 285:spinnaker_src/neuron.c **** 	for (uint32_t packet_count = 0; packet_count < mess.post_len; packet_count++){
 286:spinnaker_src/neuron.c **** 
 287:spinnaker_src/neuron.c **** 		uint32_t key; 
 288:spinnaker_src/neuron.c **** 		key =( (mess.post_start+packet_count)  << VALUE_ID_SHIFT)| (mess.post_obj_id << ENS_ID_SHIFT) | (
 289:spinnaker_src/neuron.c **** 		uint32_t payload;
 290:spinnaker_src/neuron.c **** 		conv_i_f conv;
 291:spinnaker_src/neuron.c **** 		conv.f=(REAL) mess.post_values[packet_count];
 292:spinnaker_src/neuron.c **** 		payload = conv.i;
 293:spinnaker_src/neuron.c **** 		//TODO
 294:spinnaker_src/neuron.c **** 		router_spike_d(key,payload);
 295:spinnaker_src/neuron.c **** 
 296:spinnaker_src/neuron.c **** 		
 297:spinnaker_src/neuron.c **** 		
 298:spinnaker_src/neuron.c **** 		/*
 299:spinnaker_src/neuron.c **** 		if(mess.mess_id == 18){
 300:spinnaker_src/neuron.c **** 			log_info("time: %d , key: %#010x, payload: %#010x\n",systicks, key, payload);
 301:spinnaker_src/neuron.c **** 		}
 302:spinnaker_src/neuron.c **** 		*/
 303:spinnaker_src/neuron.c **** 		
 304:spinnaker_src/neuron.c **** 		
 305:spinnaker_src/neuron.c **** 	}
 306:spinnaker_src/neuron.c **** 
 307:spinnaker_src/neuron.c **** }
 308:spinnaker_src/neuron.c **** #endif
 309:spinnaker_src/neuron.c **** 
 310:spinnaker_src/neuron.c **** void record_spike(uint32_t neuron_id){
 449              		.loc 1 310 0
 450              		.cfi_startproc
 451              		@ args = 0, pretend = 0, frame = 0
 452              		@ frame_needed = 0, uses_anonymous_args = 0
 453              		@ link register save eliminated.
 454              	.LVL13:
 311:spinnaker_src/neuron.c **** 
 312:spinnaker_src/neuron.c **** 	spike_records[neuron_id/32+2] |= 1 << ( neuron_id - neuron_id/32*32);
 455              		.loc 1 312 0
 456 0000 4309     		lsrs	r3, r0, #5
 310:spinnaker_src/neuron.c **** 
 457              		.loc 1 310 0
 458 0002 F0B4     		push	{r4, r5, r6, r7}
 459              		.cfi_def_cfa_offset 16
 460              		.cfi_offset 4, -16
 461              		.cfi_offset 5, -12
 462              		.cfi_offset 6, -8
 463              		.cfi_offset 7, -4
 464              		.loc 1 312 0
 465 0004 9F1C     		adds	r7, r3, #2
 466 0006 094E     		ldr	r6, .L44
 313:spinnaker_src/neuron.c **** 	spike_records_count[neuron_id/32]++;
 467              		.loc 1 313 0
 468 0008 094D     		ldr	r5, .L44+4
 312:spinnaker_src/neuron.c **** 	spike_records_count[neuron_id/32]++;
 469              		.loc 1 312 0
 470 000a 56F82710 		ldr	r1, [r6, r7, lsl #2]
 471              		.loc 1 313 0
 472 000e 55F82320 		ldr	r2, [r5, r3, lsl #2]
 312:spinnaker_src/neuron.c **** 	spike_records_count[neuron_id/32]++;
 473              		.loc 1 312 0
 474 0012 0124     		movs	r4, #1
 475 0014 00F01F00 		and	r0, r0, #31
 476              	.LVL14:
 477 0018 04FA00F0 		lsl	r0, r4, r0
 478              		.loc 1 313 0
 479 001c 2244     		add	r2, r2, r4
 312:spinnaker_src/neuron.c **** 	spike_records_count[neuron_id/32]++;
 480              		.loc 1 312 0
 481 001e 0143     		orrs	r1, r1, r0
 482 0020 46F82710 		str	r1, [r6, r7, lsl #2]
 483              		.loc 1 313 0
 484 0024 45F82320 		str	r2, [r5, r3, lsl #2]
 314:spinnaker_src/neuron.c **** 
 315:spinnaker_src/neuron.c **** }
 485              		.loc 1 315 0
 486 0028 F0BC     		pop	{r4, r5, r6, r7}
 487              		.cfi_restore 7
 488              		.cfi_restore 6
 489              		.cfi_restore 5
 490              		.cfi_restore 4
 491              		.cfi_def_cfa_offset 0
 492 002a 7047     		bx	lr
 493              	.L45:
 494              		.align	2
 495              	.L44:
 496 002c 00000000 		.word	spike_records
 497 0030 00000000 		.word	spike_records_count
 498              		.cfi_endproc
 499              	.LFE195:
 501              		.section	.text.send_spike_record,"ax",%progbits
 502              		.align	2
 503              		.global	send_spike_record
 504              		.thumb
 505              		.thumb_func
 507              	send_spike_record:
 508              	.LFB196:
 316:spinnaker_src/neuron.c **** 
 317:spinnaker_src/neuron.c **** void send_spike_record(){
 509              		.loc 1 317 0
 510              		.cfi_startproc
 511              		@ args = 0, pretend = 0, frame = 0
 512              		@ frame_needed = 0, uses_anonymous_args = 0
 318:spinnaker_src/neuron.c **** 
 319:spinnaker_src/neuron.c **** 	spike_records[0]=pe_id;
 320:spinnaker_src/neuron.c **** 	spike_records[1]=systicks;
 321:spinnaker_src/neuron.c **** 	spike_records[10]=warnings;
 322:spinnaker_src/neuron.c **** 	spike_records[11]=pm_levels| (time_done_last_tick << 8)| (fill_level << 16) | (fill_level2 << 24);
 513              		.loc 1 322 0
 514 0000 164A     		ldr	r2, .L51
 515 0002 174B     		ldr	r3, .L51+4
 516 0004 1068     		ldr	r0, [r2]
 320:spinnaker_src/neuron.c **** 	spike_records[10]=warnings;
 517              		.loc 1 320 0
 518 0006 174A     		ldr	r2, .L51+8
 519              		.loc 1 322 0
 520 0008 1B68     		ldr	r3, [r3]
 319:spinnaker_src/neuron.c **** 	spike_records[1]=systicks;
 521              		.loc 1 319 0
 522 000a 1749     		ldr	r1, .L51+12
 317:spinnaker_src/neuron.c **** 
 523              		.loc 1 317 0
 524 000c 2DE9F041 		push	{r4, r5, r6, r7, r8, lr}
 525              		.cfi_def_cfa_offset 24
 526              		.cfi_offset 4, -24
 527              		.cfi_offset 5, -20
 528              		.cfi_offset 6, -16
 529              		.cfi_offset 7, -12
 530              		.cfi_offset 8, -8
 531              		.cfi_offset 14, -4
 319:spinnaker_src/neuron.c **** 	spike_records[1]=systicks;
 532              		.loc 1 319 0
 533 0010 164D     		ldr	r5, .L51+16
 320:spinnaker_src/neuron.c **** 	spike_records[10]=warnings;
 534              		.loc 1 320 0
 535 0012 1468     		ldr	r4, [r2]
 536              		.loc 1 322 0
 537 0014 164F     		ldr	r7, .L51+20
 320:spinnaker_src/neuron.c **** 	spike_records[10]=warnings;
 538              		.loc 1 320 0
 539 0016 6C60     		str	r4, [r5, #4]
 540              		.loc 1 322 0
 541 0018 164E     		ldr	r6, .L51+24
 321:spinnaker_src/neuron.c **** 	spike_records[11]=pm_levels| (time_done_last_tick << 8)| (fill_level << 16) | (fill_level2 << 24);
 542              		.loc 1 321 0
 543 001a DFF86080 		ldr	r8, .L51+32
 319:spinnaker_src/neuron.c **** 	spike_records[1]=systicks;
 544              		.loc 1 319 0
 545 001e 0968     		ldr	r1, [r1]
 321:spinnaker_src/neuron.c **** 	spike_records[11]=pm_levels| (time_done_last_tick << 8)| (fill_level << 16) | (fill_level2 << 24);
 546              		.loc 1 321 0
 547 0020 D8F80020 		ldr	r2, [r8]
 548 0024 AA62     		str	r2, [r5, #40]
 549              		.loc 1 322 0
 550 0026 0404     		lsls	r4, r0, #16
 551 0028 44EA0324 		orr	r4, r4, r3, lsl #8
 552 002c 3B68     		ldr	r3, [r7]
 553 002e 3068     		ldr	r0, [r6]
 319:spinnaker_src/neuron.c **** 	spike_records[1]=systicks;
 554              		.loc 1 319 0
 555 0030 2960     		str	r1, [r5]
 556              		.loc 1 322 0
 557 0032 2343     		orrs	r3, r3, r4
 558 0034 43EA0060 		orr	r0, r3, r0, lsl #24
 559 0038 2C46     		mov	r4, r5
 560 003a E862     		str	r0, [r5, #44]
 561              	.LVL15:
 562 003c 2C35     		adds	r5, r5, #44
 563 003e 01E0     		b	.L48
 564              	.LVL16:
 565              	.L50:
 566 0040 54F8041F 		ldr	r1, [r4, #4]!
 567              	.L48:
 568              	.LBB12:
 323:spinnaker_src/neuron.c **** 
 324:spinnaker_src/neuron.c **** 	//TODO log uint32_t array
 325:spinnaker_src/neuron.c **** 	//debug! all in sram
 326:spinnaker_src/neuron.c **** 	
 327:spinnaker_src/neuron.c **** 	for(uint32_t i = 0; i < SPIKE_RECORD_LENGTH; i++){
 328:spinnaker_src/neuron.c **** 		log_info("%#010x\n",spike_records[i]);
 569              		.loc 1 328 0 discriminator 3
 570 0044 0C48     		ldr	r0, .L51+28
 571 0046 FFF7FEFF 		bl	log_info
 572              	.LVL17:
 327:spinnaker_src/neuron.c **** 		log_info("%#010x\n",spike_records[i]);
 573              		.loc 1 327 0 discriminator 3
 574 004a AC42     		cmp	r4, r5
 575 004c F8D1     		bne	.L50
 576              	.LBE12:
 329:spinnaker_src/neuron.c **** 	}	
 330:spinnaker_src/neuron.c **** 	
 331:spinnaker_src/neuron.c **** 	warnings=0;
 577              		.loc 1 331 0
 578 004e 0023     		movs	r3, #0
 579 0050 C8F80030 		str	r3, [r8]
 332:spinnaker_src/neuron.c **** 	pm_levels=0;
 580              		.loc 1 332 0
 581 0054 3B60     		str	r3, [r7]
 333:spinnaker_src/neuron.c **** 	fill_level2=0;
 582              		.loc 1 333 0
 583 0056 3360     		str	r3, [r6]
 584 0058 BDE8F081 		pop	{r4, r5, r6, r7, r8, pc}
 585              	.L52:
 586              		.align	2
 587              	.L51:
 588 005c 00000000 		.word	fill_level
 589 0060 00000000 		.word	.LANCHOR0
 590 0064 00000000 		.word	systicks
 591 0068 00000000 		.word	pe_id
 592 006c 00000000 		.word	spike_records
 593 0070 00000000 		.word	pm_levels
 594 0074 00000000 		.word	.LANCHOR1
 595 0078 24000000 		.word	.LC1
 596 007c 00000000 		.word	warnings
 597              		.cfi_endproc
 598              	.LFE196:
 600              		.section	.text.clear_spike_record,"ax",%progbits
 601              		.align	2
 602              		.global	clear_spike_record
 603              		.thumb
 604              		.thumb_func
 606              	clear_spike_record:
 607              	.LFB197:
 334:spinnaker_src/neuron.c **** 
 335:spinnaker_src/neuron.c **** }
 336:spinnaker_src/neuron.c **** 
 337:spinnaker_src/neuron.c **** void clear_spike_record(){
 608              		.loc 1 337 0
 609              		.cfi_startproc
 610              		@ args = 0, pretend = 0, frame = 0
 611              		@ frame_needed = 0, uses_anonymous_args = 0
 612              		@ link register save eliminated.
 613              	.LVL18:
 614 0000 084B     		ldr	r3, .L58
 615              	.LBB13:
 338:spinnaker_src/neuron.c **** 
 339:spinnaker_src/neuron.c **** 	for (uint32_t i = 0; i < SPIKE_RECORD_LENGTH ; i++){
 340:spinnaker_src/neuron.c **** 	
 341:spinnaker_src/neuron.c **** 		spike_records[i]=0;
 616              		.loc 1 341 0
 617 0002 0021     		movs	r1, #0
 618 0004 03F13002 		add	r2, r3, #48
 619              	.LVL19:
 620              	.L54:
 621              		.loc 1 341 0 is_stmt 0 discriminator 3
 622 0008 43F8041B 		str	r1, [r3], #4
 339:spinnaker_src/neuron.c **** 	
 623              		.loc 1 339 0 is_stmt 1 discriminator 3
 624 000c 9342     		cmp	r3, r2
 625 000e FBD1     		bne	.L54
 626 0010 054B     		ldr	r3, .L58+4
 627              	.LBE13:
 628              	.LBB14:
 342:spinnaker_src/neuron.c **** 	}
 343:spinnaker_src/neuron.c **** 	for (uint32_t i = 0 ; i < SPIKE_RECORD_COUNTER_LENGTH ; i++){
 344:spinnaker_src/neuron.c **** 	
 345:spinnaker_src/neuron.c **** 		spike_records_count[i]=0;
 629              		.loc 1 345 0
 630 0012 0021     		movs	r1, #0
 631 0014 03F12002 		add	r2, r3, #32
 632              	.L55:
 633              		.loc 1 345 0 is_stmt 0 discriminator 3
 634 0018 43F8041F 		str	r1, [r3, #4]!
 635              	.LVL20:
 343:spinnaker_src/neuron.c **** 	
 636              		.loc 1 343 0 is_stmt 1 discriminator 3
 637 001c 9342     		cmp	r3, r2
 638 001e FBD1     		bne	.L55
 639              	.LBE14:
 346:spinnaker_src/neuron.c **** 	}
 347:spinnaker_src/neuron.c **** }
 640              		.loc 1 347 0
 641 0020 7047     		bx	lr
 642              	.L59:
 643 0022 00BF     		.align	2
 644              	.L58:
 645 0024 00000000 		.word	spike_records
 646 0028 FCFFFFFF 		.word	spike_records_count-4
 647              		.cfi_endproc
 648              	.LFE197:
 650              		.global	out_spike_count
 651              		.global	time_done_last_tick
 652              		.global	time_done
 653              		.global	fill_level2
 654              		.global	debug_count15
 655              		.global	debug_record_offset
 656              		.global	spike_record_offset
 657              		.comm	spike_records_count,32,4
 658              		.comm	spike_records,48,16
 659              		.comm	n_neurons,4,4
 660              		.comm	API_BURST_FINISHED,1,1
 661              		.section	.bss.debug_record_offset,"aw",%nobits
 662              		.align	2
 665              	debug_record_offset:
 666 0000 00000000 		.space	4
 667              		.section	.bss.out_spike_count,"aw",%nobits
 668              		.align	2
 671              	out_spike_count:
 672 0000 00000000 		.space	4
 673              		.section	.bss.debug_count15,"aw",%nobits
 674              		.align	2
 677              	debug_count15:
 678 0000 00000000 		.space	4
 679              		.section	.bss.spike_record_offset,"aw",%nobits
 680              		.align	2
 683              	spike_record_offset:
 684 0000 00000000 		.space	4
 685              		.section	.bss.time_done,"aw",%nobits
 686              		.align	2
 689              	time_done:
 690 0000 00000000 		.space	4
 691              		.section	.rodata.str1.4,"aMS",%progbits,1
 692              		.align	2
 693              	.LC0:
 694 0000 4552524F 		.ascii	"ERROR: self spike counter overflow\012\000"
 694      523A2073 
 694      656C6620 
 694      7370696B 
 694      6520636F 
 695              	.LC1:
 696 0024 25233031 		.ascii	"%#010x\012\000"
 696      30780A00 
 697              		.section	.bss.fill_level2,"aw",%nobits
 698              		.align	2
 699              		.set	.LANCHOR1,. + 0
 702              	fill_level2:
 703 0000 00000000 		.space	4
 704              		.section	.bss.time_done_last_tick,"aw",%nobits
 705              		.align	2
 706              		.set	.LANCHOR0,. + 0
 709              	time_done_last_tick:
 710 0000 00000000 		.space	4
 711              		.text
 712              	.Letext0:
 713              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 714              		.file 4 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 715              		.file 5 "/home/yexin/projects/JIB1Tests/qpe-common/include/fixedpoint.h"
 716              		.file 6 "spinnaker_src/common/maths-util.h"
 717              		.file 7 "spinnaker_src/param_defs.h"
 718              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 719              		.file 9 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 720              		.file 10 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
 721              		.file 11 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
 722              		.file 12 "spinnaker_src/spinn_log.h"
