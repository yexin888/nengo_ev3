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
  17              		.file	"ensemble_mess_data_core_2.c"
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
  29              		.file 1 "spinnaker_src/ensemble_mess_data_core_2.c"
   1:spinnaker_src/ensemble_mess_data_core_2.c **** #include "qpe.h"
   2:spinnaker_src/ensemble_mess_data_core_2.c **** #include "common/neuron-typedefs.h"
   3:spinnaker_src/ensemble_mess_data_core_2.c **** #include "param_defs.h"
   4:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t encoders2[1*150]={
   5:spinnaker_src/ensemble_mess_data_core_2.c **** 31.4508768255,
   6:spinnaker_src/ensemble_mess_data_core_2.c **** 36.9376045086,
   7:spinnaker_src/ensemble_mess_data_core_2.c **** 8.88725909695,
   8:spinnaker_src/ensemble_mess_data_core_2.c **** -3.52750130112,
   9:spinnaker_src/ensemble_mess_data_core_2.c **** -47.7578830894,
  10:spinnaker_src/ensemble_mess_data_core_2.c **** -21.66636242,
  11:spinnaker_src/ensemble_mess_data_core_2.c **** 13.2797132708,
  12:spinnaker_src/ensemble_mess_data_core_2.c **** 21.1140485112,
  13:spinnaker_src/ensemble_mess_data_core_2.c **** 11.0840797634,
  14:spinnaker_src/ensemble_mess_data_core_2.c **** 11.4151431812,
  15:spinnaker_src/ensemble_mess_data_core_2.c **** -5.42984318027,
  16:spinnaker_src/ensemble_mess_data_core_2.c **** 3.54644845132,
  17:spinnaker_src/ensemble_mess_data_core_2.c **** -23.3720077997,
  18:spinnaker_src/ensemble_mess_data_core_2.c **** -11.3643018648,
  19:spinnaker_src/ensemble_mess_data_core_2.c **** -16.0766152679,
  20:spinnaker_src/ensemble_mess_data_core_2.c **** -33.5721756499,
  21:spinnaker_src/ensemble_mess_data_core_2.c **** 8.53458471736,
  22:spinnaker_src/ensemble_mess_data_core_2.c **** 15.9779799422,
  23:spinnaker_src/ensemble_mess_data_core_2.c **** -20.0198259188,
  24:spinnaker_src/ensemble_mess_data_core_2.c **** 109.778746764,
  25:spinnaker_src/ensemble_mess_data_core_2.c **** -59.0822330394,
  26:spinnaker_src/ensemble_mess_data_core_2.c **** -20.5353671991,
  27:spinnaker_src/ensemble_mess_data_core_2.c **** -10.2894832407,
  28:spinnaker_src/ensemble_mess_data_core_2.c **** -5.26155233583,
  29:spinnaker_src/ensemble_mess_data_core_2.c **** 8.78794236687,
  30:spinnaker_src/ensemble_mess_data_core_2.c **** -68.6663453533,
  31:spinnaker_src/ensemble_mess_data_core_2.c **** 21.5757834233,
  32:spinnaker_src/ensemble_mess_data_core_2.c **** -6.50250497782,
  33:spinnaker_src/ensemble_mess_data_core_2.c **** 84.5261273334,
  34:spinnaker_src/ensemble_mess_data_core_2.c **** -13.6104548192,
  35:spinnaker_src/ensemble_mess_data_core_2.c **** -19.1307539895,
  36:spinnaker_src/ensemble_mess_data_core_2.c **** -45.5519588083,
  37:spinnaker_src/ensemble_mess_data_core_2.c **** 25.2907932205,
  38:spinnaker_src/ensemble_mess_data_core_2.c **** 14.1678959567,
  39:spinnaker_src/ensemble_mess_data_core_2.c **** -16.2293426933,
  40:spinnaker_src/ensemble_mess_data_core_2.c **** -14.9068722356,
  41:spinnaker_src/ensemble_mess_data_core_2.c **** 9.59205669279,
  42:spinnaker_src/ensemble_mess_data_core_2.c **** 68.7016701849,
  43:spinnaker_src/ensemble_mess_data_core_2.c **** -7.49145873612,
  44:spinnaker_src/ensemble_mess_data_core_2.c **** -10.1277954477,
  45:spinnaker_src/ensemble_mess_data_core_2.c **** -6.80319440842,
  46:spinnaker_src/ensemble_mess_data_core_2.c **** 54.7956283758,
  47:spinnaker_src/ensemble_mess_data_core_2.c **** 6.48823863117,
  48:spinnaker_src/ensemble_mess_data_core_2.c **** -135.603289616,
  49:spinnaker_src/ensemble_mess_data_core_2.c **** -39.1391175529,
  50:spinnaker_src/ensemble_mess_data_core_2.c **** 59.5829347274,
  51:spinnaker_src/ensemble_mess_data_core_2.c **** -47.7665612363,
  52:spinnaker_src/ensemble_mess_data_core_2.c **** -14.4113183946,
  53:spinnaker_src/ensemble_mess_data_core_2.c **** 23.4005288977,
  54:spinnaker_src/ensemble_mess_data_core_2.c **** 21.5331514752,
  55:spinnaker_src/ensemble_mess_data_core_2.c **** 6.28891327609,
  56:spinnaker_src/ensemble_mess_data_core_2.c **** 18.3072033156,
  57:spinnaker_src/ensemble_mess_data_core_2.c **** -8.79392839051,
  58:spinnaker_src/ensemble_mess_data_core_2.c **** 881.197124698,
  59:spinnaker_src/ensemble_mess_data_core_2.c **** 26.1951127414,
  60:spinnaker_src/ensemble_mess_data_core_2.c **** 19.7227934496,
  61:spinnaker_src/ensemble_mess_data_core_2.c **** -11.7927313439,
  62:spinnaker_src/ensemble_mess_data_core_2.c **** -10.5576314314,
  63:spinnaker_src/ensemble_mess_data_core_2.c **** 246.800286783,
  64:spinnaker_src/ensemble_mess_data_core_2.c **** 343.125260754,
  65:spinnaker_src/ensemble_mess_data_core_2.c **** -14.6024248264,
  66:spinnaker_src/ensemble_mess_data_core_2.c **** 21.1918571143,
  67:spinnaker_src/ensemble_mess_data_core_2.c **** -17.7451668855,
  68:spinnaker_src/ensemble_mess_data_core_2.c **** -18.8508102526,
  69:spinnaker_src/ensemble_mess_data_core_2.c **** -9.10223318162,
  70:spinnaker_src/ensemble_mess_data_core_2.c **** -31.64980606,
  71:spinnaker_src/ensemble_mess_data_core_2.c **** 16.4955813057,
  72:spinnaker_src/ensemble_mess_data_core_2.c **** 10.9170465453,
  73:spinnaker_src/ensemble_mess_data_core_2.c **** -13.0975470579,
  74:spinnaker_src/ensemble_mess_data_core_2.c **** 28.8617494447,
  75:spinnaker_src/ensemble_mess_data_core_2.c **** 12.7234351985,
  76:spinnaker_src/ensemble_mess_data_core_2.c **** -16.031882437,
  77:spinnaker_src/ensemble_mess_data_core_2.c **** -15.2977806096,
  78:spinnaker_src/ensemble_mess_data_core_2.c **** 12.1167136418,
  79:spinnaker_src/ensemble_mess_data_core_2.c **** -22.0867610733,
  80:spinnaker_src/ensemble_mess_data_core_2.c **** -87.8245159637,
  81:spinnaker_src/ensemble_mess_data_core_2.c **** 26.1420410432,
  82:spinnaker_src/ensemble_mess_data_core_2.c **** 23.223505432,
  83:spinnaker_src/ensemble_mess_data_core_2.c **** 20.8673598204,
  84:spinnaker_src/ensemble_mess_data_core_2.c **** 4.64429202101,
  85:spinnaker_src/ensemble_mess_data_core_2.c **** -5.55526567263,
  86:spinnaker_src/ensemble_mess_data_core_2.c **** -41.550092592,
  87:spinnaker_src/ensemble_mess_data_core_2.c **** 8.03778636565,
  88:spinnaker_src/ensemble_mess_data_core_2.c **** 10.9454747013,
  89:spinnaker_src/ensemble_mess_data_core_2.c **** 19.8769016793,
  90:spinnaker_src/ensemble_mess_data_core_2.c **** 39.8275128028,
  91:spinnaker_src/ensemble_mess_data_core_2.c **** -14.2026070968,
  92:spinnaker_src/ensemble_mess_data_core_2.c **** 10.6750302885,
  93:spinnaker_src/ensemble_mess_data_core_2.c **** -3.44878340452,
  94:spinnaker_src/ensemble_mess_data_core_2.c **** -6.85919721361,
  95:spinnaker_src/ensemble_mess_data_core_2.c **** -5.63882012797,
  96:spinnaker_src/ensemble_mess_data_core_2.c **** 12.0948592865,
  97:spinnaker_src/ensemble_mess_data_core_2.c **** 60.4901479371,
  98:spinnaker_src/ensemble_mess_data_core_2.c **** -8.0178027361,
  99:spinnaker_src/ensemble_mess_data_core_2.c **** 11.1141042011,
 100:spinnaker_src/ensemble_mess_data_core_2.c **** -5.72202308259,
 101:spinnaker_src/ensemble_mess_data_core_2.c **** 7.38777921867,
 102:spinnaker_src/ensemble_mess_data_core_2.c **** -216.954160215,
 103:spinnaker_src/ensemble_mess_data_core_2.c **** -7.80007113046,
 104:spinnaker_src/ensemble_mess_data_core_2.c **** 17.0629804184,
 105:spinnaker_src/ensemble_mess_data_core_2.c **** -59.2155794541,
 106:spinnaker_src/ensemble_mess_data_core_2.c **** -9.65171967762,
 107:spinnaker_src/ensemble_mess_data_core_2.c **** -14.8666854733,
 108:spinnaker_src/ensemble_mess_data_core_2.c **** 21.6309279859,
 109:spinnaker_src/ensemble_mess_data_core_2.c **** 15.1331172006,
 110:spinnaker_src/ensemble_mess_data_core_2.c **** 5.57958213725,
 111:spinnaker_src/ensemble_mess_data_core_2.c **** 179.943017482,
 112:spinnaker_src/ensemble_mess_data_core_2.c **** -33.1596066332,
 113:spinnaker_src/ensemble_mess_data_core_2.c **** 7.79711939065,
 114:spinnaker_src/ensemble_mess_data_core_2.c **** 14.4296264168,
 115:spinnaker_src/ensemble_mess_data_core_2.c **** -6.14348902359,
 116:spinnaker_src/ensemble_mess_data_core_2.c **** 24.5480138604,
 117:spinnaker_src/ensemble_mess_data_core_2.c **** -32.0253087772,
 118:spinnaker_src/ensemble_mess_data_core_2.c **** 17.635777082,
 119:spinnaker_src/ensemble_mess_data_core_2.c **** 5.09746218406,
 120:spinnaker_src/ensemble_mess_data_core_2.c **** 18.4278458442,
 121:spinnaker_src/ensemble_mess_data_core_2.c **** 9.21298792024,
 122:spinnaker_src/ensemble_mess_data_core_2.c **** 18.295286478,
 123:spinnaker_src/ensemble_mess_data_core_2.c **** 11.8441734652,
 124:spinnaker_src/ensemble_mess_data_core_2.c **** -51.843719801,
 125:spinnaker_src/ensemble_mess_data_core_2.c **** 53.4832076016,
 126:spinnaker_src/ensemble_mess_data_core_2.c **** -13.2321417042,
 127:spinnaker_src/ensemble_mess_data_core_2.c **** -6.21634339095,
 128:spinnaker_src/ensemble_mess_data_core_2.c **** 14.0040170763,
 129:spinnaker_src/ensemble_mess_data_core_2.c **** 16.7647784188,
 130:spinnaker_src/ensemble_mess_data_core_2.c **** 17.5585200221,
 131:spinnaker_src/ensemble_mess_data_core_2.c **** -6.62695941315,
 132:spinnaker_src/ensemble_mess_data_core_2.c **** 7.78707118267,
 133:spinnaker_src/ensemble_mess_data_core_2.c **** -9.757554627,
 134:spinnaker_src/ensemble_mess_data_core_2.c **** -4.88523620528,
 135:spinnaker_src/ensemble_mess_data_core_2.c **** -7.57363860716,
 136:spinnaker_src/ensemble_mess_data_core_2.c **** 59.3455886395,
 137:spinnaker_src/ensemble_mess_data_core_2.c **** -20.9260891795,
 138:spinnaker_src/ensemble_mess_data_core_2.c **** 28.4642657101,
 139:spinnaker_src/ensemble_mess_data_core_2.c **** -19.6604893535,
 140:spinnaker_src/ensemble_mess_data_core_2.c **** 17.2309977031,
 141:spinnaker_src/ensemble_mess_data_core_2.c **** 63.0259150922,
 142:spinnaker_src/ensemble_mess_data_core_2.c **** -15.7224263588,
 143:spinnaker_src/ensemble_mess_data_core_2.c **** -5.50035240236,
 144:spinnaker_src/ensemble_mess_data_core_2.c **** -10.6064937235,
 145:spinnaker_src/ensemble_mess_data_core_2.c **** -132.020389279,
 146:spinnaker_src/ensemble_mess_data_core_2.c **** 14.7294632268,
 147:spinnaker_src/ensemble_mess_data_core_2.c **** 14.9292100325,
 148:spinnaker_src/ensemble_mess_data_core_2.c **** -6.62509504129,
 149:spinnaker_src/ensemble_mess_data_core_2.c **** 9.22184828983,
 150:spinnaker_src/ensemble_mess_data_core_2.c **** -11.2110254222,
 151:spinnaker_src/ensemble_mess_data_core_2.c **** -7.11779779477,
 152:spinnaker_src/ensemble_mess_data_core_2.c **** 18.6649157103,
 153:spinnaker_src/ensemble_mess_data_core_2.c **** 52.197174007,
 154:spinnaker_src/ensemble_mess_data_core_2.c **** 6.53788186746
 155:spinnaker_src/ensemble_mess_data_core_2.c **** };
 156:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t bias2[150]={
 157:spinnaker_src/ensemble_mess_data_core_2.c **** -8.66879784906,
 158:spinnaker_src/ensemble_mess_data_core_2.c **** -24.9467834035,
 159:spinnaker_src/ensemble_mess_data_core_2.c **** 6.22874470377,
 160:spinnaker_src/ensemble_mess_data_core_2.c **** 4.0053503702,
 161:spinnaker_src/ensemble_mess_data_core_2.c **** -16.7017160494,
 162:spinnaker_src/ensemble_mess_data_core_2.c **** 15.9313096505,
 163:spinnaker_src/ensemble_mess_data_core_2.c **** 10.6468123226,
 164:spinnaker_src/ensemble_mess_data_core_2.c **** 10.1821589396,
 165:spinnaker_src/ensemble_mess_data_core_2.c **** -1.78663309068,
 166:spinnaker_src/ensemble_mess_data_core_2.c **** 0.913743885709,
 167:spinnaker_src/ensemble_mess_data_core_2.c **** 3.46084735305,
 168:spinnaker_src/ensemble_mess_data_core_2.c **** 4.23818703522,
 169:spinnaker_src/ensemble_mess_data_core_2.c **** -10.555323853,
 170:spinnaker_src/ensemble_mess_data_core_2.c **** 5.21376383022,
 171:spinnaker_src/ensemble_mess_data_core_2.c **** 10.2464907567,
 172:spinnaker_src/ensemble_mess_data_core_2.c **** -3.40127167508,
 173:spinnaker_src/ensemble_mess_data_core_2.c **** 1.86365953365,
 174:spinnaker_src/ensemble_mess_data_core_2.c **** 14.2335878255,
 175:spinnaker_src/ensemble_mess_data_core_2.c **** 12.5520674515,
 176:spinnaker_src/ensemble_mess_data_core_2.c **** -91.0789853316,
 177:spinnaker_src/ensemble_mess_data_core_2.c **** -33.6302859117,
 178:spinnaker_src/ensemble_mess_data_core_2.c **** 15.9363616293,
 179:spinnaker_src/ensemble_mess_data_core_2.c **** 5.74240323617,
 180:spinnaker_src/ensemble_mess_data_core_2.c **** 3.36499627951,
 181:spinnaker_src/ensemble_mess_data_core_2.c **** 0.803100327194,
 182:spinnaker_src/ensemble_mess_data_core_2.c **** -50.5504728053,
 183:spinnaker_src/ensemble_mess_data_core_2.c **** -0.47026811228,
 184:spinnaker_src/ensemble_mess_data_core_2.c **** 6.54546597893,
 185:spinnaker_src/ensemble_mess_data_core_2.c **** -73.0532183341,
 186:spinnaker_src/ensemble_mess_data_core_2.c **** 11.1649918343,
 187:spinnaker_src/ensemble_mess_data_core_2.c **** 2.91740127853,
 188:spinnaker_src/ensemble_mess_data_core_2.c **** -15.6766752106,
 189:spinnaker_src/ensemble_mess_data_core_2.c **** -5.78452778013,
 190:spinnaker_src/ensemble_mess_data_core_2.c **** 6.44282845512,
 191:spinnaker_src/ensemble_mess_data_core_2.c **** -1.05721777492,
 192:spinnaker_src/ensemble_mess_data_core_2.c **** -1.90104627256,
 193:spinnaker_src/ensemble_mess_data_core_2.c **** 9.34254445457,
 194:spinnaker_src/ensemble_mess_data_core_2.c **** -50.3689336363,
 195:spinnaker_src/ensemble_mess_data_core_2.c **** 2.56249757592,
 196:spinnaker_src/ensemble_mess_data_core_2.c **** 2.32425971805,
 197:spinnaker_src/ensemble_mess_data_core_2.c **** 1.42843665865,
 198:spinnaker_src/ensemble_mess_data_core_2.c **** -34.2366976825,
 199:spinnaker_src/ensemble_mess_data_core_2.c **** 2.46286300588,
 200:spinnaker_src/ensemble_mess_data_core_2.c **** -120.186315486,
 201:spinnaker_src/ensemble_mess_data_core_2.c **** -0.241202497705,
 202:spinnaker_src/ensemble_mess_data_core_2.c **** -27.1566639922,
 203:spinnaker_src/ensemble_mess_data_core_2.c **** -24.4847765481,
 204:spinnaker_src/ensemble_mess_data_core_2.c **** 12.7309863664,
 205:spinnaker_src/ensemble_mess_data_core_2.c **** -1.79005765455,
 206:spinnaker_src/ensemble_mess_data_core_2.c **** 15.9858447149,
 207:spinnaker_src/ensemble_mess_data_core_2.c **** 3.1162136662,
 208:spinnaker_src/ensemble_mess_data_core_2.c **** 1.16670553673,
 209:spinnaker_src/ensemble_mess_data_core_2.c **** 4.46747740102,
 210:spinnaker_src/ensemble_mess_data_core_2.c **** -868.574073205,
 211:spinnaker_src/ensemble_mess_data_core_2.c **** 10.7438129708,
 212:spinnaker_src/ensemble_mess_data_core_2.c **** 7.64642641603,
 213:spinnaker_src/ensemble_mess_data_core_2.c **** -0.480564642975,
 214:spinnaker_src/ensemble_mess_data_core_2.c **** 6.43625480861,
 215:spinnaker_src/ensemble_mess_data_core_2.c **** -225.420804281,
 216:spinnaker_src/ensemble_mess_data_core_2.c **** -325.713769476,
 217:spinnaker_src/ensemble_mess_data_core_2.c **** -1.8943613561,
 218:spinnaker_src/ensemble_mess_data_core_2.c **** -13.2179189051,
 219:spinnaker_src/ensemble_mess_data_core_2.c **** 4.63455347366,
 220:spinnaker_src/ensemble_mess_data_core_2.c **** 4.20469379484,
 221:spinnaker_src/ensemble_mess_data_core_2.c **** 3.70993978894,
 222:spinnaker_src/ensemble_mess_data_core_2.c **** -23.7202920571,
 223:spinnaker_src/ensemble_mess_data_core_2.c **** -8.61991330703,
 224:spinnaker_src/ensemble_mess_data_core_2.c **** 11.447860521,
 225:spinnaker_src/ensemble_mess_data_core_2.c **** 9.57199189386,
 226:spinnaker_src/ensemble_mess_data_core_2.c **** 2.38830636981,
 227:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0157223815159,
 228:spinnaker_src/ensemble_mess_data_core_2.c **** 2.13577146339,
 229:spinnaker_src/ensemble_mess_data_core_2.c **** 5.25645768428,
 230:spinnaker_src/ensemble_mess_data_core_2.c **** 11.4002763649,
 231:spinnaker_src/ensemble_mess_data_core_2.c **** 14.4562011292,
 232:spinnaker_src/ensemble_mess_data_core_2.c **** -75.2503601967,
 233:spinnaker_src/ensemble_mess_data_core_2.c **** -7.38890894367,
 234:spinnaker_src/ensemble_mess_data_core_2.c **** 6.64150736643,
 235:spinnaker_src/ensemble_mess_data_core_2.c **** 9.58899125983,
 236:spinnaker_src/ensemble_mess_data_core_2.c **** 5.02813833991,
 237:spinnaker_src/ensemble_mess_data_core_2.c **** 4.83553940906,
 238:spinnaker_src/ensemble_mess_data_core_2.c **** -29.0318551821,
 239:spinnaker_src/ensemble_mess_data_core_2.c **** 2.68142637864,
 240:spinnaker_src/ensemble_mess_data_core_2.c **** -0.742174405252,
 241:spinnaker_src/ensemble_mess_data_core_2.c **** 12.8807755573,
 242:spinnaker_src/ensemble_mess_data_core_2.c **** -21.4870021446,
 243:spinnaker_src/ensemble_mess_data_core_2.c **** 11.1447026034,
 244:spinnaker_src/ensemble_mess_data_core_2.c **** 6.12723119019,
 245:spinnaker_src/ensemble_mess_data_core_2.c **** 4.31857582007,
 246:spinnaker_src/ensemble_mess_data_core_2.c **** 7.36266643832,
 247:spinnaker_src/ensemble_mess_data_core_2.c **** 4.37287406863,
 248:spinnaker_src/ensemble_mess_data_core_2.c **** -1.20543225244,
 249:spinnaker_src/ensemble_mess_data_core_2.c **** -34.4986246222,
 250:spinnaker_src/ensemble_mess_data_core_2.c **** 6.03628973957,
 251:spinnaker_src/ensemble_mess_data_core_2.c **** 7.13357697601,
 252:spinnaker_src/ensemble_mess_data_core_2.c **** 4.74266313889,
 253:spinnaker_src/ensemble_mess_data_core_2.c **** -0.138831711682,
 254:spinnaker_src/ensemble_mess_data_core_2.c **** -206.803634034,
 255:spinnaker_src/ensemble_mess_data_core_2.c **** 0.604933020973,
 256:spinnaker_src/ensemble_mess_data_core_2.c **** 17.4682657714,
 257:spinnaker_src/ensemble_mess_data_core_2.c **** -25.9339419604,
 258:spinnaker_src/ensemble_mess_data_core_2.c **** 5.92784206012,
 259:spinnaker_src/ensemble_mess_data_core_2.c **** 14.4283679876,
 260:spinnaker_src/ensemble_mess_data_core_2.c **** -10.461536782,
 261:spinnaker_src/ensemble_mess_data_core_2.c **** 13.6288618546,
 262:spinnaker_src/ensemble_mess_data_core_2.c **** 5.01957032013,
 263:spinnaker_src/ensemble_mess_data_core_2.c **** -163.147335824,
 264:spinnaker_src/ensemble_mess_data_core_2.c **** -21.4375560723,
 265:spinnaker_src/ensemble_mess_data_core_2.c **** 3.37850190032,
 266:spinnaker_src/ensemble_mess_data_core_2.c **** 4.02590278293,
 267:spinnaker_src/ensemble_mess_data_core_2.c **** 4.59457692846,
 268:spinnaker_src/ensemble_mess_data_core_2.c **** -3.08610967536,
 269:spinnaker_src/ensemble_mess_data_core_2.c **** 7.19289730827,
 270:spinnaker_src/ensemble_mess_data_core_2.c **** 14.0747685255,
 271:spinnaker_src/ensemble_mess_data_core_2.c **** 3.65523227357,
 272:spinnaker_src/ensemble_mess_data_core_2.c **** -11.0654967273,
 273:spinnaker_src/ensemble_mess_data_core_2.c **** 6.70782493776,
 274:spinnaker_src/ensemble_mess_data_core_2.c **** 12.6637097645,
 275:spinnaker_src/ensemble_mess_data_core_2.c **** 10.2437891432,
 276:spinnaker_src/ensemble_mess_data_core_2.c **** -22.1988550859,
 277:spinnaker_src/ensemble_mess_data_core_2.c **** -33.4200157639,
 278:spinnaker_src/ensemble_mess_data_core_2.c **** -0.200994874704,
 279:spinnaker_src/ensemble_mess_data_core_2.c **** 5.86024173459,
 280:spinnaker_src/ensemble_mess_data_core_2.c **** 8.1890736953,
 281:spinnaker_src/ensemble_mess_data_core_2.c **** 8.05446252245,
 282:spinnaker_src/ensemble_mess_data_core_2.c **** 9.93351308894,
 283:spinnaker_src/ensemble_mess_data_core_2.c **** 3.05440940169,
 284:spinnaker_src/ensemble_mess_data_core_2.c **** 3.70572782043,
 285:spinnaker_src/ensemble_mess_data_core_2.c **** -2.3017963414,
 286:spinnaker_src/ensemble_mess_data_core_2.c **** 4.99289122274,
 287:spinnaker_src/ensemble_mess_data_core_2.c **** 6.23861243051,
 288:spinnaker_src/ensemble_mess_data_core_2.c **** -33.1418674746,
 289:spinnaker_src/ensemble_mess_data_core_2.c **** 13.6916517316,
 290:spinnaker_src/ensemble_mess_data_core_2.c **** -2.15887035399,
 291:spinnaker_src/ensemble_mess_data_core_2.c **** -0.326076968345,
 292:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0336726832698,
 293:spinnaker_src/ensemble_mess_data_core_2.c **** -53.6164630389,
 294:spinnaker_src/ensemble_mess_data_core_2.c **** 6.95037339497,
 295:spinnaker_src/ensemble_mess_data_core_2.c **** 5.98232435322,
 296:spinnaker_src/ensemble_mess_data_core_2.c **** 9.54834000127,
 297:spinnaker_src/ensemble_mess_data_core_2.c **** -115.410691696,
 298:spinnaker_src/ensemble_mess_data_core_2.c **** 0.487308060211,
 299:spinnaker_src/ensemble_mess_data_core_2.c **** 7.43244104312,
 300:spinnaker_src/ensemble_mess_data_core_2.c **** 2.26051809562,
 301:spinnaker_src/ensemble_mess_data_core_2.c **** 5.85800191168,
 302:spinnaker_src/ensemble_mess_data_core_2.c **** -2.74926060354,
 303:spinnaker_src/ensemble_mess_data_core_2.c **** 6.25346312005,
 304:spinnaker_src/ensemble_mess_data_core_2.c **** -2.90306890823,
 305:spinnaker_src/ensemble_mess_data_core_2.c **** -25.150923975,
 306:spinnaker_src/ensemble_mess_data_core_2.c **** 4.0153622072
 307:spinnaker_src/ensemble_mess_data_core_2.c **** };
 308:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t decoders2[150*1]={
 309:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 310:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 311:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 312:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 313:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 314:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 315:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 316:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 317:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 318:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 319:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 320:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 321:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 322:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 323:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 324:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 325:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 326:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 327:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 328:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 329:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 330:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 331:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 332:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 333:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 334:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 335:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 336:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 337:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 338:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 339:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 340:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 341:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 342:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 343:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 344:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 345:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 346:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 347:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 348:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 349:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 350:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 351:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 352:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 353:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 354:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 355:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 356:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 357:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 358:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 359:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 360:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 361:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 362:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 363:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 364:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 365:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 366:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 367:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 368:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 369:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 370:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 371:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 372:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 373:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 374:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 375:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 376:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 377:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 378:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 379:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 380:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 381:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 382:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 383:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 384:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 385:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 386:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 387:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 388:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 389:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 390:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 391:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 392:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 393:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 394:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 395:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 396:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 397:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 398:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 399:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 400:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 401:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 402:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 403:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 404:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 405:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 406:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 407:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 408:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 409:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 410:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 411:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 412:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 413:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 414:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 415:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 416:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 417:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 418:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 419:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 420:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 421:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 422:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 423:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 424:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 425:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 426:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 427:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 428:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 429:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 430:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 431:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 432:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 433:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 434:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 435:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 436:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 437:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 438:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 439:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 440:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 441:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 442:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 443:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 444:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 445:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 446:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 447:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 448:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 449:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 450:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 451:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 452:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 453:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 454:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 455:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 456:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 457:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0,
 458:spinnaker_src/ensemble_mess_data_core_2.c **** 0.0
 459:spinnaker_src/ensemble_mess_data_core_2.c **** };
 460:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t inputs2[1];
 461:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t outputs2[1];
 462:spinnaker_src/ensemble_mess_data_core_2.c **** neuron_t neurons2[150];
 463:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t input_currents2[150];
 464:spinnaker_src/ensemble_mess_data_core_2.c **** REAL learning_activity2[150];
 465:spinnaker_src/ensemble_mess_data_core_2.c **** REAL error2[1];
 466:spinnaker_src/ensemble_mess_data_core_2.c **** REAL delta2[150];
 467:spinnaker_src/ensemble_mess_data_core_2.c **** ensemble_t ensembles[1];
 468:spinnaker_src/ensemble_mess_data_core_2.c **** uint32_t n_ensembles= 1;
 469:spinnaker_src/ensemble_mess_data_core_2.c **** void ensemble_init(){
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
 470:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].encoders = encoders2;
  45              		.loc 1 470 0
  46 0004 1B4B     		ldr	r3, .L3
  47 0006 1C4A     		ldr	r2, .L3+4
 471:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].bias     = bias2;
  48              		.loc 1 471 0
  49 0008 DFF888A0 		ldr	r10, .L3+32
 472:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].decoders = decoders2;
  50              		.loc 1 472 0
  51 000c DFF88890 		ldr	r9, .L3+36
 470:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].encoders = encoders2;
  52              		.loc 1 470 0
  53 0010 1A60     		str	r2, [r3]
 473:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_inputs = 1;
 474:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_neurons= 150;
  54              		.loc 1 474 0
  55 0012 9622     		movs	r2, #150
 475:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_outputs= 1;
 476:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].tau_rc   = 20.0;
 477:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].tau_ref  = 2.0;
 478:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].obj_id   = 2;
 479:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].inputs   = inputs2;
 480:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].outputs  = outputs2;
 481:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].neurons  = neurons2;
 482:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].input_currents= input_currents2;
 483:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_activity= learning_activity2;
 484:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_enabled = 1;
 485:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_rate = 0.000666666666667;
  56              		.loc 1 485 0
  57 0014 194D     		ldr	r5, .L3+8
 486:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_scale = 0.904837418036;
  58              		.loc 1 486 0
  59 0016 1A4C     		ldr	r4, .L3+12
 479:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].outputs  = outputs2;
  60              		.loc 1 479 0
  61 0018 DFF88080 		ldr	r8, .L3+40
 480:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].neurons  = neurons2;
  62              		.loc 1 480 0
  63 001c DFF880C0 		ldr	ip, .L3+44
 481:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].input_currents= input_currents2;
  64              		.loc 1 481 0
  65 0020 DFF880E0 		ldr	lr, .L3+48
 482:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_activity= learning_activity2;
  66              		.loc 1 482 0
  67 0024 174F     		ldr	r7, .L3+16
 483:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_enabled = 1;
  68              		.loc 1 483 0
  69 0026 184E     		ldr	r6, .L3+20
 487:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].error = error2;
  70              		.loc 1 487 0
  71 0028 1848     		ldr	r0, .L3+24
 488:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].delta = delta2;
  72              		.loc 1 488 0
  73 002a 1949     		ldr	r1, .L3+28
 476:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].tau_ref  = 2.0;
  74              		.loc 1 476 0
  75 002c DFF878B0 		ldr	fp, .L3+52
 471:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].decoders = decoders2;
  76              		.loc 1 471 0
  77 0030 C3F804A0 		str	r10, [r3, #4]
 472:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_inputs = 1;
  78              		.loc 1 472 0
  79 0034 C3F80890 		str	r9, [r3, #8]
 477:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].obj_id   = 2;
  80              		.loc 1 477 0
  81 0038 4FF0804A 		mov	r10, #1073741824
 478:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].inputs   = inputs2;
  82              		.loc 1 478 0
  83 003c 4FF00209 		mov	r9, #2
 474:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_outputs= 1;
  84              		.loc 1 474 0
  85 0040 1A61     		str	r2, [r3, #16]
 473:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_neurons= 150;
  86              		.loc 1 473 0
  87 0042 0122     		movs	r2, #1
 476:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].tau_ref  = 2.0;
  88              		.loc 1 476 0
  89 0044 C3F818B0 		str	fp, [r3, #24]	@ float
 477:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].obj_id   = 2;
  90              		.loc 1 477 0
  91 0048 C3F81CA0 		str	r10, [r3, #28]	@ float
 478:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].inputs   = inputs2;
  92              		.loc 1 478 0
  93 004c C3F82090 		str	r9, [r3, #32]
 479:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].outputs  = outputs2;
  94              		.loc 1 479 0
  95 0050 C3F82480 		str	r8, [r3, #36]
 480:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].neurons  = neurons2;
  96              		.loc 1 480 0
  97 0054 C3F828C0 		str	ip, [r3, #40]
 481:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].input_currents= input_currents2;
  98              		.loc 1 481 0
  99 0058 C3F82CE0 		str	lr, [r3, #44]
 482:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_activity= learning_activity2;
 100              		.loc 1 482 0
 101 005c 1F63     		str	r7, [r3, #48]
 483:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_enabled = 1;
 102              		.loc 1 483 0
 103 005e DE63     		str	r6, [r3, #60]
 485:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_scale = 0.904837418036;
 104              		.loc 1 485 0
 105 0060 5D63     		str	r5, [r3, #52]	@ float
 486:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].error = error2;
 106              		.loc 1 486 0
 107 0062 9C63     		str	r4, [r3, #56]	@ float
 487:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].delta = delta2;
 108              		.loc 1 487 0
 109 0064 5864     		str	r0, [r3, #68]
 110              		.loc 1 488 0
 111 0066 9964     		str	r1, [r3, #72]
 473:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].n_neurons= 150;
 112              		.loc 1 473 0
 113 0068 DA60     		str	r2, [r3, #12]
 475:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].tau_rc   = 20.0;
 114              		.loc 1 475 0
 115 006a 5A61     		str	r2, [r3, #20]
 484:spinnaker_src/ensemble_mess_data_core_2.c **** ensembles[0].learning_rate = 0.000666666666667;
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
 126 0084 00000000 		.word	input_currents2
 127 0088 00000000 		.word	learning_activity2
 128 008c 00000000 		.word	error2
 129 0090 00000000 		.word	delta2
 130 0094 00000000 		.word	.LANCHOR1
 131 0098 00000000 		.word	.LANCHOR2
 132 009c 00000000 		.word	inputs2
 133 00a0 00000000 		.word	outputs2
 134 00a4 00000000 		.word	neurons2
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
 489:spinnaker_src/ensemble_mess_data_core_2.c **** }
 490:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t pre_values4[1];
 491:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t post_values4[1];
 492:spinnaker_src/ensemble_mess_data_core_2.c **** precision_t matrix4[1*1]={
 493:spinnaker_src/ensemble_mess_data_core_2.c **** 1.0
 494:spinnaker_src/ensemble_mess_data_core_2.c **** };
 495:spinnaker_src/ensemble_mess_data_core_2.c **** message_t mess[1];
 496:spinnaker_src/ensemble_mess_data_core_2.c **** uint32_t n_mess= 1;
 497:spinnaker_src/ensemble_mess_data_core_2.c **** void mess_init(){
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
 498:spinnaker_src/ensemble_mess_data_core_2.c **** 
 499:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_obj_id = 3;
 158              		.loc 1 499 0
 159 0002 0F4B     		ldr	r3, .L7
 500:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_start  = 0;
 501:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_len    = 1;
 502:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_obj_id= 2;
 503:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_start = 0;
 504:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_len   = 1;
 505:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].mess_id    = 4;
 506:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].use_synapse_scale= 0;
 507:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].synapse_scale= 0;
 508:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_values = pre_values4;
 160              		.loc 1 508 0
 161 0004 0F4E     		ldr	r6, .L7+4
 509:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_values = post_values4;
 162              		.loc 1 509 0
 163 0006 104D     		ldr	r5, .L7+8
 510:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].ens_input = &inputs2[0];
 164              		.loc 1 510 0
 165 0008 104C     		ldr	r4, .L7+12
 511:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].matrix      = matrix4;
 166              		.loc 1 511 0
 167 000a 1148     		ldr	r0, .L7+16
 508:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_values = post_values4;
 168              		.loc 1 508 0
 169 000c 5E62     		str	r6, [r3, #36]
 507:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_values = pre_values4;
 170              		.loc 1 507 0
 171 000e 0022     		movs	r2, #0
 500:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_len    = 1;
 172              		.loc 1 500 0
 173 0010 0021     		movs	r1, #0
 507:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_values = pre_values4;
 174              		.loc 1 507 0
 175 0012 1A62     		str	r2, [r3, #32]	@ float
 499:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_start  = 0;
 176              		.loc 1 499 0
 177 0014 4FF0030C 		mov	ip, #3
 501:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_obj_id= 2;
 178              		.loc 1 501 0
 179 0018 0122     		movs	r2, #1
 502:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_start = 0;
 180              		.loc 1 502 0
 181 001a 4FF0020E 		mov	lr, #2
 505:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].use_synapse_scale= 0;
 182              		.loc 1 505 0
 183 001e 0427     		movs	r7, #4
 499:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_start  = 0;
 184              		.loc 1 499 0
 185 0020 C3F800C0 		str	ip, [r3]
 502:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_start = 0;
 186              		.loc 1 502 0
 187 0024 C3F80CE0 		str	lr, [r3, #12]
 505:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].use_synapse_scale= 0;
 188              		.loc 1 505 0
 189 0028 9F61     		str	r7, [r3, #24]
 509:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].ens_input = &inputs2[0];
 190              		.loc 1 509 0
 191 002a 9D62     		str	r5, [r3, #40]
 510:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].matrix      = matrix4;
 192              		.loc 1 510 0
 193 002c DC62     		str	r4, [r3, #44]
 194              		.loc 1 511 0
 195 002e 1863     		str	r0, [r3, #48]
 500:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].pre_len    = 1;
 196              		.loc 1 500 0
 197 0030 5960     		str	r1, [r3, #4]
 503:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_len   = 1;
 198              		.loc 1 503 0
 199 0032 1961     		str	r1, [r3, #16]
 506:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].synapse_scale= 0;
 200              		.loc 1 506 0
 201 0034 D961     		str	r1, [r3, #28]
 501:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].post_obj_id= 2;
 202              		.loc 1 501 0
 203 0036 9A60     		str	r2, [r3, #8]
 504:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].mess_id    = 4;
 204              		.loc 1 504 0
 205 0038 5A61     		str	r2, [r3, #20]
 512:spinnaker_src/ensemble_mess_data_core_2.c **** mess[0].matrix_is_scalar = 1;
 206              		.loc 1 512 0
 207 003a 5A63     		str	r2, [r3, #52]
 208 003c F0BD     		pop	{r4, r5, r6, r7, pc}
 209              	.L8:
 210 003e 00BF     		.align	2
 211              	.L7:
 212 0040 00000000 		.word	mess
 213 0044 00000000 		.word	pre_values4
 214 0048 00000000 		.word	post_values4
 215 004c 00000000 		.word	inputs2
 216 0050 00000000 		.word	.LANCHOR3
 217              		.cfi_endproc
 218              	.LFE157:
 220              		.global	n_mess
 221              		.comm	mess,60,4
 222              		.global	matrix4
 223              		.comm	post_values4,4,4
 224              		.comm	pre_values4,4,4
 225              		.global	n_ensembles
 226              		.comm	ensembles,80,4
 227              		.comm	delta2,600,4
 228              		.comm	error2,4,4
 229              		.comm	learning_activity2,600,4
 230              		.comm	input_currents2,600,4
 231              		.comm	neurons2,1200,4
 232              		.comm	outputs2,4,4
 233              		.comm	inputs2,4,4
 234              		.global	decoders2
 235              		.global	bias2
 236              		.global	encoders2
 237              		.section	.data.n_mess,"aw",%progbits
 238              		.align	2
 241              	n_mess:
 242 0000 01000000 		.word	1
 243              		.section	.data.bias2,"aw",%progbits
 244              		.align	2
 245              		.set	.LANCHOR1,. + 0
 248              	bias2:
 249 0000 65B30AC1 		.word	3238703973
 250 0004 0393C7C1 		.word	3251081987
 251 0008 E051C740 		.word	1086804448
 252 000c D52B8040 		.word	1082141653
 253 0010 1D9D85C1 		.word	3246759197
 254 0014 A5E67E41 		.word	1098835621
 255 0018 58592A41 		.word	1093294424
 256 001c 1FEA2241 		.word	1092807199
 257 0020 65B0E4BF 		.word	3219435621
 258 0024 1FEB693F 		.word	1063906079
 259 0028 867E5D40 		.word	1079869062
 260 002c 3A9F8740 		.word	1082629946
 261 0030 9BE228C1 		.word	3240682139
 262 0034 27D7A640 		.word	1084675879
 263 0038 A0F12341 		.word	1092874656
 264 003c 6FAE59C0 		.word	3227102831
 265 0040 658CEE3F 		.word	1072598117
 266 0044 C7BC6341 		.word	1097055431
 267 0048 45D54841 		.word	1095292229
 268 004c 7128B6C2 		.word	3266717809
 269 0050 6A8506C2 		.word	3255207274
 270 0054 56FB7E41 		.word	1098840918
 271 0058 C4C1B740 		.word	1085784516
 272 005c 195C5740 		.word	1079467033
 273 0060 FC974D3F 		.word	1062049788
 274 0064 AF334AC2 		.word	3259642799
 275 0068 FBC6F0BE 		.word	3203450619
 276 006c 7574D140 		.word	1087468661
 277 0070 3F1B92C2 		.word	3264355135
 278 0074 CEA33241 		.word	1093837774
 279 0078 B4B63A40 		.word	1077589684
 280 007c A9D37AC1 		.word	3246052265
 281 0080 DA1AB9C0 		.word	3233356506
 282 0084 A72BCE40 		.word	1087253415
 283 0088 E95287BF 		.word	3213316841
 284 008c 7C55F3BF 		.word	3220395388
 285 0090 107B1541 		.word	1091926800
 286 0094 CA7949C2 		.word	3259595210
 287 0098 F6FF2340 		.word	1076101110
 288 009c ACC01440 		.word	1075101868
 289 00a0 03D7B63F 		.word	1068947203
 290 00a4 61F208C2 		.word	3255366241
 291 00a8 8C9F1D40 		.word	1075683212
 292 00ac 655FF0C2 		.word	3270532965
 293 00b0 CAFD76BE 		.word	3195469258
 294 00b4 D940D9C1 		.word	3252240601
 295 00b8 D3E0C3C1 		.word	3250839763
 296 00bc 1FB24B41 		.word	1095479839
 297 00c0 9C20E5BF 		.word	3219464348
 298 00c4 05C67F41 		.word	1098892805
 299 00c8 0B704740 		.word	1078423563
 300 00cc 9B56953F 		.word	1066751643
 301 00d0 93F58E40 		.word	1083110803
 302 00d4 BE2459C4 		.word	3294176446
 303 00d8 A8E62B41 		.word	1093396136
 304 00dc 86AFF440 		.word	1089777542
 305 00e0 920CF6BE 		.word	3203796114
 306 00e4 CDF5CD40 		.word	1087239629
 307 00e8 BA6B61C3 		.word	3277941690
 308 00ec 5DDBA2C3 		.word	3282230109
 309 00f0 6F7AF2BF 		.word	3220339311
 310 00f4 997C53C1 		.word	3243474073
 311 00f8 434E9440 		.word	1083461187
 312 00fc DA8C8640 		.word	1082559706
 313 0100 A76F6D40 		.word	1080913831
 314 0104 28C3BDC1 		.word	3250438952
 315 0108 2AEB09C1 		.word	3238652714
 316 010c 702A3741 		.word	1094134384
 317 0110 E1261941 		.word	1092167393
 318 0114 03DA1840 		.word	1075370499
 319 0118 39CC803C 		.word	1015073849
 320 011c 7BB00840 		.word	1074311291
 321 0120 E734A840 		.word	1084765415
 322 0124 88673641 		.word	1094084488
 323 0128 9A4C6741 		.word	1097288858
 324 012c 2F8096C2 		.word	3264643119
 325 0130 F171ECC0 		.word	3236721137
 326 0134 3A87D440 		.word	1087670074
 327 0138 826C1941 		.word	1092185218
 328 013c 82E6A040 		.word	1084286594
 329 0140 BDBC9A40 		.word	1083882685
 330 0144 3D41E8C1 		.word	3253223741
 331 0148 7D9C2B40 		.word	1076599933
 332 014c 24FF3DBF 		.word	3208511268
 333 0150 A8174E41 		.word	1095636904
 334 0154 61E5ABC1 		.word	3249268065
 335 0158 B4503241 		.word	1093816500
 336 015c 4712C440 		.word	1086591559
 337 0160 C6318A40 		.word	1082798534
 338 0164 F79AEB40 		.word	1089182455
 339 0168 96EE8B40 		.word	1082912406
 340 016c 9B4B9ABF 		.word	3214560155
 341 0170 97FE09C2 		.word	3255434903
 342 0174 4929C140 		.word	1086400841
 343 0178 4346E440 		.word	1088702019
 344 017c E5C39740 		.word	1083687909
 345 0180 E6290EBE 		.word	3188599270
 346 0184 BBCD4EC3 		.word	3276721595
 347 0188 E4DC1A3F 		.word	1058725092
 348 018c 02BF8B41 		.word	1099677442
 349 0190 B778CFC1 		.word	3251599543
 350 0194 E2B0BD40 		.word	1086173410
 351 0198 98DA6641 		.word	1097259672
 352 019c 746227C1 		.word	3240583796
 353 01a0 D10F5A41 		.word	1096421329
 354 01a4 52A0A040 		.word	1084268626
 355 01a8 B82523C3 		.word	3273860536
 356 01ac 1D80ABC1 		.word	3249242141
 357 01b0 60395840 		.word	1079523680
 358 01b4 32D48040 		.word	1082184754
 359 01b8 C6069340 		.word	1083377350
 360 01bc D28245C0 		.word	3225780946
 361 01c0 372CE640 		.word	1088826423
 362 01c4 40326141 		.word	1096888896
 363 01c8 53EF6940 		.word	1080684371
 364 01cc 460C31C1 		.word	3241217094
 365 01d0 80A6D640 		.word	1087809152
 366 01d4 8E9E4A41 		.word	1095409294
 367 01d8 8FE62341 		.word	1092871823
 368 01dc 4197B1C1 		.word	3249641281
 369 01e0 19AE05C2 		.word	3255152153
 370 01e4 9AD14DBE 		.word	3192770970
 371 01e8 1A87BB40 		.word	1086031642
 372 01ec 72060341 		.word	1090717298
 373 01f0 14DF0041 		.word	1090576148
 374 01f4 ABEF1E41 		.word	1092546475
 375 01f8 727B4340 		.word	1078164338
 376 01fc A52A6D40 		.word	1080896165
 377 0200 A25013C0 		.word	3222491298
 378 0204 C4C59F40 		.word	1084212676
 379 0208 B7A2C740 		.word	1086825143
 380 020c 469104C2 		.word	3255079238
 381 0210 01115B41 		.word	1096487169
 382 0214 EF2A0AC0 		.word	3221891823
 383 0218 8FF3A6BE 		.word	3198612367
 384 021c 5EEC093D 		.word	1024060510
 385 0220 427756C2 		.word	3260446530
 386 0224 7569DE40 		.word	1088317813
 387 0228 336FBF40 		.word	1086287667
 388 022c 00C61841 		.word	1092142592
 389 0230 46D2E6C2 		.word	3269907014
 390 0234 7180F93E 		.word	1056538737
 391 0238 8FD6ED40 		.word	1089328783
 392 023c 54AC1040 		.word	1074834516
 393 0240 C074BB40 		.word	1086026944
 394 0244 E3F32FC0 		.word	3224368099
 395 0248 5F1CC840 		.word	1086856287
 396 024c E2CB39C0 		.word	3225013218
 397 0250 1835C9C1 		.word	3251189016
 398 0254 D97D8040 		.word	1082162649
 399              		.section	.data.n_ensembles,"aw",%progbits
 400              		.align	2
 403              	n_ensembles:
 404 0000 01000000 		.word	1
 405              		.section	.bss.decoders2,"aw",%nobits
 406              		.align	2
 407              		.set	.LANCHOR2,. + 0
 410              	decoders2:
 411 0000 00000000 		.space	600
 411      00000000 
 411      00000000 
 411      00000000 
 411      00000000 
 412              		.section	.data.encoders2,"aw",%progbits
 413              		.align	2
 414              		.set	.LANCHOR0,. + 0
 417              	encoders2:
 418 0000 659BFB41 		.word	1107008357
 419 0004 1BC01342 		.word	1108590619
 420 0008 37320E41 		.word	1091449399
 421 000c 95C261C0 		.word	3227632277
 422 0010 13083FC2 		.word	3258910739
 423 0014 B654ADC1 		.word	3249362102
 424 0018 B5795441 		.word	1096055221
 425 001c 92E9A841 		.word	1101588882
 426 0020 64583141 		.word	1093752932
 427 0024 6DA43641 		.word	1094100077
 428 0028 46C1ADC0 		.word	3232612678
 429 002c 03F96240 		.word	1080228099
 430 0030 DFF9BAC1 		.word	3250256351
 431 0034 2ED435C1 		.word	3241530414
 432 0038 E89C80C1 		.word	3246431464
 433 003c E84906C2 		.word	3255192040
 434 0040 A98D0841 		.word	1091079593
 435 0044 CEA57F41 		.word	1098884558
 436 0048 9A28A0C1 		.word	3248498842
 437 004c B88EDB42 		.word	1121685176
 438 0050 35546CC2 		.word	3261879349
 439 0054 6F48A4C1 		.word	3248769135
 440 0058 B9A124C1 		.word	3240403385
 441 005c A35EA8C0 		.word	3232259747
 442 0060 699B0C41 		.word	1091345257
 443 0064 2B5589C2 		.word	3263780139
 444 0068 349BAC41 		.word	1101830964
 445 006c 8514D0C0 		.word	3234862213
 446 0070 610DA942 		.word	1118375265
 447 0074 6CC459C1 		.word	3243885676
 448 0078 C90B99C1 		.word	3248032713
 449 007c 353536C2 		.word	3258332469
 450 0080 8B53CA41 		.word	1103778699
 451 0084 B4AF6241 		.word	1096986548
 452 0088 B2D581C1 		.word	3246511538
 453 008c 8C826EC1 		.word	3245245068
 454 0090 10791941 		.word	1092188432
 455 0094 41678942 		.word	1116301121
 456 0098 08BAEFC0 		.word	3236936200
 457 009c 730B22C1 		.word	3240233843
 458 00a0 C5B3D9C0 		.word	3235492805
 459 00a4 B92E5B42 		.word	1113271993
 460 00a8 A79FCF40 		.word	1087348647
 461 00ac 719A07C3 		.word	3272055409
 462 00b0 758E1CC2 		.word	3256651381
 463 00b4 ED546E42 		.word	1114526957
 464 00b8 F5103FC2 		.word	3258913013
 465 00bc C39466C1 		.word	3244725443
 466 00c0 4834BB41 		.word	1102787656
 467 00c4 E543AC41 		.word	1101808613
 468 00c8 C73EC940 		.word	1086930631
 469 00cc 27759241 		.word	1100117287
 470 00d0 EEB30CC1 		.word	3238835182
 471 00d4 9E4C5C44 		.word	1146899614
 472 00d8 978FD141 		.word	1104252823
 473 00dc 48C89D41 		.word	1100859464
 474 00e0 07AF3CC1 		.word	3241979655
 475 00e4 0FEC28C1 		.word	3240684559
 476 00e8 E0CC7643 		.word	1131859168
 477 00ec 0990AB43 		.word	1135317001
 478 00f0 88A369C1 		.word	3244925832
 479 00f4 EC88A941 		.word	1101629676
 480 00f8 1AF68DC1 		.word	3247306266
 481 00fc 76CE96C1 		.word	3247885942
 482 0100 BFA211C1 		.word	3239158463
 483 0104 CE32FDC1 		.word	3254596302
 484 0108 F3F68341 		.word	1099167475
 485 010c 39AC2E41 		.word	1093577785
 486 0110 8E8F51C1 		.word	3243347854
 487 0114 DDE4E641 		.word	1105650909
 488 0118 31934B41 		.word	1095471921
 489 011c 4C4180C1 		.word	3246408012
 490 0120 B6C374C1 		.word	3245654966
 491 0124 0FDE4141 		.word	1094835727
 492 0128 B0B1B0C1 		.word	3249582512
 493 012c 27A6AFC2 		.word	3266291239
 494 0130 E622D141 		.word	1104224998
 495 0134 BDC9B941 		.word	1102694845
 496 0138 5AF0A641 		.word	1101459546
 497 013c 0A9E9440 		.word	1083481610
 498 0140 BDC4B1C0 		.word	3232875709
 499 0144 4B3326C2 		.word	3257283403
 500 0148 C69A0041 		.word	1090558662
 501 014c AA202F41 		.word	1093607594
 502 0150 E5039F41 		.word	1100940261
 503 0154 604F1F42 		.word	1109348192
 504 0158 E13D63C1 		.word	3244506593
 505 015c EDCC2A41 		.word	1093324013
 506 0160 DEB85CC0 		.word	3227302110
 507 0164 8B7EDBC0 		.word	3235610251
 508 0168 3771B4C0 		.word	3233050935
 509 016c 8B844141 		.word	1094812811
 510 0170 E9F57142 		.word	1114764777
 511 0174 EC4800C1 		.word	3238021356
 512 0178 5FD33141 		.word	1093784415
 513 017c D01AB7C0 		.word	3233225424
 514 0180 B068EC40 		.word	1089235120
 515 0184 44F458C3 		.word	3277386820
 516 0188 2F9AF9C0 		.word	3237583407
 517 018c FC808841 		.word	1099464956
 518 0190 C1DC6CC2 		.word	3261914305
 519 0194 726D1AC1 		.word	3239734642
 520 0198 F2DD6DC1 		.word	3245202930
 521 019c 240CAD41 		.word	1101859876
 522 01a0 40217241 		.word	1097998656
 523 01a4 F08BB240 		.word	1085443056
 524 01a8 6AF13343 		.word	1127477610
 525 01ac 70A304C2 		.word	3255083888
 526 01b0 0182F940 		.word	1090093569
 527 01b4 C0DF6641 		.word	1097260992
 528 01b8 7697C4C0 		.word	3234109302
 529 01bc 5562C441 		.word	1103389269
 530 01c0 EB1900C2 		.word	3254786539
 531 01c4 12168D41 		.word	1099765266
 532 01c8 691EA340 		.word	1084431977
 533 01cc 3A6C9341 		.word	1100180538
 534 01d0 66681341 		.word	1091790950
 535 01d4 BF5C9241 		.word	1100111039
 536 01d8 BC813D41 		.word	1094549948
 537 01dc F85F4FC2 		.word	3259981816
 538 01e0 CEEE5542 		.word	1112927950
 539 01e4 DAB653C1 		.word	3243488986
 540 01e8 49ECC6C0 		.word	3234262089
 541 01ec 74106041 		.word	1096814708
 542 01f0 441E8641 		.word	1099308612
 543 01f4 D9778C41 		.word	1099724761
 544 01f8 0D10D4C0 		.word	3235123213
 545 01fc B02FF940 		.word	1090072496
 546 0200 F21E1CC1 		.word	3239845618
 547 0204 DB539CC0 		.word	3231470555
 548 0208 3F5BF2C0 		.word	3237108543
 549 020c E2616D42 		.word	1114464738
 550 0210 A168A7C1 		.word	3248973985
 551 0214 D1B6E341 		.word	1105442513
 552 0218 AF489DC1 		.word	3248310447
 553 021c 15D98941 		.word	1099553045
 554 0220 891A7C42 		.word	1115429513
 555 0224 0F8F7BC1 		.word	3246100239
 556 0228 E302B0C0 		.word	3232760547
 557 022c 33B429C1 		.word	3240735795
 558 0230 380504C3 		.word	3271820600
 559 0234 E2AB6B41 		.word	1097575394
 560 0238 0BDE6E41 		.word	1097784843
 561 023c C700D4C0 		.word	3235119303
 562 0240 B18C1341 		.word	1091800241
 563 0244 5C6033C1 		.word	3241369692
 564 0248 00C5E3C0 		.word	3236152576
 565 024c BF519541 		.word	1100304831
 566 0250 E8C95042 		.word	1112590824
 567 0254 5436D140 		.word	1087452756
 568              		.section	.data.matrix4,"aw",%progbits
 569              		.align	2
 570              		.set	.LANCHOR3,. + 0
 573              	matrix4:
 574 0000 0000803F 		.word	1065353216
 575              		.text
 576              	.Letext0:
 577              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
 578              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
 579              		.file 4 "spinnaker_src/common/maths-util.h"
 580              		.file 5 "spinnaker_src/param_defs.h"
 581              		.file 6 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
 582              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
 583              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
