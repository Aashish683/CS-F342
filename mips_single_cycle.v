module instructionMemory(readAddress,instruction);
input[31:0] readAddress; output [31:0] instruction;
reg[31:0] instrs[40:0];
// For some reason the value of the register after it is written is displaying one cycle after the instruction in which it is written by $monitor. During the cycle it changes, it is showing as some different value.
// Use invalid opcodes to just display results. The system is designed to do nothing if the opcode is invalid use 32'hBBBBBBBB as the invalid instruction.
initial begin
	instrs[0] = 32'b10001101001010000000000000000000; // lw $t0, 0(t1);
	instrs[4] = 32'b10001101010010010000000000000000; //  lw $t1 , 0 ($t2);
	instrs[8] = 32'b00000001001010000101000000100000; // add $t2 $t1 $t0;
	instrs[12] = 32'b10101101011010100000000000000000; // sw $t2 0x0000($t3)
	// instrs[13] = 32'b00000001010010110100100000100000;
	// instrs[14] = 32'b00000001010010110100100000100000;
	// instrs[15] = 32'b00000001010010110100100000100000;
	instrs[16] = 32'b10001101011010000000000000000000; // lw $t0 0x0000($t3)
	// instrs[17] = 32'b00000001010010110100100000100000;
	// instrs[18] = 32'b00000001010010110100100000100000;
	// instrs[19] = 32'b00000001010010110100100000100000;
	instrs[20] = 32'b00000001000010010100000000100010; // sub $t0 $t0 $t1
	// instrs[21] = 32'b00000001010010110100100000100000;
	// instrs[22] = 32'b00000001010010110100100000100000;
	// instrs[23] = 32'b00000001010010110100100000100000;
	instrs[24] = 32'b00000001000010010100000000100000; // add $t0 $t0 $t1
	// instrs[25] = 32'b00000001010010110100100000100000;
	// instrs[26] = 32'b00000001010010110100100000100000;
	// instrs[27] = 32'b00000001010010110100100000100000;
	instrs[28] = 32'b00000001000010100100000000100000; // add $t0 $t0 $t2
	// instrs[29] = 32'b00000001010010110100100000100000;
	// instrs[30] = 32'b00000001010010110100100000100000;
	// instrs[31] = 32'b00000001010010110100100000100000;
	instrs[32] = 32'b10001101101010000000000000000100; //lw $t0 0x0004 $t5
	
	instrs[36] = 32'hBBBBBBBB;
end

assign instruction = instrs[readAddress];
endmodule

module dataMemory(clk,address,d,MemRead,MemWrite,writeData,invalid);
input clk;
input[31:0] address; input MemRead; input MemWrite; input[31:0] writeData;
input invalid;
output [31:0] d;
reg[31:0] data[31:0];
initial begin
	data[0] = 32'd1234;
	data[1] = 32'd1234;
	data[2] = 32'd1234;
	data[3] = 32'd1234;
	data[4] = 32'd1234;
	data[5] = 32'd1234;
	data[6] = 32'd1234;
	data[7] = 32'd1234;
	data[8] = 32'd1234;
	data[9] = 32'd1234;
	data[10] = 32'd1234;
	data[11] = 32'd1234;
	data[12] = 32'd1234;
	data[13] = 32'd1234;
	data[14] = 32'd1234;
	data[15] = 32'd1234;
	data[16] = 32'd1234;
	data[17] = 32'd1234;
	data[18] = 32'd1234;
	data[19] = 32'd1234;
	data[20] = 32'd1234;
	data[21] = 32'd1234;
	data[22] = 32'd1234;
	data[23] = 32'd1234;
	data[24] = 32'd1234;
	data[25] = 32'd1234;
	data[26] = 32'd1234;
	data[27] = 32'd1234;
	data[28] = 32'd1234;
	data[29] = 32'd1234;
	data[30] = 32'd1234;
	data[31] = 32'd1234;
end

/*Did not work for posedge MemRead and MemWrite, figure out why*/
assign d = (MemRead == 1'b1 && invalid == 1'b0) ? data[address] : 32'd0;
	
always @(posedge clk)
	if(MemWrite == 1'b1 && invalid == 1'b0)
		data[address] = writeData;
	
endmodule

module leftShifter(inp,oup);
input[31:0] inp; output[31:0] oup;
assign oup = inp << 2;
endmodule

