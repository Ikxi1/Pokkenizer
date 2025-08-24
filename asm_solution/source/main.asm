%include "common.inc"
section .text
global main
extern strtok_r
extern ascii_to_bytes

main:
open_file:
    cmp rdi, 4
    jne argc_fail
    mov rax, qword [rsi + 16]
    mov [delimiter_pointer1], qword rax
    mov rax, qword [rsi + 24]
    mov [delimiter_pointer2], qword rax
    mov rax, 2
    mov rdi, qword [rsi + 8]
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
get_file_size:
    ; lseek syscall == fseek in c
    mov rax, 8
    mov rdi, qword [file_pointer]
    mov rsi, 0
    mov rdx, 2
    syscall
    test rax, rax
    js exit_size_fail
    mov rsi, rax
    clc
    shl rax, 1
    jc file_too_big
    mov [file_size], qword rsi
    call reset_file_ptr
allocate_file_buffer:
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 0x22
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov qword [file_buffer_pointer], rax
copy_file:
    xor rax, rax
    mov rdi, qword [file_pointer]
    mov rdx, rsi
    mov rsi, qword [file_buffer_pointer]
    syscall
    test rax, rax
    js exit_read_fail
    call reset_file_ptr
close_file:
    mov rax, 3
    syscall
    test rax, rax
    js something_else
allocate_pokke_buffer:
    ; multiply filesize x2 for worst case scenario
    clc
    shl rdx, 1
    jc file_too_big
    mov rsi, rdx
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 0x22
    xor r9, r9
    xor r8, r8
    syscall
    test rax, rax
    js something_else
    mov [pokke_buffer_pointer], qword rax

pokkenize:
    mov rdi, qword [file_buffer_pointer]
    mov rsi, [delimiter_pointer1]
    mov rdx, save_pointer
    call strtok_r
    mov r10, [save_pointer]
    ; tokenize the token
pokkenize_pokkenize:
    mov rsi, [delimiter_pointer2]
    mov rdx, save_pointer
    call strtok_r
    mov r11, [save_pointer]
write_pokke_buffer:
    call get_string_length
    mov [string_position], qword rcx
    mov r8, qword [pokke_buffer_pointer]
    mov r9, r8
    add r9, rcx
write_pokke_buffer_loop:
    mov dl, byte [rax]
    mov [r8], byte dl
    inc rax
    inc r8
    cmp r8, r9
    jl write_pokke_buffer_loop
    mov rdi, qword [save_pointer]
    xor rsi, rsi
    movzx rdi, byte [rdi]
    cmp rsi, rdi
    jne pokkenize_pokkenize_loop
    inc qword [save_pointer]

pokkenize_loop:
    mov rdi, 0
    mov rsi, [delimiter_pointer1]
    mov rdx, save_pointer
    call strtok_r
    test rax, rax
    js something_else
    cmp rax, 0
    je write_tokens
    mov r10, [save_pointer]
pokkenize_pokkenize2:
    mov rsi, [delimiter_pointer2]
    mov rdx, save_pointer
    call strtok_r

write_pokke_buffer2:
    call get_string_length
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
    mov rdi, qword [save_pointer]
    xor rsi, rsi
    movzx rdi, byte [rdi]
    cmp rsi, rdi
    jne pokkenize_pokkenize_loop2
    inc qword [save_pointer]
    jmp pokkenize_loop

pokkenize_pokkenize_loop:
    mov rdi, 0
    mov rsi, [delimiter_pointer2]
    mov rdx, save_pointer
    call strtok_r
    jmp write_pokke_buffer

pokkenize_pokkenize_loop2:
    mov rdi, 0
    mov rsi, [delimiter_pointer2]
    mov rdx, save_pointer
    call strtok_r
    jmp write_pokke_buffer2

write_tokens:
    mov rsi, qword [pokke_buffer_pointer]
    mov rdx, qword [string_position]
    call write

    jmp exit
