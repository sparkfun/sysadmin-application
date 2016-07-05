#!/bin/bash

# Nagios Log Server Linux setup script
# Copyright 2014, Nagios Enterprises LLC.
# Released under the terms of the Nagios Software License:
# <http://assets.nagios.com/licenses/nagios_software_license.txt>

# Configure syslog on a Linux system to forward logs to a Nagios Log Server.


# Exit immediately if an untested command fails
set -e



# Print license information for this script.
license() {
	cat <<-EOF

		Nagios Log Server Linux setup script
		Copyright 2014, Nagios Enterprises LLC.
		License:
		    Nagios Software License <http://assets.nagios.com/licenses/nagios_software_license.txt>
	EOF
}

# Print a usage message.
usage() {
	cat <<-EOF

		Usage: setup-linux.sh -s HOST [options...]

		Options:
		    -h
		        Display this help text

		    -n
		        Assume defaults for all questions (for scripted installs)

		    -s HOST
		        Log server hostname or IP address (required)

		    -p PORT
		        Log server port (defaults to '5544')

		    -f FILE
		        Forward messages from this file to Log Server

		    -t FILETAG
		        A tag for FILE, Log Server will see this as 'programname'

	EOF
}

# Print an error message (passed as $1) followed by the usage instructions and
# exit with an error status.
usage_error() {
	echo $1
	usage
	exit 1
}

# Convenience function for printing errors and exiting.
error() {
	echo "ERROR:" "$@" >&2
	exit 1
}



# Make sure we're running as root, error out if not.
we_need_to_be_root() {
	if [ $(id -u) -ne 0 ]; then
		error "This script needs to be run as root/superuser."
	fi
}

# Pretty self-descriptive: we expect /sbin and /usr/sbin to be in PATH.
make_sure_path_is_good() {
	path_is_ok() {
		echo "$PATH" \
		| awk 'BEGIN{RS=":"} {p[$0]++} END{if (p["/sbin"] && p["/usr/sbin"]) exit(0); exit(1)}'
	}

	if ! path_is_ok; then
		echo "Your system \$PATH does not include /sbin and /usr/sbin. This"\
			"could be the result of installing GNOME rather than creating a"\
			"clean system."
		echo "Adding /sbin and /usr/sbin to \$PATH."
		PATH="$PATH:/sbin:/usr/sbin"
	fi
	unset -f path_is_ok
}



# syslog detection variables.
HAVE_SYSLOG_NG=
HAVE_RSYSLOG=

RSYSLOG_SPOOL_D=

SYSLOG_TYPE=
SYSLOG_SERVICE=
SYSLOG_CONF_D=
SYSLOG_CONF_F=

# Detect syslog system and set default locations.
detect_syslog_system() {

	if which syslog-ng &> /dev/null; then
		output=`syslog-ng --version`
		regex='syslog-ng ([0-9]+\.[0-9]+\.[0-9]+)'
		[[ $output =~ $regex ]]
		HAVE_SYSLOG_NG="${BASH_REMATCH[1]}"
		echo "Found syslog-ng $HAVE_SYSLOG_NG"
		SYSLOG_TYPE='syslog-ng'
		SYSLOG_SERVICE='syslog-ng'
		SYSLOG_CONF_D='/etc/syslog-ng/'
		SYSLOG_CONF_F='/etc/syslog-ng/syslog-ng.conf'
	fi

	if which rsyslogd &> /dev/null; then
		output=`rsyslogd -v`
		regex='rsyslogd ([0-9]+\.[0-9]+\.[0-9]+)'
		[[ $output =~ $regex ]]
		HAVE_RSYSLOG="${BASH_REMATCH[1]}"
		echo "Detected rsyslog $HAVE_RSYSLOG"
		SYSLOG_TYPE='rsyslog'
		SYSLOG_SERVICE='rsyslogd'
		SYSLOG_CONF_D='/etc/rsyslog.d/'
		SYSLOG_CONF_F='/etc/rsyslog.conf'
		detect_rsyslog_spool
	fi

	# Bail out if we don't have rsyslog. We could support syslog-ng easily
	# enough with a bit of tweaking and special-cases...
	if [ -z "$HAVE_RSYSLOG" -a -z "$HAVE_SYSLOG_NG" ]; then
		error "No syslog service found."
	elif [ -z "$HAVE_RSYSLOG" -a -n "$HAVE_SYSLOG_NG" ]; then
		error "Found syslog-ng but not rsyslog. Automatic configuration of"\
			"syslog-ng for Nagios Log Server is not currently supported."
	fi
}

