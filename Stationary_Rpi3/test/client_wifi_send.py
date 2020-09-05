## Echo Client ##


# The client program sets up its socket differently from the way a server does. Instead of binding to a port and listening, it uses connect() to attach the socket directly to the remote address.

import socket
import sys

# set the sending port from args, default = 10000
if len(sys.argv) > 1:
    out_port = int(sys.argv[1])
    out_ip = str(sys.argv[2])
    print 'sending to ip ' + out_ip + ', port ' + str(out_port)

else:
    out_port = 10000
    out_ip = '192.168.1.1'
    print 'using default ip ' + out_ip + ', default port ' + str(out_port)



# Get the actual carTAG from config file
f = open('/home/pi/my_scripts/client_server/carTAG3', 'r')
lines=f.readlines()
act_carTAG =  lines[1]

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = (out_ip, out_port)
print >>sys.stderr, 'connecting to %s port %s' % server_address
sock.connect(server_address)

# After the connection is established, data can be sent through the socket with sendall() and received with recv(), just as in the server.

try:
    
    # Send data
    #message = 'This is the message.  It will be repeated.'
    message = act_carTAG

    print >>sys.stderr, 'sending "%s"' % message
    sock.sendall(message)

    # Look for the response
    amount_received = 0
    amount_expected = len(message)
    
# MC: commented out while-loop

    while 2 < 1: # amount_received < amount_expected:
        data = sock.recv(16)
        amount_received += len(data)
        print >>sys.stderr, 'received "%s"' % data



finally:
    print >>sys.stderr, 'closing socket'
    sock.close()

# When the entire message is sent and a copy received, the socket is closed to free up the port.
##
