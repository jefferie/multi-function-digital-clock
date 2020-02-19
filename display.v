module display(
		hour1,min1,sec1,ahour,amin,hour,min,sec,mode,
		clk, clk_1KHZ, rst_n,d_duan, d_wei
		);
		
input[7:0] hour1,min1,sec1;
input[7:0] ahour,amin;
input mode; 
input clk;   
input clk_1KHZ;  
input rst_n;  

output[7:0]min,sec;
output[7:0]hour;
output [7:0] d_duan;  //段选端
output [7:0] d_wei;   //位选端

reg[7:0]min,sec;
reg[7:0]hour;
reg[1:0]m = 0; 
reg[7:0] d_wei;  
reg[7:0] d_duan;  
reg[3:0] led = 4'h0;   //led灯


always@(posedge mode)//mode信号控制系统在三种功能间转换
begin if(m > 2)m<=0;
	else m<=m+1;
end 

always@(min1 or sec1 or amin or hour1 or ahour or m)
begin case(m)
		0:begin hour<=hour1;min<=min1;sec<=sec1;
		end
		1:begin hour<=ahour;min<=amin;sec<=8'h00;
		end
		2:begin hour<=hour1;min<=min1;sec<=sec1; 
		end 
endcase
end

always@(posedge clk_1KHZ or negedge rst_n)
begin   
if(!rst_n) 
d_wei<=8'b1111_1110;   //复位后选中最低位
	else   
	d_wei<={d_wei[6:0],d_wei[7]};  
end


always@(d_wei or sec or min or hour)  
begin   
	case(d_wei)				
	8'b1111_1110:led<=sec[3:0];    //将秒的低四位数据传给第8个数码管
	8'b1111_1101:led<=sec[7:4];	 //将秒的高四位数据传给第7个数码管
	8'b1111_1011:led<=4'b1010; 		 //-
	8'b1111_0111:led<=min[3:0];    //将分的低四位数据传给第5个数码管
	8'b1110_1111:led<=min[7:4];    //将分的高四位数据传给第4个数码管
	8'b1101_1111:led<=4'b1010;			 //-
	8'b1011_1111:led<=hour[3:0];    //将时的低四位数据传给第2个数码管
	8'b0111_1111:led<=hour[7:4];    //将时的高四位数据传给第1个数码管  
	endcase  
end

always@(led)   //选中段选端并送数据  
begin   
	case(led)
	4'b0000:d_duan=8'b0000_0011;    //0
	4'b0001:d_duan=8'b1001_1111; 	  //1
   4'b0010:d_duan=8'b0010_0101;    //2
	4'b0011:d_duan=8'b0000_1101;    //3
	4'b0100:d_duan=8'b1001_1001;    //4
	4'b0101:d_duan=8'b0100_1001;    //5
	4'b0110:d_duan=8'b0100_0001;    //6
	4'b0111:d_duan=8'b0001_1111;    //7
	4'b1000:d_duan=8'b0000_0001;    //8
	4'b1001:d_duan=8'b0001_1001;    //9    
	4'b1010:d_duan=8'b1111_1101;     //-
	default:d_duan=8'b1111_1111;   
	endcase  
end 


endmodule