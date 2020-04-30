#this tools is based on strings extration by dump memory and after that it try to rebuilt the http request and response packet from that
#this script does not respect secure programming tips, so it should be run as unprivileged user!!!!!!!
import sys
import os
string_match="Set-Cookie: "
key_value_id=": "
end_request_str="--"
http="HTTP/1."

def find_good_packets(packets):
	good_packets=[]
	for p in packets:	
		if (string_match in p):

			res=p.split(string_match)[1].split("\n")[0].strip()
			if (res):
				good_packets.append(p)
	return good_packets



def reader():
	lines=[]
	packets=[]

	with open("output.txt","r") as fp:
		line=fp.readline()
		while True:
			if(key_value_id in line or http in line):
				lines.append(line)
			line=fp.readline()
			if (end_request_str in line):
				packets.append("".join(lines))
				lines=[]
			if not line:
				break
	good_p=find_good_packets(packets)
	return good_p

def writer(packets):
	with open("good_packets.txt","w") as fp:
		for p in packets:
			fp.write("\nSTART-PACKET:\n")
			fp.write(p)
			fp.write("\nEND-PACKET\n")
		fp.close()
def cookie_extr(mem_file):
	#os.system('strings '+mem_file+'| grep "^Set-Cookie:" -B 30 -A 10 > output.txt')
	with open("output.txt","a") as fp:
		fp.write("--\n")
		fp.close()
	good_p=reader()
	writer(good_p)
	



if (len(sys.argv)<2):
	print("insert a memory dump")
	sys.exit()

cookie_extr(sys.argv[1])
