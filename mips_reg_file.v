/***Flip flop**/
module dff_sync_clear(d,clear_neg,clk,q);
input d; input clear_neg; input clk; output reg q;
always @(posedge clk) begin
	if(!clear_neg)
		q <= 1'b0;
	else begin
		q <= d;
	end
end
endmodule

module dff_async_clear(d,clear_neg,clk,q);
input d; input clear_neg; input clk; output reg q;
always @(posedge clk or negedge clear_neg) begin
	if(!clear_neg)
		q <= 1'b0;
	else begin
		q <= d;
	end
end
endmodule
/***/

/**Register**/
module reg_32(d,q,clk,clear_neg);
input[31:0] d; output [31:0] q; input clk; input clear_neg;
genvar i;

generate 
	for(i=0; i < 32; i=i+1) begin
		dff_async_clear flipflop(d[i],clear_neg,clk,q[i]);
	end
endgenerate
endmodule

// Uncomment to test register

// module tb_reg_32;
// reg[31:0] d; wire[31:0] oup; reg clk; reg clear_neg;
// reg_32 r(d,oup,clk,clear_neg);

// always @(clk)
	// #5 clk <= ~clk;
// initial begin
		// clk = 1'b1;
		
		// clear_neg = 1'b1;
		// $monitor($time,"The output of the register is %h", oup);
		// #50 clear_neg = 1'b0;
		// #50 d = 'hAAAAFFFF; clear_neg = 1'b1;
		// #50 d = 'hFFFFFFFF;
		// #50 d = 'hAAAAAAAA;
		// #50 $finish;
// end
// endmodule

/****/

