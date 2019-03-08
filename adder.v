
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
	
// assign oup[0] = inp[0]^m;
// assign oup[1] = inp[1]^m;
// assign oup[2] = inp[2]^m;
// assign oup[3] = inp[3]^m;
// assign oup[4] = inp[4]^m;
// assign oup[5] = inp[5]^m;
// assign oup[6] = inp[6]^m;
// assign oup[7] = inp[7]^m;
// assign oup[8] = inp[8]^m;
// assign oup[9] = inp[9]^m;
// assign oup[10] = inp[10]^m;
// assign oup[11] = inp[11]^m;
// assign oup[12] = inp[12]^m;
// assign oup[13] = inp[13]^m;
// assign oup[14] = inp[14]^m;
// assign oup[15] = inp[15]^m;
// assign oup[16] = inp[16]^m;
// assign oup[17] = inp[17]^m;
// assign oup[18] = inp[18]^m;
// assign oup[19] = inp[19]^m;
// assign oup[20] = inp[20]^m;
// assign oup[21] = inp[21]^m;
// assign oup[22] = inp[22]^m;
// assign oup[23] = inp[23]^m;
// assign oup[24] = inp[24]^m;
// assign oup[25] = inp[25]^m;
// assign oup[26] = inp[26]^m;
// assign oup[27] = inp[27]^m;
// assign oup[28] = inp[28]^m;
// assign oup[29] = inp[29]^m;
// assign oup[30] = inp[30]^m;
// assign oup[31] = inp[31]^m;
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

module testBench;
reg[31:0] x,y;
reg control;
wire of;
wire c;
wire[31:0] s;
integer i;
adder_cum_subtracter_32 ad(x,y,control,s,c,of);
initial
	begin
		control = 1'b0;
		$monitor(,$time,"x=%b, y=%b s=%b c=%b of=%b",x,y,s,c,of);
		#0 x = 'h0002; y = 'h0003;
		#2 x = 'h0009; y = 'h0001;
		#10 x = 'h0009; y = 'h000A;
		#28 control=1'b1; x = 'h0002; y = 'h0002;
		#35 control = 1'b0; x = 'h7FFFFFFF; y = 'h7FFFFFFF;
		#100 $finish;
	end
	

endmodule