# enigmaFPGA

Enigma in FPGA, made for learning Verilog as part of presentation on BalcCon 2017.

Version of code from conference is at separate branch (Balccon2017):
https://github.com/mmicko/enigmafpga/tree/Balccon2017

Due to limitation of presentation uart_rx and uart_tx modules are used from :
https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html

Project contains build files for various targets.

* make - creates binary for Go Board (using yosis and arachne-pnr)
* make blackice - creates binary for BlackIce FPGA
* make prog - programs Go Board (using iceprog)
* make test - run Verilog test for encryption (using iverilog)
* make testrotor - run Verilog test for rotor rotating (using iverilog)
* make run - run C++ tests (using verilator)

More explanation and Javascript reference application at : http://enigma.louisedade.co.uk/enigma.html

