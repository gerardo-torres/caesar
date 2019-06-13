section .data

input_msg: dq "Please enter plaintext: "
input_msg_end:  
input_msg_len equ input_msg_end - input_msg

offset_msg: dq "Please enter offset: "
offset_msg_end: 
offset_msg_len equ offset_msg_end - offset_msg

output: dd "Ciphertext: "
output_end: 
output_len equ output_end - output

newline: dd `\n`

section .bss
offset: resb 3
plaintext: resb 1000
ciphertext: resb 1000    

section .text
global _start

_start:

_write_input_msg:                   ; Write input message
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_msg_len
    int 80h                 

_read_plaintext:                    ; Read plaintext
    mov eax, 3
    mov ebx, 0
    mov ecx, plaintext
    mov edx, 1000
    int 80h

_write_offset_msg:                  ; Write offset message
    mov eax, 4
    mov ebx, 1
    mov ecx, offset_msg
    mov edx, offset_msg_len
    int 80h           

_read_offset:                       ; Read and store number
    mov eax, 3              
    mov ebx, 0
    mov ecx, offset
    mov edx, 3
    int 80h
    mov edx, offset
    mov ebx, 1

_find_offset_size:                  ; Find the size and true value of the offset
    mov bl, [offset + 1]
    cmp byte bl, 00
    je _find_text_size_pre
    xor ebx, ebx
    
    mov bl, [offset]
    mov al, [offset + 1]
    xor cl, cl
    _add_ten_loop:
        add al, 0b1010
        inc cl
        cmp cl, bl
        jne _add_ten_loop

_find_text_size_pre:
    xor ebx, ebx
_find_text_size:                    ; Find the size of the plain text
    cmp byte [plaintext + ebx], 00
    jne _not_null
    xor ecx, ecx
    jmp _encrypt                   ; If char is null, encrypt string

    _not_null:
        inc ebx
        jmp _find_text_size
    
_encrypt:                           ; Ecrypt plaintext
    ; ecx = 0, ebx = length
    ; eax = curr char, edx = offset
    cmp ecx, ebx                    ; Compare ecx with the length of the string
    jne _encrypt_loop
    inc ecx
    mov byte [ciphertext + ecx], 00
    jmp _write_ciphertext

    _encrypt_loop:
        mov al, [plaintext + ecx]   ; al holds current character
        cmp al, ' '
        jne _alpha
        mov [ciphertext + ecx], eax
        inc ecx
        jmp _encrypt

    _alpha:
        add al, [edx]               ; Add offset to current character
        sub al, '0'
        cmp al, 'z'
        jg _above_alpha
        mov [ciphertext + ecx], eax
        inc ecx
        jmp _encrypt

    _above_alpha:
        sub al, 26
        mov [ciphertext + ecx], eax
        inc ecx
        jmp _encrypt

_write_ciphertext:
    mov eax, 4
    mov ecx, ciphertext
    mov edx, ebx
    mov ebx, 1
    int 80h 

_write_new_line:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h 

_end:
    mov eax, 1
    mov ebx, 0
    int 80h
