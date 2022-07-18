
`include "../sim/sfifo_sim.vh"

module sfifo_simul_rw_tst;

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
          if (i == $urandom_range(1, 63))
            begin
              // Enable read and check
              `SFIFO_CHK_EN(`ON);
            end
        end

      // Delay a bit
      `DELAY(100);

      `FINISH;
    end

endmodule // sfifo_rw_tst
