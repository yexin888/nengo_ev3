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
  17              		.file	"population_table_binary_search_impl.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.population_table_initialise,"ax",%progbits
  22              		.align	2
  23              		.global	population_table_initialise
  24              		.thumb
  25              		.thumb_func
  27              	population_table_initialise:
  28              	.LFB170:
  29              		.file 1 "spinnaker_src/population_table_binary_search_impl.c"
   1:spinnaker_src/population_table_binary_search_impl.c **** #include "population_table.h"
   2:spinnaker_src/population_table_binary_search_impl.c **** #include "synapse_row.h"
   3:spinnaker_src/population_table_binary_search_impl.c **** 
   4:spinnaker_src/population_table_binary_search_impl.c **** extern population_table_info pop_table_info[N_CORES];
   5:spinnaker_src/population_table_binary_search_impl.c **** extern master_population_table_entry master_population_table[MASTER_TABLE_LENGTH] ;
   6:spinnaker_src/population_table_binary_search_impl.c **** 
   7:spinnaker_src/population_table_binary_search_impl.c **** static uint32_t master_population_table_length;
   8:spinnaker_src/population_table_binary_search_impl.c **** 
   9:spinnaker_src/population_table_binary_search_impl.c **** static inline uint32_t _get_address(master_population_table_entry entry) {
  10:spinnaker_src/population_table_binary_search_impl.c **** 
  11:spinnaker_src/population_table_binary_search_impl.c ****     // The address is in words and is the top 24-bits, so this downshifts by
  12:spinnaker_src/population_table_binary_search_impl.c ****     // 8 and then multiplies by 4 (= upshifts by 2) = downshift by 6
  13:spinnaker_src/population_table_binary_search_impl.c ****     return entry.address_and_row_length >> 8;
  14:spinnaker_src/population_table_binary_search_impl.c **** }
  15:spinnaker_src/population_table_binary_search_impl.c **** 
  16:spinnaker_src/population_table_binary_search_impl.c **** static inline uint32_t _get_row_length(master_population_table_entry entry) {
  17:spinnaker_src/population_table_binary_search_impl.c ****     return entry.address_and_row_length & 0xFF;
  18:spinnaker_src/population_table_binary_search_impl.c **** }
  19:spinnaker_src/population_table_binary_search_impl.c **** 
  20:spinnaker_src/population_table_binary_search_impl.c **** /*
  21:spinnaker_src/population_table_binary_search_impl.c **** static inline uint32_t _get_neuron_id(master_population_table_entry entry,
  22:spinnaker_src/population_table_binary_search_impl.c ****                                       spike_t spike) {
  23:spinnaker_src/population_table_binary_search_impl.c ****     return spike & ~entry.mask;
  24:spinnaker_src/population_table_binary_search_impl.c **** }
  25:spinnaker_src/population_table_binary_search_impl.c **** */
  26:spinnaker_src/population_table_binary_search_impl.c **** 
  27:spinnaker_src/population_table_binary_search_impl.c **** bool population_table_initialise( ) {
  30              		.loc 1 27 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  35              	.LBB9:
  36              	.LBB10:
  37              		.file 2 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
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
  38              		.loc 2 37 0
  39 0000 4FF06243 		mov	r3, #-503316480
  40              	.LBE10:
  41              	.LBE9:
  28:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t core_id=_getMyPEID()&0x3; 
  29:spinnaker_src/population_table_binary_search_impl.c ****     master_population_table_length = pop_table_info[core_id].length;
  42              		.loc 1 29 0
  43 0004 054A     		ldr	r2, .L2
  44              	.LBB12:
  45              	.LBB11:
  46              		.loc 2 37 0
  47 0006 D3F8F830 		ldr	r3, [r3, #248]
  48              	.LVL0:
  49              	.LBE11:
  50              	.LBE12:
  51              		.loc 1 29 0
  52 000a 0549     		ldr	r1, .L2+4
  28:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t core_id=_getMyPEID()&0x3; 
  53              		.loc 1 28 0
  54 000c 03F00303 		and	r3, r3, #3
  55              	.LVL1:
  56              		.loc 1 29 0
  57 0010 02EBC303 		add	r3, r2, r3, lsl #3
  30:spinnaker_src/population_table_binary_search_impl.c ****     return true;
  31:spinnaker_src/population_table_binary_search_impl.c **** }
  58              		.loc 1 31 0
  59 0014 0120     		movs	r0, #1
  29:spinnaker_src/population_table_binary_search_impl.c ****     return true;
  60              		.loc 1 29 0
  61 0016 5B68     		ldr	r3, [r3, #4]
  62 0018 0B60     		str	r3, [r1]
  63              		.loc 1 31 0
  64 001a 7047     		bx	lr
  65              	.L3:
  66              		.align	2
  67              	.L2:
  68 001c 00000000 		.word	pop_table_info
  69 0020 00000000 		.word	.LANCHOR0
  70              		.cfi_endproc
  71              	.LFE170:
  73              		.section	.text.population_table_get_address,"ax",%progbits
  74              		.align	2
  75              		.global	population_table_get_address
  76              		.thumb
  77              		.thumb_func
  79              	population_table_get_address:
  80              	.LFB171:
  32:spinnaker_src/population_table_binary_search_impl.c **** 
  33:spinnaker_src/population_table_binary_search_impl.c **** bool population_table_get_address(spike_t spike, address_t* row_address,
  34:spinnaker_src/population_table_binary_search_impl.c ****                                   size_t* n_bytes_to_transfer) {
  81              		.loc 1 34 0
  82              		.cfi_startproc
  83              		@ args = 0, pretend = 0, frame = 0
  84              		@ frame_needed = 0, uses_anonymous_args = 0
  85              	.LVL2:
  35:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t imin = 0;
  36:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t imax = master_population_table_length;
  86              		.loc 1 36 0
  87 0000 1F4B     		ldr	r3, .L17
  34:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t imin = 0;
  88              		.loc 1 34 0
  89 0002 2DE9F047 		push	{r4, r5, r6, r7, r8, r9, r10, lr}
  90              		.cfi_def_cfa_offset 32
  91              		.cfi_offset 4, -32
  92              		.cfi_offset 5, -28
  93              		.cfi_offset 6, -24
  94              		.cfi_offset 7, -20
  95              		.cfi_offset 8, -16
  96              		.cfi_offset 9, -12
  97              		.cfi_offset 10, -8
  98              		.cfi_offset 14, -4
  99              	.LBB13:
  37:spinnaker_src/population_table_binary_search_impl.c ****     while (imin < imax) {
  38:spinnaker_src/population_table_binary_search_impl.c ****         int imid = (imax + imin) >> 1;
  39:spinnaker_src/population_table_binary_search_impl.c ****         master_population_table_entry entry = master_population_table[imid];
 100              		.loc 1 39 0
 101 0006 1F4F     		ldr	r7, .L17+4
 102              	.LBE13:
  36:spinnaker_src/population_table_binary_search_impl.c ****     while (imin < imax) {
 103              		.loc 1 36 0
 104 0008 1D68     		ldr	r5, [r3]
 105              	.LVL3:
  34:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t imin = 0;
 106              		.loc 1 34 0
 107 000a 9246     		mov	r10, r2
  35:spinnaker_src/population_table_binary_search_impl.c ****     uint32_t imax = master_population_table_length;
 108              		.loc 1 35 0
 109 000c 0024     		movs	r4, #0
  37:spinnaker_src/population_table_binary_search_impl.c ****     while (imin < imax) {
 110              		.loc 1 37 0
 111 000e 01E0     		b	.L5
 112              	.LVL4:
 113              	.L8:
 114              	.LBB18:
  40:spinnaker_src/population_table_binary_search_impl.c ****         if ((spike & entry.mask) == entry.key) {
  41:spinnaker_src/population_table_binary_search_impl.c ****             *row_address =(address_t) _get_address(entry);
  42:spinnaker_src/population_table_binary_search_impl.c ****             *n_bytes_to_transfer =(size_t) _get_row_length(entry);
  43:spinnaker_src/population_table_binary_search_impl.c ****             return true;
  44:spinnaker_src/population_table_binary_search_impl.c ****         } else if (entry.key < spike) {
  45:spinnaker_src/population_table_binary_search_impl.c ****             imin = imid + 1;
 115              		.loc 1 45 0
 116 0010 08F10104 		add	r4, r8, #1
 117              	.LVL5:
 118              	.L5:
 119              	.LBE18:
  37:spinnaker_src/population_table_binary_search_impl.c ****         int imid = (imax + imin) >> 1;
 120              		.loc 1 37 0
 121 0014 AC42     		cmp	r4, r5
 122 0016 27D2     		bcs	.L13
 123              	.LBB19:
  38:spinnaker_src/population_table_binary_search_impl.c ****         master_population_table_entry entry = master_population_table[imid];
 124              		.loc 1 38 0
 125 0018 2B19     		adds	r3, r5, r4
 126 001a 5B08     		lsrs	r3, r3, #1
  39:spinnaker_src/population_table_binary_search_impl.c ****         if ((spike & entry.mask) == entry.key) {
 127              		.loc 1 39 0
 128 001c 03EB4306 		add	r6, r3, r3, lsl #1
 129 0020 07EB860E 		add	lr, r7, r6, lsl #2
 130 0024 57F826C0 		ldr	ip, [r7, r6, lsl #2]
  40:spinnaker_src/population_table_binary_search_impl.c ****             *row_address =(address_t) _get_address(entry);
 131              		.loc 1 40 0
 132 0028 DEF80460 		ldr	r6, [lr, #4]
  39:spinnaker_src/population_table_binary_search_impl.c ****         if ((spike & entry.mask) == entry.key) {
 133              		.loc 1 39 0
 134 002c DEF80820 		ldr	r2, [lr, #8]
  40:spinnaker_src/population_table_binary_search_impl.c ****             *row_address =(address_t) _get_address(entry);
 135              		.loc 1 40 0
 136 0030 0640     		ands	r6, r6, r0
 137 0032 6645     		cmp	r6, ip
  38:spinnaker_src/population_table_binary_search_impl.c ****         master_population_table_entry entry = master_population_table[imid];
 138              		.loc 1 38 0
 139 0034 9846     		mov	r8, r3
 140              	.LVL6:
  40:spinnaker_src/population_table_binary_search_impl.c ****             *row_address =(address_t) _get_address(entry);
 141              		.loc 1 40 0
 142 0036 1AD0     		beq	.L11
  44:spinnaker_src/population_table_binary_search_impl.c ****             imin = imid + 1;
 143              		.loc 1 44 0
 144 0038 6045     		cmp	r0, ip
 145 003a E9D8     		bhi	.L8
 146              	.LVL7:
 147              	.L14:
 148 003c 1D46     		mov	r5, r3
 149              	.LVL8:
  38:spinnaker_src/population_table_binary_search_impl.c ****         master_population_table_entry entry = master_population_table[imid];
 150              		.loc 1 38 0
 151 003e 2344     		add	r3, r3, r4
 152              	.LVL9:
 153 0040 5B08     		lsrs	r3, r3, #1
 154              	.LVL10:
  39:spinnaker_src/population_table_binary_search_impl.c ****         if ((spike & entry.mask) == entry.key) {
 155              		.loc 1 39 0
 156 0042 03EB430E 		add	lr, r3, r3, lsl #1
 157              	.LBE19:
  37:spinnaker_src/population_table_binary_search_impl.c ****         int imid = (imax + imin) >> 1;
 158              		.loc 1 37 0
 159 0046 AC42     		cmp	r4, r5
 160              	.LBB20:
  39:spinnaker_src/population_table_binary_search_impl.c ****         if ((spike & entry.mask) == entry.key) {
 161              		.loc 1 39 0
 162 0048 07EB8E0C 		add	ip, r7, lr, lsl #2
  38:spinnaker_src/population_table_binary_search_impl.c ****         master_population_table_entry entry = master_population_table[imid];
 163              		.loc 1 38 0
 164 004c 9846     		mov	r8, r3
 165              	.LBE20:
  37:spinnaker_src/population_table_binary_search_impl.c ****         int imid = (imax + imin) >> 1;
 166              		.loc 1 37 0
 167 004e 0BD2     		bcs	.L13
 168              	.LBB21:
  40:spinnaker_src/population_table_binary_search_impl.c ****             *row_address =(address_t) _get_address(entry);
 169              		.loc 1 40 0
 170 0050 DCF80460 		ldr	r6, [ip, #4]
  39:spinnaker_src/population_table_binary_search_impl.c ****         if ((spike & entry.mask) == entry.key) {
 171              		.loc 1 39 0
 172 0054 57F82E90 		ldr	r9, [r7, lr, lsl #2]
 173              	.LVL11:
 174 0058 DCF80820 		ldr	r2, [ip, #8]
  40:spinnaker_src/population_table_binary_search_impl.c ****             *row_address =(address_t) _get_address(entry);
 175              		.loc 1 40 0
 176 005c 0640     		ands	r6, r6, r0
 177              	.LVL12:
 178 005e 4E45     		cmp	r6, r9
 179 0060 05D0     		beq	.L11
  44:spinnaker_src/population_table_binary_search_impl.c ****             imin = imid + 1;
 180              		.loc 1 44 0
 181 0062 4845     		cmp	r0, r9
 182 0064 D4D8     		bhi	.L8
 183 0066 E9E7     		b	.L14
 184              	.LVL13:
 185              	.L13:
 186              	.LBE21:
  46:spinnaker_src/population_table_binary_search_impl.c ****         } else {
  47:spinnaker_src/population_table_binary_search_impl.c ****             imax = imid;
  48:spinnaker_src/population_table_binary_search_impl.c ****         }
  49:spinnaker_src/population_table_binary_search_impl.c ****     }
  50:spinnaker_src/population_table_binary_search_impl.c ****     return false;
 187              		.loc 1 50 0
 188 0068 0020     		movs	r0, #0
 189              	.LVL14:
  51:spinnaker_src/population_table_binary_search_impl.c **** }
 190              		.loc 1 51 0
 191 006a BDE8F087 		pop	{r4, r5, r6, r7, r8, r9, r10, pc}
 192              	.LVL15:
 193              	.L11:
 194              	.LBB22:
 195              	.LBB14:
 196              	.LBB15:
  13:spinnaker_src/population_table_binary_search_impl.c **** }
 197              		.loc 1 13 0
 198 006e 100A     		lsrs	r0, r2, #8
 199              	.LVL16:
 200              	.LBE15:
 201              	.LBE14:
 202              	.LBB16:
 203              	.LBB17:
  17:spinnaker_src/population_table_binary_search_impl.c **** }
 204              		.loc 1 17 0
 205 0070 D3B2     		uxtb	r3, r2
 206              	.LVL17:
 207              	.LBE17:
 208              	.LBE16:
  41:spinnaker_src/population_table_binary_search_impl.c ****             *n_bytes_to_transfer =(size_t) _get_row_length(entry);
 209              		.loc 1 41 0
 210 0072 0860     		str	r0, [r1]
  43:spinnaker_src/population_table_binary_search_impl.c ****         } else if (entry.key < spike) {
 211              		.loc 1 43 0
 212 0074 0120     		movs	r0, #1
  42:spinnaker_src/population_table_binary_search_impl.c ****             return true;
 213              		.loc 1 42 0
 214 0076 CAF80030 		str	r3, [r10]
 215 007a BDE8F087 		pop	{r4, r5, r6, r7, r8, r9, r10, pc}
 216              	.LVL18:
 217              	.L18:
 218 007e 00BF     		.align	2
 219              	.L17:
 220 0080 00000000 		.word	.LANCHOR0
 221 0084 00000000 		.word	master_population_table
 222              	.LBE22:
 223              		.cfi_endproc
 224              	.LFE171:
 226              		.section	.bss.master_population_table_length,"aw",%nobits
 227              		.align	2
 228              		.set	.LANCHOR0,. + 0
 231              	master_population_table_length:
 232 0000 00000000 		.space	4
 233              		.text
 234              	.Letext0:
 235              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 236              		.file 4 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 237              		.file 5 "spinnaker_src/common/../common-typedefs.h"
 238              		.file 6 "spinnaker_src/common/neuron-typedefs.h"
 239              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/qpe-types.h"
 240              		.file 8 "spinnaker_src/population_table.h"
 241              		.file 9 "spinnaker_src/param_defs.h"
 242              		.file 10 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 243              		.file 11 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
