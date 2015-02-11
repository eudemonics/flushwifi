## flushwifi
a simple script written for OSX to restart all network interfaces,
clear ARP cache, and flush routes. also added protection from ICMP
redirect attacks which OSX won't store as a permanent setting, so
it needs to be run each startup:

>> sysctl -w net.inet.icmp.drop_redirect=1

requires spoof-mac in order to utilize MAC spoofing functionality.

get it here:

>> https://github.com/feross/SpoofMAC
