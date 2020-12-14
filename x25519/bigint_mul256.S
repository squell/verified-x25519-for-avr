; Authors: Michael Hutter, Peter Schwabe, Marc Schoolderman
; Version: 2014-10-03
; Public domain

  .global bigint_mul256
  .type bigint_mul256, @function

#include <avr/io.h>

/*********************************************************
 * mul128
 *
 * Inputs:
 *    a         in register R27:R26
 *    b         in register R29:R28
 *    c         in register R31:R30
 */
mul128:
  ; init zero registers
  CLR R20
  CLR R21
  MOVW R16, R20

  ;--- level 2: compute L ---
  MUL R2, R8 ;a0*b2
  MOVW R12, R0
  MUL R2, R6 ;a0*b0
  MOVW R10, R0
  MUL R2, R7 ;a0*b1
  ADD R11, R0
  ADC R12, R1
  ADC R13, R21
  MUL R3, R9 ;a1*b3
  MOVW R14, R0

  MUL R2, R9 ;a0*b3
  MOVW R18, R0
  MUL R3, R6 ;a1*b0
  ADD R11, R0
  ADC R12, R1
  ADC R13, R18
  ADC R19, R21
  MUL R3, R7 ;a1*b1
  ADD R12, R0
  ADC R13, R1
  ADC R19, R21
  MUL R4, R9 ;a2*b3
  ADD R14, R19
  ADC R15, R0
  ADC R16, R1

  MUL R4, R8 ;a2*b2
  MOVW R18, R0
  MUL R4, R6 ;a2*b0
  ADD R12, R0
  ADC R13, R1
  ADC R14, R18
  ADC R19, R21
  MUL R3, R8 ;a1*b2
  ADD R13, R0
  ADC R14, R1
  ADC R19, R21
  MUL R5, R9 ;a3*b3
  ADD R15, R19
  ADC R16, R0
  ADC R17, R1

  MUL R5, R7 ;a3*b1
  MOVW R18, R0
  MUL R4, R7 ;a2*b1
  ADD R13, R0
  ADC R18, R1
  ADC R19, R21
  MUL R5, R6 ;a3*b0
  ADD R13, R0
  ADC R18, R1
  ADC R19, R21
  MUL R5, R8 ;a3*b2
  ADD R14, R18
  ADC R0, R19
  ADC R1, R21
  ADD R15, R0
  ADC R16, R1
  ADC R17, R21
  STD Z+0, R10
  STD Z+1, R11
  STD Z+2, R12
  STD Z+3, R13
  
  ;--- load a4..a7 and b4..b7 ---
  MOVW R10, R20
  LD R18, X+
  LD R19, X+
  LD R20, X+
  ; R21 is loaded later
  LDD R22, Y+4
  LDD R23, Y+5
  LDD R24, Y+6
  LDD R25, Y+7

  ;--- level 2: compute H + (l3,l4,l5) ---
  MUL R18, R22
  ADD R14, R0
  ADC R15, R1
  ADC R16, R21
  ADC R11, R21  

  MUL R18, R23
  ADD R15, R0
  ADC R16, R1
  ADC R11, R21
  MUL R19, R22
  ADD R15, R0
  ADC R16, R1
  ADC R17, R11
  ADC R10, R21

  MUL R18, R24
  ADD R16, R0 
  ADC R17, R1
  ADC R10, R21
  MUL R19, R23
  ADD R16, R0
  ADC R17, R1
  ADC R10, R21
  MUL R20, R22
  ADD R16, R0
  ADC R17, R1
  ADC R10, R21

  CLR R11
  MUL R18, R25
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21
  MUL R19, R24
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21
  MUL R20, R23
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21
  
  ;--- subtract a0-a4 ---
  SUB R2, R18
  SBC R3, R19
  SBC R4, R20
  ; load a7 to R18
  LD R18, X+
  SBC R5, R18
  ; 0xff if carry and 0x00 if no carry
  SBC R0, R0
  
  ;--- subtract b0-b4 ---
  SUB R6, R22
  SBC R7, R23
  SBC R8, R24
  SBC R9, R25
  ; 0xff if carry and 0x00 if no carry
  SBC R1, R1

  ;--- absolute values ---        
  EOR R2, R0
  EOR R3, R0
  EOR R4, R0
  EOR R5, R0  
  EOR R6, R1
  EOR R7, R1
  EOR R8, R1
  EOR R9, R1  
  NEG R0
  NEG R1
  ADD R2, R0
  ADC R3, R21
  ADC R4, R21
  ADC R5, R21  
  ADD R6, R1
  ADC R7, R21
  ADC R8, R21
  ADC R9, R21  
  EOR R0, R1
  BST R0, 0 
  
  ;--- continue ---
  MUL R18, R22
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21

  MUL R19, R25
  CLR R19
  ADD R10, R0
  ADC R11, R1
  ADC R19, R21
  MUL R20, R24
  ADD R10, R0
  ADC R11, R1
  ADC R19, R21
  MUL R18, R23
  ADD R10, R0
  ADC R11, R1
  ADC R19, R21

  MUL R20, R25
  CLR R20
  ADD R11, R0
  ADC R19, R1
  ADC R20, R21
  MUL R18, R24
  ADD R11, R0
  ADC R19, R1
  ADC R20, R21

  MUL R18, R25
  ADD R19, R0
  ADC R20, R1

  ;--- level 2: compute M ---
  CLR R24
  CLR R25
  CLR R18

  MUL R2, R6
  MOVW R22, R0

  MUL R2, R7
  ADD R23, R0
  ADC R24, R1
  MUL R3, R6
  ADD R23, R0
  ADC R24, R1
  ADC R25, R21

  MUL R2, R8
  ADD R24, R0
  ADC R25, R1
  ADC R18, R21
  MUL R3, R7
  ADD R24, R0
  ADC R25, R1
  ADC R18, R21
  MUL R4, R6
  ADD R24, R0
  ADC R25, R1
  ADC R18, R21

  MUL R2, R9
  CLR R2
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21
  MUL R3, R8
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21
  MUL R4, R7
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21
  MUL R5, R6
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21

  MUL R3, R9
  CLR R3
  ADD R18, R0
  ADC R2, R1
  ADC R3, R21
  MUL R4, R8
  ADD R18, R0
  ADC R2, R1
  ADC R3, R21
  MUL R5, R7
  ADD R18, R0
  ADC R2, R1
  ADC R3, R21

  MUL R4, R9
  CLR R4
  ADD R2, R0
  ADC R3, R1
  ADC R4, R21
  MUL R5, R8
  ADD R2, R0
  ADC R3, R1
  ADC R4, R21

  MUL R5, R9
  ADD R3, R0
  ADC R4, R1

  ;--- add l4+h0 to l0 and h4 ---
  LDD R6, Z+0
  LDD R7, Z+1
  ADD R6, R14
  ADC R7, R15
  ADC R12, R16
  ADC R13, R17  
  ADC R14, R10
  ADC R15, R11
  ADC R16, R19
  ADC R17, R20
  ; store carry in R21
  
  ;--- process sign bit ---  
  CLR R8
  BLD R8, 0
  DEC R8

  ; merge carry and borrow
  ADC R21, R8
  MOV R0, R21
  ASR R0

  ; invert all bits or do nothing
  EOR R22, R8
  EOR R23, R8
  EOR R24, R8
  EOR R25, R8
  EOR R18, R8
  EOR R2,  R8
  EOR R3,  R8
  EOR R4,  R8
  ADD R8, R8 ; sets carry flag if R8 = 0xff

  ; add in M
  ADC R6,  R22
  ADC R7,  R23
  ADC R12, R24
  ADC R13, R25
  ADC R14, R18
  ADC R15, R2
  ADC R16, R3
  ADC R17, R4

  ; propagate carry/borrow
  ADC R10, R21
  ADC R11, R0
  ADC R19, R0
  ADC R20, R0

  STD Z+4, R6
  STD Z+5, R7
  STD Z+6, R12
  STD Z+7, R13


  
  MOVW R22, R14
  MOVW R24, R16
  MOV R18, R10
  MOV R21, R11
  ;h8...h15 stored in 22,23,24,25,18,21,19,20

  ;------ level 1: compute H ------

  ; init zero registers
  CLR R12
  CLR R13
  MOVW R14, R12
  MOVW R16, R12

  ;--- level 2: compute L ---
  LD R2, X+
  LD R3, X+
  LD R4, X+
  LD R5, X+
  LDD R6, Y+8
  LDD R7, Y+9
  LDD R8, Y+10
  LDD R9, Y+11
  
  MUL R2, R6
  MOVW R10, R0

  MUL R2, R7
  ADD R11, R0
  ADC R12, R1
  MUL R3, R6
  ADD R11, R0
  ADC R12, R1
  ADC R13, R17

  MUL R2, R8
  ADD R12, R0
  ADC R13, R1
  ADC R14, R17
  MUL R3, R7
  ADD R12, R0
  ADC R13, R1
  ADC R14, R17
  MUL R4, R6
  ADD R12, R0
  ADC R13, R1
  ADC R14, R17

  MUL R2, R9
  ADD R13, R0
  ADC R14, R1
  ADC R15, R17
  MUL R3, R8
  ADD R13, R0
  ADC R14, R1
  ADC R15, R17
  MUL R4, R7
  ADD R13, R0
  ADC R14, R1
  ADC R15, R17
  MUL R5, R6
  ADD R13, R0
  ADC R14, R1
  ADC R15, R17

  ; now add h0+l8 and h0+l12
  ADD R22, R10
  STD Z+16, R22
  ADC R23, R11
  STD Z+17, R23
  ADC R24, R12
  STD Z+18, R24
  ADC R25, R13
  STD Z+19, R25
  ADC R10, R18
  STD Z+20, R10 
  ADC R11, R21
  STD Z+21, R11
  ADC R12, R19
  ADC R13, R20
  ; store carry on stack
  SBC R0, R0
  PUSH R0
  CLR R20
  CLR R21
  
  ; continue
  MUL R3, R9
  ADD R14, R0
  ADC R15, R1
  ADC R16, R21
  MUL R4, R8
  ADD R14, R0
  ADC R15, R1
  ADC R16, R21
  MUL R5, R7
  ADD R14, R0
  ADC R15, R1
  ADC R16, R21

  MUL R4, R9
  ADD R15, R0
  ADC R16, R1
  ADC R17, R21
  MUL R5, R8
  ADD R15, R0
  ADC R16, R1
  ADC R17, R21

  MUL R5, R9
  ADD R16, R0
  ADC R17, R1

  ;--- load a4..a7 and b4..b7 ---
  MOVW R10, R20
  LD R18, X+
  LD R19, X+
  LD R20, X+
  ; R21 is loaded later
  LDD R22, Y+12
  LDD R23, Y+13
  LDD R24, Y+14
  LDD R25, Y+15

  ;--- level 2: compute H + (l3,l4,l5) ---
  MUL R18, R22
  ADD R14, R0
  ADC R15, R1
  ADC R16, R21
  ADC R11, R21  

  MUL R18, R23
  ADD R15, R0
  ADC R16, R1
  ADC R11, R21
  MUL R19, R22
  ADD R15, R0
  ADC R16, R1
  ADC R17, R11
  ADC R10, R21

  MUL R18, R24
  ADD R16, R0 
  ADC R17, R1
  ADC R10, R21
  MUL R19, R23
  ADD R16, R0
  ADC R17, R1
  ADC R10, R21
  MUL R20, R22
  ADD R16, R0
  ADC R17, R1
  ADC R10, R21

  CLR R11
  MUL R18, R25
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21
  MUL R19, R24
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21
  MUL R20, R23
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21
  
  ;--- subtract a0-a4 ---
  SUB R2, R18
  SBC R3, R19
  SBC R4, R20
  ; load a7 to R18
  LD R18, X+
  SBC R5, R18
  ; 0xff if carry and 0x00 if no carry
  SBC R0, R0
  
  ;--- subtract b0-b4 ---
  SUB R6, R22
  SBC R7, R23
  SBC R8, R24
  SBC R9, R25
  ; 0xff if carry and 0x00 if no carry
  SBC R1, R1

  ;--- absolute values ---
  EOR R2, R0
  EOR R3, R0
  EOR R4, R0
  EOR R5, R0  
  EOR R6, R1
  EOR R7, R1
  EOR R8, R1
  EOR R9, R1  
  NEG R0
  NEG R1
  ADD R2, R0
  ADC R3, R21
  ADC R4, R21
  ADC R5, R21  
  ADD R6, R1
  ADC R7, R21
  ADC R8, R21
  ADC R9, R21  
  EOR R0, R1
  BST R0, 0 
  
  ;--- continue ---
  MUL R18, R22
  ADD R17, R0
  ADC R10, R1
  ADC R11, R21

  MUL R19, R25
  CLR R19
  ADD R10, R0
  ADC R11, R1
  ADC R19, R21
  MUL R20, R24
  ADD R10, R0
  ADC R11, R1
  ADC R19, R21
  MUL R18, R23
  ADD R10, R0
  ADC R11, R1
  ADC R19, R21

  MUL R20, R25
  CLR R20
  ADD R11, R0
  ADC R19, R1
  ADC R20, R21
  MUL R18, R24
  ADD R11, R0
  ADC R19, R1
  ADC R20, R21

  MUL R18, R25
  ADD R19, R0
  ADC R20, R1

  ;--- level 2: compute M ---
  CLR R24
  CLR R25
  CLR R18

  MUL R2, R6
  MOVW R22, R0

  MUL R2, R7
  ADD R23, R0
  ADC R24, R1
  MUL R3, R6
  ADD R23, R0
  ADC R24, R1
  ADC R25, R21

  MUL R2, R8
  ADD R24, R0
  ADC R25, R1
  ADC R18, R21
  MUL R3, R7
  ADD R24, R0
  ADC R25, R1
  ADC R18, R21
  MUL R4, R6
  ADD R24, R0
  ADC R25, R1
  ADC R18, R21

  MUL R2, R9
  CLR R2
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21
  MUL R3, R8
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21
  MUL R4, R7
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21
  MUL R5, R6
  ADD R25, R0
  ADC R18, R1
  ADC R2, R21

  MUL R3, R9
  CLR R3
  ADD R18, R0
  ADC R2, R1
  ADC R3, R21
  MUL R4, R8
  ADD R18, R0
  ADC R2, R1
  ADC R3, R21
  MUL R5, R7
  ADD R18, R0
  ADC R2, R1
  ADC R3, R21

  MUL R4, R9
  CLR R4
  ADD R2, R0
  ADC R3, R1
  ADC R4, R21
  MUL R5, R8
  ADD R2, R0
  ADC R3, R1
  ADC R4, R21

  MUL R5, R9
  ADD R3, R0
  ADC R4, R1

  ;--- add l4+h0 to l0 and h4 ---
  LDD R6, Z+20
  LDD R7, Z+21
  ADD R6, R14
  ADC R7, R15
  ADC R12, R16
  ADC R13, R17  
  ADC R14, R10
  ADC R15, R11
  ADC R16, R19
  ADC R17, R20
  ; store carry in R21
  ADC R21, R21

  ;--- propagate carry ---  
  POP R0
  NEG R0
  ADD R14, R0
  CLR R0
  ADC R15, R0
  ADC R16, R0
  ADC R17, R0
  ;store carry in R21
  
  ;--- process sign bit ---
  CLR R8
  BLD R8, 0
  DEC R8

  ; merge carry and borrow
  ADC R21, R8
  MOV R0, R21
  ASR R0

  ; invert all bits or do nothing
  EOR R22, R8
  EOR R23, R8
  EOR R24, R8
  EOR R25, R8
  EOR R18, R8
  EOR R2,  R8
  EOR R3,  R8
  EOR R4,  R8
  ADD R8, R8 ; sets carry flag if R8 = 0xff

  ; add in M
  ADC R6,  R22
  ADC R7,  R23
  ADC R12, R24
  ADC R13, R25
  ADC R14, R18
  ADC R15, R2
  ADC R16, R3
  ADC R17, R4

  ; propagate carry/borrow
  ADC R10, R21
  ADC R11, R0
  ADC R19, R0
  ADC R20, R0

  STD Z+20, R6
  STD Z+21, R7
  STD Z+22, R12
  STD Z+23, R13
  STD Z+24, R14
  STD Z+25, R15
  STD Z+26, R16
  STD Z+27, R17
  STD Z+28, R10
  STD Z+29, R11
  STD Z+30, R19
  STD Z+31, R20

  ;------ level 1: subtract a0-a7 ------
  SBIW R26, 16
  LD R2, X+
  LD R3, X+
  LD R4, X+
  LD R5, X+
  LD R18, X+
  LD R19, X+
  LD R20, X+
  LD R21, X+
  LD R10, X+
  LD R11, X+
  LD R12, X+
  LD R13, X+
  LD R14, X+
  LD R15, X+
  LD R16, X+
  LD R17, X+
  
  ;store X and Y register on stack
  PUSH R26
  PUSH R27
  PUSH R28
  PUSH R29

  SUB R2, R10
  SBC R3, R11
  SBC R4, R12
  SBC R5, R13
  SBC R18, R14
  SBC R19, R15
  SBC R20, R16
  SBC R21, R17
  ; 0xff if carry and 0x00 if no carry
  SBC R0, R0
  
  ;------ level 1: subtract b0-b7 ------
  LDD R6, Y+0
  LDD R7, Y+1
  LDD R8, Y+2
  LDD R9, Y+3
  LDD R22, Y+4
  LDD R23, Y+5
  LDD R24, Y+6
  LDD R25, Y+7
  LDD R10, Y+8
  LDD R11, Y+9
  LDD R12, Y+10
  LDD R13, Y+11
  LDD R14, Y+12
  LDD R15, Y+13
  LDD R16, Y+14
  LDD R17, Y+15
  SUB R6, R10
  SBC R7, R11
  SBC R8, R12
  SBC R9, R13
  SBC R22, R14
  SBC R23, R15
  SBC R24, R16
  SBC R25, R17
  ; 0xff if carry and 0x00 if no carry
  SBC R1, R1
    
  ;--- level 1: absolute values ---
  EOR R2, R0
  EOR R3, R0
  EOR R4, R0
  EOR R5, R0
  EOR R18, R0
  EOR R19, R0
  EOR R20, R0
  EOR R21, R0
  EOR R6, R1
  EOR R7, R1
  EOR R8, R1
  EOR R9, R1
  EOR R22, R1
  EOR R23, R1
  EOR R24, R1
  EOR R25, R1
  NEG R0
  NEG R1
  CLR R26
  CLR R27
  ADD R2, R0
  ADC R3, R26
  ADC R4, R26
  ADC R5, R26
  ADC R18, R26
  ADC R19, R26
  ADC R20, R26
  ADC R21, R26  
  ADD R6, R1
  ADC R7, R26
  ADC R8, R26
  ADC R9, R26
  ADC R22, R26
  ADC R23, R26
  ADC R24, R26
  ADC R25, R26  
  EOR R0, R1
  PUSH R0

  ;------ level 1: compute M ------
  MOVW R16, R26

  MUL R2, R8 ;a0*b2
  MOVW R12, R0
  MUL R2, R6 ;a0*b0
  MOVW R10, R0
  MUL R2, R7 ;a0*b1
  ADD R11, R0
  ADC R12, R1
  ADC R13, R26
  MUL R3, R9 ;a1*b3
  MOVW R14, R0

  MUL R2, R9 ;a0*b3
  MOVW R28, R0
  MUL R3, R6 ;a1*b0
  ADD R11, R0
  ADC R12, R1
  ADC R13, R28
  ADC R29, R26
  MUL R3, R7 ;a1*b1
  ADD R12, R0
  ADC R13, R1
  ADC R29, R26
  MUL R4, R9 ;a2*b3
  ADD R14, R29
  ADC R15, R0
  ADC R16, R1

  MUL R4, R8 ;a2*b2
  MOVW R28, R0
  MUL R4, R6 ;a2*b0
  ADD R12, R0
  ADC R13, R1
  ADC R14, R28
  ADC R29, R26
  MUL R3, R8 ;a1*b2
  ADD R13, R0
  ADC R14, R1
  ADC R29, R26
  MUL R5, R9 ;a3*b3
  ADD R15, R29
  ADC R16, R0
  ADC R17, R1

  MUL R5, R7 ;a3*b1
  MOVW R28, R0
  MUL R4, R7 ;a2*b1
  ADD R13, R0
  ADC R28, R1
  ADC R29, R26
  MUL R5, R6 ;a3*b0
  ADD R13, R0
  ADC R28, R1
  ADC R29, R26
  MUL R5, R8 ;a3*b2
  ADD R14, R28
  ADC R0, R29
  ADC R1, R26
  ADD R15, R0
  ADC R16, R1
  ADC R17, R26

  ;--- subtract a0-a4 ---  
  SUB R2, R18
  SBC R3, R19
  SBC R4, R20
  SBC R5, R21
  ; 0xff if carry and 0x00 if no carry
  SBC R0, R0
  
  ;--- subtract b0-b4 ---  
  SUB R6, R22
  SBC R7, R23
  SBC R8, R24
  SBC R9, R25
  ; 0xff if carry and 0x00 if no carry
  SBC R1, R1

  ;--- absolute values ---  
  EOR R2, R0
  EOR R3, R0
  EOR R4, R0
  EOR R5, R0  
  EOR R6, R1
  EOR R7, R1
  EOR R8, R1
  EOR R9, R1  
  NEG R0
  NEG R1
  ADD R2, R0
  ADC R3, R26
  ADC R4, R26
  ADC R5, R26  
  ADD R6, R1
  ADC R7, R26
  ADC R8, R26
  ADC R9, R26  
  EOR R0, R1
  BST R0, 0 
  
  ;--- level 2: compute H + (l3,l4,l5) ---
  MUL R18, R24 ;a0*b2
  MOVW R28, R0
  MUL R18, R22 ;a0*b0
  ADD R14, R0
  ADC R15, R1
  ADC R16, R28
  ADC R29, R26
  MUL R18, R23 ;a0*b1
  ADD R15, R0
  ADC R16, R1
  ADC R29, R26
  MUL R19, R25 ;a1*b3
  ADD R17, R29
  ADC R26, R0
  ADC R27, R1

  MUL R18, R25 ;a0*b3
  MOVW R28, R0
  MUL R19, R22 ;a1*b0
  ADD R15, R0
  ADC R16, R1
  ADC R17, R28
  CLR R18
  ADC R29, R18
  MUL R19, R23 ;a1*b1
  ADD R16, R0
  ADC R17, R1
  ADC R29, R18
  MUL R20, R25 ;a2*b3
  ADD R26, R29
  ADC R27, R0
  CLR R18
  ADC R18, R1

  MUL R20, R24 ;a2*b2
  MOVW R28, R0
  MUL R20, R22 ;a2*b0
  ADD R16, R0
  ADC R17, R1
  ADC R26, R28
  CLR R0
  ADC R29, R0
  MUL R19, R24 ;a1*b2
  ADD R17, R0
  ADC R26, R1
  CLR R19
  ADC R29, R19
  MUL R21, R25 ;a3*b3
  ADD R27, R29
  ADC R18, R0
  CLR R25
  ADC R25, R1
  
  MUL R21, R23 ;a3*b1
  MOVW R28,R0
  MUL R20, R23 ;a2*b1
  ADD R17, R0
  ADC R28, R1
  ADC R29, R19
  MUL R21, R22 ;a3*b0
  ADD R17, R0
  ADC R28, R1
  ADC R29, R19
  MUL R21, R24 ;a3*b2
  ADD R26, R28
  ADC R0, R29
  ADC R1, R19
  ADD R27, R0
  ADC R18, R1
  ADC R25, R19

  ;--- level 2: compute M ---
  MUL R2, R8 ;a0*b2
  MOVW R22, R0
  MUL R2, R6 ;a0*b0
  MOVW R20, R0
  MUL R2, R7 ;a0*b1
  ADD R21, R0
  ADC R22, R1
  ADC R23, R19
  MUL R3, R9 ;a1*b3
  MOV R24, R0
  MOV R0, R2
  MOV R2, R1

  MUL R0, R9 ;a0*b3
  MOVW R28, R0
  MUL R3, R6 ;a1*b0
  ADD R21, R0
  ADC R22, R1
  ADC R23, R28
  ADC R29, R19
  MUL R3, R7 ;a1*b1
  ADD R22, R0
  ADC R23, R1
  ADC R29, R19
  MUL R4, R9 ;a2*b3
  ADD R24, R29
  ADC R2, R0
  ADC R19, R1  

  MUL R4, R8 ;a2*b2
  MOVW R28, R0
  MUL R4, R6 ;a2*b0
  ADD R22, R0
  ADC R23, R1
  ADC R24, R28
  CLR R0
  ADC R29, R0
  MUL R3, R8 ;a1*b2
  ADD R23, R0
  ADC R24, R1
  CLR R3
  ADC R29, R3
  MUL R5, R9 ;a3*b3
  ADD R2, R29
  ADC R19, R0
  CLR R9
  ADC R9, R1

  MUL R5, R7 ;a3*b1
  MOVW R28, R0
  MUL R4, R7 ;a2*b1
  ADD R23, R0
  ADC R28, R1
  ADC R29, R3
  MUL R5, R6 ;a3*b0
  ADD R23, R0
  ADC R28, R1
  ADC R29, R3
  MUL R5, R8 ;a3*b2
  ADD R24, R28
  ADC R0, R29
  ADC R1, R3
  ADD R2, R0
  ADC R19, R1
  ADC R9, R3

  ;--- add l4+h0 to l0 and h4 ---
  MOVW R4, R10
  MOVW R6, R12
  ADD R10, R14
  ADC R11, R15
  ADC R12, R16
  ADC R13, R17
  ADC R14, R26
  ADC R15, R27
  ADC R16, R18
  ADC R17, R25
  ; store carry in R3
  
  ;--- process sign bit ---
  CLR R0
  BLD R0, 0
  DEC R0

  ; merge carry and borrow
  ADC R3, R0
  MOV R1, R3
  ASR R1

  ; invert all bits or do nothing
  EOR R20, R0
  EOR R21, R0
  EOR R22, R0
  EOR R23, R0
  EOR R24, R0
  EOR R2,  R0
  EOR R19, R0
  EOR R9,  R0
  ADD R0, R0 ; sets carry flag if R0 = 0xff

  ; add in M
  ADC R10, R20
  ADC R11, R21
  ADC R12, R22
  ADC R13, R23
  ADC R14, R24
  ADC R15, R2
  ADC R16, R19
  ADC R17, R9

  ; propagate carry/borrow
  ADC R26, R3
  ADC R27, R1
  ADC R18, R1
  ADC R25, R1

  MOV R19, R25

  ;------ level 1: combine L, H, and M ------
  LDD R20, Z+0
  LDD R21, Z+1
  LDD R22, Z+2
  LDD R23, Z+3
  LDD R24, Z+4  
  LDD R25, Z+5
  LDD R8, Z+6 
  LDD R9, Z+7

  ;--- process sign bit ---  
  POP R0  
  DEC R0

  MOV R1, R0
  ASR R1

  ; invert all bits or do nothing
  EOR R4, R0
  EOR R5, R0
  EOR R6, R0
  EOR R7, R0
  EOR R10, R0
  EOR R11, R0
  EOR R12, R0
  EOR R13, R0
  EOR R14, R0
  EOR R15, R0
  EOR R16, R0
  EOR R17, R0
  EOR R26, R0
  EOR R27, R0
  EOR R18, R0
  EOR R19, R0
  ; add in M
  ADC R20, R4
  ADC R21, R5
  ADC R22, R6
  ADC R23, R7
  ADC R24, R10
  ADC R25, R11
  ADC R8,  R12
  ADC R9,  R13
  ; store carry in R28
  CLR R28
  ADC R28, R28

  LDD R2, Z+16
  LDD R3, Z+17
  ADD R20, R2
  ADC R21, R3
  STD Z+8, R20
  STD Z+9, R21
  MOVW R20, R2
  LDD R2, Z+18
  LDD R3, Z+19
  ADC R22, R2
  ADC R23, R3
  STD Z+10, R22
  STD Z+11, R23
  MOVW R22, R2
  LDD R2, Z+20
  LDD R3, Z+21
  ADC R24, R2
  ADC R25, R3
  STD Z+12, R24
  STD Z+13, R25
  MOVW R24, R2
  LDD R2, Z+22
  LDD R3, Z+23
  ADC R8, R2
  ADC R9, R3
  STD Z+14, R8
  STD Z+15, R9
  MOVW R8, R2
  ; store carry in R2
  CLR R2
  ADC R2, R2

  LSR R28
  ADC R20, R14
  ADC R21, R15
  ADC R22, R16
  ADC R23, R17
  ADC R24, R26
  ADC R25, R27
  ADC R8, R18
  ADC R9, R19
  ; store carry in R1:R0
  ADC R0, R28
  ADC R1, R28

  LDD R4, Z+24
  LDD R5, Z+25
  LDD R6, Z+26
  LDD R7, Z+27
  LDD R10, Z+28
  LDD R11, Z+29
  LDD R12, Z+30
  LDD R13, Z+31

  LSR R2
  ADC R20, R4
  ADC R21, R5
  ADC R22, R6
  ADC R23, R7
  ADC R24, R10
  ADC R25, R11
  ADC R8,  R12
  ADC R9,  R13
  ; store carry in R1:R0
  ADC R0, R2
  ADC R1, R2

  STD Z+16, R20
  STD Z+17, R21
  STD Z+18, R22
  STD Z+19, R23
  STD Z+20, R24
  STD Z+21, R25
  STD Z+22, R8
  STD Z+23, R9

  ;--- propagate carry to end ---
  ADD R4, R0
  ADC R5, R1
  ADC R6, R1
  ADC R7, R1
  ADC R10, R1
  ADC R11, R1
  ADC R12, R1
  ADC R13, R1

  STD Z+24, R4
  STD Z+25, R5
  STD Z+26, R6
  STD Z+27, R7
  STD Z+28, R10
  STD Z+29, R11
  STD Z+30, R12
  STD Z+31, R13

  ; restore X and Y register
  POP R29
  POP R28
  POP R27
  POP R26
  RET




