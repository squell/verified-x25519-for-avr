.global avrnacl_fe25519_red
.type avrnacl_fe25519_red @function

//*********************************************************
// avrnacl_fe25519_red
// reduces the result modulo 2^256-38
//
// Inputs:
//    r       in register R25:R24
//    C       in register R23:R22
//
avrnacl_fe25519_red:
  
  CLR R18           ; load a zero value
  LDI R19, 38       ; load constant 38 to R19
  
  MOVW R26, R22     ; load address of t in X
  MOVW R30, R24     ; load address of r in Z
  MOVW R24, R28     ; save Y register in R24
  MOVW R28, R22     ; put address of upper half of t in Y

  ADIW R26, 31 ; get ptr to byte #31 
  LD R21,X
  SBIW R26, 31 ; restore ptr to byte #0
  ADIW R28, 32 ; make Y point to the upper half
  LDD R22,Y+31

  MUL R22,R19 ; result to accumulate in r0:r1
  ADD R21,R0
  ADC R1,R18  ; r21 and r1 now hold values for bytes #31 and #32

  ADD R21,R21
  ADC R1,R1   ; R1 now holds the value to be multiplied with 19
  LSR R21     ; R21 now holds result content for byte #31. Bit #7 cleared.
  STD Z+31, R21 ; save intermediate result for byte #31

  LDI r19,19  
  MUL R19,r1 ; result to accumulate to word #0 in r0,r1
  LDI r19,38  
 
  LD R21, X+        ; load r0  indirect from RAM
  CLR R23
  ADD R21,R0
  ADC R23,R1
 
  LD R22, Y+        ; load r32 indirect from RAM
  MUL R22, R19
  ADD R21, R0
  ADC R23, R1
  ST Z+, R21 ; OK byte #0 is finished.

  .rept 30  
  LD R21, X+        ; load r1  indirect from RAM
  LD R22, Y+        ; load r33 indirect from RAM
  MUL R22, R19
  ADD R21, R23
  CLR R23
  ADC R23, R1
  ADD R21, R0
  ADC R23, R18
  ST Z+, R21
  .endr 
  ; OK, byte #30 is finished

  ; finalize byte #31
  LD R21,Z
  ADD R21,R23
  ST Z, R21
 
  MOVW R28, R24     ; restore Y register

  CLR R1  

  RET

