cerinta1vechi: cerinta1.o
	ld -m elf_i386 cerinta1.o -o cerinta1vechi

# must have .global main
cerinta1: cerinta1.o
	gcc -m32 cerinta1.o -o cerinta1

cerinta1cld: cerinta1.o
	ld  -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc cerinta1.o -o cerinta1cld

cerinta1.o: cerinta1.asm
	as --32 cerinta1.asm -o cerinta1.o -ggdb
	
all: cerinta1

clean:
	rm -f cerinta1 cerinta1.o
	
run: cerinta1
	./cerinta1
	
runc: cerinta1c
	./cerinta1c
	
runcld: cerinta1cld
	./cerinta1cld
	
run2: cerinta2
	./cerinta2
clean2:
	rm -f cerinta2 cerinta2.o
cerinta2: cerinta2.o
	gcc -m32 cerinta2.o -o cerinta2

cerinta2cld: cerinta2.o
	ld  -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc cerinta2.o -o cerinta2cld

cerinta2.o: cerinta2.asm
	as --32 cerinta2.asm -o cerinta2.o -ggdb
	
run3: cerinta3
	./cerinta3
clean3:
	rm -f cerinta3 cerinta3.o
cerinta3: cerinta3.o
	gcc -m32 cerinta3.o -o cerinta3

cerinta3cld: cerinta3.o
	ld  -m elf_i386 -dynamic-linker /lib/ld-linux.so.3 -lc cerinta3.o -o cerinta3cld

cerinta3.o: cerinta3.asm
	as --32 cerinta3.asm -o cerinta3.o -ggdb
