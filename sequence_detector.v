module sd(clk,rst,inp,out);
input clk,inp,rst;
reg[4:0] s;
output reg out;

initial
	s = 3'b000;

always @(posedge clk or posedge rst) begin
	if(rst == 0)
		s = 3'b000;
		
	if(s == 3'b000 && inp == 1'b0);
	else if(s == 3'b000 && inp == 1'b1)
		s = 3'b001;
	else if(s == 3'b001 && inp == 1'b0)
		s = 3'b010;
	else if(s == 3'b001 && inp == 1'b1);
	else if(s == 3'b010 && inp == 1'b0)
		s = 3'b000;
	else if(s == 3'b010 && inp == 1'b1)
		s = 3'b011;
	else if(s == 3'b011 && inp == 1'b0)
		s = 3'b010;
	else if(s == 3'b011 && inp == 1'b1)
		s = 3'b100;
	else if(s == 3'b100 && inp == 1'b0)
		s = 3'b010;
	else if(s == 3'b100 && inp == 1'b1)
		s = 3'b001;
		
	if(s == 3'b100)
		out = 1'b1;
	else
		out = 1'b0;
end
endmodule

module test_bench;
reg clk,rst,inp;
reg[8:0] seq;
wire out;
integer i;

sd sd1(clk,rst,inp,out);
initial begin
	clk = 0; rst = 1; inp = 0;
	seq = 9'b011010110;
	
	for(i=0; i < 9; i=i+1) begin
		inp = seq[i];
		#2 clk = 1;
		#2 clk = 0;
		$display("State is %b and has it been decteted ? %b", sd1.s,out);
	end
end
endmodule