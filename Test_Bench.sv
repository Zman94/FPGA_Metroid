module testbench();


timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic Reset_h;	 
logic ResetInt;

logic Clk;
	 
wire [15:0] SRAM_DQ;
logic [19:0] SRAM_ADDR;
logic SRAM_UB_N;
logic SRAM_LB_N;
logic SRAM_CE_N;
logic SRAM_OE_N;
logic SRAM_WE_N;

logic VGA_HS;
logic VGA_VS;
logic VGA_CLK_intermediate;
logic VGA_SYNC_N;
logic VGA_CLK;
logic VGA_BLANK_N;
logic drawxsig;
logic drawysig;
logic enable;

logic [7:0] VGA_R, VGA_G, VGA_B;
	 
	//Fill in the connections for the rest of the modules 
    vga_controller vgasync_instance(.*,.Reset(Reset_h),
													.hs(VGA_HS),    
													.vs(VGA_VS),        
													.pixel_clk(VGA_CLK_intermediate), 
													.blank(VGA_BLANK_N),     
													.sync(VGA_SYNC_N),
												   .DrawX(drawxsig), 
								               .DrawY(drawysig),
													.SoftwareResetInt(ResetInt));
 
    drawer dr0(	/*** Basically a more powerful color mapper ***/
				.vgaClkIn(VGA_CLK_intermediate), .vsync(VGA_VS), .hsync(VGA_HS), .reset(Reset_h),
				.vgaClkOut(VGA_CLK),
				.red(VGA_R), .green(VGA_R), .blue(VGA_B),
				
				.enable(enable),				// From blitter, tells the drawer to start drawing
				.acknowladge(),		// Tells the blitter to got to the WAIT state
				.ackBack(),				// Tells us blitter took over
				.blitterStart(),		// Triggers the blitter (safe space required)
				.inControl(),			// Couples the drawer to the SRAM
					
				.vgaReset(ResetInt),
					
					/*** SRAM INTERFACE ***/
				.SRAM_DQ(SRAM_DQ),
				.SRAM_ADDR(SRAM_ADDR),
				.SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N), .SRAM_WE_N(SRAM_WE_N)
  				);
				
	 /* Test SRAM */
	 test_memory testSRAM( 	.Clk(Clk),
									.Reset(Reset_h), 
									.I_O(SRAM_DQ),
									.A(SRAM_ADDR),
									.CE(SRAM_CE_N),
                           .UB(SRAM_UB_N),
                           .LB(SRAM_LB_N),
                           .OE(SRAM_OE_N),
									.WE(SRAM_WE_N));

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
enable = 0;
Reset_h = 0;

#2 Reset_h = 1;
#2 Reset_h = 0;

#2 enable = 1;
#2 enable = 0;
end
endmodule
