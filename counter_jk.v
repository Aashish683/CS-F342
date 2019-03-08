module jk(j,k,clk,q);
input j,k,clk;
output reg q;

initial 
	q = 0;

always @(posedge clk) begin
	if(j == 0 & k == 0);
	
	else if(j == 0 && k == 1)
		q = 0;
	else if(j == 1 && k == 0)
		q = 1;
	else if(j == 1 && k == 1)
		q = ~q;
		
end
endmodule

module jk_counter(clk,q);
input clk;
output [3:0] q;
jk jk1(1'b1,1'b1,clk,q[0]);
jk jk2(q[0],q[0],clk,q[1]);
jk jk3(q[0]&q[1],q[0]&q[1],clk,q[2]);
jk jk4(q[0]&q[1]&q[2],q[0]&q[1]&q[2],clk,q[3]);
endmodule

module test_bench;
reg clk;
wire[3:0] q;
jk_counter jkc(clk,q);
initial 
	clk = 0;

initial begin
	forever begin
	#2 clk = ~clk;
	end
end	
initial begin
	$monitor($time," count is %b" ,q);
	#100 $finish;
end
endmodule