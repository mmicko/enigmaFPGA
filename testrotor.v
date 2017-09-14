module testrotor();	
	reg [2:0] rotor_type_3 = 3'b010;
	reg [2:0] rotor_type_2 = 3'b001;

	reg [4:0] rotor_start_3 = 5'b00000;
	reg [4:0] rotor_start_2 = 5'b00000;
	reg [4:0] rotor_start_1 = 5'b00000;

	reg [4:0] ring_position_3 = 5'b00000;
	reg [4:0] ring_position_2 = 5'b00000;
	reg [4:0] ring_position_1 = 5'b00000;
	reg reflector_type = 1'b0;
	
	reg i_clock = 0;
	
	reg reset;
	reg rotate = 0;
	
	wire [4:0] rotor1;
	wire [4:0] rotor2;
	wire [4:0] rotor3;
	
	integer i;
	
	rotor rotorcontrol(.clock(i_clock),.rotor1(rotor1),.rotor2(rotor2),.rotor3(rotor3),
	        .reset(reset),.rotate(rotate),
	        .rotor_type_2(rotor_type_2),.rotor_type_3(rotor_type_3),
		    .rotor_start_1(rotor_start_1),.rotor_start_2(rotor_start_2),.rotor_start_3(rotor_start_3)
			);
	
	always
		#(5) i_clock <= !i_clock;
 
    initial
	begin
		$dumpfile("testrotor.vcd");
		$dumpvars(0,testrotor);
		
		#5
		reset = 1;
		#10
		reset = 0;
		for (i = 0; i < 30; i = i + 1) 		
		begin
		#10
			rotate = 1;
		#10
			rotate = 0;
		#10
			$display("Rotors [%c] [%c] [%c]",rotor1+65,rotor2+65,rotor3+65);
		end


		#10

		$finish;
	end
endmodule