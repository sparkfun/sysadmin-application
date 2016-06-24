#!/bin/bash
#Oracle service app
#chkconfig: 2345 95 05
#Run at 3 5
#Stop at 0 6
#processname: oracle

SERVICE_PATH="/opt/oracle/app/product/12101/db_1/bin"
ORACLE_HOME="/opt/oracle/app/product/12101/db_1"


NAME=oracledb
DESC="Starts and Stops gracefully Oracle DB"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

case "$1" in
start)
        printf "%-50s" "Starting $NAME..."
        su - oracle -c '/opt/oracle/app/product/12101/db_1/bin/dbstart /opt/oracle/app/product/12101/db_1'
        su - oracle -c '/opt/oracle/scripts/start_agent'
;;
status)
        printf "Work in progress:  This script is ment to start and stop the DB Gracefully\n"
;;
stop)
        printf "%s-50s" "Stopping $NAME"
        su - oracle -c '/opt/oracle/app/product/12101/db_1/bin/dbshut /opt/oracle/app/product/12101/db_1'
        su - oracle -c '/opt/oracle/scripts/stop_agent'
        printf "%s\n" "OK"
;;

restart)
        $0 stop
        $0 start
;;
*)
        echo "Usage: $0 {status|start|stop|restart}"
        exit 1
esac
