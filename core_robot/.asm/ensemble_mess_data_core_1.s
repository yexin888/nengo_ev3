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
  17              		.file	"ensemble_mess_data_core_1.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.ensemble_init,"ax",%progbits
  22              		.align	2
  23              		.global	ensemble_init
  24              		.thumb
  25              		.thumb_func
  27              	ensemble_init:
  28              	.LFB156:
  29              		.file 1 "spinnaker_src/ensemble_mess_data_core_1.c"
   1:spinnaker_src/ensemble_mess_data_core_1.c **** #include "qpe.h"
   2:spinnaker_src/ensemble_mess_data_core_1.c **** #include "common/neuron-typedefs.h"
   3:spinnaker_src/ensemble_mess_data_core_1.c **** #include "param_defs.h"
   4:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t encoders1[1*150]={
   5:spinnaker_src/ensemble_mess_data_core_1.c **** -8.7233009396,
   6:spinnaker_src/ensemble_mess_data_core_1.c **** 31.7049772924,
   7:spinnaker_src/ensemble_mess_data_core_1.c **** -12.7168198922,
   8:spinnaker_src/ensemble_mess_data_core_1.c **** 19.6786576525,
   9:spinnaker_src/ensemble_mess_data_core_1.c **** 8.37178852991,
  10:spinnaker_src/ensemble_mess_data_core_1.c **** 9.02964389192,
  11:spinnaker_src/ensemble_mess_data_core_1.c **** 21.6759225884,
  12:spinnaker_src/ensemble_mess_data_core_1.c **** -17.4644991153,
  13:spinnaker_src/ensemble_mess_data_core_1.c **** 14.1368506347,
  14:spinnaker_src/ensemble_mess_data_core_1.c **** 37.5756643524,
  15:spinnaker_src/ensemble_mess_data_core_1.c **** 9.83038525638,
  16:spinnaker_src/ensemble_mess_data_core_1.c **** -6.71043541993,
  17:spinnaker_src/ensemble_mess_data_core_1.c **** 3.95281403953,
  18:spinnaker_src/ensemble_mess_data_core_1.c **** -8.49439244732,
  19:spinnaker_src/ensemble_mess_data_core_1.c **** -11.4128694724,
  20:spinnaker_src/ensemble_mess_data_core_1.c **** -27.3239717405,
  21:spinnaker_src/ensemble_mess_data_core_1.c **** 17.5053367189,
  22:spinnaker_src/ensemble_mess_data_core_1.c **** 40.7398745574,
  23:spinnaker_src/ensemble_mess_data_core_1.c **** 12.517127563,
  24:spinnaker_src/ensemble_mess_data_core_1.c **** -80.4646339096,
  25:spinnaker_src/ensemble_mess_data_core_1.c **** -11.7686607696,
  26:spinnaker_src/ensemble_mess_data_core_1.c **** -5.28391495004,
  27:spinnaker_src/ensemble_mess_data_core_1.c **** -5.76809388963,
  28:spinnaker_src/ensemble_mess_data_core_1.c **** -51.1445427285,
  29:spinnaker_src/ensemble_mess_data_core_1.c **** -36.7758056808,
  30:spinnaker_src/ensemble_mess_data_core_1.c **** 8.08855367388,
  31:spinnaker_src/ensemble_mess_data_core_1.c **** 112.882483814,
  32:spinnaker_src/ensemble_mess_data_core_1.c **** 17.3141419358,
  33:spinnaker_src/ensemble_mess_data_core_1.c **** -22.0140034044,
  34:spinnaker_src/ensemble_mess_data_core_1.c **** -29.697165806,
  35:spinnaker_src/ensemble_mess_data_core_1.c **** 44.2868529489,
  36:spinnaker_src/ensemble_mess_data_core_1.c **** 3.97370712511,
  37:spinnaker_src/ensemble_mess_data_core_1.c **** 6.09044157226,
  38:spinnaker_src/ensemble_mess_data_core_1.c **** -102.524107396,
  39:spinnaker_src/ensemble_mess_data_core_1.c **** 117.23329325,
  40:spinnaker_src/ensemble_mess_data_core_1.c **** -32.0965438224,
  41:spinnaker_src/ensemble_mess_data_core_1.c **** -7.61755963974,
  42:spinnaker_src/ensemble_mess_data_core_1.c **** 104.52680627,
  43:spinnaker_src/ensemble_mess_data_core_1.c **** -349.303290519,
  44:spinnaker_src/ensemble_mess_data_core_1.c **** -4.36276395729,
  45:spinnaker_src/ensemble_mess_data_core_1.c **** 3.65236932208,
  46:spinnaker_src/ensemble_mess_data_core_1.c **** 20.1507373275,
  47:spinnaker_src/ensemble_mess_data_core_1.c **** -58.1469189464,
  48:spinnaker_src/ensemble_mess_data_core_1.c **** -20.1345837702,
  49:spinnaker_src/ensemble_mess_data_core_1.c **** 7.38671519796,
  50:spinnaker_src/ensemble_mess_data_core_1.c **** -20.8041341549,
  51:spinnaker_src/ensemble_mess_data_core_1.c **** -7.40398687739,
  52:spinnaker_src/ensemble_mess_data_core_1.c **** 7.62385369451,
  53:spinnaker_src/ensemble_mess_data_core_1.c **** -55.9230606591,
  54:spinnaker_src/ensemble_mess_data_core_1.c **** -48.5939579803,
  55:spinnaker_src/ensemble_mess_data_core_1.c **** -5.55852288645,
  56:spinnaker_src/ensemble_mess_data_core_1.c **** -5.8047580182,
  57:spinnaker_src/ensemble_mess_data_core_1.c **** 7.248961582,
  58:spinnaker_src/ensemble_mess_data_core_1.c **** -26.0082161548,
  59:spinnaker_src/ensemble_mess_data_core_1.c **** 4.73608011047,
  60:spinnaker_src/ensemble_mess_data_core_1.c **** -4.94786771473,
  61:spinnaker_src/ensemble_mess_data_core_1.c **** -3.9983372335,
  62:spinnaker_src/ensemble_mess_data_core_1.c **** 9.68485071869,
  63:spinnaker_src/ensemble_mess_data_core_1.c **** 7.12530125203,
  64:spinnaker_src/ensemble_mess_data_core_1.c **** 8.09649297393,
  65:spinnaker_src/ensemble_mess_data_core_1.c **** -15.4200166267,
  66:spinnaker_src/ensemble_mess_data_core_1.c **** -20.4252877024,
  67:spinnaker_src/ensemble_mess_data_core_1.c **** 6.98933071431,
  68:spinnaker_src/ensemble_mess_data_core_1.c **** 8.47111406513,
  69:spinnaker_src/ensemble_mess_data_core_1.c **** -7.97445298543,
  70:spinnaker_src/ensemble_mess_data_core_1.c **** -21.492473425,
  71:spinnaker_src/ensemble_mess_data_core_1.c **** 9.51995695414,
  72:spinnaker_src/ensemble_mess_data_core_1.c **** -6.41475580686,
  73:spinnaker_src/ensemble_mess_data_core_1.c **** -121.182835528,
  74:spinnaker_src/ensemble_mess_data_core_1.c **** 41.0341772633,
  75:spinnaker_src/ensemble_mess_data_core_1.c **** -12.5876588222,
  76:spinnaker_src/ensemble_mess_data_core_1.c **** 15.9399248942,
  77:spinnaker_src/ensemble_mess_data_core_1.c **** 22.7909000114,
  78:spinnaker_src/ensemble_mess_data_core_1.c **** 18.5908901232,
  79:spinnaker_src/ensemble_mess_data_core_1.c **** 60.8020191606,
  80:spinnaker_src/ensemble_mess_data_core_1.c **** 102.302873778,
  81:spinnaker_src/ensemble_mess_data_core_1.c **** -5.58276427718,
  82:spinnaker_src/ensemble_mess_data_core_1.c **** -39.3452613739,
  83:spinnaker_src/ensemble_mess_data_core_1.c **** -97.7891327716,
  84:spinnaker_src/ensemble_mess_data_core_1.c **** -55.4679940252,
  85:spinnaker_src/ensemble_mess_data_core_1.c **** 34.3768389544,
  86:spinnaker_src/ensemble_mess_data_core_1.c **** 5.15263893083,
  87:spinnaker_src/ensemble_mess_data_core_1.c **** -5.60460782307,
  88:spinnaker_src/ensemble_mess_data_core_1.c **** 10.2971469742,
  89:spinnaker_src/ensemble_mess_data_core_1.c **** -7.37362932888,
  90:spinnaker_src/ensemble_mess_data_core_1.c **** -66.5615756406,
  91:spinnaker_src/ensemble_mess_data_core_1.c **** -38.6271080627,
  92:spinnaker_src/ensemble_mess_data_core_1.c **** -91.4248035291,
  93:spinnaker_src/ensemble_mess_data_core_1.c **** 3.51620780727,
  94:spinnaker_src/ensemble_mess_data_core_1.c **** 10.7809264107,
  95:spinnaker_src/ensemble_mess_data_core_1.c **** -14.7835457563,
  96:spinnaker_src/ensemble_mess_data_core_1.c **** 6.01090330295,
  97:spinnaker_src/ensemble_mess_data_core_1.c **** 13.0936185079,
  98:spinnaker_src/ensemble_mess_data_core_1.c **** 6.63981321603,
  99:spinnaker_src/ensemble_mess_data_core_1.c **** 9.20215678878,
 100:spinnaker_src/ensemble_mess_data_core_1.c **** -31.1071596505,
 101:spinnaker_src/ensemble_mess_data_core_1.c **** -7.72045940103,
 102:spinnaker_src/ensemble_mess_data_core_1.c **** 29.2863661429,
 103:spinnaker_src/ensemble_mess_data_core_1.c **** 22.1496909167,
 104:spinnaker_src/ensemble_mess_data_core_1.c **** -5.17483459891,
 105:spinnaker_src/ensemble_mess_data_core_1.c **** -38.451271844,
 106:spinnaker_src/ensemble_mess_data_core_1.c **** 16.628723749,
 107:spinnaker_src/ensemble_mess_data_core_1.c **** 21.2652613287,
 108:spinnaker_src/ensemble_mess_data_core_1.c **** -28.991894045,
 109:spinnaker_src/ensemble_mess_data_core_1.c **** -11.8919787051,
 110:spinnaker_src/ensemble_mess_data_core_1.c **** -18.1161706955,
 111:spinnaker_src/ensemble_mess_data_core_1.c **** -37.8012689071,
 112:spinnaker_src/ensemble_mess_data_core_1.c **** -44.8737119217,
 113:spinnaker_src/ensemble_mess_data_core_1.c **** 18.1812383288,
 114:spinnaker_src/ensemble_mess_data_core_1.c **** 1784.02274287,
 115:spinnaker_src/ensemble_mess_data_core_1.c **** -6.97193599312,
 116:spinnaker_src/ensemble_mess_data_core_1.c **** -14.6556507555,
 117:spinnaker_src/ensemble_mess_data_core_1.c **** 6.59246409957,
 118:spinnaker_src/ensemble_mess_data_core_1.c **** -11.9782494457,
 119:spinnaker_src/ensemble_mess_data_core_1.c **** 63.8747395789,
 120:spinnaker_src/ensemble_mess_data_core_1.c **** -19.7064047069,
 121:spinnaker_src/ensemble_mess_data_core_1.c **** 62.5595674044,
 122:spinnaker_src/ensemble_mess_data_core_1.c **** -20.1112741508,
 123:spinnaker_src/ensemble_mess_data_core_1.c **** 7.92544592958,
 124:spinnaker_src/ensemble_mess_data_core_1.c **** -4.66845523012,
 125:spinnaker_src/ensemble_mess_data_core_1.c **** -15.9016578171,
 126:spinnaker_src/ensemble_mess_data_core_1.c **** 70.2059479482,
 127:spinnaker_src/ensemble_mess_data_core_1.c **** 23.347083689,
 128:spinnaker_src/ensemble_mess_data_core_1.c **** 9.58375063689,
 129:spinnaker_src/ensemble_mess_data_core_1.c **** -32.4097789024,
 130:spinnaker_src/ensemble_mess_data_core_1.c **** -17.8884563907,
 131:spinnaker_src/ensemble_mess_data_core_1.c **** -46.1530648856,
 132:spinnaker_src/ensemble_mess_data_core_1.c **** -10.1330999465,
 133:spinnaker_src/ensemble_mess_data_core_1.c **** -10.3842845633,
 134:spinnaker_src/ensemble_mess_data_core_1.c **** 6.61427075739,
 135:spinnaker_src/ensemble_mess_data_core_1.c **** 21.9344940004,
 136:spinnaker_src/ensemble_mess_data_core_1.c **** 66.9963025507,
 137:spinnaker_src/ensemble_mess_data_core_1.c **** 25.9446656686,
 138:spinnaker_src/ensemble_mess_data_core_1.c **** 81.5404253311,
 139:spinnaker_src/ensemble_mess_data_core_1.c **** -5.03036864658,
 140:spinnaker_src/ensemble_mess_data_core_1.c **** -14.1695602962,
 141:spinnaker_src/ensemble_mess_data_core_1.c **** 247.59843645,
 142:spinnaker_src/ensemble_mess_data_core_1.c **** -11.6389232854,
 143:spinnaker_src/ensemble_mess_data_core_1.c **** 15.8419057133,
 144:spinnaker_src/ensemble_mess_data_core_1.c **** -83.6124437727,
 145:spinnaker_src/ensemble_mess_data_core_1.c **** 11.2577424992,
 146:spinnaker_src/ensemble_mess_data_core_1.c **** -61.6630199594,
 147:spinnaker_src/ensemble_mess_data_core_1.c **** 7.71402119986,
 148:spinnaker_src/ensemble_mess_data_core_1.c **** -36.5126598066,
 149:spinnaker_src/ensemble_mess_data_core_1.c **** -69.6537792764,
 150:spinnaker_src/ensemble_mess_data_core_1.c **** -7.02276759798,
 151:spinnaker_src/ensemble_mess_data_core_1.c **** -3.86071789768,
 152:spinnaker_src/ensemble_mess_data_core_1.c **** -12.2101289233,
 153:spinnaker_src/ensemble_mess_data_core_1.c **** 35.2922822307,
 154:spinnaker_src/ensemble_mess_data_core_1.c **** -78.6695795041
 155:spinnaker_src/ensemble_mess_data_core_1.c **** };
 156:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t bias1[150]={
 157:spinnaker_src/ensemble_mess_data_core_1.c **** 3.63612474372,
 158:spinnaker_src/ensemble_mess_data_core_1.c **** 2.03734137365,
 159:spinnaker_src/ensemble_mess_data_core_1.c **** -0.0245200635371,
 160:spinnaker_src/ensemble_mess_data_core_1.c **** 17.489869117,
 161:spinnaker_src/ensemble_mess_data_core_1.c **** 1.1744415621,
 162:spinnaker_src/ensemble_mess_data_core_1.c **** 5.69103328034,
 163:spinnaker_src/ensemble_mess_data_core_1.c **** -5.46926983556,
 164:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0306365893702,
 165:spinnaker_src/ensemble_mess_data_core_1.c **** -0.920319691911,
 166:spinnaker_src/ensemble_mess_data_core_1.c **** -21.0632938606,
 167:spinnaker_src/ensemble_mess_data_core_1.c **** 0.483187448841,
 168:spinnaker_src/ensemble_mess_data_core_1.c **** 3.85063935794,
 169:spinnaker_src/ensemble_mess_data_core_1.c **** 4.10979756179,
 170:spinnaker_src/ensemble_mess_data_core_1.c **** 8.07770242852,
 171:spinnaker_src/ensemble_mess_data_core_1.c **** 3.81683599447,
 172:spinnaker_src/ensemble_mess_data_core_1.c **** 10.1608979607,
 173:spinnaker_src/ensemble_mess_data_core_1.c **** 8.01861568623,
 174:spinnaker_src/ensemble_mess_data_core_1.c **** -19.2272918437,
 175:spinnaker_src/ensemble_mess_data_core_1.c **** -1.43456995359,
 176:spinnaker_src/ensemble_mess_data_core_1.c **** -70.3675071432,
 177:spinnaker_src/ensemble_mess_data_core_1.c **** 9.62018645084,
 178:spinnaker_src/ensemble_mess_data_core_1.c **** 4.78040592063,
 179:spinnaker_src/ensemble_mess_data_core_1.c **** 2.27941008094,
 180:spinnaker_src/ensemble_mess_data_core_1.c **** -39.2223517808,
 181:spinnaker_src/ensemble_mess_data_core_1.c **** -19.930309956,
 182:spinnaker_src/ensemble_mess_data_core_1.c **** 1.65419402345,
 183:spinnaker_src/ensemble_mess_data_core_1.c **** -104.363312308,
 184:spinnaker_src/ensemble_mess_data_core_1.c **** 12.5603328499,
 185:spinnaker_src/ensemble_mess_data_core_1.c **** -7.50490298487,
 186:spinnaker_src/ensemble_mess_data_core_1.c **** -22.4707207701,
 187:spinnaker_src/ensemble_mess_data_core_1.c **** -33.8114390133,
 188:spinnaker_src/ensemble_mess_data_core_1.c **** 3.72177036144,
 189:spinnaker_src/ensemble_mess_data_core_1.c **** 4.49487784647,
 190:spinnaker_src/ensemble_mess_data_core_1.c **** -88.7682653802,
 191:spinnaker_src/ensemble_mess_data_core_1.c **** -108.291893165,
 192:spinnaker_src/ensemble_mess_data_core_1.c **** 2.80904169478,
 193:spinnaker_src/ensemble_mess_data_core_1.c **** 6.98381673992,
 194:spinnaker_src/ensemble_mess_data_core_1.c **** -74.9505404252,
 195:spinnaker_src/ensemble_mess_data_core_1.c **** -321.835296558,
 196:spinnaker_src/ensemble_mess_data_core_1.c **** 4.22051610954,
 197:spinnaker_src/ensemble_mess_data_core_1.c **** 4.60037763825,
 198:spinnaker_src/ensemble_mess_data_core_1.c **** -2.97216003649,
 199:spinnaker_src/ensemble_mess_data_core_1.c **** -50.6172064759,
 200:spinnaker_src/ensemble_mess_data_core_1.c **** 5.56374302752,
 201:spinnaker_src/ensemble_mess_data_core_1.c **** 4.47299477957,
 202:spinnaker_src/ensemble_mess_data_core_1.c **** 1.70535607539,
 203:spinnaker_src/ensemble_mess_data_core_1.c **** 2.22193455225,
 204:spinnaker_src/ensemble_mess_data_core_1.c **** 4.06309083397,
 205:spinnaker_src/ensemble_mess_data_core_1.c **** -36.1862175313,
 206:spinnaker_src/ensemble_mess_data_core_1.c **** -38.4633764967,
 207:spinnaker_src/ensemble_mess_data_core_1.c **** 4.26801279628,
 208:spinnaker_src/ensemble_mess_data_core_1.c **** 6.46190281451,
 209:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0185979427044,
 210:spinnaker_src/ensemble_mess_data_core_1.c **** -4.10839355288,
 211:spinnaker_src/ensemble_mess_data_core_1.c **** 3.80348605343,
 212:spinnaker_src/ensemble_mess_data_core_1.c **** 5.29958580678,
 213:spinnaker_src/ensemble_mess_data_core_1.c **** 3.89336667773,
 214:spinnaker_src/ensemble_mess_data_core_1.c **** 4.52271421647,
 215:spinnaker_src/ensemble_mess_data_core_1.c **** 3.75080058746,
 216:spinnaker_src/ensemble_mess_data_core_1.c **** 7.78426311575,
 217:spinnaker_src/ensemble_mess_data_core_1.c **** 5.37183013247,
 218:spinnaker_src/ensemble_mess_data_core_1.c **** -10.7675898835,
 219:spinnaker_src/ensemble_mess_data_core_1.c **** 4.9209390383,
 220:spinnaker_src/ensemble_mess_data_core_1.c **** 8.72991180242,
 221:spinnaker_src/ensemble_mess_data_core_1.c **** 2.39491928368,
 222:spinnaker_src/ensemble_mess_data_core_1.c **** 11.7461498688,
 223:spinnaker_src/ensemble_mess_data_core_1.c **** -1.89770934011,
 224:spinnaker_src/ensemble_mess_data_core_1.c **** 2.60997602181,
 225:spinnaker_src/ensemble_mess_data_core_1.c **** -109.939304615,
 226:spinnaker_src/ensemble_mess_data_core_1.c **** -20.003314735,
 227:spinnaker_src/ensemble_mess_data_core_1.c **** -4.34282653374,
 228:spinnaker_src/ensemble_mess_data_core_1.c **** 15.2830923746,
 229:spinnaker_src/ensemble_mess_data_core_1.c **** 9.70451371793,
 230:spinnaker_src/ensemble_mess_data_core_1.c **** 1.23784896568,
 231:spinnaker_src/ensemble_mess_data_core_1.c **** -47.8929785703,
 232:spinnaker_src/ensemble_mess_data_core_1.c **** -91.3322844922,
 233:spinnaker_src/ensemble_mess_data_core_1.c **** 6.54424109538,
 234:spinnaker_src/ensemble_mess_data_core_1.c **** -8.53791869544,
 235:spinnaker_src/ensemble_mess_data_core_1.c **** -81.4926836093,
 236:spinnaker_src/ensemble_mess_data_core_1.c **** -21.2303140017,
 237:spinnaker_src/ensemble_mess_data_core_1.c **** -18.8816146927,
 238:spinnaker_src/ensemble_mess_data_core_1.c **** 4.74268782842,
 239:spinnaker_src/ensemble_mess_data_core_1.c **** 2.70557536633,
 240:spinnaker_src/ensemble_mess_data_core_1.c **** 10.419183005,
 241:spinnaker_src/ensemble_mess_data_core_1.c **** 3.86009094112,
 242:spinnaker_src/ensemble_mess_data_core_1.c **** -47.1969044358,
 243:spinnaker_src/ensemble_mess_data_core_1.c **** -4.20089986016,
 244:spinnaker_src/ensemble_mess_data_core_1.c **** -84.0505011849,
 245:spinnaker_src/ensemble_mess_data_core_1.c **** 4.28864084071,
 246:spinnaker_src/ensemble_mess_data_core_1.c **** 1.18095434375,
 247:spinnaker_src/ensemble_mess_data_core_1.c **** -3.30361363385,
 248:spinnaker_src/ensemble_mess_data_core_1.c **** 6.95889971472,
 249:spinnaker_src/ensemble_mess_data_core_1.c **** 1.09773396599,
 250:spinnaker_src/ensemble_mess_data_core_1.c **** 6.82190098148,
 251:spinnaker_src/ensemble_mess_data_core_1.c **** -0.890009316752,
 252:spinnaker_src/ensemble_mess_data_core_1.c **** -19.1749316563,
 253:spinnaker_src/ensemble_mess_data_core_1.c **** 0.910456679377,
 254:spinnaker_src/ensemble_mess_data_core_1.c **** -19.4286670386,
 255:spinnaker_src/ensemble_mess_data_core_1.c **** -4.0362918371,
 256:spinnaker_src/ensemble_mess_data_core_1.c **** 2.57099551313,
 257:spinnaker_src/ensemble_mess_data_core_1.c **** -27.293849492,
 258:spinnaker_src/ensemble_mess_data_core_1.c **** 1.5933126895,
 259:spinnaker_src/ensemble_mess_data_core_1.c **** -10.4906381757,
 260:spinnaker_src/ensemble_mess_data_core_1.c **** -12.9596701127,
 261:spinnaker_src/ensemble_mess_data_core_1.c **** 2.25967028484,
 262:spinnaker_src/ensemble_mess_data_core_1.c **** 0.703550534464,
 263:spinnaker_src/ensemble_mess_data_core_1.c **** -9.17561788286,
 264:spinnaker_src/ensemble_mess_data_core_1.c **** -33.8357678505,
 265:spinnaker_src/ensemble_mess_data_core_1.c **** 12.8341934017,
 266:spinnaker_src/ensemble_mess_data_core_1.c **** -1764.22994273,
 267:spinnaker_src/ensemble_mess_data_core_1.c **** 6.48962841371,
 268:spinnaker_src/ensemble_mess_data_core_1.c **** 11.5351900956,
 269:spinnaker_src/ensemble_mess_data_core_1.c **** 7.35758420698,
 270:spinnaker_src/ensemble_mess_data_core_1.c **** 8.6522426403,
 271:spinnaker_src/ensemble_mess_data_core_1.c **** -33.4516789477,
 272:spinnaker_src/ensemble_mess_data_core_1.c **** -7.97013873027,
 273:spinnaker_src/ensemble_mess_data_core_1.c **** -47.7604200689,
 274:spinnaker_src/ensemble_mess_data_core_1.c **** -6.84631369953,
 275:spinnaker_src/ensemble_mess_data_core_1.c **** 0.649166527071,
 276:spinnaker_src/ensemble_mess_data_core_1.c **** 3.75269123624,
 277:spinnaker_src/ensemble_mess_data_core_1.c **** -7.47760581672,
 278:spinnaker_src/ensemble_mess_data_core_1.c **** -39.7562640938,
 279:spinnaker_src/ensemble_mess_data_core_1.c **** 8.51529903077,
 280:spinnaker_src/ensemble_mess_data_core_1.c **** 2.47323812598,
 281:spinnaker_src/ensemble_mess_data_core_1.c **** -1.28913634066,
 282:spinnaker_src/ensemble_mess_data_core_1.c **** 17.292309117,
 283:spinnaker_src/ensemble_mess_data_core_1.c **** -21.8847871336,
 284:spinnaker_src/ensemble_mess_data_core_1.c **** 0.155552550603,
 285:spinnaker_src/ensemble_mess_data_core_1.c **** 10.9212957955,
 286:spinnaker_src/ensemble_mess_data_core_1.c **** 4.16132472223,
 287:spinnaker_src/ensemble_mess_data_core_1.c **** 7.67566220811,
 288:spinnaker_src/ensemble_mess_data_core_1.c **** -33.1759864316,
 289:spinnaker_src/ensemble_mess_data_core_1.c **** 13.2811610062,
 290:spinnaker_src/ensemble_mess_data_core_1.c **** -58.3017699037,
 291:spinnaker_src/ensemble_mess_data_core_1.c **** 5.28271617713,
 292:spinnaker_src/ensemble_mess_data_core_1.c **** 12.7746444776,
 293:spinnaker_src/ensemble_mess_data_core_1.c **** -237.596085038,
 294:spinnaker_src/ensemble_mess_data_core_1.c **** -3.0665477982,
 295:spinnaker_src/ensemble_mess_data_core_1.c **** -6.8273985759,
 296:spinnaker_src/ensemble_mess_data_core_1.c **** -73.0572645097,
 297:spinnaker_src/ensemble_mess_data_core_1.c **** 6.55346659465,
 298:spinnaker_src/ensemble_mess_data_core_1.c **** -34.916796463,
 299:spinnaker_src/ensemble_mess_data_core_1.c **** 2.84347195067,
 300:spinnaker_src/ensemble_mess_data_core_1.c **** -19.4501272087,
 301:spinnaker_src/ensemble_mess_data_core_1.c **** -38.6430222359,
 302:spinnaker_src/ensemble_mess_data_core_1.c **** 7.60272797455,
 303:spinnaker_src/ensemble_mess_data_core_1.c **** 3.81928685061,
 304:spinnaker_src/ensemble_mess_data_core_1.c **** 4.47296355305,
 305:spinnaker_src/ensemble_mess_data_core_1.c **** -1.39728311585,
 306:spinnaker_src/ensemble_mess_data_core_1.c **** -65.3006376624
 307:spinnaker_src/ensemble_mess_data_core_1.c **** };
 308:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t decoders1[150*1]={
 309:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 310:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 311:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 312:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 313:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 314:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 315:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 316:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 317:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 318:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 319:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 320:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 321:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 322:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 323:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 324:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 325:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 326:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 327:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 328:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 329:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 330:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 331:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 332:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 333:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 334:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 335:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 336:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 337:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 338:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 339:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 340:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 341:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 342:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 343:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 344:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 345:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 346:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 347:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 348:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 349:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 350:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 351:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 352:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 353:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 354:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 355:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 356:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 357:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 358:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 359:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 360:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 361:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 362:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 363:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 364:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 365:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 366:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 367:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 368:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 369:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 370:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 371:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 372:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 373:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 374:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 375:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 376:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 377:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 378:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 379:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 380:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 381:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 382:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 383:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 384:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 385:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 386:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 387:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 388:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 389:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 390:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 391:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 392:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 393:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 394:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 395:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 396:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 397:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 398:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 399:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 400:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 401:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 402:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 403:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 404:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 405:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 406:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 407:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 408:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 409:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 410:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 411:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 412:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 413:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 414:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 415:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 416:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 417:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 418:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 419:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 420:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 421:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 422:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 423:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 424:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 425:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 426:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 427:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 428:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 429:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 430:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 431:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 432:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 433:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 434:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 435:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 436:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 437:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 438:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 439:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 440:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 441:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 442:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 443:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 444:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 445:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 446:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 447:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 448:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 449:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 450:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 451:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 452:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 453:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 454:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 455:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 456:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 457:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0,
 458:spinnaker_src/ensemble_mess_data_core_1.c **** 0.0
 459:spinnaker_src/ensemble_mess_data_core_1.c **** };
 460:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t inputs1[1];
 461:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t outputs1[1];
 462:spinnaker_src/ensemble_mess_data_core_1.c **** neuron_t neurons1[150];
 463:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t input_currents1[150];
 464:spinnaker_src/ensemble_mess_data_core_1.c **** REAL learning_activity1[150];
 465:spinnaker_src/ensemble_mess_data_core_1.c **** REAL error1[1];
 466:spinnaker_src/ensemble_mess_data_core_1.c **** REAL delta1[150];
 467:spinnaker_src/ensemble_mess_data_core_1.c **** ensemble_t ensembles[1];
 468:spinnaker_src/ensemble_mess_data_core_1.c **** uint32_t n_ensembles= 1;
 469:spinnaker_src/ensemble_mess_data_core_1.c **** void ensemble_init(){
  30              		.loc 1 469 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34 0000 2DE9F04F 		push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
  35              		.cfi_def_cfa_offset 36
  36              		.cfi_offset 4, -36
  37              		.cfi_offset 5, -32
  38              		.cfi_offset 6, -28
  39              		.cfi_offset 7, -24
  40              		.cfi_offset 8, -20
  41              		.cfi_offset 9, -16
  42              		.cfi_offset 10, -12
  43              		.cfi_offset 11, -8
  44              		.cfi_offset 14, -4
 470:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].encoders = encoders1;
  45              		.loc 1 470 0
  46 0004 1A4B     		ldr	r3, .L3
  47 0006 DFF888A0 		ldr	r10, .L3+32
 471:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].bias     = bias1;
  48              		.loc 1 471 0
  49 000a DFF88890 		ldr	r9, .L3+36
 472:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].decoders = decoders1;
  50              		.loc 1 472 0
  51 000e 194A     		ldr	r2, .L3+4
 473:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_inputs = 1;
 474:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_neurons= 150;
 475:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_outputs= 1;
 476:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].tau_rc   = 20.0;
 477:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].tau_ref  = 2.0;
 478:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].obj_id   = 1;
 479:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].inputs   = inputs1;
 480:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].outputs  = outputs1;
 481:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].neurons  = neurons1;
 482:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].input_currents= input_currents1;
 483:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_activity= learning_activity1;
 484:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_enabled = 1;
 485:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_rate = 0.000666666666667;
  52              		.loc 1 485 0
  53 0010 194D     		ldr	r5, .L3+8
 486:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_scale = 0.904837418036;
  54              		.loc 1 486 0
  55 0012 1A4C     		ldr	r4, .L3+12
 479:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].outputs  = outputs1;
  56              		.loc 1 479 0
  57 0014 DFF88080 		ldr	r8, .L3+40
 480:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].neurons  = neurons1;
  58              		.loc 1 480 0
  59 0018 DFF880C0 		ldr	ip, .L3+44
 481:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].input_currents= input_currents1;
  60              		.loc 1 481 0
  61 001c DFF880E0 		ldr	lr, .L3+48
 482:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_activity= learning_activity1;
  62              		.loc 1 482 0
  63 0020 174F     		ldr	r7, .L3+16
 483:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_enabled = 1;
  64              		.loc 1 483 0
  65 0022 184E     		ldr	r6, .L3+20
 487:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].error = error1;
  66              		.loc 1 487 0
  67 0024 1848     		ldr	r0, .L3+24
 488:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].delta = delta1;
  68              		.loc 1 488 0
  69 0026 1949     		ldr	r1, .L3+28
 470:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].bias     = bias1;
  70              		.loc 1 470 0
  71 0028 C3F800A0 		str	r10, [r3]
 474:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_outputs= 1;
  72              		.loc 1 474 0
  73 002c 4FF0960B 		mov	fp, #150
 476:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].tau_ref  = 2.0;
  74              		.loc 1 476 0
  75 0030 DFF870A0 		ldr	r10, .L3+52
 471:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].decoders = decoders1;
  76              		.loc 1 471 0
  77 0034 C3F80490 		str	r9, [r3, #4]
 472:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_inputs = 1;
  78              		.loc 1 472 0
  79 0038 9A60     		str	r2, [r3, #8]
 477:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].obj_id   = 1;
  80              		.loc 1 477 0
  81 003a 4FF08049 		mov	r9, #1073741824
 473:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_neurons= 150;
  82              		.loc 1 473 0
  83 003e 0122     		movs	r2, #1
 474:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_outputs= 1;
  84              		.loc 1 474 0
  85 0040 C3F810B0 		str	fp, [r3, #16]
 476:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].tau_ref  = 2.0;
  86              		.loc 1 476 0
  87 0044 C3F818A0 		str	r10, [r3, #24]	@ float
 477:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].obj_id   = 1;
  88              		.loc 1 477 0
  89 0048 C3F81C90 		str	r9, [r3, #28]	@ float
 479:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].outputs  = outputs1;
  90              		.loc 1 479 0
  91 004c C3F82480 		str	r8, [r3, #36]
 480:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].neurons  = neurons1;
  92              		.loc 1 480 0
  93 0050 C3F828C0 		str	ip, [r3, #40]
 481:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].input_currents= input_currents1;
  94              		.loc 1 481 0
  95 0054 C3F82CE0 		str	lr, [r3, #44]
 482:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_activity= learning_activity1;
  96              		.loc 1 482 0
  97 0058 1F63     		str	r7, [r3, #48]
 483:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_enabled = 1;
  98              		.loc 1 483 0
  99 005a DE63     		str	r6, [r3, #60]
 485:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_scale = 0.904837418036;
 100              		.loc 1 485 0
 101 005c 5D63     		str	r5, [r3, #52]	@ float
 486:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].error = error1;
 102              		.loc 1 486 0
 103 005e 9C63     		str	r4, [r3, #56]	@ float
 487:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].delta = delta1;
 104              		.loc 1 487 0
 105 0060 5864     		str	r0, [r3, #68]
 106              		.loc 1 488 0
 107 0062 9964     		str	r1, [r3, #72]
 473:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].n_neurons= 150;
 108              		.loc 1 473 0
 109 0064 DA60     		str	r2, [r3, #12]
 475:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].tau_rc   = 20.0;
 110              		.loc 1 475 0
 111 0066 5A61     		str	r2, [r3, #20]
 478:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].inputs   = inputs1;
 112              		.loc 1 478 0
 113 0068 1A62     		str	r2, [r3, #32]
 484:spinnaker_src/ensemble_mess_data_core_1.c **** ensembles[0].learning_rate = 0.000666666666667;
 114              		.loc 1 484 0
 115 006a 1A64     		str	r2, [r3, #64]
 116 006c BDE8F08F 		pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
 117              	.L4:
 118              		.align	2
 119              	.L3:
 120 0070 00000000 		.word	ensembles
 121 0074 00000000 		.word	.LANCHOR2
 122 0078 3EC32E3A 		.word	976143166
 123 007c 6DA3673F 		.word	1063756653
 124 0080 00000000 		.word	input_currents1
 125 0084 00000000 		.word	learning_activity1
 126 0088 00000000 		.word	error1
 127 008c 00000000 		.word	delta1
 128 0090 00000000 		.word	.LANCHOR0
 129 0094 00000000 		.word	.LANCHOR1
 130 0098 00000000 		.word	inputs1
 131 009c 00000000 		.word	outputs1
 132 00a0 00000000 		.word	neurons1
 133 00a4 0000A041 		.word	1101004800
 134              		.cfi_endproc
 135              	.LFE156:
 137              		.section	.text.mess_init,"ax",%progbits
 138              		.align	2
 139              		.global	mess_init
 140              		.thumb
 141              		.thumb_func
 143              	mess_init:
 144              	.LFB157:
 489:spinnaker_src/ensemble_mess_data_core_1.c **** }
 490:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t pre_values3[1];
 491:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t post_values3[1];
 492:spinnaker_src/ensemble_mess_data_core_1.c **** precision_t matrix3[1*1]={
 493:spinnaker_src/ensemble_mess_data_core_1.c **** 1.0
 494:spinnaker_src/ensemble_mess_data_core_1.c **** };
 495:spinnaker_src/ensemble_mess_data_core_1.c **** message_t mess[1];
 496:spinnaker_src/ensemble_mess_data_core_1.c **** uint32_t n_mess= 1;
 497:spinnaker_src/ensemble_mess_data_core_1.c **** void mess_init(){
 145              		.loc 1 497 0
 146              		.cfi_startproc
 147              		@ args = 0, pretend = 0, frame = 0
 148              		@ frame_needed = 0, uses_anonymous_args = 0
 149              		@ link register save eliminated.
 150 0000 F0B4     		push	{r4, r5, r6, r7}
 151              		.cfi_def_cfa_offset 16
 152              		.cfi_offset 4, -16
 153              		.cfi_offset 5, -12
 154              		.cfi_offset 6, -8
 155              		.cfi_offset 7, -4
 498:spinnaker_src/ensemble_mess_data_core_1.c **** 
 499:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_obj_id = 3;
 156              		.loc 1 499 0
 157 0002 0C4B     		ldr	r3, .L7
 500:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_start  = 0;
 501:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_len    = 1;
 502:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_obj_id= 1;
 503:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_start = 0;
 504:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_len   = 1;
 505:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].mess_id    = 3;
 506:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].use_synapse_scale= 0;
 507:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].synapse_scale= 0;
 508:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_values = pre_values3;
 158              		.loc 1 508 0
 159 0004 0C4F     		ldr	r7, .L7+4
 509:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_values = post_values3;
 160              		.loc 1 509 0
 161 0006 0D4E     		ldr	r6, .L7+8
 510:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].ens_input = &inputs1[0];
 162              		.loc 1 510 0
 163 0008 0D4D     		ldr	r5, .L7+12
 511:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].matrix      = matrix3;
 164              		.loc 1 511 0
 165 000a 0E4C     		ldr	r4, .L7+16
 508:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_values = post_values3;
 166              		.loc 1 508 0
 167 000c 5F62     		str	r7, [r3, #36]
 507:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_values = pre_values3;
 168              		.loc 1 507 0
 169 000e 0022     		movs	r2, #0
 500:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_len    = 1;
 170              		.loc 1 500 0
 171 0010 0021     		movs	r1, #0
 499:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_start  = 0;
 172              		.loc 1 499 0
 173 0012 0320     		movs	r0, #3
 507:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_values = pre_values3;
 174              		.loc 1 507 0
 175 0014 1A62     		str	r2, [r3, #32]	@ float
 501:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_obj_id= 1;
 176              		.loc 1 501 0
 177 0016 0122     		movs	r2, #1
 509:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].ens_input = &inputs1[0];
 178              		.loc 1 509 0
 179 0018 9E62     		str	r6, [r3, #40]
 510:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].matrix      = matrix3;
 180              		.loc 1 510 0
 181 001a DD62     		str	r5, [r3, #44]
 182              		.loc 1 511 0
 183 001c 1C63     		str	r4, [r3, #48]
 499:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_start  = 0;
 184              		.loc 1 499 0
 185 001e 1860     		str	r0, [r3]
 505:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].use_synapse_scale= 0;
 186              		.loc 1 505 0
 187 0020 9861     		str	r0, [r3, #24]
 500:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].pre_len    = 1;
 188              		.loc 1 500 0
 189 0022 5960     		str	r1, [r3, #4]
 503:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_len   = 1;
 190              		.loc 1 503 0
 191 0024 1961     		str	r1, [r3, #16]
 506:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].synapse_scale= 0;
 192              		.loc 1 506 0
 193 0026 D961     		str	r1, [r3, #28]
 501:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_obj_id= 1;
 194              		.loc 1 501 0
 195 0028 9A60     		str	r2, [r3, #8]
 502:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].post_start = 0;
 196              		.loc 1 502 0
 197 002a DA60     		str	r2, [r3, #12]
 504:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].mess_id    = 3;
 198              		.loc 1 504 0
 199 002c 5A61     		str	r2, [r3, #20]
 512:spinnaker_src/ensemble_mess_data_core_1.c **** mess[0].matrix_is_scalar = 1;
 200              		.loc 1 512 0
 201 002e 5A63     		str	r2, [r3, #52]
 513:spinnaker_src/ensemble_mess_data_core_1.c **** }
 202              		.loc 1 513 0
 203 0030 F0BC     		pop	{r4, r5, r6, r7}
 204              		.cfi_restore 7
 205              		.cfi_restore 6
 206              		.cfi_restore 5
 207              		.cfi_restore 4
 208              		.cfi_def_cfa_offset 0
 209 0032 7047     		bx	lr
 210              	.L8:
 211              		.align	2
 212              	.L7:
 213 0034 00000000 		.word	mess
 214 0038 00000000 		.word	pre_values3
 215 003c 00000000 		.word	post_values3
 216 0040 00000000 		.word	inputs1
 217 0044 00000000 		.word	.LANCHOR3
 218              		.cfi_endproc
 219              	.LFE157:
 221              		.global	n_mess
 222              		.comm	mess,60,4
 223              		.global	matrix3
 224              		.comm	post_values3,4,4
 225              		.comm	pre_values3,4,4
 226              		.global	n_ensembles
 227              		.comm	ensembles,80,4
 228              		.comm	delta1,600,4
 229              		.comm	error1,4,4
 230              		.comm	learning_activity1,600,4
 231              		.comm	input_currents1,600,4
 232              		.comm	neurons1,1200,4
 233              		.comm	outputs1,4,4
 234              		.comm	inputs1,4,4
 235              		.global	decoders1
 236              		.global	bias1
 237              		.global	encoders1
 238              		.section	.data.n_mess,"aw",%progbits
 239              		.align	2
 242              	n_mess:
 243 0000 01000000 		.word	1
 244              		.section	.data.bias1,"aw",%progbits
 245              		.align	2
 246              		.set	.LANCHOR1,. + 0
 249              	bias1:
 250 0000 45B66840 		.word	1080604229
 251 0004 CD630240 		.word	1073898445
 252 0008 4DDEC8BC 		.word	3167280717
 253 000c 40EB8B41 		.word	1099688768
 254 0010 1A54963F 		.word	1066816538
 255 0014 F21CB640 		.word	1085676786
 256 0018 4204AFC0 		.word	3232695362
 257 001c 96F9FA3C 		.word	1023080854
 258 0020 129A6BBF 		.word	3211500050
 259 0024 A081A8C1 		.word	3249045920
 260 0028 5864F73E 		.word	1056400472
 261 002c E0707640 		.word	1081503968
 262 0030 76838340 		.word	1082360694
 263 0034 453E0141 		.word	1090600517
 264 0038 0A477440 		.word	1081362186
 265 003c 0A932241 		.word	1092784906
 266 0040 404C0041 		.word	1090538560
 267 0044 7ED199C1 		.word	3248083326
 268 0048 FD9FB7BF 		.word	3216482301
 269 004c 2ABC8CC2 		.word	3264003114
 270 0050 49EC1941 		.word	1092217929
 271 0054 16F99840 		.word	1083767062
 272 0058 DBE11140 		.word	1074913755
 273 005c B0E31CC2 		.word	3256673200
 274 0060 46719FC1 		.word	3248451910
 275 0064 A1BCD33F 		.word	1070840993
 276 0068 04BAD0C2 		.word	3268459012
 277 006c 20F74841 		.word	1095300896
 278 0070 2A28F0C0 		.word	3236964394
 279 0074 09C4B3C1 		.word	3249783817
 280 0078 EA3E07C2 		.word	3255254762
 281 007c 7C316E40 		.word	1080963452
 282 0080 0AD68F40 		.word	1083168266
 283 0084 5A89B1C2 		.word	3266414938
 284 0088 7395D8C2 		.word	3268973939
 285 008c 57C73340 		.word	1077135191
 286 0090 6D7BDF40 		.word	1088387949
 287 0094 ADE695C2 		.word	3264603821
 288 0098 EBEAA0C3 		.word	3282103019
 289 009c 780E8740 		.word	1082592888
 290 00a0 4B369340 		.word	1083389515
 291 00a4 DF373EC0 		.word	3225303007
 292 00a8 05784AC2 		.word	3259660293
 293 00ac 2F0AB240 		.word	1085409839
 294 00b0 C6228F40 		.word	1083122374
 295 00b4 1C49DA3F 		.word	1071270172
 296 00b8 2D340E40 		.word	1074672685
 297 00bc D7048240 		.word	1082262743
 298 00c0 B0BE10C2 		.word	3255877296
 299 00c4 7FDA19C2 		.word	3256474239
 300 00c8 90938840 		.word	1082692496
 301 00cc E8C7CE40 		.word	1087293416
 302 00d0 B65A983C 		.word	1016617654
 303 00d4 F67783C0 		.word	3229841398
 304 00d8 516C7340 		.word	1081306193
 305 00dc 3596A940 		.word	1084855861
 306 00e0 EB2C7940 		.word	1081683179
 307 00e4 13BA9040 		.word	1083226643
 308 00e8 1E0D7040 		.word	1081085214
 309 00ec AF18F940 		.word	1090066607
 310 00f0 08E6AB40 		.word	1085007368
 311 00f4 0C482CC1 		.word	3240904716
 312 00f8 55789D40 		.word	1084061781
 313 00fc B8AD0B41 		.word	1091284408
 314 0100 5C461940 		.word	1075398236
 315 0104 3BF03B41 		.word	1094447163
 316 0108 24E8F2BF 		.word	3220367396
 317 010c D9092740 		.word	1076300249
 318 0110 EDE0DBC2 		.word	3269189869
 319 0114 CA06A0C1 		.word	3248490186
 320 0118 6FF88AC0 		.word	3230333039
 321 011c 8C877441 		.word	1098155916
 322 0120 B0451B41 		.word	1092306352
 323 0124 D6719E3F 		.word	1067348438
 324 0128 69923FC2 		.word	3258946153
 325 012c 21AAB6C2 		.word	3266751009
 326 0130 6C6AD140 		.word	1087466092
 327 0134 519B08C1 		.word	3238566737
 328 0138 41FCA2C2 		.word	3265461313
 329 013c AFD7A9C1 		.word	3249133487
 330 0140 8C0D97C1 		.word	3247902092
 331 0144 19C49740 		.word	1083687961
 332 0148 26282D40 		.word	1076701222
 333 014c F9B42641 		.word	1093055737
 334 0150 BB0B7740 		.word	1081543611
 335 0154 A1C93CC2 		.word	3258763681
 336 0158 C66D86C0 		.word	3230035398
 337 015c DB19A8C2 		.word	3265796571
 338 0160 8C3C8940 		.word	1082735756
 339 0164 8329973F 		.word	1066871171
 340 0168 686E53C0 		.word	3226693224
 341 016c 4EAFDE40 		.word	1088335694
 342 0170 8C828C3F 		.word	1066173068
 343 0174 034DDA40 		.word	1088048387
 344 0178 A7D763BF 		.word	3210991527
 345 017c 436699C1 		.word	3248055875
 346 0180 B013693F 		.word	1063850928
 347 0184 E96D9BC1 		.word	3248188905
 348 0188 4D2981C0 		.word	3229690189
 349 018c 318B2440 		.word	1076136753
 350 0190 CE59DAC1 		.word	3252312526
 351 0194 ACF1CB3F 		.word	1070330284
 352 0198 A7D927C1 		.word	3240614311
 353 019c CF5A4FC1 		.word	3243203279
 354 01a0 709E1040 		.word	1074830960
 355 01a4 E31B343F 		.word	1060379619
 356 01a8 55CF12C1 		.word	3239235413
 357 01ac D45707C2 		.word	3255261140
 358 01b0 DB584D41 		.word	1095588059
 359 01b4 5C87DCC4 		.word	3302786908
 360 01b8 09ABCF40 		.word	1087351561
 361 01bc 23903841 		.word	1094225955
 362 01c0 5471EB40 		.word	1089171796
 363 01c4 966F0A41 		.word	1091202966
 364 01c8 85CE05C2 		.word	3255160453
 365 01cc 600BFFC0 		.word	3237940064
 366 01d0 AC0A3FC2 		.word	3258911404
 367 01d4 0015DBC0 		.word	3235583232
 368 01d8 C72F263F 		.word	1059467207
 369 01dc 182C7040 		.word	1081093144
 370 01e0 8C48EFC0 		.word	3236907148
 371 01e4 6A061FC2 		.word	3256813162
 372 01e8 AA3E0841 		.word	1091059370
 373 01ec 89491E40 		.word	1075726729
 374 01f0 6B02A5BF 		.word	3215262315
 375 01f4 A6568A41 		.word	1099585190
 376 01f8 0B14AFC1 		.word	3249476619
 377 01fc 2B491F3E 		.word	1042237739
 378 0200 A1BD2E41 		.word	1093582241
 379 0204 92298540 		.word	1082468754
 380 0208 069FF540 		.word	1089838854
 381 020c 36B404C2 		.word	3255088182
 382 0210 A37F5441 		.word	1096056739
 383 0214 033569C2 		.word	3261674755
 384 0218 030CA940 		.word	1084820483
 385 021c F2644C41 		.word	1095525618
 386 0220 99986DC3 		.word	3278739609
 387 0224 524244C0 		.word	3225698898
 388 0228 0D7ADAC0 		.word	3235543565
 389 022c 521D92C2 		.word	3264355666
 390 0230 00B6D140 		.word	1087485440
 391 0234 CDAA0BC2 		.word	3255544525
 392 0238 72FB3540 		.word	1077279602
 393 023c DC999BC1 		.word	3248200156
 394 0240 74921AC2 		.word	3256521332
 395 0244 8C49F340 		.word	1089685900
 396 0248 326F7440 		.word	1081372466
 397 024c 84228F40 		.word	1083122308
 398 0250 2CDAB2BF 		.word	3216169516
 399 0254 ED9982C2 		.word	3263338989
 400              		.section	.data.n_ensembles,"aw",%progbits
 401              		.align	2
 404              	n_ensembles:
 405 0000 01000000 		.word	1
 406              		.section	.bss.decoders1,"aw",%nobits
 407              		.align	2
 408              		.set	.LANCHOR2,. + 0
 411              	decoders1:
 412 0000 00000000 		.space	600
 412      00000000 
 412      00000000 
 412      00000000 
 412      00000000 
 413              		.section	.data.encoders1,"aw",%progbits
 414              		.align	2
 415              		.set	.LANCHOR0,. + 0
 418              	encoders1:
 419 0000 A4920BC1 		.word	3238761124
 420 0004 CBA3FD41 		.word	1107141579
 421 0008 18784BC1 		.word	3242948632
 422 000c E46D9D41 		.word	1100836324
 423 0010 D9F20541 		.word	1090908889
 424 0014 6C791041 		.word	1091598700
 425 0018 4A68AD41 		.word	1101883466
 426 001c 4BB78BC1 		.word	3247159115
 427 0020 8A306241 		.word	1096953994
 428 0024 7B4D1642 		.word	1108757883
 429 0028 42491D41 		.word	1092438338
 430 002c E3BBD6C0 		.word	3235298275
 431 0030 E8FA7C40 		.word	1081932520
 432 0034 08E907C1 		.word	3238521096
 433 0038 1D9B36C1 		.word	3241581341
 434 003c 7E97DAC1 		.word	3252328318
 435 0040 EE0A8C41 		.word	1099696878
 436 0044 A2F52242 		.word	1109587362
 437 0048 28464841 		.word	1095255592
 438 004c E4EDA0C2 		.word	3265326564
 439 0050 6F4C3CC1 		.word	3241954415
 440 0054 D515A9C0 		.word	3232306645
 441 0058 3A94B8C0 		.word	3233322042
 442 005c 03944CC2 		.word	3259798531
 443 0060 6D1A13C2 		.word	3256031853
 444 0064 B76A0141 		.word	1090611895
 445 0068 D5C3E142 		.word	1122091989
 446 006c 5D838A41 		.word	1099596637
 447 0070 AE1CB0C1 		.word	3249544366
 448 0074 CC93EDC1 		.word	3253572556
 449 0078 BD253142 		.word	1110517181
 450 007c 38517E40 		.word	1082020152
 451 0080 E6E4C240 		.word	1086514406
 452 0084 580CCDC2 		.word	3268217944
 453 0088 7277EA42 		.word	1122662258
 454 008c DC6200C2 		.word	3254805212
 455 0090 0CC3F3C0 		.word	3237200652
 456 0094 BA0DD142 		.word	1120996794
 457 0098 D2A6AEC3 		.word	3283003090
 458 009c C39B8BC0 		.word	3230374851
 459 00a0 6BC06940 		.word	1080672363
 460 00a4 B634A141 		.word	1101083830
 461 00a8 729668C2 		.word	3261634162
 462 00ac A113A1C1 		.word	3248559009
 463 00b0 F95FEC40 		.word	1089232889
 464 00b4 DE6EA6C1 		.word	3248910046
 465 00b8 76EDECC0 		.word	3236752758
 466 00bc 9CF6F340 		.word	1089730204
 467 00c0 37B15FC2 		.word	3261051191
 468 00c4 376042C2 		.word	3259129911
 469 00c8 6BDFB1C0 		.word	3232882539
 470 00cc 94C0B9C0 		.word	3233398932
 471 00d0 7EF7E740 		.word	1088943998
 472 00d4 D410D0C1 		.word	3251638484
 473 00d8 F88D9740 		.word	1083674104
 474 00dc EF549EC0 		.word	3231601903
 475 00e0 C2E47FC0 		.word	3229607106
 476 00e4 26F51A41 		.word	1092285734
 477 00e8 7802E440 		.word	1088684664
 478 00ec 3C8B0141 		.word	1090620220
 479 00f0 63B876C1 		.word	3245783139
 480 00f4 FD66A3C1 		.word	3248711421
 481 00f8 99A8DF40 		.word	1088399513
 482 00fc AF890741 		.word	1091013039
 483 0100 B82EFFC0 		.word	3237949112
 484 0104 96F0ABC1 		.word	3249270934
 485 0108 BE511841 		.word	1092112830
 486 010c AE45CDC0 		.word	3234678190
 487 0110 9D5DF2C2 		.word	3270663581
 488 0114 FF222442 		.word	1109664511
 489 0118 0D6749C1 		.word	3242813197
 490 011c EF097F41 		.word	1098844655
 491 0120 C353B641 		.word	1102468035
 492 0124 25BA9441 		.word	1100266021
 493 0128 45357342 		.word	1114846533
 494 012c 129BCC42 		.word	1120705298
 495 0130 01A6B2C0 		.word	3232933377
 496 0134 8C611DC2 		.word	3256705420
 497 0138 0994C3C2 		.word	3267597321
 498 013c 3ADF5DC2 		.word	3260931898
 499 0140 E2810942 		.word	1107919330
 500 0144 6BE2A440 		.word	1084547691
 501 0148 F358B3C0 		.word	3232979187
 502 014c 1DC12441 		.word	1092927773
 503 0150 C5F4EBC0 		.word	3236689093
 504 0154 871F85C2 		.word	3263504263
 505 0158 29821AC2 		.word	3256517161
 506 015c 80D9B6C2 		.word	3266763136
 507 0160 8C096140 		.word	1080101260
 508 0164 AD7E2C41 		.word	1093435053
 509 0168 67896CC1 		.word	3245115751
 510 016c 5259C040 		.word	1086347602
 511 0170 767F5141 		.word	1095860086
 512 0174 5A79D440 		.word	1087666522
 513 0178 093C1341 		.word	1091779593
 514 017c 77DBF8C1 		.word	3254311799
 515 0180 010EF7C0 		.word	3237416449
 516 0184 7A4AEA41 		.word	1105873530
 517 0188 9132B141 		.word	1102131857
 518 018c 3F98A5C0 		.word	3232077887
 519 0190 1ACE19C2 		.word	3256471066
 520 0194 A0078541 		.word	1099237280
 521 0198 411FAA41 		.word	1101668161
 522 019c 66EFE7C1 		.word	3253202790
 523 01a0 8B453EC1 		.word	3242083723
 524 01a4 EBED90C1 		.word	3247500779
 525 01a8 803417C2 		.word	3256300672
 526 01ac AE7E33C2 		.word	3258154670
 527 01b0 2D739141 		.word	1100051245
 528 01b4 BA00DF44 		.word	1155465402
 529 01b8 1A1ADFC0 		.word	3235846682
 530 01bc 8C7D6AC1 		.word	3244981644
 531 01c0 77F5D240 		.word	1087567223
 532 01c4 E9A63FC1 		.word	3242174185
 533 01c8 BC7F7F42 		.word	1115652028
 534 01cc B8A69DC1 		.word	3248334520
 535 01d0 FF3C7A42 		.word	1115307263
 536 01d4 E4E3A0C1 		.word	3248546788
 537 01d8 419DFD40 		.word	1090362689
 538 01dc FC6395C0 		.word	3231015932
 539 01e0 316D7EC1 		.word	3246288177
 540 01e4 72698C42 		.word	1116498290
 541 01e8 D4C6BA41 		.word	1102759636
 542 01ec 0B571941 		.word	1092179723
 543 01f0 9DA301C2 		.word	3254887325
 544 01f4 8F1B8FC1 		.word	3247381391
 545 01f8 BD9C38C2 		.word	3258490045
 546 01fc 2D2122C1 		.word	3240239405
 547 0200 082626C1 		.word	3240502792
 548 0204 1BA8D340 		.word	1087612955
 549 0208 D879AF41 		.word	1102019032
 550 020c 1BFE8542 		.word	1116077595
 551 0210 AD8ECF41 		.word	1104121517
 552 0214 B314A342 		.word	1117983923
 553 0218 C8F8A0C0 		.word	3231774920
 554 021c 85B662C1 		.word	3244471941
 555 0220 33997743 		.word	1131911475
 556 0224 08393AC1 		.word	3241818376
 557 0228 72787D41 		.word	1098741874
 558 022c 9239A7C2 		.word	3265739154
 559 0230 B71F3441 		.word	1093935031
 560 0234 EFA676C2 		.word	3262555887
 561 0238 43D9F640 		.word	1089919299
 562 023c F70C12C2 		.word	3255962871
 563 0240 BC4E8BC2 		.word	3263909564
 564 0244 83BAE0C0 		.word	3235953283
 565 0248 011677C0 		.word	3229029889
 566 024c B05C43C1 		.word	3242417328
 567 0250 4C2B0D42 		.word	1108159308
 568 0254 D3569DC2 		.word	3265091283
 569              		.section	.data.matrix3,"aw",%progbits
 570              		.align	2
 571              		.set	.LANCHOR3,. + 0
 574              	matrix3:
 575 0000 0000803F 		.word	1065353216
 576              		.text
 577              	.Letext0:
 578              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 579              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 580              		.file 4 "spinnaker_src/common/maths-util.h"
 581              		.file 5 "spinnaker_src/param_defs.h"
 582              		.file 6 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 583              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 584              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
