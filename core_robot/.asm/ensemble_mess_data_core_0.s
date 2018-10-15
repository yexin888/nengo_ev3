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
  17              		.file	"ensemble_mess_data_core_0.c"
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
  29              		.file 1 "spinnaker_src/ensemble_mess_data_core_0.c"
   1:spinnaker_src/ensemble_mess_data_core_0.c **** #include "qpe.h"
   2:spinnaker_src/ensemble_mess_data_core_0.c **** #include "common/neuron-typedefs.h"
   3:spinnaker_src/ensemble_mess_data_core_0.c **** #include "param_defs.h"
   4:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t encoders0[1*150]={
   5:spinnaker_src/ensemble_mess_data_core_0.c **** 17.8435005637,
   6:spinnaker_src/ensemble_mess_data_core_0.c **** 45.2190536264,
   7:spinnaker_src/ensemble_mess_data_core_0.c **** 22.0806677133,
   8:spinnaker_src/ensemble_mess_data_core_0.c **** -31.9157863308,
   9:spinnaker_src/ensemble_mess_data_core_0.c **** 12.2557837931,
  10:spinnaker_src/ensemble_mess_data_core_0.c **** 86.9902780325,
  11:spinnaker_src/ensemble_mess_data_core_0.c **** 4.09272716526,
  12:spinnaker_src/ensemble_mess_data_core_0.c **** -14.2811644409,
  13:spinnaker_src/ensemble_mess_data_core_0.c **** 5.26211255113,
  14:spinnaker_src/ensemble_mess_data_core_0.c **** -26.174307124,
  15:spinnaker_src/ensemble_mess_data_core_0.c **** 11.9139657349,
  16:spinnaker_src/ensemble_mess_data_core_0.c **** 89.8190210171,
  17:spinnaker_src/ensemble_mess_data_core_0.c **** -29.352205408,
  18:spinnaker_src/ensemble_mess_data_core_0.c **** 16.2189809742,
  19:spinnaker_src/ensemble_mess_data_core_0.c **** -18.201487122,
  20:spinnaker_src/ensemble_mess_data_core_0.c **** -10.5329554314,
  21:spinnaker_src/ensemble_mess_data_core_0.c **** -26.4884240032,
  22:spinnaker_src/ensemble_mess_data_core_0.c **** -9.71814864562,
  23:spinnaker_src/ensemble_mess_data_core_0.c **** 17.9143105118,
  24:spinnaker_src/ensemble_mess_data_core_0.c **** 26.1211346549,
  25:spinnaker_src/ensemble_mess_data_core_0.c **** 5.60095038301,
  26:spinnaker_src/ensemble_mess_data_core_0.c **** 4.57144110645,
  27:spinnaker_src/ensemble_mess_data_core_0.c **** -4.18902316305,
  28:spinnaker_src/ensemble_mess_data_core_0.c **** 3.97833104745,
  29:spinnaker_src/ensemble_mess_data_core_0.c **** -54.0632161838,
  30:spinnaker_src/ensemble_mess_data_core_0.c **** -15.5412197658,
  31:spinnaker_src/ensemble_mess_data_core_0.c **** -7.35481300707,
  32:spinnaker_src/ensemble_mess_data_core_0.c **** 3.64889015709,
  33:spinnaker_src/ensemble_mess_data_core_0.c **** -19.7405166936,
  34:spinnaker_src/ensemble_mess_data_core_0.c **** 11.2876666129,
  35:spinnaker_src/ensemble_mess_data_core_0.c **** 10.8890236826,
  36:spinnaker_src/ensemble_mess_data_core_0.c **** -14.972117378,
  37:spinnaker_src/ensemble_mess_data_core_0.c **** 27.534587979,
  38:spinnaker_src/ensemble_mess_data_core_0.c **** 25.3488774064,
  39:spinnaker_src/ensemble_mess_data_core_0.c **** -19.8382518554,
  40:spinnaker_src/ensemble_mess_data_core_0.c **** 11.94189634,
  41:spinnaker_src/ensemble_mess_data_core_0.c **** -11.196792614,
  42:spinnaker_src/ensemble_mess_data_core_0.c **** 13.9155130339,
  43:spinnaker_src/ensemble_mess_data_core_0.c **** 21.9109727797,
  44:spinnaker_src/ensemble_mess_data_core_0.c **** 7.23964429545,
  45:spinnaker_src/ensemble_mess_data_core_0.c **** 21.707891831,
  46:spinnaker_src/ensemble_mess_data_core_0.c **** 18.3006036563,
  47:spinnaker_src/ensemble_mess_data_core_0.c **** 38.5016074605,
  48:spinnaker_src/ensemble_mess_data_core_0.c **** -10.1777793265,
  49:spinnaker_src/ensemble_mess_data_core_0.c **** 5.57288289311,
  50:spinnaker_src/ensemble_mess_data_core_0.c **** -12.0977657136,
  51:spinnaker_src/ensemble_mess_data_core_0.c **** 21.1423325341,
  52:spinnaker_src/ensemble_mess_data_core_0.c **** -22.5449060257,
  53:spinnaker_src/ensemble_mess_data_core_0.c **** 21.8264211334,
  54:spinnaker_src/ensemble_mess_data_core_0.c **** -36.4390337017,
  55:spinnaker_src/ensemble_mess_data_core_0.c **** 18.8846913053,
  56:spinnaker_src/ensemble_mess_data_core_0.c **** -37.6905287923,
  57:spinnaker_src/ensemble_mess_data_core_0.c **** -12.5226238975,
  58:spinnaker_src/ensemble_mess_data_core_0.c **** 4.11602405292,
  59:spinnaker_src/ensemble_mess_data_core_0.c **** -12.8998056481,
  60:spinnaker_src/ensemble_mess_data_core_0.c **** -301.556292656,
  61:spinnaker_src/ensemble_mess_data_core_0.c **** -8.84365399446,
  62:spinnaker_src/ensemble_mess_data_core_0.c **** 7.0336270326,
  63:spinnaker_src/ensemble_mess_data_core_0.c **** -19.2013140551,
  64:spinnaker_src/ensemble_mess_data_core_0.c **** 29.1785854976,
  65:spinnaker_src/ensemble_mess_data_core_0.c **** -13.8944442407,
  66:spinnaker_src/ensemble_mess_data_core_0.c **** 21.1613680457,
  67:spinnaker_src/ensemble_mess_data_core_0.c **** -6.71492983831,
  68:spinnaker_src/ensemble_mess_data_core_0.c **** -31.6546364716,
  69:spinnaker_src/ensemble_mess_data_core_0.c **** 47.454742742,
  70:spinnaker_src/ensemble_mess_data_core_0.c **** -65.8627576255,
  71:spinnaker_src/ensemble_mess_data_core_0.c **** 13.8180164716,
  72:spinnaker_src/ensemble_mess_data_core_0.c **** 6.35148732016,
  73:spinnaker_src/ensemble_mess_data_core_0.c **** 84.9651214418,
  74:spinnaker_src/ensemble_mess_data_core_0.c **** -35.6385103511,
  75:spinnaker_src/ensemble_mess_data_core_0.c **** 10.0734827631,
  76:spinnaker_src/ensemble_mess_data_core_0.c **** 9.86857513866,
  77:spinnaker_src/ensemble_mess_data_core_0.c **** -115.17399145,
  78:spinnaker_src/ensemble_mess_data_core_0.c **** 16.7016114728,
  79:spinnaker_src/ensemble_mess_data_core_0.c **** 35.593978353,
  80:spinnaker_src/ensemble_mess_data_core_0.c **** 20.5478211552,
  81:spinnaker_src/ensemble_mess_data_core_0.c **** -47.4996204236,
  82:spinnaker_src/ensemble_mess_data_core_0.c **** 28.4410254203,
  83:spinnaker_src/ensemble_mess_data_core_0.c **** 32.7900488115,
  84:spinnaker_src/ensemble_mess_data_core_0.c **** -10.775878669,
  85:spinnaker_src/ensemble_mess_data_core_0.c **** -10.299114567,
  86:spinnaker_src/ensemble_mess_data_core_0.c **** -51.0085356701,
  87:spinnaker_src/ensemble_mess_data_core_0.c **** 5.61867250304,
  88:spinnaker_src/ensemble_mess_data_core_0.c **** 4.66288122812,
  89:spinnaker_src/ensemble_mess_data_core_0.c **** -11.0557053077,
  90:spinnaker_src/ensemble_mess_data_core_0.c **** -38.7091589744,
  91:spinnaker_src/ensemble_mess_data_core_0.c **** 5.82242720428,
  92:spinnaker_src/ensemble_mess_data_core_0.c **** 10.0979599238,
  93:spinnaker_src/ensemble_mess_data_core_0.c **** 33.578829557,
  94:spinnaker_src/ensemble_mess_data_core_0.c **** 36.1351792883,
  95:spinnaker_src/ensemble_mess_data_core_0.c **** 61.7521556743,
  96:spinnaker_src/ensemble_mess_data_core_0.c **** -18.0103705523,
  97:spinnaker_src/ensemble_mess_data_core_0.c **** 22.0215018627,
  98:spinnaker_src/ensemble_mess_data_core_0.c **** -81.7175427291,
  99:spinnaker_src/ensemble_mess_data_core_0.c **** -17.2566588195,
 100:spinnaker_src/ensemble_mess_data_core_0.c **** 23.9854204177,
 101:spinnaker_src/ensemble_mess_data_core_0.c **** 13.7613048069,
 102:spinnaker_src/ensemble_mess_data_core_0.c **** 18.9134507753,
 103:spinnaker_src/ensemble_mess_data_core_0.c **** 12.8031442053,
 104:spinnaker_src/ensemble_mess_data_core_0.c **** -7.7946163588,
 105:spinnaker_src/ensemble_mess_data_core_0.c **** -6.64665811668,
 106:spinnaker_src/ensemble_mess_data_core_0.c **** 6.21634863364,
 107:spinnaker_src/ensemble_mess_data_core_0.c **** -28.7038841815,
 108:spinnaker_src/ensemble_mess_data_core_0.c **** 19.5126826794,
 109:spinnaker_src/ensemble_mess_data_core_0.c **** -16.0307112444,
 110:spinnaker_src/ensemble_mess_data_core_0.c **** 29.3211986128,
 111:spinnaker_src/ensemble_mess_data_core_0.c **** -29.9828711325,
 112:spinnaker_src/ensemble_mess_data_core_0.c **** 11.5969590037,
 113:spinnaker_src/ensemble_mess_data_core_0.c **** 4.27530576739,
 114:spinnaker_src/ensemble_mess_data_core_0.c **** 16.6024830863,
 115:spinnaker_src/ensemble_mess_data_core_0.c **** 4.80309631297,
 116:spinnaker_src/ensemble_mess_data_core_0.c **** 20.3324925489,
 117:spinnaker_src/ensemble_mess_data_core_0.c **** 20.6682340983,
 118:spinnaker_src/ensemble_mess_data_core_0.c **** 38.0020983168,
 119:spinnaker_src/ensemble_mess_data_core_0.c **** -17.5525751182,
 120:spinnaker_src/ensemble_mess_data_core_0.c **** 7.01971809155,
 121:spinnaker_src/ensemble_mess_data_core_0.c **** 14.8151955688,
 122:spinnaker_src/ensemble_mess_data_core_0.c **** -9.48254137121,
 123:spinnaker_src/ensemble_mess_data_core_0.c **** -18.095138443,
 124:spinnaker_src/ensemble_mess_data_core_0.c **** 16.0594495246,
 125:spinnaker_src/ensemble_mess_data_core_0.c **** 13.2574118323,
 126:spinnaker_src/ensemble_mess_data_core_0.c **** 18.4166739267,
 127:spinnaker_src/ensemble_mess_data_core_0.c **** 14.5634334626,
 128:spinnaker_src/ensemble_mess_data_core_0.c **** -13.5293868403,
 129:spinnaker_src/ensemble_mess_data_core_0.c **** -10.2530662492,
 130:spinnaker_src/ensemble_mess_data_core_0.c **** 14.4750206387,
 131:spinnaker_src/ensemble_mess_data_core_0.c **** 3.8778065742,
 132:spinnaker_src/ensemble_mess_data_core_0.c **** -5.42166793033,
 133:spinnaker_src/ensemble_mess_data_core_0.c **** 9.04041792047,
 134:spinnaker_src/ensemble_mess_data_core_0.c **** -22.7598114848,
 135:spinnaker_src/ensemble_mess_data_core_0.c **** -58.7902340594,
 136:spinnaker_src/ensemble_mess_data_core_0.c **** 4.3440839576,
 137:spinnaker_src/ensemble_mess_data_core_0.c **** -47.477459437,
 138:spinnaker_src/ensemble_mess_data_core_0.c **** -16.4127516747,
 139:spinnaker_src/ensemble_mess_data_core_0.c **** 34.0753927249,
 140:spinnaker_src/ensemble_mess_data_core_0.c **** 23.7600716187,
 141:spinnaker_src/ensemble_mess_data_core_0.c **** 13.3147142482,
 142:spinnaker_src/ensemble_mess_data_core_0.c **** -9.25339070464,
 143:spinnaker_src/ensemble_mess_data_core_0.c **** 10.1713323914,
 144:spinnaker_src/ensemble_mess_data_core_0.c **** -14.4542646375,
 145:spinnaker_src/ensemble_mess_data_core_0.c **** -6.32836168565,
 146:spinnaker_src/ensemble_mess_data_core_0.c **** 10.2812995327,
 147:spinnaker_src/ensemble_mess_data_core_0.c **** 10.8786295107,
 148:spinnaker_src/ensemble_mess_data_core_0.c **** 52.6456372308,
 149:spinnaker_src/ensemble_mess_data_core_0.c **** 15.3207442985,
 150:spinnaker_src/ensemble_mess_data_core_0.c **** -1198.60892104,
 151:spinnaker_src/ensemble_mess_data_core_0.c **** 15.4097773603,
 152:spinnaker_src/ensemble_mess_data_core_0.c **** 8.8513352882,
 153:spinnaker_src/ensemble_mess_data_core_0.c **** 36.2649982036,
 154:spinnaker_src/ensemble_mess_data_core_0.c **** -12.1816788923
 155:spinnaker_src/ensemble_mess_data_core_0.c **** };
 156:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t bias0[150]={
 157:spinnaker_src/ensemble_mess_data_core_0.c **** 17.7897082097,
 158:spinnaker_src/ensemble_mess_data_core_0.c **** -35.4765082274,
 159:spinnaker_src/ensemble_mess_data_core_0.c **** 4.51658618226,
 160:spinnaker_src/ensemble_mess_data_core_0.c **** 5.71518845678,
 161:spinnaker_src/ensemble_mess_data_core_0.c **** -4.91345821587,
 162:spinnaker_src/ensemble_mess_data_core_0.c **** -77.0230425532,
 163:spinnaker_src/ensemble_mess_data_core_0.c **** 4.49915462219,
 164:spinnaker_src/ensemble_mess_data_core_0.c **** 10.3484191634,
 165:spinnaker_src/ensemble_mess_data_core_0.c **** 2.8695497721,
 166:spinnaker_src/ensemble_mess_data_core_0.c **** 14.169642083,
 167:spinnaker_src/ensemble_mess_data_core_0.c **** 1.1073452754,
 168:spinnaker_src/ensemble_mess_data_core_0.c **** -57.2852892029,
 169:spinnaker_src/ensemble_mess_data_core_0.c **** -19.7797420643,
 170:spinnaker_src/ensemble_mess_data_core_0.c **** -2.10852801401,
 171:spinnaker_src/ensemble_mess_data_core_0.c **** 10.4584488753,
 172:spinnaker_src/ensemble_mess_data_core_0.c **** 7.60431708371,
 173:spinnaker_src/ensemble_mess_data_core_0.c **** -11.8940621817,
 174:spinnaker_src/ensemble_mess_data_core_0.c **** 6.1075856996,
 175:spinnaker_src/ensemble_mess_data_core_0.c **** -0.414904164892,
 176:spinnaker_src/ensemble_mess_data_core_0.c **** -12.0229940149,
 177:spinnaker_src/ensemble_mess_data_core_0.c **** 4.04412656317,
 178:spinnaker_src/ensemble_mess_data_core_0.c **** 3.97599730246,
 179:spinnaker_src/ensemble_mess_data_core_0.c **** 4.85611574012,
 180:spinnaker_src/ensemble_mess_data_core_0.c **** 3.80417567013,
 181:spinnaker_src/ensemble_mess_data_core_0.c **** -36.9998352033,
 182:spinnaker_src/ensemble_mess_data_core_0.c **** 13.2888803661,
 183:spinnaker_src/ensemble_mess_data_core_0.c **** 5.06507802745,
 184:spinnaker_src/ensemble_mess_data_core_0.c **** 4.40983530963,
 185:spinnaker_src/ensemble_mess_data_core_0.c **** -5.9627422123,
 186:spinnaker_src/ensemble_mess_data_core_0.c **** 7.05689098485,
 187:spinnaker_src/ensemble_mess_data_core_0.c **** 2.88180366246,
 188:spinnaker_src/ensemble_mess_data_core_0.c **** 11.8008504021,
 189:spinnaker_src/ensemble_mess_data_core_0.c **** 7.76154279311,
 190:spinnaker_src/ensemble_mess_data_core_0.c **** 4.83085080962,
 191:spinnaker_src/ensemble_mess_data_core_0.c **** 2.07265618785,
 192:spinnaker_src/ensemble_mess_data_core_0.c **** 2.84283014095,
 193:spinnaker_src/ensemble_mess_data_core_0.c **** 9.89570474312,
 194:spinnaker_src/ensemble_mess_data_core_0.c **** -6.58618850621,
 195:spinnaker_src/ensemble_mess_data_core_0.c **** 16.8983387644,
 196:spinnaker_src/ensemble_mess_data_core_0.c **** 2.09619256067,
 197:spinnaker_src/ensemble_mess_data_core_0.c **** 10.9007040872,
 198:spinnaker_src/ensemble_mess_data_core_0.c **** 8.28334952888,
 199:spinnaker_src/ensemble_mess_data_core_0.c **** -12.2769538083,
 200:spinnaker_src/ensemble_mess_data_core_0.c **** 0.637941300171,
 201:spinnaker_src/ensemble_mess_data_core_0.c **** 4.45421714947,
 202:spinnaker_src/ensemble_mess_data_core_0.c **** 1.74680863103,
 203:spinnaker_src/ensemble_mess_data_core_0.c **** 7.78496062007,
 204:spinnaker_src/ensemble_mess_data_core_0.c **** -8.22074023405,
 205:spinnaker_src/ensemble_mess_data_core_0.c **** 12.9567229243,
 206:spinnaker_src/ensemble_mess_data_core_0.c **** -24.1420687278,
 207:spinnaker_src/ensemble_mess_data_core_0.c **** 0.00932175096086,
 208:spinnaker_src/ensemble_mess_data_core_0.c **** 0.953295937807,
 209:spinnaker_src/ensemble_mess_data_core_0.c **** 7.16900000194,
 210:spinnaker_src/ensemble_mess_data_core_0.c **** 3.58358162447,
 211:spinnaker_src/ensemble_mess_data_core_0.c **** 1.72705722733,
 212:spinnaker_src/ensemble_mess_data_core_0.c **** -289.594370301,
 213:spinnaker_src/ensemble_mess_data_core_0.c **** 7.49290043528,
 214:spinnaker_src/ensemble_mess_data_core_0.c **** 4.04608897769,
 215:spinnaker_src/ensemble_mess_data_core_0.c **** -10.5454112106,
 216:spinnaker_src/ensemble_mess_data_core_0.c **** -8.61591364244,
 217:spinnaker_src/ensemble_mess_data_core_0.c **** 7.14805790828,
 218:spinnaker_src/ensemble_mess_data_core_0.c **** 8.84462042237,
 219:spinnaker_src/ensemble_mess_data_core_0.c **** 2.07508371025,
 220:spinnaker_src/ensemble_mess_data_core_0.c **** -5.50735518575,
 221:spinnaker_src/ensemble_mess_data_core_0.c **** -19.8173295437,
 222:spinnaker_src/ensemble_mess_data_core_0.c **** -46.0655705232,
 223:spinnaker_src/ensemble_mess_data_core_0.c **** -4.00520256398,
 224:spinnaker_src/ensemble_mess_data_core_0.c **** 4.34111016496,
 225:spinnaker_src/ensemble_mess_data_core_0.c **** -71.3427939702,
 226:spinnaker_src/ensemble_mess_data_core_0.c **** -19.0427703953,
 227:spinnaker_src/ensemble_mess_data_core_0.c **** 4.88067867351,
 228:spinnaker_src/ensemble_mess_data_core_0.c **** 4.84942244015,
 229:spinnaker_src/ensemble_mess_data_core_0.c **** -86.8013532954,
 230:spinnaker_src/ensemble_mess_data_core_0.c **** 13.4901838835,
 231:spinnaker_src/ensemble_mess_data_core_0.c **** -8.50080408951,
 232:spinnaker_src/ensemble_mess_data_core_0.c **** 10.1350380364,
 233:spinnaker_src/ensemble_mess_data_core_0.c **** -30.0837824932,
 234:spinnaker_src/ensemble_mess_data_core_0.c **** 8.70618414383,
 235:spinnaker_src/ensemble_mess_data_core_0.c **** -14.3041712571,
 236:spinnaker_src/ensemble_mess_data_core_0.c **** 7.62893498734,
 237:spinnaker_src/ensemble_mess_data_core_0.c **** 1.38218165383,
 238:spinnaker_src/ensemble_mess_data_core_0.c **** -29.9718346631,
 239:spinnaker_src/ensemble_mess_data_core_0.c **** 2.15757900513,
 240:spinnaker_src/ensemble_mess_data_core_0.c **** 4.15608011333,
 241:spinnaker_src/ensemble_mess_data_core_0.c **** -2.29420709939,
 242:spinnaker_src/ensemble_mess_data_core_0.c **** -18.6120577854,
 243:spinnaker_src/ensemble_mess_data_core_0.c **** 3.55962475901,
 244:spinnaker_src/ensemble_mess_data_core_0.c **** 1.98229195209,
 245:spinnaker_src/ensemble_mess_data_core_0.c **** -25.8932115506,
 246:spinnaker_src/ensemble_mess_data_core_0.c **** -25.8835349515,
 247:spinnaker_src/ensemble_mess_data_core_0.c **** -24.5885630664,
 248:spinnaker_src/ensemble_mess_data_core_0.c **** -2.2743069605,
 249:spinnaker_src/ensemble_mess_data_core_0.c **** -12.9784685175,
 250:spinnaker_src/ensemble_mess_data_core_0.c **** -65.6234375719,
 251:spinnaker_src/ensemble_mess_data_core_0.c **** 18.1701146162,
 252:spinnaker_src/ensemble_mess_data_core_0.c **** 5.93007046829,
 253:spinnaker_src/ensemble_mess_data_core_0.c **** -0.690154751489,
 254:spinnaker_src/ensemble_mess_data_core_0.c **** -7.84858744665,
 255:spinnaker_src/ensemble_mess_data_core_0.c **** 11.5632914287,
 256:spinnaker_src/ensemble_mess_data_core_0.c **** 2.56274282582,
 257:spinnaker_src/ensemble_mess_data_core_0.c **** 3.92956535271,
 258:spinnaker_src/ensemble_mess_data_core_0.c **** 1.95097635373,
 259:spinnaker_src/ensemble_mess_data_core_0.c **** 1.11604218727,
 260:spinnaker_src/ensemble_mess_data_core_0.c **** -5.24465256109,
 261:spinnaker_src/ensemble_mess_data_core_0.c **** 1.12067473866,
 262:spinnaker_src/ensemble_mess_data_core_0.c **** -6.06454407294,
 263:spinnaker_src/ensemble_mess_data_core_0.c **** -3.94356751041,
 264:spinnaker_src/ensemble_mess_data_core_0.c **** 2.66225248367,
 265:spinnaker_src/ensemble_mess_data_core_0.c **** 5.23275480588,
 266:spinnaker_src/ensemble_mess_data_core_0.c **** 11.1435721441,
 267:spinnaker_src/ensemble_mess_data_core_0.c **** 2.72712951179,
 268:spinnaker_src/ensemble_mess_data_core_0.c **** 15.3556292513,
 269:spinnaker_src/ensemble_mess_data_core_0.c **** -3.07841640417,
 270:spinnaker_src/ensemble_mess_data_core_0.c **** -7.47442814858,
 271:spinnaker_src/ensemble_mess_data_core_0.c **** 0.996726107839,
 272:spinnaker_src/ensemble_mess_data_core_0.c **** 3.51518041311,
 273:spinnaker_src/ensemble_mess_data_core_0.c **** -3.54109602646,
 274:spinnaker_src/ensemble_mess_data_core_0.c **** 6.87379937769,
 275:spinnaker_src/ensemble_mess_data_core_0.c **** 18.8823040962,
 276:spinnaker_src/ensemble_mess_data_core_0.c **** -6.54607898051,
 277:spinnaker_src/ensemble_mess_data_core_0.c **** 2.49798566964,
 278:spinnaker_src/ensemble_mess_data_core_0.c **** -6.28717053717,
 279:spinnaker_src/ensemble_mess_data_core_0.c **** 10.1737004423,
 280:spinnaker_src/ensemble_mess_data_core_0.c **** 12.8349717905,
 281:spinnaker_src/ensemble_mess_data_core_0.c **** 3.49952146984,
 282:spinnaker_src/ensemble_mess_data_core_0.c **** -4.67410706764,
 283:spinnaker_src/ensemble_mess_data_core_0.c **** 4.08038709168,
 284:spinnaker_src/ensemble_mess_data_core_0.c **** 4.29817156158,
 285:spinnaker_src/ensemble_mess_data_core_0.c **** 1.83257456891,
 286:spinnaker_src/ensemble_mess_data_core_0.c **** -4.51466543793,
 287:spinnaker_src/ensemble_mess_data_core_0.c **** -28.4097261758,
 288:spinnaker_src/ensemble_mess_data_core_0.c **** 4.39068766649,
 289:spinnaker_src/ensemble_mess_data_core_0.c **** -10.8336245073,
 290:spinnaker_src/ensemble_mess_data_core_0.c **** 4.69744755762,
 291:spinnaker_src/ensemble_mess_data_core_0.c **** -10.5917922276,
 292:spinnaker_src/ensemble_mess_data_core_0.c **** 15.0868533147,
 293:spinnaker_src/ensemble_mess_data_core_0.c **** 0.256538377447,
 294:spinnaker_src/ensemble_mess_data_core_0.c **** 7.06721593321,
 295:spinnaker_src/ensemble_mess_data_core_0.c **** 10.7913109486,
 296:spinnaker_src/ensemble_mess_data_core_0.c **** 1.37724918328,
 297:spinnaker_src/ensemble_mess_data_core_0.c **** 4.99727451658,
 298:spinnaker_src/ensemble_mess_data_core_0.c **** -1.84469842824,
 299:spinnaker_src/ensemble_mess_data_core_0.c **** 0.204232181948,
 300:spinnaker_src/ensemble_mess_data_core_0.c **** -27.9493494673,
 301:spinnaker_src/ensemble_mess_data_core_0.c **** 4.27986792286,
 302:spinnaker_src/ensemble_mess_data_core_0.c **** -1172.32338088,
 303:spinnaker_src/ensemble_mess_data_core_0.c **** 0.531089839074,
 304:spinnaker_src/ensemble_mess_data_core_0.c **** 1.37488235274,
 305:spinnaker_src/ensemble_mess_data_core_0.c **** -17.0920615075,
 306:spinnaker_src/ensemble_mess_data_core_0.c **** -0.770930896234
 307:spinnaker_src/ensemble_mess_data_core_0.c **** };
 308:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t decoders0[150*1]={
 309:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 310:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 311:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 312:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 313:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 314:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 315:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 316:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 317:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 318:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 319:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 320:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 321:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 322:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 323:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 324:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 325:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 326:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 327:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 328:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 329:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 330:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 331:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 332:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 333:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 334:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 335:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 336:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 337:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 338:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 339:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 340:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 341:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 342:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 343:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 344:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 345:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 346:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 347:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 348:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 349:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 350:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 351:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 352:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 353:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 354:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 355:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 356:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 357:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 358:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 359:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 360:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 361:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 362:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 363:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 364:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 365:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 366:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 367:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 368:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 369:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 370:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 371:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 372:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 373:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 374:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 375:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 376:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 377:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 378:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 379:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 380:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 381:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 382:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 383:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 384:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 385:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 386:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 387:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 388:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 389:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 390:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 391:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 392:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 393:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 394:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 395:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 396:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 397:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 398:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 399:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 400:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 401:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 402:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 403:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 404:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 405:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 406:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 407:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 408:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 409:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 410:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 411:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 412:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 413:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 414:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 415:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 416:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 417:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 418:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 419:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 420:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 421:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 422:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 423:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 424:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 425:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 426:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 427:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 428:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 429:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 430:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 431:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 432:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 433:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 434:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 435:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 436:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 437:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 438:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 439:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 440:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 441:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 442:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 443:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 444:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 445:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 446:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 447:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 448:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 449:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 450:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 451:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 452:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 453:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 454:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 455:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 456:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 457:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0,
 458:spinnaker_src/ensemble_mess_data_core_0.c **** 0.0
 459:spinnaker_src/ensemble_mess_data_core_0.c **** };
 460:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t inputs0[1];
 461:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t outputs0[1];
 462:spinnaker_src/ensemble_mess_data_core_0.c **** neuron_t neurons0[150];
 463:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t input_currents0[150];
 464:spinnaker_src/ensemble_mess_data_core_0.c **** REAL learning_activity0[150];
 465:spinnaker_src/ensemble_mess_data_core_0.c **** REAL error0[1];
 466:spinnaker_src/ensemble_mess_data_core_0.c **** REAL delta0[150];
 467:spinnaker_src/ensemble_mess_data_core_0.c **** ensemble_t ensembles[1];
 468:spinnaker_src/ensemble_mess_data_core_0.c **** uint32_t n_ensembles= 1;
 469:spinnaker_src/ensemble_mess_data_core_0.c **** void ensemble_init(){
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
 470:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].encoders = encoders0;
  45              		.loc 1 470 0
  46 0004 1B4B     		ldr	r3, .L3
  47 0006 1C4A     		ldr	r2, .L3+4
 471:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].bias     = bias0;
  48              		.loc 1 471 0
  49 0008 DFF888A0 		ldr	r10, .L3+32
 472:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].decoders = decoders0;
  50              		.loc 1 472 0
  51 000c DFF88890 		ldr	r9, .L3+36
 470:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].encoders = encoders0;
  52              		.loc 1 470 0
  53 0010 1A60     		str	r2, [r3]
 473:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_inputs = 1;
 474:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_neurons= 150;
  54              		.loc 1 474 0
  55 0012 9622     		movs	r2, #150
 475:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_outputs= 1;
 476:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].tau_rc   = 20.0;
 477:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].tau_ref  = 2.0;
 478:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].obj_id   = 0;
 479:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].inputs   = inputs0;
 480:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].outputs  = outputs0;
 481:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].neurons  = neurons0;
 482:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].input_currents= input_currents0;
 483:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_activity= learning_activity0;
 484:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_enabled = 1;
 485:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_rate = 0.000666666666667;
  56              		.loc 1 485 0
  57 0014 194D     		ldr	r5, .L3+8
 486:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_scale = 0.904837418036;
  58              		.loc 1 486 0
  59 0016 1A4C     		ldr	r4, .L3+12
 479:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].outputs  = outputs0;
  60              		.loc 1 479 0
  61 0018 DFF88080 		ldr	r8, .L3+40
 480:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].neurons  = neurons0;
  62              		.loc 1 480 0
  63 001c DFF880C0 		ldr	ip, .L3+44
 481:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].input_currents= input_currents0;
  64              		.loc 1 481 0
  65 0020 DFF880E0 		ldr	lr, .L3+48
 482:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_activity= learning_activity0;
  66              		.loc 1 482 0
  67 0024 174F     		ldr	r7, .L3+16
 483:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_enabled = 1;
  68              		.loc 1 483 0
  69 0026 184E     		ldr	r6, .L3+20
 487:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].error = error0;
  70              		.loc 1 487 0
  71 0028 1848     		ldr	r0, .L3+24
 488:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].delta = delta0;
  72              		.loc 1 488 0
  73 002a 1949     		ldr	r1, .L3+28
 476:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].tau_ref  = 2.0;
  74              		.loc 1 476 0
  75 002c DFF878B0 		ldr	fp, .L3+52
 471:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].decoders = decoders0;
  76              		.loc 1 471 0
  77 0030 C3F804A0 		str	r10, [r3, #4]
 472:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_inputs = 1;
  78              		.loc 1 472 0
  79 0034 C3F80890 		str	r9, [r3, #8]
 477:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].obj_id   = 0;
  80              		.loc 1 477 0
  81 0038 4FF0804A 		mov	r10, #1073741824
 478:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].inputs   = inputs0;
  82              		.loc 1 478 0
  83 003c 4FF00009 		mov	r9, #0
 474:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_outputs= 1;
  84              		.loc 1 474 0
  85 0040 1A61     		str	r2, [r3, #16]
 473:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_neurons= 150;
  86              		.loc 1 473 0
  87 0042 0122     		movs	r2, #1
 476:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].tau_ref  = 2.0;
  88              		.loc 1 476 0
  89 0044 C3F818B0 		str	fp, [r3, #24]	@ float
 477:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].obj_id   = 0;
  90              		.loc 1 477 0
  91 0048 C3F81CA0 		str	r10, [r3, #28]	@ float
 478:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].inputs   = inputs0;
  92              		.loc 1 478 0
  93 004c C3F82090 		str	r9, [r3, #32]
 479:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].outputs  = outputs0;
  94              		.loc 1 479 0
  95 0050 C3F82480 		str	r8, [r3, #36]
 480:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].neurons  = neurons0;
  96              		.loc 1 480 0
  97 0054 C3F828C0 		str	ip, [r3, #40]
 481:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].input_currents= input_currents0;
  98              		.loc 1 481 0
  99 0058 C3F82CE0 		str	lr, [r3, #44]
 482:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_activity= learning_activity0;
 100              		.loc 1 482 0
 101 005c 1F63     		str	r7, [r3, #48]
 483:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_enabled = 1;
 102              		.loc 1 483 0
 103 005e DE63     		str	r6, [r3, #60]
 485:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_scale = 0.904837418036;
 104              		.loc 1 485 0
 105 0060 5D63     		str	r5, [r3, #52]	@ float
 486:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].error = error0;
 106              		.loc 1 486 0
 107 0062 9C63     		str	r4, [r3, #56]	@ float
 487:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].delta = delta0;
 108              		.loc 1 487 0
 109 0064 5864     		str	r0, [r3, #68]
 110              		.loc 1 488 0
 111 0066 9964     		str	r1, [r3, #72]
 473:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].n_neurons= 150;
 112              		.loc 1 473 0
 113 0068 DA60     		str	r2, [r3, #12]
 475:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].tau_rc   = 20.0;
 114              		.loc 1 475 0
 115 006a 5A61     		str	r2, [r3, #20]
 484:spinnaker_src/ensemble_mess_data_core_0.c **** ensembles[0].learning_rate = 0.000666666666667;
 116              		.loc 1 484 0
 117 006c 1A64     		str	r2, [r3, #64]
 118 006e BDE8F08F 		pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
 119              	.L4:
 120 0072 00BF     		.align	2
 121              	.L3:
 122 0074 00000000 		.word	ensembles
 123 0078 00000000 		.word	.LANCHOR0
 124 007c 3EC32E3A 		.word	976143166
 125 0080 6DA3673F 		.word	1063756653
 126 0084 00000000 		.word	input_currents0
 127 0088 00000000 		.word	learning_activity0
 128 008c 00000000 		.word	error0
 129 0090 00000000 		.word	delta0
 130 0094 00000000 		.word	.LANCHOR1
 131 0098 00000000 		.word	.LANCHOR2
 132 009c 00000000 		.word	inputs0
 133 00a0 00000000 		.word	outputs0
 134 00a4 00000000 		.word	neurons0
 135 00a8 0000A041 		.word	1101004800
 136              		.cfi_endproc
 137              	.LFE156:
 139              		.section	.text.mess_init,"ax",%progbits
 140              		.align	2
 141              		.global	mess_init
 142              		.thumb
 143              		.thumb_func
 145              	mess_init:
 146              	.LFB157:
 489:spinnaker_src/ensemble_mess_data_core_0.c **** }
 490:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t pre_values2[1];
 491:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t post_values2[1];
 492:spinnaker_src/ensemble_mess_data_core_0.c **** precision_t matrix2[1*1]={
 493:spinnaker_src/ensemble_mess_data_core_0.c **** 1.0
 494:spinnaker_src/ensemble_mess_data_core_0.c **** };
 495:spinnaker_src/ensemble_mess_data_core_0.c **** message_t mess[1];
 496:spinnaker_src/ensemble_mess_data_core_0.c **** uint32_t n_mess= 1;
 497:spinnaker_src/ensemble_mess_data_core_0.c **** void mess_init(){
 147              		.loc 1 497 0
 148              		.cfi_startproc
 149              		@ args = 0, pretend = 0, frame = 0
 150              		@ frame_needed = 0, uses_anonymous_args = 0
 151 0000 F0B5     		push	{r4, r5, r6, r7, lr}
 152              		.cfi_def_cfa_offset 20
 153              		.cfi_offset 4, -20
 154              		.cfi_offset 5, -16
 155              		.cfi_offset 6, -12
 156              		.cfi_offset 7, -8
 157              		.cfi_offset 14, -4
 498:spinnaker_src/ensemble_mess_data_core_0.c **** 
 499:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_obj_id = 3;
 158              		.loc 1 499 0
 159 0002 0D4B     		ldr	r3, .L7
 500:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_start  = 0;
 501:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_len    = 1;
 502:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_obj_id= 0;
 503:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_start = 0;
 504:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_len   = 1;
 505:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].mess_id    = 2;
 506:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].use_synapse_scale= 0;
 507:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].synapse_scale= 0;
 508:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_values = pre_values2;
 160              		.loc 1 508 0
 161 0004 0D4E     		ldr	r6, .L7+4
 509:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_values = post_values2;
 162              		.loc 1 509 0
 163 0006 0E4D     		ldr	r5, .L7+8
 510:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].ens_input = &inputs0[0];
 164              		.loc 1 510 0
 165 0008 0E4C     		ldr	r4, .L7+12
 511:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].matrix      = matrix2;
 166              		.loc 1 511 0
 167 000a 0F48     		ldr	r0, .L7+16
 508:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_values = post_values2;
 168              		.loc 1 508 0
 169 000c 5E62     		str	r6, [r3, #36]
 507:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_values = pre_values2;
 170              		.loc 1 507 0
 171 000e 0022     		movs	r2, #0
 501:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_obj_id= 0;
 172              		.loc 1 501 0
 173 0010 0121     		movs	r1, #1
 507:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_values = pre_values2;
 174              		.loc 1 507 0
 175 0012 1A62     		str	r2, [r3, #32]	@ float
 499:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_start  = 0;
 176              		.loc 1 499 0
 177 0014 4FF0030E 		mov	lr, #3
 500:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_len    = 1;
 178              		.loc 1 500 0
 179 0018 0022     		movs	r2, #0
 505:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].use_synapse_scale= 0;
 180              		.loc 1 505 0
 181 001a 0227     		movs	r7, #2
 499:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_start  = 0;
 182              		.loc 1 499 0
 183 001c C3F800E0 		str	lr, [r3]
 505:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].use_synapse_scale= 0;
 184              		.loc 1 505 0
 185 0020 9F61     		str	r7, [r3, #24]
 509:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].ens_input = &inputs0[0];
 186              		.loc 1 509 0
 187 0022 9D62     		str	r5, [r3, #40]
 510:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].matrix      = matrix2;
 188              		.loc 1 510 0
 189 0024 DC62     		str	r4, [r3, #44]
 190              		.loc 1 511 0
 191 0026 1863     		str	r0, [r3, #48]
 500:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].pre_len    = 1;
 192              		.loc 1 500 0
 193 0028 5A60     		str	r2, [r3, #4]
 502:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_start = 0;
 194              		.loc 1 502 0
 195 002a DA60     		str	r2, [r3, #12]
 503:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_len   = 1;
 196              		.loc 1 503 0
 197 002c 1A61     		str	r2, [r3, #16]
 506:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].synapse_scale= 0;
 198              		.loc 1 506 0
 199 002e DA61     		str	r2, [r3, #28]
 501:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].post_obj_id= 0;
 200              		.loc 1 501 0
 201 0030 9960     		str	r1, [r3, #8]
 504:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].mess_id    = 2;
 202              		.loc 1 504 0
 203 0032 5961     		str	r1, [r3, #20]
 512:spinnaker_src/ensemble_mess_data_core_0.c **** mess[0].matrix_is_scalar = 1;
 204              		.loc 1 512 0
 205 0034 5963     		str	r1, [r3, #52]
 206 0036 F0BD     		pop	{r4, r5, r6, r7, pc}
 207              	.L8:
 208              		.align	2
 209              	.L7:
 210 0038 00000000 		.word	mess
 211 003c 00000000 		.word	pre_values2
 212 0040 00000000 		.word	post_values2
 213 0044 00000000 		.word	inputs0
 214 0048 00000000 		.word	.LANCHOR3
 215              		.cfi_endproc
 216              	.LFE157:
 218              		.global	n_mess
 219              		.comm	mess,60,4
 220              		.global	matrix2
 221              		.comm	post_values2,4,4
 222              		.comm	pre_values2,4,4
 223              		.global	n_ensembles
 224              		.comm	ensembles,80,4
 225              		.comm	delta0,600,4
 226              		.comm	error0,4,4
 227              		.comm	learning_activity0,600,4
 228              		.comm	input_currents0,600,4
 229              		.comm	neurons0,1200,4
 230              		.comm	outputs0,4,4
 231              		.comm	inputs0,4,4
 232              		.global	decoders0
 233              		.global	bias0
 234              		.global	encoders0
 235              		.section	.data.n_mess,"aw",%progbits
 236              		.align	2
 239              	n_mess:
 240 0000 01000000 		.word	1
 241              		.section	.data.bias0,"aw",%progbits
 242              		.align	2
 243              		.set	.LANCHOR1,. + 0
 246              	bias0:
 247 0000 53518E41 		.word	1099845971
 248 0004 F2E70DC2 		.word	3255691250
 249 0008 E0879040 		.word	1083213792
 250 000c D3E2B640 		.word	1085727443
 251 0010 0D3B9DC0 		.word	3231529741
 252 0014 CC0B9AC2 		.word	3264875468
 253 0018 13F98F40 		.word	1083177235
 254 001c 20932541 		.word	1092981536
 255 0020 B4A63740 		.word	1077388980
 256 0024 DBB66241 		.word	1096988379
 257 0028 7DBD8D3F 		.word	1066253693
 258 002c 232465C2 		.word	3261408291
 259 0030 E93C9EC1 		.word	3248372969
 260 0034 1FF206C0 		.word	3221680671
 261 0038 CE552741 		.word	1093096910
 262 003c 9156F340 		.word	1089689233
 263 0040 144E3EC1 		.word	3242085908
 264 0044 5871C340 		.word	1086550360
 265 0048 526ED4BE 		.word	3201592914
 266 004c 2F5E40C1 		.word	3242221103
 267 0050 7C698140 		.word	1082222972
 268 0054 BD767E40 		.word	1082029757
 269 0058 4D659B40 		.word	1083925837
 270 005c 9D777340 		.word	1081309085
 271 0060 D5FF13C2 		.word	3256090581
 272 0064 419F5441 		.word	1096064833
 273 0068 1F15A240 		.word	1084364063
 274 006c 5F1D8D40 		.word	1082989919
 275 0070 C9CEBEC0 		.word	3233730249
 276 0074 0DD2E140 		.word	1088541197
 277 0078 796F3840 		.word	1077440377
 278 007c 49D03C41 		.word	1094504521
 279 0080 8F5EF840 		.word	1090018959
 280 0084 54969A40 		.word	1083872852
 281 0088 66A60440 		.word	1074046566
 282 008c EEF03540 		.word	1077276910
 283 0090 CE541E41 		.word	1092506830
 284 0094 0EC2D2C0 		.word	3235037710
 285 0098 CC2F8741 		.word	1099378636
 286 009c 05280640 		.word	1074145285
 287 00a0 49692E41 		.word	1093560649
 288 00a4 9A880441 		.word	1090816154
 289 00a8 676E44C1 		.word	3242487399
 290 00ac 1F50233F 		.word	1059278879
 291 00b0 F2888E40 		.word	1083082994
 292 00b4 6D97DF3F 		.word	1071617901
 293 00b8 661EF940 		.word	1090068070
 294 00bc 278803C1 		.word	3238234151
 295 00c0 BD4E4F41 		.word	1095716541
 296 00c4 F522C1C1 		.word	3250660085
 297 00c8 42BA183C 		.word	1008253506
 298 00cc 340B743F 		.word	1064569652
 299 00d0 7368E540 		.word	1088776307
 300 00d4 67596540 		.word	1080383847
 301 00d8 3610DD3F 		.word	1071452214
 302 00dc 14CC90C3 		.word	3281046548
 303 00e0 D7C5EF40 		.word	1089455575
 304 00e4 90798140 		.word	1082227088
 305 00e8 01BA28C1 		.word	3240671745
 306 00ec C8DA09C1 		.word	3238648520
 307 00f0 E4BCE440 		.word	1088732388
 308 00f4 91830D41 		.word	1091404689
 309 00f8 2CCE0440 		.word	1074056748
 310 00fc 413CB0C0 		.word	3232775233
 311 0100 E4899EC1 		.word	3248392676
 312 0104 254338C2 		.word	3258467109
 313 0108 9F2A80C0 		.word	3229624991
 314 010c 60EA8A40 		.word	1082845792
 315 0110 83AF8EC2 		.word	3264130947
 316 0114 985798C1 		.word	3247986584
 317 0118 852E9C40 		.word	1083977349
 318 011c 782E9B40 		.word	1083911800
 319 0120 4B9AADC2 		.word	3266157131
 320 0124 CBD75741 		.word	1096275915
 321 0128 4B0308C1 		.word	3238527819
 322 012c 1E292241 		.word	1092757790
 323 0130 96ABF0C1 		.word	3253775254
 324 0134 884C0B41 		.word	1091259528
 325 0138 E3DD64C1 		.word	3244613091
 326 013c 3C20F440 		.word	1089740860
 327 0140 54EBB03F 		.word	1068559188
 328 0144 51C6EFC1 		.word	3253716561
 329 0148 C6150A40 		.word	1074402758
 330 014c 9CFE8440 		.word	1082457756
 331 0150 4AD412C0 		.word	3222459466
 332 0154 7FE594C1 		.word	3247760767
 333 0158 E4D06340 		.word	1080283364
 334 015c BEBBFD3F 		.word	1073593278
 335 0160 4C25CFC1 		.word	3251578188
 336 0164 7B11CFC1 		.word	3251573115
 337 0168 61B5C4C1 		.word	3250894177
 338 016c 3F8E11C0 		.word	3222375999
 339 0170 CFA74FC1 		.word	3243222991
 340 0174 333F83C2 		.word	3263381299
 341 0178 655C9141 		.word	1100045413
 342 017c 23C3BD40 		.word	1086178083
 343 0180 FBAD30BF 		.word	3207638523
 344 0184 A127FBC0 		.word	3237685153
 345 0188 3E033941 		.word	1094255422
 346 018c FA032440 		.word	1076102138
 347 0190 007E7B40 		.word	1081835008
 348 0194 98B9F93F 		.word	1073330584
 349 0198 78DA8E3F 		.word	1066326648
 350 019c 32D4A7C0 		.word	3232224306
 351 01a0 45728F3F 		.word	1066365509
 352 01a4 BF10C2C0 		.word	3233943743
 353 01a8 69637CC0 		.word	3229377385
 354 01ac 58622A40 		.word	1076519512
 355 01b0 BA72A740 		.word	1084715706
 356 01b4 124C3241 		.word	1093815314
 357 01b8 4A892E40 		.word	1076791626
 358 01bc A8B07541 		.word	1098231976
 359 01c0 C60445C0 		.word	3225748678
 360 01c4 842EEFC0 		.word	3236900484
 361 01c8 71297F3F 		.word	1065298289
 362 01cc B7F86040 		.word	1080096951
 363 01d0 51A162C0 		.word	3227689297
 364 01d4 2AF6DB40 		.word	1088157226
 365 01d8 F50E9741 		.word	1100418805
 366 01dc 7B79D1C0 		.word	3234953595
 367 01e0 FFDE1F40 		.word	1075830527
 368 01e4 8030C9C0 		.word	3234410624
 369 01e8 7AC72241 		.word	1092798330
 370 01ec 0B5C4D41 		.word	1095588875
 371 01f0 29F85F40 		.word	1080031273
 372 01f4 499295C0 		.word	3231027785
 373 01f8 88928240 		.word	1082299016
 374 01fc 9F8A8940 		.word	1082755743
 375 0200 CE91EA3F 		.word	1072337358
 376 0204 247890C0 		.word	3230693412
 377 0208 1F47E3C1 		.word	3252897567
 378 020c 83808C40 		.word	1082949763
 379 0210 87562DC1 		.word	3240973959
 380 0214 7E519640 		.word	1083593086
 381 0218 FB7729C1 		.word	3240720379
 382 021c C0637141 		.word	1097950144
 383 0220 0059833E 		.word	1048795392
 384 0224 A226E240 		.word	1088562850
 385 0228 36A92C41 		.word	1093445942
 386 022c B449B03F 		.word	1068517812
 387 0230 ACE99F40 		.word	1084221868
 388 0234 141FECBF 		.word	3219922708
 389 0238 3E22513E 		.word	1045504574
 390 023c 4598DFC1 		.word	3252656197
 391 0240 AEF48840 		.word	1082717358
 392 0244 598A92C4 		.word	3297938009
 393 0248 81F5073F 		.word	1057486209
 394 024c 25FCAF3F 		.word	1068497957
 395 0250 8BBC88C1 		.word	3246963851
 396 0254 BA5B45BF 		.word	3208993722
 397              		.section	.data.n_ensembles,"aw",%progbits
 398              		.align	2
 401              	n_ensembles:
 402 0000 01000000 		.word	1
 403              		.section	.bss.decoders0,"aw",%nobits
 404              		.align	2
 405              		.set	.LANCHOR2,. + 0
 408              	decoders0:
 409 0000 00000000 		.space	600
 409      00000000 
 409      00000000 
 409      00000000 
 409      00000000 
 410              		.section	.data.encoders0,"aw",%progbits
 411              		.align	2
 412              		.set	.LANCHOR0,. + 0
 415              	encoders0:
 416 0000 7DBF8E41 		.word	1099874173
 417 0004 50E03442 		.word	1110761552
 418 0008 35A5B041 		.word	1102095669
 419 000c 8853FFC1 		.word	3254735752
 420 0010 B1174441 		.word	1094981553
 421 0014 06FBAD42 		.word	1118698246
 422 0018 9FF78240 		.word	1082324895
 423 001c A67F64C1 		.word	3244588966
 424 0020 3A63A840 		.word	1084777274
 425 0024 FB64D1C1 		.word	3251725563
 426 0028 9B9F3E41 		.word	1094623131
 427 002c 57A3B342 		.word	1119069015
 428 0030 51D1EAC1 		.word	3253391697
 429 0034 79C08141 		.word	1099022457
 430 0038 A59C91C1 		.word	3247545509
 431 003c FC8628C1 		.word	3240658684
 432 0040 4BE8D3C1 		.word	3251890251
 433 0044 897D1BC1 		.word	3239804297
 434 0048 82508F41 		.word	1099911298
 435 004c 15F8D041 		.word	1104214037
 436 0050 FC3AB340 		.word	1085487868
 437 0054 3F499240 		.word	1083328831
 438 0058 7A0C86C0 		.word	3230010490
 439 005c FA9C7E40 		.word	1082039546
 440 0060 BC4058C2 		.word	3260563644
 441 0064 D6A878C1 		.word	3245910230
 442 0068 A15AEBC0 		.word	3236649633
 443 006c 6B876940 		.word	1080657771
 444 0070 94EC9DC1 		.word	3248352404
 445 0074 489A3441 		.word	1093966408
 446 0078 71392E41 		.word	1093548401
 447 007c CB8D6FC1 		.word	3245313483
 448 0080 D646DC41 		.word	1104955094
 449 0084 80CACA41 		.word	1103809152
 450 0088 BDB49EC1 		.word	3248403645
 451 008c 02123F41 		.word	1094652418
 452 0090 102633C1 		.word	3241354768
 453 0094 F1A55E41 		.word	1096721905
 454 0098 AC49AF41 		.word	1102006700
 455 009c 2BABE740 		.word	1088924459
 456 00a0 C3A9AD41 		.word	1101900227
 457 00a4 A3679241 		.word	1100113827
 458 00a8 A5011A42 		.word	1109000613
 459 00ac 2FD822C1 		.word	3240286255
 460 00b0 0F55B240 		.word	1085429007
 461 00b4 739041C1 		.word	3242299507
 462 00b8 7F23A941 		.word	1101603711
 463 00bc F85BB4C1 		.word	3249822712
 464 00c0 839CAE41 		.word	1101962371
 465 00c4 92C111C2 		.word	3255943570
 466 00c8 D9139741 		.word	1100420057
 467 00cc 1AC316C2 		.word	3256271642
 468 00d0 AB5C48C1 		.word	3242745003
 469 00d4 78B68340 		.word	1082373752
 470 00d8 9B654EC1 		.word	3243140507
 471 00dc 35C796C3 		.word	3281438517
 472 00e0 9B7F0DC1 		.word	3238887323
 473 00e4 7913E140 		.word	1088492409
 474 00e8 4B9C99C1 		.word	3248069707
 475 00ec BE6DE941 		.word	1105817022
 476 00f0 A54F5EC1 		.word	3244183461
 477 00f4 7B4AA941 		.word	1101613691
 478 00f8 B5E0D6C0 		.word	3235307701
 479 00fc B23CFDC1 		.word	3254598834
 480 0100 A8D13D42 		.word	1111347624
 481 0104 BBB983C2 		.word	3263412667
 482 0108 98165D41 		.word	1096619672
 483 010c 623FCB40 		.word	1087061858
 484 0110 24EEA942 		.word	1118432804
 485 0114 D68D0EC2 		.word	3255733718
 486 0118 FC2C2141 		.word	1092693244
 487 011c AFE51D41 		.word	1092478383
 488 0120 1559E6C2 		.word	3269875989
 489 0124 E69C8541 		.word	1099275494
 490 0128 3C600E42 		.word	1108238396
 491 012c F061A441 		.word	1101292016
 492 0130 9CFF3DC2 		.word	3258843036
 493 0134 3887E341 		.word	1105430328
 494 0138 03290342 		.word	1107503363
 495 013c 006A2CC1 		.word	3240913408
 496 0140 2CC924C1 		.word	3240413484
 497 0144 BE084CC2 		.word	3259762878
 498 0148 2ACCB340 		.word	1085525034
 499 014c 53369540 		.word	1083520595
 500 0150 2BE430C1 		.word	3241206827
 501 0154 2ED61AC2 		.word	3256538670
 502 0158 5351BA40 		.word	1085952339
 503 015c 3E912141 		.word	1092718910
 504 0160 B9500642 		.word	1107710137
 505 0164 6C8A1042 		.word	1108380268
 506 0168 35027742 		.word	1115095605
 507 016c 3D1590C1 		.word	3247445309
 508 0170 092CB041 		.word	1102064649
 509 0174 626FA3C2 		.word	3265490786
 510 0178 A30D8AC1 		.word	3247050147
 511 017c 24E2BF41 		.word	1103094308
 512 0180 4E2E5C41 		.word	1096560206
 513 0184 BF4E9741 		.word	1100435135
 514 0188 AED94C41 		.word	1095555502
 515 018c 7F6DF9C0 		.word	3237571967
 516 0190 6CB1D4C0 		.word	3235164524
 517 0194 54ECC640 		.word	1086778452
 518 0198 8EA1E5C1 		.word	3253051790
 519 019c F9199C41 		.word	1100749305
 520 01a0 E63E80C1 		.word	3246407398
 521 01a4 D191EA41 		.word	1105891793
 522 01a8 ECDCEFC1 		.word	3253722348
 523 01ac 258D3941 		.word	1094290725
 524 01b0 4ECF8840 		.word	1082707790
 525 01b4 E3D18441 		.word	1099223523
 526 01b8 F7B29940 		.word	1083814647
 527 01bc F2A8A241 		.word	1101179122
 528 01c0 8B58A541 		.word	1101355147
 529 01c4 26021842 		.word	1108869670
 530 01c8 AD6B8CC1 		.word	3247205293
 531 01cc 88A1E040 		.word	1088463240
 532 01d0 0B0B6D41 		.word	1097665291
 533 01d4 7DB817C1 		.word	3239557245
 534 01d8 D8C290C1 		.word	3247489752
 535 01dc C1798041 		.word	1098938817
 536 01e0 5C1E5441 		.word	1096031836
 537 01e4 59559341 		.word	1100174681
 538 01e8 D3036941 		.word	1097401299
 539 01ec 5E7858C1 		.word	3243800670
 540 01f0 8F0C24C1 		.word	3240365199
 541 01f4 AF996741 		.word	1097308591
 542 01f8 FC2D7840 		.word	1081617916
 543 01fc 4E7EADC0 		.word	3232595534
 544 0200 8DA51041 		.word	1091609997
 545 0204 1814B6C1 		.word	3249935384
 546 0208 33296BC2 		.word	3261802803
 547 020c BC028B40 		.word	1082852028
 548 0210 EBE83DC2 		.word	3258837227
 549 0214 514D83C1 		.word	3246607697
 550 0218 344D0842 		.word	1107840308
 551 021c A014BE41 		.word	1102976160
 552 0220 12095541 		.word	1096091922
 553 0224 E30D14C1 		.word	3239316963
 554 0228 C7BD2241 		.word	1092795847
 555 022c AB4467C1 		.word	3244770475
 556 0230 F081CAC0 		.word	3234497008
 557 0234 34802441 		.word	1092911156
 558 0238 DE0E2E41 		.word	1093537502
 559 023c 22955242 		.word	1112708386
 560 0240 C5217541 		.word	1098195397
 561 0244 7CD395C4 		.word	3298153340
 562 0248 738E7641 		.word	1098288755
 563 024c 129F0D41 		.word	1091411730
 564 0250 5C0F1142 		.word	1108414300
 565 0254 28E842C1 		.word	3242387496
 566              		.section	.data.matrix2,"aw",%progbits
 567              		.align	2
 568              		.set	.LANCHOR3,. + 0
 571              	matrix2:
 572 0000 0000803F 		.word	1065353216
 573              		.text
 574              	.Letext0:
 575              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 576              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 577              		.file 4 "spinnaker_src/common/maths-util.h"
 578              		.file 5 "spinnaker_src/param_defs.h"
 579              		.file 6 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 580              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 581              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
