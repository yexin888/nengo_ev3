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
  17              		.file	"if_curr_exp.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.NeuralInit,"ax",%progbits
  22              		.align	2
  23              		.global	NeuralInit
  24              		.thumb
  25              		.thumb_func
  27              	NeuralInit:
  28              	.LFB188:
  29              		.file 1 "spinnaker_src/if_curr_exp.c"
   1:spinnaker_src/if_curr_exp.c **** #define USE_RECORD 1
   2:spinnaker_src/if_curr_exp.c **** 
   3:spinnaker_src/if_curr_exp.c **** #include <qpe.h>
   4:spinnaker_src/if_curr_exp.c **** #include "if_curr_exp.h"
   5:spinnaker_src/if_curr_exp.c **** 
   6:spinnaker_src/if_curr_exp.c **** #include "common/neuron-typedefs.h"
   7:spinnaker_src/if_curr_exp.c **** #include "neuron_model.h"
   8:spinnaker_src/if_curr_exp.c **** #include "neuron_model_lif_impl.h" 
   9:spinnaker_src/if_curr_exp.c **** #include "input_types/input_type_conductance.h"
  10:spinnaker_src/if_curr_exp.c **** #include "synapse_types/synapse_types_exponential_impl.h"
  11:spinnaker_src/if_curr_exp.c **** #include "synapse_row.h"
  12:spinnaker_src/if_curr_exp.c **** #include "param_defs.h"
  13:spinnaker_src/if_curr_exp.c **** 
  14:spinnaker_src/if_curr_exp.c **** #include "qpe_event_based_api.h"
  15:spinnaker_src/if_curr_exp.c **** #include "neuron.h"
  16:spinnaker_src/if_curr_exp.c **** #include "synapses.h"
  17:spinnaker_src/if_curr_exp.c **** #include "spike_source.h"
  18:spinnaker_src/if_curr_exp.c **** //#include "spike_processing.h"
  19:spinnaker_src/if_curr_exp.c **** //#include "population_table.h"
  20:spinnaker_src/if_curr_exp.c **** //#include "santos_ark.h"
  21:spinnaker_src/if_curr_exp.c **** #include "gen_bin.h"
  22:spinnaker_src/if_curr_exp.c **** 
  23:spinnaker_src/if_curr_exp.c **** 
  24:spinnaker_src/if_curr_exp.c **** 
  25:spinnaker_src/if_curr_exp.c **** 
  26:spinnaker_src/if_curr_exp.c **** 
  27:spinnaker_src/if_curr_exp.c **** static volatile uint32_t *status;
  28:spinnaker_src/if_curr_exp.c **** 
  29:spinnaker_src/if_curr_exp.c **** volatile uint32_t packet_buffer[PACKET_BUFFER_LENGTH+1] __attribute__((aligned(0x10)));
  30:spinnaker_src/if_curr_exp.c **** uint32_t read_pos = 0;
  31:spinnaker_src/if_curr_exp.c **** static volatile uint32_t finished = 0;
  32:spinnaker_src/if_curr_exp.c **** uint32_t n_packets_received = 0;
  33:spinnaker_src/if_curr_exp.c **** 
  34:spinnaker_src/if_curr_exp.c **** static volatile uint32_t time = 0;
  35:spinnaker_src/if_curr_exp.c **** 
  36:spinnaker_src/if_curr_exp.c **** uint32_t n_spikes_sent = 0;
  37:spinnaker_src/if_curr_exp.c **** static uint32_t n_unknown_keys = 0;
  38:spinnaker_src/if_curr_exp.c **** 
  39:spinnaker_src/if_curr_exp.c **** uint32_t duration = SIM_TIME;
  40:spinnaker_src/if_curr_exp.c **** uint32_t params_systick = 50;
  41:spinnaker_src/if_curr_exp.c **** 
  42:spinnaker_src/if_curr_exp.c **** uint32_t n_external_packets_received=0;
  43:spinnaker_src/if_curr_exp.c **** extern volatile uint32_t run;           	
  44:spinnaker_src/if_curr_exp.c **** 
  45:spinnaker_src/if_curr_exp.c **** 
  46:spinnaker_src/if_curr_exp.c **** extern uint32_t _heap_base;
  47:spinnaker_src/if_curr_exp.c **** extern uint32_t _heap_top;
  48:spinnaker_src/if_curr_exp.c **** 
  49:spinnaker_src/if_curr_exp.c **** extern uint32_t _estack;
  50:spinnaker_src/if_curr_exp.c **** extern uint32_t _sidata;
  51:spinnaker_src/if_curr_exp.c **** extern uint32_t _sdata, _edata;
  52:spinnaker_src/if_curr_exp.c **** extern uint32_t __bss_start__, __bss_end__;
  53:spinnaker_src/if_curr_exp.c **** 
  54:spinnaker_src/if_curr_exp.c **** 
  55:spinnaker_src/if_curr_exp.c **** extern global_neuron_params_t global_neuron_params ;
  56:spinnaker_src/if_curr_exp.c **** 
  57:spinnaker_src/if_curr_exp.c **** extern uint32_t table_count;
  58:spinnaker_src/if_curr_exp.c **** 
  59:spinnaker_src/if_curr_exp.c **** uint32_t systicks=0;
  60:spinnaker_src/if_curr_exp.c **** uint32_t fill_level;
  61:spinnaker_src/if_curr_exp.c **** 
  62:spinnaker_src/if_curr_exp.c **** int mc_packet_callback_priority=-1;
  63:spinnaker_src/if_curr_exp.c **** int dma_trasnfer_callback_priority=0;
  64:spinnaker_src/if_curr_exp.c **** int user_event_priority=0;
  65:spinnaker_src/if_curr_exp.c **** int systick_callback_priority=1;
  66:spinnaker_src/if_curr_exp.c **** 
  67:spinnaker_src/if_curr_exp.c **** uint32_t  pm_levels;
  68:spinnaker_src/if_curr_exp.c **** 
  69:spinnaker_src/if_curr_exp.c **** uint32_t pe_id;
  70:spinnaker_src/if_curr_exp.c **** uint32_t pe0 = 0;
  71:spinnaker_src/if_curr_exp.c **** uint32_t pe1 = 1;
  72:spinnaker_src/if_curr_exp.c **** uint32_t pe2 = 2;
  73:spinnaker_src/if_curr_exp.c **** uint32_t pe3 = 3;
  74:spinnaker_src/if_curr_exp.c **** 
  75:spinnaker_src/if_curr_exp.c **** uint32_t self_spike_counter=0;
  76:spinnaker_src/if_curr_exp.c **** uint32_t self_spikes[SELF_SPIKES_LENGTH];
  77:spinnaker_src/if_curr_exp.c **** 
  78:spinnaker_src/if_curr_exp.c **** #ifdef ENS_CORE
  79:spinnaker_src/if_curr_exp.c **** extern ensemble_t ensembles[N_ENSEMBLES];
  80:spinnaker_src/if_curr_exp.c **** extern uint32_t n_ensembles;
  81:spinnaker_src/if_curr_exp.c **** #endif
  82:spinnaker_src/if_curr_exp.c **** #ifdef INTER_CORE
  83:spinnaker_src/if_curr_exp.c **** extern intermediate_t inters[N_INTERS];
  84:spinnaker_src/if_curr_exp.c **** extern uint32_t n_inters;
  85:spinnaker_src/if_curr_exp.c **** #endif
  86:spinnaker_src/if_curr_exp.c **** 
  87:spinnaker_src/if_curr_exp.c **** #ifdef ENS_CORE 
  88:spinnaker_src/if_curr_exp.c **** extern message_t mess[N_MESS];
  89:spinnaker_src/if_curr_exp.c **** extern uint32_t n_mess;
  90:spinnaker_src/if_curr_exp.c **** extern void ensemble_init();
  91:spinnaker_src/if_curr_exp.c **** extern void mess_init();
  92:spinnaker_src/if_curr_exp.c **** 
  93:spinnaker_src/if_curr_exp.c **** #endif
  94:spinnaker_src/if_curr_exp.c **** //debug! topology specific
  95:spinnaker_src/if_curr_exp.c **** 
  96:spinnaker_src/if_curr_exp.c **** void NeuralInit (){
  30              		.loc 1 96 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34 0000 10B5     		push	{r4, lr}
  35              		.cfi_def_cfa_offset 8
  36              		.cfi_offset 4, -8
  37              		.cfi_offset 14, -4
  97:spinnaker_src/if_curr_exp.c **** 	
  98:spinnaker_src/if_curr_exp.c **** 	//debug! 
  99:spinnaker_src/if_curr_exp.c **** #ifdef ENS_CORE
 100:spinnaker_src/if_curr_exp.c **** 	ensemble_init();
 101:spinnaker_src/if_curr_exp.c **** #endif
 102:spinnaker_src/if_curr_exp.c **** #ifdef INTER_CORE
 103:spinnaker_src/if_curr_exp.c **** 	inter_init();
 104:spinnaker_src/if_curr_exp.c **** #endif
 105:spinnaker_src/if_curr_exp.c **** #ifdef ENS_CORE 
 106:spinnaker_src/if_curr_exp.c **** 	mess_init();
 107:spinnaker_src/if_curr_exp.c **** #endif
 108:spinnaker_src/if_curr_exp.c **** 
 109:spinnaker_src/if_curr_exp.c **** #ifdef SOURCE_CORE
 110:spinnaker_src/if_curr_exp.c **** 	pid_init(KP, KI , KD, TAU_D);
  38              		.loc 1 110 0
  39 0002 B0EE000A 		fconsts	s0, #0
  40 0006 DFED0B0A 		flds	s1, .L3
  41 000a DFED0B1A 		flds	s3, .L3+4
  42 000e B7EE001A 		fconsts	s2, #112
  43 0012 FFF7FEFF 		bl	pid_init
  44              	.LVL0:
 111:spinnaker_src/if_curr_exp.c **** 	uint32_t* address0 ;
 112:spinnaker_src/if_curr_exp.c **** 	uint32_t* address1 ;
 113:spinnaker_src/if_curr_exp.c **** 	address0 =(uint32_t*) (IF_CURR_EXP_EXT_BASE); 
 114:spinnaker_src/if_curr_exp.c **** 	address1 =(uint32_t*) (IF_CURR_EXP_EXT_BASE+8); 
 115:spinnaker_src/if_curr_exp.c **** 	*address0 = 0;
  45              		.loc 1 115 0
  46 0016 4FF4B034 		mov	r4, #90112
 116:spinnaker_src/if_curr_exp.c **** 	*(address0+1) = 0;
  47              		.loc 1 116 0
  48 001a 0848     		ldr	r0, .L3+8
 117:spinnaker_src/if_curr_exp.c **** 	*address1 = 0;
  49              		.loc 1 117 0
  50 001c 0849     		ldr	r1, .L3+12
 118:spinnaker_src/if_curr_exp.c **** 	*(address1+1) = 0;
  51              		.loc 1 118 0
  52 001e 094A     		ldr	r2, .L3+16
 115:spinnaker_src/if_curr_exp.c **** 	*(address0+1) = 0;
  53              		.loc 1 115 0
  54 0020 0023     		movs	r3, #0
  55 0022 2360     		str	r3, [r4]
 116:spinnaker_src/if_curr_exp.c **** 	*address1 = 0;
  56              		.loc 1 116 0
  57 0024 0360     		str	r3, [r0]
 119:spinnaker_src/if_curr_exp.c **** #endif
 120:spinnaker_src/if_curr_exp.c **** 
 121:spinnaker_src/if_curr_exp.c **** 	neuron_initialise();
 122:spinnaker_src/if_curr_exp.c **** }
  58              		.loc 1 122 0
  59 0026 BDE81040 		pop	{r4, lr}
  60              		.cfi_restore 14
  61              		.cfi_restore 4
  62              		.cfi_def_cfa_offset 0
 117:spinnaker_src/if_curr_exp.c **** 	*(address1+1) = 0;
  63              		.loc 1 117 0
  64 002a 0B60     		str	r3, [r1]
 118:spinnaker_src/if_curr_exp.c **** #endif
  65              		.loc 1 118 0
  66 002c 1360     		str	r3, [r2]
 121:spinnaker_src/if_curr_exp.c **** }
  67              		.loc 1 121 0
  68 002e FFF7FEBF 		b	neuron_initialise
  69              	.LVL1:
  70              	.L4:
  71 0032 00BF     		.align	2
  72              	.L3:
  73 0034 00000000 		.word	0
  74 0038 6F12833A 		.word	981668463
  75 003c 04600100 		.word	90116
  76 0040 08600100 		.word	90120
  77 0044 0C600100 		.word	90124
  78              		.cfi_endproc
  79              	.LFE188:
  81              		.section	.text.ProgramInit,"ax",%progbits
  82              		.align	2
  83              		.global	ProgramInit
  84              		.thumb
  85              		.thumb_func
  87              	ProgramInit:
  88              	.LFB189:
 123:spinnaker_src/if_curr_exp.c **** void ProgramInit(){
  89              		.loc 1 123 0
  90              		.cfi_startproc
  91              		@ args = 0, pretend = 0, frame = 0
  92              		@ frame_needed = 0, uses_anonymous_args = 0
  93              		@ link register save eliminated.
 124:spinnaker_src/if_curr_exp.c **** 
 125:spinnaker_src/if_curr_exp.c **** 	/*
 126:spinnaker_src/if_curr_exp.c **** 	//debug! real time comm
 127:spinnaker_src/if_curr_exp.c **** 	uint32_t* address ;
 128:spinnaker_src/if_curr_exp.c **** 	address =(uint32_t*) IF_CURR_EXP_EXT_BASE; 
 129:spinnaker_src/if_curr_exp.c **** 	*address = 0;
 130:spinnaker_src/if_curr_exp.c **** 	*/
 131:spinnaker_src/if_curr_exp.c **** 
 132:spinnaker_src/if_curr_exp.c **** 	NeuralInit();
  94              		.loc 1 132 0
  95 0000 FFF7FEBF 		b	NeuralInit
  96              	.LVL2:
  97              		.cfi_endproc
  98              	.LFE189:
 100              		.section	.text.calc_fill_level,"ax",%progbits
 101              		.align	2
 102              		.global	calc_fill_level
 103              		.thumb
 104              		.thumb_func
 106              	calc_fill_level:
 107              	.LFB190:
 133:spinnaker_src/if_curr_exp.c **** }
 134:spinnaker_src/if_curr_exp.c **** 
 135:spinnaker_src/if_curr_exp.c **** void calc_fill_level(){
 108              		.loc 1 135 0
 109              		.cfi_startproc
 110              		@ args = 0, pretend = 0, frame = 0
 111              		@ frame_needed = 0, uses_anonymous_args = 0
 112              		@ link register save eliminated.
 136:spinnaker_src/if_curr_exp.c **** 
 137:spinnaker_src/if_curr_exp.c ****     n_packets_received = comms[COMMS_DMA_0_N_WORDS];
 113              		.loc 1 137 0
 114 0000 024A     		ldr	r2, .L7
 115 0002 034B     		ldr	r3, .L7+4
 116 0004 1268     		ldr	r2, [r2]
 117 0006 1A60     		str	r2, [r3]
 118 0008 7047     		bx	lr
 119              	.L8:
 120 000a 00BF     		.align	2
 121              	.L7:
 122 000c 180100E2 		.word	-503316200
 123 0010 00000000 		.word	.LANCHOR0
 124              		.cfi_endproc
 125              	.LFE190:
 127              		.section	.text.timer_callback,"ax",%progbits
 128              		.align	2
 129              		.global	timer_callback
 130              		.thumb
 131              		.thumb_func
 133              	timer_callback:
 134              	.LFB191:
 138:spinnaker_src/if_curr_exp.c **** }
 139:spinnaker_src/if_curr_exp.c **** 
 140:spinnaker_src/if_curr_exp.c **** void timer_callback(uint32_t unused1, uint32_t unused2){
 135              		.loc 1 140 0
 136              		.cfi_startproc
 137              		@ args = 0, pretend = 0, frame = 0
 138              		@ frame_needed = 0, uses_anonymous_args = 0
 139              	.LVL3:
 141:spinnaker_src/if_curr_exp.c **** 
 142:spinnaker_src/if_curr_exp.c ****     systicks++; 
 140              		.loc 1 142 0
 141 0000 104A     		ldr	r2, .L15
 143:spinnaker_src/if_curr_exp.c ****     if (systicks>= duration) {
 142              		.loc 1 143 0
 143 0002 1149     		ldr	r1, .L15+4
 144              	.LVL4:
 142:spinnaker_src/if_curr_exp.c ****     if (systicks>= duration) {
 145              		.loc 1 142 0
 146 0004 1368     		ldr	r3, [r2]
 147              		.loc 1 143 0
 148 0006 0968     		ldr	r1, [r1]
 142:spinnaker_src/if_curr_exp.c ****     if (systicks>= duration) {
 149              		.loc 1 142 0
 150 0008 0133     		adds	r3, r3, #1
 151              		.loc 1 143 0
 152 000a 8B42     		cmp	r3, r1
 140:spinnaker_src/if_curr_exp.c **** 
 153              		.loc 1 140 0
 154 000c 10B5     		push	{r4, lr}
 155              		.cfi_def_cfa_offset 8
 156              		.cfi_offset 4, -8
 157              		.cfi_offset 14, -4
 142:spinnaker_src/if_curr_exp.c ****     if (systicks>= duration) {
 158              		.loc 1 142 0
 159 000e 1360     		str	r3, [r2]
 160              		.loc 1 143 0
 161 0010 08D3     		bcc	.L10
 144:spinnaker_src/if_curr_exp.c **** 
 145:spinnaker_src/if_curr_exp.c ****         timer[TIMER1_CTL] = 0;
 162              		.loc 1 145 0
 163 0012 0E4C     		ldr	r4, .L15+8
 146:spinnaker_src/if_curr_exp.c ****         finished = 1;
 164              		.loc 1 146 0
 165 0014 0E49     		ldr	r1, .L15+12
 147:spinnaker_src/if_curr_exp.c **** 		run=0;
 166              		.loc 1 147 0
 167 0016 0F4A     		ldr	r2, .L15+16
 145:spinnaker_src/if_curr_exp.c ****         finished = 1;
 168              		.loc 1 145 0
 169 0018 0023     		movs	r3, #0
 146:spinnaker_src/if_curr_exp.c ****         finished = 1;
 170              		.loc 1 146 0
 171 001a 0120     		movs	r0, #1
 172              	.LVL5:
 145:spinnaker_src/if_curr_exp.c ****         finished = 1;
 173              		.loc 1 145 0
 174 001c 2360     		str	r3, [r4]
 146:spinnaker_src/if_curr_exp.c ****         finished = 1;
 175              		.loc 1 146 0
 176 001e 0860     		str	r0, [r1]
 177              		.loc 1 147 0
 178 0020 1360     		str	r3, [r2]
 148:spinnaker_src/if_curr_exp.c ****         return;
 179              		.loc 1 148 0
 180 0022 10BD     		pop	{r4, pc}
 181              	.LVL6:
 182              	.L10:
 149:spinnaker_src/if_curr_exp.c ****     }
 150:spinnaker_src/if_curr_exp.c **** 	
 151:spinnaker_src/if_curr_exp.c **** 	/*
 152:spinnaker_src/if_curr_exp.c **** 	//debug! real time comm
 153:spinnaker_src/if_curr_exp.c **** 	uint32_t* address ;
 154:spinnaker_src/if_curr_exp.c **** 	address =(uint32_t*) IF_CURR_EXP_EXT_BASE; 
 155:spinnaker_src/if_curr_exp.c **** 	*address = 0;
 156:spinnaker_src/if_curr_exp.c **** 	*/
 157:spinnaker_src/if_curr_exp.c **** 
 158:spinnaker_src/if_curr_exp.c **** 	n_packets_received=0;
 183              		.loc 1 158 0
 184 0024 0C4A     		ldr	r2, .L15+20
 159:spinnaker_src/if_curr_exp.c **** 	n_external_packets_received=0;
 185              		.loc 1 159 0
 186 0026 0D4C     		ldr	r4, .L15+24
 160:spinnaker_src/if_curr_exp.c **** 	fill_level=0;
 187              		.loc 1 160 0
 188 0028 0D48     		ldr	r0, .L15+28
 189              	.LVL7:
 190              	.LBB77:
 191              	.LBB78:
 137:spinnaker_src/if_curr_exp.c **** }
 192              		.loc 1 137 0
 193 002a 0E49     		ldr	r1, .L15+32
 194              	.LBE78:
 195              	.LBE77:
 158:spinnaker_src/if_curr_exp.c **** 	n_external_packets_received=0;
 196              		.loc 1 158 0
 197 002c 0023     		movs	r3, #0
 198 002e 1360     		str	r3, [r2]
 159:spinnaker_src/if_curr_exp.c **** 	fill_level=0;
 199              		.loc 1 159 0
 200 0030 2360     		str	r3, [r4]
 201              		.loc 1 160 0
 202 0032 0360     		str	r3, [r0]
 203              	.LBB80:
 204              	.LBB79:
 137:spinnaker_src/if_curr_exp.c **** }
 205              		.loc 1 137 0
 206 0034 0B68     		ldr	r3, [r1]
 207 0036 1360     		str	r3, [r2]
 208              	.LBE79:
 209              	.LBE80:
 161:spinnaker_src/if_curr_exp.c **** 
 162:spinnaker_src/if_curr_exp.c **** #ifdef ENS_CORE
 163:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 164:spinnaker_src/if_curr_exp.c **** 	//if(((systicks & 0x1) == 0)){
 165:spinnaker_src/if_curr_exp.c **** 	
 166:spinnaker_src/if_curr_exp.c **** 
 167:spinnaker_src/if_curr_exp.c **** 	//debug! real time comm
 168:spinnaker_src/if_curr_exp.c **** 	
 169:spinnaker_src/if_curr_exp.c **** 	
 170:spinnaker_src/if_curr_exp.c **** 		calc_fill_level();
 171:spinnaker_src/if_curr_exp.c **** 		//debug! system
 172:spinnaker_src/if_curr_exp.c **** 		if(n_packets_received==0){
 173:spinnaker_src/if_curr_exp.c **** 			return;
 174:spinnaker_src/if_curr_exp.c **** 		}
 175:spinnaker_src/if_curr_exp.c **** 		read_input_packets();
 176:spinnaker_src/if_curr_exp.c **** 		//TODO [optimize comm] the core should know which packets to send to itself
 177:spinnaker_src/if_curr_exp.c **** 		self_spike_counter = 0;
 178:spinnaker_src/if_curr_exp.c **** 		for (uint32_t i = 0 ; i < n_mess; i++){
 179:spinnaker_src/if_curr_exp.c **** 			tranformation_and_low_pass(mess[i]);
 180:spinnaker_src/if_curr_exp.c **** 		}
 181:spinnaker_src/if_curr_exp.c **** 		for (uint32_t i = 0 ; i < n_ensembles; i++){
 182:spinnaker_src/if_curr_exp.c **** 			
 183:spinnaker_src/if_curr_exp.c **** 			calc_input_current(ensembles[i]);
 184:spinnaker_src/if_curr_exp.c **** 			neuron_do_timestep_update(ensembles[i]);
 185:spinnaker_src/if_curr_exp.c **** 			//TODO learning
 186:spinnaker_src/if_curr_exp.c **** 			if(ensembles[i].learning_enabled == 1){
 187:spinnaker_src/if_curr_exp.c **** 				update_decoder(ensembles[i]);
 188:spinnaker_src/if_curr_exp.c **** 			}
 189:spinnaker_src/if_curr_exp.c **** 		}
 190:spinnaker_src/if_curr_exp.c **** 		
 191:spinnaker_src/if_curr_exp.c **** 		
 192:spinnaker_src/if_curr_exp.c **** 		
 193:spinnaker_src/if_curr_exp.c **** 
 194:spinnaker_src/if_curr_exp.c **** 
 195:spinnaker_src/if_curr_exp.c **** 
 196:spinnaker_src/if_curr_exp.c **** 
 197:spinnaker_src/if_curr_exp.c **** 	//}
 198:spinnaker_src/if_curr_exp.c **** #endif
 199:spinnaker_src/if_curr_exp.c **** #ifdef INTER_CORE
 200:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 201:spinnaker_src/if_curr_exp.c **** 	if(((systicks & 0x1) == 0)){
 202:spinnaker_src/if_curr_exp.c **** 		calc_fill_level(); 
 203:spinnaker_src/if_curr_exp.c **** 		read_input_packets();
 204:spinnaker_src/if_curr_exp.c **** 		send_source_spikes();
 205:spinnaker_src/if_curr_exp.c **** 		//TODO [optimize comm] the core should know which packets to send to itself
 206:spinnaker_src/if_curr_exp.c **** 		self_spike_counter = 0;
 207:spinnaker_src/if_curr_exp.c **** 		for (uint32_t i = 0 ; i < n_inters; i++){
 208:spinnaker_src/if_curr_exp.c **** 			inter_do_timestep_update(inters[i]);
 209:spinnaker_src/if_curr_exp.c **** 		}
 210:spinnaker_src/if_curr_exp.c **** 	}
 211:spinnaker_src/if_curr_exp.c **** #endif
 212:spinnaker_src/if_curr_exp.c **** 		
 213:spinnaker_src/if_curr_exp.c **** 
 214:spinnaker_src/if_curr_exp.c **** #ifdef MESS_CORE
 215:spinnaker_src/if_curr_exp.c **** 	//debug! topology specific
 216:spinnaker_src/if_curr_exp.c **** 	//env
 217:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 218:spinnaker_src/if_curr_exp.c **** 	if(((systicks & 0x1) == 1)){
 219:spinnaker_src/if_curr_exp.c **** 		calc_fill_level(); 
 220:spinnaker_src/if_curr_exp.c **** 		read_input_packets();
 221:spinnaker_src/if_curr_exp.c **** 		for (uint32_t i = 0 ; i < n_mess; i++){
 222:spinnaker_src/if_curr_exp.c **** 			calc_input_current(mess[i]);
 223:spinnaker_src/if_curr_exp.c **** 			mess_do_timestep_update(mess[i]);
 224:spinnaker_src/if_curr_exp.c **** 		}
 225:spinnaker_src/if_curr_exp.c **** 		
 226:spinnaker_src/if_curr_exp.c **** 		
 227:spinnaker_src/if_curr_exp.c **** 		//TODO learning
 228:spinnaker_src/if_curr_exp.c **** 		//update_decoder();
 229:spinnaker_src/if_curr_exp.c **** 		//send_source_spikes();
 230:spinnaker_src/if_curr_exp.c **** 		//calc_prev_output();
 231:spinnaker_src/if_curr_exp.c **** 	}
 232:spinnaker_src/if_curr_exp.c **** #endif
 233:spinnaker_src/if_curr_exp.c **** 
 234:spinnaker_src/if_curr_exp.c **** #ifdef SOURCE_CORE
 235:spinnaker_src/if_curr_exp.c **** 	calc_fill_level();
 236:spinnaker_src/if_curr_exp.c **** 	read_input_packets();
 210              		.loc 1 236 0
 211 0038 FFF7FEFF 		bl	read_input_packets
 212              	.LVL8:
 237:spinnaker_src/if_curr_exp.c **** 	send_source_spikes();
 238:spinnaker_src/if_curr_exp.c **** #endif	
 239:spinnaker_src/if_curr_exp.c **** }
 213              		.loc 1 239 0
 214 003c BDE81040 		pop	{r4, lr}
 215              		.cfi_restore 14
 216              		.cfi_restore 4
 217              		.cfi_def_cfa_offset 0
 237:spinnaker_src/if_curr_exp.c **** 	send_source_spikes();
 218              		.loc 1 237 0
 219 0040 FFF7FEBF 		b	send_source_spikes
 220              	.LVL9:
 221              	.L16:
 222              		.align	2
 223              	.L15:
 224 0044 00000000 		.word	.LANCHOR1
 225 0048 00000000 		.word	.LANCHOR2
 226 004c 080000E1 		.word	-520093688
 227 0050 00000000 		.word	.LANCHOR3
 228 0054 00000000 		.word	run
 229 0058 00000000 		.word	.LANCHOR0
 230 005c 00000000 		.word	.LANCHOR4
 231 0060 00000000 		.word	fill_level
 232 0064 180100E2 		.word	-503316200
 233              		.cfi_endproc
 234              	.LFE191:
 236              		.section	.text.log_prepare,"ax",%progbits
 237              		.align	2
 238              		.global	log_prepare
 239              		.thumb
 240              		.thumb_func
 242              	log_prepare:
 243              	.LFB192:
 240:spinnaker_src/if_curr_exp.c **** 
 241:spinnaker_src/if_curr_exp.c **** //#ifdef SOURCE_CORE
 242:spinnaker_src/if_curr_exp.c **** REAL * nengo_output_record;
 243:spinnaker_src/if_curr_exp.c **** //#endif
 244:spinnaker_src/if_curr_exp.c **** void log_prepare(){
 244              		.loc 1 244 0
 245              		.cfi_startproc
 246              		@ args = 0, pretend = 0, frame = 0
 247              		@ frame_needed = 0, uses_anonymous_args = 0
 245:spinnaker_src/if_curr_exp.c **** 
 246:spinnaker_src/if_curr_exp.c ****     status = &(data[IF_CURR_EXP_STATUS]);
 248              		.loc 1 246 0
 249 0000 104A     		ldr	r2, .L19
 247:spinnaker_src/if_curr_exp.c ****     *status = IF_CURR_EXP_STATUS_RUNNING;
 248:spinnaker_src/if_curr_exp.c ****     log_init(
 250              		.loc 1 248 0
 251 0002 1148     		ldr	r0, .L19+4
 244:spinnaker_src/if_curr_exp.c **** 
 252              		.loc 1 244 0
 253 0004 08B5     		push	{r3, lr}
 254              		.cfi_def_cfa_offset 8
 255              		.cfi_offset 3, -8
 256              		.cfi_offset 14, -4
 246:spinnaker_src/if_curr_exp.c ****     *status = IF_CURR_EXP_STATUS_RUNNING;
 257              		.loc 1 246 0
 258 0006 114B     		ldr	r3, .L19+8
 259 0008 1360     		str	r3, [r2]
 247:spinnaker_src/if_curr_exp.c ****     *status = IF_CURR_EXP_STATUS_RUNNING;
 260              		.loc 1 247 0
 261 000a 0022     		movs	r2, #0
 262 000c 1A60     		str	r2, [r3]
 263              		.loc 1 248 0
 264 000e 4FF4FA41 		mov	r1, #32000
 265 0012 FFF7FEFF 		bl	log_init
 266              	.LVL10:
 249:spinnaker_src/if_curr_exp.c ****         (uint32_t *) &(data[IF_CURR_EXP_DEBUG_START]), IF_CURR_EXP_DEBUG_SIZE);
 250:spinnaker_src/if_curr_exp.c ****     log_info("heap base 0x%08x, heap top 0x%08x\n", &_heap_base, &_heap_top);
 267              		.loc 1 250 0
 268 0016 0E48     		ldr	r0, .L19+12
 269 0018 0E49     		ldr	r1, .L19+16
 270 001a 0F4A     		ldr	r2, .L19+20
 271 001c FFF7FEFF 		bl	log_info
 272              	.LVL11:
 251:spinnaker_src/if_curr_exp.c ****     log_info("estack 0x%08x, sidata 0x%08x\n", &_estack, &_sidata);
 273              		.loc 1 251 0
 274 0020 0E48     		ldr	r0, .L19+24
 275 0022 0F49     		ldr	r1, .L19+28
 276 0024 0F4A     		ldr	r2, .L19+32
 277 0026 FFF7FEFF 		bl	log_info
 278              	.LVL12:
 252:spinnaker_src/if_curr_exp.c ****     log_info("sdata 0x%08x, edata 0x%08x\n", &_sdata, &_edata);
 279              		.loc 1 252 0
 280 002a 0F48     		ldr	r0, .L19+36
 281 002c 0F49     		ldr	r1, .L19+40
 282 002e 104A     		ldr	r2, .L19+44
 283 0030 FFF7FEFF 		bl	log_info
 284              	.LVL13:
 253:spinnaker_src/if_curr_exp.c ****     log_info("bss start 0x%08x, bss end 0x%08x\n", &__bss_start__, &__bss_end__);
 285              		.loc 1 253 0
 286 0034 0F48     		ldr	r0, .L19+48
 287 0036 1049     		ldr	r1, .L19+52
 288 0038 104A     		ldr	r2, .L19+56
 254:spinnaker_src/if_curr_exp.c **** 	//debug! system
 255:spinnaker_src/if_curr_exp.c **** 	
 256:spinnaker_src/if_curr_exp.c **** //#ifdef SOURCE_CORE
 257:spinnaker_src/if_curr_exp.c **** 	//debug! minsim
 258:spinnaker_src/if_curr_exp.c **** 	//nengo_output_record = (REAL*) IF_CURR_EXP_REAL_START;
 259:spinnaker_src/if_curr_exp.c **** //#endif
 260:spinnaker_src/if_curr_exp.c **** }
 289              		.loc 1 260 0
 290 003a BDE80840 		pop	{r3, lr}
 291              		.cfi_restore 14
 292              		.cfi_restore 3
 293              		.cfi_def_cfa_offset 0
 253:spinnaker_src/if_curr_exp.c ****     log_info("bss start 0x%08x, bss end 0x%08x\n", &__bss_start__, &__bss_end__);
 294              		.loc 1 253 0
 295 003e FFF7FEBF 		b	log_info
 296              	.LVL14:
 297              	.L20:
 298 0042 00BF     		.align	2
 299              	.L19:
 300 0044 00000000 		.word	.LANCHOR5
 301 0048 286F0100 		.word	93992
 302 004c 206F0100 		.word	93984
 303 0050 00000000 		.word	.LC0
 304 0054 00000000 		.word	_heap_base
 305 0058 00000000 		.word	_heap_top
 306 005c 24000000 		.word	.LC1
 307 0060 00000000 		.word	_estack
 308 0064 00000000 		.word	_sidata
 309 0068 44000000 		.word	.LC2
 310 006c 00000000 		.word	_sdata
 311 0070 00000000 		.word	_edata
 312 0074 60000000 		.word	.LC3
 313 0078 00000000 		.word	__bss_start__
 314 007c 00000000 		.word	__bss_end__
 315              		.cfi_endproc
 316              	.LFE192:
 318              		.section	.text.timer_init,"ax",%progbits
 319              		.align	2
 320              		.global	timer_init
 321              		.thumb
 322              		.thumb_func
 324              	timer_init:
 325              	.LFB193:
 261:spinnaker_src/if_curr_exp.c **** 
 262:spinnaker_src/if_curr_exp.c **** void timer_init(){
 326              		.loc 1 262 0
 327              		.cfi_startproc
 328              		@ args = 0, pretend = 0, frame = 0
 329              		@ frame_needed = 0, uses_anonymous_args = 0
 330              		@ link register save eliminated.
 263:spinnaker_src/if_curr_exp.c ****     // Set up the timer
 264:spinnaker_src/if_curr_exp.c ****     timer[TIMER1_CTL] = 0;
 331              		.loc 1 264 0
 332 0000 064A     		ldr	r2, .L22
 265:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 266:spinnaker_src/if_curr_exp.c ****     timer[TIMER1_LOAD] = 1000 * params_systick;
 333              		.loc 1 266 0
 334 0002 074B     		ldr	r3, .L22+4
 264:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 335              		.loc 1 264 0
 336 0004 0021     		movs	r1, #0
 337 0006 1160     		str	r1, [r2]
 338              		.loc 1 266 0
 339 0008 1968     		ldr	r1, [r3]
 340 000a 4FF06142 		mov	r2, #-520093696
 341 000e 4FF47A73 		mov	r3, #1000
 342 0012 03FB01F3 		mul	r3, r3, r1
 343 0016 1360     		str	r3, [r2]
 344 0018 7047     		bx	lr
 345              	.L23:
 346 001a 00BF     		.align	2
 347              	.L22:
 348 001c 080000E1 		.word	-520093688
 349 0020 00000000 		.word	.LANCHOR6
 350              		.cfi_endproc
 351              	.LFE193:
 353              		.section	.text.timer_start,"ax",%progbits
 354              		.align	2
 355              		.global	timer_start
 356              		.thumb
 357              		.thumb_func
 359              	timer_start:
 360              	.LFB194:
 267:spinnaker_src/if_curr_exp.c **** 
 268:spinnaker_src/if_curr_exp.c **** 
 269:spinnaker_src/if_curr_exp.c **** }
 270:spinnaker_src/if_curr_exp.c **** 
 271:spinnaker_src/if_curr_exp.c **** void timer_start(){
 361              		.loc 1 271 0
 362              		.cfi_startproc
 363              		@ args = 0, pretend = 0, frame = 0
 364              		@ frame_needed = 0, uses_anonymous_args = 0
 365              		@ link register save eliminated.
 366              	.LBB81:
 367              	.LBB82:
 368              		.file 2 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
   1:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**************************************************************************//**
   2:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  * @file     core_cm4.h
   3:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  * @brief    CMSIS Cortex-M4 Core Peripheral Access Layer Header File
   4:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  * @version  V4.30
   5:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  * @date     20. October 2015
   6:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  ******************************************************************************/
   7:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Copyright (c) 2009 - 2015 ARM LIMITED
   8:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
   9:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    All rights reserved.
  10:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    Redistribution and use in source and binary forms, with or without
  11:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    modification, are permitted provided that the following conditions are met:
  12:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    - Redistributions of source code must retain the above copyright
  13:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      notice, this list of conditions and the following disclaimer.
  14:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    - Redistributions in binary form must reproduce the above copyright
  15:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      notice, this list of conditions and the following disclaimer in the
  16:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      documentation and/or other materials provided with the distribution.
  17:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    - Neither the name of ARM nor the names of its contributors may be used
  18:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      to endorse or promote products derived from this software without
  19:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      specific prior written permission.
  20:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    *
  21:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  22:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  23:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  24:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
  25:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  26:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  27:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  28:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  29:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  30:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  31:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    POSSIBILITY OF SUCH DAMAGE.
  32:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    ---------------------------------------------------------------------------*/
  33:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  34:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  35:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if   defined ( __ICCARM__ )
  36:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  #pragma system_include         /* treat file as system include file for MISRA check */
  37:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
  38:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #pragma clang system_header   /* treat file as system include file */
  39:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
  40:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  41:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifndef __CORE_CM4_H_GENERIC
  42:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define __CORE_CM4_H_GENERIC
  43:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  44:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #include <stdint.h>
  45:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  46:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifdef __cplusplus
  47:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  extern "C" {
  48:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
  49:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  50:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
  51:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \page CMSIS_MISRA_Exceptions  MISRA-C:2004 Compliance Exceptions
  52:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   CMSIS violates the following MISRA-C:2004 rules:
  53:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  54:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    \li Required Rule 8.5, object/function definition in header file.<br>
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      Function definitions in header files are used to allow 'inlining'.
  56:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  57:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    \li Required Rule 18.4, declaration of union type or object of union type: '{...}'.<br>
  58:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      Unions are used for effective representation of core registers.
  59:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  60:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****    \li Advisory Rule 19.7, Function-like macro defined.<br>
  61:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****      Function-like macros are used to allow more efficient code.
  62:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
  63:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  64:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  65:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*******************************************************************************
  66:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  *                 CMSIS definitions
  67:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  ******************************************************************************/
  68:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
  69:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup Cortex_M4
  70:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
  71:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
  72:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  73:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*  CMSIS CM4 definitions */
  74:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define __CM4_CMSIS_VERSION_MAIN  (0x04U)                                      /*!< [31:16] CMSIS H
  75:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define __CM4_CMSIS_VERSION_SUB   (0x1EU)                                      /*!< [15:0]  CMSIS H
  76:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define __CM4_CMSIS_VERSION       ((__CM4_CMSIS_VERSION_MAIN << 16U) | \
  77:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****                                     __CM4_CMSIS_VERSION_SUB           )        /*!< CMSIS HAL versi
  78:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  79:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define __CORTEX_M                (0x04U)                                      /*!< Cortex-M Core *
  80:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  81:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  82:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if   defined ( __CC_ARM )
  83:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            __asm                                      /*!< asm keyword for ARM Comp
  84:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __INLINE         __inline                                   /*!< inline keyword for ARM C
  85:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static __inline
  86:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  87:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
  88:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            __asm                                      /*!< asm keyword for ARM Comp
  89:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __INLINE         __inline                                   /*!< inline keyword for ARM C
  90:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static __inline
  91:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  92:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __GNUC__ )
  93:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            __asm                                      /*!< asm keyword for GNU Comp
  94:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __INLINE         inline                                     /*!< inline keyword for GNU C
  95:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static inline
  96:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
  97:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __ICCARM__ )
  98:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            __asm                                      /*!< asm keyword for IAR Comp
  99:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __INLINE         inline                                     /*!< inline keyword for IAR C
 100:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static inline
 101:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 102:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __TMS470__ )
 103:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            __asm                                      /*!< asm keyword for TI CCS C
 104:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static inline
 105:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 106:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __TASKING__ )
 107:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            __asm                                      /*!< asm keyword for TASKING 
 108:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __INLINE         inline                                     /*!< inline keyword for TASKI
 109:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static inline
 110:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 111:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __CSMC__ )
 112:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __packed
 113:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __ASM            _asm                                      /*!< asm keyword for COSMIC Co
 114:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __INLINE         inline                                    /*!< inline keyword for COSMIC
 115:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define __STATIC_INLINE  static inline
 116:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 117:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #else
 118:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #error Unknown compiler
 119:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
 120:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 121:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /** __FPU_USED indicates whether an FPU is used or not.
 122:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     For this, __FPU_PRESENT has to be checked prior to making use of FPU specific registers and fun
 123:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** */
 124:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if defined ( __CC_ARM )
 125:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if defined __TARGET_FPU_VFP
 126:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1U)
 127:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 128:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 129:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #error "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESENT)
 130:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 131:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 132:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 133:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 134:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 135:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 136:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
 137:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if defined __ARM_PCS_VFP
 138:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1)
 139:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 140:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 141:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #warning "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESEN
 142:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 143:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 144:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 145:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 146:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 147:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 148:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __GNUC__ )
 149:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if defined (__VFP_FP__) && !defined(__SOFTFP__)
 150:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1U)
 151:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 152:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 153:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #error "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESENT)
 154:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 155:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 156:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 157:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 158:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 159:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 160:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __ICCARM__ )
 161:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if defined __ARMVFP__
 162:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1U)
 163:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 164:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 165:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #error "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESENT)
 166:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 167:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 168:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 169:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 170:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 171:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 172:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __TMS470__ )
 173:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if defined __TI_VFP_SUPPORT__
 174:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1U)
 175:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 176:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 177:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #error "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESENT)
 178:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 179:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 180:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 181:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 182:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 183:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 184:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __TASKING__ )
 185:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if defined __FPU_VFP__
 186:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1U)
 187:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 188:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 189:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #error "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESENT)
 190:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 191:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 192:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 193:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 194:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 195:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 196:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #elif defined ( __CSMC__ )
 197:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #if ( __CSMC__ & 0x400U)
 198:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #if (__FPU_PRESENT == 1U)
 199:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       1U
 200:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #else
 201:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #error "Compiler generates FPU instructions for a device without an FPU (check __FPU_PRESENT)
 202:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****       #define __FPU_USED       0U
 203:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #endif
 204:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #else
 205:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_USED         0U
 206:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 207:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 208:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
 209:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 210:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #include "core_cmInstr.h"                /* Core Instruction Access */
 211:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #include "core_cmFunc.h"                 /* Core Function Access */
 212:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #include "core_cmSimd.h"                 /* Compiler specific SIMD Intrinsics */
 213:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 214:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifdef __cplusplus
 215:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 216:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
 217:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 218:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif /* __CORE_CM4_H_GENERIC */
 219:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 220:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifndef __CMSIS_GENERIC
 221:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 222:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifndef __CORE_CM4_H_DEPENDANT
 223:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define __CORE_CM4_H_DEPENDANT
 224:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 225:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifdef __cplusplus
 226:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  extern "C" {
 227:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
 228:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 229:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* check device defines and use defaults */
 230:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if defined __CHECK_DEVICE_DEFINES
 231:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #ifndef __CM4_REV
 232:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __CM4_REV               0x0000U
 233:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #warning "__CM4_REV not defined in device header file; using default!"
 234:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 235:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 236:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #ifndef __FPU_PRESENT
 237:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __FPU_PRESENT             0U
 238:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #warning "__FPU_PRESENT not defined in device header file; using default!"
 239:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 240:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 241:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #ifndef __MPU_PRESENT
 242:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __MPU_PRESENT             0U
 243:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #warning "__MPU_PRESENT not defined in device header file; using default!"
 244:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 245:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 246:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #ifndef __NVIC_PRIO_BITS
 247:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __NVIC_PRIO_BITS          4U
 248:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #warning "__NVIC_PRIO_BITS not defined in device header file; using default!"
 249:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 250:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 251:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #ifndef __Vendor_SysTickConfig
 252:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #define __Vendor_SysTickConfig    0U
 253:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     #warning "__Vendor_SysTickConfig not defined in device header file; using default!"
 254:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #endif
 255:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
 256:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 257:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* IO definitions (access restrictions to peripheral registers) */
 258:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 259:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     \defgroup CMSIS_glob_defs CMSIS Global Defines
 260:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 261:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     <strong>IO Type Qualifiers</strong> are used
 262:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     \li to specify the access to peripheral variables.
 263:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     \li for automatic generation of peripheral register debug information.
 264:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** */
 265:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #ifdef __cplusplus
 266:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define   __I     volatile             /*!< Defines 'read only' permissions */
 267:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #else
 268:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define   __I     volatile const       /*!< Defines 'read only' permissions */
 269:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
 270:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define     __O     volatile             /*!< Defines 'write only' permissions */
 271:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define     __IO    volatile             /*!< Defines 'read / write' permissions */
 272:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 273:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* following defines should be used for structure members */
 274:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define     __IM     volatile const      /*! Defines 'read only' structure member permissions */
 275:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define     __OM     volatile            /*! Defines 'write only' structure member permissions */
 276:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define     __IOM    volatile            /*! Defines 'read / write' structure member permissions */
 277:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 278:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group Cortex_M4 */
 279:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 280:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 281:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 282:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*******************************************************************************
 283:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  *                 Register Abstraction
 284:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   Core Register contain:
 285:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core Register
 286:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core NVIC Register
 287:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core SCB Register
 288:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core SysTick Register
 289:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core Debug Register
 290:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core MPU Register
 291:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core FPU Register
 292:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  ******************************************************************************/
 293:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 294:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_core_register Defines and Type Definitions
 295:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief Type definitions and defines for Cortex-M processor based devices.
 296:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** */
 297:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 298:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 299:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup    CMSIS_core_register
 300:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup   CMSIS_CORE  Status and Control Registers
 301:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief      Core Register type definitions.
 302:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 303:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 304:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 305:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 306:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Union type to access the Application Program Status Register (APSR).
 307:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 308:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef union
 309:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 310:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   struct
 311:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
 312:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t _reserved0:16;              /*!< bit:  0..15  Reserved */
 313:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t GE:4;                       /*!< bit: 16..19  Greater than or Equal flags */
 314:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t _reserved1:7;               /*!< bit: 20..26  Reserved */
 315:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t Q:1;                        /*!< bit:     27  Saturation condition flag */
 316:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t V:1;                        /*!< bit:     28  Overflow condition code flag */
 317:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t C:1;                        /*!< bit:     29  Carry condition code flag */
 318:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t Z:1;                        /*!< bit:     30  Zero condition code flag */
 319:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t N:1;                        /*!< bit:     31  Negative condition code flag */
 320:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   } b;                                   /*!< Structure used for bit  access */
 321:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   uint32_t w;                            /*!< Type      used for word access */
 322:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } APSR_Type;
 323:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 324:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* APSR Register Definitions */
 325:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_N_Pos                         31U                                            /*!< APSR
 326:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_N_Msk                         (1UL << APSR_N_Pos)                            /*!< APSR
 327:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 328:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_Z_Pos                         30U                                            /*!< APSR
 329:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_Z_Msk                         (1UL << APSR_Z_Pos)                            /*!< APSR
 330:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 331:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_C_Pos                         29U                                            /*!< APSR
 332:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_C_Msk                         (1UL << APSR_C_Pos)                            /*!< APSR
 333:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 334:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_V_Pos                         28U                                            /*!< APSR
 335:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_V_Msk                         (1UL << APSR_V_Pos)                            /*!< APSR
 336:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 337:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_Q_Pos                         27U                                            /*!< APSR
 338:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_Q_Msk                         (1UL << APSR_Q_Pos)                            /*!< APSR
 339:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 340:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_GE_Pos                        16U                                            /*!< APSR
 341:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define APSR_GE_Msk                        (0xFUL << APSR_GE_Pos)                         /*!< APSR
 342:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 343:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 344:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 345:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Union type to access the Interrupt Program Status Register (IPSR).
 346:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 347:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef union
 348:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 349:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   struct
 350:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
 351:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t ISR:9;                      /*!< bit:  0.. 8  Exception number */
 352:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t _reserved0:23;              /*!< bit:  9..31  Reserved */
 353:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   } b;                                   /*!< Structure used for bit  access */
 354:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   uint32_t w;                            /*!< Type      used for word access */
 355:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } IPSR_Type;
 356:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 357:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* IPSR Register Definitions */
 358:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define IPSR_ISR_Pos                        0U                                            /*!< IPSR
 359:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define IPSR_ISR_Msk                       (0x1FFUL /*<< IPSR_ISR_Pos*/)                  /*!< IPSR
 360:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 361:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 362:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 363:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Union type to access the Special-Purpose Program Status Registers (xPSR).
 364:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 365:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef union
 366:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 367:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   struct
 368:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
 369:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t ISR:9;                      /*!< bit:  0.. 8  Exception number */
 370:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t _reserved0:7;               /*!< bit:  9..15  Reserved */
 371:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t GE:4;                       /*!< bit: 16..19  Greater than or Equal flags */
 372:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t _reserved1:4;               /*!< bit: 20..23  Reserved */
 373:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t T:1;                        /*!< bit:     24  Thumb bit        (read 0) */
 374:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t IT:2;                       /*!< bit: 25..26  saved IT state   (read 0) */
 375:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t Q:1;                        /*!< bit:     27  Saturation condition flag */
 376:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t V:1;                        /*!< bit:     28  Overflow condition code flag */
 377:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t C:1;                        /*!< bit:     29  Carry condition code flag */
 378:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t Z:1;                        /*!< bit:     30  Zero condition code flag */
 379:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t N:1;                        /*!< bit:     31  Negative condition code flag */
 380:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   } b;                                   /*!< Structure used for bit  access */
 381:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   uint32_t w;                            /*!< Type      used for word access */
 382:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } xPSR_Type;
 383:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 384:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* xPSR Register Definitions */
 385:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_N_Pos                         31U                                            /*!< xPSR
 386:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_N_Msk                         (1UL << xPSR_N_Pos)                            /*!< xPSR
 387:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 388:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_Z_Pos                         30U                                            /*!< xPSR
 389:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_Z_Msk                         (1UL << xPSR_Z_Pos)                            /*!< xPSR
 390:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 391:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_C_Pos                         29U                                            /*!< xPSR
 392:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_C_Msk                         (1UL << xPSR_C_Pos)                            /*!< xPSR
 393:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 394:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_V_Pos                         28U                                            /*!< xPSR
 395:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_V_Msk                         (1UL << xPSR_V_Pos)                            /*!< xPSR
 396:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 397:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_Q_Pos                         27U                                            /*!< xPSR
 398:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_Q_Msk                         (1UL << xPSR_Q_Pos)                            /*!< xPSR
 399:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 400:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_IT_Pos                        25U                                            /*!< xPSR
 401:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_IT_Msk                        (3UL << xPSR_IT_Pos)                           /*!< xPSR
 402:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 403:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_T_Pos                         24U                                            /*!< xPSR
 404:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_T_Msk                         (1UL << xPSR_T_Pos)                            /*!< xPSR
 405:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 406:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_GE_Pos                        16U                                            /*!< xPSR
 407:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_GE_Msk                        (0xFUL << xPSR_GE_Pos)                         /*!< xPSR
 408:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 409:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_ISR_Pos                        0U                                            /*!< xPSR
 410:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define xPSR_ISR_Msk                       (0x1FFUL /*<< xPSR_ISR_Pos*/)                  /*!< xPSR
 411:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 412:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 413:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 414:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Union type to access the Control Registers (CONTROL).
 415:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 416:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef union
 417:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 418:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   struct
 419:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
 420:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t nPRIV:1;                    /*!< bit:      0  Execution privilege in Thread mode */
 421:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t SPSEL:1;                    /*!< bit:      1  Stack to be used */
 422:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t FPCA:1;                     /*!< bit:      2  FP extension active flag */
 423:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     uint32_t _reserved0:29;              /*!< bit:  3..31  Reserved */
 424:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   } b;                                   /*!< Structure used for bit  access */
 425:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   uint32_t w;                            /*!< Type      used for word access */
 426:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } CONTROL_Type;
 427:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 428:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* CONTROL Register Definitions */
 429:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CONTROL_FPCA_Pos                    2U                                            /*!< CONT
 430:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CONTROL_FPCA_Msk                   (1UL << CONTROL_FPCA_Pos)                      /*!< CONT
 431:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 432:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CONTROL_SPSEL_Pos                   1U                                            /*!< CONT
 433:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CONTROL_SPSEL_Msk                  (1UL << CONTROL_SPSEL_Pos)                     /*!< CONT
 434:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 435:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CONTROL_nPRIV_Pos                   0U                                            /*!< CONT
 436:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CONTROL_nPRIV_Msk                  (1UL /*<< CONTROL_nPRIV_Pos*/)                 /*!< CONT
 437:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 438:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_CORE */
 439:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 440:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 441:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 442:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup    CMSIS_core_register
 443:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup   CMSIS_NVIC  Nested Vectored Interrupt Controller (NVIC)
 444:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief      Type definitions for the NVIC Registers
 445:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 446:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 447:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 448:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 449:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Nested Vectored Interrupt Controller (NVIC).
 450:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 451:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
 452:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 453:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ISER[8U];               /*!< Offset: 0x000 (R/W)  Interrupt Set Enable Register */
 454:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[24U];
 455:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ICER[8U];               /*!< Offset: 0x080 (R/W)  Interrupt Clear Enable Register 
 456:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RSERVED1[24U];
 457:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ISPR[8U];               /*!< Offset: 0x100 (R/W)  Interrupt Set Pending Register *
 458:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED2[24U];
 459:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ICPR[8U];               /*!< Offset: 0x180 (R/W)  Interrupt Clear Pending Register
 460:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED3[24U];
 461:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t IABR[8U];               /*!< Offset: 0x200 (R/W)  Interrupt Active bit Register */
 462:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED4[56U];
 463:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint8_t  IP[240U];               /*!< Offset: 0x300 (R/W)  Interrupt Priority Register (8Bi
 464:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED5[644U];
 465:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __OM  uint32_t STIR;                   /*!< Offset: 0xE00 ( /W)  Software Trigger Interrupt Regis
 466:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }  NVIC_Type;
 467:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 468:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Software Triggered Interrupt Register Definitions */
 469:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define NVIC_STIR_INTID_Pos                 0U                                         /*!< STIR: I
 470:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define NVIC_STIR_INTID_Msk                (0x1FFUL /*<< NVIC_STIR_INTID_Pos*/)        /*!< STIR: I
 471:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 472:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_NVIC */
 473:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 474:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 475:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 476:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
 477:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_SCB     System Control Block (SCB)
 478:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the System Control Block Registers
 479:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 480:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 481:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 482:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 483:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the System Control Block (SCB).
 484:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 485:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
 486:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 487:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t CPUID;                  /*!< Offset: 0x000 (R/ )  CPUID Base Register */
 488:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ICSR;                   /*!< Offset: 0x004 (R/W)  Interrupt Control and State Regi
 489:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t VTOR;                   /*!< Offset: 0x008 (R/W)  Vector Table Offset Register */
 490:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t AIRCR;                  /*!< Offset: 0x00C (R/W)  Application Interrupt and Reset 
 491:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t SCR;                    /*!< Offset: 0x010 (R/W)  System Control Register */
 492:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CCR;                    /*!< Offset: 0x014 (R/W)  Configuration Control Register *
 493:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint8_t  SHP[12U];               /*!< Offset: 0x018 (R/W)  System Handlers Priority Registe
 494:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t SHCSR;                  /*!< Offset: 0x024 (R/W)  System Handler Control and State
 495:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CFSR;                   /*!< Offset: 0x028 (R/W)  Configurable Fault Status Regist
 496:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t HFSR;                   /*!< Offset: 0x02C (R/W)  HardFault Status Register */
 497:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t DFSR;                   /*!< Offset: 0x030 (R/W)  Debug Fault Status Register */
 498:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t MMFAR;                  /*!< Offset: 0x034 (R/W)  MemManage Fault Address Register
 499:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t BFAR;                   /*!< Offset: 0x038 (R/W)  BusFault Address Register */
 500:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t AFSR;                   /*!< Offset: 0x03C (R/W)  Auxiliary Fault Status Register 
 501:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PFR[2U];                /*!< Offset: 0x040 (R/ )  Processor Feature Register */
 502:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t DFR;                    /*!< Offset: 0x048 (R/ )  Debug Feature Register */
 503:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t ADR;                    /*!< Offset: 0x04C (R/ )  Auxiliary Feature Register */
 504:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t MMFR[4U];               /*!< Offset: 0x050 (R/ )  Memory Model Feature Register */
 505:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t ISAR[5U];               /*!< Offset: 0x060 (R/ )  Instruction Set Attributes Regis
 506:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[5U];
 507:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CPACR;                  /*!< Offset: 0x088 (R/W)  Coprocessor Access Control Regis
 508:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } SCB_Type;
 509:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 510:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB CPUID Register Definitions */
 511:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_IMPLEMENTER_Pos          24U                                            /*!< SCB 
 512:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_IMPLEMENTER_Msk          (0xFFUL << SCB_CPUID_IMPLEMENTER_Pos)          /*!< SCB 
 513:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 514:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_VARIANT_Pos              20U                                            /*!< SCB 
 515:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_VARIANT_Msk              (0xFUL << SCB_CPUID_VARIANT_Pos)               /*!< SCB 
 516:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 517:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_ARCHITECTURE_Pos         16U                                            /*!< SCB 
 518:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_ARCHITECTURE_Msk         (0xFUL << SCB_CPUID_ARCHITECTURE_Pos)          /*!< SCB 
 519:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 520:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_PARTNO_Pos                4U                                            /*!< SCB 
 521:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_PARTNO_Msk               (0xFFFUL << SCB_CPUID_PARTNO_Pos)              /*!< SCB 
 522:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 523:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_REVISION_Pos              0U                                            /*!< SCB 
 524:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CPUID_REVISION_Msk             (0xFUL /*<< SCB_CPUID_REVISION_Pos*/)          /*!< SCB 
 525:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 526:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Interrupt Control State Register Definitions */
 527:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_NMIPENDSET_Pos            31U                                            /*!< SCB 
 528:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_NMIPENDSET_Msk            (1UL << SCB_ICSR_NMIPENDSET_Pos)               /*!< SCB 
 529:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 530:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSVSET_Pos             28U                                            /*!< SCB 
 531:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSVSET_Msk             (1UL << SCB_ICSR_PENDSVSET_Pos)                /*!< SCB 
 532:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 533:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSVCLR_Pos             27U                                            /*!< SCB 
 534:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSVCLR_Msk             (1UL << SCB_ICSR_PENDSVCLR_Pos)                /*!< SCB 
 535:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 536:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSTSET_Pos             26U                                            /*!< SCB 
 537:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSTSET_Msk             (1UL << SCB_ICSR_PENDSTSET_Pos)                /*!< SCB 
 538:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 539:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSTCLR_Pos             25U                                            /*!< SCB 
 540:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_PENDSTCLR_Msk             (1UL << SCB_ICSR_PENDSTCLR_Pos)                /*!< SCB 
 541:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 542:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_ISRPREEMPT_Pos            23U                                            /*!< SCB 
 543:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_ISRPREEMPT_Msk            (1UL << SCB_ICSR_ISRPREEMPT_Pos)               /*!< SCB 
 544:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 545:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_ISRPENDING_Pos            22U                                            /*!< SCB 
 546:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_ISRPENDING_Msk            (1UL << SCB_ICSR_ISRPENDING_Pos)               /*!< SCB 
 547:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 548:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_VECTPENDING_Pos           12U                                            /*!< SCB 
 549:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_VECTPENDING_Msk           (0x1FFUL << SCB_ICSR_VECTPENDING_Pos)          /*!< SCB 
 550:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 551:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_RETTOBASE_Pos             11U                                            /*!< SCB 
 552:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_RETTOBASE_Msk             (1UL << SCB_ICSR_RETTOBASE_Pos)                /*!< SCB 
 553:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 554:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_VECTACTIVE_Pos             0U                                            /*!< SCB 
 555:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_ICSR_VECTACTIVE_Msk            (0x1FFUL /*<< SCB_ICSR_VECTACTIVE_Pos*/)       /*!< SCB 
 556:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 557:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Vector Table Offset Register Definitions */
 558:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_VTOR_TBLOFF_Pos                 7U                                            /*!< SCB 
 559:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_VTOR_TBLOFF_Msk                (0x1FFFFFFUL << SCB_VTOR_TBLOFF_Pos)           /*!< SCB 
 560:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 561:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Application Interrupt and Reset Control Register Definitions */
 562:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTKEY_Pos              16U                                            /*!< SCB 
 563:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTKEY_Msk              (0xFFFFUL << SCB_AIRCR_VECTKEY_Pos)            /*!< SCB 
 564:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 565:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTKEYSTAT_Pos          16U                                            /*!< SCB 
 566:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTKEYSTAT_Msk          (0xFFFFUL << SCB_AIRCR_VECTKEYSTAT_Pos)        /*!< SCB 
 567:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 568:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_ENDIANESS_Pos            15U                                            /*!< SCB 
 569:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_ENDIANESS_Msk            (1UL << SCB_AIRCR_ENDIANESS_Pos)               /*!< SCB 
 570:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 571:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_PRIGROUP_Pos              8U                                            /*!< SCB 
 572:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_PRIGROUP_Msk             (7UL << SCB_AIRCR_PRIGROUP_Pos)                /*!< SCB 
 573:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 574:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_SYSRESETREQ_Pos           2U                                            /*!< SCB 
 575:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_SYSRESETREQ_Msk          (1UL << SCB_AIRCR_SYSRESETREQ_Pos)             /*!< SCB 
 576:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 577:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTCLRACTIVE_Pos         1U                                            /*!< SCB 
 578:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTCLRACTIVE_Msk        (1UL << SCB_AIRCR_VECTCLRACTIVE_Pos)           /*!< SCB 
 579:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 580:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTRESET_Pos             0U                                            /*!< SCB 
 581:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_AIRCR_VECTRESET_Msk            (1UL /*<< SCB_AIRCR_VECTRESET_Pos*/)           /*!< SCB 
 582:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 583:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB System Control Register Definitions */
 584:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SCR_SEVONPEND_Pos               4U                                            /*!< SCB 
 585:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SCR_SEVONPEND_Msk              (1UL << SCB_SCR_SEVONPEND_Pos)                 /*!< SCB 
 586:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 587:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SCR_SLEEPDEEP_Pos               2U                                            /*!< SCB 
 588:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SCR_SLEEPDEEP_Msk              (1UL << SCB_SCR_SLEEPDEEP_Pos)                 /*!< SCB 
 589:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 590:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SCR_SLEEPONEXIT_Pos             1U                                            /*!< SCB 
 591:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SCR_SLEEPONEXIT_Msk            (1UL << SCB_SCR_SLEEPONEXIT_Pos)               /*!< SCB 
 592:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 593:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Configuration Control Register Definitions */
 594:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_STKALIGN_Pos                9U                                            /*!< SCB 
 595:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_STKALIGN_Msk               (1UL << SCB_CCR_STKALIGN_Pos)                  /*!< SCB 
 596:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 597:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_BFHFNMIGN_Pos               8U                                            /*!< SCB 
 598:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_BFHFNMIGN_Msk              (1UL << SCB_CCR_BFHFNMIGN_Pos)                 /*!< SCB 
 599:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 600:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_DIV_0_TRP_Pos               4U                                            /*!< SCB 
 601:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_DIV_0_TRP_Msk              (1UL << SCB_CCR_DIV_0_TRP_Pos)                 /*!< SCB 
 602:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 603:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_UNALIGN_TRP_Pos             3U                                            /*!< SCB 
 604:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_UNALIGN_TRP_Msk            (1UL << SCB_CCR_UNALIGN_TRP_Pos)               /*!< SCB 
 605:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 606:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_USERSETMPEND_Pos            1U                                            /*!< SCB 
 607:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_USERSETMPEND_Msk           (1UL << SCB_CCR_USERSETMPEND_Pos)              /*!< SCB 
 608:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 609:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_NONBASETHRDENA_Pos          0U                                            /*!< SCB 
 610:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CCR_NONBASETHRDENA_Msk         (1UL /*<< SCB_CCR_NONBASETHRDENA_Pos*/)        /*!< SCB 
 611:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 612:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB System Handler Control and State Register Definitions */
 613:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_USGFAULTENA_Pos          18U                                            /*!< SCB 
 614:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_USGFAULTENA_Msk          (1UL << SCB_SHCSR_USGFAULTENA_Pos)             /*!< SCB 
 615:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 616:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_BUSFAULTENA_Pos          17U                                            /*!< SCB 
 617:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_BUSFAULTENA_Msk          (1UL << SCB_SHCSR_BUSFAULTENA_Pos)             /*!< SCB 
 618:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 619:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MEMFAULTENA_Pos          16U                                            /*!< SCB 
 620:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MEMFAULTENA_Msk          (1UL << SCB_SHCSR_MEMFAULTENA_Pos)             /*!< SCB 
 621:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 622:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_SVCALLPENDED_Pos         15U                                            /*!< SCB 
 623:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_SVCALLPENDED_Msk         (1UL << SCB_SHCSR_SVCALLPENDED_Pos)            /*!< SCB 
 624:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 625:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_BUSFAULTPENDED_Pos       14U                                            /*!< SCB 
 626:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_BUSFAULTPENDED_Msk       (1UL << SCB_SHCSR_BUSFAULTPENDED_Pos)          /*!< SCB 
 627:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MEMFAULTPENDED_Pos       13U                                            /*!< SCB 
 629:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MEMFAULTPENDED_Msk       (1UL << SCB_SHCSR_MEMFAULTPENDED_Pos)          /*!< SCB 
 630:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 631:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_USGFAULTPENDED_Pos       12U                                            /*!< SCB 
 632:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_USGFAULTPENDED_Msk       (1UL << SCB_SHCSR_USGFAULTPENDED_Pos)          /*!< SCB 
 633:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 634:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_SYSTICKACT_Pos           11U                                            /*!< SCB 
 635:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_SYSTICKACT_Msk           (1UL << SCB_SHCSR_SYSTICKACT_Pos)              /*!< SCB 
 636:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 637:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_PENDSVACT_Pos            10U                                            /*!< SCB 
 638:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_PENDSVACT_Msk            (1UL << SCB_SHCSR_PENDSVACT_Pos)               /*!< SCB 
 639:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 640:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MONITORACT_Pos            8U                                            /*!< SCB 
 641:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MONITORACT_Msk           (1UL << SCB_SHCSR_MONITORACT_Pos)              /*!< SCB 
 642:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 643:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_SVCALLACT_Pos             7U                                            /*!< SCB 
 644:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_SVCALLACT_Msk            (1UL << SCB_SHCSR_SVCALLACT_Pos)               /*!< SCB 
 645:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 646:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_USGFAULTACT_Pos           3U                                            /*!< SCB 
 647:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_USGFAULTACT_Msk          (1UL << SCB_SHCSR_USGFAULTACT_Pos)             /*!< SCB 
 648:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 649:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_BUSFAULTACT_Pos           1U                                            /*!< SCB 
 650:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_BUSFAULTACT_Msk          (1UL << SCB_SHCSR_BUSFAULTACT_Pos)             /*!< SCB 
 651:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 652:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MEMFAULTACT_Pos           0U                                            /*!< SCB 
 653:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_SHCSR_MEMFAULTACT_Msk          (1UL /*<< SCB_SHCSR_MEMFAULTACT_Pos*/)         /*!< SCB 
 654:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 655:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Configurable Fault Status Register Definitions */
 656:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CFSR_USGFAULTSR_Pos            16U                                            /*!< SCB 
 657:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CFSR_USGFAULTSR_Msk            (0xFFFFUL << SCB_CFSR_USGFAULTSR_Pos)          /*!< SCB 
 658:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 659:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CFSR_BUSFAULTSR_Pos             8U                                            /*!< SCB 
 660:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CFSR_BUSFAULTSR_Msk            (0xFFUL << SCB_CFSR_BUSFAULTSR_Pos)            /*!< SCB 
 661:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 662:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CFSR_MEMFAULTSR_Pos             0U                                            /*!< SCB 
 663:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_CFSR_MEMFAULTSR_Msk            (0xFFUL /*<< SCB_CFSR_MEMFAULTSR_Pos*/)        /*!< SCB 
 664:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 665:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Hard Fault Status Register Definitions */
 666:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_HFSR_DEBUGEVT_Pos              31U                                            /*!< SCB 
 667:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_HFSR_DEBUGEVT_Msk              (1UL << SCB_HFSR_DEBUGEVT_Pos)                 /*!< SCB 
 668:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 669:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_HFSR_FORCED_Pos                30U                                            /*!< SCB 
 670:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_HFSR_FORCED_Msk                (1UL << SCB_HFSR_FORCED_Pos)                   /*!< SCB 
 671:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 672:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_HFSR_VECTTBL_Pos                1U                                            /*!< SCB 
 673:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_HFSR_VECTTBL_Msk               (1UL << SCB_HFSR_VECTTBL_Pos)                  /*!< SCB 
 674:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 675:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SCB Debug Fault Status Register Definitions */
 676:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_EXTERNAL_Pos               4U                                            /*!< SCB 
 677:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_EXTERNAL_Msk              (1UL << SCB_DFSR_EXTERNAL_Pos)                 /*!< SCB 
 678:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 679:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_VCATCH_Pos                 3U                                            /*!< SCB 
 680:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_VCATCH_Msk                (1UL << SCB_DFSR_VCATCH_Pos)                   /*!< SCB 
 681:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 682:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_DWTTRAP_Pos                2U                                            /*!< SCB 
 683:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_DWTTRAP_Msk               (1UL << SCB_DFSR_DWTTRAP_Pos)                  /*!< SCB 
 684:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 685:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_BKPT_Pos                   1U                                            /*!< SCB 
 686:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_BKPT_Msk                  (1UL << SCB_DFSR_BKPT_Pos)                     /*!< SCB 
 687:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 688:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_HALTED_Pos                 0U                                            /*!< SCB 
 689:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_DFSR_HALTED_Msk                (1UL /*<< SCB_DFSR_HALTED_Pos*/)               /*!< SCB 
 690:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 691:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_SCB */
 692:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 693:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 694:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 695:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
 696:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_SCnSCB System Controls not in SCB (SCnSCB)
 697:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the System Control and ID Register not in the SCB
 698:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 699:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 700:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 701:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 702:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the System Control and ID Register not in the SCB.
 703:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 704:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
 705:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 706:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[1U];
 707:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t ICTR;                   /*!< Offset: 0x004 (R/ )  Interrupt Controller Type Regist
 708:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ACTLR;                  /*!< Offset: 0x008 (R/W)  Auxiliary Control Register */
 709:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } SCnSCB_Type;
 710:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 711:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Interrupt Controller Type Register Definitions */
 712:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ICTR_INTLINESNUM_Pos         0U                                         /*!< ICTR: I
 713:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ICTR_INTLINESNUM_Msk        (0xFUL /*<< SCnSCB_ICTR_INTLINESNUM_Pos*/)  /*!< ICTR: I
 714:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 715:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Auxiliary Control Register Definitions */
 716:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISOOFP_Pos            9U                                         /*!< ACTLR: 
 717:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISOOFP_Msk           (1UL << SCnSCB_ACTLR_DISOOFP_Pos)           /*!< ACTLR: 
 718:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 719:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISFPCA_Pos            8U                                         /*!< ACTLR: 
 720:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISFPCA_Msk           (1UL << SCnSCB_ACTLR_DISFPCA_Pos)           /*!< ACTLR: 
 721:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 722:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISFOLD_Pos            2U                                         /*!< ACTLR: 
 723:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISFOLD_Msk           (1UL << SCnSCB_ACTLR_DISFOLD_Pos)           /*!< ACTLR: 
 724:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 725:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISDEFWBUF_Pos         1U                                         /*!< ACTLR: 
 726:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISDEFWBUF_Msk        (1UL << SCnSCB_ACTLR_DISDEFWBUF_Pos)        /*!< ACTLR: 
 727:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 728:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISMCYCINT_Pos         0U                                         /*!< ACTLR: 
 729:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB_ACTLR_DISMCYCINT_Msk        (1UL /*<< SCnSCB_ACTLR_DISMCYCINT_Pos*/)    /*!< ACTLR: 
 730:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 731:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_SCnotSCB */
 732:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 733:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 734:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 735:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
 736:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_SysTick     System Tick Timer (SysTick)
 737:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the System Timer Registers.
 738:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 739:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 740:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 741:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 742:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the System Timer (SysTick).
 743:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 744:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
 745:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 746:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CTRL;                   /*!< Offset: 0x000 (R/W)  SysTick Control and Status Regis
 747:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t LOAD;                   /*!< Offset: 0x004 (R/W)  SysTick Reload Value Register */
 748:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t VAL;                    /*!< Offset: 0x008 (R/W)  SysTick Current Value Register *
 749:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t CALIB;                  /*!< Offset: 0x00C (R/ )  SysTick Calibration Register */
 750:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } SysTick_Type;
 751:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 752:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SysTick Control / Status Register Definitions */
 753:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_COUNTFLAG_Pos         16U                                            /*!< SysT
 754:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_COUNTFLAG_Msk         (1UL << SysTick_CTRL_COUNTFLAG_Pos)            /*!< SysT
 755:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 756:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_CLKSOURCE_Pos          2U                                            /*!< SysT
 757:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_CLKSOURCE_Msk         (1UL << SysTick_CTRL_CLKSOURCE_Pos)            /*!< SysT
 758:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 759:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_TICKINT_Pos            1U                                            /*!< SysT
 760:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_TICKINT_Msk           (1UL << SysTick_CTRL_TICKINT_Pos)              /*!< SysT
 761:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 762:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_ENABLE_Pos             0U                                            /*!< SysT
 763:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CTRL_ENABLE_Msk            (1UL /*<< SysTick_CTRL_ENABLE_Pos*/)           /*!< SysT
 764:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 765:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SysTick Reload Register Definitions */
 766:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_LOAD_RELOAD_Pos             0U                                            /*!< SysT
 767:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_LOAD_RELOAD_Msk            (0xFFFFFFUL /*<< SysTick_LOAD_RELOAD_Pos*/)    /*!< SysT
 768:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 769:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SysTick Current Register Definitions */
 770:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_VAL_CURRENT_Pos             0U                                            /*!< SysT
 771:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_VAL_CURRENT_Msk            (0xFFFFFFUL /*<< SysTick_VAL_CURRENT_Pos*/)    /*!< SysT
 772:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 773:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* SysTick Calibration Register Definitions */
 774:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CALIB_NOREF_Pos            31U                                            /*!< SysT
 775:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CALIB_NOREF_Msk            (1UL << SysTick_CALIB_NOREF_Pos)               /*!< SysT
 776:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 777:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CALIB_SKEW_Pos             30U                                            /*!< SysT
 778:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CALIB_SKEW_Msk             (1UL << SysTick_CALIB_SKEW_Pos)                /*!< SysT
 779:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 780:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CALIB_TENMS_Pos             0U                                            /*!< SysT
 781:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_CALIB_TENMS_Msk            (0xFFFFFFUL /*<< SysTick_CALIB_TENMS_Pos*/)    /*!< SysT
 782:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 783:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_SysTick */
 784:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 785:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 786:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 787:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
 788:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_ITM     Instrumentation Trace Macrocell (ITM)
 789:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the Instrumentation Trace Macrocell (ITM)
 790:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 791:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 792:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 793:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 794:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Instrumentation Trace Macrocell Register (ITM).
 795:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 796:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
 797:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 798:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __OM  union
 799:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
 800:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     __OM  uint8_t    u8;                 /*!< Offset: 0x000 ( /W)  ITM Stimulus Port 8-bit */
 801:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     __OM  uint16_t   u16;                /*!< Offset: 0x000 ( /W)  ITM Stimulus Port 16-bit */
 802:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     __OM  uint32_t   u32;                /*!< Offset: 0x000 ( /W)  ITM Stimulus Port 32-bit */
 803:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   }  PORT [32U];                         /*!< Offset: 0x000 ( /W)  ITM Stimulus Port Registers */
 804:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[864U];
 805:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t TER;                    /*!< Offset: 0xE00 (R/W)  ITM Trace Enable Register */
 806:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED1[15U];
 807:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t TPR;                    /*!< Offset: 0xE40 (R/W)  ITM Trace Privilege Register */
 808:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED2[15U];
 809:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t TCR;                    /*!< Offset: 0xE80 (R/W)  ITM Trace Control Register */
 810:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED3[29U];
 811:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __OM  uint32_t IWR;                    /*!< Offset: 0xEF8 ( /W)  ITM Integration Write Register *
 812:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t IRR;                    /*!< Offset: 0xEFC (R/ )  ITM Integration Read Register */
 813:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t IMCR;                   /*!< Offset: 0xF00 (R/W)  ITM Integration Mode Control Reg
 814:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED4[43U];
 815:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __OM  uint32_t LAR;                    /*!< Offset: 0xFB0 ( /W)  ITM Lock Access Register */
 816:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t LSR;                    /*!< Offset: 0xFB4 (R/ )  ITM Lock Status Register */
 817:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED5[6U];
 818:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID4;                   /*!< Offset: 0xFD0 (R/ )  ITM Peripheral Identification Re
 819:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID5;                   /*!< Offset: 0xFD4 (R/ )  ITM Peripheral Identification Re
 820:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID6;                   /*!< Offset: 0xFD8 (R/ )  ITM Peripheral Identification Re
 821:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID7;                   /*!< Offset: 0xFDC (R/ )  ITM Peripheral Identification Re
 822:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID0;                   /*!< Offset: 0xFE0 (R/ )  ITM Peripheral Identification Re
 823:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID1;                   /*!< Offset: 0xFE4 (R/ )  ITM Peripheral Identification Re
 824:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID2;                   /*!< Offset: 0xFE8 (R/ )  ITM Peripheral Identification Re
 825:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PID3;                   /*!< Offset: 0xFEC (R/ )  ITM Peripheral Identification Re
 826:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t CID0;                   /*!< Offset: 0xFF0 (R/ )  ITM Component  Identification Re
 827:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t CID1;                   /*!< Offset: 0xFF4 (R/ )  ITM Component  Identification Re
 828:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t CID2;                   /*!< Offset: 0xFF8 (R/ )  ITM Component  Identification Re
 829:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t CID3;                   /*!< Offset: 0xFFC (R/ )  ITM Component  Identification Re
 830:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } ITM_Type;
 831:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 832:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ITM Trace Privilege Register Definitions */
 833:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TPR_PRIVMASK_Pos                0U                                            /*!< ITM 
 834:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TPR_PRIVMASK_Msk               (0xFUL /*<< ITM_TPR_PRIVMASK_Pos*/)            /*!< ITM 
 835:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 836:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ITM Trace Control Register Definitions */
 837:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_BUSY_Pos                   23U                                            /*!< ITM 
 838:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_BUSY_Msk                   (1UL << ITM_TCR_BUSY_Pos)                      /*!< ITM 
 839:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 840:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_TraceBusID_Pos             16U                                            /*!< ITM 
 841:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_TraceBusID_Msk             (0x7FUL << ITM_TCR_TraceBusID_Pos)             /*!< ITM 
 842:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 843:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_GTSFREQ_Pos                10U                                            /*!< ITM 
 844:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_GTSFREQ_Msk                (3UL << ITM_TCR_GTSFREQ_Pos)                   /*!< ITM 
 845:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 846:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_TSPrescale_Pos              8U                                            /*!< ITM 
 847:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_TSPrescale_Msk             (3UL << ITM_TCR_TSPrescale_Pos)                /*!< ITM 
 848:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 849:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_SWOENA_Pos                  4U                                            /*!< ITM 
 850:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_SWOENA_Msk                 (1UL << ITM_TCR_SWOENA_Pos)                    /*!< ITM 
 851:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 852:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_DWTENA_Pos                  3U                                            /*!< ITM 
 853:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_DWTENA_Msk                 (1UL << ITM_TCR_DWTENA_Pos)                    /*!< ITM 
 854:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 855:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_SYNCENA_Pos                 2U                                            /*!< ITM 
 856:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_SYNCENA_Msk                (1UL << ITM_TCR_SYNCENA_Pos)                   /*!< ITM 
 857:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 858:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_TSENA_Pos                   1U                                            /*!< ITM 
 859:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_TSENA_Msk                  (1UL << ITM_TCR_TSENA_Pos)                     /*!< ITM 
 860:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 861:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_ITMENA_Pos                  0U                                            /*!< ITM 
 862:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_TCR_ITMENA_Msk                 (1UL /*<< ITM_TCR_ITMENA_Pos*/)                /*!< ITM 
 863:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 864:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ITM Integration Write Register Definitions */
 865:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_IWR_ATVALIDM_Pos                0U                                            /*!< ITM 
 866:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_IWR_ATVALIDM_Msk               (1UL /*<< ITM_IWR_ATVALIDM_Pos*/)              /*!< ITM 
 867:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 868:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ITM Integration Read Register Definitions */
 869:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_IRR_ATREADYM_Pos                0U                                            /*!< ITM 
 870:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_IRR_ATREADYM_Msk               (1UL /*<< ITM_IRR_ATREADYM_Pos*/)              /*!< ITM 
 871:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 872:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ITM Integration Mode Control Register Definitions */
 873:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_IMCR_INTEGRATION_Pos            0U                                            /*!< ITM 
 874:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_IMCR_INTEGRATION_Msk           (1UL /*<< ITM_IMCR_INTEGRATION_Pos*/)          /*!< ITM 
 875:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 876:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ITM Lock Status Register Definitions */
 877:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_LSR_ByteAcc_Pos                 2U                                            /*!< ITM 
 878:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_LSR_ByteAcc_Msk                (1UL << ITM_LSR_ByteAcc_Pos)                   /*!< ITM 
 879:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 880:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_LSR_Access_Pos                  1U                                            /*!< ITM 
 881:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_LSR_Access_Msk                 (1UL << ITM_LSR_Access_Pos)                    /*!< ITM 
 882:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 883:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_LSR_Present_Pos                 0U                                            /*!< ITM 
 884:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_LSR_Present_Msk                (1UL /*<< ITM_LSR_Present_Pos*/)               /*!< ITM 
 885:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 886:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@}*/ /* end of group CMSIS_ITM */
 887:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 888:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 889:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 890:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
 891:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_DWT     Data Watchpoint and Trace (DWT)
 892:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the Data Watchpoint and Trace (DWT)
 893:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
 894:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 895:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 896:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
 897:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Data Watchpoint and Trace Register (DWT).
 898:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
 899:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
 900:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
 901:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CTRL;                   /*!< Offset: 0x000 (R/W)  Control Register */
 902:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CYCCNT;                 /*!< Offset: 0x004 (R/W)  Cycle Count Register */
 903:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CPICNT;                 /*!< Offset: 0x008 (R/W)  CPI Count Register */
 904:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t EXCCNT;                 /*!< Offset: 0x00C (R/W)  Exception Overhead Count Registe
 905:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t SLEEPCNT;               /*!< Offset: 0x010 (R/W)  Sleep Count Register */
 906:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t LSUCNT;                 /*!< Offset: 0x014 (R/W)  LSU Count Register */
 907:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FOLDCNT;                /*!< Offset: 0x018 (R/W)  Folded-instruction Count Registe
 908:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t PCSR;                   /*!< Offset: 0x01C (R/ )  Program Counter Sample Register 
 909:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t COMP0;                  /*!< Offset: 0x020 (R/W)  Comparator Register 0 */
 910:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t MASK0;                  /*!< Offset: 0x024 (R/W)  Mask Register 0 */
 911:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FUNCTION0;              /*!< Offset: 0x028 (R/W)  Function Register 0 */
 912:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[1U];
 913:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t COMP1;                  /*!< Offset: 0x030 (R/W)  Comparator Register 1 */
 914:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t MASK1;                  /*!< Offset: 0x034 (R/W)  Mask Register 1 */
 915:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FUNCTION1;              /*!< Offset: 0x038 (R/W)  Function Register 1 */
 916:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED1[1U];
 917:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t COMP2;                  /*!< Offset: 0x040 (R/W)  Comparator Register 2 */
 918:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t MASK2;                  /*!< Offset: 0x044 (R/W)  Mask Register 2 */
 919:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FUNCTION2;              /*!< Offset: 0x048 (R/W)  Function Register 2 */
 920:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED2[1U];
 921:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t COMP3;                  /*!< Offset: 0x050 (R/W)  Comparator Register 3 */
 922:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t MASK3;                  /*!< Offset: 0x054 (R/W)  Mask Register 3 */
 923:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FUNCTION3;              /*!< Offset: 0x058 (R/W)  Function Register 3 */
 924:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } DWT_Type;
 925:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 926:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT Control Register Definitions */
 927:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NUMCOMP_Pos               28U                                         /*!< DWT CTR
 928:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NUMCOMP_Msk               (0xFUL << DWT_CTRL_NUMCOMP_Pos)             /*!< DWT CTR
 929:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 930:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOTRCPKT_Pos              27U                                         /*!< DWT CTR
 931:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOTRCPKT_Msk              (0x1UL << DWT_CTRL_NOTRCPKT_Pos)            /*!< DWT CTR
 932:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 933:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOEXTTRIG_Pos             26U                                         /*!< DWT CTR
 934:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOEXTTRIG_Msk             (0x1UL << DWT_CTRL_NOEXTTRIG_Pos)           /*!< DWT CTR
 935:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 936:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOCYCCNT_Pos              25U                                         /*!< DWT CTR
 937:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOCYCCNT_Msk              (0x1UL << DWT_CTRL_NOCYCCNT_Pos)            /*!< DWT CTR
 938:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 939:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOPRFCNT_Pos              24U                                         /*!< DWT CTR
 940:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_NOPRFCNT_Msk              (0x1UL << DWT_CTRL_NOPRFCNT_Pos)            /*!< DWT CTR
 941:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 942:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CYCEVTENA_Pos             22U                                         /*!< DWT CTR
 943:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CYCEVTENA_Msk             (0x1UL << DWT_CTRL_CYCEVTENA_Pos)           /*!< DWT CTR
 944:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 945:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_FOLDEVTENA_Pos            21U                                         /*!< DWT CTR
 946:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_FOLDEVTENA_Msk            (0x1UL << DWT_CTRL_FOLDEVTENA_Pos)          /*!< DWT CTR
 947:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 948:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_LSUEVTENA_Pos             20U                                         /*!< DWT CTR
 949:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_LSUEVTENA_Msk             (0x1UL << DWT_CTRL_LSUEVTENA_Pos)           /*!< DWT CTR
 950:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 951:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_SLEEPEVTENA_Pos           19U                                         /*!< DWT CTR
 952:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_SLEEPEVTENA_Msk           (0x1UL << DWT_CTRL_SLEEPEVTENA_Pos)         /*!< DWT CTR
 953:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 954:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_EXCEVTENA_Pos             18U                                         /*!< DWT CTR
 955:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_EXCEVTENA_Msk             (0x1UL << DWT_CTRL_EXCEVTENA_Pos)           /*!< DWT CTR
 956:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 957:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CPIEVTENA_Pos             17U                                         /*!< DWT CTR
 958:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CPIEVTENA_Msk             (0x1UL << DWT_CTRL_CPIEVTENA_Pos)           /*!< DWT CTR
 959:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 960:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_EXCTRCENA_Pos             16U                                         /*!< DWT CTR
 961:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_EXCTRCENA_Msk             (0x1UL << DWT_CTRL_EXCTRCENA_Pos)           /*!< DWT CTR
 962:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 963:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_PCSAMPLENA_Pos            12U                                         /*!< DWT CTR
 964:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_PCSAMPLENA_Msk            (0x1UL << DWT_CTRL_PCSAMPLENA_Pos)          /*!< DWT CTR
 965:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 966:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_SYNCTAP_Pos               10U                                         /*!< DWT CTR
 967:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_SYNCTAP_Msk               (0x3UL << DWT_CTRL_SYNCTAP_Pos)             /*!< DWT CTR
 968:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 969:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CYCTAP_Pos                 9U                                         /*!< DWT CTR
 970:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CYCTAP_Msk                (0x1UL << DWT_CTRL_CYCTAP_Pos)              /*!< DWT CTR
 971:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 972:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_POSTINIT_Pos               5U                                         /*!< DWT CTR
 973:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_POSTINIT_Msk              (0xFUL << DWT_CTRL_POSTINIT_Pos)            /*!< DWT CTR
 974:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 975:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_POSTPRESET_Pos             1U                                         /*!< DWT CTR
 976:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_POSTPRESET_Msk            (0xFUL << DWT_CTRL_POSTPRESET_Pos)          /*!< DWT CTR
 977:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 978:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CYCCNTENA_Pos              0U                                         /*!< DWT CTR
 979:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CTRL_CYCCNTENA_Msk             (0x1UL /*<< DWT_CTRL_CYCCNTENA_Pos*/)       /*!< DWT CTR
 980:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 981:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT CPI Count Register Definitions */
 982:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CPICNT_CPICNT_Pos               0U                                         /*!< DWT CPI
 983:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_CPICNT_CPICNT_Msk              (0xFFUL /*<< DWT_CPICNT_CPICNT_Pos*/)       /*!< DWT CPI
 984:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 985:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT Exception Overhead Count Register Definitions */
 986:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_EXCCNT_EXCCNT_Pos               0U                                         /*!< DWT EXC
 987:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_EXCCNT_EXCCNT_Msk              (0xFFUL /*<< DWT_EXCCNT_EXCCNT_Pos*/)       /*!< DWT EXC
 988:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 989:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT Sleep Count Register Definitions */
 990:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_SLEEPCNT_SLEEPCNT_Pos           0U                                         /*!< DWT SLE
 991:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_SLEEPCNT_SLEEPCNT_Msk          (0xFFUL /*<< DWT_SLEEPCNT_SLEEPCNT_Pos*/)   /*!< DWT SLE
 992:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 993:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT LSU Count Register Definitions */
 994:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_LSUCNT_LSUCNT_Pos               0U                                         /*!< DWT LSU
 995:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_LSUCNT_LSUCNT_Msk              (0xFFUL /*<< DWT_LSUCNT_LSUCNT_Pos*/)       /*!< DWT LSU
 996:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
 997:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT Folded-instruction Count Register Definitions */
 998:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FOLDCNT_FOLDCNT_Pos             0U                                         /*!< DWT FOL
 999:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FOLDCNT_FOLDCNT_Msk            (0xFFUL /*<< DWT_FOLDCNT_FOLDCNT_Pos*/)     /*!< DWT FOL
1000:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1001:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT Comparator Mask Register Definitions */
1002:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_MASK_MASK_Pos                   0U                                         /*!< DWT MAS
1003:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_MASK_MASK_Msk                  (0x1FUL /*<< DWT_MASK_MASK_Pos*/)           /*!< DWT MAS
1004:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1005:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* DWT Comparator Function Register Definitions */
1006:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_MATCHED_Pos           24U                                         /*!< DWT FUN
1007:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_MATCHED_Msk           (0x1UL << DWT_FUNCTION_MATCHED_Pos)         /*!< DWT FUN
1008:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1009:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVADDR1_Pos        16U                                         /*!< DWT FUN
1010:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVADDR1_Msk        (0xFUL << DWT_FUNCTION_DATAVADDR1_Pos)      /*!< DWT FUN
1011:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1012:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVADDR0_Pos        12U                                         /*!< DWT FUN
1013:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVADDR0_Msk        (0xFUL << DWT_FUNCTION_DATAVADDR0_Pos)      /*!< DWT FUN
1014:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1015:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVSIZE_Pos         10U                                         /*!< DWT FUN
1016:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVSIZE_Msk         (0x3UL << DWT_FUNCTION_DATAVSIZE_Pos)       /*!< DWT FUN
1017:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1018:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_LNK1ENA_Pos            9U                                         /*!< DWT FUN
1019:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_LNK1ENA_Msk           (0x1UL << DWT_FUNCTION_LNK1ENA_Pos)         /*!< DWT FUN
1020:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1021:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVMATCH_Pos         8U                                         /*!< DWT FUN
1022:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_DATAVMATCH_Msk        (0x1UL << DWT_FUNCTION_DATAVMATCH_Pos)      /*!< DWT FUN
1023:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1024:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_CYCMATCH_Pos           7U                                         /*!< DWT FUN
1025:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_CYCMATCH_Msk          (0x1UL << DWT_FUNCTION_CYCMATCH_Pos)        /*!< DWT FUN
1026:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1027:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_EMITRANGE_Pos          5U                                         /*!< DWT FUN
1028:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_EMITRANGE_Msk         (0x1UL << DWT_FUNCTION_EMITRANGE_Pos)       /*!< DWT FUN
1029:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1030:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_FUNCTION_Pos           0U                                         /*!< DWT FUN
1031:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_FUNCTION_FUNCTION_Msk          (0xFUL /*<< DWT_FUNCTION_FUNCTION_Pos*/)    /*!< DWT FUN
1032:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1033:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@}*/ /* end of group CMSIS_DWT */
1034:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1035:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1036:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1037:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
1038:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_TPI     Trace Port Interface (TPI)
1039:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the Trace Port Interface (TPI)
1040:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1041:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1042:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1043:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1044:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Trace Port Interface Register (TPI).
1045:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1046:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
1047:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1048:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t SSPSR;                  /*!< Offset: 0x000 (R/ )  Supported Parallel Port Size Reg
1049:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CSPSR;                  /*!< Offset: 0x004 (R/W)  Current Parallel Port Size Regis
1050:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[2U];
1051:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ACPR;                   /*!< Offset: 0x010 (R/W)  Asynchronous Clock Prescaler Reg
1052:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED1[55U];
1053:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t SPPR;                   /*!< Offset: 0x0F0 (R/W)  Selected Pin Protocol Register *
1054:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED2[131U];
1055:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t FFSR;                   /*!< Offset: 0x300 (R/ )  Formatter and Flush Status Regis
1056:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FFCR;                   /*!< Offset: 0x304 (R/W)  Formatter and Flush Control Regi
1057:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t FSCR;                   /*!< Offset: 0x308 (R/ )  Formatter Synchronization Counte
1058:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED3[759U];
1059:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t TRIGGER;                /*!< Offset: 0xEE8 (R/ )  TRIGGER */
1060:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t FIFO0;                  /*!< Offset: 0xEEC (R/ )  Integration ETM Data */
1061:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t ITATBCTR2;              /*!< Offset: 0xEF0 (R/ )  ITATBCTR2 */
1062:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED4[1U];
1063:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t ITATBCTR0;              /*!< Offset: 0xEF8 (R/ )  ITATBCTR0 */
1064:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t FIFO1;                  /*!< Offset: 0xEFC (R/ )  Integration ITM Data */
1065:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t ITCTRL;                 /*!< Offset: 0xF00 (R/W)  Integration Mode Control */
1066:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED5[39U];
1067:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CLAIMSET;               /*!< Offset: 0xFA0 (R/W)  Claim tag set */
1068:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CLAIMCLR;               /*!< Offset: 0xFA4 (R/W)  Claim tag clear */
1069:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED7[8U];
1070:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t DEVID;                  /*!< Offset: 0xFC8 (R/ )  TPIU_DEVID */
1071:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t DEVTYPE;                /*!< Offset: 0xFCC (R/ )  TPIU_DEVTYPE */
1072:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } TPI_Type;
1073:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1074:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Asynchronous Clock Prescaler Register Definitions */
1075:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ACPR_PRESCALER_Pos              0U                                         /*!< TPI ACP
1076:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ACPR_PRESCALER_Msk             (0x1FFFUL /*<< TPI_ACPR_PRESCALER_Pos*/)    /*!< TPI ACP
1077:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1078:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Selected Pin Protocol Register Definitions */
1079:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_SPPR_TXMODE_Pos                 0U                                         /*!< TPI SPP
1080:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_SPPR_TXMODE_Msk                (0x3UL /*<< TPI_SPPR_TXMODE_Pos*/)          /*!< TPI SPP
1081:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1082:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Formatter and Flush Status Register Definitions */
1083:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_FtNonStop_Pos              3U                                         /*!< TPI FFS
1084:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_FtNonStop_Msk             (0x1UL << TPI_FFSR_FtNonStop_Pos)           /*!< TPI FFS
1085:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1086:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_TCPresent_Pos              2U                                         /*!< TPI FFS
1087:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_TCPresent_Msk             (0x1UL << TPI_FFSR_TCPresent_Pos)           /*!< TPI FFS
1088:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1089:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_FtStopped_Pos              1U                                         /*!< TPI FFS
1090:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_FtStopped_Msk             (0x1UL << TPI_FFSR_FtStopped_Pos)           /*!< TPI FFS
1091:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1092:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_FlInProg_Pos               0U                                         /*!< TPI FFS
1093:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFSR_FlInProg_Msk              (0x1UL /*<< TPI_FFSR_FlInProg_Pos*/)        /*!< TPI FFS
1094:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1095:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Formatter and Flush Control Register Definitions */
1096:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFCR_TrigIn_Pos                 8U                                         /*!< TPI FFC
1097:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFCR_TrigIn_Msk                (0x1UL << TPI_FFCR_TrigIn_Pos)              /*!< TPI FFC
1098:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1099:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFCR_EnFCont_Pos                1U                                         /*!< TPI FFC
1100:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FFCR_EnFCont_Msk               (0x1UL << TPI_FFCR_EnFCont_Pos)             /*!< TPI FFC
1101:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1102:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI TRIGGER Register Definitions */
1103:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_TRIGGER_TRIGGER_Pos             0U                                         /*!< TPI TRI
1104:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_TRIGGER_TRIGGER_Msk            (0x1UL /*<< TPI_TRIGGER_TRIGGER_Pos*/)      /*!< TPI TRI
1105:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1106:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Integration ETM Data Register Definitions (FIFO0) */
1107:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ITM_ATVALID_Pos          29U                                         /*!< TPI FIF
1108:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ITM_ATVALID_Msk          (0x3UL << TPI_FIFO0_ITM_ATVALID_Pos)        /*!< TPI FIF
1109:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1110:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ITM_bytecount_Pos        27U                                         /*!< TPI FIF
1111:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ITM_bytecount_Msk        (0x3UL << TPI_FIFO0_ITM_bytecount_Pos)      /*!< TPI FIF
1112:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1113:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM_ATVALID_Pos          26U                                         /*!< TPI FIF
1114:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM_ATVALID_Msk          (0x3UL << TPI_FIFO0_ETM_ATVALID_Pos)        /*!< TPI FIF
1115:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1116:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM_bytecount_Pos        24U                                         /*!< TPI FIF
1117:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM_bytecount_Msk        (0x3UL << TPI_FIFO0_ETM_bytecount_Pos)      /*!< TPI FIF
1118:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1119:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM2_Pos                 16U                                         /*!< TPI FIF
1120:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM2_Msk                 (0xFFUL << TPI_FIFO0_ETM2_Pos)              /*!< TPI FIF
1121:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1122:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM1_Pos                  8U                                         /*!< TPI FIF
1123:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM1_Msk                 (0xFFUL << TPI_FIFO0_ETM1_Pos)              /*!< TPI FIF
1124:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1125:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM0_Pos                  0U                                         /*!< TPI FIF
1126:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO0_ETM0_Msk                 (0xFFUL /*<< TPI_FIFO0_ETM0_Pos*/)          /*!< TPI FIF
1127:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1128:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI ITATBCTR2 Register Definitions */
1129:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ITATBCTR2_ATREADY_Pos           0U                                         /*!< TPI ITA
1130:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ITATBCTR2_ATREADY_Msk          (0x1UL /*<< TPI_ITATBCTR2_ATREADY_Pos*/)    /*!< TPI ITA
1131:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1132:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Integration ITM Data Register Definitions (FIFO1) */
1133:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM_ATVALID_Pos          29U                                         /*!< TPI FIF
1134:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM_ATVALID_Msk          (0x3UL << TPI_FIFO1_ITM_ATVALID_Pos)        /*!< TPI FIF
1135:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1136:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM_bytecount_Pos        27U                                         /*!< TPI FIF
1137:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM_bytecount_Msk        (0x3UL << TPI_FIFO1_ITM_bytecount_Pos)      /*!< TPI FIF
1138:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1139:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ETM_ATVALID_Pos          26U                                         /*!< TPI FIF
1140:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ETM_ATVALID_Msk          (0x3UL << TPI_FIFO1_ETM_ATVALID_Pos)        /*!< TPI FIF
1141:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1142:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ETM_bytecount_Pos        24U                                         /*!< TPI FIF
1143:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ETM_bytecount_Msk        (0x3UL << TPI_FIFO1_ETM_bytecount_Pos)      /*!< TPI FIF
1144:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1145:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM2_Pos                 16U                                         /*!< TPI FIF
1146:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM2_Msk                 (0xFFUL << TPI_FIFO1_ITM2_Pos)              /*!< TPI FIF
1147:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1148:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM1_Pos                  8U                                         /*!< TPI FIF
1149:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM1_Msk                 (0xFFUL << TPI_FIFO1_ITM1_Pos)              /*!< TPI FIF
1150:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1151:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM0_Pos                  0U                                         /*!< TPI FIF
1152:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_FIFO1_ITM0_Msk                 (0xFFUL /*<< TPI_FIFO1_ITM0_Pos*/)          /*!< TPI FIF
1153:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1154:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI ITATBCTR0 Register Definitions */
1155:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ITATBCTR0_ATREADY_Pos           0U                                         /*!< TPI ITA
1156:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ITATBCTR0_ATREADY_Msk          (0x1UL /*<< TPI_ITATBCTR0_ATREADY_Pos*/)    /*!< TPI ITA
1157:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1158:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI Integration Mode Control Register Definitions */
1159:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ITCTRL_Mode_Pos                 0U                                         /*!< TPI ITC
1160:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_ITCTRL_Mode_Msk                (0x1UL /*<< TPI_ITCTRL_Mode_Pos*/)          /*!< TPI ITC
1161:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1162:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI DEVID Register Definitions */
1163:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_NRZVALID_Pos             11U                                         /*!< TPI DEV
1164:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_NRZVALID_Msk             (0x1UL << TPI_DEVID_NRZVALID_Pos)           /*!< TPI DEV
1165:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1166:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_MANCVALID_Pos            10U                                         /*!< TPI DEV
1167:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_MANCVALID_Msk            (0x1UL << TPI_DEVID_MANCVALID_Pos)          /*!< TPI DEV
1168:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1169:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_PTINVALID_Pos             9U                                         /*!< TPI DEV
1170:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_PTINVALID_Msk            (0x1UL << TPI_DEVID_PTINVALID_Pos)          /*!< TPI DEV
1171:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1172:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_MinBufSz_Pos              6U                                         /*!< TPI DEV
1173:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_MinBufSz_Msk             (0x7UL << TPI_DEVID_MinBufSz_Pos)           /*!< TPI DEV
1174:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1175:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_AsynClkIn_Pos             5U                                         /*!< TPI DEV
1176:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_AsynClkIn_Msk            (0x1UL << TPI_DEVID_AsynClkIn_Pos)          /*!< TPI DEV
1177:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1178:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_NrTraceInput_Pos          0U                                         /*!< TPI DEV
1179:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVID_NrTraceInput_Msk         (0x1FUL /*<< TPI_DEVID_NrTraceInput_Pos*/)  /*!< TPI DEV
1180:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1181:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* TPI DEVTYPE Register Definitions */
1182:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVTYPE_MajorType_Pos           4U                                         /*!< TPI DEV
1183:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVTYPE_MajorType_Msk          (0xFUL << TPI_DEVTYPE_MajorType_Pos)        /*!< TPI DEV
1184:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1185:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVTYPE_SubType_Pos             0U                                         /*!< TPI DEV
1186:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_DEVTYPE_SubType_Msk            (0xFUL /*<< TPI_DEVTYPE_SubType_Pos*/)      /*!< TPI DEV
1187:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1188:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@}*/ /* end of group CMSIS_TPI */
1189:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1190:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1191:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if (__MPU_PRESENT == 1U)
1192:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1193:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
1194:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_MPU     Memory Protection Unit (MPU)
1195:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the Memory Protection Unit (MPU)
1196:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1197:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1198:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1199:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1200:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Memory Protection Unit (MPU).
1201:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1202:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
1203:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1204:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t TYPE;                   /*!< Offset: 0x000 (R/ )  MPU Type Register */
1205:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t CTRL;                   /*!< Offset: 0x004 (R/W)  MPU Control Register */
1206:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RNR;                    /*!< Offset: 0x008 (R/W)  MPU Region RNRber Register */
1207:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RBAR;                   /*!< Offset: 0x00C (R/W)  MPU Region Base Address Register
1208:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RASR;                   /*!< Offset: 0x010 (R/W)  MPU Region Attribute and Size Re
1209:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RBAR_A1;                /*!< Offset: 0x014 (R/W)  MPU Alias 1 Region Base Address 
1210:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RASR_A1;                /*!< Offset: 0x018 (R/W)  MPU Alias 1 Region Attribute and
1211:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RBAR_A2;                /*!< Offset: 0x01C (R/W)  MPU Alias 2 Region Base Address 
1212:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RASR_A2;                /*!< Offset: 0x020 (R/W)  MPU Alias 2 Region Attribute and
1213:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RBAR_A3;                /*!< Offset: 0x024 (R/W)  MPU Alias 3 Region Base Address 
1214:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t RASR_A3;                /*!< Offset: 0x028 (R/W)  MPU Alias 3 Region Attribute and
1215:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } MPU_Type;
1216:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1217:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* MPU Type Register Definitions */
1218:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_TYPE_IREGION_Pos               16U                                            /*!< MPU 
1219:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_TYPE_IREGION_Msk               (0xFFUL << MPU_TYPE_IREGION_Pos)               /*!< MPU 
1220:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1221:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_TYPE_DREGION_Pos                8U                                            /*!< MPU 
1222:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_TYPE_DREGION_Msk               (0xFFUL << MPU_TYPE_DREGION_Pos)               /*!< MPU 
1223:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1224:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_TYPE_SEPARATE_Pos               0U                                            /*!< MPU 
1225:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_TYPE_SEPARATE_Msk              (1UL /*<< MPU_TYPE_SEPARATE_Pos*/)             /*!< MPU 
1226:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1227:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* MPU Control Register Definitions */
1228:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_CTRL_PRIVDEFENA_Pos             2U                                            /*!< MPU 
1229:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_CTRL_PRIVDEFENA_Msk            (1UL << MPU_CTRL_PRIVDEFENA_Pos)               /*!< MPU 
1230:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1231:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_CTRL_HFNMIENA_Pos               1U                                            /*!< MPU 
1232:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_CTRL_HFNMIENA_Msk              (1UL << MPU_CTRL_HFNMIENA_Pos)                 /*!< MPU 
1233:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1234:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_CTRL_ENABLE_Pos                 0U                                            /*!< MPU 
1235:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_CTRL_ENABLE_Msk                (1UL /*<< MPU_CTRL_ENABLE_Pos*/)               /*!< MPU 
1236:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1237:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* MPU Region Number Register Definitions */
1238:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RNR_REGION_Pos                  0U                                            /*!< MPU 
1239:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RNR_REGION_Msk                 (0xFFUL /*<< MPU_RNR_REGION_Pos*/)             /*!< MPU 
1240:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1241:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* MPU Region Base Address Register Definitions */
1242:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RBAR_ADDR_Pos                   5U                                            /*!< MPU 
1243:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RBAR_ADDR_Msk                  (0x7FFFFFFUL << MPU_RBAR_ADDR_Pos)             /*!< MPU 
1244:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1245:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RBAR_VALID_Pos                  4U                                            /*!< MPU 
1246:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RBAR_VALID_Msk                 (1UL << MPU_RBAR_VALID_Pos)                    /*!< MPU 
1247:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1248:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RBAR_REGION_Pos                 0U                                            /*!< MPU 
1249:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RBAR_REGION_Msk                (0xFUL /*<< MPU_RBAR_REGION_Pos*/)             /*!< MPU 
1250:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1251:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* MPU Region Attribute and Size Register Definitions */
1252:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_ATTRS_Pos                 16U                                            /*!< MPU 
1253:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_ATTRS_Msk                 (0xFFFFUL << MPU_RASR_ATTRS_Pos)               /*!< MPU 
1254:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1255:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_XN_Pos                    28U                                            /*!< MPU 
1256:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_XN_Msk                    (1UL << MPU_RASR_XN_Pos)                       /*!< MPU 
1257:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1258:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_AP_Pos                    24U                                            /*!< MPU 
1259:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_AP_Msk                    (0x7UL << MPU_RASR_AP_Pos)                     /*!< MPU 
1260:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1261:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_TEX_Pos                   19U                                            /*!< MPU 
1262:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_TEX_Msk                   (0x7UL << MPU_RASR_TEX_Pos)                    /*!< MPU 
1263:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1264:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_S_Pos                     18U                                            /*!< MPU 
1265:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_S_Msk                     (1UL << MPU_RASR_S_Pos)                        /*!< MPU 
1266:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1267:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_C_Pos                     17U                                            /*!< MPU 
1268:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_C_Msk                     (1UL << MPU_RASR_C_Pos)                        /*!< MPU 
1269:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1270:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_B_Pos                     16U                                            /*!< MPU 
1271:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_B_Msk                     (1UL << MPU_RASR_B_Pos)                        /*!< MPU 
1272:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1273:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_SRD_Pos                    8U                                            /*!< MPU 
1274:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_SRD_Msk                   (0xFFUL << MPU_RASR_SRD_Pos)                   /*!< MPU 
1275:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1276:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_SIZE_Pos                   1U                                            /*!< MPU 
1277:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_SIZE_Msk                  (0x1FUL << MPU_RASR_SIZE_Pos)                  /*!< MPU 
1278:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1279:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_ENABLE_Pos                 0U                                            /*!< MPU 
1280:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define MPU_RASR_ENABLE_Msk                (1UL /*<< MPU_RASR_ENABLE_Pos*/)               /*!< MPU 
1281:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1282:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_MPU */
1283:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
1284:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1285:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1286:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if (__FPU_PRESENT == 1U)
1287:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1288:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
1289:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_FPU     Floating Point Unit (FPU)
1290:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the Floating Point Unit (FPU)
1291:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1292:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1293:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1294:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1295:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Floating Point Unit (FPU).
1296:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1297:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
1298:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1299:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****         uint32_t RESERVED0[1U];
1300:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FPCCR;                  /*!< Offset: 0x004 (R/W)  Floating-Point Context Control R
1301:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FPCAR;                  /*!< Offset: 0x008 (R/W)  Floating-Point Context Address R
1302:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t FPDSCR;                 /*!< Offset: 0x00C (R/W)  Floating-Point Default Status Co
1303:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t MVFR0;                  /*!< Offset: 0x010 (R/ )  Media and FP Feature Register 0 
1304:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IM  uint32_t MVFR1;                  /*!< Offset: 0x014 (R/ )  Media and FP Feature Register 1 
1305:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } FPU_Type;
1306:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1307:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Floating-Point Context Control Register Definitions */
1308:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_ASPEN_Pos                31U                                            /*!< FPCC
1309:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_ASPEN_Msk                (1UL << FPU_FPCCR_ASPEN_Pos)                   /*!< FPCC
1310:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1311:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_LSPEN_Pos                30U                                            /*!< FPCC
1312:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_LSPEN_Msk                (1UL << FPU_FPCCR_LSPEN_Pos)                   /*!< FPCC
1313:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1314:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_MONRDY_Pos                8U                                            /*!< FPCC
1315:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_MONRDY_Msk               (1UL << FPU_FPCCR_MONRDY_Pos)                  /*!< FPCC
1316:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1317:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_BFRDY_Pos                 6U                                            /*!< FPCC
1318:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_BFRDY_Msk                (1UL << FPU_FPCCR_BFRDY_Pos)                   /*!< FPCC
1319:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1320:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_MMRDY_Pos                 5U                                            /*!< FPCC
1321:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_MMRDY_Msk                (1UL << FPU_FPCCR_MMRDY_Pos)                   /*!< FPCC
1322:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1323:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_HFRDY_Pos                 4U                                            /*!< FPCC
1324:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_HFRDY_Msk                (1UL << FPU_FPCCR_HFRDY_Pos)                   /*!< FPCC
1325:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1326:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_THREAD_Pos                3U                                            /*!< FPCC
1327:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_THREAD_Msk               (1UL << FPU_FPCCR_THREAD_Pos)                  /*!< FPCC
1328:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1329:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_USER_Pos                  1U                                            /*!< FPCC
1330:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_USER_Msk                 (1UL << FPU_FPCCR_USER_Pos)                    /*!< FPCC
1331:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1332:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_LSPACT_Pos                0U                                            /*!< FPCC
1333:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCCR_LSPACT_Msk               (1UL /*<< FPU_FPCCR_LSPACT_Pos*/)              /*!< FPCC
1334:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1335:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Floating-Point Context Address Register Definitions */
1336:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCAR_ADDRESS_Pos               3U                                            /*!< FPCA
1337:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPCAR_ADDRESS_Msk              (0x1FFFFFFFUL << FPU_FPCAR_ADDRESS_Pos)        /*!< FPCA
1338:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1339:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Floating-Point Default Status Control Register Definitions */
1340:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_AHP_Pos                 26U                                            /*!< FPDS
1341:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_AHP_Msk                 (1UL << FPU_FPDSCR_AHP_Pos)                    /*!< FPDS
1342:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1343:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_DN_Pos                  25U                                            /*!< FPDS
1344:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_DN_Msk                  (1UL << FPU_FPDSCR_DN_Pos)                     /*!< FPDS
1345:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1346:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_FZ_Pos                  24U                                            /*!< FPDS
1347:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_FZ_Msk                  (1UL << FPU_FPDSCR_FZ_Pos)                     /*!< FPDS
1348:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1349:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_RMode_Pos               22U                                            /*!< FPDS
1350:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_FPDSCR_RMode_Msk               (3UL << FPU_FPDSCR_RMode_Pos)                  /*!< FPDS
1351:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1352:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Media and FP Feature Register 0 Definitions */
1353:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_FP_rounding_modes_Pos    28U                                            /*!< MVFR
1354:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_FP_rounding_modes_Msk    (0xFUL << FPU_MVFR0_FP_rounding_modes_Pos)     /*!< MVFR
1355:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1356:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Short_vectors_Pos        24U                                            /*!< MVFR
1357:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Short_vectors_Msk        (0xFUL << FPU_MVFR0_Short_vectors_Pos)         /*!< MVFR
1358:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1359:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Square_root_Pos          20U                                            /*!< MVFR
1360:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Square_root_Msk          (0xFUL << FPU_MVFR0_Square_root_Pos)           /*!< MVFR
1361:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1362:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Divide_Pos               16U                                            /*!< MVFR
1363:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Divide_Msk               (0xFUL << FPU_MVFR0_Divide_Pos)                /*!< MVFR
1364:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1365:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_FP_excep_trapping_Pos    12U                                            /*!< MVFR
1366:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_FP_excep_trapping_Msk    (0xFUL << FPU_MVFR0_FP_excep_trapping_Pos)     /*!< MVFR
1367:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1368:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Double_precision_Pos      8U                                            /*!< MVFR
1369:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Double_precision_Msk     (0xFUL << FPU_MVFR0_Double_precision_Pos)      /*!< MVFR
1370:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1371:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Single_precision_Pos      4U                                            /*!< MVFR
1372:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_Single_precision_Msk     (0xFUL << FPU_MVFR0_Single_precision_Pos)      /*!< MVFR
1373:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1374:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_A_SIMD_registers_Pos      0U                                            /*!< MVFR
1375:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR0_A_SIMD_registers_Msk     (0xFUL /*<< FPU_MVFR0_A_SIMD_registers_Pos*/)  /*!< MVFR
1376:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1377:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Media and FP Feature Register 1 Definitions */
1378:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_FP_fused_MAC_Pos         28U                                            /*!< MVFR
1379:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_FP_fused_MAC_Msk         (0xFUL << FPU_MVFR1_FP_fused_MAC_Pos)          /*!< MVFR
1380:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1381:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_FP_HPFP_Pos              24U                                            /*!< MVFR
1382:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_FP_HPFP_Msk              (0xFUL << FPU_MVFR1_FP_HPFP_Pos)               /*!< MVFR
1383:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1384:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_D_NaN_mode_Pos            4U                                            /*!< MVFR
1385:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_D_NaN_mode_Msk           (0xFUL << FPU_MVFR1_D_NaN_mode_Pos)            /*!< MVFR
1386:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1387:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_FtZ_mode_Pos              0U                                            /*!< MVFR
1388:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define FPU_MVFR1_FtZ_mode_Msk             (0xFUL /*<< FPU_MVFR1_FtZ_mode_Pos*/)          /*!< MVFR
1389:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1390:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_FPU */
1391:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
1392:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1393:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1394:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1395:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_core_register
1396:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_CoreDebug       Core Debug Registers (CoreDebug)
1397:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Type definitions for the Core Debug Registers
1398:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1399:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1400:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1401:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1402:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief  Structure type to access the Core Debug Register (CoreDebug).
1403:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1404:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** typedef struct
1405:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1406:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t DHCSR;                  /*!< Offset: 0x000 (R/W)  Debug Halting Control and Status
1407:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __OM  uint32_t DCRSR;                  /*!< Offset: 0x004 ( /W)  Debug Core Register Selector Reg
1408:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t DCRDR;                  /*!< Offset: 0x008 (R/W)  Debug Core Register Data Registe
1409:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   __IOM uint32_t DEMCR;                  /*!< Offset: 0x00C (R/W)  Debug Exception and Monitor Cont
1410:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** } CoreDebug_Type;
1411:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1412:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Debug Halting Control and Status Register Definitions */
1413:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_DBGKEY_Pos         16U                                            /*!< Core
1414:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_DBGKEY_Msk         (0xFFFFUL << CoreDebug_DHCSR_DBGKEY_Pos)       /*!< Core
1415:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1416:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_RESET_ST_Pos     25U                                            /*!< Core
1417:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_RESET_ST_Msk     (1UL << CoreDebug_DHCSR_S_RESET_ST_Pos)        /*!< Core
1418:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1419:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_RETIRE_ST_Pos    24U                                            /*!< Core
1420:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_RETIRE_ST_Msk    (1UL << CoreDebug_DHCSR_S_RETIRE_ST_Pos)       /*!< Core
1421:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1422:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_LOCKUP_Pos       19U                                            /*!< Core
1423:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_LOCKUP_Msk       (1UL << CoreDebug_DHCSR_S_LOCKUP_Pos)          /*!< Core
1424:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1425:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_SLEEP_Pos        18U                                            /*!< Core
1426:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_SLEEP_Msk        (1UL << CoreDebug_DHCSR_S_SLEEP_Pos)           /*!< Core
1427:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1428:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_HALT_Pos         17U                                            /*!< Core
1429:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_HALT_Msk         (1UL << CoreDebug_DHCSR_S_HALT_Pos)            /*!< Core
1430:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1431:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_REGRDY_Pos       16U                                            /*!< Core
1432:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_S_REGRDY_Msk       (1UL << CoreDebug_DHCSR_S_REGRDY_Pos)          /*!< Core
1433:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1434:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_SNAPSTALL_Pos     5U                                            /*!< Core
1435:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_SNAPSTALL_Msk    (1UL << CoreDebug_DHCSR_C_SNAPSTALL_Pos)       /*!< Core
1436:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1437:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_MASKINTS_Pos      3U                                            /*!< Core
1438:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_MASKINTS_Msk     (1UL << CoreDebug_DHCSR_C_MASKINTS_Pos)        /*!< Core
1439:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1440:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_STEP_Pos          2U                                            /*!< Core
1441:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_STEP_Msk         (1UL << CoreDebug_DHCSR_C_STEP_Pos)            /*!< Core
1442:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1443:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_HALT_Pos          1U                                            /*!< Core
1444:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_HALT_Msk         (1UL << CoreDebug_DHCSR_C_HALT_Pos)            /*!< Core
1445:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1446:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_DEBUGEN_Pos       0U                                            /*!< Core
1447:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DHCSR_C_DEBUGEN_Msk      (1UL /*<< CoreDebug_DHCSR_C_DEBUGEN_Pos*/)     /*!< Core
1448:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1449:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Debug Core Register Selector Register Definitions */
1450:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DCRSR_REGWnR_Pos         16U                                            /*!< Core
1451:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DCRSR_REGWnR_Msk         (1UL << CoreDebug_DCRSR_REGWnR_Pos)            /*!< Core
1452:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1453:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DCRSR_REGSEL_Pos          0U                                            /*!< Core
1454:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DCRSR_REGSEL_Msk         (0x1FUL /*<< CoreDebug_DCRSR_REGSEL_Pos*/)     /*!< Core
1455:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1456:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Debug Exception and Monitor Control Register Definitions */
1457:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_TRCENA_Pos         24U                                            /*!< Core
1458:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_TRCENA_Msk         (1UL << CoreDebug_DEMCR_TRCENA_Pos)            /*!< Core
1459:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1460:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_REQ_Pos        19U                                            /*!< Core
1461:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_REQ_Msk        (1UL << CoreDebug_DEMCR_MON_REQ_Pos)           /*!< Core
1462:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1463:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_STEP_Pos       18U                                            /*!< Core
1464:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_STEP_Msk       (1UL << CoreDebug_DEMCR_MON_STEP_Pos)          /*!< Core
1465:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1466:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_PEND_Pos       17U                                            /*!< Core
1467:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_PEND_Msk       (1UL << CoreDebug_DEMCR_MON_PEND_Pos)          /*!< Core
1468:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1469:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_EN_Pos         16U                                            /*!< Core
1470:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_MON_EN_Msk         (1UL << CoreDebug_DEMCR_MON_EN_Pos)            /*!< Core
1471:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1472:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_HARDERR_Pos     10U                                            /*!< Core
1473:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_HARDERR_Msk     (1UL << CoreDebug_DEMCR_VC_HARDERR_Pos)        /*!< Core
1474:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1475:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_INTERR_Pos       9U                                            /*!< Core
1476:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_INTERR_Msk      (1UL << CoreDebug_DEMCR_VC_INTERR_Pos)         /*!< Core
1477:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1478:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_BUSERR_Pos       8U                                            /*!< Core
1479:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_BUSERR_Msk      (1UL << CoreDebug_DEMCR_VC_BUSERR_Pos)         /*!< Core
1480:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1481:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_STATERR_Pos      7U                                            /*!< Core
1482:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_STATERR_Msk     (1UL << CoreDebug_DEMCR_VC_STATERR_Pos)        /*!< Core
1483:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1484:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_CHKERR_Pos       6U                                            /*!< Core
1485:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_CHKERR_Msk      (1UL << CoreDebug_DEMCR_VC_CHKERR_Pos)         /*!< Core
1486:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1487:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_NOCPERR_Pos      5U                                            /*!< Core
1488:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_NOCPERR_Msk     (1UL << CoreDebug_DEMCR_VC_NOCPERR_Pos)        /*!< Core
1489:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1490:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_MMERR_Pos        4U                                            /*!< Core
1491:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_MMERR_Msk       (1UL << CoreDebug_DEMCR_VC_MMERR_Pos)          /*!< Core
1492:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1493:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_CORERESET_Pos    0U                                            /*!< Core
1494:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_DEMCR_VC_CORERESET_Msk   (1UL /*<< CoreDebug_DEMCR_VC_CORERESET_Pos*/)  /*!< Core
1495:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1496:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_CoreDebug */
1497:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1498:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1499:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1500:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup    CMSIS_core_register
1501:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup   CMSIS_core_bitfield     Core register bit field macros
1502:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief      Macros for use with bit field definitions (xxx_Pos, xxx_Msk).
1503:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1504:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1505:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1506:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1507:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Mask and shift a bit field value for use in a register bit range.
1508:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param[in] field  Name of the register bit field.
1509:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param[in] value  Value of the bit field.
1510:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return           Masked and shifted value.
1511:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** */
1512:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define _VAL2FLD(field, value)    ((value << field ## _Pos) & field ## _Msk)
1513:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1514:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1515:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief     Mask and shift a register value to extract a bit filed value.
1516:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param[in] field  Name of the register bit field.
1517:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param[in] value  Value of register.
1518:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return           Masked and shifted bit field value.
1519:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** */
1520:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define _FLD2VAL(field, value)    ((value & field ## _Msk) >> field ## _Pos)
1521:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1522:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} end of group CMSIS_core_bitfield */
1523:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1524:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1525:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1526:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup    CMSIS_core_register
1527:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup   CMSIS_core_base     Core Definitions
1528:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief      Definitions for base addresses, unions, and structures.
1529:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1530:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1531:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1532:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* Memory mapping of Cortex-M4 Hardware */
1533:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCS_BASE            (0xE000E000UL)                            /*!< System Control Space Bas
1534:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM_BASE            (0xE0000000UL)                            /*!< ITM Base Address */
1535:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT_BASE            (0xE0001000UL)                            /*!< DWT Base Address */
1536:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI_BASE            (0xE0040000UL)                            /*!< TPI Base Address */
1537:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug_BASE      (0xE000EDF0UL)                            /*!< Core Debug Base Address 
1538:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick_BASE        (SCS_BASE +  0x0010UL)                    /*!< SysTick Base Address */
1539:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define NVIC_BASE           (SCS_BASE +  0x0100UL)                    /*!< NVIC Base Address */
1540:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB_BASE            (SCS_BASE +  0x0D00UL)                    /*!< System Control Block Bas
1541:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1542:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCnSCB              ((SCnSCB_Type    *)     SCS_BASE      )   /*!< System control Register 
1543:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SCB                 ((SCB_Type       *)     SCB_BASE      )   /*!< SCB configuration struct
1544:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define SysTick             ((SysTick_Type   *)     SysTick_BASE  )   /*!< SysTick configuration st
1545:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define NVIC                ((NVIC_Type      *)     NVIC_BASE     )   /*!< NVIC configuration struc
1546:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define ITM                 ((ITM_Type       *)     ITM_BASE      )   /*!< ITM configuration struct
1547:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define DWT                 ((DWT_Type       *)     DWT_BASE      )   /*!< DWT configuration struct
1548:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define TPI                 ((TPI_Type       *)     TPI_BASE      )   /*!< TPI configuration struct
1549:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #define CoreDebug           ((CoreDebug_Type *)     CoreDebug_BASE)   /*!< Core Debug configuration
1550:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1551:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if (__MPU_PRESENT == 1U)
1552:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define MPU_BASE          (SCS_BASE +  0x0D90UL)                    /*!< Memory Protection Unit *
1553:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define MPU               ((MPU_Type       *)     MPU_BASE      )   /*!< Memory Protection Unit *
1554:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
1555:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1556:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #if (__FPU_PRESENT == 1U)
1557:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define FPU_BASE          (SCS_BASE +  0x0F30UL)                    /*!< Floating Point Unit */
1558:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   #define FPU               ((FPU_Type       *)     FPU_BASE      )   /*!< Floating Point Unit */
1559:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** #endif
1560:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1561:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*@} */
1562:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1563:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1564:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1565:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /*******************************************************************************
1566:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  *                Hardware Abstraction Layer
1567:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   Core Function Interface contains:
1568:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core NVIC Functions
1569:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core SysTick Functions
1570:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core Debug Functions
1571:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   - Core Register Access Functions
1572:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  ******************************************************************************/
1573:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1574:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_Core_FunctionInterface Functions and Instructions Reference
1575:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** */
1576:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1577:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1578:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1579:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /* ##########################   NVIC functions  #################################### */
1580:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1581:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \ingroup  CMSIS_Core_FunctionInterface
1582:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \defgroup CMSIS_Core_NVICFunctions NVIC Functions
1583:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief    Functions that manage interrupts and exceptions via the NVIC.
1584:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   @{
1585:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1586:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1587:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1588:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Set Priority Grouping
1589:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Sets the priority grouping field using the required unlock sequence.
1590:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****            The parameter PriorityGroup is assigned to the field SCB->AIRCR [10:8] PRIGROUP field.
1591:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****            Only values from 0..7 are used.
1592:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****            In case of a conflict between priority grouping and available
1593:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****            priority bits (__NVIC_PRIO_BITS), the smallest possible priority group is set.
1594:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      PriorityGroup  Priority grouping field.
1595:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1596:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE void NVIC_SetPriorityGrouping(uint32_t PriorityGroup)
1597:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1598:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   uint32_t reg_value;
1599:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   uint32_t PriorityGroupTmp = (PriorityGroup & (uint32_t)0x07UL);             /* only values 0..7 a
1600:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1601:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   reg_value  =  SCB->AIRCR;                                                   /* read old register 
1602:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   reg_value &= ~((uint32_t)(SCB_AIRCR_VECTKEY_Msk | SCB_AIRCR_PRIGROUP_Msk)); /* clear bits to chan
1603:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   reg_value  =  (reg_value                                   |
1604:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****                 ((uint32_t)0x5FAUL << SCB_AIRCR_VECTKEY_Pos) |
1605:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****                 (PriorityGroupTmp << 8U)                      );              /* Insert write key a
1606:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   SCB->AIRCR =  reg_value;
1607:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1608:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1609:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1610:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1611:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Get Priority Grouping
1612:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Reads the priority grouping field from the NVIC Interrupt Controller.
1613:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return                Priority grouping field (SCB->AIRCR [10:8] PRIGROUP field).
1614:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1615:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE uint32_t NVIC_GetPriorityGrouping(void)
1616:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1617:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   return ((uint32_t)((SCB->AIRCR & SCB_AIRCR_PRIGROUP_Msk) >> SCB_AIRCR_PRIGROUP_Pos));
1618:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1619:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1620:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1621:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1622:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Enable External Interrupt
1623:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Enables a device-specific interrupt in the NVIC interrupt controller.
1624:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  External interrupt number. Value cannot be negative.
1625:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1626:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE void NVIC_EnableIRQ(IRQn_Type IRQn)
1627:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   NVIC->ISER[(((uint32_t)(int32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)(int32_t)IRQn) & 0
1629:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1630:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1631:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1632:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1633:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Disable External Interrupt
1634:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Disables a device-specific interrupt in the NVIC interrupt controller.
1635:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  External interrupt number. Value cannot be negative.
1636:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1637:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE void NVIC_DisableIRQ(IRQn_Type IRQn)
1638:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1639:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   NVIC->ICER[(((uint32_t)(int32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)(int32_t)IRQn) & 0
1640:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1641:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1642:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1643:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1644:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Get Pending Interrupt
1645:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Reads the pending register in the NVIC and returns the pending bit for the specified int
1646:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  Interrupt number.
1647:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return             0  Interrupt status is not pending.
1648:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return             1  Interrupt status is pending.
1649:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1650:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE uint32_t NVIC_GetPendingIRQ(IRQn_Type IRQn)
1651:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1652:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   return((uint32_t)(((NVIC->ISPR[(((uint32_t)(int32_t)IRQn) >> 5UL)] & (1UL << (((uint32_t)(int32_t
1653:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1654:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1655:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1656:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1657:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Set Pending Interrupt
1658:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Sets the pending bit of an external interrupt.
1659:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  Interrupt number. Value cannot be negative.
1660:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1661:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE void NVIC_SetPendingIRQ(IRQn_Type IRQn)
1662:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1663:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   NVIC->ISPR[(((uint32_t)(int32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)(int32_t)IRQn) & 0
1664:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1665:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1666:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1667:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1668:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Clear Pending Interrupt
1669:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Clears the pending bit of an external interrupt.
1670:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  External interrupt number. Value cannot be negative.
1671:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1672:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE void NVIC_ClearPendingIRQ(IRQn_Type IRQn)
1673:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1674:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   NVIC->ICPR[(((uint32_t)(int32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)(int32_t)IRQn) & 0
1675:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1676:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1677:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1678:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1679:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Get Active Interrupt
1680:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Reads the active register in NVIC and returns the active bit.
1681:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  Interrupt number.
1682:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return             0  Interrupt status is not active.
1683:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \return             1  Interrupt status is active.
1684:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1685:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE uint32_t NVIC_GetActive(IRQn_Type IRQn)
1686:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1687:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   return((uint32_t)(((NVIC->IABR[(((uint32_t)(int32_t)IRQn) >> 5UL)] & (1UL << (((uint32_t)(int32_t
1688:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
1689:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1690:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** 
1691:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** /**
1692:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \brief   Set Interrupt Priority
1693:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \details Sets the priority of an interrupt.
1694:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \note    The priority cannot be set for every core interrupt.
1695:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]      IRQn  Interrupt number.
1696:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   \param [in]  priority  Priority to set.
1697:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****  */
1698:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** __STATIC_INLINE void NVIC_SetPriority(IRQn_Type IRQn, uint32_t priority)
1699:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** {
1700:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   if ((int32_t)(IRQn) < 0)
1701:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
1702:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     SCB->SHP[(((uint32_t)(int32_t)IRQn) & 0xFUL)-4UL] = (uint8_t)((priority << (8U - __NVIC_PRIO_BI
1703:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   }
1704:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   else
1705:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****   {
1706:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h ****     NVIC->IP[((uint32_t)(int32_t)IRQn)]               = (uint8_t)((priority << (8U - __NVIC_PRIO_BI
 369              		.loc 2 1706 0
 370 0000 064B     		ldr	r3, .L26
 371              	.LBE82:
 372              	.LBE81:
 272:spinnaker_src/if_curr_exp.c **** 
 273:spinnaker_src/if_curr_exp.c ****     timer[TIMER1_CTL] = 0xE2;
 373              		.loc 1 273 0
 374 0002 0748     		ldr	r0, .L26+4
 271:spinnaker_src/if_curr_exp.c **** 
 375              		.loc 1 271 0
 376 0004 10B4     		push	{r4}
 377              		.cfi_def_cfa_offset 4
 378              		.cfi_offset 4, -4
 379              	.LBB85:
 380              	.LBB83:
 381              		.loc 2 1706 0
 382 0006 F021     		movs	r1, #240
 383              	.LBE83:
 384              	.LBE85:
 385              		.loc 1 273 0
 386 0008 E224     		movs	r4, #226
 387 000a 0460     		str	r4, [r0]
 388              	.LVL15:
 389              	.LBB86:
 390              	.LBB87:
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 391              		.loc 2 1628 0
 392 000c 0122     		movs	r2, #1
 393              	.LBE87:
 394              	.LBE86:
 395              	.LBB89:
 396              	.LBB84:
 397              		.loc 2 1706 0
 398 000e 83F80013 		strb	r1, [r3, #768]
 399              	.LVL16:
 400              	.LBE84:
 401              	.LBE89:
 274:spinnaker_src/if_curr_exp.c ****     NVIC_SetPriority(IRQ_00_IRQn, (1UL << __NVIC_PRIO_BITS) - 2UL);
 275:spinnaker_src/if_curr_exp.c ****     NVIC_EnableIRQ(IRQ_00_IRQn);
 276:spinnaker_src/if_curr_exp.c **** 
 277:spinnaker_src/if_curr_exp.c **** }
 402              		.loc 1 277 0
 403 0012 5DF8044B 		ldr	r4, [sp], #4
 404              		.cfi_restore 4
 405              		.cfi_def_cfa_offset 0
 406              	.LBB90:
 407              	.LBB88:
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 408              		.loc 2 1628 0
 409 0016 1A60     		str	r2, [r3]
 410              	.LBE88:
 411              	.LBE90:
 412              		.loc 1 277 0
 413 0018 7047     		bx	lr
 414              	.L27:
 415 001a 00BF     		.align	2
 416              	.L26:
 417 001c 00E100E0 		.word	-536813312
 418 0020 080000E1 		.word	-520093688
 419              		.cfi_endproc
 420              	.LFE194:
 422              		.section	.text.calc_dest,"ax",%progbits
 423              		.align	2
 424              		.global	calc_dest
 425              		.thumb
 426              		.thumb_func
 428              	calc_dest:
 429              	.LFB195:
 278:spinnaker_src/if_curr_exp.c **** 
 279:spinnaker_src/if_curr_exp.c **** uint32_t calc_dest(){
 430              		.loc 1 279 0
 431              		.cfi_startproc
 432              		@ args = 0, pretend = 0, frame = 0
 433              		@ frame_needed = 0, uses_anonymous_args = 0
 434              		@ link register save eliminated.
 280:spinnaker_src/if_curr_exp.c **** 
 281:spinnaker_src/if_curr_exp.c **** 	uint32_t dest_exc;
 282:spinnaker_src/if_curr_exp.c **** 
 283:spinnaker_src/if_curr_exp.c **** 	if (pe_id == pe0){
 435              		.loc 1 283 0
 436 0000 144B     		ldr	r3, .L35
 437 0002 154A     		ldr	r2, .L35+4
 438 0004 1B68     		ldr	r3, [r3]
 439 0006 1268     		ldr	r2, [r2]
 440 0008 9342     		cmp	r3, r2
 279:spinnaker_src/if_curr_exp.c **** 
 441              		.loc 1 279 0
 442 000a 10B4     		push	{r4}
 443              		.cfi_def_cfa_offset 4
 444              		.cfi_offset 4, -4
 445              		.loc 1 283 0
 446 000c 0FD0     		beq	.L31
 284:spinnaker_src/if_curr_exp.c ****     	dest_exc = (8 >> pe3);
 285:spinnaker_src/if_curr_exp.c **** 	}
 286:spinnaker_src/if_curr_exp.c **** 	else if (pe_id == pe1){
 447              		.loc 1 286 0
 448 000e 1349     		ldr	r1, .L35+8
 449 0010 0968     		ldr	r1, [r1]
 450 0012 8B42     		cmp	r3, r1
 451 0014 0BD0     		beq	.L31
 287:spinnaker_src/if_curr_exp.c ****     	dest_exc = (8 >> pe3);
 288:spinnaker_src/if_curr_exp.c **** 	}
 289:spinnaker_src/if_curr_exp.c **** 	else if (pe_id == pe2){
 452              		.loc 1 289 0
 453 0016 1248     		ldr	r0, .L35+12
 454 0018 0468     		ldr	r4, [r0]
 455 001a A342     		cmp	r3, r4
 456 001c 07D0     		beq	.L31
 290:spinnaker_src/if_curr_exp.c ****     	dest_exc = (8 >> pe3);
 291:spinnaker_src/if_curr_exp.c **** 	}
 292:spinnaker_src/if_curr_exp.c **** 	else if (pe_id == pe3){
 457              		.loc 1 292 0
 458 001e 1148     		ldr	r0, .L35+16
 459 0020 0068     		ldr	r0, [r0]
 460 0022 8342     		cmp	r3, r0
 461 0024 0AD0     		beq	.L34
 293:spinnaker_src/if_curr_exp.c ****     	dest_exc = (8 >> pe0)|(8 >> pe1)|(8 >> pe2);
 294:spinnaker_src/if_curr_exp.c **** 	}
 295:spinnaker_src/if_curr_exp.c **** 	else{
 296:spinnaker_src/if_curr_exp.c **** 		dest_exc = 0;
 462              		.loc 1 296 0
 463 0026 0020     		movs	r0, #0
 464              	.LVL17:
 297:spinnaker_src/if_curr_exp.c **** 	}
 298:spinnaker_src/if_curr_exp.c **** 
 299:spinnaker_src/if_curr_exp.c **** 	return dest_exc;
 300:spinnaker_src/if_curr_exp.c **** 
 301:spinnaker_src/if_curr_exp.c **** }
 465              		.loc 1 301 0
 466 0028 5DF8044B 		ldr	r4, [sp], #4
 467              		.cfi_remember_state
 468              		.cfi_restore 4
 469              		.cfi_def_cfa_offset 0
 470 002c 7047     		bx	lr
 471              	.LVL18:
 472              	.L31:
 473              		.cfi_restore_state
 284:spinnaker_src/if_curr_exp.c **** 	}
 474              		.loc 1 284 0
 475 002e 0D4B     		ldr	r3, .L35+16
 476              		.loc 1 301 0
 477 0030 5DF8044B 		ldr	r4, [sp], #4
 478              		.cfi_remember_state
 479              		.cfi_restore 4
 480              		.cfi_def_cfa_offset 0
 284:spinnaker_src/if_curr_exp.c **** 	}
 481              		.loc 1 284 0
 482 0034 1B68     		ldr	r3, [r3]
 483 0036 0820     		movs	r0, #8
 484 0038 1841     		asrs	r0, r0, r3
 485              	.LVL19:
 486              		.loc 1 301 0
 487 003a 7047     		bx	lr
 488              	.LVL20:
 489              	.L34:
 490              		.cfi_restore_state
 293:spinnaker_src/if_curr_exp.c ****     	dest_exc = (8 >> pe0)|(8 >> pe1)|(8 >> pe2);
 491              		.loc 1 293 0
 492 003c 0820     		movs	r0, #8
 493 003e 40FA01F1 		asr	r1, r0, r1
 494 0042 40FA02F3 		asr	r3, r0, r2
 495 0046 0B43     		orrs	r3, r3, r1
 496 0048 2041     		asrs	r0, r0, r4
 497 004a 1843     		orrs	r0, r0, r3
 498              	.LVL21:
 499              		.loc 1 301 0
 500 004c 5DF8044B 		ldr	r4, [sp], #4
 501              		.cfi_restore 4
 502              		.cfi_def_cfa_offset 0
 503 0050 7047     		bx	lr
 504              	.L36:
 505 0052 00BF     		.align	2
 506              	.L35:
 507 0054 00000000 		.word	pe_id
 508 0058 00000000 		.word	.LANCHOR7
 509 005c 00000000 		.word	.LANCHOR9
 510 0060 00000000 		.word	.LANCHOR10
 511 0064 00000000 		.word	.LANCHOR8
 512              		.cfi_endproc
 513              	.LFE195:
 515              		.section	.text.comms_init,"ax",%progbits
 516              		.align	2
 517              		.global	comms_init
 518              		.thumb
 519              		.thumb_func
 521              	comms_init:
 522              	.LFB196:
 302:spinnaker_src/if_curr_exp.c **** 
 303:spinnaker_src/if_curr_exp.c **** void comms_init(){
 523              		.loc 1 303 0
 524              		.cfi_startproc
 525              		@ args = 0, pretend = 0, frame = 0
 526              		@ frame_needed = 0, uses_anonymous_args = 0
 527 0000 2DE9F84F 		push	{r3, r4, r5, r6, r7, r8, r9, r10, fp, lr}
 528              		.cfi_def_cfa_offset 40
 529              		.cfi_offset 3, -40
 530              		.cfi_offset 4, -36
 531              		.cfi_offset 5, -32
 532              		.cfi_offset 6, -28
 533              		.cfi_offset 7, -24
 534              		.cfi_offset 8, -20
 535              		.cfi_offset 9, -16
 536              		.cfi_offset 10, -12
 537              		.cfi_offset 11, -8
 538              		.cfi_offset 14, -4
 539              	.LBB91:
 540              	.LBB92:
 541              		.file 3 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
   1:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #ifndef __COMMUNICATION_H__
   2:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #define __COMMUNICATION_H__
   3:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
   4:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #ifdef __cplusplus
   5:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h ****  extern "C" {
   6:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #endif
   7:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
   8:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #include <stdint.h>
   9:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #include <stdbool.h>
  10:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #include "attributes.h"
  11:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** #include "qpe-types.h"
  12:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
  13:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** extern uint8_t _MYCHIPID;
  14:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** extern uint8_t _MYPEID;
  15:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
  16:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** //! @brief Get chipID where the code is running
  17:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** __static_inline uint8_t getMyChipID ()
  18:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** {
  19:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 	return _MYCHIPID;
  20:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** }
  21:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
  22:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** //! @brief Getting the Module of ID where the code is running
  23:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** __static_inline uint8_t getMyPEID ()
  24:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** {
  25:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 	return _MYPEID;
  26:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** }
  27:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
  28:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** //! @brief Get chipID where the code is running
  29:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** __static_inline uint8_t _getMyChipID ()
  30:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** {
  31:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 	return COMMS->ID_Field.MyChipID;
  32:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** }
  33:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 
  34:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** //! @brief Getting the Module of ID where the code is running
  35:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** __static_inline uint8_t _getMyPEID ()
  36:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** {
  37:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** 	return COMMS->ID_Field.MyPEID;
 542              		.loc 3 37 0
 543 0004 4FF06245 		mov	r5, #-503316480
 544              	.LBE92:
 545              	.LBE91:
 304:spinnaker_src/if_curr_exp.c **** 
 305:spinnaker_src/if_curr_exp.c **** 	pe_id = _getMyPEID()&0x3;
 546              		.loc 1 305 0
 547 0008 3F4C     		ldr	r4, .L41
 548              	.LBB94:
 549              	.LBB93:
 550              		.loc 3 37 0
 551 000a D5F8F830 		ldr	r3, [r5, #248]
 552              	.LBE93:
 553              	.LBE94:
 306:spinnaker_src/if_curr_exp.c **** 
 307:spinnaker_src/if_curr_exp.c **** 	uint32_t dest_exc;
 308:spinnaker_src/if_curr_exp.c **** 	//topology specific
 309:spinnaker_src/if_curr_exp.c ****     dest_exc = calc_dest();	
 310:spinnaker_src/if_curr_exp.c ****     // Set up to receive spikes
 311:spinnaker_src/if_curr_exp.c ****     read_pos = 0;
 312:spinnaker_src/if_curr_exp.c ****     comms[COMMS_GCTL] |= 0x00000004;
 313:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_WRITE] = (uint32_t) packet_buffer;
 554              		.loc 1 313 0
 555 000e 3F4E     		ldr	r6, .L41+4
 314:spinnaker_src/if_curr_exp.c ****     comms[COMMS_GCTL] &= 0xFFFFFFFB;
 315:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_READ] = (uint32_t) packet_buffer;
 556              		.loc 1 315 0
 557 0010 DFF824B1 		ldr	fp, .L41+48
 316:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_START] = (uint32_t) packet_buffer;
 558              		.loc 1 316 0
 559 0014 DFF824A1 		ldr	r10, .L41+52
 317:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_END] =
 560              		.loc 1 317 0
 561 0018 DFF82491 		ldr	r9, .L41+56
 318:spinnaker_src/if_curr_exp.c ****         (uint32_t) &(packet_buffer[PACKET_BUFFER_LENGTH]);
 319:spinnaker_src/if_curr_exp.c **** 
 320:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_CONTROL] = 0x0000000F;
 562              		.loc 1 320 0
 563 001c DFF82481 		ldr	r8, .L41+60
 321:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 322:spinnaker_src/if_curr_exp.c ****     comms[COMMS_RCTL] = 0x01F00000;
 564              		.loc 1 322 0
 565 0020 3B4F     		ldr	r7, .L41+8
 305:spinnaker_src/if_curr_exp.c **** 
 566              		.loc 1 305 0
 567 0022 03F00303 		and	r3, r3, #3
 568 0026 2360     		str	r3, [r4]
 309:spinnaker_src/if_curr_exp.c ****     // Set up to receive spikes
 569              		.loc 1 309 0
 570 0028 FFF7FEFF 		bl	calc_dest
 571              	.LVL22:
 311:spinnaker_src/if_curr_exp.c ****     comms[COMMS_GCTL] |= 0x00000004;
 572              		.loc 1 311 0
 573 002c 3949     		ldr	r1, .L41+12
 312:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_WRITE] = (uint32_t) packet_buffer;
 574              		.loc 1 312 0
 575 002e 3A4A     		ldr	r2, .L41+16
 313:spinnaker_src/if_curr_exp.c ****     comms[COMMS_GCTL] &= 0xFFFFFFFB;
 576              		.loc 1 313 0
 577 0030 3A4B     		ldr	r3, .L41+20
 321:spinnaker_src/if_curr_exp.c ****     comms[COMMS_RCTL] = 0x01F00000;
 578              		.loc 1 321 0
 579 0032 DFF814E1 		ldr	lr, .L41+64
 311:spinnaker_src/if_curr_exp.c ****     comms[COMMS_GCTL] |= 0x00000004;
 580              		.loc 1 311 0
 581 0036 4FF0000C 		mov	ip, #0
 582 003a C1F800C0 		str	ip, [r1]
 312:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_WRITE] = (uint32_t) packet_buffer;
 583              		.loc 1 312 0
 584 003e 1168     		ldr	r1, [r2]
 321:spinnaker_src/if_curr_exp.c ****     comms[COMMS_RCTL] = 0x01F00000;
 585              		.loc 1 321 0
 586 0040 DFF808C1 		ldr	ip, .L41+68
 312:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_WRITE] = (uint32_t) packet_buffer;
 587              		.loc 1 312 0
 588 0044 41F00401 		orr	r1, r1, #4
 589 0048 1160     		str	r1, [r2]
 313:spinnaker_src/if_curr_exp.c ****     comms[COMMS_GCTL] &= 0xFFFFFFFB;
 590              		.loc 1 313 0
 591 004a 3360     		str	r3, [r6]
 314:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_READ] = (uint32_t) packet_buffer;
 592              		.loc 1 314 0
 593 004c 1168     		ldr	r1, [r2]
 323:spinnaker_src/if_curr_exp.c **** 
 324:spinnaker_src/if_curr_exp.c ****     // Set up to send spikes
 325:spinnaker_src/if_curr_exp.c **** 	
 326:spinnaker_src/if_curr_exp.c **** 	uint32_t tcr;
 327:spinnaker_src/if_curr_exp.c **** 	//debug! tcr test
 328:spinnaker_src/if_curr_exp.c **** 	if(pe_id != pe3){
 594              		.loc 1 328 0
 595 004e 344E     		ldr	r6, .L41+24
 314:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_READ] = (uint32_t) packet_buffer;
 596              		.loc 1 314 0
 597 0050 21F00401 		bic	r1, r1, #4
 598 0054 1160     		str	r1, [r2]
 315:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_START] = (uint32_t) packet_buffer;
 599              		.loc 1 315 0
 600 0056 CBF80030 		str	r3, [fp]
 318:spinnaker_src/if_curr_exp.c **** 
 601              		.loc 1 318 0
 602 005a 03F57B71 		add	r1, r3, #1004
 320:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 603              		.loc 1 320 0
 604 005e 0F22     		movs	r2, #15
 322:spinnaker_src/if_curr_exp.c **** 
 605              		.loc 1 322 0
 606 0060 4FF0F87B 		mov	fp, #32505856
 316:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_END] =
 607              		.loc 1 316 0
 608 0064 CAF80030 		str	r3, [r10]
 317:spinnaker_src/if_curr_exp.c ****         (uint32_t) &(packet_buffer[PACKET_BUFFER_LENGTH]);
 609              		.loc 1 317 0
 610 0068 C9F80010 		str	r1, [r9]
 320:spinnaker_src/if_curr_exp.c ****     comms[COMMS_DMA_0_CONFIG] = COMMS_DMA_CONFIG_MC_PAYLOAD_RESET;
 611              		.loc 1 320 0
 612 006c C8F80020 		str	r2, [r8]
 321:spinnaker_src/if_curr_exp.c ****     comms[COMMS_RCTL] = 0x01F00000;
 613              		.loc 1 321 0
 614 0070 CEF800C0 		str	ip, [lr]
 322:spinnaker_src/if_curr_exp.c **** 
 615              		.loc 1 322 0
 616 0074 C7F800B0 		str	fp, [r7]
 617              		.loc 1 328 0
 618 0078 2268     		ldr	r2, [r4]
 619 007a 3368     		ldr	r3, [r6]
 620 007c 9A42     		cmp	r2, r3
 621 007e 0AD0     		beq	.L38
 622              	.LVL23:
 329:spinnaker_src/if_curr_exp.c **** 		tcr =
 330:spinnaker_src/if_curr_exp.c **** 			//TODO [optimize comm] more payload
 331:spinnaker_src/if_curr_exp.c **** 			(0x3 <<29) |
 332:spinnaker_src/if_curr_exp.c **** 			((QPE_X<< COMMS_TCR_DEST_X_SHIFT) & COMMS_TCR_DEST_X_MASK)|
 333:spinnaker_src/if_curr_exp.c **** 			((QPE_Y<< COMMS_TCR_DEST_Y_SHIFT) & COMMS_TCR_DEST_Y_MASK);
 334:spinnaker_src/if_curr_exp.c **** 		tcr |= (dest_exc << COMMS_TCR_DEST_P_SHIFT) & COMMS_TCR_DEST_P_MASK;
 623              		.loc 1 334 0
 624 0080 8004     		lsls	r0, r0, #18
 625              	.LVL24:
 335:spinnaker_src/if_curr_exp.c **** 		tcr |= COMMS_TCR_TYPE_SPINN;
 336:spinnaker_src/if_curr_exp.c **** 		tcr |= COMMS_TCR_SPINN_FROUTE_NONE;
 626              		.loc 1 336 0
 627 0082 284B     		ldr	r3, .L41+28
 334:spinnaker_src/if_curr_exp.c **** 		tcr |= COMMS_TCR_TYPE_SPINN;
 628              		.loc 1 334 0
 629 0084 00F4F800 		and	r0, r0, #8126464
 630              		.loc 1 336 0
 631 0088 0343     		orrs	r3, r3, r0
 632              	.LVL25:
 337:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_A] = tcr;
 633              		.loc 1 337 0
 634 008a 2B60     		str	r3, [r5]
 338:spinnaker_src/if_curr_exp.c **** 	}
 339:spinnaker_src/if_curr_exp.c **** 
 340:spinnaker_src/if_curr_exp.c **** 	//debug! tcr test
 341:spinnaker_src/if_curr_exp.c **** 	else if(pe_id == pe3){
 342:spinnaker_src/if_curr_exp.c **** 		uint32_t tcr_a, tcr_b, tcr_c, tcr_d;
 343:spinnaker_src/if_curr_exp.c **** 		uint32_t dest_a, dest_b, dest_c, dest_d;
 344:spinnaker_src/if_curr_exp.c **** 		dest_a = (8>>pe0);
 345:spinnaker_src/if_curr_exp.c **** 		dest_b = (8>>pe1);
 346:spinnaker_src/if_curr_exp.c **** 		dest_c = (8>>pe2);
 347:spinnaker_src/if_curr_exp.c **** 		dest_d = (8>>pe0)|(8>>pe1)|(8>>pe2);
 348:spinnaker_src/if_curr_exp.c **** 		tcr_a =
 349:spinnaker_src/if_curr_exp.c **** 			//TODO [optimize comm] more payload
 350:spinnaker_src/if_curr_exp.c **** 			(0x3 <<29) |
 351:spinnaker_src/if_curr_exp.c **** 			((QPE_X<< COMMS_TCR_DEST_X_SHIFT) & COMMS_TCR_DEST_X_MASK)|
 352:spinnaker_src/if_curr_exp.c **** 			((QPE_Y<< COMMS_TCR_DEST_Y_SHIFT) & COMMS_TCR_DEST_Y_MASK);
 353:spinnaker_src/if_curr_exp.c **** 		tcr_a |= (dest_a << COMMS_TCR_DEST_P_SHIFT) & COMMS_TCR_DEST_P_MASK;
 354:spinnaker_src/if_curr_exp.c **** 		tcr_a |= COMMS_TCR_TYPE_SPINN;
 355:spinnaker_src/if_curr_exp.c **** 		tcr_a |= COMMS_TCR_SPINN_FROUTE_NONE;
 356:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_A] = tcr_a;
 357:spinnaker_src/if_curr_exp.c **** 	
 358:spinnaker_src/if_curr_exp.c **** 		tcr_b =
 359:spinnaker_src/if_curr_exp.c **** 			//TODO [optimize comm]  more payload
 360:spinnaker_src/if_curr_exp.c **** 			(0x3 <<29) |
 361:spinnaker_src/if_curr_exp.c **** 			((QPE_X<< COMMS_TCR_DEST_X_SHIFT) & COMMS_TCR_DEST_X_MASK)|
 362:spinnaker_src/if_curr_exp.c **** 			((QPE_Y<< COMMS_TCR_DEST_Y_SHIFT) & COMMS_TCR_DEST_Y_MASK);
 363:spinnaker_src/if_curr_exp.c **** 		tcr_b |= (dest_b << COMMS_TCR_DEST_P_SHIFT) & COMMS_TCR_DEST_P_MASK;
 364:spinnaker_src/if_curr_exp.c **** 		tcr_b |= COMMS_TCR_TYPE_SPINN;
 365:spinnaker_src/if_curr_exp.c **** 		tcr_b |= COMMS_TCR_SPINN_FROUTE_NONE;
 366:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_B] = tcr_b;
 367:spinnaker_src/if_curr_exp.c **** 
 368:spinnaker_src/if_curr_exp.c **** 		tcr_c =
 369:spinnaker_src/if_curr_exp.c **** 			//TODO  [optimize comm] more payload
 370:spinnaker_src/if_curr_exp.c **** 			(0x3 <<29) |
 371:spinnaker_src/if_curr_exp.c **** 			((QPE_X<< COMMS_TCR_DEST_X_SHIFT) & COMMS_TCR_DEST_X_MASK)|
 372:spinnaker_src/if_curr_exp.c **** 			((QPE_Y<< COMMS_TCR_DEST_Y_SHIFT) & COMMS_TCR_DEST_Y_MASK);
 373:spinnaker_src/if_curr_exp.c **** 		tcr_c |= (dest_c << COMMS_TCR_DEST_P_SHIFT) & COMMS_TCR_DEST_P_MASK;
 374:spinnaker_src/if_curr_exp.c **** 		tcr_c |= COMMS_TCR_TYPE_SPINN;
 375:spinnaker_src/if_curr_exp.c **** 		tcr_c |= COMMS_TCR_SPINN_FROUTE_NONE;
 376:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_C] = tcr_c;
 377:spinnaker_src/if_curr_exp.c **** 
 378:spinnaker_src/if_curr_exp.c **** 		tcr_d =
 379:spinnaker_src/if_curr_exp.c **** 			//TODO  [optimize comm] more payload
 380:spinnaker_src/if_curr_exp.c **** 			(0x3 <<29) |
 381:spinnaker_src/if_curr_exp.c **** 			((QPE_X<< COMMS_TCR_DEST_X_SHIFT) & COMMS_TCR_DEST_X_MASK)|
 382:spinnaker_src/if_curr_exp.c **** 			((QPE_Y<< COMMS_TCR_DEST_Y_SHIFT) & COMMS_TCR_DEST_Y_MASK);
 383:spinnaker_src/if_curr_exp.c **** 		tcr_d |= (dest_d << COMMS_TCR_DEST_P_SHIFT) & COMMS_TCR_DEST_P_MASK;
 384:spinnaker_src/if_curr_exp.c **** 		tcr_d |= COMMS_TCR_TYPE_SPINN;
 385:spinnaker_src/if_curr_exp.c **** 		tcr_d |= COMMS_TCR_SPINN_FROUTE_NONE;
 386:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_D] = tcr_d;
 387:spinnaker_src/if_curr_exp.c **** 	}
 388:spinnaker_src/if_curr_exp.c **** 
 389:spinnaker_src/if_curr_exp.c **** 
 390:spinnaker_src/if_curr_exp.c ****     comms[COMMS_TCTL] = 0xE;
 635              		.loc 1 390 0
 636 008c 264B     		ldr	r3, .L41+32
 637              	.LVL26:
 638 008e 0E22     		movs	r2, #14
 639 0090 1A60     		str	r2, [r3]
 640              	.LVL27:
 641 0092 BDE8F88F 		pop	{r3, r4, r5, r6, r7, r8, r9, r10, fp, pc}
 642              	.LVL28:
 643              	.L38:
 644              	.LBB95:
 344:spinnaker_src/if_curr_exp.c **** 		dest_b = (8>>pe1);
 645              		.loc 1 344 0
 646 0096 254B     		ldr	r3, .L41+36
 345:spinnaker_src/if_curr_exp.c **** 		dest_c = (8>>pe2);
 647              		.loc 1 345 0
 648 0098 2549     		ldr	r1, .L41+40
 346:spinnaker_src/if_curr_exp.c **** 		dest_d = (8>>pe0)|(8>>pe1)|(8>>pe2);
 649              		.loc 1 346 0
 650 009a 264A     		ldr	r2, .L41+44
 344:spinnaker_src/if_curr_exp.c **** 		dest_b = (8>>pe1);
 651              		.loc 1 344 0
 652 009c 1B68     		ldr	r3, [r3]
 345:spinnaker_src/if_curr_exp.c **** 		dest_c = (8>>pe2);
 653              		.loc 1 345 0
 654 009e 0968     		ldr	r1, [r1]
 346:spinnaker_src/if_curr_exp.c **** 		dest_d = (8>>pe0)|(8>>pe1)|(8>>pe2);
 655              		.loc 1 346 0
 656 00a0 1068     		ldr	r0, [r2]
 657              	.LVL29:
 355:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_A] = tcr_a;
 658              		.loc 1 355 0
 659 00a2 DFF880E0 		ldr	lr, .L41+28
 366:spinnaker_src/if_curr_exp.c **** 
 660              		.loc 1 366 0
 661 00a6 DFF8A890 		ldr	r9, .L41+72
 376:spinnaker_src/if_curr_exp.c **** 
 662              		.loc 1 376 0
 663 00aa DFF8A880 		ldr	r8, .L41+76
 386:spinnaker_src/if_curr_exp.c **** 	}
 664              		.loc 1 386 0
 665 00ae DFF8A8C0 		ldr	ip, .L41+80
 344:spinnaker_src/if_curr_exp.c **** 		dest_b = (8>>pe1);
 666              		.loc 1 344 0
 667 00b2 0822     		movs	r2, #8
 668 00b4 42FA03F3 		asr	r3, r2, r3
 669              	.LVL30:
 345:spinnaker_src/if_curr_exp.c **** 		dest_c = (8>>pe2);
 670              		.loc 1 345 0
 671 00b8 42FA01F1 		asr	r1, r2, r1
 672              	.LVL31:
 346:spinnaker_src/if_curr_exp.c **** 		dest_d = (8>>pe0)|(8>>pe1)|(8>>pe2);
 673              		.loc 1 346 0
 674 00bc 0241     		asrs	r2, r2, r0
 675              	.LVL32:
 347:spinnaker_src/if_curr_exp.c **** 		tcr_a =
 676              		.loc 1 347 0
 677 00be 41EA0300 		orr	r0, r1, r3
 678 00c2 1043     		orrs	r0, r0, r2
 679              	.LVL33:
 353:spinnaker_src/if_curr_exp.c **** 		tcr_a |= COMMS_TCR_TYPE_SPINN;
 680              		.loc 1 353 0
 681 00c4 9B04     		lsls	r3, r3, #18
 682              	.LVL34:
 385:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_D] = tcr_d;
 683              		.loc 1 385 0
 684 00c6 7446     		mov	r4, lr
 353:spinnaker_src/if_curr_exp.c **** 		tcr_a |= COMMS_TCR_TYPE_SPINN;
 685              		.loc 1 353 0
 686 00c8 03F4F803 		and	r3, r3, #8126464
 363:spinnaker_src/if_curr_exp.c **** 		tcr_b |= COMMS_TCR_TYPE_SPINN;
 687              		.loc 1 363 0
 688 00cc 8904     		lsls	r1, r1, #18
 689              	.LVL35:
 383:spinnaker_src/if_curr_exp.c **** 		tcr_d |= COMMS_TCR_TYPE_SPINN;
 690              		.loc 1 383 0
 691 00ce 8004     		lsls	r0, r0, #18
 692              	.LVL36:
 373:spinnaker_src/if_curr_exp.c **** 		tcr_c |= COMMS_TCR_TYPE_SPINN;
 693              		.loc 1 373 0
 694 00d0 9204     		lsls	r2, r2, #18
 695              	.LVL37:
 365:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_B] = tcr_b;
 696              		.loc 1 365 0
 697 00d2 7746     		mov	r7, lr
 375:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_C] = tcr_c;
 698              		.loc 1 375 0
 699 00d4 2646     		mov	r6, r4
 373:spinnaker_src/if_curr_exp.c **** 		tcr_c |= COMMS_TCR_TYPE_SPINN;
 700              		.loc 1 373 0
 701 00d6 02F4F802 		and	r2, r2, #8126464
 355:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_A] = tcr_a;
 702              		.loc 1 355 0
 703 00da 43EA0E0E 		orr	lr, r3, lr
 704              	.LVL38:
 363:spinnaker_src/if_curr_exp.c **** 		tcr_b |= COMMS_TCR_TYPE_SPINN;
 705              		.loc 1 363 0
 706 00de 01F4F801 		and	r1, r1, #8126464
 383:spinnaker_src/if_curr_exp.c **** 		tcr_d |= COMMS_TCR_TYPE_SPINN;
 707              		.loc 1 383 0
 708 00e2 00F4F800 		and	r0, r0, #8126464
 709              	.LBE95:
 710              		.loc 1 390 0
 711 00e6 104B     		ldr	r3, .L41+32
 712              	.LBB96:
 356:spinnaker_src/if_curr_exp.c **** 	
 713              		.loc 1 356 0
 714 00e8 C5F800E0 		str	lr, [r5]
 715              	.LVL39:
 375:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_C] = tcr_c;
 716              		.loc 1 375 0
 717 00ec 1643     		orrs	r6, r6, r2
 385:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_D] = tcr_d;
 718              		.loc 1 385 0
 719 00ee 0443     		orrs	r4, r4, r0
 365:spinnaker_src/if_curr_exp.c **** 		comms[COMMS_TCR_B] = tcr_b;
 720              		.loc 1 365 0
 721 00f0 0F43     		orrs	r7, r7, r1
 722              	.LVL40:
 723              	.LBE96:
 724              		.loc 1 390 0
 725 00f2 0E22     		movs	r2, #14
 726              	.LBB97:
 366:spinnaker_src/if_curr_exp.c **** 
 727              		.loc 1 366 0
 728 00f4 C9F80070 		str	r7, [r9]
 729              	.LVL41:
 376:spinnaker_src/if_curr_exp.c **** 
 730              		.loc 1 376 0
 731 00f8 C8F80060 		str	r6, [r8]
 732              	.LVL42:
 386:spinnaker_src/if_curr_exp.c **** 	}
 733              		.loc 1 386 0
 734 00fc CCF80040 		str	r4, [ip]
 735              	.LBE97:
 736              		.loc 1 390 0
 737 0100 1A60     		str	r2, [r3]
 738 0102 BDE8F88F 		pop	{r3, r4, r5, r6, r7, r8, r9, r10, fp, pc}
 739              	.LVL43:
 740              	.L42:
 741 0106 00BF     		.align	2
 742              	.L41:
 743 0108 00000000 		.word	pe_id
 744 010c 100100E2 		.word	-503316208
 745 0110 9C0000E2 		.word	-503316324
 746 0114 00000000 		.word	.LANCHOR11
 747 0118 FC0000E2 		.word	-503316228
 748 011c 00000000 		.word	packet_buffer
 749 0120 00000000 		.word	.LANCHOR8
 750 0124 00C78164 		.word	1686226688
 751 0128 7C0000E2 		.word	-503316356
 752 012c 00000000 		.word	.LANCHOR7
 753 0130 00000000 		.word	.LANCHOR9
 754 0134 00000000 		.word	.LANCHOR10
 755 0138 0C0100E2 		.word	-503316212
 756 013c 040100E2 		.word	-503316220
 757 0140 080100E2 		.word	-503316216
 758 0144 3C0100E2 		.word	-503316164
 759 0148 000100E2 		.word	-503316224
 760 014c 41062000 		.word	2098753
 761 0150 200000E2 		.word	-503316448
 762 0154 400000E2 		.word	-503316416
 763 0158 600000E2 		.word	-503316384
 764              		.cfi_endproc
 765              	.LFE196:
 767              		.section	.text.log_results,"ax",%progbits
 768              		.align	2
 769              		.global	log_results
 770              		.thumb
 771              		.thumb_func
 773              	log_results:
 774              	.LFB197:
 391:spinnaker_src/if_curr_exp.c **** 
 392:spinnaker_src/if_curr_exp.c **** }
 393:spinnaker_src/if_curr_exp.c **** void log_results(){
 775              		.loc 1 393 0
 776              		.cfi_startproc
 777              		@ args = 0, pretend = 0, frame = 0
 778              		@ frame_needed = 0, uses_anonymous_args = 0
 779 0000 08B5     		push	{r3, lr}
 780              		.cfi_def_cfa_offset 8
 781              		.cfi_offset 3, -8
 782              		.cfi_offset 14, -4
 394:spinnaker_src/if_curr_exp.c **** 
 395:spinnaker_src/if_curr_exp.c ****     log_info("Received %u spikes\n", n_packets_received);
 783              		.loc 1 395 0
 784 0002 0B4B     		ldr	r3, .L45
 785 0004 0B48     		ldr	r0, .L45+4
 786 0006 1968     		ldr	r1, [r3]
 787 0008 FFF7FEFF 		bl	log_info
 788              	.LVL44:
 396:spinnaker_src/if_curr_exp.c ****     log_info("Received %u unknown keys\n", n_unknown_keys);
 789              		.loc 1 396 0
 790 000c 0A48     		ldr	r0, .L45+8
 791 000e 0021     		movs	r1, #0
 792 0010 FFF7FEFF 		bl	log_info
 793              	.LVL45:
 397:spinnaker_src/if_curr_exp.c ****     log_info(
 794              		.loc 1 397 0
 795 0014 094B     		ldr	r3, .L45+12
 796 0016 0A4A     		ldr	r2, .L45+16
 797 0018 0A48     		ldr	r0, .L45+20
 798 001a 1168     		ldr	r1, [r2]
 799 001c 1A68     		ldr	r2, [r3]
 800 001e FFF7FEFF 		bl	log_info
 801              	.LVL46:
 398:spinnaker_src/if_curr_exp.c ****         "Dropped normal = %d, Dropped DMA = %d\n",
 399:spinnaker_src/if_curr_exp.c ****         comms[COMMS_RDC], comms[COMMS_DMA_0_DROPS]);
 400:spinnaker_src/if_curr_exp.c ****     log_info("Sent %u spikes\n", n_spikes_sent);
 802              		.loc 1 400 0
 803 0022 094B     		ldr	r3, .L45+24
 804 0024 0948     		ldr	r0, .L45+28
 805 0026 1968     		ldr	r1, [r3]
 401:spinnaker_src/if_curr_exp.c **** 
 402:spinnaker_src/if_curr_exp.c **** }
 806              		.loc 1 402 0
 807 0028 BDE80840 		pop	{r3, lr}
 808              		.cfi_restore 14
 809              		.cfi_restore 3
 810              		.cfi_def_cfa_offset 0
 400:spinnaker_src/if_curr_exp.c **** 
 811              		.loc 1 400 0
 812 002c FFF7FEBF 		b	log_info
 813              	.LVL47:
 814              	.L46:
 815              		.align	2
 816              	.L45:
 817 0030 00000000 		.word	.LANCHOR0
 818 0034 84000000 		.word	.LC4
 819 0038 98000000 		.word	.LC5
 820 003c 200100E2 		.word	-503316192
 821 0040 980000E2 		.word	-503316328
 822 0044 B4000000 		.word	.LC6
 823 0048 00000000 		.word	.LANCHOR12
 824 004c DC000000 		.word	.LC7
 825              		.cfi_endproc
 826              	.LFE197:
 828              		.section	.text.startup.main,"ax",%progbits
 829              		.align	2
 830              		.global	main
 831              		.thumb
 832              		.thumb_func
 834              	main:
 835              	.LFB198:
 403:spinnaker_src/if_curr_exp.c **** int main() {
 836              		.loc 1 403 0
 837              		.cfi_startproc
 838              		@ args = 0, pretend = 0, frame = 0
 839              		@ frame_needed = 0, uses_anonymous_args = 0
 840 0000 2DE9F843 		push	{r3, r4, r5, r6, r7, r8, r9, lr}
 841              		.cfi_def_cfa_offset 32
 842              		.cfi_offset 3, -32
 843              		.cfi_offset 4, -28
 844              		.cfi_offset 5, -24
 845              		.cfi_offset 6, -20
 846              		.cfi_offset 7, -16
 847              		.cfi_offset 8, -12
 848              		.cfi_offset 9, -8
 849              		.cfi_offset 14, -4
 850              	.LBB98:
 851              	.LBB99:
 852              	.LBB100:
 853              	.LBB101:
 854              	.LBB102:
  25:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** }
 855              		.loc 3 25 0
 856 0004 294A     		ldr	r2, .L53
 857              	.LBE102:
 858              	.LBE101:
 859              	.LBB103:
 860              	.LBB104:
  19:/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h **** }
 861              		.loc 3 19 0
 862 0006 2A4B     		ldr	r3, .L53+4
 863              	.LBE104:
 864              	.LBE103:
 865              		.file 4 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
   1:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
   2:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #ifndef __RANDOM_H__
   3:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define __RANDOM_H__
   4:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
   5:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #include <stdint.h>
   6:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
   7:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #include "attributes.h"
   8:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #include "communication.h"
   9:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  10:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #include "nmu.h"
  11:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  12:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #ifndef INIT_KISS_X
  13:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define INIT_KISS_X 143185431
  14:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #endif
  15:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  16:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #ifndef INIT_KISS_Y
  17:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define INIT_KISS_Y 987654321
  18:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #endif
  19:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  20:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #ifndef INIT_KISS_Z
  21:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define INIT_KISS_Z 1762089
  22:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #endif
  23:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  24:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #ifndef INIT_KISS_C
  25:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define INIT_KISS_C 6543217 /* Seed variables */
  26:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #endif
  27:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  28:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #ifdef USE_SOFTWARE_RNG
  29:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** //#pragma message "Using Software Random Number Generator"
  30:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define RNG_WRAPPER(func) func##_soft
  31:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #else
  32:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #define RNG_WRAPPER(func) func##_hard
  33:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** #endif
  34:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  35:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** typedef uint32_t (*rng_uni)  (void);
  36:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** typedef float    (*rng_unif) (void);
  37:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** extern uint32_t kiss_x, kiss_y, kiss_z, kiss_c;
  38:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  39:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** //============  srand functions  ===============================================
  40:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  41:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** __static_inline void srand_soft (void)
  42:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** {
  43:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	uint32_t unused __attribute__((unused));
  44:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  45:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_x = INIT_KISS_X * (getMyChipID () + getMyPEID () + 1);
  46:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_y = INIT_KISS_Y * (getMyChipID () + getMyPEID () + 1);
  47:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_z = INIT_KISS_Z * (getMyChipID () + getMyPEID () + 1);
  48:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_c = INIT_KISS_C * (getMyChipID () + getMyPEID () + 1);
  49:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** }
  50:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  51:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** __static_inline void srand_hard (void)
  52:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** {
  53:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	uint32_t unused __attribute__((unused));
  54:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 1, INIT_KISS_X * (getMyChipID () + getMyPEID () + 1));
 866              		.loc 4 55 0
 867 0008 1278     		ldrb	r2, [r2]	@ zero_extendqisi2
 868 000a 1B78     		ldrb	r3, [r3]	@ zero_extendqisi2
  56:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 2, INIT_KISS_Y * (getMyChipID () + getMyPEID () + 1));
  57:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 3, INIT_KISS_Z * (getMyChipID () + getMyPEID () + 1));
 869              		.loc 4 57 0
 870 000c DFF8C4E0 		ldr	lr, .L53+40
  58:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 0, INIT_KISS_C * (getMyChipID () + getMyPEID () + 1));
 871              		.loc 4 58 0
 872 0010 2848     		ldr	r0, .L53+8
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 2, INIT_KISS_Y * (getMyChipID () + getMyPEID () + 1));
 873              		.loc 4 55 0
 874 0012 294D     		ldr	r5, .L53+12
  56:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 2, INIT_KISS_Y * (getMyChipID () + getMyPEID () + 1));
 875              		.loc 4 56 0
 876 0014 DFF8C0C0 		ldr	ip, .L53+44
 877              	.LBB105:
 878              	.LBB106:
 879              		.file 5 "/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h"
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
 108:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
 109:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 110:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Floatingpoint version of expf ()
 111:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline float hwexpf (float arg)
 112:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
 113:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #ifdef HWEXPF_FP_APPROX
 114:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****   #ifndef HWEXPF_LIMIT_FP_LOW 
 115:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     #define HWEXPF_LIMIT_FP_LOW -2.0
 116:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****   #endif
 117:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****   #ifndef HWEXPF_LIMIT_FP_HIGH
 118:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     #define HWEXPF_LIMIT_FP_LOW 10.0
 119:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****   #endif
 120:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     if (arg>HWEXPF_LIMIT_FP_LOW && arg<HWEXPF_LIMIT_FP_HIGH) {
 121:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         nmu_exp_calc (float2fxpt(arg));
 122:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         return fxpt2float (nmu_exp_fetch ());
 123:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     }
 124:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #endif
 125:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     /* 49 cycles in total (inline saves 10 (!) cycles)*/
 126:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 127:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     /* range checking */
 128:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     if (unlikely (arg<-87.3365 /* ln (2^-126) [no denormal numbers] */)) {
 129:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         return 0.0;
 130:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     }
 131:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     if (unlikely (arg>88.7228 /* ln (2^128)  */)) {
 132:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         union {
 133:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****             uint32_t i;
 134:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****             float f;
 135:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         } nan;
 136:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         nan.i = 0x7f8fffff; /* NaN */;
 137:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         return nan.f;
 138:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     }
 139:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 140:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     const int32_t F_LN = 8;
 141:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     const int32_t MIN_V = 0x0002c5c9; /* hwexp (MIN_V)>256 */
 142:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     const int32_t MAX_V= 0x00031e81; /* hwexp (MAX_V)<512 */
 143:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 144:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     const float LN_2 = 0.69314718f;
 145:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     const float INV_LN_2 = (1.0/0.69314718f);
 146:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 147:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     float_word_t a;
 148:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     a.f = arg;
 149:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     // normalize argument to [F_LN*ln(2), (F_LN+1)*ln(2)]
 150:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t n = (int32_t) (a.f*INV_LN_2);
 151:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     n = (a.w&0x80000000) ? n-(F_LN+1) : n-F_LN;
 152:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     a.f = a.f - n*LN_2;
 153:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 154:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t s = (23/*float-frac*/-15/*fp-frac*/-2/*exp*/);
 155:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     //int32_t hwexp_x = (0x00800000|(a.w&0x007fffff)) >> s;
 156:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     /* since we already know the exponent(0x81), we can mask and set in one cycle */
 157:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t hwexp_x = (a.w^0x40000000) >> s;
 158:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 159:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     nmu_exp_calc (hwexp_x);
 160:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     int32_t exp = 127+n+F_LN;
 161:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 162:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     exp<<=23;
 163:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 164:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     float_word_t res;
 165:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     res.w = exp;
 166:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     if (unlikely (hwexp_x<MIN_V)) {
 167:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         nmu_exp_fetch ();
 168:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w |= 0x00000000;
 169:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     } else if (unlikely (hwexp_x>MAX_V)) {
 170:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         nmu_exp_fetch ();
 171:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w |= 0x007fffff;
 172:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     } else {
 173:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****         res.w |= (nmu_exp_fetch ())&0x007fffff;
 174:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     }
 175:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 176:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return res.f;
 177:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
 178:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @}
 179:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 180:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @name Random acceleration units
 181:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @{
 182:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 183:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! Selection of the Random Number Generator
 184:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** typedef enum {
 185:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 	kiss32_0, //!< 1st KISS32 Random Number Generator
 186:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 	kiss32_1, //!< 2nd KISS32 Random Number Generator
 187:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 	kiss64_0, //!<     KISS64 Random Number Generator
 188:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #ifndef DOXYGEN
 189:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     KISS_COUNT
 190:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** #endif
 191:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** } kiss_t;
 192:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 193:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Read Integer value from the hardware KISS
 194:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline uint32_t kiss_read_int (kiss_t kiss)
 195:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
 196:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     assert (kiss>=0 && kiss < KISS_COUNT);
 197:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return NMU_KISS[kiss].RND_VALUE;
 198:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
 199:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 200:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Read Integer value from the hardware KISS
 201:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline float kiss_read_float (kiss_t kiss)
 202:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
 203:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     assert (kiss>=0 && kiss < KISS_COUNT);
 204:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     return NMU_KISS[kiss].RND_VALUE_FLOAT;
 205:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** }
 206:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** 
 207:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** //! @brief Write KISS Seed
 208:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** __static_inline void kiss_seed_set (kiss_t kiss, int i_seed, uint32_t value)
 209:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h **** {
 210:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     assert (kiss>=0 && kiss < KISS_COUNT);
 211:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     assert (i_seed >= 0 && i_seed < 5);
 212:/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h ****     NMU_KISS[kiss].SEED[i_seed] = value;
 880              		.loc 5 212 0
 881 0018 2849     		ldr	r1, .L53+16
 882              	.LBE106:
 883              	.LBE105:
 884              	.LBE100:
 885              	.LBE99:
 886              	.LBE98:
 404:spinnaker_src/if_curr_exp.c **** 
 405:spinnaker_src/if_curr_exp.c ****     finished = 0;
 887              		.loc 1 405 0
 888 001a 294C     		ldr	r4, .L53+20
 406:spinnaker_src/if_curr_exp.c ****     time = 0;
 889              		.loc 1 406 0
 890 001c DFF8BC80 		ldr	r8, .L53+48
 891              	.LBB119:
 892              	.LBB120:
 264:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 893              		.loc 1 264 0
 894 0020 284F     		ldr	r7, .L53+24
 895              	.LBE120:
 896              	.LBE119:
 407:spinnaker_src/if_curr_exp.c **** 	srand();
 408:spinnaker_src/if_curr_exp.c **** 	log_prepare();
 409:spinnaker_src/if_curr_exp.c **** 	timer_init();
 410:spinnaker_src/if_curr_exp.c **** 	comms_init();
 411:spinnaker_src/if_curr_exp.c **** 	//debug! all in sram
 412:spinnaker_src/if_curr_exp.c ****     ProgramInit();
 413:spinnaker_src/if_curr_exp.c **** 
 414:spinnaker_src/if_curr_exp.c **** 	// Wait for start
 415:spinnaker_src/if_curr_exp.c ****     *status = IF_CURR_EXP_STATUS_READY;
 897              		.loc 1 415 0
 898 0022 294E     		ldr	r6, .L53+28
 899              	.LBB122:
 900              	.LBB117:
 901              	.LBB115:
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 2, INIT_KISS_Y * (getMyChipID () + getMyPEID () + 1));
 902              		.loc 4 55 0
 903 0024 1344     		add	r3, r3, r2
 904 0026 0133     		adds	r3, r3, #1
  57:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 0, INIT_KISS_C * (getMyChipID () + getMyPEID () + 1));
 905              		.loc 4 57 0
 906 0028 0EFB03F2 		mul	r2, lr, r3
  56:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 3, INIT_KISS_Z * (getMyChipID () + getMyPEID () + 1));
 907              		.loc 4 56 0
 908 002c 0CFB03FC 		mul	ip, ip, r3
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/random.h **** 	kiss_seed_set (kiss64_0, 2, INIT_KISS_Y * (getMyChipID () + getMyPEID () + 1));
 909              		.loc 4 55 0
 910 0030 05FB03F9 		mul	r9, r5, r3
 911              	.LVL48:
 912              		.loc 4 58 0
 913 0034 00FB03F3 		mul	r3, r0, r3
 914              	.LVL49:
 915              	.LBE115:
 916              	.LBE117:
 917              	.LBE122:
 405:spinnaker_src/if_curr_exp.c ****     time = 0;
 918              		.loc 1 405 0
 919 0038 0025     		movs	r5, #0
 920 003a 2560     		str	r5, [r4]
 406:spinnaker_src/if_curr_exp.c **** 	srand();
 921              		.loc 1 406 0
 922 003c C8F80050 		str	r5, [r8]
 923              	.LBB123:
 924              	.LBB118:
 925              	.LBB116:
 926              	.LBB108:
 927              	.LBB107:
 928              		.loc 5 212 0
 929 0040 C1F80490 		str	r9, [r1, #4]
 930              	.LBE107:
 931              	.LBE108:
 932              	.LBB109:
 933              	.LBB110:
 934 0044 C1F808C0 		str	ip, [r1, #8]
 935              	.LBE110:
 936              	.LBE109:
 937              	.LBB111:
 938              	.LBB112:
 939 0048 CA60     		str	r2, [r1, #12]
 940              	.LBE112:
 941              	.LBE111:
 942              	.LBB113:
 943              	.LBB114:
 944 004a 0B60     		str	r3, [r1]
 945              	.LBE114:
 946              	.LBE113:
 947              	.LBE116:
 948              	.LBE118:
 949              	.LBE123:
 408:spinnaker_src/if_curr_exp.c **** 	timer_init();
 950              		.loc 1 408 0
 951 004c FFF7FEFF 		bl	log_prepare
 952              	.LVL50:
 953              	.LBB124:
 954              	.LBB121:
 266:spinnaker_src/if_curr_exp.c **** 
 955              		.loc 1 266 0
 956 0050 1E4B     		ldr	r3, .L53+32
 264:spinnaker_src/if_curr_exp.c **** 	//TODO real time operation
 957              		.loc 1 264 0
 958 0052 3D60     		str	r5, [r7]
 266:spinnaker_src/if_curr_exp.c **** 
 959              		.loc 1 266 0
 960 0054 1968     		ldr	r1, [r3]
 961 0056 4FF06142 		mov	r2, #-520093696
 962 005a 4FF47A73 		mov	r3, #1000
 963 005e 03FB01F3 		mul	r3, r3, r1
 964 0062 1360     		str	r3, [r2]
 965              	.LBE121:
 966              	.LBE124:
 410:spinnaker_src/if_curr_exp.c **** 	//debug! all in sram
 967              		.loc 1 410 0
 968 0064 FFF7FEFF 		bl	comms_init
 969              	.LVL51:
 970              	.LBB125:
 971              	.LBB126:
 132:spinnaker_src/if_curr_exp.c **** }
 972              		.loc 1 132 0
 973 0068 FFF7FEFF 		bl	NeuralInit
 974              	.LVL52:
 975              	.LBE126:
 976              	.LBE125:
 977              		.loc 1 415 0
 978 006c 3368     		ldr	r3, [r6]
 979 006e 0222     		movs	r2, #2
 980 0070 1A60     		str	r2, [r3]
 416:spinnaker_src/if_curr_exp.c ****     wait_for_start();
 981              		.loc 1 416 0
 982 0072 FFF7FEFF 		bl	wait_for_start
 983              	.LVL53:
 417:spinnaker_src/if_curr_exp.c ****     *status = IF_CURR_EXP_STATUS_RUNNING;
 984              		.loc 1 417 0
 985 0076 3268     		ldr	r2, [r6]
 986              	.LBB127:
 987              	.LBB128:
 988              	.LBB129:
 989              	.LBB130:
 990              		.loc 2 1706 0
 991 0078 154B     		ldr	r3, .L53+36
 992              	.LBE130:
 993              	.LBE129:
 994              	.LBE128:
 995              	.LBE127:
 996              		.loc 1 417 0
 997 007a 1560     		str	r5, [r2]
 998              	.LBB140:
 999              	.LBB139:
 273:spinnaker_src/if_curr_exp.c ****     NVIC_SetPriority(IRQ_00_IRQn, (1UL << __NVIC_PRIO_BITS) - 2UL);
 1000              		.loc 1 273 0
 1001 007c E220     		movs	r0, #226
 1002              	.LBB133:
 1003              	.LBB131:
 1004              		.loc 2 1706 0
 1005 007e F021     		movs	r1, #240
 1006              	.LBE131:
 1007              	.LBE133:
 1008              	.LBB134:
 1009              	.LBB135:
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 1010              		.loc 2 1628 0
 1011 0080 0122     		movs	r2, #1
 1012              	.LBE135:
 1013              	.LBE134:
 273:spinnaker_src/if_curr_exp.c ****     NVIC_SetPriority(IRQ_00_IRQn, (1UL << __NVIC_PRIO_BITS) - 2UL);
 1014              		.loc 1 273 0
 1015 0082 3860     		str	r0, [r7]
 1016              	.LVL54:
 1017              	.LBB137:
 1018              	.LBB132:
 1019              		.loc 2 1706 0
 1020 0084 83F80013 		strb	r1, [r3, #768]
 1021              	.LVL55:
 1022              	.LBE132:
 1023              	.LBE137:
 1024              	.LBB138:
 1025              	.LBB136:
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 1026              		.loc 2 1628 0
 1027 0088 1A60     		str	r2, [r3]
 1028              	.LBE136:
 1029              	.LBE138:
 1030              	.LBE139:
 1031              	.LBE140:
 418:spinnaker_src/if_curr_exp.c **** 
 419:spinnaker_src/if_curr_exp.c **** 	//debug! real time comm
 420:spinnaker_src/if_curr_exp.c **** 	timer_start();
 421:spinnaker_src/if_curr_exp.c **** 
 422:spinnaker_src/if_curr_exp.c ****     dispatch();
 1032              		.loc 1 422 0
 1033 008a FFF7FEFF 		bl	dispatch
 1034              	.LVL56:
 423:spinnaker_src/if_curr_exp.c **** 	
 424:spinnaker_src/if_curr_exp.c ****     while (finished == 0) {
 1035              		.loc 1 424 0
 1036 008e 2368     		ldr	r3, [r4]
 1037 0090 1BB9     		cbnz	r3, .L48
 1038              	.L49:
 1039              	.LBB141:
 1040              	.LBB142:
 1041              		.file 6 "/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h"
   1:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**************************************************************************//**
   2:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  * @file     cmsis_gcc.h
   3:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  * @brief    CMSIS Cortex-M Core Function/Instruction Header File
   4:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  * @version  V4.30
   5:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  * @date     20. October 2015
   6:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  ******************************************************************************/
   7:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /* Copyright (c) 2009 - 2015 ARM LIMITED
   8:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
   9:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    All rights reserved.
  10:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    Redistribution and use in source and binary forms, with or without
  11:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    modification, are permitted provided that the following conditions are met:
  12:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    - Redistributions of source code must retain the above copyright
  13:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****      notice, this list of conditions and the following disclaimer.
  14:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    - Redistributions in binary form must reproduce the above copyright
  15:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****      notice, this list of conditions and the following disclaimer in the
  16:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****      documentation and/or other materials provided with the distribution.
  17:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    - Neither the name of ARM nor the names of its contributors may be used
  18:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****      to endorse or promote products derived from this software without
  19:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****      specific prior written permission.
  20:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    *
  21:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  22:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  23:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  24:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
  25:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  26:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  27:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  28:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  29:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  30:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  31:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    POSSIBILITY OF SUCH DAMAGE.
  32:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    ---------------------------------------------------------------------------*/
  33:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  34:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  35:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #ifndef __CMSIS_GCC_H
  36:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #define __CMSIS_GCC_H
  37:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  38:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #include "attributes.h"
  39:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /* ignore some GCC warnings */
  40:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #if defined ( __GNUC__ )
  41:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #pragma GCC diagnostic push
  42:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #pragma GCC diagnostic ignored "-Wsign-conversion"
  43:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #pragma GCC diagnostic ignored "-Wconversion"
  44:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #pragma GCC diagnostic ignored "-Wunused-parameter"
  45:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #endif
  46:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  47:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  48:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /* ###########################  Core Function Access  ########################### */
  49:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /** \ingroup  CMSIS_Core_FunctionInterface
  50:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****     \defgroup CMSIS_Core_RegAccFunctions CMSIS Core Register Access Functions
  51:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   @{
  52:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
  53:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  54:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
  55:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Enable IRQ Interrupts
  56:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Enables IRQ interrupts by clearing the I-bit in the CPSR.
  57:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****            Can only be executed in Privileged modes.
  58:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
  59:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __enable_irq(void)
  60:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
  61:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("cpsie i" : : : "memory");
  62:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
  63:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  64:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  65:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
  66:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Disable IRQ Interrupts
  67:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Disables IRQ interrupts by setting the I-bit in the CPSR.
  68:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   Can only be executed in Privileged modes.
  69:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
  70:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __disable_irq(void)
  71:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
  72:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("cpsid i" : : : "memory");
  73:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
  74:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  75:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  76:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
  77:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get Control Register
  78:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the content of the Control Register.
  79:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               Control Register value
  80:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
  81:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_CONTROL(void)
  82:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
  83:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
  84:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  85:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, control" : "=r" (result) );
  86:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
  87:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
  88:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  89:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
  90:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
  91:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Control Register
  92:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Writes the given value to the Control Register.
  93:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    control  Control Register value to set
  94:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
  95:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_CONTROL(uint32_t control)
  96:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
  97:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR control, %0" : : "r" (control) : "memory");
  98:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
  99:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 100:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 101:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 102:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get IPSR Register
 103:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the content of the IPSR Register.
 104:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               IPSR Register value
 105:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 106:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_IPSR(void)
 107:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 108:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 109:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 110:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, ipsr" : "=r" (result) );
 111:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 112:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 113:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 114:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 115:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 116:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get APSR Register
 117:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the content of the APSR Register.
 118:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               APSR Register value
 119:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 120:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_APSR(void)
 121:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 122:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 123:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 124:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, apsr" : "=r" (result) );
 125:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 126:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 127:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 128:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 129:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 130:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get xPSR Register
 131:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the content of the xPSR Register.
 132:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 133:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****     \return               xPSR Register value
 134:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 135:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_xPSR(void)
 136:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 137:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 138:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 139:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, xpsr" : "=r" (result) );
 140:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 141:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 142:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 143:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 144:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 145:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get Process Stack Pointer
 146:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the current value of the Process Stack Pointer (PSP).
 147:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               PSP Register value
 148:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 149:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_PSP(void)
 150:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 151:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   register uint32_t result;
 152:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 153:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, psp\n"  : "=r" (result) );
 154:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 155:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 156:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 157:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 158:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 159:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Process Stack Pointer
 160:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Process Stack Pointer (PSP).
 161:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    topOfProcStack  Process Stack Pointer value to set
 162:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 163:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_PSP(uint32_t topOfProcStack)
 164:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 165:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR psp, %0\n" : : "r" (topOfProcStack) : "sp");
 166:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 167:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 168:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 169:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 170:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get Main Stack Pointer
 171:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the current value of the Main Stack Pointer (MSP).
 172:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               MSP Register value
 173:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 174:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_MSP(void)
 175:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 176:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   register uint32_t result;
 177:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 178:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, msp\n" : "=r" (result) );
 179:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 180:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 181:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 182:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 183:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 184:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Main Stack Pointer
 185:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Main Stack Pointer (MSP).
 186:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 187:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****     \param [in]    topOfMainStack  Main Stack Pointer value to set
 188:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 189:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_MSP(uint32_t topOfMainStack)
 190:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 191:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR msp, %0\n" : : "r" (topOfMainStack) : "sp");
 192:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 193:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 194:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 195:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 196:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get Priority Mask
 197:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the current state of the priority mask bit from the Priority Mask Register.
 198:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               Priority Mask value
 199:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 200:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_PRIMASK(void)
 201:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 202:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 203:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 204:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, primask" : "=r" (result) );
 205:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 206:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 207:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 208:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 209:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 210:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Priority Mask
 211:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Priority Mask Register.
 212:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    priMask  Priority Mask
 213:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 214:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_PRIMASK(uint32_t priMask)
 215:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 216:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR primask, %0" : : "r" (priMask) : "memory");
 217:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 218:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 219:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 220:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #if       (__CORTEX_M >= 0x03U)
 221:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 222:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 223:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Enable FIQ
 224:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Enables FIQ interrupts by clearing the F-bit in the CPSR.
 225:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****            Can only be executed in Privileged modes.
 226:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 227:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __enable_fault_irq(void)
 228:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 229:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("cpsie f" : : : "memory");
 230:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 231:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 232:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 233:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 234:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Disable FIQ
 235:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Disables FIQ interrupts by setting the F-bit in the CPSR.
 236:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****            Can only be executed in Privileged modes.
 237:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 238:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __disable_fault_irq(void)
 239:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 240:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("cpsid f" : : : "memory");
 241:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 242:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 243:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 244:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 245:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get Base Priority
 246:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the current value of the Base Priority register.
 247:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               Base Priority register value
 248:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 249:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_BASEPRI(void)
 250:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 251:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 252:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 253:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, basepri" : "=r" (result) );
 254:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 255:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 256:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 257:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 258:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 259:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Base Priority
 260:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Base Priority register.
 261:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    basePri  Base Priority value to set
 262:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 263:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_BASEPRI(uint32_t value)
 264:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 265:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR basepri, %0" : : "r" (value) : "memory");
 266:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 267:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 268:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 269:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 270:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Base Priority with condition
 271:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Base Priority register only if BASEPRI masking is disable
 272:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****            or the new value increases the BASEPRI priority level.
 273:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    basePri  Base Priority value to set
 274:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 275:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_BASEPRI_MAX(uint32_t value)
 276:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 277:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR basepri_max, %0" : : "r" (value) : "memory");
 278:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 279:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 280:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 281:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 282:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get Fault Mask
 283:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the current value of the Fault Mask register.
 284:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               Fault Mask register value
 285:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 286:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_FAULTMASK(void)
 287:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 288:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 289:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 290:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MRS %0, faultmask" : "=r" (result) );
 291:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 292:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 293:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 294:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 295:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 296:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set Fault Mask
 297:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Fault Mask register.
 298:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    faultMask  Fault Mask value to set
 299:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 300:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_FAULTMASK(uint32_t faultMask)
 301:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 302:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("MSR faultmask, %0" : : "r" (faultMask) : "memory");
 303:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 304:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 305:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #endif /* (__CORTEX_M >= 0x03U) */
 306:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 307:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 308:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #if       (__CORTEX_M == 0x04U) || (__CORTEX_M == 0x07U)
 309:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 310:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 311:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Get FPSCR
 312:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Returns the current value of the Floating Point Status/Control register.
 313:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \return               Floating Point Status/Control register value
 314:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 315:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_FPSCR(void)
 316:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 317:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #if (__FPU_PRESENT == 1U) && (__FPU_USED == 1U)
 318:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   uint32_t result;
 319:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 320:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   /* Empty asm statement works as a scheduling barrier */
 321:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("");
 322:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("VMRS %0, fpscr" : "=r" (result) );
 323:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("");
 324:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   return(result);
 325:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #else
 326:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****    return(0);
 327:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #endif
 328:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 329:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 330:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 331:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 332:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Set FPSCR
 333:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Assigns the given value to the Floating Point Status/Control register.
 334:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \param [in]    fpscr  Floating Point Status/Control value to set
 335:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 336:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__( ( always_inline ) ) __STATIC_INLINE void __set_FPSCR(uint32_t fpscr)
 337:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 338:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #if (__FPU_PRESENT == 1U) && (__FPU_USED == 1U)
 339:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   /* Empty asm statement works as a scheduling barrier */
 340:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("");
 341:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("VMSR fpscr, %0" : : "r" (fpscr) : "vfpcc");
 342:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("");
 343:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #endif
 344:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 345:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 346:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #endif /* (__CORTEX_M == 0x04U) || (__CORTEX_M == 0x07U) */
 347:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 348:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 349:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 350:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /*@} end of CMSIS_Core_RegAccFunctions */
 351:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 352:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 353:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /* ##########################  Core Instruction Access  ######################### */
 354:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /** \defgroup CMSIS_Core_InstructionInterface CMSIS Core Instruction Interface
 355:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   Access to dedicated instructions
 356:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   @{
 357:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** */
 358:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 359:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /* Define macros for porting to both thumb1 and thumb2.
 360:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  * For thumb1, use low register (r0-r7), specified by constraint "l"
 361:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  * Otherwise, use general registers, specified by constraint "r" */
 362:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #if defined (__thumb__) && !defined (__thumb2__)
 363:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #define __CMSIS_GCC_OUT_REG(r) "=l" (r)
 364:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #define __CMSIS_GCC_USE_REG(r) "l" (r)
 365:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #else
 366:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #define __CMSIS_GCC_OUT_REG(r) "=r" (r)
 367:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #define __CMSIS_GCC_USE_REG(r) "r" (r)
 368:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** #endif
 369:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 370:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 371:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   No Operation
 372:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details No Operation does nothing. This instruction can be used for code alignment purposes.
 373:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 374:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__((always_inline)) __STATIC_INLINE void __NOP(void)
 375:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 376:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("nop");
 377:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** }
 378:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 379:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** 
 380:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** /**
 381:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \brief   Wait For Interrupt
 382:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   \details Wait For Interrupt is a hint instruction that suspends execution until one of a number o
 383:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****  */
 384:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** __attribute__((always_inline)) __STATIC_INLINE void __WFI(void)
 385:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h **** {
 386:/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h ****   __ASM volatile ("wfi");
 1042              		.loc 6 386 0
 1043              	@ 386 "/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h" 1
 1044 0092 30BF     		wfi
 1045              	@ 0 "" 2
 1046              		.thumb
 1047              	.LBE142:
 1048              	.LBE141:
 1049              		.loc 1 424 0
 1050 0094 2368     		ldr	r3, [r4]
 1051 0096 002B     		cmp	r3, #0
 1052 0098 FBD0     		beq	.L49
 1053              	.L48:
 425:spinnaker_src/if_curr_exp.c ****         __WFI();
 426:spinnaker_src/if_curr_exp.c ****     }
 427:spinnaker_src/if_curr_exp.c **** 
 428:spinnaker_src/if_curr_exp.c **** 	log_results();
 1054              		.loc 1 428 0
 1055 009a FFF7FEFF 		bl	log_results
 1056              	.LVL57:
 429:spinnaker_src/if_curr_exp.c **** 
 430:spinnaker_src/if_curr_exp.c ****     *status = IF_CURR_EXP_STATUS_DONE;
 1057              		.loc 1 430 0
 1058 009e 3368     		ldr	r3, [r6]
 1059 00a0 0122     		movs	r2, #1
 1060 00a2 1A60     		str	r2, [r3]
 431:spinnaker_src/if_curr_exp.c **** }
 1061              		.loc 1 431 0
 1062 00a4 0020     		movs	r0, #0
 1063 00a6 BDE8F883 		pop	{r3, r4, r5, r6, r7, r8, r9, pc}
 1064              	.LVL58:
 1065              	.L54:
 1066 00aa 00BF     		.align	2
 1067              	.L53:
 1068 00ac 00000000 		.word	_MYPEID
 1069 00b0 00000000 		.word	_MYCHIPID
 1070 00b4 71D76300 		.word	6543217
 1071 00b8 17D68808 		.word	143185431
 1072 00bc 400010E0 		.word	-535822272
 1073 00c0 00000000 		.word	.LANCHOR3
 1074 00c4 080000E1 		.word	-520093688
 1075 00c8 00000000 		.word	.LANCHOR5
 1076 00cc 00000000 		.word	.LANCHOR6
 1077 00d0 00E100E0 		.word	-536813312
 1078 00d4 29E31A00 		.word	1762089
 1079 00d8 B168DE3A 		.word	987654321
 1080 00dc 00000000 		.word	.LANCHOR13
 1081              		.cfi_endproc
 1082              	.LFE198:
 1084              		.comm	nengo_output_record,4,4
 1085              		.comm	self_spikes,64,4
 1086              		.global	self_spike_counter
 1087              		.global	pe3
 1088              		.global	pe2
 1089              		.global	pe1
 1090              		.global	pe0
 1091              		.comm	pe_id,4,4
 1092              		.comm	pm_levels,4,4
 1093              		.global	systick_callback_priority
 1094              		.global	user_event_priority
 1095              		.global	dma_trasnfer_callback_priority
 1096              		.global	mc_packet_callback_priority
 1097              		.comm	fill_level,4,4
 1098              		.global	systicks
 1099              		.global	n_external_packets_received
 1100              		.global	params_systick
 1101              		.global	duration
 1102              		.global	n_spikes_sent
 1103              		.global	n_packets_received
 1104              		.global	read_pos
 1105              		.comm	packet_buffer,1008,16
 1106              		.comm	API_BURST_FINISHED,1,1
 1107              		.section	.data.params_systick,"aw",%progbits
 1108              		.align	2
 1109              		.set	.LANCHOR6,. + 0
 1112              	params_systick:
 1113 0000 32000000 		.word	50
 1114              		.section	.data.duration,"aw",%progbits
 1115              		.align	2
 1116              		.set	.LANCHOR2,. + 0
 1119              	duration:
 1120 0000 10270000 		.word	10000
 1121              		.section	.bss.self_spike_counter,"aw",%nobits
 1122              		.align	2
 1125              	self_spike_counter:
 1126 0000 00000000 		.space	4
 1127              		.section	.bss.user_event_priority,"aw",%nobits
 1128              		.align	2
 1131              	user_event_priority:
 1132 0000 00000000 		.space	4
 1133              		.section	.bss.n_spikes_sent,"aw",%nobits
 1134              		.align	2
 1135              		.set	.LANCHOR12,. + 0
 1138              	n_spikes_sent:
 1139 0000 00000000 		.space	4
 1140              		.section	.data.pe1,"aw",%progbits
 1141              		.align	2
 1142              		.set	.LANCHOR9,. + 0
 1145              	pe1:
 1146 0000 01000000 		.word	1
 1147              		.section	.data.pe2,"aw",%progbits
 1148              		.align	2
 1149              		.set	.LANCHOR10,. + 0
 1152              	pe2:
 1153 0000 02000000 		.word	2
 1154              		.section	.data.pe3,"aw",%progbits
 1155              		.align	2
 1156              		.set	.LANCHOR8,. + 0
 1159              	pe3:
 1160 0000 03000000 		.word	3
 1161              		.section	.rodata.str1.4,"aMS",%progbits,1
 1162              		.align	2
 1163              	.LC0:
 1164 0000 68656170 		.ascii	"heap base 0x%08x, heap top 0x%08x\012\000"
 1164      20626173 
 1164      65203078 
 1164      25303878 
 1164      2C206865 
 1165 0023 00       		.space	1
 1166              	.LC1:
 1167 0024 65737461 		.ascii	"estack 0x%08x, sidata 0x%08x\012\000"
 1167      636B2030 
 1167      78253038 
 1167      782C2073 
 1167      69646174 
 1168 0042 0000     		.space	2
 1169              	.LC2:
 1170 0044 73646174 		.ascii	"sdata 0x%08x, edata 0x%08x\012\000"
 1170      61203078 
 1170      25303878 
 1170      2C206564 
 1170      61746120 
 1171              	.LC3:
 1172 0060 62737320 		.ascii	"bss start 0x%08x, bss end 0x%08x\012\000"
 1172      73746172 
 1172      74203078 
 1172      25303878 
 1172      2C206273 
 1173 0082 0000     		.space	2
 1174              	.LC4:
 1175 0084 52656365 		.ascii	"Received %u spikes\012\000"
 1175      69766564 
 1175      20257520 
 1175      7370696B 
 1175      65730A00 
 1176              	.LC5:
 1177 0098 52656365 		.ascii	"Received %u unknown keys\012\000"
 1177      69766564 
 1177      20257520 
 1177      756E6B6E 
 1177      6F776E20 
 1178 00b2 0000     		.space	2
 1179              	.LC6:
 1180 00b4 44726F70 		.ascii	"Dropped normal = %d, Dropped DMA = %d\012\000"
 1180      70656420 
 1180      6E6F726D 
 1180      616C203D 
 1180      2025642C 
 1181 00db 00       		.space	1
 1182              	.LC7:
 1183 00dc 53656E74 		.ascii	"Sent %u spikes\012\000"
 1183      20257520 
 1183      7370696B 
 1183      65730A00 
 1184              		.section	.data.systick_callback_priority,"aw",%progbits
 1185              		.align	2
 1188              	systick_callback_priority:
 1189 0000 01000000 		.word	1
 1190              		.section	.bss.time,"aw",%nobits
 1191              		.align	2
 1192              		.set	.LANCHOR13,. + 0
 1195              	time:
 1196 0000 00000000 		.space	4
 1197              		.section	.bss.pe0,"aw",%nobits
 1198              		.align	2
 1199              		.set	.LANCHOR7,. + 0
 1202              	pe0:
 1203 0000 00000000 		.space	4
 1204              		.section	.bss.systicks,"aw",%nobits
 1205              		.align	2
 1206              		.set	.LANCHOR1,. + 0
 1209              	systicks:
 1210 0000 00000000 		.space	4
 1211              		.section	.bss.n_packets_received,"aw",%nobits
 1212              		.align	2
 1213              		.set	.LANCHOR0,. + 0
 1216              	n_packets_received:
 1217 0000 00000000 		.space	4
 1218              		.section	.bss.read_pos,"aw",%nobits
 1219              		.align	2
 1220              		.set	.LANCHOR11,. + 0
 1223              	read_pos:
 1224 0000 00000000 		.space	4
 1225              		.section	.bss.n_external_packets_received,"aw",%nobits
 1226              		.align	2
 1227              		.set	.LANCHOR4,. + 0
 1230              	n_external_packets_received:
 1231 0000 00000000 		.space	4
 1232              		.section	.data.mc_packet_callback_priority,"aw",%progbits
 1233              		.align	2
 1236              	mc_packet_callback_priority:
 1237 0000 FFFFFFFF 		.word	-1
 1238              		.section	.bss.finished,"aw",%nobits
 1239              		.align	2
 1240              		.set	.LANCHOR3,. + 0
 1243              	finished:
 1244 0000 00000000 		.space	4
 1245              		.section	.bss.dma_trasnfer_callback_priority,"aw",%nobits
 1246              		.align	2
 1249              	dma_trasnfer_callback_priority:
 1250 0000 00000000 		.space	4
 1251              		.section	.bss.status,"aw",%nobits
 1252              		.align	2
 1253              		.set	.LANCHOR5,. + 0
 1256              	status:
 1257 0000 00000000 		.space	4
 1258              		.text
 1259              	.Letext0:
 1260              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/device.h"
 1261              		.file 8 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 1262              		.file 9 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 1263              		.file 10 "/home/yexin/projects/JIB1Tests/qpe-common/include/qpe-types.h"
 1264              		.file 11 "spinnaker_src/common/maths-util.h"
 1265              		.file 12 "spinnaker_src/if_curr_exp.h"
 1266              		.file 13 "spinnaker_src/param_defs.h"
 1267              		.file 14 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
 1268              		.file 15 "spinnaker_src/spike_source.h"
 1269              		.file 16 "spinnaker_src/neuron.h"
 1270              		.file 17 "spinnaker_src/synapses.h"
 1271              		.file 18 "spinnaker_src/spinn_log.h"
 1272              		.file 19 "spinnaker_src/spinn_start.h"
