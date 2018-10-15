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
  17              		.file	"qpe_isr.c"
  18              		.text
  19              	.Ltext0:
  20              		.cfi_sections	.debug_frame
  21              		.section	.text.IRQ_00_Handler,"ax",%progbits
  22              		.align	2
  23              		.global	IRQ_00_Handler
  24              		.thumb
  25              		.thumb_func
  27              	IRQ_00_Handler:
  28              	.LFB158:
  29              		.file 1 "spinnaker_src/qpe_isr.c"
   1:spinnaker_src/qpe_isr.c **** 
   2:spinnaker_src/qpe_isr.c **** #include "qpe.h"
   3:spinnaker_src/qpe_isr.c **** #include "qpe_event_based_api.h"
   4:spinnaker_src/qpe_isr.c **** #include "qpe_event_based_api_params.h"
   5:spinnaker_src/qpe_isr.c **** #include "if_curr_exp.h"
   6:spinnaker_src/qpe_isr.c **** #include "param_defs.h"
   7:spinnaker_src/qpe_isr.c **** /*
   8:spinnaker_src/qpe_isr.c **** #include "neuron.h"
   9:spinnaker_src/qpe_isr.c **** #include "spike_processing.h"
  10:spinnaker_src/qpe_isr.c **** #include "synapses.h"
  11:spinnaker_src/qpe_isr.c **** #include "spike_source.h"
  12:spinnaker_src/qpe_isr.c **** #include "circular_buffer.h"
  13:spinnaker_src/qpe_isr.c **** */
  14:spinnaker_src/qpe_isr.c **** 
  15:spinnaker_src/qpe_isr.c **** //extern volatile bool BURST_FINISHED;
  16:spinnaker_src/qpe_isr.c **** 
  17:spinnaker_src/qpe_isr.c **** //extern volatile uint32_t systicks;
  18:spinnaker_src/qpe_isr.c **** //extern volatile uint32_t systicks_pm;
  19:spinnaker_src/qpe_isr.c **** 
  20:spinnaker_src/qpe_isr.c **** //extern int user_event_priority;
  21:spinnaker_src/qpe_isr.c **** extern int systick_callback_priority;
  22:spinnaker_src/qpe_isr.c **** 
  23:spinnaker_src/qpe_isr.c **** //extern uchar user_pending ;
  24:spinnaker_src/qpe_isr.c **** 
  25:spinnaker_src/qpe_isr.c **** extern void timer_callback(uint32_t unused1, uint32_t unused2);
  26:spinnaker_src/qpe_isr.c **** //extern void timer_send_spike_callback(uint32_t unused1, uint32_t unused2);
  27:spinnaker_src/qpe_isr.c **** //extern uint32_t debug_records[DEBUG_RECORD_LENGTH] __attribute__((aligned(0x10)));
  28:spinnaker_src/qpe_isr.c **** 
  29:spinnaker_src/qpe_isr.c **** //extern uint32_t warnings;
  30:spinnaker_src/qpe_isr.c **** 
  31:spinnaker_src/qpe_isr.c **** //extern uint32_t sleeping;
  32:spinnaker_src/qpe_isr.c **** 
  33:spinnaker_src/qpe_isr.c **** //extern uint32_t time_done;
  34:spinnaker_src/qpe_isr.c **** 
  35:spinnaker_src/qpe_isr.c **** extern uint32_t reset_wait;
  36:spinnaker_src/qpe_isr.c **** 
  37:spinnaker_src/qpe_isr.c **** //extern uint32_t fill_level2;
  38:spinnaker_src/qpe_isr.c **** 
  39:spinnaker_src/qpe_isr.c **** //extern circular_buffer input_spike_buffer;
  40:spinnaker_src/qpe_isr.c **** 
  41:spinnaker_src/qpe_isr.c **** 
  42:spinnaker_src/qpe_isr.c **** /*
  43:spinnaker_src/qpe_isr.c **** void dma_done_isr ()
  44:spinnaker_src/qpe_isr.c **** {
  45:spinnaker_src/qpe_isr.c **** 
  46:spinnaker_src/qpe_isr.c **** //set_gp_reg(21,debug_count11);
  47:spinnaker_src/qpe_isr.c **** //debug_count11++;
  48:spinnaker_src/qpe_isr.c **** 
  49:spinnaker_src/qpe_isr.c ****   __disable_irq();
  50:spinnaker_src/qpe_isr.c ****   uint completed_id  = dma_queue.queue[dma_queue.start].id;
  51:spinnaker_src/qpe_isr.c ****   uint completed_tag = dma_queue.queue[dma_queue.start].tag;
  52:spinnaker_src/qpe_isr.c **** 
  53:spinnaker_src/qpe_isr.c **** 
  54:spinnaker_src/qpe_isr.c ****   dma_queue.start = (dma_queue.start + 1) % DMA_QUEUE_SIZE;
  55:spinnaker_src/qpe_isr.c **** 
  56:spinnaker_src/qpe_isr.c ****   if(dma_queue.start != dma_queue.end)//if more dma requests
  57:spinnaker_src/qpe_isr.c ****   {
  58:spinnaker_src/qpe_isr.c **** 
  59:spinnaker_src/qpe_isr.c ****       uint tag = dma_queue.queue[dma_queue.start].tag;
  60:spinnaker_src/qpe_isr.c ****       uintptr_t system_address = dma_queue.queue[dma_queue.start].system_address;
  61:spinnaker_src/qpe_isr.c ****       uintptr_t tcm_address = dma_queue.queue[dma_queue.start].tcm_address;
  62:spinnaker_src/qpe_isr.c ****       uint  description = dma_queue.queue[dma_queue.start].description;
  63:spinnaker_src/qpe_isr.c **** 
  64:spinnaker_src/qpe_isr.c **** 	  while (tag == DMA_TAG_SEND_SPIKE ){//if next request is send spike
  65:spinnaker_src/qpe_isr.c **** 	  
  66:spinnaker_src/qpe_isr.c ****         
  67:spinnaker_src/qpe_isr.c ****         struct spinn_packet packet;
  68:spinnaker_src/qpe_isr.c **** 
  69:spinnaker_src/qpe_isr.c ****   		
  70:spinnaker_src/qpe_isr.c **** 		//debug!
  71:spinnaker_src/qpe_isr.c **** 		if((description & ((1<<19)-1)) >> 31 == 0){
  72:spinnaker_src/qpe_isr.c ****         	packet.header  = 0x0;
  73:spinnaker_src/qpe_isr.c ****         	packet.packet  = (description & ((1<<19)-1));
  74:spinnaker_src/qpe_isr.c **** 
  75:spinnaker_src/qpe_isr.c ****         	noc_send_spinn_packet (&packet);
  76:spinnaker_src/qpe_isr.c **** 	  
  77:spinnaker_src/qpe_isr.c ****         	dma_queue.start = (dma_queue.start + 1) % DMA_QUEUE_SIZE;
  78:spinnaker_src/qpe_isr.c **** 		}
  79:spinnaker_src/qpe_isr.c **** 		else{
  80:spinnaker_src/qpe_isr.c **** 		
  81:spinnaker_src/qpe_isr.c ****         	packet.header  = 0x2;
  82:spinnaker_src/qpe_isr.c ****         	packet.packet  = (description & ((1<<19)-1));
  83:spinnaker_src/qpe_isr.c **** 			packet.payload = (uint32_t) system_address;
  84:spinnaker_src/qpe_isr.c ****         	noc_send_spinn_packet (&packet);
  85:spinnaker_src/qpe_isr.c **** 	  
  86:spinnaker_src/qpe_isr.c ****         	dma_queue.start = (dma_queue.start + 1) % DMA_QUEUE_SIZE;
  87:spinnaker_src/qpe_isr.c **** 
  88:spinnaker_src/qpe_isr.c **** 		}
  89:spinnaker_src/qpe_isr.c **** 
  90:spinnaker_src/qpe_isr.c **** 		if (dma_queue.start != dma_queue.end){//if requests not finished, take the information, 
  91:spinnaker_src/qpe_isr.c **** 												//then return to check if it is a send spike request, 
  92:spinnaker_src/qpe_isr.c **** 												//if yes, process it, if not , send the ddr2 burst (below)
  93:spinnaker_src/qpe_isr.c **** 											  //
  94:spinnaker_src/qpe_isr.c ****             tag = dma_queue.queue[dma_queue.start].tag;
  95:spinnaker_src/qpe_isr.c ****             system_address = dma_queue.queue[dma_queue.start].system_address;
  96:spinnaker_src/qpe_isr.c ****             tcm_address = dma_queue.queue[dma_queue.start].tcm_address;
  97:spinnaker_src/qpe_isr.c ****             description = dma_queue.queue[dma_queue.start].description;
  98:spinnaker_src/qpe_isr.c ****         } 
  99:spinnaker_src/qpe_isr.c **** 											  		
 100:spinnaker_src/qpe_isr.c **** 		else{//if requests finished, jump out of while, process callback function
 101:spinnaker_src/qpe_isr.c **** 
 102:spinnaker_src/qpe_isr.c **** 			break;
 103:spinnaker_src/qpe_isr.c **** 		}
 104:spinnaker_src/qpe_isr.c **** 	  }
 105:spinnaker_src/qpe_isr.c ****       
 106:spinnaker_src/qpe_isr.c **** 	  if(dma_queue.start != dma_queue.end){
 107:spinnaker_src/qpe_isr.c ****           if ((description & (1<<19))==DMA_READ)
 108:spinnaker_src/qpe_isr.c ****           {
 109:spinnaker_src/qpe_isr.c ****               //dma_read_launch (system_address, tcm_address, (description & ((1<<19)-1))*8);
 110:spinnaker_src/qpe_isr.c **** 			  //debug!
 111:spinnaker_src/qpe_isr.c **** 			  API_BURST_FINISHED=false;
 112:spinnaker_src/qpe_isr.c ****               dma_read_launch (system_address, tcm_address, (description & ((1<<19)-1)));
 113:spinnaker_src/qpe_isr.c ****   			  if((description & ((1<<19)-1))<=16){
 114:spinnaker_src/qpe_isr.c ****   			  		NVIC_SetPendingIRQ(NoCDoneRxBurst_IRQn);
 115:spinnaker_src/qpe_isr.c ****   			  }
 116:spinnaker_src/qpe_isr.c ****           }
 117:spinnaker_src/qpe_isr.c ****           else
 118:spinnaker_src/qpe_isr.c ****           {
 119:spinnaker_src/qpe_isr.c ****               //dma_write_launch (system_address, tcm_address, (description & ((1<<19)-1))*8);
 120:spinnaker_src/qpe_isr.c **** 			  //debug!
 121:spinnaker_src/qpe_isr.c **** 			  API_BURST_FINISHED=false;
 122:spinnaker_src/qpe_isr.c ****               dma_write_launch (system_address, tcm_address, (description & ((1<<19)-1)));
 123:spinnaker_src/qpe_isr.c ****   			  if((description & ((1<<19)-1))<=16){
 124:spinnaker_src/qpe_isr.c ****   			  		NVIC_SetPendingIRQ(NoCDoneTxBurst_IRQn);
 125:spinnaker_src/qpe_isr.c **** 			  }
 126:spinnaker_src/qpe_isr.c ****           }
 127:spinnaker_src/qpe_isr.c ****       }
 128:spinnaker_src/qpe_isr.c ****   }
 129:spinnaker_src/qpe_isr.c ****   if(callback[DMA_TRANSFER_DONE].cback != NULL)
 130:spinnaker_src/qpe_isr.c ****   {
 131:spinnaker_src/qpe_isr.c **** 
 132:spinnaker_src/qpe_isr.c ****     santos_schedule_callback (callback[DMA_TRANSFER_DONE].cback,  completed_tag,completed_id,callba
 133:spinnaker_src/qpe_isr.c **** 		//if (systicks > 1550 && systicks < 1610  ){
 134:spinnaker_src/qpe_isr.c **** 		
 135:spinnaker_src/qpe_isr.c **** 			//set_gp_reg(debug_count5,*((uint32_t*)&theta_));
 136:spinnaker_src/qpe_isr.c **** 			//set_gp_reg(debug_count5,time);
 137:spinnaker_src/qpe_isr.c **** 			//set_gp_reg((time - 1550)/10,time | ((uint32_t)writeback_address+2 )<<(16+debug_count5*8) );
 138:spinnaker_src/qpe_isr.c **** 	        //debug_count6++;	
 139:spinnaker_src/qpe_isr.c **** 			//set_gp_reg((systicks - 1550)/10, systicks | debug_count6<<16  );
 140:spinnaker_src/qpe_isr.c **** 		//}
 141:spinnaker_src/qpe_isr.c ****   }
 142:spinnaker_src/qpe_isr.c **** 
 143:spinnaker_src/qpe_isr.c ****   __enable_irq();
 144:spinnaker_src/qpe_isr.c **** }
 145:spinnaker_src/qpe_isr.c **** 
 146:spinnaker_src/qpe_isr.c **** 
 147:spinnaker_src/qpe_isr.c **** void __attribute__((interrupt)) NoCDoneTxBurst_Handler (void)
 148:spinnaker_src/qpe_isr.c **** {
 149:spinnaker_src/qpe_isr.c ****     NOC->CTRL = 0x10; // clear
 150:spinnaker_src/qpe_isr.c **** 		BURST_FINISHED = true;
 151:spinnaker_src/qpe_isr.c **** 
 152:spinnaker_src/qpe_isr.c **** 	if (DMA_PACKETS_COUNT > 0) {
 153:spinnaker_src/qpe_isr.c ****        
 154:spinnaker_src/qpe_isr.c **** 		DMA_ADDR_TARGET += 0x08 * MAX_BURST_PACKET_COUNT;
 155:spinnaker_src/qpe_isr.c **** 		DMA_ADDR_LOCAL  += 0x08 * MAX_BURST_PACKET_COUNT;
 156:spinnaker_src/qpe_isr.c **** 
 157:spinnaker_src/qpe_isr.c **** 		if (DMA_PACKETS_COUNT > MAX_BURST_PACKET_COUNT) {
 158:spinnaker_src/qpe_isr.c **** 			DMA_PACKETS_COUNT -= MAX_BURST_PACKET_COUNT;
 159:spinnaker_src/qpe_isr.c **** 			noc_launch_TX_burst (getMyChipID (), MODID_SDRAM, DMA_ADDR_TARGET, DMA_ADDR_LOCAL, MAX_BURST_PAC
 160:spinnaker_src/qpe_isr.c **** 		} else {
 161:spinnaker_src/qpe_isr.c **** 
 162:spinnaker_src/qpe_isr.c **** 			noc_launch_TX_burst (getMyChipID (), MODID_SDRAM, DMA_ADDR_TARGET, DMA_ADDR_LOCAL, DMA_PACKETS_C
 163:spinnaker_src/qpe_isr.c **** 			DMA_PACKETS_COUNT = 0;
 164:spinnaker_src/qpe_isr.c **** 		}
 165:spinnaker_src/qpe_isr.c ****     } else {
 166:spinnaker_src/qpe_isr.c **** 		API_BURST_FINISHED = true;
 167:spinnaker_src/qpe_isr.c **** 		__SEV();
 168:spinnaker_src/qpe_isr.c **** 	}
 169:spinnaker_src/qpe_isr.c **** 
 170:spinnaker_src/qpe_isr.c **** 
 171:spinnaker_src/qpe_isr.c **** 
 172:spinnaker_src/qpe_isr.c ****     if(API_BURST_FINISHED == true){
 173:spinnaker_src/qpe_isr.c **** 	    dma_done_isr();
 174:spinnaker_src/qpe_isr.c **** 	}
 175:spinnaker_src/qpe_isr.c **** }
 176:spinnaker_src/qpe_isr.c **** 
 177:spinnaker_src/qpe_isr.c **** uint32_t debug_count4=0;
 178:spinnaker_src/qpe_isr.c **** void __attribute__((interrupt)) NoCDoneRxBurst_Handler (void)
 179:spinnaker_src/qpe_isr.c **** {
 180:spinnaker_src/qpe_isr.c ****     NOC->CTRL = 0x40; // clear
 181:spinnaker_src/qpe_isr.c **** 		BURST_FINISHED = true;
 182:spinnaker_src/qpe_isr.c **** 
 183:spinnaker_src/qpe_isr.c **** 
 184:spinnaker_src/qpe_isr.c **** 	if (DMA_PACKETS_COUNT > 0) {
 185:spinnaker_src/qpe_isr.c **** 		DMA_ADDR_TARGET += (64/8) * MAX_BURST_PACKET_COUNT;
 186:spinnaker_src/qpe_isr.c **** 		DMA_ADDR_LOCAL  += (64/8) * MAX_BURST_PACKET_COUNT;
 187:spinnaker_src/qpe_isr.c **** 
 188:spinnaker_src/qpe_isr.c **** 		if (DMA_PACKETS_COUNT > MAX_BURST_PACKET_COUNT) {
 189:spinnaker_src/qpe_isr.c **** 			DMA_PACKETS_COUNT -= MAX_BURST_PACKET_COUNT;
 190:spinnaker_src/qpe_isr.c **** 			noc_launch_RX_burst (getMyChipID (), MODID_SDRAM, DMA_ADDR_TARGET, DMA_ADDR_LOCAL, MAX_BURST_PAC
 191:spinnaker_src/qpe_isr.c **** 		} else {
 192:spinnaker_src/qpe_isr.c **** 			noc_launch_RX_burst (getMyChipID (), MODID_SDRAM, DMA_ADDR_TARGET, DMA_ADDR_LOCAL, DMA_PACKETS_C
 193:spinnaker_src/qpe_isr.c **** 			DMA_PACKETS_COUNT = 0;
 194:spinnaker_src/qpe_isr.c **** 		}
 195:spinnaker_src/qpe_isr.c ****     } else {
 196:spinnaker_src/qpe_isr.c **** 		API_BURST_FINISHED = true;
 197:spinnaker_src/qpe_isr.c **** 		__SEV();
 198:spinnaker_src/qpe_isr.c **** 	}
 199:spinnaker_src/qpe_isr.c **** 
 200:spinnaker_src/qpe_isr.c ****     if(API_BURST_FINISHED == true){
 201:spinnaker_src/qpe_isr.c **** 		dma_done_isr();
 202:spinnaker_src/qpe_isr.c **** 	}
 203:spinnaker_src/qpe_isr.c **** }
 204:spinnaker_src/qpe_isr.c **** */
 205:spinnaker_src/qpe_isr.c **** /*
 206:spinnaker_src/qpe_isr.c **** void GP3_Handler(void){
 207:spinnaker_src/qpe_isr.c **** 
 208:spinnaker_src/qpe_isr.c **** 	GP_INT->INT0 = 0x8;
 209:spinnaker_src/qpe_isr.c **** 
 210:spinnaker_src/qpe_isr.c **** 
 211:spinnaker_src/qpe_isr.c **** 
 212:spinnaker_src/qpe_isr.c **** 	if(sleeping == 0 ){
 213:spinnaker_src/qpe_isr.c **** 		
 214:spinnaker_src/qpe_isr.c **** 		time_done=systicks_pm;
 215:spinnaker_src/qpe_isr.c **** 	}
 216:spinnaker_src/qpe_isr.c ****     systicks_pm++;
 217:spinnaker_src/qpe_isr.c **** 	
 218:spinnaker_src/qpe_isr.c **** 
 219:spinnaker_src/qpe_isr.c **** 	if (systicks_pm==10 && reset_wait ==1){
 220:spinnaker_src/qpe_isr.c **** 	
 221:spinnaker_src/qpe_isr.c **** 		systicks_pm=0;
 222:spinnaker_src/qpe_isr.c **** 		reset_wait=0;
 223:spinnaker_src/qpe_isr.c **** 	}
 224:spinnaker_src/qpe_isr.c **** 
 225:spinnaker_src/qpe_isr.c ****     if (systicks_pm==9 && reset_wait !=1 ){//hardware bug spike + burst.
 226:spinnaker_src/qpe_isr.c **** 
 227:spinnaker_src/qpe_isr.c **** 		if (sleeping == 0 && systicks>0 ){
 228:spinnaker_src/qpe_isr.c **** 			warnings |=NOT_DONE_IN_ONE_TIME_STEP;
 229:spinnaker_src/qpe_isr.c **** 			fill_level2=noc_spinn_fifo_fill_level(0);
 230:spinnaker_src/qpe_isr.c ****   			noc_spinn_fifo_reset(0);
 231:spinnaker_src/qpe_isr.c **** 			circular_buffer_clear(input_spike_buffer);
 232:spinnaker_src/qpe_isr.c **** 			santos_clear_dma_queue();
 233:spinnaker_src/qpe_isr.c **** 			set_gp_reg(10,0xbad);//destroy sent dma request
 234:spinnaker_src/qpe_isr.c **** 			deschedule(DMA_TRANSFER_DONE);
 235:spinnaker_src/qpe_isr.c **** 			deschedule(USER_EVENT);
 236:spinnaker_src/qpe_isr.c **** 			NVIC_ClearPendingIRQ(GP3_IRQn);
 237:spinnaker_src/qpe_isr.c **** 			NVIC_ClearPendingIRQ(GP4_IRQn);
 238:spinnaker_src/qpe_isr.c **** 			NVIC_ClearPendingIRQ(NoCDoneTxBurst_IRQn);
 239:spinnaker_src/qpe_isr.c **** 			NVIC_ClearPendingIRQ(NoCDoneRxBurst_IRQn);
 240:spinnaker_src/qpe_isr.c **** 		 		
 241:spinnaker_src/qpe_isr.c **** 		}
 242:spinnaker_src/qpe_isr.c **** 
 243:spinnaker_src/qpe_isr.c **** 		santos_schedule_callback(timer_send_spike_callback,8,0,systick_callback_priority);
 244:spinnaker_src/qpe_isr.c **** 	}
 245:spinnaker_src/qpe_isr.c **** 
 246:spinnaker_src/qpe_isr.c ****     if (systicks_pm==10 && reset_wait !=1 ){
 247:spinnaker_src/qpe_isr.c **** 		systicks_pm=0;
 248:spinnaker_src/qpe_isr.c **** 		santos_schedule_callback(timer_callback,8,0,systick_callback_priority);
 249:spinnaker_src/qpe_isr.c **** 	}
 250:spinnaker_src/qpe_isr.c **** }
 251:spinnaker_src/qpe_isr.c **** */
 252:spinnaker_src/qpe_isr.c **** /*
 253:spinnaker_src/qpe_isr.c **** void FifoMuCTouched_Handler (void)
 254:spinnaker_src/qpe_isr.c **** {
 255:spinnaker_src/qpe_isr.c **** 	
 256:spinnaker_src/qpe_isr.c ****     struct spinn_packet packet;
 257:spinnaker_src/qpe_isr.c ****     if (noc_spinn_fifo_get(0, &packet) == 0) return;
 258:spinnaker_src/qpe_isr.c ****     
 259:spinnaker_src/qpe_isr.c **** }
 260:spinnaker_src/qpe_isr.c **** */
 261:spinnaker_src/qpe_isr.c **** /*
 262:spinnaker_src/qpe_isr.c **** void GP4_Handler(void)
 263:spinnaker_src/qpe_isr.c **** {
 264:spinnaker_src/qpe_isr.c ****     santos_schedule_callback (_user_event_callback,10,10,user_event_priority);
 265:spinnaker_src/qpe_isr.c ****     user_pending=FALSE;   
 266:spinnaker_src/qpe_isr.c **** }
 267:spinnaker_src/qpe_isr.c **** */
 268:spinnaker_src/qpe_isr.c **** 
 269:spinnaker_src/qpe_isr.c **** extern uint32_t duration ;
 270:spinnaker_src/qpe_isr.c **** extern uint32_t systick;
 271:spinnaker_src/qpe_isr.c **** 
 272:spinnaker_src/qpe_isr.c **** void IRQ_00_Handler(void) {
  30              		.loc 1 272 0
  31              		.cfi_startproc
  32              		@ args = 0, pretend = 0, frame = 0
  33              		@ frame_needed = 0, uses_anonymous_args = 0
  34              		@ link register save eliminated.
 273:spinnaker_src/qpe_isr.c ****     timer[TIMER1_INT_CLR] = 0xFFFFFFFF;
  35              		.loc 1 273 0
  36 0000 054A     		ldr	r2, .L2
 274:spinnaker_src/qpe_isr.c **** 	qpe_schedule_callback(timer_callback,8,0,systick_callback_priority);
  37              		.loc 1 274 0
  38 0002 064B     		ldr	r3, .L2+4
  39 0004 0648     		ldr	r0, .L2+8
  40 0006 1B68     		ldr	r3, [r3]
 273:spinnaker_src/qpe_isr.c ****     timer[TIMER1_INT_CLR] = 0xFFFFFFFF;
  41              		.loc 1 273 0
  42 0008 4FF0FF31 		mov	r1, #-1
  43 000c 1160     		str	r1, [r2]
  44              		.loc 1 274 0
  45 000e 0821     		movs	r1, #8
  46 0010 0022     		movs	r2, #0
  47 0012 FFF7FEBF 		b	qpe_schedule_callback
  48              	.LVL0:
  49              	.L3:
  50 0016 00BF     		.align	2
  51              	.L2:
  52 0018 0C0000E1 		.word	-520093684
  53 001c 00000000 		.word	systick_callback_priority
  54 0020 00000000 		.word	timer_callback
  55              		.cfi_endproc
  56              	.LFE158:
  58              		.comm	API_BURST_FINISHED,1,1
  59              		.text
  60              	.Letext0:
  61              		.file 2 "/home/yexin/projects/JIB1Tests/float-libm/include/machine/_default_types.h"
  62              		.file 3 "/home/yexin/projects/JIB1Tests/float-libm/include/sys/_stdint.h"
  63              		.file 4 "/home/yexin/projects/JIB1Tests/event_based_api/include/qpe_event_based_api.h"
  64              		.file 5 "spinnaker_src/if_curr_exp.h"
  65              		.file 6 "spinnaker_src/param_defs.h"
  66              		.file 7 "/home/yexin/projects/JIB1Tests/qpe-common/include/core_cm4.h"
  67              		.file 8 "/home/yexin/projects/JIB1Tests/qpe-common/include/communication.h"
  68              		.file 9 "/home/yexin/projects/JIB1Tests/qpe-common/include/random.h"
