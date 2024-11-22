; EAN_String_Conversion_Driver.asm
;
; Author:               D. Haley
; Modified by:  	Egor Vovk               S/N: 041081020
;               	John Rycca Belcina      S/N: 041128039
;               	Taeyoung You            S/N: 041079981
; Date:         	11/16/2024
;
; Purpose:              Driver program to convert 17 character EANs to
;                       a 10 Digit ISBN using a subroutine that skips the EAN's
;                       "978-" characters and any Hyphens ('-') within the
;                       EAN and converts the remaining ASCII values to Digits.
;
; Note:                 EAN stands for European Article Numbering, also referred
;                       to as EAN-13 (used in supermarkets)or ISBN-13 (used by
;                       textbook publishers).
;
;                       The subroutine you write will convert 17 character
;                       ISBN-13 Dual strings to 10 digit ISBN-10 values
;                       by stripping off (removing) "978-" and any Hyphens "-"
;                       from the string and converting the remaining characters
;                       to numeric digits.
;
; Sources:              https://www.activebarcode.com/codes/isbn13dual
;                       https://www.activebarcode.com/codes/isbn10
;
;
; Example:              ASCII format of EAN  -> 978-0-684-84438-5
;                       Digit format of ISBN -> 0684844385
;
; Program Constants
EAN_LENGTH      equ     17        ; Each ASCII EAN has 17 ASCII characters
ISBN_LENGTH     equ     10        ; Each numeric ISBN has 10 digits
NUMBER_OF_EANs  equ     06        ; Total of six EANs to Validate
ASCII_HYPHEN    equ     '-'       ; Hyphen to be removed from ASCII EAN

        org        $1000
Start_ASCII_EAN
#include EAN_Lab_Section_312.txt
End_ASCII_EAN

        org        $1070          ; Aligns Values in Simulator Address Window
Start_Numeric_ISBN
        ds        ISBN_lENGTH*NUMBER_OF_EANs    ; This array should not be the
End_Numeric_ISBN                                ; same size as the original one
                                                ; because we skip over
                                                ; EAN's "978-" and remove
                                                ; the Hyphens ('-')
Filler  db      $0A,$0A,$0A,$0A                 ; Filler bytes so we can observe
                                                ; that the destination ISBN
                                                ; array is the correct size.
        org     $2000
        lds     #$2000
        ldx     #Start_ASCII_EAN                ; Pointer to Source Array
        ldy     #Start_Numeric_ISBN             ; Pointer to Destination Array
        ldaa    #EAN_LENGTH*NUMBER_OF_EANS      ; Number of ASCII EAN Characters
                                                ; to process
        ldab    #ASCII_HYPHEN                   ; Character to Remove from EANs

        jsr     EAN_String_Conversion           ; Subroutine to strip "978-" and
                                                ; Hyphens '-' from ASCII EAN and
                                                ; convert ASCII values to Digits
                                                ; Destination Array will be
                                                ; filled with ISBN Digits
        swi
#include EAN_String_Conversion.asm              ; Subroutine to be completed
        end