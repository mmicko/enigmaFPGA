module hex_to_7seg 
  (
   input       i_Clk,
   input [3:0] i_Value,
   output      o_Segment_A,
   output      o_Segment_B,
   output      o_Segment_C,
   output      o_Segment_D,
   output      o_Segment_E,
   output      o_Segment_F,
   output      o_Segment_G
   );
 
  reg [6:0]    out = 7'b0000000;
   
  always @(posedge i_Clk)
    begin
      case (i_Value)
        4'b0000 : out <= 7'b0000001;
        4'b0001 : out <= 7'b1001111;
        4'b0010 : out <= 7'b0010010;
        4'b0011 : out <= 7'b0000110;
        4'b0100 : out <= 7'b1001100;          
        4'b0101 : out <= 7'b0100100;
        4'b0110 : out <= 7'b0100000;
        4'b0111 : out <= 7'b0001111;
        4'b1000 : out <= 7'b0000000;
        4'b1001 : out <= 7'b0000100;
        4'b1010 : out <= 7'b0001000;
        4'b1011 : out <= 7'b1100000;
        4'b1100 : out <= 7'b0110001;
        4'b1101 : out <= 7'b1000010;
        4'b1110 : out <= 7'b0110000;
        4'b1111 : out <= 7'b0111000;
      endcase
    end 
 
  assign o_Segment_A = out[6];
  assign o_Segment_B = out[5];
  assign o_Segment_C = out[4];
  assign o_Segment_D = out[3];
  assign o_Segment_E = out[2];
  assign o_Segment_F = out[1];
  assign o_Segment_G = out[0];
 
endmodule