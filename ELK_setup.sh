#!/bin/bash

e="elasticsearch.service"
l="logstash.service"
k="kibana.service"

for i in "/home/tools/elasticsearch/elasticsearch.deb" "/home/tools/logstash/logstash.deb" "/home/tools/kibana/kibana.deb"; do
	dpkg -i $i && echo " " && echo " "
done

systemctl daemon-reload

for j in $e $l $k; do
	systemctl enable $j && systemctl start $j
done

echo "done installing, now editing config files..."

# kibana config 
cd /etc/kibana && sed -i 's/#server.port:/server.port/g' kibana.yml && sed -i 's/#server.host: "localhost"/server.host: 0.0.0.0/g' kibana.yml

# logstash config
cd /etc/logstash && sed -i 's/# config.reload.interval:/config.reload.interval:/g' logstash.yml && sed -i 's/# config.reload.automatic: false/config.reload.automatic: true/g' logstash.yml

# elasticsearch config
cd /etc/elasticsearch && sed -i 's/#network.host: 192.168.0.1/network.host: 127.0.0.1/g' elasticsearch.yml && sed -i 's/#http.port:/http.port:/g' elasticsearch.yml

echo "done configuring config files, restarting services..."

for k in $e $l $k; do
	systemctl restart $k
done

echo "done"