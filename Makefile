### Environment constants 

ARCH ?=
CROSS_COMPILE ?=
export

### general build targets

all:
	$(MAKE) all -e -C libloragw
	$(MAKE) all -e -C util_pkt_logger
	$(MAKE) all -e -C util_spi_stress
	$(MAKE) all -e -C util_tx_test
	$(MAKE) all -e -C util_lbt_test
	$(MAKE) all -e -C util_tx_continuous
	$(MAKE) all -e -C util_spectral_scan

clean:
	$(MAKE) clean -e -C libloragw
	$(MAKE) clean -e -C util_pkt_logger
	$(MAKE) clean -e -C util_spi_stress
	$(MAKE) clean -e -C util_tx_test
	$(MAKE) clean -e -C util_lbt_test
	$(MAKE) clean -e -C util_tx_continuous
	$(MAKE) clean -e -C util_spectral_scan
	
install:
	sudo git clone https://github.com/pape-barro/packet2.git
	sudo git clone https://github.com/pape-barro/packet3.git
	sudo chmod 777 ./opt/edge-gateway
	sudo cp -a ./packet2/* ./
	sudo cp -a ./packet3/* ./
	sudo rm -rf ./packet2
	sudo rm -rf ./packet3
	sudo cp -f ./edge-gateway.service /lib/systemd/system/
	sudo systemctl enable edge-gateway.service
	sudo systemctl daemon-reload
	
graphic:
	sudo apt-get update
	sudo apt-get install apache2 php libapache2-mod-php
	sudo chmod 777 /var/www/
	sudo chmod 777 /opt/edge-gateway/
	sudo rm -rf /var/www/html
	sudo cp -rf /opt/edge-gateway/html /var/www/
	sudo chmod 777 /var/www/html/web/utils/app.txt
	sudo chmod 777 /var/www/html/web/utils/log.json
	sudo chmod 777 /var/www/html/web/utils/log.json
	sudo chmod 777 /opt/edge-gateway/global_conf.json
	sudo apt-get update && sudo apt-get install mosquitto mosquitto-clients redis-server redis-tools postgresql
	sudo apt-get update && sudo apt install apt-transport-https curl
	
mod:
	sudo apt-get update && sudo apt-get install apt-transport-https dirmngr
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1CE2AFD36DBCCA00
	sudo echo "deb https://artifacts.loraserver.io/packages/2.x/deb stable main" | sudo tee /etc/apt/sources.list.d/loraserver.list
	sudo apt-get update
	sudo apt-get install lora-gateway-bridge
	sudo systemctl start lora-gateway-bridge
	sudo systemctl enable lora-gateway-bridge
	sudo apt-get install loraserver
	sudo chmod 777 /etc/loraserver/
	sudo chmod 777 /etc/loraserver/loraserver.toml
	sudo rm -f /etc/loraserver/loraserver.toml
	sudo cp -f ./modules/loraserver.toml /etc/loraserver/
	sudo systemctl start loraserver
	sudo systemctl enable loraserver
	sudo apt-get install lora-app-server
	sudo chmod 777 /etc/lora-app-server/
	sudo chmod 777 /etc/lora-app-server/lora-app-server.toml
	sudo rm -f /etc/lora-app-server/lora-app-server.toml
	sudo cp -f ./modules/lora-app-server.toml /etc/lora-app-server/
	sudo systemctl start lora-app-server
	sudo systemctl enable lora-app-server
	curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
	sudo apt-get update && sudo apt-get install telegraf
	sudo chmod 777 /etc/telegraf/
	sudo chmod 777 /etc/telegraf/telegraf.conf
	sudo rm -f /etc/telegraf/telegraf.conf
	sudo cp -f ./modules/telegraf.conf /etc/telegraf/
	sudo apt-get update && sudo apt-get install influxdb
	sudo chmod 777 /etc/influxdb/
	sudo chmod 777 /etc/influxdb/influxdb.conf
	sudo rm -f /etc/influxdb/influxdb.conf
	sudo cp -f ./modules/influxdb.conf /etc/influxdb/influxdb.conf
	sudo apt-get update && sudo wget https://github.com/fg2it/grafana-on-raspberry/releases/download/v4.2.0/grafana_4.2.0_armhf.deb
	sudo dpkg -i grafana_4.2.0_armhf.deb
	sudo systemctl enable influxdb
	sudo systemctl start influxdb
	sudo systemctl enable telegraf
	sudo systemctl start telegraf
	sudo systemctl enable grafana-server
	sudo systemctl start grafana-server
	sudo apt-get update 
	sudo apt-get install dnsmasq hostapd
	sudo systemctl stop hostapd
	sudo systemctl stop dnsmasq
	sudo chmod 777 /etc/
	sudo chmod 777 /etc/dhcpcd.conf
	sudo rm -f /etc/dhcpcd.conf
	sudo cp -f ./modules/dhcpcd.conf /etc/
	sudo chmod 777 /etc/network/
	sudo chmod 777 /etc/network/interfaces
	sudo rm -f /etc/network/interfaces
	sudo cp -f ./modules/interfaces /etc/network/
	sudo chmod 777 /etc/hostapd/
	sudo cp -f ./modules/hostapd.conf /etc/hostapd/
	sudo chmod 777 /etc/default/
	sudo chmod 777 /etc/default/hostapd
	sudo rm -f /etc/default/hostapd
	sudo cp -f ./modules/hostapd /etc/default/
	sudo chmod 777 /etc/dnsmasq.conf
	sudo rm -f /etc/dnsmasq.conf
	sudo cp -f ./modules/dnsmasq.conf /etc/
	sudo chmod 777 /etc/sysctl.conf
	sudo rm -f /etc/sysctl.conf
	sudo cp -f ./modules/sysctl.conf /etc/
	sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
	sudo chmod 777 /etc/rc.local
	sudo rm -f /etc/rc.local
	sudo cp -f ./modules/rc.local /etc/
	sudo apt-get install bridge-utils
	sudo brctl addbr br0
	sudo brctl addif br0 eth0
	sudo systemctl start hostapd
	sudo systemctl start dnsmasq
	
fireup:
	sudo apt-get update
	sudo apt-get upgrade
	sudo systemctl restart influxdb
	sudo reboot

### EOF
