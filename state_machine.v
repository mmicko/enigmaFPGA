module state_machine(
	input i_clock,
	input i_ready,	
	input [7:0] i_inputData,
	output reg o_ready,
	output reg [7:0] o_outputData,
	output reg o_valid
);	

	reg [2:0] rotor_type_3 = 3'b010;
	reg [2:0] rotor_type_2 = 3'b001;
	reg [2:0] rotor_type_1 = 3'b000;

	reg [4:0] rotor_start_3 = 5'b00000;
	reg [4:0] rotor_start_2 = 5'b00000;
	reg [4:0] rotor_start_1 = 5'b00000;

	reg [4:0] ring_position_3 = 5'b00000;
	reg [4:0] ring_position_2 = 5'b00000;
	reg [4:0] ring_position_1 = 5'b00000;
	reg reflector_type = 1'b0;

	wire [4:0] rotor1;
	wire [4:0] rotor2;
	wire [4:0] rotor3;
	
	reg reset = 1'b1;
	reg rotate = 1'b0;
	
	wire [4:0] value0;	
	wire [4:0] value1;
	wire [4:0] value2;
	wire [4:0] value3;
	wire [4:0] value4;
	wire [4:0] value5;
	wire [4:0] value6;
	wire [4:0] value7;
	wire [4:0] value8;
	
	parameter STATE_RESET   = 2'b00;
	parameter STATE_IDLE    = 2'b01;
	parameter STATE_ENCODE  = 2'b10;
	parameter STATE_CHECKKEY= 2'b11;

	reg [1:0] state = STATE_RESET;
	
	wire [4:0] inputCode;
	wire valid;
    wire [7:0] final_ascii;
	
    encodeASCII encode(.ascii(i_inputData), .code(inputCode), .valid(valid));
		
	rotor rotorcontrol(.clock(i_clock),.rotor1(rotor1),.rotor2(rotor2),.rotor3(rotor3),.reset(reset),.rotate(rotate),
	        .rotor_type_2(rotor_type_2),.rotor_type_3(rotor_type_3),
		    .rotor_start_1(rotor_start_1),.rotor_start_2(rotor_start_2),.rotor_start_3(rotor_start_3)
			);
	
	plugboardEncode plugboard(.code(inputCode),.val(value0));		
	encode #(.REVERSE(0)) rot3Encode(.inputValue(value0),.rotor(rotor3),.outputValue(value1),.rotor_type(rotor_type_3),.ring_position(ring_position_3));
	encode #(.REVERSE(0)) rot2Encode(.inputValue(value1),.rotor(rotor2),.outputValue(value2),.rotor_type(rotor_type_2),.ring_position(ring_position_2));
	encode #(.REVERSE(0)) rot1Encode(.inputValue(value2),.rotor(rotor1),.outputValue(value3),.rotor_type(rotor_type_1),.ring_position(ring_position_1));
	reflectorEncode reflector(.code(value3),.val(value4),.reflector_type(reflector_type));
	encode #(.REVERSE(1)) rot1EncodeRev(.inputValue(value4),.rotor(rotor1),.outputValue(value5),.rotor_type(rotor_type_1),.ring_position(ring_position_1));
	encode #(.REVERSE(1)) rot2EncodeRev(.inputValue(value5),.rotor(rotor2),.outputValue(value6),.rotor_type(rotor_type_2),.ring_position(ring_position_2));
	encode #(.REVERSE(1)) rot3EncodeRev(.inputValue(value6),.rotor(rotor3),.outputValue(value7),.rotor_type(rotor_type_3),.ring_position(ring_position_3));
	plugboardEncode plugboard2(.code(value7),.val(value8));		

	decodeASCII decode(.code(value8), .ascii(final_ascii));

	  
	always @(posedge i_clock)
	begin
		case (state)
			STATE_RESET :
				begin
					reset <= 1'b0;
					state <= STATE_IDLE;
					o_ready <= 1'b0;
					o_outputData <= 8'b00000000;
					o_valid <= 1'b0;
					rotate  <= 1'b1;
				end
				
			STATE_IDLE :
				begin
				    o_ready <= 1'b0;
					state   <= i_ready ? STATE_CHECKKEY : STATE_IDLE;
					o_valid <= valid;
					rotate  <= 1'b0;
				end			
				
			STATE_CHECKKEY :
				begin
				    o_ready <= 1'b0;
					rotate  <= 1'b0;
					if (valid)
					begin
						state   <= STATE_ENCODE;
					end
					else
					begin
						case(i_inputData)
							8'd27:
								begin
									reset <= 1'b1;
									state   <= STATE_RESET;
									o_ready <= 1'b1;
									o_outputData <= 8'd10;
								end
							8'd13:
								begin
									state   <= STATE_IDLE;
									o_ready <= 1'b1;
									o_outputData <= 8'd13;
								end
							default:
								state   <= STATE_IDLE;
						endcase
					end
					
					o_valid <= valid;
				end			
						
			STATE_ENCODE :
				begin
					rotate  <= 1'b1;
					o_ready <= 1'b1;
					o_outputData <= final_ascii;
					
					state  <= STATE_IDLE;
				end
			
		endcase
	end
	
endmodule
