
module Fastestfingerfirst( SW ,KEY,CLOCK_50,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,PS2_CLK,PS2_DAT,VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B )  						//	VGA Blue[9:0])
;

//All input and output ports
       input [9:0]SW;
       input[3:0]KEY;
       input CLOCK_50;
       output [6:0]HEX0;
		 output [6:0]HEX1;
		 output [6:0]HEX2;
		 output [6:0]HEX3;
		 output [6:0]HEX4;
		 output [6:0]HEX5;
		 output [6:0]HEX6;
       output [9:0]LEDR;
		
	
//All wires and registers

	
		 wire govga;
		 reg [23:0] colour;
	    reg [8:0] x;
	    reg[7:0] y;
	    wire writeEn;
		 wire [3:0]playerAanswer;//options of player a on switch
		 wire [3:0]playerBanswer;//options of player b on switch 
		 wire [7:0]playerCanswer;//options of player C-7 bit wide comming from the controller 
		 wire clock;//clock_50
		 
		 wire ldA;//load signal for reg A to store time from control 
		 wire ldB;//load signal
		 wire ldC;
		 wire ldR;
		 wire Abuzzer;//key pressed by player
		 wire Bbuzzer;//key pressed by player
		 wire [7:0]Cbuzzer;
		 wire game_start;//switch 9
		 wire ranking_display;//SW[8]
		 wire resetgame;//for controller
		 
		 
		 
		 //10 wires or load signals from controller
		 wire ldAQS1,ldAQS2,ldAQS3,ldAQS4,ldAQS5,ldBQS1,ldBQS2,ldBQS3,ldBQS4,ldBQS5;
		 wire ldCQS1,ldCQS2,ldCQS3,ldCQS4,ldCQS5;
		 //registers storing the time taken by the players 
		 reg [25:0]timeA1;
		 reg [25:0]timeA2;
		 reg [25:0]timeA3;
		 reg [25:0]timeA4;
		 reg [25:0]timeA5;
		 reg [25:0]timeB1;
		 reg [25:0]timeB2;
		 reg [25:0]timeB3;
		 reg [25:0]timeB4;
		 reg [25:0]timeB5;
		 reg [25:0]timeB6;
		 reg [25:0]timeC1;
		 reg [25:0]timeC2;
		 reg [25:0]timeC3;
		 reg [25:0]timeC4;
		 reg [25:0]timeC5;
		  
		  // Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
		  
	  
		vga_adapter VGA(
			.resetn(resetgame),
			.clock(CLOCK_50),
		.colour(colour),
		.x(x),
			.y(y),
			.plot(writeEn),
			
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
			
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 8;
		defparam VGA.BACKGROUND_IMAGE = "Front5";
		  
		  
		wire [1:0]select;
	
	
wire load_First;
	wire  load_Black;
wire [23:0] colorF;
	wire [23:0] colorS;
	wire [8:0] xF;
	wire [7:0] yF;
	wire [8:0] xS;
	wire [7:0] yS;
	wire [7:0] yB;
	wire [8:0] xB;
	wire [23:0] colorB;
	
	
	wire[25:0] main;
	controlPath u0 (.counter(main),.enable(writeEn), .clock(CLOCK_50), 
	.go(govga), .resetn(resetgame), .ld_first(load_First),
	 .ld_black(load_Black),.combination(select));
	
	
	dataPath u1 (.counterF(main),.clock(CLOCK_50), .go(change), .resetn(resetgame), .ld_first(load_First), .ld_black(load_Black),
				    .x_outF(xF),  .y_outF(yF),  .color_outF(colorF),  .x_outB(xB), .y_outB(yB), .color_outB(colorB));
	
	
	always@(CLOCK_50)
	begin
	case(select)
	 2'b00:begin
	      //DISPLAY BKG IMAGE
			 end
	 2'b01:begin
	       x=xF;
			 y=yF;
			 colour=colorF;
			 end
	 2'b10:begin
	       x=xB;
			 y=yB;
			 colour=colorB;
			 end
	default:begin
			//DISPLAY BKG IMAGE
			 end
	endcase
	end	
		  
		  
		  
		  
		  
		  //similarly registers to store correct answers of players 
		 reg correctA1;
		 reg correctA2;
		 reg correctA3;
		 reg correctA4;
		 reg correctA5;
		 reg correctB1;
		 reg correctB2;
		 reg correctB3;
		 reg correctB4;
		 reg correctB5;
		  reg correctc1;
		 reg correctc2;
		 reg correctc3;
		 reg correctc4;
		 reg correctc5;
		 
		 
		 
		 
		inout PS2_CLK;
	    
		 inout PS2_DAT;
		 wire		[7:0]	ps2_key_data;
       wire				ps2_key_pressed;
		 reg [7:0] last_data_received;
		 
		 always@(posedge CLOCK_50)
		 begin 
		 if(KEY[0]==1'b0)
		   last_data_received<=8'h00;
			else if(ps2_key_pressed==1'b1)
			     last_data_received<=ps2_key_data;
		end 
		
		 PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 reg assignedrankA;//variable that says rank has been assigned dont enter again
		 reg assignedrankB;
		 reg assignedrankC;
		 
		 wire[25:0]timeA;//comming from datapath-can contain time for different qs 
		 wire[25:0]timeB;//comminf from datapath
		 wire [25:0]timeC;
		 reg [25:0]data_resultA;//storing the total time 
		
		 
		 reg [25:0]data_resultPlayerB;
		  reg [25:0] data_resultC;                           //storing total time of B
		 reg [2:0]data_correctA;//register storing the count of player a'scorrect answers
		 reg [2:0]data_correctB;
		 reg [2:0]data_correctC;
		 
		 
		 
		 
		 
		 wire [2:0]playerAtrack;
		 wire [2:0]playerBtrack;
		 wire [2:0]playerCtrack;
		  
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 reg [2:0]correct_counterA;
		 reg [2:0] correct_counterB;
		 reg [2:0]correct_counterC;
		 //internal wires
		 
		 wire begingame;//from controller to datapath
		 wire gameover;//from controller to top level module 
		 
		 wire [2:0]questions_selected;//the current questionselected controller to datapath
		 
		 wire enableforclock;
		 reg PlayerArank;
		 reg PlayerBrank;
		 reg PlayerCrank;
		 

		 
		 assign playerAanswer=SW[3:0];
		 assign playerBanswer=SW[7:4];
		 assign playerCanswer=last_data_received[7:0];
		 assign resetgame=KEY[0];//reset for the controller
		
		 assign Abuzzer=KEY[1];
		 assign Bbuzzer=KEY[2];
		 assign Cbuzzer=ps2_key_data[7:0];//from the keyboard-input third player 
		 
		 
		 assign game_start=~KEY[3];
		 assign ranking_display=SW[8];
		 
		 
		 

datapath mydata(.clock(CLOCK_50),.Acorrect(playerAtrack),.Bcorrect(playerBtrack),.Ccorrect(playerCtrack),
                 .tic(tictic),
                .reset(resetgame),.firstplayer(playerAanswer),.secondplayer(playerBanswer),.thirdplayer(playerCanswer),
					 .time_PlayerA(timeA),.time_PlayerB(timeB),.time_PlayerC(timeC),.start(begingame),
					 .questionselected(questions_selected),.playerabuzz(Abuzzer),.playerbbuzz(Bbuzzer),.playercbuzz(Cbuzzer),
					 .game_over(gameover));
					 
					 
control mycontrol(.go(govga),.cctenable(enableforclock),.clk(CLOCK_50),.reset(resetgame),.gamestart(game_start),.displayrankings(ranking_display),
                 .ld_game(begingame),.question_selection(questions_selected),.endgame(gameover),.ld_r(ldR),
						
						.ld_A_QS1(ldAQS1),
						.ld_A_QS2(ldAQS2),
						.ld_A_QS3(ldAQS3),
						.ld_A_QS4(ldAQS4),
						.ld_A_QS5(ldAQS5),
						.ld_B_QS1(ldBQS1),
						.ld_B_QS2(ldBQS2),
						.ld_B_QS3(ldBQS3),
						.ld_B_QS4(ldBQS4),
						.ld_B_QS5(ldBQS5),
						.ld_C_QS1(ldCQS1),
						.ld_C_QS2(ldCQS2),
						.ld_C_QS3(ldCQS3),
						.ld_C_QS4(ldCQS4),
						.ld_C_QS5(ldCQS5)
						
						
						
					);
						
//compute rankings 
//this is the time register for both players for all the questions s
 always@(posedge CLOCK_50) begin
        if(!resetgame) begin
           
				correct_counterA<=3'b000;
				correct_counterB<=3'b000;
				
				
				timeA1<=25'b0;
		 timeA2<=25'b0;
		 timeA3<=25'b0;
		 timeA4<=25'b0;
		 timeA5<=25'b0;
		 timeB1<=25'b0;
	     timeB2<=25'b0;
		 timeB3<=25'b0;
		timeB4<=25'b0;
		 timeB5<=25'b0;
		 timeB6<=25'b0;
		 correctA1<=1'b0;
		  correctA2<=1'b0;
		   correctA3<=1'b0;
			 correctA4<=1'b0;
			  correctA5<=1'b0;
			   correctB1<=1'b0;
				correctB2<=1'b0;
		  correctB3<=1'b0;
		   correctB4<=1'b0;
			 correctB5<=1'b0;
			 
			  timeC1<=25'b0;
			   timeC2<=25'b0;
				 timeC3<=25'b0;
				  timeC4<=25'b0;
				   timeC5<=25'b0;
					
					
					
					
					 correctc1<=1'b0;
				correctc2<=1'b0;
		  correctc3<=1'b0;
		   correctc4<=1'b0;
			 correctc5<=1'b0;
			
		 
				
				
				
			 end
        else begin
            if(ldAQS1)
                begin
	          timeA1<=timeA	;
		       correctA1<=playerAtrack;		 
				   end
				if(ldAQS2)
                begin
	          timeA2<=timeA	;	
			correctA2<=playerAtrack;	 
				   end	
					
					
			if(ldAQS3)
                begin
	          timeA3<=timeA	;
		correctA3<=playerAtrack;		 
				   end
			if(ldAQS4)
                begin
	          timeA4<=timeA	;
		correctA4<=playerAtrack;		 
				   end
			if(ldAQS5)
                begin
	          timeA5<=timeA;	
		correctA5<=playerAtrack;		 
				   end
			
			if(ldBQS1)
                begin
	          timeB1<=timeB;
	correctB1<=playerBtrack;			 
				   end
			if(ldBQS2)
                begin
	          timeB2<=timeB;
	correctB2<=playerBtrack;			 
				   end
			if(ldBQS3)
                begin
	          timeB3<=timeB;
		correctB3<=playerBtrack;		 
				   end
			if(ldBQS4)
                begin
	          timeB4<=timeB;
	correctB4<=playerBtrack;			 
				   end
					
					
			if(ldBQS5)
                begin
	          timeB5<=timeB;
		correctB5<=playerBtrack;		 
				   end
					
			
			if(ldCQS1)
                begin
	          timeC1<=timeC;
		correctc1<=playerCtrack;		 
				   end
			if(ldCQS2)
                begin
	          timeC2<=timeC;
		correctc2<=playerCtrack;		 
				   end
			if(ldCQS3)
                begin
	          timeC3<=timeC;
		correctc3<=playerCtrack;		 
				   end
			if(ldCQS4)
                begin
	          timeC5<=timeC;
		correctc4<=playerCtrack;		 
				   end
			if(ldCQS5)
                begin
	          timeC5<=timeC;
		correctc5<=playerCtrack;		 
				   end		
					
					
					
					
end
end


	 
	// The ALU 
    always @(*)
    begin : ALU
        // alu
      
	
     data_resultA=timeA1+timeA2+timeA3+timeA4+timeA5;
	  data_resultPlayerB=timeB1+timeB2+timeB3+timeB4+timeB5;
	  data_correctA=correctA1+correctA2+correctA3+correctA4+correctA5;
	  data_correctB=correctB1+correctB2+correctB3+correctB4+correctB5;
	  data_resultC=timeC1+timeC2+timeC3+timeC4+timeC5;
 	   data_correctC=	correctc1+correctc2+correctc3+correctc4+correctc5;	
					
		end
 



//final results computation logic 
always@( *)
   
   begin
	if(!resetgame)
	  begin
	            PlayerArank<=1'b0;
	            PlayerBrank<=1'b0;
					assignedrankA<=1'b0;
				   assignedrankB<=1'b0;
					 PlayerCrank<=0;
	            assignedrankC<=0;
					
					
					end
	else
begin	
	if(gameover)//only whwen controlled signals end of game compare
	
	
         begin
	    if(assignedrankA==1'b0 & assignedrankB==1'b0 )
		 begin
             if(data_correctA<data_correctB)//b answwered more questions correctly 
				   begin
					PlayerArank<=1'b0;
					PlayerBrank<=1'b1;
					assignedrankA<=1'b1;
					assignedrankB<=1'b1;
					end
				else if(data_correctA>data_correctB)
				    begin
					PlayerArank<=1'b1;
					PlayerBrank<=1'b0;
					assignedrankA<=1'b1;
					assignedrankB<=1'b1;
					end
				else
			      begin 	
				 
				 
				 
				 
				 
				 
				 
	               if(data_resultA<data_resultPlayerB)//player A took less time to answer
	                  begin
	                       PlayerArank<=1'b1;
	                        PlayerBrank<=1'b0;
									assignedrankA<=1'b1;
				               assignedrankB<=1'b1;
					
	                   end
	              else if (data_resultA>data_resultPlayerB)//in case player B took more time to answer 
                       begin
	                    PlayerArank<=1'b0;
	                   PlayerBrank<=1'b1;
							 assignedrankA<=1'b1;
				          assignedrankB<=1'b1;
					 
	                    end
	              else
	                    begin
	                    PlayerArank<=1'b0;
	                    PlayerBrank<=1'b0;
							  assignedrankA<=1'b1;
				          assignedrankB<=1'b1;
							  
	                     end
	
	           end
	   
		end
		if(assignedrankC==0 &&assignedrankB==1 && assignedrankA==1)// a and B rank assignement done 
	             begin
		              if(PlayerArank==1'b1)
		               begin
			              if(data_correctC>data_correctA)
			                 begin
				                 PlayerCrank<=1;
				                 assignedrankC<=1;
									  PlayerArank<=0;//overwrite the rank of player A
				                end
			           else if(data_correctC<data_correctA)
			                  begin
			                  PlayerCrank<=0;
			                  assignedrankC<=1;//dont overwrite 
			                   end
			           else//if both C and A answered the same no of qs correctly
			              begin
			                 if(data_resultC<data_resultA)//case where C took less time to answer 
			                  begin 
			                  PlayerCrank<=1'b1;
			                   assignedrankC<=1;
									 PlayerArank<=0;
			                  end
			                else if (data_resultC>data_resultA)
	                          begin
			                    PlayerCrank<=0;
			                    assignedrankC<=1;//dont overwrite
			                     end 
			                 else
                             begin
	                           end
	                     end
	                end
					 
                else if (PlayerBrank==1'b1)
                         begin
			                  if(data_correctC>data_correctB)
			                    begin
				                 PlayerCrank<=1;
				                 assignedrankC<=1;
									  PlayerBrank<=0;
				                  end
			                  else if(data_correctC<data_correctB)
			                       begin
			                       PlayerCrank<=0;
			                       assignedrankC<=1;
			                       end
			                   else//if both C and A answered the same no of qs correctly
			                      begin
			                       if(data_resultC<data_resultPlayerB)//case where C took less time to answer 
			                        begin 
			                         PlayerCrank<=1'b1;
			                         assignedrankC<=1;
											 PlayerBrank<=0;
			                         end
			                      else if (data_resultC>data_resultPlayerB)
	                                     begin
			                                PlayerCrank<=0;
			                                assignedrankC<=1;
			                                  end
			                        else
                                        begin
	                                      end
	     
		  
		                 end
               end
		
else //case where none of the players A or B are assigned a rank of 1 
begin













if (data_correctC>data_correctA &data_correctC>data_correctB)
    begin
	 PlayerCrank<=1'b1;
	 assignedrankC<=1'b1;
	 PlayerArank<=1'b0;
	 PlayerBrank<=1'b0;
	 assignedrankA<=1'b1;
	 assignedrankB<=1'b1;
	 end
else if(data_resultC<data_resultPlayerB & data_resultC<data_resultA)
     begin
	  PlayerCrank<=1'b1;
	  assignedrankC<=1'b1;
	   PlayerArank<=1'b0;
	 PlayerBrank<=1'b0;
	 assignedrankA<=1'b1;
	 assignedrankB<=1'b1;
	  end
	  
else
begin 
PlayerCrank<=1'b0;
assignedrankC<=1'b1;
end

end



	
end
		
		
		
		
		
		
		end
		
	
     end
	
	end
	
	   








	
	
	
	
assign LEDR[0]=PlayerArank;

assign LEDR[1]=PlayerBrank;
assign LEDR[2]=PlayerCrank;

assign LEDR[5]=questions_selected[0];//for debugging 
assign LEDR[6]=questions_selected[1];
assign LEDR[7]=questions_selected[2];

//assign LEDR[8]=Cbuzzer;
assign LEDR[9]=assignedrankB;
reg [3:0]display1;
reg[3:0]display2;
reg [3:0] display3;
always@(posedge CLOCK_50)
begin

if(!resetgame)
begin
display1<=0;
display2<=0;
display3<=0;
end 
else 
begin 
if(gameover)
begin
if(PlayerArank==1'b1&PlayerBrank==0 &PlayerCrank==0)
   display1=4'b0001;
else if(PlayerBrank==1'b1 &PlayerArank==0& PlayerCrank==0)
    display2=4'b0001;
else if(PlayerCrank==1 && PlayerBrank==0 &PlayerArank==0) 
display3=4'b0001;

else
begin
display1=4'b0000;
display2=4'b0000;
display3=4'b0000;
end
end
end 
end


hex_decoder hexdisplay1(.hex_digit(display1),.segments(HEX0));//displays rank of player one -time for debugging 
hex_decoder hexdisplay2(.hex_digit(display2),.segments(HEX1));//displays rank of player 2
hex_decoder d1(.hex_digit(display3),.segments(HEX3));


endmodule
module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule



































//control path
module controlPath( counter,clock,go, resetn, enable, ld_first, ld_black,combination);
	input [25:0] counter;
	input clock;
	input go;
	input resetn;
	output reg enable;
	reg [3:0]next_state;
	reg [3:0]current_state;
	output reg [1:0]combination;
	output reg ld_first;
	
	output reg ld_black;
	
	 parameter Background_pixels = 76800;
	


localparam BKG_IMAGE =3'd0,
			  DISP_Q1   =3'd1,
			  ERASE_Q1  =3'd2,
			  S_DONE    =3'd4;

	
	always@(*)
	begin: state_table
		case(current_state)
			BKG_IMAGE: next_state=go?DISP_Q1:BKG_IMAGE;
			
			DISP_Q1:begin
			      if(counter>18'b10010110000000000)//means finished counting 
					   begin
						if(go)next_state=ERASE_Q1;
						else  next_state=DISP_Q1;
						end
					else 
					  next_state=DISP_Q1;
			     end
				  
			ERASE_Q1: next_state = go?S_DONE:ERASE_Q1;
		   S_DONE: next_state = go?S_DONE:BKG_IMAGE;
		endcase
	end
	
	always@( *)
	begin: enable_signals
	//By default, all our signals are 0
	enable = 1'b0;
	ld_first = 1'b0;
	ld_black = 1'b0;
	combination=2'b11;
	
	case (current_state)
		BKG_IMAGE: begin
			enable=1'b0;
		   ld_first = 1'b0;
	     
			ld_black = 1'b0;
			combination=2'b00;
		  end
		DISP_Q1: begin
			ld_first = 1'b1;
			enable = 1'b1;
			ld_black = 1'b0;
			combination=2'b01;
		end
		
		ERASE_Q1: begin
			
			ld_first = 1'b0;
			enable = 1'b1;
			ld_black = 1'b1;
			combination=2'b10;
		end
		
		
		
		S_DONE: begin
			enable = 1'b0;
			ld_first = 1'b0;
			ld_black = 1'b1;
			combination=2'b00;
		end
	endcase
	end
	// current_state registers
    always@(posedge clock)
    begin: state_FFs
        if (!resetn)
            current_state <= BKG_IMAGE;
        else
            current_state <= next_state;
    end // state_FFS
endmodule 


//data path
module dataPath(counterF,clock,go, resetn, enable, ld_first, ld_black, 
					x_outF,y_outF, x_outB, y_outB, color_outF,color_outB);
	
	input go;
	input clock;
	input resetn;
	input enable; 
	
	input ld_first;
	input ld_black;
	reg 	[8:0] X_counterFirst;
	reg   [7:0] Y_counterFirst;
	reg   [8:0] X_counterSecond;
	reg   [7:0] Y_counterSecond;
	
	
	
  output  reg   [25:0] counterF;
	
	
	
   reg   [25:0] counterB;
	reg   [8:0] X_counterBlack;
	reg   [7:0] Y_counterBlack;
	wire   [23:0]	colourFirst;
	
	output reg [8:0] x_outF;
	
	output reg [7:0] y_outF;
	
	output reg [8:0] x_outB;
	output reg [7:0] y_outB;

	output reg [23:0] color_outF;
	
	output reg [23:0] color_outB;
	
	//ram u n(.address(), .q(outptu),.clock(clock));
	//imgMem u0 (.address((8'd320)*(Y_counterFirst)+X_counterFirst), .q(colourFirst), .clock(clock));
	wire [16:0] address;
	assign address = (17'd320)*(Y_counterFirst)+X_counterFirst;
	q1Mem  u1 (.address(address), .q(colourFirst), .wren(1'b0), .clock(clock));
	
	
	always@ (posedge clock) begin
		if (!resetn) begin
X_counterFirst <= 9'd0;
Y_counterFirst <= 8'd0;
x_outB<=0;
		y_outB<=0;
		x_outF<=0;
		y_outF<=0;
		
	   color_outB<=0;
		color_outF<=0;






		end 
		else 
		begin
		if(ld_first) begin
		    
			 if(X_counterFirst == 9'd319 && Y_counterFirst!=8'd239 ) begin
			 
				X_counterFirst <= 0;
				Y_counterFirst <= Y_counterFirst+1'b1;
			end
			else begin
				X_counterFirst<=X_counterFirst+1'b1;
			end
			x_outF<=X_counterFirst;
			 y_outF<=Y_counterFirst;
			 color_outF<=colourFirst;
			 counterF <= counterF+1'b1;	
		    
		end

	
		
		
	else if(ld_black) begin
		    
			  if(X_counterBlack == 9'd319 && Y_counterBlack!=8'd239 ) begin
			 
				X_counterBlack <= 0;
				Y_counterBlack <= Y_counterBlack+1'b1;
			end
			else begin
				X_counterBlack<=X_counterBlack+1'b1;
			end
			x_outB<=X_counterBlack;
			 y_outB<=Y_counterBlack;
			 color_outB<=24'b0;
			 counterB <= counterB+1'b1;	
			 
	end
	
	
end
end
	
				
endmodule 




























 