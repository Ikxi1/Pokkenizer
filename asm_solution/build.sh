#!/bin/sh
set -e

cd source

OUT="pokkenizer"

asm_files=$(find . -type f -name '*.asm' ! -path '.*/ignore/*')

for src in $asm_files; do
    obj="${src%.asm}.o"
    echo "Assembling $src -> $obj"
    nasm -g -f elf64 "$src" -o "$obj"
done

obj_files=$(echo "$asm_files" | sed 's/\.asm$/.o/')

echo "Linking -> $OUT"
gcc -O1 -no-pie -o "$OUT" $obj_files

cd ..