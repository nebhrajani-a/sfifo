//------------------------------------------------------------------------------
// Simulation Environment Tasks and Functions
//
// Author: Vijay A. Nebhrajani
// Email:  vijay.nebhrajani@gmail.com
// Date:   July 15, 2022
//------------------------------------------------------------------------------


//----------------------------------------------------------------------
// Task Name:   init()
// Description: Initializes - i.e., does a reset on the DUT
//----------------------------------------------------------------------
task init;
  begin
    rd_count = 0;
    wr_count = 0;
    @ setup_event;
    rst <= 1'b0;
    repeat (4) @ (posedge clk);
    rst <= 1'b1;
    @ (posedge clk);
  end
endtask // init

//----------------------------------------------------------------------
// Task Name:   delay(clks)
// Description: Delays by 'clks' number of clock cycles
//----------------------------------------------------------------------
task delay
  (input [31:0] clks
  );
  begin
    repeat (clks) @ (posedge clk);
  end
endtask // delay

//----------------------------------------------------------------------
// Task Name:   wrfifo(wrdata)
// Description: Writes 'wrdata' to FIFO
//----------------------------------------------------------------------
task wrfifo 
  (input [7:0] wrdata
   );
  begin
    @ setup_event;
    w_en = 1'b1;
    din  = wrdata;
    @ (posedge clk);
    wr_count = wr_count + 1;
    # t_h;
    w_en = 1'b0;
    din = 8'hXX;
  end
endtask // wrfifo

//----------------------------------------------------------------------
// Task Name:   fifo_chk_en(enable)
// Description: Sets the FIFO read data checker to state of 'enable' 
//----------------------------------------------------------------------
task fifo_chk_en
  (input en
   );
  begin
    chk_en = en;
  end
endtask // fifo_chk_en

//----------------------------------------------------------------------
// Finish
//----------------------------------------------------------------------
task endsim;
  begin
    if (rd_count !== wr_count)
      begin
        $display("At time %0t: Error: Written and Read data word count mismatch",
                 $time);
        $display("             Data words read = %0d, Data words written = %0d.\n",
                 rd_count, wr_count);
      end
    $finish;
  end
endtask // finish
  
