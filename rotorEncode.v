module rotorEncode #(parameter REVERSE = 0) (code, rotor_type, val);
	input [4:0] code; 
	output reg [4:0] val;
	input [2:0] rotor_type;
	
    parameter MEM_INIT_FILE = "rotors.mem";

    reg [4:0] rotor_data[0:415];

    initial
		if (MEM_INIT_FILE != "")
			$readmemh(MEM_INIT_FILE, rotor_data);
   
	always @*
		val = rotor_data[((REVERSE) ? 208 : 0) + rotor_type*26 + code];
endmodule
