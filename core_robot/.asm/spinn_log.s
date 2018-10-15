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
  17              		.file	"spinn_log.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.write_full.part.0,"ax",%progbits
  22              		.align	2
  23              		.thumb
  24              		.thumb_func
  26              	write_full.part.0:
  27              	.LFB4:
  28              		.file 1 "spinnaker_src/spinn_log.c"
   1:spinnaker_src/spinn_log.c **** #include <printf.h>
   2:spinnaker_src/spinn_log.c **** #include <stdbool.h>
   3:spinnaker_src/spinn_log.c **** 
   4:spinnaker_src/spinn_log.c **** volatile uint32_t *_debug_count;
   5:spinnaker_src/spinn_log.c **** static uint32_t _size;
   6:spinnaker_src/spinn_log.c **** static uint32_t _max_size;
   7:spinnaker_src/spinn_log.c **** static volatile char* _debug;
   8:spinnaker_src/spinn_log.c **** static bool overrun = false;
   9:spinnaker_src/spinn_log.c **** static bool initialised = false;
  10:spinnaker_src/spinn_log.c **** 
  11:spinnaker_src/spinn_log.c **** static uint32_t _strlen(volatile char *str) {
  12:spinnaker_src/spinn_log.c ****     uint32_t len;
  13:spinnaker_src/spinn_log.c ****     for (len = 0; str[len]; len++);
  14:spinnaker_src/spinn_log.c ****     return len;
  15:spinnaker_src/spinn_log.c **** }
  16:spinnaker_src/spinn_log.c **** 
  17:spinnaker_src/spinn_log.c **** static void write_full() {
  29              		.loc 1 17 0
  30              		.cfi_startproc
  31              		@ args = 0, pretend = 0, frame = 0
  32              		@ frame_needed = 0, uses_anonymous_args = 0
  33 0000 F0B5     		push	{r4, r5, r6, r7, lr}
  34              		.cfi_def_cfa_offset 20
  35              		.cfi_offset 4, -20
  36              		.cfi_offset 5, -16
  37              		.cfi_offset 6, -12
  38              		.cfi_offset 7, -8
  39              		.cfi_offset 14, -4
  18:spinnaker_src/spinn_log.c ****     if (!overrun) {
  19:spinnaker_src/spinn_log.c ****         _debug[0] = '\n';
  40              		.loc 1 19 0
  41 0002 124D     		ldr	r5, .L3
  20:spinnaker_src/spinn_log.c ****         _debug[1] = 'F';
  21:spinnaker_src/spinn_log.c ****         _debug[2] = 'U';
  22:spinnaker_src/spinn_log.c ****         _debug[3] = 'L';
  23:spinnaker_src/spinn_log.c ****         _debug[4] = 'L';
  24:spinnaker_src/spinn_log.c ****         _debug[5] = '!';
  25:spinnaker_src/spinn_log.c ****         _debug[6] = '\0';
  26:spinnaker_src/spinn_log.c ****         _debug += 7;
  27:spinnaker_src/spinn_log.c ****         _size += 7;
  28:spinnaker_src/spinn_log.c ****         *_debug_count += 7;
  42              		.loc 1 28 0
  43 0004 124C     		ldr	r4, .L3+4
  19:spinnaker_src/spinn_log.c ****         _debug[1] = 'F';
  44              		.loc 1 19 0
  45 0006 2B68     		ldr	r3, [r5]
  27:spinnaker_src/spinn_log.c ****         *_debug_count += 7;
  46              		.loc 1 27 0
  47 0008 1248     		ldr	r0, .L3+8
  29:spinnaker_src/spinn_log.c ****         overrun = true;
  48              		.loc 1 29 0
  49 000a 134E     		ldr	r6, .L3+12
  27:spinnaker_src/spinn_log.c ****         *_debug_count += 7;
  50              		.loc 1 27 0
  51 000c 0268     		ldr	r2, [r0]
  22:spinnaker_src/spinn_log.c ****         _debug[4] = 'L';
  52              		.loc 1 22 0
  53 000e 4C21     		movs	r1, #76
  20:spinnaker_src/spinn_log.c ****         _debug[2] = 'U';
  54              		.loc 1 20 0
  55 0010 4FF0460E 		mov	lr, #70
  21:spinnaker_src/spinn_log.c ****         _debug[3] = 'L';
  56              		.loc 1 21 0
  57 0014 5527     		movs	r7, #85
  19:spinnaker_src/spinn_log.c ****         _debug[1] = 'F';
  58              		.loc 1 19 0
  59 0016 4FF00A0C 		mov	ip, #10
  60 001a 83F800C0 		strb	ip, [r3]
  20:spinnaker_src/spinn_log.c ****         _debug[2] = 'U';
  61              		.loc 1 20 0
  62 001e 83F801E0 		strb	lr, [r3, #1]
  21:spinnaker_src/spinn_log.c ****         _debug[3] = 'L';
  63              		.loc 1 21 0
  64 0022 9F70     		strb	r7, [r3, #2]
  22:spinnaker_src/spinn_log.c ****         _debug[4] = 'L';
  65              		.loc 1 22 0
  66 0024 D970     		strb	r1, [r3, #3]
  25:spinnaker_src/spinn_log.c ****         _debug += 7;
  67              		.loc 1 25 0
  68 0026 0027     		movs	r7, #0
  28:spinnaker_src/spinn_log.c ****         overrun = true;
  69              		.loc 1 28 0
  70 0028 2468     		ldr	r4, [r4]
  23:spinnaker_src/spinn_log.c ****         _debug[5] = '!';
  71              		.loc 1 23 0
  72 002a 1971     		strb	r1, [r3, #4]
  24:spinnaker_src/spinn_log.c ****         _debug[6] = '\0';
  73              		.loc 1 24 0
  74 002c 4FF0210E 		mov	lr, #33
  75 0030 83F805E0 		strb	lr, [r3, #5]
  25:spinnaker_src/spinn_log.c ****         _debug += 7;
  76              		.loc 1 25 0
  77 0034 9F71     		strb	r7, [r3, #6]
  28:spinnaker_src/spinn_log.c ****         overrun = true;
  78              		.loc 1 28 0
  79 0036 2168     		ldr	r1, [r4]
  26:spinnaker_src/spinn_log.c ****         _size += 7;
  80              		.loc 1 26 0
  81 0038 0733     		adds	r3, r3, #7
  28:spinnaker_src/spinn_log.c ****         overrun = true;
  82              		.loc 1 28 0
  83 003a 0731     		adds	r1, r1, #7
  27:spinnaker_src/spinn_log.c ****         *_debug_count += 7;
  84              		.loc 1 27 0
  85 003c 0732     		adds	r2, r2, #7
  86              		.loc 1 29 0
  87 003e 0127     		movs	r7, #1
  26:spinnaker_src/spinn_log.c ****         _size += 7;
  88              		.loc 1 26 0
  89 0040 2B60     		str	r3, [r5]
  28:spinnaker_src/spinn_log.c ****         overrun = true;
  90              		.loc 1 28 0
  91 0042 2160     		str	r1, [r4]
  27:spinnaker_src/spinn_log.c ****         *_debug_count += 7;
  92              		.loc 1 27 0
  93 0044 0260     		str	r2, [r0]
  94              		.loc 1 29 0
  95 0046 3770     		strb	r7, [r6]
  96 0048 F0BD     		pop	{r4, r5, r6, r7, pc}
  97              	.L4:
  98 004a 00BF     		.align	2
  99              	.L3:
 100 004c 00000000 		.word	.LANCHOR0
 101 0050 00000000 		.word	_debug_count
 102 0054 00000000 		.word	.LANCHOR1
 103 0058 00000000 		.word	.LANCHOR2
 104              		.cfi_endproc
 105              	.LFE4:
 107              		.section	.text.log_info,"ax",%progbits
 108              		.align	2
 109              		.global	log_info
 110              		.thumb
 111              		.thumb_func
 113              	log_info:
 114              	.LFB2:
  30:spinnaker_src/spinn_log.c ****     }
  31:spinnaker_src/spinn_log.c **** }
  32:spinnaker_src/spinn_log.c **** 
  33:spinnaker_src/spinn_log.c **** void log_info(char* fmt, ...) {
 115              		.loc 1 33 0
 116              		.cfi_startproc
 117              		@ args = 4, pretend = 16, frame = 8
 118              		@ frame_needed = 0, uses_anonymous_args = 1
 119              	.LVL0:
 120 0000 0FB4     		push	{r0, r1, r2, r3}
 121              		.cfi_def_cfa_offset 16
 122              		.cfi_offset 0, -16
 123              		.cfi_offset 1, -12
 124              		.cfi_offset 2, -8
 125              		.cfi_offset 3, -4
 126 0002 F0B5     		push	{r4, r5, r6, r7, lr}
 127              		.cfi_def_cfa_offset 36
 128              		.cfi_offset 4, -36
 129              		.cfi_offset 5, -32
 130              		.cfi_offset 6, -28
 131              		.cfi_offset 7, -24
 132              		.cfi_offset 14, -20
  34:spinnaker_src/spinn_log.c ****     if (!initialised) {
 133              		.loc 1 34 0
 134 0004 1F4B     		ldr	r3, .L22
 135 0006 1B78     		ldrb	r3, [r3]	@ zero_extendqisi2
  33:spinnaker_src/spinn_log.c ****     if (!initialised) {
 136              		.loc 1 33 0
 137 0008 83B0     		sub	sp, sp, #12
 138              		.cfi_def_cfa_offset 48
 139              		.loc 1 34 0
 140 000a 4BB1     		cbz	r3, .L5
  35:spinnaker_src/spinn_log.c ****         return;
  36:spinnaker_src/spinn_log.c ****     }
  37:spinnaker_src/spinn_log.c ****     if (_size < (_max_size - 8)) {
 141              		.loc 1 37 0
 142 000c 1E4B     		ldr	r3, .L22+4
 143 000e 1F4D     		ldr	r5, .L22+8
 144 0010 1A68     		ldr	r2, [r3]
 145 0012 2968     		ldr	r1, [r5]
 146 0014 083A     		subs	r2, r2, #8
 147 0016 8A42     		cmp	r2, r1
 148 0018 0ED8     		bhi	.L20
 149              	.LBB9:
 150              	.LBB10:
  18:spinnaker_src/spinn_log.c ****         _debug[0] = '\n';
 151              		.loc 1 18 0
 152 001a 1D4B     		ldr	r3, .L22+12
 153 001c 1B78     		ldrb	r3, [r3]	@ zero_extendqisi2
 154 001e 23B1     		cbz	r3, .L21
 155              	.L5:
 156              	.LBE10:
 157              	.LBE9:
  38:spinnaker_src/spinn_log.c ****         va_list va;
  39:spinnaker_src/spinn_log.c ****         va_start(va, fmt);
  40:spinnaker_src/spinn_log.c ****         int chars = tfp_vsnprintf(
  41:spinnaker_src/spinn_log.c ****             (char *) _debug, ((_max_size - _size) - 8), fmt, va);
  42:spinnaker_src/spinn_log.c ****         va_end(va);
  43:spinnaker_src/spinn_log.c ****         uint32_t len = _strlen(_debug);
  44:spinnaker_src/spinn_log.c ****         *_debug_count += len;
  45:spinnaker_src/spinn_log.c ****         _debug += len;
  46:spinnaker_src/spinn_log.c ****         _size += len;
  47:spinnaker_src/spinn_log.c **** 
  48:spinnaker_src/spinn_log.c ****         if (chars > len) {
  49:spinnaker_src/spinn_log.c ****             write_full();
  50:spinnaker_src/spinn_log.c ****         }
  51:spinnaker_src/spinn_log.c ****     } else {
  52:spinnaker_src/spinn_log.c ****         write_full();
  53:spinnaker_src/spinn_log.c ****     }
  54:spinnaker_src/spinn_log.c **** }
 158              		.loc 1 54 0
 159 0020 03B0     		add	sp, sp, #12
 160              		.cfi_remember_state
 161              		.cfi_def_cfa_offset 36
 162              		@ sp needed
 163 0022 BDE8F040 		pop	{r4, r5, r6, r7, lr}
 164              		.cfi_restore 14
 165              		.cfi_restore 7
 166              		.cfi_restore 6
 167              		.cfi_restore 5
 168              		.cfi_restore 4
 169              		.cfi_def_cfa_offset 16
 170 0026 04B0     		add	sp, sp, #16
 171              		.cfi_restore 3
 172              		.cfi_restore 2
 173              		.cfi_restore 1
 174              		.cfi_restore 0
 175              		.cfi_def_cfa_offset 0
 176 0028 7047     		bx	lr
 177              	.L21:
 178              		.cfi_restore_state
 179              	.LBB13:
 180              	.LBB11:
 181 002a FFF7FEFF 		bl	write_full.part.0
 182              	.LVL1:
 183              	.LBE11:
 184              	.LBE13:
 185 002e 03B0     		add	sp, sp, #12
 186              		.cfi_remember_state
 187              		.cfi_def_cfa_offset 36
 188              		@ sp needed
 189 0030 BDE8F040 		pop	{r4, r5, r6, r7, lr}
 190              		.cfi_restore 4
 191              		.cfi_restore 5
 192              		.cfi_restore 6
 193              		.cfi_restore 7
 194              		.cfi_restore 14
 195              		.cfi_def_cfa_offset 16
 196 0034 04B0     		add	sp, sp, #16
 197              		.cfi_restore 0
 198              		.cfi_restore 1
 199              		.cfi_restore 2
 200              		.cfi_restore 3
 201              		.cfi_def_cfa_offset 0
 202 0036 7047     		bx	lr
 203              	.L20:
 204              		.cfi_restore_state
 205              	.LBB14:
  40:spinnaker_src/spinn_log.c ****             (char *) _debug, ((_max_size - _size) - 8), fmt, va);
 206              		.loc 1 40 0
 207 0038 164E     		ldr	r6, .L22+16
  39:spinnaker_src/spinn_log.c ****         int chars = tfp_vsnprintf(
 208              		.loc 1 39 0
 209 003a 09AB     		add	r3, sp, #36
  40:spinnaker_src/spinn_log.c ****             (char *) _debug, ((_max_size - _size) - 8), fmt, va);
 210              		.loc 1 40 0
 211 003c 511A     		subs	r1, r2, r1
 212 003e 3068     		ldr	r0, [r6]
 213 0040 089A     		ldr	r2, [sp, #32]
  39:spinnaker_src/spinn_log.c ****         int chars = tfp_vsnprintf(
 214              		.loc 1 39 0
 215 0042 0193     		str	r3, [sp, #4]
  40:spinnaker_src/spinn_log.c ****             (char *) _debug, ((_max_size - _size) - 8), fmt, va);
 216              		.loc 1 40 0
 217 0044 FFF7FEFF 		bl	tfp_vsnprintf
 218              	.LVL2:
  43:spinnaker_src/spinn_log.c ****         *_debug_count += len;
 219              		.loc 1 43 0
 220 0048 3268     		ldr	r2, [r6]
 221              	.LVL3:
 222              	.LBB15:
 223              	.LBB16:
  13:spinnaker_src/spinn_log.c ****     return len;
 224              		.loc 1 13 0
 225 004a 1178     		ldrb	r1, [r2]	@ zero_extendqisi2
 226 004c 01F0FF03 		and	r3, r1, #255
 227 0050 A9B1     		cbz	r1, .L11
 228 0052 0023     		movs	r3, #0
 229              	.LVL4:
 230              	.L9:
 231 0054 0133     		adds	r3, r3, #1
 232              	.LVL5:
 233 0056 D418     		adds	r4, r2, r3
 234 0058 D15C     		ldrb	r1, [r2, r3]	@ zero_extendqisi2
 235 005a 0029     		cmp	r1, #0
 236 005c FAD1     		bne	.L9
 237              	.LVL6:
 238              	.L8:
 239              	.LBE16:
 240              	.LBE15:
  44:spinnaker_src/spinn_log.c ****         _debug += len;
 241              		.loc 1 44 0
 242 005e 0E49     		ldr	r1, .L22+20
  46:spinnaker_src/spinn_log.c **** 
 243              		.loc 1 46 0
 244 0060 2A68     		ldr	r2, [r5]
 245              	.LVL7:
  44:spinnaker_src/spinn_log.c ****         _debug += len;
 246              		.loc 1 44 0
 247 0062 0F68     		ldr	r7, [r1]
  45:spinnaker_src/spinn_log.c ****         _size += len;
 248              		.loc 1 45 0
 249 0064 3460     		str	r4, [r6]
  44:spinnaker_src/spinn_log.c ****         _debug += len;
 250              		.loc 1 44 0
 251 0066 3968     		ldr	r1, [r7]
  46:spinnaker_src/spinn_log.c **** 
 252              		.loc 1 46 0
 253 0068 1A44     		add	r2, r2, r3
  44:spinnaker_src/spinn_log.c ****         _debug += len;
 254              		.loc 1 44 0
 255 006a 1944     		add	r1, r1, r3
  48:spinnaker_src/spinn_log.c ****             write_full();
 256              		.loc 1 48 0
 257 006c 8342     		cmp	r3, r0
  44:spinnaker_src/spinn_log.c ****         _debug += len;
 258              		.loc 1 44 0
 259 006e 3960     		str	r1, [r7]
  46:spinnaker_src/spinn_log.c **** 
 260              		.loc 1 46 0
 261 0070 2A60     		str	r2, [r5]
  48:spinnaker_src/spinn_log.c ****             write_full();
 262              		.loc 1 48 0
 263 0072 D5D2     		bcs	.L5
 264              	.LBE14:
 265              	.LBB19:
 266              	.LBB12:
  18:spinnaker_src/spinn_log.c ****         _debug[0] = '\n';
 267              		.loc 1 18 0
 268 0074 064B     		ldr	r3, .L22+12
 269 0076 1B78     		ldrb	r3, [r3]	@ zero_extendqisi2
 270 0078 002B     		cmp	r3, #0
 271 007a D1D1     		bne	.L5
 272 007c D5E7     		b	.L21
 273              	.LVL8:
 274              	.L11:
 275              	.LBE12:
 276              	.LBE19:
 277              	.LBB20:
 278              	.LBB18:
 279              	.LBB17:
  13:spinnaker_src/spinn_log.c ****     return len;
 280              		.loc 1 13 0
 281 007e 1446     		mov	r4, r2
 282 0080 EDE7     		b	.L8
 283              	.L23:
 284 0082 00BF     		.align	2
 285              	.L22:
 286 0084 00000000 		.word	.LANCHOR3
 287 0088 00000000 		.word	.LANCHOR4
 288 008c 00000000 		.word	.LANCHOR1
 289 0090 00000000 		.word	.LANCHOR2
 290 0094 00000000 		.word	.LANCHOR0
 291 0098 00000000 		.word	_debug_count
 292              	.LBE17:
 293              	.LBE18:
 294              	.LBE20:
 295              		.cfi_endproc
 296              	.LFE2:
 298              		.section	.text.log_init,"ax",%progbits
 299              		.align	2
 300              		.global	log_init
 301              		.thumb
 302              		.thumb_func
 304              	log_init:
 305              	.LFB3:
  55:spinnaker_src/spinn_log.c **** 
  56:spinnaker_src/spinn_log.c **** void log_init(volatile uint32_t *base_address, uint32_t size) {
 306              		.loc 1 56 0
 307              		.cfi_startproc
 308              		@ args = 0, pretend = 0, frame = 0
 309              		@ frame_needed = 0, uses_anonymous_args = 0
 310              		@ link register save eliminated.
 311              	.LVL9:
 312 0000 10B4     		push	{r4}
 313              		.cfi_def_cfa_offset 4
 314              		.cfi_offset 4, -4
  57:spinnaker_src/spinn_log.c ****     _debug_count = &(base_address[0]);
  58:spinnaker_src/spinn_log.c ****     _debug = (volatile char *) &(base_address[1]);
 315              		.loc 1 58 0
 316 0002 0D4A     		ldr	r2, .L30
  57:spinnaker_src/spinn_log.c ****     _debug_count = &(base_address[0]);
 317              		.loc 1 57 0
 318 0004 0D4C     		ldr	r4, .L30+4
 319              		.loc 1 58 0
 320 0006 031D     		adds	r3, r0, #4
 321 0008 1360     		str	r3, [r2]
 322              	.LVL10:
  57:spinnaker_src/spinn_log.c ****     _debug_count = &(base_address[0]);
 323              		.loc 1 57 0
 324 000a 2060     		str	r0, [r4]
 325              	.LBB21:
  59:spinnaker_src/spinn_log.c ****     for (uint32_t i = 0; i < size; i++) {
 326              		.loc 1 59 0
 327 000c 39B1     		cbz	r1, .L25
 328 000e 0A1D     		adds	r2, r1, #4
 329 0010 1044     		add	r0, r0, r2
 330              	.LVL11:
  60:spinnaker_src/spinn_log.c ****         _debug[i] = '\0';
 331              		.loc 1 60 0
 332 0012 0022     		movs	r2, #0
 333              	.LVL12:
 334              	.L26:
 335              		.loc 1 60 0 is_stmt 0 discriminator 3
 336 0014 03F8012B 		strb	r2, [r3], #1
 337              	.LVL13:
  59:spinnaker_src/spinn_log.c ****     for (uint32_t i = 0; i < size; i++) {
 338              		.loc 1 59 0 is_stmt 1 discriminator 3
 339 0018 8342     		cmp	r3, r0
 340 001a FBD1     		bne	.L26
 341 001c 2068     		ldr	r0, [r4]
 342              	.LVL14:
 343              	.L25:
 344              	.LBE21:
  61:spinnaker_src/spinn_log.c ****     }
  62:spinnaker_src/spinn_log.c ****     *_debug_count = 1;
  63:spinnaker_src/spinn_log.c ****     _max_size = size;
 345              		.loc 1 63 0
 346 001e 084B     		ldr	r3, .L30+8
  64:spinnaker_src/spinn_log.c ****     _size = 0;
 347              		.loc 1 64 0
 348 0020 084C     		ldr	r4, .L30+12
  65:spinnaker_src/spinn_log.c ****     initialised = true;
 349              		.loc 1 65 0
 350 0022 094A     		ldr	r2, .L30+16
  63:spinnaker_src/spinn_log.c ****     _size = 0;
 351              		.loc 1 63 0
 352 0024 1960     		str	r1, [r3]
  62:spinnaker_src/spinn_log.c ****     _max_size = size;
 353              		.loc 1 62 0
 354 0026 0123     		movs	r3, #1
  64:spinnaker_src/spinn_log.c ****     initialised = true;
 355              		.loc 1 64 0
 356 0028 0021     		movs	r1, #0
 357              	.LVL15:
 358 002a 2160     		str	r1, [r4]
 359              		.loc 1 65 0
 360 002c 1370     		strb	r3, [r2]
  62:spinnaker_src/spinn_log.c ****     _max_size = size;
 361              		.loc 1 62 0
 362 002e 0360     		str	r3, [r0]
  66:spinnaker_src/spinn_log.c **** }
 363              		.loc 1 66 0
 364 0030 5DF8044B 		ldr	r4, [sp], #4
 365              		.cfi_restore 4
 366              		.cfi_def_cfa_offset 0
 367 0034 7047     		bx	lr
 368              	.L31:
 369 0036 00BF     		.align	2
 370              	.L30:
 371 0038 00000000 		.word	.LANCHOR0
 372 003c 00000000 		.word	_debug_count
 373 0040 00000000 		.word	.LANCHOR4
 374 0044 00000000 		.word	.LANCHOR1
 375 0048 00000000 		.word	.LANCHOR3
 376              		.cfi_endproc
 377              	.LFE3:
 379              		.comm	_debug_count,4,4
 380              		.section	.bss._debug,"aw",%nobits
 381              		.align	2
 382              		.set	.LANCHOR0,. + 0
 385              	_debug:
 386 0000 00000000 		.space	4
 387              		.section	.bss.overrun,"aw",%nobits
 388              		.set	.LANCHOR2,. + 0
 391              	overrun:
 392 0000 00       		.space	1
 393              		.section	.bss._size,"aw",%nobits
 394              		.align	2
 395              		.set	.LANCHOR1,. + 0
 398              	_size:
 399 0000 00000000 		.space	4
 400              		.section	.bss._max_size,"aw",%nobits
 401              		.align	2
 402              		.set	.LANCHOR4,. + 0
 405              	_max_size:
 406 0000 00000000 		.space	4
 407              		.section	.bss.initialised,"aw",%nobits
 408              		.set	.LANCHOR3,. + 0
 411              	initialised:
 412 0000 00       		.space	1
 413              		.text
 414              	.Letext0:
 415              		.file 2 "/usr/lib/gcc/arm-none-eabi/4.9.3/include/stdarg.h"
 416              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 417              		.file 4 "/usr/lib/gcc/arm-none-eabi/4.9.3/include/stddef.h"
 418              		.file 5 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 419              		.file 6 "<built-in>"
 420              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/printf.h"
