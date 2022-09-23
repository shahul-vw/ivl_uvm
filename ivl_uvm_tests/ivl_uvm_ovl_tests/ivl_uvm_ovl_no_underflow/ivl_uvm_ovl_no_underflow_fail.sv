`timescale 1ns/1ns
parameter WIDTH=4;
parameter MIN=4;
parameter MAX=12;

module test;

   wire clk;
   reg rst_n;
   logic [WIDTH-1:0] addr;
   int i;
   

   // simple signal check OVL 
   ovl_no_underflow  u_ovl_no_underflow ( 
			     .clock     (clk),
			     .reset     (rst_n), 
			     .enable    (1'b1),
			     .test_expr (addr)
			     );



   defparam u_ovl_no_underflow.width= WIDTH;
   defparam u_ovl_no_underflow.min= MIN;
   defparam u_ovl_no_underflow.max= MAX;

   initial begin
      // Dump waves
      $dumpfile("fail_dump.vcd");
      $dumpvars(1, test);
      
      // Initialize values.
      rst_n = 0;
      
     $display("Running ovl_no_underflow fail Test \n");
     wait_clks(2);
     
     
     $display("Setting rest_n to 0 and giving  fail values for the test expresion \n");
     $display("ovl_no_underflow does not fire at rst_n \n");
     
     addr=MIN;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr);
     
     wait_clks(1);
     
     addr=MIN-1;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr);

     wait_clks(1);
     
     $display("Setting rest_n to 1 and giving  fail values for the test expresion \n");
     
     rst_n = 1;
     $display("ovl_no_underflow only start evaluating  when the test_expression=%0b \n", MIN );
     $display("ovl_no_underflow  fires if the following value of test_expression is  not in the range : (%0b <= test_expr < %0b) ",MIN,MAX );
     

     i=1;
     do
       begin
          addr=MIN;
          $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr);
          wait_clks(1);
          addr=addr-i;
          i=i+1;
          $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr);
          wait_clks(1);
       end
       while(addr>0);
    
     wait_clks(1);
         addr=MIN;
         $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr); 
      wait_clks(1);
         addr=MAX;
          $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr); 
      wait_clks(1);
         addr=MIN;
         $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr); 
      wait_clks(1);
         addr=MAX+1;
         $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr); 



     wait_clks(1);

      $display("ovl_no_underflow  fires when test_expression contains X or Z");
         addr=4'b0Z11;
         $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr); 
      wait_clks(1);
      addr=4'b0000;
      wait_clks(1);
      
         addr=4'bXX1X;
         $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,addr); 
      
     wait_clks(1);
     addr=4'b0000;
     wait_clks(2);
      $display(" ovl_no_underflow fail Test ended \n");

      $finish;
   end

   task wait_clks (input int num_clks = 1);
      repeat (num_clks) @(posedge clk);
   endtask : wait_clks

  ivl_uvm_ovl_clk_gen #(.FREQ_IN_MHZ(100)) u_clk_100 (clk);

endmodule
