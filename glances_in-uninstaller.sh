#!/bin/bash -

#
# Script in- and uninstalls Glances with webinterface support.
#
# ummeegge ipfire org $date: 10.05.2016 CEST 15:54:24
#######################################################################
#

PACKAGEA="glances_for_IPFire-2.10-32bit.tar.gz";
URLA="http://people.ipfire.org/~ummeegge/glances/32bit/";
SUMA="5799fd7e65c18dc61fe6f8d13a997cef20714686137ba62d3a6ccb06425c387d";
PACKAGEB="glances_for_IPFire-2.10-64bit.tar.gz";
URLB="http://people.ipfire.org/~ummeegge/glances/64bit/";
SUMB="5a15bce2e2152dae72a5e61ac9dbb568c37b2f80eaab4f000b848924de4b8458";
PAK="/opt/pakfire/tmp";
TAR="tar xvf";
INIT="/etc/rc.d/init.d/glances";
BIN="glances";
META="/opt/pakfire/db/installed/meta-glances";

# Packages
GL="glances-2.10-1.ipfire";
PS="python-psutil-5.2.2-1.ipfire";
SE="python-setuptools-0.6c11-2.ipfire";
BO="python-bottle-0.12.13-1.ipfire";

# Platform check
TYPE=$(uname -m | tail -c 3);


# Formatting Colors and text
COLUMNS="$(tput cols)";
R=$(tput setaf 1);
B=$(tput setaf 6);
b=$(tput bold);
N=$(tput sgr0);
seperator(){ printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -; }
WELCOME="Welcome to Glances on IPFire installation";
WELCOMEA="This script includes an in- and unstaller for Glances";
INSTALL="If you want to install Glances press          ${B}${b}'i'${N} and [ENTER]";
UNINSTALL="If you want to uninstall Glances press        ${B}${b}'u'${N} and [ENTER]";
QUIT="If you want to quit this installation press    ${B}${b}'q'${N} and [ENTER]";

# Clean up function
clean_up() {
    cd ${PAK};
    rm -rvf files.tar.xz install.sh *.ipfire ROOTFILES uninstall.sh update.sh;
    cd /tmp || exit 1;
}

symlink_function() {
    ## Add symlinks
    # Possible runlevel ranges
    SO="[5-9][0-9]";
    SA="[3-9][0-9]";
    RE="[3-9][0-9]";
    # Search free runlevel
    STOP=$(ls /etc/rc.d/rc0.d/ | sed -e 's/[^0-9]//g' | awk '$1!=p+1{print p+1" "$1-1}{p=$1}' | sed -e '1d' | tr ' ' '\n' | grep -E "${SO}" | head -1);
    START=$(ls /etc/rc.d/rc3.d/ | sed -e 's/[^0-9]//g' | awk '$1!=p+1{print p+1" "$1-1}{p=$1}' | sed -e '1d' | tr ' ' '\n' | grep -E "${SA}" | head -1);
    REBOOT=$(ls /etc/rc.d/rc6.d/ | sed -e 's/[^0-9]//g' | awk '$1!=p+1{print p+1" "$1-1}{p=$1}' | sed -e '1d' | tr ' ' '\n' | grep -E "${RE}" | head -1);
    # Add symlinks
    ln -s ../init.d/${BIN} /etc/rc.d/rc0.d/K${STOP}${BIN};
    ln -s ../init.d/${BIN} /etc/rc.d/rc3.d/S${START}${BIN};
    ln -s ../init.d/${BIN} /etc/rc.d/rc6.d/K${REBOOT}${BIN};
}

