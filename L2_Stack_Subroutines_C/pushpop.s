				.text
				.global _start

_start:
				LDR R4, =NUMBERS			//R4 has address first number
				LDR R5, [R4]				//R5 has first number
				LDR R6, [R4, #4]			//R6 has next number

				LDR R4, =X					//R4 has address of X
				LDR R0, [R4]				//R0 has X
											
				STR R0, [SP, #-4]!			//PUSH {R0} (immidiate offset)
				STR R5, [SP, #-4]!			//PUSH {R5}
				STR R6, [SP, #-4]!			//PUSH {R6}
	
				LDMIA SP!, {R0-R2}			//POP {R0-R2}
				

END:			B END						//end loop

NUMBERS:		.word	2, 6				//set of numbers		

X:			.word 7

				