module decoder3_8(a,b,c,op);
input a,b,c;
output[7:0] op;
assign op[0] = ~a & ~b & ~c;
assign op[1] = ~a & ~b & c;
assign op[2] = ~a & b & ~c;
assign op[3] = ~a & b & c;
assign op[4] = a & ~b & ~c;
assign op[5] = a & ~b & c;
assign op[6] = a & b & ~c;
assign op[7] = a & b & c;
endmodule

module adder(x,y,z,s,c);
input x,y,z;
output s,c;
wire[7:0] op;
decoder3_8 d(x,y,z,op);
assign s = op[1] | op[2] | op[4] | op[7];
assign c = op[3] | op[5] | op[6] | op[7];
endmodule

module adder_8(x,y,cin,s,cout,of);
input[7:0] x,y;
input cin;
output[7:0] s;
output cout;
output of;
wire[6:0] carry;
adder a1(x[0],y[0],cin,s[0],carry[0]);
adder a2(x[1],y[1],carry[0],s[1],carry[1]);
adder a3(x[2],y[2],carry[1],s[2],carry[2]);
adder a4(x[3],y[3],carry[2],s[3],carry[3]);
adder a5(x[4],y[4],carry[3],s[4],carry[4]);
adder a6(x[5],y[5],carry[4],s[5],carry[5]);
adder a7(x[6],y[6],carry[5],s[6],carry[6]);
adder a8(x[7],y[7],carry[6],s[7],cout);
assign of = carry[6]^cout;
endmodule

module adder_32(x,y,cin,s,cout,of);
input[31:0] x,y;
input cin;
output[31:0] s;
output cout;
wire[4:0] carry;
wire[2:0] dump;
output of;
adder_8 a1(x[7:0],y[7:0],cin,s[7:0],carry[0],dump[0]);
adder_8 a2(x[15:8],y[15:8],carry[0],s[15:8],carry[1],dump[1]);
adder_8 a3(x[23:16],y[23:16],carry[1],s[23:16],carry[2],dump[2]);
adder_8 a4(x[31:24],y[31:24],carry[2],s[31:24],cout,of);
endmodule

module sign_extender(in,out);
input[15:0] in; output reg[31:0] out;
integer i;
always @(*) begin
	for(i=0; i < 32; i=i+1) begin
		if(i > 15)
			out[i] = in[15];
		else
			out[i] = in[i];
	end
end
endmodule

/*****Register File***/
module dff_async_clear(d,clear_neg,clk,q);
input d; input clear_neg; input clk; output reg q;
		
always @(posedge clk or negedge clear_neg) begin
	if(!clear_neg)
		q <= 1'b0;
	else 
		q <= d;
end
endmodule

module reg_32(d,q,clk,clear_neg);
input[31:0] d; output [31:0] q; input clk; input clear_neg;
genvar i;
generate 
	for(i=0; i < 32; i=i+1) begin
		dff_async_clear flipflop(d[i],clear_neg,clk,q[i]);
	end
endgenerate

endmodule

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

