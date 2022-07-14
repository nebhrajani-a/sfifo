module sfifo_tb;

  reg           rst;
  reg           clk;  
  reg           w_en;
  reg [7:0]     din;

  event         setup_event;
  
  //----------------------------------------------------------------------
  // Timing parameters for the simulation environment
  //----------------------------------------------------------------------
  parameter t_clk_low  = 5;
  parameter t_clk_high = 5;
  parameter t_s        = 0.2  * (t_clk_low + t_clk_high);
  parameter t_h        = 0.1  * (t_clk_low + t_clk_high);
  parameter t_cq       = 0.15 * (t_clk_low + t_clk_high);
  
  //----------------------------------------------------------------------
  // Clock generation
  //----------------------------------------------------------------------
  always
    begin
      clk <= 1'b0;
      # t_clk_low;
      clk <= 1'b1;
      # t_clk_high;
    end

  //----------------------------------------------------------------------
  // Reset generation
  //----------------------------------------------------------------------
  initial
    begin
      rst <= 1'b0;
      repeat (4) @ (posedge clk);
      rst <= 1'b1;
      @ (posedge clk);
    end

  //----------------------------------------------------------------------
  // Event for setup alignment
  //----------------------------------------------------------------------
  always @(posedge clk)
    begin
      #(t_clk_low + t_clk_high - t_s);
      -> setup_event;
    end
  
  //----------------------------------------------------------------------
  // Writes to FIFO
  //----------------------------------------------------------------------
  task wrfifo 
    (input [7:0] wrdata
    );
    begin
      @ setup_event;
      w_en = 1'b1;
      din  = wrdata;
      @ (posedge clk);
      # t_h;
      w_en = 1'bx;
      din = 8'hXX;
    end
  endtask // wrfifo

  //----------------------------------------------------------------------
  // Read process
  //----------------------------------------------------------------------
  always @(posedge clk)
    begin
    end

  
  initial
    begin
      $dumpvars;
      repeat (5) @(posedge clk);
      wrfifo(8'h75);
      wrfifo(8'h76);
      wrfifo(8'h77);
      repeat (3) @(posedge clk);      
      wrfifo(8'h78);
      repeat (5) @(posedge clk);
      $finish;
    end      
  
  sfifo u1_sfifo 
    (.rst(rst),
     .clk(clk),
     .w_en(w_en),
     .din(din),
     .r_en(r_en),
     .dout(dout),
     .full(full)
     .empty(empty),
     .overflow(ovfl),
     .underflow(udfl)
    );

endmodule // sfifo_tb
