; 1st argument rdi = *string
; 2nd argument rsi = *delimiters
; 3rd argument rdx = **save_ptr
strtok_r:
        mov     r12, rdx
        push    rbp
        push    rbx
        test    rdi, rdi
        je      .L10
.L2:
        cmp     BYTE PTR [rbx], 0
        je      .L8
        mov     rdi, rbx
        mov     QWORD PTR [rsp+8], rsi
        call    strspn
        lea     rbp, [rbx+rax]
        cmp     BYTE PTR [rbp+0], 0
        je      .L5
        mov     rsi, QWORD PTR [rsp+8]
        mov     rdi, rbp
        call    strcspn
        lea     rbx, [rbp+0+rax]
        cmp     BYTE PTR [rbx], 0
        je      .L3
        mov     BYTE PTR [rbx], 0
        add     rbx, 1
.L3:
        mov     QWORD PTR [r12], rbx
        add     rsp, 16
        mov     rax, rbp
        pop     rbx
        pop     rbp
        pop     r12
        ret
.L5:
        mov     rbx, rbp
.L8:
        mov     QWORD PTR [r12], rbx
        xor     ebp, ebp
        add     rsp, 16
        mov     rax, rbp
        pop     rbx
        pop     rbp
        pop     r12
        ret
.L10:
        mov     rbx, QWORD PTR [rdx]
        jmp     .L2