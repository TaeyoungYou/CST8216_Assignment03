; API_Config.txt
; Author: D. Haley, Professor 31 July 2024
;
; API Library Routines used for this assignment.
; This file must be placed in your .asm source folder.
;
; Note that the 24F_API.s19 file replaces the
; assembly language (.asm) library files previously used
; from the C:\HCS12\Lib folder.
;
; 24F_API.s19 must be manually loaded into the Simulator
; as well as the hardware board for its subroutine to function,
; using the instructions in the "load api and code s19file.pdf" document 
;
; The following labels denote the entry points for the various
; subroutines that will be used in this assignment.
;
;See CST8216 68HCS12 API Booklet.pdf for further information.
;
Config_Sws_And_Leds         equ        $2300
Config_Hex_Displays         equ        $2317
Delay_Ms                    equ        $231F
Hex_Display                 equ        $2339
Extract_Msb                 equ        $2344
Extract_Lsb                 equ        $2349