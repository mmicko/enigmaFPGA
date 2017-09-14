.PHONY: all test testrotor clean prog run

all: enigma.bin

blackice: enigma_bi.bin

test: enigma.out
	vvp enigma.out

testrotor: rotor.out
	vvp rotor.out

enigma.bin: rotors.mem enigma_top.v state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v hex_to_7seg.v uart_tx.v uart_rx.v  Go_Board_Constraints.pcf 
	yosys -q -p "synth_ice40 -abc2 -nocarry -top enigma_top -blif enigma.blif" enigma_top.v state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v hex_to_7seg.v uart_tx.v uart_rx.v  
	arachne-pnr -d 1k -P vq100 -p Go_Board_Constraints.pcf enigma.blif -o enigma.txt
	icepack enigma.txt enigma.bin
	icetime -d hx1k -P vq100 enigma.txt

enigma_bi.bin: rotors.mem enigma_top_bi.v state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v uart_tx.v uart_rx.v  blackice.pcf 
	yosys -q -p "synth_ice40 -abc2 -nocarry -top enigma_top_bi -blif enigma_bi.blif" enigma_top_bi.v state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v uart_tx.v uart_rx.v  
	arachne-pnr -d 8k -P tq144:4k -p blackice.pcf enigma_bi.blif -o enigma_bi.txt
	icepack enigma_bi.txt enigma_bi.bin
	icetime -d hx8k -P tq144:4k enigma_bi.txt

enigma.out: rotors.mem test.v state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v
	iverilog -o enigma.out test.v state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v

rotor.out: testrotor.v rotor.v checkKnockpoints.v
	iverilog -o rotor.out testrotor.v rotor.v checkKnockpoints.v

prog: enigma.bin
	iceprog enigma.bin

rotors.mem: generate.py 
	python generate.py > rotors.mem

clean:
	$(RM) -f enigma.blif enigma.txt enigma.bin enigma_bi.blif enigma_bi.txt enigma_bi.bin enigma.out rotor.out abc.history enigma.vcd testrotor.vcd rotors.mem
	$(RM) -f -r obj_dir

run: obj_dir/Venigma
	obj_dir/Venigma

obj_dir/Venigma: rotors.mem state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v main.cpp
	verilator_bin -Wall --cc enigma.vlt state_machine.v encode.v rotor.v encodeASCII.v decodeASCII.v rotorEncode.v reflectorEncode.v plugboardEncode.v checkKnockpoints.v --exe main.cpp
	make -C obj_dir -j -f Venigma.mk Venigma VERILATOR_ROOT=C:/msys64/opt/share/verilator