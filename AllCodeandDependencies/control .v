module control(rankdisplay,go,ld_A_QS1,ld_A_QS2,ld_A_QS3,ld_A_QS4,ld_A_QS5,ld_B_QS1,ld_B_QS2,ld_B_QS3,ld_B_QS4,ld_B_QS5,
 ld_C_QS1,ld_C_QS2,ld_C_QS3,ld_C_QS4,ld_C_QS5,
cctenable,clk,ld_r,reset,gamestart,displayrankings,ld_game,question_selection,endgame);

//gamestart is switch 9

//displayrankings is sw8

//a total of 10 load signals for the registers
output reg ld_A_QS1,ld_A_QS2,ld_A_QS3,ld_A_QS4,ld_A_QS5,ld_B_QS1,ld_B_QS2,ld_B_QS3,ld_B_QS4,ld_B_QS5;
output reg  ld_C_QS1,ld_C_QS2,ld_C_QS3,ld_C_QS4,ld_C_QS5;

output reg  go;//to the VGA 
output reg rankdisplay;//to VGA

input clk,reset,gamestart,displayrankings; 
//output to the VGA need to fill this
//output to the datapath
reg [5:0] current_state;
reg [5:0]next_state;
output reg ld_game;//going to the datapath
output reg [2:0] question_selection;
//output reg ld_time_A;//the load signal for the register
//output reg ld_time_B;//the load signal for time registerB
//output reg mux_selectA;//select signal for mux on top of A register
output reg ld_r;//load signal for results register
//output reg  mux_selectB;
output reg cctenable;
output reg  endgame;//to datapath to stop comparing ans and compute the avg time 
localparam      S_GAME_IDLE    = 5'd0,
              
                S_GAME_QUESTION1 = 5'd1,
					 S_GAME_QUESTION1_WAIT=5'd2,
                S_GAME_QUESTION2 = 5'd3,
					 S_GAME_QUESTION2_WAIT=5'd4,
                S_GAME_QUESTION3 = 5'd5,
					 S_GAME_QUESTION3_WAIT=5'd6,
                S_GAME_QUESTION4 = 5'd7,
					 S_GAME_QUESTION4_WAIT=5'd8,
                S_GAME_QUESTION5 = 5'd9,
					 S_GAME_QUESTION5_WAIT=5'd10,
                S_GAME_RANKING      = 5'd11;
					
					 
 // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_GAME_IDLE: next_state = gamestart ? S_GAME_QUESTION1 : S_GAME_IDLE; // Loop in current state until value is input
               
                 S_GAME_QUESTION1: next_state = gamestart ?  S_GAME_QUESTION1:S_GAME_QUESTION1_WAIT; // Loop in current state until value is input
                 
					  S_GAME_QUESTION1_WAIT:next_state = gamestart ?  S_GAME_QUESTION2:S_GAME_QUESTION1_WAIT;
					  
					  
					  
					  
					S_GAME_QUESTION2: next_state = gamestart ?   S_GAME_QUESTION2:S_GAME_QUESTION2_WAIT; // Loop in current state until go signal goes low
                
					S_GAME_QUESTION2_WAIT:next_state = gamestart ?  S_GAME_QUESTION3:S_GAME_QUESTION2_WAIT; 
					 
					 
					 S_GAME_QUESTION3: next_state = gamestart ? S_GAME_QUESTION3 : S_GAME_QUESTION3_WAIT; // Loop in current state until value is input
                
					 S_GAME_QUESTION3_WAIT: next_state = gamestart ? S_GAME_QUESTION4 : S_GAME_QUESTION3_WAIT;
					 S_GAME_QUESTION4: next_state = gamestart ? S_GAME_QUESTION4 : S_GAME_QUESTION4_WAIT; // Loop in current state until go signal goes low
                S_GAME_QUESTION4_WAIT:next_state=gamestart?S_GAME_QUESTION5:S_GAME_QUESTION4_WAIT;
					
					 
					 S_GAME_QUESTION5:next_state=gamestart? S_GAME_QUESTION5:S_GAME_QUESTION5_WAIT;
					 
					 S_GAME_QUESTION5_WAIT: begin
					 if(gamestart==0)
					   next_state=S_GAME_QUESTION5_WAIT;
					 else 
					   next_state=S_GAME_RANKING;
					 
					  
					end
                
					 S_GAME_RANKING: begin
					 if(displayrankings)
					   next_state=S_GAME_RANKING;
						else
						next_state=S_GAME_IDLE;
					 
					 
					 
					 end
					 default:     next_state = S_GAME_IDLE;
        endcase
    end // state_table
               
               
// Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        // This is a different style from using a default statement.
        // It makes the code easier to read.  If you add other out
        // signals be sure to assign a default value for them here.
        ld_game = 1'b0;
		  question_selection=3'b111;//noe of the questions are slected //game not started yet
        endgame=1'b0;
//		  ld_time_A=1'b1;//always load the shift registere??
//		  ld_time_B=1'b1;
//		  mux_selectA=1'b0;
//		  mux_selectB=1'b0;
         ld_A_QS1=1'b0;
			ld_A_QS2=1'b0;
			ld_A_QS3=1'b0;
			ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
         ld_r=1'b0;
			go=0;
			rankdisplay=0;

		  
		  //set the vga oputputs here 

        case (current_state)
            S_GAME_IDLE: begin
				    ld_game=1'b1;//signal to datapath for beginning of a game 
                //DO NOTHING
					 //CALL THE DISPLAY SIGNAL FOR BASIC FIRST DISPLAY WHEN GAME OPENS
					 go=0;
					 
					 
					 
					 
					 //also reset the counter
//				    ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b0;//select the time from datapath
//				    mux_selectB=1'b0;
				    ld_r=1'b1;
				    cctenable=1'b0;
					 ld_A_QS1=1'b0;
			ld_A_QS2=1'b0;
			ld_A_QS3=1'b0;
			ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
				
                end
            S_GAME_QUESTION1: begin
                //CALL THE VGA FOR FIRST QUESTION DISPLAY
					 question_selection=3'b000;
					 ld_game=1'b0;//dont reset the data path game happening
					
//				     ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b0;//select the time from datapath
//				  mux_selectB=1'b0;
				  ld_A_QS1=1'b1;
				  ld_B_QS1=1'b1;
				  
				  
				  ld_A_QS2=1'b0;
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b1;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
				 
				//ld_r=1'b1;
				//signal to click tic to begin counting time in milliseconds
				cctenable=1'b1; //qs 1 is displayed
				go=1'b1; 
				
				
				end
		      S_GAME_QUESTION1_WAIT:begin
				    question_selection=3'b000;
					 ld_game=1'b1;//reset the datapath for the next question 
//					
//				     ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b1;//select the time from alu
//				  mux_selectB=1'b1;
//				 
				//ld_r=1'b1;
				//now stop timer for that question 
				cctenable=1'b0;
				ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
			go=1'b1;	 

		
					
                end
            S_GAME_QUESTION2: begin
                //CALL VGA FOR DISPLAY 1 QUESTION 
					  question_selection=3'b001;//just select a question so correct ans is known 
                ld_game=1'b0;//reset the datapath for next question  
//					  ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b0;//select the time from datapath
//				  mux_selectB=1'b0;
				 //ld_r=1'b1;
				 
				 ld_A_QS1=1'b0;
				  ld_A_QS2=1'b1;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b1;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b1;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
				 
				go=1'b0; 
				 
				 
				 
					 
				cctenable=1'b1;//begin timer for qs 2
				
					 
					 
					 end
           
			 S_GAME_QUESTION2_WAIT:begin
				    question_selection=3'b001;
					 ld_game=1'b1;//reset the datapath for the next question 
//
//				     ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b1;//select the time from alu
//				  mux_selectB=1'b1;
				 //ld_r=1'b1;
		        cctenable=1'b0;
				  go=1'b0;
				  
				  
				  
				  
				  
				  ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
				 
					
                end
			
		
	
         	S_GAME_QUESTION3: begin
                //CALL VGA TO DISPLAY 2 QUESTION 
					  question_selection=3'b010;
					  ld_game=1'b0;
