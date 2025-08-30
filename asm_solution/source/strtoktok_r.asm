; arg 1 = rdi char *string
; arg 2 = rsi char *delimiters
; arg 3 = rdx char **save_ptr
; arg 4 = rcx char *token_buffer

section .text

global strtoktok_r

extern strspn
extern strcspn
extern memcpy

strtoktok_r:
	cmp rdi, 0
	jne .l1
	mov rdi, qword [rdx]
.l1:
	cmp byte [rdi], 0
	jne .l2
	mov rax, 0
	ret
.l2:
	mov [string], qword rdi
	mov [delimiters], qword rsi
	mov [save_pointer], qword rdx
	mov [token_buffer], qword rcx
	call strspn ; rdi string rsi delimiters
	cmp rax, 0
	je .l4
	mov r8, qword [string_position]
.l3:
	mov al, byte [rdi]
	mov rcx, qword [token_buffer]
	mov [rcx + r8], al
	inc r8
	mov byte [rcx + r8], 0
	inc r8
	inc rdi
	mov rsi, qword [delimiters]
	call strspn
	cmp rax, 0
	jne .l3
	mov [string_position], qword r8
	mov [string], qword rdi
.l4:
	cmp byte [rdi], 0
	jne .l5
	mov rax, 0
	ret
.l5:
	mov rsi, qword [delimiters]
	call strcspn
	mov rdi, qword [token_buffer]
	add rdi, qword [string_position]
	mov rsi, qword [string]
	mov rdx, rax
	call memcpy
.l6:
	add [string], qword rdx
	add [string_position], qword rdx
	mov rdi, qword [token_buffer]
	add rdi, qword [string_position]
	mov byte [rdi], 0
	inc qword [string_position]
	mov rdi, qword [string]
	cmp byte [rdi], 0
	jne .l7
	mov rax, 0
	ret
.l7:
	mov rsi, qword [delimiters]
	call strspn
	cmp rax, 0
	je .l9
	mov r8, qword [string_position]
.l8:
	mov al, byte [rdi]
	mov rcx, qword [token_buffer]
	mov byte [rcx + r8], al
	inc r8
	mov byte [rcx + r8], 0
	inc r8
	inc rdi
	mov rsi, qword [delimiters]
	call strspn
	cmp rax, 0
	jne .l8
	mov [string_position], qword r8
	mov [string], qword rdi
.l9:
	cmp byte [rdi], 0
	jne .l10
	mov rax, 0
	ret
.l10:
	mov [save_pointer], rdi
	mov rax, rdi
	ret


section .bss
	string_position resq 1
	string resq 1
	delimiters resq 1
	token_buffer resq 1
	save_pointer resq 1