# Detect the local syslog spool directory.
detect_rsyslog_spool() {
	if [ -d '/var/spool/rsyslog' ]; then
		RSYSLOG_SPOOL_D='/var/spool/rsyslog'
		# On Ubuntu systems we may need to change ownership.
		# 	if [  ]
		# 		chown -R syslog:adm $RSYSLOG_SPOOL_D
		# 	fi
	elif [ -d '/var/lib/rsyslog' ]; then
		RSYSLOG_SPOOL_D='/var/lib/rsyslog'
	else
		error "No rsyslog spool directory found. Make sure rsyslog is"\
			"installed and configured correctly."
	fi

	echo "Detected rsyslog work directory $RSYSLOG_SPOOL_D"
}



# Check if SELinux might cause problems, and notify the user if so.
check_for_selinux() {
	if ! which getenforce &> /dev/null; then
		echo "getenforce command not found, assuming SELinux is disabled."
		return
	fi
	SELinux_MODE=$(getenforce 2>/dev/null)

	if [ $SELinux_MODE = "Disabled" ]; then
		echo "SELinux is disabled."
	elif [ $SELinux_MODE = "Permissive." ]; then
		echo "SELinux is permissive."
	elif [ $SELinux_MODE = "Enforcing" ]; then
		cat <<-EOF
==============================! WARNING !====================================
SELinux is enforcing. This may prevent $SYSLOG_TYPE from forwarding messages.
If log messages do not reach Log Server from this host, ensure SELInux is
configured to allow $SYSLOG_TYPE forwarding.
=============================================================================
		EOF
	fi
}

# Restart the syslog service so our configuration changes will be used.
restart_syslog_service() {
	# First try verifying the configuration (rsyslog specific).
	if ! rsyslogd -f $SYSLOG_CONF_F -N 1 &> /dev/null; then
		error "$SYSLOG_TYPE configuration check failed."
	else
		echo "$SYSLOG_TYPE configuration check passed."
	fi

	# Try using 'service' first.
	if which service &> /dev/null; then
		echo "Restarting $SYSLOG_TYPE service with 'service'..."
		if service $SYSLOG_TYPE restart; then
			echo "Okay."
			return 0
		fi
	fi

	# Try the SysV init script directly.
	if [[ -f "/etc/init.d/$SYSLOG_TYPE" ]]; then
		echo "Restarting $SYSLOG_TYPE service with '/etc/init.d/$SYSLOG_TYPE'..."
		if "/etc/init.d/$SYSLOG_TYPE" restart; then
			echo "Okay."
			return 0
		fi
	fi

	# Lastly try systemctl
	if which systemctl &> /dev/null; then
		echo "restarting $SYSLOG_TYPE service with 'systemctl'..."
		if systemctl restart $SYSLOG_TYPE; then
			echo "Okay."
			return 0
		fi
	fi

	error "Unable to restart $SYSLOG_TYPE service. Please restart the"\
		"$SYSLOG_TYPE service to use the new configuration."
}


# Default Log Server host:port
NLS_HOST=
NLS_PORT="5544"

# Send all local syslogs to the specified Nagios Log Server host:port.
setup_local_syslog_conf() {
	# Since we're forwarding everything that makes it to rsyslog, name our
	# conf file something that will sort at the end of the *.conf list.
	NLS_SYSLOG_CONF_F="${SYSLOG_CONF_D}99-nagioslogserver.conf"
	echo "Creating $NLS_SYSLOG_CONF_F..."

	cat >$NLS_SYSLOG_CONF_F <<-EOF
	### Begin forwarding rule for Nagios Log Server                           NAGIOSLOGSERVER
	\$WorkDirectory $RSYSLOG_SPOOL_D # Where spool files will live             NAGIOSLOGSERVER
	\$ActionQueueFileName nlsFwdRule0 # Unique name prefix for spool files     NAGIOSLOGSERVER
	\$ActionQueueMaxDiskSpace 1g   # 1GB space limit (use as much as possible) NAGIOSLOGSERVER
	\$ActionQueueSaveOnShutdown on # Save messages to disk on shutdown         NAGIOSLOGSERVER
	\$ActionQueueType LinkedList   # Use asynchronous processing               NAGIOSLOGSERVER
	\$ActionResumeRetryCount -1    # Infinite retries if host is down          NAGIOSLOGSERVER
	# Remote host is: name/ip:port, e.g. 192.168.0.1:514, port optional       NAGIOSLOGSERVER
	*.* @@$NLS_HOST:$NLS_PORT                                               # NAGIOSLOGSERVER
	### End of Nagios Log Server forwarding rule                              NAGIOSLOGSERVER
	EOF
}

