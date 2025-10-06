package cvg_pkg;
  import trans_pkg::*;
  class FIFO_coverage;
    FIFO_Transaction F_cvg_txn = new(70, 30);
    covergroup cvr_gp;
      wr_en_cv: coverpoint F_cvg_txn.wr_en {bins wr_en_1 = {1}; bins wr_en_0 = {0};}
      rd_en_cv: coverpoint F_cvg_txn.rd_en {bins rd_en_1 = {1}; bins rd_en_0 = {0};}
      wr_ack_cv: coverpoint F_cvg_txn.wr_ack {bins wr_ack_1 = {1}; bins wr_ack_0 = {0};}
      overflow_cv: coverpoint F_cvg_txn.overflow {bins overflow_1 = {1}; bins overflow_0 = {0};}
      full_cv: coverpoint F_cvg_txn.full {bins full_1 = {1}; bins full_0 = {0};}
      empty_cv: coverpoint F_cvg_txn.empty {bins empty_1 = {1}; bins empty_0 = {0};}
      almostfull_cv: coverpoint F_cvg_txn.almostfull {
        bins almostfull_1 = {1}; bins almostfull_0 = {0};
      }
      almostempty_cv: coverpoint F_cvg_txn.almostempty {
        bins almostempty_1 = {1}; bins almostempty_0 = {0};
      }
      underflow_cv: coverpoint F_cvg_txn.underflow {bins underflow_1 = {1}; bins underflow_0 = {0};}
      wr_ack_cv_cross : cross wr_en_cv, rd_en_cv, wr_ack_cv{}
      overflow_cv_cross : cross overflow_cv, rd_en_cv, wr_en_cv{}
      full_cv_cross : cross wr_en_cv, rd_en_cv, full_cv{}
      empty_cv_cross : cross wr_en_cv, rd_en_cv, empty_cv{}
      almost_full_cv_cross : cross wr_en_cv, rd_en_cv, almostfull_cv{}
      almostempty_cv_cross : cross wr_en_cv, rd_en_cv, almostempty_cv{}
      underflow_cv_cross : cross wr_en_cv, rd_en_cv, underflow_cv{}
    endgroup : cvr_gp
    function new();
      cvr_gp = new;
    endfunction
    function void sample_data(input FIFO_Transaction F_txt);
      F_cvg_txn = F_txt;
      cvr_gp.sample;
    endfunction
  endclass

endpackage
