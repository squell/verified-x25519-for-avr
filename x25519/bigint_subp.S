.global bigint_subp
.type bigint_subp, @function

// Inputs:
//    r      in register R25:R24
//    a      in register R23:R22
//    returns the borrow bit in R24
//
bigint_subp:
  
  MOVW R26, R22             ; load operand address a to X
  MOVW R30, R24             ; load address of result to Z

LDI R21,0xED
LD R20, X+
SUB R20,R21
ST Z+, R20

LDI R21,0xFF
  
.rept 30  
  LD R20, X+
  SBC R20,R21
  ST Z+, R20
.endr 

LDI R21,0x7F
LD R20, X+
SBC R20,R21
ST Z+, R20

CLR R24
ADC R24, R24

RET
