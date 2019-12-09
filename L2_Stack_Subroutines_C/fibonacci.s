				.text
				.global _start

_start:		
				LDR R1, =RESULT					//R1 contains address of the result
				LDR R2, [R1, #4]				//R2 contains N
				PUSH {LR}						//Push the current LR onto the stack 
				BL FIBONACCI					//branch to the fibonacci subroutine using BL
				STR R0, [R1]					//Store the end result of fibonacci subroutine 
				POP {LR}						//Pop LR back to original
				
				B END							
 
FIBONACCI: 		CMP R2, #2						//compare R2 and 2
				BLT BASE						//if R2 value is less then branch to the base case
				SUBS R2, R2, #1					//R2--
				PUSH {R2,LR}					//push fib(n-1) and LR onto the stack for storage
				BL FIBONACCI					//recursive statement, doing fib(n-1)
				POP {R2, LR}					//pop this value and LR off the stack 
				MOV R3, R0						//put R0 value into R3
				SUBS R2, R2, #1					//again decrementing by 1, so in total decrement by 2
				PUSH {R3,LR}					//push fib(n-2) and LR in stack for storage
				BL FIBONACCI 					//recursive statement, doing fib(n-1)
				POP {R3, LR}					//pop decremented value and LR at each 
												//call of recursive statement
				ADD R0, R0, R3					//adding R0 and R3 and storing it in R0
				B DONE

BASE:			LDR R0, =1						//Base case
				B DONE

DONE:			BX LR							//Return statement

END:			B END							//end loop

					

RESULT:			.word	0						//initially, result is 0


N:				.word	7						//get Nth fibonacci number 
												//in reality we will get the (N+1)th fibonacci number

