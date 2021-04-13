
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega2561
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega2561
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8192
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x200

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x74
	.EQU XMCRB=0x75
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0200
	.EQU __SRAM_END=0x21FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ControllerRunMethod=R4
	.DEF _SolenoidTestType=R3
	.DEF _TestGrade=R6
	.DEF _CW_DIR=R5
	.DEF _z_led_flag=R8
	.DEF _a_led_flag=R7
	.DEF _modRunning=R10
	.DEF _ScanEnable=R9
	.DEF _crackValue=R12
	.DEF _dotValue=R11
	.DEF _scan_ad_ch=R14
	.DEF _ScanStopEnable=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int5_isr
	JMP  _ext_int6_isr
	JMP  _ext_int7_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0xC4,0x9
_0x4:
	.DB  0x5E,0x1
_0x5:
	.DB  0xA
_0x6:
	.DB  0x2,0x0,0x4,0xA0,0x0,0x0,0x0,0x3
_0x7:
	.DB  0xA
_0x8:
	.DB  0x5
_0x9:
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x1D,0x0
	.DB  0x26,0x0,0x33,0x0,0x3C,0x0,0x49,0x0
	.DB  0x52,0x0,0x5F,0x0,0x68,0x0,0x0,0x0
	.DB  0x2,0x1,0x0,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x0,0x1,0x0,0x2,0x0,0x3,0x0
	.DB  0x4,0x0,0x5,0x0,0x6,0x0,0x7,0x0
	.DB  0x8,0x0,0x0,0x0,0x0,0x1,0x0,0x2
	.DB  0x0,0x3,0x0,0x4,0x0,0x5,0x0,0x32
	.DB  0x0,0x32,0x0,0x32,0x0,0x32,0x0,0x32
	.DB  0x0,0x32,0x0,0x8C,0x0,0x92,0x0,0x98
	.DB  0x0,0x9E,0x0,0xA4,0x0,0xAA,0x0,0x1
	.DB  0x2,0x4,0x8,0x10,0x20,0xA8,0x2,0x58
	.DB  0x2,0x8,0x2,0xE0,0x1,0xA4,0x1,0x40
	.DB  0x1,0x40,0x1,0x0,0x0,0x0,0x0,0x52
	.DB  0x3,0xA7,0x2,0x57,0x2,0x7,0x2,0xDF
	.DB  0x1,0xA3,0x1,0x52,0x3,0x0,0x0,0x0
	.DB  0x0
_0x26:
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x1D,0x0
	.DB  0x26,0x0,0x33,0x0,0x3C,0x0,0x49,0x0
	.DB  0x52,0x0,0x5F,0x0,0x68,0x0,0x0,0x0
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x0,0x1,0x0,0x2,0x0,0x3,0x0
	.DB  0x4,0x0,0x5,0x0,0x6,0x0,0x7,0x0
	.DB  0x8,0x0,0x0,0x0,0x0,0x1,0x0,0x2
	.DB  0x0,0x3,0x0,0x4,0x0,0x5,0x0,0x32
	.DB  0x0,0x32,0x0,0x32,0x0,0x32,0x0,0x32
	.DB  0x0,0x32,0x0,0x14,0x0,0x21,0x0,0x2E
	.DB  0x0,0x3B,0x0,0x48,0x0,0x55,0x0,0x1
	.DB  0x2,0x4,0x8,0x10,0x20,0xA8,0x2,0x58
	.DB  0x2,0x8,0x2,0xE0,0x1,0xA4,0x1,0x40
	.DB  0x1,0x40,0x1,0x0,0x0,0x0,0x0,0x52
	.DB  0x3,0xA7,0x2,0x57,0x2,0x7,0x2,0xDF
	.DB  0x1,0xA3,0x1,0x52,0x3,0x0,0x0,0x0
	.DB  0x0
_0x39:
	.DB  0x0,0x40,0x10,0x50,0x20,0x60,0x30,0x70
_0xA4:
	.DB  0x1
_0xA5:
	.DB  0x19
_0xA6:
	.DB  0x5
_0xA7:
	.DB  0x3
_0xA8:
	.DB  0xA
_0xA9:
	.DB  0x1
_0xAA:
	.DB  0x9
_0xAB:
	.DB  0x0,0x80,0x40,0xC0,0x20,0xA0,0x60,0xE0
_0xF3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x1FC:
	.DB  0x0,0x0,0x0,0x0,0xBC,0x2,0x8A,0x2
	.DB  0x44,0x2,0xF4,0x1,0xC2,0x1,0x86,0x1
	.DB  0x0,0x0,0x0,0x0,0x64,0x0
_0x2F0:
	.DB  0x26,0x1,0x26,0x1,0x26,0x1,0x26,0x1
	.DB  0x26,0x1,0x26,0x1

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _MAX_SCAN_REF
	.DW  _0x3*2

	.DW  0x02
	.DW  _COMM_SET_Position
	.DW  _0x4*2

	.DW  0x01
	.DW  _avr_loop_cnt
	.DW  _0x5*2

	.DW  0x08
	.DW  _A_TX_DATA
	.DW  _0x6*2

	.DW  0x01
	.DW  _timer_period
	.DW  _0x8*2

	.DW  0x08
	.DW  __ADC_CH
	.DW  _0x39*2

	.DW  0x01
	.DW  _Crack_Dot_Chk_Enable
	.DW  _0xA4*2

	.DW  0x01
	.DW  _init_off_correction
	.DW  _0xA5*2

	.DW  0x01
	.DW  _deAccelStartCount
	.DW  _0xA6*2

	.DW  0x01
	.DW  _accelStartCount
	.DW  _0xA7*2

	.DW  0x01
	.DW  _DelayTimeCount
	.DW  _0xA8*2

	.DW  0x01
	.DW  _accel_rdy
	.DW  _0xA9*2

	.DW  0x01
	.DW  _PackerSharedEnable
	.DW  _0xAA*2

	.DW  0x08
	.DW  _Marking_MOUT_SNG
	.DW  _0xAB*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

	OUT  EIND,R24

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x600

	.CSEG
;/**************************************************/
;/* PROJECT NAME : EGG GRADER & PACKING SYSTEM     */
;/* AUTHOR COMPANY : EGGTEC.,CO.LTD                */
;/* MACHINE NAME : B25K-V3                         */
;/* DESCRITE : GRADE SPEED 25,000~30,000           */
;/*            MAX 8 GRADE & PACKER                */
;/* 1st revision : 2013. 06.17 (MJHyun)            */
;/* 2nd revision : 2013. 10.01                     */
;/* 3rd revision : 2013. 10.15                     */
;/* 4th revision : 2014. 01.25                     */
;/*              인쇄기능수정:등외란 인쇄가능      */
;/*                           무한,유한 오류수정   */
;/*              시작/정지시 솔타점 유지시간 보정  */
;/* 5th revision : 2014. 03.10                     */
;/*              시작/정지시 보정분해능 상향       */
;/* 6th revision : 2014.10.12                      */
;/*              나벨 저가 acd 신호처리 변경       */
;/*              신호처리 버퍼에 넣고              */
;/*              특정한 버퍼 위치 값을 체크        */
;/*              선별 데이터 전송 프로토콜 변경,   */
;/*              헤더 파일 변경                    */
;/* 7th revision : 2019.08.13                      */
;/*              마킹기 마킹 모드를 8종으로 확대   */
;/*                                                */
;/*                                                */
;/*                                                */
;/**************************************************/
;
;#include "b25k-v3_4_1.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
;	infotype -> Y+131
;	icnt -> R17
;	icnt1 -> R16
;	grade_hilimit -> Y+113
;	grade_lolimit -> Y+95
;	sol_outsignal -> Y+89
;	sol_ontime -> Y+77
;	sol_offtime -> Y+65
;	sol_id -> Y+53
;	sol_packer -> Y+35
;	gtype -> Y+26
;	startpocketnumber -> Y+8
;	ldcell_ch -> Y+2
_Initailize_PARAMETER:
; .FSTART _Initailize_PARAMETER
	SBIW R28,63
	SBIW R28,63
	SBIW R28,3
	LDI  R24,129
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x26*2)
	LDI  R31,HIGH(_0x26*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	icnt -> R17
;	icnt1 -> R16
;	grade_hilimit -> Y+113
;	grade_lolimit -> Y+95
;	sol_outsignal -> Y+89
;	sol_ontime -> Y+77
;	sol_offtime -> Y+65
;	sol_id -> Y+53
;	sol_packer -> Y+35
;	gtype -> Y+26
;	startpocketnumber -> Y+8
;	ldcell_ch -> Y+2
	LDI  R17,LOW(0)
_0x28:
	CPI  R17,9
	BRSH _0x29
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_GRADE_INFO)
	SBCI R31,HIGH(-_GRADE_INFO)
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(113))
	SBCI R27,HIGH(-(113))
	CALL SUBOPT_0x0
	__ADDW1MN _GRADE_INFO,2
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(95))
	SBCI R27,HIGH(-(95))
	CALL SUBOPT_0x0
	__ADDW1MN _GRADE_INFO,4
	LDI  R26,LOW(6)
	STD  Z+0,R26
	CALL SUBOPT_0x1
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _GRADE_INFO,6
	CALL SUBOPT_0x2
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _GRADE_INFO,8
	CALL SUBOPT_0x2
	SUBI R17,-1
	RJMP _0x28
_0x29:
	LDI  R17,LOW(0)
_0x2B:
	CPI  R17,9
	BRLO PC+2
	RJMP _0x2C
	LDI  R16,LOW(0)
_0x2E:
	CPI  R16,6
	BRLO PC+2
	RJMP _0x2F
	LDI  R26,LOW(48)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_SOL_INFO)
	SBCI R31,HIGH(-_SOL_INFO)
	CALL SUBOPT_0x3
	LDI  R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x4
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x5
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	CALL SUBOPT_0x6
	ST   X,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0x5
	MOVW R26,R28
	SUBI R26,LOW(-(77))
	SBCI R27,HIGH(-(77))
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	CALL SUBOPT_0x5
	MOVW R26,R28
	SUBI R26,LOW(-(65))
	SBCI R27,HIGH(-(65))
	CALL SUBOPT_0x8
	__ADDW1MN _SOL_INFO,36
	MOVW R26,R30
	MOV  R30,R16
	CALL SUBOPT_0xA
	MOVW R22,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,35
	CALL SUBOPT_0xB
	LD   R0,X+
	LD   R1,X
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,53
	CALL SUBOPT_0xB
	CALL __GETW1P
	OR   R30,R0
	OR   R31,R1
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	SUBI R16,-1
	RJMP _0x2E
_0x2F:
	SUBI R17,-1
	RJMP _0x2B
_0x2C:
	LDI  R17,LOW(0)
_0x31:
	CPI  R17,9
	BRSH _0x32
	CALL SUBOPT_0xC
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,26
	CALL SUBOPT_0x6
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	CALL SUBOPT_0xC
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LDI  R30,LOW(6)
	ST   X,R30
	CALL SUBOPT_0xC
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,3
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,8
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x6
	ST   X,R30
	SUBI R17,-1
	RJMP _0x31
_0x32:
	LDI  R17,LOW(0)
_0x34:
	CPI  R17,6
	BRSH _0x35
	LDI  R26,LOW(5)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_LDCELL_INFO)
	SBCI R31,HIGH(-_LDCELL_INFO)
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x6
	ST   X,R30
	CALL SUBOPT_0xD
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R26,LOW(5)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _LDCELL_INFO,3
	CALL SUBOPT_0x2
	SUBI R17,-1
	RJMP _0x34
_0x35:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0xE
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xF
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x10
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x12
	LDI  R30,LOW(225)
	LDI  R31,HIGH(225)
	CALL SUBOPT_0x13
	LDI  R17,LOW(0)
_0x37:
	CPI  R17,2
	BRSH _0x38
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_PRT_INFO)
	SBCI R31,HIGH(-_PRT_INFO)
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _PRT_INFO,2
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _PRT_INFO,4
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	SUBI R17,-1
	RJMP _0x37
_0x38:
	LDI  R30,LOW(60)
	__PUTB1MN _SYS_INFO,11
	__PUTB1MN _SYS_INFO,4
	LDI  R30,LOW(1600)
	LDI  R31,HIGH(1600)
	CALL SUBOPT_0x14
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CALL SUBOPT_0x15
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	__PUTW1MN _SYS_INFO,9
	LDI  R30,LOW(19)
	__PUTB1MN _SYS_INFO,12
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,63
	ADIW R28,5
	RET
; .FEND
_Initialize_GPIO:
; .FSTART _Initialize_GPIO
	LDI  R30,LOW(255)
	OUT  0x1,R30
	OUT  0x2,R30
	LDI  R30,LOW(167)
	OUT  0x4,R30
	OUT  0x5,R30
	LDI  R30,LOW(255)
	OUT  0x7,R30
	LDI  R30,LOW(127)
	OUT  0x8,R30
	LDI  R30,LOW(8)
	OUT  0xA,R30
	LDI  R30,LOW(255)
	OUT  0xB,R30
	LDI  R30,LOW(6)
	OUT  0xD,R30
	LDI  R30,LOW(255)
	OUT  0xE,R30
	OUT  0x10,R30
	OUT  0x11,R30
	LDI  R30,LOW(1)
	OUT  0x13,R30
	OUT  0x14,R30
	RET
; .FEND
_Initialize_REG:
; .FSTART _Initialize_REG
	LDI  R30,LOW(0)
	OUT  0x24,R30
	LDI  R30,LOW(5)
	OUT  0x25,R30
	LDI  R30,LOW(241)
	OUT  0x26,R30
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x28,R30
	STS  128,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	LDI  R30,LOW(0)
	STS  135,R30
	STS  134,R30
	LDI  R30,LOW(6)
	STS  137,R30
	LDI  R30,LOW(26)
	STS  136,R30
	LDI  R30,LOW(0)
	STS  139,R30
	STS  138,R30
	STS  141,R30
	STS  140,R30
	LDI  R30,LOW(2)
	STS  111,R30
	LDI  R30,LOW(5)
	STS  105,R30
	LDI  R30,LOW(244)
	STS  106,R30
	LDI  R30,LOW(227)
	OUT  0x1D,R30
	OUT  0x1C,R30
	LDI  R30,LOW(0)
	STS  200,R30
	LDI  R30,LOW(216)
	STS  201,R30
	LDI  R30,LOW(6)
	STS  202,R30
	LDI  R30,LOW(0)
	STS  205,R30
	LDI  R30,LOW(16)
	STS  204,R30
	LDI  R30,LOW(0)
	OUT  0x35,R30
	LDI  R30,LOW(128)
	STS  116,R30
	LDI  R30,LOW(0)
	STS  117,R30
	RET
; .FEND
;#include "ADS8344E-ADC.h"

	.DSEG

	.CSEG
_RD_ADC:
; .FSTART _RD_ADC
	ST   -Y,R26
	CALL __SAVELOCR6
;	ch -> Y+6
;	config -> R17
;	clk -> R16
;	config_bit -> R19
;	tmp -> R20,R21
	LDI  R17,0
	__GETWRN 20,21,0
	LDI  R17,LOW(128)
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-__ADC_CH)
	SBCI R31,HIGH(-__ADC_CH)
	LD   R30,Z
	OR   R17,R30
	ORI  R17,LOW(4)
	ORI  R17,LOW(3)
	CBI  0x5,0
	LDI  R16,LOW(0)
_0x3D:
	CPI  R16,8
	BRSH _0x3E
	CBI  0x5,7
	MOV  R30,R17
	ANDI R30,LOW(0x80)
	MOV  R19,R30
	CPI  R19,0
	BRNE _0x41
	CBI  0x5,5
	RJMP _0x44
_0x41:
	SBI  0x5,5
_0x44:
	LSL  R17
	SBI  0x5,7
	nop
	nop
	SUBI R16,-1
	RJMP _0x3D
_0x3E:
	CBI  0x5,7
	nop
	SBI  0x5,7
	nop
	LDI  R16,LOW(0)
_0x4E:
	CPI  R16,16
	BRSH _0x4F
	CBI  0x5,7
	LSL  R20
	ROL  R21
	LDI  R30,0
	SBIC 0x3,4
	LDI  R30,1
	LDI  R31,0
	__ORWRR 20,21,30,31
	SBI  0x5,7
	SUBI R16,-1
	RJMP _0x4E
_0x4F:
	SBI  0x5,0
	MOVW R30,R20
	CALL __LOADLOCR6
	RJMP _0x2060004
; .FEND
;#include "AT45DB_FLASH.h"
_SPI_Init:
; .FSTART _SPI_Init
	LDI  R30,LOW(8)
	OUT  0x5,R30
	LDI  R30,LOW(80)
	OUT  0x2C,R30
	IN   R30,0x2D
	ORI  R30,1
	OUT  0x2D,R30
	RET
; .FEND
_SendSPIByte:
; .FSTART _SendSPIByte
	ST   -Y,R26
;	byte -> Y+0
	LD   R30,Y
	OUT  0x2E,R30
_0x56:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ _0x56
	IN   R30,0x2E
	ST   Y,R30
	ADIW R28,1
	RET
; .FEND
_GetSPIByte:
; .FSTART _GetSPIByte
	LDI  R30,LOW(0)
	OUT  0x2E,R30
_0x59:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ _0x59
	IN   R30,0x2E
	RET
; .FEND
_GetDeviceID:
; .FSTART _GetDeviceID
	SBIW R28,6
	ST   -Y,R17
;	dev_id -> Y+1
;	lcnt -> R17
	CBI  0xE,2
	LDI  R26,LOW(159)
	RCALL _SendSPIByte
	LDI  R17,LOW(0)
_0x5F:
	CPI  R17,6
	BRSH _0x60
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _GetSPIByte
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x5F
_0x60:
	SBI  0xE,2
	LDD  R26,Y+1
	CPI  R26,LOW(0x1F)
	BRNE _0x64
	LDD  R26,Y+2
	CPI  R26,LOW(0x26)
	BREQ _0x65
_0x64:
	RJMP _0x63
_0x65:
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x2060004
_0x63:
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2060004
; .FEND
_Check_Flash_Busy:
; .FSTART _Check_Flash_Busy
	ST   -Y,R17
;	busy_flag -> R17
	CBI  0xE,2
	LDI  R26,LOW(215)
	RCALL _SendSPIByte
	LDI  R26,LOW(255)
	RCALL _SendSPIByte
	IN   R17,46
	SBI  0xE,2
	SBRS R17,7
	RJMP _0x6B
	LDI  R17,LOW(0)
	RJMP _0x6C
_0x6B:
	LDI  R17,LOW(1)
_0x6C:
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_SetPageBuffer1:
; .FSTART _SetPageBuffer1
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
;	pagenum -> Y+4
;	tmp -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL __LSLW2
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R30,Y+5
	ST   Y,R30
	ANDI R30,LOW(0x3F)
	ST   Y,R30
	LDD  R30,Y+4
	ANDI R30,LOW(0xFC)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	CBI  0xE,2
	LDI  R26,LOW(131)
	RCALL _SendSPIByte
	LD   R26,Y
	RCALL _SendSPIByte
	LDD  R26,Y+1
	RCALL _SendSPIByte
	LDD  R26,Y+2
	RCALL _SendSPIByte
	SBI  0xE,2
	ADIW R28,6
	RET
; .FEND
_PageRead:
; .FSTART _PageRead
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	pagenum -> Y+6
;	tmp -> Y+2
;	i -> R16,R17
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSLW2
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R30,Y+7
	STD  Y+2,R30
	ANDI R30,LOW(0x3F)
	STD  Y+2,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+3,R30
	LDI  R30,LOW(0)
	STD  Y+4,R30
	CBI  0xE,2
	LDI  R26,LOW(210)
	RCALL _SendSPIByte
	LDD  R26,Y+2
	RCALL _SendSPIByte
	LDD  R26,Y+3
	RCALL _SendSPIByte
	LDD  R26,Y+4
	CALL SUBOPT_0x1A
	LDI  R26,LOW(0)
	RCALL _SendSPIByte
	LDI  R26,LOW(0)
	CALL SUBOPT_0x1A
	__GETWRN 16,17,0
_0x74:
	__CPWRN 16,17,528
	BRSH _0x75
	MOVW R30,R16
	SUBI R30,LOW(-_Data_Buff)
	SBCI R31,HIGH(-_Data_Buff)
	PUSH R31
	PUSH R30
	RCALL _GetSPIByte
	POP  R26
	POP  R27
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x74
_0x75:
	SBI  0xE,2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; .FEND
_Write_Buff:
; .FSTART _Write_Buff
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	Write_com -> Y+6
;	buffer_offset -> Y+4
;	byte_count -> Y+2
;	i -> R16,R17
	CBI  0xE,2
	LDI  R30,LOW(132)
	STD  Y+6,R30
	LDD  R26,Y+6
	CALL SUBOPT_0x1A
	LDD  R26,Y+5
	RCALL _SendSPIByte
	LDD  R30,Y+4
	MOV  R26,R30
	RCALL _SendSPIByte
	__GETWRS 16,17,4
_0x7F:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x80
	LDI  R26,LOW(_Data_Buff)
	LDI  R27,HIGH(_Data_Buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _SendSPIByte
	__ADDWRN 16,17,1
	RJMP _0x7F
_0x80:
	SBI  0xE,2
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2060004:
	ADIW R28,7
	RET
; .FEND
_GET_USR_INFO_DATA:
; .FSTART _GET_USR_INFO_DATA
	ST   -Y,R27
	ST   -Y,R26
;	usrcnt -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _PageRead
_0x83:
	RCALL _Check_Flash_Busy
	CPI  R30,0
	BRNE _0x83
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	LD   R30,Y
	LDD  R31,Y+1
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x89
	LDI  R30,LOW(_GRADE_INFO)
	LDI  R31,HIGH(_GRADE_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(90)
	RJMP _0x4BB
_0x89:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x8A
	LDI  R30,LOW(_SOL_INFO)
	LDI  R31,HIGH(_SOL_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(432)
	LDI  R27,HIGH(432)
	RJMP _0x4BC
_0x8A:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x8B
	LDI  R30,LOW(_PACKER_INFO)
	LDI  R31,HIGH(_PACKER_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(36)
	RJMP _0x4BB
_0x8B:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x8C
	LDI  R30,LOW(_LDCELL_INFO)
	LDI  R31,HIGH(_LDCELL_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(30)
	RJMP _0x4BB
_0x8C:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x8D
	LDI  R30,LOW(_MEASURE_INFO)
	LDI  R31,HIGH(_MEASURE_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(12)
	RJMP _0x4BB
_0x8D:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x8E
	LDI  R30,LOW(_PRT_INFO)
	LDI  R31,HIGH(_PRT_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(18)
	RJMP _0x4BB
_0x8E:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x8F
	LDI  R30,LOW(_SYS_INFO)
	LDI  R31,HIGH(_SYS_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(18)
	RJMP _0x4BB
_0x8F:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x90
	LDI  R30,LOW(_Marking_Version)
	LDI  R31,HIGH(_Marking_Version)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(1)
	RJMP _0x4BB
_0x90:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x88
	LDI  R30,LOW(_ABN_INFO)
	LDI  R31,HIGH(_ABN_INFO)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(2)
_0x4BB:
	LDI  R27,0
_0x4BC:
	CALL _memcpy
_0x88:
	RJMP _0x2060003
; .FEND
_PUT_USR_INFO_DATA:
; .FSTART _PUT_USR_INFO_DATA
	ST   -Y,R27
	ST   -Y,R26
;	usrcnt -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x95
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_GRADE_INFO)
	LDI  R31,HIGH(_GRADE_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(90)
	RJMP _0x4BD
_0x95:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x96
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_SOL_INFO)
	LDI  R31,HIGH(_SOL_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(432)
	LDI  R27,HIGH(432)
	RJMP _0x4BE
_0x96:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x97
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_PACKER_INFO)
	LDI  R31,HIGH(_PACKER_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(36)
	RJMP _0x4BD
_0x97:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x98
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_LDCELL_INFO)
	LDI  R31,HIGH(_LDCELL_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(30)
	RJMP _0x4BD
_0x98:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x99
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_MEASURE_INFO)
	LDI  R31,HIGH(_MEASURE_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(12)
	RJMP _0x4BD
_0x99:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x9A
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_PRT_INFO)
	LDI  R31,HIGH(_PRT_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(18)
	RJMP _0x4BD
_0x9A:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x9B
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_SYS_INFO)
	LDI  R31,HIGH(_SYS_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(18)
	RJMP _0x4BD
_0x9B:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x9C
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_Marking_Version)
	LDI  R31,HIGH(_Marking_Version)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _0x4BD
_0x9C:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x94
	CALL SUBOPT_0x1C
	LDI  R30,LOW(_ABN_INFO)
	LDI  R31,HIGH(_ABN_INFO)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
_0x4BD:
	LDI  R27,0
_0x4BE:
	CALL _memcpy
_0x94:
	LDI  R30,LOW(132)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(528)
	LDI  R27,HIGH(528)
	RCALL _Write_Buff
_0x9E:
	RCALL _Check_Flash_Busy
	CPI  R30,0
	BRNE _0x9E
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _SetPageBuffer1
_0xA1:
	RCALL _Check_Flash_Busy
	CPI  R30,0
	BRNE _0xA1
	nop
	nop
	nop
_0x2060003:
	ADIW R28,2
	RET
; .FEND
;
;#define     AccelStartPos       5
;
;#define     Mark_M0             0x00
;#define     Mark_M1             0x80
;#define     Mark_M2             0x40
;#define     Mark_M3             0xC0
;#define     Mark_M4             0x20
;#define     Mark_M5             0xA0
;#define     Mark_M6             0x60
;#define     Mark_M7             0xE0
;
;void SolenoidRunning(void);
;void ConvertWeight(unsigned char);
;void CorrectionData(unsigned char);
;void SaveParameter(void);
;void WeightGrading(unsigned char);
;void ABN_CHECK(unsigned char);
;
;unsigned char A_TX_DATA[8], old_prttype[9];
;unsigned char led_toggle, StopCMD, MACHINE_STATE=0, Crack_Dot_Chk_Enable=1, weight_ad_cnt, zero_ad_cnt;

	.DSEG
;unsigned int old_Zero[6];
;unsigned int correct_data_end_pulse, voltData[6][20], off_Correction_Count=0, init_off_correction=25;
;unsigned int deAccelStartCount=5, accelStartCount=3, DeAccelDelay=0, DelayTimeCount=10;
;unsigned char timerstop = 0, deaccel_chk=0, accel_chk=0, SpeedAdjEnable=0, debugMode=0;
;unsigned char slidemotor_state;
;unsigned char ACD_DATA_BUF[150], acd_chk_pos;
;unsigned char slidemotor_state, accel_rdy=1, deaccel_rdy=0, PackerSharedEnable=9;
;unsigned char Marking_MOUT;
;unsigned char Marking_MOUT_SNG[8]={Mark_M0, Mark_M1, Mark_M2, Mark_M3, Mark_M4, Mark_M5, Mark_M6, Mark_M7};
;
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0041 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0042     //version 3.4.2
; 0000 0043     //슬라이드 모터 기동/정지 신호를 이용
; 0000 0044     //기동시 슬라이드 모터 High신호시 운전시작 accelate 보정시작
; 0000 0045     //                     low신호시  accelate보정 종료
; 0000 0046 
; 0000 0047     if(SpeedAdjEnable==1){
	LDS  R26,_SpeedAdjEnable
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xAC
; 0000 0048         //슬라이드 모터 OFF
; 0000 0049         if(PIND.0==1){
	SBIS 0x9,0
	RJMP _0xAD
; 0000 004A             if(slidemotor_state ==1){
	LDS  R26,_slidemotor_state
	CPI  R26,LOW(0x1)
	BRNE _0xAE
; 0000 004B                 if(accel_chk==1){
	LDS  R26,_accel_chk
	CPI  R26,LOW(0x1)
	BRNE _0xAF
; 0000 004C                     if(MACHINE_STATE==1){       //가속종료
	LDS  R26,_MACHINE_STATE
	CPI  R26,LOW(0x1)
	BRNE _0xB0
; 0000 004D                         if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0xB1
; 0000 004E                             UDR1 =0xA1;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(161)
	STS  206,R30
_0xB2:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xB2
; 0000 004F                         }
; 0000 0050 
; 0000 0051                         //Acclate Finish
; 0000 0052                         AccelStart = 0;
_0xB1:
	CALL SUBOPT_0x1D
; 0000 0053                         AccelStep = 0;
; 0000 0054                         AccelCount=accelStartCount;
; 0000 0055                         Sol_Correction_Count = 0;
; 0000 0056                         SpeedAdjEnable = 0;
	LDI  R30,LOW(0)
	STS  _SpeedAdjEnable,R30
; 0000 0057                         slidemotor_state = 0;
	STS  _slidemotor_state,R30
; 0000 0058                         accel_chk = 0;
	STS  _accel_chk,R30
; 0000 0059                         //deaccel_rdy = 1;
; 0000 005A                     }
; 0000 005B                 }
_0xB0:
; 0000 005C             }
_0xAF:
; 0000 005D         }
_0xAE:
; 0000 005E         //슬라이드모터ON
; 0000 005F         else if(PIND.0==0){
	RJMP _0xB5
_0xAD:
	SBIC 0x9,0
	RJMP _0xB6
; 0000 0060             if(slidemotor_state==0){
	LDS  R30,_slidemotor_state
	CPI  R30,0
	BRNE _0xB7
; 0000 0061                 if(MACHINE_STATE==0){  //가속시작
	LDS  R30,_MACHINE_STATE
	CPI  R30,0
	BRNE _0xB8
; 0000 0062                     if(accel_rdy==1){
	LDS  R26,_accel_rdy
	CPI  R26,LOW(0x1)
	BRNE _0xB9
; 0000 0063                         if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0xBA
; 0000 0064                             UDR1 =0xA0;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(160)
	STS  206,R30
_0xBB:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xBB
; 0000 0065                         }
; 0000 0066                         slidemotor_state = 1;
_0xBA:
	LDI  R30,LOW(1)
	STS  _slidemotor_state,R30
; 0000 0067                         accel_rdy = 0;
	CALL SUBOPT_0x1E
; 0000 0068                         accel_chk = 1;
	STS  _accel_chk,R30
; 0000 0069                         timerstop = 0;
	LDI  R30,LOW(0)
	STS  _timerstop,R30
; 0000 006A                         AccelCount =0;
	STS  _AccelCount,R30
	STS  _AccelCount+1,R30
; 0000 006B                         AccelStep = accelStartCount;
	LDS  R30,_accelStartCount
	STS  _AccelStep,R30
; 0000 006C                         MACHINE_STATE =1;
	LDI  R30,LOW(1)
	STS  _MACHINE_STATE,R30
; 0000 006D                         off_Correction_Count = init_off_correction;
	CALL SUBOPT_0x1F
	STS  _off_Correction_Count,R30
	STS  _off_Correction_Count+1,R31
; 0000 006E 
; 0000 006F                         Sol_Correction_Count=SYS_INFO.correction+AccelStartPos;
	CALL SUBOPT_0x20
; 0000 0070 
; 0000 0071                         AccelStart = 1;
	STS  _AccelStart,R30
; 0000 0072                         TimerMode = tmrSPEED;
	LDI  R30,LOW(2)
	STS  _TimerMode,R30
; 0000 0073                         OCR1AH=0x00;        OCR1AL=0x4E;        //5msec /1024 prescaler
	CALL SUBOPT_0x21
; 0000 0074                         TCCR1B = 0x05;
; 0000 0075                     }
; 0000 0076                 }
_0xB9:
; 0000 0077             }
_0xB8:
; 0000 0078         }
_0xB7:
; 0000 0079     }
_0xB6:
_0xB5:
; 0000 007A }
_0xAC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 007D {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 007E     //version 3.4.2
; 0000 007F     //정지시 슬라이드 모터 high 신호시 운전 시작 deaccelate보정시작
; 0000 0080     //       슬라이드 모터 low신호시 deaccelate 보정 종료
; 0000 0081     if(SpeedAdjEnable==1){
	LDS  R26,_SpeedAdjEnable
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xBE
; 0000 0082         //슬라이드 모터 OFF
; 0000 0083         if(PIND.1==1){
	SBIS 0x9,1
	RJMP _0xBF
; 0000 0084             if(slidemotor_state ==1){
	LDS  R26,_slidemotor_state
	CPI  R26,LOW(0x1)
	BRNE _0xC0
; 0000 0085                 if(MACHINE_STATE==0){                       //감속종료
	LDS  R30,_MACHINE_STATE
	CPI  R30,0
	BRNE _0xC1
; 0000 0086                     if(deaccel_chk==1){
	LDS  R26,_deaccel_chk
	CPI  R26,LOW(0x1)
	BRNE _0xC2
; 0000 0087                         if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0xC3
; 0000 0088                             UDR1 =0xB1;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(177)
	STS  206,R30
_0xC4:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xC4
; 0000 0089                         }
; 0000 008A                         DeAccelStart = 0;           //감속종료
_0xC3:
	CALL SUBOPT_0x22
; 0000 008B                         DeAccelStep = deAccelStartCount;
; 0000 008C                         DeAccelCount=0;
; 0000 008D 
; 0000 008E                         deaccel_chk = 0;
	LDI  R30,LOW(0)
	STS  _deaccel_chk,R30
; 0000 008F                         timerstop = 1;
	LDI  R30,LOW(1)
	STS  _timerstop,R30
; 0000 0090                         MACHINE_STATE = 0;
	LDI  R30,LOW(0)
	STS  _MACHINE_STATE,R30
; 0000 0091                         slidemotor_state = 0;
	STS  _slidemotor_state,R30
; 0000 0092 
; 0000 0093                         if(StopCMD==1){
	LDS  R26,_StopCMD
	CPI  R26,LOW(0x1)
	BRNE _0xC7
; 0000 0094                             plc_prt_value &= ~MACHINE_START;
	CALL SUBOPT_0x23
; 0000 0095                             PLC_CON = plc_prt_value;
	CALL SUBOPT_0x24
; 0000 0096                             led_buz_value &= ~LED_RUN_STOP;
; 0000 0097                             LED_BUZ = led_buz_value;
; 0000 0098                             StopCMD = 0;
	LDI  R30,LOW(0)
	STS  _StopCMD,R30
; 0000 0099                         }
; 0000 009A                     }
_0xC7:
; 0000 009B                 }
_0xC2:
; 0000 009C             }
_0xC1:
; 0000 009D         }
_0xC0:
; 0000 009E         //슬라이드모터ON
; 0000 009F         else if(PIND.1==0){
	RJMP _0xC8
_0xBF:
	SBIC 0x9,1
	RJMP _0xC9
; 0000 00A0             if(slidemotor_state==0){
	LDS  R30,_slidemotor_state
	CPI  R30,0
	BRNE _0xCA
; 0000 00A1                 if(MACHINE_STATE==1){       //감속시작
	LDS  R26,_MACHINE_STATE
	CPI  R26,LOW(0x1)
	BRNE _0xCB
; 0000 00A2                     if(deaccel_rdy==1){
	LDS  R26,_deaccel_rdy
	CPI  R26,LOW(0x1)
	BRNE _0xCC
; 0000 00A3                         if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0xCD
; 0000 00A4                             UDR1 =0xB0;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(176)
	STS  206,R30
_0xCE:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xCE
; 0000 00A5                         }
; 0000 00A6                         DeAccelDelay=0;
_0xCD:
	LDI  R30,LOW(0)
	STS  _DeAccelDelay,R30
	STS  _DeAccelDelay+1,R30
; 0000 00A7                         DeAccelCount=0;
	STS  _DeAccelCount,R30
	STS  _DeAccelCount+1,R30
; 0000 00A8                         DeAccelStep = deAccelStartCount;
	LDS  R30,_deAccelStartCount
	STS  _DeAccelStep,R30
; 0000 00A9                         off_Correction_Count=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
; 0000 00AA                         DeAccelStart = 1;
	LDI  R30,LOW(1)
	STS  _DeAccelStart,R30
; 0000 00AB                         MACHINE_STATE = 0;
	LDI  R30,LOW(0)
	STS  _MACHINE_STATE,R30
; 0000 00AC                         deaccel_rdy = 0;
	STS  _deaccel_rdy,R30
; 0000 00AD                         deaccel_chk =1;
	LDI  R30,LOW(1)
	STS  _deaccel_chk,R30
; 0000 00AE                         slidemotor_state = 1;
	STS  _slidemotor_state,R30
; 0000 00AF                     }
; 0000 00B0                 }
_0xCC:
; 0000 00B1             }
_0xCB:
; 0000 00B2         }
_0xCA:
; 0000 00B3     }
_0xC9:
_0xC8:
; 0000 00B4 }
_0xBE:
	RJMP _0x4E0
; .FEND
;
;/***********************************/
;/*         Event Start/Stop        */
;/***********************************/
;interrupt [EXT_INT5] void ext_int5_isr(void)
; 0000 00BA {
_ext_int5_isr:
; .FSTART _ext_int5_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00BB     //이벤트 신호가 입력되면, 정지 명령
; 0000 00BC     //이벤트 신호가 off되면, 기동 명령
; 0000 00BD     //version 3.4.2
; 0000 00BE     if(EVENT_SIGNAL==0){//정지
	SBIC 0xC,5
	RJMP _0xD1
; 0000 00BF         if(debugMode==1)
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0xD2
; 0000 00C0         {
; 0000 00C1             UDR1 =0x02;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(2)
	STS  206,R30
_0xD3:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xD3
; 0000 00C2             UDR1 =0x00;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(0)
	STS  206,R30
_0xD6:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xD6
; 0000 00C3             UDR1 =0x01;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(1)
	STS  206,R30
_0xD9:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xD9
; 0000 00C4             UDR1 =0xA3;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(163)
	STS  206,R30
_0xDC:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xDC
; 0000 00C5             UDR1 =0x03;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(3)
	STS  206,R30
_0xDF:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xDF
; 0000 00C6         }
; 0000 00C7         EVENT_ENABLE = 1;
_0xD2:
	CALL SUBOPT_0x26
; 0000 00C8         SpeedAdjEnable = 1;
; 0000 00C9 
; 0000 00CA         deaccel_rdy = 1;
	LDI  R30,LOW(1)
	STS  _deaccel_rdy,R30
; 0000 00CB     }
; 0000 00CC     else{//기동시작
	RJMP _0xE2
_0xD1:
; 0000 00CD         EVENT_ENABLE = 0;
	LDI  R30,LOW(0)
	STS  _EVENT_ENABLE,R30
; 0000 00CE         SpeedAdjEnable = 1;
	LDI  R30,LOW(1)
	STS  _SpeedAdjEnable,R30
; 0000 00CF         accel_rdy = 1;
	STS  _accel_rdy,R30
; 0000 00D0         led_buz_value |= LED_RUN_STOP;
	CALL SUBOPT_0x27
; 0000 00D1         LED_BUZ = led_buz_value;
; 0000 00D2 
; 0000 00D3         if(debugMode==1)
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0xE3
; 0000 00D4 		{
; 0000 00D5             UDR1 =0x02;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(2)
	STS  206,R30
_0xE4:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xE4
; 0000 00D6             UDR1 =0x00;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(0)
	STS  206,R30
_0xE7:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xE7
; 0000 00D7             UDR1 =0x01;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(1)
	STS  206,R30
_0xEA:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xEA
; 0000 00D8             UDR1 =0xA2;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(162)
	STS  206,R30
_0xED:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xED
; 0000 00D9             UDR1 =0x03;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(3)
	STS  206,R30
_0xF0:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0xF0
; 0000 00DA         }
; 0000 00DB         plc_prt_value &= ~EVENT_STOP;
_0xE3:
	LDS  R30,_plc_prt_value
	ANDI R30,0xFD
	CALL SUBOPT_0x28
; 0000 00DC         PLC_CON = plc_prt_value;
; 0000 00DD     }
_0xE2:
; 0000 00DE }
_0x4E0:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;/**************************************/
;/*         Encoder Z-Phase Signal     */
;/**************************************/
;// A상이 1이면 포워딩 상태
;// A상이 0이면 리워딩 상태
;interrupt [EXT_INT6] void ext_int6_isr(void)
; 0000 00E6 {
_ext_int6_isr:
; .FSTART _ext_int6_isr
	CALL SUBOPT_0x29
; 0000 00E7     unsigned char tmp_acd_data[150]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00E8                                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00E9                                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00EA                                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00EB                                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00EC                                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00ED                                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
; 0000 00EE                                      0,0,0,0,0,0,0,0,0,0};
; 0000 00EF 
; 0000 00F0     //Moving ACD Data bucket
; 0000 00F1     memcpy(&tmp_acd_data[0],&ACD_DATA_BUF[0],sizeof(ACD_DATA_BUF));
	SBIW R28,63
	SBIW R28,63
	SBIW R28,24
	LDI  R24,150
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xF3*2)
	LDI  R31,HIGH(_0xF3*2)
	CALL __INITLOCB
;	tmp_acd_data -> Y+0
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ACD_DATA_BUF)
	LDI  R31,HIGH(_ACD_DATA_BUF)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _memcpy
; 0000 00F2 
; 0000 00F3     //z상 상태표시를 위해 led on 한뒤, a상펄스가 100pulse정도에 후에 off
; 0000 00F4     //a상 상태 체크를 위한 대기시간
; 0000 00F5 
; 0000 00F6     //A상이 하이 레벨일때 포워딩
; 0000 00F7     //A상이 로우 레벨이면 백워딩
; 0000 00F8     //if(old_a_cnt != phase_a_cnt){
; 0000 00F9 
; 0000 00FA     //old_a_cnt = phase_a_cnt;
; 0000 00FB     //if(phase_a_cnt>2){
; 0000 00FC     if(PHASE_A==LEVEL_HI){
	SBIS 0xC,6
	RJMP _0xF4
; 0000 00FD         if(phase_z_cnt==0 ){                             //전원이 ON된후 처음 시작한 뒤, z펄스가 들어오면 클리어
	CALL SUBOPT_0x2A
	CALL __CPD10
	BRNE _0xF5
; 0000 00FE             phase_z_cnt = 1; phase_a_cnt =0;
	__GETD1N 0x1
	STS  _phase_z_cnt,R30
	STS  _phase_z_cnt+1,R31
	STS  _phase_z_cnt+2,R22
	STS  _phase_z_cnt+3,R23
	CALL SUBOPT_0x2B
; 0000 00FF             z_led_flag = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0100             led_buz_value |= LED_ENCODER_Z;                     //z상 엔코더 led ON
	LDS  R30,_led_buz_value
	ORI  R30,1
	STS  _led_buz_value,R30
; 0000 0101             if(modRunning == MEASURE_AD){
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xF6
; 0000 0102                 ScanEnable = 1;     max_scan_val = 0;
	LDI  R30,LOW(1)
	MOV  R9,R30
	LDI  R30,LOW(0)
	STS  _max_scan_val,R30
	STS  _max_scan_val+1,R30
; 0000 0103             }
; 0000 0104         }
_0xF6:
; 0000 0105         else if( phase_a_cnt >= SYS_INFO.z_encoder_interval && phase_z_cnt>=1){       //a상 카운터값이 엔코더 max 카운터 ...
	RJMP _0xF7
_0xF5:
	__GETW1MN _SYS_INFO,7
	CALL SUBOPT_0x2C
	CP   R26,R30
	CPC  R27,R31
	BRLO _0xF9
	CALL SUBOPT_0x2D
	BRGE _0xFA
_0xF9:
	RJMP _0xF8
_0xFA:
; 0000 0106             phase_a_cnt =0;                                     //a상 카운터 초기화
	CALL SUBOPT_0x2B
; 0000 0107             phase_z_cnt++;
	CALL SUBOPT_0x2E
; 0000 0108             z_led_flag = 1;                                     //z상 led on
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0109             led_buz_value |= LED_ENCODER_Z;                     //z상 엔코더 led ON
	RJMP _0x4BF
; 0000 010A         }
; 0000 010B         /*else if(phase_a_cnt < SYS_INFO.z_encoder_min_interval && phase_z_cnt>=1){  //a상 카운터가 최소 100카운터 이상� ...
; 0000 010C             phase_a_cnt =0;
; 0000 010D             phase_z_cnt++;
; 0000 010E             z_led_flag = 1;
; 0000 010F             led_buz_value |= LED_ENCODER_Z;             //z상 엔코더 led ON
; 0000 0110             UDR1 =0xBB;            while(!(UCSR1A & 0x20));
; 0000 0111         }*/
; 0000 0112         else{
_0xF8:
; 0000 0113             phase_a_cnt = 0;
	CALL SUBOPT_0x2B
; 0000 0114             z_led_flag = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0115             phase_z_cnt++;
	CALL SUBOPT_0x2E
; 0000 0116             led_buz_value |= LED_ENCODER_Z;
_0x4BF:
	LDS  R30,_led_buz_value
	ORI  R30,1
	STS  _led_buz_value,R30
; 0000 0117         }
_0xF7:
; 0000 0118         //Moving ACD Data bucket
; 0000 0119         memcpy(&ACD_DATA_BUF[1],&tmp_acd_data[0],sizeof(ACD_DATA_BUF)-1);
	__POINTW1MN _ACD_DATA_BUF,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(149)
	LDI  R27,0
	CALL _memcpy
; 0000 011A         ACD_DATA_BUF[0]=0;
	LDI  R30,LOW(0)
	STS  _ACD_DATA_BUF,R30
; 0000 011B     }
; 0000 011C     LED_BUZ = led_buz_value;
_0xF4:
	CALL SUBOPT_0x2F
; 0000 011D }
	ADIW R28,63
	ADIW R28,63
	ADIW R28,24
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;/**************************************/
;/*         Encoder A-Phase Signal     */
;/**************************************/
;// Encoder A-Phase Signal :: Edge High check
;// A상이 1일 때 B상이 0이면 포워딩
;// A상이 1일 때 B상이 1이면 백워딩 상태 읽기
;interrupt [EXT_INT7] void ext_int7_isr(void)
; 0000 0126 {
_ext_int7_isr:
; .FSTART _ext_int7_isr
	CALL SUBOPT_0x29
; 0000 0127     unsigned int lcnt, datalen=0;
; 0000 0128     unsigned char cal_cnt=0;
; 0000 0129     unsigned char phaseB;
; 0000 012A     unsigned char crack_dot_ch;
; 0000 012B     unsigned int rawdata;
; 0000 012C     unsigned int chkdata,chkdata_new, cur_sol_num ;
; 0000 012D     //UDR1 = PHASE_B;            while(!(UCSR1A & 0x20));
; 0000 012E     //포워딩 상태일때
; 0000 012F     phaseB = PHASE_B;
	SBIW R28,9
	CALL __SAVELOCR6
;	lcnt -> R16,R17
;	datalen -> R18,R19
;	cal_cnt -> R21
;	phaseB -> R20
;	crack_dot_ch -> Y+14
;	rawdata -> Y+12
;	chkdata -> Y+10
;	chkdata_new -> Y+8
;	cur_sol_num -> Y+6
	__GETWRN 18,19,0
	LDI  R21,0
	LDI  R30,0
	SBIC 0xC,4
	LDI  R30,1
	MOV  R20,R30
; 0000 0130 
; 0000 0131     if(phaseB==CW_DIR){    //알찬 & 공장용 엔코더 :: 우방향  :: CW_DIR = 1
	CP   R5,R20
	BREQ PC+2
	RJMP _0xFC
; 0000 0132     //if(phaseB==0){      //상지 집란장 :: 좌방향 :: CW_DIR = 0
; 0000 0133         //매 60펄스마다 A상 LED ON, bucket count
; 0000 0134 
; 0000 0135         /*if(DeAccelStart==1){
; 0000 0136             UDR1 =DeAccelStep;            while(!(UCSR1A & 0x20));
; 0000 0137             UDR1 =0xAA;            while(!(UCSR1A & 0x20));
; 0000 0138         } */
; 0000 0139         switch(phase_a_cnt){
	CALL SUBOPT_0x30
; 0000 013A             case 1 : case 61 : case 121 : case 181 : case 241 : case 301 :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x101
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0x102
_0x101:
	RJMP _0x103
_0x102:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x104
_0x103:
	RJMP _0x105
_0x104:
	CPI  R30,LOW(0xB5)
	LDI  R26,HIGH(0xB5)
	CPC  R31,R26
	BRNE _0x106
_0x105:
	RJMP _0x107
_0x106:
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BRNE _0x108
_0x107:
	RJMP _0x109
_0x108:
	CPI  R30,LOW(0x12D)
	LDI  R26,HIGH(0x12D)
	CPC  R31,R26
	BRNE _0xFF
_0x109:
; 0000 013B                 MovingBucket();
	CALL _MovingBucket
; 0000 013C                 MaskingBucket();
	CALL _MaskingBucket
; 0000 013D                 CHK_ABN = LEVEL_LO;
	LDI  R30,LOW(0)
	STS  _CHK_ABN,R30
; 0000 013E                 dotValue = 0;
	CLR  R11
; 0000 013F                 // Insert ABN 2020-11-26  [Check Signal] 버켓 위치 리셋
; 0000 0140                 if(phase_a_cnt == 1)
	CALL SUBOPT_0x2C
	SBIW R26,1
	BRNE _0x10B
; 0000 0141                 {
; 0000 0142                     abn_phase_a = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x4C0
; 0000 0143                 }
; 0000 0144                 else if(phase_a_cnt == 61)
_0x10B:
	CALL SUBOPT_0x2C
	SBIW R26,61
	BRNE _0x10D
; 0000 0145                 {
; 0000 0146                     abn_phase_a = 61;
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	RJMP _0x4C0
; 0000 0147                 }
; 0000 0148                 else if(phase_a_cnt == 121)
_0x10D:
	CALL SUBOPT_0x2C
	CPI  R26,LOW(0x79)
	LDI  R30,HIGH(0x79)
	CPC  R27,R30
	BRNE _0x10F
; 0000 0149                 {
; 0000 014A                     abn_phase_a = 121;
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	RJMP _0x4C0
; 0000 014B                 }
; 0000 014C                 else if(phase_a_cnt == 181)
_0x10F:
	CALL SUBOPT_0x2C
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRNE _0x111
; 0000 014D                 {
; 0000 014E                     abn_phase_a = 181;
	LDI  R30,LOW(181)
	LDI  R31,HIGH(181)
	RJMP _0x4C0
; 0000 014F                 }
; 0000 0150                 else if(phase_a_cnt == 241)
_0x111:
	CALL SUBOPT_0x2C
	CPI  R26,LOW(0xF1)
	LDI  R30,HIGH(0xF1)
	CPC  R27,R30
	BRNE _0x113
; 0000 0151                 {
; 0000 0152                     abn_phase_a = 241;
	LDI  R30,LOW(241)
	LDI  R31,HIGH(241)
	RJMP _0x4C0
; 0000 0153                 }
; 0000 0154                 else if(phase_a_cnt == 301)
_0x113:
	CALL SUBOPT_0x2C
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRNE _0x115
; 0000 0155                 {
; 0000 0156                     abn_phase_a = 301;
	LDI  R30,LOW(301)
	LDI  R31,HIGH(301)
_0x4C0:
	STS  _abn_phase_a,R30
	STS  _abn_phase_a+1,R31
; 0000 0157                 }
; 0000 0158         }
_0x115:
_0xFF:
; 0000 0159 
; 0000 015A         //A-Phase LED OFF
; 0000 015B         if((phase_a_cnt % SYS_INFO.bucket_ref_pulse_cnt)==30){
	__GETB1MN _SYS_INFO,11
	LDI  R31,0
	CALL SUBOPT_0x2C
	CALL __MODW21U
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0x116
; 0000 015C             if(a_led_flag ==1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x117
; 0000 015D                 a_led_flag = 0;
	CLR  R7
; 0000 015E                 led_buz_value &= ~LED_ENCODER_A;
	LDS  R30,_led_buz_value
	ANDI R30,0xFB
	STS  _led_buz_value,R30
; 0000 015F             }
; 0000 0160         }
_0x117:
; 0000 0161 
; 0000 0162          //InterLock OFF
; 0000 0163         if(InterLockON == 1){
_0x116:
	LDS  R26,_InterLockON
	CPI  R26,LOW(0x1)
	BRNE _0x118
; 0000 0164             InterLockCnt++;
	LDS  R30,_InterLockCnt
	SUBI R30,-LOW(1)
	STS  _InterLockCnt,R30
; 0000 0165             if(InterLockCnt > 10){
	LDS  R26,_InterLockCnt
	CPI  R26,LOW(0xB)
	BRLO _0x119
; 0000 0166                 InterLockON = 0;
	LDI  R30,LOW(0)
	STS  _InterLockON,R30
; 0000 0167                 InterLockCnt = 0;
	STS  _InterLockCnt,R30
; 0000 0168                 //plc_prt_value &= ~INTER_LOCK_ON;
; 0000 0169                 //PLC_CON = plc_prt_value;
; 0000 016A             }
; 0000 016B         }
_0x119:
; 0000 016C 
; 0000 016D         //장비 정지 신호 출력
; 0000 016E         //장비 정지 신호 출력후 PLC정지 신호 올때 까지 기동 유지
; 0000 016F         //이때부터 타이머을 이용 DeAcceltime 적용, 솔레노이드 동작 시간 조정
; 0000 0170         if(StopEnable==1 && phase_a_cnt == SYS_INFO.stopcount){
_0x118:
	LDS  R26,_StopEnable
	CPI  R26,LOW(0x1)
	BRNE _0x11B
	CALL SUBOPT_0x31
	BREQ _0x11C
_0x11B:
	RJMP _0x11A
_0x11C:
; 0000 0171             StopEnable = 0;
	LDI  R30,LOW(0)
	STS  _StopEnable,R30
; 0000 0172             plc_prt_value &= ~MACHINE_START;
	CALL SUBOPT_0x23
; 0000 0173             plc_prt_value |= EVENT_STOP;
	ORI  R30,2
	STS  _plc_prt_value,R30
; 0000 0174 
; 0000 0175             EVENT_ENABLE = 2;
	LDI  R30,LOW(2)
	STS  _EVENT_ENABLE,R30
; 0000 0176 
; 0000 0177             PLC_CON = plc_prt_value;
	LDS  R30,_plc_prt_value
	CALL SUBOPT_0x24
; 0000 0178 
; 0000 0179             led_buz_value &= ~LED_RUN_STOP;
; 0000 017A             LED_BUZ = led_buz_value;
; 0000 017B         }
; 0000 017C 
; 0000 017D         //이벤트 신호 입력시 정지
; 0000 017E         if(EVENT_ENABLE==1 && phase_a_cnt == SYS_INFO.stopcount){
_0x11A:
	LDS  R26,_EVENT_ENABLE
	CPI  R26,LOW(0x1)
	BRNE _0x11E
	CALL SUBOPT_0x31
	BREQ _0x11F
_0x11E:
	RJMP _0x11D
_0x11F:
; 0000 017F             plc_prt_value |= EVENT_STOP;
	LDS  R30,_plc_prt_value
	ORI  R30,2
	CALL SUBOPT_0x28
; 0000 0180             PLC_CON = plc_prt_value;
; 0000 0181 
; 0000 0182             EVENT_ENABLE = 2;
	LDI  R30,LOW(2)
	STS  _EVENT_ENABLE,R30
; 0000 0183             led_buz_value &= ~LED_RUN_STOP;
	CALL SUBOPT_0x32
; 0000 0184             LED_BUZ = led_buz_value;
; 0000 0185         }
; 0000 0186 
; 0000 0187         A_TX_DATA[0] = 0x02;
_0x11D:
	CALL SUBOPT_0x33
; 0000 0188         A_TX_DATA[1] = 0x00;
; 0000 0189         A_TX_DATA[2] = 0x04;
; 0000 018A         A_TX_DATA[3] = 0xE1;
; 0000 018B         A_TX_DATA[4] = 0x01;
; 0000 018C         A_TX_DATA[5] = phase_a_cnt >> 8 ;
; 0000 018D         A_TX_DATA[6] = phase_a_cnt;
; 0000 018E         A_TX_DATA[7] = 0x03;
; 0000 018F 
; 0000 0190         if(A_CNT_TX_HOLD==0 && TxEnable==0){
	LDS  R26,_A_CNT_TX_HOLD
	CPI  R26,LOW(0x0)
	BRNE _0x121
	LDS  R26,_TxEnable
	CPI  R26,LOW(0x0)
	BREQ _0x122
_0x121:
	RJMP _0x120
_0x122:
; 0000 0191             //memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
; 0000 0192             if(COMM_SET_Position!=phase_a_cnt){
	CALL SUBOPT_0x30
; 0000 0193                 //TxEnable = 1;   txcnt = 1;  TxLength = 8;   UDR1 = TxBuffer[0];
; 0000 0194             }
; 0000 0195         }
; 0000 0196 
; 0000 0197         switch(modRunning){
_0x120:
	MOV  R30,R10
	LDI  R31,0
; 0000 0198             case ENCODER_CHK :
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x127
; 0000 0199                 //while(TxEnable);
; 0000 019A                 memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
	CALL SUBOPT_0x34
; 0000 019B                 //if(COMM_SET_Position!=phase_a_cnt){
; 0000 019C                     TxEnable = 1;   txcnt = 1;  TxLength = 8;   UDR1 = TxBuffer[0];
; 0000 019D                 //}
; 0000 019E                 break;
	RJMP _0x126
; 0000 019F             case MACHINE_STOP :
_0x127:
	SBIW R30,0
	BRNE _0x128
; 0000 01A0                 break;
	RJMP _0x126
; 0000 01A1             case NORMAL_RUN :
_0x128:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x129
; 0000 01A2                 // Insert ABN 2020-11-26  [Check Signal]
; 0000 01A3                 if(ABN_PORT == LEVEL_HI && CHK_ABN == LEVEL_LO )
	LDS  R30,45056
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x12B
	LDS  R26,_CHK_ABN
	CPI  R26,LOW(0x0)
	BREQ _0x12C
_0x12B:
	RJMP _0x12A
_0x12C:
; 0000 01A4                 {
; 0000 01A5                     GRADE_DATA.abn_S_Count = phase_a_cnt;
	__POINTW2MN _GRADE_DATA,188
	CALL SUBOPT_0x35
; 0000 01A6                     CHK_ABN = LEVEL_HI;
	LDI  R30,LOW(1)
	STS  _CHK_ABN,R30
; 0000 01A7                     led_buz_value |= LED_EVENT1;
	LDS  R30,_led_buz_value
	ORI  R30,8
	STS  _led_buz_value,R30
; 0000 01A8                 }
; 0000 01A9                 else if(ABN_PORT == LEVEL_HI)
	RJMP _0x12D
_0x12A:
	LDS  R30,45056
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x12E
; 0000 01AA                 {
; 0000 01AB                     if((MEASURE_INFO.abnCheckSTime + abn_phase_a) <= phase_a_cnt && (MEASURE_INFO.abnCheckETime + abn_ph ...
	__GETW1MN _MEASURE_INFO,8
	CALL SUBOPT_0x36
	BRLO _0x130
	CALL SUBOPT_0x37
	CALL SUBOPT_0x36
	BRLO _0x131
_0x130:
	RJMP _0x12F
_0x131:
; 0000 01AC                     {
; 0000 01AD                         dotValue++;
	INC  R11
; 0000 01AE                     }
; 0000 01AF                     GRADE_DATA.abn_E_Count = phase_a_cnt;
_0x12F:
	__POINTW2MN _GRADE_DATA,192
	CALL SUBOPT_0x35
; 0000 01B0                 }
; 0000 01B1                 else if(ABN_PORT == LEVEL_LO)
	RJMP _0x132
_0x12E:
	LDS  R30,45056
	ANDI R30,LOW(0x1)
	BRNE _0x133
; 0000 01B2                 {
; 0000 01B3                     led_buz_value &= ~LED_EVENT1;
	LDS  R30,_led_buz_value
	ANDI R30,0XF7
	CALL SUBOPT_0x38
; 0000 01B4                     LED_BUZ = led_buz_value;
; 0000 01B5                 }
; 0000 01B6 
; 0000 01B7                 // Insert ABN 2020-11-26  [Check ABN Bucket]
; 0000 01B8                 if(phase_a_cnt == (MEASURE_INFO.abnCheckETime + abn_phase_a) && dotValue > 0)
_0x133:
_0x132:
_0x12D:
	CALL SUBOPT_0x37
	LDS  R26,_abn_phase_a
	LDS  R27,_abn_phase_a+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x2C
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x135
	LDI  R30,LOW(0)
	CP   R30,R11
	BRLO _0x136
_0x135:
	RJMP _0x134
_0x136:
; 0000 01B9                 {
; 0000 01BA                      chkdata = (BucketData[ABN_INFO.AbnBucketNum] >> 8) &0x000F;
	CALL SUBOPT_0x39
	CALL __GETW1P
	MOV  R30,R31
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 01BB                      chkdata = chkdata - 1;
	SBIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 01BC                      //GRADE_DATA.gNumber[g_CRACK] = BucketData[ABN_INFO.AbnBucketNum];
; 0000 01BD                      if( chkdata < MAX_GRADE)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,9
	BRLO PC+2
	RJMP _0x137
; 0000 01BE                      {
; 0000 01BF                         GRADE_DATA.gNumber[chkdata]--;    //Minus at the same Grade number as the current ABN
	__POINTW2MN _GRADE_DATA,48
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
; 0000 01C0                         GRADE_DATA.gNumber[g_ABN]++;      // Plus in the current ABN number
	__POINTW2MN _GRADE_DATA,84
	CALL SUBOPT_0x3C
; 0000 01C1                         GRADE_DATA.gWeight[chkdata] = GRADE_DATA.gWeight[chkdata] - BucketData_Wight[ABN_INFO.AbnBucketN ...
	__POINTW2MN _GRADE_DATA,88
	CALL SUBOPT_0x3A
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__POINTW2MN _GRADE_DATA,88
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3E
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __SWAPD12
	CALL __SUBD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 01C2                         GRADE_DATA.gWeight[g_ABN] += BucketData_Wight[ABN_INFO.AbnBucketNum+2]; //  Plus in the current  ...
	CALL SUBOPT_0x3E
	__GETD2MN _GRADE_DATA,124
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1MN _GRADE_DATA,124
; 0000 01C3                         Old_Value = BucketData[ABN_INFO.AbnBucketNum];
	CALL SUBOPT_0x39
	CALL __GETW1P
	STS  _Old_Value,R30
	STS  _Old_Value+1,R31
; 0000 01C4 
; 0000 01C5                         if(GRADE_INFO[chkdata].prttype!=PRT_TYPE_NO)      //ABD검출시 마킹기 차감
	CALL SUBOPT_0x3F
	__ADDW1MN _GRADE_INFO,5
	LD   R30,Z
	CPI  R30,0
	BREQ _0x138
; 0000 01C6                         {
; 0000 01C7                             if(GRADE_INFO[chkdata].prtOutCount<GRADE_INFO[chkdata].prtSetCount || GRADE_INFO[chkdata].pr ...
	CALL SUBOPT_0x3F
	MOVW R0,R30
	MOVW R26,R30
	__ADDW1MN _GRADE_INFO,8
	LD   R23,Z
	LDD  R24,Z+1
	__ADDW2MN _GRADE_INFO,6
	CALL __GETW1P
	CP   R23,R30
	CPC  R24,R31
	BRLT _0x13A
	MOVW R30,R0
	__ADDW1MN _GRADE_INFO,6
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x139
_0x13A:
; 0000 01C8                              {
; 0000 01C9                                 GRADE_INFO[chkdata].prtOutCount--;
	CALL SUBOPT_0x3F
	__ADDW1MN _GRADE_INFO,8
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 01CA                                 GRADE_DATA.pNumber[chkdata]--;
	__POINTW2MN _GRADE_DATA,128
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
; 0000 01CB                              }
; 0000 01CC                         }
_0x139:
; 0000 01CD                         for(lcnt = ABN_INFO.AbnBucketNum-1; lcnt > 0 ; lcnt--)  //ABN버켓 번호 까지의 데이터 재배열
_0x138:
	LDS  R30,_ABN_INFO
	LDS  R31,_ABN_INFO+1
	SBIW R30,1
	MOVW R16,R30
_0x13D:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x13E
; 0000 01CE                         {
; 0000 01CF                             chkdata_new =((BucketData[lcnt] >> 8)&0x000F);
	CALL SUBOPT_0x40
	CALL __GETW1P
	MOV  R30,R31
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01D0                             chkdata_new = chkdata_new -1;
	SBIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01D1 							if(chkdata_new == chkdata)
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x13F
; 0000 01D2                             {
; 0000 01D3                                 New_Value = BucketData[lcnt];
	CALL SUBOPT_0x40
	CALL __GETW1P
	STS  _New_Value,R30
	STS  _New_Value+1,R31
; 0000 01D4                                 BucketData[lcnt] = Old_Value;
	CALL SUBOPT_0x41
	LDS  R26,_Old_Value
	LDS  R27,_Old_Value+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 01D5                                 Old_Value =  New_Value;
	LDS  R30,_New_Value
	LDS  R31,_New_Value+1
	STS  _Old_Value,R30
	STS  _Old_Value+1,R31
; 0000 01D6                            }
; 0000 01D7                         }
_0x13F:
	__SUBWRN 16,17,1
	RJMP _0x13D
_0x13E:
; 0000 01D8                         BucketData[ABN_INFO.AbnBucketNum] = 0;  // 베켓데이터에서 솔레노이드 취소
	CALL SUBOPT_0x39
	CALL SUBOPT_0x42
; 0000 01D9                      }
; 0000 01DA                 }
_0x137:
; 0000 01DB 
; 0000 01DC                 //매 펄스마다 체크하여 영점 위치에서 AD체크, 중량체크
; 0000 01DD                 //                     중량체크 이후에 분류, 통신
; 0000 01DE                 //
; 0000 01DF 
; 0000 01E0                 //중량측정시작-3.3.4
; 0000 01E1                 if(MEASURE_INFO.ad_start_pulse <= phase_a_cnt&& phase_a_cnt < weight_ad_end_pulse ){
_0x134:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x43
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x141
	LDS  R30,_weight_ad_end_pulse
	LDS  R31,_weight_ad_end_pulse+1
	CALL SUBOPT_0x44
	BRLO _0x142
_0x141:
	RJMP _0x140
_0x142:
; 0000 01E2                     //중량 측정 시작 펄스보다 같거나 크고 측정 종료 펄스보다 작으면
; 0000 01E3                     //중량 측정 || 1pulse 6channel
; 0000 01E4                     for(lcnt=0;lcnt<MAX_LDCELL;lcnt++){
	__GETWRN 16,17,0
_0x144:
	__CPWRN 16,17,6
	BRSH _0x145
; 0000 01E5                         rawdata = RD_ADC(lcnt);
	MOV  R26,R16
	CALL _RD_ADC
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 01E6                         voltData[lcnt][weight_ad_cnt] = ((long)rawdata*763)/10000;
	__MULBNWRU 16,17,40
	SUBI R30,LOW(-_voltData)
	SBCI R31,HIGH(-_voltData)
	MOVW R26,R30
	LDS  R30,_weight_ad_cnt
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x45
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 01E7                     }
	__ADDWRN 16,17,1
	RJMP _0x144
_0x145:
; 0000 01E8                     weight_ad_cnt++;
	LDS  R30,_weight_ad_cnt
	SUBI R30,-LOW(1)
	STS  _weight_ad_cnt,R30
; 0000 01E9                 }
; 0000 01EA                 else if(weight_ad_end_pulse <= phase_a_cnt && phase_a_cnt < correct_data_end_pulse){
	RJMP _0x146
_0x140:
	CALL SUBOPT_0x30
	LDS  R26,_weight_ad_end_pulse
	LDS  R27,_weight_ad_end_pulse+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x148
	LDS  R30,_correct_data_end_pulse
	LDS  R31,_correct_data_end_pulse+1
	CALL SUBOPT_0x44
	BRLO _0x149
_0x148:
	RJMP _0x147
_0x149:
; 0000 01EB                     //중량측정 구간의 raw데이터를 평균값, 최대, 최소값에 의해 보정
; 0000 01EC                     cal_cnt = phase_a_cnt - weight_ad_end_pulse;
	LDS  R26,_weight_ad_end_pulse
	CALL SUBOPT_0x46
; 0000 01ED                     CorrectionData(cal_cnt);
	RCALL _CorrectionData
; 0000 01EE                     if(cal_cnt>=5) weight_ad_cnt=0;
	CPI  R21,5
	BRLO _0x14A
	LDI  R30,LOW(0)
	STS  _weight_ad_cnt,R30
; 0000 01EF                 }
_0x14A:
; 0000 01F0                 else if(ConvertPosition <=phase_a_cnt && phase_a_cnt < convert_end_pulse){
	RJMP _0x14B
_0x147:
	CALL SUBOPT_0x30
	LDS  R26,_ConvertPosition
	LDS  R27,_ConvertPosition+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x14D
	LDS  R30,_convert_end_pulse
	LDS  R31,_convert_end_pulse+1
	CALL SUBOPT_0x44
	BRLO _0x14E
_0x14D:
	RJMP _0x14C
_0x14E:
; 0000 01F1                     //측정된 데이터를 무게값으로 환산
; 0000 01F2                     cal_cnt = phase_a_cnt - ConvertPosition;
	LDS  R26,_ConvertPosition
	CALL SUBOPT_0x46
; 0000 01F3                     /*
; 0000 01F4                     //UDR1 =cal_cnt;            while(!(UCSR1A & 0x20));
; 0000 01F5                     //UDR1 =zero_value[cal_cnt]>>8;            while(!(UCSR1A & 0x20));
; 0000 01F6                     //UDR1 =zero_value[cal_cnt];            while(!(UCSR1A & 0x20));
; 0000 01F7                     //UDR1 =0xCC;            while(!(UCSR1A & 0x20));
; 0000 01F8 
; 0000 01F9                     if(cal_cnt>=5) {
; 0000 01FA                         zero_ad_cnt=0;
; 0000 01FB                         UDR1 =0xCF;            while(!(UCSR1A & 0x20));
; 0000 01FC                     }
; 0000 01FD                     */
; 0000 01FE                     ConvertWeight(cal_cnt);
	RCALL _ConvertWeight
; 0000 01FF                 }
; 0000 0200                 //영점 측정 시작
; 0000 0201                 if(MEASURE_INFO.zeroposition <= phase_a_cnt && phase_a_cnt < zero_ad_end_pulse){
_0x14C:
_0x14B:
_0x146:
	__GETW2MN _MEASURE_INFO,4
	CALL SUBOPT_0x30
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x150
	LDS  R30,_zero_ad_end_pulse
	LDS  R31,_zero_ad_end_pulse+1
	CALL SUBOPT_0x44
	BRLO _0x151
_0x150:
	RJMP _0x14F
_0x151:
; 0000 0202                     //영점 측정 시작 펄스보다 같거나 크고 측정 종료 펄스보다 작으면
; 0000 0203                     //영점 중량 측정 || 1pulse 6channel
; 0000 0204                     for(lcnt=0;lcnt<MAX_LDCELL;lcnt++){
	__GETWRN 16,17,0
_0x153:
	__CPWRN 16,17,6
	BRSH _0x154
; 0000 0205                         zero_measure_value[lcnt] += (long)RD_ADC(lcnt);
	MOVW R30,R16
	LDI  R26,LOW(_zero_measure_value)
	LDI  R27,HIGH(_zero_measure_value)
	CALL SUBOPT_0x47
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R26,R16
	CALL _RD_ADC
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0206                     }
	__ADDWRN 16,17,1
	RJMP _0x153
_0x154:
; 0000 0207                     zero_ad_cnt++;
	LDS  R30,_zero_ad_cnt
	SUBI R30,-LOW(1)
	RJMP _0x4C1
; 0000 0208 
; 0000 0209                 }
; 0000 020A                 else if(zero_ad_end_pulse <= phase_a_cnt && phase_a_cnt < zero_cal_end_pulse){
_0x14F:
	CALL SUBOPT_0x30
	LDS  R26,_zero_ad_end_pulse
	LDS  R27,_zero_ad_end_pulse+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x157
	LDS  R30,_zero_cal_end_pulse
	LDS  R31,_zero_cal_end_pulse+1
	CALL SUBOPT_0x44
	BRLO _0x158
_0x157:
	RJMP _0x156
_0x158:
; 0000 020B                     //영점 측정 종료 펄스보다 같거나 크고 측정 종료 펄스에서 6펄스 더한 값보다 작으면
; 0000 020C                     //영점 연산 || 1pulse 1channel average calculate
; 0000 020D                     cal_cnt = phase_a_cnt - zero_ad_end_pulse;
	LDS  R26,_zero_ad_end_pulse
	LDS  R30,_phase_a_cnt
	SUB  R30,R26
	MOV  R21,R30
; 0000 020E                     //평균
; 0000 020F                     //zero_measure_value[cal_cnt] /= ZeroMeasurePulse;
; 0000 0210                     zero_measure_value[cal_cnt] /= zero_ad_cnt;
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_zero_ad_cnt
	LDI  R31,0
	CALL SUBOPT_0x49
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0000 0211                     //Digit to Voltage
; 0000 0212                     zero_value[cal_cnt] = (zero_measure_value[cal_cnt]* 763)/10000;
	MOV  R30,R21
	CALL SUBOPT_0x4A
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0213                     zero_measure_value[cal_cnt] = 0;
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4D
; 0000 0214                     //UDR1 =zero_value[cal_cnt]>>8;            while(!(UCSR1A & 0x20));
; 0000 0215                     //UDR1 =zero_value[cal_cnt];            while(!(UCSR1A & 0x20));
; 0000 0216                     //UDR1 =0xEE;            while(!(UCSR1A & 0x20));
; 0000 0217 
; 0000 0218                     if(cal_cnt>=5) {
	CPI  R21,5
	BRLO _0x159
; 0000 0219                         zero_ad_cnt=0;
	LDI  R30,LOW(0)
_0x4C1:
	STS  _zero_ad_cnt,R30
; 0000 021A                         //UDR1 =0xEF;            while(!(UCSR1A & 0x20));
; 0000 021B                     }
; 0000 021C                 }
_0x159:
; 0000 021D 
; 0000 021E                 if(COMM_SET_Position==phase_a_cnt){
_0x156:
	CALL SUBOPT_0x30
	LDS  R26,_COMM_SET_Position
	LDS  R27,_COMM_SET_Position+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x15A
; 0000 021F                     //전송될 통신 데이터 셋팅 및 전송 시작 명령
; 0000 0220                     A_CNT_TX_HOLD=1;
	LDI  R30,LOW(1)
	STS  _A_CNT_TX_HOLD,R30
; 0000 0221                     if(debugMode==0){
	LDS  R30,_debugMode
	CPI  R30,0
	BRNE _0x15B
; 0000 0222                        COMM_TX_SET();
	CALL _COMM_TX_SET
; 0000 0223                     }
; 0000 0224                 }
_0x15B:
; 0000 0225 
; 0000 0226                 if(GradingPosition <= phase_a_cnt && phase_a_cnt < grading_end_pulse){
_0x15A:
	CALL SUBOPT_0x4E
	BRLO _0x15D
	CALL SUBOPT_0x4F
	BRLO _0x15E
_0x15D:
	RJMP _0x15C
_0x15E:
; 0000 0227                     cal_cnt = phase_a_cnt - GradingPosition;
	LDS  R26,_GradingPosition
	CALL SUBOPT_0x46
; 0000 0228                     WeightGrading(cal_cnt);
	RCALL _WeightGrading
; 0000 0229                 }
; 0000 022A 
; 0000 022B 
; 0000 022C                 //if(MEASURE_INFO.crackchecktime  <=phase_a_cnt && phase_a_cnt < crackchk_end_pulse){
; 0000 022D                 if(MEASURE_INFO.crackchecktime <=phase_a_cnt && phase_a_cnt < crackchk_end_pulse ){
_0x15C:
	__GETW2MN _MEASURE_INFO,6
	CALL SUBOPT_0x30
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x160
	LDS  R30,_crackchk_end_pulse
	LDS  R31,_crackchk_end_pulse+1
	CALL SUBOPT_0x44
	BRLO _0x161
_0x160:
	RJMP _0x15F
_0x161:
; 0000 022E                     if(Crack_Dot_Chk_Enable==1){//크랙디텍터, 오란검출기 신호 체크
	LDS  R26,_Crack_Dot_Chk_Enable
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x162
; 0000 022F                         crackValue = EDI_CH0;
	LDS  R12,40960
; 0000 0230                         //dotValue = EDI_CH1;
; 0000 0231 
; 0000 0232 
; 0000 0233 
; 0000 0234                         for(lcnt=0;lcnt<6;lcnt++){
	__GETWRN 16,17,0
_0x164:
	__CPWRN 16,17,6
	BRSH _0x165
; 0000 0235                             crack_dot_ch = 0x01 << lcnt;
	MOV  R30,R16
	CALL SUBOPT_0x50
; 0000 0236                             if((crackValue & crack_dot_ch)==crack_dot_ch){ //각 채널별 crack신호가 있으면
	LDD  R26,Y+14
	AND  R26,R12
	LDD  R30,Y+14
	CP   R30,R26
	BRNE _0x166
; 0000 0237                                 crackCHKCNT[lcnt]++;
	CALL SUBOPT_0x51
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0238                             }
; 0000 0239                             //오물란 신호 감지 일시중지
; 0000 023A                             /*if((dotValue & crack_dot_ch)==crack_dot_ch){ //각 채널별 crack신호가 있으면
; 0000 023B                                 dotCHKCNT[lcnt]++;
; 0000 023C                             }*/
; 0000 023D                             //dotCHKCNT[lcnt] = 0;
; 0000 023E                         }
_0x166:
	__ADDWRN 16,17,1
	RJMP _0x164
_0x165:
; 0000 023F 
; 0000 0240                         if(phase_a_cnt == (crackchk_end_pulse-1)){
	LDS  R30,_crackchk_end_pulse
	LDS  R31,_crackchk_end_pulse+1
	SBIW R30,1
	CALL SUBOPT_0x2C
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+2
	RJMP _0x167
; 0000 0241                             for(lcnt=0;lcnt<6;lcnt++){
	__GETWRN 16,17,0
_0x169:
	__CPWRN 16,17,6
	BRSH _0x16A
; 0000 0242                                 crack_dot_ch = 0x01 << lcnt;
	MOV  R30,R16
	CALL SUBOPT_0x50
; 0000 0243                                 if(debugMode==3){
; 0000 0244                                     //UDR1 =0xFC;            while(!(UCSR1A & 0x20));
; 0000 0245                                 }
; 0000 0246                                 //저가형 acd적용
; 0000 0247                                 if(crackCHKCNT[lcnt] > 10){
	CALL SUBOPT_0x51
	LD   R26,X
	CPI  R26,LOW(0xB)
	BRLO _0x16C
; 0000 0248                                     ACD_DATA_BUF[0] |= (0x01<<lcnt);
	MOV  R30,R16
	CALL SUBOPT_0x52
; 0000 0249                                     if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x16D
; 0000 024A                                         UDR1 =ACD_DATA_BUF[0];            while(!(UCSR1A & 0x20));
	LDS  R30,_ACD_DATA_BUF
	STS  206,R30
_0x16E:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x16E
; 0000 024B                                         UDR1 =0xFA;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(250)
	STS  206,R30
_0x171:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x171
; 0000 024C                                     }
; 0000 024D                                     crackCHKCNT[lcnt] = 0;
_0x16D:
	RJMP _0x4C2
; 0000 024E                                 }
; 0000 024F                                 else{
_0x16C:
; 0000 0250 
; 0000 0251                                     if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x175
; 0000 0252                                         UDR1 =crackCHKCNT[lcnt];            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x51
	LD   R30,X
	STS  206,R30
_0x176:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x176
; 0000 0253                                         UDR1 =0xFD;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(253)
	STS  206,R30
_0x179:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x179
; 0000 0254                                     }
; 0000 0255                                     crackCHKCNT[lcnt] = 0;
_0x175:
_0x4C2:
	LDI  R26,LOW(_crackCHKCNT)
	LDI  R27,HIGH(_crackCHKCNT)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0256                                 }
; 0000 0257                             }
	__ADDWRN 16,17,1
	RJMP _0x169
_0x16A:
; 0000 0258                         }
; 0000 0259                     }
_0x167:
; 0000 025A                 }
_0x162:
; 0000 025B 
; 0000 025C                 //매펄스마다 솔레노이드 동작 처리
; 0000 025D                 SolenoidRunning();
_0x15F:
	CALL _SolenoidRunning
; 0000 025E                 break;
	RJMP _0x126
; 0000 025F             case MEASURE_AD :
_0x129:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x17C
; 0000 0260                 if(ScanEnable==1 && phase_z_cnt>=1){
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x17E
	CALL SUBOPT_0x2D
	BRGE _0x17F
_0x17E:
	RJMP _0x17D
_0x17F:
; 0000 0261                     //UDR1 = 0xEA;     while(!(UCSR1A & 0x20));
; 0000 0262                     ad_full_scan[phase_a_cnt] = RD_ADC(scan_ad_ch);
	CALL SUBOPT_0x53
	PUSH R31
	PUSH R30
	MOV  R26,R14
	CALL _RD_ADC
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0263                     ad_full_scan[phase_a_cnt] = (long)ad_full_scan[phase_a_cnt]*763/10000;
	CALL SUBOPT_0x53
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0264 
; 0000 0265                     //ad_full_scan캔된 값의 최대값을 추출
; 0000 0266                     if(ad_full_scan[phase_a_cnt] > max_scan_val)   max_scan_val = ad_full_scan[phase_a_cnt];
	CALL SUBOPT_0x54
	CALL __GETW1P
	MOVW R26,R30
	LDS  R30,_max_scan_val
	LDS  R31,_max_scan_val+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x180
	CALL SUBOPT_0x54
	CALL __GETW1P
	STS  _max_scan_val,R30
	STS  _max_scan_val+1,R31
; 0000 0267 
; 0000 0268                     //크랙 데이터 삽입 :: 0000 0000 0000 0000
; 0000 0269                     //                    1000 0000 0000 0000 :: 크랙신호
; 0000 026A                     //                    0100 0000 0000 0000 :: 오물란 신호
; 0000 026B                     crack_dot_ch = 0x01 << scan_ad_ch;
_0x180:
	MOV  R30,R14
	CALL SUBOPT_0x50
; 0000 026C                     crackValue = EDI_CH0;
	LDS  R12,40960
; 0000 026D                     if((crackValue & crack_dot_ch) == crack_dot_ch){
	LDD  R26,Y+14
	AND  R26,R12
	LDD  R30,Y+14
	CP   R30,R26
	BRNE _0x181
; 0000 026E                         ACD_DATA_BUF[0] |= (0x01<<crack_dot_ch);
	CALL SUBOPT_0x52
; 0000 026F                         crackCHKCNT[lcnt] = 0;
	CALL SUBOPT_0x51
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0270                     }
; 0000 0271 
; 0000 0272                     if(((ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS]>>scan_ad_ch) & 0x01)==0x01){  ad_full_scan[phase_a_cnt] |= 0 ...
_0x181:
	CALL SUBOPT_0x56
	LDI  R27,0
	MOV  R30,R14
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x182
	CALL SUBOPT_0x54
	LD   R30,X+
	LD   R31,X+
	ORI  R31,HIGH(0x8000)
	ST   -X,R31
	ST   -X,R30
; 0000 0273 
; 0000 0274 
; 0000 0275 
; 0000 0276                     //dotValue = EDI_CH1;
; 0000 0277                     if((dotValue & crack_dot_ch) == crack_dot_ch){
_0x182:
	LDD  R26,Y+14
	AND  R26,R11
	LDD  R30,Y+14
	CP   R30,R26
	BRNE _0x183
; 0000 0278                         ad_full_scan[phase_a_cnt] |= 0x4000;
	CALL SUBOPT_0x54
	LD   R30,X+
	LD   R31,X+
	ORI  R31,HIGH(0x4000)
	ST   -X,R31
	ST   -X,R30
; 0000 0279                     }
; 0000 027A 
; 0000 027B 
; 0000 027C                     //최대값이 최소한 소란 중량이상의 값이면 로드셀에 계란이 탑재된것으로 인식하고 스캔 종료
; 0000 027D                     if(max_scan_val > MAX_SCAN_REF && ScanStopEnable==0) {
_0x183:
	LDS  R30,_MAX_SCAN_REF
	LDS  R31,_MAX_SCAN_REF+1
	LDS  R26,_max_scan_val
	LDS  R27,_max_scan_val+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x185
	TST  R13
	BREQ _0x186
_0x185:
	RJMP _0x184
_0x186:
; 0000 027E                         max_scan_cnt++;
	LDI  R26,LOW(_max_scan_cnt)
	LDI  R27,HIGH(_max_scan_cnt)
	CALL SUBOPT_0x57
; 0000 027F                         //UDR1 = max_scan_cnt;     while(!(UCSR1A & 0x20));
; 0000 0280                         //UDR1 = 0xED;     while(!(UCSR1A & 0x20));
; 0000 0281                         if(max_scan_cnt > 20){
	LDS  R26,_max_scan_cnt
	LDS  R27,_max_scan_cnt+1
	SBIW R26,21
	BRLO _0x187
; 0000 0282                             //UDR1 = 0xEE;     while(!(UCSR1A & 0x20));
; 0000 0283                             //ScanStopEnable=1;
; 0000 0284                             ScanStopEnable=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0285                             max_scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _max_scan_cnt,R30
	STS  _max_scan_cnt+1,R30
; 0000 0286                             cur_z_phase_cnt = phase_z_cnt;
	CALL SUBOPT_0x58
; 0000 0287                         }
; 0000 0288                     }
_0x187:
; 0000 0289 
; 0000 028A                     /*if(phase_z_cnt>10){
; 0000 028B                         MAX_SCAN_REF = 1000;
; 0000 028C                     }
; 0000 028D                     */
; 0000 028E                     //엔코더 a상펄스가 z인터벌보다 크거나 같고, 스캔 종료시점인경우 장치 정지
; 0000 028F                     //측정된 데이터 전송 시작
; 0000 0290                     if(ScanStopEnable==1){
_0x184:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x188
; 0000 0291                         //UDR1 = 0xEB;     while(!(UCSR1A & 0x20));
; 0000 0292                         //UDR1 = cur_z_phase_cnt;     while(!(UCSR1A & 0x20));
; 0000 0293                         //UDR1 = phase_z_cnt;     while(!(UCSR1A & 0x20));
; 0000 0294                         //if(phase_a_cnt>= SYS_INFO.z_encoder_interval || phase_z_cnt > 1){
; 0000 0295                         if(cur_z_phase_cnt < phase_z_cnt){
	CALL SUBOPT_0x59
	BRGE _0x189
; 0000 0296                         //if(phase_a_cnt==359){
; 0000 0297                             //UDR1 = 0xEB;     while(!(UCSR1A & 0x20));
; 0000 0298                             ScanStopEnable = 2;
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 0299                             cur_z_phase_cnt = phase_z_cnt;
	CALL SUBOPT_0x58
; 0000 029A                         }
; 0000 029B                     }
_0x189:
; 0000 029C                     else if(ScanStopEnable==2){
	RJMP _0x18A
_0x188:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x18B
; 0000 029D                         //UDR1 = 0xEC;     while(!(UCSR1A & 0x20));
; 0000 029E                         if(cur_z_phase_cnt < phase_z_cnt){
	CALL SUBOPT_0x59
	BRGE _0x18C
; 0000 029F                         //if(phase_a_cnt==359){
; 0000 02A0                             ScanEnable = 0;     modRunning = MACHINE_STOP;
	CLR  R9
	CLR  R10
; 0000 02A1                             ScanStopEnable = 0;
	CLR  R13
; 0000 02A2                             //datalen = sizeof(ad_full_scan);
; 0000 02A3                             datalen = sizeof(ad_full_scan);
	__GETWRN 18,19,1200
; 0000 02A4                             TxBuffer[0] = 0x02;
	LDI  R30,LOW(2)
	STS  _TxBuffer,R30
; 0000 02A5                             TxBuffer[1] = (datalen+2)>>8;             //실제데이터 이외 COMMAND 2byte 포함
	MOVW R30,R18
	ADIW R30,2
	CALL SUBOPT_0x5A
; 0000 02A6                             TxBuffer[2] = (datalen+2) & 0xFF;
	MOV  R30,R18
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x5B
; 0000 02A7                             TxBuffer[3] = 0x10;
; 0000 02A8                             TxBuffer[4] = 0x0A + scan_ad_ch;
	MOV  R30,R14
	SUBI R30,-LOW(10)
	CALL SUBOPT_0x5C
; 0000 02A9                             memcpy(&(TxBuffer[5]), &(ad_full_scan[0]), datalen);
	LDI  R30,LOW(_ad_full_scan)
	LDI  R31,HIGH(_ad_full_scan)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	CALL _memcpy
; 0000 02AA                             TxBuffer[5+datalen] = 0x03;
	MOVW R30,R18
	CALL SUBOPT_0x5D
; 0000 02AB                             TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0x5E
; 0000 02AC                             plc_prt_value &= ~MACHINE_START;
; 0000 02AD                             PLC_CON = plc_prt_value;
	CALL SUBOPT_0x24
; 0000 02AE                             led_buz_value &= ~LED_RUN_STOP;
; 0000 02AF                             LED_BUZ = led_buz_value;
; 0000 02B0                         }
; 0000 02B1                     }
_0x18C:
; 0000 02B2                     else{
	RJMP _0x18D
_0x18B:
; 0000 02B3                       if(phase_z_cnt > 50){
	LDS  R26,_phase_z_cnt
	LDS  R27,_phase_z_cnt+1
	LDS  R24,_phase_z_cnt+2
	LDS  R25,_phase_z_cnt+3
	__CPD2N 0x33
	BRLT _0x18E
; 0000 02B4                         ScanEnable = 0; modRunning = MACHINE_STOP;
	CLR  R9
	CLR  R10
; 0000 02B5                         TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 02B6                         TxBuffer[1] = 0x00;             //실제데이터 이외 COMMAND 2byte 포함
; 0000 02B7                         TxBuffer[2] = 0x02;
	CALL SUBOPT_0x5B
; 0000 02B8                         TxBuffer[3] = 0x10;
; 0000 02B9                         TxBuffer[4] = 0xFF;
	LDI  R30,LOW(255)
	CALL SUBOPT_0x60
; 0000 02BA                         TxBuffer[5] = 0x03;
; 0000 02BB                         TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0x5E
; 0000 02BC 
; 0000 02BD                         plc_prt_value &= ~MACHINE_START;
; 0000 02BE                         PLC_CON = plc_prt_value;
	CALL SUBOPT_0x24
; 0000 02BF                         led_buz_value &= ~LED_RUN_STOP;
; 0000 02C0                         LED_BUZ = led_buz_value;
; 0000 02C1                     }
; 0000 02C2                     else{
_0x18E:
; 0000 02C3                         //UDR1 = phase_z_cnt;     while(!(UCSR1A & 0x20));
; 0000 02C4                         //UDR1 = 0xEC;     while(!(UCSR1A & 0x20));
; 0000 02C5                     }
; 0000 02C6                     }
_0x18D:
_0x18A:
; 0000 02C7                 }
; 0000 02C8                 //if(UDR1 == 0xA5){
; 0000 02C9                 if(StopCMD==1){
_0x17D:
	LDS  R26,_StopCMD
	CPI  R26,LOW(0x1)
	BRNE _0x190
; 0000 02CA                     ScanEnable = 0; modRunning = MACHINE_STOP;
	CLR  R9
	CLR  R10
; 0000 02CB                     StopCMD = 0;
	LDI  R30,LOW(0)
	STS  _StopCMD,R30
; 0000 02CC                     /*TxBuffer[0] = 0x02;
; 0000 02CD                     TxBuffer[1] = 0x00;             //실제데이터 이외 COMMAND 2byte 포함
; 0000 02CE                     TxBuffer[2] = 0x02;
; 0000 02CF                     TxBuffer[3] = 0x10;
; 0000 02D0                     TxBuffer[4] = 0x05;
; 0000 02D1                     TxBuffer[5] = 0x03;
; 0000 02D2                     TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
; 0000 02D3                     */
; 0000 02D4                     plc_prt_value &= ~MACHINE_START;
	CALL SUBOPT_0x23
; 0000 02D5                     PLC_CON = plc_prt_value;
	STS  34816,R30
; 0000 02D6                 }
; 0000 02D7                 break;
_0x190:
	RJMP _0x126
; 0000 02D8             case SOLENOID_TEST :
_0x17C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x191
; 0000 02D9                 if(GradingPosition <= phase_a_cnt && phase_a_cnt < grading_end_pulse){
	CALL SUBOPT_0x4E
	BRLO _0x193
	CALL SUBOPT_0x4F
	BRLO _0x194
_0x193:
	RJMP _0x192
_0x194:
; 0000 02DA                     //등급 분류::240pulse
; 0000 02DB                     cal_cnt = phase_a_cnt - GradingPosition;
	LDS  R26,_GradingPosition
	CALL SUBOPT_0x46
; 0000 02DC                     WeightGrading(cal_cnt);
	RCALL _WeightGrading
; 0000 02DD                 }
; 0000 02DE 
; 0000 02DF                 //매펄스마다 솔레노이드 동작 처리
; 0000 02E0                 SolenoidRunning();
_0x192:
	CALL _SolenoidRunning
; 0000 02E1                 break;
; 0000 02E2             case EMERGENCY_STOP :
_0x191:
; 0000 02E3                 break;
; 0000 02E4         }
_0x126:
; 0000 02E5 
; 0000 02E6         //z상 LED가 on상태에서 100msec지연후 led off
; 0000 02E7         if(z_led_flag==1 && (phase_a_cnt>100)){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x197
	CALL SUBOPT_0x2C
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRSH _0x198
_0x197:
	RJMP _0x196
_0x198:
; 0000 02E8             z_led_flag = 0;
	CLR  R8
; 0000 02E9             led_buz_value &= ~LED_ENCODER_Z;
	LDS  R30,_led_buz_value
	ANDI R30,0xFE
	STS  _led_buz_value,R30
; 0000 02EA         }
; 0000 02EB         //old_a_cnt = phase_a_cnt;
; 0000 02EC         phase_a_cnt++;
_0x196:
	LDI  R26,LOW(_phase_a_cnt)
	LDI  R27,HIGH(_phase_a_cnt)
	CALL SUBOPT_0x57
; 0000 02ED 
; 0000 02EE         /*if(phase_a_cnt>360){
; 0000 02EF             phase_a_cnt=0;
; 0000 02F0             z_led_flag = 0;
; 0000 02F1             led_buz_value &= ~LED_ENCODER_Z;
; 0000 02F2         } */
; 0000 02F3 
; 0000 02F4         LED_BUZ = led_buz_value;
	CALL SUBOPT_0x2F
; 0000 02F5     }
; 0000 02F6     else{
	RJMP _0x199
_0xFC:
; 0000 02F7         //메인모터 역회전에 따른 엔코더 Reverse인 경우
; 0000 02F8         //A상 카운터를 빼줌.
; 0000 02F9 
; 0000 02FA         if(modRunning==ENCODER_CHK){
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x19A
; 0000 02FB             if(phase_a_cnt>0){
	CALL SUBOPT_0x2C
	CALL __CPW02
	BRSH _0x19B
; 0000 02FC                 phase_a_cnt--;
	LDI  R26,LOW(_phase_a_cnt)
	LDI  R27,HIGH(_phase_a_cnt)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 02FD             }
; 0000 02FE             else if(phase_a_cnt==0){
	RJMP _0x19C
_0x19B:
	CALL SUBOPT_0x30
	SBIW R30,0
	BRNE _0x19D
; 0000 02FF                 phase_a_cnt=359;
	LDI  R30,LOW(359)
	LDI  R31,HIGH(359)
	STS  _phase_a_cnt,R30
	STS  _phase_a_cnt+1,R31
; 0000 0300             }
; 0000 0301 
; 0000 0302             A_TX_DATA[0] = 0x02;
_0x19D:
_0x19C:
	CALL SUBOPT_0x33
; 0000 0303             A_TX_DATA[1] = 0x00;
; 0000 0304             A_TX_DATA[2] = 0x04;
; 0000 0305             A_TX_DATA[3] = 0xE1;
; 0000 0306             A_TX_DATA[4] = 0x01;
; 0000 0307             A_TX_DATA[5] = phase_a_cnt >> 8 ;
; 0000 0308             A_TX_DATA[6] = phase_a_cnt;
; 0000 0309             A_TX_DATA[7] = 0x03;
; 0000 030A 
; 0000 030B             memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
	CALL SUBOPT_0x34
; 0000 030C             //if(COMM_SET_Position!=phase_a_cnt){
; 0000 030D                 TxEnable = 1;   txcnt = 1;  TxLength = 8;   UDR1 = TxBuffer[0];
; 0000 030E             //}
; 0000 030F         }
; 0000 0310 
; 0000 0311     }
_0x19A:
_0x199:
; 0000 0312 }
	CALL __LOADLOCR6
	ADIW R28,15
	RJMP _0x4DE
; .FEND
;
;// USART0 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 0316 {
_usart1_rx_isr:
; .FSTART _usart1_rx_isr
	CALL SUBOPT_0x61
; 0000 0317     unsigned char rxd;
; 0000 0318 
; 0000 0319     rxd = UDR1;
	ST   -Y,R17
;	rxd -> R17
	LDS  R17,206
; 0000 031A 
; 0000 031B     switch(COM_MOD){
	LDS  R30,_COM_MOD
	LDI  R31,0
; 0000 031C         case COM_STX :
	SBIW R30,0
	BREQ PC+2
	RJMP _0x1A1
; 0000 031D             if(rxd==0x02){
	CPI  R17,2
	BRNE _0x1A2
; 0000 031E                 COM_MOD = COM_LEN;
	LDI  R30,LOW(1)
	STS  _COM_MOD,R30
; 0000 031F             }
; 0000 0320             else if(rxd==0xA5){
	RJMP _0x1A3
_0x1A2:
	CPI  R17,165
	BRNE _0x1A4
; 0000 0321                 //version 3.4.2
; 0000 0322                 //구동중 정지 명령 수신의 경우
; 0000 0323                 //    이벤트 발생으로 처리해서 정지하도록 하고,
; 0000 0324                 //    슬라이드모터가 기동후 정지되면 장비 기동 신호를 OFF
; 0000 0325                 //정지상태에서 정지명령 수신의 경우
; 0000 0326                 //    정지상태로 모든 플래그 셋팅하고,
; 0000 0327                 //    장비 기동 신호를 off
; 0000 0328                 if(MACHINE_STATE==1){
	LDS  R26,_MACHINE_STATE
	CPI  R26,LOW(0x1)
	BRNE _0x1A5
; 0000 0329                     //StopEnable = 1;
; 0000 032A                     EVENT_ENABLE = 1;
	CALL SUBOPT_0x26
; 0000 032B                     SpeedAdjEnable = 1;
; 0000 032C                     accel_rdy = 0;
	CALL SUBOPT_0x1E
; 0000 032D                     deaccel_rdy = 1;
	STS  _deaccel_rdy,R30
; 0000 032E                     StopCMD = 1;
	LDI  R30,LOW(1)
	STS  _StopCMD,R30
; 0000 032F                     if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0x1A6
; 0000 0330                        UDR1 =0xF2;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(242)
	STS  206,R30
_0x1A7:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1A7
; 0000 0331                     }
; 0000 0332                 }
_0x1A6:
; 0000 0333                 else if(MACHINE_STATE==0){
	RJMP _0x1AA
_0x1A5:
	LDS  R30,_MACHINE_STATE
	CPI  R30,0
	BRNE _0x1AB
; 0000 0334                     StopEnable = 0;
	LDI  R30,LOW(0)
	STS  _StopEnable,R30
; 0000 0335                     StopCMD = 0;
	STS  _StopCMD,R30
; 0000 0336                     plc_prt_value &= ~MACHINE_START;
	CALL SUBOPT_0x23
; 0000 0337                     plc_prt_value |= EVENT_STOP;
	ORI  R30,2
	STS  _plc_prt_value,R30
; 0000 0338                     PLC_CON = plc_prt_value;
	CALL SUBOPT_0x24
; 0000 0339                     led_buz_value &= ~LED_RUN_STOP;
; 0000 033A                     LED_BUZ = led_buz_value;
; 0000 033B                      if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0x1AC
; 0000 033C                         UDR1 =0xF3;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(243)
	STS  206,R30
_0x1AD:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1AD
; 0000 033D                      }
; 0000 033E                 }
_0x1AC:
; 0000 033F             }
_0x1AB:
_0x1AA:
; 0000 0340             break;
_0x1A4:
_0x1A3:
	RJMP _0x1A0
; 0000 0341         case COM_LEN :
_0x1A1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1B0
; 0000 0342             RxLength = rxd;        COM_MOD = COM_DAT;
	MOV  R30,R17
	LDI  R31,0
	STS  _RxLength,R30
	STS  _RxLength+1,R31
	LDI  R30,LOW(2)
	STS  _COM_MOD,R30
; 0000 0343             break;
	RJMP _0x1A0
; 0000 0344         case COM_DAT :
_0x1B0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1B1
; 0000 0345             RxBuffer[revcnt++] = rxd;
	LDI  R26,LOW(_revcnt)
	LDI  R27,HIGH(_revcnt)
	CALL SUBOPT_0x57
	SBIW R30,1
	SUBI R30,LOW(-_RxBuffer)
	SBCI R31,HIGH(-_RxBuffer)
	ST   Z,R17
; 0000 0346             if(RxLength<=revcnt){
	LDS  R30,_revcnt
	LDS  R31,_revcnt+1
	LDS  R26,_RxLength
	LDS  R27,_RxLength+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x1B2
; 0000 0347                 COM_MOD = COM_ETX;
	LDI  R30,LOW(3)
	STS  _COM_MOD,R30
; 0000 0348             }
; 0000 0349             break;
_0x1B2:
	RJMP _0x1A0
; 0000 034A         case COM_ETX :
_0x1B1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1A0
; 0000 034B             if(rxd==0x03){
	CPI  R17,3
	BRNE _0x1B4
; 0000 034C                 COM_MOD = COM_STX;
	LDI  R30,LOW(0)
	STS  _COM_MOD,R30
; 0000 034D                 revcnt=0;
	STS  _revcnt,R30
	STS  _revcnt+1,R30
; 0000 034E                 COM_REV_ENABLE = 1;
	LDI  R30,LOW(1)
	STS  _COM_REV_ENABLE,R30
; 0000 034F             }
; 0000 0350             break;
_0x1B4:
; 0000 0351     }
_0x1A0:
; 0000 0352 }
	LD   R17,Y+
	RJMP _0x4DF
; .FEND
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 0356 {
_usart1_tx_isr:
; .FSTART _usart1_tx_isr
	CALL SUBOPT_0x61
; 0000 0357     if(TxEnable){
	LDS  R30,_TxEnable
	CPI  R30,0
	BREQ _0x1B5
; 0000 0358         if(txcnt<TxLength){
	LDS  R30,_TxLength
	LDS  R31,_TxLength+1
	LDS  R26,_txcnt
	LDS  R27,_txcnt+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1B6
; 0000 0359             UDR1 = TxBuffer[txcnt++];
	LDI  R26,LOW(_txcnt)
	LDI  R27,HIGH(_txcnt)
	CALL SUBOPT_0x57
	SBIW R30,1
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	LD   R30,Z
	STS  206,R30
; 0000 035A             A_CNT_TX_HOLD = 1;
	LDI  R30,LOW(1)
	RJMP _0x4C3
; 0000 035B         }
; 0000 035C         else{
_0x1B6:
; 0000 035D             TxEnable = 0;   txcnt = 0;      A_CNT_TX_HOLD = 0;
	LDI  R30,LOW(0)
	STS  _TxEnable,R30
	STS  _txcnt,R30
	STS  _txcnt+1,R30
_0x4C3:
	STS  _A_CNT_TX_HOLD,R30
; 0000 035E         }
; 0000 035F     }
; 0000 0360 }
_0x1B5:
_0x4DF:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0364 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
; 0000 0365     // Reinitialize Timer 0 value
; 0000 0366     //TCNT0=0xF1;
; 0000 0367     // Place your code here
; 0000 0368 
; 0000 0369 }
	RETI
; .FEND
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 036D {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	CALL SUBOPT_0x29
; 0000 036E 
; 0000 036F     long avrtotal=0;
; 0000 0370     unsigned int readvalue=0;
; 0000 0371 
; 0000 0372     // Place your code here
; 0000 0373     TCNT1H = 0x00;
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	CALL SUBOPT_0x62
	ST   -Y,R17
	ST   -Y,R16
;	avrtotal -> Y+2
;	readvalue -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 0000 0374     TCNT1L = 0x00;
; 0000 0375 
; 0000 0376     switch(TimerMode){
	LDS  R30,_TimerMode
	CALL SUBOPT_0x63
; 0000 0377         case tmrADC :
	BREQ PC+2
	RJMP _0x1BB
; 0000 0378             readvalue = RD_ADC(reformCH);
	LDS  R26,_reformCH
	CALL _RD_ADC
	MOVW R16,R30
; 0000 0379             avrtotal = reformTotal + ((long)readvalue*763)/10000;                     //평균합계(reformTotal)와 현재값을 ...
	MOVW R26,R16
	CALL SUBOPT_0x45
	CALL SUBOPT_0x64
	CALL __ADDD12
	__PUTD1S 2
; 0000 037A             reformTotal -= (long)reform_ADC[adcnt];                       //평균합계에서 직전 평균값을 뺀다.
	CALL SUBOPT_0x65
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0x55
	CALL SUBOPT_0x66
; 0000 037B             reform_ADC[adcnt] = (unsigned int)(avrtotal / (avr_loop_cnt+1));        //
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	LDS  R30,_avr_loop_cnt
	LDI  R31,0
	ADIW R30,1
	__GETD2S 2
	CALL SUBOPT_0x49
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 037C 
; 0000 037D             reformVoltage = (long)reform_ADC[adcnt];
	CALL SUBOPT_0x65
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	STS  _reformVoltage,R30
	STS  _reformVoltage+1,R31
; 0000 037E             reformTotal += (long)reform_ADC[adcnt++];
	CALL SUBOPT_0x67
	CALL SUBOPT_0x55
	CALL SUBOPT_0x68
; 0000 037F             adcnt %= avr_loop_cnt;
; 0000 0380 
; 0000 0381 
; 0000 0382             if(reformVoltage >= zero_value[reformCH]){
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1BC
; 0000 0383                 diffVoltage = reformVoltage - zero_value[reformCH];
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	SUB  R26,R30
	SBC  R27,R31
	STS  _diffVoltage,R26
	STS  _diffVoltage+1,R27
; 0000 0384                 //Positive Value
; 0000 0385                 reformSigned = 0;
	LDI  R30,LOW(0)
	STS  _reformSigned,R30
	STS  _reformSigned+1,R30
; 0000 0386             }
; 0000 0387             else   {
	RJMP _0x1BD
_0x1BC:
; 0000 0388                  diffVoltage = zero_value[reformCH] - reformVoltage;
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	SUB  R30,R26
	SBC  R31,R27
	STS  _diffVoltage,R30
	STS  _diffVoltage+1,R31
; 0000 0389                  //Negative Value
; 0000 038A                 reformSigned = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _reformSigned,R30
	STS  _reformSigned+1,R31
; 0000 038B             }
_0x1BD:
; 0000 038C 
; 0000 038D             reformWeight = ((long)diffVoltage * ConstWeight[reformCH])/1000;
	LDS  R30,_diffVoltage
	LDS  R31,_diffVoltage+1
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6B
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x6C
	STS  _reformWeight,R30
	STS  _reformWeight+1,R31
; 0000 038E             reformWeight = ((long)reformWeight* 29412)/100000;
	LDS  R26,_reformWeight
	LDS  R27,_reformWeight+1
	CLR  R24
	CLR  R25
	CALL SUBOPT_0x6D
	STS  _reformWeight,R30
	STS  _reformWeight+1,R31
; 0000 038F 
; 0000 0390             OCR1AH=0x00;        OCR1AL=0x4E;        //5msec /1024 prescaler
	CALL SUBOPT_0x21
; 0000 0391             TCCR1B = 0x05;
; 0000 0392 
; 0000 0393             break;
	RJMP _0x1BA
; 0000 0394         case tmrSPEED :
_0x1BB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1BE
; 0000 0395             if(modRunning==NORMAL_RUN || modRunning==SOLENOID_TEST){
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ _0x1C0
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ _0x1C0
	RJMP _0x1BF
_0x1C0:
; 0000 0396                 tmrSPEEDCNT++;
	LDI  R26,LOW(_tmrSPEEDCNT)
	LDI  R27,HIGH(_tmrSPEEDCNT)
	CALL SUBOPT_0x57
; 0000 0397 
; 0000 0398                 if(AccelStart==1){
	LDS  R26,_AccelStart
	CPI  R26,LOW(0x1)
	BRNE _0x1C2
; 0000 0399                     AccelCount++;
	LDI  R26,LOW(_AccelCount)
	LDI  R27,HIGH(_AccelCount)
	CALL SUBOPT_0x57
; 0000 039A                     if((AccelCount % unit_rising) ==0){ //5msec period interrupt
	LDS  R30,_unit_rising
	LDI  R31,0
	LDS  R26,_AccelCount
	LDS  R27,_AccelCount+1
	CALL __MODW21U
	SBIW R30,0
	BRNE _0x1C3
; 0000 039B                         AccelStep++;
	LDS  R30,_AccelStep
	SUBI R30,-LOW(1)
	STS  _AccelStep,R30
; 0000 039C                         Sol_Correction_Count = SYS_INFO.correction -(AccelStep*unit_correct);
	LDS  R30,_unit_correct
	LDS  R26,_AccelStep
	MULS R30,R26
	MOVW R30,R0
	__GETB2MN _SYS_INFO,4
	SUB  R26,R30
	STS  _Sol_Correction_Count,R26
; 0000 039D 
; 0000 039E                         if(AccelStep<init_off_correction){
	CALL SUBOPT_0x1F
	LDS  R26,_AccelStep
	LDI  R27,0
; 0000 039F                             off_Correction_Count = 0;
; 0000 03A0                         }
; 0000 03A1                         else{
; 0000 03A2                             off_Correction_Count = 0;
_0x4C4:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
; 0000 03A3                         }
; 0000 03A4 
; 0000 03A5                         if(AccelStep>=SYS_INFO.correction){
	__GETB1MN _SYS_INFO,4
	LDS  R26,_AccelStep
	CP   R26,R30
	BRLO _0x1C6
; 0000 03A6                             AccelStart = 0;                 //가속종료
	CALL SUBOPT_0x1D
; 0000 03A7                             AccelStep = 0;
; 0000 03A8                             AccelCount=accelStartCount;
; 0000 03A9                             Sol_Correction_Count = 0;
; 0000 03AA                         }
; 0000 03AB                     }
_0x1C6:
; 0000 03AC                 }
_0x1C3:
; 0000 03AD 
; 0000 03AE                 if(DeAccelStart==1){
_0x1C2:
	LDS  R26,_DeAccelStart
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x1C7
; 0000 03AF                     DeAccelDelay++;
	LDI  R26,LOW(_DeAccelDelay)
	LDI  R27,HIGH(_DeAccelDelay)
	CALL SUBOPT_0x57
; 0000 03B0                     if(DeAccelDelay>=DelayTimeCount){
	LDS  R30,_DelayTimeCount
	LDS  R31,_DelayTimeCount+1
	LDS  R26,_DeAccelDelay
	LDS  R27,_DeAccelDelay+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1C8
; 0000 03B1 
; 0000 03B2                     DeAccelCount++;
	LDI  R26,LOW(_DeAccelCount)
	LDI  R27,HIGH(_DeAccelCount)
	CALL SUBOPT_0x57
; 0000 03B3                     if((DeAccelCount %unit_falling) ==0){
	LDS  R30,_unit_falling
	LDI  R31,0
	LDS  R26,_DeAccelCount
	LDS  R27,_DeAccelCount+1
	CALL __MODW21U
	SBIW R30,0
	BRNE _0x1C9
; 0000 03B4                         DeAccelStep++;
	LDS  R30,_DeAccelStep
	SUBI R30,-LOW(1)
	STS  _DeAccelStep,R30
; 0000 03B5                         Sol_Correction_Count = DeAccelStep * unit_correct;
	LDS  R30,_unit_correct
	LDS  R26,_DeAccelStep
	MULS R30,R26
	MOVW R30,R0
	STS  _Sol_Correction_Count,R30
; 0000 03B6 
; 0000 03B7                         if(DeAccelStep>(init_off_correction+10)){
	CALL SUBOPT_0x1F
	ADIW R30,10
	LDS  R26,_DeAccelStep
	LDI  R27,0
; 0000 03B8                             off_Correction_Count = 0;
; 0000 03B9                         }
; 0000 03BA                         else{
; 0000 03BB                             off_Correction_Count = 0;
_0x4C5:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
; 0000 03BC                         }
; 0000 03BD 
; 0000 03BE                         if(DeAccelStep>=SYS_INFO.correction){
	__GETB1MN _SYS_INFO,4
	LDS  R26,_DeAccelStep
	CP   R26,R30
	BRLO _0x1CC
; 0000 03BF                             DeAccelStart = 0;           //감속종료
	CALL SUBOPT_0x22
; 0000 03C0                             DeAccelStep = deAccelStartCount;
; 0000 03C1                             DeAccelCount=0;
; 0000 03C2                             Sol_Correction_Count=SYS_INFO.correction+5;
	CALL SUBOPT_0x20
; 0000 03C3 
; 0000 03C4                             timerstop = 1;
	STS  _timerstop,R30
; 0000 03C5                         }
; 0000 03C6                     }
_0x1CC:
; 0000 03C7 
; 0000 03C8                     }
_0x1C9:
; 0000 03C9                 }
_0x1C8:
; 0000 03CA 
; 0000 03CB                 if(timerstop==0){
_0x1C7:
	LDS  R30,_timerstop
	CPI  R30,0
	BRNE _0x1CD
; 0000 03CC                     OCR1AH=0x00;        OCR1AL=0x4E;        //5msec /1024 prescaler
	CALL SUBOPT_0x21
; 0000 03CD                     TCCR1B = 0x05;
; 0000 03CE                 }
; 0000 03CF                 else{
	RJMP _0x1CE
_0x1CD:
; 0000 03D0                     TCCR1B = 0x00;
	CALL SUBOPT_0x18
; 0000 03D1                     TimerMode = tmrNONE;
	STS  _TimerMode,R30
; 0000 03D2                 }
_0x1CE:
; 0000 03D3             }
; 0000 03D4             break;
_0x1BF:
	RJMP _0x1BA
; 0000 03D5         case tmrBUZ :
_0x1BE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1BA
; 0000 03D6             led_buz_value &= ~BUZZER_ON;
	CALL SUBOPT_0x6E
; 0000 03D7             LED_BUZ = led_buz_value;
; 0000 03D8             TCCR1B = 0x00;
	CALL SUBOPT_0x18
; 0000 03D9             TimerMode = tmrNONE;
	STS  _TimerMode,R30
; 0000 03DA             break;
; 0000 03DB     }
_0x1BA:
; 0000 03DC }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
_0x4DE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;//중량 측정 위치에서 측정된 데이터를 최대값, 최소값, 평균값에 의해 보정
;void CorrectionData(unsigned char ch){
; 0000 03E0 void CorrectionData(unsigned char ch){
_CorrectionData:
; .FSTART _CorrectionData
; 0000 03E1     unsigned int maxdata=0, mindata=10000, avrdata;
; 0000 03E2     long TotalValue=0;
; 0000 03E3     unsigned char lcnt;
; 0000 03E4 
; 0000 03E5     //측정된 데이터의 최대값, 최소값, 평균값 구하기
; 0000 03E6     for(lcnt=0;lcnt<weight_ad_cnt;lcnt++){
	ST   -Y,R26
	SBIW R28,5
	CALL SUBOPT_0x62
	LDI  R30,LOW(0)
	STD  Y+4,R30
	CALL __SAVELOCR6
;	ch -> Y+11
;	maxdata -> R16,R17
;	mindata -> R18,R19
;	avrdata -> R20,R21
;	TotalValue -> Y+7
;	lcnt -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,10000
	STD  Y+6,R30
_0x1D1:
	LDS  R30,_weight_ad_cnt
	LDD  R26,Y+6
	CP   R26,R30
	BRSH _0x1D2
; 0000 03E7         if(voltData[ch][lcnt] >= maxdata) maxdata=voltData[ch][lcnt];
	CALL SUBOPT_0x6F
	CALL __GETW1P
	CP   R30,R16
	CPC  R31,R17
	BRLO _0x1D3
	CALL SUBOPT_0x6F
	LD   R16,X+
	LD   R17,X
; 0000 03E8         if(voltData[ch][lcnt] <= mindata) mindata=voltData[ch][lcnt];
_0x1D3:
	CALL SUBOPT_0x6F
	CALL __GETW1P
	CP   R18,R30
	CPC  R19,R31
	BRLO _0x1D4
	CALL SUBOPT_0x6F
	LD   R18,X+
	LD   R19,X
; 0000 03E9         TotalValue += (long)voltData[ch][lcnt];
_0x1D4:
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x55
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
; 0000 03EA     }
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x1D1
_0x1D2:
; 0000 03EB 
; 0000 03EC     avrdata = (unsigned int)(TotalValue / weight_ad_cnt);
	CALL SUBOPT_0x72
	MOVW R20,R30
; 0000 03ED     TotalValue = 0;
	LDI  R30,LOW(0)
	__CLRD1S 7
; 0000 03EE 
; 0000 03EF     //최대값, 최소값을 평균값으로 대체
; 0000 03F0     for(lcnt=0;lcnt<weight_ad_cnt;lcnt++){
	STD  Y+6,R30
_0x1D6:
	LDS  R30,_weight_ad_cnt
	LDD  R26,Y+6
	CP   R26,R30
	BRSH _0x1D7
; 0000 03F1         if(voltData[ch][lcnt] >= maxdata || voltData[ch][lcnt]<=mindata){
	CALL SUBOPT_0x6F
	CALL __GETW1P
	CP   R30,R16
	CPC  R31,R17
	BRSH _0x1D9
	CP   R18,R30
	CPC  R19,R31
	BRLO _0x1D8
_0x1D9:
; 0000 03F2             voltData[ch][lcnt] = avrdata;
	LDD  R30,Y+11
	LDI  R26,LOW(40)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_voltData)
	SBCI R31,HIGH(-_voltData)
	MOVW R26,R30
	LDD  R30,Y+6
	CALL SUBOPT_0xA
	ST   Z,R20
	STD  Z+1,R21
; 0000 03F3         }
; 0000 03F4 
; 0000 03F5         TotalValue += (long)voltData[ch][lcnt];
_0x1D8:
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x55
	CALL SUBOPT_0x73
; 0000 03F6         weight_value[ch] = (TotalValue / weight_ad_cnt);
	LDD  R30,Y+11
	LDI  R26,LOW(_weight_value)
	LDI  R27,HIGH(_weight_value)
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 03F7     }
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x1D6
_0x1D7:
; 0000 03F8 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
;
;//전압레벨로 변환된 측정값을 실제 무게로 환산
;void ConvertWeight(unsigned char ch){
; 0000 03FB void ConvertWeight(unsigned char ch){
_ConvertWeight:
; .FSTART _ConvertWeight
; 0000 03FC     unsigned int iWeight;
; 0000 03FD     int RWeight;
; 0000 03FE 
; 0000 03FF     //측정된 중량값에서 영점값을 뺀다.
; 0000 0400     if(weight_value[ch] >= zero_value[ch]){
	ST   -Y,R26
	CALL __SAVELOCR4
;	ch -> Y+4
;	iWeight -> R16,R17
;	RWeight -> R18,R19
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	BRLO _0x1DB
; 0000 0401         iWeight = weight_value[ch] - zero_value[ch];
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	RJMP _0x4C6
; 0000 0402     }
; 0000 0403     else{
_0x1DB:
; 0000 0404         iWeight = zero_value[ch]-weight_value[ch];
	CALL SUBOPT_0x76
	LD   R0,X+
	LD   R1,X
	LDD  R30,Y+4
	LDI  R26,LOW(_weight_value)
	LDI  R27,HIGH(_weight_value)
_0x4C6:
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
; 0000 0405     }
; 0000 0406 
; 0000 0407     old_Zero[ch] = zero_value[ch];
	LDD  R30,Y+4
	LDI  R26,LOW(_old_Zero)
	LDI  R27,HIGH(_old_Zero)
	CALL SUBOPT_0xA
	MOVW R0,R30
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
; 0000 0408 
; 0000 0409     //1차 계산된 값에 SPAN값을 곱하고, 전압값을 중량으로 변환하기 위한 변환 상수(약 0.0286=100/3500)를 곱하고
; 0000 040A     //최종 중량값을 추출
; 0000 040B     RWeight = ((long)iWeight * ConstWeight[ch])/1000;
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+4
	LDI  R26,LOW(_ConstWeight)
	LDI  R27,HIGH(_ConstWeight)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x6C
	MOVW R18,R30
; 0000 040C     RWeight = ((long)RWeight*29412 )/100000;
	MOVW R26,R18
	CALL __CWD2
	CALL SUBOPT_0x6D
	MOVW R18,R30
; 0000 040D 
; 0000 040E 
; 0000 040F     // 중량연산 결과 모니터링
; 0000 0410     if(debugMode==2){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0x1DD
; 0000 0411 
; 0000 0412         UDR1 =weight_value[ch]>>8;            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x74
	CALL SUBOPT_0x78
_0x1DE:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1DE
; 0000 0413         UDR1 =weight_value[ch];            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x74
	LD   R30,X
	STS  206,R30
_0x1E1:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1E1
; 0000 0414         UDR1 =zero_value[ch]>>8;            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x76
	CALL SUBOPT_0x78
_0x1E4:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1E4
; 0000 0415         UDR1 =zero_value[ch];            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x76
	LD   R30,X
	STS  206,R30
_0x1E7:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1E7
; 0000 0416         UDR1 =0xDD;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(221)
	STS  206,R30
_0x1EA:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1EA
; 0000 0417 
; 0000 0418 
; 0000 0419         UDR1 =RWeight>>8;            while(!(UCSR1A & 0x20));
	MOVW R30,R18
	CALL SUBOPT_0x79
_0x1ED:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1ED
; 0000 041A         UDR1 =RWeight;            while(!(UCSR1A & 0x20));
	STS  206,R18
_0x1F0:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1F0
; 0000 041B         UDR1 =0xDE;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(222)
	STS  206,R30
_0x1F3:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1F3
; 0000 041C 
; 0000 041D         if(ch==5){
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRNE _0x1F6
; 0000 041E             UDR1 =0xDF;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(223)
	STS  206,R30
_0x1F7:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1F7
; 0000 041F         }
; 0000 0420     }
_0x1F6:
; 0000 0421 
; 0000 0422     //Offset & Span 계산
; 0000 0423     //Offset은 매번 영점 기준 측정후 계산
; 0000 0424     //Span은 무게 보정시에만 계산
; 0000 0425     //Offset = Z_MeasureValue - Z_Reference
; 0000 0426     //SPAN = iWeight / MaxRef ( 측정된값과 100g 기준값의 배율- MaxRef = 4800)
; 0000 0427     //추출된 값을 저장
; 0000 0428     if(weight_value[ch] >= zero_value[ch]){
_0x1DD:
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	BRLO _0x1FA
; 0000 0429         ResultWeight[ch] = RWeight;
	LDD  R30,Y+4
	LDI  R26,LOW(_ResultWeight)
	LDI  R27,HIGH(_ResultWeight)
	CALL SUBOPT_0xA
	ST   Z,R18
	STD  Z+1,R19
; 0000 042A     }
; 0000 042B     else{
	RJMP _0x1FB
_0x1FA:
; 0000 042C         ResultWeight[ch] = RWeight * -1;
	LDD  R30,Y+4
	LDI  R26,LOW(_ResultWeight)
	LDI  R27,HIGH(_ResultWeight)
	CALL SUBOPT_0xA
	MOVW R22,R30
	MOVW R30,R18
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 042D     }
_0x1FB:
; 0000 042E 
; 0000 042F }
	CALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
;
;//측정된 계란을 무게, 솔위치, 파란, 오란 분류
;void WeightGrading(unsigned char ch){
; 0000 0432 void WeightGrading(unsigned char ch){
_WeightGrading:
; .FSTART _WeightGrading
; 0000 0433     unsigned char grade_result=0xFF, k=0;
; 0000 0434     int gradeWeight, set_bucket_data=0;
; 0000 0435     int testWeight[9] = {700,650,580,500,450,390,0,0,100};
; 0000 0436     long eggcnt_sum = 0;
; 0000 0437 
; 0000 0438     //ver3.4.1 = 저가형 acd적용을 위한 수정
; 0000 0439     unsigned char crackdata;
; 0000 043A 
; 0000 043B     testWeight[0] = GRADE_INFO[g_KING].loLimit + 20;
	ST   -Y,R26
	SBIW R28,23
	LDI  R24,22
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	LDI  R30,LOW(_0x1FC*2)
	LDI  R31,HIGH(_0x1FC*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	ch -> Y+29
;	grade_result -> R17
;	k -> R16
;	gradeWeight -> R18,R19
;	set_bucket_data -> R20,R21
;	testWeight -> Y+11
;	eggcnt_sum -> Y+7
;	crackdata -> Y+6
	LDI  R17,255
	LDI  R16,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x7A
	ADIW R30,20
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 043C     testWeight[1] = GRADE_INFO[g_SPECIAL].loLimit + 20;
	CALL SUBOPT_0x7B
	ADIW R30,20
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 043D     testWeight[2] = GRADE_INFO[g_BIG].loLimit + 20;
	CALL SUBOPT_0x7C
	ADIW R30,20
	STD  Y+15,R30
	STD  Y+15+1,R31
; 0000 043E     testWeight[3] = GRADE_INFO[g_MIDDLE].loLimit + 20;
	CALL SUBOPT_0x7D
	ADIW R30,20
	STD  Y+17,R30
	STD  Y+17+1,R31
; 0000 043F     testWeight[4] = GRADE_INFO[g_SMALL].loLimit + 20;
	CALL SUBOPT_0x7E
	ADIW R30,20
	STD  Y+19,R30
	STD  Y+19+1,R31
; 0000 0440     testWeight[5] = GRADE_INFO[g_LIGHT].loLimit + 20;
	CALL SUBOPT_0x7F
	ADIW R30,20
	STD  Y+21,R30
	STD  Y+21+1,R31
; 0000 0441 
; 0000 0442     if(modRunning==NORMAL_RUN){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x1FD
; 0000 0443         gradeWeight = ResultWeight[ch];
	LDD  R30,Y+29
	LDI  R26,LOW(_ResultWeight)
	LDI  R27,HIGH(_ResultWeight)
	LDI  R31,0
	RJMP _0x4C7
; 0000 0444     }
; 0000 0445     else if(modRunning==SOLENOID_TEST){
_0x1FD:
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ PC+2
	RJMP _0x1FF
; 0000 0446         if(SolenoidTestType==0){
	TST  R3
	BRNE _0x200
; 0000 0447             if(ch==0){
	LDD  R30,Y+29
	CPI  R30,0
	BRNE _0x201
; 0000 0448                 if(TestGrade==5){
	LDI  R30,LOW(5)
	CP   R30,R6
	BRNE _0x202
; 0000 0449                     //ver3.4.1 = 저가형 acd적용을 위한 수정
; 0000 044A                     //crackCHKCNT[0] = 100;
; 0000 044B                     ACD_DATA_BUF[0] = 0x01;
	LDI  R30,LOW(1)
	STS  _ACD_DATA_BUF,R30
; 0000 044C                     dotCHKCNT[0] = 0;
	LDI  R30,LOW(0)
	STS  _dotCHKCNT,R30
; 0000 044D                 }
; 0000 044E                 else if(TestGrade==6){
	RJMP _0x203
_0x202:
	LDI  R30,LOW(6)
	CP   R30,R6
	BRNE _0x204
; 0000 044F                     dotCHKCNT[0] =100;
	LDI  R30,LOW(100)
	STS  _dotCHKCNT,R30
; 0000 0450                     //crackCHKCNT[0] = 0;
; 0000 0451                     //ver3.4.1 = 저가형 acd적용을 위한 수정
; 0000 0452                     ACD_DATA_BUF[0] = 0x00;
	LDI  R30,LOW(0)
	STS  _ACD_DATA_BUF,R30
; 0000 0453                 }
; 0000 0454                 else{
	RJMP _0x205
_0x204:
; 0000 0455                     gradeWeight = testWeight[TestGrade];
	MOV  R30,R6
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,11
	CALL SUBOPT_0xB
	LD   R18,X+
	LD   R19,X
; 0000 0456                 }
_0x205:
_0x203:
; 0000 0457             }
; 0000 0458             else{
	RJMP _0x206
_0x201:
; 0000 0459                 gradeWeight = 10;
	__GETWRN 18,19,10
; 0000 045A             }
_0x206:
; 0000 045B         }
; 0000 045C         else if(SolenoidTestType==1){
	RJMP _0x207
_0x200:
	LDI  R30,LOW(1)
	CP   R30,R3
	BRNE _0x208
; 0000 045D             if(TestGrade==5){
	LDI  R30,LOW(5)
	CP   R30,R6
	BRNE _0x209
; 0000 045E                 //ver3.4.1 = 저가형 acd적용을 위한 수정
; 0000 045F                 //crackCHKCNT[ch] = 100;
; 0000 0460                 ACD_DATA_BUF[0] = 0x01<<ch;
	CALL SUBOPT_0x80
	STS  _ACD_DATA_BUF,R30
; 0000 0461             }
; 0000 0462             else if(TestGrade==6){
	RJMP _0x20A
_0x209:
	LDI  R30,LOW(6)
	CP   R30,R6
	BRNE _0x20B
; 0000 0463                 dotCHKCNT[ch] =100;
	CALL SUBOPT_0x81
	LDI  R26,LOW(100)
	STD  Z+0,R26
; 0000 0464             }
; 0000 0465             else{
	RJMP _0x20C
_0x20B:
; 0000 0466                 gradeWeight = testWeight[TestGrade];
	MOV  R30,R6
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,11
_0x4C7:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
; 0000 0467             }
_0x20C:
_0x20A:
; 0000 0468         }
; 0000 0469     }
_0x208:
_0x207:
; 0000 046A 
; 0000 046B     GRADE_DATA.gEWeight[ch] = ResultWeight[ch];
_0x1FF:
	LDD  R30,Y+29
	LDI  R26,LOW(_GRADE_DATA)
	LDI  R27,HIGH(_GRADE_DATA)
	LDI  R31,0
	CALL SUBOPT_0x47
	MOVW R0,R30
	LDD  R30,Y+29
	LDI  R26,LOW(_ResultWeight)
	LDI  R27,HIGH(_ResultWeight)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	MOVW R26,R0
	CALL __CWD1
	CALL __PUTDP1
; 0000 046C 
; 0000 046D     // if((crackCHKCNT[ch] <= 5) && dotCHKCNT[ch]<= 5){     //크랙이나 오물란 신호가 없으면 :: 5이하이면 무시
; 0000 046E     //ver3.4.1 = 저가형 acd적용을 위한 수정
; 0000 046F     //SYS_INFO.ACD_CHK_POS =3;
; 0000 0470     crackdata = (ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS]>>ch) & 0x01;
	CALL SUBOPT_0x56
	LDD  R30,Y+29
	CALL __LSRB12
	ANDI R30,LOW(0x1)
	STD  Y+6,R30
; 0000 0471 
; 0000 0472     if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x20D
; 0000 0473         UDR1 =ACD_DATA_BUF[0];            while(!(UCSR1A & 0x20));
	LDS  R30,_ACD_DATA_BUF
	STS  206,R30
_0x20E:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x20E
; 0000 0474         UDR1 =ACD_DATA_BUF[1];            while(!(UCSR1A & 0x20));
	__GETB1MN _ACD_DATA_BUF,1
	STS  206,R30
_0x211:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x211
; 0000 0475         UDR1 =ACD_DATA_BUF[2];            while(!(UCSR1A & 0x20));
	__GETB1MN _ACD_DATA_BUF,2
	STS  206,R30
_0x214:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x214
; 0000 0476         UDR1 =ACD_DATA_BUF[3];            while(!(UCSR1A & 0x20));
	__GETB1MN _ACD_DATA_BUF,3
	STS  206,R30
_0x217:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x217
; 0000 0477         UDR1 =ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS];            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x82
	LD   R30,Z
	STS  206,R30
_0x21A:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x21A
; 0000 0478         UDR1 =0xFB;                                          while(!(UCSR1A & 0x20));
	LDI  R30,LOW(251)
	STS  206,R30
_0x21D:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x21D
; 0000 0479     }
; 0000 047A 
; 0000 047B     if((crackdata == 0 ) && dotCHKCNT[ch]<= 5){     //크랙이나 오물란 신호가 없으면 :: 5이하이면 무시
_0x20D:
	LDD  R26,Y+6
	CPI  R26,LOW(0x0)
	BRNE _0x221
	CALL SUBOPT_0x81
	LD   R26,Z
	CPI  R26,LOW(0x6)
	BRLO _0x222
_0x221:
	RJMP _0x220
_0x222:
; 0000 047C         //crackCHKCNT[ch] = 0;
; 0000 047D         //crack data reset;
; 0000 047E         GRADE_DATA.gECrack[ch]=0;
	__POINTW2MN _GRADE_DATA,24
	LDD  R30,Y+29
	LDI  R31,0
	CALL SUBOPT_0x4D
; 0000 047F         ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS] &= ~(0x01<<ch);
	CALL SUBOPT_0x82
	MOVW R22,R30
	LD   R1,Z
	CALL SUBOPT_0x80
	COM  R30
	AND  R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 0480 
; 0000 0481         dotCHKCNT[ch] = 0;
	CALL SUBOPT_0x81
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0482         //Grading
; 0000 0483         if(gradeWeight >= GRADE_INFO[g_ETC].hiLimit){       //상등외
	CALL SUBOPT_0x83
	BRLT _0x223
; 0000 0484             grade_result = g_ETC;   GRADE_DATA.gNumber[g_ETC]++;    //등급 저장, 계란 수량 누적
	LDI  R17,LOW(8)
	__POINTW2MN _GRADE_DATA,80
	CALL SUBOPT_0x3C
; 0000 0485             GRADE_DATA.gWeight[g_ETC] += gradeWeight;
	CALL SUBOPT_0x84
; 0000 0486             //인쇄
; 0000 0487             if(GRADE_INFO[g_ETC].prttype!=PRT_TYPE_NO){
	BREQ _0x224
; 0000 0488                 if(GRADE_INFO[g_ETC].prtOutCount<GRADE_INFO[g_ETC].prtSetCount || GRADE_INFO[g_ETC].prtSetCount==0) {
	CALL SUBOPT_0x85
	BRLT _0x226
	__GETW1MN _GRADE_INFO,86
	SBIW R30,0
	BRNE _0x225
_0x226:
; 0000 0489                     GRADE_INFO[g_ETC].prtOutCount++;
	__POINTW2MN _GRADE_INFO,88
	CALL SUBOPT_0x57
; 0000 048A                     GRADE_DATA.pNumber[g_ETC]++;
	__POINTW2MN _GRADE_DATA,160
	CALL SUBOPT_0x3C
; 0000 048B                 }
; 0000 048C                 else{
	RJMP _0x228
_0x225:
; 0000 048D                     old_prttype[g_ETC] = GRADE_INFO[g_ETC].prttype;
	CALL SUBOPT_0x86
; 0000 048E                     GRADE_INFO[g_ETC].prttype = PRT_TYPE_NO;
; 0000 048F                     GRADE_INFO[g_ETC].prtOutCount = 0;
; 0000 0490                 }
_0x228:
; 0000 0491             }
; 0000 0492         }
_0x224:
; 0000 0493         else if((gradeWeight < GRADE_INFO[g_ETC].hiLimit)&&(gradeWeight >= GRADE_INFO[g_KING].loLimit)){ //왕란
	RJMP _0x229
_0x223:
	CALL SUBOPT_0x83
	BRGE _0x22B
	CALL SUBOPT_0x7A
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x22C
_0x22B:
	RJMP _0x22A
_0x22C:
; 0000 0494             grade_result = g_KING;
	LDI  R17,LOW(0)
; 0000 0495             GRADE_DATA.gNumber[g_KING]++;
	__POINTW2MN _GRADE_DATA,48
	CALL SUBOPT_0x3C
; 0000 0496             GRADE_DATA.gWeight[g_KING] += gradeWeight;
	__GETD2MN _GRADE_DATA,88
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,88
; 0000 0497             //인쇄
; 0000 0498             if(GRADE_INFO[g_KING].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,5
	CPI  R30,0
	BREQ _0x22D
; 0000 0499                 if(GRADE_INFO[g_KING].prtOutCount<GRADE_INFO[g_KING].prtSetCount || GRADE_INFO[g_KING].prtSetCount==0) {
	__GETW2MN _GRADE_INFO,8
	__GETW1MN _GRADE_INFO,6
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x22F
	__GETW2MN _GRADE_INFO,6
	SBIW R26,0
	BRNE _0x22E
_0x22F:
; 0000 049A                     GRADE_INFO[g_KING].prtOutCount++;
	__POINTW2MN _GRADE_INFO,8
	CALL SUBOPT_0x57
; 0000 049B                     GRADE_DATA.pNumber[g_KING]++;
	__POINTW2MN _GRADE_DATA,128
	CALL SUBOPT_0x3C
; 0000 049C                 }
; 0000 049D                 else{
	RJMP _0x231
_0x22E:
; 0000 049E                     old_prttype[g_KING] = GRADE_INFO[g_KING].prttype;
	__GETB1MN _GRADE_INFO,5
	STS  _old_prttype,R30
; 0000 049F                     GRADE_INFO[g_KING].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,5
; 0000 04A0                     GRADE_INFO[g_KING].prtOutCount = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _GRADE_INFO,8
; 0000 04A1                 }
_0x231:
; 0000 04A2             }
; 0000 04A3         }
_0x22D:
; 0000 04A4         else if((gradeWeight < GRADE_INFO[g_KING].loLimit)&&(gradeWeight >= GRADE_INFO[g_SPECIAL].loLimit)){ //특란::왕� ...
	RJMP _0x232
_0x22A:
	CALL SUBOPT_0x7A
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x234
	CALL SUBOPT_0x7B
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x235
_0x234:
	RJMP _0x233
_0x235:
; 0000 04A5             grade_result = g_SPECIAL;
	LDI  R17,LOW(1)
; 0000 04A6             GRADE_DATA.gNumber[g_SPECIAL]++;
	__POINTW2MN _GRADE_DATA,52
	CALL SUBOPT_0x3C
; 0000 04A7             GRADE_DATA.gWeight[g_SPECIAL] += gradeWeight;
	__GETD2MN _GRADE_DATA,92
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,92
; 0000 04A8             //인쇄
; 0000 04A9             if(GRADE_INFO[g_SPECIAL].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,15
	CPI  R30,0
	BREQ _0x236
; 0000 04AA                 if( GRADE_INFO[g_SPECIAL].prtOutCount<GRADE_INFO[g_SPECIAL].prtSetCount || GRADE_INFO[g_SPECIAL].prtSetC ...
	__GETW2MN _GRADE_INFO,18
	__GETW1MN _GRADE_INFO,16
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x238
	__GETW1MN _GRADE_INFO,16
	SBIW R30,0
	BRNE _0x237
_0x238:
; 0000 04AB                     GRADE_INFO[g_SPECIAL].prtOutCount++;
	__POINTW2MN _GRADE_INFO,18
	CALL SUBOPT_0x57
; 0000 04AC                     GRADE_DATA.pNumber[g_SPECIAL]++;
	__POINTW2MN _GRADE_DATA,132
	CALL SUBOPT_0x3C
; 0000 04AD                 }
; 0000 04AE                 else{
	RJMP _0x23A
_0x237:
; 0000 04AF                     old_prttype[g_SPECIAL] = GRADE_INFO[g_SPECIAL].prttype;
	__GETB1MN _GRADE_INFO,15
	__PUTB1MN _old_prttype,1
; 0000 04B0                     GRADE_INFO[g_SPECIAL].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,15
; 0000 04B1                     GRADE_INFO[g_SPECIAL].prtOutCount = 0;
	__POINTW1MN _GRADE_INFO,18
	CALL SUBOPT_0x2
; 0000 04B2                 }
_0x23A:
; 0000 04B3             }
; 0000 04B4         }
_0x236:
; 0000 04B5         else if((gradeWeight < GRADE_INFO[g_SPECIAL].loLimit)&&(gradeWeight >=GRADE_INFO[g_BIG].loLimit)){ //대란::특란  ...
	RJMP _0x23B
_0x233:
	CALL SUBOPT_0x7B
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x23D
	CALL SUBOPT_0x7C
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x23E
_0x23D:
	RJMP _0x23C
_0x23E:
; 0000 04B6             grade_result = g_BIG;
	LDI  R17,LOW(2)
; 0000 04B7             GRADE_DATA.gNumber[g_BIG]++;
	__POINTW2MN _GRADE_DATA,56
	CALL SUBOPT_0x3C
; 0000 04B8             GRADE_DATA.gWeight[g_BIG] += gradeWeight;
	__GETD2MN _GRADE_DATA,96
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,96
; 0000 04B9             //인쇄
; 0000 04BA             if(GRADE_INFO[g_BIG].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,25
	CPI  R30,0
	BREQ _0x23F
; 0000 04BB                 if(GRADE_INFO[g_BIG].prtOutCount<GRADE_INFO[g_BIG].prtSetCount || GRADE_INFO[g_BIG].prtSetCount==0) {
	__GETW2MN _GRADE_INFO,28
	__GETW1MN _GRADE_INFO,26
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x241
	__GETW1MN _GRADE_INFO,26
	SBIW R30,0
	BRNE _0x240
_0x241:
; 0000 04BC                     GRADE_INFO[g_BIG].prtOutCount++;
	__POINTW2MN _GRADE_INFO,28
	CALL SUBOPT_0x57
; 0000 04BD                     GRADE_DATA.pNumber[g_BIG]++;
	__POINTW2MN _GRADE_DATA,136
	CALL SUBOPT_0x3C
; 0000 04BE                 }
; 0000 04BF                 else{
	RJMP _0x243
_0x240:
; 0000 04C0                     old_prttype[g_BIG] = GRADE_INFO[g_BIG].prttype;
	__GETB1MN _GRADE_INFO,25
	__PUTB1MN _old_prttype,2
; 0000 04C1                     GRADE_INFO[g_BIG].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,25
; 0000 04C2                     GRADE_INFO[g_BIG].prtOutCount = 0;
	__POINTW1MN _GRADE_INFO,28
	CALL SUBOPT_0x2
; 0000 04C3                 }
_0x243:
; 0000 04C4             }
; 0000 04C5         }
_0x23F:
; 0000 04C6         else if((gradeWeight < GRADE_INFO[g_BIG].loLimit)&&(gradeWeight >= GRADE_INFO[g_MIDDLE].loLimit)){ //중란::대란  ...
	RJMP _0x244
_0x23C:
	CALL SUBOPT_0x7C
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x246
	CALL SUBOPT_0x7D
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x247
_0x246:
	RJMP _0x245
_0x247:
; 0000 04C7             grade_result = g_MIDDLE;
	LDI  R17,LOW(3)
; 0000 04C8             GRADE_DATA.gNumber[g_MIDDLE]++;
	__POINTW2MN _GRADE_DATA,60
	CALL SUBOPT_0x3C
; 0000 04C9             GRADE_DATA.gWeight[g_MIDDLE] += gradeWeight;
	__GETD2MN _GRADE_DATA,100
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,100
; 0000 04CA             //인쇄
; 0000 04CB             if(GRADE_INFO[g_MIDDLE].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,35
	CPI  R30,0
	BREQ _0x248
; 0000 04CC                 if(GRADE_INFO[g_MIDDLE].prtOutCount<GRADE_INFO[g_MIDDLE].prtSetCount || GRADE_INFO[g_MIDDLE].prtSetCount ...
	__GETW2MN _GRADE_INFO,38
	__GETW1MN _GRADE_INFO,36
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x24A
	__GETW1MN _GRADE_INFO,36
	SBIW R30,0
	BRNE _0x249
_0x24A:
; 0000 04CD                     GRADE_INFO[g_MIDDLE].prtOutCount++;
	__POINTW2MN _GRADE_INFO,38
	CALL SUBOPT_0x57
; 0000 04CE                     GRADE_DATA.pNumber[g_MIDDLE]++;
	__POINTW2MN _GRADE_DATA,140
	CALL SUBOPT_0x3C
; 0000 04CF                 }
; 0000 04D0                 else{
	RJMP _0x24C
_0x249:
; 0000 04D1                     old_prttype[g_MIDDLE] = GRADE_INFO[g_MIDDLE].prttype;
	__GETB1MN _GRADE_INFO,35
	__PUTB1MN _old_prttype,3
; 0000 04D2                     GRADE_INFO[g_MIDDLE].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,35
; 0000 04D3                     GRADE_INFO[g_MIDDLE].prtOutCount = 0;
	__POINTW1MN _GRADE_INFO,38
	CALL SUBOPT_0x2
; 0000 04D4                 }
_0x24C:
; 0000 04D5             }
; 0000 04D6         }
_0x248:
; 0000 04D7         else if((gradeWeight < GRADE_INFO[g_MIDDLE].loLimit)&&(gradeWeight >= GRADE_INFO[g_SMALL].loLimit)){ //소란 :: � ...
	RJMP _0x24D
_0x245:
	CALL SUBOPT_0x7D
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x24F
	CALL SUBOPT_0x7E
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x250
_0x24F:
	RJMP _0x24E
_0x250:
; 0000 04D8             grade_result = g_SMALL;
	LDI  R17,LOW(4)
; 0000 04D9             GRADE_DATA.gNumber[g_SMALL]++;
	__POINTW2MN _GRADE_DATA,64
	CALL SUBOPT_0x3C
; 0000 04DA             GRADE_DATA.gWeight[g_SMALL] += gradeWeight;
	__GETD2MN _GRADE_DATA,104
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,104
; 0000 04DB             //인쇄
; 0000 04DC             if(GRADE_INFO[g_SMALL].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,45
	CPI  R30,0
	BREQ _0x251
; 0000 04DD                 if(GRADE_INFO[g_SMALL].prtOutCount<GRADE_INFO[g_SMALL].prtSetCount || GRADE_INFO[g_SMALL].prtSetCount==0 ...
	__GETW2MN _GRADE_INFO,48
	__GETW1MN _GRADE_INFO,46
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x253
	__GETW1MN _GRADE_INFO,46
	SBIW R30,0
	BRNE _0x252
_0x253:
; 0000 04DE                     GRADE_INFO[g_SMALL].prtOutCount++;
	__POINTW2MN _GRADE_INFO,48
	CALL SUBOPT_0x57
; 0000 04DF                     GRADE_DATA.pNumber[g_SMALL]++;
	__POINTW2MN _GRADE_DATA,144
	CALL SUBOPT_0x3C
; 0000 04E0                 }
; 0000 04E1                 else{
	RJMP _0x255
_0x252:
; 0000 04E2                     old_prttype[g_SMALL] = GRADE_INFO[g_SMALL].prttype;
	__GETB1MN _GRADE_INFO,45
	__PUTB1MN _old_prttype,4
; 0000 04E3                     GRADE_INFO[g_SMALL].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,45
; 0000 04E4                     GRADE_INFO[g_SMALL].prtOutCount = 0;
	__POINTW1MN _GRADE_INFO,48
	CALL SUBOPT_0x2
; 0000 04E5                 }
_0x255:
; 0000 04E6             }
; 0000 04E7         }
_0x251:
; 0000 04E8         else if((gradeWeight < GRADE_INFO[g_SMALL].loLimit)&&(gradeWeight >= GRADE_INFO[g_LIGHT].loLimit)){ //경란 :: 소 ...
	RJMP _0x256
_0x24E:
	CALL SUBOPT_0x7E
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x258
	CALL SUBOPT_0x7F
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x259
_0x258:
	RJMP _0x257
_0x259:
; 0000 04E9             grade_result = g_LIGHT;
	LDI  R17,LOW(5)
; 0000 04EA             GRADE_DATA.gNumber[g_LIGHT]++;
	__POINTW2MN _GRADE_DATA,68
	CALL SUBOPT_0x3C
; 0000 04EB             GRADE_DATA.gWeight[g_LIGHT] += gradeWeight;
	__GETD2MN _GRADE_DATA,108
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,108
; 0000 04EC             //인쇄
; 0000 04ED             if(GRADE_INFO[g_LIGHT].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,55
	CPI  R30,0
	BREQ _0x25A
; 0000 04EE                 if(GRADE_INFO[g_LIGHT].prtOutCount<GRADE_INFO[g_LIGHT].prtSetCount || GRADE_INFO[g_LIGHT].prtSetCount==0 ...
	__GETW2MN _GRADE_INFO,58
	__GETW1MN _GRADE_INFO,56
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x25C
	__GETW1MN _GRADE_INFO,56
	SBIW R30,0
	BRNE _0x25B
_0x25C:
; 0000 04EF                     GRADE_INFO[g_LIGHT].prtOutCount++;
	__POINTW2MN _GRADE_INFO,58
	CALL SUBOPT_0x57
; 0000 04F0                     GRADE_DATA.pNumber[g_LIGHT]++;
	__POINTW2MN _GRADE_DATA,148
	CALL SUBOPT_0x3C
; 0000 04F1                 }
; 0000 04F2                 else{
	RJMP _0x25E
_0x25B:
; 0000 04F3                     old_prttype[g_LIGHT] = GRADE_INFO[g_LIGHT].prttype;
	__GETB1MN _GRADE_INFO,55
	__PUTB1MN _old_prttype,5
; 0000 04F4                     GRADE_INFO[g_LIGHT].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,55
; 0000 04F5                     GRADE_INFO[g_LIGHT].prtOutCount = 0;
	__POINTW1MN _GRADE_INFO,58
	CALL SUBOPT_0x2
; 0000 04F6                 }
_0x25E:
; 0000 04F7             }
; 0000 04F8         }
_0x25A:
; 0000 04F9         else if( (gradeWeight < GRADE_INFO[g_LIGHT].loLimit) && (gradeWeight >= 100)){       //하등외 :: 경란의 하한보다 ...
	RJMP _0x25F
_0x257:
	CALL SUBOPT_0x7F
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x261
	__CPWRN 18,19,100
	BRGE _0x262
_0x261:
	RJMP _0x260
_0x262:
; 0000 04FA             grade_result = g_ETC;
	LDI  R17,LOW(8)
; 0000 04FB             GRADE_DATA.gNumber[g_ETC]++;
	__POINTW2MN _GRADE_DATA,80
	CALL SUBOPT_0x3C
; 0000 04FC             GRADE_DATA.gWeight[g_ETC] += gradeWeight;
	CALL SUBOPT_0x84
; 0000 04FD             //인쇄
; 0000 04FE             if(GRADE_INFO[g_ETC].prttype!=PRT_TYPE_NO){
	BREQ _0x263
; 0000 04FF                 if(GRADE_INFO[g_ETC].prtOutCount<GRADE_INFO[g_ETC].prtSetCount || GRADE_INFO[g_ETC].prtSetCount==0) {
	CALL SUBOPT_0x85
	BRLT _0x265
	__GETW1MN _GRADE_INFO,86
	SBIW R30,0
	BRNE _0x264
_0x265:
; 0000 0500                     GRADE_INFO[g_ETC].prtOutCount++;
	__POINTW2MN _GRADE_INFO,88
	CALL SUBOPT_0x57
; 0000 0501                     GRADE_DATA.pNumber[g_ETC]++;
	__POINTW2MN _GRADE_DATA,160
	CALL SUBOPT_0x3C
; 0000 0502                 }
; 0000 0503                 else{
	RJMP _0x267
_0x264:
; 0000 0504                     old_prttype[g_ETC] = GRADE_INFO[g_ETC].prttype;
	CALL SUBOPT_0x86
; 0000 0505                     GRADE_INFO[g_ETC].prttype = PRT_TYPE_NO;
; 0000 0506                     GRADE_INFO[g_ETC].prtOutCount = 0;
; 0000 0507                 }
_0x267:
; 0000 0508             }
; 0000 0509         }
_0x263:
; 0000 050A     }
_0x260:
_0x25F:
_0x256:
_0x24D:
_0x244:
_0x23B:
_0x232:
_0x229:
; 0000 050B     else{
	RJMP _0x268
_0x220:
; 0000 050C         if(dotCHKCNT[ch]>5){
	CALL SUBOPT_0x81
	LD   R26,Z
; 0000 050D //            grade_result = g_DOT;
; 0000 050E //            GRADE_DATA.gNumber[g_DOT]++;
; 0000 050F //            GRADE_DATA.gWeight[g_DOT] += gradeWeight;
; 0000 0510 //            //version 3.4.2
; 0000 0511 //            //인쇄
; 0000 0512 //            if(GRADE_INFO[g_DOT].prttype!=PRT_TYPE_NO){
; 0000 0513 //                if(GRADE_INFO[g_DOT].prtOutCount<GRADE_INFO[g_DOT].prtSetCount || GRADE_INFO[g_DOT].prtSetCount==0) {
; 0000 0514 //                    GRADE_INFO[g_DOT].prtOutCount++;
; 0000 0515 //                    GRADE_DATA.pNumber[g_DOT]++;
; 0000 0516 //                }
; 0000 0517 //                else{
; 0000 0518 //                    old_prttype[g_DOT] = GRADE_INFO[g_DOT].prttype;
; 0000 0519 //                    GRADE_INFO[g_DOT].prttype = PRT_TYPE_NO;
; 0000 051A //                    GRADE_INFO[g_DOT].prtOutCount = 0;
; 0000 051B //                }
; 0000 051C //            }
; 0000 051D //
; 0000 051E //            dotCHKCNT[ch] = 0;
; 0000 051F         }
; 0000 0520         //ver3.4.1 = 저가형 acd적용을 위한 수정
; 0000 0521         crackdata = (ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS]>>ch) & 0x01;
	CALL SUBOPT_0x56
	LDD  R30,Y+29
	CALL __LSRB12
	ANDI R30,LOW(0x1)
	STD  Y+6,R30
; 0000 0522         //if(crackCHKCNT[ch]>5){
; 0000 0523         if(crackdata==0x01){
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x26A
; 0000 0524 
; 0000 0525             if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x26B
; 0000 0526 
; 0000 0527                 UDR1 =gradeWeight>>8;                           while(!(UCSR1A & 0x20));
	MOVW R30,R18
	CALL SUBOPT_0x79
_0x26C:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x26C
; 0000 0528                 UDR1 =gradeWeight;                              while(!(UCSR1A & 0x20));
	STS  206,R18
_0x26F:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x26F
; 0000 0529                 UDR1 =ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS];            while(!(UCSR1A & 0x20));
	CALL SUBOPT_0x82
	LD   R30,Z
	STS  206,R30
_0x272:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x272
; 0000 052A                 UDR1 =0xFE;                                          while(!(UCSR1A & 0x20));
	LDI  R30,LOW(254)
	STS  206,R30
_0x275:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x275
; 0000 052B             }
; 0000 052C             grade_result = g_CRACK;
_0x26B:
	LDI  R17,LOW(6)
; 0000 052D 
; 0000 052E             GRADE_DATA.gECrack[ch]=1;
	__POINTW2MN _GRADE_DATA,24
	LDD  R30,Y+29
	LDI  R31,0
	CALL SUBOPT_0x88
	__GETD1N 0x1
	CALL __PUTDP1
; 0000 052F 
; 0000 0530             GRADE_DATA.gNumber[g_CRACK]++;
	__POINTW2MN _GRADE_DATA,72
	CALL SUBOPT_0x3C
; 0000 0531             GRADE_DATA.gWeight[g_CRACK] += gradeWeight;
	__GETD2MN _GRADE_DATA,112
	CALL SUBOPT_0x87
	__PUTD1MN _GRADE_DATA,112
; 0000 0532 
; 0000 0533             //version 3.4.2
; 0000 0534             //인쇄
; 0000 0535             if(GRADE_INFO[g_CRACK].prttype!=PRT_TYPE_NO){
	__GETB1MN _GRADE_INFO,65
	CPI  R30,0
	BREQ _0x278
; 0000 0536                 if(GRADE_INFO[g_CRACK].prtOutCount<GRADE_INFO[g_CRACK].prtSetCount || GRADE_INFO[g_CRACK].prtSetCount==0 ...
	__GETW2MN _GRADE_INFO,68
	__GETW1MN _GRADE_INFO,66
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x27A
	__GETW1MN _GRADE_INFO,66
	SBIW R30,0
	BRNE _0x279
_0x27A:
; 0000 0537                     GRADE_INFO[g_CRACK].prtOutCount++;
	__POINTW2MN _GRADE_INFO,68
	CALL SUBOPT_0x57
; 0000 0538                     GRADE_DATA.pNumber[g_CRACK]++;
	__POINTW2MN _GRADE_DATA,152
	CALL SUBOPT_0x3C
; 0000 0539                 }
; 0000 053A                 else{
	RJMP _0x27C
_0x279:
; 0000 053B                     old_prttype[g_CRACK] = GRADE_INFO[g_CRACK].prttype;
	__GETB1MN _GRADE_INFO,65
	__PUTB1MN _old_prttype,6
; 0000 053C                     GRADE_INFO[g_CRACK].prttype = PRT_TYPE_NO;
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,65
; 0000 053D                     GRADE_INFO[g_CRACK].prtOutCount = 0;
	__POINTW1MN _GRADE_INFO,68
	CALL SUBOPT_0x2
; 0000 053E                 }
_0x27C:
; 0000 053F             }
; 0000 0540             //version 3.4.1
; 0000 0541             ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS] &= ~(0x01<<ch);
_0x278:
	CALL SUBOPT_0x82
	MOVW R22,R30
	LD   R1,Z
	CALL SUBOPT_0x80
	COM  R30
	AND  R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 0542             //crackCHKCNT[ch] = 0;
; 0000 0543         }
; 0000 0544     }
_0x26A:
_0x268:
; 0000 0545     ////Grading Value Bit Table
; 0000 0546     // 0000 | 0000 | 0000 | 0000
; 0000 0547     //--------------------------
; 0000 0548     //   |      |     |       |-> Solenoid Position || Low Nibble
; 0000 0549     //   |      |     |---------> Solenoid Position || High Nibble
; 0000 054A     //   |      |---------------> Grade Position
; 0000 054B     //   |----------------------> Crack/DOT Info, PRT TYPE || 00:CLean, 01:CRACK(0x8000), 02:DOT(0x4000), 00:NONE, 01:PR ...
; 0000 054C 
; 0000 054D     if(grade_result != 0xFF){
	CPI  R17,255
	BRNE PC+2
	RJMP _0x27D
; 0000 054E         GRADE_DATA.gTNumber++;
	__POINTW2MN _GRADE_DATA,168
	CALL SUBOPT_0x3C
; 0000 054F         GRADE_DATA.gTWeight += gradeWeight;
	__GETD2MN _GRADE_DATA,172
	CALL SUBOPT_0x87
	CALL SUBOPT_0x89
; 0000 0550         BucketData_Wight[MAX_LDCELL-ch+1] = gradeWeight;
	LDD  R30,Y+29
	LDI  R31,0
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,1
	CALL SUBOPT_0x8A
	ST   Z,R18
	STD  Z+1,R19
; 0000 0551         set_bucket_data = 0;
	__GETWRN 20,21,0
; 0000 0552         //#########################################
; 0000 0553         //###  등외란-파란 팩커 공용 사용 설정  ###
; 0000 0554         //###  2014.11.24 수정                  ###
; 0000 0555         //### 등외란과 파란의 선별수량을 합하여 ###
; 0000 0556         //### 파란 팩커의 솔 수량으로 나눠 사용 ###
; 0000 0557         //#########################################
; 0000 0558 
; 0000 0559         //솔레노이드 위치 설정
; 0000 055A         if(GRADE_DATA.gNumber[grade_result]<=0){
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x4B
	CALL __CPD01
	BRLT _0x27E
; 0000 055B             GRADE_DATA.gNumber[grade_result] = 0;
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x4D
; 0000 055C             set_bucket_data = ((GRADE_DATA.gNumber[grade_result]) % GRADE_INFO[grade_result].solenoidnumber);
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x4B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8D
; 0000 055D         }
; 0000 055E         else{
	RJMP _0x27F
_0x27E:
; 0000 055F             //PackerSharedEnable이 9보다 작으면 특정 등급이하를 파란 팩커에 담음.
; 0000 0560             if(PackerSharedEnable!=9){
	LDS  R26,_PackerSharedEnable
	CPI  R26,LOW(0x9)
	BRNE PC+2
	RJMP _0x280
; 0000 0561                 if(grade_result<PackerSharedEnable){
	LDS  R30,_PackerSharedEnable
	CP   R17,R30
	BRSH _0x281
; 0000 0562                     set_bucket_data = ((GRADE_DATA.gNumber[grade_result]-1) % GRADE_INFO[grade_result].solenoidnumber);
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x8E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8D
; 0000 0563                 }
; 0000 0564                 else{
	RJMP _0x282
_0x281:
; 0000 0565 
; 0000 0566                     eggcnt_sum = 0;
	LDI  R30,LOW(0)
	__CLRD1S 7
; 0000 0567 
; 0000 0568                     for(k=PackerSharedEnable;k<=8;k++){
	LDS  R16,_PackerSharedEnable
_0x284:
	CPI  R16,9
	BRSH _0x285
; 0000 0569                         eggcnt_sum +=  GRADE_DATA.gNumber[k];
	__POINTW2MN _GRADE_DATA,48
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x73
; 0000 056A                     }
	SUBI R16,-1
	RJMP _0x284
_0x285:
; 0000 056B 
; 0000 056C                     if(PackerSharedEnable==8){
	LDS  R26,_PackerSharedEnable
	CPI  R26,LOW(0x8)
	BRNE _0x286
; 0000 056D                         eggcnt_sum += GRADE_DATA.gNumber[g_CRACK];
	__GETD1MN _GRADE_DATA,72
	CALL SUBOPT_0x73
; 0000 056E                     }
; 0000 056F                     set_bucket_data = (eggcnt_sum-1) % GRADE_INFO[g_CRACK].solenoidnumber;
_0x286:
	__GETD1S 7
	CALL SUBOPT_0x8E
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN _GRADE_INFO,64
	LDI  R31,0
	CALL SUBOPT_0x8D
; 0000 0570 
; 0000 0571                     if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x287
; 0000 0572                         UDR1 =grade_result;            while(!(UCSR1A & 0x20));
	STS  206,R17
_0x288:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x288
; 0000 0573                         UDR1 =set_bucket_data>>8;            while(!(UCSR1A & 0x20));
	MOVW R30,R20
	CALL SUBOPT_0x79
_0x28B:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x28B
; 0000 0574                         UDR1 =set_bucket_data;            while(!(UCSR1A & 0x20));
	STS  206,R20
_0x28E:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x28E
; 0000 0575                         UDR1 =0xDF;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(223)
	STS  206,R30
_0x291:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x291
; 0000 0576                     }
; 0000 0577                 }
_0x287:
_0x282:
; 0000 0578             }
; 0000 0579             else{
	RJMP _0x294
_0x280:
; 0000 057A                 set_bucket_data = ((GRADE_DATA.gNumber[grade_result]-1) % GRADE_INFO[grade_result].solenoidnumber);
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x8E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8C
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8D
; 0000 057B                 if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x295
; 0000 057C                             UDR1 =set_bucket_data;            while(!(UCSR1A & 0x20));
	STS  206,R20
_0x296:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x296
; 0000 057D                             UDR1 =0xDC;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(220)
	STS  206,R30
_0x299:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x299
; 0000 057E                 }
; 0000 057F             }
_0x295:
_0x294:
; 0000 0580         }
_0x27F:
; 0000 0581 
; 0000 0582 
; 0000 0583         //등급 설정-수정을 요함.
; 0000 0584         //#########################################
; 0000 0585         //###  등외란-파란 팩커 공용 사용 설정  ###
; 0000 0586         //###  2014.11.24 수정                  ###
; 0000 0587         //### 등외란과 파란의 선별수량을 합하여 ###
; 0000 0588         //### 파란 팩커의 솔 수량으로 나눠 사용 ###
; 0000 0589         //#########################################
; 0000 058A          if(PackerSharedEnable!=9){
	LDS  R26,_PackerSharedEnable
	CPI  R26,LOW(0x9)
	BREQ _0x29C
; 0000 058B             if(grade_result<PackerSharedEnable){
	LDS  R30,_PackerSharedEnable
	CP   R17,R30
	BRSH _0x29D
; 0000 058C                 set_bucket_data |= (grade_result+1) <<  8;
	CALL SUBOPT_0x8F
; 0000 058D             }
; 0000 058E             else{
	RJMP _0x29E
_0x29D:
; 0000 058F                 set_bucket_data |= (g_CRACK+1) <<  8;
	ORI  R21,HIGH(1792)
; 0000 0590             }
_0x29E:
; 0000 0591          }
; 0000 0592          else
	RJMP _0x29F
_0x29C:
; 0000 0593          {
; 0000 0594             set_bucket_data |= (grade_result+1) <<  8;
	CALL SUBOPT_0x8F
; 0000 0595          }
_0x29F:
; 0000 0596 
; 0000 0597 
; 0000 0598         //인쇄설정
; 0000 0599         //19.08.14 인쇄기 다중 모드 지원 작업
; 0000 059A         //모드 0~모드7 까지 있으면
; 0000 059B         //마킹 신호 출력 + 마킹 모드 신호 출력
; 0000 059C         if(Marking_Version == 1)
	LDS  R26,_Marking_Version
	CPI  R26,LOW(0x1)
	BRNE _0x2A0
; 0000 059D         {
; 0000 059E             if(GRADE_INFO[grade_result].prttype>PRT_TYPE_NO)
	CALL SUBOPT_0x1
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x2A1
; 0000 059F             {
; 0000 05A0                 set_bucket_data |=0x1000;
	ORI  R21,HIGH(4096)
; 0000 05A1             }
; 0000 05A2         }
_0x2A1:
; 0000 05A3         else if(Marking_Version == 0)
	RJMP _0x2A2
_0x2A0:
	LDS  R30,_Marking_Version
	CPI  R30,0
	BRNE _0x2A3
; 0000 05A4         {
; 0000 05A5             if(GRADE_INFO[grade_result].prttype==PRT_TYPE_A)
	CALL SUBOPT_0x1
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x2A4
; 0000 05A6             {
; 0000 05A7                 set_bucket_data |=0x1000;
	ORI  R21,HIGH(4096)
; 0000 05A8             }
; 0000 05A9             else if(GRADE_INFO[grade_result].prttype==PRT_TYPE_B)
	RJMP _0x2A5
_0x2A4:
	CALL SUBOPT_0x1
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BRNE _0x2A6
; 0000 05AA             {
; 0000 05AB                 set_bucket_data |= 0x2000;
	ORI  R21,HIGH(8192)
; 0000 05AC             }
; 0000 05AD         }
_0x2A6:
_0x2A5:
; 0000 05AE 
; 0000 05AF 
; 0000 05B0         BucketData[MAX_LDCELL-ch-1] = set_bucket_data;
_0x2A3:
_0x2A2:
	LDD  R30,Y+29
	LDI  R31,0
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	CALL SUBOPT_0x90
	ST   Z,R20
	STD  Z+1,R21
; 0000 05B1 
; 0000 05B2 
; 0000 05B3         if(debugMode==3){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x3)
	BRNE _0x2A7
; 0000 05B4             UDR1 =set_bucket_data>>8;            while(!(UCSR1A & 0x20));
	MOVW R30,R20
	CALL SUBOPT_0x79
_0x2A8:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x2A8
; 0000 05B5             UDR1 =set_bucket_data;            while(!(UCSR1A & 0x20));
	STS  206,R20
_0x2AB:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x2AB
; 0000 05B6             UDR1 =0xDB;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(219)
	STS  206,R30
_0x2AE:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x2AE
; 0000 05B7         }
; 0000 05B8     }
_0x2A7:
; 0000 05B9 }
_0x27D:
	CALL __LOADLOCR6
	ADIW R28,30
	RET
; .FEND
;
;//선별된 데이터를 전송하기 위한 통신 버퍼 셋팅
;void COMM_TX_SET(void){
; 0000 05BC void COMM_TX_SET(void){
_COMM_TX_SET:
; .FSTART _COMM_TX_SET
; 0000 05BD     unsigned int datalen;
; 0000 05BE 
; 0000 05BF     GRADE_DATA.gSpeed = tmrSPEEDCNT;
	ST   -Y,R17
	ST   -Y,R16
;	datalen -> R16,R17
	__POINTW2MN _GRADE_DATA,184
	LDS  R30,_tmrSPEEDCNT
	LDS  R31,_tmrSPEEDCNT+1
	CLR  R22
	CLR  R23
	CALL __PUTDP1
; 0000 05C0     GRADE_DATA.gZCount  = phase_z_cnt;
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x91
; 0000 05C1 
; 0000 05C2     tmrSPEEDCNT = 0;
	CALL SUBOPT_0x92
; 0000 05C3     datalen = sizeof(GRADE_DATA);
	__GETWRN 16,17,196
; 0000 05C4     TxBuffer[0] = 0x02;
	LDI  R30,LOW(2)
	STS  _TxBuffer,R30
; 0000 05C5     TxBuffer[1] = (datalen + 2)>>8;
	MOVW R30,R16
	ADIW R30,2
	CALL SUBOPT_0x5A
; 0000 05C6     TxBuffer[2] = (datalen + 2)&0xFF;
	MOV  R30,R16
	SUBI R30,-LOW(2)
	__PUTB1MN _TxBuffer,2
; 0000 05C7     TxBuffer[3] = CMD_GRADEDATA;
	LDI  R30,LOW(160)
	__PUTB1MN _TxBuffer,3
; 0000 05C8     TxBuffer[4] = 0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5C
; 0000 05C9     memcpy(&(TxBuffer[5]), &GRADE_DATA, datalen);
	LDI  R30,LOW(_GRADE_DATA)
	LDI  R31,HIGH(_GRADE_DATA)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	CALL _memcpy
; 0000 05CA     TxBuffer[5+datalen] = 0x03;
	MOVW R30,R16
	CALL SUBOPT_0x5D
; 0000 05CB     TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
	MOVW R30,R16
	ADIW R30,6
	CALL SUBOPT_0x93
; 0000 05CC }
	RJMP _0x2060002
; .FEND
;
;//솔레노이드 출력
;void SolenoidRunning(void){
; 0000 05CF void SolenoidRunning(void){
_SolenoidRunning:
; .FSTART _SolenoidRunning
; 0000 05D0     unsigned char icnt, jcnt;
; 0000 05D1     unsigned char offtime;
; 0000 05D2 
; 0000 05D3     /*********************************************************************/
; 0000 05D4     /* New Method                                                        */
; 0000 05D5     /* pocketState = SET이면 솔레노이드 on 카운터 증가                   */
; 0000 05D6     /*                       솔레노이드 on시간이 지정된 시간이 되면 ON   */
; 0000 05D7     /*                       솔레노이드 온 이후 off카운터 시작 플래그 ON */
; 0000 05D8     /* off카운터 플래그 on이면 off카운터 시작                            */
; 0000 05D9     /*                         off카운터가 지정된 유지 시간이면 솔 off   */
; 0000 05DA     /*********************************************************************/
; 0000 05DB 
; 0000 05DC     for(icnt=0;icnt<MAX_PACKER;icnt++){
	CALL __SAVELOCR4
;	icnt -> R17
;	jcnt -> R16
;	offtime -> R19
	LDI  R17,LOW(0)
_0x2B2:
	CPI  R17,9
	BRLO PC+2
	RJMP _0x2B3
; 0000 05DD         for(jcnt=0;jcnt<MAX_SOLENOID;jcnt++){
	LDI  R16,LOW(0)
_0x2B5:
	CPI  R16,6
	BRLO PC+2
	RJMP _0x2B6
; 0000 05DE         //for(jcnt=0;jcnt<PACKER_INFO[icnt].solcount;jcnt++){
; 0000 05DF             if(pocketSTATE[icnt][jcnt]==SET){
	CALL SUBOPT_0x94
	LD   R26,X
	CPI  R26,LOW(0xA0)
	BREQ PC+2
	RJMP _0x2B7
; 0000 05E0                 sol_outcnt[icnt][jcnt]++;
	CALL SUBOPT_0x95
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 05E1                 if(SpeedAdjEnable==1){
	LDS  R26,_SpeedAdjEnable
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x2B8
; 0000 05E2                     if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt]+Sol_Correction_Count)){
	CALL SUBOPT_0x95
	LD   R18,X
	CALL SUBOPT_0x7
	CALL SUBOPT_0x96
	MOVW R26,R30
	LDS  R30,_Sol_Correction_Count
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x97
	BRLT _0x2B9
; 0000 05E3                     //if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt])){
; 0000 05E4                         if(debugMode==1){
	LDS  R26,_debugMode
	CPI  R26,LOW(0x1)
	BRNE _0x2BA
; 0000 05E5                             UDR1 =Sol_Correction_Count;            while(!(UCSR1A & 0x20));
	LDS  R30,_Sol_Correction_Count
	STS  206,R30
_0x2BB:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x2BB
; 0000 05E6                             UDR1 =0xEE;            while(!(UCSR1A & 0x20));
	LDI  R30,LOW(238)
	STS  206,R30
_0x2BE:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x2BE
; 0000 05E7                         }
; 0000 05E8                         sol_outcnt[icnt][jcnt] = 0;
_0x2BA:
	CALL SUBOPT_0x95
	CALL SUBOPT_0x98
; 0000 05E9                         sol_offcnt_on[icnt][jcnt] = 1;
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 05EA                         pocketSTATE[icnt][jcnt] = CLEAR;
	CALL SUBOPT_0x94
	LDI  R30,LOW(10)
	ST   X,R30
; 0000 05EB 
; 0000 05EC                         //팩커기동신호
; 0000 05ED                         //if(jcnt==GRADE_INFO[icnt].solenoidnumber-1){
; 0000 05EE                         if(jcnt==PACKER_INFO[icnt].solcount-1){
	CALL SUBOPT_0xC
	CALL SUBOPT_0x99
	BRNE _0x2C1
; 0000 05EF                             HolderState[icnt] = HolderRDY;
	CALL SUBOPT_0x9A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 05F0                         }
; 0000 05F1                         do_value[icnt] |= SOL_INFO[icnt].outsignal[jcnt];
_0x2C1:
	CALL SUBOPT_0x9B
	CALL SUBOPT_0x3
	LD   R30,X
	OR   R30,R18
	MOVW R26,R22
	ST   X,R30
; 0000 05F2                     }
; 0000 05F3                 }
_0x2B9:
; 0000 05F4                 else if(SpeedAdjEnable==0){
	RJMP _0x2C2
_0x2B8:
	LDS  R30,_SpeedAdjEnable
	CPI  R30,0
	BRNE _0x2C3
; 0000 05F5                     //if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt]+Sol_Correction_Count)){
; 0000 05F6 
; 0000 05F7                     if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt])){
	CALL SUBOPT_0x95
	LD   R18,X
	CALL SUBOPT_0x7
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
	BRLT _0x2C4
; 0000 05F8                         sol_outcnt[icnt][jcnt] = 0;
	CALL SUBOPT_0x95
	CALL SUBOPT_0x98
; 0000 05F9                         sol_offcnt_on[icnt][jcnt] = 1;
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 05FA                         pocketSTATE[icnt][jcnt] = CLEAR;
	CALL SUBOPT_0x94
	LDI  R30,LOW(10)
	ST   X,R30
; 0000 05FB                         if(debugMode==1){
; 0000 05FC                             //UDR1 =Sol_Correction_Count;            while(!(UCSR1A & 0x20));
; 0000 05FD                             //UDR1 =0xDD;                            while(!(UCSR1A & 0x20));
; 0000 05FE                         }
; 0000 05FF                         //팩커기동신호
; 0000 0600                         //if(jcnt==GRADE_INFO[icnt].solenoidnumber-1){
; 0000 0601                         if(jcnt==PACKER_INFO[icnt].solcount-1){
	CALL SUBOPT_0xC
	CALL SUBOPT_0x99
	BRNE _0x2C6
; 0000 0602                             HolderState[icnt] = HolderRDY;
	CALL SUBOPT_0x9A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 0603                         }
; 0000 0604                         do_value[icnt] |= SOL_INFO[icnt].outsignal[jcnt];
_0x2C6:
	CALL SUBOPT_0x9B
	CALL SUBOPT_0x3
	LD   R30,X
	OR   R30,R18
	MOVW R26,R22
	ST   X,R30
; 0000 0605                     }
; 0000 0606                 }
_0x2C4:
; 0000 0607             }
_0x2C3:
_0x2C2:
; 0000 0608             if(sol_offcnt_on[icnt][jcnt]){
_0x2B7:
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sol_offcnt_on)
	SBCI R31,HIGH(-_sol_offcnt_on)
	CALL SUBOPT_0x3
	LD   R30,X
	CPI  R30,0
	BREQ _0x2C7
; 0000 0609                 sol_offcnt[icnt][jcnt]++;
	CALL SUBOPT_0x9C
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 060A 
; 0000 060B                 if(sol_offcnt[icnt][jcnt]>=(SOL_INFO[icnt].offtime[jcnt])){
	CALL SUBOPT_0x9C
	LD   R18,X
	LDI  R26,LOW(48)
	MUL  R17,R26
	MOVW R30,R0
	CALL SUBOPT_0x9
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
	BRLT _0x2C8
; 0000 060C                     do_value[icnt] &= ~SOL_INFO[icnt].outsignal[jcnt];
	CALL SUBOPT_0x9B
	CALL SUBOPT_0x3
	LD   R30,X
	COM  R30
	AND  R30,R18
	MOVW R26,R22
	ST   X,R30
; 0000 060D                     sol_offcnt[icnt][jcnt] = 0;
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x98
; 0000 060E                     sol_offcnt_on[icnt][jcnt]=0;
	ST   X,R30
; 0000 060F 
; 0000 0610                     //홀더 기동신호 출력ON
; 0000 0611                     if(jcnt==(PACKER_INFO[icnt].solcount-1)){
	CALL SUBOPT_0xC
	CALL SUBOPT_0x99
	BRNE _0x2C9
; 0000 0612                         if(HolderState[icnt] == HolderRDY){
	CALL SUBOPT_0x9A
	CALL __GETW1P
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2CA
; 0000 0613                             HolderOnTime[icnt] = 0;
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x42
; 0000 0614                             HolderState[icnt] = HolderON;
	CALL SUBOPT_0x9A
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0615                             do_value[icnt] |= HOLDER_ON_SNG;
	MOV  R26,R17
	CALL SUBOPT_0x9E
	ORI  R30,0x80
	ST   X,R30
; 0000 0616                         }
; 0000 0617                     }
_0x2CA:
; 0000 0618                 }
_0x2C9:
; 0000 0619             }
_0x2C8:
; 0000 061A         }
_0x2C7:
	SUBI R16,-1
	RJMP _0x2B5
_0x2B6:
; 0000 061B 
; 0000 061C         //홀더 기동신호 일정시간후 off
; 0000 061D         if(HolderState[icnt]==HolderON){
	CALL SUBOPT_0x9A
	CALL __GETW1P
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2CB
; 0000 061E             HolderOnTime[icnt]++;
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x57
; 0000 061F             if(HolderOnTime[icnt] > 10){
	CALL SUBOPT_0x9D
	CALL __GETW1P
	SBIW R30,11
	BRLO _0x2CC
; 0000 0620                 do_value[icnt] &= ~HOLDER_ON_SNG;
	MOV  R26,R17
	CALL SUBOPT_0x9E
	ANDI R30,0x7F
	ST   X,R30
; 0000 0621                 HolderState[icnt] = HolderOFF;
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x42
; 0000 0622             }
; 0000 0623         }
_0x2CC:
; 0000 0624     }
_0x2CB:
	SUBI R17,-1
	RJMP _0x2B2
_0x2B3:
; 0000 0625 
; 0000 0626 
; 0000 0627     //인쇄기 7타입 모 출력 셋팅
; 0000 0628     if(Marking_Version == 1)
	LDS  R26,_Marking_Version
	CPI  R26,LOW(0x1)
	BRNE _0x2CD
; 0000 0629     {
; 0000 062A             if(PRT_A_OUT==SET)
	LDS  R26,_PRT_A_OUT
	CPI  R26,LOW(0xA0)
	BRNE _0x2CE
; 0000 062B             {
; 0000 062C                 prt_a_outcnt++;
	CALL SUBOPT_0x9F
; 0000 062D                 if(prt_a_outcnt>=PRT_INFO[1].ontime)
	BRLT _0x2CF
; 0000 062E                 {
; 0000 062F                     prt_a_outcnt = 0;
	CALL SUBOPT_0xA0
; 0000 0630                     PRT_A_OUT=CLEAR;
; 0000 0631                     prt_a_off_enable =1;
; 0000 0632                     plc_prt_value |= PRT_A_ON;
; 0000 0633                     //2019.08.13 update
; 0000 0634                     //마킹모드 추가 출력
; 0000 0635                     plc_prt_value |= Marking_MOUT;
	LDS  R30,_Marking_MOUT
	LDS  R26,_plc_prt_value
	OR   R30,R26
	STS  _plc_prt_value,R30
; 0000 0636                 }
; 0000 0637             }
_0x2CF:
; 0000 0638         if(prt_a_off_enable==1)
_0x2CE:
	LDS  R26,_prt_a_off_enable
	CPI  R26,LOW(0x1)
	BRNE _0x2D0
; 0000 0639         {
; 0000 063A             prt_a_offcnt++;
	CALL SUBOPT_0xA1
; 0000 063B             if(prt_a_offcnt>=PRT_INFO[1].offtime)
	BRLT _0x2D1
; 0000 063C             {
; 0000 063D                 prt_a_offcnt = 0;
	CALL SUBOPT_0xA2
; 0000 063E                 plc_prt_value &= ~PRT_A_ON;
; 0000 063F                 plc_prt_value &= ~Marking_MOUT;
	LDS  R30,_Marking_MOUT
	CALL SUBOPT_0xA3
	STS  _plc_prt_value,R30
; 0000 0640                 prt_a_off_enable = 0;
	LDI  R30,LOW(0)
	STS  _prt_a_off_enable,R30
; 0000 0641             }
; 0000 0642         }
_0x2D1:
; 0000 0643     }
_0x2D0:
; 0000 0644     else if(Marking_Version == 0)
	RJMP _0x2D2
_0x2CD:
	LDS  R30,_Marking_Version
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2D3
; 0000 0645     {
; 0000 0646         if(PRT_A_OUT==SET) //인쇄기 A타입 출력 셋팅
	LDS  R26,_PRT_A_OUT
	CPI  R26,LOW(0xA0)
	BRNE _0x2D4
; 0000 0647         {
; 0000 0648             prt_a_outcnt++;
	CALL SUBOPT_0x9F
; 0000 0649             if(prt_a_outcnt>=PRT_INFO[1].ontime)
	BRLT _0x2D5
; 0000 064A             {
; 0000 064B                 prt_a_outcnt = 0;
	CALL SUBOPT_0xA0
; 0000 064C                 PRT_A_OUT=CLEAR;
; 0000 064D                 prt_a_off_enable =1;
; 0000 064E                 plc_prt_value |= PRT_A_ON;
; 0000 064F 
; 0000 0650             }
; 0000 0651         }
_0x2D5:
; 0000 0652 
; 0000 0653         if(prt_a_off_enable==1)
_0x2D4:
	LDS  R26,_prt_a_off_enable
	CPI  R26,LOW(0x1)
	BRNE _0x2D6
; 0000 0654         {
; 0000 0655             prt_a_offcnt++;
	CALL SUBOPT_0xA1
; 0000 0656             if(prt_a_offcnt>=PRT_INFO[1].offtime)
	BRLT _0x2D7
; 0000 0657             {
; 0000 0658                 prt_a_offcnt = 0;
	CALL SUBOPT_0xA2
; 0000 0659                 plc_prt_value &= ~PRT_A_ON;
; 0000 065A                 prt_a_off_enable = 0;
	LDI  R30,LOW(0)
	STS  _prt_a_off_enable,R30
; 0000 065B             }
; 0000 065C         }
_0x2D7:
; 0000 065D         if(PRT_B_OUT==SET)//인쇄기 B타입 출력 셋팅
_0x2D6:
	LDS  R26,_PRT_B_OUT
	CPI  R26,LOW(0xA0)
	BRNE _0x2D8
; 0000 065E         {
; 0000 065F             prt_b_outcnt++;
	LDS  R30,_prt_b_outcnt
	SUBI R30,-LOW(1)
	STS  _prt_b_outcnt,R30
; 0000 0660             if(prt_b_outcnt>=PRT_INFO[2].ontime)
	__GETW1MN _PRT_INFO,12
	LDS  R26,_prt_b_outcnt
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x2D9
; 0000 0661             {
; 0000 0662                 prt_b_outcnt = 0;
	LDI  R30,LOW(0)
	STS  _prt_b_outcnt,R30
; 0000 0663                 PRT_B_OUT=CLEAR;
	LDI  R30,LOW(10)
	STS  _PRT_B_OUT,R30
; 0000 0664                 prt_b_off_enable =1;
	LDI  R30,LOW(1)
	STS  _prt_b_off_enable,R30
; 0000 0665                 plc_prt_value |= PRT_B_ON;
	LDS  R30,_plc_prt_value
	ORI  R30,0x20
	STS  _plc_prt_value,R30
; 0000 0666             }
; 0000 0667         }
_0x2D9:
; 0000 0668 
; 0000 0669         if(prt_b_off_enable==1)
_0x2D8:
	LDS  R26,_prt_b_off_enable
	CPI  R26,LOW(0x1)
	BRNE _0x2DA
; 0000 066A         {
; 0000 066B             prt_b_offcnt++;
	LDS  R30,_prt_b_offcnt
	SUBI R30,-LOW(1)
	STS  _prt_b_offcnt,R30
; 0000 066C             if(prt_b_offcnt>=PRT_INFO[2].offtime)
	__GETW1MN _PRT_INFO,14
	LDS  R26,_prt_b_offcnt
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x2DB
; 0000 066D             {
; 0000 066E                 prt_b_offcnt = 0;
	LDI  R30,LOW(0)
	STS  _prt_b_offcnt,R30
; 0000 066F                 plc_prt_value &= ~PRT_B_ON;
	LDS  R30,_plc_prt_value
	ANDI R30,0xDF
	STS  _plc_prt_value,R30
; 0000 0670                 prt_b_off_enable = 0;
	LDI  R30,LOW(0)
	STS  _prt_b_off_enable,R30
; 0000 0671             }
; 0000 0672         }
_0x2DB:
; 0000 0673     }
_0x2DA:
; 0000 0674 
; 0000 0675     SOL_CH1 = do_value[0];
_0x2D3:
_0x2D2:
	CALL SUBOPT_0xA4
; 0000 0676     SOL_CH2 = do_value[1];
	CALL SUBOPT_0xA5
; 0000 0677     SOL_CH3 = do_value[2];
	CALL SUBOPT_0xA6
; 0000 0678     SOL_CH4 = do_value[3];
	CALL SUBOPT_0xA7
; 0000 0679     SOL_CH5 = do_value[4];
	CALL SUBOPT_0xA8
; 0000 067A     SOL_CH6 = do_value[5];
	CALL SUBOPT_0xA9
; 0000 067B     SOL_CH7 = do_value[6];
	CALL SUBOPT_0xAA
; 0000 067C     PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 067D }
	RJMP _0x2060001
; .FEND
;
;//가상 버켓 이동
;void MovingBucket(void){
; 0000 0680 void MovingBucket(void){
_MovingBucket:
; .FSTART _MovingBucket
; 0000 0681     int lcnt;
; 0000 0682 
; 0000 0683     for(lcnt=MAX_BUCKET;lcnt>=0;lcnt--){
	ST   -Y,R17
	ST   -Y,R16
;	lcnt -> R16,R17
	__GETWRN 16,17,300
_0x2DD:
	TST  R17
	BRMI _0x2DE
; 0000 0684         if(lcnt != 0 )  {    BucketData[lcnt] = BucketData[lcnt-1];  BucketData_Wight[lcnt] = BucketData_Wight[lcnt-1];  ...
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x2DF
	CALL SUBOPT_0x41
	MOVW R0,R30
	MOVW R30,R16
	CALL SUBOPT_0xAC
	CALL SUBOPT_0x77
	CALL SUBOPT_0x8A
	MOVW R0,R30
	MOVW R30,R16
	SBIW R30,1
	CALL SUBOPT_0xAD
	CALL __GETW1P
	MOVW R26,R0
	RJMP _0x4C8
; 0000 0685         else            {    BucketData[lcnt] = BucketInitValue; BucketData_Wight[lcnt] = BucketInitValue;        }
_0x2DF:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x42
	MOVW R30,R16
	CALL SUBOPT_0xAD
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4C8:
	ST   X+,R30
	ST   X,R31
; 0000 0686     }
	__SUBWRN 16,17,1
	RJMP _0x2DD
_0x2DE:
; 0000 0687 }
_0x2060002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;//출력할 솔레노이드 위치 설정
;void MaskingBucket(void){
; 0000 068A void MaskingBucket(void){
_MaskingBucket:
; .FSTART _MaskingBucket
; 0000 068B 
; 0000 068C     unsigned char icnt;
; 0000 068D     unsigned int prtchk;
; 0000 068E     unsigned char tmpgrade;
; 0000 068F 
; 0000 0690     //2014.11.24수정 :: 모든 등급을 인쇄함.
; 0000 0691     //PRT Type A Setting
; 0000 0692     //2019.08.13 수정 :: 인쇄 모드를 8가지로 구분함.
; 0000 0693     //마킹기 신호 체계 == 마킹 신호 + 마킹 모드 선택 신호
; 0000 0694     //-----------------------------------------------------
; 0000 0695     // Grading Value Bit Table
; 0000 0696     // 0000 | 0000 | 0000 | 0000
; 0000 0697     //--------------------------
; 0000 0698     //   |      |     |       |-> Solenoid Position || Low Nibble
; 0000 0699     //   |      |     |---------> Solenoid Position || High Nibble
; 0000 069A     //   |      |---------------> Grade Position
; 0000 069B     //   |----------------------> Crack/DOT Info, PRT TYPE || 00:CLean, 01:CRACK(0x8000), 02:DOT(0x4000), 00:NONE, 01:PR ...
; 0000 069C 
; 0000 069D     //UDR1 = tmpgrade;            while(!(UCSR1A & 0x20));
; 0000 069E 
; 0000 069F     if(Marking_Version == 1)
	CALL __SAVELOCR4
;	icnt -> R17
;	prtchk -> R18,R19
;	tmpgrade -> R16
	LDS  R26,_Marking_Version
	CPI  R26,LOW(0x1)
	BRNE _0x2E1
; 0000 06A0     {   //NEW_MARKING_VERSION
; 0000 06A1         prtchk = (BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ]>>12)&0x0003;
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xAF
; 0000 06A2         tmpgrade = (BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ] >> 8) & 0x000F;
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xB0
	ANDI R30,LOW(0xF)
	MOV  R16,R30
; 0000 06A3         if(prtchk == 0x0001)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2E2
; 0000 06A4         {
; 0000 06A5            PRT_A_OUT = SET;
	LDI  R30,LOW(160)
	STS  _PRT_A_OUT,R30
; 0000 06A6            Marking_MOUT = Marking_MOUT_SNG[GRADE_INFO[tmpgrade-1].prttype];
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	__ADDW1MN _GRADE_INFO,5
	LD   R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_Marking_MOUT_SNG)
	SBCI R31,HIGH(-_Marking_MOUT_SNG)
	LD   R30,Z
	STS  _Marking_MOUT,R30
; 0000 06A7            BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ] &= 0x0FFF;
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xB1
; 0000 06A8         }
; 0000 06A9     }
_0x2E2:
; 0000 06AA     else if(Marking_Version == 0)
	RJMP _0x2E3
_0x2E1:
	LDS  R30,_Marking_Version
	CPI  R30,0
	BRNE _0x2E4
; 0000 06AB     {
; 0000 06AC     //2014.11.24수정 :: 모든 등급을 인쇄함. OLD_MARKING_VERSION
; 0000 06AD     //PRT Type A Setting
; 0000 06AE         prtchk = (BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ]>>12)&0x0003;
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xAF
; 0000 06AF         if(prtchk == 0x0001)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2E5
; 0000 06B0         {
; 0000 06B1             PRT_A_OUT = SET;
	LDI  R30,LOW(160)
	STS  _PRT_A_OUT,R30
; 0000 06B2             BucketData[PRT_INFO[PRT_TYPE_A].startpocketnumber ] &= 0x0FFF;
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xB1
; 0000 06B3         }
; 0000 06B4 
; 0000 06B5     //PRT Type B Setting
; 0000 06B6         prtchk = (BucketData[PRT_INFO[PRT_TYPE_B].startpocketnumber ]>>12)&0x0003;
_0x2E5:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xAF
; 0000 06B7         if(prtchk == 0x0002)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2E6
; 0000 06B8         {
; 0000 06B9             PRT_B_OUT = SET;
	LDI  R30,LOW(160)
	STS  _PRT_B_OUT,R30
; 0000 06BA             BucketData[ PRT_INFO[PRT_TYPE_B].startpocketnumber ] &= 0x0FFF;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xB1
; 0000 06BB         }
; 0000 06BC     }
_0x2E6:
; 0000 06BD 
; 0000 06BE     //각 스테이션마다 솔레노이드 ID와 비교, 값이 같으면 출력 셋
; 0000 06BF     for(icnt = 0; icnt <MAX_PACKER;icnt++){
_0x2E4:
_0x2E3:
	LDI  R17,LOW(0)
_0x2E8:
	CPI  R17,9
	BRLO PC+2
	RJMP _0x2E9
; 0000 06C0         if((BucketData[ PACKER_INFO[icnt].startpocketnumber-5 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[5] ){ pocketSTATE[icn ...
	CALL SUBOPT_0xC
	CALL SUBOPT_0xB3
	CALL SUBOPT_0xB4
	__ADDW1MN _SOL_INFO,46
	CALL SUBOPT_0xB5
	BRNE _0x2EA
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _pocketSTATE,5
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB3
	CALL SUBOPT_0x42
; 0000 06C1         if((BucketData[ PACKER_INFO[icnt].startpocketnumber-4 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[4] ){ pocketSTATE[icn ...
_0x2EA:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xB4
	__ADDW1MN _SOL_INFO,44
	CALL SUBOPT_0xB5
	BRNE _0x2EB
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _pocketSTATE,4
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x42
; 0000 06C2         if((BucketData[ PACKER_INFO[icnt].startpocketnumber-3 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[3] ){ pocketSTATE[icn ...
_0x2EB:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xB4
	__ADDW1MN _SOL_INFO,42
	CALL SUBOPT_0xB5
	BRNE _0x2EC
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _pocketSTATE,3
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x42
; 0000 06C3         if((BucketData[ PACKER_INFO[icnt].startpocketnumber-2 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[2] ){ pocketSTATE[icn ...
_0x2EC:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xB4
	__ADDW1MN _SOL_INFO,40
	CALL SUBOPT_0xB5
	BRNE _0x2ED
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _pocketSTATE,2
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB9
	CALL SUBOPT_0x42
; 0000 06C4         if((BucketData[ PACKER_INFO[icnt].startpocketnumber-1 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[1] ){ pocketSTATE[icn ...
_0x2ED:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xB4
	__ADDW1MN _SOL_INFO,38
	CALL SUBOPT_0xB5
	BRNE _0x2EE
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _pocketSTATE,1
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xBA
	CALL SUBOPT_0x42
; 0000 06C5         if((BucketData[ PACKER_INFO[icnt].startpocketnumber-0 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[0] ){ pocketSTATE[icn ...
_0x2EE:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xB4
	__ADDW1MN _SOL_INFO,36
	CALL SUBOPT_0xB5
	BRNE _0x2EF
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_pocketSTATE)
	SBCI R31,HIGH(-_pocketSTATE)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xBB
	CALL SUBOPT_0x42
; 0000 06C6     }
_0x2EF:
	SUBI R17,-1
	RJMP _0x2E8
_0x2E9:
; 0000 06C7 }
_0x2060001:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void LoadParameter(void)
; 0000 06CA {
_LoadParameter:
; .FSTART _LoadParameter
; 0000 06CB     unsigned char icnt;
; 0000 06CC 
; 0000 06CD     //unsigned int  sol_id[MAX_SOLENOID] = {0x0000,0x0001,0x0002,0x0003,0x0004,0x0005};
; 0000 06CE     //unsigned int  sol_packer[MAX_PACKER] = {0x0400,0x0100,0x0600,0x0200,0x0500,0x0300,0x0700};
; 0000 06CF     //unsigned int  sol_ontime[MAX_SOLENOID] = {24,32,38,44,50,56};
; 0000 06D0     //unsigned int  sol_offtime[MAX_SOLENOID] = {10,16,22,28,34,40};
; 0000 06D1     //unsigned int  sol_ontime[MAX_SOLENOID] = {7,11,15,19,23,27};
; 0000 06D2     //unsigned int  sol_offtime[MAX_SOLENOID] = {50,50,50,50,50,50};
; 0000 06D3     //unsigned int  startpocketnumber[MAX_PACKER] = {19,29,47,56,69,78,95,104};
; 0000 06D4     unsigned int  iconstvalue[MAX_LDCELL]={294,294,294,294,294,294};
; 0000 06D5     //unsigned int grade_hilimit[MAX_GRADE]={850,679,599,519,479,419,0,0,851};
; 0000 06D6     //unsigned int grade_lolimit[MAX_GRADE]={680,600,520,480,420,320,0,0,321};
; 0000 06D7 
; 0000 06D8     GET_USR_INFO_DATA(GRADE_INFO_DATA);
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2F0*2)
	LDI  R31,HIGH(_0x2F0*2)
	CALL __INITLOCB
	ST   -Y,R17
;	icnt -> R17
;	iconstvalue -> Y+1
	LDI  R26,LOW(11)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06D9     GET_USR_INFO_DATA(SOL_INFO_DATA);
	LDI  R26,LOW(12)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06DA     GET_USR_INFO_DATA(PACKER_INFO_DATA);
	LDI  R26,LOW(13)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06DB     GET_USR_INFO_DATA(LDCELL_INFO_DATA);
	LDI  R26,LOW(14)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06DC     GET_USR_INFO_DATA(MEASURE_INFO_DATA);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06DD     GET_USR_INFO_DATA(PRT_INFO_DATA);
	LDI  R26,LOW(16)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06DE     GET_USR_INFO_DATA(SYS_INFO_DATA);
	LDI  R26,LOW(17)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06DF     GET_USR_INFO_DATA(ABN_INFO_DATA);
	LDI  R26,LOW(19)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 06E0 
; 0000 06E1     for(icnt=0;icnt<MAX_LDCELL;icnt++){
	LDI  R17,LOW(0)
_0x2F2:
	CPI  R17,6
	BRSH _0x2F3
; 0000 06E2         if(LDCELL_INFO[icnt].span==0 || LDCELL_INFO[icnt].span==0xFF){
	CALL SUBOPT_0xD
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2F5
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0x2F4
_0x2F5:
; 0000 06E3             ConstWeight[icnt] = iconstvalue[icnt];
	MOV  R30,R17
	LDI  R26,LOW(_ConstWeight)
	LDI  R27,HIGH(_ConstWeight)
	CALL SUBOPT_0xA
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0xB
	CALL SUBOPT_0xBC
; 0000 06E4             LDCELL_INFO[icnt].span = ConstWeight[icnt];
	CALL SUBOPT_0xD
	MOVW R0,R30
	MOV  R30,R17
	LDI  R26,LOW(_ConstWeight)
	LDI  R27,HIGH(_ConstWeight)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL __GETW1P
	MOVW R26,R0
	RJMP _0x4C9
; 0000 06E5         }
; 0000 06E6         else{
_0x2F4:
; 0000 06E7             ConstWeight[icnt] = LDCELL_INFO[icnt].span;
	MOV  R30,R17
	LDI  R26,LOW(_ConstWeight)
	LDI  R27,HIGH(_ConstWeight)
	CALL SUBOPT_0xA
	MOVW R22,R30
	CALL SUBOPT_0xD
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R22
_0x4C9:
	ST   X+,R30
	ST   X,R31
; 0000 06E8         }
; 0000 06E9         //로딩 초기 영점값을 강제 설정해줌.
; 0000 06EA         //영점을 후단에서 측정함에 따라 최초 실행시 0으로 설정되어 -31g이 1회 잡힘.
; 0000 06EB         //zero_value[icnt]=1400;
; 0000 06EC     }
	SUBI R17,-1
	RJMP _0x2F2
_0x2F3:
; 0000 06ED 
; 0000 06EE     if(SYS_INFO.z_encoder_interval!=360 || SYS_INFO.z_encoder_interval!=600){
	CALL SUBOPT_0xBD
	CPI  R26,LOW(0x168)
	LDI  R30,HIGH(0x168)
	CPC  R27,R30
	BRNE _0x2F9
	CALL SUBOPT_0xBD
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BREQ _0x2F8
_0x2F9:
; 0000 06EF         SYS_INFO.bucket_ref_pulse_cnt = 60;
	LDI  R30,LOW(60)
	__PUTB1MN _SYS_INFO,11
; 0000 06F0         SYS_INFO.z_encoder_min_interval= 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	__PUTW1MN _SYS_INFO,9
; 0000 06F1         SYS_INFO.z_encoder_interval = 360;
	CALL SUBOPT_0x17
; 0000 06F2     }
; 0000 06F3 
; 0000 06F4     //왕란 등급 상한값이 55g이하로 설정되어있으면 등외 상한값보다 0.1g작게 설정되도록 함.
; 0000 06F5     if(GRADE_INFO[0].hiLimit<550){
_0x2F8:
	LDS  R26,_GRADE_INFO
	LDS  R27,_GRADE_INFO+1
	CPI  R26,LOW(0x226)
	LDI  R30,HIGH(0x226)
	CPC  R27,R30
	BRGE _0x2FB
; 0000 06F6         GRADE_INFO[0].hiLimit = GRADE_INFO[g_ETC].hiLimit -1;
	CALL SUBOPT_0xBE
; 0000 06F7     }
; 0000 06F8 
; 0000 06F9 
; 0000 06FA }
_0x2FB:
	LDD  R17,Y+0
	ADIW R28,13
	RET
; .FEND
;
;void SaveParameter(void){
; 0000 06FC void SaveParameter(void){
; 0000 06FD     //초기값 메모리 저장
; 0000 06FE     PUT_USR_INFO_DATA(GRADE_INFO_DATA);
; 0000 06FF     PUT_USR_INFO_DATA(SOL_INFO_DATA);
; 0000 0700     PUT_USR_INFO_DATA(PACKER_INFO_DATA);
; 0000 0701     PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
; 0000 0702     PUT_USR_INFO_DATA(MEASURE_INFO_DATA);
; 0000 0703     PUT_USR_INFO_DATA(PRT_INFO_DATA);
; 0000 0704     PUT_USR_INFO_DATA(SYS_INFO_DATA);
; 0000 0705 }
;
;void ETC_PARAMETER_SETTING(void){
; 0000 0707 void ETC_PARAMETER_SETTING(void){
_ETC_PARAMETER_SETTING:
; .FSTART _ETC_PARAMETER_SETTING
; 0000 0708     //ETC Parameter Initialize
; 0000 0709     weight_ad_end_pulse = MEASURE_INFO.ad_start_pulse  + MEASURE_INFO.duringcount;
	__GETW1MN _MEASURE_INFO,2
	CALL SUBOPT_0x43
	ADD  R30,R26
	ADC  R31,R27
	STS  _weight_ad_end_pulse,R30
	STS  _weight_ad_end_pulse+1,R31
; 0000 070A     weight_cal_end_pulse = weight_ad_end_pulse + MAX_LDCELL;
	ADIW R30,6
	STS  _weight_cal_end_pulse,R30
	STS  _weight_cal_end_pulse+1,R31
; 0000 070B 
; 0000 070C     zero_ad_end_pulse = MEASURE_INFO.zeroposition + ZeroMeasurePulse;
	__GETW1MN _MEASURE_INFO,4
	ADIW R30,10
	STS  _zero_ad_end_pulse,R30
	STS  _zero_ad_end_pulse+1,R31
; 0000 070D     zero_cal_end_pulse = zero_ad_end_pulse + MAX_LDCELL;
	ADIW R30,6
	STS  _zero_cal_end_pulse,R30
	STS  _zero_cal_end_pulse+1,R31
; 0000 070E 
; 0000 070F     correct_data_end_pulse = weight_cal_end_pulse + MAX_LDCELL;
	LDS  R30,_weight_cal_end_pulse
	LDS  R31,_weight_cal_end_pulse+1
	ADIW R30,6
	STS  _correct_data_end_pulse,R30
	STS  _correct_data_end_pulse+1,R31
; 0000 0710 
; 0000 0711     ConvertPosition = correct_data_end_pulse + 2;                                 //재정의 필요
	ADIW R30,2
	STS  _ConvertPosition,R30
	STS  _ConvertPosition+1,R31
; 0000 0712     convert_end_pulse = ConvertPosition + MAX_LDCELL;
	ADIW R30,6
	STS  _convert_end_pulse,R30
	STS  _convert_end_pulse+1,R31
; 0000 0713     GradingPosition =  340;                                     //Fixed Value-최소한 330펄스이후에 분류작업
	LDI  R30,LOW(340)
	LDI  R31,HIGH(340)
	STS  _GradingPosition,R30
	STS  _GradingPosition+1,R31
; 0000 0714     grading_end_pulse = GradingPosition+MAX_LDCELL;
	ADIW R30,6
	STS  _grading_end_pulse,R30
	STS  _grading_end_pulse+1,R31
; 0000 0715 
; 0000 0716     crackchk_end_pulse = MEASURE_INFO.crackchecktime + 30;
	CALL SUBOPT_0xBF
	ADIW R30,30
	STS  _crackchk_end_pulse,R30
	STS  _crackchk_end_pulse+1,R31
; 0000 0717 
; 0000 0718     //2014.03.10 :: 수정사항
; 0000 0719     //보정단계를 보정값과 동일하게 :: 50보정이면 50단계
; 0000 071A     //보정시간 단위 : 50보정이면
; 0000 071B     unit_correct = SYS_INFO.correction / SYS_INFO.correction;
	__GETB2MN _SYS_INFO,4
	__GETB1MN _SYS_INFO,4
	CALL __DIVB21U
	STS  _unit_correct,R30
; 0000 071C     unit_rising = (SYS_INFO.risingTime / SYS_INFO.correction)/timer_period;
	__GETB1MN _SYS_INFO,4
	LDI  R31,0
	LDS  R26,_SYS_INFO
	LDS  R27,_SYS_INFO+1
	CALL SUBOPT_0xC0
	STS  _unit_rising,R30
; 0000 071D     unit_falling = (SYS_INFO.fallingTime / SYS_INFO.correction)/timer_period;
	__GETW2MN _SYS_INFO,2
	__GETB1MN _SYS_INFO,4
	LDI  R31,0
	CALL SUBOPT_0xC0
	STS  _unit_falling,R30
; 0000 071E 
; 0000 071F     //감속보정 지연
; 0000 0720     DelayTimeCount = SYS_INFO.DeAccelDelayTime / 5;
	__GETW2MN _SYS_INFO,15
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __DIVW21
	STS  _DelayTimeCount,R30
	STS  _DelayTimeCount+1,R31
; 0000 0721     deAccelStartCount = SYS_INFO.DeAccelDelayCount;
	__GETW1MN _SYS_INFO,13
	STS  _deAccelStartCount,R30
	STS  _deAccelStartCount+1,R31
; 0000 0722 
; 0000 0723     //파란 측정 시간이 0이면 파란, 오란 측정안함.
; 0000 0724     if(MEASURE_INFO.crackchecktime == 0){
	CALL SUBOPT_0xBF
	SBIW R30,0
	BRNE _0x2FC
; 0000 0725         Crack_Dot_Chk_Enable = 0;
	LDI  R30,LOW(0)
	STS  _Crack_Dot_Chk_Enable,R30
; 0000 0726     }
; 0000 0727 }
_0x2FC:
	RET
; .FEND
;
;void Initialize_SYSTEM(void){
; 0000 0729 void Initialize_SYSTEM(void){
_Initialize_SYSTEM:
; .FSTART _Initialize_SYSTEM
; 0000 072A     unsigned char icnt, rtn, id_value, direction_chk, jcnt;
; 0000 072B     unsigned int lcnt;
; 0000 072C 
; 0000 072D     //Load Parameter
; 0000 072E 
; 0000 072F     //Bucket Clear
; 0000 0730     for(lcnt = 0;lcnt<MAX_BUCKET;lcnt++){
	SBIW R28,2
	CALL __SAVELOCR6
;	icnt -> R17
;	rtn -> R16
;	id_value -> R19
;	direction_chk -> R18
;	jcnt -> R21
;	lcnt -> Y+6
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x2FE:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRSH _0x2FF
; 0000 0731         BucketData[lcnt] = BucketInitValue;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	CALL SUBOPT_0xB
	CALL SUBOPT_0x42
; 0000 0732         BucketData_Wight[icnt] = BucketInitValue;
	MOV  R30,R17
	LDI  R26,LOW(_BucketData_Wight)
	LDI  R27,HIGH(_BucketData_Wight)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0x42
; 0000 0733     }
	CALL SUBOPT_0xC1
	RJMP _0x2FE
_0x2FF:
; 0000 0734 
; 0000 0735     //Flash memory check
; 0000 0736     SPI_Init();
	CALL _SPI_Init
; 0000 0737     rtn = GetDeviceID();        //Memory Device ID Check
	CALL _GetDeviceID
	MOV  R16,R30
; 0000 0738     if(rtn){    //Device ID Check OK :: Load Data
	CPI  R16,0
	BREQ _0x300
; 0000 0739         LoadParameter();
	RCALL _LoadParameter
; 0000 073A         //Initailize_PARAMETER();
; 0000 073B         //SaveParameter();
; 0000 073C 
; 0000 073D         if(SYS_INFO.chkCODE!=MEM_CHK_CODE){
	__GETB2MN _SYS_INFO,12
	CPI  R26,LOW(0x13)
	BREQ _0x301
; 0000 073E             Initailize_PARAMETER();
	CALL _Initailize_PARAMETER
; 0000 073F         }
; 0000 0740     }
_0x301:
; 0000 0741     else{       //Device ID Check Fail :: 공장 초기값으로 데이터 로드
	RJMP _0x302
_0x300:
; 0000 0742         Initailize_PARAMETER();
	CALL _Initailize_PARAMETER
; 0000 0743     }
_0x302:
; 0000 0744 
; 0000 0745     //측정점, 영점, 분류위치등 타이밍 셋팅
; 0000 0746     ETC_PARAMETER_SETTING();
	RCALL _ETC_PARAMETER_SETTING
; 0000 0747 
; 0000 0748     //Controller ID Setting
; 0000 0749     //ID Value 0 then CONTROLLER #1 and REMOTE CONTROLL
; 0000 074A     //ID Value 1 then CONTROLLER #2 and REMOTE CONTROLL
; 0000 074B     //ID Value 2 then CONTROLLER #1 and AUTO RUN
; 0000 074C     //ID Value 3 then CONTROLLER #2 and AUTO RUN
; 0000 074D     id_value = (~MACHINE_ID1 <<1) | ~MACHINE_ID0;
	LDI  R26,0
	SBIS 0x9,7
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R30
	LDI  R30,0
	SBIS 0x9,6
	LDI  R30,1
	OR   R30,R26
	MOV  R19,R30
; 0000 074E 
; 0000 074F     if(id_value == 0 || id_value == 2){
	CPI  R19,0
	BREQ _0x304
	CPI  R19,2
	BRNE _0x303
_0x304:
; 0000 0750         CONTROLLER_ID =  0x01;
	LDI  R30,LOW(1)
	RJMP _0x4CA
; 0000 0751     }
; 0000 0752     else{
_0x303:
; 0000 0753         CONTROLLER_ID =  0x02;
	LDI  R30,LOW(2)
_0x4CA:
	STS  _CONTROLLER_ID,R30
; 0000 0754     }
; 0000 0755 
; 0000 0756     if(id_value == 2 || id_value ==3){
	CPI  R19,2
	BREQ _0x308
	CPI  R19,3
	BRNE _0x307
_0x308:
; 0000 0757         ControllerRunMethod = AUTO_RUN_MODE;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0758     }
; 0000 0759     else{
	RJMP _0x30A
_0x307:
; 0000 075A         ControllerRunMethod = MANUAL_RUN_MODE;
	CLR  R4
; 0000 075B     }
_0x30A:
; 0000 075C 
; 0000 075D     //#######################################################
; 0000 075E     //### 2014.11.28 :: 파란팩커에 특정 등급을 같이 받기  ###
; 0000 075F     //#######################################################
; 0000 0760     PackerSharedEnable = PACKER_INFO[8].gradetype;
	__GETB1MN _PACKER_INFO,32
	STS  _PackerSharedEnable,R30
; 0000 0761 
; 0000 0762     //#######################################################
; 0000 0763 
; 0000 0764     //엔코더 방향 설정 :: 선별기 좌방향인 경우(상지농장) 정회전시 B상이 Low
; 0000 0765     //                    선별기 우방향인 경우(공장, 알찬농장) 정회전시 B상이 High
; 0000 0766     //파란기 입력 단자의 최상위 비트(D7)이 '1' 이면 우방향 (D7 단자 GND접속) ==>B상을 High체크
; 0000 0767     //파란기 입력 단자의 최상위 비트(D7)이 '0' 이면 좌방향 (D7 단자 V24접속) ==>B상을 Low체크
; 0000 0768     direction_chk = EDI_CH0 & 0x80;
	LDS  R30,40960
	ANDI R30,LOW(0x80)
	MOV  R18,R30
; 0000 0769     if(direction_chk == 0x00){
	CPI  R18,0
	BRNE _0x30B
; 0000 076A         CW_DIR = 0;
	CLR  R5
; 0000 076B     }
; 0000 076C     else if(direction_chk==0x80){
	RJMP _0x30C
_0x30B:
	CPI  R18,128
	BRNE _0x30D
; 0000 076D         CW_DIR = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 076E     }
; 0000 076F 
; 0000 0770 
; 0000 0771 
; 0000 0772     //로드셀 기준 영점값 취득
; 0000 0773     for(jcnt=0;jcnt<MAX_LDCELL;jcnt++){
_0x30D:
_0x30C:
	LDI  R21,LOW(0)
_0x30F:
	CPI  R21,6
	BRLO PC+2
	RJMP _0x310
; 0000 0774         reformTotal = 0;    reformVoltage = 0;  adcnt = 0;
	CALL SUBOPT_0xC2
; 0000 0775         for(icnt = 0;icnt<240;icnt++){
	LDI  R17,LOW(0)
_0x312:
	CPI  R17,240
	BRSH _0x313
; 0000 0776             if(icnt>=avr_loop_cnt){
	LDS  R30,_avr_loop_cnt
	CP   R17,R30
	BRLO _0x314
; 0000 0777                 reformTotal -= reform_ADC[adcnt];
	CALL SUBOPT_0x65
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC3
	CALL __SUBD21
	STS  _reformTotal,R26
	STS  _reformTotal+1,R27
	STS  _reformTotal+2,R24
	STS  _reformTotal+3,R25
; 0000 0778             }
; 0000 0779             reform_ADC[adcnt] = RD_ADC(jcnt);
_0x314:
	CALL SUBOPT_0x65
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	MOV  R26,R21
	CALL _RD_ADC
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 077A             reformTotal += (long)reform_ADC[adcnt++];
	CALL SUBOPT_0x67
	CALL SUBOPT_0x55
	CALL SUBOPT_0x68
; 0000 077B             adcnt %= avr_loop_cnt;
; 0000 077C             ref_zero_value[jcnt]=(reformTotal / avr_loop_cnt)*763/10000;
	MOV  R30,R21
	LDI  R26,LOW(_ref_zero_value)
	LDI  R27,HIGH(_ref_zero_value)
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	LDS  R30,_avr_loop_cnt
	LDI  R31,0
	CALL SUBOPT_0x64
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 077D         }
	SUBI R17,-1
	RJMP _0x312
_0x313:
; 0000 077E         zero_value[jcnt] = ref_zero_value[jcnt];
	MOV  R30,R21
	CALL SUBOPT_0x4A
	MOVW R0,R30
	MOV  R30,R21
	LDI  R26,LOW(_ref_zero_value)
	LDI  R27,HIGH(_ref_zero_value)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xBC
; 0000 077F         old_Zero[jcnt] = zero_value[jcnt];
	MOV  R30,R21
	LDI  R26,LOW(_old_Zero)
	LDI  R27,HIGH(_old_Zero)
	CALL SUBOPT_0xA
	MOVW R0,R30
	MOV  R30,R21
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xBC
; 0000 0780 
; 0000 0781     }
	SUBI R21,-1
	RJMP _0x30F
_0x310:
; 0000 0782 
; 0000 0783 
; 0000 0784 
; 0000 0785     //초기화 완료 부저
; 0000 0786     led_buz_value |= BUZZER_ON;     LED_BUZ = led_buz_value;     delay_ms(150);
	CALL SUBOPT_0xC4
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0787     led_buz_value &= ~BUZZER_ON;    LED_BUZ = led_buz_value;     delay_ms(80);
	CALL SUBOPT_0x6E
	LDI  R26,LOW(80)
	LDI  R27,0
	CALL _delay_ms
; 0000 0788     for(icnt=0;icnt<1;icnt++){
	LDI  R17,LOW(0)
_0x316:
	CPI  R17,1
	BRSH _0x317
; 0000 0789         led_buz_value |= BUZZER_ON;     LED_BUZ = led_buz_value;     delay_ms(50);
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC5
; 0000 078A         led_buz_value &= ~BUZZER_ON;    LED_BUZ = led_buz_value;     delay_ms(80);
	CALL SUBOPT_0x6E
	LDI  R26,LOW(80)
	LDI  R27,0
	CALL _delay_ms
; 0000 078B     }
	SUBI R17,-1
	RJMP _0x316
_0x317:
; 0000 078C 
; 0000 078D     //초기 파워 SYSTEM 동작 LED 온
; 0000 078E     led_buz_value |= LED_INIT_OK;
	LDS  R30,_led_buz_value
	ORI  R30,0x40
	CALL SUBOPT_0x38
; 0000 078F     LED_BUZ = led_buz_value;
; 0000 0790 
; 0000 0791     //초기 PLC OFF 신호 출력
; 0000 0792     plc_prt_value |= EVENT_STOP;
	LDS  R30,_plc_prt_value
	ORI  R30,2
	CALL SUBOPT_0x28
; 0000 0793     PLC_CON = plc_prt_value;
; 0000 0794 
; 0000 0795     #asm("sei");
	sei
; 0000 0796 }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;
;void BuzzerOn(void){
; 0000 0798 void BuzzerOn(void){
_BuzzerOn:
; .FSTART _BuzzerOn
; 0000 0799     led_buz_value |= BUZZER_ON;
	CALL SUBOPT_0xC4
; 0000 079A     LED_BUZ = led_buz_value;
; 0000 079B     TimerMode = tmrBUZ;
	LDI  R30,LOW(3)
	CALL SUBOPT_0xC6
; 0000 079C     TCNT1H=0x00;        TCNT1L=0x00;
; 0000 079D     OCR1AH=0x0C;        OCR1AL=0x35;
	LDI  R30,LOW(12)
	STS  137,R30
	LDI  R30,LOW(53)
	CALL SUBOPT_0xC7
; 0000 079E     TCCR1B = 0x05;
; 0000 079F }
	RET
; .FEND
;
;void Reform_Weight(void)
; 0000 07A2 {
_Reform_Weight:
; .FSTART _Reform_Weight
; 0000 07A3     unsigned char done=1;
; 0000 07A4     unsigned int icnt, jcnt, kcnt;
; 0000 07A5     unsigned int readvalue;
; 0000 07A6     long avrtotal;
; 0000 07A7 
; 0000 07A8     TxBuffer[0] = 0x02;
	SBIW R28,8
	CALL __SAVELOCR6
;	done -> R17
;	icnt -> R18,R19
;	jcnt -> R20,R21
;	kcnt -> Y+12
;	readvalue -> Y+10
;	avrtotal -> Y+6
	LDI  R17,1
	CALL SUBOPT_0x5F
; 0000 07A9     TxBuffer[1] = 0x00;
; 0000 07AA     TxBuffer[2] = 0x02;
	__PUTB1MN _TxBuffer,2
; 0000 07AB     TxBuffer[3] = CMD_REFORM_WEIGHT;
	LDI  R30,LOW(240)
	CALL SUBOPT_0xC8
; 0000 07AC     TxBuffer[4] = 0x01;
; 0000 07AD     TxBuffer[5] = 0x03;
; 0000 07AE     TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 07AF     COM_REV_ENABLE = 0;
	LDI  R30,LOW(0)
	STS  _COM_REV_ENABLE,R30
; 0000 07B0 
; 0000 07B1 
; 0000 07B2     for(jcnt=0;jcnt<MAX_LDCELL;jcnt++){
	__GETWRN 20,21,0
_0x319:
	__CPWRN 20,21,6
	BRLO PC+2
	RJMP _0x31A
; 0000 07B3         reformTotal = 0;    reformVoltage = 0;  adcnt = 0;
	CALL SUBOPT_0xC2
; 0000 07B4         for(icnt = 0;icnt<240;icnt++){
	__GETWRN 18,19,0
_0x31C:
	__CPWRN 18,19,240
	BRLO PC+2
	RJMP _0x31D
; 0000 07B5             /*if(icnt>=avr_loop_cnt){
; 0000 07B6                 reformTotal -= reform_ADC[adcnt];
; 0000 07B7             }
; 0000 07B8             reform_ADC[adcnt] = RD_ADC(jcnt);
; 0000 07B9             reformTotal += (long)reform_ADC[adcnt++];
; 0000 07BA             adcnt %= avr_loop_cnt;
; 0000 07BB             zero_value[jcnt]=(reformTotal / avr_loop_cnt)*763/10000;
; 0000 07BC             */
; 0000 07BD 
; 0000 07BE             readvalue = RD_ADC(jcnt);
	MOV  R26,R20
	CALL _RD_ADC
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 07BF 
; 0000 07C0             if(icnt ==0){                                       //평균 초기값을 최초값으로 설정
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x31E
; 0000 07C1                 for(kcnt = 0 ;kcnt<avr_loop_cnt;kcnt++){
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
_0x320:
	CALL SUBOPT_0xCA
	BRSH _0x321
; 0000 07C2                     reform_ADC[kcnt] = readvalue;
	CALL SUBOPT_0xCB
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07C3                     reformTotal += (long)readvalue;
	CALL SUBOPT_0xCC
	CALL SUBOPT_0xCD
; 0000 07C4                 }
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
	RJMP _0x320
_0x321:
; 0000 07C5             }
; 0000 07C6 
; 0000 07C7             avrtotal = reformTotal + (long)readvalue;                     //평균합계(reformTotal)와 현재값을 합산
_0x31E:
	CALL SUBOPT_0xCC
	__PUTD1S 6
; 0000 07C8             reformTotal -= (long)reform_ADC[adcnt];                       //평균합계에서 직전 평균값을 뺀다.
	CALL SUBOPT_0x65
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0x55
	CALL SUBOPT_0x66
; 0000 07C9             reform_ADC[adcnt] = (unsigned int)(avrtotal / (avr_loop_cnt+1));        //
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	LDS  R30,_avr_loop_cnt
	LDI  R31,0
	ADIW R30,1
	__GETD2S 6
	CALL SUBOPT_0x49
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 07CA 
; 0000 07CB             zero_value[jcnt] = ((long)reform_ADC[adcnt] * 763) / 10000;
	MOVW R30,R20
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	CALL SUBOPT_0x90
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x65
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0x55
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 07CC             reformTotal += reform_ADC[adcnt++];
	CALL SUBOPT_0x67
	CALL SUBOPT_0xC3
	CALL __ADDD12
	CALL SUBOPT_0xCD
; 0000 07CD 
; 0000 07CE             adcnt %= avr_loop_cnt;
	LDS  R30,_avr_loop_cnt
	LDS  R26,_adcnt
	CALL __MODB21U
	STS  _adcnt,R30
; 0000 07CF         }
	__ADDWRN 18,19,1
	RJMP _0x31C
_0x31D:
; 0000 07D0     }
	__ADDWRN 20,21,1
	RJMP _0x319
_0x31A:
; 0000 07D1 
; 0000 07D2     BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 07D3     delay_ms(200);
; 0000 07D4 
; 0000 07D5     while(done){
_0x322:
	CPI  R17,0
	BRNE PC+2
	RJMP _0x324
; 0000 07D6         if(COM_REV_ENABLE){
	LDS  R30,_COM_REV_ENABLE
	CPI  R30,0
	BRNE PC+2
	RJMP _0x325
; 0000 07D7             switch(RxBuffer[0]){
	LDS  R30,_RxBuffer
	LDI  R31,0
; 0000 07D8                 case CMD_REFORM_START :
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x329
; 0000 07D9                     TCCR1B = 0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 07DA                     TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 07DB                     TxBuffer[1] = 0x00;
; 0000 07DC                     TxBuffer[2] = 0x02;
	__PUTB1MN _TxBuffer,2
; 0000 07DD                     TxBuffer[3] = CMD_REFORM_START;
	LDI  R30,LOW(241)
	CALL SUBOPT_0xC8
; 0000 07DE                     TxBuffer[4] = 0x01;
; 0000 07DF                     TxBuffer[5] = 0x03;
; 0000 07E0                     TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 07E1 
; 0000 07E2                     while(TxEnable){
_0x32A:
	LDS  R30,_TxEnable
	CPI  R30,0
	BRNE _0x32A
; 0000 07E3                     }
; 0000 07E4 
; 0000 07E5                     BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 07E6                     delay_ms(200);
; 0000 07E7 
; 0000 07E8                     led_buz_value |= LED_RUN_STOP;
	CALL SUBOPT_0x27
; 0000 07E9                     LED_BUZ = led_buz_value;
; 0000 07EA                     TCCR1B = 0x00;
	CALL SUBOPT_0x18
; 0000 07EB 
; 0000 07EC                     reformTotal=0; adcnt=0;
	STS  _reformTotal,R30
	STS  _reformTotal+1,R30
	STS  _reformTotal+2,R30
	STS  _reformTotal+3,R30
	LDI  R30,LOW(0)
	STS  _adcnt,R30
; 0000 07ED                     reformCH = RxBuffer[1];
	__GETB1MN _RxBuffer,1
	STS  _reformCH,R30
; 0000 07EE 
; 0000 07EF                     for(kcnt = 0 ;kcnt<avr_loop_cnt;kcnt++){
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
_0x32E:
	CALL SUBOPT_0xCA
	BRSH _0x32F
; 0000 07F0                         reform_ADC[kcnt] = zero_value[reformCH];
	CALL SUBOPT_0xCB
	MOVW R0,R30
	CALL SUBOPT_0x69
	CALL SUBOPT_0xBC
; 0000 07F1                         reformTotal += (long)reform_ADC[kcnt];
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDI  R26,LOW(_reform_ADC)
	LDI  R27,HIGH(_reform_ADC)
	CALL SUBOPT_0xB
	CALL SUBOPT_0x55
	CALL SUBOPT_0x64
	CALL __ADDD12
	CALL SUBOPT_0xCD
; 0000 07F2                     }
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
	RJMP _0x32E
_0x32F:
; 0000 07F3 
; 0000 07F4 
; 0000 07F5                     /*for(icnt=0;icnt<24;icnt++){
; 0000 07F6                         reform_ADC[icnt] = 0;
; 0000 07F7                     }
; 0000 07F8                     reformCH = RxBuffer[1];
; 0000 07F9                     */
; 0000 07FA                     TimerMode =  tmrADC;
	LDI  R30,LOW(1)
	CALL SUBOPT_0xC6
; 0000 07FB                     TCNT1H = 0x00;      TCNT1L = 0x00;
; 0000 07FC                     OCR1AH=0x01;        OCR1AL=0x38;        //20msec /1024 prescaler
	LDI  R30,LOW(1)
	STS  137,R30
	LDI  R30,LOW(56)
	CALL SUBOPT_0xC7
; 0000 07FD                     TCCR1B = 0x05;
; 0000 07FE                     break;
	RJMP _0x328
; 0000 07FF                 case CMD_REFORM_STOP :
_0x329:
	CPI  R30,LOW(0xF3)
	LDI  R26,HIGH(0xF3)
	CPC  R31,R26
	BRNE _0x330
; 0000 0800                     TCNT1H = 0x00;      TCNT1L = 0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 0000 0801                     TCCR1B = 0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 0802 
; 0000 0803                     BuzzerOn();
	RCALL _BuzzerOn
; 0000 0804                     led_buz_value &= ~LED_RUN_STOP;
	CALL SUBOPT_0x32
; 0000 0805                     LED_BUZ = led_buz_value;
; 0000 0806                     delay_ms(100);
	CALL SUBOPT_0xCF
; 0000 0807                     TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 0808                     TxBuffer[1] = 0x00;
; 0000 0809                     TxBuffer[2] = 0x02;
	__PUTB1MN _TxBuffer,2
; 0000 080A                     TxBuffer[3] = CMD_REFORM_STOP;
	LDI  R30,LOW(243)
	CALL SUBOPT_0xC8
; 0000 080B                     TxBuffer[4] = 0x01;
; 0000 080C                     TxBuffer[5] = 0x03;
; 0000 080D                     TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 080E 
; 0000 080F                     break;
	RJMP _0x328
; 0000 0810                 case CMD_REFORM_SET : //0xF2
_0x330:
	CPI  R30,LOW(0xF2)
	LDI  R26,HIGH(0xF2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x331
; 0000 0811                 //case CMD_LDCELLINFO : //0x80
; 0000 0812                     TCCR1B = 0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 0813 
; 0000 0814                     switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0815                         case 0x01 :     //SAVE DATA
	BRNE _0x335
; 0000 0816                             //LDCELL_INFO[RxBuffer[2]].span = (RxBuffer[3] * 256) + RxBuffer[4];
; 0000 0817                             ConstWeight[reformCH] = (RxBuffer[3] * 256) + RxBuffer[4];
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xA
	MOVW R22,R30
	__GETB2MN _RxBuffer,3
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,4
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R22
	RJMP _0x4CB
; 0000 0818                             LDCELL_INFO[reformCH].span = ConstWeight[reformCH];
; 0000 0819                             PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
; 0000 081A                             break;
; 0000 081B                         case 0x02 :     //INIT DATA
_0x335:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x334
; 0000 081C                             //LDCELL_INFO[RxBuffer[2]].span = 1000;
; 0000 081D                             //ConstWeight[reformCH] = 286;
; 0000 081E                             ConstWeight[reformCH] = 1000;
	CALL SUBOPT_0x6B
	LDI  R31,0
	CALL SUBOPT_0xB
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0x4CB:
	ST   X+,R30
	ST   X,R31
; 0000 081F                             LDCELL_INFO[reformCH].span = ConstWeight[reformCH];
	LDS  R30,_reformCH
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	__ADDW1MN _LDCELL_INFO,1
	MOVW R0,R30
	CALL SUBOPT_0x6B
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xBC
; 0000 0820                             PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
	LDI  R26,LOW(14)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0821                             break;
; 0000 0822                     }
_0x334:
; 0000 0823 
; 0000 0824                     BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0825                     delay_ms(200);
; 0000 0826 
; 0000 0827                     TimerMode =  tmrADC;
	LDI  R30,LOW(1)
	CALL SUBOPT_0xC6
; 0000 0828                     TCNT1H = 0x00;      TCNT1L = 0x00;
; 0000 0829                     OCR1AH=0x00;        OCR1AL=0x1F;        //2msec /1024 prescaler
	CALL SUBOPT_0xD2
; 0000 082A                     TCCR1B = 0x05;
; 0000 082B 
; 0000 082C                     break;
	RJMP _0x328
; 0000 082D                 case CMD_REFORM_DATA :
_0x331:
	CPI  R30,LOW(0xFD)
	LDI  R26,HIGH(0xFD)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x337
; 0000 082E                     TxBuffer[0] = 0x02;     TxBuffer[1] = 0x00;     TxBuffer[2]= 11;      TxBuffer[3] = CMD_REFORM_DATA; ...
	CALL SUBOPT_0xD3
	LDI  R30,LOW(11)
	__PUTB1MN _TxBuffer,2
	LDI  R30,LOW(253)
	__PUTB1MN _TxBuffer,3
	LDS  R30,_reformCH
	__PUTB1MN _TxBuffer,4
; 0000 082F                     TxBuffer[5] = reformSigned;
	LDS  R30,_reformSigned
	__PUTB1MN _TxBuffer,5
; 0000 0830                     TxBuffer[6] = reformVoltage >> 8;       TxBuffer[7] = reformVoltage;
	LDS  R30,_reformVoltage+1
	__PUTB1MN _TxBuffer,6
	LDS  R30,_reformVoltage
	__PUTB1MN _TxBuffer,7
; 0000 0831                     TxBuffer[8] = reformWeight >> 8;                TxBuffer[9] = reformWeight;
	LDS  R30,_reformWeight+1
	__PUTB1MN _TxBuffer,8
	LDS  R30,_reformWeight
	__PUTB1MN _TxBuffer,9
; 0000 0832                     TxBuffer[10] = zero_value[reformCH] >> 8;        TxBuffer[11] = zero_value[reformCH];
	CALL SUBOPT_0x69
	CALL SUBOPT_0xB0
	__PUTB1MN _TxBuffer,10
	CALL SUBOPT_0x69
	LD   R30,X
	__PUTB1MN _TxBuffer,11
; 0000 0833                     TxBuffer[12] = ConstWeight[reformCH] >> 8;        TxBuffer[13] = ConstWeight[reformCH];
	CALL SUBOPT_0x6B
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB0
	__PUTB1MN _TxBuffer,12
	CALL SUBOPT_0x6B
	LDI  R31,0
	CALL SUBOPT_0xB
	LD   R30,X
	__PUTB1MN _TxBuffer,13
; 0000 0834                     TxBuffer[14] = 0x03;
	LDI  R30,LOW(3)
	__PUTB1MN _TxBuffer,14
; 0000 0835 
; 0000 0836                     TxEnable = 1;   TxLength = 15;   txcnt = 1;      UDR1 = TxBuffer[0];
	LDI  R30,LOW(1)
	STS  _TxEnable,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	STS  _TxLength,R30
	STS  _TxLength+1,R31
	CALL SUBOPT_0xD4
	LDS  R30,_TxBuffer
	STS  206,R30
; 0000 0837                     break;
	RJMP _0x328
; 0000 0838                 case CMD_REFORM_ZERO :
_0x337:
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0x338
; 0000 0839                     zero_value[RxBuffer[1]] = reformVoltage;
	__GETB1MN _RxBuffer,1
	CALL SUBOPT_0x4A
	LDS  R26,_reformVoltage
	LDS  R27,_reformVoltage+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 083A                     ref_zero_value[RxBuffer[1]] = zero_value[RxBuffer[1]];
	__GETB1MN _RxBuffer,1
	LDI  R26,LOW(_ref_zero_value)
	LDI  R27,HIGH(_ref_zero_value)
	CALL SUBOPT_0xA
	MOVW R0,R30
	__GETB1MN _RxBuffer,1
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	LDI  R31,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xBC
; 0000 083B                     BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 083C 
; 0000 083D                     delay_ms(200);
; 0000 083E 
; 0000 083F                     TimerMode =  tmrADC;
	LDI  R30,LOW(1)
	CALL SUBOPT_0xC6
; 0000 0840                     TCNT1H = 0x00;      TCNT1L = 0x00;
; 0000 0841                     OCR1AH=0x00;        OCR1AL=0x1F;        //2msec /1024 prescaler
	CALL SUBOPT_0xD2
; 0000 0842                     TCCR1B = 0x05;
; 0000 0843                     break;
	RJMP _0x328
; 0000 0844                 case CMD_REFORM_EXIT :
_0x338:
	CPI  R30,LOW(0xF4)
	LDI  R26,HIGH(0xF4)
	CPC  R31,R26
	BRNE _0x328
; 0000 0845                     TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 0846                     TxBuffer[1] = 0x00;
; 0000 0847                     TxBuffer[2] = 0x02;
	__PUTB1MN _TxBuffer,2
; 0000 0848                     TxBuffer[3] = CMD_REFORM_EXIT;
	LDI  R30,LOW(244)
	CALL SUBOPT_0xC8
; 0000 0849                     TxBuffer[4] = 0x01;
; 0000 084A                     TxBuffer[5] = 0x03;
; 0000 084B                     TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 084C                     TCCR1B = 0x00;
	CALL SUBOPT_0x18
; 0000 084D                     TimerMode = tmrNONE;
	STS  _TimerMode,R30
; 0000 084E 
; 0000 084F                     BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0850                     delay_ms(200);
; 0000 0851 
; 0000 0852                     done = 0;
	LDI  R17,LOW(0)
; 0000 0853                     break;
; 0000 0854             }
_0x328:
; 0000 0855             COM_REV_ENABLE = 0;
	LDI  R30,LOW(0)
	STS  _COM_REV_ENABLE,R30
; 0000 0856         }
; 0000 0857     }
_0x325:
	RJMP _0x322
_0x324:
; 0000 0858 
; 0000 0859     BuzzerOn();
	RCALL _BuzzerOn
; 0000 085A }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
;
;void ExtPort_TEST(unsigned char port, unsigned char pindata, unsigned char outtype, unsigned char packerpos){
; 0000 085C void ExtPort_TEST(unsigned char port, unsigned char pindata, unsigned char outtype, unsigned char packerpos){
_ExtPort_TEST:
; .FSTART _ExtPort_TEST
; 0000 085D     unsigned char outdata, lcnt;
; 0000 085E 
; 0000 085F     if(port == 0xFF){
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	port -> Y+5
;	pindata -> Y+4
;	outtype -> Y+3
;	packerpos -> Y+2
;	outdata -> R17
;	lcnt -> R16
	LDD  R26,Y+5
	CPI  R26,LOW(0xFF)
	BREQ PC+2
	RJMP _0x33A
; 0000 0860         if(pindata == 0x0a){
	LDD  R26,Y+4
	CPI  R26,LOW(0xA)
	BREQ PC+2
	RJMP _0x33B
; 0000 0861             //솔레노이드 작동
; 0000 0862             for(lcnt=0;lcnt<6;lcnt++){
	LDI  R16,LOW(0)
_0x33D:
	CPI  R16,6
	BRLO PC+2
	RJMP _0x33E
; 0000 0863                 outdata = 0x01 << lcnt;
	MOV  R30,R16
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R17,R30
; 0000 0864                 do_value[packerpos] |= outdata;
	LDD  R26,Y+2
	CALL SUBOPT_0x9E
	OR   R30,R17
	CALL SUBOPT_0xD5
; 0000 0865                 switch(packerpos){
; 0000 0866                     case 0: SOL_CH1 = do_value[0];  break;
	BRNE _0x342
	CALL SUBOPT_0xA4
	RJMP _0x341
; 0000 0867                     case 1: SOL_CH2 = do_value[1];  break;
_0x342:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x343
	CALL SUBOPT_0xA5
	RJMP _0x341
; 0000 0868                     case 2: SOL_CH3 = do_value[2];  break;
_0x343:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x344
	CALL SUBOPT_0xA6
	RJMP _0x341
; 0000 0869                     case 3: SOL_CH4 = do_value[3];  break;
_0x344:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x345
	CALL SUBOPT_0xA7
	RJMP _0x341
; 0000 086A                     case 4: SOL_CH5 = do_value[4];  break;
_0x345:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x346
	CALL SUBOPT_0xA8
	RJMP _0x341
; 0000 086B                     case 5: SOL_CH6 = do_value[5];  break;
_0x346:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x347
	CALL SUBOPT_0xA9
	RJMP _0x341
; 0000 086C                     case 6: SOL_CH7 = do_value[6];  break;
_0x347:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x341
	CALL SUBOPT_0xAA
; 0000 086D                 }
_0x341:
; 0000 086E                 led_buz_value |= BUZZER_ON;
	CALL SUBOPT_0xC4
; 0000 086F                 LED_BUZ = led_buz_value;
; 0000 0870                 delay_ms(100);
	CALL SUBOPT_0xCF
; 0000 0871 
; 0000 0872                 do_value[packerpos] &= ~outdata;
	CALL SUBOPT_0xD6
; 0000 0873                 switch(packerpos){
; 0000 0874                     case 0: SOL_CH1 = do_value[0];  break;
	BRNE _0x34C
	CALL SUBOPT_0xA4
	RJMP _0x34B
; 0000 0875                     case 1: SOL_CH2 = do_value[1];  break;
_0x34C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x34D
	CALL SUBOPT_0xA5
	RJMP _0x34B
; 0000 0876                     case 2: SOL_CH3 = do_value[2];  break;
_0x34D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34E
	CALL SUBOPT_0xA6
	RJMP _0x34B
; 0000 0877                     case 3: SOL_CH4 = do_value[3];  break;
_0x34E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x34F
	CALL SUBOPT_0xA7
	RJMP _0x34B
; 0000 0878                     case 4: SOL_CH5 = do_value[4];  break;
_0x34F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x350
	CALL SUBOPT_0xA8
	RJMP _0x34B
; 0000 0879                     case 5: SOL_CH6 = do_value[5];  break;
_0x350:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x351
	CALL SUBOPT_0xA9
	RJMP _0x34B
; 0000 087A                     case 6: SOL_CH7 = do_value[6];  break;
_0x351:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x34B
	CALL SUBOPT_0xAA
; 0000 087B                 }
_0x34B:
; 0000 087C                 led_buz_value &= ~BUZZER_ON;
	CALL SUBOPT_0x6E
; 0000 087D                 LED_BUZ = led_buz_value;
; 0000 087E                 delay_ms(100);
	CALL SUBOPT_0xCF
; 0000 087F             }
	SUBI R16,-1
	RJMP _0x33D
_0x33E:
; 0000 0880             //팩커 기동
; 0000 0881             outdata = 0x80;
	LDI  R17,LOW(128)
; 0000 0882             do_value[packerpos] |= outdata;
	LDD  R26,Y+2
	CALL SUBOPT_0x9E
	OR   R30,R17
	CALL SUBOPT_0xD5
; 0000 0883             switch(packerpos){
; 0000 0884                 case 0: SOL_CH1 = do_value[0];  break;
	BRNE _0x356
	CALL SUBOPT_0xA4
	RJMP _0x355
; 0000 0885                 case 1: SOL_CH2 = do_value[1];  break;
_0x356:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x357
	CALL SUBOPT_0xA5
	RJMP _0x355
; 0000 0886                 case 2: SOL_CH3 = do_value[2];  break;
_0x357:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x358
	CALL SUBOPT_0xA6
	RJMP _0x355
; 0000 0887                 case 3: SOL_CH4 = do_value[3];  break;
_0x358:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x359
	CALL SUBOPT_0xA7
	RJMP _0x355
; 0000 0888                 case 4: SOL_CH5 = do_value[4];  break;
_0x359:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x35A
	CALL SUBOPT_0xA8
	RJMP _0x355
; 0000 0889                 case 5: SOL_CH6 = do_value[5];  break;
_0x35A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x35B
	CALL SUBOPT_0xA9
	RJMP _0x355
; 0000 088A                 case 6: SOL_CH7 = do_value[6];  break;
_0x35B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x355
	CALL SUBOPT_0xAA
; 0000 088B             }
_0x355:
; 0000 088C             delay_ms(100);
	CALL SUBOPT_0xCF
; 0000 088D 
; 0000 088E             do_value[packerpos] &= ~outdata;
	CALL SUBOPT_0xD6
; 0000 088F             switch(packerpos){
; 0000 0890                 case 0: SOL_CH1 = do_value[0];  break;
	BRNE _0x360
	CALL SUBOPT_0xA4
	RJMP _0x35F
; 0000 0891                 case 1: SOL_CH2 = do_value[1];  break;
_0x360:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x361
	CALL SUBOPT_0xA5
	RJMP _0x35F
; 0000 0892                 case 2: SOL_CH3 = do_value[2];  break;
_0x361:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x362
	CALL SUBOPT_0xA6
	RJMP _0x35F
; 0000 0893                 case 3: SOL_CH4 = do_value[3];  break;
_0x362:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x363
	CALL SUBOPT_0xA7
	RJMP _0x35F
; 0000 0894                 case 4: SOL_CH5 = do_value[4];  break;
_0x363:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x364
	CALL SUBOPT_0xA8
	RJMP _0x35F
; 0000 0895                 case 5: SOL_CH6 = do_value[5];  break;
_0x364:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x365
	CALL SUBOPT_0xA9
	RJMP _0x35F
; 0000 0896                 case 6: SOL_CH7 = do_value[6];  break;
_0x365:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x35F
	CALL SUBOPT_0xAA
; 0000 0897             }
_0x35F:
; 0000 0898             delay_ms(100);
	CALL SUBOPT_0xCF
; 0000 0899         }
; 0000 089A         else{
	RJMP _0x367
_0x33B:
; 0000 089B             outdata = (0x01<<pindata);
	LDD  R30,Y+4
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R17,R30
; 0000 089C 
; 0000 089D             if(outtype ==1){
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x368
; 0000 089E                 do_value[packerpos] |= outdata;
	LDD  R26,Y+2
	CALL SUBOPT_0x9E
	OR   R30,R17
	RJMP _0x4CC
; 0000 089F             }
; 0000 08A0             else if(outtype==0){
_0x368:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x36A
; 0000 08A1                 do_value[packerpos] &= ~outdata;
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-_do_value)
	SBCI R31,HIGH(-_do_value)
	MOVW R0,R30
	LD   R26,Z
	MOV  R30,R17
	COM  R30
	AND  R30,R26
	MOVW R26,R0
_0x4CC:
	ST   X,R30
; 0000 08A2             }
; 0000 08A3 
; 0000 08A4             switch(packerpos){
_0x36A:
	LDD  R30,Y+2
	LDI  R31,0
; 0000 08A5                 case 0 :
	SBIW R30,0
	BRNE _0x36E
; 0000 08A6                     SOL_CH1 = do_value[0];
	CALL SUBOPT_0xA4
; 0000 08A7                     break;
	RJMP _0x36D
; 0000 08A8                 case 1 :
_0x36E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x36F
; 0000 08A9                     SOL_CH2 = do_value[1];
	CALL SUBOPT_0xA5
; 0000 08AA                     break;
	RJMP _0x36D
; 0000 08AB                 case 2 :
_0x36F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x370
; 0000 08AC                     SOL_CH3 = do_value[2];
	CALL SUBOPT_0xA6
; 0000 08AD                     break;
	RJMP _0x36D
; 0000 08AE                 case 3 :
_0x370:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x371
; 0000 08AF                     SOL_CH4 = do_value[3];
	CALL SUBOPT_0xA7
; 0000 08B0                     break;
	RJMP _0x36D
; 0000 08B1                 case 4 :
_0x371:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x372
; 0000 08B2                     SOL_CH5 = do_value[4];
	CALL SUBOPT_0xA8
; 0000 08B3                     break;
	RJMP _0x36D
; 0000 08B4                 case 5 :
_0x372:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x373
; 0000 08B5                     SOL_CH6 = do_value[5];
	CALL SUBOPT_0xA9
; 0000 08B6                     break;
	RJMP _0x36D
; 0000 08B7                 case 6 :
_0x373:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x36D
; 0000 08B8                     SOL_CH7 = do_value[6];
	CALL SUBOPT_0xAA
; 0000 08B9                     break;
; 0000 08BA             }
_0x36D:
; 0000 08BB         }
_0x367:
; 0000 08BC     }
; 0000 08BD     else if(port==0x02)
	RJMP _0x375
_0x33A:
	LDD  R26,Y+5
	CPI  R26,LOW(0x2)
	BRNE _0x376
; 0000 08BE     {
; 0000 08BF         if(outtype==1){
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x377
; 0000 08C0             plc_prt_value |= PRT_A_ON;
	LDS  R30,_plc_prt_value
	ORI  R30,0x10
	RJMP _0x4CD
; 0000 08C1             PLC_CON = plc_prt_value;
; 0000 08C2         }
; 0000 08C3         else if(outtype==0){
_0x377:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x379
; 0000 08C4             plc_prt_value &= ~PRT_A_ON;
	LDS  R30,_plc_prt_value
	ANDI R30,0xEF
_0x4CD:
	STS  _plc_prt_value,R30
; 0000 08C5             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 08C6         }
; 0000 08C7     }
_0x379:
; 0000 08C8     else if(port==0x03)
	RJMP _0x37A
_0x376:
	LDD  R26,Y+5
	CPI  R26,LOW(0x3)
	BRNE _0x37B
; 0000 08C9     {
; 0000 08CA         if(outtype==1){
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x37C
; 0000 08CB             plc_prt_value |= PRT_B_ON;
	LDS  R30,_plc_prt_value
	ORI  R30,0x20
	RJMP _0x4CE
; 0000 08CC             PLC_CON = plc_prt_value;
; 0000 08CD         }
; 0000 08CE         else if(outtype==0){
_0x37C:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x37E
; 0000 08CF             plc_prt_value &= ~PRT_B_ON;
	LDS  R30,_plc_prt_value
	ANDI R30,0xDF
_0x4CE:
	STS  _plc_prt_value,R30
; 0000 08D0             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 08D1         }
; 0000 08D2     }
_0x37E:
; 0000 08D3     else if(port==0x10)
	RJMP _0x37F
_0x37B:
	LDD  R26,Y+5
	CPI  R26,LOW(0x10)
	BRNE _0x380
; 0000 08D4     {
; 0000 08D5         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x381
; 0000 08D6         {
; 0000 08D7             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 08D8             plc_prt_value |= Marking_MOUT_SNG[1];
	__GETB1MN _Marking_MOUT_SNG,1
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4CF
; 0000 08D9             PLC_CON = plc_prt_value;
; 0000 08DA         }
; 0000 08DB         else if(outtype==0)
_0x381:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x383
; 0000 08DC         {
; 0000 08DD             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 08DE             plc_prt_value &= ~Marking_MOUT_SNG[1];
	__GETB1MN _Marking_MOUT_SNG,1
	CALL SUBOPT_0xA3
_0x4CF:
	STS  _plc_prt_value,R30
; 0000 08DF             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 08E0         }
; 0000 08E1     }
_0x383:
; 0000 08E2     else if(port==0x20)
	RJMP _0x384
_0x380:
	LDD  R26,Y+5
	CPI  R26,LOW(0x20)
	BRNE _0x385
; 0000 08E3     {
; 0000 08E4         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x386
; 0000 08E5         {
; 0000 08E6             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 08E7             plc_prt_value |= Marking_MOUT_SNG[2];
	__GETB1MN _Marking_MOUT_SNG,2
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4D0
; 0000 08E8             PLC_CON = plc_prt_value;
; 0000 08E9         }
; 0000 08EA         else if(outtype==0)
_0x386:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x388
; 0000 08EB         {
; 0000 08EC             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 08ED             plc_prt_value &= ~Marking_MOUT_SNG[2];
	__GETB1MN _Marking_MOUT_SNG,2
	CALL SUBOPT_0xA3
_0x4D0:
	STS  _plc_prt_value,R30
; 0000 08EE             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 08EF         }
; 0000 08F0     }
_0x388:
; 0000 08F1     else if(port==0x30)
	RJMP _0x389
_0x385:
	LDD  R26,Y+5
	CPI  R26,LOW(0x30)
	BRNE _0x38A
; 0000 08F2     {
; 0000 08F3         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x38B
; 0000 08F4         {
; 0000 08F5             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 08F6             plc_prt_value |= Marking_MOUT_SNG[3];
	__GETB1MN _Marking_MOUT_SNG,3
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4D1
; 0000 08F7             PLC_CON = plc_prt_value;
; 0000 08F8         }
; 0000 08F9         else if(outtype==0)
_0x38B:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x38D
; 0000 08FA         {
; 0000 08FB             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 08FC             plc_prt_value &= ~Marking_MOUT_SNG[3];
	__GETB1MN _Marking_MOUT_SNG,3
	CALL SUBOPT_0xA3
_0x4D1:
	STS  _plc_prt_value,R30
; 0000 08FD             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 08FE         }
; 0000 08FF     }
_0x38D:
; 0000 0900     else if(port==0x40)
	RJMP _0x38E
_0x38A:
	LDD  R26,Y+5
	CPI  R26,LOW(0x40)
	BRNE _0x38F
; 0000 0901     {
; 0000 0902         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x390
; 0000 0903         {
; 0000 0904             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 0905             plc_prt_value |= Marking_MOUT_SNG[4];
	__GETB1MN _Marking_MOUT_SNG,4
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4D2
; 0000 0906             PLC_CON = plc_prt_value;
; 0000 0907         }
; 0000 0908         else if(outtype==0)
_0x390:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x392
; 0000 0909         {
; 0000 090A             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 090B             plc_prt_value &= ~Marking_MOUT_SNG[4];
	__GETB1MN _Marking_MOUT_SNG,4
	CALL SUBOPT_0xA3
_0x4D2:
	STS  _plc_prt_value,R30
; 0000 090C             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 090D         }
; 0000 090E     }
_0x392:
; 0000 090F     else if(port==0x50)
	RJMP _0x393
_0x38F:
	LDD  R26,Y+5
	CPI  R26,LOW(0x50)
	BRNE _0x394
; 0000 0910     {
; 0000 0911         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x395
; 0000 0912         {
; 0000 0913             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 0914             plc_prt_value |= Marking_MOUT_SNG[5];
	__GETB1MN _Marking_MOUT_SNG,5
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4D3
; 0000 0915             PLC_CON = plc_prt_value;
; 0000 0916         }
; 0000 0917         else if(outtype==0)
_0x395:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x397
; 0000 0918         {
; 0000 0919             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 091A             plc_prt_value &= ~Marking_MOUT_SNG[5];
	__GETB1MN _Marking_MOUT_SNG,5
	CALL SUBOPT_0xA3
_0x4D3:
	STS  _plc_prt_value,R30
; 0000 091B             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 091C         }
; 0000 091D     }
_0x397:
; 0000 091E     else if(port==0x60)
	RJMP _0x398
_0x394:
	LDD  R26,Y+5
	CPI  R26,LOW(0x60)
	BRNE _0x399
; 0000 091F     {
; 0000 0920         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x39A
; 0000 0921         {
; 0000 0922             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 0923             plc_prt_value |= Marking_MOUT_SNG[6];
	__GETB1MN _Marking_MOUT_SNG,6
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4D4
; 0000 0924             PLC_CON = plc_prt_value;
; 0000 0925         }
; 0000 0926         else if(outtype==0)
_0x39A:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x39C
; 0000 0927         {
; 0000 0928             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 0929             plc_prt_value &= ~Marking_MOUT_SNG[6];
	__GETB1MN _Marking_MOUT_SNG,6
	CALL SUBOPT_0xA3
_0x4D4:
	STS  _plc_prt_value,R30
; 0000 092A             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 092B         }
; 0000 092C     }
_0x39C:
; 0000 092D     else if(port==0x70)
	RJMP _0x39D
_0x399:
	LDD  R26,Y+5
	CPI  R26,LOW(0x70)
	BRNE _0x39E
; 0000 092E     {
; 0000 092F         if(outtype==1)
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x39F
; 0000 0930         {
; 0000 0931             plc_prt_value |= PRT_A_ON;
	CALL SUBOPT_0xD7
; 0000 0932             plc_prt_value |= Marking_MOUT_SNG[7];
	__GETB1MN _Marking_MOUT_SNG,7
	LDS  R26,_plc_prt_value
	OR   R30,R26
	RJMP _0x4D5
; 0000 0933             PLC_CON = plc_prt_value;
; 0000 0934         }
; 0000 0935         else if(outtype==0)
_0x39F:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x3A1
; 0000 0936         {
; 0000 0937             plc_prt_value &= ~PRT_A_ON;
	CALL SUBOPT_0xD8
; 0000 0938             plc_prt_value &= ~Marking_MOUT_SNG[7];
	__GETB1MN _Marking_MOUT_SNG,7
	CALL SUBOPT_0xA3
_0x4D5:
	STS  _plc_prt_value,R30
; 0000 0939             PLC_CON = plc_prt_value;
	CALL SUBOPT_0xAB
; 0000 093A         }
; 0000 093B     }
_0x3A1:
; 0000 093C }
_0x39E:
_0x39D:
_0x398:
_0x393:
_0x38E:
_0x389:
_0x384:
_0x37F:
_0x37A:
_0x375:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND
;
;void MACHINE_DATA_CLEAR(void){
; 0000 093E void MACHINE_DATA_CLEAR(void){
_MACHINE_DATA_CLEAR:
; .FSTART _MACHINE_DATA_CLEAR
; 0000 093F     unsigned int icnt;
; 0000 0940 
; 0000 0941     for(icnt=0;icnt<MAX_BUCKET;icnt++){
	ST   -Y,R17
	ST   -Y,R16
;	icnt -> R16,R17
	__GETWRN 16,17,0
_0x3A3:
	__CPWRN 16,17,300
	BRSH _0x3A4
; 0000 0942         BucketData[icnt] = BucketInitValue;
	CALL SUBOPT_0x40
	CALL SUBOPT_0x42
; 0000 0943     }
	__ADDWRN 16,17,1
	RJMP _0x3A3
_0x3A4:
; 0000 0944     for(icnt=0;icnt<MAX_BUCKET;icnt++)
	__GETWRN 16,17,0
_0x3A6:
	__CPWRN 16,17,300
	BRSH _0x3A7
; 0000 0945     {
; 0000 0946         BucketData_Wight[icnt] = BucketInitValue;
	MOVW R30,R16
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x42
; 0000 0947     }
	__ADDWRN 16,17,1
	RJMP _0x3A6
_0x3A7:
; 0000 0948 
; 0000 0949     for(icnt=0;icnt<MAX_PACKER+1;icnt++)
	__GETWRN 16,17,0
_0x3A9:
	__CPWRN 16,17,10
	BRSH _0x3AA
; 0000 094A     {
; 0000 094B         GRADE_DATA.gNumber[icnt] = 0;
	__POINTW2MN _GRADE_DATA,48
	MOVW R30,R16
	CALL SUBOPT_0x4D
; 0000 094C         GRADE_DATA.gWeight[icnt] = 0;
	__POINTW2MN _GRADE_DATA,88
	MOVW R30,R16
	CALL SUBOPT_0x4D
; 0000 094D         GRADE_DATA.pNumber[icnt] = 0;
	__POINTW2MN _GRADE_DATA,128
	MOVW R30,R16
	CALL SUBOPT_0x4D
; 0000 094E 
; 0000 094F         //GRADE_INFO[icnt].prtOutCount=0;
; 0000 0950     }
	__ADDWRN 16,17,1
	RJMP _0x3A9
_0x3AA:
; 0000 0951     for(icnt=0;icnt<MAX_PACKER;icnt++)
	__GETWRN 16,17,0
_0x3AC:
	__CPWRN 16,17,9
	BRSH _0x3AD
; 0000 0952     {
; 0000 0953          GRADE_INFO[icnt].prtOutCount=0;
	__MULBNWRU 16,17,10
	__ADDW1MN _GRADE_INFO,8
	CALL SUBOPT_0x2
; 0000 0954     }
	__ADDWRN 16,17,1
	RJMP _0x3AC
_0x3AD:
; 0000 0955 
; 0000 0956     GRADE_DATA.gTNumber = 0;
	CALL SUBOPT_0xD9
	__PUTD1MN _GRADE_DATA,168
; 0000 0957     GRADE_DATA.gTWeight = 0;
	CALL SUBOPT_0xD9
	CALL SUBOPT_0x89
; 0000 0958     GRADE_DATA.gSpeed = 0;
	CALL SUBOPT_0xD9
	__PUTD1MN _GRADE_DATA,184
; 0000 0959     GRADE_DATA.gZCount = 0;
	CALL SUBOPT_0xD9
	CALL SUBOPT_0x91
; 0000 095A     phase_z_cnt = 0;
	CALL SUBOPT_0xDA
; 0000 095B     abn_butket_num_temp = 0;
	STS  _abn_butket_num_temp,R30
	STS  _abn_butket_num_temp+1,R30
; 0000 095C     tmrSPEEDCNT = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x92
; 0000 095D }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 0960 {
_main:
; .FSTART _main
; 0000 0961     unsigned char hi_cmd, lo_cmd, done = 1;
; 0000 0962     unsigned int dbufstart, lcnt, jcnt, oddbuf, evenbuf, bufpos=0;
; 0000 0963 
; 0000 0964 
; 0000 0965 
; 0000 0966     //로드셀 앰프 전원인가후 대기시간
; 0000 0967     Initialize_REG();
	SBIW R28,10
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	hi_cmd -> R17
;	lo_cmd -> R16
;	done -> R19
;	dbufstart -> R20,R21
;	lcnt -> Y+8
;	jcnt -> Y+6
;	oddbuf -> Y+4
;	evenbuf -> Y+2
;	bufpos -> Y+0
	LDI  R19,1
	CALL _Initialize_REG
; 0000 0968     Initialize_GPIO();
	CALL _Initialize_GPIO
; 0000 0969 
; 0000 096A     //Solenoid Port Initialize
; 0000 096B     SOL_CH1 = 0;
	LDI  R30,LOW(0)
	STS  35072,R30
; 0000 096C     SOL_CH2 = 0;
	STS  35328,R30
; 0000 096D     SOL_CH3 = 0;
	STS  35584,R30
; 0000 096E     SOL_CH4 = 0;
	STS  35840,R30
; 0000 096F     SOL_CH5 = 0;
	STS  36096,R30
; 0000 0970     SOL_CH6 = 0;
	STS  36352,R30
; 0000 0971     SOL_CH7 = 0;
	STS  36608,R30
; 0000 0972     PLC_CON = 0;
	STS  34816,R30
; 0000 0973     LED_BUZ = 0;
	STS  36864,R30
; 0000 0974     //led_buz_value &= ~BUZZER_ON;
; 0000 0975     //LED_BUZ = led_buz_value;
; 0000 0976     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0977     //로드셀 앰프 전원 인가후 로드셀 앰프 워밍업 대기 시간 약 1.4초
; 0000 0978     //자체 제작 앰프 특성
; 0000 0979     for(jcnt=0;jcnt<40;jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x3AF:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,40
	BRSH _0x3B0
; 0000 097A         if((jcnt%2)==0){
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ANDI R30,LOW(0x1)
	BRNE _0x3B1
; 0000 097B             LED_BUZ = 0x40;          delay_ms(50);
	LDI  R30,LOW(64)
	CALL SUBOPT_0xDB
; 0000 097C             LED_BUZ = 0x20;          delay_ms(50);
	LDI  R30,LOW(32)
	CALL SUBOPT_0xDB
; 0000 097D             LED_BUZ = 0x10;          delay_ms(50);
	LDI  R30,LOW(16)
	CALL SUBOPT_0xDB
; 0000 097E             LED_BUZ = 0x08;          delay_ms(50);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xDB
; 0000 097F             LED_BUZ = 0x04;          delay_ms(50);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xDB
; 0000 0980             LED_BUZ = 0x02;          delay_ms(50);
	LDI  R30,LOW(2)
	CALL SUBOPT_0xDB
; 0000 0981             LED_BUZ = 0x01;          delay_ms(50);
	LDI  R30,LOW(1)
	RJMP _0x4D6
; 0000 0982         }
; 0000 0983         else{
_0x3B1:
; 0000 0984             LED_BUZ = 0x01;          delay_ms(50);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xDB
; 0000 0985             LED_BUZ = 0x02;          delay_ms(50);
	LDI  R30,LOW(2)
	CALL SUBOPT_0xDB
; 0000 0986             LED_BUZ = 0x04;          delay_ms(50);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xDB
; 0000 0987             LED_BUZ = 0x08;          delay_ms(50);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xDB
; 0000 0988             LED_BUZ = 0x10;          delay_ms(50);
	LDI  R30,LOW(16)
	CALL SUBOPT_0xDB
; 0000 0989             LED_BUZ = 0x20;          delay_ms(50);
	LDI  R30,LOW(32)
	CALL SUBOPT_0xDB
; 0000 098A             LED_BUZ = 0x40;          delay_ms(50);
	LDI  R30,LOW(64)
_0x4D6:
	STS  36864,R30
	CALL SUBOPT_0xC5
; 0000 098B         }
; 0000 098C     }
	CALL SUBOPT_0xC1
	RJMP _0x3AF
_0x3B0:
; 0000 098D 
; 0000 098E     LED_BUZ = led_buz_value;
	CALL SUBOPT_0x2F
; 0000 098F 
; 0000 0990     Initialize_SYSTEM();
	RCALL _Initialize_SYSTEM
; 0000 0991     GET_USR_INFO_DATA(MARKING_VERSION);
	LDI  R26,LOW(18)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 0992 
; 0000 0993 
; 0000 0994     //Auto Running Mode
; 0000 0995     if(ControllerRunMethod == AUTO_RUN_MODE){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x3B3
; 0000 0996         tmrSPEEDCNT = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x92
; 0000 0997         led_buz_value |= LED_RUN_STOP;
	CALL SUBOPT_0x27
; 0000 0998         LED_BUZ = led_buz_value;
; 0000 0999 
; 0000 099A         BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 099B         delay_ms(200);
; 0000 099C 
; 0000 099D         modRunning = NORMAL_RUN;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 099E         TimerMode = tmrSPEED;
	LDI  R30,LOW(2)
	CALL SUBOPT_0xDC
; 0000 099F         plc_prt_value |= MACHINE_START;
; 0000 09A0         PLC_CON = plc_prt_value;
; 0000 09A1         //Timer Start
; 0000 09A2         OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
	CALL SUBOPT_0x21
; 0000 09A3         TCCR1B = 0x05;
; 0000 09A4 
; 0000 09A5         while(done);
_0x3B4:
	CPI  R19,0
	BRNE _0x3B4
; 0000 09A6     }
; 0000 09A7 
; 0000 09A8     while(1){
_0x3B3:
_0x3B7:
; 0000 09A9         if(modRunning==MACHINE_STOP || modRunning==NORMAL_RUN || modRunning==SOLENOID_TEST || modRunning==ENCODER_CHK){
	TST  R10
	BREQ _0x3BB
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ _0x3BB
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ _0x3BB
	LDI  R30,LOW(7)
	CP   R30,R10
	BREQ _0x3BB
	JMP  _0x3BA
_0x3BB:
; 0000 09AA             if(COM_REV_ENABLE){
	LDS  R30,_COM_REV_ENABLE
	CPI  R30,0
	BRNE PC+3
	JMP _0x3BD
; 0000 09AB                 hi_cmd = RxBuffer[0] & 0xF0;
	LDS  R30,_RxBuffer
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
; 0000 09AC                 lo_cmd = RxBuffer[0] & 0x0F;
	LDS  R30,_RxBuffer
	ANDI R30,LOW(0xF)
	MOV  R16,R30
; 0000 09AD                 switch(RxBuffer[0]){
	LDS  R30,_RxBuffer
	LDI  R31,0
; 0000 09AE                     case CMD_START : //0x10
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3C1
; 0000 09AF                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 09B0                             case 0x01 : case 0x02: case 0x03 : case 0x04 : //Machine Start
	BREQ _0x3C6
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3C7
_0x3C6:
	RJMP _0x3C8
_0x3C7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C9
_0x3C8:
	RJMP _0x3CA
_0x3C9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3CB
_0x3CA:
; 0000 09B1                                 if(RxBuffer[1]==0x01)
	__GETB2MN _RxBuffer,1
	CPI  R26,LOW(0x1)
	BRNE _0x3CC
; 0000 09B2                                 {
; 0000 09B3                                     debugMode = 0;
	LDI  R30,LOW(0)
	STS  _debugMode,R30
; 0000 09B4 
; 0000 09B5                                     if( Marking_Version != 0 )
	LDS  R30,_Marking_Version
	CPI  R30,0
	BREQ _0x3CD
; 0000 09B6                                     {
; 0000 09B7                                         Marking_Version = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xDD
; 0000 09B8                                         PUT_USR_INFO_DATA(MARKING_VERSION);
; 0000 09B9                                     }
; 0000 09BA                                     LifeTime_Run = 0;
_0x3CD:
	RJMP _0x4D7
; 0000 09BB                                 }
; 0000 09BC                                 else if(RxBuffer[1]==0x02)
_0x3CC:
	__GETB2MN _RxBuffer,1
	CPI  R26,LOW(0x2)
	BRNE _0x3CF
; 0000 09BD                                 {
; 0000 09BE                                     debugMode = 0;
	LDI  R30,LOW(0)
	STS  _debugMode,R30
; 0000 09BF                                     if( Marking_Version != 1 )
	LDS  R26,_Marking_Version
	CPI  R26,LOW(0x1)
	BREQ _0x3D0
; 0000 09C0                                     {
; 0000 09C1                                         Marking_Version = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0xDD
; 0000 09C2                                         PUT_USR_INFO_DATA(MARKING_VERSION);
; 0000 09C3                                     }
; 0000 09C4                                     LifeTime_Run = 0;
_0x3D0:
	RJMP _0x4D7
; 0000 09C5                                 }
; 0000 09C6                                 else if(RxBuffer[1]==0x03){
_0x3CF:
	__GETB2MN _RxBuffer,1
	CPI  R26,LOW(0x3)
	BRNE _0x3D2
; 0000 09C7                                     debugMode = 2;
	LDI  R30,LOW(2)
	RJMP _0x4D8
; 0000 09C8                                     LifeTime_Run = 0;
; 0000 09C9                                 }
; 0000 09CA                                 else if(RxBuffer[1]==0x04){
_0x3D2:
	__GETB2MN _RxBuffer,1
	CPI  R26,LOW(0x4)
	BRNE _0x3D4
; 0000 09CB                                     debugMode = 3;
	LDI  R30,LOW(3)
_0x4D8:
	STS  _debugMode,R30
; 0000 09CC                                     LifeTime_Run = 0;
_0x4D7:
	LDI  R30,LOW(0)
	STS  _LifeTime_Run,R30
; 0000 09CD                                 }
; 0000 09CE 
; 0000 09CF                                 tmrSPEEDCNT = 0;
_0x3D4:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x92
; 0000 09D0                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 09D1                                 TxBuffer[1] = 0x00;
; 0000 09D2                                 TxBuffer[2] = 0x02;
	CALL SUBOPT_0x5B
; 0000 09D3                                 TxBuffer[3] = CMD_START;
; 0000 09D4                                 TxBuffer[4] = 0x01;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x60
; 0000 09D5                                 TxBuffer[5] = 0x03;
; 0000 09D6                                 TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 09D7                                 led_buz_value |= LED_RUN_STOP;
	CALL SUBOPT_0x27
; 0000 09D8                                 LED_BUZ = led_buz_value;
; 0000 09D9 
; 0000 09DA                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 09DB                                 delay_ms(200);
; 0000 09DC 
; 0000 09DD                                 modRunning = NORMAL_RUN;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 09DE                                 TimerMode = tmrSPEED;
	RJMP _0x4D9
; 0000 09DF                                 plc_prt_value |= MACHINE_START;
; 0000 09E0                                 PLC_CON = plc_prt_value;
; 0000 09E1                                 //Timer Start
; 0000 09E2                                 OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
; 0000 09E3                                 TCCR1B = 0x05;
; 0000 09E4                                 //modRunning = MACHINE_RDY;
; 0000 09E5                                 break;
; 0000 09E6                             case 0x10 :
_0x3CB:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x3D5
; 0000 09E7                                 //파란검출 비율이 일정이상인 경우 인터락 출력
; 0000 09E8                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 09E9                                 delay_ms(200);
; 0000 09EA 
; 0000 09EB                                 //plc_prt_value |= INTER_LOCK_ON;
; 0000 09EC                                 //PLC_CON = plc_prt_value;
; 0000 09ED                                 InterLockCnt = 0;
	LDI  R30,LOW(0)
	STS  _InterLockCnt,R30
; 0000 09EE                                 InterLockON = 1;
	LDI  R30,LOW(1)
	STS  _InterLockON,R30
; 0000 09EF                                 break;
	RJMP _0x3C4
; 0000 09F0                             case 0x0A : case 0x0B: case 0x0C: case 0x0D: case 0x0E: case 0x0F:  //Measure Test
_0x3D5:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ _0x3D7
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x3D8
_0x3D7:
	RJMP _0x3D9
_0x3D8:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x3DA
_0x3D9:
	RJMP _0x3DB
_0x3DA:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x3DC
_0x3DB:
	RJMP _0x3DD
_0x3DC:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x3DE
_0x3DD:
	RJMP _0x3DF
_0x3DE:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3E0
_0x3DF:
; 0000 09F1                                 //modRunning = MACHINE_RDY;
; 0000 09F2                                 led_buz_value |= LED_RUN_STOP;
	CALL SUBOPT_0x27
; 0000 09F3                                 LED_BUZ = led_buz_value;
; 0000 09F4 
; 0000 09F5                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 09F6                                 TxBuffer[1] = 0x00;
; 0000 09F7                                 TxBuffer[2] = 0x02;
	CALL SUBOPT_0x5B
; 0000 09F8                                 TxBuffer[3] = CMD_START;
; 0000 09F9                                 TxBuffer[4] = RxBuffer[1];
	__GETB1MN _RxBuffer,1
	CALL SUBOPT_0x60
; 0000 09FA                                 TxBuffer[5] = 0x03;
; 0000 09FB                                 TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 09FC 
; 0000 09FD                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 09FE                                 delay_ms(200);
; 0000 09FF 
; 0000 0A00                                 for(lcnt=0;lcnt<600;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x3E2:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRSH _0x3E3
; 0000 0A01                                     ad_full_scan[lcnt] = 0;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_ad_full_scan)
	LDI  R27,HIGH(_ad_full_scan)
	CALL SUBOPT_0xB
	CALL SUBOPT_0x42
; 0000 0A02                                 }
	CALL SUBOPT_0xDE
	RJMP _0x3E2
_0x3E3:
; 0000 0A03                                 LifeTime_Run = 1;
	LDI  R30,LOW(1)
	STS  _LifeTime_Run,R30
; 0000 0A04                                 modRunning = MEASURE_AD;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 0A05                                 scan_ad_ch = RxBuffer[1] - 0x0A;
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(10)
	MOV  R14,R30
; 0000 0A06                                 cur_z_phase_cnt =0; phase_a_cnt = 0;   phase_z_cnt=0;    max_scan_val=0;       max_scan_ ...
	LDI  R30,LOW(0)
	STS  _cur_z_phase_cnt,R30
	STS  _cur_z_phase_cnt+1,R30
	CALL SUBOPT_0x2B
	LDI  R30,LOW(0)
	CALL SUBOPT_0xDA
	STS  _max_scan_val,R30
	STS  _max_scan_val+1,R30
	LDI  R30,LOW(0)
	STS  _max_scan_cnt,R30
	STS  _max_scan_cnt+1,R30
; 0000 0A07                                 plc_prt_value |= MACHINE_START;
	LDS  R30,_plc_prt_value
	ORI  R30,1
	CALL SUBOPT_0x28
; 0000 0A08                                 PLC_CON = plc_prt_value;
; 0000 0A09 
; 0000 0A0A                                 break;
	RJMP _0x3C4
; 0000 0A0B                             case 0x05 :                 //MACHINE STOP
_0x3E0:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3E4
; 0000 0A0C                                 EVENT_ENABLE = 1;
	CALL SUBOPT_0x26
; 0000 0A0D                                 SpeedAdjEnable = 1;
; 0000 0A0E                                 accel_rdy = 0;
	CALL SUBOPT_0x1E
; 0000 0A0F                                 deaccel_rdy = 1;
	STS  _deaccel_rdy,R30
; 0000 0A10                                 break;
	RJMP _0x3C4
; 0000 0A11                             case 0xB0 :                 //세척기 ON
_0x3E4:
	CPI  R30,LOW(0xB0)
	LDI  R26,HIGH(0xB0)
	CPC  R31,R26
	BRNE _0x3E5
; 0000 0A12                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0A13                                 delay_ms(200);
; 0000 0A14                                 plc_prt_value |= WASHER_ON;
	LDS  R30,_plc_prt_value
	ORI  R30,4
	CALL SUBOPT_0x28
; 0000 0A15                                 PLC_CON = plc_prt_value;
; 0000 0A16                                 break;
	RJMP _0x3C4
; 0000 0A17                             case 0xB1 :                 //세척기 OFF
_0x3E5:
	CPI  R30,LOW(0xB1)
	LDI  R26,HIGH(0xB1)
	CPC  R31,R26
	BRNE _0x3E6
; 0000 0A18                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0A19                                 delay_ms(200);
; 0000 0A1A                                 plc_prt_value &= ~WASHER_ON;
	LDS  R30,_plc_prt_value
	ANDI R30,0xFB
	CALL SUBOPT_0x28
; 0000 0A1B                                 PLC_CON = plc_prt_value;
; 0000 0A1C                                 break;
	RJMP _0x3C4
; 0000 0A1D                             case 0xC0 :                 //브로와  ON
_0x3E6:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0x3E7
; 0000 0A1E                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0A1F                                 delay_ms(200);
; 0000 0A20                                 plc_prt_value |= BROWA_ON;
	LDS  R30,_plc_prt_value
	ORI  R30,8
	CALL SUBOPT_0x28
; 0000 0A21                                 PLC_CON = plc_prt_value;
; 0000 0A22                                 break;
	RJMP _0x3C4
; 0000 0A23                             case 0xC1 :                 //브로와 OFF
_0x3E7:
	CPI  R30,LOW(0xC1)
	LDI  R26,HIGH(0xC1)
	CPC  R31,R26
	BRNE _0x3E8
; 0000 0A24                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0A25                                 delay_ms(200);
; 0000 0A26                                 plc_prt_value &= ~BROWA_ON;
	LDS  R30,_plc_prt_value
	ANDI R30,0XF7
	CALL SUBOPT_0x28
; 0000 0A27                                 PLC_CON = plc_prt_value;
; 0000 0A28                                 break;
	RJMP _0x3C4
; 0000 0A29                             case 0xA0 :     //작업 내용 Clear
_0x3E8:
	CPI  R30,LOW(0xA0)
	LDI  R26,HIGH(0xA0)
	CPC  R31,R26
	BRNE _0x3E9
; 0000 0A2A                                 MACHINE_DATA_CLEAR();
	RCALL _MACHINE_DATA_CLEAR
; 0000 0A2B 
; 0000 0A2C                                 for(lcnt=0;lcnt<9;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x3EB:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x3EC
; 0000 0A2D                                     if(old_prttype[lcnt] != PRT_TYPE_NO){
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_old_prttype)
	SBCI R31,HIGH(-_old_prttype)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x3ED
; 0000 0A2E                                         GRADE_INFO[lcnt].prttype = old_prttype[lcnt];
	CALL SUBOPT_0xDF
	__ADDW1MN _GRADE_INFO,5
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_old_prttype)
	SBCI R31,HIGH(-_old_prttype)
	LD   R30,Z
	ST   X,R30
; 0000 0A2F                                     }
; 0000 0A30                                 }
_0x3ED:
	CALL SUBOPT_0xDE
	RJMP _0x3EB
_0x3EC:
; 0000 0A31 
; 0000 0A32                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 0A33                                 TxBuffer[1] = 0x00;
; 0000 0A34                                 TxBuffer[2] = 0x02;
	CALL SUBOPT_0x5B
; 0000 0A35                                 TxBuffer[3] = CMD_START;
; 0000 0A36                                 TxBuffer[4] = 0x0F;
	LDI  R30,LOW(15)
	CALL SUBOPT_0x60
; 0000 0A37                                 TxBuffer[5] = 0x03;
; 0000 0A38                                 TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 0A39                                 BuzzerOn();
	RCALL _BuzzerOn
; 0000 0A3A                                 break;
	RJMP _0x3C4
; 0000 0A3B                             //솔레노이드 셋팅 시험 명령 :: 로드셀 1개만 가상 데이터 입력하여 시험
; 0000 0A3C                             //팩커별 첫번째 포켓 위치 셋팅시 사용
; 0000 0A3D                             case 0xE0 : case 0xE1 : case 0xE2 : case 0xE3 : case 0xE4 : case 0xE5 : case 0xE6 : case 0xE ...
_0x3E9:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BREQ _0x3EF
	CPI  R30,LOW(0xE1)
	LDI  R26,HIGH(0xE1)
	CPC  R31,R26
	BRNE _0x3F0
_0x3EF:
	RJMP _0x3F1
_0x3F0:
	CPI  R30,LOW(0xE2)
	LDI  R26,HIGH(0xE2)
	CPC  R31,R26
	BRNE _0x3F2
_0x3F1:
	RJMP _0x3F3
_0x3F2:
	CPI  R30,LOW(0xE3)
	LDI  R26,HIGH(0xE3)
	CPC  R31,R26
	BRNE _0x3F4
_0x3F3:
	RJMP _0x3F5
_0x3F4:
	CPI  R30,LOW(0xE4)
	LDI  R26,HIGH(0xE4)
	CPC  R31,R26
	BRNE _0x3F6
_0x3F5:
	RJMP _0x3F7
_0x3F6:
	CPI  R30,LOW(0xE5)
	LDI  R26,HIGH(0xE5)
	CPC  R31,R26
	BRNE _0x3F8
_0x3F7:
	RJMP _0x3F9
_0x3F8:
	CPI  R30,LOW(0xE6)
	LDI  R26,HIGH(0xE6)
	CPC  R31,R26
	BRNE _0x3FA
_0x3F9:
	RJMP _0x3FB
_0x3FA:
	CPI  R30,LOW(0xE7)
	LDI  R26,HIGH(0xE7)
	CPC  R31,R26
	BRNE _0x3FC
_0x3FB:
	RJMP _0x3FD
_0x3FC:
	CPI  R30,LOW(0xE8)
	LDI  R26,HIGH(0xE8)
	CPC  R31,R26
	BRNE _0x3FE
_0x3FD:
; 0000 0A3E                                 SolenoidTestType = 0;
	CLR  R3
; 0000 0A3F                                 TestGrade = RxBuffer[1] - 0xE0;
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(224)
	RJMP _0x4DA
; 0000 0A40 
; 0000 0A41                                 MACHINE_DATA_CLEAR();
; 0000 0A42                                 led_buz_value |= LED_RUN_STOP;
; 0000 0A43                                 LED_BUZ = led_buz_value;
; 0000 0A44 
; 0000 0A45                                 TxBuffer[0] = 0x02;
; 0000 0A46                                 TxBuffer[1] = 0x00;
; 0000 0A47                                 TxBuffer[2] = 0x02;
; 0000 0A48                                 TxBuffer[3] = CMD_START;
; 0000 0A49                                 TxBuffer[4] = RxBuffer[1];
; 0000 0A4A                                 TxBuffer[5] = 0x03;
; 0000 0A4B                                 TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
; 0000 0A4C 
; 0000 0A4D                                 BuzzerOn();
; 0000 0A4E                                 delay_ms(200);
; 0000 0A4F 
; 0000 0A50                                 modRunning = SOLENOID_TEST;
; 0000 0A51                                 phase_z_cnt=0;
; 0000 0A52                                 TimerMode = tmrSPEED;
; 0000 0A53                                 plc_prt_value |= MACHINE_START;
; 0000 0A54                                 PLC_CON = plc_prt_value;
; 0000 0A55                                 //Timer Start
; 0000 0A56                                 OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
; 0000 0A57                                 TCCR1B = 0x05;
; 0000 0A58 
; 0000 0A59                                 break;
; 0000 0A5A                             //솔레노이드 셋팅 시험 명령 :: 로드셀 6개 모두 가상 데이터 입력해서 사용
; 0000 0A5B                             //팩커별 솔레노이드 ON/OFF타임 설정시 사용
; 0000 0A5C                             case 0xF0 : case 0xF1 : case 0xF2 : case 0xF3 : case 0xF4 : case 0xF5 : case 0xF6 : case 0xF ...
_0x3FE:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BREQ _0x400
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BRNE _0x401
_0x400:
	RJMP _0x402
_0x401:
	CPI  R30,LOW(0xF2)
	LDI  R26,HIGH(0xF2)
	CPC  R31,R26
	BRNE _0x403
_0x402:
	RJMP _0x404
_0x403:
	CPI  R30,LOW(0xF3)
	LDI  R26,HIGH(0xF3)
	CPC  R31,R26
	BRNE _0x405
_0x404:
	RJMP _0x406
_0x405:
	CPI  R30,LOW(0xF4)
	LDI  R26,HIGH(0xF4)
	CPC  R31,R26
	BRNE _0x407
_0x406:
	RJMP _0x408
_0x407:
	CPI  R30,LOW(0xF5)
	LDI  R26,HIGH(0xF5)
	CPC  R31,R26
	BRNE _0x409
_0x408:
	RJMP _0x40A
_0x409:
	CPI  R30,LOW(0xF6)
	LDI  R26,HIGH(0xF6)
	CPC  R31,R26
	BRNE _0x40B
_0x40A:
	RJMP _0x40C
_0x40B:
	CPI  R30,LOW(0xF7)
	LDI  R26,HIGH(0xF7)
	CPC  R31,R26
	BRNE _0x40D
_0x40C:
	RJMP _0x40E
_0x40D:
	CPI  R30,LOW(0xF8)
	LDI  R26,HIGH(0xF8)
	CPC  R31,R26
	BRNE _0x3C4
_0x40E:
; 0000 0A5D                                 SolenoidTestType = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 0A5E                                 TestGrade = RxBuffer[1] - 0xF0;
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(240)
_0x4DA:
	MOV  R6,R30
; 0000 0A5F 
; 0000 0A60                                 MACHINE_DATA_CLEAR();
	RCALL _MACHINE_DATA_CLEAR
; 0000 0A61                                 led_buz_value |= LED_RUN_STOP;
	CALL SUBOPT_0x27
; 0000 0A62                                 LED_BUZ = led_buz_value;
; 0000 0A63 
; 0000 0A64                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 0A65                                 TxBuffer[1] = 0x00;
; 0000 0A66                                 TxBuffer[2] = 0x02;
	CALL SUBOPT_0x5B
; 0000 0A67                                 TxBuffer[3] = CMD_START;
; 0000 0A68                                 TxBuffer[4] = RxBuffer[1];
	__GETB1MN _RxBuffer,1
	CALL SUBOPT_0x60
; 0000 0A69                                 TxBuffer[5] = 0x03;
; 0000 0A6A                                 TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 0A6B 
; 0000 0A6C                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0A6D                                 delay_ms(200);
; 0000 0A6E 
; 0000 0A6F                                 modRunning = SOLENOID_TEST;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 0A70                                 phase_z_cnt=0;
	LDI  R30,LOW(0)
	STS  _phase_z_cnt,R30
	STS  _phase_z_cnt+1,R30
	STS  _phase_z_cnt+2,R30
	STS  _phase_z_cnt+3,R30
; 0000 0A71                                 TimerMode = tmrSPEED;
_0x4D9:
	LDI  R30,LOW(2)
	CALL SUBOPT_0xDC
; 0000 0A72                                 plc_prt_value |= MACHINE_START;
; 0000 0A73                                 PLC_CON = plc_prt_value;
; 0000 0A74                                 //Timer Start
; 0000 0A75                                 OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
	CALL SUBOPT_0x21
; 0000 0A76                                 TCCR1B = 0x05;
; 0000 0A77                                 break;
; 0000 0A78                         }
_0x3C4:
; 0000 0A79                         break;
	JMP  _0x3C0
; 0000 0A7A                     case CMD_SYSINFO : //0x20 :: 시스템 일반 정보, 측정 관련 정보 송수신
_0x3C1:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x410
; 0000 0A7B                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0A7C                             case 0x01 :     //SAVE  DATA
	BREQ PC+2
	RJMP _0x414
; 0000 0A7D                                 SYS_INFO.risingTime = RxBuffer[2] * 256;
	__GETB2MN _RxBuffer,2
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x15
; 0000 0A7E                                 SYS_INFO.risingTime |= RxBuffer[3];
	__GETB1MN _RxBuffer,3
	LDS  R26,_SYS_INFO
	LDS  R27,_SYS_INFO+1
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x15
; 0000 0A7F                                 SYS_INFO.fallingTime = RxBuffer[4] * 256;
	__GETB2MN _RxBuffer,4
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x14
; 0000 0A80                                 SYS_INFO.fallingTime |= RxBuffer[5];
	__GETW2MN _SYS_INFO,2
	__GETB1MN _RxBuffer,5
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x14
; 0000 0A81                                 SYS_INFO.correction = RxBuffer[6] * 256;
	__GETB1MN _RxBuffer,6
	LDI  R30,LOW(0)
	__PUTB1MN _SYS_INFO,4
; 0000 0A82                                 SYS_INFO.correction |= RxBuffer[7];
	__GETB2MN _SYS_INFO,4
	__GETB1MN _RxBuffer,7
	OR   R30,R26
	__PUTB1MN _SYS_INFO,4
; 0000 0A83                                 SYS_INFO.stopcount = RxBuffer[8] * 256;
	__GETB2MN _RxBuffer,8
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x16
; 0000 0A84                                 SYS_INFO.stopcount |= RxBuffer[9];
	__GETW2MN _SYS_INFO,5
	__GETB1MN _RxBuffer,9
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x16
; 0000 0A85                                 MEASURE_INFO.ad_start_pulse =RxBuffer[10] * 256;
	__GETB2MN _RxBuffer,10
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xE
; 0000 0A86                                 MEASURE_INFO.ad_start_pulse |= RxBuffer[11];
	__GETB1MN _RxBuffer,11
	CALL SUBOPT_0x43
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0xE
; 0000 0A87                                 MEASURE_INFO.duringcount = RxBuffer[12] * 256;
	__GETB2MN _RxBuffer,12
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xF
; 0000 0A88                                 MEASURE_INFO.duringcount |= RxBuffer[13];
	__GETW2MN _MEASURE_INFO,2
	__GETB1MN _RxBuffer,13
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0xF
; 0000 0A89                                 MEASURE_INFO.zeroposition = RxBuffer[14] * 256;
	__GETB2MN _RxBuffer,14
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x13
; 0000 0A8A                                 MEASURE_INFO.zeroposition |= RxBuffer[15];
	__GETW2MN _MEASURE_INFO,4
	__GETB1MN _RxBuffer,15
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x13
; 0000 0A8B                                 MEASURE_INFO.crackchecktime = RxBuffer[16] * 256;
	__GETB2MN _RxBuffer,16
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x10
; 0000 0A8C                                 MEASURE_INFO.crackchecktime |= RxBuffer[17];
	__GETW2MN _MEASURE_INFO,6
	__GETB1MN _RxBuffer,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x10
; 0000 0A8D                                 MEASURE_INFO.abnCheckSTime = RxBuffer[18] * 256;
	__GETB2MN _RxBuffer,18
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x11
; 0000 0A8E                                 MEASURE_INFO.abnCheckSTime |= RxBuffer[19];
	__GETW2MN _MEASURE_INFO,8
	__GETB1MN _RxBuffer,19
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x11
; 0000 0A8F                                 MEASURE_INFO.abnCheckETime = RxBuffer[20] * 256;
	__GETB2MN _RxBuffer,20
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x12
; 0000 0A90                                 MEASURE_INFO.abnCheckETime |= RxBuffer[21];
	__GETW2MN _MEASURE_INFO,10
	__GETB1MN _RxBuffer,21
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x12
; 0000 0A91                                 SYS_INFO.z_encoder_interval = RxBuffer[22] * 256;
	__GETB2MN _RxBuffer,22
	CALL SUBOPT_0xD1
	__PUTW1MN _SYS_INFO,7
; 0000 0A92                                 SYS_INFO.z_encoder_interval |= RxBuffer[23] ;
	CALL SUBOPT_0xBD
	__GETB1MN _RxBuffer,23
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _SYS_INFO,7
; 0000 0A93                                 SYS_INFO.DeAccelDelayCount = RxBuffer[24] * 256;
	__GETB2MN _RxBuffer,24
	CALL SUBOPT_0xD1
	__PUTW1MN _SYS_INFO,13
; 0000 0A94                                 SYS_INFO.DeAccelDelayCount |= RxBuffer[25];
	__GETW2MN _SYS_INFO,13
	__GETB1MN _RxBuffer,25
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _SYS_INFO,13
; 0000 0A95                                 SYS_INFO.DeAccelDelayTime = RxBuffer[26] * 256;
	__GETB2MN _RxBuffer,26
	CALL SUBOPT_0xD1
	__PUTW1MN _SYS_INFO,15
; 0000 0A96                                 SYS_INFO.DeAccelDelayTime |= RxBuffer[27];
	__GETW2MN _SYS_INFO,15
	__GETB1MN _RxBuffer,27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _SYS_INFO,15
; 0000 0A97                                 SYS_INFO.ACD_CHK_POS = RxBuffer[28];
	__GETB1MN _RxBuffer,28
	__PUTB1MN _SYS_INFO,17
; 0000 0A98 
; 0000 0A99                                 //Save the Flash Memory
; 0000 0A9A                                 PUT_USR_INFO_DATA(MEASURE_INFO_DATA);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0A9B                                 PUT_USR_INFO_DATA(SYS_INFO_DATA);
	LDI  R26,LOW(17)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0A9C 
; 0000 0A9D                                 ETC_PARAMETER_SETTING();
	CALL _ETC_PARAMETER_SETTING
; 0000 0A9E 
; 0000 0A9F                                 BuzzerOn();
	RCALL _BuzzerOn
; 0000 0AA0                                 break;
	RJMP _0x413
; 0000 0AA1                             case 0x02 :     //LOAD DATA
_0x414:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x415
; 0000 0AA2                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0xD3
; 0000 0AA3                                 TxBuffer[1] = 0;
; 0000 0AA4                                 TxBuffer[2] = 27;
	LDI  R30,LOW(27)
	__PUTB1MN _TxBuffer,2
; 0000 0AA5                                 TxBuffer[3] = 0x20;
	LDI  R30,LOW(32)
	CALL SUBOPT_0xE0
; 0000 0AA6                                 TxBuffer[4] = 0x02;
; 0000 0AA7                                 TxBuffer[5] = SYS_INFO.risingTime >> 8;
	LDS  R30,_SYS_INFO
	LDS  R31,_SYS_INFO+1
	CALL __ASRW8
	__PUTB1MN _TxBuffer,5
; 0000 0AA8                                 TxBuffer[6] = SYS_INFO.risingTime & 0xFF;
	LDS  R30,_SYS_INFO
	__PUTB1MN _TxBuffer,6
; 0000 0AA9                                 TxBuffer[7] = SYS_INFO.fallingTime >> 8;
	__GETW1MN _SYS_INFO,2
	CALL __ASRW8
	__PUTB1MN _TxBuffer,7
; 0000 0AAA                                 TxBuffer[8] = SYS_INFO.fallingTime & 0xFF;
	__GETB1MN _SYS_INFO,2
	__PUTB1MN _TxBuffer,8
; 0000 0AAB                                 TxBuffer[9] = SYS_INFO.correction >> 8;
	__GETB2MN _SYS_INFO,4
	LDI  R30,LOW(8)
	CALL __LSRB12
	__PUTB1MN _TxBuffer,9
; 0000 0AAC                                 TxBuffer[10] = SYS_INFO.correction & 0xFF;
	__GETB1MN _SYS_INFO,4
	__PUTB1MN _TxBuffer,10
; 0000 0AAD                                 TxBuffer[11] = SYS_INFO.stopcount >> 8;
	__GETW1MN _SYS_INFO,5
	CALL __ASRW8
	__PUTB1MN _TxBuffer,11
; 0000 0AAE                                 TxBuffer[12] = SYS_INFO.stopcount & 0xFF;
	__GETB1MN _SYS_INFO,5
	__PUTB1MN _TxBuffer,12
; 0000 0AAF                                 TxBuffer[13] = MEASURE_INFO.ad_start_pulse >> 8;
	LDS  R30,_MEASURE_INFO
	LDS  R31,_MEASURE_INFO+1
	CALL __ASRW8
	__PUTB1MN _TxBuffer,13
; 0000 0AB0                                 TxBuffer[14] = MEASURE_INFO.ad_start_pulse & 0xFF;
	LDS  R30,_MEASURE_INFO
	__PUTB1MN _TxBuffer,14
; 0000 0AB1                                 TxBuffer[15] = MEASURE_INFO.duringcount >> 8;
	__GETW1MN _MEASURE_INFO,2
	CALL __ASRW8
	__PUTB1MN _TxBuffer,15
; 0000 0AB2                                 TxBuffer[16] = MEASURE_INFO.duringcount & 0xFF;
	__GETB1MN _MEASURE_INFO,2
	__PUTB1MN _TxBuffer,16
; 0000 0AB3                                 TxBuffer[17] = MEASURE_INFO.zeroposition >> 8;
	__GETW1MN _MEASURE_INFO,4
	CALL __ASRW8
	__PUTB1MN _TxBuffer,17
; 0000 0AB4                                 TxBuffer[18] = MEASURE_INFO.zeroposition & 0xFF;
	__GETB1MN _MEASURE_INFO,4
	__PUTB1MN _TxBuffer,18
; 0000 0AB5                                 TxBuffer[19] = MEASURE_INFO.crackchecktime >> 8;
	CALL SUBOPT_0xBF
	CALL __ASRW8
	__PUTB1MN _TxBuffer,19
; 0000 0AB6                                 TxBuffer[20] = MEASURE_INFO.crackchecktime & 0xFF;
	__GETB1MN _MEASURE_INFO,6
	__PUTB1MN _TxBuffer,20
; 0000 0AB7                                 TxBuffer[21] = MEASURE_INFO.abnCheckSTime >> 8;
	__GETW1MN _MEASURE_INFO,8
	CALL __ASRW8
	__PUTB1MN _TxBuffer,21
; 0000 0AB8                                 TxBuffer[22] = MEASURE_INFO.abnCheckSTime & 0xFF;
	__GETB1MN _MEASURE_INFO,8
	__PUTB1MN _TxBuffer,22
; 0000 0AB9                                 TxBuffer[23] = MEASURE_INFO.abnCheckETime >> 8;
	CALL SUBOPT_0x37
	CALL __ASRW8
	__PUTB1MN _TxBuffer,23
; 0000 0ABA                                 TxBuffer[24] = MEASURE_INFO.abnCheckETime & 0xFF;
	__GETB1MN _MEASURE_INFO,10
	__PUTB1MN _TxBuffer,24
; 0000 0ABB                                 TxBuffer[25] = SYS_INFO.z_encoder_interval >> 8 ;
	__GETW1MN _SYS_INFO,7
	CALL __ASRW8
	__PUTB1MN _TxBuffer,25
; 0000 0ABC                                 TxBuffer[26] = SYS_INFO.z_encoder_interval & 0xFF;
	__GETB1MN _SYS_INFO,7
	__PUTB1MN _TxBuffer,26
; 0000 0ABD                                 TxBuffer[27] = SYS_INFO.DeAccelDelayCount >> 8 ;
	__GETW1MN _SYS_INFO,13
	CALL __ASRW8
	__PUTB1MN _TxBuffer,27
; 0000 0ABE                                 TxBuffer[28] = SYS_INFO.DeAccelDelayCount & 0xFF;
	__GETB1MN _SYS_INFO,13
	__PUTB1MN _TxBuffer,28
; 0000 0ABF                                 TxBuffer[29] = SYS_INFO.DeAccelDelayTime >> 8 ;
	__GETW1MN _SYS_INFO,15
	CALL __ASRW8
	__PUTB1MN _TxBuffer,29
; 0000 0AC0                                 TxBuffer[30] = SYS_INFO.DeAccelDelayTime & 0xFF;
	__GETB1MN _SYS_INFO,15
	__PUTB1MN _TxBuffer,30
; 0000 0AC1                                 TxBuffer[31] = SYS_INFO.ACD_CHK_POS;
	__GETB1MN _SYS_INFO,17
	__PUTB1MN _TxBuffer,31
; 0000 0AC2 
; 0000 0AC3                                 TxBuffer[32] = 0x03;
	LDI  R30,LOW(3)
	__PUTB1MN _TxBuffer,32
; 0000 0AC4 
; 0000 0AC5                                 TxEnable = 1;   txcnt = 1;  TxLength = 33;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xE1
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	CALL SUBOPT_0x93
; 0000 0AC6                                 BuzzerOn();
	CALL _BuzzerOn
; 0000 0AC7                                 break;
; 0000 0AC8                               case 0x00 :     //INIT DATA
_0x415:
; 0000 0AC9                                 break;
; 0000 0ACA                         }
_0x413:
; 0000 0ACB                         break;
	RJMP _0x3C0
; 0000 0ACC                     case CMD_SOLINFO : //0x30 :: 솔레노이드 ON/ OFF타임, 팩커별 솔레노이드 시작 위치, 인쇄기 위치, 인쇄� ...
_0x410:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x417
; 0000 0ACD                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0ACE                             case 0x01 :     //SAVE DATA
	BREQ PC+2
	RJMP _0x41B
; 0000 0ACF 
; 0000 0AD0                                 dbufstart = 2;
	__GETWRN 20,21,2
; 0000 0AD1 
; 0000 0AD2                                 //###  Solenoid On Time  ###
; 0000 0AD3                                 for(lcnt = 0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x41D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x41E
; 0000 0AD4                                     for(jcnt=0; jcnt<=5; jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x420:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x421
; 0000 0AD5                                         oddbuf = dbufstart +  (jcnt * 2) + 1;
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
; 0000 0AD6                                         evenbuf = dbufstart + (jcnt * 2);
	CALL SUBOPT_0xE4
; 0000 0AD7 
; 0000 0AD8                                         SOL_INFO[lcnt].ontime[jcnt] = RxBuffer[evenbuf];             //High Byte
	CALL SUBOPT_0xE5
	CALL SUBOPT_0xE6
; 0000 0AD9                                         SOL_INFO[lcnt].ontime[jcnt] <<= 8;
	CALL SUBOPT_0xE5
	CALL SUBOPT_0xE7
; 0000 0ADA                                         SOL_INFO[lcnt].ontime[jcnt] |= RxBuffer[oddbuf];             //Low Byte
	__ADDW1MN _SOL_INFO,12
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xE9
; 0000 0ADB                                     }
	CALL SUBOPT_0xC1
	RJMP _0x420
_0x421:
; 0000 0ADC                                     dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0ADD                                 }
	CALL SUBOPT_0xDE
	RJMP _0x41D
_0x41E:
; 0000 0ADE 
; 0000 0ADF                                 dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0AE0                                 //###########################
; 0000 0AE1                                 //###  Solenoid OFF Time  ###
; 0000 0AE2                                 //###########################
; 0000 0AE3                                 for(lcnt = 0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x423:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x424
; 0000 0AE4                                     for(jcnt=0; jcnt<=5; jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x426:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x427
; 0000 0AE5                                         oddbuf = dbufstart +  (jcnt * 2) + 1;
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
; 0000 0AE6                                         evenbuf = dbufstart +  (jcnt * 2);
	CALL SUBOPT_0xE4
; 0000 0AE7 
; 0000 0AE8                                         SOL_INFO[lcnt].offtime[jcnt] = RxBuffer[evenbuf];
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xE6
; 0000 0AE9                                         SOL_INFO[lcnt].offtime[jcnt] <<= 8;                          //High Byte
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xE7
; 0000 0AEA                                         SOL_INFO[lcnt].offtime[jcnt] |= RxBuffer[oddbuf];            //Low Byte
	__ADDW1MN _SOL_INFO,24
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xE9
; 0000 0AEB                                     }
	CALL SUBOPT_0xC1
	RJMP _0x426
_0x427:
; 0000 0AEC                                      dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0AED                                 }
	CALL SUBOPT_0xDE
	RJMP _0x423
_0x424:
; 0000 0AEE 
; 0000 0AEF                                 dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0AF0                                 //########################################
; 0000 0AF1                                 //###  Solenoid Start Bucket Position  ###
; 0000 0AF2                                 //########################################
; 0000 0AF3                                 for(lcnt = 0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x429:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x42A
; 0000 0AF4                                     oddbuf = dbufstart + (lcnt * 2) + 1;
	CALL SUBOPT_0xEC
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0AF5                                     evenbuf = dbufstart + (lcnt * 2);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xED
; 0000 0AF6 
; 0000 0AF7                                     PACKER_INFO[lcnt].startpocketnumber = RxBuffer[evenbuf];           //High Byte
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
; 0000 0AF8                                     PACKER_INFO[lcnt].startpocketnumber <<= 8;
	ADIW R30,3
	MOVW R22,R30
	LD   R26,Z
	LDI  R30,LOW(8)
	CALL __LSLB12
	MOVW R26,R22
	CALL SUBOPT_0xEF
; 0000 0AF9                                     PACKER_INFO[lcnt].startpocketnumber |= RxBuffer[oddbuf];           //Low Byte
	ADIW R30,3
	MOVW R0,R30
	LD   R26,Z
	CALL SUBOPT_0xF0
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
; 0000 0AFA                                 }
	CALL SUBOPT_0xDE
	RJMP _0x429
_0x42A:
; 0000 0AFB 
; 0000 0AFC                                 dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0AFD                                 //###################################
; 0000 0AFE                                 //###  PRT Start Bucket Position  ###
; 0000 0AFF                                 //###################################
; 0000 0B00                                 PRT_INFO[1].startpocketnumber  = RxBuffer[dbufstart];
	LDI  R26,LOW(_RxBuffer)
	LDI  R27,HIGH(_RxBuffer)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	__POINTW2MN _PRT_INFO,10
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0B01                                 PRT_INFO[1].startpocketnumber  <<= 8;
	__GETB1HMN _PRT_INFO,10
	LDI  R30,LOW(0)
	__PUTW1MN _PRT_INFO,10
; 0000 0B02                                 PRT_INFO[1].startpocketnumber  |= RxBuffer[dbufstart+1];
	__GETW2MN _PRT_INFO,10
	CALL SUBOPT_0xF1
	__PUTW1MN _PRT_INFO,10
; 0000 0B03 
; 0000 0B04                                 PRT_INFO[2].startpocketnumber  = RxBuffer[dbufstart+2];
	__POINTW2MN _PRT_INFO,16
	CALL SUBOPT_0xF2
; 0000 0B05                                 PRT_INFO[2].startpocketnumber  <<= 8;
	__GETB1HMN _PRT_INFO,16
	LDI  R30,LOW(0)
	__PUTW1MN _PRT_INFO,16
; 0000 0B06                                 PRT_INFO[2].startpocketnumber  |= RxBuffer[dbufstart+3];
	__GETW2MN _PRT_INFO,16
	CALL SUBOPT_0xF3
	__PUTW1MN _PRT_INFO,16
; 0000 0B07 
; 0000 0B08                                 dbufstart = dbufstart+4;
	__ADDWRN 20,21,4
; 0000 0B09                                 //#########################
; 0000 0B0A                                 //###  PRT ON/OFF TIME  ###
; 0000 0B0B                                 //#########################
; 0000 0B0C                                 PRT_INFO[1].ontime  = RxBuffer[dbufstart];
	LDI  R26,LOW(_RxBuffer)
	LDI  R27,HIGH(_RxBuffer)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	__POINTW2MN _PRT_INFO,6
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0B0D                                 PRT_INFO[1].ontime  <<= 8;
	__GETB1HMN _PRT_INFO,6
	LDI  R30,LOW(0)
	__PUTW1MN _PRT_INFO,6
; 0000 0B0E                                 PRT_INFO[1].ontime  |= RxBuffer[dbufstart+1];
	__GETW2MN _PRT_INFO,6
	CALL SUBOPT_0xF1
	__PUTW1MN _PRT_INFO,6
; 0000 0B0F                                 PRT_INFO[1].offtime  = RxBuffer[dbufstart+2];
	__POINTW2MN _PRT_INFO,8
	CALL SUBOPT_0xF2
; 0000 0B10                                 PRT_INFO[1].offtime  <<= 8;
	__GETB1HMN _PRT_INFO,8
	LDI  R30,LOW(0)
	__PUTW1MN _PRT_INFO,8
; 0000 0B11                                 PRT_INFO[1].offtime  |= RxBuffer[dbufstart+3];
	__GETW2MN _PRT_INFO,8
	CALL SUBOPT_0xF3
	__PUTW1MN _PRT_INFO,8
; 0000 0B12 
; 0000 0B13                                 PRT_INFO[2].ontime  = RxBuffer[dbufstart+4];
	__POINTW2MN _PRT_INFO,12
	MOVW R30,R20
	__ADDW1MN _RxBuffer,4
	LD   R30,Z
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0B14                                 PRT_INFO[2].ontime  <<= 8;
	__GETB1HMN _PRT_INFO,12
	LDI  R30,LOW(0)
	__PUTW1MN _PRT_INFO,12
; 0000 0B15                                 PRT_INFO[2].ontime  |= RxBuffer[dbufstart+5];
	__GETW2MN _PRT_INFO,12
	MOVW R30,R20
	__ADDW1MN _RxBuffer,5
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _PRT_INFO,12
; 0000 0B16                                 PRT_INFO[2].offtime  = RxBuffer[dbufstart+6];
	__POINTW2MN _PRT_INFO,14
	MOVW R30,R20
	__ADDW1MN _RxBuffer,6
	LD   R30,Z
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0B17                                 PRT_INFO[2].offtime  <<= 8;
	__GETB1HMN _PRT_INFO,14
	LDI  R30,LOW(0)
	__PUTW1MN _PRT_INFO,14
; 0000 0B18                                 PRT_INFO[2].offtime  |= RxBuffer[dbufstart+7];
	__GETW2MN _PRT_INFO,14
	MOVW R30,R20
	__ADDW1MN _RxBuffer,7
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _PRT_INFO,14
; 0000 0B19 
; 0000 0B1A                                 //dbufstart = dbufstart+8;
; 0000 0B1B 
; 0000 0B1C                                 ABN_INFO.AbnBucketNum = RxBuffer[dbufstart+8];
	MOVW R30,R20
	__ADDW1MN _RxBuffer,8
	LD   R30,Z
	LDI  R31,0
	CALL SUBOPT_0xF4
; 0000 0B1D                                 ABN_INFO.AbnBucketNum <<= 8;
	LDS  R31,_ABN_INFO
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF4
; 0000 0B1E                                 ABN_INFO.AbnBucketNum |= RxBuffer[dbufstart+9];
	MOVW R30,R20
	__ADDW1MN _RxBuffer,9
	LD   R30,Z
	LDS  R26,_ABN_INFO
	LDS  R27,_ABN_INFO+1
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0xF4
; 0000 0B1F                                 //Flash Memory Write
; 0000 0B20                                 //PUT_USR_INFO_DATA(GRADE_INFO_DATA);
; 0000 0B21                                 PUT_USR_INFO_DATA(SOL_INFO_DATA);
	CALL SUBOPT_0xF5
; 0000 0B22                                 PUT_USR_INFO_DATA(PACKER_INFO_DATA);
; 0000 0B23                                 //PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
; 0000 0B24                                 //PUT_USR_INFO_DATA(MEASURE_INFO_DATA);
; 0000 0B25                                 PUT_USR_INFO_DATA(PRT_INFO_DATA);
	LDI  R26,LOW(16)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0B26                                 PUT_USR_INFO_DATA(ABN_INFO_DATA);
	LDI  R26,LOW(19)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0B27                                 //PUT_USR_INFO_DATA(SYS_INFO_DATA);
; 0000 0B28 
; 0000 0B29                                 BuzzerOn();
	CALL _BuzzerOn
; 0000 0B2A                                 break;
	RJMP _0x41A
; 0000 0B2B                             case 0x02 :     //LOAD DATA
_0x41B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x42B
; 0000 0B2C                                 TxBuffer[0] = 0x02;
	LDI  R30,LOW(2)
	STS  _TxBuffer,R30
; 0000 0B2D                                 TxBuffer[3] = 0x30;
	LDI  R30,LOW(48)
	CALL SUBOPT_0xE0
; 0000 0B2E                                 TxBuffer[4] = 0x02;
; 0000 0B2F 
; 0000 0B30                                 dbufstart = 5;
	__GETWRN 20,21,5
; 0000 0B31 
; 0000 0B32                                 //###########################
; 0000 0B33                                 //###  Solenoid ON Time  ###
; 0000 0B34                                 //###########################
; 0000 0B35                                 for(lcnt = 0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x42D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x42E
; 0000 0B36                                     for(jcnt=0; jcnt<=5; jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x430:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x431
; 0000 0B37                                         oddbuf = dbufstart +  (jcnt * 2) + 1;
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
; 0000 0B38                                         evenbuf = dbufstart +  (jcnt * 2);
	CALL SUBOPT_0xF6
; 0000 0B39 
; 0000 0B3A                                         TxBuffer[evenbuf] = SOL_INFO[lcnt].ontime[jcnt] >> 8;             //High Byte
	CALL SUBOPT_0xE5
	CALL SUBOPT_0xF7
; 0000 0B3B                                         TxBuffer[oddbuf] = SOL_INFO[lcnt].ontime[jcnt] & 0xFF;           //Low Byte
	CALL SUBOPT_0xE5
	CALL SUBOPT_0xF8
; 0000 0B3C                                     }
	CALL SUBOPT_0xC1
	RJMP _0x430
_0x431:
; 0000 0B3D                                     dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0B3E                                 }
	CALL SUBOPT_0xDE
	RJMP _0x42D
_0x42E:
; 0000 0B3F 
; 0000 0B40                                 dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0B41                                 //###########################
; 0000 0B42                                 //###  Solenoid OFF Time  ###
; 0000 0B43                                 //###########################
; 0000 0B44                                 for(lcnt = 0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x433:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x434
; 0000 0B45                                     for(jcnt=0; jcnt<=5; jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x436:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x437
; 0000 0B46                                         oddbuf = dbufstart +  (jcnt * 2) + 1;
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
; 0000 0B47                                         evenbuf = dbufstart + (jcnt * 2);
	CALL SUBOPT_0xF6
; 0000 0B48 
; 0000 0B49                                         TxBuffer[evenbuf] = SOL_INFO[lcnt].offtime[jcnt] >> 8;             //High Byte
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xF7
; 0000 0B4A                                         TxBuffer[oddbuf] = SOL_INFO[lcnt].offtime[jcnt] & 0xFF;           //Low Byte
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xF8
; 0000 0B4B                                     }
	CALL SUBOPT_0xC1
	RJMP _0x436
_0x437:
; 0000 0B4C                                     dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0B4D                                 }
	CALL SUBOPT_0xDE
	RJMP _0x433
_0x434:
; 0000 0B4E 
; 0000 0B4F                                 dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0B50                                 //'########################################
; 0000 0B51                                 //'###  Solenoid Start Bucket Position  ###
; 0000 0B52                                 //'########################################
; 0000 0B53                                 for(lcnt = 0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x439:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x43A
; 0000 0B54                                     oddbuf = dbufstart + (lcnt * 2) + 1;
	CALL SUBOPT_0xEC
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0B55                                     evenbuf = dbufstart + (lcnt * 2);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xF9
; 0000 0B56 
; 0000 0B57                                     TxBuffer[evenbuf] = PACKER_INFO[lcnt].startpocketnumber >> 8;             //High Byt ...
	MOVW R22,R30
	CALL SUBOPT_0xFA
	LD   R26,X
	LDI  R30,LOW(8)
	CALL __LSRB12
	MOVW R26,R22
	CALL SUBOPT_0xFB
; 0000 0B58                                     TxBuffer[oddbuf] = PACKER_INFO[lcnt].startpocketnumber & 0xFF;           //Low Byte
	MOVW R0,R30
	CALL SUBOPT_0xFA
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0B59                                 }
	CALL SUBOPT_0xDE
	RJMP _0x439
_0x43A:
; 0000 0B5A 
; 0000 0B5B                                 dbufstart = oddbuf+1;
	CALL SUBOPT_0xEA
; 0000 0B5C                                 //###################################
; 0000 0B5D                                 //###  PRT Start Bucket Position  ###
; 0000 0B5E                                 //###################################
; 0000 0B5F                                 TxBuffer[dbufstart] = PRT_INFO[1].startpocketnumber >> 8;
	MOVW R26,R20
	SUBI R26,LOW(-_TxBuffer)
	SBCI R27,HIGH(-_TxBuffer)
	__GETW1MN _PRT_INFO,10
	CALL SUBOPT_0xFC
; 0000 0B60                                 TxBuffer[dbufstart + 1] = PRT_INFO[1].startpocketnumber & 0xFF;
	__ADDW1MN _TxBuffer,1
	MOVW R26,R30
	__GETB1MN _PRT_INFO,10
	ST   X,R30
; 0000 0B61                                 TxBuffer[dbufstart + 2] = PRT_INFO[2].startpocketnumber >> 8;
	MOVW R30,R20
	__ADDW1MN _TxBuffer,2
	MOVW R26,R30
	__GETW1MN _PRT_INFO,16
	CALL SUBOPT_0xFC
; 0000 0B62                                 TxBuffer[dbufstart + 3] = PRT_INFO[2].startpocketnumber & 0xFF;
	__ADDW1MN _TxBuffer,3
	MOVW R26,R30
	__GETB1MN _PRT_INFO,16
	ST   X,R30
; 0000 0B63 
; 0000 0B64                                 dbufstart = dbufstart + 4;
	__ADDWRN 20,21,4
; 0000 0B65                                 //#########################
; 0000 0B66                                 //###  PRT ON/OFF TIME  ###
; 0000 0B67                                 //#########################
; 0000 0B68                                 TxBuffer[dbufstart] = PRT_INFO[1].ontime >> 8;
	MOVW R26,R20
	SUBI R26,LOW(-_TxBuffer)
	SBCI R27,HIGH(-_TxBuffer)
	__GETW1MN _PRT_INFO,6
	CALL SUBOPT_0xFC
; 0000 0B69                                 TxBuffer[dbufstart+1] = PRT_INFO[1].ontime & 0xFF;
	__ADDW1MN _TxBuffer,1
	MOVW R26,R30
	__GETB1MN _PRT_INFO,6
	ST   X,R30
; 0000 0B6A                                 TxBuffer[dbufstart+2] = PRT_INFO[1].offtime >> 8;
	MOVW R30,R20
	__ADDW1MN _TxBuffer,2
	MOVW R26,R30
	__GETW1MN _PRT_INFO,8
	CALL SUBOPT_0xFC
; 0000 0B6B                                 TxBuffer[dbufstart+3] = PRT_INFO[1].offtime & 0xFF;
	__ADDW1MN _TxBuffer,3
	MOVW R26,R30
	__GETB1MN _PRT_INFO,8
	ST   X,R30
; 0000 0B6C 
; 0000 0B6D                                 TxBuffer[dbufstart+4] = PRT_INFO[2].ontime >> 8;
	MOVW R30,R20
	__ADDW1MN _TxBuffer,4
	MOVW R26,R30
	__GETW1MN _PRT_INFO,12
	CALL SUBOPT_0xFC
; 0000 0B6E                                 TxBuffer[dbufstart+5] = PRT_INFO[2].ontime & 0xFF;
	__ADDW1MN _TxBuffer,5
	MOVW R26,R30
	__GETB1MN _PRT_INFO,12
	ST   X,R30
; 0000 0B6F                                 TxBuffer[dbufstart+6] = PRT_INFO[2].offtime >> 8;
	MOVW R30,R20
	__ADDW1MN _TxBuffer,6
	MOVW R26,R30
	__GETW1MN _PRT_INFO,14
	CALL SUBOPT_0xFC
; 0000 0B70                                 TxBuffer[dbufstart+7] = PRT_INFO[2].offtime & 0xFF;
	__ADDW1MN _TxBuffer,7
	MOVW R26,R30
	__GETB1MN _PRT_INFO,14
	ST   X,R30
; 0000 0B71 
; 0000 0B72                                 TxBuffer[dbufstart+8] = ABN_INFO.AbnBucketNum  >> 8;
	MOVW R30,R20
	__ADDW1MN _TxBuffer,8
	MOVW R26,R30
	LDS  R30,_ABN_INFO+1
	ST   X,R30
; 0000 0B73                                 TxBuffer[dbufstart+9] = ABN_INFO.AbnBucketNum & 0xFF;
	MOVW R30,R20
	__ADDW1MN _TxBuffer,9
	MOVW R26,R30
	LDS  R30,_ABN_INFO
	ST   X,R30
; 0000 0B74 
; 0000 0B75                                 dbufstart = dbufstart + 10;
	__ADDWRN 20,21,10
; 0000 0B76                                 //###########################
; 0000 0B77                                 //###  ETX & Data Length  ###
; 0000 0B78                                 //###########################
; 0000 0B79                                 TxBuffer[1] = (dbufstart-3) >> 8;
	MOVW R30,R20
	SBIW R30,3
	CALL SUBOPT_0x5A
; 0000 0B7A                                 TxBuffer[2] = (dbufstart-3) & 0xFF;
	MOV  R30,R20
	SUBI R30,LOW(3)
	__PUTB1MN _TxBuffer,2
; 0000 0B7B                                 TxBuffer[dbufstart] = 0x03;
	LDI  R26,LOW(_TxBuffer)
	LDI  R27,HIGH(_TxBuffer)
	ADD  R26,R20
	ADC  R27,R21
	LDI  R30,LOW(3)
	ST   X,R30
; 0000 0B7C 
; 0000 0B7D                                 TxEnable = 1;   txcnt = 1;  TxLength = dbufstart+1;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xE1
	MOVW R30,R20
	ADIW R30,1
	CALL SUBOPT_0x93
; 0000 0B7E                                 BuzzerOn();
	CALL _BuzzerOn
; 0000 0B7F                                 break;
; 0000 0B80                             case 0x00 :     //INIT DATA
_0x42B:
; 0000 0B81                                 break;
; 0000 0B82                         }
_0x41A:
; 0000 0B83 
; 0000 0B84                         break;
	RJMP _0x3C0
; 0000 0B85                     case CMD_GRADEINFO : //0x40 :: 등급별 상하한 값, 인쇄수량, 팩커 위치정보, 솔레노이드 갯수, 팩커 난좌 ...
_0x417:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x43C
; 0000 0B86                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0B87                             case 0x01 :     //SAVE DATA
	BREQ PC+2
	RJMP _0x440
; 0000 0B88                                 //#######################
; 0000 0B89                                 //###  등급별 상한값  ###
; 0000 0B8A                                 //#######################
; 0000 0B8B                                 dbufstart = 2;
	__GETWRN 20,21,2
; 0000 0B8C 
; 0000 0B8D                                 for(lcnt=0;lcnt<=6;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x442:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,7
	BRSH _0x443
; 0000 0B8E                                     evenbuf = dbufstart + (lcnt * 2);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xFD
; 0000 0B8F                                     oddbuf = dbufstart + (lcnt * 2) + 1;
	CALL SUBOPT_0xFE
; 0000 0B90                                     if(lcnt==6){
	BRNE _0x444
; 0000 0B91                                         GRADE_INFO[8].hiLimit = RxBuffer[evenbuf];
	__POINTW2MN _GRADE_INFO,80
	CALL SUBOPT_0xEE
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0B92                                         GRADE_INFO[8].hiLimit <<= 8;
	__GETB1HMN _GRADE_INFO,80
	LDI  R30,LOW(0)
	__PUTW1MN _GRADE_INFO,80
; 0000 0B93                                         GRADE_INFO[8].hiLimit |= RxBuffer[oddbuf];
	__GETW2MN _GRADE_INFO,80
	CALL SUBOPT_0xF0
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _GRADE_INFO,80
; 0000 0B94                                     }
; 0000 0B95                                     else{
	RJMP _0x445
_0x444:
; 0000 0B96                                         GRADE_INFO[lcnt].hiLimit = RxBuffer[evenbuf];
	CALL SUBOPT_0xDF
	SUBI R30,LOW(-_GRADE_INFO)
	SBCI R31,HIGH(-_GRADE_INFO)
	MOVW R26,R30
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFF
; 0000 0B97                                         GRADE_INFO[lcnt].hiLimit <<= 8;
	SUBI R30,LOW(-_GRADE_INFO)
	SBCI R31,HIGH(-_GRADE_INFO)
	CALL SUBOPT_0x100
; 0000 0B98                                         GRADE_INFO[lcnt].hiLimit |= RxBuffer[oddbuf];
	SUBI R30,LOW(-_GRADE_INFO)
	SBCI R31,HIGH(-_GRADE_INFO)
	CALL SUBOPT_0xE9
; 0000 0B99                                     }
_0x445:
; 0000 0B9A                                 }
	CALL SUBOPT_0xDE
	RJMP _0x442
_0x443:
; 0000 0B9B 
; 0000 0B9C                                 //#######################
; 0000 0B9D                                 //###  등급별 하한값  ###
; 0000 0B9E                                 //#######################
; 0000 0B9F                                 dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0BA0 
; 0000 0BA1                                 for(lcnt=0;lcnt<=6;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x447:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,7
	BRSH _0x448
; 0000 0BA2                                     evenbuf = dbufstart + (lcnt * 2);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xFD
; 0000 0BA3                                     oddbuf = dbufstart + (lcnt * 2) + 1;
	CALL SUBOPT_0xFE
; 0000 0BA4                                     if(lcnt==6){
	BRNE _0x449
; 0000 0BA5                                         GRADE_INFO[8].loLimit = RxBuffer[evenbuf];
	__POINTW2MN _GRADE_INFO,82
	CALL SUBOPT_0xEE
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0BA6                                         GRADE_INFO[8].loLimit <<= 8;
	__GETB1HMN _GRADE_INFO,82
	LDI  R30,LOW(0)
	__PUTW1MN _GRADE_INFO,82
; 0000 0BA7                                         GRADE_INFO[8].loLimit |= RxBuffer[oddbuf];
	__GETW2MN _GRADE_INFO,82
	CALL SUBOPT_0xF0
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1MN _GRADE_INFO,82
; 0000 0BA8                                     }
; 0000 0BA9                                     else{
	RJMP _0x44A
_0x449:
; 0000 0BAA                                         GRADE_INFO[lcnt].loLimit = RxBuffer[evenbuf];
	CALL SUBOPT_0xDF
	__ADDW1MN _GRADE_INFO,2
	MOVW R26,R30
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFF
; 0000 0BAB                                         GRADE_INFO[lcnt].loLimit <<= 8;
	__ADDW1MN _GRADE_INFO,2
	CALL SUBOPT_0x100
; 0000 0BAC                                         GRADE_INFO[lcnt].loLimit |= RxBuffer[oddbuf];
	__ADDW1MN _GRADE_INFO,2
	CALL SUBOPT_0xE9
; 0000 0BAD                                     }
_0x44A:
; 0000 0BAE                                 }
	CALL SUBOPT_0xDE
	RJMP _0x447
_0x448:
; 0000 0BAF 
; 0000 0BB0                                 //#########################
; 0000 0BB1                                 //###  등급별 인쇄수량  ###
; 0000 0BB2                                 //#########################
; 0000 0BB3                                 dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0BB4 
; 0000 0BB5                                 for(lcnt=0;lcnt<=8;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x44C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x44D
; 0000 0BB6                                     evenbuf = dbufstart + (lcnt * 2);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xFD
; 0000 0BB7                                     oddbuf = dbufstart + (lcnt * 2) + 1;
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0BB8 
; 0000 0BB9                                     GRADE_INFO[lcnt].prtSetCount = RxBuffer[evenbuf];
	CALL SUBOPT_0xDF
	__ADDW1MN _GRADE_INFO,6
	MOVW R26,R30
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFF
; 0000 0BBA                                     GRADE_INFO[lcnt].prtSetCount <<= 8;
	__ADDW1MN _GRADE_INFO,6
	CALL SUBOPT_0x100
; 0000 0BBB                                     GRADE_INFO[lcnt].prtSetCount |= RxBuffer[oddbuf];
	__ADDW1MN _GRADE_INFO,6
	CALL SUBOPT_0xE9
; 0000 0BBC                                 }
	CALL SUBOPT_0xDE
	RJMP _0x44C
_0x44D:
; 0000 0BBD 
; 0000 0BBE                                 //#########################
; 0000 0BBF                                 //###  등급별 인쇄형태  ###
; 0000 0BC0                                 //#########################
; 0000 0BC1                                 dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0BC2 
; 0000 0BC3                                 for(lcnt=0;lcnt<=8;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x44F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x450
; 0000 0BC4                                     evenbuf = dbufstart + lcnt;
	CALL SUBOPT_0x101
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0BC5 
; 0000 0BC6                                     GRADE_INFO[lcnt].prttype = RxBuffer[evenbuf];
	CALL SUBOPT_0xDF
	__ADDW1MN _GRADE_INFO,5
	MOVW R26,R30
	CALL SUBOPT_0xEE
	ST   X,R30
; 0000 0BC7                                     old_prttype[lcnt] = GRADE_INFO[lcnt].prttype;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_old_prttype)
	SBCI R31,HIGH(-_old_prttype)
	CALL SUBOPT_0x102
	CALL SUBOPT_0x103
; 0000 0BC8 
; 0000 0BC9                                 }
	CALL SUBOPT_0xDE
	RJMP _0x44F
_0x450:
; 0000 0BCA 
; 0000 0BCB                                 //################################
; 0000 0BCC                                 //###  팩커별 솔레노이드 수량  ###
; 0000 0BCD                                 //################################
; 0000 0BCE                                 dbufstart = evenbuf + 1;
	CALL SUBOPT_0x104
; 0000 0BCF 
; 0000 0BD0                                 for(lcnt=0;lcnt<=7;lcnt++){
_0x452:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x453
; 0000 0BD1                                     evenbuf = dbufstart + lcnt;
	CALL SUBOPT_0x101
	CALL SUBOPT_0xED
; 0000 0BD2 
; 0000 0BD3                                     PACKER_INFO[lcnt].solcount = RxBuffer[evenbuf];
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL SUBOPT_0xEE
	ST   X,R30
; 0000 0BD4                                 }
	CALL SUBOPT_0xDE
	RJMP _0x452
_0x453:
; 0000 0BD5 
; 0000 0BD6                                 //################################
; 0000 0BD7                                 //###  등급별 솔레노이드 수량  ###
; 0000 0BD8                                 //################################
; 0000 0BD9                                 dbufstart = evenbuf + 1;
	CALL SUBOPT_0x104
; 0000 0BDA 
; 0000 0BDB                                 for(lcnt=0;lcnt<=7;lcnt++){
_0x455:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x456
; 0000 0BDC                                     evenbuf = dbufstart + lcnt;
	CALL SUBOPT_0x101
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0BDD 
; 0000 0BDE                                     GRADE_INFO[lcnt].solenoidnumber = RxBuffer[evenbuf];
	CALL SUBOPT_0xDF
	__ADDW1MN _GRADE_INFO,4
	MOVW R26,R30
	CALL SUBOPT_0xEE
	ST   X,R30
; 0000 0BDF                                 }
	CALL SUBOPT_0xDE
	RJMP _0x455
_0x456:
; 0000 0BE0 
; 0000 0BE1                                 //#########################
; 0000 0BE2                                 //###  팩커별 등급정보  ###
; 0000 0BE3                                 //#########################
; 0000 0BE4                                 dbufstart = evenbuf + 1;
	CALL SUBOPT_0x104
; 0000 0BE5 
; 0000 0BE6                                 for(lcnt=0;lcnt<=8;lcnt++){
_0x458:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x459
; 0000 0BE7                                     evenbuf = dbufstart + (2 * lcnt);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xFD
; 0000 0BE8                                     oddbuf = dbufstart + (2 * lcnt) + 1;
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0BE9 
; 0000 0BEA                                     PACKER_INFO[lcnt].gradetype = RxBuffer[evenbuf];
	CALL SUBOPT_0x105
	CALL SUBOPT_0xEE
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0BEB                                     PACKER_INFO[lcnt].gradetype <<= 8;
	CALL SUBOPT_0x105
	LD   R30,X+
	LD   R31,X+
	MOV  R31,R30
	LDI  R30,0
	ST   -X,R31
	ST   -X,R30
; 0000 0BEC                                     PACKER_INFO[lcnt].gradetype |= RxBuffer[oddbuf];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	CALL SUBOPT_0x47
	CALL SUBOPT_0xE9
; 0000 0BED                                 }
	CALL SUBOPT_0xDE
	RJMP _0x458
_0x459:
; 0000 0BEE 
; 0000 0BEF                                 //#########################################
; 0000 0BF0                                 //###  등외란-파란 팩커 공용 사용 설정  ###
; 0000 0BF1                                 //###  2014.11.24 수정                  ###
; 0000 0BF2                                 //#########################################
; 0000 0BF3                                 PackerSharedEnable = PACKER_INFO[8].gradetype;
	__GETB1MN _PACKER_INFO,32
	STS  _PackerSharedEnable,R30
; 0000 0BF4 
; 0000 0BF5                                 //##############################
; 0000 0BF6                                 //###  팩커별 솔레노이드 ID  ###
; 0000 0BF7                                 //##############################
; 0000 0BF8                                 dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0BF9 
; 0000 0BFA                                 for(lcnt=0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x45B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x45C
; 0000 0BFB                                     for(jcnt=0;jcnt<=5;jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x45E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x45F
; 0000 0BFC                                         evenbuf = dbufstart + (jcnt * 2);
	CALL SUBOPT_0xE2
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0BFD                                         oddbuf = dbufstart + (jcnt * 2) + 1;
	CALL SUBOPT_0xE2
	ADIW R30,1
	CALL SUBOPT_0x106
; 0000 0BFE 
; 0000 0BFF                                         SOL_INFO[lcnt].sol_id[jcnt]=RxBuffer[evenbuf];
	CALL SUBOPT_0x107
	CALL SUBOPT_0xE6
; 0000 0C00                                         SOL_INFO[lcnt].sol_id[jcnt]<<=8;
	CALL SUBOPT_0x107
	CALL SUBOPT_0xE7
; 0000 0C01                                         SOL_INFO[lcnt].sol_id[jcnt]|=RxBuffer[oddbuf];
	__ADDW1MN _SOL_INFO,36
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xE9
; 0000 0C02                                     }
	CALL SUBOPT_0xC1
	RJMP _0x45E
_0x45F:
; 0000 0C03                                     dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0C04                                 }
	CALL SUBOPT_0xDE
	RJMP _0x45B
_0x45C:
; 0000 0C05 
; 0000 0C06                                 //#####################################
; 0000 0C07                                 //###  팩커별 솔레노이드 출력 신호  ###
; 0000 0C08                                 //#####################################
; 0000 0C09                                 dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0C0A 
; 0000 0C0B                                 for(lcnt=0;lcnt<=7;lcnt++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x461:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x462
; 0000 0C0C                                     for(jcnt=0;jcnt<=5;jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x464:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x465
; 0000 0C0D                                         oddbuf = dbufstart + jcnt;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADD  R30,R20
	ADC  R31,R21
	CALL SUBOPT_0x106
; 0000 0C0E                                         SOL_INFO[lcnt].outsignal[jcnt] = RxBuffer[oddbuf];
	CALL SUBOPT_0x108
	CALL SUBOPT_0xF0
	ST   X,R30
; 0000 0C0F                                     }
	CALL SUBOPT_0xC1
	RJMP _0x464
_0x465:
; 0000 0C10                                     dbufstart = oddbuf + 1;
	CALL SUBOPT_0xEA
; 0000 0C11                                 }
	CALL SUBOPT_0xDE
	RJMP _0x461
_0x462:
; 0000 0C12 
; 0000 0C13                                 //Data Save Flash Memory
; 0000 0C14                                 PUT_USR_INFO_DATA(GRADE_INFO_DATA);
	LDI  R26,LOW(11)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0C15                                 PUT_USR_INFO_DATA(SOL_INFO_DATA);
	CALL SUBOPT_0xF5
; 0000 0C16                                 PUT_USR_INFO_DATA(PACKER_INFO_DATA);
; 0000 0C17 
; 0000 0C18                                 BuzzerOn();
	CALL _BuzzerOn
; 0000 0C19                                 break;
	RJMP _0x43F
; 0000 0C1A                             case 0x02 :     //REQ DATA
_0x440:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x466
; 0000 0C1B                                 //#######################
; 0000 0C1C                                 //###  등급별 상한값  ###
; 0000 0C1D                                 //#######################
; 0000 0C1E                                 TxBuffer[0] = 0x02;
	LDI  R30,LOW(2)
	STS  _TxBuffer,R30
; 0000 0C1F                                 TxBuffer[3] = 0x40;
	LDI  R30,LOW(64)
	CALL SUBOPT_0xE0
; 0000 0C20                                 TxBuffer[4] = 0x02;
; 0000 0C21 
; 0000 0C22                                 bufpos = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0C23                                 if(GRADE_INFO[0].hiLimit<100){
	LDS  R26,_GRADE_INFO
	LDS  R27,_GRADE_INFO+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x467
; 0000 0C24                                     GRADE_INFO[0].hiLimit = GRADE_INFO[8].hiLimit - 1;
	CALL SUBOPT_0xBE
; 0000 0C25                                 }
; 0000 0C26 
; 0000 0C27                                 for(lcnt=0;lcnt<=6;lcnt++){
_0x467:
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x469:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,7
	BRSH _0x46A
; 0000 0C28                                     evenbuf = bufpos + (lcnt * 2);
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
; 0000 0C29                                     oddbuf = bufpos + (lcnt * 2) + 1;
	CALL SUBOPT_0xFE
; 0000 0C2A                                     if(lcnt==6){
	BRNE _0x46B
; 0000 0C2B                                         TxBuffer[evenbuf] = GRADE_INFO[8].hiLimit >>8 ;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_TxBuffer)
	SBCI R27,HIGH(-_TxBuffer)
	__GETW1MN _GRADE_INFO,80
	CALL SUBOPT_0x10B
; 0000 0C2C                                         TxBuffer[oddbuf] = GRADE_INFO[8].hiLimit & 0xFF;
	__GETB1MN _GRADE_INFO,80
	RJMP _0x4DB
; 0000 0C2D                                     }
; 0000 0C2E                                     else{
_0x46B:
; 0000 0C2F                                         TxBuffer[evenbuf] = GRADE_INFO[lcnt].hiLimit >>8 ;
	CALL SUBOPT_0x10C
	SUBI R30,LOW(-_GRADE_INFO)
	SBCI R31,HIGH(-_GRADE_INFO)
	CALL SUBOPT_0x10D
; 0000 0C30                                         TxBuffer[oddbuf] = GRADE_INFO[lcnt].hiLimit & 0xFF;
	CALL SUBOPT_0x102
	SUBI R30,LOW(-_GRADE_INFO)
	SBCI R31,HIGH(-_GRADE_INFO)
	LD   R30,Z
	__GETW2R 23,24
_0x4DB:
	ST   X,R30
; 0000 0C31                                     }
; 0000 0C32                                 }
	CALL SUBOPT_0xDE
	RJMP _0x469
_0x46A:
; 0000 0C33 
; 0000 0C34                                 //#######################
; 0000 0C35                                 //###  등급별 하한값  ###
; 0000 0C36                                 //#######################
; 0000 0C37                                 bufpos = oddbuf + 1;
	CALL SUBOPT_0x10E
; 0000 0C38 
; 0000 0C39                                 for(lcnt=0;lcnt<=6;lcnt++){
_0x46E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,7
	BRSH _0x46F
; 0000 0C3A                                     evenbuf = bufpos + (lcnt * 2);
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
; 0000 0C3B                                     oddbuf = bufpos + (lcnt * 2) + 1;
	CALL SUBOPT_0xFE
; 0000 0C3C                                     if(lcnt==6){
	BRNE _0x470
; 0000 0C3D                                         TxBuffer[evenbuf] = GRADE_INFO[8].loLimit >> 8;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_TxBuffer)
	SBCI R27,HIGH(-_TxBuffer)
	__GETW1MN _GRADE_INFO,82
	CALL SUBOPT_0x10B
; 0000 0C3E                                         TxBuffer[oddbuf] = GRADE_INFO[8].loLimit & 0xFF;
	__GETB1MN _GRADE_INFO,82
	RJMP _0x4DC
; 0000 0C3F                                     }
; 0000 0C40                                     else{
_0x470:
; 0000 0C41                                         TxBuffer[evenbuf] = GRADE_INFO[lcnt].loLimit >> 8;
	CALL SUBOPT_0x10C
	__ADDW1MN _GRADE_INFO,2
	CALL SUBOPT_0x10D
; 0000 0C42                                         TxBuffer[oddbuf] = GRADE_INFO[lcnt].loLimit & 0xFF;
	CALL SUBOPT_0x102
	__ADDW1MN _GRADE_INFO,2
	LD   R30,Z
	__GETW2R 23,24
_0x4DC:
	ST   X,R30
; 0000 0C43                                     }
; 0000 0C44                                 }
	CALL SUBOPT_0xDE
	RJMP _0x46E
_0x46F:
; 0000 0C45 
; 0000 0C46                                 //#########################
; 0000 0C47                                 //###  등급별 인쇄수량  ###
; 0000 0C48                                 //#########################
; 0000 0C49                                 bufpos = oddbuf + 1;
	CALL SUBOPT_0x10E
; 0000 0C4A 
; 0000 0C4B                                 for(lcnt=0;lcnt<=8;lcnt++){
_0x473:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x474
; 0000 0C4C                                     evenbuf = bufpos + (lcnt * 2);
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
; 0000 0C4D                                     oddbuf = bufpos + (lcnt * 2) + 1;
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0C4E 
; 0000 0C4F                                     TxBuffer[evenbuf] = GRADE_INFO[lcnt].prtSetCount >> 8;
	CALL SUBOPT_0x10C
	__ADDW1MN _GRADE_INFO,6
	CALL SUBOPT_0x10D
; 0000 0C50                                     TxBuffer[oddbuf] = GRADE_INFO[lcnt].prtSetCount & 0xFF;
	CALL SUBOPT_0x102
	__ADDW1MN _GRADE_INFO,6
	LD   R30,Z
	__GETW2R 23,24
	ST   X,R30
; 0000 0C51                                 }
	CALL SUBOPT_0xDE
	RJMP _0x473
_0x474:
; 0000 0C52 
; 0000 0C53                                 //#########################
; 0000 0C54                                 //###  등급별 인쇄형태  ###
; 0000 0C55                                 //#########################
; 0000 0C56                                 bufpos = oddbuf + 1;
	CALL SUBOPT_0x10E
; 0000 0C57 
; 0000 0C58                                 for(lcnt=0;lcnt<=8;lcnt++){
_0x476:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x477
; 0000 0C59                                     evenbuf = bufpos + lcnt;
	CALL SUBOPT_0x10F
; 0000 0C5A 
; 0000 0C5B                                     TxBuffer[evenbuf] = GRADE_INFO[lcnt].prttype;
	CALL SUBOPT_0x102
	CALL SUBOPT_0x103
; 0000 0C5C                                 }
	CALL SUBOPT_0xDE
	RJMP _0x476
_0x477:
; 0000 0C5D 
; 0000 0C5E                                 //################################
; 0000 0C5F                                 //###  팩커별 솔레노이드 수량  ###
; 0000 0C60                                 //################################
; 0000 0C61                                 bufpos = evenbuf + 1;
	CALL SUBOPT_0x110
; 0000 0C62 
; 0000 0C63                                 for(lcnt=0;lcnt<=7;lcnt++){
_0x479:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x47A
; 0000 0C64                                     evenbuf = bufpos + lcnt;
	CALL SUBOPT_0x10F
; 0000 0C65 
; 0000 0C66                                     TxBuffer[evenbuf] = PACKER_INFO[lcnt].solcount;
	MOVW R0,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0C67                                 }
	CALL SUBOPT_0xDE
	RJMP _0x479
_0x47A:
; 0000 0C68 
; 0000 0C69 
; 0000 0C6A                                 //################################
; 0000 0C6B                                 //###  등급별 솔레노이드 수량  ###
; 0000 0C6C                                 //################################
; 0000 0C6D                                 bufpos = evenbuf + 1;
	CALL SUBOPT_0x110
; 0000 0C6E 
; 0000 0C6F                                 for(lcnt=0;lcnt<=7;lcnt++){
_0x47C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x47D
; 0000 0C70                                     evenbuf = bufpos + lcnt;
	CALL SUBOPT_0x10F
; 0000 0C71 
; 0000 0C72                                     TxBuffer[evenbuf]= GRADE_INFO[lcnt].solenoidnumber;
	CALL SUBOPT_0x102
	__ADDW1MN _GRADE_INFO,4
	LD   R30,Z
	__GETW2R 23,24
	ST   X,R30
; 0000 0C73                                 }
	CALL SUBOPT_0xDE
	RJMP _0x47C
_0x47D:
; 0000 0C74 
; 0000 0C75                                 //#########################
; 0000 0C76                                 //###  팩커별 등급정보  ###
; 0000 0C77                                 //#########################
; 0000 0C78                                 bufpos = evenbuf + 1;
	CALL SUBOPT_0x110
; 0000 0C79 
; 0000 0C7A                                 for(lcnt=0;lcnt<=8;lcnt++){
_0x47F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRSH _0x480
; 0000 0C7B                                     evenbuf = bufpos + (2 * lcnt);
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
; 0000 0C7C                                     oddbuf = bufpos + (2 * lcnt) + 1;
	CALL SUBOPT_0x111
; 0000 0C7D 
; 0000 0C7E                                     TxBuffer[evenbuf] = PACKER_INFO[lcnt].gradetype >> 8;
	MOVW R0,R30
	CALL SUBOPT_0x105
	CALL __GETW1P
	CALL __ASRW8
	MOVW R26,R0
	CALL SUBOPT_0xFB
; 0000 0C7F                                     TxBuffer[oddbuf] = PACKER_INFO[lcnt].gradetype & 0xFF;
	MOVW R0,R30
	CALL SUBOPT_0x105
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0C80                                 }
	CALL SUBOPT_0xDE
	RJMP _0x47F
_0x480:
; 0000 0C81 
; 0000 0C82                                 //##############################
; 0000 0C83                                 //###  팩커별 솔레노이드 ID  ###
; 0000 0C84                                 //##############################
; 0000 0C85                                 bufpos = oddbuf + 1;
	CALL SUBOPT_0x10E
; 0000 0C86 
; 0000 0C87                                 for(lcnt=0;lcnt<=7;lcnt++){
_0x482:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x483
; 0000 0C88                                     for(jcnt=0;jcnt<=5;jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x485:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x486
; 0000 0C89                                         evenbuf = bufpos + (jcnt * 2);
	CALL SUBOPT_0x112
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0C8A                                         oddbuf = bufpos + (jcnt * 2) + 1;
	CALL SUBOPT_0x112
	CALL SUBOPT_0x111
; 0000 0C8B 
; 0000 0C8C                                         TxBuffer[evenbuf] = SOL_INFO[lcnt].sol_id[jcnt] >> 8;
	CALL SUBOPT_0x113
	CALL SUBOPT_0x107
	CALL SUBOPT_0xF7
; 0000 0C8D                                         TxBuffer[oddbuf] = SOL_INFO[lcnt].sol_id[jcnt] & 0xFF;
	CALL SUBOPT_0x107
	CALL SUBOPT_0xF8
; 0000 0C8E                                     }
	CALL SUBOPT_0xC1
	RJMP _0x485
_0x486:
; 0000 0C8F                                     bufpos = oddbuf + 1;
	CALL SUBOPT_0x114
; 0000 0C90                                 }
	CALL SUBOPT_0xDE
	RJMP _0x482
_0x483:
; 0000 0C91 
; 0000 0C92                                 //#####################################
; 0000 0C93                                 //###  팩커별 솔레노이드 출력 신호  ###
; 0000 0C94                                 //#####################################
; 0000 0C95                                 bufpos = oddbuf + 1;
	CALL SUBOPT_0x10E
; 0000 0C96 
; 0000 0C97                                 for(lcnt=0;lcnt<=7;lcnt++){
_0x488:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRSH _0x489
; 0000 0C98                                     for(jcnt=0;jcnt<=5;jcnt++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x48B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BRSH _0x48C
; 0000 0C99                                         oddbuf = bufpos + jcnt;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0C9A                                         TxBuffer[oddbuf] = SOL_INFO[lcnt].outsignal[jcnt];
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	CALL SUBOPT_0x113
	CALL SUBOPT_0x108
	LD   R30,X
	__GETW2R 23,24
	ST   X,R30
; 0000 0C9B                                     }
	CALL SUBOPT_0xC1
	RJMP _0x48B
_0x48C:
; 0000 0C9C                                     bufpos = oddbuf + 1;
	CALL SUBOPT_0x114
; 0000 0C9D                                 }
	CALL SUBOPT_0xDE
	RJMP _0x488
_0x489:
; 0000 0C9E 
; 0000 0C9F                                 //###############################
; 0000 0CA0                                 //###  ETX & DATA LENGTH SET  ###
; 0000 0CA1                                 //###############################
; 0000 0CA2                                 bufpos = oddbuf + 1;
	CALL SUBOPT_0x114
; 0000 0CA3                                 TxBuffer[bufpos] = 0x03;
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	LDI  R26,LOW(3)
	STD  Z+0,R26
; 0000 0CA4 
; 0000 0CA5                                 //Data Length Setting
; 0000 0CA6                                 TxBuffer[1] = (bufpos - 3)>>8;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,3
	CALL SUBOPT_0x5A
; 0000 0CA7                                 TxBuffer[2] = (bufpos - 3)&0xFF;
	LD   R30,Y
	SUBI R30,LOW(3)
	__PUTB1MN _TxBuffer,2
; 0000 0CA8 
; 0000 0CA9                                 TxEnable = 1;   txcnt = 1;  TxLength = bufpos+1;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xE1
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	CALL SUBOPT_0x93
; 0000 0CAA                                 BuzzerOn();
	CALL _BuzzerOn
; 0000 0CAB                                 break;
; 0000 0CAC                             case 0x00 :     //INIT DATA
_0x466:
; 0000 0CAD                                 break;
; 0000 0CAE                         }
_0x43F:
; 0000 0CAF                         break;
	RJMP _0x3C0
; 0000 0CB0                     case CMD_ENCODER_CHK ://0xE1 ::엔코더A상 카운터값 표시
_0x43C:
	CPI  R30,LOW(0xE1)
	LDI  R26,HIGH(0xE1)
	CPC  R31,R26
	BRNE _0x48E
; 0000 0CB1                         BuzzerOn();
	CALL _BuzzerOn
; 0000 0CB2                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0CB3                             case 0x01 :     //표시시작
	BRNE _0x492
; 0000 0CB4                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0CB5                                 delay_ms(200);
; 0000 0CB6                                 TxEnable = 0;
	LDI  R30,LOW(0)
	STS  _TxEnable,R30
; 0000 0CB7                                 modRunning = ENCODER_CHK;
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 0CB8                                 break;
	RJMP _0x491
; 0000 0CB9                             case 0x02 :     //표시정지
_0x492:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x491
; 0000 0CBA                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0CBB                                 delay_ms(200);
; 0000 0CBC                                 TxEnable = 0;
	LDI  R30,LOW(0)
	STS  _TxEnable,R30
; 0000 0CBD                                 modRunning =  MACHINE_STOP;
	CLR  R10
; 0000 0CBE                                 break;
; 0000 0CBF                         }
_0x491:
; 0000 0CC0                         break;
	RJMP _0x3C0
; 0000 0CC1                     case CMD_SOLTEST :    //0xB0::솔레노이드, 팩커, 인쇄기 개별 동작 시험
_0x48E:
	CPI  R30,LOW(0xB0)
	LDI  R26,HIGH(0xB0)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x494
; 0000 0CC2                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0CC3                             //솔레노이드1번~6번 동작 시험
; 0000 0CC4                             case 0x01 : case 0x02: case 0x03: case 0x04: case 0x05 : case 0x06 :
	BREQ _0x499
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x49A
_0x499:
	RJMP _0x49B
_0x49A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x49C
_0x49B:
	RJMP _0x49D
_0x49C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x49E
_0x49D:
	RJMP _0x49F
_0x49E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4A0
_0x49F:
	RJMP _0x4A1
_0x4A0:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4A2
_0x4A1:
; 0000 0CC5                                 ExtPort_TEST(0xFF, RxBuffer[1]-1,Signal_ON, RxBuffer[2]-1);
	CALL SUBOPT_0x115
	CALL SUBOPT_0x116
; 0000 0CC6                                 delay_ms(100);
; 0000 0CC7                                 ExtPort_TEST(0xFF, RxBuffer[1]-1,Signal_OFF, RxBuffer[2]-1);
	CALL SUBOPT_0x115
	CALL SUBOPT_0x117
; 0000 0CC8                                 delay_ms(100);
; 0000 0CC9                                 break;
	RJMP _0x497
; 0000 0CCA                             //팩커 기동 신호
; 0000 0CCB                             case 0x07 :
_0x4A2:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x4A3
; 0000 0CCC                                 ExtPort_TEST(0xFF, RxBuffer[1],Signal_ON, RxBuffer[2]-1);
	CALL SUBOPT_0x118
	CALL SUBOPT_0x116
; 0000 0CCD                                 delay_ms(100);
; 0000 0CCE                                 ExtPort_TEST(0xFF, RxBuffer[1],Signal_OFF, RxBuffer[2]-1);
	CALL SUBOPT_0x118
	CALL SUBOPT_0x117
; 0000 0CCF                                 delay_ms(100);
; 0000 0CD0                                 break;
	RJMP _0x497
; 0000 0CD1                             //인쇄기 A구동
; 0000 0CD2                             case 0x08 :
_0x4A3:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4A4
; 0000 0CD3                                 ExtPort_TEST(0x02, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x119
	CALL SUBOPT_0x11A
; 0000 0CD4                                 delay_ms(100);
; 0000 0CD5                                 ExtPort_TEST(0x02, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x119
	CALL SUBOPT_0x11B
; 0000 0CD6                                 delay_ms(100);
; 0000 0CD7                                 break;
	RJMP _0x497
; 0000 0CD8                             //인쇄기 B구동
; 0000 0CD9                             case 0x09 :
_0x4A4:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x4A5
; 0000 0CDA                                 ExtPort_TEST(0x03, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x11A
; 0000 0CDB                                 delay_ms(100);
; 0000 0CDC                                 ExtPort_TEST(0x03, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x11B
; 0000 0CDD                                 delay_ms(100);
; 0000 0CDE                                 break;
	RJMP _0x497
; 0000 0CDF                             case 0x10 :
_0x4A5:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x4A6
; 0000 0CE0                                 ExtPort_TEST(0x10, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x11A
; 0000 0CE1                                 delay_ms(100);
; 0000 0CE2                                 ExtPort_TEST(0x10, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x11B
; 0000 0CE3                                 delay_ms(100);
; 0000 0CE4                                 break;
	RJMP _0x497
; 0000 0CE5                             case 0x20 :
_0x4A6:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x4A7
; 0000 0CE6                                 ExtPort_TEST(0x20, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11A
; 0000 0CE7                                 delay_ms(100);
; 0000 0CE8                                 ExtPort_TEST(0x20, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11B
; 0000 0CE9                                 delay_ms(100);
; 0000 0CEA                                 break;
	RJMP _0x497
; 0000 0CEB                             case 0x30 :
_0x4A7:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x4A8
; 0000 0CEC                                 ExtPort_TEST(0x30, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x11F
	CALL SUBOPT_0x11A
; 0000 0CED                                 delay_ms(100);
; 0000 0CEE                                 ExtPort_TEST(0x30, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x11F
	CALL SUBOPT_0x11B
; 0000 0CEF                                 delay_ms(100);
; 0000 0CF0                                 break;
	RJMP _0x497
; 0000 0CF1                             case 0x40 :
_0x4A8:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x4A9
; 0000 0CF2                                 ExtPort_TEST(0x40, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x120
	CALL SUBOPT_0x11A
; 0000 0CF3                                 delay_ms(100);
; 0000 0CF4                                 ExtPort_TEST(0x40, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x120
	CALL SUBOPT_0x11B
; 0000 0CF5                                 delay_ms(100);
; 0000 0CF6                                 break;
	RJMP _0x497
; 0000 0CF7                             case 0x50 :
_0x4A9:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x4AA
; 0000 0CF8                                 ExtPort_TEST(0x50, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x121
	CALL SUBOPT_0x11A
; 0000 0CF9                                 delay_ms(100);
; 0000 0CFA                                 ExtPort_TEST(0x50, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x121
	CALL SUBOPT_0x11B
; 0000 0CFB                                 delay_ms(100);
; 0000 0CFC                                 break;
	RJMP _0x497
; 0000 0CFD                             case 0x60 :
_0x4AA:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x4AB
; 0000 0CFE                                 ExtPort_TEST(0x60, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x122
	CALL SUBOPT_0x11A
; 0000 0CFF                                 delay_ms(100);
; 0000 0D00                                 ExtPort_TEST(0x60, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x122
	CALL SUBOPT_0x11B
; 0000 0D01                                 delay_ms(100);
; 0000 0D02                                 break;
	RJMP _0x497
; 0000 0D03                             case 0x70 :
_0x4AB:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x4AC
; 0000 0D04                                 ExtPort_TEST(0x70, RxBuffer[1]-1,Signal_ON, 0);
	CALL SUBOPT_0x123
	CALL SUBOPT_0x11A
; 0000 0D05                                 delay_ms(100);
; 0000 0D06                                 ExtPort_TEST(0x70, RxBuffer[1]-1,Signal_OFF, 0);
	CALL SUBOPT_0x123
	CALL SUBOPT_0x11B
; 0000 0D07                                 delay_ms(100);
; 0000 0D08                                 break;
	RJMP _0x497
; 0000 0D09                             //전체 기동 :: 솔레노이드 1번~6번, 팩커 기동
; 0000 0D0A                             case 0x0A :
_0x4AC:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x497
; 0000 0D0B                                 ExtPort_TEST(0xFF, RxBuffer[1],Signal_ON, RxBuffer[2]-1);
	CALL SUBOPT_0x118
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB1MN _RxBuffer,2
	SUBI R30,LOW(1)
	MOV  R26,R30
	CALL _ExtPort_TEST
; 0000 0D0C                                 break;
; 0000 0D0D                         }
_0x497:
; 0000 0D0E                         BuzzerOn();
	RJMP _0x4DD
; 0000 0D0F                         break;
; 0000 0D10                     case CMD_REFORM_WEIGHT :            //중량 교정 기능
_0x494:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BRNE _0x4AE
; 0000 0D11                         Reform_Weight();
	CALL _Reform_Weight
; 0000 0D12                         break;
	RJMP _0x3C0
; 0000 0D13                     case CMD_LDCELLINFO :  //0x80       //2019.07.02 수정
_0x4AE:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4AF
; 0000 0D14                         switch(RxBuffer[1]){
	CALL SUBOPT_0xD0
; 0000 0D15                             case 0x01 :     //저장
	BREQ PC+2
	RJMP _0x4B3
; 0000 0D16                                 ConstWeight[0] = (RxBuffer[2] * 256) + RxBuffer[3];
	__GETB2MN _RxBuffer,2
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,3
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _ConstWeight,R30
	STS  _ConstWeight+1,R31
; 0000 0D17                                 LDCELL_INFO[0].span = ConstWeight[0];
	__PUTW1MN _LDCELL_INFO,1
; 0000 0D18                                 ConstWeight[1] = (RxBuffer[4] * 256) + RxBuffer[5];
	__GETB2MN _RxBuffer,4
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,5
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _ConstWeight,2
; 0000 0D19                                 LDCELL_INFO[1].span = ConstWeight[1];
	__GETW1MN _ConstWeight,2
	__PUTW1MN _LDCELL_INFO,6
; 0000 0D1A                                 ConstWeight[2] = (RxBuffer[6] * 256) + RxBuffer[7];
	__GETB2MN _RxBuffer,6
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,7
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _ConstWeight,4
; 0000 0D1B                                 LDCELL_INFO[2].span = ConstWeight[2];
	__GETW1MN _ConstWeight,4
	__PUTW1MN _LDCELL_INFO,11
; 0000 0D1C                                 ConstWeight[3] = (RxBuffer[8] * 256) + RxBuffer[9];
	__GETB2MN _RxBuffer,8
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,9
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _ConstWeight,6
; 0000 0D1D                                 LDCELL_INFO[3].span = ConstWeight[3];
	__GETW1MN _ConstWeight,6
	__PUTW1MN _LDCELL_INFO,16
; 0000 0D1E                                 ConstWeight[4] = (RxBuffer[10] * 256) + RxBuffer[11];
	__GETB2MN _RxBuffer,10
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,11
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _ConstWeight,8
; 0000 0D1F                                 LDCELL_INFO[4].span = ConstWeight[4];
	__GETW1MN _ConstWeight,8
	__PUTW1MN _LDCELL_INFO,21
; 0000 0D20                                 ConstWeight[5] = (RxBuffer[12] * 256) + RxBuffer[13];
	__GETB2MN _RxBuffer,12
	CALL SUBOPT_0xD1
	MOVW R26,R30
	__GETB1MN _RxBuffer,13
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _ConstWeight,10
; 0000 0D21                                 LDCELL_INFO[5].span = ConstWeight[5];
	__GETW1MN _ConstWeight,10
	__PUTW1MN _LDCELL_INFO,26
; 0000 0D22 
; 0000 0D23                                 PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
	LDI  R26,LOW(14)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
; 0000 0D24                                 break;
	RJMP _0x4B2
; 0000 0D25                             case 0x02 :     //읽기
_0x4B3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4B2
; 0000 0D26                                 GET_USR_INFO_DATA(LDCELL_INFO_DATA);
	LDI  R26,LOW(14)
	LDI  R27,0
	CALL _GET_USR_INFO_DATA
; 0000 0D27 
; 0000 0D28                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0xD3
; 0000 0D29                                 TxBuffer[1] = 0x00;
; 0000 0D2A                                 TxBuffer[2] = 14;
	LDI  R30,LOW(14)
	__PUTB1MN _TxBuffer,2
; 0000 0D2B                                 TxBuffer[3] = 0x80;
	LDI  R30,LOW(128)
	CALL SUBOPT_0xE0
; 0000 0D2C                                 TxBuffer[4] = 0x02;
; 0000 0D2D                                 TxBuffer[5] = LDCELL_INFO[0].span >> 8;
	__GETW1MN _LDCELL_INFO,1
	CALL __ASRW8
	__PUTB1MN _TxBuffer,5
; 0000 0D2E                                 TxBuffer[6] = LDCELL_INFO[0].span &0xFF;
	__GETB1MN _LDCELL_INFO,1
	__PUTB1MN _TxBuffer,6
; 0000 0D2F                                 TxBuffer[7] = LDCELL_INFO[1].span >> 8;
	__GETW1MN _LDCELL_INFO,6
	CALL __ASRW8
	__PUTB1MN _TxBuffer,7
; 0000 0D30                                 TxBuffer[8] = LDCELL_INFO[1].span &0xFF;
	__GETB1MN _LDCELL_INFO,6
	__PUTB1MN _TxBuffer,8
; 0000 0D31                                 TxBuffer[9] = LDCELL_INFO[2].span >> 8;
	__GETW1MN _LDCELL_INFO,11
	CALL __ASRW8
	__PUTB1MN _TxBuffer,9
; 0000 0D32                                 TxBuffer[10] = LDCELL_INFO[2].span &0xFF;
	__GETB1MN _LDCELL_INFO,11
	__PUTB1MN _TxBuffer,10
; 0000 0D33                                 TxBuffer[11] = LDCELL_INFO[3].span >> 8;
	__GETW1MN _LDCELL_INFO,16
	CALL __ASRW8
	__PUTB1MN _TxBuffer,11
; 0000 0D34                                 TxBuffer[12] = LDCELL_INFO[3].span &0xFF;
	__GETB1MN _LDCELL_INFO,16
	__PUTB1MN _TxBuffer,12
; 0000 0D35                                 TxBuffer[13] = LDCELL_INFO[4].span >> 8;
	__GETW1MN _LDCELL_INFO,21
	CALL __ASRW8
	__PUTB1MN _TxBuffer,13
; 0000 0D36                                 TxBuffer[14] = LDCELL_INFO[4].span &0xFF;
	__GETB1MN _LDCELL_INFO,21
	__PUTB1MN _TxBuffer,14
; 0000 0D37                                 TxBuffer[15] = LDCELL_INFO[5].span >> 8;
	__GETW1MN _LDCELL_INFO,26
	CALL __ASRW8
	__PUTB1MN _TxBuffer,15
; 0000 0D38                                 TxBuffer[16] = LDCELL_INFO[5].span &0xFF;
	__GETB1MN _LDCELL_INFO,26
	__PUTB1MN _TxBuffer,16
; 0000 0D39                                 TxBuffer[17] = 0x03;
	LDI  R30,LOW(3)
	__PUTB1MN _TxBuffer,17
; 0000 0D3A 
; 0000 0D3B                                 TxEnable = 1;   txcnt = 1;  TxLength = 18;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xE1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x93
; 0000 0D3C 
; 0000 0D3D                                 BuzzerOn();
	CALL SUBOPT_0xCE
; 0000 0D3E                                 delay_ms(200);
; 0000 0D3F                                 break;
; 0000 0D40                         }
_0x4B2:
; 0000 0D41                         BuzzerOn();
	RJMP _0x4DD
; 0000 0D42                         break;
; 0000 0D43                     case CMD_COMCHK :         //0xAA        //통신 연결 체크
_0x4AF:
	CPI  R30,LOW(0xAA)
	LDI  R26,HIGH(0xAA)
	CPC  R31,R26
	BRNE _0x3C0
; 0000 0D44                         switch(RxBuffer[1]){
	__GETB1MN _RxBuffer,1
	LDI  R31,0
; 0000 0D45                             case 0x55 :
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x4B8
; 0000 0D46                                 TxBuffer[0] = 0x02;
	CALL SUBOPT_0x5F
; 0000 0D47                                 TxBuffer[1] = 0x00;
; 0000 0D48                                 TxBuffer[2] = 0x02;
	__PUTB1MN _TxBuffer,2
; 0000 0D49                                 TxBuffer[3] = 0xAA;
	LDI  R30,LOW(170)
	__PUTB1MN _TxBuffer,3
; 0000 0D4A                                 TxBuffer[4] = CONTROLLER_ID;
	LDS  R30,_CONTROLLER_ID
	CALL SUBOPT_0x60
; 0000 0D4B                                 TxBuffer[5] = 0x03;
; 0000 0D4C                                 TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
	CALL SUBOPT_0xC9
; 0000 0D4D                                 BuzzerOn();
_0x4DD:
	CALL _BuzzerOn
; 0000 0D4E                                 break;
; 0000 0D4F                         }
_0x4B8:
; 0000 0D50                         break;
; 0000 0D51                 }
_0x3C0:
; 0000 0D52                 COM_REV_ENABLE = 0;
	LDI  R30,LOW(0)
	STS  _COM_REV_ENABLE,R30
; 0000 0D53             }
; 0000 0D54         }
_0x3BD:
; 0000 0D55     }
_0x3BA:
	JMP  _0x3B7
; 0000 0D56 }
_0x4BA:
	RJMP _0x4BA
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG
_memcpy:
; .FSTART _memcpy
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
; .FEND

	.CSEG

	.DSEG
_BucketData:
	.BYTE 0x258
_BucketData_Wight:
	.BYTE 0x258
_GRADE_INFO:
	.BYTE 0x5A
_SOL_INFO:
	.BYTE 0x1B0
_PACKER_INFO:
	.BYTE 0x24
_LDCELL_INFO:
	.BYTE 0x1E
_MEASURE_INFO:
	.BYTE 0xC
_PRT_INFO:
	.BYTE 0x12
_SYS_INFO:
	.BYTE 0x12
_ABN_INFO:
	.BYTE 0x2
_GRADE_DATA:
	.BYTE 0xC4
_crackCHKCNT:
	.BYTE 0x6
_dotCHKCNT:
	.BYTE 0x6
_PRT_A_OUT:
	.BYTE 0x1
_PRT_B_OUT:
	.BYTE 0x1
_pocketSTATE:
	.BYTE 0x36
_sol_outcnt:
	.BYTE 0x36
_sol_offcnt:
	.BYTE 0x36
_sol_offcnt_on:
	.BYTE 0x36
_do_value:
	.BYTE 0x9
_plc_prt_value:
	.BYTE 0x1
_phase_a_cnt:
	.BYTE 0x2
_max_scan_val:
	.BYTE 0x2
_MAX_SCAN_REF:
	.BYTE 0x2
_max_scan_cnt:
	.BYTE 0x2
_HolderState:
	.BYTE 0x12
_HolderOnTime:
	.BYTE 0x12
_weight_ad_end_pulse:
	.BYTE 0x2
_weight_cal_end_pulse:
	.BYTE 0x2
_zero_ad_end_pulse:
	.BYTE 0x2
_zero_cal_end_pulse:
	.BYTE 0x2
_ConvertPosition:
	.BYTE 0x2
_convert_end_pulse:
	.BYTE 0x2
_grading_end_pulse:
	.BYTE 0x2
_crackchk_end_pulse:
	.BYTE 0x2
_COMM_SET_Position:
	.BYTE 0x2
_GradingPosition:
	.BYTE 0x2
_cur_z_phase_cnt:
	.BYTE 0x2
_weight_value:
	.BYTE 0xC
_zero_value:
	.BYTE 0xC
_ref_zero_value:
	.BYTE 0xC
_ConstWeight:
	.BYTE 0xC
_ad_full_scan:
	.BYTE 0x4B0
_ResultWeight:
	.BYTE 0xC
_zero_measure_value:
	.BYTE 0x18
_phase_z_cnt:
	.BYTE 0x4
_RxBuffer:
	.BYTE 0x1F4
_TxBuffer:
	.BYTE 0x5DC
_COM_REV_ENABLE:
	.BYTE 0x1
_COM_MOD:
	.BYTE 0x1
_TxEnable:
	.BYTE 0x1
_TimerMode:
	.BYTE 0x1
_adcnt:
	.BYTE 0x1
_avr_loop_cnt:
	.BYTE 0x1
_reformCH:
	.BYTE 0x1
_StopEnable:
	.BYTE 0x1
_A_TX_DATA:
	.BYTE 0x8
_A_CNT_TX_HOLD:
	.BYTE 0x1
_TxLength:
	.BYTE 0x2
_txcnt:
	.BYTE 0x2
_revcnt:
	.BYTE 0x2
_RxLength:
	.BYTE 0x2
_tmrSPEEDCNT:
	.BYTE 0x2
_reformTotal:
	.BYTE 0x4
_reform_ADC:
	.BYTE 0x30
_reformVoltage:
	.BYTE 0x2
_reformWeight:
	.BYTE 0x2
_reformSigned:
	.BYTE 0x2
_diffVoltage:
	.BYTE 0x2
_prt_a_outcnt:
	.BYTE 0x1
_prt_a_off_enable:
	.BYTE 0x1
_prt_a_offcnt:
	.BYTE 0x1
_prt_b_outcnt:
	.BYTE 0x1
_prt_b_off_enable:
	.BYTE 0x1
_prt_b_offcnt:
	.BYTE 0x1
_CONTROLLER_ID:
	.BYTE 0x1
_led_buz_value:
	.BYTE 0x1
_AccelStart:
	.BYTE 0x1
_DeAccelStart:
	.BYTE 0x1
_AccelStep:
	.BYTE 0x1
_DeAccelStep:
	.BYTE 0x1
_Sol_Correction_Count:
	.BYTE 0x1
_InterLockON:
	.BYTE 0x1
_InterLockCnt:
	.BYTE 0x1
_AccelCount:
	.BYTE 0x2
_DeAccelCount:
	.BYTE 0x2
_timer_period:
	.BYTE 0x1
_unit_correct:
	.BYTE 0x1
_unit_rising:
	.BYTE 0x1
_unit_falling:
	.BYTE 0x1
_EVENT_ENABLE:
	.BYTE 0x1
_Marking_Version:
	.BYTE 0x1
_LifeTime_Run:
	.BYTE 0x1
_CHK_ABN:
	.BYTE 0x1
_abn_phase_a:
	.BYTE 0x2
_abn_butket_num_temp:
	.BYTE 0x2
_Old_Value:
	.BYTE 0x2
_New_Value:
	.BYTE 0x2
__ADC_CH:
	.BYTE 0x8
_Data_Buff:
	.BYTE 0x210
_old_prttype:
	.BYTE 0x9
_StopCMD:
	.BYTE 0x1
_MACHINE_STATE:
	.BYTE 0x1
_Crack_Dot_Chk_Enable:
	.BYTE 0x1
_weight_ad_cnt:
	.BYTE 0x1
_zero_ad_cnt:
	.BYTE 0x1
_old_Zero:
	.BYTE 0xC
_correct_data_end_pulse:
	.BYTE 0x2
_voltData:
	.BYTE 0xF0
_off_Correction_Count:
	.BYTE 0x2
_init_off_correction:
	.BYTE 0x2
_deAccelStartCount:
	.BYTE 0x2
_accelStartCount:
	.BYTE 0x2
_DeAccelDelay:
	.BYTE 0x2
_DelayTimeCount:
	.BYTE 0x2
_timerstop:
	.BYTE 0x1
_deaccel_chk:
	.BYTE 0x1
_accel_chk:
	.BYTE 0x1
_SpeedAdjEnable:
	.BYTE 0x1
_debugMode:
	.BYTE 0x1
_slidemotor_state:
	.BYTE 0x1
_ACD_DATA_BUF:
	.BYTE 0x96
_accel_rdy:
	.BYTE 0x1
_deaccel_rdy:
	.BYTE 0x1
_PackerSharedEnable:
	.BYTE 0x1
_Marking_MOUT:
	.BYTE 0x1
_Marking_MOUT_SNG:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _GRADE_INFO,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3:
	MOVW R26,R30
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(48)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _SOL_INFO,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(48)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _SOL_INFO,12
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	LDI  R26,LOW(48)
	MUL  R17,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	__ADDW1MN _SOL_INFO,24
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xA:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 108 TIMES, CODE SIZE REDUCTION:211 WORDS
SUBOPT_0xB:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xC:
	MOV  R30,R17
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(5)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _LDCELL_INFO,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	STS  _MEASURE_INFO,R30
	STS  _MEASURE_INFO+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__PUTW1MN _MEASURE_INFO,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__PUTW1MN _MEASURE_INFO,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__PUTW1MN _MEASURE_INFO,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__PUTW1MN _MEASURE_INFO,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__PUTW1MN _MEASURE_INFO,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__PUTW1MN _SYS_INFO,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	STS  _SYS_INFO,R30
	STS  _SYS_INFO+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__PUTW1MN _SYS_INFO,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	__PUTW1MN _SYS_INFO,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x19:
	STS  133,R30
	LDI  R30,LOW(0)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	CALL _SendSPIByte
	LDI  R26,LOW(0)
	JMP  _SendSPIByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Data_Buff)
	LDI  R31,HIGH(_Data_Buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(_Data_Buff)
	LDI  R31,HIGH(_Data_Buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	STS  _AccelStart,R30
	STS  _AccelStep,R30
	LDS  R30,_accelStartCount
	LDS  R31,_accelStartCount+1
	STS  _AccelCount,R30
	STS  _AccelCount+1,R31
	LDI  R30,LOW(0)
	STS  _Sol_Correction_Count,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	STS  _accel_rdy,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R30,_init_off_correction
	LDS  R31,_init_off_correction+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETB1MN _SYS_INFO,4
	SUBI R30,-LOW(5)
	STS  _Sol_Correction_Count,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(0)
	STS  137,R30
	LDI  R30,LOW(78)
	STS  136,R30
	LDI  R30,LOW(5)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	STS  _DeAccelStart,R30
	LDS  R30,_deAccelStartCount
	STS  _DeAccelStep,R30
	LDI  R30,LOW(0)
	STS  _DeAccelCount,R30
	STS  _DeAccelCount+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x23:
	LDS  R30,_plc_prt_value
	ANDI R30,0xFE
	STS  _plc_prt_value,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x24:
	STS  34816,R30
	LDS  R30,_led_buz_value
	ANDI R30,0xDF
	STS  _led_buz_value,R30
	STS  36864,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	STS  _off_Correction_Count,R30
	STS  _off_Correction_Count+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(1)
	STS  _EVENT_ENABLE,R30
	STS  _SpeedAdjEnable,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x27:
	LDS  R30,_led_buz_value
	ORI  R30,0x20
	STS  _led_buz_value,R30
	STS  36864,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x28:
	STS  _plc_prt_value,R30
	STS  34816,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x29:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2A:
	LDS  R30,_phase_z_cnt
	LDS  R31,_phase_z_cnt+1
	LDS  R22,_phase_z_cnt+2
	LDS  R23,_phase_z_cnt+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(0)
	STS  _phase_a_cnt,R30
	STS  _phase_a_cnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2C:
	LDS  R26,_phase_a_cnt
	LDS  R27,_phase_a_cnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2D:
	LDS  R26,_phase_z_cnt
	LDS  R27,_phase_z_cnt+1
	LDS  R24,_phase_z_cnt+2
	LDS  R25,_phase_z_cnt+3
	__CPD2N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(_phase_z_cnt)
	LDI  R27,HIGH(_phase_z_cnt)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2F:
	LDS  R30,_led_buz_value
	STS  36864,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x30:
	LDS  R30,_phase_a_cnt
	LDS  R31,_phase_a_cnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	__GETW1MN _SYS_INFO,5
	RCALL SUBOPT_0x2C
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDS  R30,_led_buz_value
	ANDI R30,0xDF
	STS  _led_buz_value,R30
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(2)
	STS  _A_TX_DATA,R30
	LDI  R30,LOW(0)
	__PUTB1MN _A_TX_DATA,1
	LDI  R30,LOW(4)
	__PUTB1MN _A_TX_DATA,2
	LDI  R30,LOW(225)
	__PUTB1MN _A_TX_DATA,3
	LDI  R30,LOW(1)
	__PUTB1MN _A_TX_DATA,4
	LDS  R30,_phase_a_cnt+1
	__PUTB1MN _A_TX_DATA,5
	LDS  R30,_phase_a_cnt
	__PUTB1MN _A_TX_DATA,6
	LDI  R30,LOW(3)
	__PUTB1MN _A_TX_DATA,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(_TxBuffer)
	LDI  R31,HIGH(_TxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_A_TX_DATA)
	LDI  R31,HIGH(_A_TX_DATA)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memcpy
	LDI  R30,LOW(1)
	STS  _TxEnable,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _txcnt,R30
	STS  _txcnt+1,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _TxLength,R30
	STS  _TxLength+1,R31
	LDS  R30,_TxBuffer
	STS  206,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x30
	CLR  R22
	CLR  R23
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	LDS  R26,_abn_phase_a
	LDS  R27,_abn_phase_a+1
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x30
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETW1MN _MEASURE_INFO,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x38:
	STS  _led_buz_value,R30
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x39:
	LDS  R30,_ABN_INFO
	LDS  R31,_ABN_INFO+1
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3B:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x3C:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDS  R26,_ABN_INFO
	LDS  R27,_ABN_INFO+1
	LSL  R26
	ROL  R27
	__ADDW2MN _BucketData_Wight,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	MOVW R30,R16
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	MOVW R30,R16
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDS  R26,_MEASURE_INFO
	LDS  R27,_MEASURE_INFO+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x2C
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x45:
	CLR  R24
	CLR  R25
	__GETD1N 0x2FB
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2710
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x46:
	LDS  R30,_phase_a_cnt
	SUB  R30,R26
	MOV  R21,R30
	MOV  R26,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x47:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	MOV  R30,R21
	LDI  R26,LOW(_zero_measure_value)
	LDI  R27,HIGH(_zero_measure_value)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x49:
	CALL __CWD1
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	CALL __LSLW2
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4C:
	__GETD2N 0x2FB
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2710
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x4D:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x30
	LDS  R26,_GradingPosition
	LDS  R27,_GradingPosition+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDS  R30,_grading_end_pulse
	LDS  R31,_grading_end_pulse+1
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(1)
	CALL __LSLB12
	STD  Y+14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(_crackCHKCNT)
	LDI  R27,HIGH(_crackCHKCNT)
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	LDI  R26,LOW(1)
	CALL __LSLB12
	LDS  R26,_ACD_DATA_BUF
	OR   R30,R26
	STS  _ACD_DATA_BUF,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x30
	LDI  R26,LOW(_ad_full_scan)
	LDI  R27,HIGH(_ad_full_scan)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x30
	LDI  R26,LOW(_ad_full_scan)
	LDI  R27,HIGH(_ad_full_scan)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x55:
	CALL __GETW1P
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x56:
	__GETB1MN _SYS_INFO,17
	LDI  R31,0
	SUBI R30,LOW(-_ACD_DATA_BUF)
	SBCI R31,HIGH(-_ACD_DATA_BUF)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x57:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	LDS  R30,_phase_z_cnt
	LDS  R31,_phase_z_cnt+1
	STS  _cur_z_phase_cnt,R30
	STS  _cur_z_phase_cnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x59:
	RCALL SUBOPT_0x2A
	LDS  R26,_cur_z_phase_cnt
	LDS  R27,_cur_z_phase_cnt+1
	CLR  R24
	CLR  R25
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	MOV  R30,R31
	LDI  R31,0
	__PUTB1MN _TxBuffer,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5B:
	__PUTB1MN _TxBuffer,2
	LDI  R30,LOW(16)
	__PUTB1MN _TxBuffer,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__PUTB1MN _TxBuffer,4
	__POINTW1MN _TxBuffer,5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5D:
	__ADDW1MN _TxBuffer,5
	LDI  R26,LOW(3)
	STD  Z+0,R26
	LDI  R30,LOW(1)
	STS  _TxEnable,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _txcnt,R30
	STS  _txcnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5E:
	MOVW R30,R18
	ADIW R30,6
	STS  _TxLength,R30
	STS  _TxLength+1,R31
	LDS  R30,_TxBuffer
	STS  206,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x5F:
	LDI  R30,LOW(2)
	STS  _TxBuffer,R30
	LDI  R30,LOW(0)
	__PUTB1MN _TxBuffer,1
	LDI  R30,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x60:
	__PUTB1MN _TxBuffer,4
	LDI  R30,LOW(3)
	__PUTB1MN _TxBuffer,5
	LDI  R30,LOW(1)
	STS  _TxEnable,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _txcnt,R30
	STS  _txcnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x63:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x64:
	LDS  R26,_reformTotal
	LDS  R27,_reformTotal+1
	LDS  R24,_reformTotal+2
	LDS  R25,_reformTotal+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x65:
	LDS  R30,_adcnt
	LDI  R26,LOW(_reform_ADC)
	LDI  R27,HIGH(_reform_ADC)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x66:
	RCALL SUBOPT_0x64
	CALL __SUBD21
	STS  _reformTotal,R26
	STS  _reformTotal+1,R27
	STS  _reformTotal+2,R24
	STS  _reformTotal+3,R25
	RJMP SUBOPT_0x65

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x67:
	LDS  R30,_adcnt
	SUBI R30,-LOW(1)
	STS  _adcnt,R30
	SUBI R30,LOW(1)
	LDI  R26,LOW(_reform_ADC)
	LDI  R27,HIGH(_reform_ADC)
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x64
	CALL __ADDD12
	STS  _reformTotal,R30
	STS  _reformTotal+1,R31
	STS  _reformTotal+2,R22
	STS  _reformTotal+3,R23
	LDS  R30,_avr_loop_cnt
	LDS  R26,_adcnt
	CALL __MODB21U
	STS  _adcnt,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x69:
	LDS  R30,_reformCH
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6A:
	CALL __GETW1P
	LDS  R26,_reformVoltage
	LDS  R27,_reformVoltage+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6B:
	LDS  R30,_reformCH
	LDI  R26,LOW(_ConstWeight)
	LDI  R27,HIGH(_ConstWeight)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6C:
	CLR  R22
	CLR  R23
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E8
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	__GETD1N 0x72E4
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x186A0
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6E:
	LDS  R30,_led_buz_value
	ANDI R30,0x7F
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x6F:
	LDD  R30,Y+11
	LDI  R26,LOW(40)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_voltData)
	SBCI R31,HIGH(-_voltData)
	MOVW R26,R30
	LDD  R30,Y+6
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x70:
	__GETD2S 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x71:
	CALL __ADDD12
	__PUTD1S 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x72:
	LDS  R30,_weight_ad_cnt
	LDI  R31,0
	RCALL SUBOPT_0x70
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	RCALL SUBOPT_0x70
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x74:
	LDD  R30,Y+4
	LDI  R26,LOW(_weight_value)
	LDI  R27,HIGH(_weight_value)
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	LD   R0,X+
	LD   R1,X
	LDD  R30,Y+4
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x76:
	LDD  R30,Y+4
	LDI  R26,LOW(_zero_value)
	LDI  R27,HIGH(_zero_value)
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	CALL __GETW1P
	MOV  R30,R31
	LDI  R31,0
	STS  206,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x79:
	CALL __ASRW8
	STS  206,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	__GETW1MN _GRADE_INFO,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7B:
	__GETW1MN _GRADE_INFO,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	__GETW1MN _GRADE_INFO,22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7D:
	__GETW1MN _GRADE_INFO,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	__GETW1MN _GRADE_INFO,42
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	__GETW1MN _GRADE_INFO,52
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x80:
	LDD  R30,Y+29
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	LDD  R30,Y+29
	LDI  R31,0
	SUBI R30,LOW(-_dotCHKCNT)
	SBCI R31,HIGH(-_dotCHKCNT)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x82:
	__GETB1MN _SYS_INFO,17
	LDI  R31,0
	SUBI R30,LOW(-_ACD_DATA_BUF)
	SBCI R31,HIGH(-_ACD_DATA_BUF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	__GETW1MN _GRADE_INFO,80
	CP   R18,R30
	CPC  R19,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x84:
	__GETD2MN _GRADE_DATA,120
	MOVW R30,R18
	CALL __CWD1
	CALL __ADDD12
	__PUTD1MN _GRADE_DATA,120
	__GETB1MN _GRADE_INFO,85
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x85:
	__GETW2MN _GRADE_INFO,88
	__GETW1MN _GRADE_INFO,86
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x86:
	__GETB1MN _GRADE_INFO,85
	__PUTB1MN _old_prttype,8
	LDI  R30,LOW(0)
	__PUTB1MN _GRADE_INFO,85
	__POINTW1MN _GRADE_INFO,88
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x87:
	MOVW R30,R18
	CALL __CWD1
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x88:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x89:
	__PUTD1MN _GRADE_DATA,172
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	LDI  R26,LOW(_BucketData_Wight)
	LDI  R27,HIGH(_BucketData_Wight)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8B:
	__POINTW2MN _GRADE_DATA,48
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8C:
	LDI  R26,LOW(10)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _GRADE_INFO,4
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8D:
	CALL __CWD1
	CALL __MODD21
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8E:
	__SUBD1N 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8F:
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,1
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 20,21,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x90:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x91:
	__PUTD1MN _GRADE_DATA,180
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x92:
	STS  _tmrSPEEDCNT,R30
	STS  _tmrSPEEDCNT+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x93:
	STS  _TxLength,R30
	STS  _TxLength+1,R31
	LDS  R30,_TxBuffer
	STS  206,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x94:
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_pocketSTATE)
	SBCI R31,HIGH(-_pocketSTATE)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x95:
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sol_outcnt)
	SBCI R31,HIGH(-_sol_outcnt)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x96:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x97:
	MOV  R26,R18
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x98:
	ST   X,R30
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sol_offcnt_on)
	SBCI R31,HIGH(-_sol_offcnt_on)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x99:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LD   R30,X
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R16
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9A:
	MOV  R30,R17
	LDI  R26,LOW(_HolderState)
	LDI  R27,HIGH(_HolderState)
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9B:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_do_value)
	SBCI R31,HIGH(-_do_value)
	MOVW R22,R30
	LD   R18,Z
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9C:
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sol_offcnt)
	SBCI R31,HIGH(-_sol_offcnt)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9D:
	MOV  R30,R17
	LDI  R26,LOW(_HolderOnTime)
	LDI  R27,HIGH(_HolderOnTime)
	LDI  R31,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9E:
	LDI  R27,0
	SUBI R26,LOW(-_do_value)
	SBCI R27,HIGH(-_do_value)
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9F:
	LDS  R30,_prt_a_outcnt
	SUBI R30,-LOW(1)
	STS  _prt_a_outcnt,R30
	__GETW1MN _PRT_INFO,6
	LDS  R26,_prt_a_outcnt
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA0:
	LDI  R30,LOW(0)
	STS  _prt_a_outcnt,R30
	LDI  R30,LOW(10)
	STS  _PRT_A_OUT,R30
	LDI  R30,LOW(1)
	STS  _prt_a_off_enable,R30
	LDS  R30,_plc_prt_value
	ORI  R30,0x10
	STS  _plc_prt_value,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA1:
	LDS  R30,_prt_a_offcnt
	SUBI R30,-LOW(1)
	STS  _prt_a_offcnt,R30
	__GETW1MN _PRT_INFO,8
	LDS  R26,_prt_a_offcnt
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA2:
	LDI  R30,LOW(0)
	STS  _prt_a_offcnt,R30
	LDS  R30,_plc_prt_value
	ANDI R30,0xEF
	STS  _plc_prt_value,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA3:
	COM  R30
	LDS  R26,_plc_prt_value
	AND  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA4:
	LDS  R30,_do_value
	STS  35072,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA5:
	__GETB1MN _do_value,1
	STS  35328,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA6:
	__GETB1MN _do_value,2
	STS  35584,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA7:
	__GETB1MN _do_value,3
	STS  35840,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA8:
	__GETB1MN _do_value,4
	STS  36096,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA9:
	__GETB1MN _do_value,5
	STS  36352,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xAA:
	__GETB1MN _do_value,6
	STS  36608,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xAB:
	LDS  R30,_plc_prt_value
	STS  34816,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAC:
	SBIW R30,1
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAD:
	LDI  R26,LOW(_BucketData_Wight)
	LDI  R27,HIGH(_BucketData_Wight)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xAE:
	__GETW1MN _PRT_INFO,10
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAF:
	CALL __GETW1P
	CALL __LSRW4
	MOV  R30,R31
	ANDI R30,LOW(0x3)
	ANDI R31,HIGH(0x3)
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB0:
	CALL __GETW1P
	MOV  R30,R31
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB1:
	LD   R30,X+
	LD   R31,X+
	ANDI R31,HIGH(0xFFF)
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB2:
	__GETW1MN _PRT_INFO,16
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB3:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	SBIW R30,5
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB4:
	CALL __GETW1P
	ANDI R31,HIGH(0xFFF)
	MOVW R22,R30
	LDI  R26,LOW(48)
	MUL  R17,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB5:
	MOVW R26,R30
	CALL __GETW1P
	CP   R30,R22
	CPC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB6:
	LDI  R26,LOW(160)
	STD  Z+0,R26
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB7:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	SBIW R30,4
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB8:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	SBIW R30,3
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB9:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	SBIW R30,2
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xBA:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	RJMP SUBOPT_0xAC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBB:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	SBIW R30,0
	LDI  R26,LOW(_BucketData)
	LDI  R27,HIGH(_BucketData)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xBC:
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBD:
	__GETW2MN _SYS_INFO,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xBE:
	__GETW1MN _GRADE_INFO,80
	SBIW R30,1
	STS  _GRADE_INFO,R30
	STS  _GRADE_INFO+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBF:
	__GETW1MN _MEASURE_INFO,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC0:
	CALL __DIVW21
	MOVW R26,R30
	LDS  R30,_timer_period
	LDI  R31,0
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xC1:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC2:
	LDI  R30,LOW(0)
	STS  _reformTotal,R30
	STS  _reformTotal+1,R30
	STS  _reformTotal+2,R30
	STS  _reformTotal+3,R30
	STS  _reformVoltage,R30
	STS  _reformVoltage+1,R30
	STS  _adcnt,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC3:
	CALL __GETW1P
	RCALL SUBOPT_0x64
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC4:
	LDS  R30,_led_buz_value
	ORI  R30,0x80
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xC5:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC6:
	STS  _TimerMode,R30
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC7:
	STS  136,R30
	LDI  R30,LOW(5)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC8:
	__PUTB1MN _TxBuffer,3
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x60

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC9:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP SUBOPT_0x93

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xCA:
	LDS  R30,_avr_loop_cnt
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCB:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDI  R26,LOW(_reform_ADC)
	LDI  R27,HIGH(_reform_ADC)
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCC:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x64
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xCD:
	STS  _reformTotal,R30
	STS  _reformTotal+1,R31
	STS  _reformTotal+2,R22
	STS  _reformTotal+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xCE:
	CALL _BuzzerOn
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xCF:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD0:
	__GETB1MN _RxBuffer,1
	RJMP SUBOPT_0x63

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xD1:
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD2:
	LDI  R30,LOW(0)
	STS  137,R30
	LDI  R30,LOW(31)
	RJMP SUBOPT_0xC7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD3:
	LDI  R30,LOW(2)
	STS  _TxBuffer,R30
	LDI  R30,LOW(0)
	__PUTB1MN _TxBuffer,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _txcnt,R30
	STS  _txcnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD5:
	ST   X,R30
	LDD  R30,Y+2
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD6:
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-_do_value)
	SBCI R31,HIGH(-_do_value)
	MOVW R0,R30
	LD   R26,Z
	MOV  R30,R17
	COM  R30
	AND  R30,R26
	MOVW R26,R0
	RJMP SUBOPT_0xD5

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD7:
	LDS  R30,_plc_prt_value
	ORI  R30,0x10
	STS  _plc_prt_value,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD8:
	LDS  R30,_plc_prt_value
	ANDI R30,0xEF
	STS  _plc_prt_value,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD9:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xDA:
	STS  _phase_z_cnt,R30
	STS  _phase_z_cnt+1,R30
	STS  _phase_z_cnt+2,R30
	STS  _phase_z_cnt+3,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xDB:
	STS  36864,R30
	RJMP SUBOPT_0xC5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xDC:
	STS  _TimerMode,R30
	LDS  R30,_plc_prt_value
	ORI  R30,1
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDD:
	STS  _Marking_Version,R30
	LDI  R26,LOW(18)
	LDI  R27,0
	JMP  _PUT_USR_INFO_DATA

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0xDE:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xDF:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE0:
	__PUTB1MN _TxBuffer,3
	LDI  R30,LOW(2)
	__PUTB1MN _TxBuffer,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE1:
	LDI  R30,LOW(1)
	STS  _TxEnable,R30
	RJMP SUBOPT_0xD4

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xE2:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	ADD  R30,R20
	ADC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE3:
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	RJMP SUBOPT_0xE2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE4:
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE5:
	__ADDW1MN _SOL_INFO,12
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE6:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-_RxBuffer)
	SBCI R31,HIGH(-_RxBuffer)
	LD   R30,Z
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE7:
	LD   R30,X+
	LD   R31,X+
	MOV  R31,R30
	LDI  R30,0
	ST   -X,R31
	ST   -X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE8:
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xE9:
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-_RxBuffer)
	SBCI R31,HIGH(-_RxBuffer)
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xEA:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xEB:
	__ADDW1MN _SOL_INFO,24
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0xEC:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	ADD  R30,R20
	ADC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xED:
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xEE:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-_RxBuffer)
	SBCI R31,HIGH(-_RxBuffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xEF:
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF0:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-_RxBuffer)
	SBCI R31,HIGH(-_RxBuffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF1:
	MOVW R30,R20
	__ADDW1MN _RxBuffer,1
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF2:
	MOVW R30,R20
	__ADDW1MN _RxBuffer,2
	LD   R30,Z
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF3:
	MOVW R30,R20
	__ADDW1MN _RxBuffer,3
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF4:
	STS  _ABN_INFO,R30
	STS  _ABN_INFO+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF5:
	LDI  R26,LOW(12)
	LDI  R27,0
	CALL _PUT_USR_INFO_DATA
	LDI  R26,LOW(13)
	LDI  R27,0
	JMP  _PUT_USR_INFO_DATA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xF6:
	STD  Y+2,R30
	STD  Y+2+1,R31
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	__PUTW1R 23,24
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xF7:
	CALL __GETW1P
	CALL __ASRW8
	__GETW2R 23,24
	ST   X,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	__PUTW1R 23,24
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF8:
	LD   R30,X
	__GETW2R 23,24
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF9:
	STD  Y+2,R30
	STD  Y+2+1,R31
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xFA:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xFB:
	ST   X,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xFC:
	CALL __ASRW8
	ST   X,R30
	MOVW R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xFD:
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP SUBOPT_0xEC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xFE:
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xFF:
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0xDF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x100:
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	MOV  R31,R30
	LDI  R30,0
	ST   -X,R31
	ST   -X,R30
	RJMP SUBOPT_0xDF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x101:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADD  R30,R20
	ADC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x102:
	__PUTW1R 23,24
	RJMP SUBOPT_0xDF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x103:
	__ADDW1MN _GRADE_INFO,5
	LD   R30,Z
	__GETW2R 23,24
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x104:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	MOVW R20,R30
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x105:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_PACKER_INFO)
	LDI  R27,HIGH(_PACKER_INFO)
	RJMP SUBOPT_0x88

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x106:
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x107:
	__ADDW1MN _SOL_INFO,36
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x108:
	__ADDW1MN _SOL_INFO,6
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x109:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10A:
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP SUBOPT_0x109

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10B:
	CALL __ASRW8
	ST   X,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUBI R26,LOW(-_TxBuffer)
	SBCI R27,HIGH(-_TxBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10C:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	RJMP SUBOPT_0x102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10D:
	MOVW R26,R30
	CALL __GETW1P
	CALL __ASRW8
	__GETW2R 23,24
	RJMP SUBOPT_0xFB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10E:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0xF9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x110:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x111:
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-_TxBuffer)
	SBCI R31,HIGH(-_TxBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x112:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x113:
	__PUTW1R 23,24
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x114:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x115:
	LDI  R30,LOW(255)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x116:
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB1MN _RxBuffer,2
	SUBI R30,LOW(1)
	MOV  R26,R30
	CALL _ExtPort_TEST
	RJMP SUBOPT_0xCF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x117:
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETB1MN _RxBuffer,2
	SUBI R30,LOW(1)
	MOV  R26,R30
	CALL _ExtPort_TEST
	RJMP SUBOPT_0xCF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x118:
	LDI  R30,LOW(255)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x119:
	LDI  R30,LOW(2)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x11A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _ExtPort_TEST
	RJMP SUBOPT_0xCF

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x11B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _ExtPort_TEST
	RJMP SUBOPT_0xCF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11C:
	LDI  R30,LOW(3)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11D:
	LDI  R30,LOW(16)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11E:
	LDI  R30,LOW(32)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11F:
	LDI  R30,LOW(48)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x120:
	LDI  R30,LOW(64)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x121:
	LDI  R30,LOW(80)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x122:
	LDI  R30,LOW(96)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x123:
	LDI  R30,LOW(112)
	ST   -Y,R30
	__GETB1MN _RxBuffer,1
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	CPC  R0,R22
	CPC  R0,R23
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