; operand b: r21:r20
; operand a: r23:r22
; operand r: r25:r24
bigint_mul256:

  PUSH R2
  PUSH R3
  PUSH R4
  PUSH R5
  PUSH R6
  PUSH R7
  PUSH R8
  PUSH R9
  PUSH R10
  PUSH R11
  PUSH R12
  PUSH R13
  PUSH R14
  PUSH R15
  PUSH R16
  PUSH R17
  PUSH R28
  PUSH R29

  MOVW R30, R24
  MOVW R28, R20
  MOVW R26, R22

  ;--- level 1: compute L ---
  LD R2, X+
  LD R3, X+
  LD R4, X+
  LD R5, X+
  LDD R6, Y+0
  LDD R7, Y+1
  LDD R8, Y+2
  LDD R9, Y+3
  RCALL mul128

  ;--- level 1: compute H ---
  ADIW R28, 16
  ADIW R30, 32
  LD R2, X+
  LD R3, X+
  LD R4, X+
  LD R5, X+
  LDD R6, Y+0
  LDD R7, Y+1
  LDD R8, Y+2
  LDD R9, Y+3
  RCALL mul128
  SBIW R28, 16
  SBIW R30, 32

  ;--- level 1: HIGH(L)+LOW(H) ---
  LDD R0, Z+16
  LDD R1, Z+32
  ADD R0, R1
  STD Z+32, R0
  LDD R0, Z+17
  LDD R1, Z+33
  ADC R0, R1
  STD Z+33, R0
  LDD R0, Z+18
  LDD R1, Z+34
  ADC R0, R1
  STD Z+34, R0
  LDD R0, Z+19
  LDD R1, Z+35
  ADC R0, R1
  STD Z+35, R0
  LDD R0, Z+20
  LDD R1, Z+36
  ADC R0, R1
  STD Z+36, R0
  LDD R0, Z+21
  LDD R1, Z+37
  ADC R0, R1
  STD Z+37, R0
  LDD R0, Z+22
  LDD R1, Z+38
  ADC R0, R1
  STD Z+38, R0
  LDD R0, Z+23
  LDD R1, Z+39
  ADC R0, R1
  STD Z+39, R0
  LDD R0, Z+24
  LDD R1, Z+40
  ADC R0, R1
  STD Z+40, R0
  LDD R0, Z+25
  LDD R1, Z+41
  ADC R0, R1
  STD Z+41, R0
  LDD R0, Z+26
  LDD R1, Z+42
  ADC R0, R1
  STD Z+42, R0
  LDD R0, Z+27
  LDD R1, Z+43
  ADC R0, R1
  STD Z+43, R0
  LDD R0, Z+28
  LDD R1, Z+44
  ADC R0, R1
  STD Z+44, R0
  LDD R0, Z+29
  LDD R1, Z+45
  ADC R0, R1
  STD Z+45, R0
  LDD R0, Z+30
  LDD R1, Z+46
  ADC R0, R1
  STD Z+46, R0
  LDD R0, Z+31
  LDD R1, Z+47
  ADC R0, R1
  STD Z+47, R0
  ;propagate carry to end
  CLR R0
  LDD R1, Z+48
  ADC R1, R0
  STD Z+48, R1
  LDD R1, Z+49
  ADC R1, R0
  STD Z+49, R1
  LDD R1, Z+50
  ADC R1, R0
  STD Z+50, R1
  LDD R1, Z+51
  ADC R1, R0
  STD Z+51, R1
  LDD R1, Z+52
  ADC R1, R0
  STD Z+52, R1
  LDD R1, Z+53
  ADC R1, R0
  STD Z+53, R1
  LDD R1, Z+54
  ADC R1, R0
  STD Z+54, R1
  LDD R1, Z+55
  ADC R1, R0
  STD Z+55, R1
  LDD R1, Z+56
  ADC R1, R0
  STD Z+56, R1
  LDD R1, Z+57
  ADC R1, R0
  STD Z+57, R1
  LDD R1, Z+58
  ADC R1, R0
  STD Z+58, R1
  LDD R1, Z+59
  ADC R1, R0
  STD Z+59, R1
  LDD R1, Z+60
  ADC R1, R0
  STD Z+60, R1
  LDD R1, Z+61
  ADC R1, R0
  STD Z+61, R1
  LDD R1, Z+62
  ADC R1, R0
  STD Z+62, R1
  LDD R1, Z+63
  ADC R1, R0
  STD Z+63, R1

  ;--- level 1: subtract a0-a15 ---
  SBIW R26, 32
  LD R2, X+
  LD R3, X+
  LD R4, X+
  LD R5, X+
  LD R18, X+
  LD R19, X+
  LD R20, X+
  LD R21, X+
  LD R10, X+
  LD R11, X+
  LD R12, X+
  LD R13, X+
  LD R14, X+
  LD R15, X+
  LD R16, X+
  LD R17, X+

  LD R0, X+
  SUB R2, R0
  LD R0, X+
  SBC R3, R0
  LD R0, X+
  SBC R4, R0
  LD R0, X+
  SBC R5, R0
  LD R0, X+
  SBC R18, R0
  LD R0, X+
  SBC R19, R0
  LD R0, X+
  SBC R20, R0
  LD R0, X+
  SBC R21, R0  
  LD R0, X+
  SBC R10, R0
  LD R0, X+
  SBC R11, R0
  LD R0, X+
  SBC R12, R0
  LD R0, X+
  SBC R13, R0
  LD R0, X+
  SBC R14, R0
  LD R0, X+
  SBC R15, R0
  LD R0, X+
  SBC R16, R0
  LD R0, X+
  SBC R17, R0
  ; store borrow in R0
  SBC R0, R0

  ;--- level 1: absolute values ---
  EOR R2, R0
  EOR R3, R0
  EOR R4, R0
  EOR R5, R0
  EOR R18, R0
  EOR R19, R0
  EOR R20, R0
  EOR R21, R0
  EOR R10, R0
  EOR R11, R0
  EOR R12, R0
  EOR R13, R0
  EOR R14, R0
  EOR R15, R0
  EOR R16, R0
  EOR R17, R0
  NEG R0
  CLR R22
  ADD R2, R0
  ADC R3, R22
  ADC R4, R22
  ADC R5, R22
  ADC R18, R22
  ADC R19, R22
  ADC R20, R22
  ADC R21, R22
  ADC R10, R22
  ADC R11, R22
  ADC R12, R22
  ADC R13, R22
  ADC R14, R22
  ADC R15, R22
  ADC R16, R22
  ADC R17, R22

  ;--- level 1: write absolute values to temp ---
  STD Z+16, R2
  STD Z+17, R3
  STD Z+18, R4
  STD Z+19, R5
  STD Z+20, R18
  STD Z+21, R19
  STD Z+22, R20
  STD Z+23, R21
  STD Z+24, R10
  STD Z+25, R11
  STD Z+26, R12
  STD Z+27, R13
  STD Z+28, R14
  STD Z+29, R15
  STD Z+30, R16
  STD Z+31, R17
  
  ;--- level 1: subtract b0-b15 ---
  LDD R6, Y+0
  LDD R7, Y+1
  LDD R8, Y+2
  LDD R9, Y+3
  LDD R22, Y+4
  LDD R23, Y+5
  LDD R24, Y+6
  LDD R25, Y+7
  LDD R10, Y+8
  LDD R11, Y+9 
  LDD R12, Y+10
  LDD R13, Y+11
  LDD R14, Y+12
  LDD R15, Y+13
  LDD R16, Y+14
  LDD R17, Y+15
  
  LDD R1, Y+16
  SUB R6, R1
  LDD R1, Y+17
  SBC R7, R1
  LDD R1, Y+18
  SBC R8, R1
  LDD R1, Y+19
  SBC R9, R1
  LDD R1, Y+20
  SBC R22, R1
  LDD R1, Y+21
  SBC R23, R1
  LDD R1, Y+22
  SBC R24, R1
  LDD R1, Y+23
  SBC R25, R1
  LDD R1, Y+24
  SBC R10, R1
  LDD R1, Y+25
  SBC R11, R1
  LDD R1, Y+26
  SBC R12, R1
  LDD R1, Y+27
  SBC R13, R1
  LDD R1, Y+28
  SBC R14, R1
  LDD R1, Y+29
  SBC R15, R1
  LDD R1, Y+30
  SBC R16, R1
  LDD R1, Y+31
  SBC R17, R1
  ; store borrow in R1
  SBC R1, R1

  ;--- level 1: absolute values ---
  EOR R6, R1
  EOR R7, R1
  EOR R8, R1
  EOR R9, R1
  EOR R22, R1
  EOR R23, R1
  EOR R24, R1
  EOR R25, R1
  EOR R10, R1
  EOR R11, R1
  EOR R12, R1
  EOR R13, R1
  EOR R14, R1
  EOR R15, R1
  EOR R16, R1
  EOR R17, R1
  NEG R1
  CLR R28
  ADD R6, R1
  ADC R7, R28
  ADC R8, R28
  ADC R9, R28
  ADC R22, R28
  ADC R23, R28
  ADC R24, R28
  ADC R25, R28
  ADC R10, R28
  ADC R11, R28
  ADC R12, R28
  ADC R13, R28
  ADC R14, R28
  ADC R15, R28
  ADC R16, R28
  ADC R17, R28

  ;--- level 1: push absolute values on stack ---
  MOVW R26, R30
  ADIW R26, 20
  IN R30, 0x3D
  IN R31, 0x3E
  SBIW R30, 48
  IN R20, 0x3F
  CLI
  OUT 0x3E, R31
  OUT 0x3F, R20
  OUT 0x3D, R30
  ADIW R30, 1
  MOVW R28, R30
  ST Z+, R6
  ST Z+, R7
  ST Z+, R8
  ST Z+, R9
  ST Z+, R22
  ST Z+, R23
  ST Z+, R24
  ST Z+, R25
  ST Z+, R10
  ST Z+, R11
  ST Z+, R12
  ST Z+, R13
  ST Z+, R14
  ST Z+, R15
  ST Z+, R16
  ST Z+, R17

  EOR R0, R1
  PUSH R0

  ;--- level 1: compute M ---
  RCALL mul128

  ;restore address of result in Y
  MOVW R28, R26
  SBIW R28, 32
  POP R20

  ;--- level 1: combine L, H, and M ---
  LDD R0, Y+0
  LDD R1, Y+1
  LDD R2, Y+2
  LDD R3, Y+3
  LDD R4, Y+4
  LDD R5, Y+5
  LDD R6, Y+6
  LDD R7, Y+7
  LDD R8, Y+8
  LDD R9, Y+9
  LDD R10, Y+10
  LDD R11, Y+11
  LDD R12, Y+12
  LDD R13, Y+13
  LDD R14, Y+14
  LDD R15, Y+15

  ;--- process sign bit ---  
  TST R20
  BRNE add_M

  ;subtract M
  LDD R16, Z+0
  SUB R0, R16
  LDD R16, Z+1
  SBC R1, R16
  LDD R16, Z+2
  SBC R2, R16
  LDD R16, Z+3
  SBC R3, R16
  LDD R16, Z+4
  SBC R4, R16
  LDD R16, Z+5
  SBC R5, R16
  LDD R16, Z+6
  SBC R6, R16
  LDD R16, Z+7
  SBC R7, R16
  LDD R16, Z+8
  SBC R8, R16
  LDD R16, Z+9
  SBC R9, R16
  LDD R16, Z+10
  SBC R10, R16
  LDD R16, Z+11
  SBC R11, R16
  LDD R16, Z+12
  SBC R12, R16
  LDD R16, Z+13
  SBC R13, R16
  LDD R16, Z+14
  SBC R14, R16
  LDD R16, Z+15
  SBC R15, R16
  ; store borrow in R16
  SBC R16, R16
  RJMP final2

