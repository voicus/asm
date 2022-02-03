# asm
```
Overview

Assembly languages represent a picture of the car code, and their appearance was, in the most
mostly because programmers wanted to work with language that can be understood
and people, not just a computer. By switching from a bit stringing to instructions with
meaning, other programming languages, known as medium level languages, could be developed later,
precum C, C++ etc.
A significant difference between machine code and assembly languages, respectively medium languages
level and higher level is that, as regards the first two, are strictly dependent
architecture in which they are used. An assembly language depends strictly on the processor, so that x86 does
can be used to program a MIPS processor, RISC-V times etc.
it's not because of assembly language, it's because of the car code that it reflects. M
bit-straining has meaning on a processor, and may not make sense, or have meaning
completely different on another processor.
2.1 A look at the car code
In this case, we wonder - how do we know what meaning a binary string has for our processor? How can we decode that seemingly random bit straining, so we understand the instructions
to execute? A simple answer we can have if we analyze, in particular, the class of RISC processors.
One of the considerable differences between CISC and RISC, is that in the CISC class the instructions
have a variable length, while in RISC all instructions have exactly the same length. (length of
representation in bits) For example, if we take a RISC processor on 32 bits, in this all
the operations have a binary code - car code, on 32 bits. In CISC class things are completely
different - operations have variable length, and then it is relatively more difficult to park.
We will set an example. Let's consider add operation. In the RISC class, the implementation of the add is
simpler, as it has three operands - destination, source 1 and source 2. We can write, so add %7,
%8, %11, where 7, 8, 11 are the registries of this processor (the registries are identified or by a name
symbolic, or by an associated number).
We resume the offered operation: add %7, %8, %11. We'd like to represent you in car code.
Reading the documentation, we get that the format of the instruction is the following: (how they are divided
32 bits)
· 6 bits for the operation code;
· 5 bits for coding the first source register;
· 5 bits for encoding the second source registry; 5 bits for the registry coding
destination;
· 5 bits to encode if there is a shift in the operation;
· 6 bits to encode the applied function;
At this point, all we have to do is identify the fields and consider a few
aspect:
· all R-format operations have the operation code 0 - that means we have the value representation
0 pe 6 kick;
· the function code applied - in our case add - is 100000.
For encoding the registry, we use the 2-bit-based encoding, so that:
· the first source registry is %8: 8 in base 2 is 100, and on 5 bits is 00100 (add 2 bits
insignificant to the left);
· the second source registry is %11: 11 in base 2 is 1011, and on 5 bits is 01011;
· destination registry is %7: 7 in base 2 is 111, and on 5 bits is 00111.
As we do not have a shifting operation, the fields will be completed as follows:
· opcode: 000000;
· Source 1 register: 00100
· Source 2 register: 01011
· destination register: 00111
・ digit: 00000;
· applied function: 100000
The corresponding bit string is obtained by concatenation. We'll concatena and we'll group
4: 0000 000 1000 1011 0011 1000 0010 0000
This binary code is actually representing add %7, %8, %11 in machine code on a processor
of the RISC class. We can turn it into a hexa, and we'll have: 00 8B 38 20. (generally what we see
when analyzing binary files)
2.2 Machine code for an arithmetic processor
We saw the correspondence between the car code and the assembly language, and we understand that this
transformation is bidirectional - if we have clear transformation rules, then we can
and binary coding, and decoding in an assembly language.
In this theme we will imagine that we managed to design a processor specialized in solving
of arithmetic expressions. We want this processor to be more expressive than those in classes
RISC and CISC, so we don't have to write the instructions step by step, but we want to give him operations
complexes to be able to translate.
Because we have a processor, it means he's programmable by a machine code. This code
the machine is the one that should transmit the Arithmetic and Logical Unit of the CPU what operations,
possibly very complex, we want to perform. As we saw in the above example, we have
need a clear format for how our instructions look.
2.3 Postfix polish shape
First of all, we need to determine what we want to calculate. Complex expressions lead us to
writings of the form:
Exp = ((2 + 125 ∗ 3 + (144 - 11)/27 + 9)/(6 + 3))2
There is a simple representation of these instructions that does not require parenting. Shape On
which we're going to use is the postfix polish form. It's postfix, because the surgery is the last
that appears. For example, to calculate 2 + 3, in postfix Polish form we write 2 3+.
Writing is obviously helpful in complex operations. For example, we can write 2 3 + 4 ∗ 5 ∗.
The correspondent is (2 + 3) ∗ 4 ∗ 5.
a stack. For example, for 2 3 + 4 ∗ 5 ∗, we add on stack 2 and 3, we find the addition symbol,
make the assembly, remove 2 and 3 from the stack and keep only the result, respectively on 5.
4 on the stack, find the symbol of multiplication, perform multiplication, remove 5 and 4 on the stack and keep
20. Add 5 on the stack, find the multiplication symbol, perform multiplication, remove 20 and 5 off
stack, we keep 100. We have nothing left to execute, so the result is 100 - the item at the top
Steve.
For example, for 15 2 ∗ 4 + the mechanism is similar: add 15 and 2 on stack, perform
multiplication, eliminate 15 and 2, place 30 on the stack, put 4 on the stack, find the assembly symbol,
calculate the result, remove 30 and 4 from the stack, put 34 and stop the execution. We only use
push and pop operations, we use the fact that arithmetic operations accept two arguments, and we apply
algorithm until we have nothing to go through.
For subtraction and sharing, if we have x y -, we will consider x-y, and xy/ will be x / y. Splitting
it'll just be splitting with as much as the rest, on the whole, and it'll just keep playing.
We will consider the let operation, which assigns a value. For example x 1 let means x := 1,
and everywhere he will be met x in the expression, his value will be replaced by 1.
2.4 Format of instructions
We'll build the machine code for this processor. For this, it is important to note that
we work in the style of an 8 bit processor (we can work with numbers up to 255). Format
our instructions will be a little different, because we must be able to enchain expressions of complexity of those mentioned previously, and for example -7 18 + 13 / -5 * we can not have instructions
standard, but we can do them with fixed length.
For the operands coding we have the following structure:
· The coding is on 12 bits (1.5 Bytes);
· the meaning of bits is:
- the first bit, b0 is always equal to 1;
- the following 2 bits identify which type the operand has: if we have 00, then the operand is
number, and if we have 01, then the operand is the variable;
- if we had the number identifier, 00, then b3 is the bit of the sign: 0 means
the number is considered positive, respectively 1 means that the number is considered negative.
If I had the identifier 01, then the b3 bit of the sign will be considered 0;
- the operand can be, as the case may be, as we saw: or positive number (0 to 255), or
negative number (all from 0 to 255, but with changed sign), or a variable - the variables are
formed only by one letter. For example, if we have in the operand encoding
01111000, 1111000 is actually 120 in base 10, which corresponds to the ASCII code for x.
Thus, a complete coding on 12 bits 1 01 0 01111000 means that the current operand
is the x variable. If we had the same representation in the operation, but with another code
identifier, for example 00, 1 00 0 01111000, would have been the whole number 120, and if
i had the 1, 1 00 1 01111000 mark bit, it would have been the whole number -120.
It's just about to code the operations. They will follow a similar structure - an initial bit 1, a
identifier, and an operating code applied up to 12 bits:
We have the following codes:
Coding Operation
let 000000000
add 000000001
sub 000000010
000000011
div 000000100
The identifier is, in this case, 10 (the two bits specifying the identifier). Thus, the representation of an add operation would be 1 10 000000001.
For clarity, we present the identifiers in the following table:
Meaning Identifier
00 full number
01 variable
10 operation
2.5 An example of translation
Let's consider that we want to represent the instruction x 1 let x -14 div.
We will use the formats described above, and we will represent each field in turn.
1. x: as shown in an example above, x is encoded 1 01 0 01111000.
four digits each, so x's representation is 1010 0111 1000.
2. We're coding it on one. It's a positive integer operand coding, so we have the identifier
00 and the sign bit 0. His representation will be 1 00 0 00000001, and on the grouping 4 digits
1000 000 001.
3 let is a operation, it will be encoded as an operation, so having the identifier 10, respectively
The code of operation 000000000. His representation will be 1 10 000000000, and on the grouping 4
figure 1100 0000 000.
4 x will be represented again as 1010 0111 1000.
5. -14 is represented as operating the entire negative number, so with the 00 identifier, the sign bit 1,
and the value 14 in the base 2 → 1110, but on 8 bits, so with 4 bits of 0 to the left (insignificant):
00001110. -14 will be represented, so 1 00 1 00001110, and on the grouping of 4 digits 1001
0000 1110.
6. Finally, div is an operation, so the identifier 10, and the encoding of the oepration according to the table
000000100, thus it will be 10 000000100, and on the grouping of 4 digits 1100 0000 0100.
In this case, we can concatenate all the binary representations, and have:
1010 0111 1000 1000 0001 1100 000 0000 1010 0111 1000 1001 000 1001 000 11000 110 110 1000 110 100 00 00
0100
in hexa:
A7 88 01 C0 0A 78 90 EC 04
We have, therefore, that the operation in our assembly, x 1 let x -14 div, translates into code
hexa representation car in A7 88 01 C0 0A 78 90 EC 04.
3 Topic
In solving the requirements, the variables used are only the small letters of the English alphabet.
3.1 requirement 1
Requirement 1 will be evaluated on 4 tests and will help you get a score of 4p from grade 10.
Be given as input a sir hexa, it is required to display the instruction assembly of
executed.
For example, for the A78801C00A7890EC04 input, the output x 1 let x will be displayed
14 div.
3.2 requirement 2
Requirement 2 will be evaluated on 4 tests and will help you get a score of 2p from grade 10.
Either given as input an instruction in the assembly language of the considered arithmetic processor, it
requires to display the standard output the instruction evaluation. For this requirement, in the instruction
there are no variables, it being formed only from integer numbers and operations.
For example, it can be given instruction 2 10 mul 5 div 7 6 sub add. The result must
either according to the following algorithm:
· add 2 on the stack;
· add 10 on the stack;
· identify the operation, multiply between 2 and 10, get 20, remove 2 and 10
on the stack and only 20 is kept;
· add 5 on the stack;
· identify div - acts as 20 div 5, and the result is 4; remove 20 and 5 from the stack,
and it keeps only 4;
· add 7 on the stack;
· add 6 on the stack;
· identify sub - calculate the difference between 7 and 6, get 1, remove 7 and 6 from the stack,
and add to the stack value 1. Attention! at this point, on the stack we have 4 (at base) and 1 in
peak, because sub is binary operation and worked only with arguments 7 and 6, but not with 4
which was already at the base of the stack.
· identify add - calculate the sum of 1 and 4, get 5, remove 1 and 4 on the stack, se
add 5;
· I have finished the track and the result obtained is, now, located on the top of the stack. The result of this calculation is 5.
A suggestion to implement the algorithm is found at the end of this document. Important! Se
request the evaluation only on unsigned! It guarantees that all operations will be on unsigned.
3.3 requirement 3
Requirement 3 will be evaluated on 3 tests and will help you get 1.5p of grade 10.
Be given as input an instruction in the assembly language of the considered arithmetic processor. Se
requires to display the standard output the instruction evaluation. For this requirement, unlike
of requirement 2, variables introduced by let are used.
An example of the input can be x 1 let 2 x add y 3 let x y add mul.
The evaluation will be made as follows:
· add x and 1 on the stack, is found let, and it is understood from now that x = 1 in the whole expression
arithmetic; are removed x and 1 on the stack;
· add 2 and 1 on the stack (because that x is = 1 now);
· meet add, calculate the amount 3, remove 2 and 1 from the stack and keep only 3;
· add y and 3 on the stack, is found let, and it is understood from now that y = 3 in the whole expression
arithmetic; are removed y and 3 on the stack;
· add 1 and 3 on the stack (x, respectively y);
· assembly is performed, the result will be 4, remove 1 and 3 from the stack, add 4;
· the number is identified, and on the stack we already had 3 (from the third bullet in the current explanation) and
4, from the previous bubble, and calculate the result, 12, then remove 3 and 4 from the stack and
add 12;
· there are no more elements, so the final result is 12.
Exactly as in the second requirement, it is guaranteed that all operations will be applied on unsigned.
3.4 requirement 4
Requirement 4 will be evaluated on 5 tests and will help you get 1.5p of grade 10.
For this requirement, we introduce simple matrix work operations. An array can be
represented in shape
noOfColumnsNoOfLines*noOf_Items
The operations we can use on the matrix are:
· add - we add all the elements of the matrix with the operand value;
· sub - we subtract from all elements of the matrix the operand value;
· mul - inmultim all the elements of the matrix with the operand value;
· div - we divide all the elements in the array to the operand value;
· rot90d - turn the matrix to 90 degrees to the right;
Matrix operations contain only the let instruction and one of the operations mentioned above.
There are no complex instructions, like those from previous requirements!
x 2 3 1 2 4 5 let x 2 add
In this case, matrix x is a matrix of 2 lines x 3 columns, which has the following form:
1 2 3
4 5 6
Apply a -2 addition to all matrix elements:
-1 0 1
2 3 4
As output, the standard output will display the representation of this matrix in the form it is introduced
in: number of lines, number of columns and matrix elements, from left to left
right and top down. In this case, the outpuut will be 2 3 -1 0 1 2 3 4.
If we have the following instruction: x 2 3 -1 0 1 2 3 4 let rot90d, then apply the following rotation to the right 90 degrees:
2-1
3 0
4 1
In this case, the outpuce will be
3 2 2 2 1 3 4 1
Important! All operations in this requirement are applied on signed!
11
4 Theme submission and evaluation
You will send an archive containing four files .asm (or how many requirements you have solved),
named requirement1.asm, requirement2.asm, requirement3.asm and requirement4.asm. Archive will be named
group_First_Name with corresponding extension.
4.1 Form of input
For each requirement, the input will be just a string of characters, given on a single line, that you will
interpret as being read from the keyboard.
The outpuut will be given on a single line: decoding the instruction for requirement 1, respectively
the result of the assessments for the other requirements.
Important! It is the obligation of the students to ensure the correct treatment of the input and the display
correct output. Testing will only be done automatically! Score 0 obtained due to errors
read/display will remain 0. We will not manually evaluate sources due to such
problems.
5 Indicative algorithm for postfix polish shape
We will present the structure of a Polish Postfix Form algorithm in the form that will help you in
implementation of the expression evaluation requirement. The pseudocode below is similar to C
and it indicates what functions you should use.
Input
- instruction // correct instruction for the arithmetic processor
Exit data
- eval // evaluating the instruction
Algorithm
res := strtok(instruction, " ")
firstNumber = atoi(res)
push firstNumber
et_loop:
res := strand(NULL, ")
if res == NULL goto exit
atoiRes := atoi(res)
if atoiRes = 0
// Operation
if atoiRes[0] =='a' // add
pop x
pop y
push (x + y)
if atoiRes[0] == ’s’ // sub
pop x
pop y
push (y - x)
if atoiRes[0] == ’m’ // mul
pop x
pop y
push (x * y)
if atoiRes[0] == 'd' // div
pop x
pop y
push (y / x)
else
// is number; just put it on the stack
push atoiRes
goto et_loop
exit:
pop eval
write (eval)
```
