// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/15.0/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2015/02/08 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module nios_system_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 12,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 66 
   )
  (output [99 - 93 : 0] default_destination_id,
   output [70-1 : 0] default_wr_channel,
   output [70-1 : 0] default_rd_channel,
   output [70-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[99 - 93 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 70'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 70'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 70'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module nios_system_mm_interconnect_0_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [113-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [113-1    : 0] src_data,
    output reg [70-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 64;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 99;
    localparam PKT_DEST_ID_L = 93;
    localparam PKT_PROTECTION_H = 103;
    localparam PKT_PROTECTION_L = 101;
    localparam ST_DATA_W = 113;
    localparam ST_CHANNEL_W = 70;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 67;
    localparam PKT_TRANS_READ  = 68;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10 - 64'h0); 
    localparam PAD1 = log2ceil(64'h30 - 64'h20); 
    localparam PAD2 = log2ceil(64'h40 - 64'h30); 
    localparam PAD3 = log2ceil(64'h50 - 64'h40); 
    localparam PAD4 = log2ceil(64'h60 - 64'h50); 
    localparam PAD5 = log2ceil(64'h70 - 64'h60); 
    localparam PAD6 = log2ceil(64'h80 - 64'h70); 
    localparam PAD7 = log2ceil(64'h90 - 64'h80); 
    localparam PAD8 = log2ceil(64'ha0 - 64'h90); 
    localparam PAD9 = log2ceil(64'hb0 - 64'ha0); 
    localparam PAD10 = log2ceil(64'hc0 - 64'hb0); 
    localparam PAD11 = log2ceil(64'hd0 - 64'hc0); 
    localparam PAD12 = log2ceil(64'he0 - 64'hd0); 
    localparam PAD13 = log2ceil(64'hf0 - 64'he0); 
    localparam PAD14 = log2ceil(64'h100 - 64'hf0); 
    localparam PAD15 = log2ceil(64'h110 - 64'h100); 
    localparam PAD16 = log2ceil(64'h120 - 64'h110); 
    localparam PAD17 = log2ceil(64'h130 - 64'h120); 
    localparam PAD18 = log2ceil(64'h140 - 64'h130); 
    localparam PAD19 = log2ceil(64'h150 - 64'h140); 
    localparam PAD20 = log2ceil(64'h160 - 64'h150); 
    localparam PAD21 = log2ceil(64'h170 - 64'h160); 
    localparam PAD22 = log2ceil(64'h180 - 64'h170); 
    localparam PAD23 = log2ceil(64'h190 - 64'h180); 
    localparam PAD24 = log2ceil(64'h1a0 - 64'h190); 
    localparam PAD25 = log2ceil(64'h1b0 - 64'h1a0); 
    localparam PAD26 = log2ceil(64'h1c0 - 64'h1b0); 
    localparam PAD27 = log2ceil(64'h1d0 - 64'h1c0); 
    localparam PAD28 = log2ceil(64'h1e0 - 64'h1d0); 
    localparam PAD29 = log2ceil(64'h1f0 - 64'h1e0); 
    localparam PAD30 = log2ceil(64'h200 - 64'h1f0); 
    localparam PAD31 = log2ceil(64'h210 - 64'h200); 
    localparam PAD32 = log2ceil(64'h220 - 64'h210); 
    localparam PAD33 = log2ceil(64'h230 - 64'h220); 
    localparam PAD34 = log2ceil(64'h240 - 64'h230); 
    localparam PAD35 = log2ceil(64'h250 - 64'h240); 
    localparam PAD36 = log2ceil(64'h260 - 64'h250); 
    localparam PAD37 = log2ceil(64'h270 - 64'h260); 
    localparam PAD38 = log2ceil(64'h280 - 64'h270); 
    localparam PAD39 = log2ceil(64'h290 - 64'h280); 
    localparam PAD40 = log2ceil(64'h2a0 - 64'h290); 
    localparam PAD41 = log2ceil(64'h2b0 - 64'h2a0); 
    localparam PAD42 = log2ceil(64'h2c0 - 64'h2b0); 
    localparam PAD43 = log2ceil(64'h2d0 - 64'h2c0); 
    localparam PAD44 = log2ceil(64'h2e0 - 64'h2d0); 
    localparam PAD45 = log2ceil(64'h2f0 - 64'h2e0); 
    localparam PAD46 = log2ceil(64'h300 - 64'h2f0); 
    localparam PAD47 = log2ceil(64'h310 - 64'h300); 
    localparam PAD48 = log2ceil(64'h320 - 64'h310); 
    localparam PAD49 = log2ceil(64'h330 - 64'h320); 
    localparam PAD50 = log2ceil(64'h340 - 64'h330); 
    localparam PAD51 = log2ceil(64'h350 - 64'h340); 
    localparam PAD52 = log2ceil(64'h360 - 64'h350); 
    localparam PAD53 = log2ceil(64'h370 - 64'h360); 
    localparam PAD54 = log2ceil(64'h380 - 64'h370); 
    localparam PAD55 = log2ceil(64'h390 - 64'h380); 
    localparam PAD56 = log2ceil(64'h3a0 - 64'h390); 
    localparam PAD57 = log2ceil(64'h3b0 - 64'h3a0); 
    localparam PAD58 = log2ceil(64'h3c0 - 64'h3b0); 
    localparam PAD59 = log2ceil(64'h3d0 - 64'h3c0); 
    localparam PAD60 = log2ceil(64'h3e0 - 64'h3d0); 
    localparam PAD61 = log2ceil(64'h3f0 - 64'h3e0); 
    localparam PAD62 = log2ceil(64'h400 - 64'h3f0); 
    localparam PAD63 = log2ceil(64'h410 - 64'h400); 
    localparam PAD64 = log2ceil(64'h420 - 64'h410); 
    localparam PAD65 = log2ceil(64'h430 - 64'h420); 
    localparam PAD66 = log2ceil(64'h440 - 64'h438); 
    localparam PAD67 = log2ceil(64'h448 - 64'h440); 
    localparam PAD68 = log2ceil(64'h1800 - 64'h1000); 
    localparam PAD69 = log2ceil(64'h18000000 - 64'h10000000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h18000000;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [70-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    nios_system_mm_interconnect_0_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x10 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 29'h0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 51;
    end

    // ( 0x20 .. 0x30 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 29'h20   ) begin
            src_channel = 70'b1000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 38;
    end

    // ( 0x30 .. 0x40 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 29'h30   ) begin
            src_channel = 70'b0100000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 37;
    end

    // ( 0x40 .. 0x50 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 29'h40   ) begin
            src_channel = 70'b0010000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 36;
    end

    // ( 0x50 .. 0x60 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 29'h50   ) begin
            src_channel = 70'b0001000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x60 .. 0x70 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 29'h60   ) begin
            src_channel = 70'b0000100000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x70 .. 0x80 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 29'h70   ) begin
            src_channel = 70'b0000010000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x80 .. 0x90 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 29'h80   ) begin
            src_channel = 70'b0000001000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x90 .. 0xa0 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 29'h90   ) begin
            src_channel = 70'b0000000100000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 35;
    end

    // ( 0xa0 .. 0xb0 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 29'ha0   ) begin
            src_channel = 70'b0000000010000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
    end

    // ( 0xb0 .. 0xc0 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 29'hb0   ) begin
            src_channel = 70'b0000000001000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0xc0 .. 0xd0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 29'hc0   ) begin
            src_channel = 70'b0000000000100000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0xd0 .. 0xe0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 29'hd0   ) begin
            src_channel = 70'b0000000000010000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0xe0 .. 0xf0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 29'he0   ) begin
            src_channel = 70'b0000000000001000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0xf0 .. 0x100 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 29'hf0   ) begin
            src_channel = 70'b0000000000000100000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x100 .. 0x110 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 29'h100   ) begin
            src_channel = 70'b0000000000000010000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x110 .. 0x120 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 29'h110   ) begin
            src_channel = 70'b0000000000000001000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x120 .. 0x130 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 29'h120   ) begin
            src_channel = 70'b0000000000000000100000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 46;
    end

    // ( 0x130 .. 0x140 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 29'h130   ) begin
            src_channel = 70'b0000000000000000010000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x140 .. 0x150 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 29'h140   ) begin
            src_channel = 70'b0000000000000000001000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 60;
    end

    // ( 0x150 .. 0x160 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 29'h150   ) begin
            src_channel = 70'b0000000000000000000100000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 64;
    end

    // ( 0x160 .. 0x170 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 29'h160   ) begin
            src_channel = 70'b0000000000000000000010000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 57;
    end

    // ( 0x170 .. 0x180 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 29'h170   ) begin
            src_channel = 70'b0000000000000000000001000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 69;
    end

    // ( 0x180 .. 0x190 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 29'h180   ) begin
            src_channel = 70'b0000000000000000000000100000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 39;
    end

    // ( 0x190 .. 0x1a0 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 29'h190   ) begin
            src_channel = 70'b0000000000000000000000010000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 68;
    end

    // ( 0x1a0 .. 0x1b0 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 29'h1a0   ) begin
            src_channel = 70'b0000000000000000000000001000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x1b0 .. 0x1c0 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 29'h1b0   ) begin
            src_channel = 70'b0000000000000000000000000100000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x1c0 .. 0x1d0 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 29'h1c0   ) begin
            src_channel = 70'b0000000000000000000000000010000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x1d0 .. 0x1e0 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 29'h1d0   ) begin
            src_channel = 70'b0000000000000000000000000001000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x1e0 .. 0x1f0 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 29'h1e0   ) begin
            src_channel = 70'b0000000000000000000000000000100000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x1f0 .. 0x200 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 29'h1f0   ) begin
            src_channel = 70'b0000000000000000000000000000010000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x200 .. 0x210 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 29'h200   ) begin
            src_channel = 70'b0000000000000000000000000000001000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x210 .. 0x220 )
    if ( {address[RG:PAD32],{PAD32{1'b0}}} == 29'h210   ) begin
            src_channel = 70'b0000000000000000000000000000000100000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x220 .. 0x230 )
    if ( {address[RG:PAD33],{PAD33{1'b0}}} == 29'h220   ) begin
            src_channel = 70'b0000000000000000000000000000000010000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x230 .. 0x240 )
    if ( {address[RG:PAD34],{PAD34{1'b0}}} == 29'h230   ) begin
            src_channel = 70'b0000000000000000000000000000000001000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x240 .. 0x250 )
    if ( {address[RG:PAD35],{PAD35{1'b0}}} == 29'h240   ) begin
            src_channel = 70'b0000000000000000000000000000000000100000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x250 .. 0x260 )
    if ( {address[RG:PAD36],{PAD36{1'b0}}} == 29'h250   ) begin
            src_channel = 70'b0000000000000000000000000000000000010000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x260 .. 0x270 )
    if ( {address[RG:PAD37],{PAD37{1'b0}}} == 29'h260   ) begin
            src_channel = 70'b0000000000000000000000000000000000001000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x270 .. 0x280 )
    if ( {address[RG:PAD38],{PAD38{1'b0}}} == 29'h270   ) begin
            src_channel = 70'b0000000000000000000000000000000000000100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x280 .. 0x290 )
    if ( {address[RG:PAD39],{PAD39{1'b0}}} == 29'h280   ) begin
            src_channel = 70'b0000000000000000000000000000000000000010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x290 .. 0x2a0 )
    if ( {address[RG:PAD40],{PAD40{1'b0}}} == 29'h290   ) begin
            src_channel = 70'b0000000000000000000000000000000000000001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x2a0 .. 0x2b0 )
    if ( {address[RG:PAD41],{PAD41{1'b0}}} == 29'h2a0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x2b0 .. 0x2c0 )
    if ( {address[RG:PAD42],{PAD42{1'b0}}} == 29'h2b0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x2c0 .. 0x2d0 )
    if ( {address[RG:PAD43],{PAD43{1'b0}}} == 29'h2c0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x2d0 .. 0x2e0 )
    if ( {address[RG:PAD44],{PAD44{1'b0}}} == 29'h2d0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 49;
    end

    // ( 0x2e0 .. 0x2f0 )
    if ( {address[RG:PAD45],{PAD45{1'b0}}} == 29'h2e0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 48;
    end

    // ( 0x2f0 .. 0x300 )
    if ( {address[RG:PAD46],{PAD46{1'b0}}} == 29'h2f0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 47;
    end

    // ( 0x300 .. 0x310 )
    if ( {address[RG:PAD47],{PAD47{1'b0}}} == 29'h300   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 45;
    end

    // ( 0x310 .. 0x320 )
    if ( {address[RG:PAD48],{PAD48{1'b0}}} == 29'h310   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 44;
    end

    // ( 0x320 .. 0x330 )
    if ( {address[RG:PAD49],{PAD49{1'b0}}} == 29'h320   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 43;
    end

    // ( 0x330 .. 0x340 )
    if ( {address[RG:PAD50],{PAD50{1'b0}}} == 29'h330   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 42;
    end

    // ( 0x340 .. 0x350 )
    if ( {address[RG:PAD51],{PAD51{1'b0}}} == 29'h340   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 41;
    end

    // ( 0x350 .. 0x360 )
    if ( {address[RG:PAD52],{PAD52{1'b0}}} == 29'h350   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 40;
    end

    // ( 0x360 .. 0x370 )
    if ( {address[RG:PAD53],{PAD53{1'b0}}} == 29'h360   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 59;
    end

    // ( 0x370 .. 0x380 )
    if ( {address[RG:PAD54],{PAD54{1'b0}}} == 29'h370   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 61;
    end

    // ( 0x380 .. 0x390 )
    if ( {address[RG:PAD55],{PAD55{1'b0}}} == 29'h380   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 63;
    end

    // ( 0x390 .. 0x3a0 )
    if ( {address[RG:PAD56],{PAD56{1'b0}}} == 29'h390   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 62;
    end

    // ( 0x3a0 .. 0x3b0 )
    if ( {address[RG:PAD57],{PAD57{1'b0}}} == 29'h3a0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 58;
    end

    // ( 0x3b0 .. 0x3c0 )
    if ( {address[RG:PAD58],{PAD58{1'b0}}} == 29'h3b0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x3c0 .. 0x3d0 )
    if ( {address[RG:PAD59],{PAD59{1'b0}}} == 29'h3c0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x3d0 .. 0x3e0 )
    if ( {address[RG:PAD60],{PAD60{1'b0}}} == 29'h3d0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 53;
    end

    // ( 0x3e0 .. 0x3f0 )
    if ( {address[RG:PAD61],{PAD61{1'b0}}} == 29'h3e0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 56;
    end

    // ( 0x3f0 .. 0x400 )
    if ( {address[RG:PAD62],{PAD62{1'b0}}} == 29'h3f0   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 55;
    end

    // ( 0x400 .. 0x410 )
    if ( {address[RG:PAD63],{PAD63{1'b0}}} == 29'h400   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 54;
    end

    // ( 0x410 .. 0x420 )
    if ( {address[RG:PAD64],{PAD64{1'b0}}} == 29'h410   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 52;
    end

    // ( 0x420 .. 0x430 )
    if ( {address[RG:PAD65],{PAD65{1'b0}}} == 29'h420   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 65;
    end

    // ( 0x438 .. 0x440 )
    if ( {address[RG:PAD66],{PAD66{1'b0}}} == 29'h438  && read_transaction  ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 67;
    end

    // ( 0x440 .. 0x448 )
    if ( {address[RG:PAD67],{PAD67{1'b0}}} == 29'h440   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x1000 .. 0x1800 )
    if ( {address[RG:PAD68],{PAD68{1'b0}}} == 29'h1000   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 50;
    end

    // ( 0x10000000 .. 0x18000000 )
    if ( {address[RG:PAD69],{PAD69{1'b0}}} == 29'h10000000   ) begin
            src_channel = 70'b0000000000000000000000000000000000000000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 66;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