add_M:
  ;add M
  LDD R16, Z+0
  ADD R0, R16
  LDD R16, Z+1
  ADC R1, R16
  LDD R16, Z+2
  ADC R2, R16
  LDD R16, Z+3
  ADC R3, R16
  LDD R16, Z+4
  ADC R4, R16
  LDD R16, Z+5
  ADC R5, R16
  LDD R16, Z+6
  ADC R6, R16
  LDD R16, Z+7
  ADC R7, R16
  LDD R16, Z+8
  ADC R8, R16
  LDD R16, Z+9
  ADC R9, R16
  LDD R16, Z+10
  ADC R10, R16
  LDD R16, Z+11
  ADC R11, R16
  LDD R16, Z+12
  ADC R12, R16
  LDD R16, Z+13
  ADC R13, R16
  LDD R16, Z+14
  ADC R14, R16
  LDD R16, Z+15
  ADC R15, R16
  ; store carry in R16
  CLR R16
  ADC R16, R16
  
final2:
  LDD R17, Y+32
  ADD R0, R17
  STD Y+16, R0
  LDD R0, Y+33
  ADC R1, R0
  STD Y+17, R1
  LDD R1, Y+34
  ADC R2, R1
  STD Y+18, R2
  LDD R2, Y+35
  ADC R3, R2
  STD Y+19, R3
  LDD R3, Y+36
  ADC R4, R3
  STD Y+20, R4
  LDD R4, Y+37
  ADC R5, R4
  STD Y+21, R5
  LDD R5, Y+38
  ADC R6, R5
  STD Y+22, R6
  LDD R6, Y+39
  ADC R7, R6
  STD Y+23, R7
  LDD R7, Y+40
  ADC R8, R7
  STD Y+24, R8
  LDD R8, Y+41
  ADC R9, R8
  STD Y+25, R9
  LDD R9, Y+42
  ADC R10, R9
  STD Y+26, R10
  LDD R10, Y+43
  ADC R11, R10
  STD Y+27, R11
  LDD R11, Y+44
  ADC R12, R11
  STD Y+28, R12
  LDD R12, Y+45
  ADC R13, R12
  STD Y+29, R13
  LDD R13, Y+46
  ADC R14, R13
  STD Y+30, R14
  LDD R14, Y+47
  ADC R15, R14
  STD Y+31, R15
  ; store carry in R1
  CLR R18
  ADC R18, R18

  TST R20
  BRNE add_M_2

  ;subtract M
  LSR R16
  LDD R16, Z+16
  SBC R17, R16
  LDD R16, Z+17
  SBC R0, R16
  LDD R16, Z+18
  SBC R1, R16
  LDD R16, Z+19
  SBC R2, R16
  LDD R16, Z+20
  SBC R3, R16
  LDD R16, Z+21
  SBC R4, R16
  LDD R16, Z+22
  SBC R5, R16
  LDD R16, Z+23
  SBC R6, R16
  LDD R16, Z+24
  SBC R7, R16
  LDD R16, Z+25
  SBC R8, R16
  LDD R16, Z+26
  SBC R9, R16
  LDD R16, Z+27
  SBC R10, R16
  LDD R16, Z+28
  SBC R11, R16
  LDD R16, Z+29
  SBC R12, R16
  LDD R16, Z+30
  SBC R13, R16
  LDD R16, Z+31
  SBC R14, R16
  ; store borrow in R27:R26
  SBC R26, R26
  SBC R27, R27
  RJMP final3

