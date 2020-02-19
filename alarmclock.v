module alarmclock(
			clk,amin,ahour,count2,countb,LD_alert
); 
input clk,count2,countb; 
output[7:0]amin;
output[7:0]ahour;
output LD_alert;
wire LD_alert;
reg [7:0] amin=0;
reg [7:0] ahour=0;
reg[1:0]m = 2'b01;

wire k = (m == 2'b01)? 1:0;


assign ct2=((~k) & clk)||(count2);//ct2用于定时状态下调整分钟信号
assign LD_alert=(ahour|amin)?0:1;//指示是否进行了闹铃定时
always@(posedge ct2)
	if(amin==8'h59)   
		amin<=0;
		else if(amin[3:0]==9) 
		begin amin[3:0]<=0; 
				amin[7:4]<=amin[7:4]+1;
		end 
			else amin[3:0]<=amin[3:0]+1;
			
			
assign ctb=((~k) & clk)||(countb);////ctb用于定时状态调节小时信号
always@(posedge ctb)
	if(ahour==8'h23) 	ahour<=0;
		else if(ahour[3:0]==9) 
		begin ahour[3:0]<=0;
				ahour[7:4]<=ahour[7:4]+1;
		end 
			else ahour[3:0]<=ahour[3:0]+1;
endmodule