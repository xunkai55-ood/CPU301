LI R1 1
LI R2 1
LI R3 85
SLL R3 R3 0
SW R3 R1 0
SW R3 R2 1
LI R4 18
ADDIU R3 2
ADDU R1 R2 R1
SLTU R2 R1
BTEQZ 9
NOP
SW R3 R1 0
ADDU R1 R2 R2
SLTU R1 R2
BTEQZ 4
NOP
SW R3 R2 1
ADDIU R4 FF
BNEZ R4 F3
RET