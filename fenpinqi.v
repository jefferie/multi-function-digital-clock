module fenpinqi(clk,clk_1HZ,clk_100HZ,clk_1KHZ,rst_n);
input clk,rst_n;
output clk_1HZ,clk_100HZ,clk_1KHZ;
reg clk_1HZ=0,clk_1KHZ=0,clk_100HZ=0,clk_1=0,clk_2=0,clk_3=0;
reg[6:0] cnt1=0,cnt2=0,cnt3=0,cnt4=0,cnt5=0;
wire clk_100Hz;
always@(posedge clk)
begin 
	if(cnt1 < 12/2-1)   //12分频，生成1MHZ信号
	begin 
	cnt1 <= cnt1+1;
	end
		else
			begin
			cnt1 <= 0;
			clk_1 <= ~clk_1;
			end
end

always@(posedge clk_1)
begin 
	if(cnt2 < 100/2-1)  //100分频，生成10000HZ信号
	begin 
	cnt2 <= cnt2+1;
	end
		else
			begin
			cnt2 <=0;
			clk_2 <= ~clk_2;
			end
end


always@(posedge clk_2)
begin 
	if(cnt3 < 10/2-1)  //10分频，生成1KHZ信号
	begin 
	cnt3 <= cnt3+1;
	end
		else
			begin
			cnt3 <=0;
			clk_1KHZ <= ~clk_1KHZ;
			end
end


always@(posedge clk_1KHZ)
begin 
	if(cnt4 < 10/2-1) 	//10分频，生成100HZ信号
	begin 
	cnt4 <= cnt4+1;
	end
		else
			begin
			cnt4 <=0;
			clk_100HZ <= ~clk_100HZ;
			end
end

always@(posedge clk_100HZ)
begin 
	if(cnt5 < 100/2-1)  //100分频，生成1HZ信号
	begin 
	cnt5 <= cnt5+1;
	end
		else
			begin
			cnt5 <=0;
			clk_1HZ <= ~clk_1HZ;
			end
end

endmodule

