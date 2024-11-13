; 24F_BCD_Counter_HEX_Displays.asm

#include C:\68HCS12\registers.inc

; Author:       D. Haley
; Date          24 May 2024
;
; Modified by:  Egor Vovk       	S/N: 041081020
;               John Rycca Belcina      S/N: 041128039
;               Taeyoung You            S/N: 041079981
; Date:         11/16/2024
;
; Purpose       Up/Down Count BCD Counter $00 - $99 (BCD) using Hex Displays
;               and a single register, Accumulator A, for the count
;               The range of counting can be altered by changing the
;               FIRST_BCD and LAST_BCD constants.
;
; Algorithm:
;               Initialize starting value of count to FIRST_BCD
;               Initialize ending value of count to LAST_BCD
;               Display FIRST_BCD
;               Loop: Get a value from PTH
;                     if SW5 (SW1-1) is presssed, count upwards
;                        else if SW4 (SW1-2) is pressed, count downwards
;                          else Loop
;
; Speed of Counter:
;
;                 The speed of the counter is adjusted by changing DVALUE,
;               which changes the delay of displaying values in
;               the Delay Subroutine Value. Any delays > 255 ms will require
;               addition lines of code to obtain the required delay
;
;               ldaa    #DVALUE         ; delay for DVALUE milliseconds
;               jsr     Delay_ms
;
; Direction of Counter:
;
;               The direction of the count is controlled by SW5, SW1-1,
;               SW4 and SW1-2.
;
;               FIRST_BCD must be < LAST_BCD and both must be 8-bit values.
;
; Counting Upwards:
;
;               Each time SW5 is momentarily pressed, the counter counts
;               one count upwards in BCD.
;
;               If SW5 is pressed and held down or SW1-1 is unchecked
;               (in the simulator), or SW1-1 on the hardware board is ON (pushed
;               downwards), the count continuously counts upwards in BCD
;               until that condition is changed.
;
;               If the count > LAST_BCD, then count resets to FIRST_BCD.
;
; Counting Downwards:
;
;               When SW4 is pressed, the counter counts downwards in BCD.
;
;               If SW4 is pressed and held down or SW1-2 is unchecked
;               (in the simulator), or SW1-2 on the hardware board is ON (pushed
;               downwards), the count continuously counts upwards in BCD
;               until that condition is changed.
;
;               If the count < START_BCD, then count resets to LAST_BCD.
;
; Abnormal Condition:
;
;               It is not normal for switches to be pressed for a
;               count upwards and a count downwards at the same time.
;               Results are unpredicatable.
;
;
; ***** DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****

#include        API_Config.txt

; Program Constants
STACK           equ     $2000

; Port H SWITCHES
SW4             equ     %11111101  ; b1 = 0 if SW4 is pressed
SW5             equ     %11111110  ; b0 = 0 if SW5 is pressed

; Port P (PPT) Display Selection Values
DIGIT1_PP2      equ     %1011   ; 2nd from right-most display MSB
DIGIT0_PP3      equ     %0111   ; right-most display LSB

OUT_OF_RANGE    equ     $FF     ; Out of range value when down counting
                                ; e.g. $00  - $01 = $FF

; ***** END OF DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****

; Delay Subroutine Values
; Could also be termed Switch Debounce value, as the switches MUST be debounced
DVALUE  equ     250                    ; Delay value (base 10) 0 - 255 ms
                                ; 125 = 1/8 second <- good for Dragon12 Board

; Changing these values will change the Starting and Ending BCD counts
FIRST_BCD       equ     $00     ; Starting BCD count ( < LAST_BCD )
LAST_BCD        equ     $99     ; Ending BCD count   ( > FIRST_BCD )

        org     $2000           ; program code
Start   lds     #STACK          ; stack location

        jsr     Config_HEX_Displays ; Use the Hex Displays to display the count

        end