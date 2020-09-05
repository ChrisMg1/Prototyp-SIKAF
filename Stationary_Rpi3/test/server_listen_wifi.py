## Echo Server ##

# This sample program, based on the one in the standard library documentation, receives incoming messages and echos them back to the sender. It starts by creating a TCP/IP socket.

import socket
import sys
import datetime
import subprocess

# set the port from args, default = 10000
if len(sys.argv) > 1:
    in_port = int(sys.argv[1])
    in_ip = str(sys.argv[2])

else:
    in_port = 10000
    in_ip =  subprocess.check_output("ifconfig | grep -A 1 'wlan0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1", shell=True).strip()
    print 'args empty'




# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Then bind() is used to associate the socket with the server address. In this case, the address is localhost, referring to the current server, and the port number is 10000.

# Bind the socket to the port
server_address = (in_ip, in_port)
print >>sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)

# Calling listen() puts the socket into server mode, and accept() waits for an incoming connection.

# Listen for incoming connections
sock.listen(1)

while True:
    # Wait for a connection
    print >>sys.stderr, 'waiting for a connection'
    connection, client_address = sock.accept()

# accept() returns an open connection between the server and client, along with the address of the client. The connection is actually a different socket on another port (assigned by the kernel). Data is read from the connection with recv() and transmitted with sendall().

    try:
        print >>sys.stderr, 'connection from', client_address

	# write logfile about connections
	data = connection.recv(160)
	#print data + 'line data',

	data_set=[]
	data_set.append(str(datetime.datetime.now()))
	data_set.append(data)
	data_set.append('UTC')
	data_set.append(str(client_address[0]))
	print data_set
	data_string = data_set[0] + ';' + data_set[1].rstrip('\n') + ';' + data_set[2] + ';' + data_set[3]
	print data_string

	carLog = open("/home/pi/my_scripts/logfiles/G5_log.log", mode='a')
	carLog.write(data_string + '\n')
	carLog.close()

        # Receive the data in small chunks and retransmit it

        while True:
            data = connection.recv(16)
            print >>sys.stderr, 'received "%s"' % data

            if data:
                print >>sys.stderr, 'sending data back to the client'
                connection.sendall(data)
            else:
                print >>sys.stderr, 'no more data from', client_address
                break
	    
	    if data == "new_m":
		print "ping_ping_ping"
            
    finally:
        # Clean up the connection
        connection.close()

# When communication with a client is finished, the connection needs to be cleaned up using close(). This example uses a try:finally block to ensure that close() is always called, even in the event of an error.

