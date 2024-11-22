; EAN_String_Conversion.asm
;
; Author:       D. Haley, Professor
; Date:         1 Aug 2024: ISBN-13 (EAN)
;
; Modified by:  Egor Vovk               S/N: 041081020
;               John Rycca Belcina      S/N: 041128039
;               Taeyoung You            S/N: 041079981
; Date:         11/16/2024
;
; Notes:         1. Only students identified in the above header
;                   * at the time of submission * are eligible for marks
;                   for this portion of the assignment.
;                2. ALL students must be from the SAME lab section. No exceptions
;
; Purpose:      A subroutine that will traverse through a Source Array
;               and copy its contents to a Destination Array except for
;               the first 4 characters of the EAN ("978-") and a
;               a provided specific character. Note that the length of the
;               Destination Array will be shortened by 4 with the removal of
;               "978-" and shortened by 1 for each other character that is
;               skipped over and not copied to it.
;
;               Example: Source Array has 17 elements with the "978-" and
;               13 elements other elements, which contain 3 specific characters
;               to find and skip. Destination Array will contain only
;               10 elements.
;
; Preconditions: (EAN_String_Conversion_Driver.asm sets up these Preconditions)
;               X points to first element of Source Array
;               Y points to first element of Destination array
;               A contains the Length of the Source Array
;               B contains the Character to be removed from Source Array
;
; Postconditions:
;               X, Y, A and B are destroyed
;               Source Array left unchanged
;               Destination Array contains all elements of Source Array
;               except for the "978-" and the other characters skipped over
;
; Algorithm:
;               Save Character to be Removed (passed in B) to memory
;               Take Length of the Source Array and divide it by the number
;                   of array elements. This will provide an Outer Loop Counter
;               Create a Inner Loop Counter Set to Number of Characters in EAN
;               For Outer Loop Counter value downto 0
;                   Skip "987-"
;                   For Inner Loop Counter= Number of Characters in EAN downto 0
;                       Get a Value from Source Array
;                        Increment Source Array Pointer
;                       Decrement Inner Loop_Counter
;                       if  (Value != Character to be Removed)
;                       {
;                           Convert Value from Source Array from ASCII to Digit
;                           Store Converted Value to Destination Array and
;                           increment Destination Array Pointer
;                       }
;                   If Inner Loop Counter !=0, Execute Inner Loop code again
;               Decrement Outer Loop Counter
;               If Outer Loop Counter !=0, Execute Outer Loop code again
;               return
;
; Use:          jsr EAN_String_Conversion

CONVERSION_FACTOR               equ     $30   ; ASCII to Digit Conversion Factor
Number_of_Characters_in_EAN     equ     17    ; Each EAN has 17 characters
Character_To_Remove             ds      1     ; Character to be Removed

index   ds      1

EAN_String_Conversion:

        stab    Character_To_Remove     ; Save skipped character

Array_Loop:
        psha                    	; save A in stack
        clr     index                   ; index = 0
        
        inx     ; 9
        inx     ; 7
        inx     ; 8
        inx     ; -


Conver_Loop:

        ldaa    index,x             	; Load character
        cmpa    Character_To_Remove     ; compare with -
        beq     Skip
        
        suba    CONVERSION_FACTOR       ; Convert ASCII to digit
        staa    0,y                     ; save character
        iny

Skip:
        inc     index
        cpx	Number_of_Characters_in_EAN
        bne     Conver_Loop
        
        pula
        suba    Number_of_Characters_in_EAN
        cmpa    #0
        bne     Array_Loop
        
        rts
        
        
        
        
        
        