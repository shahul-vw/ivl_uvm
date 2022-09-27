`timescale 1ns/1ns

module test;

   wire clk;
   reg rst_n;
   reg write,write_ack,bus_gnt;
   

   // simple signal check OVL 
   ovl_window  u_ovl_window ( 
			     .clock     (clk),
			     .reset     (rst_n), 
			     .enable    (1'b1),
			     .test_expr (bus_gnt),
                             .start_event (write),
                             .end_event (write_ack)
			     );


   initial begin
      // Dump waves
      $dumpfile("pass_dump.vcd");
      $dumpvars(1, test);
      
      // Initialize values.
      rst_n = 0;
      bus_gnt=0;
      write=0;
      write_ack=0;
      
     $display("Running ovl_window pass Test \n");
     wait_clks(1);
     
     
     $display("Setting rest_n to 0 and giving  fail conditions \n");
     $display("ovl_window does not fire at rst_n \n");
     
     $display("ovl_window does not fire at rst_n \n");
     $monitor("Time=%0d Current value \t rst_n:%0d start_event: %b test_expr :%b  end_event: %b  \n", $time,rst_n,write,bus_gnt,write_ack);
     bus_gnt=1;
     
     event_start();
     wait_clks(2);
     
     bus_gnt=0;
     wait_clks(1);
     bus_gnt=1;

     wait_clks(2);
     event_end();
     bus_gnt=0;
     
     wait_clks(2);
     $display("Setting rest_n to 1 and giving pass condition \n");
     $display("ovl_window does not fire if the test_expression is true in between start_event and end_event \n" );
     
     rst_n = 1;
     bus_gnt=1;
     
     event_start();  
     wait_clks(5);
     event_end(); 
     bus_gnt=0;
    
      
     wait_clks(2);
     $display("ovl_window pass Test ended \n");
     
      $finish;
   end
  
   task event_start( input logic value=1);
     write= value;
     wait_clks(1);
     write= 0;   
   endtask : event_start

  
   task event_end( input logic value=1);
     write_ack= value;
     wait_clks(1);
     write_ack=0;
   endtask : event_end

   task wait_clks (input int num_clks = 1);
      repeat (num_clks) @(posedge clk);
   endtask : wait_clks

  ivl_uvm_ovl_clk_gen #(.FREQ_IN_MHZ(100)) u_clk_100 (clk);

endmodule
