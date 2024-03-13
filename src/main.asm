org 0x7c00
bits 16

%define endl 0x0d, 0x0a, 0

start:
	jmp main

printr:
	push si
	push ax

	lodsb
	mov ah, 0x0e
	mov bh, 0
	int 0x10

	pop si
	pop ax

	ret

print:
	;save the contents of the registers in the stack
	;we will be changing the values of the registers
	push si
	push ax

.loop:
	lodsb ;loads the next character in ds to al
	;or al, al ;doesn't change the value stored in al, sets the flags of the register
	cmp al, 0 ;same as previous 
	je .done

	;display the character
	mov ah, 0x0e
	mov bh, 0
	int 0x10

	jmp .loop

.done:
	;retore the values of ax and si
	pop ax
	pop si
	ret 

main:

	;initialise the segments to 0
	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00

	;move the string to the si register
	mov si, string
	
	push ax
	mov ax, 10

.mainloop:
	call print
	cmp ax, 0
	dec ax
	jg .mainloop

	pop ax

    hlt

string: db "Hello world", endl

.halt:
    jmp .halt

times 510 - ($-$$) db 0
dw 0xaa55

