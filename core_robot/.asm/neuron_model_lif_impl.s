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
  17              		.file	"neuron_model_lif_impl.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.neuron_calc_I_offset,"ax",%progbits
  22              		.align	2
  23              		.global	neuron_calc_I_offset
  24              		.thumb
  25              		.thumb_func
  27              	neuron_calc_I_offset:
  28              	.LFB157:
  29              		.file 1 "spinnaker_src/neuron_model_lif_impl.c"
   1:spinnaker_src/neuron_model_lif_impl.c **** #include "neuron_model_lif_impl.h"
   2:spinnaker_src/neuron_model_lif_impl.c **** 
   3:spinnaker_src/neuron_model_lif_impl.c **** REAL noise_prob[20]={0.40053986,  0.2744197 ,  0.19909816,  1.04875618,  0.12856614,
   4:spinnaker_src/neuron_model_lif_impl.c ****         0.6634103 ,  0.66681287,  0.05064152, -0.2306157 , -1.13309678,
   5:spinnaker_src/neuron_model_lif_impl.c ****         0.94487558, -0.30322118, -0.5887405 , -0.61920162, -0.64853873,
   6:spinnaker_src/neuron_model_lif_impl.c ****         0.28161237,  0.00738971, -0.40291548,  2.34712114, -1.98882378};
   7:spinnaker_src/neuron_model_lif_impl.c **** 	   
   8:spinnaker_src/neuron_model_lif_impl.c **** // simple Leaky I&F ODE
   9:spinnaker_src/neuron_model_lif_impl.c **** 
  10:spinnaker_src/neuron_model_lif_impl.c **** uint32_t rand_count=0;
  11:spinnaker_src/neuron_model_lif_impl.c **** 
  12:spinnaker_src/neuron_model_lif_impl.c **** extern volatile uint32_t systicks;
  13:spinnaker_src/neuron_model_lif_impl.c **** //extern global_neuron_params_t global_neuron_params __attribute__((aligned(0x10)));
  14:spinnaker_src/neuron_model_lif_impl.c **** 
  15:spinnaker_src/neuron_model_lif_impl.c **** static inline void _lif_neuron_closed_form(
  16:spinnaker_src/neuron_model_lif_impl.c ****         neuron_pointer_t neuron, REAL V_prev, input_t input_this_timestep) {
  17:spinnaker_src/neuron_model_lif_impl.c **** 	//reserved for other neuron models
  18:spinnaker_src/neuron_model_lif_impl.c **** }
  19:spinnaker_src/neuron_model_lif_impl.c **** 
  20:spinnaker_src/neuron_model_lif_impl.c **** void neuron_calc_I_offset(neuron_pointer_t neuron){
  30              		.loc 1 20 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
  35              	.LVL0:
  36 0000 7047     		bx	lr
  37              		.cfi_endproc
  38              	.LFE157:
  40 0002 00BF     		.section	.text.expm1_acc,"ax",%progbits
  41              		.align	2
  42              		.global	expm1_acc
  43              		.thumb
  44              		.thumb_func
  46              	expm1_acc:
  47              	.LFB158:
  21:spinnaker_src/neuron_model_lif_impl.c **** 	//reserved for other neuron models
  22:spinnaker_src/neuron_model_lif_impl.c **** }
  23:spinnaker_src/neuron_model_lif_impl.c **** 
  24:spinnaker_src/neuron_model_lif_impl.c **** REAL expm1_acc(REAL x){
  48              		.loc 1 24 0
  49              		.cfi_startproc
  50              		@ args = 0, pretend = 0, frame = 0
  51              		@ frame_needed = 0, uses_anonymous_args = 0
  52              		@ link register save eliminated.
  53              	.LVL1:
  54              	.LBB6:
  55              	.LBB7:
  56              		.file 2 "/home/yexin/projects/JIB1Tests/qpe-common/include/nmu.h"
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
  57              		.loc 2 90 0
  58 0000 074B     		ldr	r3, .L3
  59              	.LBE7:
  60              	.LBE6:
  25:spinnaker_src/neuron_model_lif_impl.c **** 	nmu_exp_calc((fixpt_s1615)(x*((int32_t)(1<<15))));//no unit
  26:spinnaker_src/neuron_model_lif_impl.c **** 	REAL result;
  27:spinnaker_src/neuron_model_lif_impl.c **** 	result =(((REAL)nmu_exp_fetch())/(int32_t)(1<<15)-1) ;
  61              		.loc 1 27 0
  62 0002 9FED087A 		flds	s14, .L3+4
  25:spinnaker_src/neuron_model_lif_impl.c **** 	nmu_exp_calc((fixpt_s1615)(x*((int32_t)(1<<15))));//no unit
  63              		.loc 1 25 0
  64 0006 BEEEE80A 		vcvt.s32.f32	s0, s0, #15
  65              	.LVL2:
  66              	.LBB9:
  67              	.LBB8:
  68              		.loc 2 90 0
  69 000a 83ED000A 		fsts	s0, [r3]	@ int
  70              	.LBE8:
  71              	.LBE9:
  72              	.LBB10:
  73              	.LBB11:
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
  74              		.loc 2 102 0
  75 000e D3ED007A 		flds	s15, [r3]	@ int
  76              	.LVL3:
  77              	.LBE11:
  78              	.LBE10:
  79              		.loc 1 27 0
  80 0012 F8EEE77A 		fsitos	s15, s15
  81              	.LVL4:
  82 0016 BFEE000A 		fconsts	s0, #240
  83              	.LVL5:
  28:spinnaker_src/neuron_model_lif_impl.c **** 		    
  29:spinnaker_src/neuron_model_lif_impl.c **** 	return result ;
  30:spinnaker_src/neuron_model_lif_impl.c **** }
  84              		.loc 1 30 0
  85 001a A7EE870A 		vfma.f32	s0, s15, s14
  86              	.LVL6:
  87 001e 7047     		bx	lr
  88              	.L4:
  89              		.align	2
  90              	.L3:
  91 0020 000110E0 		.word	-535822080
  92 0024 00000038 		.word	939524096
  93              		.cfi_endproc
  94              	.LFE158:
  96              		.section	.text.neuron_model_state_update,"ax",%progbits
  97              		.align	2
  98              		.global	neuron_model_state_update
  99              		.thumb
 100              		.thumb_func
 102              	neuron_model_state_update:
 103              	.LFB159:
  31:spinnaker_src/neuron_model_lif_impl.c **** 
  32:spinnaker_src/neuron_model_lif_impl.c **** REAL neuron_model_state_update(
  33:spinnaker_src/neuron_model_lif_impl.c ****        REAL current,  neuron_pointer_t neuron, REAL tau_rc) {
 104              		.loc 1 33 0
 105              		.cfi_startproc
 106              		@ args = 0, pretend = 0, frame = 0
 107              		@ frame_needed = 0, uses_anonymous_args = 0
 108              	.LVL7:
  34:spinnaker_src/neuron_model_lif_impl.c **** 
  35:spinnaker_src/neuron_model_lif_impl.c ****     neuron->refract_timer -= 1;
 109              		.loc 1 35 0
 110 0000 D0ED017A 		flds	s15, [r0, #4]
 111 0004 B7EE006A 		fconsts	s12, #112
 112 0008 77EEC67A 		fsubs	s15, s15, s12
  33:spinnaker_src/neuron_model_lif_impl.c **** 
 113              		.loc 1 33 0
 114 000c 10B5     		push	{r4, lr}
 115              		.cfi_def_cfa_offset 8
 116              		.cfi_offset 4, -8
 117              		.cfi_offset 14, -4
  36:spinnaker_src/neuron_model_lif_impl.c ****     REAL delta_t = (1 -(REAL) neuron->refract_timer);
 118              		.loc 1 36 0
 119 000e 36EE677A 		fsubs	s14, s12, s15
 120              	.LVL8:
  33:spinnaker_src/neuron_model_lif_impl.c **** 
 121              		.loc 1 33 0
 122 0012 2DED028B 		fstmfdd	sp!, {d8}
 123              		.cfi_def_cfa_offset 16
 124              		.cfi_offset 80, -16
 125              		.cfi_offset 81, -12
  37:spinnaker_src/neuron_model_lif_impl.c ****     if(delta_t > 1){
 126              		.loc 1 37 0
 127 0016 B4EEC67A 		fcmpes	s14, s12
 128 001a F1EE10FA 		fmstat
  33:spinnaker_src/neuron_model_lif_impl.c **** 
 129              		.loc 1 33 0
 130 001e 0446     		mov	r4, r0
 131 0020 F0EE406A 		fcpys	s13, s0
  35:spinnaker_src/neuron_model_lif_impl.c ****     REAL delta_t = (1 -(REAL) neuron->refract_timer);
 132              		.loc 1 35 0
 133 0024 C0ED017A 		fsts	s15, [r0, #4]
 134              		.loc 1 37 0
 135 0028 1FDD     		ble	.L13
 136 002a BFEE000A 		fconsts	s0, #240
 137              	.LVL9:
 138              	.L6:
  38:spinnaker_src/neuron_model_lif_impl.c **** 		delta_t = 1;
  39:spinnaker_src/neuron_model_lif_impl.c **** 	}
  40:spinnaker_src/neuron_model_lif_impl.c **** 	else if(delta_t < 0){
  41:spinnaker_src/neuron_model_lif_impl.c **** 	
  42:spinnaker_src/neuron_model_lif_impl.c **** 		delta_t = 0;
  43:spinnaker_src/neuron_model_lif_impl.c **** 	}	
  44:spinnaker_src/neuron_model_lif_impl.c **** 	//TODO exp acc
  45:spinnaker_src/neuron_model_lif_impl.c **** 	neuron->V_membrane -= (current -(REAL) neuron->V_membrane) * expm1f(-delta_t /(REAL) tau_rc );
 139              		.loc 1 45 0
 140 002e 94ED008A 		flds	s16, [r4]
 141 0032 80EE200A 		fdivs	s0, s0, s1
 142 0036 36EEC88A 		fsubs	s16, s13, s16
 143 003a FFF7FEFF 		bl	expm1f
 144              	.LVL10:
 145 003e D4ED007A 		flds	s15, [r4]
  46:spinnaker_src/neuron_model_lif_impl.c **** 	//neuron->V_membrane -= (current - neuron->V_membrane) * expm1_acc(-delta_t / tau_rc );
  47:spinnaker_src/neuron_model_lif_impl.c **** 	if(neuron->V_membrane< 0){
 146              		.loc 1 47 0
 147 0042 9FED0F7A 		flds	s14, .L14
  45:spinnaker_src/neuron_model_lif_impl.c **** 	//neuron->V_membrane -= (current - neuron->V_membrane) * expm1_acc(-delta_t / tau_rc );
 148              		.loc 1 45 0
 149 0046 E8EE407A 		vfms.f32	s15, s16, s0
  48:spinnaker_src/neuron_model_lif_impl.c **** 		neuron->V_membrane = 0;
  49:spinnaker_src/neuron_model_lif_impl.c **** 	}
  50:spinnaker_src/neuron_model_lif_impl.c **** 
  51:spinnaker_src/neuron_model_lif_impl.c ****     return neuron->V_membrane;
  52:spinnaker_src/neuron_model_lif_impl.c **** }
 150              		.loc 1 52 0
 151 004a BDEC028B 		fldmfdd	sp!, {d8}
 152              		.cfi_remember_state
 153              		.cfi_restore 80
 154              		.cfi_restore 81
 155              		.cfi_def_cfa_offset 8
  47:spinnaker_src/neuron_model_lif_impl.c **** 		neuron->V_membrane = 0;
 156              		.loc 1 47 0
 157 004e F4EEC77A 		fcmpes	s15, s14
 158 0052 F1EE10FA 		fmstat
  45:spinnaker_src/neuron_model_lif_impl.c **** 	//neuron->V_membrane -= (current - neuron->V_membrane) * expm1_acc(-delta_t / tau_rc );
 159              		.loc 1 45 0
 160 0056 B0EE670A 		fcpys	s0, s15
 161 005a 52BF     		itee	pl
 162 005c C4ED007A 		fstspl	s15, [r4]
  48:spinnaker_src/neuron_model_lif_impl.c **** 		neuron->V_membrane = 0;
 163              		.loc 1 48 0
 164 0060 B0EE470A 		fcpysmi	s0, s14
 165 0064 84ED007A 		fstsmi	s14, [r4]
 166              		.loc 1 52 0
 167 0068 10BD     		pop	{r4, pc}
 168              	.LVL11:
 169              	.L13:
 170              		.cfi_restore_state
  40:spinnaker_src/neuron_model_lif_impl.c **** 	
 171              		.loc 1 40 0
 172 006a B5EEC07A 		fcmpezs	s14
 173 006e F1EE10FA 		fmstat
 174 0072 02D4     		bmi	.L10
 175 0074 B1EE470A 		fnegs	s0, s14
 176              	.LVL12:
 177 0078 D9E7     		b	.L6
 178              	.LVL13:
 179              	.L10:
 180 007a 9FED020A 		flds	s0, .L14+4
 181              	.LVL14:
 182 007e D6E7     		b	.L6
 183              	.L15:
 184              		.align	2
 185              	.L14:
 186 0080 00000000 		.word	0
 187 0084 00000080 		.word	2147483648
 188              		.cfi_endproc
 189              	.LFE159:
 191              		.section	.text.neuron_model_has_spiked,"ax",%progbits
 192              		.align	2
 193              		.global	neuron_model_has_spiked
 194              		.thumb
 195              		.thumb_func
 197              	neuron_model_has_spiked:
 198              	.LFB160:
  53:spinnaker_src/neuron_model_lif_impl.c **** 
  54:spinnaker_src/neuron_model_lif_impl.c **** void neuron_model_has_spiked(neuron_pointer_t neuron) {
 199              		.loc 1 54 0
 200              		.cfi_startproc
 201              		@ args = 0, pretend = 0, frame = 0
 202              		@ frame_needed = 0, uses_anonymous_args = 0
 203              		@ link register save eliminated.
 204              	.LVL15:
 205 0000 7047     		bx	lr
 206              		.cfi_endproc
 207              	.LFE160:
 209 0002 00BF     		.section	.text.neuron_model_get_membrane_voltage,"ax",%progbits
 210              		.align	2
 211              		.global	neuron_model_get_membrane_voltage
 212              		.thumb
 213              		.thumb_func
 215              	neuron_model_get_membrane_voltage:
 216              	.LFB161:
  55:spinnaker_src/neuron_model_lif_impl.c **** 
  56:spinnaker_src/neuron_model_lif_impl.c **** 	//reserved for other neuron models
  57:spinnaker_src/neuron_model_lif_impl.c **** 	
  58:spinnaker_src/neuron_model_lif_impl.c ****     //reset membrane voltage
  59:spinnaker_src/neuron_model_lif_impl.c ****     //neuron->V_membrane = global_neuron_params.V_reset;
  60:spinnaker_src/neuron_model_lif_impl.c **** 
  61:spinnaker_src/neuron_model_lif_impl.c ****     // reset refractory timer
  62:spinnaker_src/neuron_model_lif_impl.c ****     //neuron->refract_timer  = global_neuron_params.T_refract;
  63:spinnaker_src/neuron_model_lif_impl.c **** }
  64:spinnaker_src/neuron_model_lif_impl.c **** 
  65:spinnaker_src/neuron_model_lif_impl.c **** inline REAL neuron_model_get_membrane_voltage(neuron_pointer_t neuron) {
 217              		.loc 1 65 0
 218              		.cfi_startproc
 219              		@ args = 0, pretend = 0, frame = 0
 220              		@ frame_needed = 0, uses_anonymous_args = 0
 221              		@ link register save eliminated.
 222              	.LVL16:
  66:spinnaker_src/neuron_model_lif_impl.c ****     return neuron->V_membrane;
  67:spinnaker_src/neuron_model_lif_impl.c **** }
 223              		.loc 1 67 0
 224 0000 90ED000A 		flds	s0, [r0]
 225 0004 7047     		bx	lr
 226              		.cfi_endproc
 227              	.LFE161:
 229              		.global	rand_count
 230              		.global	noise_prob
 231 0006 00BF     		.section	.bss.rand_count,"aw",%nobits
 232              		.align	2
 235              	rand_count:
 236 0000 00000000 		.space	4
 237              		.section	.data.noise_prob,"aw",%progbits
 238              		.align	2
 241              	noise_prob:
 242 0000 8F13CD3E 		.word	1053627279
 243 0004 BD808C3E 		.word	1049395389
 244 0008 63E04B3E 		.word	1045160035
 245 000c A43D863F 		.word	1065762212
 246 0010 D8A6033E 		.word	1040426712
 247 0014 42D5293F 		.word	1059706178
 248 0018 40B42A3F 		.word	1059763264
 249 001c 7C6D4F3D 		.word	1028615548
 250 0020 86266CBE 		.word	3194758790
 251 0024 510991BF 		.word	3213953361
 252 0028 5EE3713F 		.word	1064428382
 253 002c CE3F9BBE 		.word	3197845454
 254 0030 B3B716BF 		.word	3205937075
 255 0034 FF831EBF 		.word	3206448127
 256 0038 A20626BF 		.word	3206940322
 257 003c 7F2F903E 		.word	1049636735
 258 0040 6125F23B 		.word	1005725025
 259 0044 F04ACEBE 		.word	3201190640
 260 0048 3C371640 		.word	1075197756
 261 004c C791FEBF 		.word	3221131719
 262              		.text
 263              	.Letext0:
 264              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 265              		.file 4 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 266              		.file 5 "spinnaker_src/common/maths-util.h"
 267              		.file 6 "/home/yexin/projects/JIB1Tests/qpe-common/include/fixedpoint.h"
 268              		.file 7 "spinnaker_src/neuron_model.h"
 269              		.file 8 "spinnaker_src/param_defs.h"
 270              		.file 9 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 271              		.file 10 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 272              		.file 11 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
 273              		.file 12 "/home/yexin/projects/JIB1Tests/float-libm/include/math.h"
