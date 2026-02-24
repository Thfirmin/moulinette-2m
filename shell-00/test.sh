#!/usr/bin/env bash

cd $(dirname -- "$0")

source "../tools/binutils.sh"

import "../tools/box.sh"
import "../tools/logger.sh"

REPO_URL="$1"
NAME="$2"
REPO_PATH="$LOG_TMP/$2"

if [[ -z "$1" || -z "$2" ]]; then
	str_error "Usage: $0 <repository_url> <repo_name>"
	exit 1
fi

# =======================================
# CHECK FUNCTIONS DEFINITION
# =======================================

test_repository()
{
	local permited_files="
		ex00
		ex01
		ex02
		ex03
		ex04
		ex05
		ex06
		ex07
		ex08
		.git
		.github
		.gitignore
	"

	git clone "$REPO_URL" "$REPO_PATH"

	test -z "$(nls "$REPO_PATH" $permited_files)"
}


test_ex00()
{
	local path="$REPO_PATH/ex00"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" z)"

	# valid file content
	diff "$path/z" "src/z.diff"
}


test_ex01()
{
	local path="$REPO_PATH/ex01"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" testShell00.tar)"
	
	# Mount environment
	mkdir "$path/src" &&
	tar -xf "$path/testShell00.tar" -C "$path/src"

	test -f "$(find "$path/src" \
		-type f \
		-perm 455 \
		-links 1 \
		-size 40c \
		-newermt "2025-06-01 23:42" ! -newermt "2025-06-01 23:43" \
		-name "testShell00"
	)"
}


test_ex02()
{
	local path="$REPO_PATH/ex02"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" exo2.tar)"

	# Mount environment
	mkdir "$path/src" &&
	tar -xf "$path/exo2.tar" -C "$path/src"

	# Find test0
	test -f "$(find "$path/src" \
		-type d \
		-perm 715 \
		-newermt "2025-06-01 20:47" ! -newermt "2025-06-01 20:48" \
		-name "test0"
	)"

	# Find test1
	test -f "$(find "$path/src" \
		-type f \
		-perm 714 \
		-links 1 \
		-size 4c \
		-newermt "2025-06-01 21:46" ! -newermt "2025-06-01 21:47" \
		-name "test1"
	)"

	# Find test2
	test -f "$(find "$path/src" \
		-type d \
		-perm 504 \
		-newermt "2025-06-01 22:45" ! -newermt "2025-06-01 22:46" \
		-name "test2"
	)"

	# Find test3
	test -f "$(find "$path/src" \
		-type f \
		-perm 404 \
		-links 2 \
		-size 1c \
		-newermt "2025-06-01 23:44" ! -newermt "2025-06-01 23:45" \
		-name "test3"
	)"

	# Find test4
	test -f "$(find "$path/src" \
		-type f \
		-perm 641 \
		-links 1 \
		-size 2c \
		-newermt "2025-06-01 23:43" ! -newermt "2025-06-01 23:44" \
		-name "test4"
	)"

	# Find test5
	test -f "$(find "$path/src" \
		-type f \
		-perm 404 \
		-links 2 \
		-size 1c \
		-newermt "2025-06-01 23:44" ! -newermt "2025-06-01 23:45" \
		-name "test5"
	)"

	# Find test6
	test -f "$(find "$path/src" \
		-type l \
		-size 5c \
		-newermt "2025-06-01 22:20" ! -newermt "2025-06-01 22:21" \
		-name "test6" \
		-lname "test0"
	)"
}

test_ex03()
{
	local path="$REPO_PATH/ex03"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" midLs)"

	mkdir "$path/src"
	mkdir "$path/src/dir1"
	mkdir "$path/src/dir2"
	mkdir "$path/src/dir3"
	mkdir "$path/src/.hidden_dir1"
	mkdir "$path/src/.hidden_dir2"
	mkdir "$path/src/.hidden_dir3"
	touch "$path/src/file1"
	touch "$path/src/file2"
	touch "$path/src/file3"
	touch "$path/src/.hidden_file1"
	touch "$path/src/.hidden_file2"
	touch "$path/src/.hidden_file3"

	test "$("$path/midLs" "$path/src")" = "file3, file2, file1, dir3/, dir2/, dir1/"
	
	touch "$path/src/dir3"
	touch "$path/src/file3"
	touch "$path/src/dir2"
	touch "$path/src/file2"
	touch "$path/src/dir1"
	touch "$path/src/file1"
	
	test "$("$path/midLs" "$path/src")" = "file1, dir1/, file2, dir2/, file3, dir3/"
}

test_ex04()
{
	local path="$REPO_PATH/ex04"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" "")"
}

test_ex05()
{
	local path="$REPO_PATH/ex05"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" "")"
}

test_ex06()
{
	local path="$REPO_PATH/ex06"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" "")"
}

test_ex07()
{
	local path="$REPO_PATH/ex07"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" "")"
}

test_ex08()
{
	local path="$REPO_PATH/ex08"

	# Required directory
	test -d "$path"

	# Required file
	test -z "$(nls "$path" "")"
}


# =======================================
# MAIN SCRIPT
# =======================================

[ -d "$REPO_PATH" ] && rm -rf "$REPO_PATH"

box_header "Shell 00"

assert test_repository "'$NAME' repository existence"

if [ "$CHECK" != FAIL ]; then
	assert test_ex00 "Exercise 00: Z"
fi

if [ "$CHECK" != FAIL ]; then
	assert test_ex01 "Exercise 01: testShell00"
fi

if [ "$CHECK" != FAIL ]; then
	assert test_ex02 "Exercise 02: Sim, de novo..."
fi

str_status "Shell 00 result" $CHECK

log_msg

rm -rf "$REPO_PATH"
log_clean

exit 0
