#!/usr/bin/env bash

source "$1/string.sh"

box_title()
{
    local title="$1"

    str_line -b "<" -e ">" "="
    str_center "$title"
    str_line -b "<" -e ">" "="
}

box_header()
{
    local title="$1"

    echo
    str_line -b "┌" -e "┐" "-"
	str_center "$(str -be 36 "${title}")"
    str_line -b "└" -e "┘" "-"
}
