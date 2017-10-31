rotors = []
rotors.append(['E','K','M','F','L','G','D','Q','V','Z','N','T','O','W','Y','H','X','U','S','P','A','I','B','R','C','J']) # Rotor I
rotors.append(['A','J','D','K','S','I','R','U','X','B','L','H','W','T','M','C','Q','G','Z','N','P','Y','F','V','O','E']) # Rotor II
rotors.append(['B','D','F','H','J','L','C','P','R','T','X','V','Z','N','Y','E','I','W','G','A','K','M','U','S','Q','O']) # Rotor III
rotors.append(['E','S','O','V','P','Z','J','A','Y','Q','U','I','R','H','X','L','N','F','T','G','K','D','C','M','W','B']) # Rotor IV
rotors.append(['V','Z','B','R','G','I','T','Y','U','P','S','D','N','H','L','X','A','W','M','J','Q','O','F','E','C','K']) # Rotor V
rotors.append(['J','P','G','V','O','U','M','F','Y','Q','B','E','N','H','Z','R','D','K','A','S','X','L','I','C','T','W']) # Rotor VI
rotors.append(['N','Z','J','H','G','R','C','X','M','Y','S','W','B','O','U','F','A','I','V','L','P','E','K','Q','D','T']) # Rotor VII
rotors.append(['F','K','Q','H','T','L','X','O','C','B','J','S','P','D','Z','R','A','M','E','W','N','I','U','Y','G','V']) # Rotor VIII

for rotor in rotors:
    for code in rotor:
        print(format(ord(code)-65, '02x'))

for rotor in rotors:
	for num in range(0, 26):
		for i in range(0, 26):
			if (rotor[i]==chr(num+65)):
				print(format(i, '02x'))
