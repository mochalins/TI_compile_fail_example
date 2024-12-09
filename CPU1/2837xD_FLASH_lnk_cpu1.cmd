// The user must define CLA_C in the project linker settings if using the
// CLA C compiler
// Project Properties -> C2000 Linker -> Advanced Options -> Command File
// Preprocessing -> --define
#ifdef CLA_C
// Define a size for the CLA scratchpad area that will be used
// by the CLA compiler for local symbols and temps
// Also force references to the special symbols that mark the
// scratchpad are.
CLA_SCRATCHPAD_SIZE = 0x100;
--undef_sym=__cla_scratchpad_end
--undef_sym=__cla_scratchpad_start
#endif //CLA_C

MEMORY
{
PAGE 0 :
	/* BEGIN is used for the "boot to SARAM" bootloader mode   */

	BEGIN           	: origin = 0x080000, length = 0x000002 /* USE */
	RAMM0           	: origin = 0x000123, length = 0x0002DD /* USE, ramfuncs, .pinit, .switch */
	RAMD0_D1          : origin = 0x00B000, length = 0x001000 /* USE, .cinit, .ebss, .econst */
	RAMLS0           	: origin = 0x008000, length = 0x000800
	RAMLS1            : origin = 0x008800, length = 0x000800
	RAMLS2      	    : origin = 0x009000, length = 0x000800
	RAMLS3      		  : origin = 0x009800, length = 0x000800
	RAMLS4_5          : origin = 0x00A000, length = 0x001000
	RESET           	: origin = 0x3FFFC0, length = 0x000002 /* USE */

	/* Flash sectors */
	FLASHA           : origin = 0x080002, length = 0x001FFE  /* on-chip Flash */
	FLASHB           : origin = 0x082000, length = 0x002000  /* on-chip Flash */
	FLASHC           : origin = 0x084000, length = 0x002000  /* on-chip Flash */
	FLASHD           : origin = 0x086000, length = 0x002000  /* on-chip Flash */
	FLASHE           : origin = 0x088000, length = 0x010000  /* on-chip Flash */
	// FLASHF           : origin = 0x090000, length = 0x008000  /* on-chip Flash */
	FLASHG           : origin = 0x098000, length = 0x008000  /* on-chip Flash */
	FLASHH           : origin = 0x0A0000, length = 0x008000  /* on-chip Flash */
	FLASHI           : origin = 0x0A8000, length = 0x008000  /* on-chip Flash */
	FLASHJ           : origin = 0x0B0000, length = 0x008000  /* on-chip Flash */
	FLASHK           : origin = 0x0B8000, length = 0x002000  /* on-chip Flash */
	FLASHL           : origin = 0x0BA000, length = 0x002000  /* on-chip Flash */
	FLASHM           : origin = 0x0BC000, length = 0x002000  /* on-chip Flash */
	FLASHN           : origin = 0x0BE000, length = 0x002000  /* on-chip Flash */

PAGE 1 :
	BOOT_RSVD       : origin = 0x000002, length = 0x000120 /* USE */  /* Part of M0, BOOT rom will use this for stack */
	RAMM1           : origin = 0x000400, length = 0x0003F8 /* on-chip RAM block M1 */

	// RAMGS0      : origin = 0x00C000, length = 0x001000
	// RAMGS1      : origin = 0x00D000, length = 0x001000
	// RAMGS2      : origin = 0x00E000, length = 0x001000
	// RAMGS3      : origin = 0x00F000, length = 0x001000
	// RAMGS4      : origin = 0x010000, length = 0x001000
	// RAMGS5      : origin = 0x011000, length = 0x001000
	// RAMGS6      : origin = 0x012000, length = 0x001000
	// RAMGS7      : origin = 0x013000, length = 0x001000
  // RAMGS8      : origin = 0x014000, length = 0x001000
  // RAMGS9      : origin = 0x015000, length = 0x001000
  // RAMGS10     : origin = 0x016000, length = 0x001000
  // RAMGS11     : origin = 0x017000, length = 0x001000
  // RAMGS12     : origin = 0x018000, length = 0x001000
	RAMGS0_12       : origin = 0x00C000, length = 0x00DE00
  // RAMGS13     : origin = 0x019000, length = 0x001000
  // RAMGS14     : origin = 0x01A000, length = 0x001000
  RAMGS13_14      : origin = 0x019E00, length = 0x002000
  RAMGS15         : origin = 0x01BE00, length = 0x0001F8

  CANA_MSG_RAM    : origin = 0x049000, length = 0x000800
  CANB_MSG_RAM    : origin = 0x04B000, length = 0x000800

  CPU2TOCPU1RAM   : origin = 0x03F800, length = 0x000400
  CPU1TOCPU2RAM   : origin = 0x03FC00, length = 0x000400

  CLA1_MSGRAMLOW  : origin = 0x001480,   length = 0x0000F0
 	CLA1_MSGRAMHIGH : origin = 0x001570,   length = 0x000010
}


