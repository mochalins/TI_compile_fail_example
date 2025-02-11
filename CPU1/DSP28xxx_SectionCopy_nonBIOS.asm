;############################################################################
;
; FILE:   DSP28xxx_SectionCopy_nonBIOS.asm
;
; DESCRIPTION:  Provides functionality for copying initialized sections from
;				flash to ram at runtime before entering the _c_int00 startup
;				routine
;############################################################################
; Author: Tim Love
; Release Date: March 2008	
;############################################################################


	.ref _c_int00
	.global copy_sections
	.global _cinit_loadstart, _cinit_runstart, _cinit_size
	.global _const_loadstart, _const_runstart, _const_size
	.global _econst_loadstart, _econst_runstart, _econst_size
	.global _pinit_loadstart, _pinit_runstart, _pinit_size
	.global _switch_loadstart, _switch_runstart, _switch_size
	.global _text_loadstart, _text_runstart, _text_size
	.global _RamfuncsLoadStart, _RamfuncsRunStart, _RamfuncsLoadSize
	.global _Cla1funcsLoadStart, _Cla1funcsRunStart, _Cla1funcsLoadSize
	.global _Cla1ConstLoadStart, _Cla1ConstRunStart, _Cla1ConstLoadSize


***********************************************************************
* Function: copy_sections
*
* Description: Copies initialized sections from flash to ram
***********************************************************************

	.sect "copysections"

copy_sections:

	MOVL XAR5,#_cinit_size			; Store Section Size in XAR5
	MOVL ACC,@XAR5						; Move Section Size to ACC
	MOVL XAR6,#_cinit_loadstart	; Store Load Starting Address in XAR6
    MOVL XAR7,#_cinit_runstart	; Store Run Address in XAR7
    LCR  copy							; Branch to Copy

	MOVL XAR5,#_const_size			; Store Section Size in XAR5
	MOVL ACC,@XAR5						; Move Section Size to ACC
	MOVL XAR6,#_const_loadstart	; Store Load Starting Address in XAR6
    MOVL XAR7,#_const_runstart	; Store Run Address in XAR7
    LCR  copy							; Branch to Copy

	MOVL XAR5,#_econst_size			; Store Section Size in XAR5
	MOVL ACC,@XAR5						; Move Section Size to ACC
	MOVL XAR6,#_econst_loadstart	; Store Load Starting Address in XAR6
    MOVL XAR7,#_econst_runstart	; Store Run Address in XAR7
    LCR  copy							; Branch to Copy

	MOVL XAR5,#_pinit_size			; Store Section Size in XAR5
	MOVL ACC,@XAR5						; Move Section Size to ACC
	MOVL XAR6,#_pinit_loadstart	; Store Load Starting Address in XAR6
    MOVL XAR7,#_pinit_runstart	; Store Run Address in XAR7
    LCR  copy							; Branch to Copy 

	MOVL XAR5,#_switch_size			; Store Section Size in XAR5
	MOVL ACC,@XAR5						; Move Section Size to ACC
	MOVL XAR6,#_switch_loadstart	; Store Load Starting Address in XAR6
    MOVL XAR7,#_switch_runstart	; Store Run Address in XAR7
    LCR  copy							; Branch to Copy

	MOVL XAR5,#_text_size			; Store Section Size in XAR5
	MOVL ACC,@XAR5						; Move Section Size to ACC
	MOVL XAR6,#_text_loadstart		; Store Load Starting Address in XAR6
    MOVL XAR7,#_text_runstart		; Store Run Address in XAR7
    LCR  copy							; Branch to Copy

    MOVL XAR5,#_RamfuncsLoadSize
    MOVL ACC,@XAR5
    MOVL XAR6,#_RamfuncsLoadStart
    MOVL XAR7,#_RamfuncsRunStart
    LCR copy

    MOVL XAR5,#_Cla1funcsLoadSize
    MOVL ACC,@XAR5
    MOVL XAR6,#_Cla1funcsLoadStart
    MOVL XAR7,#_Cla1funcsRunStart
    LCR copy

    MOVL XAR5,#_Cla1ConstLoadSize
    MOVL ACC,@XAR5
    MOVL XAR6,#_Cla1ConstLoadStart
    MOVL XAR7,#_Cla1ConstRunStart
    LCR copy
	   
  	LB _c_int00				 			; Branch to start of boot.asm in RTS library

copy:	
	B return,EQ							; Return if ACC is Zero (No section to copy)

	SUBB ACC,#1

    RPT AL								; Copy Section From Load Address to
    || PWRITE  *XAR7, *XAR6++			; Run Address

return:
	LRETR								; Return

	.end
	
;//===========================================================================
;// End of file.
;//===========================================================================
