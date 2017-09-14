module calculate_val #(
	parameter INPUT = 1
) (
	input [4:0] value,
	input [4:0] rotor,
	output reg [4:0] out,
	input [4:0] ring_position
);
	reg signed [6:0] val = 7'b0000000;

	always @* 
	begin		
		if (INPUT==1)
			val = value - ring_position + rotor;
		else
			val = value + ring_position - rotor;

		if (val < 0    ) val = val + 7'd26;
		if (val > 7'd25) val = val - 7'd26;
		out = val[4:0];
	end
endmodule

module encode #(
	parameter REVERSE = 0
) (
	input [4:0] inputValue,
	input [4:0] rotor,
	output [4:0] outputValue,
	input [2:0] rotor_type,
	input [4:0] ring_position
);
	wire [4:0] calculated_input;
	wire [4:0] outval;
	
	calculate_val #(.INPUT(1)) cinput(.value(inputValue),.rotor(rotor),.out(calculated_input),.ring_position(ring_position));
	
	rotorEncode #(.REVERSE(REVERSE)) rotEncode(.code(calculated_input),.val(outval),.rotor_type(rotor_type));
	
	calculate_val #(.INPUT(0)) coutput(.value(outval),.rotor(rotor),.out(outputValue),.ring_position(ring_position));
endmodule
