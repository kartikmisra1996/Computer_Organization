#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include <math.h>


//Using given formulas, create signal waves (freqency and amplitude)

double make_wave(double frequency, double t, int amplitude) {
	
	double index = ((int)(frequency*t))%48000;
	int intIndex = (int) index;
	int floor floor = intIndex;
	int ceil = floor +1;

	if(intIndex - index != 0.00){
		signal = amplitude*((ceil - index) * sine[floor] + (index - floor) * sine[ceil]);
	}else{
		signal = amplitude*sine[intIndex];
	}
    //return signal;
	return signal;

}

/*
//Make wave
int main () {
	int_setup(1, (int []) {199});

	HPS_TIM_config_t hps_tim;
	
	//initiallizing key variables
	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000000;
	hps_tim.LD_en = 0;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);

	double signal = 0;
    double t = 0;

    while(1) {
		if (hps_tim0_int_flag) {
			t++;
		}
		signal = make_wave(130.813, t, 100);
		audio_write_data_ASM(signal, signal);
	}
	return 0;
}
*/


//2 Control Waves
int main() {

	VGA_clear_pixelbuff_ASM();

	int_setup(3, (int []) {199,200, 201});		//setup array of int

	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 20.83;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);				//calling assembly code

	
	HPS_TIM_config_t hps_tim1;

	hps_tim1.tim = TIM1;
	hps_tim1.timeout = 100;
	hps_tim1.LD_en = 1;
	hps_tim1.INT_en = 1;
	hps_tim1.enable = 1;

	HPS_TIM_config_ASM(&hps_tim1);				//calling assembly code

	
	HPS_TIM_config_t hps_tim2;

	hps_tim2.tim = TIM2;
	hps_tim2.timeout = 20.83;
	hps_tim2.LD_en = 1;
	hps_tim2.INT_en = 1;
	hps_tim2.enable = 1;

	HPS_TIM_config_ASM(&hps_tim2);				//calling assembly code
	
	
	//All possible keys and char holding register data
	char *data;
	int a = 0;
	int s = 0;
	int d = 0;
	int f = 0;
	int j = 0;
	int k = 0;
	int l = 0;
	int semicolon = 0; 
	int v = 0;
	int h = 1;

	double signal = 0;
	int bCode = 0;
	double t = 0;
	int x = 0;
	int y =0;
	int pixelHeight[320];
	int vol =10;

	while (1) { 						//infinite loop to keep the program running 
		
		if ( hps_tim0_int_flag1) {		//using timer from assembly code
			hps_tim0_int_flag1 = 0;		//set flag to 0
			
			if (read_PS2_data_ASM(data)){	//reading register for keyboard data

				if (*data == 0x1C) {		//letter a is pressed
					if (bCode) {		//if its no longer pressed
						a = 0;
						bCode = 0;
					}
					else{
					a = 1;
					}			//key still being pressed
				}
				
				if (*data == 0x1B) {		//letter s is pressed
					if (bCode){			//if its no longer pressed
						s = 0;
						bCode = 0; 
					}
					else{
					s =1;
					}			//key still being pressed
				}
				
				if (*data == 0x23) {		//letter d is pressed
					if ( bCode){		//if its no longer pressed
						d = 0;
						bCode = 0;
					}
					 else {
					 d = 1;
					 }			//key still being pressed
				}

				if (*data == 0x2B) {		//letter f is pressed
					if ( bCode){		//if its no longer pressed
						f = 0;
						bCode = 0;
					}
					else{
					f =1;
					}			//key still being pressed
				}

				if (*data == 0x3B) {		//letter j is pressed
					if (bCode){			//if its no longer pressed
						j = 0;
						bCode = 0;
					}
					else{
					j =1;
					}			//key still being pressed
				}

				if (*data == 0x42) {		//letter k is pressed
					if(bCode) {			//if its no longer pressed
						k = 0;
						bCode = 0;
					}
					else{
					k =1;
					}			//key still being pressed
				}

				if (*data == 0x4B) {		//letter l is pressed
					if ( bCode) {		//if its no longer pressed
						l = 0;
						bCode = 0;
					}
					else{
					l = 1;
					}			//key still being pressed
				}
				
				if (*data == 0x4C) {		//key ;  is pressed
					if (bCode){			//if its no longer pressed
						semicolon = 0;
						bCode = 0;
					}
					else{
					semicolon = 1;
					}			//key still being pressed
				}

				if (*data == 0x3A) {		//letter m is pressed
					if (bCode){			//if its no longer pressed
						if(vol < 100){vol += 10;}		//increment vol when pressed
						bCode = 0;
					}
				}

				if (*data == 0x31) {		//letter n is pressed
					if (bCode){			//if its no longer pressed
						if (vol > 0){vol -= 10;}		//decrement vol once no longer pressed
						bCode = 0;
					}
				}

				if (*data == 0xF0) {		//if break code is read
					bCode = 1; 			//break code is true, key no longer pressed 
				}
			}	
		}

		
		signal = 0;

		//creating the signal using the make_wave method
		//each if add a note to the signal 
		if (a) {signal = signal + make_wave(130.813, t, vol);} //add lower C to wave
		if (s) {signal = signal + make_wave(146.832, t, vol);} //add D to wave
		if (d) {signal = signal + make_wave(164.814, t, vol);} //add E to wave
		if (f) {signal = signal + make_wave(174.614, t, vol);} //add F to wave
		if (j) {signal = signal + make_wave(196.000, t, vol);} //add G to wave
		if (k) {signal = signal + make_wave(220.000, t, vol);} //add A to wave
		if (l) {signal = signal + make_wave(246.942, t, vol);} //add B to wave
		if (semicolon) {signal = signal + make_wave(261.626, t, vol);} //add upper C to wave
	
		if( hps_tim0_int_flag) {
			if( audio_write_data_ASM(signal, signal));
			t++;
		}


		if (hps_tim0_int_flag2) {	//using timer from assembly code
			hps_tim0_int_flag2 = 0;

			if((int) (t/9) % 320 == x){
   				pixelHeight[x] =  (int)(signal/0x7fffff) +120; //align the signal properly
				VGA_draw_point_ASM(x, pixelHeight[x], 0xF800);//drawing current pixel in red
				VGA_draw_point_ASM(x+1, pixelHeight[x+1], 0); //next pixel is in black (cleared)
				x++;
				if (x == 320) {								//when we reach the end
					VGA_draw_point_ASM(0, pixelHeight[0], 0);//drawing nothing (black)
					x=0;
				}   
			}
		}
	}
return 0;
}