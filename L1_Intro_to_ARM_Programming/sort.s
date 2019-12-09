.text
				.global _start

_start:
				LDR R0, =0x00000000				//R0 the boolean (0 = false, 1 = true)

WHILE:			LDR R1, =N						//R1 contains the address of the size of the list
				LDR R2, [R1]					//R2 contains size of the list
				LDR R3, =NUMBERS				//R3 has address of 1st entry
				ADD R4, R3, #4					//R4 has address of 2nd entry
				LDR R6, [R3]					//R6 has value of 1st entry
				LDR R7, [R4]					//R7 has value of 2nd entry
				CMP R0, #1						//Check R0
				BEQ DONE						//If true exit loop
				ADD R0, #1						//Set R0 to true

WHILETWO:			SUBS R2, R2, #1				//Decrement loop counter
				BEQ WHILE						//If counter is 0, branch back to WHILE
				CMP R6, R7						//Compare R6 to R7	
				BGT SWITCH						//If R6 > R7 go to SWITCH
				ADD R3, R3, #4					//R3 has address of next entry
				ADD R4, R4, #4					//R4 has address of next entry
				LDR R6, [R3]					//R6 has value of next entry
				LDR R7, [R4]					//R7 has value at address R4	
				B WHILETWO						//Branch back to WHILETWO

SWITCH:			STR R6, [R4]					//store value in R6 into memory with address R4
				STR R7, [R3]					//store value in R7 into memory with address R3
				LDR R6, [R3]
				LDR R7, [R4]
				ADD R0, #-1						//set R0 to false, the list is sorted
				ADD R2, #1						//increase counter
				B WHILETWO	 

DONE:			B DONE							


N:				.word	5						//size of entry list

NUMBERS:		.word	7,14,12,5,13			//entries


