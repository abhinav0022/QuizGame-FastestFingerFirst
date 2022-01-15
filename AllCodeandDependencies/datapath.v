module datapath(tic,Acorrect,Bcorrect,Ccorrect,clock,reset,firstplayer,secondplayer,thirdplayer,time_PlayerA,
time_PlayerB,time_PlayerC,start,questionselected,playerabuzz,playerbbuzz,playercbuzz,game_over);

//ADD THIRD AND FOURTH PLAYER LATER
//FIRSTPLAYER IS OPTIONS
//QUESTION SELECTED IS THE QUESTION PATTERN SELECTED
//START IS GAME START
//player1buzz is the key from top module





 

input [3:0]firstplayer;//options
input [3:0]secondplayer;//options
input [7:0]thirdplayer;
reg [3:0]coptions;
//converting from keyboard to proper input 
always @(*)
 begin
 case (thirdplayer)
 8'h 1C: coptions=4'b0001;
 8'h 32: coptions=4'b0010;
 8'h 21: coptions=4'b0100;
 8'h 23: coptions=4'b1000;
default: coptions=4'b0000;
endcase
end 









input game_over;//comming from controller to display rankings 
input clock,start,reset;//start is comming from the controller to begin a new game


input tic;//comes every 1 millisecond from controller/top module

input[2:0] questionselected;//from control-determines which qs is selected

input playerabuzz,playerbbuzz;
input [7:0]playercbuzz;



output reg [25:0] time_PlayerA;//the time taken by each player
output reg [25:0] time_PlayerB;
output reg [25:0] time_PlayerC;




  

output reg  [2:0] Acorrect;//one bit wires to determine wether or not the player answered correctly 
output reg [2:0]Bcorrect;
output reg [2:0]Ccorrect;

reg [25:0]qa;//the time counting machinery
reg [25:0]qb;
reg [25:0] qc;


reg A_pressed;//signal the pressing of the buzzer-different from Abuzz and Bbuzz
reg B_pressed;
reg C_pressed;


//the correctoptions coding
reg [3:0]correctanswers;
always@(posedge clock)
begin
case(questionselected)//commimg from control deciding which answer is orrect for particular qs 
3'b000: correctanswers= 4'b0001;//answer to question 1 is option a(if question1)//one hot encoding intuitive 
 3'b001: correctanswers=4'b0010;//answer to question 2 is option b
 3'b010: correctanswers=4'b0100;//answer to question3 is option c
 3'b011: correctanswers=4'b1000;//answer to question4 is option d
 3'b100: correctanswers=4'b1000;//answer to question5 is also d
 
 default:correctanswers=4'b0000;//set default to 0
		
	
endcase
end


   
    
    // what is happening for evry question
    always@(posedge clock) begin
        if((!reset)  ) begin//this is manual reset after every question
            
				Acorrect<=3'b0;
				Bcorrect<=3'b0;
				Ccorrect<=3'b0;
				
				time_PlayerA<=25'b0;
				time_PlayerB<=25'b0;
				time_PlayerC<=25'b0;
				
				A_pressed<=1'b0;
		      B_pressed<=1'b0;
				C_pressed<=1'b0;
				
				qa<=0;
		      qb<=0;
				qc<=0;
				
				
        end

