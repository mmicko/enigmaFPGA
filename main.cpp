#include <iostream>
#include <memory>
#include "Venigma.h"
#include "verilated.h"

int main(int argc, char **argv, char **env) 
{
	Verilated::commandArgs(argc, argv);
	std::unique_ptr<Venigma> top = std::make_unique<Venigma>();

	top->i_clock = 0;
	top->i_ready = 0;
	top->eval();

	top->i_clock ^= 1; top->eval();
	top->i_clock ^= 1; top->eval();

	for (int i=0;i<20;i++)
	{
		top->i_inputData = 'A';
		top->i_ready = 1;
		top->i_clock ^= 1; top->eval();
		top->i_ready = 0;
		top->i_clock ^= 1; top->eval();

		while (top->o_ready == 0 || top->o_outputData == 0)
		{
			top->i_clock ^= 1; top->eval();			
		}

		cout << "output is " << top->o_outputData << std::endl;

		top->i_clock ^= 1; top->eval();
	}
}