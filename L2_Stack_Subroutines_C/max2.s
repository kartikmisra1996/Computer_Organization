		.text
		.global MAX_2			//launch MAX_2

MAX_2:							//compare R0 and R1
		CMP R0, R1
		BXGE LR
		MOV R0, R1				
		BX LR					//returns largest value
		.end
		