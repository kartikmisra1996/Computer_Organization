.text
				.global _start

_start:		
				LDR R4, =RESULTMAX		//R4 contains the result memory address
				LDR R2, [R4, #8]		//R2 holds the number of elements in the list
				ADD R3, R4, #12			//R3 points to the first number
				LDR R0, [R3]			//R0 holds the first number in the list
 
LOOPONE:	 	SUBS R2, R2, #1			//decrement the loop counter
				BEQ DONEONE				//end loop if counter has reached 0
	 			ADD R3, R3, #4			//R3 points to next number in the list
	 			LDR R1, [R3]			//R1 holds the next number in the list
	 			CMP R0, R1				//check if it is greater than the maximum
	 			BGE LOOPONE				//if no, branch back to the loop
	 			MOV R0, R1				//if yes, update current max
	 			B LOOPONE				//branch back to the loop

DONEONE:	 	STR R0, [R4]			//store the result to the memory address in R4




				LDR R4, =RESULTMIN		//R4 points to the result location
				LDR R2, [R4, #4]		//R2 holds the number of elements in the list
				ADD R3, R4, #8			//R3 points to the first number
				LDR R0, [R3]			//R0 holds the first number in the list
 
LOOPTWO:	 	SUBS R2, R2, #1			//decrement the loop counter
				BEQ DONETWO				//end loop if counter has reached 0
	 			ADD R3, R3, #4			//R3 points to next number in the list
	 			LDR R1, [R3]			//R1 holds the next number in the list
	 			CMP R0, R1				//check if it is greater than the minimum
	 			BLE LOOPTWO				//if yes, branch back to the loop
	 			MOV R0, R1				//if no, update current min
	 			B LOOPTWO				//branch back to the loop

DONETWO:	 	STR R0, [R4]			//store result to the memory

				LDR R3, =RESULTFINAL	//memory address of final result goes in R3
				LDR R4, RESULTMAX		//load the max in R4
				LDR R5, RESULTMIN		//load the min in R5
				SUB R1, R4, R5			//subtract min from max and store it in R1
				ASR R0, R1, #2			//divide by 4 (shit by 2) and store in R0



				STR R0, [R3]			//Store final result  in R3
			

END:	 		B END					//end loops

RESULTMAX:		.word	0				//memory assigned for max result location

RESULTMIN:		.word	0				//memory assigned for min result location	

N:				.word	8				//entry list size

NUMBERS:		.word	6, 26, 5, 91	//entries
				.word	9, 498, 7, 1

DIFFERENCE:		.word	0				//memory for difference between max and min

RESULTFINAL:	.word	0				//memory for final result


			
