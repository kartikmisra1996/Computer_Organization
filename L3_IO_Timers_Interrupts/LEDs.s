				.text
				.equ LED_BASE, 0xFF200000
				.global read_LEDs_ASM
				.global write_LEDs_ASM

read_LEDs_ASM:
				LDR R1, =LED_BASE	//Load R1 with the address of the LEDs memory location
				LDR R0, [R1]		//Load R0 with the value in that address
				BX LR				//Branch back to the Link Register

write_LEDs_ASM:
				LDR R1, =LED_BASE	//Load R1 with the address of the LEDs memory location
				STR R0, [R1]		//Store into that address the value in R0
				BX LR				//Branch back to the Link Register

				.end