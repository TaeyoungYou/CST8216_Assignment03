; EAN_String_Conversion.asm
;
; Author:       D. Haley, Professor
; Date:         1 Aug 2024: ISBN-13 (EAN)
;
; Modified by:  Egor Vovk     S/N: 041081020
;               John Rycca Belcina   S/N: 041128039
;               Taeyoung You    S/N: 041079981
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
;               10 el1ements.
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
;                   of array elements.
		;This will provide an Outer Loop Counter



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

EAN_String_Conversion:
        stab    Character_To_Remove     ; Save the character to be removed into memory

Outer_Loop:
        cmpa    #0                      ; Check if the outer loop is complete
        beq     Return_From_Function    ; Exit if no more EANs to process

        ldab    #13                     ; Set inner loop counter to 13 (remaining characters)

        ; Skip the first 4 characters ("978-")
        leax    4,X                     ; Advance X by 4 to skip the prefix

Inner_Loop:
        cmpb    #0                      ; Check if the inner loop is complete
        beq     Outer_Loop_Decrement    ; If complete, exit to decrement outer loop

        ; Load current character from the source array
        ldaa    0,X                     ; Load the current character

        ; Check for characters to skip: ASCII_HYPHEN ('-') or specific removal character
        cmpa    #'-'                    ; Compare with '-'
        beq     Skip_Character          ; Skip if it matches
        cmpa    Character_To_Remove     ; Compare with the specific character to remove
        beq     Skip_Character          ; Skip if it matches

        ; Convert valid ASCII character to numeric digit
        suba    #CONVERSION_FACTOR      ; Convert ASCII character to numeric digit

        ; Store the converted digit in the destination array
        staa    0,Y                     ; Store the value at the destination pointer
        iny                             ; Increment destination pointer (Y)

Skip_Character:
        inx                             ; Increment source pointer (X) to the next character
        decb                            ; Decrement the inner loop counter (B)
        bra     Inner_Loop              ; Repeat the inner loop

Outer_Loop_Decrement:
        leax    13,X                    ; Adjust X to move past the processed characters
        leax    4,X                     ; Move X to skip the next EAN prefix ("978-")
        deca                            ; Decrement the outer loop counter (A)
        bra     Outer_Loop              ; Repeat the outer loop

Return_From_Function:
        rts                             ; Return from the subroutine
