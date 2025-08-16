%include "common.inc"
section .text
global main
; extern strtok_r

main:
open_file:
    cmp rdi, 2
    jl exit_no_file
    mov rax, 2
    mov rdi, [rsi + 8]
    test rdi, rdi
    js exit_no_file
    cmp rdi, 0
    jz exit_no_file
    mov rsi, 0
    mov rdx, 0
    syscall
    test rax, rax
    js exit_bad_file
    mov r8, rax
get_file_size:
    ; lseek syscall == fseek in c
    mov rax, 8
    mov rdi, r8
    mov rsi, 0
    mov rdx, 2
    syscall
    test rax, rax
    js exit_size_fail
    mov qword [file_size], rax
    mov rsi, rax
allocate_file_buffer:
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    xor r9, r9
    syscall
    mov qword [file_buffer_pointer], rax
copy_file:
    xor rax, rax
    mov rdi, r8
    lea rsi, [file_buffer_pointer]
    mov rdx, file_size
    syscall
    test rax, rax
    js exit_read_fail
close_file:
    mov rax, 3
    syscall
    test rax, rax
    js something_else
; token:
;     mov rdi, file_buffer_pointer
;     mov rsi, delimiters
;     mov rdx,
;     call strtok_r


    jmp exit
