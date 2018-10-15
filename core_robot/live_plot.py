import matplotlib.pyplot as plt
import os, threading, Queue
import numpy as np
import time


import subprocess

packet_queue = Queue.Queue()

class scan_terminal(threading.Thread):
    def __init__(self, packet_queue ):
        super(scan_terminal, self).__init__()
        self.packet_queue = packet_queue
        self.proc = 0 
        self.init_complete = 0
        self.sim_end =  0

        self.data = np.zeros([4,10])
        self.data_count = 0


    def run(self):

        os.system('make')
        self.proc = subprocess.Popen(' ./test_multicore'.split(), stdout = subprocess.PIPE, shell=False)


        while True:
        
            output = self.proc.stdout.readline()
            
            
            #debug!
            #self.packet_queue.put(output)
            if output!= '':
                print(output)

            
            if  'SIM END' in  output.strip():
                self.sim_end = 1
                self.packet_queue.put('SIM_END')
                break

            if self.init_complete ==1 and self.sim_end == 0 and 'time' in output:


                time = float(output.split()[1])
                p = float(output.split()[3])
                pd = float(output.split()[5])
                u = float(output.split()[7])

                self.data[0][self.data_count] = time
                self.data[1][self.data_count] = p 
                self.data[2][self.data_count] = pd 
                self.data[3][self.data_count] = u 
                self.data_count += 1

                if self.data_count == 10:
                    self.packet_queue.put(self.data)
                    self.data_count = 0
                
            if  'INIT COMPLETE' in  output:
                self.init_complete = 1
                self.packet_queue.put('INIT_COMPLETE')
                print ('INIT_COMPLETE received by subprocess')

            #print('subprocess: '+output)



'''
class live_plot():
    def __init__(self,data_queue):
        #super(live_plot,self).__init__()
        self.data_queue = data_queue
        fig1 = plt.figure(1)
        plt.ion()
        self.graph1 = plt.plot([],[],'r-')
        self.graph2 = plt.plot([],[],'g-')
        plt.figure(2)
        self.graph3 = plt.plot([],[],'r-')
        plt.figure(3)
        self.graph4 = plt.plot([],[],'r-')
        plt.show()
        plt.pause(0.001)
        self.data1_t=[]
        self.data1_q=[]
        self.data1_d=[]
        self.data1_u=[]
        self.real_time=[]
        self.data_received = []
        self.start_time = time.time()
        self.init_complete = 0 
    def run(self):
        while True:
            try:#should be done within 1 ms
                #print ('main process')
                self.data_received = self.data_queue.get(True, 0.01)
                #print(self.data_received)
                if 'INIT_COMPLETE' in self.data_received:
                    self.init_complete = 1
                    print ('INIT_COMPLETE received by main process')
                elif ('SIM_END' not in self.data_received) and (self.init_complete == 1) and (self.data_received[0] == 'DATA') :


                    self.data1_t.append(self.data_received[1])
                    self.data1_q.append(self.data_received[2])
                    self.data1_d.append(self.data_received[3])
                    self.data1_u.append(self.data_received[4])
                    self.real_time.append(time.time()-self.start_time)
                    #print (self.data_received)
                    plt.figure(1)
                    self.graph1[0].set_data(self.real_time[-500:],self.data1_q[-500:])
                    self.graph2[0].set_data(self.real_time[-500:],self.data1_d[-500:])
                    plt.axis([self.real_time[-1]-40, self.real_time[-1], -1.5, 1.5])
                    plt.figure(2)
                    self.graph3[0].set_data(self.real_time[-500:],self.data1_u[-500:])
                    plt.axis([self.real_time[-1]-40, self.real_time[-1], -100, 100])
                    plt.figure(3)
                    self.graph4[0].set_data(self.real_time[-500:],np.array(self.data1_q[-500:])-np.array(self.data1_d[-500:]))
                    plt.axis([self.real_time[-1]-40, self.real_time[-1], -0.2, 0.2])
                    plt.show()
                    plt.pause(0.00001)

                #elif 'SIM_END' in self.data_received:
                #    return


            except Queue.Empty:
                continue
'''

