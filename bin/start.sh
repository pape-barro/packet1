#!/bin/sh
## START
# init
IOT_SK_SX1301_RESET_PIN=5

# wait function
WAIT_GPIO() {
    sleep 0.1
}

# cleanup GPIO 5
if [ -d /sys/class/gpio/gpio$IOT_SK_SX1301_RESET_PIN ]
then
   echo "$IOT_SK_SX1301_RESET_PIN" > /sys/class/gpio/unexport; WAIT_GPIO
fi

# setup GPIO 5
echo "$IOT_SK_SX1301_RESET_PIN" > /sys/class/gpio/export; WAIT_GPIO

# set GPIO 5 as output
echo "out" > /sys/class/gpio/gpio$IOT_SK_SX1301_RESET_PIN/direction; WAIT_GPIO

# write output for SX1301 reset
echo "0" > /sys/class/gpio/gpio$IOT_SK_SX1301_RESET_PIN/value; WAIT_GPIO
echo "1" > /sys/class/gpio/gpio$IOT_SK_SX1301_RESET_PIN/value; WAIT_GPIO
echo "0" > /sys/class/gpio/gpio$IOT_SK_SX1301_RESET_PIN/value; WAIT_GPIO

# clean and install dependances
cd  /opt/edge-gateway/
sudo make clean all
cd /opt/edge-gateway/packet_forwarder/
sudo make clean all
cd /opt/edge-gateway/packet_forwarder/lora_pkt_fwd

# FIRE UP THE FORWARDER
sudo ./lora_pkt_fwd || (sudo ./start.sh)
## STOP


