module shift_reg(in,en,clk,r);
parameter n = 4;
input in,en,clk;
output reg[n-1:0] r;
initial
	r = 4'b0000;
always @(posedge clk) begin
    if(en)
		r = {in,r[n-1:1]};
end
endmodule


module test_bench;
parameter n = 4;
reg in,en,clk;
wire[n-1:0] r;
shift_reg sr(in,en,clk,r);

initial begin
clk = 0;
en = 0;
in = 0;
end

always
#2 clk = ~clk;

initial begin
	$monitor($time," en=%b in=%b sr=%b",en,in,r);
	#2 en = 1'b1; in = 1'b1;
	#6 en = 1'b1; in = 1'b1;
	#10 en = 1'b1; in = 1'b1;
	#14 en = 1'b1; in = 1'b1;
	#18 en = 1'b1; in = 1'b1;
	#22 en = 1'b0; in = 1'b0;
	#26 en = 1'b1; in = 1'b0;
	#30 en = 1'b0; in = 1'b0;
	#34 en = 1'b0; in = 1'b1;
	#38 $finish;
end
endmodule