module registerFile(clk,clear,readReg1,readReg2,writeReg,writeData,regWrite,readData1,readData2,invalid);
input clk; input clear; input[4:0] readReg1; input[4:0] readReg2; input[4:0] writeReg; input regWrite; input[31:0] writeData; input invalid;
output[31:0] readData1; output[31:0] readData2;
wire[31:0] whichRegisterToWrite;
reg_select_decoder decoder(writeReg,whichRegisterToWrite);
wire[31:0] q0; wire[31:0] q1;wire[31:0] q2;wire[31:0] q3;wire[31:0] q4;wire[31:0] q5;wire[31:0] q6;wire[31:0] q7;wire[31:0] q8;wire[31:0] q9;wire[31:0] q10;wire[31:0] q11;wire[31:0] q12;wire[31:0] q13;wire[31:0] q14;wire[31:0] q15;wire[31:0] q16;
wire[31:0] q17;wire[31:0] q18;wire[31:0] q19;wire[31:0] q20;wire[31:0] q21;wire[31:0] q22;wire[31:0] q23;wire[31:0] q24;wire[31:0] q25;wire[31:0] q26;wire[31:0] q27;wire[31:0] q28;wire[31:0] q29;wire[31:0] q30;
wire[31:0] q31;
reg_32 reg0(writeData,q0,clk&regWrite&whichRegisterToWrite[0]&!invalid,clear);
reg_32 reg1(writeData,q1,clk&regWrite&whichRegisterToWrite[1]&!invalid,clear);
reg_32 reg2(writeData,q2,clk&regWrite&whichRegisterToWrite[2]&!invalid,clear);
reg_32 reg3(writeData,q3,clk&regWrite&whichRegisterToWrite[3]&!invalid,clear);
reg_32 reg4(writeData,q4,clk&regWrite&whichRegisterToWrite[4]&!invalid,clear);
reg_32 reg5(writeData,q5,clk&regWrite&whichRegisterToWrite[5]&!invalid,clear);
reg_32 reg6(writeData,q6,clk&regWrite&whichRegisterToWrite[6]&!invalid,clear);
reg_32 reg7(writeData,q7,clk&regWrite&whichRegisterToWrite[7]&!invalid,clear);
reg_32 reg8(writeData,q8,clk&regWrite&whichRegisterToWrite[8]&!invalid,clear);
reg_32 reg9(writeData,q9,clk&regWrite&whichRegisterToWrite[9]&!invalid,clear);
reg_32 reg10(writeData,q10,clk&regWrite&whichRegisterToWrite[10]&!invalid,clear);
reg_32 reg11(writeData,q11,clk&regWrite&whichRegisterToWrite[11]&!invalid,clear);
reg_32 reg12(writeData,q12,clk&regWrite&whichRegisterToWrite[12]&!invalid,clear);
reg_32 reg13(writeData,q13,clk&regWrite&whichRegisterToWrite[13]&!invalid,clear);
reg_32 reg14(writeData,q14,clk&regWrite&whichRegisterToWrite[14]&!invalid,clear);
reg_32 reg15(writeData,q15,clk&regWrite&whichRegisterToWrite[15]&!invalid,clear);
reg_32 reg16(writeData,q16,clk&regWrite&whichRegisterToWrite[16]&!invalid,clear);
reg_32 reg17(writeData,q17,clk&regWrite&whichRegisterToWrite[17]&!invalid,clear);
reg_32 reg18(writeData,q18,clk&regWrite&whichRegisterToWrite[18]&!invalid,clear);
reg_32 reg19(writeData,q19,clk&regWrite&whichRegisterToWrite[19]&!invalid,clear);
reg_32 reg20(writeData,q20,clk&regWrite&whichRegisterToWrite[20]&!invalid,clear);
reg_32 reg21(writeData,q21,clk&regWrite&whichRegisterToWrite[21]&!invalid,clear);
reg_32 reg22(writeData,q22,clk&regWrite&whichRegisterToWrite[22]&!invalid,clear);
reg_32 reg23(writeData,q23,clk&regWrite&whichRegisterToWrite[23]&!invalid,clear);
reg_32 reg24(writeData,q24,clk&regWrite&whichRegisterToWrite[24]&!invalid,clear);
reg_32 reg25(writeData,q25,clk&regWrite&whichRegisterToWrite[25]&!invalid,clear);
reg_32 reg26(writeData,q26,clk&regWrite&whichRegisterToWrite[26]&!invalid,clear);
reg_32 reg27(writeData,q27,clk&regWrite&whichRegisterToWrite[27]&!invalid,clear);
reg_32 reg28(writeData,q28,clk&regWrite&whichRegisterToWrite[28]&!invalid,clear);
reg_32 reg29(writeData,q29,clk&regWrite&whichRegisterToWrite[29]&!invalid,clear);
reg_32 reg30(writeData,q30,clk&regWrite&whichRegisterToWrite[30]&!invalid,clear);
reg_32 reg31(writeData,q31,clk&regWrite&whichRegisterToWrite[31]&!invalid,clear);

reg_select_mux mux1(readReg1,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,readData1);
reg_select_mux mux2(readReg2,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,readData2);
endmodule

/********/

/*** Mips control ***/
/*******Mux of the ALU*********/
module bt1_3_1mux(inp1,inp2,inp3,sel,oup);
input inp1; input inp2; input inp3; input[1:0] sel;
output oup;
assign oup = (sel == 2'b00) ? inp1 : (sel == 2'b01 ? inp2 : inp3); 
endmodule

module bt4_3_1mux(inp1,inp2,inp3,sel,oup);
input[3:0] inp1; input[3:0] inp2; input[3:0] inp3; input[1:0] sel;
output[3:0] oup;
bt1_3_1mux bt1(inp1[0],inp2[0],inp3[0],sel,oup[0]);
bt1_3_1mux bt2(inp1[1],inp2[1],inp3[1],sel,oup[1]);
bt1_3_1mux bt3(inp1[2],inp2[2],inp3[2],sel,oup[2]);
bt1_3_1mux bt4(inp1[3],inp2[3],inp3[3],sel,oup[3]);
endmodule

