#!/usr/bin/env bash

source ../tools/box.sh ../tools

export PS4='+ [${BASH_SOURCE}:${LINENO}] '

LOGFILE="trace.log"

: > "$LOGFILE"

OUTLOG=$(mktemp --suffix=".log")
ERRLOG=$(mktemp --suffix=".log")

TMP=$(dirname -- "$OUTLOG")

REPO_URL="$1"
NAME="$2"
REPO_PATH="$TMP/$2"
DIR="eu"
FILE="aceito.txt"
PAD=40
CHECK=OK


if [[ -z "$1" || -z "$2" ]]; then
	str_error "Usage: $0 <repository_url> <repo_name>"
	exit 1
fi

# =======================================
# FUNCTIONS DEFINITION
# =======================================

log()
{
	echo -e "|$(date --rfc-3339=seconds)|:[ LEVEL: ${1} ]:| >>>>>>>>>>>> BEGIN"
	echo -e "$(cat $OUTLOG)"
	echo -e "$(cat $ERRLOG)"
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
	) > $OUTLOG 2> $ERRLOG
	
	local status=$?
	
	local errorlog=$(cat $ERRLOG)
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
	str_status -p $PAD "$2"  $result
}

check_repository()
{
	git clone "$REPO_URL" "$REPO_PATH"
}

check_directory()
{
	ls -l "$REPO_PATH/$DIR"
}

check_file()
{
	ls -l "$REPO_PATH/$DIR/$FILE"
}

validate_file()
{
	diff "$REPO_PATH/$DIR/$FILE" "aceito.diff"
}


# =======================================
# MAIN SCRIPT
# =======================================

[ -d "$REPO_PATH" ] && rm -rf "$REPO_PATH"

box_header "Eu Aceito"

assert check_repository "'$NAME' repository existence"

if [ "$CHECK" != FAIL ]; then
	assert check_directory "'$DIR' directory existence"
fi

if [ "$CHECK" != FAIL ]; then
	assert check_file "'$FILE' file existence"
fi

if [ "$CHECK" != FAIL ]; then
	assert validate_file "Valid file content"
fi

echo

str_status -p $PAD "Eu aceito result" $CHECK

if [ "$CHECK" = FAIL ]; then
	echo "trave log available at $(pwd)/$LOGFILE"
fi

rm -rf "$REPO_PATH" "$ERRLOG" "$OUTLOG"

[ "$CHECK" != FAIL ] || exit 1
