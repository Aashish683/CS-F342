module bht(clk,address,writeSignal,writeData,oup);
input clk;
input[9:0] address; input writeSignal; input[1:0] writeData; output[1:0] oup;
reg[1:0] memLocs[1023:0];
integer i;
initial begin
	for(i=0; i < 1024; i=i+1) begin
		memLocs[i] = 2'b00;
	end
end

assign oup = memLocs[address];

always @(posedge clk) begin
	if(writeSignal == 1'b1)
		memLocs[address] = writeData;
	end
endmodule

module mux(inp1,inp2,sel,oup);
input[1:0] inp1,inp2; input sel; output[1:0] oup; 
assign oup = (sel == 1'b0) ? inp1 : inp2;
endmodule

module predictor(clk,prev_actual,next_predict,wd);
input clk;
input prev_actual;
input wd;
output reg[1:0] next_predict;
reg[1:0] state;
initial 
	state = 2'b00;
	
always @(posedge clk) begin
	if(wd == 1'b1) begin
		if(state == 2'b00 && prev_actual == 1'b0)
			state = 2'b00;
		else if(state == 2'b00 && prev_actual == 1'b1)
			state = 2'b01;
		else if(state == 2'b01 && prev_actual == 1'b0)
			state = 2'b00;
		else if(state == 2'b01 && prev_actual == 1'b1)
			state = 2'b11;
		else if(state == 2'b10 && prev_actual == 1'b0)
			state = 2'b00;
		else if(state == 2'b10 && prev_actual == 1'b1)
			state = 2'b11;
		else if(state == 2'b11 && prev_actual == 1'b0)
			state = 2'b10;
		else if(state == 2'b11 && prev_actual == 1'b1)
			state = 2'b11;
	end
	next_predict = state;
end
endmodule

module INTG(clk,address,outcome,predict);
input clk;
input[9:0] address; input outcome;
wire[1:0] bht1res; wire[1:0] bht2res;
wire[1:0] next_predict1;
wire[1:0] next_predict2;
wire writeData1; wire writeData2;
reg previous;
wire[1:0] pr;
output predict;

initial
	previous = 1'b0;
	
always @(posedge clk)
	#39 previous = outcome; // Necessary to add delay otherwise the current outcome will be made into previous and all the results will be based on the current one.

bht b1(clk,address,writeData1,next_predict1,bht1res);
bht b2(clk,address,writeData2,next_predict2,bht2res);
predictor p1(clk,outcome,next_predict1,writeData1);
predictor p2(clk,outcome,next_predict2,writeData2);
mux m(bht1res,bht2res,previous,pr);


assign predict = ((pr == 2'b00 || pr == 2'b01) ? 1'b0 : 1'b1);
assign writeData1 = (previous == 1'b0) ? 1'b1 : 1'b0;
assign writeData2 = (previous == 1'b1) ? 1'b1 : 1'b0;

endmodule

module tb;
reg clk; reg[9:0] address; reg outcome; wire predict;
INTG intg(clk,address,outcome,predict);
initial begin
	clk = 1'b1;
	address = 10'b0011110000;
end

initial begin
	forever begin
		#20 clk = ~clk;
	end
end
	
initial begin
	$monitor($time, " The actual outcome is %b, prev_actual sent to the predictors are %b %b the states of the bht are %b %b the prediction for it is %b" , outcome,intg.p1.prev_actual,intg.p2.prev_actual,intg.p1.state,intg.p2.state,intg.predict);
	#0 outcome = 1'b0;
	#40 outcome = 1'b1;
	#40 outcome = 1'b1;
	#40 outcome = 1'b1;
	#40 outcome = 1'b0;
	$finish;
end
endmodule
