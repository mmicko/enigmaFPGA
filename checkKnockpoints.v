module checkKnockpoints (position, knockpoint, rotor_type);
	input [4:0] position;
	output reg knockpoint;
	input [2:0] rotor_type;

	always @*
	begin
		knockpoint = 0;
		case(rotor_type)
			0 : if (position==16+1) knockpoint = 1;
			1 : if (position== 4+1) knockpoint = 1;
			2 : if (position==21+1) knockpoint = 1;
			3 : if (position== 9+1) knockpoint = 1;
			//4 : if (position==25+1) knockpoint = 1;
			4 : if (position==0)    knockpoint = 1;
			5 : if (position==12+1) knockpoint = 1; else if(position==0) knockpoint = 1; 
			6 : if (position==12+1) knockpoint = 1; else if(position==0) knockpoint = 1;
			7 : if (position==12+1) knockpoint = 1; else if(position==0) knockpoint = 1;
		endcase
	end
endmodule