else begin//if not reset
           
			if(start)//game has begun reset all output signals-also reset after every question 
	         begin 
			
				Acorrect<=3'b0;
				Bcorrect<=3'b0; 
				Ccorrect<=3'b0;
				
				 
				time_PlayerA<=25'b0;
				time_PlayerB<=25'b0;
				time_PlayerC<=25'b0;
				
				
				
				A_pressed<=1'b0;
		      B_pressed<=1'b0;
				C_pressed<=1'b0;
				
				qa<=0;
		      qb<=0;
				qc<=0;
				
				
		      end
				
			
			
			else if(game_over)//controller signalled the end of game 
			     begin
				  //the logic to compute winner goes here-done in top level module 
			Acorrect<=3'b0;
				Bcorrect<=3'b0;
				Ccorrect<=3'b0;

				
				 
				time_PlayerA<=25'b0;
				time_PlayerB<=25'b0;
				time_PlayerC<=25'b0;
				
				
				
				A_pressed<=1'b0;
		      B_pressed<=1'b0;
				C_pressed<=1'b0;
				
				qa<=0;
		      qb<=0;
			    qc<=0;
			
			
			
			
			
			
			end
			
			
			
			else//game  not over yet, not new round so keep comp time and rankings 
			  begin
			  
			  //the timer logic
			  if(playerabuzz & playerbbuzz)//SEEMS LIKE nobody pressed
	     begin
		     if(A_pressed==0 &B_pressed==0 )//nobody pressed//
			     begin
				  //start counter for both players times
				  qa<=qa+1;
				  qb<=qb+1;
				  time_PlayerA<=qa;
				  time_PlayerB<=qb;
				  end
			 else if(A_pressed==1&B_pressed==0 )//A has already  given input B hasnt yet
			       begin
					 qb<=qb+1;//continue timer of B
					 time_PlayerB<=qb;
					 //do nothing with player a's time-taken care below
					 end
			else if(A_pressed==0 & B_pressed==1)//B gave input A didnt yet
      			begin
					  qa<=qa+1;
					 time_PlayerA<=qa;
					 end
			else if(B_pressed==1 & A_pressed==1)//both players have given inputs already and key debounced to 1
			       begin
					 qb<=0;//do nothing??
					 qa<=0;//dont increment counter keep time as it is to be stored in register
					 end
		 end
		else if(playerabuzz==0 & playerbbuzz==1)//THE VERY INSTANCE when  player A toggles his switch and B doesnt-sig delay
		      begin
			       if(A_pressed==0 &B_pressed==0)//first time input-ACCEPT-A pressing first B not pressed yet
			         begin
				      A_pressed<=1'b1;//make this one so it never enters loop again untill reset pressed
						qa<=0;//stop counter of A while result intact in register time_PlayerA
						qb<=qb+1;//keep counting B
						time_PlayerB<=qb;//assign and store time of B
						end
					 else if(A_pressed==0 & B_pressed==1)//B gave input, A is giving later-now
					      begin
							A_pressed<=1'b1;//make this one so it never enters loop again
					      qa<=0;//stop timer for A leave time_playerA intact
							//dont touch B
					      end
					else if(A_pressed==1 & B_pressed==0)//A has already given input trying again-dont accept!!-B not yet given
					     begin
						  qb<=qb+1;//increment time for qb
						  time_PlayerB<=qb;//store value in reg
						  //dont do anything with qa-already set to zeroor set to zero??
						  end
					else if (A_pressed==1 &B_pressed==1)//both player gave inputs-A trying again
				        begin
						  //do nothing ?? or set to zero??
						  end
		end
		else if(playerabuzz==1 & playerbbuzz==0)//player B had has pressed the buzzer
		       begin
			       if(A_pressed==0 &B_pressed==0)//first time input-ACCEPT-B A not pressed yet 
			         begin
				      B_pressed<=1'b1;//make this one so it never enters loop again untill reset pressed
						qb<=0;//stop counter of B while result intact in register time_PlayerB
						qa<=qa+1;//keep counting A
						time_PlayerA<=qa;//assign and store time of A
						end
					 else if(A_pressed==0 & B_pressed==1)//B gave input trying again!!, A not yet given
					      begin
							qa<=qa+1;//continue timer of A
					      time_PlayerA<=qa;//store value in register
							//dont touch B
					      end
					else if(A_pressed==1 & B_pressed==0)//A has already given input B is giving later-Now
					     begin
						  B_pressed<=1'b1;//so it never enters loop again 
						  qb<=0;//reset counter of B
						  //time stotrein in reg time_playerB
						  //dont touch A
						  end
					else if (A_pressed==1 &B_pressed==1)//both player gave inputs-B trying again
				        begin
						  //do nothing ?? or set to zero??
						  end
						  
			end
			
						  
	 else if (playerabuzz==0 & playerbbuzz==0)//both actually pressed together-is it even possible??
	        
			  //really difficult for two player to synchronise inputs with the same positive clock edge
			  
			  begin
			       if(A_pressed==0 &B_pressed==0)//first time input-accept for both A and B
			         begin
				      B_pressed<=1'b1;//make this one so it never enters loop again untill reset pressed
						qb<=0;//stop counter of B while result intact in register time_PlayerB
						A_pressed<=1'b1;//A has also pressed
						qa<=0;//set counter of A to zero
						end
					 else if(A_pressed==0 & B_pressed==1)//B gave input trying again!!, A not yet given
					      begin
							A_pressed<=1'b1;//so it never enters loop again 
							qa<=0;//stop timer of A now
					      
							//dont touch B
					      end
					else if(A_pressed==1 & B_pressed==0)//A has already given input trying again!B giving Now!!
					     begin
						  B_pressed<=1'b1;//so it never enters loop again 
						  qb<=0;//reset counter of B
						  //time stotrein in reg time_playerB
						  //dont touch A
						  end
					else if (A_pressed==1 &B_pressed==1)//both player gave inputs-B again trying again at same time !!
				        begin
						  //do nothing ?? or set to zero??
						  end
			  
					end
					
					//just trying the player C logic separately 
					if(playercbuzz==0)//if keyboard is  not pressed 
					  begin
					   if(C_pressed==0)
						   begin 
							qc<=qc+1;
							time_PlayerC<=qc;
							end
						else begin //if player already given  dont do anything 
					        end
						end
					else if(playercbuzz>8'h1)
					      begin
							if(C_pressed==0)//giving input first time 
							begin 
							qc<=0;//reset the timer store result in reg time_playerc
							C_pressed<=1'b1;
							end
							else
							begin
							end
						end
						
					
						
							
							
					  
					
				 
			  
		//now checked the timing for all players
      //output to top level-time if player is correct
      if(A_pressed &B_pressed)//both players have pressed their buzzers
	      begin
		     if(firstplayer==correctanswers)//check correct answer of player
			     begin
				  Acorrect<=3'b001;//SEND THIS TO top module sayinmg that player is correct for this answer
				
				  end
				if(secondplayer==correctanswers)
				  begin
				  Bcorrect<=3'b001;
				
			     end
				  
			end
	  if(C_pressed)
	     begin 
		     if(coptions==correctanswers)
			 begin
			Ccorrect<=3'b001;
		    end
			 
			  
        end
		  
		  
		  
		  
		  
		  
		  
		  
		  
	end 	  
		  
    end
	 

end	 
	 
endmodule
