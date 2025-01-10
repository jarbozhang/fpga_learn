module delay (
    input wire i_clk,
    input wire i_rst_n,
    input wire [7:0] iv_data,
    output wire [7:0] ov_data
);
    reg [7:0] ov_reg1;
    reg [7:0] ov_reg2;
    assign ov_data = ov_reg2;

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            ov_reg1 <= 8'b0;
            ov_reg2 <= 8'b0;
        end else begin
            ov_reg1 <= iv_data;
            ov_reg2 <= ov_reg1;
        end
    end
    
endmodule