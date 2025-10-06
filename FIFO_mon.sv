import shared_pkg::*;
import trans_pkg::*;
import cvg_pkg::*;
import sb_pkg::*;
module FIFO_mon (
    FIFO_IF.MON MON_IF
);
  FIFO_Transaction FIFO_Transaction_obj;
  FIFO_scoreboard FIFO_scoreboard_obj;
  FIFO_coverage FIFO_coverage_obj;
  initial begin
    FIFO_scoreboard_obj = new();
    FIFO_coverage_obj = new();
    FIFO_Transaction_obj = new(30, 70);
    forever begin
      @(negedge MON_IF.clk);
      FIFO_Transaction_obj.data_in = MON_IF.data_in;
      FIFO_Transaction_obj.rst_n = MON_IF.rst_n;
      FIFO_Transaction_obj.wr_en = MON_IF.wr_en;
      FIFO_Transaction_obj.wr_ack = MON_IF.wr_ack;
      FIFO_Transaction_obj.rd_en = MON_IF.rd_en;
      FIFO_Transaction_obj.overflow = MON_IF.overflow;
      FIFO_Transaction_obj.full = MON_IF.full;
      FIFO_Transaction_obj.empty = MON_IF.empty;
      FIFO_Transaction_obj.underflow = MON_IF.underflow;
      FIFO_Transaction_obj.almostfull = MON_IF.almostfull;
      FIFO_Transaction_obj.almostempty = MON_IF.almostempty;
      FIFO_Transaction_obj.data_out    = MON_IF.data_out;
      fork  //run in //
        FIFO_scoreboard_obj.check_data(FIFO_Transaction_obj);
        FIFO_coverage_obj.sample_data(FIFO_Transaction_obj);
      join
      if (test_finished) begin
        $display("Correct_count=%d ", correct_count);
        $display("error_count=%d ", error_count);
        $stop;
      end
    end
  end
endmodule
