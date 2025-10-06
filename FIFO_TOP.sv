module FIFO_TOP ();
  bit clk;
  initial begin
    clk = 0;
    forever begin
      #10 clk = ~clk;
    end
  end
  FIFO_IF FIFO_IF_obj (clk);
  FIFO DUT (
      FIFO_IF_obj.data_in,
      FIFO_IF_obj.wr_en,
      FIFO_IF_obj.rd_en,
      clk,
      FIFO_IF_obj.rst_n,
      FIFO_IF_obj.full,
      FIFO_IF_obj.empty,
      FIFO_IF_obj.almostfull,
      FIFO_IF_obj.almostempty,
      FIFO_IF_obj.wr_ack,
      FIFO_IF_obj.overflow,
      FIFO_IF_obj.underflow,
      FIFO_IF_obj.data_out
  );
  FIFO_tb TEST (FIFO_IF_obj);
  FIFO_mon MON (FIFO_IF_obj);
endmodule
