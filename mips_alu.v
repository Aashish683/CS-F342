/*******Mux of the ALU*********/
module bt1_3_1mux(inp1,inp2,inp3,sel,oup);
input inp1; input inp2; input inp3; input[1:0] sel;
output reg oup;
always @(*) begin
	if(sel == 2'b00)
		oup = inp1;
	else if(sel == 2'b01)
		oup = inp2;
	else if(sel == 2'b10)
		oup = inp3;
end
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


// Uncomment to test

// module testBench32_3_1mux;
// reg[31:0] inp1; reg[31:0] inp2; reg[31:0] inp3;
// reg[1:0] sel;
// wire[31:0] op;
// bt32_3_1mux bt(inp1,inp2,inp3,sel,op);
// initial begin
	// inp1 = 'h00000AAA; inp2 = 'h00001AAA; inp3 = 'h00000001; sel = 2'b00;
	// $monitor("The output is %h",op);
	// #100 sel = 2'b01;
	// #150 inp1 = 'hFFFFFFFF; sel = 2'b00;
	// #200 sel = 2'b10;
// end
// endmodule

/*****************/

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

/*******Adder of the ALU****/

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
module aluControl(inp1,inp2,bitVert,operation,oup);
input[31:0] inp1; input[31:0] inp2; output[31:0] oup; input bitVert; input[1:0] operation;
wire[31:0] addRes; wire carryRes; wire overflowDetect;
wire[31:0] andRes;
wire[31:0] orRes;
adder_cum_subtracter_32 add(inp1,inp2,bitVert,addRes,carryRes,overflowDetect);
and_32 ander(inp1,inp2,andRes);
or_32 orer(inp1,inp2,orRes);
bt32_3_1mux muxer(andRes,orRes,addRes,operation,oup);
endmodule

module tb_aluControl;
reg[31:0] inp1; reg[31:0] inp2; wire[31:0] oup; reg bitVert; reg[1:0] operation;
aluControl alu(inp1,inp2,bitVert,operation,oup);
initial begin
	$monitor("The value of the output is %b",oup);
	inp1 = 'h00000001; inp2 = 'h00000001; bitVert = 1'b0; operation = 2'b10;
	#100 bitVert = 1'b1;
	#150	inp1 = 'h00000AAA; inp2 = 'hFFFFFFFF; operation = 2'b00;
	#200	operation = 2'b01;
end
endmodule
/*******/

/****Main Control*****/
module mainControl(opcode,RegDst,RegWrite,AluSrc,AluOp,MemWrite,MemRead,MemToReg,Branch);
input[5:0] opcode;
output RegDst; output RegWrite; output AluSrc; output[1:0] AluOp; output MemWrite; output MemRead; output MemToReg; output Branch;
wire rformat; wire lw; wire sw; wire beq;

assign rformat = (~opcode[0]) & (~opcode[1]) & (~opcode[2]) & (~opcode[3]) & (~opcode[4]) & (~opcode[5]); 
assign lw = opcode[0] & opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4] & opcode[5];
assign sw = opcode[0] & opcode[1] & ~opcode[2] & opcode[3] & ~opcode[4] & opcode[5];
assign beq = ~opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4] & ~opcode[5];

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
input[1:0] ALUOp; input[5:0] func; output reg[2:0] operation; output reg bitVert;
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