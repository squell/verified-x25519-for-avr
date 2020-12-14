#! /bin/sh

# rudimentary code extraction, just for demonstration purposes; doesnt handle the macros used in fe25518_* yet

# usage: extract_code.sh file.mlw

why3 -L . -L .. extract -D extract/asm.drv -o /tmp "$1"
sed 's/^$/;/' "/tmp/${1%.mlw}__AVRcode.ml" | tr -d '\n' | tr ';' '\n' | sed -f extract/unmangle.sed
