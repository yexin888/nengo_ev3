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
  17              		.file	"spike_processing.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text._setup_synaptic_dma_read,"ax",%progbits
  22              		.align	2
  23              		.global	_setup_synaptic_dma_read
  24              		.thumb
  25              		.thumb_func
  27              	_setup_synaptic_dma_read:
  28              	.LFB187:
  29              		.file 1 "spinnaker_src/spike_processing.c"
   1:spinnaker_src/spike_processing.c **** 
   2:spinnaker_src/spike_processing.c **** #include "qpe.h"
   3:spinnaker_src/spike_processing.c **** #include "spike_processing.h"
   4:spinnaker_src/spike_processing.c **** #include "population_table.h"
   5:spinnaker_src/spike_processing.c **** #include "synapse_row.h"
   6:spinnaker_src/spike_processing.c **** #include "synapses.h"
   7:spinnaker_src/spike_processing.c **** #include "circular_buffer.h"
   8:spinnaker_src/spike_processing.c **** #include "neuron.h"
   9:spinnaker_src/spike_processing.c **** 
  10:spinnaker_src/spike_processing.c **** typedef struct dma_buffer {
  11:spinnaker_src/spike_processing.c ****   address_t sdram_writeback_address;
  12:spinnaker_src/spike_processing.c **** 
  13:spinnaker_src/spike_processing.c ****   spike_t originating_spike;
  14:spinnaker_src/spike_processing.c **** 
  15:spinnaker_src/spike_processing.c ****   uint32_t n_bytes_transferred;
  16:spinnaker_src/spike_processing.c **** 
  17:spinnaker_src/spike_processing.c ****   uint32_t *row;
  18:spinnaker_src/spike_processing.c **** 
  19:spinnaker_src/spike_processing.c **** } dma_buffer;
  20:spinnaker_src/spike_processing.c **** 
  21:spinnaker_src/spike_processing.c **** extern volatile uint32_t systicks;
  22:spinnaker_src/spike_processing.c **** 
  23:spinnaker_src/spike_processing.c **** static bool dma_busy;
  24:spinnaker_src/spike_processing.c **** 
  25:spinnaker_src/spike_processing.c **** static dma_buffer dma_buffers[N_DMA_BUFFERS];
  26:spinnaker_src/spike_processing.c **** 
  27:spinnaker_src/spike_processing.c **** static uint32_t next_buffer_to_fill;
  28:spinnaker_src/spike_processing.c **** 
  29:spinnaker_src/spike_processing.c **** static uint32_t buffer_being_read;
  30:spinnaker_src/spike_processing.c **** 
  31:spinnaker_src/spike_processing.c **** static uint32_t rows[N_DMA_BUFFERS][ROW_MAX_N_WORDS] __attribute__((aligned(0x10)));
  32:spinnaker_src/spike_processing.c **** 
  33:spinnaker_src/spike_processing.c **** extern uint32_t synapse_row_array[SYNAPSE_ROW_ARRAY_MAX_LENGTH];
  34:spinnaker_src/spike_processing.c **** 
  35:spinnaker_src/spike_processing.c **** circular_buffer input_spike_buffer;
  36:spinnaker_src/spike_processing.c **** 
  37:spinnaker_src/spike_processing.c **** uint32_t debug_count3=0;
  38:spinnaker_src/spike_processing.c **** 
  39:spinnaker_src/spike_processing.c **** uint32_t debug_count2=0;
  40:spinnaker_src/spike_processing.c **** 
  41:spinnaker_src/spike_processing.c **** extern uint32_t warnings;
  42:spinnaker_src/spike_processing.c **** 
  43:spinnaker_src/spike_processing.c **** void _setup_synaptic_dma_read() {
  30              		.loc 1 43 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 16
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              	.LVL0:
  35 0000 10B5     		push	{r4, lr}
  36              		.cfi_def_cfa_offset 8
  37              		.cfi_offset 4, -8
  38              		.cfi_offset 14, -4
  39 0002 0F4C     		ldr	r4, .L11
  40 0004 84B0     		sub	sp, sp, #16
  41              		.cfi_def_cfa_offset 24
  42              	.L2:
  44:spinnaker_src/spike_processing.c **** 
  45:spinnaker_src/spike_processing.c ****     spike_t spike;
  46:spinnaker_src/spike_processing.c ****     uint32_t setup_done = false;
  47:spinnaker_src/spike_processing.c ****     while (!setup_done &&  circular_buffer_get_next(input_spike_buffer, &spike)) {
  43              		.loc 1 47 0 discriminator 1
  44 0006 01A9     		add	r1, sp, #4
  45 0008 2068     		ldr	r0, [r4]
  46 000a FFF7FEFF 		bl	circular_buffer_get_next
  47              	.LVL1:
  48              	.LBB4:
  48:spinnaker_src/spike_processing.c ****         address_t row_address;
  49:spinnaker_src/spike_processing.c ****         size_t n_bursts_to_transfer;
  50:spinnaker_src/spike_processing.c **** 
  51:spinnaker_src/spike_processing.c ****         if (population_table_get_address(spike, &row_address,
  49              		.loc 1 51 0 discriminator 1
  50 000e 02A9     		add	r1, sp, #8
  51 0010 03AA     		add	r2, sp, #12
  52              	.LBE4:
  47:spinnaker_src/spike_processing.c ****         address_t row_address;
  53              		.loc 1 47 0 discriminator 1
  54 0012 80B1     		cbz	r0, .L10
  55              	.LBB6:
  56              		.loc 1 51 0
  57 0014 0198     		ldr	r0, [sp, #4]
  58 0016 FFF7FEFF 		bl	population_table_get_address
  59              	.LVL2:
  60 001a 0028     		cmp	r0, #0
  61 001c F3D0     		beq	.L2
  62              	.LVL3:
  63              	.LBB5:
  52:spinnaker_src/spike_processing.c ****                 &n_bursts_to_transfer)) {     
  53:spinnaker_src/spike_processing.c **** 
  54:spinnaker_src/spike_processing.c **** #ifdef USE_DRAM //TODO			
  55:spinnaker_src/spike_processing.c ****             dma_buffer *next_buffer = &dma_buffers[next_buffer_to_fill];
  56:spinnaker_src/spike_processing.c ****             next_buffer->sdram_writeback_address=row_address;
  57:spinnaker_src/spike_processing.c ****             next_buffer->originating_spike=spike;
  58:spinnaker_src/spike_processing.c ****             next_buffer->n_bytes_transferred=n_bursts_to_transfer;
  59:spinnaker_src/spike_processing.c ****             buffer_being_read = next_buffer_to_fill;
  60:spinnaker_src/spike_processing.c **** 	
  61:spinnaker_src/spike_processing.c ****             santos_dma_transfer(DMA_TAG_READ_SYNAPTIC_ROW, row_address,
  62:spinnaker_src/spike_processing.c ****                                next_buffer->row,
  63:spinnaker_src/spike_processing.c ****                                DMA_READ, n_bursts_to_transfer*4);
  64:spinnaker_src/spike_processing.c ****             next_buffer_to_fill = (next_buffer_to_fill + 1) % N_DMA_BUFFERS;
  65:spinnaker_src/spike_processing.c **** #else
  66:spinnaker_src/spike_processing.c **** 			/*
  67:spinnaker_src/spike_processing.c **** 			if(systicks == 2 ){
  68:spinnaker_src/spike_processing.c **** 				log_info("process spike: %#010x\n", spike);
  69:spinnaker_src/spike_processing.c **** 			}
  70:spinnaker_src/spike_processing.c **** 			*/
  71:spinnaker_src/spike_processing.c **** 			synaptic_row_t row;
  72:spinnaker_src/spike_processing.c **** 			row = (synaptic_row_t)&(synapse_row_array[(uint32_t)row_address]);
  73:spinnaker_src/spike_processing.c **** 			synapses_process_synaptic_row(systicks, row, false, 0);
  64              		.loc 1 73 0
  65 001e 094B     		ldr	r3, .L11+4
  72:spinnaker_src/spike_processing.c **** 			synapses_process_synaptic_row(systicks, row, false, 0);
  66              		.loc 1 72 0
  67 0020 0299     		ldr	r1, [sp, #8]
  68              		.loc 1 73 0
  69 0022 1868     		ldr	r0, [r3]
  72:spinnaker_src/spike_processing.c **** 			synapses_process_synaptic_row(systicks, row, false, 0);
  70              		.loc 1 72 0
  71 0024 084B     		ldr	r3, .L11+8
  72              		.loc 1 73 0
  73 0026 0022     		movs	r2, #0
  74 0028 03EB8101 		add	r1, r3, r1, lsl #2
  75 002c 1346     		mov	r3, r2
  76 002e FFF7FEFF 		bl	synapses_process_synaptic_row
  77              	.LVL4:
  78              	.LBE5:
  79              	.LBE6:
  74:spinnaker_src/spike_processing.c **** #endif            
  75:spinnaker_src/spike_processing.c **** 			
  76:spinnaker_src/spike_processing.c **** 			setup_done = true;
  77:spinnaker_src/spike_processing.c ****         }
  78:spinnaker_src/spike_processing.c ****     }
  79:spinnaker_src/spike_processing.c **** 
  80:spinnaker_src/spike_processing.c ****     if (!setup_done) {
  81:spinnaker_src/spike_processing.c ****         dma_busy = false;
  82:spinnaker_src/spike_processing.c ****     }
  83:spinnaker_src/spike_processing.c **** }
  80              		.loc 1 83 0
  81 0032 04B0     		add	sp, sp, #16
  82              		.cfi_remember_state
  83              		.cfi_def_cfa_offset 8
  84              		@ sp needed
  85 0034 10BD     		pop	{r4, pc}
  86              	.LVL5:
  87              	.L10:
  88              		.cfi_restore_state
  81:spinnaker_src/spike_processing.c ****     }
  89              		.loc 1 81 0
  90 0036 054B     		ldr	r3, .L11+12
  91 0038 1870     		strb	r0, [r3]
  92              		.loc 1 83 0
  93 003a 04B0     		add	sp, sp, #16
  94              		.cfi_def_cfa_offset 8
  95              		@ sp needed
  96 003c 10BD     		pop	{r4, pc}
  97              	.L12:
  98 003e 00BF     		.align	2
  99              	.L11:
 100 0040 00000000 		.word	input_spike_buffer
 101 0044 00000000 		.word	systicks
 102 0048 00000000 		.word	synapse_row_array
 103 004c 00000000 		.word	.LANCHOR0
 104              		.cfi_endproc
 105              	.LFE187:
 107              		.section	.text._user_event_callback,"ax",%progbits
 108              		.align	2
 109              		.global	_user_event_callback
 110              		.thumb
 111              		.thumb_func
 113              	_user_event_callback:
 114              	.LFB189:
  84:spinnaker_src/spike_processing.c **** 
  85:spinnaker_src/spike_processing.c **** static inline void _setup_synaptic_dma_write(uint32_t dma_buffer_index)
  86:spinnaker_src/spike_processing.c **** {
  87:spinnaker_src/spike_processing.c ****     /*TODO:
  88:spinnaker_src/spike_processing.c ****     dma_buffer *buffer = &dma_buffers[dma_buffer_index];
  89:spinnaker_src/spike_processing.c **** 
  90:spinnaker_src/spike_processing.c ****     size_t n_plastic_region_bytes =
  91:spinnaker_src/spike_processing.c ****         synapse_row_plastic_size(buffer->row) * sizeof(uint32_t);
  92:spinnaker_src/spike_processing.c ****         */
  93:spinnaker_src/spike_processing.c **** }
  94:spinnaker_src/spike_processing.c **** 
  95:spinnaker_src/spike_processing.c **** 
  96:spinnaker_src/spike_processing.c **** void _user_event_callback(uint32_t unused, uint32_t unused1) {
 115              		.loc 1 96 0
 116              		.cfi_startproc
 117              		@ args = 0, pretend = 0, frame = 0
 118              		@ frame_needed = 0, uses_anonymous_args = 0
 119              		@ link register save eliminated.
 120              	.LVL6:
  97:spinnaker_src/spike_processing.c ****     _setup_synaptic_dma_read();
 121              		.loc 1 97 0
 122 0000 FFF7FEBF 		b	_setup_synaptic_dma_read
 123              	.LVL7:
 124              		.cfi_endproc
 125              	.LFE189:
 127              		.section	.text._multicast_packet_received_callback,"ax",%progbits
 128              		.align	2
 129              		.global	_multicast_packet_received_callback
 130              		.thumb
 131              		.thumb_func
 133              	_multicast_packet_received_callback:
 134              	.LFB190:
  98:spinnaker_src/spike_processing.c **** }
  99:spinnaker_src/spike_processing.c **** 
 100:spinnaker_src/spike_processing.c **** void _multicast_packet_received_callback(uint32_t key, uint32_t unused) {
 135              		.loc 1 100 0
 136              		.cfi_startproc
 137              		@ args = 0, pretend = 0, frame = 0
 138              		@ frame_needed = 0, uses_anonymous_args = 0
 139              	.LVL8:
 140 0000 08B5     		push	{r3, lr}
 141              		.cfi_def_cfa_offset 8
 142              		.cfi_offset 3, -8
 143              		.cfi_offset 14, -4
 101:spinnaker_src/spike_processing.c ****         
 102:spinnaker_src/spike_processing.c **** 	if (circular_buffer_add(input_spike_buffer,key)) {
 144              		.loc 1 102 0
 145 0002 0A4B     		ldr	r3, .L19
 100:spinnaker_src/spike_processing.c ****         
 146              		.loc 1 100 0
 147 0004 0146     		mov	r1, r0
 148              	.LVL9:
 149              		.loc 1 102 0
 150 0006 1868     		ldr	r0, [r3]
 151              	.LVL10:
 152 0008 FFF7FEFF 		bl	circular_buffer_add
 153              	.LVL11:
 154 000c 18B1     		cbz	r0, .L15
 103:spinnaker_src/spike_processing.c **** 
 104:spinnaker_src/spike_processing.c ****         if (!dma_busy) {
 155              		.loc 1 104 0
 156 000e 084B     		ldr	r3, .L19+4
 157 0010 1B78     		ldrb	r3, [r3]	@ zero_extendqisi2
 158 0012 33B1     		cbz	r3, .L18
 159 0014 08BD     		pop	{r3, pc}
 160              	.L15:
 105:spinnaker_src/spike_processing.c **** 			/*
 106:spinnaker_src/spike_processing.c **** 			if(santos_trigger_user_event()){
 107:spinnaker_src/spike_processing.c **** 				dma_busy = true;
 108:spinnaker_src/spike_processing.c **** 			} else {
 109:spinnaker_src/spike_processing.c **** 				warnings |= COULD_NOT_TRIGGER_USER_EVENT;
 110:spinnaker_src/spike_processing.c **** 			}
 111:spinnaker_src/spike_processing.c **** 			*/
 112:spinnaker_src/spike_processing.c **** 			_setup_synaptic_dma_read();
 113:spinnaker_src/spike_processing.c ****        }
 114:spinnaker_src/spike_processing.c **** 	} 
 115:spinnaker_src/spike_processing.c **** 	else {
 116:spinnaker_src/spike_processing.c **** 		warnings |= COULD_NOT_ADD_SPIKE;
 161              		.loc 1 116 0
 162 0016 074A     		ldr	r2, .L19+8
 163 0018 1368     		ldr	r3, [r2]
 164 001a 43F02003 		orr	r3, r3, #32
 165 001e 1360     		str	r3, [r2]
 166 0020 08BD     		pop	{r3, pc}
 167              	.L18:
 117:spinnaker_src/spike_processing.c **** 	}
 118:spinnaker_src/spike_processing.c **** }
 168              		.loc 1 118 0
 169 0022 BDE80840 		pop	{r3, lr}
 170              		.cfi_restore 14
 171              		.cfi_restore 3
 172              		.cfi_def_cfa_offset 0
 112:spinnaker_src/spike_processing.c ****        }
 173              		.loc 1 112 0
 174 0026 FFF7FEBF 		b	_setup_synaptic_dma_read
 175              	.LVL12:
 176              	.L20:
 177 002a 00BF     		.align	2
 178              	.L19:
 179 002c 00000000 		.word	input_spike_buffer
 180 0030 00000000 		.word	.LANCHOR0
 181 0034 00000000 		.word	warnings
 182              		.cfi_endproc
 183              	.LFE190:
 185              		.section	.text._dma_complete_callback,"ax",%progbits
 186              		.align	2
 187              		.global	_dma_complete_callback
 188              		.thumb
 189              		.thumb_func
 191              	_dma_complete_callback:
 192              	.LFB191:
 119:spinnaker_src/spike_processing.c **** 
 120:spinnaker_src/spike_processing.c ****  
 121:spinnaker_src/spike_processing.c **** 
 122:spinnaker_src/spike_processing.c **** 
 123:spinnaker_src/spike_processing.c **** // Called when a DMA completes
 124:spinnaker_src/spike_processing.c **** void _dma_complete_callback(uint32_t tag,uint32_t unused ) {
 193              		.loc 1 124 0
 194              		.cfi_startproc
 195              		@ args = 0, pretend = 0, frame = 0
 196              		@ frame_needed = 0, uses_anonymous_args = 0
 197              	.LVL13:
 125:spinnaker_src/spike_processing.c **** 
 126:spinnaker_src/spike_processing.c ****     // If this DMA is the result of a read
 127:spinnaker_src/spike_processing.c ****     if (tag == DMA_TAG_READ_SYNAPTIC_ROW) {
 198              		.loc 1 127 0
 199 0000 00B1     		cbz	r0, .L28
 200 0002 7047     		bx	lr
 201              	.L28:
 202              	.LBB7:
 128:spinnaker_src/spike_processing.c **** 	 
 129:spinnaker_src/spike_processing.c ****         // Get pointer to current buffer
 130:spinnaker_src/spike_processing.c ****         uint32_t current_buffer_index = buffer_being_read;
 203              		.loc 1 130 0
 204 0004 0E4B     		ldr	r3, .L29
 205              	.LBE7:
 124:spinnaker_src/spike_processing.c **** 
 206              		.loc 1 124 0
 207 0006 2DE9F041 		push	{r4, r5, r6, r7, r8, lr}
 208              		.cfi_def_cfa_offset 24
 209              		.cfi_offset 4, -24
 210              		.cfi_offset 5, -20
 211              		.cfi_offset 6, -16
 212              		.cfi_offset 7, -12
 213              		.cfi_offset 8, -8
 214              		.cfi_offset 14, -4
 215              	.LBB8:
 216              		.loc 1 130 0
 217 000a 1E68     		ldr	r6, [r3]
 218              	.LVL14:
 219 000c 0D4D     		ldr	r5, .L29+4
 220 000e DFF83C80 		ldr	r8, .L29+12
 221 0012 0D4F     		ldr	r7, .L29+8
 131:spinnaker_src/spike_processing.c ****         dma_buffer *current_buffer = &dma_buffers[current_buffer_index];
 132:spinnaker_src/spike_processing.c **** 
 133:spinnaker_src/spike_processing.c ****         // Start the next DMA transfer, so it is complete when we are finished
 134:spinnaker_src/spike_processing.c ****         _setup_synaptic_dma_read();
 222              		.loc 1 134 0
 223 0014 FFF7FEFF 		bl	_setup_synaptic_dma_read
 224              	.LVL15:
 135:spinnaker_src/spike_processing.c ****         // Process synaptic row repeatedly
 136:spinnaker_src/spike_processing.c ****         bool subsequent_spikes;
 137:spinnaker_src/spike_processing.c **** 
 138:spinnaker_src/spike_processing.c ****         do {
 139:spinnaker_src/spike_processing.c **** 
 140:spinnaker_src/spike_processing.c ****             // Are there any more incoming spikes from the same pre-synaptic
 141:spinnaker_src/spike_processing.c ****             // neuron?
 142:spinnaker_src/spike_processing.c ****             subsequent_spikes = circular_buffer_advance_if_next_equals(input_spike_buffer,
 225              		.loc 1 142 0
 226 0018 05EB0615 		add	r5, r5, r6, lsl #4
 227              	.L23:
 228 001c 6968     		ldr	r1, [r5, #4]
 229 001e D8F80000 		ldr	r0, [r8]
 230 0022 FFF7FEFF 		bl	circular_buffer_advance_if_next_equals
 231              	.LVL16:
 232 0026 0446     		mov	r4, r0
 233              	.LVL17:
 143:spinnaker_src/spike_processing.c ****                 current_buffer->originating_spike);
 144:spinnaker_src/spike_processing.c **** 
 145:spinnaker_src/spike_processing.c ****             if (!synapses_process_synaptic_row(systicks, current_buffer->row,
 146:spinnaker_src/spike_processing.c ****                                           !subsequent_spikes,
 147:spinnaker_src/spike_processing.c ****                                           current_buffer_index)) {
 234              		.loc 1 147 0
 235 0028 84F00102 		eor	r2, r4, #1
 145:spinnaker_src/spike_processing.c ****                                           !subsequent_spikes,
 236              		.loc 1 145 0
 237 002c 3868     		ldr	r0, [r7]
 238 002e E968     		ldr	r1, [r5, #12]
 239 0030 D2B2     		uxtb	r2, r2
 240 0032 3346     		mov	r3, r6
 241 0034 FFF7FEFF 		bl	synapses_process_synaptic_row
 242              	.LVL18:
 148:spinnaker_src/spike_processing.c ****             }
 149:spinnaker_src/spike_processing.c ****         } while (subsequent_spikes);
 243              		.loc 1 149 0
 244 0038 002C     		cmp	r4, #0
 245 003a EFD1     		bne	.L23
 246 003c BDE8F081 		pop	{r4, r5, r6, r7, r8, pc}
 247              	.LVL19:
 248              	.L30:
 249              		.align	2
 250              	.L29:
 251 0040 00000000 		.word	.LANCHOR1
 252 0044 00000000 		.word	.LANCHOR2
 253 0048 00000000 		.word	systicks
 254 004c 00000000 		.word	input_spike_buffer
 255              	.LBE8:
 256              		.cfi_endproc
 257              	.LFE191:
 259              		.section	.text.spike_processing_initialise,"ax",%progbits
 260              		.align	2
 261              		.global	spike_processing_initialise
 262              		.thumb
 263              		.thumb_func
 265              	spike_processing_initialise:
 266              	.LFB192:
 150:spinnaker_src/spike_processing.c ****     }
 151:spinnaker_src/spike_processing.c **** }
 152:spinnaker_src/spike_processing.c **** 
 153:spinnaker_src/spike_processing.c **** 
 154:spinnaker_src/spike_processing.c **** 
 155:spinnaker_src/spike_processing.c **** bool spike_processing_initialise(
 156:spinnaker_src/spike_processing.c ****          int mc_packet_callback_priority,
 157:spinnaker_src/spike_processing.c ****         int dma_trasnfer_callback_priority, int user_event_priority
 158:spinnaker_src/spike_processing.c **** ) {
 267              		.loc 1 158 0
 268              		.cfi_startproc
 269              		@ args = 0, pretend = 0, frame = 0
 270              		@ frame_needed = 0, uses_anonymous_args = 0
 271              	.LVL20:
 272 0000 F8B5     		push	{r3, r4, r5, r6, r7, lr}
 273              		.cfi_def_cfa_offset 24
 274              		.cfi_offset 3, -24
 275              		.cfi_offset 4, -20
 276              		.cfi_offset 5, -16
 277              		.cfi_offset 6, -12
 278              		.cfi_offset 7, -8
 279              		.cfi_offset 14, -4
 280              	.LBB9:
 159:spinnaker_src/spike_processing.c **** 
 160:spinnaker_src/spike_processing.c ****     for (uint32_t i = 0; i < N_DMA_BUFFERS; i++){
 161:spinnaker_src/spike_processing.c ****         dma_buffers[i].row = rows[i];
 281              		.loc 1 161 0
 282 0002 0B49     		ldr	r1, .L33
 283              	.LVL21:
 284 0004 0B4B     		ldr	r3, .L33+4
 285 0006 CB60     		str	r3, [r1, #12]
 286              	.LVL22:
 287              	.LBE9:
 162:spinnaker_src/spike_processing.c ****     }
 163:spinnaker_src/spike_processing.c **** 
 164:spinnaker_src/spike_processing.c ****     dma_busy = false;
 288              		.loc 1 164 0
 289 0008 0B4F     		ldr	r7, .L33+8
 165:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 290              		.loc 1 165 0
 291 000a 0C4E     		ldr	r6, .L33+12
 166:spinnaker_src/spike_processing.c ****     buffer_being_read = N_DMA_BUFFERS;
 292              		.loc 1 166 0
 293 000c 0C4C     		ldr	r4, .L33+16
 294              	.LBB10:
 161:spinnaker_src/spike_processing.c ****     }
 295              		.loc 1 161 0
 296 000e 03F58063 		add	r3, r3, #1024
 297              	.LBE10:
 164:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 298              		.loc 1 164 0
 299 0012 0022     		movs	r2, #0
 300              	.LVL23:
 301              	.LBB11:
 161:spinnaker_src/spike_processing.c ****     }
 302              		.loc 1 161 0
 303 0014 CB61     		str	r3, [r1, #28]
 304              	.LVL24:
 305              	.LBE11:
 306              		.loc 1 166 0
 307 0016 0225     		movs	r5, #2
 167:spinnaker_src/spike_processing.c **** 
 168:spinnaker_src/spike_processing.c **** 
 169:spinnaker_src/spike_processing.c ****     input_spike_buffer=circular_buffer_initialize(256);
 308              		.loc 1 169 0
 309 0018 4FF48070 		mov	r0, #256
 310              	.LVL25:
 164:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 311              		.loc 1 164 0
 312 001c 3A70     		strb	r2, [r7]
 165:spinnaker_src/spike_processing.c ****     buffer_being_read = N_DMA_BUFFERS;
 313              		.loc 1 165 0
 314 001e 3260     		str	r2, [r6]
 166:spinnaker_src/spike_processing.c **** 
 315              		.loc 1 166 0
 316 0020 2560     		str	r5, [r4]
 317              		.loc 1 169 0
 318 0022 FFF7FEFF 		bl	circular_buffer_initialize
 319              	.LVL26:
 320 0026 074B     		ldr	r3, .L33+20
 321 0028 1860     		str	r0, [r3]
 170:spinnaker_src/spike_processing.c **** 	/*
 171:spinnaker_src/spike_processing.c ****     santos_callback_on(MC_PACKET_RECEIVED,
 172:spinnaker_src/spike_processing.c ****             _multicast_packet_received_callback, mc_packet_callback_priority);
 173:spinnaker_src/spike_processing.c ****     santos_callback_on(DMA_TRANSFER_DONE, _dma_complete_callback,
 174:spinnaker_src/spike_processing.c ****                       dma_trasnfer_callback_priority);
 175:spinnaker_src/spike_processing.c ****     santos_callback_on(USER_EVENT, _user_event_callback, user_event_priority);
 176:spinnaker_src/spike_processing.c **** 	*/
 177:spinnaker_src/spike_processing.c **** 
 178:spinnaker_src/spike_processing.c ****     return true;
 179:spinnaker_src/spike_processing.c **** }
 322              		.loc 1 179 0
 323 002a 0120     		movs	r0, #1
 324 002c F8BD     		pop	{r3, r4, r5, r6, r7, pc}
 325              	.L34:
 326 002e 00BF     		.align	2
 327              	.L33:
 328 0030 00000000 		.word	.LANCHOR2
 329 0034 00000000 		.word	.LANCHOR3
 330 0038 00000000 		.word	.LANCHOR0
 331 003c 00000000 		.word	.LANCHOR4
 332 0040 00000000 		.word	.LANCHOR1
 333 0044 00000000 		.word	input_spike_buffer
 334              		.cfi_endproc
 335              	.LFE192:
 337              		.section	.text.spike_processing_reset,"ax",%progbits
 338              		.align	2
 339              		.global	spike_processing_reset
 340              		.thumb
 341              		.thumb_func
 343              	spike_processing_reset:
 344              	.LFB193:
 180:spinnaker_src/spike_processing.c **** 
 181:spinnaker_src/spike_processing.c **** void spike_processing_reset(){
 345              		.loc 1 181 0
 346              		.cfi_startproc
 347              		@ args = 0, pretend = 0, frame = 0
 348              		@ frame_needed = 0, uses_anonymous_args = 0
 349              		@ link register save eliminated.
 350 0000 30B4     		push	{r4, r5}
 351              		.cfi_def_cfa_offset 8
 352              		.cfi_offset 4, -8
 353              		.cfi_offset 5, -4
 182:spinnaker_src/spike_processing.c **** 
 183:spinnaker_src/spike_processing.c ****     dma_busy = false;
 184:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 185:spinnaker_src/spike_processing.c ****     buffer_being_read = N_DMA_BUFFERS;
 186:spinnaker_src/spike_processing.c **** 	//debug!
 187:spinnaker_src/spike_processing.c **** 	circular_buffer_clear(input_spike_buffer);
 354              		.loc 1 187 0
 355 0002 064B     		ldr	r3, .L37
 183:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 356              		.loc 1 183 0
 357 0004 064D     		ldr	r5, .L37+4
 184:spinnaker_src/spike_processing.c ****     buffer_being_read = N_DMA_BUFFERS;
 358              		.loc 1 184 0
 359 0006 074C     		ldr	r4, .L37+8
 185:spinnaker_src/spike_processing.c **** 	//debug!
 360              		.loc 1 185 0
 361 0008 074A     		ldr	r2, .L37+12
 362              		.loc 1 187 0
 363 000a 1868     		ldr	r0, [r3]
 183:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 364              		.loc 1 183 0
 365 000c 0023     		movs	r3, #0
 185:spinnaker_src/spike_processing.c **** 	//debug!
 366              		.loc 1 185 0
 367 000e 0221     		movs	r1, #2
 183:spinnaker_src/spike_processing.c ****     next_buffer_to_fill = 0;
 368              		.loc 1 183 0
 369 0010 2B70     		strb	r3, [r5]
 184:spinnaker_src/spike_processing.c ****     buffer_being_read = N_DMA_BUFFERS;
 370              		.loc 1 184 0
 371 0012 2360     		str	r3, [r4]
 188:spinnaker_src/spike_processing.c **** }
 372              		.loc 1 188 0
 373 0014 30BC     		pop	{r4, r5}
 374              		.cfi_restore 5
 375              		.cfi_restore 4
 376              		.cfi_def_cfa_offset 0
 185:spinnaker_src/spike_processing.c **** 	//debug!
 377              		.loc 1 185 0
 378 0016 1160     		str	r1, [r2]
 187:spinnaker_src/spike_processing.c **** }
 379              		.loc 1 187 0
 380 0018 FFF7FEBF 		b	circular_buffer_clear
 381              	.LVL27:
 382              	.L38:
 383              		.align	2
 384              	.L37:
 385 001c 00000000 		.word	input_spike_buffer
 386 0020 00000000 		.word	.LANCHOR0
 387 0024 00000000 		.word	.LANCHOR4
 388 0028 00000000 		.word	.LANCHOR1
 389              		.cfi_endproc
 390              	.LFE193:
 392              		.section	.text.spike_processing_print_buffer_overflows,"ax",%progbits
 393              		.align	2
 394              		.global	spike_processing_print_buffer_overflows
 395              		.thumb
 396              		.thumb_func
 398              	spike_processing_print_buffer_overflows:
 399              	.LFB194:
 189:spinnaker_src/spike_processing.c **** 
 190:spinnaker_src/spike_processing.c **** 
 191:spinnaker_src/spike_processing.c **** void spike_processing_print_buffer_overflows(){
 400              		.loc 1 191 0
 401              		.cfi_startproc
 402              		@ args = 0, pretend = 0, frame = 0
 403              		@ frame_needed = 0, uses_anonymous_args = 0
 404 0000 08B5     		push	{r3, lr}
 405              		.cfi_def_cfa_offset 8
 406              		.cfi_offset 3, -8
 407              		.cfi_offset 14, -4
 192:spinnaker_src/spike_processing.c **** 
 193:spinnaker_src/spike_processing.c **** 	uint32_t spike_buffer_overflows = circular_buffer_get_n_buffer_overflows(input_spike_buffer);
 408              		.loc 1 193 0
 409 0002 054B     		ldr	r3, .L45
 410 0004 1868     		ldr	r0, [r3]
 411 0006 FFF7FEFF 		bl	circular_buffer_get_n_buffer_overflows
 412              	.LVL28:
 194:spinnaker_src/spike_processing.c **** 	if (spike_buffer_overflows > 0){
 413              		.loc 1 194 0
 414 000a 20B1     		cbz	r0, .L39
 195:spinnaker_src/spike_processing.c **** 	
 196:spinnaker_src/spike_processing.c **** 		warnings |= SPIKE_BUFFER_OVERFLOW;
 415              		.loc 1 196 0
 416 000c 034A     		ldr	r2, .L45+4
 417 000e 1368     		ldr	r3, [r2]
 418 0010 43F08003 		orr	r3, r3, #128
 419 0014 1360     		str	r3, [r2]
 420              	.L39:
 421 0016 08BD     		pop	{r3, pc}
 422              	.L46:
 423              		.align	2
 424              	.L45:
 425 0018 00000000 		.word	input_spike_buffer
 426 001c 00000000 		.word	warnings
 427              		.cfi_endproc
 428              	.LFE194:
 430              		.section	.text.spike_processing_finish_write,"ax",%progbits
 431              		.align	2
 432              		.global	spike_processing_finish_write
 433              		.thumb
 434              		.thumb_func
 436              	spike_processing_finish_write:
 437              	.LFB195:
 197:spinnaker_src/spike_processing.c **** 	}
 198:spinnaker_src/spike_processing.c **** }
 199:spinnaker_src/spike_processing.c **** 
 200:spinnaker_src/spike_processing.c **** void spike_processing_finish_write(uint32_t process_id) {
 438              		.loc 1 200 0
 439              		.cfi_startproc
 440              		@ args = 0, pretend = 0, frame = 0
 441              		@ frame_needed = 0, uses_anonymous_args = 0
 442              		@ link register save eliminated.
 443              	.LVL29:
 444 0000 7047     		bx	lr
 445              		.cfi_endproc
 446              	.LFE195:
 448              		.global	debug_count2
 449              		.global	debug_count3
 450              		.comm	input_spike_buffer,4,4
 451              		.comm	API_BURST_FINISHED,1,1
 452 0002 00BF     		.section	.bss.dma_busy,"aw",%nobits
 453              		.set	.LANCHOR0,. + 0
 456              	dma_busy:
 457 0000 00       		.space	1
 458              		.section	.bss.dma_buffers,"aw",%nobits
 459              		.align	2
 460              		.set	.LANCHOR2,. + 0
 463              	dma_buffers:
 464 0000 00000000 		.space	32
 464      00000000 
 464      00000000 
 464      00000000 
 464      00000000 
 465              		.section	.bss.rows,"aw",%nobits
 466              		.align	4
 467              		.set	.LANCHOR3,. + 0
 470              	rows:
 471 0000 00000000 		.space	2048
 471      00000000 
 471      00000000 
 471      00000000 
 471      00000000 
 472              		.section	.bss.buffer_being_read,"aw",%nobits
 473              		.align	2
 474              		.set	.LANCHOR1,. + 0
 477              	buffer_being_read:
 478 0000 00000000 		.space	4
 479              		.section	.bss.next_buffer_to_fill,"aw",%nobits
 480              		.align	2
 481              		.set	.LANCHOR4,. + 0
 484              	next_buffer_to_fill:
 485 0000 00000000 		.space	4
 486              		.section	.bss.debug_count2,"aw",%nobits
 487              		.align	2
 490              	debug_count2:
 491 0000 00000000 		.space	4
 492              		.section	.bss.debug_count3,"aw",%nobits
 493              		.align	2
 496              	debug_count3:
 497 0000 00000000 		.space	4
 498              		.text
 499              	.Letext0:
 500              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 501              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 502              		.file 4 "/usr/lib/gcc/arm-none-eabi/4.9.3/include/stddef.h"
 503              		.file 5 "spinnaker_src/common/../common-typedefs.h"
 504              		.file 6 "spinnaker_src/common/neuron-typedefs.h"
 505              		.file 7 "spinnaker_src/circular_buffer.h"
 506              		.file 8 "spinnaker_src/param_defs.h"
 507              		.file 9 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 508              		.file 10 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 509              		.file 11 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
 510              		.file 12 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
 511              		.file 13 "spinnaker_src/synapses.h"
 512              		.file 14 "spinnaker_src/population_table.h"
