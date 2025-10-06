import shared_pkg::*;
import trans_pkg::*;
module FIFO_tb (
    FIFO_IF.TEST FIFO_tb_if
);
  initial begin
    FIFO_Transaction trans_obj;
    trans_obj = new(30, 70);
    //first reset
    @(negedge FIFO_tb_if.clk);
    FIFO_tb_if.rst_n = 0;
    @(negedge FIFO_tb_if.clk);
    //now randomize
    repeat (10000) begin
      assert (trans_obj.randomize());
      FIFO_tb_if.rst_n   = trans_obj.rst_n;
      FIFO_tb_if.wr_en   = trans_obj.wr_en;
      FIFO_tb_if.rd_en   = trans_obj.rd_en;
      FIFO_tb_if.data_in = trans_obj.data_in;
      @(negedge FIFO_tb_if.clk);
    end
    @(negedge FIFO_tb_if.clk);
    FIFO_tb_if.rst_n = 0;
    @(negedge FIFO_tb_if.clk);
    repeat (8) begin
      @(negedge FIFO_tb_if.clk);
      FIFO_tb_if.wr_en   = 1;
      FIFO_tb_if.rst_n   = 1;
      FIFO_tb_if.rd_en   = 0;
      FIFO_tb_if.data_in = trans_obj.data_in;
    end
    @(negedge FIFO_tb_if.clk);
    FIFO_tb_if.rst_n = 0;
    @(negedge FIFO_tb_if.clk);
    repeat (20) begin
      @(negedge FIFO_tb_if.clk);
      FIFO_tb_if.wr_en   = 0;
      FIFO_tb_if.rst_n   = 1;
      FIFO_tb_if.rd_en   = 1;
      FIFO_tb_if.data_in = trans_obj.data_in;
    end
    //hard coding these sequence to ensure design is working sussesfully 
    #10;
    test_finished = 1;
  end
endmodule
