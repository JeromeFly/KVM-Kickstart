#! /bin/bash

#需要自备一个QCOW2镜像与一个XML文件

name=`cat ./server.xml | grep -i '<name>' | awk -F\> '{print $2}' | awk -F\< '{print $1}'`
uuid=`cat ./server.xml | grep -i uuid | awk -F\> '{print $2}' | awk -F\< '{print $1}'`
#mac=`cat ./server.xml | grep -i 'mac address' | sed "s/'//g" | awk -F\= '{print $2}' | awk -F\/ '{print $1}'`
source_file=`cat ./server.xml | grep -i 'source file' | awk -F\= '{print $2}' | awk -F\' '{print $2}' | awk 'NR==1{print $0}'`
#source_file=` cat ./server.xml | grep -i 'source file' | awk -F\= '{print $2}' | awk -F\' '{print $2}' | sed "s/'//g"`
pwd=`pwd`

for((i=1; i<=12; i++))
do
	file=server-${i}.xml
	dir=server-${i}
	qcow2_disk=server-${i}.qcow2
	mkdir -p ./Date/server/${dir}
	cp ./server.xml ./Date/server/${dir}/${file}
	cp ./server.qcow2 ./Date/server/${dir}/${qcow2_disk}
	sed -i "s,${name},server-${i},g" ./Date/server/${dir}/${file}
	uuid_new=`uuidgen`
	sed -i "s,${uuid},${uuid_new},g" ./Date/server/${dir}/${file}
	#mac_new=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
	mac_new=`openssl rand -hex 1`
	sed -i "s,52:54:00:87:f6:d4,52:54:00:87:f6:${mac_new},g" ./Date/server/${dir}/${file}
	sed -i "s,${source_file},${pwd}/Date/server/${dir}/${qcow2_disk},g" ./Date/server/${dir}/${file}
	virsh define ./Date/server/${dir}/${file}
	virsh start server-${i}
done
