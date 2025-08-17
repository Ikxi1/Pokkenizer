%include "common.inc"
section .text
global main
extern strtok_r

main:
open_file:
    mov rax, 2
    mov rdi, [rsi + 8]
    ; mov rdi, [rsp + 16]
    test rdi, rdi
    js exit_no_file
    cmp rdi, 0
    jz exit_no_file
    mov rsi, 0
    mov rdx, 0
    syscall
    test rax, rax
    js exit_bad_file
    mov r11, rax
    mov qword [file_pointer], rax
get_file_size:
    ; lseek syscall == fseek in c
    mov rax, 8
    mov rdi, r11
    mov rsi, 0
    mov rdx, 2
    syscall
    test rax, rax
    js exit_size_fail
    mov qword [file_size], rax
    mov r11, rax
    call reset_file_ptr
allocate_file_buffer1:
    mov rax, 9
    xor rdi, rdi
    mov rsi, [file_size]
    mov rdx, 3
    mov r10, 0x21
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov qword [file_buffer_pointer1], rax
allocate_file_buffer2:
    mov rax, 9
    xor rdi, rdi
    mov rsi, [file_size]
    mov rdx, 3
    mov r10, 0x21
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov qword [file_buffer_pointer2], rax
copy_file1:
    xor rax, rax
    mov rdi, [file_pointer]
    mov rsi, [file_buffer_pointer1]
    mov rdx, [file_size]
    syscall
    test rax, rax
    js exit_read_fail
    call reset_file_ptr
copy_file2:
    xor rax, rax
    mov rsi, [file_buffer_pointer2]
    mov rdx, [file_size]
    syscall
    test rax, rax
    js exit_read_fail
close_file:
    mov rax, 3
    syscall
    test rax, rax
    js something_else
count_tokens:
    mov rdi, [file_buffer_pointer1]
    mov rsi, delimiters
    mov rdx, save_pointer
    call strtok_r
    mov qword [token_count], 1
count_tokens_loop:
    mov rdi, 0
    mov rsi, delimiters
    mov rdx, save_pointer
    call strtok_r
    test rax, rax
    js something_else
    cmp rax, 0
    je count_tokens_finished
    inc qword [token_count]
    jmp count_tokens_loop

count_tokens_finished:


    jmp exit
;three more tokens