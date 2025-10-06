package trans_pkg;
  import shared_pkg::*;
  class FIFO_Transaction;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n, wr_en, rd_en;
    reg [FIFO_WIDTH-1:0] data_out;
    reg wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    int RD_EN_ON_DIST, WR_EN_ON_DIST;
    function new(input int RD_EN_ON_DIST, int WR_EN_ON_DIST);
      this.RD_EN_ON_DIST = RD_EN_ON_DIST;
      this.WR_EN_ON_DIST = WR_EN_ON_DIST;
      data_in = 0;
      rst_n = 1;
      wr_en = 0;
      rd_en = 0;
    endfunction
    constraint cons {
      rst_n dist {
        1 := 95,
        0 := 5
      };
      wr_en dist {
        1 := WR_EN_ON_DIST,
        0 := 100 - WR_EN_ON_DIST
      };
      rd_en dist {
        1 := RD_EN_ON_DIST,
        0 := 100 - RD_EN_ON_DIST
      };
    }
  endclass

endpackage
