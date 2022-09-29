`timescale 1ns/1ns

module test;

   wire clk;
   reg rst_n;
   reg [3:0]a;
   reg start,done;

   // simple signal check OVL 
   ovl_win_unchange #(.width(4))  u_ovl_win_unchange ( 
			     .clock     (clk),
			     .reset     (rst_n), 
			     .enable    (1'b1),
			     .test_expr (a),
                             .start_event (start),
                             .end_event (done)
			     );


   initial begin
      // Dump waves
	   $dumpfile("pass_dump.vcd");
      $dumpvars(1, test);
      
      // Initialize values.
      rst_n = 0;
      start=0;
     a=0;
     done=0;
     
     $display("Running ovl_win_unchange Pass Test \n");

     wait_clks(2);
  
     $display("Setting rest_n to 0 and giving  fail conditions \n");
     
     $display("ovl_win_unchange does not fire at rst_n \n");
     $monitor("Time=%0d Current value \t rst_n:%0d start_event: %b test_expr :%b  end_event: %b  \n", $time,rst_n,start,a,done);
     a=4'b0101;
     event_start();
  
     wait_clks(2);
     a=4'b0100;
  
     wait_clks(2);
     event_end();
     a=0;

     $display("Setting rest_n to 1 and giving pass condition \n");
     $display("ovl_win_unchange doesn't fire if the test_expression is not changed the value in between start_event and end_event \n" );
     rst_n = 1;
     
     a=4'b0101;
     event_start();
     
     wait_clks(4);

     event_end();
     a=0;
      

    wait_clks(2);
      a=4'b0011;
     event_start();
     wait_clks(3);
     
     
   
     event_end();
     a=0;
   
      

       wait_clks(2);
     $display("ovl_win_unchange pass Test ended \n");

      $finish;
   end

   task event_start( input logic value=1);
     start= value;
     wait_clks(1);
     start= 0;   
   endtask : event_start

  
   task event_end( input logic value=1);
     done= value;
     wait_clks(1);
     done=0;
   endtask : event_end


   task wait_clks (input int num_clks = 1);
      repeat (num_clks) @(posedge clk);
   endtask : wait_clks

  ivl_uvm_ovl_clk_gen #(.FREQ_IN_MHZ(100)) u_clk_100 (clk);

endmodule
