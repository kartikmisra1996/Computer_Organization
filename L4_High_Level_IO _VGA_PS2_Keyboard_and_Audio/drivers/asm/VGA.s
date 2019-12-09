.text

	.equ PIXEL_BUFF, 0xC8000000
	.equ CHAR_BUFF, 0xC9000000

	.equ PIXELWIDTH, 320
	.equ PIXELHEIGHT, 240
	.equ CHARWIDTH, 80
	.equ CHARHEIGHT, 60

	X .req R0
	Y .req R1
	C .req R2
	BASE .req R5
	OFST .req R6

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM 

	.global VGA_draw_point_ASM 

VGA_clear_charbuff_ASM:
	PUSH {R0-R10,LR}				//pushing R0 to R10 on top of the stack
	LDR BASE, =CHAR_BUFF			//Loading the char buffer argument
	MOV R2, #-1						//initial coordinate values before we loop through them		
	MOV R3, #0						//initial coordinate values before we loop through them	
	MOV R4, #0						//initial coordinate values before we loop through them
	MOV R7, #0						//initial coordinate values before we loop through them	

XCOORD:
	ADD R2, R2, #1					//iterating through
	CMP R2, #80 					//we want x to be less that 79 as mentioned in the lab handout
	BEQ DONEX						//branch to DONEX if validated
	MOV R3, #0						//move 0 into R3 (return register)
YCOORD:	
	CMP R3, #60						//compare y to 59 as mentionned in the lab handout
	BEQ XCOORD						//branch to XCOORD if validated
	LSL OFST, R3, #7				//applying offset of seven for increment in y coordinate 
	ORR OFST, OFST, R2
	ADD R4, BASE, OFST				//updating the address after offset is applied

	STRB R7, [R4]					//store 0 at the address

	ADD R3, R3, #1 					//increment y coordinate
	B YCOORD						//branch back to YCOORD

DONEX:
	POP {R0-R10,LR}					//pop stack values RO through R10, we are done
	BX LR 							//return statement



VGA_clear_pixelbuff_ASM:
	PUSH {R0-R10,LR}				//pushing R0 through R10 onto the stack
	LDR BASE, =PIXEL_BUFF			//loading pixel buffer argument
	MOV R2, #-1						//initial coordinate values before we loop through them	
	MOV R3, #0						//initial coordinate values before we loop through them	
	MOV R4, #0						//initial coordinate values before we loop through them	
	MOV R9, #0						//initial coordinate values before we loop through them	

	LDR R7, =PIXELWIDTH				//loading horizontal pixel resolution argument

XPIXEL:
	ADD R2, R2, #1					//increment x
	CMP R2, R7						//compare x and 319 (max x res of FPGA)
	BEQ DONEPIXEL					//branch to DONEPIXEL if validated
	MOV R3, #0						//move 0 into R3 (return register)
YPIXEL:	
	CMP R3, #240 					//compare y and 239 (max y res of FPGA)
	BEQ XPIXEL						//branch to XPIXEL after we have moved down one y pixel
	
	LSL OFST, R3, #10				//apply the offset for the pixel as instructed in the manual
	LSL R8, R2, #1					//move x by one so that we can have a 0 bit
	ORR OFST, OFST, R8				//add the offsetted x, y and c 
	ADD R4, BASE, OFST				//update the address
	STRH R9, [R4]					//save 0
	
	ADD R3, R3, #1 					//increment y coordinate
	B YPIXEL						//branch to YPIXEL for the next line
DONEPIXEL:
	POP {R0-R10,LR}					//pop Ro to R10, we are done
	BX LR 							//return statement


	
VGA_write_char_ASM:
	PUSH {R0-R10,LR}				//pushing Ro through R10 into the stack
	LDR R3, =CHARWIDTH 				//this is 80
	LDR R4, =CHARHEIGHT 			//this is 60
	CMP X, R3						//compare X and R3
	BGE DONEWCHAR					//if x>=R3 branch to ending
	CMP X, #0						//compare x and 0
	BLT DONEWCHAR					//if x<0 branch to ending
	CMP Y, R4						//compare y and R4
	BGE DONEWCHAR					//if y>=0 ,branch to ending
	CMP Y, #0						//compare y and 0
	BLT DONEWCHAR					//if y<0 branch to ending

	MOV R3, #0						//offset for x
	MOV R4, #7						//offset for y

	LDR BASE, =CHAR_BUFF			//loading char buffer
	LSL OFST, Y, #7					//move y 7 places to the left to make space for x
	ORR OFST, OFST, X
	ADD R4, BASE, OFST				//update address with offsetted addresses

	STRB C, [R4]					//store c at the address

DONEWCHAR:
	POP {R0-R10,LR}					//pop R0 through R10, we are done
	BX LR 							//return statement
	
VGA_write_byte_ASM:
	PUSH {R0-R10,LR}				//puch R1 through R10 onto the stack
	LDR R7, =HEXCHAR				//load the argument
	MOV R3, R2						//because we want to print it twice
	LSR R2, R3, #4					//shifting right by 4 bits to get only the last 4 ones
	AND R2, R2, #15 				//get the last 4 bits of the byte
	LDRB R2, [R7, R2]				//load at R2 R7 shifted by R2 to get the character you want
	BL VGA_write_char_ASM			//write that character
	AND R2, R3, #15 				//get the first 4 bits of the byte
	ADD R0, R0, #1 					//increment x
	LDRB R2, [R7, R2]				//same as above
	BL VGA_write_char_ASM			//again, call the write char method

	POP {R0-R10,LR}					//pop R1 through R10, we are done
	BX LR 							//return statement
	
VGA_draw_point_ASM:
	PUSH {R0-R10,LR}
	LDR BASE, =PIXEL_BUFF			//load pixel buffer argument
	MOV R6, R2						//store colour in R6

	LSL OFST, Y, #10				//shift y left by 10bits to make room for x
	LSL R8, X, #1					//shift x left by 1 bit to make room for 0 bit 
	ADD OFST, OFST, R8				//add shifted y and x,  to offset
	ADD R4, BASE, OFST				//add offset to address
	STRH R6, [R4]					//store colour at the address

	POP {R0-R10, LR}
	BX LR

HEXCHAR:
	.ascii "0123456789ABCDEF"

	.end