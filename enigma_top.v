module enigma_top
  (input  i_Clk,       // Main Clock
   input  i_UART_RX,   // UART RX Data
   output o_UART_TX,    // UART TX Data
   output o_LED_1,
   output o_LED_2,
   output o_LED_3,
   output o_LED_4,
 // Segment1 is upper digit, Segment2 is lower digit
   output o_Segment1_A,
   output o_Segment1_B,
   output o_Segment1_C,
   output o_Segment1_D,
   output o_Segment1_E,
   output o_Segment1_F,
   output o_Segment1_G,
   //
   output o_Segment2_A,
   output o_Segment2_B,
   output o_Segment2_C,
   output o_Segment2_D,
   output o_Segment2_E,
   output o_Segment2_F,
   output o_Segment2_G
   ); 
   
  wire w_RX_DV;
  wire [7:0] w_RX_Byte;
  wire w_TX_Active, w_TX_Serial;
    
  wire o_ready;
  wire o_valid;
  wire [7:0] outputData;
  
  // 25,000,000 / 115,200 = 217
  uart_rx #(.CLKS_PER_BIT(217)) UART_RX_Inst
  (.i_Clock(i_Clk),
   .i_Rx_Serial(i_UART_RX),
   .o_Rx_DV(w_RX_DV),
   .o_Rx_Byte(w_RX_Byte));

  state_machine st(.i_clock(i_Clk),.i_ready(w_RX_DV),.i_inputData(w_RX_Byte),.o_ready(o_ready),.o_outputData(outputData),.o_valid(o_valid));
  
  uart_tx #(.CLKS_PER_BIT(217)) UART_TX_Inst
  (.i_Clock(i_Clk),
   .i_Tx_DV(o_ready),      
   .i_Tx_Byte(outputData),  
   .o_Tx_Active(w_TX_Active),
   .o_Tx_Serial(w_TX_Serial),
   .o_Tx_Done());
   
  // Drive UART line high when transmitter is not active
  assign o_UART_TX = w_TX_Active ? w_TX_Serial : 1'b1; 
      
  hex_to_7seg upper_digit
  (.i_Clk(i_Clk),
   .i_Value(outputData[7:4]),
   .o_Segment_A(o_Segment1_A),
   .o_Segment_B(o_Segment1_B),
   .o_Segment_C(o_Segment1_C),
   .o_Segment_D(o_Segment1_D),
   .o_Segment_E(o_Segment1_E),
   .o_Segment_F(o_Segment1_F),
   .o_Segment_G(o_Segment1_G));
    
  hex_to_7seg lower_digit
  (.i_Clk(i_Clk),
   .i_Value(outputData[3:0]),
   .o_Segment_A(o_Segment2_A),
   .o_Segment_B(o_Segment2_B),
   .o_Segment_C(o_Segment2_C),
   .o_Segment_D(o_Segment2_D),
   .o_Segment_E(o_Segment2_E),
   .o_Segment_F(o_Segment2_F),
   .o_Segment_G(o_Segment2_G));
       
  assign o_LED_1 = 1'b0;
  assign o_LED_2 = 1'b0;
  assign o_LED_3 = o_valid;
  assign o_LED_4 = 1'b0;
endmodule