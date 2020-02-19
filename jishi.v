module jishi(clk,clk_1HZ, turn,
				mode,count1,counta,sec1,min1,hour1
				);
				
input clk,clk_1HZ,turn;
input mode; 
input count1,counta;

output[7:0]sec1,min1;
output[7:0]hour1; 
wire clk_1HZ,ct1,cta,turn;
reg[7:0]sec1=0,min1=0;
reg[7:0]hour1=0;
reg[1:0]m = 0;
wire count1,counta;
reg minclk,hclk;

always@(posedge mode)//mode信号控制系统在三种功能间转换
begin if(m > 2) m<=0;
	else m<=m+1;
end 

wire k = (m == 2'b10)? 1:0;
/////秒钟计时模块//////
wire sec_clk = (~k) & clk_1HZ;
always@(posedge sec_clk) 
if(sec1==8'h59)
	begin 
	sec1<=0;
	minclk<=1;///产生进位
	end
		else
			begin if(sec1[3:0]==4'b1001)
				begin sec1[3:0]<=4'b0000;
						sec1[7:4]<=sec1[7:4]+1;
				end 
					else
						sec1[3:0]<=sec1[3:0]+1; 
						minclk<=0;
			end


////////-------------------分钟计时模块--------------/// 
assign m_clk = ((~k) & minclk)||count1;/////m_clk产生进位或校正改变 
//assign ct1=clk|m_clk;//ct1用于计时、校时中的分钟计数

always@(posedge m_clk)
begin if(min1 == 8'h59)
			begin min1<=0;
					hclk<=1;
			end 
				else 
					begin if(min1[3:0]==9)
						begin min1[3:0]<=0;
								min1[7:4]<=min1[7:4]+1;
						end 
							else min1[3:0]<=min1[3:0]+1; 
							  hclk<=0;
					end
end


////////-------------------小时计时模块--------------/// 
assign h_clk=((~k) & hclk)||counta;//////h_clk产生进位或校正改变 
//assign cta=(num4&clk)|(!num4&h_clk);//cta用于计时、校时中的小时计数
always@(posedge h_clk)
	if(hour1==8'h23)
		hour1<=0;
		else if(hour1[3:0]==9) 
			begin hour1[7:4]<=hour1[7:4]+1;
					hour1[3:0]<=0;
			end 
				else hour1[3:0]<=hour1[3:0]+1;
				
endmodule