module bt8_3_1mux(inp1,inp2,inp3,sel,oup);
input[7:0] inp1; input[7:0] inp2; input[7:0] inp3; input[1:0] sel;
output[7:0] oup;
bt4_3_1mux bt1(inp1[3:0],inp2[3:0],inp3[3:0],sel,oup[3:0]);
bt4_3_1mux bt2(inp1[7:4],inp2[7:4],inp3[7:4],sel,oup[7:4]);
endmodule

module bt32_3_1mux(inp1,inp2,inp3,sel,oup);
input[31:0] inp1; input[31:0] inp2; input[31:0] inp3; input[1:0] sel;
output[31:0] oup;
bt8_3_1mux bt1(inp1[7:0],inp2[7:0],inp3[7:0],sel,oup[7:0]);
bt8_3_1mux bt2(inp1[15:8],inp2[15:8],inp3[15:8],sel,oup[15:8]);
bt8_3_1mux bt3(inp1[23:16],inp2[23:16],inp3[23:16],sel,oup[23:16]);
bt8_3_1mux bt4(inp1[31:24],inp2[31:24],inp3[31:24],sel,oup[31:24]);
endmodule

module bt5_2_1mux(inp1,inp2,sel,oup);
input[4:0] inp1; input[4:0] inp2; input sel; output [4:0] oup;
assign oup = sel == 1'b0 ? inp1 : inp2;
endmodule

module bt32_2_1mux(inp1,inp2,sel,oup);
input[31:0] inp1; input[31:0] inp2; input sel; output reg[31:0] oup;
always @(*) begin
	if(sel == 1'b0)
		oup = inp1;
	else
		oup = inp2;
end
endmodule
/*********Gates of the ALU**********/

module and_32(inp1,inp2,oup);
input[31:0] inp1; input[31:0] inp2; output reg[31:0] oup;
integer i;
always @(*) begin
	for(i=0; i <= 31; i=i+1) begin
		oup[i] = inp1[i] & inp2[i];
	end
end
endmodule

module or_32(inp1,inp2,oup);
input[31:0] inp1; input[31:0] inp2; output reg[31:0] oup;
integer i;
always @(*) begin
	for(i=0; i <= 31; i=i+1) begin
		oup[i] = inp1[i] | inp2[i];
	end
end
endmodule

/*******************/

module flipper(inp,m,oup);
input[31:0] inp;
input m;
output reg[31:0] oup;
integer i;
always @(*) begin
	for(i=0; i < 32; i=i+1)	begin
		oup[i] = inp[i] ^ m;
		end
	end
endmodule

module adder_cum_subtracter_32(x,y,m,s,cout,of);
input[31:0] x,y;
output[31:0] s;
output cout;
input m;
output of;
wire[31:0] sOp;
flipper fp(y,m,sOp);
adder_32 ad(x,sOp,m,s,cout,of);
endmodule
/******************/

/*****ALU Control***/
module aluControl(inp1,inp2,bitVert,operation,oup,zero);
input[31:0] inp1; input[31:0] inp2; output[31:0] oup; output reg zero; input bitVert; input[1:0] operation;
wire[31:0] addRes; wire carryRes; wire overflowDetect;
wire[31:0] andRes;
wire[31:0] orRes;
adder_cum_subtracter_32 add(inp1,inp2,bitVert,addRes,carryRes,overflowDetect);
and_32 ander(inp1,inp2,andRes);
or_32 orer(inp1,inp2,orRes);
bt32_3_1mux muxer(andRes,orRes,addRes,operation,oup);
always @(*) begin
	if(oup == 32'b0)
		zero = 1'b1;
	else
		zero = 1'b0;
end

endmodule

/*******/

/****Main Control*****/
module mainControl(opcode,RegDst,RegWrite,AluSrc,AluOp,MemWrite,MemRead,MemToReg,Branch,invalid);
input[5:0] opcode;
output RegDst; output RegWrite; output AluSrc; output[1:0] AluOp; output MemWrite; output MemRead; output MemToReg; output Branch; output invalid;
wire rformat; wire lw; wire sw; wire beq;

assign rformat = (~opcode[0]) & (~opcode[1]) & (~opcode[2]) & (~opcode[3]) & (~opcode[4]) & (~opcode[5]); 
assign lw = opcode[0] & opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4] & opcode[5];
assign sw = opcode[0] & opcode[1] & ~opcode[2] & opcode[3] & ~opcode[4] & opcode[5];
assign beq = ~opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4] & ~opcode[5];

assign invalid = ~rformat & ~lw & ~sw & ~beq;

