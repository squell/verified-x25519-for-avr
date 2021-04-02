#! /bin/sh

# rudimentary code extraction, just for demonstration purposes --- doesnt handle fe25519_mul121666 because it has a while loop
# to make this better a proper OCaml-syntax -> assembly-syntax translator would need to be written

# usage: extract_code.sh file.mlw

why3 -L . -L .. extract -D extract/asm.drv -o /tmp "$1"
sed 's/^$/;/' "/tmp/${1%.mlw}__AVRcode.ml" | tr -d '\n' | tr ';' '\n' | (sed -f extract/unmangle.sed; echo LASTDEF) | m4 | sed 's/^ \+/  /'
