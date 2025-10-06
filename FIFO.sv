module FIFO (
    data_in,
    wr_en,
    rd_en,
    clk,
    rst_n,
    full,
    empty,
    almostfull,
    almostempty,
    wr_ack,
    overflow,
    underflow,
    data_out
);
  parameter FIFO_WIDTH = 16;
  parameter FIFO_DEPTH = 8;
  input [FIFO_WIDTH-1:0] data_in;
  input clk, rst_n, wr_en, rd_en;
  output reg [FIFO_WIDTH-1:0] data_out;
  output reg wr_ack, overflow, underflow;  //CORRECT
  output full, empty, almostfull, almostempty /*underflow false*/; //UNDERFLOW IS A SEQ SO IT MUST BE REG
  localparam max_fifo_addr = $clog2(FIFO_DEPTH);
  reg [FIFO_WIDTH-1:0] mem[FIFO_DEPTH-1:0];
  reg [max_fifo_addr-1:0] wr_ptr=0; //Must initialize this to zero
  reg [max_fifo_addr-1:0] rd_ptr=0; //Must initialize this to zero
  reg [max_fifo_addr:0] count=0;    //Must initialize this to zero
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr   <= 0;
      overflow <= 0;  //since overflow is a seq so reset affects it  
      wr_ack   <= 0;  //wr_ack should equal zero in reset 
    end else if (wr_en && !full) begin 
      mem[wr_ptr] <= data_in;
      wr_ack <= 1;
      wr_ptr <= wr_ptr + 1;
    end else begin
      wr_ack <= 0;
      if (full && wr_en) overflow <= 1;  //sould be &&
      else overflow <= 0;
    end
  end  //WRITE LOGIC IS VALID

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_ptr <= 0;
      underflow <= 0;  //reseting underflow since it is a seq logic
    end else if (rd_en && !empty) begin
      data_out <= mem[rd_ptr];
      rd_ptr   <= rd_ptr + 1;
    end else if (empty && rd_en) underflow <= 1;  //ADDING UNDERFLOW LOGIC IN THE ALWAYS BLOCK
    else underflow <= 0;  //ASSERT TO 0 IF NO EMPTY AND NO read_enable
  end  //ELSE IS VALID
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 0;
    end else begin
      if (({wr_en, rd_en} == 2'b10) && !full) count <= count + 1;
      else if (({wr_en, rd_en} == 2'b01) && !empty) count <= count - 1;
      else if (({wr_en, rd_en} == 2'b11) && full) count <= count - 1;  //error
      else if (({wr_en, rd_en} == 2'b11) && empty) count <= count + 1;  //error
    end
  end

  assign full = (count == FIFO_DEPTH) ? 1 : 0;
  assign empty = (count == 0) ? 1 : 0;
  assign almostfull = (count == FIFO_DEPTH - 1) ? 1 : 0;  //count from 1 to 8 so almost full -1 
  assign almostempty = (count == 1) ? 1 : 0;
`ifdef SIM
property rst_;
  @(posedge clk) ~rst_n |=> (~count && ~rd_ptr && ~wr_ptr);
endproperty
assert_rst:   assert property (rst_) else $error("Reset error");
cover_rst_:    cover property (rst_);


property wr_ack_;
  disable iff(!rst_n)
  @(posedge clk) (wr_en && ~full) |=> (wr_ack);
endproperty
assert_wr_ack_:  assert property (wr_ack_) else $error("wr_ack error");
cover_wr_ack_:   cover property (wr_ack_);


property overflow_;
  disable iff(!rst_n)
  @(posedge clk) (wr_en && full) |=> (overflow);
endproperty
assert_overflow_: assert property (overflow_) else $error("Overflow error");
cover_overflow_:  cover property (overflow_);


property underflow_;
  disable iff(!rst_n)
  @(posedge clk) (rd_en && empty) |=> (underflow);
endproperty
assert_underflow_: assert property (underflow_) else $error("Underflow error");
cover_underflow_:  cover property (underflow_);


property empty_;
  disable iff(!rst_n)
  @(posedge clk) (count == 0) |-> (empty);
endproperty
assert_empty_:  assert property (empty_) else $error("Empty error");
cover_empty_:   cover property (empty_);


property full_;
  disable iff(!rst_n)
  @(posedge clk) (count == FIFO_DEPTH) |-> (full);
endproperty
assert_full_:  assert property (full_) else $error("Full error");
cover_full_:   cover property (full_);


property almostfull_;
  disable iff(!rst_n)
  @(posedge clk) (count == FIFO_DEPTH-1) |-> (almostfull);
endproperty
assert_almostfull_:  assert property (almostfull_) else $error("Almostfull error");
cover_almostfull_:   cover property (almostfull_);


property almostempty_;
  disable iff(!rst_n)
  @(posedge clk) (count == 1) |-> (almostempty);
endproperty
assert_almostempty_:  assert property (almostempty_) else $error("Almostempty error");
cover_almostempty_:   cover property (almostempty_);


property wr_pointer_0;
  disable iff(!rst_n)
  @(posedge clk) (wr_ptr == FIFO_DEPTH-1 && wr_en &&~full) |=> (wr_ptr == 0);
endproperty
assert_wr_pointer_0_:  assert property (wr_pointer_0) else $error("Writepointer error");
cover_wr_pointer_0_:   cover property (wr_pointer_0);


property rd_pointer_0;
  disable iff(!rst_n)
  @(posedge clk) (rd_ptr == FIFO_DEPTH-1 && rd_en&&~empty) |=> (rd_ptr == 0);
endproperty
assert_rd_pointer_0_:  assert property (rd_pointer_0) else $error("Readpointer error");
cover_rd_pointer_0_:   cover property (rd_pointer_0);


property wr_pointer_rst;
  @(posedge clk) (~rst_n) |=> (wr_ptr == 0);
endproperty
assert_wr_pointer_rst_: assert property (wr_pointer_rst) else $error("Writepointer not reset");
cover_wr_pointer_rst_:  cover property (wr_pointer_rst);


property rd_pointer_rst;
  @(posedge clk) (~rst_n) |=> (rd_ptr == 0);
endproperty
assert_rd_pointer_rst_: assert property (rd_pointer_rst) else $error("Readpointer not reset");
cover_rd_pointer_rst_:  cover property (rd_pointer_rst);


property count_rst;
  @(posedge clk) (~rst_n) |=> (count == 0);
endproperty
assert_count_rst_: assert property (count_rst) else $error("Count not reset");
cover_count_rst_:  cover property (count_rst);


property wr_pointer_max;
  @(posedge clk) wr_ptr < FIFO_DEPTH;
endproperty
assert_wr_pointer_max_: assert property (wr_pointer_max) else $error("Writepointer greater than depth");
cover_wr_pointer_max_:  cover property (wr_pointer_max);


property rd_pointer_max;
  @(posedge clk) rd_ptr < FIFO_DEPTH;
endproperty
assert_rd_pointer_max_: assert property (rd_pointer_max) else $error("Readpointer greater than depth");
cover_rd_pointer_max_:  cover property (rd_pointer_max);


property count_max;
  @(posedge clk) count <= FIFO_DEPTH;
endproperty
assert_count_max_: assert property (count_max) else $error("Count greater than depth");
cover_count_max_:  cover property (count_max);
`endif
endmodule