SECTIONS
{
	codestart        : > BEGIN,      PAGE = 0, ALIGN(4)
	wddisable        : > FLASHA,     PAGE = 0
	copysections     : > FLASHA,     PAGE = 0

	.reset           : > RESET,      PAGE = 0, TYPE = DSECT /* not used, */
	.stack           : > RAMD0_D1,   PAGE = 0
	.ebss            : > RAMD0_D1,   PAGE = 0
	.esysmem         : > RAMGS13_14, PAGE = 1

	/* Initialized sections copied from flash to ram */
	.cinit    : LOAD = FLASHA,    PAGE = 0    /* can be ROM */
				        RUN = RAMD0_D1, PAGE = 0      /* must be CSM secured RAM */
                LOAD_START(_cinit_loadstart),
                RUN_START(_cinit_runstart),
                SIZE(_cinit_size)

	.const    : LOAD = FLASHA,    PAGE = 0    /* can be ROM */
                RUN = RAMD0_D1, PAGE = 0      /* must be CSM secured RAM */
                LOAD_START(_const_loadstart),
                RUN_START(_const_runstart),
                SIZE(_const_size)

	.econst   : LOAD = FLASHA,    PAGE = 0    /* can be ROM */
                RUN = RAMD0_D1, PAGE = 0      /* must be CSM secured RAM */
                LOAD_START(_econst_loadstart),
                RUN_START(_econst_runstart),
                SIZE(_econst_size)

	.pinit    : LOAD = FLASHA,    PAGE = 0    /* can be ROM */
                RUN = RAMM0, PAGE = 0         /* must be CSM secured RAM */
                LOAD_START(_pinit_loadstart),
                RUN_START(_pinit_runstart),
                SIZE(_pinit_size)

	.switch   : LOAD = FLASHA,    PAGE = 0    /* can be ROM */
                RUN = RAMM0, PAGE = 0         /* must be CSM secured RAM */
                LOAD_START(_switch_loadstart),
                RUN_START(_switch_runstart),
                SIZE(_switch_size)

	.text     : LOAD = FLASHE,    PAGE = 0    /* can be ROM */
                RUN = RAMGS0_12, PAGE = 1    /* must be CSM secured RAM */
                LOAD_START(_text_loadstart),
                RUN_START(_text_runstart),
                SIZE(_text_size)

  /* The following section definitions are required when using the IPC API Drivers */
  GROUP : > CPU1TOCPU2RAM, PAGE = 1
  {
    MSGRAM_CPU1_TO_CPU2
      PUTBUFFER
      PUTWRITEIDX
      GETREADIDX
  }

  GROUP : > CPU2TOCPU1RAM, PAGE = 1
  {
    MSGRAM_CPU2_TO_CPU1
      GETBUFFER            :  TYPE = DSECT
      GETWRITEIDX          :  TYPE = DSECT
      PUTREADIDX           :  TYPE = DSECT
  }

  /* CLA specific sections */
  #if defined(__TI_EABI__)
		Cla1Prog    : LOAD = FLASHD,
                  RUN = RAMLS4_5,
                  LOAD_START(Cla1funcsLoadStart),
                  LOAD_END(Cla1funcsLoadEnd),
                  RUN_START(Cla1funcsRunStart),
                  LOAD_SIZE(Cla1funcsLoadSize),
                  PAGE = 0, ALIGN(8)
  #else
    Cla1Prog    : LOAD = FLASHD,
                  RUN = RAMLS4_5,
                  LOAD_START(_Cla1funcsLoadStart),
                  LOAD_END(_Cla1funcsLoadEnd),
                  RUN_START(_Cla1funcsRunStart),
                  LOAD_SIZE(_Cla1funcsLoadSize),
                  PAGE = 0, ALIGN(8)
  #endif

	CLADataLS0		  : > RAMLS0, PAGE=0
	CLADataLS1		  : > RAMLS1, PAGE=0

	Cla1ToCpuMsgRAM : > CLA1_MSGRAMLOW,   PAGE = 1
	CpuToCla1MsgRAM : > CLA1_MSGRAMHIGH,  PAGE = 1

#ifdef __TI_COMPILER_VERSION__
	#if __TI_COMPILER_VERSION__ >= 15009000
		#if defined(__TI_EABI__)
			.TI.ramfunc : {}  LOAD = FLASHG,
							          RUN = RAMLS3,
                        LOAD_START(RamfuncsLoadStart),
                        LOAD_SIZE(RamfuncsLoadSize),
                 	      LOAD_END(RamfuncsLoadEnd),
                        RUN_START(RamfuncsRunStart),
                        RUN_SIZE(RamfuncsRunSize),
                        RUN_END(RamfuncsRunEnd),
							          PAGE = 0, ALIGN(8)
		#else
			.TI.ramfunc : {}  LOAD = FLASHG,
							          RUN = RAMLS3,
                        LOAD_START(_RamfuncsLoadStart),
                        LOAD_SIZE(_RamfuncsLoadSize),
                        LOAD_END(_RamfuncsLoadEnd),
                        RUN_START(_RamfuncsRunStart),
                        RUN_SIZE(_RamfuncsRunSize),
                        RUN_END(_RamfuncsRunEnd),
							          PAGE = 0, ALIGN(8)
		#endif
	#else
		ramfuncs      : LOAD = FLASHG,
						        RUN = RAMLS3,
						        LOAD_START(_RamfuncsLoadStart),
						        LOAD_SIZE(_RamfuncsLoadSize),
						        LOAD_END(_RamfuncsLoadEnd),
						        RUN_START(_RamfuncsRunStart),
                    RUN_SIZE(_RamfuncsRunSize),
                    RUN_END(_RamfuncsRunEnd),
                    PAGE = 0, ALIGN(8)
	#endif
#endif

#ifdef CLA_C
	/* CLA C compiler sections */
	//
	// Must be allocated to memory the CLA has write access to
	//
	CLAscratch      :
						{ *.obj(CLAscratch)
						. += CLA_SCRATCHPAD_SIZE;
						*.obj(CLAscratch_end) } >  RAMLS2,  PAGE = 0

	.scratchpad     : > RAMLS2,       PAGE = 0
	.bss_cla		    : > RAMLS2,       PAGE = 0
	.const_cla	    : LOAD = FLASHB,
                    RUN = RAMLS2,
                    RUN_START(_Cla1ConstRunStart),
                    LOAD_START(_Cla1ConstLoadStart),
                    LOAD_SIZE(_Cla1ConstLoadSize),
                    PAGE = 0
#endif //CLA_C
}

/*
//===========================================================================
// End of file.
//===========================================================================
*/
