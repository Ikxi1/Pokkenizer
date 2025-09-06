## Compile

`./build.sh`


## Running

`./pokkenizer input.txt $'abcdef\n\t\\'`\
Use the `$''` otherwise it will be passed wrong.


## Header file

If you want to use this in another C or C++ program, then you need:
- pokkenizer.h
- pokkenizer.asm
- strtoktok_r.asm
- common.inc

You will need to assemble the asm files with NASM to object files:\
`nasm -felf64 pokkenizer.asm -o pokkenizer.o`\
(Check build.sh to see how to do it more quickly)

And then you need to link with GCC, like you would any other header file.\
(Or any other linker)