# Installer Menu
while true
do
    # Choose installation
    echo ${N};
    clear;
    seperator;
    printf "%*s\n" $(((${#WELCOME}+COLUMNS)/2)) "${WELCOME}";
    printf "%*s\n" $(((${#WELCOMEA}+COLUMNS)/2)) "${WELCOMEA}";
    seperator;
    echo;
    printf "%*s\n" $(((${#INSTALL}+COLUMNS)/2)) "${INSTALL}";
    printf "%*s\n" $(((${#UNINSTALL}+COLUMNS)/2)) "${UNINSTALL}";
    echo;
    seperator;
    printf "%*s\n" $(((${#QUIT}+COLUMNS)/2)) "${QUIT}";
    seperator;
    echo;
    read choice
    clear;

    # Install Glances
    case $choice in
        i*|I*)
            clear;
            if [ -e /usr/bin/glances ]; then
                echo;
                echo "Glances is already installed on your system, please uninstall it first if needed. ";
                echo
                exit 1;
            else
                read -p "To install Glances now press [ENTER] , to quit use [CTRL-c]... ";
                cd /tmp || exit 1;
                # Check for 32-bit system
                if [[ ${TYPE} = "86" ]]; then
                    # Check if package is already presant otherwise download it
                    if [[ ! -e "${PACKAGEA}" ]]; then
                        echo;
                        curl -O ${URLA}/${PACKAGEA};
                        # Check SHA256 sum
                        CHECK=$(sha256sum ${PACKAGEA} | awk '{print $1}');
                        if [[ "${CHECK}" = "${SUMA}" ]]; then
                            echo;
                            echo -e "SHA2 sum should be \033[1;32m${SUMA}\033[0m";
                            echo -e "SHA2 sum is        \033[1;32m${CHECK}\033[0m and is correct… ";
                            echo;
                            echo "will go to further processing :-) ...";
                            echo;
                            sleep 3;
                        else
                            echo;
                            echo -e "SHA2 sum should be \033[1;32m${SUMA}\033[0m";
                            echo -e "SHA2 sum is        \033[1;32m${CHECK}\033[0m and is not correct… ";
                            echo;
                            echo -e "\033[1;31mShit happens :-( the SHA2 sum is incorrect, please report this here\033[0m";
                            echo;
                            exit 1;
                        fi
                    fi
                elif [[ ${TYPE} = "64" ]]; then
                    # Check if package is already presant otherwise download it
                    if [[ ! -e "${PACKAGE}" ]]; then
                        echo;
                        curl -O ${URLB}/${PACKAGEB};
                        # Check SHA256 sum
                        CHECK=$(sha256sum ${PACKAGEB} | awk '{print $1}');
                        if [[ "${CHECK}" = "${SUMB}" ]]; then
                            echo;
                            echo -e "SHA2 sum should be \033[1;32m${SUMB}\033[0m";
                            echo -e "SHA2 sum is        \033[1;32m${CHECK}\033[0m and is correct… ";
                            echo;
                            echo "will go to further processing :-) ...";
                            echo;
                            sleep 3;
                        else
                            echo;
                            echo -e "SHA2 sum should be \033[1;32m${SUMB}\033[0m";
                            echo -e "SHA2 sum is        \033[1;32m${CHECK}\033[0m and is not correct… ";
                            echo;
                            echo -e "\033[1;31mShit happens :-( the SHA2 sum is incorrect, please report this here\033[0m";
                            echo;
                            exit 1;
                        fi
                    fi
                else
                        echo;
                        echo "Sorry this platform is currently not supported... Need to quit.";
                        echo;
                        exit 1;
                fi
            fi

            ## Installation part
            tar xvfz glances_for_IPFire-2.10-*;
            # Install psutil
            mv ${GL} ${PAK};
            cd ${PAK};
            ${TAR} ${GL}
            ./install.sh;
            clean_up;

            # Install setuptools
            mv ${SE} ${PAK};
            cd ${PAK};
            $TAR ${SE};
            ./install.sh;
            clean_up;

            # Install distutils via Pakfire
            pakfire install python-distutils;

            # Install glances
            mv ${PS} ${PAK};
            cd ${PAK};
            $TAR ${PS};
            ./install.sh;
            clean_up;

            clear;
            printf "%b" "If you want also the Glances webinterface press ${R}'Y'${N} - If Glances over Console/SSH is enough press ${R}'N'${N}: ";
            read what;
            echo;
            case "$what" in
                y*|Y*)
                    # Install bottle
                    mv ${BO} ${PAK};
                    cd ${PAK};
                    ${TAR} ${BO}
                    ./install.sh;
                    clean_up;
                    # Install glances init script
                    cat > "${INIT}" << "EOF"
#!/bin/sh
########################################################################
# Begin $rc_base/init.d/glances
#
# Description : Glances daemon init script
#
# ummeegge|at|ipfire|org $date:11.05.2016 11:22:23
########################################################################

. /etc/sysconfig/rc
. ${rc_functions}

DESC="Glances server";
NAME="glances";
DAEMON="/usr/bin/${NAME}";
CONF="/etc/glances/glances.conf";
DAEMON_ARGS="-C ${CONF} -w";
PID=$(ps | grep glances | awk '{ print $1 }' | tr '\n' ' ');

# Exit if the package is not installed
[ -x "${DAEMON}" ] || exit 0


case "${1}" in
   start)
      boot_mesg "Starting ${DESC}..."
      ${NAME} ${DAEMON_ARGS} > /dev/null &
      ;;

   stop)
      boot_mesg "Stopping ${DESC}..."
      killproc ${NAME};
      kill ${PID};
      ;;

   restart)
      ${0} stop
      sleep 1
      ${0} start
      ;;

   status)
      statusproc ${NAME}
      ;;

   *)
      echo "Usage: ${0} {start|stop|restart|status}"
      exit 1
      ;;
esac

# End $rc_base/init.d/glances

EOF
                    # Set init script permissions
                    chmod 754 ${INIT};
                    # Set symlinks
                    symlink_function;
                    # Set meta file
                    touch ${META};
                    /etc/init.d/glances start;
                    echo;
                    echo "You can reach the Glances web interface over 'http://Green-IP-ipfire:61208' ";
                    echo "For further extensions, take a look in here --> http://forum.ipfire.org/viewtopic.php?t=16563 ...";
                    echo
                    read -p "To finish now installation press [ENTER] ... ";
                    echo;
                ;;

                n*|N*)
                    echo;
                    echo "OK won´t install Glances web interface";
                    echo;
                    sleep 3
                ;;
            esac

            clear;
            echo "Installation is finish now... "
            echo
            sleep 3;
            echo;
            clear;
            printf "%b" "If you want to start it now press ${R}'Y'${N} (you can quit it by pressing ${R}'q'${N} - Otherwise press ${R}'N'${N}: \nYou can use Glances by simply typing 'glances' into the console: \n";
            read what;
            echo;
            case "$what" in
                y*|Y*)
                    # Start Glances
                    glances;
                ;;

                n*|N*)
                    echo "OK will quit... Goodbye. ";
                    exit 0;
                ;;
            esac
            exit 0
        ;;
           
        u*|U*)
            clear;
            read -p "To uninstall Glances now press u and [ENTER], to quit use [CTRL-c]... ";

            if [ -e /usr/bin/glances ]; then
                rm -rvf \
                /usr/bin/glances \
                /etc/glances \
                /usr/bin/easy_install* \
                /usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg \
                /usr/lib/python2.7/site-packages/easy-install.pth \
                /usr/lib/python2.7/site-packages/bottle.py* \
                /usr/lib/python2.7/site-packages/Glances-*-py2.7.egg/ \
                /usr/lib/python2.7/site-packages/psutil-*-py2.7-*.egg;
                pakfire remove python-distutils;
                if [ -e "${INIT}" ]; then
                    rm -rfv \
                    ${INIT} \
                    ${META} \
                    /etc/rc.d/rc?.d/*glances;
                fi
                echo;
                echo "Glances has been uninstalled, the uninstaller is finished now, thanks for testing.";
                echo;
                echo "Goodbye."
                echo;
                if [ -n "$(pgrep glances)" ]; then
                    kill $(pgrep glances);
                fi
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

## EOF
