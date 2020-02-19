module ring(
			clk,clk_1KHZ,min1,sec1,amin,hour1,ahour,clcok_stop,alert,clk_100HZ
			);
			
input[7:0]min1,sec1,amin;
input[7:0]hour1,ahour;
input clcok_stop,clk,clk_1KHZ,clk_100HZ;

output alert; 

wire[7:0]min1,sec1,amin;
wire[7:0]hour1,ahour;
wire clcok_stop; 

reg alert1=1'b0,alert2=1'b0;
reg[1:0] sound;
reg ear;

wire alert;
wire clk_1KHZ,clk;

always@(posedge clk) 
	if((min1==amin)&&(hour1==ahour)&&(clcok_stop == 1'b0)) alert1 <= 1'b0;
	else alert1 <= 1'b1;

				
always@(posedge clk)
if((min1 == 8'h00) && (sec1 == 8'h01)  ||  (min1 == 8'h00) && (sec1 == 8'h00))   
alert2 <= 1'b0;
else
alert2 <= 1'b1;


assign alert= (alert1 ? 1'b1 : clk_100HZ) & (alert2 ? 1'b1 : clk_1KHZ);  //产生闹铃音或整点报时音
endmodule