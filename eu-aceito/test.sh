#!/usr/bin/env bash

cd $(dirname -- "$0")

source "../tools/binutils.sh"

import "../tools/box.sh"
import "../tools/logger.sh"

REPO_URL="$1"
NAME="$2"
REPO_PATH="$LOG_TMP/$2"

DIR="eu"
FILE="aceito.txt"

if [[ -z "$1" || -z "$2" ]]; then
	str_error "Usage: $0 <repository_url> <repo_name>"
	exit 1
fi

# =======================================
# CHECK FUNCTIONS DEFINITION
# =======================================

check_repository()
{
	git clone "$REPO_URL" "$REPO_PATH"
}

check_directory()
{
	test -d "$REPO_PATH/$DIR"
}

check_file()
{
	test -f "$REPO_PATH/$DIR/$FILE"
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

str_status "Eu aceito result" $CHECK

log_msg

rm -rf "$REPO_PATH"
log_clean

exit 0
