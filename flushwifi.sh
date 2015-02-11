#!/bin/bash
# chmod +x flushwifi.sh
# run as root or sudo
# AUTHOR: vvn <vvn@notworth.it>

if (( $(id -u) )) ; then
  echo "this script needs to run as root or sudo"
  exit 1
fi

echo ""
echo "************************************"
echo "FLUSHWIFI.SH by vvn<vvn@notworth.it>"
echo "************************************"
echo ""
echo "checking if spoof-mac is installed.."
echo ""

if ! type "spoof-mac" > /dev/null; then
  git clone https://github.com/feross/spoofmac spoofmac
  cd spoofmac
  python setup.py install
  if type "spoof-mac" > /dev/null; then
    echo "spoof-mac successfully installed!"
    cd ..
    rm -rf spoofmac
  else
    echo "there was a problem installing spoof-mac. please check you have python and easy_install properly installed."
  fi
else
  SPOOFMAC=`which spoof-mac`
  echo "spoof-mac found at $SPOOFMAC, no need to install!"
fi

echo ""
echo "refreshing wifi services.."
sysctl -w net.inet.icmp.drop_redirect=1
arp -a -d
if [ -n 0 ]; then
  echo "ARP tables cleared"
fi

WIFINT=`ifconfig -l | grep -oh en[1-9]`

for i in $WIFINT
  do
    ifconfig $i down
    if [ -n 0 ]; then
      echo "interface $i temporarily disabled"
    fi
    sleep 2
    route -n flush
    if [ -n 0 ]; then
      echo "routes flushed"
    fi
    sleep 2
    ifconfig $i up
    if [ -n 0 ]; then
      echo "interface $i re-enabled"
    fi
    sleep 1
    ifconfig $i mediaopt full-duplex
    echo "interface $i running in full-duplex mode"
    sleep 2
    if type "spoof-mac" > /dev/null; then
      spoof-mac randomize $i
      echo "MAC address randomized"
      sleep 2
    else
      echo "spoof-mac is not installed. skipping MAC randomization."
      echo "to install spoof-mac, git clone https://github.com/feross/spoofmac"
    fi
    ifconfig $i up
  done

if type "spoof-mac" > /dev/null; then
  spoof-mac list
fi
sleep 2
echo "Wi-Fi successfully restarted."

exit 0
