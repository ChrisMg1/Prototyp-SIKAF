from Tkinter import *
import os
import random
import tkFileDialog
import subprocess


class App:
    def __init__ (self, master):

	# button layout
	b_width = 20
	b_height = 20

        frame = Frame(master)
	frame.pack()
	
	# create BUTTON for QUIT
	self.button = Button(frame, text = "QUIT", fg = "red", command = frame.quit, cursor="none")
	# self.button = Button(frame, text = "QUIT", fg = "red", command = self.tki_quit, cursor="none")
	self.button.config(height = b_height, width = b_width)
	self.button.pack(side=LEFT)
	
	# create BUTTON for SCRIPT-CALL (call python-script for tkinter GUI)
	self.slogan = Button(frame, text="view Mode", command=self.callBeacon, cursor="none")
	# self.slogan = Button(frame, text="eyeRoute Mode part 2", command=self.write_slogan)
	self.slogan.config(height = b_height, width = b_width)
	self.slogan.pack(side=LEFT)

		
	# create BUTTON for print to TEXT-BOX
        # self.box = Button(frame, text="to Box", command=self.write_slogan)
	self.box = Button(frame, text="write Mode", command=self.write_box, cursor="none")
	self.box.config(height = b_height, width = b_width)
	self.box.pack(side=LEFT)	
	
	
	# create TEXT-BOX
	self.textbox = Text(root, height=2, width=30)
	self.textbox.insert(INSERT, 'start')
        self.textbox.pack()
	
	
	# create BUTTON for Output File
	
	self.OutFile = Button(frame, text='Select Output File', command=self.asksaveasfile, cursor="none")#.pack(**button_opt)
	self.OutFile.config(height = 10, width = 20)
	self.OutFile.pack(side=RIGHT)
	
	
    def write_slogan(self):
	w = Label(root, text="HI BOX22")
	w.pack()
	
	
    def write_box(self):
        self.textbox.delete(1.0, END)
	self.textbox.insert(INSERT, str(random.random()) + '\n...written to file')
    
	
    def callBeacon(self):
        os.system('python /home/pi/my_scripts/tk_script2.py')
        
    def tki_quit(self):
        '''
        CM: TODO: killall python
        '''
        self.frame.quit()
        
    def asksaveasfile(self):
        '''
        Returns an opened file in write mode.
        '''
        return tkFileDialog.asksaveasfile(mode='w')#, **self.file_opt)        


# todo: Extra box with 'initialize hci'
subprocess.call(["sudo", "hciconfig", "hci0", "down"])
subprocess.call(["sudo", "hciconfig", "hci0", "up"])


root = Tk()
root.attributes('-fullscreen', True)
root.config(cursor="none") # CM: Disable cursor
app = App(root)
root.mainloop()
