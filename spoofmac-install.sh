#!/bin/bash
# SPOOFMAC-INSTALL.SH
# author: vvn <vvn@notworth.it>

#if (( $(id -u) )) ; then
#    echo "this script needs to run as root or sudo"
#    exit 1
#fi

git clone https://github.com/feross/spoofmac spoofmac

cd spoofmac

python setup.py install

if type "spoof-mac" > /dev/null; then
  echo "spoof-mac successfully installed!"
  cd ..
  rm -rf spoof-mac

else
  echo "there was a problem installing spoof-mac. please check you have python and easy_install properly installed."
  exit 1
fi

SPOOFMAC=`which spoof-mac`
echo "spoof-mac is installed at $SPOOFMAC"

exit 0
