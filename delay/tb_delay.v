`timescale 1ns/1ns

module tb_delay();
    reg i_clk;
    reg i_rst_n;
    reg  [7:0] iv_data;
    wire [7:0] ov_data;

    
    integer i;

    initial begin
        i_clk = 1;
        forever #5 i_clk = ~i_clk;
    end

    initial begin
        i_rst_n = 0;
        iv_data = 'b0;

        #10 i_rst_n = 1;

        for(i = 0; i < 16; i=i+1) begin
            #10 iv_data <= i;
        end

        #50 $finish;
    end

    initial begin
        $monitor("time = %0t, iv_data = %b, ov_data = %b", $time, iv_data, ov_data);
    end
    
    delay u_delay(
        .i_clk     (i_clk),
        .i_rst_n   (i_rst_n),
        .iv_data   (iv_data),
        .ov_data   (ov_data)
    );

    initial begin            
        $dumpfile("delay.vcd");        //生成的vcd文件名称
        $dumpvars(0, tb_delay);    //tb模块名称
    end
endmodule