class live_plot():
    def __init__(self,data_queue):
        #super(live_plot,self).__init__()
        self.data_queue = data_queue
        self.fig1 = plt.figure(1)
        self.ax1 = plt.gca()
        #plt.ion()
        self.graph1 = plt.plot([],[],'r-')
        self.graph2 = plt.plot([],[],'g-')
        self.fig2 = plt.figure(2)
        self.ax2 = plt.gca()
        self.graph3 = plt.plot([],[],'r-')
        self.fig3 = plt.figure(3)
        self.ax3 = plt.gca()
        self.graph4 = plt.plot([],[],'r-')
        self.fig1.canvas.draw()
        self.fig2.canvas.draw()
        self.fig3.canvas.draw()
        self.axbg1 = self.fig1.canvas.copy_from_bbox(self.ax1.bbox)
        self.axbg2 = self.fig2.canvas.copy_from_bbox(self.ax2.bbox)
        self.axbg3 = self.fig3.canvas.copy_from_bbox(self.ax3.bbox)
        #plt.show()
        #plt.pause(0.001)
        self.data1_t=np.array([])
        self.data1_q=np.array([])
        self.data1_d=np.array([])
        self.data1_u=np.array([])
        self.real_time=np.array([])
        self.data_received = []
        self.start_time = time.time()
        self.init_complete = 0 
    def run(self):
        while True:
            try:#should be done within 1 ms
                #print ('main process')
                self.data_received = self.data_queue.get(True, 0.001)
                #print(self.data_received)
                if 'INIT_COMPLETE' in self.data_received:
                    self.init_complete = 1
                    print ('INIT_COMPLETE received by main process')
                #elif ('SIM_END' not in self.data_received) and (self.init_complete == 1) and (self.data_received[0] == 'DATA') :
                elif self.init_complete == 1:

                    self.data1_t = np.append(self.data1_t, self.data_received[0])
                    self.data1_q = np.append(self.data1_q, self.data_received[1])
                    self.data1_d = np.append(self.data1_d, self.data_received[2])
                    self.data1_u = np.append(self.data1_u, self.data_received[3])
                    #np.append(self.real_time.append(time.time()-self.start_time)
                    #print (self.data_received)
                    plt.figure(1)
                    plt.title('q and qd')
                    self.graph1[0].set_data(self.data1_t[-1000:],self.data1_q[-1000:])
                    self.graph2[0].set_data(self.data1_t[-1000:],self.data1_d[-1000:])
                    plt.axis([self.data1_t[-1]-40, self.data1_t[-1], -1.5, 1.5])
                    
                    plt.figure(2)
                    plt.title('u')
                    self.graph3[0].set_data(self.data1_t[-1000:],self.data1_u[-1000:])
                    plt.axis([self.data1_t[-1]-40, self.data1_t[-1], -100, 100])
                    plt.figure(3)
                    plt.title('q-qd')
                    self.graph4[0].set_data(self.data1_t[-1000:],np.array(self.data1_q[-1000:])-np.array(self.data1_d[-1000:]))
                    plt.axis([self.data1_t[-1]-40, self.data1_t[-1], -0.2, 0.2])
                    

                    self.fig1.canvas.restore_region(self.axbg1)
                    
                    self.fig2.canvas.restore_region(self.axbg2)
                    self.fig3.canvas.restore_region(self.axbg3)
                   

                    self.ax1.draw_artist(self.graph1[0])
                    self.ax1.draw_artist(self.graph2[0])
                    
                    self.ax2.draw_artist(self.graph3[0])
                    self.ax3.draw_artist(self.graph4[0])
                    
                    self.fig1.canvas.blit(self.ax1.bbox)
                   
                    self.fig2.canvas.blit(self.ax2.bbox)
                    self.fig3.canvas.blit(self.ax3.bbox)
                  


                    #plt.show()
                    plt.pause(0.00001)

                #elif 'SIM_END' in self.data_received:
                #    return


            except Queue.Empty:
                continue
scan = scan_terminal(packet_queue)
live_plot_ = live_plot(packet_queue)
scan.start()
live_plot_.run()