assign RegDst = rformat;
assign AluSrc = lw | sw;
assign RegWrite = rformat | lw;
assign MemToReg = lw;
assign MemRead = lw;
assign MemWrite = sw;
assign Branch = beq;
assign AluOp[1] = rformat;
assign AluOp[0] =  Branch;

endmodule

module mapToALU(ALUOp, func, operation,bitVert);
input[1:0] ALUOp; input[5:0] func; output reg[1:0] operation; output reg bitVert;
always @(*) begin
	if(ALUOp == 2'b00) begin
		operation = 2'b10;
		bitVert = 1'b0;
	end
	else if(ALUOp == 2'b01) begin
		operation = 2'b01;
		bitVert = 1'b1;
	end
	else if(ALUOp[1] == 1'b1 && func[3:0] == 4'b0000) begin
		operation = 2'b10;
		bitVert = 1'b0;
	end
	else if(ALUOp[1] == 1'b1 && func[3:0] == 4'b0010) begin
		operation = 2'b10;
		bitVert =1'b0;
	end
	else if(ALUOp[1] == 1'b1 && func[3:0] == 4'b0100) begin
		operation = 2'b00;
	end
	else if(ALUOp[1] == 1'b1 && func[3:0] == 4'b0101)
		operation = 2'b01;
	// No slt capability yet
end
endmodule
/********/
/******/

module mips(clk,reset_pc,clear_regFile);
input clk; input reset_pc; input clear_regFile; wire[31:0] instruction; wire[31:0] pc_res; wire[31:0] pc_adder_res; wire pc_carry; wire pc_overflow;
wire[31:0] regRead1; wire[31:0] regRead2;
wire RegDst; wire RegWrite; wire[1:0] AluOp; wire AluSrc; wire MemToReg; wire MemRead; wire MemWrite; wire Branch; wire invalid;
wire[4:0] writeReg; wire[31:0] signExteneded;
wire[31:0] aluSecond; wire[1:0] finalAluInp; wire bitVert; wire[31:0] aluRes; wire aluZero;
wire[31:0] data; wire[31:0] writeData;
wire[31:0] branchTargetOperand;
wire[31:0] branch_target; wire branch_target_overflow; wire branch_target_carry;
wire[31:0] next_address;
// Set reset_pc to 0 when pc is to be overwritten with some value
reg_32 pc(next_address,pc_res,clk,reset_pc);
adder_32 pc_adder(pc_res,32'd4,1'b0,pc_adder_res,pc_carry,pc_overflow);
instructionMemory instr_mem(pc_res,instruction);
mainControl mc(instruction[31:26],RegDst,RegWrite,AluSrc,AluOp,MemWrite,MemRead,MemToReg,Branch,invalid);
mapToALU mp(AluOp,instruction[5:0],finalAluInp,bitVert);
bt5_2_1mux RtOrRd(instruction[20:16],instruction[15:11],RegDst,writeReg);
sign_extender se(instruction[15:0],signExteneded);
registerFile r_file(clk,clear_regFile,instruction[25:21],instruction[20:16],writeReg,writeData,RegWrite,regRead1,regRead2,invalid);
bt32_2_1mux aluSecondOperand(regRead2,signExteneded,AluSrc,aluSecond);
aluControl alu(regRead1,aluSecond,bitVert,finalAluInp,aluRes,aluZero);
dataMemory data_memory(clk,aluRes,data,MemRead,MemWrite,regRead2,invalid);
bt32_2_1mux aluOrMemData(aluRes,data,MemToReg,writeData);
leftShifter ls(signExteneded,branchTargetOperand);
adder_32 next_instr_address(pc_adder_res,branchTargetOperand,1'b0,branch_target,branch_target_carry,branch_target_overflow);
bt32_2_1mux nextAddress(pc_adder_res,branch_target,Branch&aluZero,next_address);
endmodule

module test_mips;
reg clk; reg reset_pc; reg clear_regFile;
mips m(clk,reset_pc,clear_regFile);

always @(clk)
	#40 clk <= ~clk;

initial begin
	$monitor($time," The contents of register pc,t0,t1,t2 are %d %d %d %d %d %d" ,m.pc_res,m.instruction[25:21],m.instruction[20:16],m.writeData,m.regRead1,m.regRead2); 
	#0 	clk = 1'b0; reset_pc = 1'b1; clear_regFile = 1'b1;
	#1 reset_pc = 1'b0; clear_regFile = 1'b0;
	#5 reset_pc = 1'b1; clear_regFile = 1'b1;
	#800 $finish;
end
endmodule