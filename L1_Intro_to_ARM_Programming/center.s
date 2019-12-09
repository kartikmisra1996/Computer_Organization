.text
				.global _start

_start:
				LDR R4, =SUM				//R4 has address of sum of entries
				LDR R2, [R4, #4]			//R2 has size of list
				ADD R3, R4, #8				//R3 has address of first entry
				LDR R6, [R4, #4]			//R6 has size of list
				LDR R0, [R3]				//R0 has value of first entry

LOOPONE:		SUBS R2, R2, #1				//Decrement loop counter
				BEQ DONEONE					//End loop if counter reaches 0
				ADD R3, R3, #4				//R3 has address of next entry in list
				LDR R1, [R3]				//R1 has value of next entry in list
				ADD R0, R0, R1				//Add next entry to value in R0
				B LOOPONE					//Branch back to LOOPONE

DONEONE:		STR R0, [R4]				//Store sum to SUM memory location
				ADD R2, R2, R6				//Reset R2 to contain size of entry list



				LDR R5, =0x00000001			//loop counter for LOOPTWO

LOOPTWO:		ASR R6, R6, #1				//Divide size of array by 2, store in R6 (shift by 1)
				CMP R6, #1					//Compare R6 value to 1
				BEQ DONETWO					//If R6 = 1 then exit loop
				ADD R5, R5, #1				//counter++
				B LOOPTWO					//branch back to LOOPTWO

DONETWO:		ASR R0, R0, R5				//Shift SUM value by counter (R5)
	
				LDR R4, =AVG				//R4 conains address of average of all entries 				
				STR R0, [R4]



CENTER:			LDR R1, [R3]				//R1 has value of last number in list
				SUBS R1, R1, R0				//Subtract average from this number
				STR R1, [R3]				//Store this centered value in place
				ADD R3, R3, #-4				//R3 has address of previous number in list
				SUBS R2, R2, #1				//Decrement loop counter
				BEQ END						//End loop if counter = 0
				B CENTER					//Branch back to CENTER
				
				

END:			B END						//infinte loop

ADDED:			.word	0					//memory assigned for ADDED location

N:				.word	8					//number of entries in array

NUMBERS:		.word	1, 2, 2, 3 			//entries		
				.word	3, 4, 4, 5 			

AVG:		.word 	0						//memory assigned for avg value location

				

