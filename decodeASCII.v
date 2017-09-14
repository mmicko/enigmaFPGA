module decodeASCII(code, ascii);
	input [4:0] code; 
	output [7:0] ascii;

	assign ascii = 8'h41 + code;	
endmodule