module reg_select_mux(regNo,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,regData);
input[4:0] regNo;
input[31:0] q0; input[31:0] q1; input[31:0] q2;input[31:0] q3;input[31:0] q4;input[31:0] q5;input[31:0] q6;input[31:0] q7;input[31:0] q8;input[31:0] q9;input[31:0] q10;input[31:0] q11;input[31:0] q12;input[31:0] q13;input[31:0] q14;input[31:0] q15;input[31:0] q16;input[31:0] q17;
input[31:0] q18;input[31:0] q19;input[31:0] q20;input[31:0] q21;input[31:0] q22;input[31:0] q23;input[31:0] q24;input[31:0] q25;input[31:0] q26;input[31:0] q27;input[31:0] q28;input[31:0] q29;input[31:0] q30;input[31:0] q31;
output reg[31:0] regData;
always @(*) begin
	if(regNo == 5'd0)
		regData = q0;
	else if(regNo == 5'd1)
		regData = q1;
	else if(regNo == 5'd2)
		regData = q2;
	else if(regNo == 5'd3)
		regData = q3;
	else if(regNo == 5'd4)
		regData = q4;
	else if(regNo == 5'd5)
		regData = q5;
	else if(regNo == 5'd6)
		regData = q6;
	else if(regNo == 5'd7)
		regData = q7;
	else if(regNo == 5'd8)
		regData = q8;
	else if(regNo == 5'd9)
		regData = q9;
	else if(regNo == 5'd10)
		regData = q10;
	else if(regNo == 5'd11)
		regData = q11;
	else if(regNo == 5'd12)
		regData = q12;
	else if(regNo == 5'd13)
		regData = q13;
	else if(regNo == 5'd14)
		regData = q14;
	else if(regNo == 5'd15)
		regData = q15;
	else if(regNo == 5'd16)
		regData = q16;
	else if(regNo == 5'd17)
		regData = q17;
	else if(regNo == 5'd18)
		regData = q18;
	else if(regNo == 5'd19)
		regData = q19;
	else if(regNo == 5'd20)
		regData = q20;
	else if(regNo == 5'd21)
		regData = q21;
	else if(regNo == 5'd22)
		regData = q22;
	else if(regNo == 5'd23)
		regData = q23;
	else if(regNo == 5'd24)
		regData = q24;
	else if(regNo == 5'd25)
		regData = q25;
	else if(regNo == 5'd26)
		regData = q26;
	else if(regNo == 5'd27)
		regData = q27;
	else if(regNo == 5'd28)
		regData = q28;
	else if(regNo == 5'd29)
		regData = q29;
	else if(regNo == 5'd30)
		regData = q30;
	else if(regNo == 5'd31)
		regData = q31;

end
endmodule

module reg_select_decoder(regNo,regSelect);
input[4:0] regNo; output reg[31:0] regSelect;
always @(*) begin
	if(regNo == 5'd0)
		regSelect = 32'd1;
	else if(regNo == 5'd1)
		regSelect = 32'd2;
	else if(regNo == 5'd2)
		regSelect = 32'd4;
	else if(regNo == 5'd3)
		regSelect = 32'd8;
	else if(regNo == 5'd4)
		regSelect = 32'd16;
	else if(regNo == 5'd5)
		regSelect = 32'd32;
	else if(regNo == 5'd6)
		regSelect = 32'd64;
	else if(regNo == 5'd7)
		regSelect = 32'd128;
	else if(regNo == 5'd8)
		regSelect = 32'd256;
	else if(regNo == 5'd9)
		regSelect = 32'd512;
	else if(regNo == 5'd10)
		regSelect = 32'd1024;
	else if(regNo == 5'd11)
		regSelect = 32'd2048;
	else if(regNo == 5'd12)
		regSelect = 32'd4096;
	else if(regNo == 5'd13)
		regSelect = 32'd8192;
	else if(regNo == 5'd14)
		regSelect = 32'd16384;
	else if(regNo == 5'd15)
		regSelect = 32'd32768;
	else if(regNo == 5'd16)
		regSelect = 32'd65536;
	else if(regNo == 5'd17)
		regSelect = 32'd131072;
	else if(regNo == 5'd18)
		regSelect = 32'd262144;
	else if(regNo == 5'd19)
		regSelect = 32'd524288;
	else if(regNo == 5'd20)
		regSelect = 32'h00100000;
	else if(regNo == 5'd21)
		regSelect = 32'h00200000;
	else if(regNo == 5'd22)
		regSelect = 32'h00400000;
	else if(regNo == 5'd23)
		regSelect = 32'h00800000;
	else if(regNo == 5'd24)
		regSelect = 32'h01000000;
	else if(regNo == 5'd25)
		regSelect = 32'h02000000;
	else if(regNo == 5'd26)
		regSelect = 32'h04000000;
	else if(regNo == 5'd27)
		regSelect = 32'h08000000;
	else if(regNo == 5'd28)
		regSelect = 32'h10000000;
	else if(regNo == 5'd29)
		regSelect = 32'h20000000;
	else if(regNo == 5'd30)
		regSelect = 32'h40000000;
	else if(regNo == 5'd31)
		regSelect = 32'h80000000;
	
end	
endmodule

// Uncoment to test decoder

// module tb_reg_select_decode;
// reg[4:0] inp; wire[31:0] op;
// reg_select_decoder rd(inp,op);
// initial begin 
	// $monitor($time," The output is %b",op);
	// #5 inp = 5'b00000;
	// #5 inp = 5'b00001;
	// #5 inp = 5'd2;
	// #5 inp = 5'd3;
	// #5 inp = 5'd4;
	// #5 inp = 5'd5;
	// #5 inp = 5'd6;
	// #5 inp = 5'd7;
	// #5 inp = 5'd8;
	// #5 inp = 5'd9;
	// #5 inp = 5'd10;
	// #5 inp = 5'd11;
	// #5 inp = 5'd12;
	// #5 inp = 5'd13;
	// #5 inp = 5'd14;
	// #5 inp = 5'd15;
	// #5 inp = 5'd16;
	// #5 inp = 5'd17;
	// #5 inp = 5'd18;
	// #5 inp = 5'd19;
	// #5 inp = 5'd20;
	// #5 inp = 5'd21;
	// #5 inp = 5'd22;
	// #5 inp = 5'd23;
	// #5 inp = 5'd24;
	// #5 inp = 5'd25;
	// #5 inp = 5'd26;
	// #5 inp = 5'd27;
	// #5 inp = 5'd28;
	// #5 inp = 5'd29;
	// #5 inp = 5'd30;
	// #5 inp = 5'd31;
// end
// endmodule

module registerFile(clk,clear,readReg1,readReg2,writeReg,writeData,regWrite,readData1,readData2);
input clk; input clear; input[4:0] readReg1; input[4:0] readReg2; input[4:0] writeReg; input regWrite; input[31:0] writeData;
output[31:0] readData1; output[31:0] readData2;
genvar i;
wire[31:0] whichRegisterToWrite;
reg_select_decoder decoder(writeReg,whichRegisterToWrite);
wire[31:0] q0; wire[31:0] q1;wire[31:0] q2;wire[31:0] q3;wire[31:0] q4;wire[31:0] q5;wire[31:0] q6;wire[31:0] q7;wire[31:0] q8;wire[31:0] q9;wire[31:0] q10;wire[31:0] q11;wire[31:0] q12;wire[31:0] q13;wire[31:0] q14;wire[31:0] q15;wire[31:0] q16;
wire[31:0] q17;wire[31:0] q18;wire[31:0] q19;wire[31:0] q20;wire[31:0] q21;wire[31:0] q22;wire[31:0] q23;wire[31:0] q24;wire[31:0] q25;wire[31:0] q26;wire[31:0] q27;wire[31:0] q28;wire[31:0] q29;wire[31:0] q30;
wire[31:0] q31;
reg_32 reg0(writeData,q0,clk&regWrite&whichRegisterToWrite[0],clear);
reg_32 reg1(writeData,q1,clk&regWrite&whichRegisterToWrite[1],clear);
reg_32 reg2(writeData,q2,clk&regWrite&whichRegisterToWrite[2],clear);
reg_32 reg3(writeData,q3,clk&regWrite&whichRegisterToWrite[3],clear);
reg_32 reg4(writeData,q4,clk&regWrite&whichRegisterToWrite[4],clear);
reg_32 reg5(writeData,q5,clk&regWrite&whichRegisterToWrite[5],clear);
reg_32 reg6(writeData,q6,clk&regWrite&whichRegisterToWrite[6],clear);
reg_32 reg7(writeData,q7,clk&regWrite&whichRegisterToWrite[7],clear);
reg_32 reg8(writeData,q8,clk&regWrite&whichRegisterToWrite[8],clear);
reg_32 reg9(writeData,q9,clk&regWrite&whichRegisterToWrite[9],clear);
reg_32 reg10(writeData,q10,clk&regWrite&whichRegisterToWrite[10],clear);
reg_32 reg11(writeData,q11,clk&regWrite&whichRegisterToWrite[11],clear);
reg_32 reg12(writeData,q12,clk&regWrite&whichRegisterToWrite[12],clear);
reg_32 reg13(writeData,q13,clk&regWrite&whichRegisterToWrite[13],clear);
reg_32 reg14(writeData,q14,clk&regWrite&whichRegisterToWrite[14],clear);
reg_32 reg15(writeData,q15,clk&regWrite&whichRegisterToWrite[15],clear);
reg_32 reg16(writeData,q16,clk&regWrite&whichRegisterToWrite[16],clear);
reg_32 reg17(writeData,q17,clk&regWrite&whichRegisterToWrite[17],clear);
reg_32 reg18(writeData,q18,clk&regWrite&whichRegisterToWrite[18],clear);
reg_32 reg19(writeData,q19,clk&regWrite&whichRegisterToWrite[19],clear);
reg_32 reg20(writeData,q20,clk&regWrite&whichRegisterToWrite[20],clear);
reg_32 reg21(writeData,q21,clk&regWrite&whichRegisterToWrite[21],clear);
reg_32 reg22(writeData,q22,clk&regWrite&whichRegisterToWrite[22],clear);
reg_32 reg23(writeData,q23,clk&regWrite&whichRegisterToWrite[23],clear);
reg_32 reg24(writeData,q24,clk&regWrite&whichRegisterToWrite[24],clear);
reg_32 reg25(writeData,q25,clk&regWrite&whichRegisterToWrite[25],clear);
reg_32 reg26(writeData,q26,clk&regWrite&whichRegisterToWrite[26],clear);
reg_32 reg27(writeData,q27,clk&regWrite&whichRegisterToWrite[27],clear);
reg_32 reg28(writeData,q28,clk&regWrite&whichRegisterToWrite[28],clear);
reg_32 reg29(writeData,q29,clk&regWrite&whichRegisterToWrite[29],clear);
reg_32 reg30(writeData,q30,clk&regWrite&whichRegisterToWrite[30],clear);
reg_32 reg31(writeData,q31,clk&regWrite&whichRegisterToWrite[31],clear);

reg_select_mux mux1(readReg1,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,readData1);
reg_select_mux mux2(readReg2,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,readData2);
endmodule

module tb_registerFile;
reg clk; reg clear; reg[4:0] readReg1; reg[4:0] readReg2; reg[4:0] writeReg; reg[31:0] writeData; reg regWrite; wire[31:0] readData1; wire[31:0] readData2;
registerFile rf(clk,clear,readReg1,readReg2,writeReg,writeData,regWrite,readData1,readData2);

always @(clk)
	#5 clk <= ~clk;

integer i;
initial begin
	$monitor($time," The value of the registers being read are %d %d and their values are %b %b " ,readReg1,readReg2,readData1,readData2);
	clk = 1'b0; clear = 1'b1;
	regWrite = 1'b0;
	writeReg = 5'd9;
	#5 clear = 1'b0;
	#5 clear = 1'b1;
	
	// for(i=0; i < 32; i=i+1) begin
			// #10 readReg1 = i; readReg2 = i+1; writeReg = i+1; writeData = i+1;
	// end
	
	// #10 readReg1 = 5'd0; writeReg = 5'd0; writeData = 32'd32;
	// #10 writeData = 32'd101;
	// #10 regWrite = 1'b0;
	// #10 writeData = 32'd100;
	// #10 regWrite = 1'b1;
	// #10 writeData = 32'd101;
	
	#5 readReg1 = 5'd2; readReg2 = 5'd3; 
	#5 writeData = 32'hFFFF0000; regWrite = 1'b1; writeReg = 5'd3;
	#5 regWrite = 1'b0; 
	#5 writeReg = 5'd2; writeData = 32'hFFFFFFFF; regWrite = 1'b1;
	#5 regWrite = 1'b0;
	#1000 $finish;
end
endmodule