//					   ld_game=1'b0;//reset the datapath for next question  
//					  ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b0;//select the time from datapath
//				  mux_selectB=1'b0;
				 
				//ld_r=1'b1;
				cctenable=1'b1;
				
				ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b1;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b1;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b1;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
			go=1'b1;	
				
				
				
				
				
				
				
                end
            
				S_GAME_QUESTION3_WAIT:begin
				    question_selection=3'b010;
					 ld_game=1'b1;//reset the datapath for the next question 
//                 ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b1;//select the time from alu
//				  mux_selectB=1'b1;
//		        ld_r=1'b1;
					cctenable=1'b0;
					
					ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
			go=1'b1;	 
					
					
					
					
					
					
					
					
                end
				
				
				
				S_GAME_QUESTION4: begin 
               //CALL VGA TO DISPLAY QS 3 
					 question_selection=3'b011;
					 ld_game=1'b0;
//					  ld_game=1'b0;//reset the datapath for next question  
//					  ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b0;//select the time from datapath
//				  mux_selectB=1'b0;
//				  ld_r=1'b1;
				  cctenable=1'b1;
				  
				 ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b1;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b1;
			ld_B_QS5=1'b0;
		ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b1;
			ld_C_QS5=1'b0;	
			go=1'b0;	  
				  
				  
				  
				  
				  
				
            end
            
				S_GAME_QUESTION4_WAIT:begin
				    question_selection=3'b011;
					 ld_game=1'b1;//reset the datapath for the next question 
//                 ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b1;//select the time from alu
//				  mux_selectB=1'b1;
		         //ld_r=1'b1;
					
					
					go=1'b0;
					
					
					
					ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
				 
					cctenable=1'b0;
                end
				
				
				
				
				
				S_GAME_QUESTION5: begin 
				//CALL VGA TO DISPLAY QS 4
			   question_selection=3'b100;	
				ld_game=1'b0;
				 ld_game=1'b0;//reset the datapath for next question  
//					  ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b0;//select the time from datapath
//				  mux_selectB=1'b0;
//				  ld_r=1'b1;
				cctenable=1'b1;
				ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b1;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b1;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b1;
				
				go=1'b1;
				
				
				
				
				
				end
				
				
				S_GAME_QUESTION5_WAIT:begin
				    question_selection=3'b100;
					 ld_game=1'b1;//reset the datapath for the next question 
//                 ld_time_A=1'b1;//load time comming from datapath
//				    ld_time_B=1'b1;
//				    mux_selectA=1'b1;//select the time from alu
//				  mux_selectB=1'b1;
//				  ld_r=1'b1;
		cctenable=1'b0;
		go=1'b1;
		
		
		
		
		
		ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
				 
					
                end
				
				
				S_GAME_RANKING: begin
			   //call to topmodule to stop comparing and display results on VGA
				endgame=1'b1;
				ld_r=1'b1;//only load results register at end of game 
				cctenable=1'b0;
				
				
				ld_A_QS1=1'b0;
				  ld_A_QS2=1'b0;
				  
			     ld_A_QS3=1'b0;
			     ld_A_QS4=1'b0;
			ld_A_QS5=1'b0;
			 
			 ld_B_QS1=1'b0;
			ld_B_QS2=1'b0;
			ld_B_QS3=1'b0;
			ld_B_QS4=1'b0;
			ld_B_QS5=1'b0;
			ld_C_QS1=1'b0;
			ld_C_QS2 =1'b0;
			ld_C_QS3=1'b0;
			ld_C_QS4 =1'b0;
			ld_C_QS5=1'b0;
			rankdisplay=1'b1;
				 
				
				
				end
				
				
				
				
				
				// default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!reset)//active low 
            current_state <= S_GAME_IDLE;
        else
            current_state <= next_state;
    end // state_FFS
endmodule