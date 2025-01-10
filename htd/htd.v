module htd #(
  parameter DATA_WIDTH = 8
) (
    input wire                  i_clk,
    input wire                  i_rst_n,
    input wire [DATA_WIDTH-1:0] iv_data,
    input wire                  i_data_wr,
    output wire [DATA_WIDTH:0]  ov_data,
    output wire                 o_data_wr
);

  reg [DATA_WIDTH-1:0]  iv_data_reg;
  reg                   i_data_wr_reg;
  reg [DATA_WIDTH:0]    ov_data_reg;
  reg                   o_data_wr_reg;

  parameter IDLE_S = 2'b00;
  parameter TRANS_FIRST_S = 2'b01;
  parameter TRANS_S = 2'b10;
  reg [1:0] st_current;

  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      iv_data_reg <= 0;
      i_data_wr_reg <= 0;
      ov_data_reg <= 0;
      o_data_wr_reg <= 0;
      st_current <= IDLE_S;
    end else begin
      iv_data_reg <= iv_data;
      i_data_wr_reg <= i_data_wr;
      o_data_wr_reg <= i_data_wr_reg;
    end
  end

  always @(posedge i_clk or negedge i_rst_n) begin
    case (st_current)
        IDLE_S: begin
            if (i_data_wr && !i_data_wr_reg) begin
                st_current <= TRANS_FIRST_S;
            end else
                st_current <= IDLE_S;
        end
        TRANS_FIRST_S: begin
            if (i_data_wr_reg && !o_data_wr_reg) begin
                ov_data_reg <= {1'b1, iv_data_reg};
            end else if(!i_data_wr && i_data_wr_reg) begin
                ov_data_reg <= {1'b1, iv_data_reg};
                st_current <= TRANS_S;
            end else begin
                ov_data_reg <= {1'b0, iv_data_reg};
            end
        end
        TRANS_S: begin
            st_current <= IDLE_S;
        end
    endcase
  end


  assign ov_data = ov_data_reg;
  assign o_data_wr = o_data_wr_reg;

endmodule
