#!/usr/bin/env bash

# ==============================
# TEXT EFFECTS
# ==============================

RESET="\033[0m"
BOLD="\033[1m"
DARK="\033[2m"
ITALIC="\033[3m"
UNDER="\033[4m"
TWINKLE="\033[5m"
REVERSE="\033[7m"
CENSURE="\033[8m"
STRIKE="\033[9m"

# ==============================
# FOREGROUND COLORS
# ==============================

FG_BLACK="\033[30m"
FG_RED="\033[31m"
FG_GREEN="\033[32m"
FG_YELLOW="\033[33m"
FG_BLUE="\033[34m"
FG_MAGENTA="\033[35m"
FG_CYAN="\033[36m"
FG_WHITE="\033[37m"

FG_BBLACK="\033[90m"
FG_BRED="\033[91m"
FG_BGREEN="\033[92m"
FG_BYELLOW="\033[93m"
FG_BBLUE="\033[94m"
FG_BMAGENTA="\033[95m"
FG_BCYAN="\033[96m"
FG_BWHITE="\033[97m"

# ==============================
# BACKGROUND COLORS
# ==============================

BG_BLACK="\033[40m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"
BG_WHITE="\033[47m"

BG_BBLACK="\033[100m"
BG_BRED="\033[101m"
BG_BGREEN="\033[102m"
BG_BYELLOW="\033[103m"
BG_BBLUE="\033[104m"
BG_BMAGENTA="\033[105m"
BG_BCYAN="\033[106m"
BG_BWHITE="\033[107m"

# ==============================
# TERMINAL WIDTH
# ==============================

TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
TERM_HEIGHT=$(tput lines 2>/dev/null || echo 80)

# ==============================
# HELPS
# ==============================

STRING_HELP=$(cat << EOF
string.sh - lib of string utils bash functions

FUNCTIONS:
	str_help - lib internal functions help
	str_error - error message displayer
	str_center - align string to center of terminal
	str_line - format and print lines
	str_status - format and print status line
EOF
)

STR_HELP=$(cat << EOF
string::str_help() - lib internal functions help
EOF
)

STR_ERROR_HELP=$(cat << EOF
string::str_error() - error message displayer
EOF
)

STR_CENTER_HELP=$(cat << EOF
string::str_center() - align string to center of terminal
EOF
)

STR_LINE_HELP=$(cat << EOF
string::str_line() - format and print lines
EOF
)

STR_STATUS_HELP=$(cat << EOF
string::str_status() - format and print status line

USAGE:
	str_status -h
	str_status [-l] [-p] [-s] [-P] [-S] <label> <[OK|FAIL|WARN|----]>

FLAGS
	-l, --label: set label line
	-p, --pad: set padding between label and status
	-s, --status: set status (OK, FAIL, WARN, ----)
	-P, --prefix: set line prefix
	-S, --suffix: set line suffix

EOF
)

# ==============================
# FUNCTIONS
# ==============================

str_help()
{

	if [ -z "$1" ]; then
		echo "$STRING_HELP"
		return 0
	fi
	case "$1" in
		str_error)
			echo "$STR_ERROR_HELP"
			;;
		str_center)
			echo "$STR_CENTER_HELP"
			;;
		str_line)
			echo "$STR_LINE_HELP"
			;;
		str_status)
			echo "$STR_STATUS_HELP"
			;;
		str)
			echo "$STR_HELP"
			;;
		*)
			str_error "Function not implemented"
			return 1
			;;
	esac
}


str_error()
{
	local opts
	local mode=echo

	opts=$(getopt \
		-o pe \
		--long printf,echo \
		-- "$@"
	)

	eval set -- "$opts"

	while true; do
		case "$1" in
			-e|--echo)
				mode=echo
				shift
				;;
			-p|--printf)
				mode=printf
				shift
				;;
			--)
				shift
				break
				;;
		esac
	done

	if [ "$mode" = echo ]; then
		echo $@ > /dev/stderr
	else
		printf $@ > /dev/stderr
	fi
}


str_center()
{
    local text="$1"
    local clean_text
	
	# remove ANSI for width calc
    clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g') 
    local padding=$(( (TERM_WIDTH - ${#clean_text}) / 2 ))
    printf "%*s%b\n" "$padding" "" "$text"
}


str_line()
{
	local opts
	local boxb
	local boxe

	opts=$(getopt \
		-o b:e: \
		--long box:,end: \
		-- "$@" \
	)

	eval set -- "$opts"

	while true; do
		case "$1" in
			-b|--box)
				boxb="$2"
				shift 2
				;;
			-e|--end)
				boxe="$2"
				shift 2
				;;
			--)
				shift
				break
				;;
		esac
	done
	
	boxb="${boxb:-$1}"
	boxe="${boxe:-$1}"

    local char="$1"
	if [ -z "$boxb" ]; then
		printf "%*s" "$TERM_WIDTH" "" | tr ' ' "$char"
	else
    	printf "%s%*s%s\n" "$boxb" $((TERM_WIDTH-2)) "" "$boxe" | tr ' ' "$char"
	fi
}


str_status()
{
	local opts
	local label
	local pad=40
	local status
	local prefix
	local suffix

	opts=$(getopt \
		-o l:p:s:P:S: \
		--long label:,pad:,status:,prefix:,suffix: \
		-- "$@"
	)

	eval set -- "$opts"

	while true; do
		case "$1" in
			-l|--label)
				label="$2"
				shift 2
				;;
			-p|--pad)
				pad=$(($2))
				shift 2
				;;
			-s|--status)
				status="$2"
				shift 2
				;;
			-P|--prefix)
				prefix="$2"
				shift 2
				;;
			-S|--suffix)
				suffix="$2"
				shift 2
				;;
			--)
				shift
				break
				;;
		esac
	done

	[ -n "$1" ] && label="$1" && shift
	[ -n "$1" ] && status="$1" && shift

	case "$status" in
		OK)
			status_text=$(str -e 32 "[OK]")
			;;
		FAIL)
			status_text=$(str -e 31 "[FAIL]")
			;;
		WARN)
			status_text=$(str -e 33 "[WARN]")
			;;
		*)
			status_text="[----]"
			;;
	esac

	printf "%s%-*s%b%s\n" "$prefix" "$pad" "$label" "$status_text" "$suffix"
}


str()
{
	local opts
	local effx=""
	local reset=""

	opts=$(getopt \
		-o bcdirstue: \
		--long bold,censure,dark,italic,reverse,strike,twinkle,under,effect \
		-- "$@"
	)

	eval set -- "$opts"

	while true; do
		case "$1" in
			-b|--bold)
				effx+=";1"
				shift
				;;
			-c|--censure)
				effx+=";8"
				shift
				;;
			-d|--dark)
				effx+=";2"
				shift
				;;
			-i|--italic)
				effx+=";3"
				shift
				;;
			-r|--reverse)
				effx+=";7"
				shift
				;;
			-s|--strike)
				effx+=";9"
				shift
				;;
			-t|--twinkle)
				effx+=";5"
				shift
				;;
			-u|--under)
				effx+=";4"
				shift
				;;
			-e|--effect)
				effx+=";$2"
				shift 2
				;;
			--)
				shift
				break
				;;
		esac
	done

	if [[ -n "$effx" ]]; then
		effx="\033[${effx:1}m"
		reset="\033[0m"
	else
		effx=""
	fi

	printf "%s%s%s" "$effx" "$1" "$reset"
}

