#!/usr/bin/env bash

cd $(dirname -- "$0")

source "../tools/binutils.sh"

import "../tools/box.sh"

box_header "Eu Aceito"

cat trace.log
