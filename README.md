# flushwifi
a simple script written for OSX to restart all network interfaces, clear ARP cache, and flush routes. also added protection from ICMP redirect attacks which OSX won't store as a permanent setting, so it needs to be run each startup:

	sysctl -w net.inet.icmp.drop_redirect=1

**requires spoof-mac in order to utilize MAC spoofing functionality.**

get it here:

<https://github.com/feross/SpoofMAC>

###TO INSTALL AND RUN SCRIPT:

	git clone https://github.com/eudemonics/flushwifi flushwifi
	cd flushwifi
	cp flushwifi.sh /usr/local/bin/

**OPTIONAL - REMOVE GIT DOWNLOAD DIRECTORY:**

	cd ..
	rm -rf flushwifi

**OPTIONAL (just in case your environmental path is all screwed up):**

	export PATH=${PATH}:/usr/local/bin

**SET SCRIPT AS EXECUTABLE:**

	chmod +x /usr/local/bin/flushwifi.sh

**FINALLY, RUN THE SCRIPT:**

	sudo flushwifi.sh
