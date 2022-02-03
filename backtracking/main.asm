.section .data

formatscanf: .asciz "%d"

formatprintf: .asciz "%d "

array: .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

f: .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

n: .long 0

m: .long 0

dim: .long 0

carry: .long 0

nl: .asciz "\n"

.section .bss



.section .text

.globl main

    main:

    push $0x0

    push $0x2

    push $0x0

    push stdout

    call setvbuf

    addl $16, %esp

    pushl $n

    pushl $formatscanf

    call scanf

    addl $8, %esp

    pushl $m

    pushl $formatscanf

    call scanf

    addl $8, %esp

    and $0, %esi

    movl n, %ecx

    imull $3, %ecx

    movl %ecx, dim

read:

    pushl $carry

    pushl $formatscanf

    call scanf

    addl $8, %esp

    movl carry, %eax

    cmp $0, %eax

    movl %eax, array(,%esi,4)

    je nuincrementezf

    movl array(,%esi,4), %ebx

    movl f(,%ebx,4), %edx

    incl %edx

    movl %edx, f(,%ebx,4)

nuincrementezf:

    addl $1, %esi

    cmp dim, %esi

    jl read

    and $0, %esi

    movl $0, %edx

    call bkt

    addl $4, %esp

    jmp nosolution

bkt:

	pushl %ebp

	mov %esp, %ebp

	movl array(,%edx,4), %ebx

	cmp $0, %ebx

	jg punctfix

    cmp dim, %edx

    je solution

    movl $1, %eax

loop1:

	cmp n, %eax

	jg endverif

	movl f(,%eax,4), %ecx

	cmp $3, %ecx

	jge endverif

	movl %eax, array(,%edx,4)

	movl $1, %ebx

verif:

	movl %edx, %esi

	addl %ebx, %esi

	cmp $dim, %esi

	jge verifpart2

	movl array(,%esi,4), %ecx

	cmp array(,%edx,4), %ecx

	je endverif

verifpart2:

	subl %ebx, %esi

	subl %ebx, %esi

	cmp $0, %esi

	jl skipnegative

	movl array(,%esi,4), %ecx

	cmp array(,%edx,4), %ecx

	je endverif

skipnegative:

	addl $1, %ebx

	cmp m, %ebx

	jle verif

	jmp okverif

punctfix:

	incl %edx

    call bkt

    decl %edx

    popl %ebp

    ret

endverif:

	addl $1, %eax

	cmp n, %eax

	jle loop1

	movl $0, %esi

	movl %esi, array(,%edx,4)

	decl %edx

	popl %ebp

	ret

okverif:

	movl array(,%edx,4), %esi

	movl f(,%esi,4), %ebx

	incl %ebx

	movl %ebx, f(,%esi,4)

	incl %edx

	call bkt

	movl array(,%edx,4), %esi

	movl f(,%esi,4), %ebx

	decl %ebx

	movl %ebx, f(,%esi,4)

	movl array(,%edx,4), %eax

	incl %eax

	movl $0, %esi

	movl %esi, array(,%edx,4)

	jmp loop1

nosolution:

	pushl $-1

	pushl $formatprintf

	call printf

	addl $8, %esp

	pushl $nl

	call printf

	addl $4, %esp

	mov $0x01, %eax

	xor %ebx, %ebx

	int $0x80

solution:

	and $0, %ebx

solutionloop:

	movl array(,%ebx,4), %edx

	pushl %edx

	pushl $formatprintf

	call printf

	addl $8, %esp

	incl %ebx

	cmp dim, %ebx

	jl solutionloop

	pushl $nl

	call printf

	addl $4, %esp

	mov $0x01, %eax

	xor %ebx, %ebx

	int $0x80

