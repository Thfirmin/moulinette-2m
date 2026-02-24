#!/usr/bin/env bash

directories=$(find . -mindepth 1 -maxdepth 1 -type d)

for directory in $directories; do
	if [ -f "$directory/trace.sh" ]; then
		$directory/trace.sh
	fi
done
