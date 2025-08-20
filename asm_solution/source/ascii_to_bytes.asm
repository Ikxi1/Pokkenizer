; arg 1 = rdi string_ptr

global ascii_to_bytes

ascii_to_bytes:
	xor rax, rax
    mov al, byte [rdi]
    cmp al, 0
    jle .error
    cmp al, 0x7f
    ja .error

    cmp al, "\"
    jne .normal

    ; escape handling
    mov al, byte [rdi+1]
    cmp al, "n"
    je .esc_n
    cmp al, "t"
    je .esc_t
    cmp al, "v"
    je .esc_v
    cmp al, "r"
    je .esc_r
    cmp al, "0"
    je .esc_0
    cmp al, "\"
    je .esc_backslash
    cmp al, "'"
    je .esc_single
    cmp al, '"'
    je .esc_double
    cmp al, "f"
    je .esc_f
    jmp .error

.esc_n:
	mov eax, 0x0a ; \n
	ret
.esc_t:
	mov eax, 0x09 ; tab \t
	ret
.esc_v:
    mov eax, 0x0a ; vertical tab \v
    ret
.esc_r:
	mov eax, 0x0d ; carriage return \r
	ret
.esc_0:
	xor eax, eax ; 0
	ret
.esc_backslash:
	mov eax, "\"
	ret
.esc_single:
	mov eax, "'"
	ret
.esc_double:
	mov eax, '"'
	ret
.esc_f:
    mov eax, 0x0c
    ret

.normal:
    movzx eax, byte [rdi]
    ret

.error:
    mov rax, -1
    ret