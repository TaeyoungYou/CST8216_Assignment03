; 24F_BCD_Counter_HEX_Displays.asm

#include C:\68HCS12\registers.inc

; Author:       D. Haley
; Date          24 May 2024
;
; Modified by:  < your Student Name(s) and Number(s) go here >
; Date:         < completion date goes here >
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
                org         $1000
COUNT           ds          2
                org         $2000               ; Program start location
Start:
                lds         #STACK              ; Initialize stack
                jsr         Config_HEX_Displays ; Configure Hex Displays
CheckpointC:
                ldaa        #FIRST_BCD          ; Load initial BCD value
                staa        COUNT               ; Initialize COUNT
                bra         CheckpointB         ; Start main loop
CheckpointB:
                ldaa        COUNT               ; Load COUNT
                psha
                jsr         Extract_MSB         ; Extract MSB
                ldab        #DIGIT1_PP2         ; Select MSB display
                jsr         Hex_Display         ; Display MSB
                ldaa        #DVALUE
                jsr         Delay_Ms            ; Delay
                
                ldaa        COUNT               ; Reload COUNT
                jsr         Extract_LSB         ; Extract LSB
                ldab        #DIGIT0_PP3         ; Select LSB display
                jsr         Hex_Display         ; Display LSB
                ldaa        #DVALUE
                jsr         Delay_Ms            ; Delay
                bra         CheckpointA         ; Check switch status
CheckpointA:
                ldaa        PTH                 ; Read Port H
                ; Check if SW5 is pressed (only bit 0)
                anda        #%00000001          ; Isolate bit 0 (SW5)
                beq         CheckpointF         ; Branch to increment if SW5 is pressed
                ; Check if SW4 is pressed (only bit 1)
                ldaa        PTH                 ; Reload Port H to avoid incorrect masking
                anda        #%00000010          ; Isolate bit 1 (SW4)
                beq         CheckpointD         ; Branch to decrement if SW4 is pressed
                bra         CheckpointA         ; Handle abnormal conditions if neither is pressed

CheckpointF:
                pula
                inca                            ; Increment COUNT
                psha
                anda        #%00001111          ; Isolate LSB
                cmpa        #%00001010          ; Check if invalid (>= 10)
                blo         ValidIncrement      ; If valid, branch
InvalidIncrement:
                pula
                anda        #%11110000
                adda        #$10
                staa        COUNT
                bra         CheckpointG_Increment
ValidIncrement:
                pula
                staa        COUNT              		  ; Store updated COUNT
                bra         CheckpointG_Increment         ; Validate COUNT
CheckpointD:
                pula
                deca
                cmpa        #%11111111
                beq         OutOfRange
                
		psha
                anda        #%00001111          ; Isolate LSB
                cmpa        #%00001010          ; Check if invalid (F)
                blo         ValidDecrement      ; If valid, branch
InvalidDecrement:
                pula
                suba        #$06
                staa        COUNT
                bra         CheckpointB
ValidDecrement:
                pula
                staa        COUNT              	       	  ; Store updated COUNT
                bra         CheckpointB		          ; Validate COUNT
OutOfRange:
                ldaa        #LAST_BCD
                staa        COUNT
                bra         CheckpointB
                
CheckpointG_Increment:
                ldaa        COUNT               ; Load COUNT
                cmpa        #LAST_BCD           ; Compare with LAST_BCD
                bls         CheckpointB         ; If <= LAST_BCD, loop to display
                bra         CheckpointC         ; Loop to display

Endpoint:
                swi                             ; End program
                end