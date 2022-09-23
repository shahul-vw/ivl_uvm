`timescale 1ns/1ns
parameter WIDTH=4;


module test;

   wire clk;
   reg rst_n;
   logic [WIDTH-1:0] data;
   int i;
   
// checking with expression

   ovl_odd_parity u_chk_with_exprsn ( 
			     .clock     (clk),
			     .reset     (rst_n), 
			     .enable    (1'b1),
			     .test_expr (^data)
			     );

   // simple signal check OVL 
   ovl_odd_parity  u_ovl_odd_parity ( 
			     .clock     (clk),
			     .reset     (rst_n), 
			     .enable    (1'b1),
			     .test_expr (data)
			     );



   defparam u_ovl_odd_parity.width= WIDTH;

   initial begin
      // Dump waves
      $dumpfile("fail_dump.vcd");
      $dumpvars(1, test);
      
  
      // Initialize values.
      rst_n = 0;
      
     $display("Running OVL_odd_parity fail Test \n");
      
      $display("Setting rest_n to 0 and giving different fail values for test expresion \n");
     
      $display("ovl_odd_parity does not fire at rst_n \n");

     for(i=0;i<(2**WIDTH-1);i=i+1)
       begin
         if(~^i)
           begin
              data=i;
              $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);
              #10;
           end
       end
      
      $display("Setting rest_n to 1 and giving different fail values for test expresion \n");
     rst_n = 1;

      $display("ovl_odd_parity FIRES when test_exp does not exhibit odd parity \n");
     
     for(i=0;i<(2**WIDTH-1);i=i+1)
       begin
         if(~^i)
           begin
              data=i;
              $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);
              #10;
           end
       end

     
     $display("ovl_odd_parity FIRES when test_exp is  Z  \n");
     data=4'bZZZZ;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);
     
     #10;
     data=4'b100Z;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);


     #10;
     data=4'b11Z1;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);
   
     
     #10;
    $display("ovl_odd_parity FIRES when test_exp contains  X  \n");
     data=4'bXXXX;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);
     
     #10;
     data=4'b100X;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);

      
     #10;
     data=4'b1X11;
     $display("Time=%0d Current value \t rst_n:%0d test_expr :%b \n", $time,rst_n,data);
     
     #10;
    $display(" OVL_odd_parity fail Test ended \n");

      $finish;
   end


  ivl_uvm_ovl_clk_gen #(.FREQ_IN_MHZ(100)) u_clk_100 (clk);

endmodule

