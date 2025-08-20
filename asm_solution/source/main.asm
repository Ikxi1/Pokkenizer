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
    mov qword [file_pointer], rax
    call get_delimiters
get_file_size:
    ; lseek syscall == fseek in c
    mov rax, 8
    mov rdi, [file_pointer]
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
    mov rsi, qword [file_size]
    mov rdx, 3
    mov r10, 0x22
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov qword [file_buffer_pointer1], rax
allocate_file_buffer2:
    mov rax, 9
    xor rdi, rdi
    mov rsi, qword [file_size]
    mov rdx, 3
    mov r10, 0x22
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov qword [file_buffer_pointer2], rax
copy_file1:
    xor rax, rax
    mov rdi, qword [file_pointer]
    mov rsi, qword [file_buffer_pointer1]
    mov rdx, qword [file_size]
    syscall
    test rax, rax
    js exit_read_fail
    call reset_file_ptr
copy_file2:
    xor rax, rax
    mov rsi, qword [file_buffer_pointer2]
    mov rdx, qword [file_size]
    syscall
    test rax, rax
    js exit_read_fail
close_file:
    mov rax, 3
    syscall
    test rax, rax
    js something_else
count_pokkes:
    mov rdi, qword [file_buffer_pointer1]
    mov rsi, delimiters
    mov rdx, save_pointer
    call strtok_r
    mov qword [pokke_count], 1
count_pokkes_loop:
    mov rdi, 0
    mov rsi, delimiters
    mov rdx, save_pointer
    call strtok_r
    test rax, rax
    js something_else
    cmp rax, 0
    je allocate_pokke_buffer
    inc qword [pokke_count]
    jmp count_pokkes_loop
allocate_pokke_buffer:
    mov rax, 9
    xor rdi, rdi
    mov rsi, qword [file_size]
    add rsi, qword [pokke_count]
    mov rdx, 3
    mov r10, 0x22
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov qword [pokke_buffer_pointer], rax

pokkenize:
    mov rdi, qword [file_buffer_pointer2]
    mov rsi, delimiters
    mov rdx, save_pointer
    call strtok_r
write_pokke_buffer:
    mov rdi, rax
    call get_string_length ; length in rcx
    mov qword [string_position], rcx
    mov r8, [pokke_buffer_pointer]
    mov r9, r8
    add r9, rcx
write_pokke_buffer_loop:
    mov dl, byte [rax]
    mov [r8], byte dl
    inc rax
    inc r8
    cmp r8, r9
    jl write_pokke_buffer_loop
    ; mov rsi, pokke_buffer_pointer
    ; mov rdx, rcx
    ; call write
pokkenize_loop:
    mov rdi, 0
    mov rsi, delimiters
    mov rdx, save_pointer
    call strtok_r
    test rax, rax
    js something_else
    cmp rax, 0
    je what
write_pokke_buffer2:
    ; mov rdi, rax ; not needed, strtok_r does it
    call get_string_length ; length in rcx
    mov r8, qword [pokke_buffer_pointer]
    add r8, qword [string_position]
    mov r9, r8
    add r9, rcx
write_pokke_buffer_loop2:
    mov dl, byte [rax]
    mov [r8], byte dl
    inc rax
    inc r8
    cmp r8, r9
    jl write_pokke_buffer_loop2
    add [string_position], qword rcx
    jmp pokkenize_loop
what:
    mov rsi, [pokke_buffer_pointer]
    mov rdx, [string_position]
    call write


    jmp exit


get_delimiters:
    ; expects a string_ptr at rsi + 16
    mov rdi, [rsi + 16]
    ret