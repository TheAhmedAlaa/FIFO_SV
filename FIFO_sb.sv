package sb_pkg;
  import trans_pkg::*;
  import shared_pkg::*;
  class FIFO_scoreboard;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    reg [FIFO_WIDTH-1:0] data_out_ref;
    reg wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
    reg [FIFO_WIDTH-1:0] mem_sb[FIFO_DEPTH-1:0];
    parameter max_fifo_addr = $clog2(FIFO_DEPTH);
    logic [max_fifo_addr-1:0] wr_pointer = 0;
    logic [max_fifo_addr-1:0] rd_pointer = 0;
    logic [max_fifo_addr:0] count = 0;
    task check_data(input FIFO_Transaction trans_obj);
      if (trans_obj.data_out === data_out_ref) begin
        correct_count++;
      end else begin
        error_count++;
        $display(
            "================================================ERROR DETAILS================================================");
        $display("Error at [%0t]", $time());
        $display("rst_n       = %d", trans_obj.rst_n);
        $display("wr_en       = %d", trans_obj.wr_en);
        $display("rd_en       = %d", trans_obj.rd_en);
        $display("data_in     = %4h", trans_obj.data_in);
        $display("data_out    = %4h  refrence %4h", trans_obj.data_out, data_out_ref);
        $display("count_sb=%d", count);
        $display("false_count=%d", error_count);
        $display(
            "================================================================================================");
      end
      reference_model(trans_obj);
    endtask
    task reference_model(input FIFO_Transaction trans_obj);
      full_ref = (count == FIFO_DEPTH);
      almostfull_ref = (count == FIFO_DEPTH - 1);
      empty_ref = (count == 0);
      almostempty_ref = (count == 1);
      overflow_ref = (full_ref && trans_obj.wr_en);
      underflow_ref = (empty_ref && trans_obj.rd_en);
      if (~trans_obj.rst_n) begin  // write reset
        wr_pointer = 0;
        wr_ack_ref = 0;
        count = 0;
      end else if (~full_ref)
        if (trans_obj.wr_en) begin
          mem_sb[wr_pointer] = trans_obj.data_in;
          wr_pointer = (wr_pointer + 1);
          count++;
          wr_ack_ref = 1;
        end else wr_ack_ref = 0;
      if (~trans_obj.rst_n) begin  // read reset
        rd_pointer = 0;
      end else if (~empty_ref)
        if (trans_obj.rd_en) begin
          data_out_ref = mem_sb[rd_pointer];
          rd_pointer   = (rd_pointer + 1);
          count--;
          wr_ack_ref = 0;
        end
    endtask
  endclass

endpackage
