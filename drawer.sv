module drawer(	/*** Basically a more powerful color mapper ***/
					input logic  vgaX, vgaY, clk, vgaClkIn, vsync, hsync, reset,
					output logic vgaClkOut,
					output logic [7:0] red, green, blue,
					
					// Handshake with the blitter:
					input logic enable,				// From blitter, tells the drawer to start drawing
					output logic acknowladge,		// Tells the blitter to got to the WAIT state
					input logic ackBack,				// Tells us blitter took over
					output logic blitterStart,		// Triggers the blitter (safe space required)
					output logic inControl,			// Couples the drawer to the SRAM
					
					output logic vgaReset,
					
					/*** SRAM INTERFACE ***/
					input logic [15:0] SRAM_DQ,
					output logic [19:0] SRAM_ADDR,
					output logic SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N
  				 );

/*** This modules purpose is to iterate over the buffer in memory and determine the correct color for that pixel ***/
parameter [19:0] bufferStart = 0;
parameter [8:0] bufferWidth = 127;

/*** Local signals ***/
logic [3:0] sram_data;
logic [19:0] address;
logic [19:0] prev_address;
logic [8:0] memoryCounter;
logic [7:0] new_data;
logic [7:0] cur_data;
logic [3:0] hs_counter;		// When we horizontal sync twice, add to the address;
enum logic [6:0] {WAIT, RESET, INITIAL_0, INITIAL_1, output1_0, output1_1, output1_2, output1_3, output1_4, output2_0, output2_1, output2_2, output2_3, output2_4, TERMINATE} state, next_state;

