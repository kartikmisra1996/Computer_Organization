				.text
				.global _start

_start:		
				LDR R1, =NUMBERS		//R1 has address of first number
				ADD R3, R1, #16			//R3 holds address number of elements
				LDR R2, [R3]			//R2 holds size of set
				LDR R0, [R1]			//R0 has first number
				BL MAX 					//calling the subroutine using BL
END:			B END					//stop loop
 
MAX:	 		SUBS R2, R2, #1			//decrement by 1
				BEQ DONE				//end loop if counter has reached 0
	 			ADD R1, R1, #4			//R1 points to next number in the set
	 			LDR R3, [R1]			//R3 holds the next number in the set
	 			CMP R0, R3				//compare R0 and R3, which is the current maximum
	 			BGE MAX					//if R3 is smaller branch back to MAX and repeat using recursion
	 			MOV R0, R3				//if R3 is bigger move the return value into R0
	 			B MAX					//branch back to MAX and repeat using recursion

DONE:			BX LR					//returning to calling code


NUMBERS:		.word	1, 2, 9, 7, 12	//set of numbers

N:				.word	5				//size of set