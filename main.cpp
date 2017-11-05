#include <iostream>
#include <memory>
#include "Venigma.h"
#include "verilated.h"

const char plaintext[26] = { 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z' };
 
const char rotors[8][26] = { { 'E','K','M','F','L','G','D','Q','V','Z','N','T','O','W','Y','H','X','U','S','P','A','I','B','R','C','J' }, // Rotor I
							 { 'A','J','D','K','S','I','R','U','X','B','L','H','W','T','M','C','Q','G','Z','N','P','Y','F','V','O','E' }, // Rotor II
							 { 'B','D','F','H','J','L','C','P','R','T','X','V','Z','N','Y','E','I','W','G','A','K','M','U','S','Q','O' }, // Rotor III
							 { 'E','S','O','V','P','Z','J','A','Y','Q','U','I','R','H','X','L','N','F','T','G','K','D','C','M','W','B' }, // Rotor IV
							 { 'V','Z','B','R','G','I','T','Y','U','P','S','D','N','H','L','X','A','W','M','J','Q','O','F','E','C','K' }, // Rotor V
							 { 'J','P','G','V','O','U','M','F','Y','Q','B','E','N','H','Z','R','D','K','A','S','X','L','I','C','T','W' }, // Rotor VI
							 { 'N','Z','J','H','G','R','C','X','M','Y','S','W','B','O','U','F','A','I','V','L','P','E','K','Q','D','T' }, // Rotor VII
							 { 'F','K','Q','H','T','L','X','O','C','B','J','S','P','D','Z','R','A','M','E','W','N','I','U','Y','G','V' } }; // Rotor VIII


							  //{ 'L','E','Y','J','V','C','N','I','X','W','P','B','Q','M','D','R','T','A','K','Z','G','F','U','H','O','S' }, // M4 Greek Rotor "b" (beta)
							  //{ 'F','S','O','K','A','N','U','E','R','H','M','B','T','I','Y','C','W','L','Q','P','Z','X','V','G','J','D' } }; // M4 Greek Rotor "g" (gama)

const char reflectors[2][26] = { { 'Y','R','U','H','Q','S','L','D','P','X','N','G','O','K','M','I','E','B','F','Z','C','W','V','J','A','T' }, // M3 B
								 { 'F','V','P','J','I','A','O','Y','E','D','R','Z','X','W','G','C','T','K','U','Q','S','B','N','M','H','L' } }; // M3 C
								 //{ 'E','N','K','Q','A','U','Y','W','J','I','C','O','P','B','L','M','D','X','Z','V','F','T','H','R','G','S' }, // M4 thin B
								 //{ 'R','D','O','B','J','N','T','K','V','E','H','M','L','F','C','W','Z','A','X','G','Y','I','P','S','U','Q' } }; // M4 thin C

int knockpoints[8][2] = {
	{ 16+1, 16 + 1 }, //   Q - one knockpoint (R I)
	{ 4 + 1,  4 + 1 }, //   E - one knockpoint (R II)
	{ 21 + 1, 21 + 1 }, //   V - one knockpoint (R III)
	{ 9 + 1,  9 + 1 }, //   J - one knockpoint (R IV)
	{ 0, 0 }, //   Z - one knockpoint (R V)
	{ 0, 12 + 1 }, // Z/M - two knockpoints (R VI)
	{ 0, 12 + 1 }, // Z/M - two knockpoints (R VII)
	{ 0, 12 + 1 } }; // Z/M - two knockpoints (R VIII)

int validate(int num)
{
	if (num < 0) return num + 26;
	if (num >= 26) return num - 26;
	return num;

}

int findWeel(int weel, int num, bool pass)
{
	if (!pass)
	{
		return rotors[weel][num] - 65;
	}
	else {
		for (int i = 0; i < 26; i++) if (rotors[weel][i] == (num + 65)) return i;
	}
}

int mapLetter(int number, int ring, int start, int weel, bool pass)
{
	int out = validate(number - ring);
	out = validate(out + start);
	out = findWeel(weel, out, pass);
	out = validate(out - start);
	out = validate(out + ring);
	return out;
}

int prev_knock1 = 0;
int prev_knock2 = 0;

void incrementGround(int &ground1, int &ground2, int &ground3, int r1,int r2, int r3)
{
	int knock1 = 0;
	int knock2 = 0;
	
	ground1++;
	if (ground1 > 25) ground1 = 0;
	
	
	if ((knockpoints[r1][0] == ground1) || (knockpoints[r1][1] == ground1)) {
		knock1 = 1;
	}
	if ((knockpoints[r2][0] == ground2) || (knockpoints[r2][1] == ground2)) {
		knock2 = 1;
	}
	
	if ((prev_knock1==0) && (knock1==1)) 
	{
		ground2++;
		if (ground2 > 25) ground2 = 0;
	}
	if ((prev_knock2==0) && (knock2==1)) 
	{
		ground3++;
		if (ground3 > 25) ground3 = 0;
	}

	prev_knock1 = knock1;
	prev_knock2 = knock2;	
}

char plugboard[26] = { 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z' };

int rotor1 = 2;
int rotor2 = 1;
int rotor3 = 0;

int ring1 = 0;
int ring2 = 0;
int ring3 = 0;

int ground1 = 0;
int ground2 = 0;
int ground3 = 0;


char encode(char input)
{
	incrementGround(ground1, ground2, ground3, rotor1, rotor2, rotor3);


	int number = plugboard[int(input) - 65] - 65;

	//printf("Kb=%c\n", input);
	//printf("Pb=%c\n", input);

	number = mapLetter(number, ring1, ground1, rotor1, false);
	//printf("R=%c\n", char(number + 65));
	number = mapLetter(number, ring2, ground2, rotor2, false);
	//printf("M=%c\n", char(number + 65));
	number = mapLetter(number, ring3, ground3, rotor3, false);
	//printf("L=%c\n", char(number + 65));

	number = reflectors[0][number] - 65;

	//printf("Rf=%c\n", char(number + 65));

	number = mapLetter(number, ring3, ground3, rotor3, true);
	//printf("L=%c\n", char(number + 65));
	number = mapLetter(number, ring2, ground2, rotor2, true);
	//printf("M=%c\n", char(number + 65));
	number = mapLetter(number, ring1, ground1, rotor1, true);
	//printf("R=%c\n", char(number + 65));

	//printf("Pb=%c\n", plugboard[number]);

	return plugboard[number];
}


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

		char val = encode('A');

		std::cout << "output is " << top->o_outputData << std::endl;

		if (val != top->o_outputData) {
			std::cout << "error : iteration " << i << " output is " << top->o_outputData << " and expected is " << val << std::endl;
			//break;
		}
		top->i_clock ^= 1; top->eval();
	}
}