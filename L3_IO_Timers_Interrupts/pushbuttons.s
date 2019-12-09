					.text
					.equ PB_BASE, 0xFF200050
					.equ EDGE_BASE, 0xFF20005C
					.global read_PB_data_ASM
					.global PB_data_is_pressed_ASM
					.global read_PB_edgecap_ASM
					.global PB_edgecap_is_pressed_ASM
					.global PB_clear_edgecap_ASM
					.global enable_PB_INT_ASM
					.global disable_PB_INT_ASM

read_PB_data_ASM:
					LDR R1, =PB_BASE			//Put pushbutton register's value into R1
					LDR R0, [R1]				//Put pushbutton register's value into R0
					BX LR

PB_data_is_pressed_ASM:
					LDR R1, =PB_BASE			//Put pushbutton register's value into R1
					LDR R2, [R1]				//Put the pushbuttons register's value into R2
					AND R1, R2, R0				//Logical AND		
					CMP R1, #1					//Compare R2 and 1
					MOVEQ R0, #1				//Move 1 into R0
					MOVNE R0, #0				//Or move 0 into R0
					BX LR						//Return statement

read_PB_edgecap_ASM:
					LDR R1, =EDGE_BASE			// put EDGE_BASE value into R1
					LDR R0, [R1]
					BX LR 						//Return statement

					.end
					
					
