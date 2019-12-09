.text

	.global write_audio_data_ASM
	.equ Control,	0xFF203040
	.equ Fifospace,	0xFF203044
	.equ Leftdata,	0xFF203048
	.equ Rightdata,	0xFF20304C


write_audio_data_ASM:
		 LDR R2, =Fifospace		//load the Fifospace register
		 LDR R3, [R2]			//putting that into R3
         MOV R4, R3, LSR #16    //shifting to WSRC and WSLC positions, then put them in R4

		 LDRB R5, [R4]		    //WSRC val

		 MOV R4, R4, LSR #8		//shift by 8 to get the WSLC

		 LDRB R6, [R4]         	//WSLC val

		 CMP R5,#1              //verifying space availability in WSRC
         BLT saturated          //if it is full branch to saturated
         CMP R6,#1              //verifying space availability in WSLC 
         BLT saturated          //if it is full branch to saturated 


		 LDR R7,=Leftdata		//loading address argument of Leftdata
         LDR R8,=Rightdata		//loading address argument of Rightdata
         STR R0,[R7]			//put this value into R0
         STR R0,[R8]			//put this value into R0
         MOV R0, #1				//if operation could be done, move 1 into R0
		 B END					//end
		 
saturated:
		MOV R0, #0				//return 0 for failed
END:	BX LR 					//return statement