module encoder(inp,oup);
input[7:0] inp; output reg[2:0] oup;
always @(*) begin
	if(inp == 8'b00000001)
		oup = 3'd0;
	else if(inp == 8'b00000010)
		oup = 3'd1;
	else if(inp == 8'b00000100)
		oup = 3'd2;
	else if(inp == 8'b00001000)
		oup = 3'd3;
	else if(inp == 8'b00010000)
		oup = 3'd4;
	else if(inp == 8'b00100000)
		oup = 3'd5;
	else if(inp == 8'b01000000)
		oup = 3'd6;
	else if(inp == 8'b10000000)
		oup = 3'd7;
	else
		oup = 3'd0;
end
endmodule

module adder(in1,in2,cin,s,cout);
input in1; input in2; input cin; output s; output cout;
assign s = in1 ^ (in2 ^ cin);
assign cout = (in1&cin) | (in2&cin) | (in1&in2); 
endmodule

module bt4_flip(in,out);
input[3:0] in; output[3:0] out;
assign out[0] = ~in[0];
assign out[1] = ~in[1];
assign out[2] = ~in[2];
assign out[3] = ~in[3];
endmodule

module bt4_sub(in1,in2,s,cout);
input[3:0] in1; input[3:0] in2; output[3:0] s; output cout;
wire[3:0] res;
bt4_flip f(in2,res);
bt4_add ad(in1,res,1'b1,s,cout);
endmodule

module bt4_add(in1,in2,cin,s,cout);
input[3:0] in1; input[3:0] in2; input cin; output[3:0] s; output cout;
wire[2:0] carry;
adder a1(in1[0],in2[0],cin,s[0],carry[0]);
adder a2(in1[1],in2[1],carry[0],s[1],carry[1]);
adder a3(in1[2],in2[2],carry[1],s[2],carry[2]);
adder a4(in1[3],in2[3],carry[2],s[3],cout);
endmodule

module bt4_and(inp1,inp2,out);
input[3:0] inp1; input[3:0] inp2; output[3:0] out;
assign out[0] = inp1[0] & inp2[0];
assign out[1] = inp1[1] & inp2[1];
assign out[2] = inp1[2] & inp2[2];
assign out[3] = inp1[3] & inp2[3];
endmodule

module bt4_nand(inp1,inp2,out);
input[3:0] inp1; input[3:0] inp2; output[3:0] out;
assign out[0] = ~(inp1[0] & inp2[0]);
assign out[1] = ~(inp1[1] & inp2[1]);
assign out[2] = ~(inp1[2] & inp2[2]);
assign out[3] = ~(inp1[3] & inp2[3]);
endmodule

module bt4_or(inp1,inp2,out);
input[3:0] inp1; input[3:0] inp2; output[3:0] out;
assign out[0] = inp1[0] | inp2[0];
assign out[1] = inp1[1] | inp2[1];
assign out[2] = inp1[2] | inp2[2];
assign out[3] = inp1[3] | inp2[3];
endmodule

module bt4_xor(inp1,inp2,out);
input[3:0] inp1; input[3:0] inp2; output[3:0] out;
assign out[0] = inp1[0] ^ inp2[0];
assign out[1] = inp1[1] ^ inp2[1];
assign out[2] = inp1[2] ^ inp2[2];
assign out[3] = inp1[3] ^ inp2[3];
endmodule

module bt4_xnor(inp1,inp2,out);
input[3:0] inp1; input[3:0] inp2; output[3:0] out;
assign out[0] = ~(inp1[0] ^ inp2[0]);
assign out[1] = ~(inp1[1] ^ inp2[1]);
assign out[2] = ~(inp1[2] ^ inp2[2]);
assign out[3] = ~(inp1[3] ^ inp2[3]);
endmodule


module bt4_nor(inp1,inp2,out);
input[3:0] inp1; input[3:0] inp2; output[3:0] out;
assign out[0] = ~(inp1[0] | inp2[0]);
assign out[1] = ~(inp1[1] | inp2[1]);
assign out[2] = ~(inp1[2] | inp2[2]);
assign out[3] = ~(inp1[3] | inp2[3]);
endmodule 

module bt5_parity_generator(inp,parity);
input[4:0] inp; output parity;
assign parity = ^(inp);
endmodule

// module tb;
// reg[3:0] inp; wire parity;
// bt4_parity_generator pg(inp,parity);
// initial begin
	// $monitor($time," The parity for the input is %b",parity);
	// #20 inp = 4'b0000;
	// #20 inp = 4'b0001;
	// #20 inp = 4'b0011;
	// #20 inp = 4'b0111;
	// #20 inp = 4'b1111;
	// #20 inp = 4'b1010;
	// #20 inp = 4'b1110;
	// #200 $finish;
// end
// endmodule

module first_pipeline_reg(clk,in,out,clear_neg);
input clk; input[10:0] in; input clear_neg; output reg[10:0] out;
always @(posedge clk or negedge clear_neg) begin
	if(clear_neg == 1'b0)
		out <= 10'b0;
	else
		out <= in;
end
endmodule

module sec_pipeline_reg(clk,in,out,clear_neg);
input clk; input[4:0] in; input clear_neg; output reg[4:0] out;
always @(posedge clk or negedge clear_neg) begin
	if(clear_neg == 1'b0)
		out <= 5'b0;
	else
		out <= in;
end
endmodule

module alu(inp1,inp2,control,res,c);
input[3:0] inp1; input[3:0] inp2; input[2:0] control; output reg[3:0] res; output reg c;
wire[3:0] add; wire addCarry; wire[3:0] sub; wire subCarry;
wire[3:0] and_w; wire[3:0] or_w; wire[3:0] nand_w; wire[3:0] xor_w; wire[3:0] xnor_w; wire[3:0] nor_w;
bt4_add ad(inp1,inp2,1'b0,add,addCarry);
bt4_sub sb(inp1,inp2,sub,subCarry);
bt4_and ander(inp1,inp2,and_w); bt4_or orer(inp1,inp2,or_w); bt4_nand nander(inp1,inp2,nand_w); bt4_xor xorer(inp1,inp2,xor_w); bt4_xnor xnorer(inp1,inp2,xnor_w);
bt4_nor norer(inp1,inp2,nor_w);
always @(*) begin
	if(control == 'd0) begin
		res = add;
		c = addCarry;
	end
	else if(control == 'd1) begin
		res = sub;
		c = subCarry;
	end
	else if(control == 'd2) begin
		res = xor_w;
		c = 1'b0;
	end
	else if(control == 'd3) begin
		res = or_w;
		c = 1'b0;
	end
	else if(control == 'd4) begin
		res = and_w;
		c = 1'b0;
	end
	else if(control == 'd5) begin
		res = nor_w;
		c = 1'b0;
	end
	else if(control == 'd6) begin
		res = nand_w;
		c = 1'b0;
	end
	else if(control == 'd7) begin
		res = xnor_w;
		c = 1'b0;
	end
end
//assign res = (control==3'd0) ? (inp1+inp2) : (control==3'd1) ? ()
endmodule

module pipe_line(clk,in,A,B,clear_pipeline,parity);
input clk; input clear_pipeline;
input[3:0] A; input[3:0] B;
input[7:0] in; wire[2:0] encoded;
wire[10:0] from_first;
wire[10:0] first_pipeline_input;
wire[4:0] sec_pipeline_input;
wire[3:0] aluRes; wire carry;
wire[4:0] from_second;
output parity;
encoder enc(in,encoded);

assign first_pipeline_input[10:8] = encoded; assign first_pipeline_input[7:4] = A; assign first_pipeline_input[3:0] = B;
first_pipeline_reg fpr(clk,first_pipeline_input,from_first,clear_pipeline);
alu ALU(from_first[7:4],from_first[3:0],from_first[10:8],aluRes,carry);
assign sec_pipeline_input[3:0] = aluRes; assign sec_pipeline_input[4] = carry;
sec_pipeline_reg spr(clk,sec_pipeline_input,from_second,clear_pipeline);
bt5_parity_generator pg(from_second,parity);
endmodule

module tb;
reg clk; reg[7:0] in; reg[3:0] A,B; reg clear_pipeline; wire parity;
pipe_line pl(clk,in,A,B,clear_pipeline,parity);

always
#10 clk = ~clk;

initial begin
	$monitor($time," The values of the encoded, pipeline registers and parity are %d %d %d %d %d %b" ,pl.encoded,pl.fpr.out[10:8],pl.fpr.out[7:4],pl.fpr.out[3:0],pl.spr.out,parity);
	#0 clk = 1'b0; 
	#20 in = 8'b00000000; A = 4'b0001; B = 4'b0100;
	#20 A = 4'd10; B = 4'd11;
	#20 A = 4'd9; B = 4'd7;
	#20 in = 8'b00010000; A = 4'hF; B = 4'hA;
	#40 $finish;
end
endmodule