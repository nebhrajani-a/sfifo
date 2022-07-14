module sfifo_tb;

  reg           rst;
  reg           clk;  
  reg           w_en;
  reg [7:0]     din;
  reg           r_en;
  wire [7:0]    dout;
  wire          full;
  wire          empty;
  wire          ovfl;
  wire          udfl;
  
  event         setup_event;
  event         error_event;
  reg           ok_to_read;
  reg           rd_en_d;
  reg           rd_vld;
  reg [7:0]     exp_data;
  
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
      w_en = 1'b0;
      din = 8'hXX;
    end
  endtask // wrfifo

  //----------------------------------------------------------------------
  // Read process
  //----------------------------------------------------------------------
  always @(posedge clk)
    begin
      if (empty == 1'b0)
        begin
          ok_to_read = 1;
        end
      else
        begin
          ok_to_read = 0;
        end
      
      # t_h;
      r_en = 1'b0;

      if (ok_to_read == 1'b1)
        begin
          @ setup_event;
          r_en = 1'b1;
        end
    end

  //----------------------------------------------------------------------
  // Read checker
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    if (rst == 1'b0)
      begin
        exp_data = 8'h75;
        rd_en_d <= 1'b0;
        rd_vld <= 1'b0;
      end

    else
      begin
        rd_en_d <= r_en;
        rd_vld  <= rd_en_d;
        
        if (rd_vld == 1'b1)
          begin
            if (dout !== exp_data)
              begin
                $display("At time %0t: ERROR: Data read error, expected 0x%h received 0x%h\n", 
                         $time, exp_data, dout);
                -> error_event;
              end
            exp_data = exp_data + 1'b1;
          end
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
     .full(full),
     .empty(empty),
     .overflow(ovfl),
     .underflow(udfl)
    );

endmodule // sfifo_tb
