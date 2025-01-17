#!/usr/bin/python
"""
- read output from a subprocess in a background thread
- show the output in the GUI
"""
import sys
import os
import random
from Tkinter import *
from itertools import islice
from subprocess import Popen, PIPE
from textwrap import dedent
from threading import Thread

try:
    import Tkinter as tk
    from Queue import Queue, Empty
except ImportError:
    import tkinter as tk # Python 3
    from queue import Queue, Empty # Python 3

def iter_except(function, exception):
    """Works like builtin 2-argument `iter()`, but stops on `exception`."""
    try:
        while True:
            yield function()
    except exception:
        return

class DisplaySubprocessOutputDemo:
    def __init__(self, root):
        self.root = root
        

        
        

        # start dummy subprocess to generate some output
        self.process = Popen([sys.executable, "-u", "-c", dedent("""
            import os

            os.system("bash tag_receiver.sh") 
            """)], stdout=PIPE) # CM: Added as own script

        # launch thread to read the subprocess output
        #   (put the subprocess output into the queue in a background thread,
        #    get output from the queue in the GUI thread.
        #    Output chain: process.readline -> queue -> label)
        q = Queue(maxsize=1024)  # limit output buffering (may stall subprocess)
        t = Thread(target=self.reader_thread, args=[q])
        t.daemon = True # close pipe if GUI process exits
        
        
        
        t.start()

        
        # show subprocess' stdout in GUI
        
        self.label = tk.Label(root, text="  ", font=(None, 20)) # CM: change this for font size (init: 200)
        self.label.pack(ipadx=4, padx=4, ipady=4, pady=4, fill='both')
        
        
        
        
        
        self.update(q) # start update loop
        
        
        
        
        # create TEXT-BOX for received IDs
		
	labelText=StringVar()
        labelText.set("Received CarTAG: ")
        labelDir=Label(root, textvariable=labelText, height=4)
        labelDir.pack()#side="left")
	
	self.textbox_id = Text(root, height=1, width=60, cursor="none") 
	self.textbox_id.insert(INSERT, 'init_id')
	self.textbox_id.pack()#side="left")
        
        
        
	# create TEXT-BOX for received values
	
	labelText=StringVar()
        labelText.set("Received Value: ")
        labelDir=Label(root, textvariable=labelText, height=4)
        labelDir.pack()#side="left")
        
	self.textbox_val = Text(root, height=1, width=60, cursor="none")
	self.textbox_val.insert(INSERT, 'init_val')
        self.textbox_val.pack()#side="left")
	
        
	# create BUTTON for BACK to main-menue
        frame = Frame()
	frame.pack()
	# self.button = Button(frame, text = "BACK", fg = "red", cursor="none", command = root.destroy) # CM: try "frame.quit" or "root.destroy"
	self.button = Button(frame, text = "BACK", fg = "red", cursor="none", command = self.quit_frame)
	self.button.config(height = 5, width = 20)
	self.button.pack(side=RIGHT)

    def quit_frame(self):
        '''
        CM: kill the tag_receiver.sh-process and go back to main menu. Change bash-command when renaming .sh
        '''
        os.system('killall tag_receiver.sh')
        self.root.destroy()
        
    
    
    def reader_thread(self, q):
        """Read subprocess output and put it into the queue."""
        try:
            with self.process.stdout as pipe:
                for line in iter(pipe.readline, b''):
                    q.put(line)
        finally:
            q.put(None)

    def update(self, q):
        """Update GUI with items from the queue."""
        for line in iter_except(q.get_nowait, Empty): # display all content
            if line is None:
                self.quit()
                return
            else:
                
                self.label['text'] = iter_except(q.get_nowait, Empty) #CM: echo function for debugging
                # self.label['text'] = line # update GUI
                
                # CM: added lines to update textbox(_id + _val)
                self.textbox_id.delete(1.0, END)
                self.textbox_id.insert(INSERT, line)
                
                my_line = 'temp_val is ' + line[54:56] + '.' + line[56:59] + ' ' + 'deg'
                                
                self.textbox_val.delete(1.0, END)
                self.textbox_val.insert(INSERT, my_line)
                
                break # display no more than one line per 40 milliseconds
        self.root.after(40, self.update, q) # schedule next update

    def quit(self):
        self.process.kill() # exit subprocess if GUI is closed (zombie!)
        self.root.destroy()


root = tk.Tk()
app = DisplaySubprocessOutputDemo(root)
root.protocol("WM_DELETE_WINDOW", app.quit)
# center window
root.eval('tk::PlaceWindow %s center' % root.winfo_pathname(root.winfo_id()))
root.attributes('-fullscreen', True) # CM: added as fullscreen mode
root.config(cursor="none") # CM: Disable cursor
root.mainloop()
