.section .data
	formatscanf: .asciz "%[^\n]s" #fara spatiu, formatstring are spatiu pt operatii ca sa nu fac manual
   	formatstring: .asciz "%s "
   	formatchar: .asciz "%c "
	formatlong: .asciz "%d "
	oplet: .asciz "let"
	opadd: .asciz "add"
	opsub: .asciz "sub"
	opdiv: .asciz "div"
	opmul: .asciz "mul"
	array: .long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 #maxim 26 pt ca sunt litere
	nl: .asciz "\n"

.section .bss
    .lcomm str, 101

.section .text
.globl main
    main:
    	push $0x0
    	push $0x2
    	push $0x0
    	push stdout
    	call setvbuf
    	addl $16, %esp
    	pushl $str
		pushl $formatscanf
		call scanf
		addl $8, %esp
		mov $str, %eax
		
	loop1:
		and $0, %ecx
		movb (%eax), %cl
		cmp $0, %cl
		jle endloop1
		cmp $57, %cl
		jle numar0
		jg caracter
		
	caracter:
		movb 1(%eax), %bl
		cmp $32, %bl # ' '
		je variabila
		addl $4, %eax #daca nu e variabila atunci urmatoarea "instructiune" va fi peste 3 caractere + spatiu = 4
		cmp $97, %cl
		je addstack
		cmp $97, %cl
		je addstack
		cmp $100, %cl
		je divstack
		cmp $108, %cl
		je letstack
		cmp $109, %cl
		je mulstack
		cmp $115, %cl
		je substack
	variabila:
		addl $1, %eax
		movl %ecx, %esi #practic cl
		movl array(,%esi,4), %edx
		cmp $0, %edx
		je newvar
		jmp oldvar
	
	newvar:
		imul $-1, %ecx
		pushl %ecx
		jmp loop1
		
	oldvar:
		movl %ecx, %esi
		movl array(,%esi,4), %ecx
		pushl %ecx
		jmp loop1
		
	letstack:
		popl %ebx
		popl %edx
		imul $-1, %ebx #variabilele asa se vor coda. a = 0, b = -1, c = -2, etc. asa ca pentru a ajunge pe pozitia lor in array schimbam semnul
		movl %ebx, %esi
		movl %edx, array(,%esi,4)
		jmp loop1
	numar0:
		and $0, %ecx	
	numar:
		imull $10, %ecx	
		and $0, %edx
		addb (%eax), %dl
		sub $48, %edx
		addl %edx, %ecx
		addl $1, %eax
		movb (%eax), %bl
		cmp $32, %bl
		jne numar
		pushl %ecx
		addl $1, %eax
		jmp loop1
		
    addstack:
    	popl %ebx
    	popl %edx
    	addl %ebx, %edx
    	pushl %edx
    	jmp loop1
    
    mulstack:
    	movl %eax, %ebx
    	popl %eax
    	popl %ecx
    	imull %ecx #numerele sunt mici, cl = ecx
    	pushl %eax
    	movl %ebx, %eax
    	jmp loop1
    substack:
    	popl %ebx
    	popl %edx
    	sub %ebx, %edx
    	pushl %edx
    	jmp loop1
    divstack:
    	movl %eax, %ebx
    	and $0, %edx #daca e garbage in edx il trateaza ca parte din dividend deci il facem 0
    	popl %ecx
    	popl %eax
    	idivl %ecx #numerele sunt mici, cl = ecx
    	pushl %eax
    	movl %ebx, %eax
    	jmp loop1
    endloop1:
    	pushl $formatlong #solutia este singura in stiva
    	call printf
    	addl $8, %esp
    	pushl $nl
	call printf
	addl $4, %esp
	mov $0x01, %eax
	xor %ebx, %ebx
	int $0x80
		
