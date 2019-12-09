.text

	.global read_PS2_data_ASM
	.equ PS2_Data, 0xFF200100
	.equ PS2_Control, 0xFF200104


read_PS2_data_ASM:
	LDR R3, =PS2_Data 			//loading PS2_Data argument, polling this register
	LDR R4, [R3]				//put this into R4
	MOV R1, #0x8000				//becasue the RVALID bit is at position 16
	MOV R5, #0xFF				//last byte
	AND R2, R4, R1 				//if the RVALID register is one, we will get one
	CMP R2, #0					//compared R2 and 0
	BEQ INCORRECT				//if R2 is 0, branch to INCORRECT
	AND R6, R4, R5				//to get the last 8 bits
	STRB R6, [R0]				//store keyboard input data at pointer location
	
	MOV R0, #1					//move 1 into R0 if the data is valid
	BX LR 						//return statement

INCORRECT:
	MOV R0, #0					//there is no data to pass on, move 0 into R0
	BX LR 						//return statement

	.end