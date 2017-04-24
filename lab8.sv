//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  lab8 			( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  //output [8:0]  LEDG,
							  //output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK				// SDRAM Clock
											);
    
    logic Reset_h, vssig, Clk;
	 logic [15:0] keycode;
    
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	 
	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	// Logic signals for the sprite mapper:
	logic samus_en, samus_dir, samus_walk, samus_jump, samus_up;
	logic [9:0] samus_x, samus_y;

	// VGA Signals:
	logic [9:0] drawxsig, drawysig;
	
	// Background
	logic [2:0]scene_number;

	// GUI
	logic title_en;
	logic loss_en;
	logic win_en;
	logic [1:0] health;

	// Monster
	logic monster1, monster2, monster3, monster3_dir;
	logic [9:0] monster1_x, monster1_y, monster2_x, monster2_y, monster3_x, monster3_y;

	// Explosion
	logic exp1_en, exp2_en, exp3_en;
	logic [9:0] exp1_x, exp1_y, exp2_x, exp2_y, exp3_x, exp3_y;

	// Bullet
	logic bullet1, bullet2, bullet3, b_emp;
	logic [9:0] b1_x, b1_y, b2_x, b2_y, b3_x, b3_y;
	
	// Kraid
	logic  			kraid_r_en, kraid_g_en, kraid_n_en, kraid_shoot_en, kraid_throw_en, kraid_throw_2_en, kraid_dir, kraid_as_dir;
	logic  [10:0] 	kraid_y, kraid_x, kraid_spike_x, kraid_spike_y, kraid_throw_x, kraid_throw_y, kraid_throw_2_x, kraid_throw_2_y;
	 
	 
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(~KEY[1]) 
	 );
	 
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	nios_system nios_system(		.clk_clk(Clk),         
											.reset_reset_n(KEY[0]),   
											.sdram_wire_addr(DRAM_ADDR), 
											.sdram_wire_ba(DRAM_BA),   
											.sdram_wire_cas_n(DRAM_CAS_N),
											.sdram_wire_cke(DRAM_CKE),  
											.sdram_wire_cs_n(DRAM_CS_N), 
											.sdram_wire_dq(DRAM_DQ),   
											.sdram_wire_dqm(DRAM_DQM),  
											.sdram_wire_ras_n(DRAM_RAS_N),
											.sdram_wire_we_n(DRAM_WE_N), 
											.sdram_clk_clk(DRAM_CLK),
											.keycode_export(keycode),  
											.otg_hpi_address_export(hpi_addr),
											.otg_hpi_data_in_port(hpi_data_in),
											.otg_hpi_data_out_port(hpi_data_out),
											.otg_hpi_cs_export(hpi_cs),
											.otg_hpi_r_export(hpi_r),
											.otg_hpi_w_export(hpi_w),
											
											// Our Game Config Here:
											// Bullet:
											.bullet1_en_export(bullet1),
											.bullet1_x_export(b1_x),
											.bullet1_y_export(b1_y),
											.bullet2_en_export(bullet2),
											.bullet2_x_export(b2_x),
											.bullet2_y_export(b2_y),
											.bullet3_en_export(bullet3),
											.bullet3_x_export(b3_x),
											.bullet3_y_export(b3_y),
											.b_emp_export(b_emp),
											
											// Health + Title + Background:
											.health_export(health),
											.loss_en_export(loss_en),
											.title_en_export(title_en),
											.win_en_export(win_en),
											.scene_sel_export(scene_number),
											
											// Samus:
											.samus_dir_export(samus_dir),
											.samus_en_export(samus_en),
											.samus_jump_export(samus_jump),
											.samus_walk_export(samus_walk),
											.samus_up_export(samus_up),
											.samus_x_export(samus_x),
											.samus_y_export(samus_y),
											
											
											// Monsters:
											.monster1_en_export(monster1),
											.monster1_x_export(monster1_x),
											.monster1_y_export(monster1_y),
											.monster2_en_export(monster2),
											.monster2_x_export(monster2_x),
											.monster2_y_export(monster2_y),
											.monster3_en_export(monster3),
											.monster3_x_export(monster3_x),
											.monster3_y_export(monster3_y),
											.monster3_dir_export(monster3_dir),
											
										   // Explosions:
											.explosion1_en_export(exp1_en),
											.explosion1_x_export(exp1_x),
											.explosion1_y_export(exp1_y),
											.explosion2_en_export(exp2_en),
											.explosion2_x_export(exp2_x),
											.explosion2_y_export(exp2_y),
											.explosion3_en_export(exp3_en),
											.explosion3_x_export(exp3_x),
											.explosion3_y_export(exp3_y),
											
											// Kraid:
											.kraid_r_en_export(kraid_r_en), 
											.kraid_g_en_export(kraid_g_en), 
											.kraid_n_en_export(kraid_n_en), 
											.kraid_shoot_en_export(kraid_shoot_en), 
											.kraid_throw_en_export(kraid_throw_en),
											.krait_throw_2_en_export(kraid_throw_2_en),
											.kraid_dir_export(kraid_dir), 
											.kraid_as_dir_export(kraid_as_dir),
											.kraid_y_export(kraid_y), .kraid_x_export(kraid_x), 
											.kraid_spike_x_export(kraid_spike_x), .kraid_spike_y_export(kraid_spike_y), 
											.kraid_throw_x_export(kraid_throw_x), .kraid_throw_y_export(kraid_throw_y),
											.krait_throw_2_x_export(kraid_throw_2_x), .krait_throw_2_y_export(kraid_throw_2_y));
	
	//Fill in the connections for the rest of the modules 
   vga_controller vgasync_instance(.*,.Reset(Reset_h),
													.hs(VGA_HS),    
													.vs(VGA_VS),        
													.pixel_clk(VGA_CLK), 
													.blank(VGA_BLANK_N),     
													.sync(VGA_SYNC_N),
												   .DrawX(drawxsig), 
								               .DrawY(drawysig));
	 	
	//--------------------------------------------------------------------------------------------
	// Sprite Mapper:
	//
	//		The sprite mapper is a glorified color mapper and it will draw the sprites with the 
	//		top left corner at the (x,y) coordinate. The background moves based on the position of
	//		samus. (She is in the middle on the screen)
	//
	//--------------------------------------------------------------------------------------------
	sprite_mapper sp1(.*, .clk(Clk), 
							.reset(Reset_h), 
							.vgaX(drawxsig), 
							.vgaY(drawysig), 
							.red(VGA_R), 
							.green(VGA_G), 
							.blue(VGA_B), 
							.vsync(VGA_VS));
							
	//--------------------------------------------------------------------------------------------
	// Sound Unit:
	//
	//		Interfaces with the GPIO Pins:
	//
	//--------------------------------------------------------------------------------------------
	//sound_controller sc1(	.clk(), 
	//								.enable(),
	//								.reset(),
	//								.soundNumber());

	// Hex drivers (for debug)
	HexDriver hex_inst_0 (keycode[3:0], HEX0);
	HexDriver hex_inst_1 (keycode[7:4], HEX1);
	HexDriver hex_inst_2 (hpi_data_in[3:0], HEX2);
	HexDriver hex_inst_3 (hpi_data_in[7:4], HEX3);
	HexDriver hex_inst_4 (hpi_data_in[11:8], HEX4);
	HexDriver hex_inst_5 (hpi_data_in[15:12], HEX5);
	HexDriver hex_inst_6 ({OTG_DATA[3:0]}, HEX6);
	HexDriver hex_inst_7 ({OTG_DATA[7:4]}, HEX7);
endmodule
