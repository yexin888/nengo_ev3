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
  17              		.file	"spinn_start.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.IRQ_05_Handler,"ax",%progbits
  22              		.align	2
  23              		.global	IRQ_05_Handler
  24              		.thumb
  25              		.thumb_func
  27              	IRQ_05_Handler:
  28              	.LFB153:
  29              		.file 1 "spinnaker_src/spinn_start.c"
   1:spinnaker_src/spinn_start.c **** #include "spinn_start.h"
   2:spinnaker_src/spinn_start.c **** #include <stdbool.h>
   3:spinnaker_src/spinn_start.c **** #include "spinn2.h"
   4:spinnaker_src/spinn_start.c **** #include "qpe.h"
   5:spinnaker_src/spinn_start.c **** #include "spinn_log.h"
   6:spinnaker_src/spinn_start.c **** 
   7:spinnaker_src/spinn_start.c **** static volatile uint32_t* const comms = (uint32_t *) COMMS_BASE;
   8:spinnaker_src/spinn_start.c **** 
   9:spinnaker_src/spinn_start.c **** static volatile bool start_received = false;
  10:spinnaker_src/spinn_start.c **** 
  11:spinnaker_src/spinn_start.c **** extern uint32_t systicks;
  12:spinnaker_src/spinn_start.c **** extern int systick_callback_priority;
  13:spinnaker_src/spinn_start.c **** extern void timer_callback(uint32_t unused1, uint32_t unused2);
  14:spinnaker_src/spinn_start.c **** extern uint32_t n_external_packets_received;
  15:spinnaker_src/spinn_start.c **** //uint32_t external_packets[EXTERNAL_PACKETS_LENGTH];
  16:spinnaker_src/spinn_start.c **** 
  17:spinnaker_src/spinn_start.c **** void IRQ_05_Handler(void) {
  30              		.loc 1 17 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  18:spinnaker_src/spinn_start.c ****     uint32_t header = comms[COMMS_RCR];
  35              		.loc 1 18 0
  36 0000 094A     		ldr	r2, .L7
  19:spinnaker_src/spinn_start.c **** 	
  20:spinnaker_src/spinn_start.c **** 	//debug! real time comm
  21:spinnaker_src/spinn_start.c **** 	/*
  22:spinnaker_src/spinn_start.c **** 	uint32_t payloads[4];
  23:spinnaker_src/spinn_start.c **** 	payloads[0] = comms[COMMS_RDR3];
  24:spinnaker_src/spinn_start.c **** 	payloads[1] = comms[COMMS_RDR2];
  25:spinnaker_src/spinn_start.c **** 	payloads[2] = comms[COMMS_RDR1];
  26:spinnaker_src/spinn_start.c **** 	payloads[3] = comms[COMMS_RDR0];
  27:spinnaker_src/spinn_start.c **** 	*/
  28:spinnaker_src/spinn_start.c **** 
  29:spinnaker_src/spinn_start.c ****     uint32_t key = comms[COMMS_RKR];
  37              		.loc 1 29 0
  38 0002 0A4B     		ldr	r3, .L7+4
  18:spinnaker_src/spinn_start.c ****     uint32_t header = comms[COMMS_RCR];
  39              		.loc 1 18 0
  40 0004 1168     		ldr	r1, [r2]
  41              	.LVL0:
  42              		.loc 1 29 0
  43 0006 1A68     		ldr	r2, [r3]
  44              	.LVL1:
  30:spinnaker_src/spinn_start.c ****     if (((header & COMMS_RCR_TYPE_MASK) == COMMS_RCR_TYPE_PROTOCOL)
  45              		.loc 1 30 0
  46 0008 01F4E033 		and	r3, r1, #114688
  47 000c B3F5A03F 		cmp	r3, #81920
  48 0010 04D0     		beq	.L6
  49              	.L2:
  31:spinnaker_src/spinn_start.c ****             && key == SPINN_START_KEY_START) {
  32:spinnaker_src/spinn_start.c ****         start_received = true;
  33:spinnaker_src/spinn_start.c ****     }
  34:spinnaker_src/spinn_start.c **** 	
  35:spinnaker_src/spinn_start.c **** 	//debug! real time comm
  36:spinnaker_src/spinn_start.c **** 	/*
  37:spinnaker_src/spinn_start.c **** 	else if (((header & COMMS_RCR_TYPE_MASK) == COMMS_RCR_TYPE_PROTOCOL)
  38:spinnaker_src/spinn_start.c ****             && key == SPINN_EXT_TIMER_KEY) {
  39:spinnaker_src/spinn_start.c **** 
  40:spinnaker_src/spinn_start.c **** 		//log_info("received timer key at %d\n", systicks);
  41:spinnaker_src/spinn_start.c **** 		log_info("received payload 0 %d\n", payloads[0]);
  42:spinnaker_src/spinn_start.c **** 		log_info("received payload 1 %d\n", payloads[1]);
  43:spinnaker_src/spinn_start.c **** 		log_info("received payload 2 %d\n", payloads[2]);
  44:spinnaker_src/spinn_start.c **** 		log_info("received payload 3 %d\n", payloads[3]);
  45:spinnaker_src/spinn_start.c **** 		//TODO currently only support 1 key + 1 payload
  46:spinnaker_src/spinn_start.c **** 		external_packets[n_external_packets_received] = payloads[1];
  47:spinnaker_src/spinn_start.c **** 		n_external_packets_received++;
  48:spinnaker_src/spinn_start.c **** 		external_packets[n_external_packets_received] = payloads[0];
  49:spinnaker_src/spinn_start.c **** 		n_external_packets_received++;
  50:spinnaker_src/spinn_start.c **** 		//qpe_schedule_callback(timer_callback,8,0,systick_callback_priority);
  51:spinnaker_src/spinn_start.c ****     }
  52:spinnaker_src/spinn_start.c **** 	*/
  53:spinnaker_src/spinn_start.c **** 	else {
  54:spinnaker_src/spinn_start.c **** 	
  55:spinnaker_src/spinn_start.c **** 		log_info("received unkown packet %d %d at %d", header, key, systicks);
  50              		.loc 1 55 0
  51 0012 074B     		ldr	r3, .L7+8
  52 0014 0748     		ldr	r0, .L7+12
  53 0016 1B68     		ldr	r3, [r3]
  54 0018 FFF7FEBF 		b	log_info
  55              	.LVL2:
  56              	.L6:
  31:spinnaker_src/spinn_start.c ****             && key == SPINN_START_KEY_START) {
  57              		.loc 1 31 0
  58 001c 012A     		cmp	r2, #1
  59 001e F8D1     		bne	.L2
  32:spinnaker_src/spinn_start.c ****     }
  60              		.loc 1 32 0
  61 0020 054B     		ldr	r3, .L7+16
  62 0022 1A70     		strb	r2, [r3]
  63 0024 7047     		bx	lr
  64              	.L8:
  65 0026 00BF     		.align	2
  66              	.L7:
  67 0028 800000E2 		.word	-503316352
  68 002c 940000E2 		.word	-503316332
  69 0030 00000000 		.word	systicks
  70 0034 00000000 		.word	.LC0
  71 0038 00000000 		.word	.LANCHOR0
  72              		.cfi_endproc
  73              	.LFE153:
  75              		.section	.text.wait_for_start,"ax",%progbits
  76              		.align	2
  77              		.global	wait_for_start
  78              		.thumb
  79              		.thumb_func
  81              	wait_for_start:
  82              	.LFB154:
  56:spinnaker_src/spinn_start.c **** 	}
  57:spinnaker_src/spinn_start.c **** 	
  58:spinnaker_src/spinn_start.c **** }
  59:spinnaker_src/spinn_start.c **** 
  60:spinnaker_src/spinn_start.c **** void wait_for_start() {
  83              		.loc 1 60 0
  84              		.cfi_startproc
  85              		@ args = 0, pretend = 0, frame = 0
  86              		@ frame_needed = 0, uses_anonymous_args = 0
  87 0000 F8B5     		push	{r3, r4, r5, r6, r7, lr}
  88              		.cfi_def_cfa_offset 24
  89              		.cfi_offset 3, -24
  90              		.cfi_offset 4, -20
  91              		.cfi_offset 5, -16
  92              		.cfi_offset 6, -12
  93              		.cfi_offset 7, -8
  94              		.cfi_offset 14, -4
  95              	.LBB10:
  96              	.LBB11:
  97              		.file 2 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
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
  98              		.loc 2 1706 0
  99 0002 0F4B     		ldr	r3, .L15
 100              	.LBE11:
 101              	.LBE10:
  61:spinnaker_src/spinn_start.c ****     start_received = false;
 102              		.loc 1 61 0
 103 0004 0F4C     		ldr	r4, .L15+4
  62:spinnaker_src/spinn_start.c ****     comms[COMMS_RCTL] = 0x01F00000;
 104              		.loc 1 62 0
 105 0006 104D     		ldr	r5, .L15+8
  63:spinnaker_src/spinn_start.c ****     NVIC_SetPriority(IRQ_05_IRQn, (1UL << __NVIC_PRIO_BITS) - 1UL);
  64:spinnaker_src/spinn_start.c ****     NVIC_EnableIRQ(IRQ_05_IRQn);
  65:spinnaker_src/spinn_start.c **** 
  66:spinnaker_src/spinn_start.c ****     log_info("Waiting for start\n");
 106              		.loc 1 66 0
 107 0008 1048     		ldr	r0, .L15+12
 108              	.LBB14:
 109              	.LBB12:
 110              		.loc 2 1706 0
 111 000a F821     		movs	r1, #248
 112              	.LBE12:
 113              	.LBE14:
 114              	.LBB15:
 115              	.LBB16:
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 116              		.loc 2 1628 0
 117 000c 2022     		movs	r2, #32
 118              	.LBE16:
 119              	.LBE15:
  61:spinnaker_src/spinn_start.c ****     comms[COMMS_RCTL] = 0x01F00000;
 120              		.loc 1 61 0
 121 000e 0027     		movs	r7, #0
  62:spinnaker_src/spinn_start.c ****     NVIC_SetPriority(IRQ_05_IRQn, (1UL << __NVIC_PRIO_BITS) - 1UL);
 122              		.loc 1 62 0
 123 0010 4FF0F876 		mov	r6, #32505856
  61:spinnaker_src/spinn_start.c ****     comms[COMMS_RCTL] = 0x01F00000;
 124              		.loc 1 61 0
 125 0014 2770     		strb	r7, [r4]
  62:spinnaker_src/spinn_start.c ****     NVIC_SetPriority(IRQ_05_IRQn, (1UL << __NVIC_PRIO_BITS) - 1UL);
 126              		.loc 1 62 0
 127 0016 2E60     		str	r6, [r5]
 128              	.LVL3:
 129              	.LBB18:
 130              	.LBB13:
 131              		.loc 2 1706 0
 132 0018 83F80513 		strb	r1, [r3, #773]
 133              	.LVL4:
 134              	.LBE13:
 135              	.LBE18:
 136              	.LBB19:
 137              	.LBB17:
1628:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 138              		.loc 2 1628 0
 139 001c 1A60     		str	r2, [r3]
 140              	.LBE17:
 141              	.LBE19:
 142              		.loc 1 66 0
 143 001e FFF7FEFF 		bl	log_info
 144              	.LVL5:
  67:spinnaker_src/spinn_start.c ****     while (!start_received) {
 145              		.loc 1 67 0
 146 0022 2378     		ldrb	r3, [r4]	@ zero_extendqisi2
 147 0024 1BB9     		cbnz	r3, .L10
 148              	.L11:
 149              	.LBB20:
 150              	.LBB21:
 151              		.file 3 "/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h"
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
 152              		.loc 3 386 0
 153              	@ 386 "/home/yexin/projects/JIB1Tests/qpe-common/include/cmsis_gcc.h" 1
 154 0026 30BF     		wfi
 155              	@ 0 "" 2
 156              		.thumb
 157              	.LBE21:
 158              	.LBE20:
 159              		.loc 1 67 0
 160 0028 2378     		ldrb	r3, [r4]	@ zero_extendqisi2
 161 002a 002B     		cmp	r3, #0
 162 002c FBD0     		beq	.L11
 163              	.L10:
  68:spinnaker_src/spinn_start.c ****         __WFI();
  69:spinnaker_src/spinn_start.c ****     }
  70:spinnaker_src/spinn_start.c ****     log_info("Starting\n");
 164              		.loc 1 70 0
 165 002e 0848     		ldr	r0, .L15+16
 166 0030 FFF7FEFF 		bl	log_info
 167              	.LVL6:
 168              	.LBB22:
 169              	.LBB23:
1639:/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h **** }
 170              		.loc 2 1639 0
 171 0034 024B     		ldr	r3, .L15
 172 0036 2022     		movs	r2, #32
 173 0038 C3F88020 		str	r2, [r3, #128]
 174 003c F8BD     		pop	{r3, r4, r5, r6, r7, pc}
 175              	.L16:
 176 003e 00BF     		.align	2
 177              	.L15:
 178 0040 00E100E0 		.word	-536813312
 179 0044 00000000 		.word	.LANCHOR0
 180 0048 9C0000E2 		.word	-503316324
 181 004c 24000000 		.word	.LC1
 182 0050 38000000 		.word	.LC2
 183              	.LBE23:
 184              	.LBE22:
 185              		.cfi_endproc
 186              	.LFE154:
 188              		.section	.bss.start_received,"aw",%nobits
 189              		.set	.LANCHOR0,. + 0
 192              	start_received:
 193 0000 00       		.space	1
 194              		.section	.rodata.str1.4,"aMS",%progbits,1
 195              		.align	2
 196              	.LC0:
 197 0000 72656365 		.ascii	"received unkown packet %d %d at %d\000"
 197      69766564 
 197      20756E6B 
 197      6F776E20 
 197      7061636B 
 198 0023 00       		.space	1
 199              	.LC1:
 200 0024 57616974 		.ascii	"Waiting for start\012\000"
 200      696E6720 
 200      666F7220 
 200      73746172 
 200      740A00
 201 0037 00       		.space	1
 202              	.LC2:
 203 0038 53746172 		.ascii	"Starting\012\000"
 203      74696E67 
 203      0A00
 204              		.text
 205              	.Letext0:
 206              		.file 4 "/home/yexin/projects/JIB1Tests/qpe-common/include/device.h"
 207              		.file 5 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 208              		.file 6 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 209              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 210              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
 211              		.file 9 "spinnaker_src/spinn_log.h"
