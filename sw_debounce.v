`timescale 1ns / 1ps
module sw_debounce(
    		clk,rst_n,
			mode,turn,change,led_ctrl
    		);

input   clk;	//主时钟信号，50MHz
input   rst_n;	//复位信号，低有效
input   mode,turn,change; 	//三个独立按键，低表示按下
output[2:0] led_ctrl;

//---------------------------------------------------------------------------
reg[2:0] key_rst;  

always @(posedge clk  or negedge rst_n)
    if (!rst_n) key_rst <= 3'b111;
    else key_rst <= {change,turn,mode};

reg[2:0] key_rst_r;       //每个时钟周期的上升沿将 low_sw 信号锁存到 low_sw_r 中
always @ ( posedge clk  or negedge rst_n )
    if (!rst_n) key_rst_r <= 3'b111;
    else key_rst_r <= key_rst;
   
//当寄存器 key_rst 由 1 变为 0 时，led_an 的值变为高，维持一个时钟周期
wire[2:0] key_an;
assign key_an = key_rst_r & (~key_rst);

//---------------------------------------------------------------------------
reg[19:0]  cnt;	//计数寄存器

always @ (posedge clk  or negedge rst_n)
    if (!rst_n) cnt <= 20'd0;	//异步复位
	else if(key_an) cnt <=20'd0;
    else cnt <= cnt + 1'b1;
  
reg[2:0] low_sw;

always @(posedge clk  or negedge rst_n)
    if (!rst_n) low_sw <= 3'b111;
    else if (cnt == 20'hfffff) 	//满 20ms，将按键值锁存到寄存器 low_sw 中 cnt == 20'hfffff
      low_sw <= {change,turn,mode};   //每20ms锁存一次按键值
      
//---------------------------------------------------------------------------
reg  [2:0] low_sw_r;       //每个时钟周期的上升沿将 low_sw 信号锁存到 low_sw_r 中

always @ ( posedge clk  or negedge rst_n )
    if (!rst_n) low_sw_r <= 3'b111;
    else low_sw_r <= low_sw;
/*
low_sw		111 111 111 110 110 110  
~low_sw     000 000 000 001 001 001
low_sw_r        111 111 111 110 110 110

led_ctrl	000 000 000 001 000 000 
   */
//当寄存器 low_sw 由 1 变为 0 时，led_ctrl 的值变为高，维持一个时钟周期
wire[2:0] led_ctrl;
assign led_ctrl = low_sw_r[2:0] & ( ~low_sw[2:0]);

endmodule