/*** Synchronous logic ***/
always_ff @(posedge vgaClkIn) begin
	if (reset == 1'b0) begin
		state <= WAIT;
		address <= bufferStart;
		hs_counter <= 3'b0;
	end
	else
		state <= next_state;
		
	if (hsync) begin
		hs_counter <= hs_counter+1;
	end
	
	if (state == output1_0) begin
		 sram_data <= cur_data[7:4];
	    if(memoryCounter == bufferWidth && hs_counter != 4) begin
		     address <= prev_address;
			  memoryCounter = memoryCounter + 1;
		 end
		 else if(memoryCounter < bufferWidth) begin
		     address <= address + 1;
			  memoryCounter = memoryCounter + 1;
		 end
		 else if(memoryCounter == bufferWidth && hs_counter == 4) begin
		     address <= address + 1;
			  prev_address <= address;
			  hs_counter <= 3'b0;
			  memoryCounter <= 1'b0;
		 end
	end
	
	if(state == output1_1) begin
		// Retrieve data from SRAM:
		cur_data <= new_data;
		new_data <= SRAM_DQ[7:0];
	end
	
	if (state == output2_0) begin
		// Transfer the second nibble to the sram_data:
		sram_data <= cur_data[3:0];
		
	end
end

/*** Next State Logic ***/
always_comb begin
	next_state = state;
	case(state)
	WAIT: begin
		if(enable)
			next_state = INITIAL_0;
		else
			next_state = WAIT;
	end
	INITIAL_0: begin
		next_state = INITIAL_1;
	end
	INITIAL_1: begin
		next_state = output1_0;
	end
	RESET: begin
		next_state = WAIT;
	end
	output1_0: begin
		next_state = output1_1;
	end
	output1_1: begin
		next_state = output1_2;
	end
	output1_2: begin
		next_state = output1_3;
	end
	output1_3: begin
		next_state = output1_4;
	end
	output1_4: begin
		next_state = output2_0;
	end
	output2_0: begin
		next_state = output2_1;
	end
	output2_1: begin
		next_state = output2_2;
	end
	output2_2: begin
		next_state = output2_3;
	end
	output2_3: begin
		next_state = output2_4;
	end
	output2_4: begin
	   if(vsync == 1'b1)
			next_state = TERMINATE;
		else
			next_state = output1_0;
	end
	TERMINATE: begin
		if(ackBack == 1'b1)
			next_state = WAIT;
		else
			next_state = TERMINATE;
	end
	endcase
end

/*** Output Logic : Color Mapper ***/
always_comb begin
   /* Defaults */
	vgaClkOut = 1'b0;
	SRAM_ADDR = 20'b0;
	
	vgaReset = 1'b0;			// Resets the VGA to sync up with our counting
   acknowladge = 1'b0;		// Tells the blitter to got to the WAIT state
	blitterStart = 1'b0;		// Triggers the blitter (safe space required)
	inControl = 1'b0;			// Couples the drawer to the SRAM
	
	//SRAM interface
	SRAM_UB_N = 1'b0;
	SRAM_LB_N = 1'b0;
	SRAM_CE_N = 1'b0;
	SRAM_OE_N = 1'b0;
	SRAM_WE_N = 1'b1;
	
	
	/* State Dependent : Overwrites Defaults */
	case(state)
	WAIT: begin
		//Defaults
	end
	INITIAL_0: begin
		acknowladge = 1'b1;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	INITIAL_1: begin
		inControl = 1'b1;
		SRAM_ADDR = address;
		vgaReset = 1'b1;
	end
	RESET: begin
		
	end
	output1_0: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output1_1: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output1_2: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output1_3: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output1_4: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output2_0: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output2_1: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output2_2: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output2_3: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	output2_4: begin
		vgaClkOut = vgaClkIn;
		inControl = 1'b1;
		SRAM_ADDR = address;
	end
	TERMINATE: begin
		blitterStart = 1'b1;
	end
	endcase
end


/*** Looks Up from a Pallate ***/
always_comb begin

	red = 8'h00;
	green = 8'h00;
	blue = 8'h00;
		
	case(sram_data)
	/* Color 0 is black */
	4'h0: begin
		red = 8'h00;
		green = 8'h00;
		blue = 8'h00;
	end
	/* Color 1 is royal blue */
	4'h1: begin
		red = 8'h00;
		green = 8'h80;
		blue = 8'hff;
	end
	/* Color 2 is dark blue */
	4'h2: begin
		red = 8'h00;
		green = 8'h00;
		blue = 8'hff;
	end
	/* Color 3 is brick 2,3 outline */
	4'h3: begin
		red = 8'h00;
		green = 8'hff;
		blue = 8'hff;
	end
	/* Color 4 is grey */
	4'h4: begin
		red = 8'h66;
		green = 8'h66;
		blue = 8'h66;
	end
	/* Color 5 is moss */
	4'h5: begin
		red = 8'h00;
		green = 8'hff;
		blue = 8'h00;
	end
 	/* Color 6 is dark moss */
	4'h6: begin
		red = 8'h80;
		green = 8'h80;
		blue = 8'h00;
	end
	/* Color 7 is outside blue */
	4'h7: begin
		red = 8'h00;
		green = 8'h00;
		blue = 8'h80;
	end
	/* Color 8 is outside green */
	4'h8: begin
		red = 8'h18;
		green = 8'hfa;
		blue = 8'h92;
	end
	/* Color 9 is white */
	4'h9: begin
		red = 8'hff;
		green = 8'hff;
		blue = 8'hff;
	end
	/* Color 10 is orange */
	4'ha: begin
		red = 8'hff;
		green = 8'h93;
		blue = 8'h00;
	end
	/* Color 11 is red */
	4'hb: begin
		red = 8'hff;
		green = 8'h00;
		blue = 8'h00;
	end
	/* Color 12 is blaster tip */
	4'hc: begin
		red = 8'h80;
		green = 8'hff;
		blue = 8'h00;
	end
	/* Color 13 is visor */
	4'hd: begin
		red = 8'hff;
		green = 8'hff;
		blue = 8'h00;
	end
	/* Color 14 is dark red */
	4'he: begin
		red = 8'h80;
		green = 8'h00;
		blue = 8'h00;
	end
	/* Color 15 is pink */
	4'hf: begin
		red = 8'hff;
		green = 8'h66;
		blue = 8'h66;
	end
	/* Default is Black */
	default: begin
		red = 8'h00;
		green = 8'h00;
		blue = 8'h00;
	end
	endcase
end

endmodule