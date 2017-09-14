module encodeASCII(ascii, code, valid);
	input [7:0] ascii; 
	output [4:0] code;
	output valid;

	assign valid = ((ascii < 8'h41 || ascii > 8'h5A) && (ascii < 8'h61 || ascii > 8'h7A)) ? 0 : 1;
	assign code = (ascii > 8'h5A) ? ascii - 8'h61 : ascii - 8'h41;	
endmodule
