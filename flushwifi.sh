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

WIFIDEV=`networksetup -listallhardwareports | grep -A 1 "Wi-Fi" | sed -ne 's/^.*Device: //p'`
WIFIMAC=`networksetup -listallhardwareports | grep -A 2 "Wi-Fi" | sed -ne 's/^.*Address: //p'`

echo ""
echo "system Wi-Fi device found on $WIFIDEV with MAC address: $WIFIMAC"

echo ""
echo "refreshing wifi services.."
echo ""

if (route -n flush); then
  echo "routes flushed"
fi

if (sysctl -w net.inet.icmp.drop_redirect=1); then
  echo "ICMP set to drop redirect packets"
fi

if (arp -a -d); then
  echo "ARP tables cleared"
fi

if (spoof-mac randomize $WIFIDEV); then
  echo "MAC address randomized for $WIFIDEV"
fi
sleep 1

if (ifconfig $WIFIDEV mediaopt full-duplex); then
  echo "interface $WIFIDEV running in full-duplex mode"
fi
spoof-mac list
sleep 1
ifconfig $WIFIDEV up
echo ""
echo "Wi-Fi successfully restarted."
exit 0
