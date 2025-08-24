; functions


write:
	; arg 1 = rsi buffer
	; arg 2 = rdx buffer size
	push rax
	push rdi
	mov rax, 1
	mov rdi, 1
	syscall
	pop rdi
	pop rax
	ret


reset_file_ptr:
	; arg 1 = rdi file_ptr
	push rax
	push rsi
	push rdx
	mov rax, 8
	mov rsi, 0
	mov rdx, 0
	syscall
	pop rdx
	pop rsi
	pop rax
	ret


get_string_length:
	; arg 1 = rdi string_ptr
	; rcx is overwritten
	push rax
	xor rax, rax
	mov rcx, -1
	cld ; set DF to 0 == UP -> increments rdi
	repne scasb
	not rcx
	pop rax

return:
	ret


; exit statements


exit_no_file:
	lea rsi, [no_file]
	mov rdx, no_file_len
	call write
	jmp exit

exit_bad_file:
	lea rsi, [bad_file]
	mov rdx, bad_file_len
	call write
	jmp exit

exit_read_fail:
	lea rsi, [read_fail]
	mov rdx, read_fail_len
	call write
	jmp exit

exit_empty_file:
	lea rsi, [empty_file]
	mov rdx, empty_file_len
	call write
	jmp exit

exit_size_fail:
	lea rsi, [size_file]
	mov rdx, size_file_len
	call write
	jmp exit

argc_fail:
	lea rsi, [argc_wrong]
	mov rdx, argc_wrong_len
	call write
	jmp exit

something_else:
	lea rsi, [undefined]
	mov rdx, undefined_len
	call write

exit:
	mov rax, 60
	xor rdi, rdi
	syscall


endless_loop:
	jmp endless_loop


; data


section .bss
	file_pointer resq 1
	file_size resq 1
	delimiter_pointer resq 1
	pokke_buffer_pointer resq 1
	file_buffer_pointer1 resq 1
	file_buffer_pointer2 resq 1
	save_pointer resq 1
	pokke_count resq 1
	string_position resq 1
	argv_pointer resq 1

section .data
	intermediate_file_buffer_size equ 1

	no_file db "Specify a file as the first argument.", 10
	no_file_len equ $ - no_file

	bad_file db "Couldn't open the file.", 10
	bad_file_len equ $ - bad_file

	read_fail db "Couldn't read the file.", 10
	read_fail_len equ $ - read_fail

	empty_file db "The specified file is empty.", 10
	empty_file_len equ $ - empty_file

	size_file db "Something went wrong getting the file size.", 10
	size_file_len equ $ - size_file

	undefined db "Undefined error", 10
	undefined_len equ $ - undefined

	argc_wrong db "Please specify an input file and delimiters.", 10
	argc_wrong_len equ $ - argc_wrong

	delimiters db 32,10,9,0