add_M_2:
  ;add M
  LSR R16
  LDD R16, Z+16
  ADC R17, R16
  LDD R16, Z+17
  ADC R0, R16
  LDD R16, Z+18
  ADC R1, R16
  LDD R16, Z+19
  ADC R2, R16
  LDD R16, Z+20
  ADC R3, R16
  LDD R16, Z+21
  ADC R4, R16
  LDD R16, Z+22
  ADC R5, R16
  LDD R16, Z+23
  ADC R6, R16
  LDD R16, Z+24
  ADC R7, R16
  LDD R16, Z+25
  ADC R8, R16
  LDD R16, Z+26
  ADC R9, R16
  LDD R16, Z+27
  ADC R10, R16
  LDD R16, Z+28
  ADC R11, R16
  LDD R16, Z+29
  ADC R12, R16
  LDD R16, Z+30
  ADC R13, R16
  LDD R16, Z+31
  ADC R14, R16
  ; store carry in R16
  CLR R26
  CLR R27
  ADC R26, R26
  
final3:
  LSR R18
  LDD R19, Y+48
  ADC R17, R19
  STD Y+32, R17
  LDD R17, Y+49
  ADC R0, R17
  STD Y+33, R0
  LDD R0, Y+50
  ADC R1, R0
  STD Y+34, R1
  LDD R1, Y+51
  ADC R2, R1
  STD Y+35, R2
  LDD R2, Y+52
  ADC R3, R2
  STD Y+36, R3
  LDD R3, Y+53
  ADC R4, R3
  STD Y+37, R4
  LDD R4, Y+54
  ADC R5, R4
  STD Y+38, R5
  LDD R5, Y+55
  ADC R6, R5
  STD Y+39, R6
  LDD R6, Y+56
  ADC R7, R6
  STD Y+40, R7
  LDD R7, Y+57
  ADC R8, R7
  STD Y+41, R8
  LDD R8, Y+58
  ADC R9, R8
  STD Y+42, R9
  LDD R9, Y+59
  ADC R10, R9
  STD Y+43, R10
  LDD R10, Y+60
  ADC R11, R10
  STD Y+44, R11
  LDD R11, Y+61
  ADC R12, R11
  STD Y+45, R12
  LDD R12, Y+62
  ADC R13, R12
  STD Y+46, R13
  LDD R13, Y+63
  ADC R14, R13
  STD Y+47, R14 
  ; store carry in R1
  ADC R26, R18
  ADC R27, R18

  ;--- propagate carry to end ---
  ADD R19, R26
  ADC R17, R27
  ADC R0, R27
  ADC R1, R27
  ADC R2, R27
  ADC R3, R27
  ADC R4, R27
  ADC R5, R27
  ADC R6, R27
  ADC R7, R27
  ADC R8, R27
  ADC R9, R27
  ADC R10, R27
  ADC R11, R27
  ADC R12, R27
  ADC R13, R27
  
  STD Y+48, R19
  STD Y+49, R17
  STD Y+50, R0
  STD Y+51, R1
  STD Y+52, R2
  STD Y+53, R3
  STD Y+54, R4
  STD Y+55, R5
  STD Y+56, R6
  STD Y+57, R7
  STD Y+58, R8
  STD Y+59, R9
  STD Y+60, R10
  STD Y+61, R11
  STD Y+62, R12
  STD Y+63, R13

  ADIW R30, 31
  IN R1, 0x3F
  CLI
  OUT 0x3E, R31
  OUT 0x3F, R1
  OUT 0x3D, R30
  
  CLR R1
  POP R29
  POP R28
  POP R17
  POP R16
  POP R15
  POP R14
  POP R13
  POP R12
  POP R11
  POP R10
  POP R9
  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  RET
