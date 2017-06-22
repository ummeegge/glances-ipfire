# glances-ipfire
################
Scripts should deliver a possiblity to install and uninsinstall 
Glances --> https://github.com/nicolargo/glances
on IPFire systems --> https://github.com/ipfire/ipfire-2.x 
also with webinterface extension to get an alternative IPFire system monitoring via console/SSH or if wanted also via web interface.



This repo contains currently:

- glances_in-uninstaller.sh:
	- An in- and uninstaller for Glances and his dependcies on IPFire systems.
	- 32 and 64 bit binaries are available which are located in here --> http://people.ipfire.org/~ummeegge/glances/ .
	- Installer includes installation for psutil, setuptools and distutils. Bottle is also packed in there but...
	- Installer provides a possibility to install the webinterface extension from Glances which is reachable over IPFires local network interfaces via http://LAN-IP-ipfire:61208/


- glances_init.sh:
	- Web interface installation includes an initscript, whereby all symlinks will also be set, so a 'glances -w' won´t be possible.
	- Web interface works via his own fast and simple micro-framework for python web-applications calles bottle.py --> https://github.com/bottlepy/bottle whic will also be installed if wanted.


