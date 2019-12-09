				.text
				.equ HEX_BASE, 0xFF200020
				.equ HEXF1_BASE, 0xFF200030
				.global HEX_clear_ASM
				.global HEX_flood_ASM
				.global HEX_write_ASM

HEX_flood_ASM:
				LDR R1, =0x0000007F		//Load R1 with value to be written to flood, 01111111 in binary
				LDR R2, =HEX_BASE		//Load R2 with the HEX values' base address
				PUSH {R4}				//Push R4 onto the stack 
				MOV R4, #0				//Move 0 into R4

LOOPF1:
				CMP R4, #4				//Compare R4 and 4 (counter)
				BEQ HEXF1				//Branch to HEXF1 if validated
				AND R3, R0, #1			//Check if LSB of R0 is one and store result in R3 (logical and)
				CMP R3, #1				//Compare R3 and 1
				BEQ WRITEF1				//If validated, branch to WRITEF1 to write this value
SUBF1:		ADD R2, R2, #1				//Increment base address  y 1
				LSR R0, R0, #1			//Shift so that new LSB is the same as next HEX value
				ADD R4, R4, #1			//Increment counter by 1
				MOV R3, #0				//Move 0 into R3
				B LOOPF1				//Branch to LOOPF1
				
WRITEF1:									
				STRB R1, [R2]			//Write last 8 bits of R1 into memory at base address
				MOV R3, #0				//Move 0 into R3
				B SUBF1					//Branch to SUBF1 after writting is completed

HEXF1:
				LDR R2, =HEXF1_BASE
				B LOOPF2

LOOPF2:
				CMP R4, #6				//Compare R4 and 6 (counter)
				BEQ DONEF				//if validated, branch to DONEF (completed)
				AND R3, R0, #1			//Check if LSB of argument R0 is one and store result in R3 (logical and)
				CMP R3, #1				//Compare R3 and 1
				BEQ WRITEF2				//If validated, branch to WRITEF2 to write this value
SUBF2:			ADD R2, R2, #1			//Increment base address by 1
				LSR R0, R0, #1			//Shift argument so that new LSB is the bit corresponding to the next HEX value
				ADD R4, R4, #1			//Increment counter
				MOV R3, #0				//Move 0 into R3
				B LOOPF2				//Branch to LOOPF2			

WRITEF2:
				STRB R1, [R2]
				MOV R3, #0				//Move 0 into R3
				B SUBF2					//Branch to SUBF2 after writting is complete
				


DONEF:
				POP {R4}				//Pop R4
				BX LR					//Return statement

//-----------------------------------------------------------------------------------------------------------------------------------------------------
HEX_clear_ASM:
				MOV R1, #0				//Load R1 with value to be written to clear, equivalent to 00000000
				LDR R2, =HEX_BASE		//Load R2 with the HEX values' base address
				PUSH {R4}				//Push R4 to the stack (saving it)
				MOV R4, #0				//Move 0 into R4, resetting the counter to 0

LOOPC1:
				CMP R4, #4				//Check counter
				BEQ HEXC1				//Branch to HEXC1 if validated
				AND R3, R0, #1			//Check if LSB of argument R0 is one and store result in R3 (logical and)
				CMP R3, #1				//Compare R3 and 1
				BEQ WRITEC1				//If validated branch to WRITEC1 to write this value
SUBC1:		ADD R2, R2, #1				//Increment base address by 1
				LSR R0, R0, #1			//Shift argument so that new LSB is the bit corresponding to the next HEX value
				ADD R4, R4, #1			//Increment counter by 1
				MOV R3, #0				//Move 0 into R3
				B LOOPC1				//Branch to LOOPC1
				
WRITEC1:									
				STRB R1, [R2]			//Write last 8 bits of R1 into memory at base address (flood whichever HEX value R2 now points to)
				MOV R3, #0				//Move 0 to R3
				B SUBC1					//Branch SUBC1 after writting is complete

HEXC1:
				LDR R2, =HEXF1_BASE
				B LOOPC2

LOOPC2:
				CMP R4, #6				//Compare R4 and 5, checking counter
				BEQ DONEC				//branch to DONEC if counter condition is validated
				AND R3, R0, #1			//Check if LSB of argument R0 is one and store result in R3 (logical and)
				CMP R3, #1				//Compare R3 and 1
				BEQ WRITEC2				//If validaded, branch to WRITEC2 to write this value
SUBC2:		ADD R2, R2, #1				//Increment base address by 1
				LSR R0, R0, #1			//Shift argument so that new LSB is the bit corresponding to the next HEX value
				ADD R4, R4, #1			//Increment counter by 1
				MOV R3, #0				//Move 0 into R3
				B LOOPC2				//Branch to LOOPC2				

