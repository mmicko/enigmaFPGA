module reflectorEncode (code, val, reflector_type);
	input [4:0] code; 
	output reg [4:0] val;
	input reflector_type;

    always @*
    begin
	  if (reflector_type == 1'b0)
	  begin
		  // Reflector B
		  case (code)
			0 : val = "Y" - 8'h41;
			1 : val = "R" - 8'h41;
			2 : val = "U" - 8'h41;
			3 : val = "H" - 8'h41;
			4 : val = "Q" - 8'h41;
			5 : val = "S" - 8'h41;
			6 : val = "L" - 8'h41;
			7 : val = "D" - 8'h41;
			8 : val = "P" - 8'h41;
			9 : val = "X" - 8'h41;
			10: val = "N" - 8'h41;
			11: val = "G" - 8'h41;
			12: val = "O" - 8'h41;
			13: val = "K" - 8'h41;
			14: val = "M" - 8'h41;
			15: val = "I" - 8'h41;
			16: val = "E" - 8'h41;
			17: val = "B" - 8'h41;
			18: val = "F" - 8'h41;
			19: val = "Z" - 8'h41;
			20: val = "C" - 8'h41;
			21: val = "W" - 8'h41;
			22: val = "V" - 8'h41;
			23: val = "J" - 8'h41;
			24: val = "A" - 8'h41;
			25: val = "T" - 8'h41;		
		  endcase
	  end
	  else
	  begin
		// Reflector C
	  	case (code)
			0 : val = "F" - 8'h41;
			1 : val = "V" - 8'h41;
			2 : val = "P" - 8'h41;
			3 : val = "J" - 8'h41;
			4 : val = "I" - 8'h41;
			5 : val = "A" - 8'h41;
			6 : val = "O" - 8'h41;
			7 : val = "Y" - 8'h41;
			8 : val = "E" - 8'h41;
			9 : val = "D" - 8'h41;
			10: val = "R" - 8'h41;
			11: val = "Z" - 8'h41;
			12: val = "X" - 8'h41;
			13: val = "W" - 8'h41;
			14: val = "G" - 8'h41;
			15: val = "C" - 8'h41;
			16: val = "T" - 8'h41;
			17: val = "K" - 8'h41;
			18: val = "U" - 8'h41;
			19: val = "Q" - 8'h41;
			20: val = "S" - 8'h41;
			21: val = "B" - 8'h41;
			22: val = "N" - 8'h41;
			23: val = "M" - 8'h41;
			24: val = "H" - 8'h41;
			25: val = "L" - 8'h41;		
		  endcase
	  end
    end 
endmodule
