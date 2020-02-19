module top(
	      clk,rst_n,
			mode,turn,
			change,
			LD_hour,LD_min,
			alert,
			LD_alert,clcok_stop,
			d_duan,d_wei
  
);

input clk,rst_n;
input mode,change,turn;
input clcok_stop;

output LD_hour,LD_min,LD_alert;
output alert;
output[7:0] d_duan,d_wei;
//-------------------------分频器模块----------------------------//
wire clk_1HZ,clk_100HZ,clk_1KHZ,clk;
fenpinqi  fenpinqi_rst(
		.clk(clk),.clk_1HZ(clk_1HZ),.clk_100HZ(clk_100HZ),.clk_1KHZ(clk_1KHZ),.rst_n(rst_n)
);


//-------------------------按键消抖模块------------------------------//

wire[2:0] led_ctrl;
sw_debounce		sw_debounce_rst(
    		.clk(clk),.rst_n(rst_n),
			.mode(mode),.turn(turn),.change(change),.led_ctrl(led_ctrl)
    		);


//------------------------计时模块----------------------------------//

wire[7:0] sec1,min1,hour1,amin,ahour;
wire count1,counta;
jishi		jishi_rst(
				.clk(clk),.clk_1HZ(clk_1HZ), .turn(led_ctrl[1]),
				.mode(led_ctrl[0]),.count1(count1),.counta(counta),.sec1(sec1),.min1(min1),.hour1(hour1)
				);


//-----------------------时间设置模块------------------------------//

wire count2,countb;
wire LD_min,LD_hour;

time_set		time_set_rst(
		.change(led_ctrl[2]),.turn(led_ctrl[1]),.count1(count1),.count2(count2),.counta(counta),.countb(countb),.LD_min(LD_min),.LD_hour(LD_hour),.mode(led_ctrl[0])
		);
		
//-----------------------报时-------------------------------------//

wire clcok_stop;
wire alert;

ring  ring_rst(
			.clk(clk),.clk_1KHZ(clk_1KHZ),.min1(min1),.sec1(sec1),.amin(amin),.hour1(hour1),.ahour(ahour),.clcok_stop(clcok_stop),.alert(alert),.clk_100HZ(clk_100HZ)
			);
		
		
//-----------------------闹钟模块---------------------------------//

wire LD_alert;

alarmclock		alarmclock_rst(
			.clk(clk),.amin(amin),.ahour(ahour),.count2(count2),.countb(countb),.LD_alert(LD_alert)
);

//----------------------显示模块----------------------------------//

wire hour,min,sec;
wire[7:0] d_duan,d_wei;

display		display_rst(
		.hour1(hour1),.min1(min1),.sec1(sec1),.ahour(ahour),.amin(amin),.hour(hour),.min(min),.sec(sec),.mode(led_ctrl[0]),
		.clk(clk), .clk_1KHZ(clk_1KHZ), .rst_n(rst_n),.d_duan(d_duan), .d_wei(d_wei)
		);
		
		
		
		
endmodule