# Poll messages from a file and forward them to Nagios Log Server.
setup_file_syslog_conf() {
	# Generate an identifier from the file path that can be embedded in a
	# filename. Translate / to _ and remove any leading _.
	NLS_FILE_ID=`echo $NLS_FILE_PATH | tr '/' '_' | sed 's/^_//'`
	# Limit the file ID length so our filenames are within FS limits.
	id_len=${#NLS_FILE_ID}
	max_id_len=$((`getconf NAME_MAX $SYSLOG_CONF_D`-24))
	if [ $id_len -gt $max_id_len ]; then
		NLS_FILE_ID=${NLS_FILE_ID:$id_len-$max_id_len}
	fi

	# Our file watching configs need to sort before our syslog forwarding, or
	# the *.* rule will send the file messages before we send them here and
	# then stop processing them, resulting in duplicates in Log Server.
	NLS_SYSLOG_CONF_F="${SYSLOG_CONF_D}90-nagioslogserver_$NLS_FILE_ID.conf"
	echo "Creating $NLS_SYSLOG_CONF_F..."

	cat >$NLS_SYSLOG_CONF_F <<-EOF
	\$ModLoad imfile
	\$InputFilePollInterval 10
	\$PrivDropToGroup adm
	\$WorkDirectory $RSYSLOG_SPOOL_D

	# Input for $NLS_FILE_TAG
	\$InputFileName $NLS_FILE_PATH
	\$InputFileTag ${NLS_FILE_TAG}:
	\$InputFileStateFile nls-state-$NLS_FILE_ID # Must be unique for each file being polled
	# Uncomment the folowing line to override the default severity for messages
	# from this file.
	#\$InputFileSeverity info
	\$InputFilePersistStateInterval 20000
	\$InputRunFileMonitor

	# Forward to Nagios Log Server and then discard, otherwise these messages
	# will end up in the syslog file (/var/log/messages) unless there are other
	# overriding rules.
	if \$programname == '$NLS_FILE_TAG' then @@$NLS_HOST:$NLS_PORT
	if \$programname == '$NLS_FILE_TAG' then ~
	EOF
}



# Take care of the prereqs.
we_need_to_be_root
make_sure_path_is_good
detect_syslog_system


# Process our arguments and figure out what to do.
FILE_PATH_COUNT=0
FILE_TAG_COUNT=0
while getopts "hns:p:f:i:t:" opt; do
	case $opt in

		h ) license; usage; exit 0;;

		n ) INTERACTIVE="False";;

		s ) NLS_HOST="$OPTARG";;

		p ) NLS_PORT="$OPTARG"
			if [[ ! $NLS_PORT =~ ^[0-9]+$  ]] || [ $NLS_PORT -le 0 ]; then
				usage_error "-$opt: '$OPTARG' is not a valid port number."
			fi
			;;

		f ) NLS_FILE_PATH="$OPTARG"
			if [ $FILE_PATH_COUNT -ne 0 ]; then
				usage_error "-$opt: Only one file path may be given at a time."
			elif [ ! -r $NLS_FILE_PATH ]; then
				usage_error "-$opt: '$OPTARG' is not a readable file."
			fi
			FILE_PATH_COUNT=1
			;;

		i|t ) NLS_FILE_TAG="$OPTARG"
			if [ $FILE_TAG_COUNT -ne 0 ]; then
				usage_error "-$opt: Only one file tag may be given at a time."
			fi
			FILE_TAG_COUNT=1
			;;

		? ) usage; exit 1;;

	esac
done

shift $(($OPTIND - 1))
if [ -n "$*" ]; then usage_error "Unexpected extra arguments: '$*'"; fi

if [ -z "$NLS_HOST" ]; then usage_error "No log server host specified."; fi

echo "Destination Log Server: $NLS_HOST:$NLS_PORT"

if [ $((FILE_PATH_COUNT+FILE_TAG_COUNT)) -eq 1 ]; then
	usage_error "File forwarding requires a file path and tag."
fi


# Now setup the local syslog configuration.
if [ $FILE_PATH_COUNT -eq 0 ]; then
	setup_local_syslog_conf
else
	setup_file_syslog_conf
fi

check_for_selinux
restart_syslog_service

echo "$SYSLOG_TYPE is running with the new configuration."
echo "Visit your Nagios Log Server dashboard to verify that logs are being received."
