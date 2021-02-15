.model small

.stack 64

.data
    str db "AAAA$$3$9999", "$"
    str1 db "Characters: "
    var1 db 00h
    str2 db 10,13,"Numbers: "
    var2 db 00h 
    str3 db 10,13,"Symbols: "
    var3 db 00h
    str4 db "$"
.code 
;number stored in dh
;symbols in dl
;characters in bx
    main proc
    mov ax, @data
    mov cx, 12
    mov ds, ax
    mov ax, 00h
    mov dx, 00h
    lea si, str
    mov bh, 00h
    ok: mov ah, [si]
        cmp ah, 041h  ; A
        JAE pass1
        cmp ah, 30h    ; comparing with 1
        JAE pass
        add dl, 1     ; less so a different character
        dec cx        ; 
        jz end
        inc si
        jmp ok
    pass: cmp ah,  39h ;compare with 9
          JA pass1
          add dh, 1
          inc si
          jmp lp
    pass1: cmp ah, 05ah  ; Z
           JLE pass2
           cmp ah, 61h    ; a
           JAE pass4      ; greater chha bhane could be between a-z
           add dl,1       ; less chha bhane could be numbers
           dec cx
            jz end
            inc si
            jmp ok
    pass2: add bh, 1
            inc si
            jmp lp
    pass4: cmp ah, 07ah    ; z
            JLE pass5      ; less chha bhane pass5
    pass5: add bh, 1
            inc si
           lp:loop ok
           add bh, 030h
           mov var1, bh
           mov ch, dh
           mov cl, dl
           add ch, 30h
           add cl, 30h
           mov var2, ch
           mov var3, cl
           
           lea dx, str1 
           mov ah, 09h
           int 21h 
      end:main endp
