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
  17              		.file	"circular_buffer.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.circular_buffer_initialize,"ax",%progbits
  22              		.align	2
  23              		.global	circular_buffer_initialize
  24              		.thumb
  25              		.thumb_func
  27              	circular_buffer_initialize:
  28              	.LFB161:
  29              		.file 1 "spinnaker_src/circular_buffer.c"
   1:spinnaker_src/circular_buffer.c **** #include "circular_buffer.h"
   2:spinnaker_src/circular_buffer.c **** extern volatile uint32_t systicks; 
   3:spinnaker_src/circular_buffer.c **** uint32_t debug_count20 =0;
   4:spinnaker_src/circular_buffer.c **** //#include <debug.h>
   5:spinnaker_src/circular_buffer.c **** 
   6:spinnaker_src/circular_buffer.c **** typedef struct _circular_buffer {
   7:spinnaker_src/circular_buffer.c ****     uint32_t* buffer;
   8:spinnaker_src/circular_buffer.c ****     uint32_t buffer_size;
   9:spinnaker_src/circular_buffer.c ****     uint32_t output;
  10:spinnaker_src/circular_buffer.c ****     uint32_t input;
  11:spinnaker_src/circular_buffer.c ****     uint32_t overflows;
  12:spinnaker_src/circular_buffer.c **** } _circular_buffer;
  13:spinnaker_src/circular_buffer.c **** 
  14:spinnaker_src/circular_buffer.c **** // Returns the next highest power of 2 of a value
  15:spinnaker_src/circular_buffer.c **** static inline uint32_t _next_power_of_two(uint32_t v) {
  16:spinnaker_src/circular_buffer.c ****     return 1 << (32 - __builtin_clz(v));
  17:spinnaker_src/circular_buffer.c **** }
  18:spinnaker_src/circular_buffer.c **** 
  19:spinnaker_src/circular_buffer.c **** // Returns True if the value is a power of 2
  20:spinnaker_src/circular_buffer.c **** static inline bool _is_power_of_2(uint32_t v) {
  21:spinnaker_src/circular_buffer.c ****     return (v & (v - 1)) == 0;
  22:spinnaker_src/circular_buffer.c **** }
  23:spinnaker_src/circular_buffer.c **** 
  24:spinnaker_src/circular_buffer.c **** // Returns the index of the next position in the buffer from the given value
  25:spinnaker_src/circular_buffer.c **** static inline uint32_t _circular_buffer_next(
  26:spinnaker_src/circular_buffer.c ****         circular_buffer buffer, uint32_t current) {
  27:spinnaker_src/circular_buffer.c ****     return (current + 1) & buffer->buffer_size;
  28:spinnaker_src/circular_buffer.c **** }
  29:spinnaker_src/circular_buffer.c **** 
  30:spinnaker_src/circular_buffer.c **** // Returns true if the buffer is not empty
  31:spinnaker_src/circular_buffer.c **** static inline bool _circular_buffer_not_empty(circular_buffer buffer) {
  32:spinnaker_src/circular_buffer.c ****     return buffer->input != buffer->output;
  33:spinnaker_src/circular_buffer.c **** }
  34:spinnaker_src/circular_buffer.c **** 
  35:spinnaker_src/circular_buffer.c **** // Returns true if the buffer is not full
  36:spinnaker_src/circular_buffer.c **** static inline bool _circular_buffer_not_full(circular_buffer buffer) {
  37:spinnaker_src/circular_buffer.c ****     return ((buffer->input + 1) & buffer->buffer_size) != buffer->output;
  38:spinnaker_src/circular_buffer.c **** }
  39:spinnaker_src/circular_buffer.c **** 
  40:spinnaker_src/circular_buffer.c **** //debug!
  41:spinnaker_src/circular_buffer.c **** //for pm paper
  42:spinnaker_src/circular_buffer.c **** 
  43:spinnaker_src/circular_buffer.c **** circular_buffer buffer;
  44:spinnaker_src/circular_buffer.c **** uint32_t _buffer[CIRCULAR_BUFFER_SIZE];
  45:spinnaker_src/circular_buffer.c **** 
  46:spinnaker_src/circular_buffer.c **** 
  47:spinnaker_src/circular_buffer.c **** circular_buffer circular_buffer_initialize(uint32_t size) {
  30              		.loc 1 47 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  35              	.LVL0:
  36              	.LBB18:
  37              	.LBB19:
  21:spinnaker_src/circular_buffer.c **** }
  38              		.loc 1 21 0
  39 0000 431E     		subs	r3, r0, #1
  40              	.LBE19:
  41              	.LBE18:
  48:spinnaker_src/circular_buffer.c ****     uint32_t real_size = size;
  49:spinnaker_src/circular_buffer.c ****     if (!_is_power_of_2(real_size)) {
  42              		.loc 1 49 0
  43 0002 0342     		tst	r3, r0
  44 0004 06D0     		beq	.L2
  45              	.LVL1:
  46              	.LBB20:
  47              	.LBB21:
  16:spinnaker_src/circular_buffer.c **** }
  48              		.loc 1 16 0
  49 0006 B0FA80F0 		clz	r0, r0
  50              	.LVL2:
  51 000a 0123     		movs	r3, #1
  52              	.LVL3:
  53 000c C0F12000 		rsb	r0, r0, #32
  54 0010 8340     		lsls	r3, r3, r0
  55 0012 013B     		subs	r3, r3, #1
  56              	.LVL4:
  57              	.L2:
  58              	.LBE21:
  59              	.LBE20:
  50:spinnaker_src/circular_buffer.c ****         real_size = _next_power_of_two(size);
  51:spinnaker_src/circular_buffer.c **** 		/*
  52:spinnaker_src/circular_buffer.c ****         log_warning(
  53:spinnaker_src/circular_buffer.c ****             "Requested size of %u was rounded up to %u", size, real_size - 1);
  54:spinnaker_src/circular_buffer.c **** 		*/
  55:spinnaker_src/circular_buffer.c ****     }
  56:spinnaker_src/circular_buffer.c **** 	//debug!
  57:spinnaker_src/circular_buffer.c ****     //circular_buffer buffer =(circular_buffer) sark_alloc(1 * sizeof(struct _circular_buffer));
  58:spinnaker_src/circular_buffer.c ****     //if (buffer == NULL) {
  59:spinnaker_src/circular_buffer.c **** 		/*
  60:spinnaker_src/circular_buffer.c ****         log_error("Cannot allocate space for buffer structure");
  61:spinnaker_src/circular_buffer.c **** 		*/
  62:spinnaker_src/circular_buffer.c ****         //return NULL;
  63:spinnaker_src/circular_buffer.c ****     //}
  64:spinnaker_src/circular_buffer.c **** 	//debug!
  65:spinnaker_src/circular_buffer.c ****     //buffer->buffer = (uint32_t *) sark_alloc(1 * real_size * sizeof(uint32_t));
  66:spinnaker_src/circular_buffer.c **** 	buffer->buffer = _buffer;
  60              		.loc 1 66 0
  61 0014 044A     		ldr	r2, .L7
  62 0016 0549     		ldr	r1, .L7+4
  63 0018 1068     		ldr	r0, [r2]
  67:spinnaker_src/circular_buffer.c ****     if (buffer->buffer == NULL) {
  68:spinnaker_src/circular_buffer.c **** 		/*
  69:spinnaker_src/circular_buffer.c ****         log_error("Cannot allocate space for buffer in circular buffer");
  70:spinnaker_src/circular_buffer.c **** 		*/
  71:spinnaker_src/circular_buffer.c ****         return NULL;
  72:spinnaker_src/circular_buffer.c ****     }
  73:spinnaker_src/circular_buffer.c **** 	/*
  74:spinnaker_src/circular_buffer.c **** 	if( getMyModID()==6  ){
  75:spinnaker_src/circular_buffer.c **** 		set_gp_reg(17,0xa);
  76:spinnaker_src/circular_buffer.c **** 	}
  77:spinnaker_src/circular_buffer.c **** 	*/
  78:spinnaker_src/circular_buffer.c ****     buffer->buffer_size = real_size - 1;
  79:spinnaker_src/circular_buffer.c ****     buffer->input = 0;
  64              		.loc 1 79 0
  65 001a 0022     		movs	r2, #0
  66:spinnaker_src/circular_buffer.c ****     if (buffer->buffer == NULL) {
  66              		.loc 1 66 0
  67 001c 80E80A00 		stmia	r0, {r1, r3}
  68              		.loc 1 79 0
  69 0020 C260     		str	r2, [r0, #12]
  80:spinnaker_src/circular_buffer.c ****     buffer->output = 0;
  70              		.loc 1 80 0
  71 0022 8260     		str	r2, [r0, #8]
  81:spinnaker_src/circular_buffer.c ****     buffer->overflows = 0;
  72              		.loc 1 81 0
  73 0024 0261     		str	r2, [r0, #16]
  82:spinnaker_src/circular_buffer.c **** 	/*
  83:spinnaker_src/circular_buffer.c **** 	if( getMyModID()==6  ){
  84:spinnaker_src/circular_buffer.c **** 	
  85:spinnaker_src/circular_buffer.c **** 		set_gp_reg(14,buffer->input);
  86:spinnaker_src/circular_buffer.c **** 		set_gp_reg(15,buffer->output);
  87:spinnaker_src/circular_buffer.c **** 	}
  88:spinnaker_src/circular_buffer.c **** 	*/
  89:spinnaker_src/circular_buffer.c ****     return buffer;
  90:spinnaker_src/circular_buffer.c **** }
  74              		.loc 1 90 0
  75 0026 7047     		bx	lr
  76              	.L8:
  77              		.align	2
  78              	.L7:
  79 0028 00000000 		.word	buffer
  80 002c 00000000 		.word	_buffer
  81              		.cfi_endproc
  82              	.LFE161:
  84              		.section	.text.circular_buffer_add,"ax",%progbits
  85              		.align	2
  86              		.global	circular_buffer_add
  87              		.thumb
  88              		.thumb_func
  90              	circular_buffer_add:
  91              	.LFB162:
  91:spinnaker_src/circular_buffer.c **** 
  92:spinnaker_src/circular_buffer.c **** bool circular_buffer_add(circular_buffer buffer, uint32_t item) {
  92              		.loc 1 92 0
  93              		.cfi_startproc
  94              		@ args = 0, pretend = 0, frame = 0
  95              		@ frame_needed = 0, uses_anonymous_args = 0
  96              		@ link register save eliminated.
  97              	.LVL5:
  98 0000 30B4     		push	{r4, r5}
  99              		.cfi_def_cfa_offset 8
 100              		.cfi_offset 4, -8
 101              		.cfi_offset 5, -4
 102              	.LBB22:
 103              	.LBB23:
  37:spinnaker_src/circular_buffer.c **** }
 104              		.loc 1 37 0
 105 0002 C468     		ldr	r4, [r0, #12]
 106 0004 4268     		ldr	r2, [r0, #4]
 107 0006 8568     		ldr	r5, [r0, #8]
 108 0008 631C     		adds	r3, r4, #1
 109 000a 1A40     		ands	r2, r2, r3
 110 000c 531B     		subs	r3, r2, r5
 111 000e 18BF     		it	ne
 112 0010 0123     		movne	r3, #1
 113              	.LBE23:
 114              	.LBE22:
  93:spinnaker_src/circular_buffer.c **** /*	
  94:spinnaker_src/circular_buffer.c **** 	if( getMyModID()==6 && debug_count20!=1 ){
  95:spinnaker_src/circular_buffer.c **** 	
  96:spinnaker_src/circular_buffer.c **** 		set_gp_reg(11,buffer->input);
  97:spinnaker_src/circular_buffer.c **** 		set_gp_reg(12,buffer->output);
  98:spinnaker_src/circular_buffer.c **** 		debug_count20=1;
  99:spinnaker_src/circular_buffer.c **** 	}
 100:spinnaker_src/circular_buffer.c **** */	
 101:spinnaker_src/circular_buffer.c ****     bool success = _circular_buffer_not_full(buffer);
 102:spinnaker_src/circular_buffer.c **** 
 103:spinnaker_src/circular_buffer.c ****     if (success) {
 115              		.loc 1 103 0
 116 0012 2BB9     		cbnz	r3, .L13
 104:spinnaker_src/circular_buffer.c ****         buffer->buffer[buffer->input] = item;
 105:spinnaker_src/circular_buffer.c ****         buffer->input = _circular_buffer_next(buffer, buffer->input);
 106:spinnaker_src/circular_buffer.c ****     } else {
 107:spinnaker_src/circular_buffer.c ****         buffer->overflows++;
 117              		.loc 1 107 0
 118 0014 0269     		ldr	r2, [r0, #16]
 119 0016 0132     		adds	r2, r2, #1
 120 0018 0261     		str	r2, [r0, #16]
 108:spinnaker_src/circular_buffer.c ****     }
 109:spinnaker_src/circular_buffer.c **** 
 110:spinnaker_src/circular_buffer.c ****     return success;
 111:spinnaker_src/circular_buffer.c **** }
 121              		.loc 1 111 0
 122 001a 30BC     		pop	{r4, r5}
 123              		.cfi_remember_state
 124              		.cfi_restore 5
 125              		.cfi_restore 4
 126              		.cfi_def_cfa_offset 0
 127 001c 1846     		mov	r0, r3
 128              	.LVL6:
 129 001e 7047     		bx	lr
 130              	.LVL7:
 131              	.L13:
 132              		.cfi_restore_state
 104:spinnaker_src/circular_buffer.c ****         buffer->buffer[buffer->input] = item;
 133              		.loc 1 104 0
 134 0020 0268     		ldr	r2, [r0]
 135 0022 42F82410 		str	r1, [r2, r4, lsl #2]
 136              	.LVL8:
 137              	.LBB24:
 138              	.LBB25:
  27:spinnaker_src/circular_buffer.c **** }
 139              		.loc 1 27 0
 140 0026 C268     		ldr	r2, [r0, #12]
 141 0028 4168     		ldr	r1, [r0, #4]
 142              	.LVL9:
 143 002a 0132     		adds	r2, r2, #1
 144 002c 0A40     		ands	r2, r2, r1
 145              	.LBE25:
 146              	.LBE24:
 105:spinnaker_src/circular_buffer.c ****     } else {
 147              		.loc 1 105 0
 148 002e C260     		str	r2, [r0, #12]
 149              	.LVL10:
 150              		.loc 1 111 0
 151 0030 30BC     		pop	{r4, r5}
 152              		.cfi_restore 4
 153              		.cfi_restore 5
 154              		.cfi_def_cfa_offset 0
 155 0032 1846     		mov	r0, r3
 156              	.LVL11:
 157 0034 7047     		bx	lr
 158              		.cfi_endproc
 159              	.LFE162:
 161 0036 00BF     		.section	.text.circular_buffer_get_next,"ax",%progbits
 162              		.align	2
 163              		.global	circular_buffer_get_next
 164              		.thumb
 165              		.thumb_func
 167              	circular_buffer_get_next:
 168              	.LFB163:
 112:spinnaker_src/circular_buffer.c **** 
 113:spinnaker_src/circular_buffer.c **** bool circular_buffer_get_next(circular_buffer buffer, uint32_t* item) {
 169              		.loc 1 113 0
 170              		.cfi_startproc
 171              		@ args = 0, pretend = 0, frame = 0
 172              		@ frame_needed = 0, uses_anonymous_args = 0
 173              		@ link register save eliminated.
 174 0000 8268     		ldr	r2, [r0, #8]
 175 0002 0346     		mov	r3, r0
 176              	.LBB26:
 177              	.LBB27:
  32:spinnaker_src/circular_buffer.c **** }
 178              		.loc 1 32 0
 179 0004 C068     		ldr	r0, [r0, #12]
 180 0006 101A     		subs	r0, r2, r0
 181 0008 18BF     		it	ne
 182 000a 0120     		movne	r0, #1
 183              	.LBE27:
 184              	.LBE26:
 114:spinnaker_src/circular_buffer.c ****     bool success = _circular_buffer_not_empty(buffer);
 115:spinnaker_src/circular_buffer.c **** 
 116:spinnaker_src/circular_buffer.c ****     if (success) {
 185              		.loc 1 116 0
 186 000c 58B1     		cbz	r0, .L21
 113:spinnaker_src/circular_buffer.c ****     bool success = _circular_buffer_not_empty(buffer);
 187              		.loc 1 113 0
 188 000e 10B4     		push	{r4}
 189              		.cfi_def_cfa_offset 4
 190              		.cfi_offset 4, -4
 117:spinnaker_src/circular_buffer.c ****         *item = buffer->buffer[buffer->output];
 191              		.loc 1 117 0
 192 0010 1C68     		ldr	r4, [r3]
 193 0012 54F82220 		ldr	r2, [r4, r2, lsl #2]
 194 0016 0A60     		str	r2, [r1]
 195              	.LBB28:
 196              	.LBB29:
  27:spinnaker_src/circular_buffer.c **** }
 197              		.loc 1 27 0
 198 0018 9A68     		ldr	r2, [r3, #8]
 199 001a 5968     		ldr	r1, [r3, #4]
 200              	.LBE29:
 201              	.LBE28:
 118:spinnaker_src/circular_buffer.c ****         buffer->output = _circular_buffer_next(buffer, buffer->output);
 119:spinnaker_src/circular_buffer.c ****     }
 120:spinnaker_src/circular_buffer.c **** 
 121:spinnaker_src/circular_buffer.c ****     return success;
 122:spinnaker_src/circular_buffer.c **** }
 202              		.loc 1 122 0
 203 001c 5DF8044B 		ldr	r4, [sp], #4
 204              		.cfi_restore 4
 205              		.cfi_def_cfa_offset 0
 206              	.LBB31:
 207              	.LBB30:
  27:spinnaker_src/circular_buffer.c **** }
 208              		.loc 1 27 0
 209 0020 0132     		adds	r2, r2, #1
 210 0022 0A40     		ands	r2, r2, r1
 211              	.LBE30:
 212              	.LBE31:
 118:spinnaker_src/circular_buffer.c ****         buffer->output = _circular_buffer_next(buffer, buffer->output);
 213              		.loc 1 118 0
 214 0024 9A60     		str	r2, [r3, #8]
 215              	.L21:
 216              		.loc 1 122 0
 217 0026 7047     		bx	lr
 218              		.cfi_endproc
 219              	.LFE163:
 221              		.section	.text.circular_buffer_advance_if_next_equals,"ax",%progbits
 222              		.align	2
 223              		.global	circular_buffer_advance_if_next_equals
 224              		.thumb
 225              		.thumb_func
 227              	circular_buffer_advance_if_next_equals:
 228              	.LFB164:
 123:spinnaker_src/circular_buffer.c **** 
 124:spinnaker_src/circular_buffer.c **** bool circular_buffer_advance_if_next_equals(
 125:spinnaker_src/circular_buffer.c ****         circular_buffer buffer, uint32_t item) {
 229              		.loc 1 125 0
 230              		.cfi_startproc
 231              		@ args = 0, pretend = 0, frame = 0
 232              		@ frame_needed = 0, uses_anonymous_args = 0
 233              		@ link register save eliminated.
 234              	.LVL12:
 235 0000 8368     		ldr	r3, [r0, #8]
 236              	.LVL13:
 126:spinnaker_src/circular_buffer.c ****     bool success = _circular_buffer_not_empty(buffer);
 127:spinnaker_src/circular_buffer.c ****     if (success) {
 237              		.loc 1 127 0
 238 0002 C268     		ldr	r2, [r0, #12]
 239 0004 9342     		cmp	r3, r2
 240 0006 0AD0     		beq	.L25
 241              	.LVL14:
 128:spinnaker_src/circular_buffer.c ****         success = (buffer->buffer[buffer->output] == item);
 242              		.loc 1 128 0
 243 0008 0268     		ldr	r2, [r0]
 129:spinnaker_src/circular_buffer.c ****         if (success) {
 244              		.loc 1 129 0
 245 000a 52F82320 		ldr	r2, [r2, r3, lsl #2]
 246 000e 8A42     		cmp	r2, r1
 247 0010 05D1     		bne	.L25
 248              	.LVL15:
 249              	.LBB32:
 250              	.LBB33:
  27:spinnaker_src/circular_buffer.c **** }
 251              		.loc 1 27 0
 252 0012 4268     		ldr	r2, [r0, #4]
 253 0014 0133     		adds	r3, r3, #1
 254              	.LVL16:
 255 0016 1340     		ands	r3, r3, r2
 256              	.LBE33:
 257              	.LBE32:
 130:spinnaker_src/circular_buffer.c ****             buffer->output = _circular_buffer_next(buffer, buffer->output);
 258              		.loc 1 130 0
 259 0018 8360     		str	r3, [r0, #8]
 260              	.LVL17:
 261 001a 0120     		movs	r0, #1
 262              	.LVL18:
 263 001c 7047     		bx	lr
 264              	.LVL19:
 265              	.L25:
 266 001e 0020     		movs	r0, #0
 267              	.LVL20:
 131:spinnaker_src/circular_buffer.c ****         }
 132:spinnaker_src/circular_buffer.c ****     }
 133:spinnaker_src/circular_buffer.c ****     return success;
 134:spinnaker_src/circular_buffer.c **** }
 268              		.loc 1 134 0
 269 0020 7047     		bx	lr
 270              		.cfi_endproc
 271              	.LFE164:
 273 0022 00BF     		.section	.text.circular_buffer_size,"ax",%progbits
 274              		.align	2
 275              		.global	circular_buffer_size
 276              		.thumb
 277              		.thumb_func
 279              	circular_buffer_size:
 280              	.LFB165:
 135:spinnaker_src/circular_buffer.c **** 
 136:spinnaker_src/circular_buffer.c **** uint32_t circular_buffer_size(circular_buffer buffer) {
 281              		.loc 1 136 0
 282              		.cfi_startproc
 283              		@ args = 0, pretend = 0, frame = 0
 284              		@ frame_needed = 0, uses_anonymous_args = 0
 285              		@ link register save eliminated.
 286              	.LVL21:
 137:spinnaker_src/circular_buffer.c ****     return buffer->input >= buffer->output?
 287              		.loc 1 137 0
 288 0000 C168     		ldr	r1, [r0, #12]
 289 0002 8368     		ldr	r3, [r0, #8]
 138:spinnaker_src/circular_buffer.c ****         buffer->input - buffer->output:
 290              		.loc 1 138 0
 291 0004 9942     		cmp	r1, r3
 292 0006 04D2     		bcs	.L29
 139:spinnaker_src/circular_buffer.c ****         (buffer->input + buffer->buffer_size + 1) - buffer->output;
 293              		.loc 1 139 0 discriminator 2
 294 0008 4268     		ldr	r2, [r0, #4]
 295 000a 8818     		adds	r0, r1, r2
 296              	.LVL22:
 297 000c 0130     		adds	r0, r0, #1
 138:spinnaker_src/circular_buffer.c ****         buffer->input - buffer->output:
 298              		.loc 1 138 0 discriminator 2
 299 000e C01A     		subs	r0, r0, r3
 140:spinnaker_src/circular_buffer.c **** }
 300              		.loc 1 140 0 discriminator 2
 301 0010 7047     		bx	lr
 302              	.LVL23:
 303              	.L29:
 138:spinnaker_src/circular_buffer.c ****         buffer->input - buffer->output:
 304              		.loc 1 138 0 discriminator 1
 305 0012 C81A     		subs	r0, r1, r3
 306              	.LVL24:
 307 0014 7047     		bx	lr
 308              		.cfi_endproc
 309              	.LFE165:
 311 0016 00BF     		.section	.text.circular_buffer_get_n_buffer_overflows,"ax",%progbits
 312              		.align	2
 313              		.global	circular_buffer_get_n_buffer_overflows
 314              		.thumb
 315              		.thumb_func
 317              	circular_buffer_get_n_buffer_overflows:
 318              	.LFB166:
 141:spinnaker_src/circular_buffer.c **** 
 142:spinnaker_src/circular_buffer.c **** uint32_t circular_buffer_get_n_buffer_overflows(circular_buffer buffer) {
 319              		.loc 1 142 0
 320              		.cfi_startproc
 321              		@ args = 0, pretend = 0, frame = 0
 322              		@ frame_needed = 0, uses_anonymous_args = 0
 323              		@ link register save eliminated.
 324              	.LVL25:
 143:spinnaker_src/circular_buffer.c ****     return buffer->overflows;
 144:spinnaker_src/circular_buffer.c **** }
 325              		.loc 1 144 0
 326 0000 0069     		ldr	r0, [r0, #16]
 327              	.LVL26:
 328 0002 7047     		bx	lr
 329              		.cfi_endproc
 330              	.LFE166:
 332              		.section	.text.circular_buffer_clear,"ax",%progbits
 333              		.align	2
 334              		.global	circular_buffer_clear
 335              		.thumb
 336              		.thumb_func
 338              	circular_buffer_clear:
 339              	.LFB167:
 145:spinnaker_src/circular_buffer.c **** 
 146:spinnaker_src/circular_buffer.c **** void circular_buffer_clear(circular_buffer buffer) {
 340              		.loc 1 146 0
 341              		.cfi_startproc
 342              		@ args = 0, pretend = 0, frame = 0
 343              		@ frame_needed = 0, uses_anonymous_args = 0
 344              		@ link register save eliminated.
 345              	.LVL27:
 147:spinnaker_src/circular_buffer.c ****     buffer->input = 0;
 346              		.loc 1 147 0
 347 0000 0023     		movs	r3, #0
 348 0002 C360     		str	r3, [r0, #12]
 148:spinnaker_src/circular_buffer.c ****     buffer->output = 0;
 349              		.loc 1 148 0
 350 0004 8360     		str	r3, [r0, #8]
 149:spinnaker_src/circular_buffer.c ****     buffer->overflows = 0;
 351              		.loc 1 149 0
 352 0006 0361     		str	r3, [r0, #16]
 353 0008 7047     		bx	lr
 354              		.cfi_endproc
 355              	.LFE167:
 357              		.comm	_buffer,1024,4
 358              		.comm	buffer,4,4
 359              		.global	debug_count20
 360              		.comm	API_BURST_FINISHED,1,1
 361 000a 00BF     		.section	.bss.debug_count20,"aw",%nobits
 362              		.align	2
 365              	debug_count20:
 366 0000 00000000 		.space	4
 367              		.text
 368              	.Letext0:
 369              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 370              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 371              		.file 4 "spinnaker_src/circular_buffer.h"
 372              		.file 5 "spinnaker_src/param_defs.h"
 373              		.file 6 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
 374              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 375              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 376              		.file 9 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
