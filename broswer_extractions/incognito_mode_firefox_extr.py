#this tools is based on strings extration by dump memory and after that it try to rebuilt the http request and response packet from that
#this script does not respect secure programming tips, so it should be run as unprivileged user!!!!!!!
import sys
import os
string_match="Set-Cookie: "
key_value_id=": "
end_request_str="--"
http="HTTP/1."

def find_good_response_packets(packets):
	good_packets=[]
	for p in packets:	
		if (string_match in p):

			res=p.split(string_match)[1].split("\n")[0].strip()
			if (res):
				good_packets.append(p)
	return good_packets

def response_reader(res_file):
	lines=[]
	packets=[]

	with open(res_file,"r") as fp:
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
	good_p=find_good_response_packets(packets)
	return good_p

def request_reader(res_file):
	lines=[]
	packets=[]

	with open(res_file,"r") as fp:
		while True:
			line=fp.readline()
			if("HTTP" in line):
				line1=fp.readline()
				if("Host: " in line1):
					lines.append(line)
					lines.append(line1)
					while True:
						line=fp.readline()
						lines.append(line)
						if (end_request_str in line or "Content-Length: 0" in line):
							packets.append("".join(lines))
							lines=[]
							break
			if not line:
				break
	return packets


def writer(packets,filename):
	with open(filename,"w") as fp:
		for p in packets:
			fp.write("\nSTART-PACKET:\n")
			fp.write(p)
			fp.write("\nEND-PACKET\n")
		fp.close()

def http_response_with_cookies(mem_file):
	response_grep='"^Set-Cookie:" -B 30 -A 10 '
	res_output="response.txt"
	tmp_file="output.txt"
	os.system('strings '+mem_file+'| grep '+response_grep+' >' +tmp_file)
	with open(tmp_file,"a") as fp:
		fp.write("--\n")
		fp.close()
	good_p=response_reader(tmp_file)
	writer(good_p,res_output)
	os.system("rm -f "+tmp_file)

def http_request(mem_file):
	request_output="request.txt"
	tmp_file="output.txt"
	request_grep='-E "^POST [^%]* HTTP|^GET [^%]* HTTP|^HEAD [^%]* HTTP|^PUT [^%]* HTTP" -A 25 '
	os.system('strings '+mem_file+'| grep '+request_grep+' >' +tmp_file)
	with open(tmp_file,"a") as fp:
		fp.write("--\n")
		fp.close()
	good_p=request_reader(tmp_file)
	writer(good_p,request_output)
	os.system("rm -f "+tmp_file)



if (len(sys.argv)<2):
	print("insert a memory dump")
	sys.exit()
http_response_with_cookies(sys.argv[1])
http_request(sys.argv[1])
