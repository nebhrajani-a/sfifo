//------------------------------------------------------------------------------
// Simulation Environment Top Level for Synchronous FIFO
//
// Author: Vijay A. Nebhrajani
// Email:  vijay.nebhrajani@gmail.com
// Date:   July 12, 2022
//------------------------------------------------------------------------------

module sfifo_tb;

  `include "../sim/sfifo_timing_params.v"

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
  reg           chk_en;
  reg           chk_en_d;
  reg           chk_en_d2;
  integer       wr_count;
  integer       rd_count;
  
  
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

  `include "../sim/sfifo_simtasks.v"

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

      if (chk_en == 1'b1)
        begin
          if (ok_to_read == 1'b1)
            begin
              @ setup_event;
              r_en = 1'b1;
            end
        end
    end

  //----------------------------------------------------------------------
  // Read checker
  //----------------------------------------------------------------------
  always @(posedge clk or negedge rst)
    if (rst == 1'b0)
      begin
        exp_data   = 8'h75;
        rd_en_d   <= 1'b0;
        rd_vld    <= 1'b0;
        chk_en_d  <= chk_en;
        chk_en_d2 <= chk_en_d;
      end

    else
      begin
        rd_en_d <= r_en;
        rd_vld  <= rd_en_d;

        if (chk_en_d2 == 1'b1)
          begin
            if (rd_vld == 1'b1)
              begin
                rd_count = rd_count + 1;
                if (dout !== exp_data)
                  begin
                    $display("At time %0t: ERROR: Data read error, expected 0x%h received 0x%h\n", 
                         $time, exp_data, dout);
                    -> error_event;
                  end
                if (exp_data == 8'hFF)
                  exp_data = 8'h00;
                else
                  exp_data = exp_data + 1'b1;
              end
          end
      end

  
  //----------------------------------------------------------------------
  // Design under test
  //----------------------------------------------------------------------
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
