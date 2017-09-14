module test();
	reg i_ready = 0;
	reg [7:0] inputData;
	reg r_Clock = 0;
	wire o_ready;
	wire [7:0] outputData;
	integer i;
	
	state_machine st(.i_clock(r_Clock),.i_ready(i_ready),.i_inputData(inputData),.o_ready(o_ready),.o_outputData(outputData));
	
	always
		#(5) r_Clock <= !r_Clock;
 
	always @(posedge o_ready)
	begin
		$display("data is [%c]",outputData);
	end

    initial
	begin
		$dumpfile("enigma.vcd");
		$dumpvars(0,test);
		inputData = "A";
		for (i = 0; i < 20; i = i + 1) 		
		begin
			#10
			i_ready = 1;
			#30
			i_ready = 0;
		end
		#260
		$finish;
	end
endmodule