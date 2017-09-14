module enigma_top_bi
  (input  i_Clk,       // Main Clock
   input  i_UART_RX,   // UART RX Data
   output o_UART_TX,    // UART TX Data
   output o_LED_1,
   output o_LED_2,
   output o_LED_3,
   output o_LED_4
   ); 
   
  wire w_RX_DV;
  wire [7:0] w_RX_Byte;
  wire w_TX_Active, w_TX_Serial;
    
  wire o_ready;
  wire o_valid;
  wire [7:0] outputData;
  
  
   wire         w_clk;
   wire         wegate;
   wire         PLL_BYPASS = 0;
   wire         PLL_RESETB = 1;
   wire         LOCK;
   SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
        .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
        .PLLOUT_SELECT("GENCLK"),
        .SHIFTREG_DIV_MODE(1'b0),
        .FDA_FEEDBACK(4'b0000),
        .FDA_RELATIVE(4'b0000),
        .DIVR(4'b0000),
        .DIVF(7'b0000111),
        .DIVQ(3'b101),
        .FILTER_RANGE(3'b101),
   ) uut (
        .REFERENCECLK   (i_Clk),
        .PLLOUTGLOBAL   (w_clk),
        .PLLOUTCORE     (wegate),
        .BYPASS         (PLL_BYPASS),
        .RESETB         (PLL_RESETB),
        .LOCK           (LOCK)
   );  
  
  // 25,000,000 / 115,200 = 217
  uart_rx #(.CLKS_PER_BIT(217)) UART_RX_Inst
  (.i_Clock(w_clk),
   .i_Rx_Serial(i_UART_RX),
   .o_Rx_DV(w_RX_DV),
   .o_Rx_Byte(w_RX_Byte));

  state_machine st(.i_clock(w_clk),.i_ready(w_RX_DV),.i_inputData(w_RX_Byte),.o_ready(o_ready),.o_outputData(outputData),.o_valid(o_valid));
  
  uart_tx #(.CLKS_PER_BIT(217)) UART_TX_Inst
  (.i_Clock(w_clk),
   .i_Tx_DV(o_ready),      
   .i_Tx_Byte(outputData),  
   .o_Tx_Active(w_TX_Active),
   .o_Tx_Serial(w_TX_Serial),
   .o_Tx_Done());
   
  // Drive UART line high when transmitter is not active
  assign o_UART_TX = w_TX_Active ? w_TX_Serial : 1'b1; 
      
  assign o_LED_1 = 1'b0;
  assign o_LED_2 = 1'b0;
  assign o_LED_3 = o_valid;
  assign o_LED_4 = 1'b0;
endmodule