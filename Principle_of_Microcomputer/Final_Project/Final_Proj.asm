;-----------------------------------------
; 8051 Ultrasonic Project - Final Optimized & Compilable
;-----------------------------------------

; Ports & Pins
ULTRASONIC_TRIG_PORT       EQU P3.7
ULTRASONIC_TIMEBASE_PORT   EQU P3.6
SEG_DATA_PORT              EQU P2
SEG_SHIFT_PORT             EQU P0
LED_PORT                   EQU P1
BUZZER_PORT                EQU P3.0
BUZZER_FLAG                EQU P3.1
BUZZER_COUNT_ADDR          EQU 30H   ; Internal RAM for buzzer counter

;-----------------------------------------
ORG 00H
AJMP INIT

ORG 0BH
AJMP TIMER0_ISR

ORG 013H
AJMP LOAD_DISTANCE

ORG 50H
; 7-segment data table
SEG_DATA:
    DB 03H, 09FH, 025H, 0DH, 099H, 049H, 041H, 01FH, 01H, 09H

;-----------------------------------------
INIT:
    MOV DPTR, #SEG_DATA
    MOV TMOD, #0D1H
    CLR ULTRASONIC_TIMEBASE_PORT
    MOV SEG_DATA_PORT, #0FFH
    MOV SEG_SHIFT_PORT, #01110111B
    MOV LED_PORT, #0FFH

    MOV R0, #00H       ; tens/units
    MOV R1, #00H       ; hundreds/thousands

    MOV BUZZER_COUNT_ADDR, #00H
    CLR BUZZER_FLAG
    MOV R6, #00H       ; display multiplex counter
    MOV R7, #010H      ; double dabble loop counter

    ; Enable interrupts
    SETB EX1
    SETB IT1
    SETB ET0
    SETB EA

    ; Start timers
    SETB TR0
    SETB TR1

MAIN_LOOP:
    SJMP MAIN_LOOP

;-----------------------------------------
; DISPLAY FUNCTIONS
DISPLAY:
    MOV A, SEG_SHIFT_PORT
    RR A
    MOV SEG_SHIFT_PORT, A

DISPLAY_DIGIT3:
    CJNE A, #01110111B, DISPLAY_DIGIT2
    MOV A, R1
    ANL A, #0F0H
    SWAP A
    MOVC A, @A+DPTR
    MOV SEG_DATA_PORT, A
    RET

DISPLAY_DIGIT2:
    CJNE A, #10111011B, DISPLAY_DIGIT1
    MOV A, R1
    ANL A, #0FH
    MOVC A, @A+DPTR
    MOV SEG_DATA_PORT, A
    RET

DISPLAY_DIGIT1:
    CJNE A, #11011101B, DISPLAY_DIGIT0
    MOV A, R0
    ANL A, #0F0H
    SWAP A
    MOVC A, @A+DPTR
    MOV SEG_DATA_PORT, A
    RET

DISPLAY_DIGIT0:
    CJNE A, #11101110B, DEFAULT
    MOV A, R0
    ANL A, #0FH
    MOVC A, @A+DPTR
    MOV SEG_DATA_PORT, A
    RET

DEFAULT:
    RET

;-----------------------------------------
; DOUBLE DABBLE ALGORITHM
DOUBLE_DABBLE_ALGORITHM:
    MOV R0, #00H
    MOV R1, #00H
    MOV R7, #10H

ADJUST_LOOP:
    ; High byte adjustments
    MOV A, R1
    ANL A, #0F0H
    CLR C
    SUBB A, #50H
    JC NEXT_H
    MOV A, R1
    ADD A, #30H
    MOV R1, A
NEXT_H:
    MOV A, R1
    ANL A, #0FH
    CLR C
    SUBB A, #05H
    JC NEXT_H2
    MOV A, R1
    ADD A, #03H
    MOV R1, A
NEXT_H2:
    ; Low byte adjustments
    MOV A, R0
    ANL A, #0F0H
    CLR C
    SUBB A, #50H
    JC NEXT_L
    MOV A, R0
    ADD A, #30H
    MOV R0, A
NEXT_L:
    MOV A, R0
    ANL A, #0FH
    CLR C
    SUBB A, #05H
    JC SHIFT_LEFT
    MOV A, R0
    ADD A, #03H
    MOV R0, A

SHIFT_LEFT:
    CLR C
    MOV A, TL1
    RLC A
    MOV TL1, A
    MOV A, TH1
    RLC A
    MOV TH1, A
    MOV A, R0
    RLC A
    MOV R0, A
    MOV A, R1
    RLC A
    MOV R1, A

    DJNZ R7, ADJUST_LOOP
    RET

;-----------------------------------------
; TIMER0 ISR
TIMER0_ISR:
    PUSH ACC

    ; display tick
    INC R6
    CJNE R6, #08FH, SKIP_DISPLAY
    MOV R6, #00H
	
	JB BUZZER_FLAG, BUZZER_HANDLER
    ACALL DISPLAY
	ACALL TRIG
    ACALL LED_INDICATOR

SKIP_DISPLAY:

    ; buzzer handler
    JB BUZZER_FLAG, BUZZER_HANDLER

    ; ultrasonic time base
    CPL ULTRASONIC_TIMEBASE_PORT
    MOV TH0, #0FFH
    MOV TL0, #0E3H
    CLR TF0
    POP ACC
    RETI

;-----------------------------------------
BUZZER_HANDLER:
    CLR C
    MOV A, BUZZER_COUNT_ADDR
    SUBB A, #0F0H
    JNC BUZZER_STOP

    CPL BUZZER_PORT
    INC BUZZER_COUNT_ADDR
    MOV TH0, #0FDH
    MOV TL0, #045H
    CLR TF0
    POP ACC
    RETI

BUZZER_STOP:
    MOV BUZZER_COUNT_ADDR, #00H
    CLR BUZZER_FLAG
	MOV R0, #0FFH
	MOV R1, #0FFH
    MOV TH0, #0FFH
    MOV TL0, #0E3H
    CLR TF0
    POP ACC
    RETI

;-----------------------------------------
; LOAD DISTANCE ISR
LOAD_DISTANCE:
    PUSH ACC
    CLR TR1
    ACALL DOUBLE_DABBLE_ALGORITHM
    MOV TH1, #00H
    MOV TL1, #00H
    SETB TR1
    POP ACC
    RETI

;-----------------------------------------
; LED INDICATOR
LED_INDICATOR:
    CLR C
    MOV A, R0
    SUBB A, #05H
    JNC L7
    MOV LED_PORT, #00000000B
    SETB BUZZER_FLAG
    RET
L7:
    SUBB A, #05H
    JNC L6
    MOV LED_PORT, #00000001B
    RET
L6:
    SUBB A, #05H
    JNC L5
    MOV LED_PORT, #00000011B
    RET
L5:
    SUBB A, #05H
    JNC L4
    MOV LED_PORT, #00000111B
    RET
L4:
    SUBB A, #05H
    JNC L3
    MOV LED_PORT, #00001111B
    RET
L3:
    SUBB A, #05H
    JNC L2
    MOV LED_PORT, #00011111B
    RET
L2:
    SUBB A, #05H
    JNC L1
    MOV LED_PORT, #00111111B
    RET
L1:
    SUBB A, #05H
    JNC L0
    MOV LED_PORT, #01111111B
    RET
L0:
    MOV LED_PORT, #0FFH
    RET

;-----------------------------------------
; TRIG FUNCTION
TRIG:
    CPL ULTRASONIC_TRIG_PORT
    RET

END
