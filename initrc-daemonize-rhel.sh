#!/bin/bash
#
# @@APP@@	This shell script takes care of starting and stopping
#
# chkconfig: - 64 36
# description:	@@APP@@
# processname: @@APP@@
# pidfile: /var/run/@@APP@@.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

prog="/usr/sbin/@@APP@@"
logfile="/var/log/@@APP@@.log"
pidfile="/var/run/@@APP@@.pid"
prog_opts="   "
delay=10

function x_start
{
	echo -n "starting $prog ..."
	daemon --pidfile=$pidfile +20 \
		"($0 exec $prog $prog_opts &) &"
	success
}

function x_stop
{
	echo -n "stoping $prog ..."
	killproc -p $pidfile -d $delay $prog

}

function x_status
{
	status $prog
}

function x_exec
{
	pid=$$
	echo $pid > $pidfile
	exec $* 0<&- >> $logfile 2>&1
}

# See how we were called.
case "$1" in
  exec)
    shift
    x_exec $*
    ;;
  start)
    x_start
    ;;
  stop)
    x_stop
    ;;
  status)
    x_status
    ;;
  restart)
    x_restart
    ;;
  condrestart)
    x_restart
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|condrestart|restart}"
    exit 1
esac

exit $?
