
`include "../sim/sfifo_sim.vh"

module sfifo_burst_tst;

  integer i;

  initial
    begin
      $dumpvars;

      // Initialize (reset etc)
      `SFIFO_INIT;


      // Perform 64 writes
      for (i = 0; i < 64; i++)
        begin
          `SFIFO_WR($random);
        end


      // Enable read and check
      `SFIFO_CHK_EN(`ON);
      // Delay a bit
      `DELAY(100);

      `FINISH;
    end

endmodule // sfifo_rw_tst
