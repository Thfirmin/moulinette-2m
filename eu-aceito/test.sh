#!/usr/bin/env bash

source ../tools/box.sh ../tools

repo_url="$1"
name="$2"
repo_path="/tmp/$2"
dir="eu"
file="aceito.txt"
pad=40

outlog=$(mktemp --suffix=".log")
errlog=$(mktemp --suffix=".log")

if [[ -z "$1" || -z "$2" ]]; then
	str_error "Usage: $0 <repository_url> <repo_name>"
	exit 1
fi

# =======================================
# FUNCTIONS DEFINITION
# =======================================

checker()
{
	errlog="$(cat $2)"

	if [[ -n "$errlog" && "$1" = OK ]]; then
		echo "WARN"
	else
		echo OK
	fi
}

check_repository()
{
	git clone "$repo_url" "$repo_path" > $outlog 2> $errlog
	cat $errlog | sed 's/Cloning into '"'\/tmp\/$name'"'\.\.\.//g' > "${errlog}2"
	mv ${errlog}2 $errlog
	[ $? -eq 0 ] && echo "OK" || echo "FAIL"
}

check_directory()
{
	ls -l "$repo_path/$dir" > $outlog 2> $errlog
	[ $? -eq 0 ] && echo "OK" || echo "FAIL"
}

check_file()
{
	ls -l "$repo_path/$dir/$file" > $outlog 2> $errlog
	[ $? -eq 0 ] && echo "OK" || echo "FAIL"
}

validate_file()
{
	diff "$repo_path/$dir/$file" "aceito.diff" > $outlog 2> $errlog
	[ $? -eq 0 ] && echo "OK" || echo "FAIL"
}


# =======================================
# MAIN SCRIPT
# =======================================

rm -rf "$repo_path"

box_header "Eu Aceito"

check=$(check_repository)
cat $errlog
check=$(checker "$check" "$errlog")
str_status -p $pad "'eu-aceito' repository existence"  $check

if [[ "$check" = OK || "$check" = WARN ]]; then
	check=$(check_directory)
	cat $errlog
	check=$(checker "$check" "$errlog")
	str_status -p $pad "'eu' directory existence"  $check
fi

if [[ "$check" = OK || "$check" = WARN ]]; then
	check=$(check_file)
	cat $errlog
	check=$(checker "$check" "$errlog")
	str_status -p $pad "'aceito.txt' file existence"  $check
fi


if [[ "$check" = OK || "$check" = WARN ]]; then
	check=$(validate_file)
	cat $errlog
	check=$(checker "$check" "$errlog")
	str_status -p $pad "Valid file content"  $check
fi

str_status -p $pad "Eu aceito result" $check

rm -rf $repo_path $errlog $outlog

[ "$check" != FAIL ] || exit 1
