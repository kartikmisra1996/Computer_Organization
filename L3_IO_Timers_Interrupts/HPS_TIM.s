					.text
					.equ TIM_0, 0xFFC08000
					.equ TIM_1, 0xFFC09000
					.equ TIM_2, 0xFFD00000
					.equ TIM_3, 0xFFD01000
					.global HPS_TIM_config_ASM
					.global HPS_TIM_read_ASM
					.global HPS_TIM_clear_INT_ASM

HPS_TIM_config_ASM:
					PUSH {R1-R6}			//push values R1 to R6
					LDR R1, [R0]			//Load R1 with first variable in structure
					MOV R2, #4				//Put 4 into R2 (because we have 4 timers)
		
config_loop:
					CMP R2, #0				//Check if counter has reached 0
					BEQ config_finished		//branch to config_finished if validated
					AND R3, R1, #1			
					CMP R3, #1				//Compare R3 and 1
					SUBNE R2, R2, #1		//Decrement counter if not validated
					BNE config_loop			//Also branch back to top of loop if bit is not 1
					
					//Load base address of each register
					CMP R2, #4
					LDREQ	R4, =TIM_0
					CMP R2, #3
					LDREQ	R4, =TIM_1
					CMP R2, #2
					LDREQ	R4, =TIM_2
					CMP R2, #1
					LDREQ	R4, =TIM_3

					LDR R5, =0x00FFFFFE			//Load R5 with value to clear E bit
					STR R5, [R4, #8]			//Disable E bit

					LDR R5, [R0, #4]			//Load R5 with structure timeout value
					STR R5, [R4] 				//Store this value to the control register					
					
					MOV R5, #0					//Put 0 into R5
					LDR R6, [R0, #16]			//Immidiate offset by 16
					CMP R6, #1					//Compare R6 and 1
					ADDEQ R5, R5, #1
					LDR R6, [R0, #8]			//Immidiate offset by 8
					CMP R6, #1					//Compare R6 and 1
					ADDEQ R5, R5, #2
					LDR R6, [R0, #12]			//Immidiate offset by 12
					CMP R6, #1					//Compare R6 and 1
					ADDEQ R5, R5, #4
					STR R5, [R4, #8]

					SUB R2, R2, #1
					B config_loop				//Branch to config_loop

config_finished:
					POP {R1-R6}					//Pop R1 to R6 (convention)
					BX LR 						//Return statement


HPS_TIM_read_ASM:
					PUSH {R1-R6}
					MOV R2, #4					//R2 is counter, start it off at 4 (bc 4 timers)
		
read_loop:
					//CMP R2, #0				//Check if counter has reached 0
					//BEQ config_finished		//Branch to config_finished
					AND R3, R0, #1				//(logical and)
					CMP R3, #1					//Compare R3 and 1
					SUBNE R2, R2, #1			//Decrement counter if not validated 
					LSRNE R0, R0, #1
					BNE read_loop				//Also branch back to top of loop if bit is not 1
					
												//Load base address of corresponding register
					CMP R2, #4
					LDR	R4, =TIM_0
					CMP R2, #3
					LDR	R4, =TIM_1
					CMP R2, #2
					LDR	R4, =TIM_2
					CMP R2, #1
					LDR	R4, =TIM_3					
					
					LDR R0, [R4, #0x10]			//Load S-bit
					AND R0, R0, #1				//Clear bits 31-1 and leave S-bit (logical and)
					B read_finished 			//Branch to read_finished because we only have a single timer

read_finished:
					POP {R1-R4}					//Pop R1 to R4
					BX LR 						//Return statement


HPS_TIM_clear_INT_ASM:
					PUSH {R1-R4}
					LDR R1, =TIM_0				//load address of TIM_0 into R1
					MOV R2, #0					//assign 0 to R2
					MOV R3, #4					//start counter

clearL:
					CMP R3, #0				//Check counter
					BEQ clear_finished			//Branch to done one if counter is 0
					AND R4, R0, #1			//Check that LSB of argument R0 is one and store result in R3
					CMP R4, #1				//Check that LSB of R0 is one or not
					BEQ clearW			//If it is one, clear F and S for this TIM
clearS:			ADD R1, R1, #0x1000		//Increment base address
					LSR R0, R0, #1			//Shift argument so that new LSB is the bit corresponding to the next HEX value
					SUB R3, R3, #1			//Decrement counter by one
					MOV R4, #0				//Move 0 into R4
					B clearL			//Branch back to the top of the loop
				
clearW:									
					STRB R2, [R1, #12]		
					STRB R2, [R1, #16]
					MOV R4, #0				//Reset R3 to 0
					B clearS				//Branch back to right after this HEX value was written to					

clear_finished:
					POP {R1-R4}
					BX LR

			
