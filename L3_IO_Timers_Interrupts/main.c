#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/)_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"

int main(){

/*
	//Question 1
	while(1){
		write_LEDs_ASM(read_slider_switches_ASM());
	}
*/


/*
	//Question 2
	//Note: some residual segments of the 7-segment display light up when they shouldn't. Other than that this code works.
	int lastFourBits = 15;	

	while(1){
		int sliderValue = read_slider_switches_ASM();
		write_LEDs_ASM(sliderValue);
		int SW9 = 512;
		if (SW9 & sliderValue) { //so as to isolate the bit for SW9 only
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
		} else {
			char numWrite =  lastFourBits & sliderValue; //isolate SW0-SW3
			int pb = lastFourBits & read_PB_data_ASM();
			HEX_write_ASM(pb, numWrite); //Write specified value in specified location
		}
	}
*/
	
/*
	//Question 3
	//Initialize timer parameters
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 0;
	hps_tim.enable = 1;
	HPS_TIM_config_ASM(&hps_tim); //Config timer 1
	//Initialize second timer parameters
	HPS_TIM_config_t hps_tim_pb;
	hps_tim_pb.tim = TIM1;
	hps_tim_pb.timeout = 5000;
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 0;
	hps_tim_pb.enable = 1;
	HPS_TIM_config_ASM(&hps_tim_pb); //config timer 2
	int push_buttons = 0;
	int ms_count = 0;
	int sec_count = 0;
	int min_count = 0;
	int timer_start = 0; //Bit that holds whether time is running
	while(1) {
		if (HPS_TIM_read_ASM(TIM0) && timer_start) {
			HPS_TIM_clear_INT_ASM(TIM0);
			ms_count += 1000; //Timer is for 10 milliseconds
			//Ensure ms, sec and min are within their ranges
			if (ms_count >= 100000) {
				ms_count -= 100000;
				sec_count++;
				
				//resetting when the timer reaches 60
				if (sec_count >= 60) {
					sec_count -= 60;
					min_count++;
					if (min_count >= 60) {
						min_count = 0;
					}
				}
			}
			//Get corresponding digit and convert to ASCII
			HEX_write_ASM(HEX0, (ms_count % 100));
			HEX_write_ASM(HEX1, (ms_count / 100));
			HEX_write_ASM(HEX2, (sec_count % 10));
			HEX_write_ASM(HEX3, (sec_count / 10));
			HEX_write_ASM(HEX4, (min_count % 10));
			HEX_write_ASM(HEX5, (min_count / 10));
		}
		//Timer to read push buttons
		if (HPS_TIM_read_ASM(TIM1)) { 
			HPS_TIM_clear_INT_ASM(TIM1);
			int pb = 0xF & read_PB_data_ASM();
			if ((pb & 1) && (!timer_start)) { //Start timer
				timer_start = 1;
			} else if ((pb & 2) && (timer_start)) { //Stop timer
				timer_start = 0;
			} else if (pb & 4) { //Reset timer
				ms_count = 0;
				sec_count = 0;
				min_count = 0;
				timer_start = 0; //Stop timer
				
				//Set every number to 0
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 48);
			}
		}
	}
*/

	/*
	//Question 4
	


	*/


	return 0;
}
