#!/bin/bash -

#
# Script in- and uninstalls Glances with webinterface support.
#
# ummeegge ipfire org $date: 10.05.2016 CEST 15:54:24
#######################################################################
#

PACKAGE="glances_for_IPFire-2.6.1.tar.gz";
URL="http://people.ipfire.org/~ummeegge/glances/";
SUM="67c110ba55996ca6bdd5f682f50cbef90450ff22921e38d88b1dcbdb177dc6ef";
PAK="/opt/pakfire/tmp";
TAR="tar xvf";
TMP="/tmp";

# Packages
GL="glances-2.6.1-1.ipfire";
PS="python-psutil-4.1.0-1.ipfire";
ES="easy_install easy_install-2.7";
PY="setuptools-0.6c11-py2.7.egg easy-install.pth bottle.py";

# Platform check
TYPE=$(uname -m | tail -c 3);

# Clean up function
clean_up() {
   cd ${PAK};
   rm -rvf files.tar.xz install.sh *.ipfire ROOTFILES uninstall.sh update.sh;
   cd ${TMP};
}

# Installer Menu
while true
do

    # Choose installation
    clear;
    echo "+------------------------------------------------------------------------------+          ";
    echo "|                 Welcome to Glances on IPFire installation                    |          ";
    echo "|           This script includes an in- and unstaller for Glances              |          ";
    echo "+------------------------------------------------------------------------------+          ";
    echo;
    echo -e "    If you want to install Glances            press \033[1;36m'i'\033[0m and [ENTER]" ;
    echo -e "    If you want to uninstall Glances          press \033[1;36m'u'\033[0m and [ENTER]" ;
    echo;
    echo    "+------------------------------------------------------------------------------+";
    echo -e "          If you want to quit this installation press \033[1;36m'q'\033[0m and [ENTER] ";
    echo    "+------------------------------------------------------------------------------+";
    echo;
    read choice
    clear;

        # Install Glances   
        case $choice in
            i*|I*)
                clear;
                read -p "To install Glances now press [ENTER] , to quit use [CTRL-c]... ";
                cd /tmp || exit 1;
                # Check needed 32-bit system
                if [[ ${TYPE} != "86" ]]; then
                   echo "Sorry You need a 32-bit system, need to quit... ";
                   exit 1;
                fi
                # Check if package is already presant otherwise download it
                if [[ ! -e "${PACKAGE}" ]]; then
                   echo;
                   curl -O ${URL}/${PACKAGE};
                     # Check SHA256 sum
                   CHECK=$(sha256sum ${PACKAGE} | awk '{print $1}');
                      if [[ "${CHECK}" = "${SUM}" ]]; then
                       echo;
                       echo -e "SHA2 sum should be \033[1;32m${SUM}\033[0m";
                       echo -e "SHA2 sum is        \033[1;32m${CHECK}\033[0m and is correct… ";
                       echo;
                       echo "will go to further processing :-) ...";
                       echo;
                       sleep 3;
                   else
                       echo;
                       echo -e "SHA2 sum should be \033[1;32m${SUM}\033[0m";
                       echo -e "SHA2 sum is        \033[1;32m${CHECK}\033[0m and is not correct… ";
                       echo;
                       echo -e "\033[1;31mShit happens :-( the SHA2 sum is incorrect, please report this here\033[0m";
                       echo;
                       exit 1;
                     fi
                fi
                tar xvfz ${PACKAGE};
                 clear;
                 # Install psutil
                 mv ${GL} ${PAK};
                 cd ${PAK};
                 ${TAR} ${GL}
                 ./install.sh;
                 clean_up;

                 # Install glances
                 mv ${PS} ${PAK};
                 cd ${PAK};
                 $TAR ${PS};
                 ./install.sh;
                 clean_up;
                 # install python
                 cp ${PY} /usr/lib/python2.7/site-packages;
             
                 # Install setuptools binaries
                 cp ${ES} /usr/bin;
             
                 # Install distutils via Pakfire
                 pakfire install python-distutils;
             
                 # webinterface support
                 cp bottle.py /usr/lib/python2.7/site-packages;
             
                 # Clean up /tmp
                 rm -rfv bottle.py  easy_install  easy_install-2.7  easy-install.pth setuptools-0.6c11-py2.7.egg

             
                 clear;
                 echo "Installation is finish now... "
                 echo
                 echo "You can use Glances by simply typing 'glances' into the console";
                 echo "Goodbye";
                 exit 0;
         ;;
           
         u*|U*)
                clear;
                read -p "To uninstall Glances now press u and [ENTER], to quit use [CTRL-c]... ";

                if [[ -e /usr/bin/glances ]]; then
                    rm -rvf \
                    /usr/bin/glances \
                    /etc/glances \
                    /usr/bin/easy_install \
                    /usr/bin/easy_install-2.7 \
                    /usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg \
                    /usr/lib/python2.7/site-packages/easy-install.pth \
                    /usr/lib/python2.7/site-packages/bottle.py* \
                     /usr/lib/python2.7/site-packages/Glances-2.6.1-py2.7.egg/ \
                     /usr/lib/python2.7/site-packages/psutil-4.1.0-py2.7-linux-i586.egg;
                     pakfire remove python-distutils;
                     cd /tmp || exit 1;
                     rm -rf ${ES} ${PY};
                    echo;
                    echo "Glances has been uninstalled, the uninstaller is finished now, thanks for testing.";
                    echo;
                    echo "Goodbye."
                    echo;
                    exit 0;
                else
                    echo;
                    echo "Can´t find Glances installation... ";
                    echo;
                    exit 1;
                fi
        ;;

        q*|Q*)
                exit 0
        ;;
   
        *)   
                echo;
                echo "   Ooops, there went something wrong 8-\ - for explanation again   ";
                echo "-------------------------------------------------------------------";
                echo "             To install Glances press    'i' and [ENTER]";
                echo "             To uninstall Glances press  'u' and [ENTER]";
                echo;
                read -p " To start the installer again press [ENTER] , to quit use [CTRL-c]";
                echo;
        ;;
   
    esac

done

## End Glances installer script

