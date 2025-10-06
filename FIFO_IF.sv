interface FIFO_IF (
    input bit clk
);
  parameter FIFO_WIDTH = 16;
  parameter FIFO_DEPTH = 8;
  bit [FIFO_WIDTH-1:0] data_in;
  logic rst_n, wr_en, rd_en;
  reg [FIFO_WIDTH-1:0] data_out;
  reg wr_ack, overflow;
  logic full, empty, almostfull, almostempty, underflow;
  modport TEST(
      output data_in, clk, rst_n, wr_en, rd_en,
      input data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
  );
  modport MON(
      input data_in,clk,rst_n,wr_en,rd_en,
   data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow
  );
endinterface