WRITEC2:
				STRB R1, [R2]
				MOV R3, #0				//Reset R3 to 0
				B SUBC2					//Branch back to right after this HEX value was written to
				


DONEC:
				POP {R4}				//Pop R4 (restore)
				BX LR					//Return statement
				
//------------------------------------------

HEX_write_ASM:
				PUSH {R4, R5}			//Puch R4 and R5
				MOV R5, R1				//Move the value in R1 into R5
				CMP R5, #0				//Compare R5 and 0
				BEQ ZERO 
				CMP R5, #1				//Compare R5 and 1. each CMP statement compare R5 to 0 through 15, then branching to the appropriate loop
				BEQ ONE 
				CMP R5, #2				
				BEQ TWO 
				CMP R5, #3				
				BEQ THREE 
				CMP R5, #4				
				BEQ FOUR 
				CMP R5, #5				
				BEQ FIVE 
				CMP R5, #6				
				BEQ SIX 
				CMP R5, #7				
				BEQ SEVEN 
				CMP R5, #8				
				BEQ EIGHT 
				CMP R5, #9				
				BEQ NINE 
				CMP R5, #10				
				BEQ TEN 
				CMP R5, #11				
				BEQ ELEVEN 
				CMP R5, #12				
				BEQ TWELVE 
				CMP R5, #13				
				BEQ THIRTEEN 
				CMP R5, #14				
				BEQ FOURTEEN 
				CMP R5, #15				
				BEQ FIFTEEN 

ZERO:			LDR R1, =0X0000003F
				B CONT
ONE:			LDR R1, =0X00000006
				B CONT
TWO:			LDR R1, =0X0000005B
				B CONT
THREE:			LDR R1, =0X0000004F
				B CONT
FOUR:			LDR R1, =0X00000066
				B CONT
FIVE:			LDR R1, =0X0000006D
				B CONT
SIX:			LDR R1, =0X0000007D
				B CONT
SEVEN:			LDR R1, =0X00000007
				B CONT
EIGHT:			LDR R1, =0X0000007F
				B CONT
NINE:			LDR R1, =0X0000006F
				B CONT
TEN:			LDR R1, =0X00000077
				B CONT
ELEVEN:			LDR R1, =0X0000007C
				B CONT
TWELVE:			LDR R1, =0X00000039
				B CONT
THIRTEEN:		LDR R1, =0X0000005E
				B CONT
FOURTEEN:		LDR R1, =0X00000079
				B CONT
FIFTEEN:		LDR R1, =0X00000071
				B CONT

CONT:			LDR R2, =HEX_BASE		//Load R2 with the HEX values' base address
				MOV R4, #0				//Initialise counter to 0

LOOPW1:
				CMP R4, #4				//Check counter
				BEQ HEXF1				//Branch to HEXF1 if counter is 4
				AND R3, R0, #1			//If LSB of argument R0 is 1 store result in R3
				CMP R3, #1				//Compare R3 and 1
				BEQ WRITEW1				//If validated branch to WRITEW1 to write this value
SUBW1:		ADD R2, R2, #1				//Increment base address
				LSR R0, R0, #1			//Shift argument so that new LSB is the bit corresponding to the next HEX value
				ADD R4, R4, #1			//Increment counter
				MOV R3, #0				//Move 0 to R3
				B LOOPW1				//Branch to LOOPW1
				
WRITEW1:									
				STRB R1, [R2]			//Write last 8 bits of R1 into memory at base address (i.e. flood whichever HEX value R2 now points to)
				MOV R3, #0				//Move 0 to R3
				B SUBW1					//Branch to SUBW1 after writting is complete

HEXW1:
				LDR R2, =HEXF1_BASE
				B LOOPW2

LOOPW2:
				CMP R4, #6				//check counter
				BEQ DONEW				//Branch to DONEW if counter is 4
				AND R3, R0, #1			//If LSB of R0 is 1 store in R3
				CMP R3, #1				//Compare contents of R3 and 1
				BEQ WRITEW2				//If validated branch to WRITEW2 to write this value
SUBW2:		ADD R2, R2, #1				//Increment base address
				LSR R0, R0, #1			//Shift argument so that new LSB is the bit corresponding to the next HEX value
				ADD R4, R4, #1			//Increment counter
				MOV R3, #0				//Move 0 into R3
				B LOOPW2				//Branch back to LOOPW2				

WRITEW2:
				STRB R1, [R2]
				MOV R3, #0				//Put 0 into R3
				B SUBW2					//Branch to SUBW2 when writting porcedure is complete
				
DONEW:
				POP {R4, R5}			//Restore R4 (calling convention)
				BX LR					//Return		


				.end

				
