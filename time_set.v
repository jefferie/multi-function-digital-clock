module time_set(
		change,turn,count1,count2,counta,countb,LD_min,LD_hour,mode
		);
		
input change,mode,turn; 

output count1,count2,counta,countb,LD_min,LD_hour;

reg[1:0] m = 0;
 
reg fm=0,count1=0,count2=0,counta=0,countb=0,LD_min=1,LD_hour=1;

wire mode,turn,change; 

always@(posedge mode)  //mode信号控制系统在三种功能间转换
begin if(m > 2)
			m <= 0;
			else m <= m+1;
end 

always@(posedge turn)//////////接按键，在手动校时功能时，选择是调整小时，还是分钟；
begin fm <= ~fm;
end 

always@(m or fm or change)
	begin case(m) 
	2:begin////////2：调节时间功能； 
		if(fm) 
		begin count1<=change;
				{LD_min,LD_hour} <= 1;
		end//////指示当前调整的是分钟 
		else begin counta<=change;
					  {LD_min,LD_hour}<=2;
				end/////指示当前调整的是小时 
				{count2,countb}<=0;
				end 
	1:begin //////1：调节闹钟功能
		if(fm) 
		begin count2<=change; 
				{LD_min,LD_hour}<=1;
		end /////指示当前调整的是分 
			else begin countb <= change;
						  {LD_min,LD_hour}<=2;
						  end/////指示当前调整的是小时
						  {count1,counta}<=0;
						  end 
	0:begin{count1,count2,counta,countb,LD_min,LD_hour}<=0;
	
	end////0：计时功能
	endcase 
	end
endmodule