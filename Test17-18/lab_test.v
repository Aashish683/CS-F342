`timescale 1ns / 1ps

module mux_2_1(inp1,inp2,sel,out);
	input inp1,inp2,sel; output out;
	assign out = (sel == 1'b1) ? inp1 : inp2;
endmodule

module mux_8_1(in,out,s);
input[7:0] in; output out; input[2:0] s;
wire w1,w2,w3,w4,w5,w6;
mux_2_1 m1(in[7],in[6],s[0],w1);
mux_2_1 m2(in[5],in[4],s[0],w2);
mux_2_1 m3(in[3],in[2],s[0],w3);
mux_2_1 m4(in[1],in[0],s[0],w4);
mux_2_1 m5(w1,w2,s[1],w5);
mux_2_1 m6(w3,w4,s[1],w6);
mux_2_1 m7(w5,w6,s[2],out);
endmodule

module t_ff(clk,t,clear_neg,q);
input clk,clear_neg,t; output reg q;
always @(posedge clk or negedge clear_neg) begin
	if(clear_neg == 1'b0)
		q <= 1'b0;
	else begin
		if(t == 1'b0);
		else
			q <= ~q;
	end
end
endmodule

module COUNTER_4BIT(clk,q,clear_neg);
input clk,clear_neg; output[3:0] q;
t_ff t1(clk,1'b1,clear_neg,q[0]);
t_ff t2(clk,q[0],clear_neg,q[1]);
t_ff t3(clk,q[0]&q[1],clear_neg,q[2]);
t_ff t4(clk,q[1]&q[1]&q[2],clear_neg,q[3]);
endmodule

module COUNTER_3BIT(clk,q,clear_neg);
input clk,clear_neg; output[2:0] q;
t_ff t1(clk,1'b1,clear_neg,q[0]);
t_ff t2(clk,q[0],clear_neg,q[1]);
t_ff t3(clk,q[0]&q[1],clear_neg,q[2]);
endmodule

module MEMORY(address,data);
input[3:0] address; output reg[7:0] data;
reg[7:0] registers[7:0];
initial begin
	registers[0] = 8'hCC;
	registers[1] = 8'hAA;
	registers[2] = 8'hCC;
	registers[3] = 8'hAA;
	registers[4] = 8'hCC;
	registers[5] = 8'hAA;
	registers[6] = 8'hCC;
	registers[7] = 8'hAA;
end

always @(*)
	data = registers[address];
endmodule

module INTG(clk,clear_neg,wform);
	input clk,clear_neg;
	output wform;
	wire[3:0] c4out;
	wire[2:0] c3out;
	wire[7:0] data;
	COUNTER_3BIT c3(clk,c3out,clear_neg);
	COUNTER_4BIT c4(c3out[2]&c3out[1]&c3out[0],c4out,clear_neg);
	MEMORY mem(c4out,data);
	mux_8_1 m(data,wform,c3out);
endmodule

module test_bench;
	reg clk,clear_neg; wire wform;
	
	INTG intg(clk,clear_neg,wform);
	initial begin
	forever
		#500000 clk <= ~clk;
	end
	
	initial begin
		clear_neg = 1'b1;
		clk = 1'b0;
		$monitor($time, " The waveform is at %b " ,wform);
		#10 clear_neg = 1'b0;
		#10 clear_neg = 1'b1;
		#50000000 $finish;
	end
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars();
	end
endmodule