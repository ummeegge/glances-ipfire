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
