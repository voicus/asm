.section .data
	formatscanf: .asciz "%s" #fara spatiu, formatstring are spatiu pt operatii ca sa nu fac manual
   	formatstring: .asciz "%s "
   	formatchar: .asciz "%c "
	formatlong: .asciz "%d "
	oplet: .asciz "let"
	opadd: .asciz "add"
	opsub: .asciz "sub"
	opdiv: .asciz "div"
	opmul: .asciz "mul"
	minuszero: .asciz "-0 "
#    	str: .asciz "A78801C00A7890EC04" - hardcodat pt. testari
	nl: .asciz "\n"

.section .bss
    	.lcomm str, 101
    	.lcomm dec, 101

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
				
		#din ascii in int
		mov $str, %eax
		mov $dec, %ebx
	loop1:	
		movb (%eax), %cl
		cmp $0, %cl
		je endloop1
		sub $48, %cl  # '0'
		cmp $9, %cl
		jle numarloop1
		sub $7, %cl # 'A' - '0' - 10
	numarloop1:
		movb %cl, (%ebx)
		inc %ebx
		inc %eax
		jmp loop1	
	endloop1:
		movb $0xFF, (%ebx)
		
		mov $0, %ebx
		mov $dec, %eax
	loop2:
		movb (%eax), %bh
		cmp $0xFF, %bh
		je endloop2
		movb 1(%eax), %bl
		shl $4, %bl
		or 2(%eax), %bl		
		jmp convert
	endconvert:
		addl $3, %eax
		jmp loop2
	endloop2:
		pushl $nl
		call printf
		addl $4, %esp

		mov $0x01, %eax
		xor %ebx, %ebx
		int $0x80
		
	convert:
		mov %bx, %cx
		shr $9, %cx
		and $3, %cx
		cmp $0, %cx #in cx raman bitii b2 si b3
		je numarintreg
		cmp $1, %cx
		je variabila
		cmp $2, %cx
		je operatie
	variabila:
		mov $0, %ecx
		mov %bx, %cx
		and $127, %cx #variabilele sunt litere mici deci cod ascii mai mic decat 123
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl %ecx
		pushl $formatchar
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
		
	operatie:
		mov %bx, %cx
		and $7, %cx #toti bitii de la b4 la b8 sunt zero deci nu are rost sa facem and cu ceva mai mare.
		cmp $0, %cx
		je letprint
		cmp $1, %cx
		je addprint
		cmp $2, %cx
		je subprint
		cmp $3, %cx
		je mulprint
		cmp $4, %cx
		je divprint
	numarintreg:	
		mov %bx, %cx
		and $511, %cx #ultimii 9 biti
		cmp $256, %cx
		jge numarnegativ
		jl numarpozitiv
		
	numarnegativ:
		and $0xFFFF, %ecx #dam clear lui ecx in afara lui cx
		sub $256, %ecx
		imul $-1, %ecx
		cmp $0, %ecx
		je zeronegativ
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl %ecx
		pushl $formatlong
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	zeronegativ:
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl $minuszero
		call printf
		addl $4, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	
	numarpozitiv:
		and $0xFFFF, %ecx #dam clear lui ecx in afara lui cx
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl %ecx
		pushl $formatlong
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	letprint:
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl $oplet
		pushl $formatstring
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	addprint:
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl $opadd
		pushl $formatstring
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	subprint:
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl $opsub
		pushl $formatstring
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	mulprint:
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl $opmul
		pushl $formatstring
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
	divprint:
		pushl %eax
		pushl %ebx
		pushl %ecx
		pushl $opdiv
		pushl $formatstring
		call printf
		addl $8, %esp
		popl %ecx
		popl %ebx
		popl %eax
		jmp endconvert
		
	


