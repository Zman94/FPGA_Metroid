module RegFile_testbench();


timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;


logic 	[15:0] DataIn, IR;
logic 	LDREG, DR, SR1, Clk, Reset;
logic 	[3:0] SR2;
logic	[15:0] SR2out, SR1out;

Register_File testFile(.*);

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
DataIn = 16'h1111;
IR = 16'b0001000100000000;
DR = 1'b0;
SR1 = 1'b0;
LDREG = 1'b0;
Reset = 1'b0;
SR2 = 3'b000;

#1 Reset = 1'b1;
#1 Reset = 1'b0;

#1 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001001100000000;
   DataIn = 16'h2222;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001010100000000;
   DataIn = 16'h3333;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001011100000000;
   DataIn = 16'h4444;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001100100000000;
   DataIn = 16'h5555;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001101100000000;
   DataIn = 16'h6666;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001110100000000;
   DataIn = 16'h77777;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;

#1 begin
	IR = 16'b0001111100000000;
   DataIn = 16'h8888;
	end
#2 LDREG = 1'b1;
#1 LDREG = 1'b0;


#1 begin
	 SR2 = 3'b000;
	 IR = 16'b0001000100000000;
	 end
#1 begin
	 SR2 = 3'b001;
	 IR = 16'b0001001100000000;
	 end
#1 begin
	 SR2 = 3'b010;
	 IR = 16'b0001010100000000;
	 end
#1 begin
	 SR2 = 3'b011;
	 IR = 16'b0001011100000000;
	 end
#1 begin
	 SR2 = 3'b100;
	 IR = 16'b0001100100000000;
	 end
#1 begin
	 SR2 = 3'b101;
	 IR = 16'b0001101100000000;
	 end
#1 begin
	 SR2 = 3'b110;
	 IR = 16'b0001110100000000;
	 end
#1 begin
	 SR2 = 3'b111;
	 IR = 16'b0001111100000000;
	 end
	 
	 
end
endmodule
