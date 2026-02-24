#!/usr/bin/env bash

source "$1/string.sh"

export PS4='+ [${BASH_SOURCE}:${LINENO}] '

LOGFILE="trace.log"

: > "$LOGFILE"

LOG_OUT=$(mktemp --suffix=".log")
LOG_ERR=$(mktemp --suffix=".log")

LOG_TMP=$(dirname -- "$LOG_OUT")

CHECK=OK

log()
{
	echo -e "|$(date --rfc-3339=seconds)|:[ LEVEL: ${1} ]:| >>>>>>>>>>>> BEGIN"
	echo -e "$(cat $LOG_OUT)"
	echo -e "$(cat $LOG_ERR)"
	echo -e "<<<<<<<<<<<< END"
}

assert()
{
	local func="$1"

	(
		exec 3>&1
		BASH_XTRACEFD=3
		set -xe
		"$func"
	) > $LOG_OUT 2> $LOG_ERR
	
	local status=$?
	
	local errorlog=$(cat $LOG_ERR)
	local result
	
	if [ $status -eq 0 ]; then
		[ -z "$errorlog" ] && result=OK || result=WARN
	else
		result=FAIL
	fi


	if [ "$result" = FAIL ]; then
		CHECK=FAIL
	elif [ "$result" = WARN ] && [ "$CHECK" != FAIL ]; then
		CHECK=WARN
	fi
	
	log "$result" >> $LOGFILE
	echo "$errorlog" >&2
	str_status "$2"  $result
}

log_msg()
{
	if [ "$CHECK" = FAIL ]; then
		echo "trace log available at $(pwd)/$LOGFILE or run 'make trace'."
	fi
}

log_clean()
{
	rm "$LOG_OUT" "$LOG_ERR"
}

