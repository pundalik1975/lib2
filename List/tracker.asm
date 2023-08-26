
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _hour=R7
	.DEF _minute=R6
	.DEF _second=R9
	.DEF _week=R8
	.DEF _day=R11
	.DEF _month=R10
	.DEF _year=R13
	.DEF _blink_locx=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
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
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_wCRCTable:
	.DB  0x0,0x0,0xC1,0xC0,0x81,0xC1,0x40,0x1
	.DB  0x1,0xC3,0xC0,0x3,0x80,0x2,0x41,0xC2
	.DB  0x1,0xC6,0xC0,0x6,0x80,0x7,0x41,0xC7
	.DB  0x0,0x5,0xC1,0xC5,0x81,0xC4,0x40,0x4
	.DB  0x1,0xCC,0xC0,0xC,0x80,0xD,0x41,0xCD
	.DB  0x0,0xF,0xC1,0xCF,0x81,0xCE,0x40,0xE
	.DB  0x0,0xA,0xC1,0xCA,0x81,0xCB,0x40,0xB
	.DB  0x1,0xC9,0xC0,0x9,0x80,0x8,0x41,0xC8
	.DB  0x1,0xD8,0xC0,0x18,0x80,0x19,0x41,0xD9
	.DB  0x0,0x1B,0xC1,0xDB,0x81,0xDA,0x40,0x1A
	.DB  0x0,0x1E,0xC1,0xDE,0x81,0xDF,0x40,0x1F
	.DB  0x1,0xDD,0xC0,0x1D,0x80,0x1C,0x41,0xDC
	.DB  0x0,0x14,0xC1,0xD4,0x81,0xD5,0x40,0x15
	.DB  0x1,0xD7,0xC0,0x17,0x80,0x16,0x41,0xD6
	.DB  0x1,0xD2,0xC0,0x12,0x80,0x13,0x41,0xD3
	.DB  0x0,0x11,0xC1,0xD1,0x81,0xD0,0x40,0x10
	.DB  0x1,0xF0,0xC0,0x30,0x80,0x31,0x41,0xF1
	.DB  0x0,0x33,0xC1,0xF3,0x81,0xF2,0x40,0x32
	.DB  0x0,0x36,0xC1,0xF6,0x81,0xF7,0x40,0x37
	.DB  0x1,0xF5,0xC0,0x35,0x80,0x34,0x41,0xF4
	.DB  0x0,0x3C,0xC1,0xFC,0x81,0xFD,0x40,0x3D
	.DB  0x1,0xFF,0xC0,0x3F,0x80,0x3E,0x41,0xFE
	.DB  0x1,0xFA,0xC0,0x3A,0x80,0x3B,0x41,0xFB
	.DB  0x0,0x39,0xC1,0xF9,0x81,0xF8,0x40,0x38
	.DB  0x0,0x28,0xC1,0xE8,0x81,0xE9,0x40,0x29
	.DB  0x1,0xEB,0xC0,0x2B,0x80,0x2A,0x41,0xEA
	.DB  0x1,0xEE,0xC0,0x2E,0x80,0x2F,0x41,0xEF
	.DB  0x0,0x2D,0xC1,0xED,0x81,0xEC,0x40,0x2C
	.DB  0x1,0xE4,0xC0,0x24,0x80,0x25,0x41,0xE5
	.DB  0x0,0x27,0xC1,0xE7,0x81,0xE6,0x40,0x26
	.DB  0x0,0x22,0xC1,0xE2,0x81,0xE3,0x40,0x23
	.DB  0x1,0xE1,0xC0,0x21,0x80,0x20,0x41,0xE0
	.DB  0x1,0xA0,0xC0,0x60,0x80,0x61,0x41,0xA1
	.DB  0x0,0x63,0xC1,0xA3,0x81,0xA2,0x40,0x62
	.DB  0x0,0x66,0xC1,0xA6,0x81,0xA7,0x40,0x67
	.DB  0x1,0xA5,0xC0,0x65,0x80,0x64,0x41,0xA4
	.DB  0x0,0x6C,0xC1,0xAC,0x81,0xAD,0x40,0x6D
	.DB  0x1,0xAF,0xC0,0x6F,0x80,0x6E,0x41,0xAE
	.DB  0x1,0xAA,0xC0,0x6A,0x80,0x6B,0x41,0xAB
	.DB  0x0,0x69,0xC1,0xA9,0x81,0xA8,0x40,0x68
	.DB  0x0,0x78,0xC1,0xB8,0x81,0xB9,0x40,0x79
	.DB  0x1,0xBB,0xC0,0x7B,0x80,0x7A,0x41,0xBA
	.DB  0x1,0xBE,0xC0,0x7E,0x80,0x7F,0x41,0xBF
	.DB  0x0,0x7D,0xC1,0xBD,0x81,0xBC,0x40,0x7C
	.DB  0x1,0xB4,0xC0,0x74,0x80,0x75,0x41,0xB5
	.DB  0x0,0x77,0xC1,0xB7,0x81,0xB6,0x40,0x76
	.DB  0x0,0x72,0xC1,0xB2,0x81,0xB3,0x40,0x73
	.DB  0x1,0xB1,0xC0,0x71,0x80,0x70,0x41,0xB0
	.DB  0x0,0x50,0xC1,0x90,0x81,0x91,0x40,0x51
	.DB  0x1,0x93,0xC0,0x53,0x80,0x52,0x41,0x92
	.DB  0x1,0x96,0xC0,0x56,0x80,0x57,0x41,0x97
	.DB  0x0,0x55,0xC1,0x95,0x81,0x94,0x40,0x54
	.DB  0x1,0x9C,0xC0,0x5C,0x80,0x5D,0x41,0x9D
	.DB  0x0,0x5F,0xC1,0x9F,0x81,0x9E,0x40,0x5E
	.DB  0x0,0x5A,0xC1,0x9A,0x81,0x9B,0x40,0x5B
	.DB  0x1,0x99,0xC0,0x59,0x80,0x58,0x41,0x98
	.DB  0x1,0x88,0xC0,0x48,0x80,0x49,0x41,0x89
	.DB  0x0,0x4B,0xC1,0x8B,0x81,0x8A,0x40,0x4A
	.DB  0x0,0x4E,0xC1,0x8E,0x81,0x8F,0x40,0x4F
	.DB  0x1,0x8D,0xC0,0x4D,0x80,0x4C,0x41,0x8C
	.DB  0x0,0x44,0xC1,0x84,0x81,0x85,0x40,0x45
	.DB  0x1,0x87,0xC0,0x47,0x80,0x46,0x41,0x86
	.DB  0x1,0x82,0xC0,0x42,0x80,0x43,0x41,0x83
	.DB  0x0,0x41,0xC1,0x81,0x81,0x80,0x40,0x40
_char0:
	.DB  0xE,0x11,0x11,0xE,0x0,0x0,0x0,0x0
_tbl10_G106:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G106:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000
	.DW  0x0000

_0x3:
	.DB  0xD0,0xF,0x49,0x40
_0x4:
	.DB  0x14,0xAE,0x7,0x3F
_0x5:
	.DB  0x11,0x11,0x11,0x3F
_0x0:
	.DB  0x6D,0x61,0x6E,0x75,0x61,0x6C,0x20,0x6D
	.DB  0x6F,0x64,0x65,0x0,0x65,0x78,0x69,0x74
	.DB  0x69,0x6E,0x67,0x2E,0x2E,0x2E,0x0,0x20
	.DB  0x20,0x0,0x32,0x30,0x0,0x3A,0x0,0x73
	.DB  0x65,0x74,0x20,0x74,0x68,0x65,0x20,0x74
	.DB  0x69,0x6D,0x65,0x0,0x65,0x6E,0x74,0x65
	.DB  0x72,0x69,0x6E,0x67,0x2E,0x2E,0x2E,0x2E
	.DB  0x0,0x53,0x65,0x74,0x20,0x54,0x69,0x6D
	.DB  0x65,0x0,0x53,0x65,0x74,0x20,0x44,0x61
	.DB  0x74,0x65,0x0,0x53,0x65,0x74,0x20,0x4C
	.DB  0x61,0x74,0x69,0x74,0x75,0x64,0x65,0x0
	.DB  0x53,0x65,0x74,0x20,0x4C,0x6F,0x6E,0x67
	.DB  0x69,0x74,0x75,0x64,0x65,0x0,0x54,0x69
	.DB  0x6D,0x65,0x20,0x49,0x6E,0x74,0x65,0x72
	.DB  0x76,0x61,0x6C,0x20,0x0,0x20,0x6D,0x69
	.DB  0x6E,0x75,0x74,0x65,0x73,0x0,0x53,0x65
	.DB  0x74,0x20,0x54,0x69,0x6D,0x65,0x7A,0x6F
	.DB  0x6E,0x65,0x0,0x47,0x4D,0x54,0x20,0x0
	.DB  0x48,0x72,0x73,0x2E,0x0,0x53,0x65,0x74
	.DB  0x20,0x50,0x61,0x6E,0x65,0x6C,0x20,0x48
	.DB  0x65,0x69,0x67,0x68,0x74,0x0,0x20,0x20
	.DB  0x20,0x20,0x0,0x4D,0x74,0x72,0x73,0x2E
	.DB  0x0,0x53,0x65,0x74,0x20,0x44,0x69,0x73
	.DB  0x74,0x61,0x6E,0x63,0x65,0x0,0x4D,0x6F
	.DB  0x64,0x42,0x75,0x73,0x20,0x49,0x44,0x0
	.DB  0x4D,0x6F,0x64,0x62,0x75,0x73,0x20,0x52
	.DB  0x61,0x74,0x65,0x20,0x0,0x20,0x20,0x39
	.DB  0x36,0x30,0x30,0x0,0x20,0x31,0x39,0x32
	.DB  0x30,0x30,0x0,0x20,0x33,0x38,0x34,0x30
	.DB  0x30,0x0,0x20,0x35,0x37,0x36,0x30,0x30
	.DB  0x0,0x31,0x31,0x35,0x32,0x30,0x30,0x0
	.DB  0x20,0x42,0x61,0x75,0x64,0x0,0x43,0x61
	.DB  0x6C,0x69,0x62,0x72,0x61,0x74,0x69,0x6F
	.DB  0x6E,0x20,0x4D,0x6F,0x64,0x65,0x0,0x65
	.DB  0x6E,0x74,0x65,0x72,0x69,0x6E,0x67,0x0
	.DB  0x74,0x69,0x6D,0x65,0x3A,0x20,0x0,0x61
	.DB  0x6E,0x67,0x6C,0x65,0x3A,0x20,0x0,0x73
	.DB  0x75,0x6E,0x72,0x69,0x73,0x65,0x3A,0x20
	.DB  0x0,0x73,0x75,0x6E,0x73,0x65,0x74,0x3A
	.DB  0x20,0x0,0x6E,0x65,0x78,0x74,0x20,0x74
	.DB  0x69,0x6D,0x65,0x2F,0x61,0x6E,0x67,0x6C
	.DB  0x65,0x3A,0x0,0x64,0x61,0x74,0x65,0x3A
	.DB  0x20,0x0,0x20,0x2F,0x20,0x0,0x20,0x47
	.DB  0x3A,0x0,0x62,0x3A,0x0,0x20,0x6D,0x69
	.DB  0x6E,0x75,0x74,0x65,0x73,0x20,0x20,0x0
	.DB  0x2A,0x20,0x4D,0x61,0x6E,0x75,0x61,0x6C
	.DB  0x20,0x4D,0x6F,0x64,0x65,0x20,0x2A,0x20
	.DB  0x0,0x20,0x20,0x4E,0x49,0x47,0x48,0x54
	.DB  0x20,0x4D,0x4F,0x44,0x45,0x20,0x20,0x0
	.DB  0x61,0x6E,0x67,0x3A,0x20,0x0,0x74,0x61
	.DB  0x72,0x3A,0x20,0x0,0x6D,0x65,0x63,0x68
	.DB  0x2E,0x20,0x65,0x72,0x72,0x6F,0x72,0x0
	.DB  0x2A,0x20,0x53,0x49,0x4E,0x47,0x4C,0x45
	.DB  0x20,0x41,0x58,0x49,0x53,0x20,0x20,0x2A
	.DB  0x0,0x2A,0x53,0x4F,0x4C,0x41,0x52,0x20
	.DB  0x54,0x52,0x41,0x43,0x4B,0x45,0x52,0x20
	.DB  0x2A,0x0,0x2A,0x20,0x20,0x20,0x50,0x4C
	.DB  0x45,0x41,0x53,0x45,0x20,0x20,0x20,0x20
	.DB  0x20,0x2A,0x0,0x2A,0x20,0x20,0x20,0x20
	.DB  0x57,0x41,0x49,0x54,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x2A,0x0,0x74,0x68,0x65,0x20
	.DB  0x70,0x61,0x6E,0x65,0x6C,0x20,0x0,0x63
	.DB  0x61,0x6C,0x69,0x62,0x72,0x61,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x6D,0x6F,0x64,0x65,0x0
	.DB  0x69,0x6E,0x63,0x20,0x3E,0x20,0x69,0x6E
	.DB  0x63,0x68,0x20,0x75,0x70,0x0,0x64,0x65
	.DB  0x63,0x20,0x3E,0x20,0x69,0x6E,0x63,0x68
	.DB  0x20,0x64,0x6F,0x77,0x6E,0x0,0x73,0x65
	.DB  0x74,0x2D,0x3E,0x20,0x65,0x6E,0x74,0x65
	.DB  0x72,0x20,0x6C,0x6F,0x77,0x0,0x73,0x68
	.DB  0x66,0x2D,0x3E,0x20,0x65,0x6E,0x74,0x65
	.DB  0x72,0x20,0x68,0x69,0x67,0x68,0x0,0x61
	.DB  0x64,0x63,0x3A,0x20,0x0,0x53,0x65,0x74
	.DB  0x20,0x53,0x74,0x61,0x72,0x74,0x20,0x41
	.DB  0x6E,0x67,0x6C,0x65,0x0,0x73,0x74,0x61
	.DB  0x72,0x74,0x20,0x61,0x6E,0x67,0x6C,0x65
	.DB  0x20,0x0,0x61,0x63,0x63,0x65,0x70,0x74
	.DB  0x65,0x64,0x21,0x0,0x53,0x65,0x74,0x20
	.DB  0x45,0x6E,0x64,0x20,0x41,0x6E,0x67,0x6C
	.DB  0x65,0x0,0x65,0x6E,0x64,0x20,0x61,0x6E
	.DB  0x67,0x6C,0x65,0x20,0x0,0x61,0x63,0x63
	.DB  0x65,0x70,0x74,0x65,0x64,0x21,0x20,0x0
	.DB  0x7A,0x65,0x72,0x6F,0x20,0x61,0x6E,0x67
	.DB  0x6C,0x65,0x20,0x0,0x73,0x70,0x61,0x6E
	.DB  0x20,0x61,0x6E,0x67,0x6C,0x65,0x20,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x20A0003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  _pi
	.DW  _0x3*2

	.DW  0x04
	.DW  _sundia
	.DW  _0x4*2

	.DW  0x04
	.DW  _airrefr
	.DW  _0x5*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

	.DW  0x02
	.DW  __base_y_G105
	.DW  _0x20A0003*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;
;/*****************************************************
;derived from solarp605013.c
;done: added modbus id and modbus rate paramaters
;todo:
;transfer three regiters to modbus memory array
;add modbus protocol
;
;
;add modbus paramaters
;
;derived from solarp60508.c
;reason: to add modbus
;three registers only
;read/write mode
;1. actual angle
;2. target angle
;3. mode: 1>auto,2> manual,3>sleep(night)mode
;
;
;
;
;FINAL SOFTWARE FOR BACKTRACKING AND PWM WITHOUT GPS
;
;
;derived from solarp60507.c
;date: 13 jan 2021
;
;backtracking achieved
;todo
;1. PWM soft start
;2. PWM soft end
;
;derived from solarp60506.c
;reason: paramaters set_width and set_distance added in 6.c
;todo:
;add backtracking logic and set target angle accordingly.
;also remove bug of limit angles.
;also correct eeprom load addition of width and distance
;CHANGED TO MEGA32
;
;
;derived from solarp60505.c
;to add backtracking parameters
;
;
;
;derived from solarp60504.c
;reason:
;to change angle fro 0 to 180 to -90 to 90 degrees for backtracking compatibility
;
;
;derived from solarmpu60503.c
;to add complimentary filter to pitch/roll from gyroscope reading
;pitch = 0.7(oldpitch*gyronormalised)+ 0.3(newpitch)
;
;serived from  solarmpu60501.c
;reason: to calculate pitch and roll from mpu data
;
;
;
;
;derived from ravindra energy logic with no name
;reason: to replace 3421 with MPU6050
;adc3421 read and init routines changed
;
;
;date: 22-09-2021
;reason: to change the welcome message to remove micron instruments
;
;derived from ravindra energy.c
;date: 21-06-2019
;reason: to add loading of rtc value  to eeprom on power up if rtc value is valid.
;
;
;derived from only tracker1.c
;date: 19 -06-2019
;reason: to add protection for corruption of data
;
;1. add backup for time and date if corrupt
;        if time is corrupt, reset time to last stored value, if last stored value is ff, then reset to 12:00
;        store time and date every 30mins. total writes /year =16000.
;2. add limits to start angle and end angle. if they are corrupt reset them to 55/125 degrees
;
;
;
;derived from tracker 3 phase.c
;to change the latitude and longitude to 26.5 and 73.8 degrees
;to change the start angle and end angle to 50 deg and 125 deg.
;
;derived from micron 20W.c
;reason: to create a only tracker software
;todo
;1. remove the battery charger and battery voltage related part
;2. remove the adc sensing of various voltages. retain onlty the accelerometer part
;
;
;
;DERIVED FROM LUBI ELECTRONIC.C
;TO CHANGE WELCOME MESSAGE TO MICRON INSTRUMENTS
;
;
;
;derived from tracker3.c
;reason: to change welcome message to lubi electronics.
;
;
;date : 17-11-2013
;derived from tracker2.c
;
;reason:
;1.low battery indication in normal mode. hysterisis to be provided for reconnection on 12.4V
;2. cutoff backlight on low battery status (errfl2)
;3. if adc_battery > 15V, cut charging , put message ("no battery connected");
;4. remove condition that if battery voltage < 5V, disconnect charging.
;5. increase current limits to 1.2A/1A
;6. overflow for OCR1A correction
;7. fast charging depending on battery voltage
;8. low battery/battery not connected sensing and algorithm.
;9. bug of sleep mode.
;10.MPPT changed to full charge PV >=battery + 2.0V
;
;
;
;
;
;date: 13 nov 2013
;derived from tracker1.c
;reason: to test in new hardware
;changes:
;OC1A - pin 19 of mega32 - pwm output
;OC1B = pin 18 of mega32 - shutdown for ir2104
;mux lines pc7 and pc5 interchanged to suit new hardware solar4-main
;rs232 to be re-introduced
;
;
;
;
;
;derived from solar14.c
;
;reason: to add algorithm for sleep mode between sunset + 30 min and sunrise - 30 min.
;derived from solar13.c
;reason: to make algorithm change to the mechanical error logic.
;checked once every 30 seconds. if angle has changed more than 2 degrees then continue else end panel movement
;
;
;
;date: 04-nov 2013
;reason: to make following changes as suggested by tata solar
;1.enter/exit of calibration mode for start/emd angle setting improved.**
;2.LED indication in case of error on charger side to be inhibited.    **
;3. timeout for mechanical error to be changed
;4. battery low indication in absence of PV to be indicated.           **
;5. output to relay to be inhibited in all conditions even in manual mode. **
;
;
;date: 23-9-13
;reason:
;done: setting of latitude/longitude and timezone for user
;result stored in riset,settm.
;
;todo: put value in regular calculation of target angle.
;remove existing table for sunrise/set.
;
;********
;
;
;date: 16-09-2013
;
;derived from solar4.c
;reason:to add latitude/longitude calculations.
;only for checking purpose
;
;
;
;
;
;date: 20 july 2013
;reason:
;to add logic to come out of the program mode after 29 seconds of inactivity of key pressed
;the variable used is program_timeout, function added is clear_default();
;
;date:5-7-13
;reason: to add RS232 control to the unit.
;if 'R' is received, send record count.
;if 'P' is received, send print command.
;if 's' is received , reset record count.
;
;
;date : 29-6-13
;derived from solar1.c
;reason:
;to add fixed parameters batteryvoltage = 12V and MPPT 17V
;and to monitor and control charging parameters
;
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 27.06.2013
;Author  : NeVaDa
;Company : Warner Brothers Movie World
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <math.h>
;#include <ctype.h>
;#include <stdlib.h>
;#include <sleep.h>
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x1B ;PORTA
   .equ __sda_bit=4
   .equ __scl_bit=5
; 0000 00E7 #endasm
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 00F0 #endasm
;#include <lcd.h>
;
;#define key1    PINA.0
;#define key2    PINA.1
;#define key3    PINA.2
;#define key4    PINA.3
;#define relay2  PORTC.0
;#define relay1  PORTD.7
;#define printkey PINA.6
;#define led1    PORTD.3
;#define led2    PORTC.4
;#define led3    PORTD.6
;#define led4    PORTC.3
;#define led5    PORTC.1
;#define led6    PORTC.2
;#define mux1    PORTC.5
;#define mux2    PORTC.6
;#define mux3    PORTC.7
;#define backlight   PORTB.3
;#define shutdown    PORTD.4
;#define mb_dir PORTD.4
;
;
;
;/////////
;
;//////mpu6050 definition section//////////////
;#define XG_OFFS_TC 0x00
;#define YG_OFFS_TC 0x01
;#define ZG_OFFS_TC 0x02
;#define X_FINE_GAIN 0x03
;#define Y_FINE_GAIN 0x04
;#define Z_FINE_GAIN 0x05
;#define XA_OFFS_H 0x06
;#define XA_OFFS_L_TC 0x07
;#define YA_OFFS_H 0x08
;#define YA_OFFS_L_TC 0x09
;#define ZA_OFFS_H 0x0A
;#define ZA_OFFS_L_TC 0x0B
;#define XG_OFFS_USRH 0x13
;#define XG_OFFS_USRL 0x14
;#define YG_OFFS_USRH 0x15
;#define YG_OFFS_USRL 0x16
;#define ZG_OFFS_USRH 0x17
;#define ZG_OFFS_USRL 0x18
;#define SMPLRT_DIV 0x19
;#define CONFIG 0x1A
;#define GYRO_CONFIG 0x1B
;#define ACCEL_CONFIG 0x1C
;#define FF_THR 0x1D
;#define FF_DUR 0x1E
;#define MOT_THR 0x1F
;#define MOT_DUR 0x20
;#define ZRMOT_THR 0x21
;#define ZRMOT_DUR 0x22
;#define FIFO_EN 0x23
;#define I2C_MST_CTRL 0x24
;#define I2C_SLV0_ADDR 0x25
;#define I2C_SLV0_REG 0x26
;#define I2C_SLV0_CTRL 0x27
;#define I2C_SLV1_ADDR 0x28
;#define I2C_SLV1_REG 0x29
;#define I2C_SLV1_CTRL 0x2A
;#define I2C_SLV2_ADDR 0x2B
;#define I2C_SLV2_REG 0x2C
;#define I2C_SLV2_CTRL 0x2D
;#define I2C_SLV3_ADDR 0x2E
;#define I2C_SLV3_REG 0x2F
;#define I2C_SLV3_CTRL 0x30
;#define I2C_SLV4_ADDR 0x31
;#define I2C_SLV4_REG 0x32
;#define I2C_SLV4_DO 0x33
;#define I2C_SLV4_CTRL 0x34
;#define I2C_SLV4_DI 0x35
;#define I2C_MST_STATUS 0x36
;#define INT_PIN_CFG 0x37
;#define INT_ENABLE 0x38
;#define DMP_INT_STATUS 0x39
;#define INT_STATUS 0x3A
;#define ACCEL_XOUT_H 0x3B
;#define ACCEL_XOUT_L 0x3C
;#define ACCEL_YOUT_H 0x3D
;#define ACCEL_YOUT_L 0x3E
;#define ACCEL_ZOUT_H 0x3F
;#define ACCEL_ZOUT_L 0x40
;#define TEMP_OUT_H 0x41
;#define TEMP_OUT_L 0x42
;#define GYRO_XOUT_H 0x43
;#define GYRO_XOUT_L 0x44
;#define GYRO_YOUT_H 0x45
;#define GYRO_YOUT_L 0x46
;#define GYRO_ZOUT_H 0x47
;#define GYRO_ZOUT_L 0x48
;#define EXT_SENS_DATA_00 0x49
;#define EXT_SENS_DATA_01 0x4A
;#define EXT_SENS_DATA_02 0x4B
;#define EXT_SENS_DATA_03 0x4C
;#define EXT_SENS_DATA_04 0x4D
;#define EXT_SENS_DATA_05 0x4E
;#define EXT_SENS_DATA_06 0x4F
;#define EXT_SENS_DATA_07 0x50
;#define EXT_SENS_DATA_08 0x51
;#define EXT_SENS_DATA_09 0x52
;#define EXT_SENS_DATA_10 0x53
;#define EXT_SENS_DATA_11 0x54
;#define EXT_SENS_DATA_12 0x55
;#define EXT_SENS_DATA_13 0x56
;#define EXT_SENS_DATA_14 0x57
;#define EXT_SENS_DATA_15 0x58
;#define EXT_SENS_DATA_16 0x59
;#define EXT_SENS_DATA_17 0x5A
;#define EXT_SENS_DATA_18 0x5B
;#define EXT_SENS_DATA_19 0x5C
;#define EXT_SENS_DATA_20 0x5D
;#define EXT_SENS_DATA_21 0x5E
;#define EXT_SENS_DATA_22 0x5F
;#define EXT_SENS_DATA_23 0x60
;#define MOT_DETECT_STATUS 0x61
;#define I2C_SLV0_DO 0x63
;#define I2C_SLV1_DO 0x64
;#define I2C_SLV2_DO 0x65
;#define I2C_SLV3_DO 0x66
;#define I2C_MST_DELAY_CTRL 0x67
;#define SIGNAL_PATH_RESET 0x68
;#define MOT_DETECT_CTRL 0x69
;#define USER_CTRL 0x6A
;#define PWR_MGMT_1 0x6B
;#define PWR_MGMT_2 0x6C
;#define BANK_SEL 0x6D
;#define MEM_START_ADDR 0x6E
;#define MEM_R_W 0x6F
;#define DMP_CFG_1 0x70
;#define DMP_CFG_2 0x71
;#define FIFO_COUNTH 0x72
;#define FIFO_COUNTL 0x73
;#define FIFO_R_W 0x74
;#define WHO_AM_I 0x75
;
;
;
;///////////////////////////////////////////
;
;
;
;
;float pi =3.14159;

	.DSEG
;float degs;
;float rads;
;float L,g;
;float sundia = 0.53;
;float airrefr = 34.0/60.0;
;float settm,riset,daytime,sunrise_min,sunset_min;
;
;///////////////////////////////////////////////////
;
;long int adc_buffer,timeout_cnt,target_angle,sun_angle,printkeycnt,calibusercnt,program_timeout;
;unsigned char hour,minute,second,week,day,month,year;
;bit key1_old,key2_old,key3_old,key4_old,printkey_old,start_fl,end_fl,inf_fl;
;//bit rcflag;
;bit key1_fl,key2_fl,key3_fl,key4_fl,printkey_fl,err_fl,led_blinkfl,sleep_fl,print_fl;
;bit pgm_fl,blink_fl,adc_fl,read_adcfl,boost_fl,trickle_fl,float_fl;
;short int mode,set,item1,bright_cnt,mode0_seqcnt,end_cnt,sleep_counter;
;//short int ir_cnt;
;unsigned int time_cnt,time_cnt1,pwm_count;
;unsigned int mode1_count,blink_count,display_cnt,manual_cnt;
;//unsigned long int boost_time,float_time;
;char blink_locx,blink_locy;
;char blink_data;
;signed int set_latit,set_longitude,low_angle,high_angle,time_interval,target_time,time_elap,set_timezone;
;//int ircommand;
;//unsigned long irsense;
;long int zero_adc,span_adc;
;unsigned char char_latitude,char_longitude,char_timezone,char_width,char_distance,char_id,char_rate;
;//char record_buffer[16];
;eeprom signed int e_set_latit = 2650,e_set_longitude =7380,e_low_angle=-400,e_high_angle=400,e_time_interval=5,e_set_tim ...
;eeprom long int e_zero_adc =0,e_span_adc=20000;
;eeprom int record_cnt @0x020;
;eeprom int record_cnt =0;
;eeprom unsigned char e_hour=12,e_minute=0,e_second=0,e_week=1,e_month=6,e_day=1,e_year=19;
;//flash int sunrise_time[] ={718,709,607,620,601,556,605,617,625,634,649,708};            //according to month
;//flash int sunset_time[]={1818,1836,1848,1857,1909,1921,1923,1908,1841,1814,1757,1759};   //according to month
;//flash int sunrise_min[]={438,429,407,380,361,356,365,377,385,394,409,428};
;//flash int sunset_min[]={1098,1116,1128,1137,1149,1161,1163,1148,1121,1094,1077,1079};
;//flash int daytime[]={659,687,720,757,788,804,798,771,736,700,668,651};
;bit calibuser,calibfact,manual_fl=0;
;//char flash *message1 = {"set the time"};
;int x_angle,y_angle,z_angle,pitch,roll,angle,Gyrox,Gyroy,Gyroz;
;int angle_filt[4]={0,0,0,0};
;void display_update(void);
;int set_distance,set_width,modbus_id,modbus_rate;
;eeprom int e_set_width =10,e_set_distance = 20,e_modbus_id =13,e_modbus_rate=1;
;signed int new_target,b_factor,gangle;
;
;bit modbus_fl;
;
;/////usart routines//////
;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 20
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;char mbreceived_data[10];
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 01E9 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 01EA char status,data,i;
; 0000 01EB status=UCSRA;
	CALL __SAVELOCR4
;	status -> R17
;	data -> R16
;	i -> R19
	IN   R17,11
; 0000 01EC data=UDR;
	IN   R16,12
; 0000 01ED if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x6
; 0000 01EE    {
; 0000 01EF    rx_buffer[rx_wr_index]=data;
	LDS  R30,_rx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 01F0    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x14)
	BRNE _0x7
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 01F1    if (++rx_counter == RX_BUFFER_SIZE)
_0x7:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x14)
	BRNE _0x8
; 0000 01F2       {
; 0000 01F3       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 01F4       rx_buffer_overflow=1;
	SET
	BLD  R5,4
; 0000 01F5       };
_0x8:
; 0000 01F6 
; 0000 01F7 ///////////////////////////////////
; 0000 01F8 //added to form modbus frame
; 0000 01F9 if (rx_counter==1)
	LDS  R26,_rx_counter
	CPI  R26,LOW(0x1)
	BRNE _0x9
; 0000 01FA     {
; 0000 01FB     if (rx_buffer[0] != (char)(modbus_id))  //modbus_id
	LDS  R30,_modbus_id
	LDS  R26,_rx_buffer
	CP   R30,R26
	BREQ _0xA
; 0000 01FC         rx_counter = rx_wr_index =0;    //reset frame till first byte matchs slave address
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
	STS  _rx_counter,R30
; 0000 01FD     }
_0xA:
; 0000 01FE else
	RJMP _0xB
_0x9:
; 0000 01FF     {
; 0000 0200     // valid slave address.allot frame size according to function code.
; 0000 0201     if (rx_counter >=8)
	LDS  R26,_rx_counter
	CPI  R26,LOW(0x8)
	BRLO _0xC
; 0000 0202       {
; 0000 0203     //modbus frame complete. transfer data to mbreceived_data[]
; 0000 0204         for (i=0;i<8;i++)
	LDI  R19,LOW(0)
_0xE:
	CPI  R19,8
	BRSH _0xF
; 0000 0205         {
; 0000 0206         mbreceived_data[i] = rx_buffer[i];
	MOV  R26,R19
	LDI  R27,0
	SUBI R26,LOW(-_mbreceived_data)
	SBCI R27,HIGH(-_mbreceived_data)
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R30,Z
	ST   X,R30
; 0000 0207         }
	SUBI R19,-1
	RJMP _0xE
_0xF:
; 0000 0208         rx_counter = rx_wr_index =0;        //reset counter to start for next frame
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
	STS  _rx_counter,R30
; 0000 0209         modbus_fl =1;                       // set flag to indicate frame recieved in main routine.
	SET
	BLD  R5,3
; 0000 020A //        mb_dir =1;      //ready for transmit
; 0000 020B       }
; 0000 020C     }
_0xC:
_0xB:
; 0000 020D 
; 0000 020E 
; 0000 020F //////////////////////////////////
; 0000 0210    };
_0x6:
; 0000 0211 }
	CALL __LOADLOCR4
	ADIW R28,4
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0218 {
; 0000 0219 char data;
; 0000 021A while (rx_counter==0);
;	data -> R17
; 0000 021B data=rx_buffer[rx_rd_index];
; 0000 021C if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 021D #asm("cli")
; 0000 021E --rx_counter;
; 0000 021F #asm("sei")
; 0000 0220 return data;
; 0000 0221 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 48
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0231 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0232 if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0x14
; 0000 0233    {
; 0000 0234    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 0235    UDR=tx_buffer[tx_rd_index];
	LDS  R30,_tx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0236    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	SUBI R26,-LOW(1)
	STS  _tx_rd_index,R26
	CPI  R26,LOW(0x30)
	BRNE _0x15
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 0237    };
_0x15:
_0x14:
; 0000 0238 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 023F {
_putchar:
; .FSTART _putchar
; 0000 0240 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x16:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x30)
	BREQ _0x16
; 0000 0241 #asm("cli")
	cli
; 0000 0242 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x1A
	SBIC 0xB,5
	RJMP _0x19
_0x1A:
; 0000 0243    {
; 0000 0244    tx_buffer[tx_wr_index]=c;
	LDS  R30,_tx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0245    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	SUBI R26,-LOW(1)
	STS  _tx_wr_index,R26
	CPI  R26,LOW(0x30)
	BRNE _0x1C
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 0246    ++tx_counter;
_0x1C:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 0247    }
; 0000 0248 else
	RJMP _0x1D
_0x19:
; 0000 0249    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 024A #asm("sei")
_0x1D:
	sei
; 0000 024B }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;
;
;
;
;/////////////////
;
;
;
;
;
;
;
;
;
;
;
;///////////////////////MODBUS CODES /////////////////////////
;
;
;
;
;
;flash int wCRCTable[] = {
;0X0000, 0XC0C1, 0XC181, 0X0140, 0XC301, 0X03C0, 0X0280, 0XC241,
;0XC601, 0X06C0, 0X0780, 0XC741, 0X0500, 0XC5C1, 0XC481, 0X0440,
;0XCC01, 0X0CC0, 0X0D80, 0XCD41, 0X0F00, 0XCFC1, 0XCE81, 0X0E40,
;0X0A00, 0XCAC1, 0XCB81, 0X0B40, 0XC901, 0X09C0, 0X0880, 0XC841,
;0XD801, 0X18C0, 0X1980, 0XD941, 0X1B00, 0XDBC1, 0XDA81, 0X1A40,
;0X1E00, 0XDEC1, 0XDF81, 0X1F40, 0XDD01, 0X1DC0, 0X1C80, 0XDC41,
;0X1400, 0XD4C1, 0XD581, 0X1540, 0XD701, 0X17C0, 0X1680, 0XD641,
;0XD201, 0X12C0, 0X1380, 0XD341, 0X1100, 0XD1C1, 0XD081, 0X1040,
;0XF001, 0X30C0, 0X3180, 0XF141, 0X3300, 0XF3C1, 0XF281, 0X3240,
;0X3600, 0XF6C1, 0XF781, 0X3740, 0XF501, 0X35C0, 0X3480, 0XF441,
;0X3C00, 0XFCC1, 0XFD81, 0X3D40, 0XFF01, 0X3FC0, 0X3E80, 0XFE41,
;0XFA01, 0X3AC0, 0X3B80, 0XFB41, 0X3900, 0XF9C1, 0XF881, 0X3840,
;0X2800, 0XE8C1, 0XE981, 0X2940, 0XEB01, 0X2BC0, 0X2A80, 0XEA41,
;0XEE01, 0X2EC0, 0X2F80, 0XEF41, 0X2D00, 0XEDC1, 0XEC81, 0X2C40,
;0XE401, 0X24C0, 0X2580, 0XE541, 0X2700, 0XE7C1, 0XE681, 0X2640,
;0X2200, 0XE2C1, 0XE381, 0X2340, 0XE101, 0X21C0, 0X2080, 0XE041,
;0XA001, 0X60C0, 0X6180, 0XA141, 0X6300, 0XA3C1, 0XA281, 0X6240,
;0X6600, 0XA6C1, 0XA781, 0X6740, 0XA501, 0X65C0, 0X6480, 0XA441,
;0X6C00, 0XACC1, 0XAD81, 0X6D40, 0XAF01, 0X6FC0, 0X6E80, 0XAE41,
;0XAA01, 0X6AC0, 0X6B80, 0XAB41, 0X6900, 0XA9C1, 0XA881, 0X6840,
;0X7800, 0XB8C1, 0XB981, 0X7940, 0XBB01, 0X7BC0, 0X7A80, 0XBA41,
;0XBE01, 0X7EC0, 0X7F80, 0XBF41, 0X7D00, 0XBDC1, 0XBC81, 0X7C40,
;0XB401, 0X74C0, 0X7580, 0XB541, 0X7700, 0XB7C1, 0XB681, 0X7640,
;0X7200, 0XB2C1, 0XB381, 0X7340, 0XB101, 0X71C0, 0X7080, 0XB041,
;0X5000, 0X90C1, 0X9181, 0X5140, 0X9301, 0X53C0, 0X5280, 0X9241,
;0X9601, 0X56C0, 0X5780, 0X9741, 0X5500, 0X95C1, 0X9481, 0X5440,
;0X9C01, 0X5CC0, 0X5D80, 0X9D41, 0X5F00, 0X9FC1, 0X9E81, 0X5E40,
;0X5A00, 0X9AC1, 0X9B81, 0X5B40, 0X9901, 0X59C0, 0X5880, 0X9841,
;0X8801, 0X48C0, 0X4980, 0X8941, 0X4B00, 0X8BC1, 0X8A81, 0X4A40,
;0X4E00, 0X8EC1, 0X8F81, 0X4F40, 0X8D01, 0X4DC0, 0X4C80, 0X8C41,
;0X4400, 0X84C1, 0X8581, 0X4540, 0X8701, 0X47C0, 0X4680, 0X8641,
;0X8201, 0X42C0, 0X4380, 0X8341, 0X4100, 0X81C1, 0X8081, 0X4040 };
;
;unsigned int CRC16 (const char *nData, unsigned int wLength)
; 0000 0288 {
_CRC16:
; .FSTART _CRC16
; 0000 0289 
; 0000 028A 
; 0000 028B char nTemp;
; 0000 028C unsigned int wCRCWord = 0xFFFF;
; 0000 028D 
; 0000 028E    while (wLength--)
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*nData -> Y+6
;	wLength -> Y+4
;	nTemp -> R17
;	wCRCWord -> R18,R19
	__GETWRN 18,19,-1
_0x1E:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	ADIW R30,1
	BREQ _0x20
; 0000 028F    {
; 0000 0290       nTemp = *nData++ ^ wCRCWord;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	EOR  R30,R18
	MOV  R17,R30
; 0000 0291       wCRCWord >>= 8;
	MOV  R18,R19
	CLR  R19
; 0000 0292       wCRCWord ^= wCRCTable[nTemp];
	LDI  R26,LOW(_wCRCTable*2)
	LDI  R27,HIGH(_wCRCTable*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	__EORWRR 18,19,30,31
; 0000 0293    }
	RJMP _0x1E
_0x20:
; 0000 0294    return wCRCWord;
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; 0000 0295 
; 0000 0296 }
; .FEND
;
;int mb_data[20];
;int mb_inputdata[5];
;//function  codes
;#define mbreadholdingregisters  3
;#define mbreadinputregisters    4
;#define mb presetmultipleregisters 16
;#define mbreportslaveid  17
;
;//error codes
;#define mbillegalfunction 1
;#define mbillegaldataaddress 2
;#define mbillegaldatavalue 3
;#define mbslavedevicefailure 4
;#define mbacknowledge 5
;#define mbslavedevicebusy 6
;#define mbnegativeacknowledge 7
;#define mbmemoryparityerror 8
;
;
;
;void mbreset()
; 0000 02AD {
_mbreset:
; .FSTART _mbreset
; 0000 02AE 
; 0000 02AF     rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 02B0     rx_rd_index=0;
	STS  _rx_rd_index,R30
; 0000 02B1     rx_rd_index =0;
	STS  _rx_rd_index,R30
; 0000 02B2     tx_counter =0;
	STS  _tx_counter,R30
; 0000 02B3     tx_wr_index =0;
	STS  _tx_wr_index,R30
; 0000 02B4     tx_rd_index =0;
	STS  _tx_rd_index,R30
; 0000 02B5 }
	RET
; .FEND
;
;
;//map
;//40001 - 8    process_Value
;//40009-16   al-hi
;//40017-24   al-lo
;//40018-32    r-hi
;//40033-40   r-lo
;void mb_datatransfer()
; 0000 02BF {
_mb_datatransfer:
; .FSTART _mb_datatransfer
; 0000 02C0 //set_latit,set_longitude,low_angle,high_angle,time_interval,target_time,time_elap,set_timezone;
; 0000 02C1 
; 0000 02C2 //holding register data(R/W)
; 0000 02C3 mb_data[0]= day;
	MOV  R30,R11
	LDI  R31,0
	STS  _mb_data,R30
	STS  _mb_data+1,R31
; 0000 02C4 mb_data[1] =month;
	__POINTW2MN _mb_data,2
	MOV  R30,R10
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 02C5 mb_data[2] = year;
	__POINTW2MN _mb_data,4
	MOV  R30,R13
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 02C6 mb_data[3] = hour;
	__POINTW2MN _mb_data,6
	MOV  R30,R7
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 02C7 mb_data[4] =minute;
	__POINTW2MN _mb_data,8
	MOV  R30,R6
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 02C8 mb_data[5] = set_latit;
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	__PUTW1MN _mb_data,10
; 0000 02C9 mb_data[6] = set_longitude;
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	__PUTW1MN _mb_data,12
; 0000 02CA mb_data[7] = time_interval;
	LDS  R30,_time_interval
	LDS  R31,_time_interval+1
	__PUTW1MN _mb_data,14
; 0000 02CB mb_data[8] = set_timezone;
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	__PUTW1MN _mb_data,16
; 0000 02CC mb_data[9] = set_width;
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	__PUTW1MN _mb_data,18
; 0000 02CD mb_data[10] = set_distance;
	LDS  R30,_set_distance
	LDS  R31,_set_distance+1
	__PUTW1MN _mb_data,20
; 0000 02CE 
; 0000 02CF //input data
; 0000 02D0 mb_inputdata[0] = angle;
	LDS  R30,_angle
	LDS  R31,_angle+1
	STS  _mb_inputdata,R30
	STS  _mb_inputdata+1,R31
; 0000 02D1 mb_inputdata[1] = target_angle;
	LDS  R30,_target_angle
	LDS  R31,_target_angle+1
	__PUTW1MN _mb_inputdata,2
; 0000 02D2 mb_inputdata[2] = target_time/60;   //target time in hours
	LDS  R26,_target_time
	LDS  R27,_target_time+1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21
	__PUTW1MN _mb_inputdata,4
; 0000 02D3 mb_inputdata[3] = target_time%60;   //target time in minutes
	LDS  R26,_target_time
	LDS  R27,_target_time+1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	__PUTW1MN _mb_inputdata,6
; 0000 02D4 }
	RET
; .FEND
;
;
;//used for function code 06. write single register.
;//checks the address to be written,if valid,writes to the address and returns 0,else returns 1
;short int mblimitcheck(int address,int value)
; 0000 02DA {
_mblimitcheck:
; .FSTART _mblimitcheck
; 0000 02DB //int min[8],max[8],i;
; 0000 02DC short int ok_st=1;
; 0000 02DD 
; 0000 02DE return (ok_st);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	address -> Y+4
;	value -> Y+2
;	ok_st -> R16,R17
	__GETWRN 16,17,1
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 02DF }
; .FEND
;
;
;void check_mbreceived()
; 0000 02E3 {
_check_mbreceived:
; .FSTART _check_mbreceived
; 0000 02E4 unsigned int mbaddress;
; 0000 02E5 int mbamount;
; 0000 02E6 unsigned char mbtransmit_data[40];        //transmit buffer max. 32 nytes or 16 registers
; 0000 02E7 short int error_code =0;
; 0000 02E8 unsigned int i,j,k;
; 0000 02E9 //mb_dir =0;  //set 485 to transmit data
; 0000 02EA //check function code
; 0000 02EB //printf(" test sending");
; 0000 02EC switch (mbreceived_data[1])
	SBIW R28,46
	CALL __SAVELOCR6
;	mbaddress -> R16,R17
;	mbamount -> R18,R19
;	mbtransmit_data -> Y+12
;	error_code -> R20,R21
;	i -> Y+10
;	j -> Y+8
;	k -> Y+6
	__GETWRN 20,21,0
	__GETB1MN _mbreceived_data,1
	LDI  R31,0
; 0000 02ED             {
; 0000 02EE             case 0x03:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x24
; 0000 02EF  //                mbaddress = (mbreceived_data[2]*256) + mbreceived_data[3];      //start address;
; 0000 02F0                  mbaddress = mbreceived_data[3];      //start address;
	__GETBRMN 16,_mbreceived_data,3
	CLR  R17
; 0000 02F1                  if (mbaddress+1 >=58)
	MOVW R26,R16
	ADIW R26,1
	SBIW R26,58
	BRLO _0x25
; 0000 02F2                     {
; 0000 02F3                     error_code = mbillegaldataaddress;
	__GETWRN 20,21,2
; 0000 02F4                     break;
	RJMP _0x23
; 0000 02F5                     }
; 0000 02F6 //                 mbamount = (mbreceived_data[4] *256) +mbreceived_data[5];      //requested amount
; 0000 02F7                  mbamount = mbreceived_data[5];      //requested amount
_0x25:
	__GETBRMN 18,_mbreceived_data,5
	CLR  R19
; 0000 02F8                  if ((mbaddress+mbamount) > 58 || mbamount >16)
	MOVW R26,R18
	ADD  R26,R16
	ADC  R27,R17
	SBIW R26,59
	BRSH _0x27
	__CPWRN 18,19,17
	BRLT _0x26
_0x27:
; 0000 02F9                     {
; 0000 02FA                     error_code = mbillegaldatavalue;         //requested data overflow
	__GETWRN 20,21,3
; 0000 02FB                     break;
	RJMP _0x23
; 0000 02FC                     }
; 0000 02FD                     i = CRC16(rx_buffer,6);
_0x26:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _CRC16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 02FE 
; 0000 02FF                     if((rx_buffer[6] != i%256) || (rx_buffer[7] != i/256)  )
	__GETB2MN _rx_buffer,6
	ANDI R31,HIGH(0xFF)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2A
	__GETB2MN _rx_buffer,7
	LDD  R30,Y+11
	ANDI R31,HIGH(0x0)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x29
_0x2A:
; 0000 0300                     {
; 0000 0301                     error_code = mbillegaldatavalue;      //CRC not matching
	__GETWRN 20,21,3
; 0000 0302                     break;
	RJMP _0x23
; 0000 0303                     }
; 0000 0304                   //valid request so form mb frame accordingly
; 0000 0305                   error_code =0;       //
_0x29:
	__GETWRN 20,21,0
; 0000 0306                     mb_dir =1;      //transmit
	SBI  0x12,4
; 0000 0307 //                  mbamount =8;                  //test
; 0000 0308                   mbtransmit_data[0] = mbreceived_data[0];      //slave id
	LDS  R30,_mbreceived_data
	STD  Y+12,R30
; 0000 0309                   mbtransmit_data[1] = mbreceived_data[1];       //function code
	__GETB1MN _mbreceived_data,1
	STD  Y+13,R30
; 0000 030A                   mbtransmit_data[2] = (char)mbamount *2;             //SIZE OF DATA IN BYTES
	MOV  R30,R18
	LSL  R30
	STD  Y+14,R30
; 0000 030B                     j=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 030C 
; 0000 030D //                    mb_dir =0;  //set to transmit
; 0000 030E                     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 030F                     for (i=0;i<mbamount;i++)               //transfer data
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x2F:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R18
	CPC  R27,R19
	BRSH _0x30
; 0000 0310                         {
; 0000 0311 //                        mbtransmit_data[j] = (char)(mb_data[mbaddress+i]/256);
; 0000 0312                          mbtransmit_data[j] = (short int)((mb_data[mbaddress+i]>>8)& 0X00ff);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADD  R30,R16
	ADC  R31,R17
	LDI  R26,LOW(_mb_data)
	LDI  R27,HIGH(_mb_data)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CALL __ASRW8
	MOVW R26,R0
	ST   X,R30
; 0000 0313 
; 0000 0314                         j++;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0315 //                        mbtransmit_data[j] = (char)(mb_data[mbaddress+i]%256);
; 0000 0316                          mbtransmit_data[j] = (short int)(mb_data[mbaddress+i]& 0X00ff);
	MOVW R26,R28
	ADIW R26,12
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADD  R30,R16
	ADC  R31,R17
	LDI  R26,LOW(_mb_data)
	LDI  R27,HIGH(_mb_data)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0317 
; 0000 0318                         j++;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0319                         }
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2F
_0x30:
; 0000 031A                     i= CRC16(mbtransmit_data,(mbamount*2)+3);
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ADIW R30,3
	MOVW R26,R30
	RCALL _CRC16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 031B                     mbtransmit_data[j] = i%256;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+10
	ST   X,R30
; 0000 031C                     mbtransmit_data[j+1]=i/256;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+11
	ST   X,R30
; 0000 031D                     #asm("cli")
	cli
; 0000 031E 
; 0000 031F //                    mb_dir =0;//set to transmit data
; 0000 0320                     for (i=0;i<mbtransmit_data[2]+4+1;i++)
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x32:
	LDD  R30,Y+14
	LDI  R31,0
	ADIW R30,5
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x33
; 0000 0321                         {
; 0000 0322                         putchar(mbtransmit_data[i]);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 0323                         }
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x32
_0x33:
; 0000 0324 
; 0000 0325 //                     mbreset();
; 0000 0326                     #asm("sei")
	sei
; 0000 0327                     delay_ms(50);      //wait till all data transmitted need time to transmit max 36 bytes @9600
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0328                     mb_dir =0;   //recieve
	CBI  0x12,4
; 0000 0329                     mbreset();
	RCALL _mbreset
; 0000 032A                     break;
	RJMP _0x23
; 0000 032B 
; 0000 032C 
; 0000 032D             case 0x04:     //read input registers (30xxx)
_0x24:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x36
; 0000 032E                      //                mbaddress = (mbreceived_data[2]*256) + mbreceived_data[3];      //start address;
; 0000 032F                  mbaddress = mbreceived_data[3];      //start address; 30001
	__GETBRMN 16,_mbreceived_data,3
	CLR  R17
; 0000 0330                  if (mbaddress+1 >=21)
	MOVW R26,R16
	ADIW R26,1
	SBIW R26,21
	BRLO _0x37
; 0000 0331                     {
; 0000 0332                     error_code = mbillegaldataaddress;
	__GETWRN 20,21,2
; 0000 0333                     break;
	RJMP _0x23
; 0000 0334                     }
; 0000 0335 //                 mbamount = (mbreceived_data[4] *256) +mbreceived_data[5];      //requested amount
; 0000 0336                  mbamount = mbreceived_data[5];      //requested amount
_0x37:
	__GETBRMN 18,_mbreceived_data,5
	CLR  R19
; 0000 0337                  if ((mbaddress+mbamount) > 20 || mbamount >16)
	MOVW R26,R18
	ADD  R26,R16
	ADC  R27,R17
	SBIW R26,21
	BRSH _0x39
	__CPWRN 18,19,17
	BRLT _0x38
_0x39:
; 0000 0338                     {
; 0000 0339                     error_code = mbillegaldatavalue;         //requested data overflow
	__GETWRN 20,21,3
; 0000 033A                     break;
	RJMP _0x23
; 0000 033B                     }
; 0000 033C                     i = CRC16(rx_buffer,6);
_0x38:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _CRC16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 033D 
; 0000 033E                     if((rx_buffer[6] != i%256) || (rx_buffer[7] != i/256)  )
	__GETB2MN _rx_buffer,6
	ANDI R31,HIGH(0xFF)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x3C
	__GETB2MN _rx_buffer,7
	LDD  R30,Y+11
	ANDI R31,HIGH(0x0)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x3B
_0x3C:
; 0000 033F                     {
; 0000 0340                     error_code = mbillegaldatavalue;      //CRC not matching
	__GETWRN 20,21,3
; 0000 0341                     break;
	RJMP _0x23
; 0000 0342                     }
; 0000 0343 
; 0000 0344                   //valid request so form mb frame accordingly
; 0000 0345                   error_code =0;       //
_0x3B:
	__GETWRN 20,21,0
; 0000 0346                     mb_dir =1;      //transmit
	SBI  0x12,4
; 0000 0347 //                  mbamount =8;                  //test
; 0000 0348                   mbtransmit_data[0] = mbreceived_data[0];      //slave id
	LDS  R30,_mbreceived_data
	STD  Y+12,R30
; 0000 0349                   mbtransmit_data[1] = mbreceived_data[1];       //function code
	__GETB1MN _mbreceived_data,1
	STD  Y+13,R30
; 0000 034A                   mbtransmit_data[2] = (char)mbamount *2;             //SIZE OF DATA IN BYTES
	MOV  R30,R18
	LSL  R30
	STD  Y+14,R30
; 0000 034B                     j=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 034C 
; 0000 034D //                    mb_dir =0;  //set to transmit
; 0000 034E                     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 034F                     for (i=0;i<mbamount;i++)               //transfer data
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x41:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R18
	CPC  R27,R19
	BRSH _0x42
; 0000 0350                         {
; 0000 0351 //                        mbtransmit_data[j] = (char)(mb_inputdata[mbaddress+i]/256);
; 0000 0352                          mbtransmit_data[j] = (short int)((mb_inputdata[mbaddress+i]>>8)& 0X00ff);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADD  R30,R16
	ADC  R31,R17
	LDI  R26,LOW(_mb_inputdata)
	LDI  R27,HIGH(_mb_inputdata)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CALL __ASRW8
	MOVW R26,R0
	ST   X,R30
; 0000 0353                         j++;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0354 //                        mbtransmit_data[j] = (char)(mb_inputdata[mbaddress+i]%256);
; 0000 0355                          mbtransmit_data[j] = (short int)(mb_inputdata[mbaddress+i]& 0X00ff);
	MOVW R26,R28
	ADIW R26,12
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADD  R30,R16
	ADC  R31,R17
	LDI  R26,LOW(_mb_inputdata)
	LDI  R27,HIGH(_mb_inputdata)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0356                         j++;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0357                         }
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x41
_0x42:
; 0000 0358                     i= CRC16(mbtransmit_data,(mbamount*2)+3);
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ADIW R30,3
	MOVW R26,R30
	RCALL _CRC16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0359                     mbtransmit_data[j] = i%256;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+10
	ST   X,R30
; 0000 035A                     mbtransmit_data[j+1]=i/256;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+11
	ST   X,R30
; 0000 035B                     #asm("cli")
	cli
; 0000 035C 
; 0000 035D //                    mb_dir =0;//set to transmit data
; 0000 035E                     for (i=0;i<mbtransmit_data[2]+4+1;i++)
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x44:
	LDD  R30,Y+14
	LDI  R31,0
	ADIW R30,5
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x45
; 0000 035F                         {
; 0000 0360                         putchar(mbtransmit_data[i]);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 0361                         }
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x44
_0x45:
; 0000 0362 
; 0000 0363 //                     mbreset();
; 0000 0364                     #asm("sei")
	sei
; 0000 0365                     delay_ms(50);      //wait till all data transmitted need time to transmit max 36 bytes @9600
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0366                     mb_dir =0;   //recieve
	CBI  0x12,4
; 0000 0367                     mbreset();
	RCALL _mbreset
; 0000 0368 
; 0000 0369 
; 0000 036A 
; 0000 036B                     break;
	RJMP _0x23
; 0000 036C 
; 0000 036D 
; 0000 036E 
; 0000 036F             //Preset Single Register
; 0000 0370             case 0x06:
_0x36:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x59
; 0000 0371                  mbaddress = mbreceived_data[3];      //start address;
	__GETBRMN 16,_mbreceived_data,3
	CLR  R17
; 0000 0372                  if (mbaddress+1 > 58)
	MOVW R26,R16
	ADIW R26,1
	SBIW R26,59
	BRLO _0x49
; 0000 0373                     {
; 0000 0374                     error_code = mbillegaldataaddress;
	__GETWRN 20,21,2
; 0000 0375                     break;
	RJMP _0x23
; 0000 0376                     }
; 0000 0377                  mbamount = (mbreceived_data[4] *256) +mbreceived_data[5];      //requested amount
_0x49:
	__GETB2MN _mbreceived_data,4
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	MOVW R26,R30
	__GETB1MN _mbreceived_data,5
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
; 0000 0378 
; 0000 0379                  if (mbamount < -1999 || mbamount >9999)
	__CPWRN 18,19,-1999
	BRLT _0x4B
	__CPWRN 18,19,10000
	BRLT _0x4A
_0x4B:
; 0000 037A                     {
; 0000 037B                     error_code = mbillegaldatavalue;         //requested data overflow
	__GETWRN 20,21,3
; 0000 037C                     break;
	RJMP _0x23
; 0000 037D                     }
; 0000 037E                  else
_0x4A:
; 0000 037F                     {
; 0000 0380                     k = mblimitcheck(mbaddress,mbamount);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _mblimitcheck
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0381                     if (k == 1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x4E
; 0000 0382                     {
; 0000 0383                     error_code = 7;//mbillegaldatavalue;       //write not done. invalid value
	__GETWRN 20,21,7
; 0000 0384                     break;
	RJMP _0x23
; 0000 0385                     }
; 0000 0386                     }
_0x4E:
; 0000 0387                     i = CRC16(rx_buffer,6);
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _CRC16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0388 
; 0000 0389                  if((rx_buffer[6] != i%256) || (rx_buffer[7] != i/256)  )
	__GETB2MN _rx_buffer,6
	ANDI R31,HIGH(0xFF)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x50
	__GETB2MN _rx_buffer,7
	LDD  R30,Y+11
	ANDI R31,HIGH(0x0)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x4F
_0x50:
; 0000 038A                     {
; 0000 038B                     error_code = mbillegaldatavalue;      //CRC not matching
	__GETWRN 20,21,3
; 0000 038C                     break;
	RJMP _0x23
; 0000 038D                     }
; 0000 038E                   //valid request so form mb frame  echo accordingly
; 0000 038F                   error_code =0;       //
_0x4F:
	__GETWRN 20,21,0
; 0000 0390                   mb_dir =1;      //transmit
	SBI  0x12,4
; 0000 0391                   mbtransmit_data[0] = mbreceived_data[0];      //slave id
	LDS  R30,_mbreceived_data
	STD  Y+12,R30
; 0000 0392                   mbtransmit_data[1] = mbreceived_data[1];       //function code
	__GETB1MN _mbreceived_data,1
	STD  Y+13,R30
; 0000 0393                   mbtransmit_data[2] = mbreceived_data[2];      //slave id
	__GETB1MN _mbreceived_data,2
	STD  Y+14,R30
; 0000 0394                   mbtransmit_data[3] = mbreceived_data[3];       //function code
	__GETB1MN _mbreceived_data,3
	STD  Y+15,R30
; 0000 0395                   mbtransmit_data[4] = mbreceived_data[4];      //slave id
	__GETB1MN _mbreceived_data,4
	STD  Y+16,R30
; 0000 0396                   mbtransmit_data[5] = mbreceived_data[5];       //function code
	__GETB1MN _mbreceived_data,5
	STD  Y+17,R30
; 0000 0397                   mbtransmit_data[6] = mbreceived_data[6];      //slave id
	__GETB1MN _mbreceived_data,6
	STD  Y+18,R30
; 0000 0398                   mbtransmit_data[7] = mbreceived_data[7];       //function code
	__GETB1MN _mbreceived_data,7
	STD  Y+19,R30
; 0000 0399 
; 0000 039A                     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 039B 
; 0000 039C                     #asm("cli")
	cli
; 0000 039D 
; 0000 039E //                    mb_dir =0;//set to transmit data
; 0000 039F                     for (i=0;i<8;i++)
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x55:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,8
	BRSH _0x56
; 0000 03A0                         {
; 0000 03A1                         putchar(mbtransmit_data[i]);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 03A2                         }
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x55
_0x56:
; 0000 03A3 
; 0000 03A4 //                     mbreset();
; 0000 03A5                     #asm("sei")
	sei
; 0000 03A6                     delay_ms(50);      //wait till all data transmitted need time to transmit max 36 bytes @9600
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 03A7                     mb_dir =0;   //recieve
	CBI  0x12,4
; 0000 03A8                     mbreset();
	RCALL _mbreset
; 0000 03A9                     break;
	RJMP _0x23
; 0000 03AA             default: error_code = mbillegalfunction;
_0x59:
	__GETWRN 20,21,1
; 0000 03AB //                    mbreset();
; 0000 03AC                     break;
; 0000 03AD 
; 0000 03AE             }
_0x23:
; 0000 03AF //        error handling;
; 0000 03B0         if (error_code !=0)
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x5A
; 0000 03B1             {
; 0000 03B2             //todo : error handling code here
; 0000 03B3                 mb_dir =1;
	SBI  0x12,4
; 0000 03B4                 mbtransmit_data[0] = mbreceived_data[0];    //slave id
	LDS  R30,_mbreceived_data
	STD  Y+12,R30
; 0000 03B5                 mbtransmit_data[1] = mbreceived_data[1] | 0x80;     //set highest bit to indicate exception
	__GETB1MN _mbreceived_data,1
	ORI  R30,0x80
	STD  Y+13,R30
; 0000 03B6                 mbtransmit_data[2] = error_code;        //error code
	MOVW R30,R28
	ADIW R30,14
	ST   Z,R20
; 0000 03B7                     i= CRC16(mbtransmit_data,3);    // CRC
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _CRC16
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 03B8                     mbtransmit_data[3] = i%256;
	LDD  R30,Y+10
	STD  Y+15,R30
; 0000 03B9                     mbtransmit_data[4]=i/256;
	LDD  R30,Y+11
	STD  Y+16,R30
; 0000 03BA                     #asm("cli")
	cli
; 0000 03BB 
; 0000 03BC //                    mb_dir =0;//set to transmit data
; 0000 03BD                     for (i=0;i<5;i++)
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x5E:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,5
	BRSH _0x5F
; 0000 03BE                         {
; 0000 03BF                         putchar(mbtransmit_data[i]);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	MOVW R26,R28
	ADIW R26,12
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 03C0                         }
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x5E
_0x5F:
; 0000 03C1 
; 0000 03C2 //                     mbreset();
; 0000 03C3                     #asm("sei")
	sei
; 0000 03C4                     delay_ms(50);      //wait till all data transmitted need time to transmit max 36 bytes @9600
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 03C5                     mb_dir =0;   //recieve
	CBI  0x12,4
; 0000 03C6                     mbreset();
	RCALL _mbreset
; 0000 03C7 
; 0000 03C8 
; 0000 03C9             }
; 0000 03CA 
; 0000 03CB 
; 0000 03CC 
; 0000 03CD }
_0x5A:
	CALL __LOADLOCR6
	ADIW R28,52
	RET
; .FEND
;
;
;
;
;
;
;
;
;
;
;
;
;////////////////////////////////////////////////////////////
;
;
;
;/* table for the user defined character
;   arrow that points to the top right corner */
;
;
;
;flash char char0[8]={
;0b0001110,
;0b0010001,
;0b0010001,
;0b0001110,
;0b0000000,
;0b0000000,
;0b0000000,
;0b0000000};
;
;void backtrack(void);
;
;
;
;
;/* function used to define user characters */
;void define_char(char flash *pc,char char_code)
; 0000 03F4 {
_define_char:
; .FSTART _define_char
; 0000 03F5 char i,a;
; 0000 03F6 a=(char_code<<3) | 0x40;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 03F7 for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x63:
	CPI  R17,8
	BRSH _0x64
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	CALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x63
_0x64:
; 0000 03F8 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x212000F
; .FEND
;
;
;
;
;
;
;
;//void control_buck_off(void)
;//{
;//TCCR1A &= 0x3f;         // stop PWM outpu
;//shutdown = 0;
;//}
;
;//void control_buck_on(void)
;//{
;//shutdown =1;
;//delay_ms(2);
;//TCCR1A |= 0x80;         // turn PWM on.
;//}
;//////*********
;
;float fnday(long y,long m,long d,float h)
; 0000 040F             {
_fnday:
; .FSTART _fnday
; 0000 0410             long int luku = -7 *(y+(m+9)/12)/4 + 275*m/9 + d;
; 0000 0411             luku+=(long int) y*367;
	CALL __PUTPARD2
	SBIW R28,4
;	y -> Y+16
;	m -> Y+12
;	d -> Y+8
;	h -> Y+4
;	luku -> Y+0
	__GETD2S 12
	__ADDD2N 9
	__GETD1N 0xC
	CALL __DIVD21
	__GETD2S 16
	CALL __ADDD12
	__GETD2N 0xFFFFFFF9
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4
	CALL __DIVD21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 12
	__GETD2N 0x113
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x9
	CALL __DIVD21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	__GETD2S 8
	CALL __ADDD12
	CALL __PUTD1S0
	__GETD1S 16
	__GETD2N 0x16F
	CALL __MULD12
	CALL __GETD2S0
	CALL __ADDD12
	CALL __PUTD1S0
; 0000 0412             return (float)luku-730531.5 + h/24.0;
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x49325A38
	CALL __SWAPD12
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 4
	__GETD1N 0x41C00000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	ADIW R28,20
	RET
; 0000 0413             }
; .FEND
;
;float fnrange(float x)
; 0000 0416             {
_fnrange:
; .FSTART _fnrange
; 0000 0417             float b = 0.5 * x / pi;
; 0000 0418             float a = 2.0 * pi * (b - (long) b);
; 0000 0419             if (a<0) a = 2.0 * pi+a;
	CALL __PUTPARD2
	SBIW R28,8
;	x -> Y+8
;	b -> Y+4
;	a -> Y+0
	__GETD1S 8
	__GETD2N 0x3F000000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	CALL __DIVF21
	__PUTD1S 4
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	__GETD2N 0x40000000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 4
	CALL __CFD1
	__GETD2S 4
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	CALL __PUTD1S0
	LDD  R26,Y+3
	TST  R26
	BRPL _0x65
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	__GETD2N 0x40000000
	CALL __MULF12
	CALL __GETD2S0
	CALL __ADDF12
	CALL __PUTD1S0
; 0000 041A             return a;
_0x65:
	CALL __GETD1S0
	ADIW R28,12
	RET
; 0000 041B             }
; .FEND
;
;
;float f0(float lat, float declin)
; 0000 041F             {
_f0:
; .FSTART _f0
; 0000 0420             float f0,df0;
; 0000 0421             df0 = rads *(0.5*sundia + airrefr);
	CALL __PUTPARD2
	SBIW R28,8
;	lat -> Y+12
;	declin -> Y+8
;	f0 -> Y+4
;	df0 -> Y+0
	LDS  R30,_sundia
	LDS  R31,_sundia+1
	LDS  R22,_sundia+2
	LDS  R23,_sundia+3
	__GETD2N 0x3F000000
	CALL __MULF12
	LDS  R26,_airrefr
	LDS  R27,_airrefr+1
	LDS  R24,_airrefr+2
	LDS  R25,_airrefr+3
	CALL __ADDF12
	LDS  R26,_rads
	LDS  R27,_rads+1
	LDS  R24,_rads+2
	LDS  R25,_rads+3
	CALL __MULF12
	CALL __PUTD1S0
; 0000 0422             if (lat <0.0) df0 = -df0;
	LDD  R26,Y+15
	TST  R26
	BRPL _0x66
	CALL __ANEGF1
	CALL __PUTD1S0
; 0000 0423             f0 = tan(declin+df0) * tan(lat*rads);
_0x66:
	CALL __GETD1S0
	__GETD2S 8
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _tan
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2S 12
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _tan
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	__PUTD1S 4
; 0000 0424             if (f0>0.99999) f0 = 1.0;
	__GETD2S 4
	__GETD1N 0x3F7FFF58
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x67
	__GETD1N 0x3F800000
	__PUTD1S 4
; 0000 0425             f0 = asin(f0) + pi/2.0;
_0x67:
	__GETD2S 4
	CALL _asin
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_pi
	LDS  R27,_pi+1
	LDS  R24,_pi+2
	LDS  R25,_pi+3
	__GETD1N 0x40000000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__PUTD1S 4
; 0000 0426             return f0;
	ADIW R28,16
	RET
; 0000 0427             }
; .FEND
;
;
;float fnsun(float d)
; 0000 042B             {
_fnsun:
; .FSTART _fnsun
; 0000 042C             L = fnrange(280.461* rads + 0.9856474 * rads * d);
	CALL __PUTPARD2
;	d -> Y+0
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x438C3B02
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x3F7C5363
	CALL __MULF12
	CALL __GETD2S0
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _fnrange
	STS  _L,R30
	STS  _L+1,R31
	STS  _L+2,R22
	STS  _L+3,R23
; 0000 042D             g = fnrange(357.528 * rads + 0.9856003 * rads * d);
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x43B2C396
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x3F7C504D
	CALL __MULF12
	CALL __GETD2S0
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _fnrange
	STS  _g,R30
	STS  _g+1,R31
	STS  _g+2,R22
	STS  _g+3,R23
; 0000 042E 
; 0000 042F             return fnrange(L+1.915 * rads * sin(g) + 0.02 * rads * sin(2*g));
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x3FF51EB8
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_g
	LDS  R27,_g+1
	LDS  R24,_g+2
	LDS  R25,_g+3
	CALL _sin
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDS  R26,_L
	LDS  R27,_L+1
	LDS  R24,_L+2
	LDS  R25,_L+3
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x3CA3D70A
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_g
	LDS  R31,_g+1
	LDS  R22,_g+2
	LDS  R23,_g+3
	__GETD2N 0x40000000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _sin
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _fnrange
	RJMP _0x212000B
; 0000 0430             }
; .FEND
;
;void rise_set( float day,float m,float y,float h,float latit,float longit,float tzone)
; 0000 0433 {
_rise_set:
; .FSTART _rise_set
; 0000 0434 float d,lamda;
; 0000 0435 float obliq,alpha,delta,LL,equation,ha;
; 0000 0436 degs = 180.0/pi;
	CALL __PUTPARD2
	SBIW R28,32
;	day -> Y+56
;	m -> Y+52
;	y -> Y+48
;	h -> Y+44
;	latit -> Y+40
;	longit -> Y+36
;	tzone -> Y+32
;	d -> Y+28
;	lamda -> Y+24
;	obliq -> Y+20
;	alpha -> Y+16
;	delta -> Y+12
;	LL -> Y+8
;	equation -> Y+4
;	ha -> Y+0
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	__GETD2N 0x43340000
	CALL __DIVF21
	STS  _degs,R30
	STS  _degs+1,R31
	STS  _degs+2,R22
	STS  _degs+3,R23
; 0000 0437 rads = pi/180.0;
	LDS  R26,_pi
	LDS  R27,_pi+1
	LDS  R24,_pi+2
	LDS  R25,_pi+3
	__GETD1N 0x43340000
	CALL __DIVF21
	STS  _rads,R30
	STS  _rads+1,R31
	STS  _rads+2,R22
	STS  _rads+3,R23
; 0000 0438 h=12;
	__GETD1N 0x41400000
	__PUTD1S 44
; 0000 0439 d= fnday (y,m,day,h);
	__GETD1S 48
	CALL __CFD1
	CALL __PUTPARD1
	__GETD1S 56
	CALL __CFD1
	CALL __PUTPARD1
	__GETD1SX 64
	CALL __CFD1
	CALL __PUTPARD1
	__GETD2S 56
	RCALL _fnday
	__PUTD1S 28
; 0000 043A lamda = fnsun(d);
	__GETD2S 28
	RCALL _fnsun
	__PUTD1S 24
; 0000 043B obliq = 23.439 * rads - 0.0000004 * rads *d;
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x41BB8312
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_rads
	LDS  R31,_rads+1
	LDS  R22,_rads+2
	LDS  R23,_rads+3
	__GETD2N 0x34D6BF95
	CALL __MULF12
	__GETD2S 28
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 20
; 0000 043C alpha =atan2(cos(obliq) * sin(lamda),cos(lamda));
	__GETD2S 20
	CALL _cos
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 24
	CALL _sin
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	CALL __PUTPARD1
	__GETD2S 28
	CALL _cos
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan2
	__PUTD1S 16
; 0000 043D delta = asin(sin(obliq) * sin(lamda));
	__GETD2S 20
	CALL _sin
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 24
	CALL _sin
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _asin
	__PUTD1S 12
; 0000 043E 
; 0000 043F LL = L-alpha;
	__GETD2S 16
	LDS  R30,_L
	LDS  R31,_L+1
	LDS  R22,_L+2
	LDS  R23,_L+3
	CALL __SUBF12
	__PUTD1S 8
; 0000 0440 if (L<pi) LL+= 2.0 * pi;
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	LDS  R26,_L
	LDS  R27,_L+1
	LDS  R24,_L+2
	LDS  R25,_L+3
	CALL __CMPF12
	BRSH _0x68
	__GETD2N 0x40000000
	CALL __MULF12
	__GETD2S 8
	CALL __ADDF12
	__PUTD1S 8
; 0000 0441 equation = 1440.0 * (1.0 - LL/pi/2.0);
_0x68:
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	__GETD2S 8
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	CALL __DIVF21
	__GETD2N 0x3F800000
	CALL __SWAPD12
	CALL __SUBF12
	__GETD2N 0x44B40000
	CALL __MULF12
	__PUTD1S 4
; 0000 0442 ha = f0(latit,delta);
	__GETD1S 40
	CALL __PUTPARD1
	__GETD2S 16
	RCALL _f0
	CALL __PUTD1S0
; 0000 0443 riset = 12.0 - 12.0 * ha/pi +tzone - longit/15.0 +equation/60.0;
	__GETD2N 0x41400000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	CALL __DIVF21
	__GETD2N 0x41400000
	CALL __SWAPD12
	CALL __SUBF12
	__GETD2S 32
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 36
	__GETD1N 0x41700000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SWAPD12
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 4
	__GETD1N 0x42700000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _riset,R30
	STS  _riset+1,R31
	STS  _riset+2,R22
	STS  _riset+3,R23
; 0000 0444 settm = 12.0 + 12.0 * ha/pi +tzone - longit/15.0 + equation/60.0;
	CALL __GETD1S0
	__GETD2N 0x41400000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	CALL __DIVF21
	__GETD2N 0x41400000
	CALL __ADDF12
	__GETD2S 32
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 36
	__GETD1N 0x41700000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SWAPD12
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 4
	__GETD1N 0x42700000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _settm,R30
	STS  _settm+1,R31
	STS  _settm+2,R22
	STS  _settm+3,R23
; 0000 0445 if (riset > 24.0) riset =riset -24.0;
	LDS  R26,_riset
	LDS  R27,_riset+1
	LDS  R24,_riset+2
	LDS  R25,_riset+3
	__GETD1N 0x41C00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x69
	LDS  R30,_riset
	LDS  R31,_riset+1
	LDS  R22,_riset+2
	LDS  R23,_riset+3
	__GETD2N 0x41C00000
	CALL __SUBF12
	STS  _riset,R30
	STS  _riset+1,R31
	STS  _riset+2,R22
	STS  _riset+3,R23
; 0000 0446 if (settm > 24.0) settm =settm -24.0;
_0x69:
	LDS  R26,_settm
	LDS  R27,_settm+1
	LDS  R24,_settm+2
	LDS  R25,_settm+3
	__GETD1N 0x41C00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x6A
	LDS  R30,_settm
	LDS  R31,_settm+1
	LDS  R22,_settm+2
	LDS  R23,_settm+3
	__GETD2N 0x41C00000
	CALL __SUBF12
	STS  _settm,R30
	STS  _settm+1,R31
	STS  _settm+2,R22
	STS  _settm+3,R23
; 0000 0447 sunrise_min = riset * 60;       //rise time in minutes
_0x6A:
	LDS  R26,_riset
	LDS  R27,_riset+1
	LDS  R24,_riset+2
	LDS  R25,_riset+3
	__GETD1N 0x42700000
	CALL __MULF12
	STS  _sunrise_min,R30
	STS  _sunrise_min+1,R31
	STS  _sunrise_min+2,R22
	STS  _sunrise_min+3,R23
; 0000 0448 sunset_min = settm * 60;        //set time in minutes
	LDS  R26,_settm
	LDS  R27,_settm+1
	LDS  R24,_settm+2
	LDS  R25,_settm+3
	__GETD1N 0x42700000
	CALL __MULF12
	STS  _sunset_min,R30
	STS  _sunset_min+1,R31
	STS  _sunset_min+2,R22
	STS  _sunset_min+3,R23
; 0000 0449 daytime = sunset_min - sunrise_min ;   //day time in minutes
	LDS  R26,_sunrise_min
	LDS  R27,_sunrise_min+1
	LDS  R24,_sunrise_min+2
	LDS  R25,_sunrise_min+3
	CALL __SUBF12
	STS  _daytime,R30
	STS  _daytime+1,R31
	STS  _daytime+2,R22
	STS  _daytime+3,R23
; 0000 044A }
	ADIW R28,60
	RET
; .FEND
;
;/////*********
;
;
;//void print_realtime(void);
;
;void clear_to_default()
; 0000 0452 {
_clear_to_default:
; .FSTART _clear_to_default
; 0000 0453 if (mode!=0)
	LDS  R30,_mode
	LDS  R31,_mode+1
	SBIW R30,0
	BREQ _0x6B
; 0000 0454     {
; 0000 0455                 mode1_count =0;
	LDI  R30,LOW(0)
	STS  _mode1_count,R30
	STS  _mode1_count+1,R30
; 0000 0456                 mode =0;
	STS  _mode,R30
	STS  _mode+1,R30
; 0000 0457                 pgm_fl =0;
	CLT
	BLD  R4,1
; 0000 0458                 blink_fl =0;
	BLD  R4,2
; 0000 0459                 set =0;
	STS  _set,R30
	STS  _set+1,R30
; 0000 045A                 item1 =0;
	STS  _item1,R30
	STS  _item1+1,R30
; 0000 045B                 lcd_clear();
	CALL _lcd_clear
; 0000 045C                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 045D     }
; 0000 045E if (manual_fl)
_0x6B:
	SBRS R5,2
	RJMP _0x6C
; 0000 045F     {
; 0000 0460             manual_fl =0;
	CLT
	BLD  R5,2
; 0000 0461             lcd_clear();
	CALL _lcd_clear
; 0000 0462             lcd_putsf("manual mode");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0463             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0464             lcd_putsf("exiting...");
	__POINTW2FN _0x0,12
	CALL _lcd_putsf
; 0000 0465             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0466 
; 0000 0467     }
; 0000 0468 }
_0x6C:
	RET
; .FEND
;
;int to_minute(char hr,char min)
; 0000 046B {
_to_minute:
; .FSTART _to_minute
; 0000 046C return (hr*60 + min);
	ST   -Y,R26
;	hr -> Y+1
;	min -> Y+0
	LDD  R26,Y+1
	LDI  R30,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x212000C
; 0000 046D }
; .FEND
;
;
;
;void put_message(long int a)
; 0000 0472 {
_put_message:
; .FSTART _put_message
; 0000 0473 char b[5];
; 0000 0474 if (a <0)
	CALL __PUTPARD2
	SBIW R28,5
;	a -> Y+5
;	b -> Y+0
	LDD  R26,Y+8
	TST  R26
	BRPL _0x6D
; 0000 0475 {
; 0000 0476 lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 0477 a = -a;
	__GETD1S 5
	CALL __ANEGD1
	__PUTD1S 5
; 0000 0478 }
; 0000 0479 else
	RJMP _0x6E
_0x6D:
; 0000 047A {
; 0000 047B lcd_putchar(' ');
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 047C }
_0x6E:
; 0000 047D b[0] = a % 10 + 48;
	__GETD2S 5
	__GETD1N 0xA
	CALL __MODD21
	SUBI R30,-LOW(48)
	ST   Y,R30
; 0000 047E a = a/10;
	__GETD2S 5
	__GETD1N 0xA
	CALL __DIVD21
	__PUTD1S 5
; 0000 047F b[1] = a % 10 + 48;
	__GETD2S 5
	__GETD1N 0xA
	CALL __MODD21
	SUBI R30,-LOW(48)
	STD  Y+1,R30
; 0000 0480 a = a/10;
	__GETD2S 5
	__GETD1N 0xA
	CALL __DIVD21
	__PUTD1S 5
; 0000 0481 b[2] = a % 10 + 48;
	__GETD2S 5
	__GETD1N 0xA
	CALL __MODD21
	SUBI R30,-LOW(48)
	STD  Y+2,R30
; 0000 0482 a = a/10;
	__GETD2S 5
	__GETD1N 0xA
	CALL __DIVD21
	__PUTD1S 5
; 0000 0483 b[3] = a % 10 + 48;
	__GETD2S 5
	__GETD1N 0xA
	CALL __MODD21
	SUBI R30,-LOW(48)
	STD  Y+3,R30
; 0000 0484 a = a/10;
	__GETD2S 5
	__GETD1N 0xA
	CALL __DIVD21
	__PUTD1S 5
; 0000 0485 b[4] = a + 48;
	LDD  R30,Y+5
	SUBI R30,-LOW(48)
	STD  Y+4,R30
; 0000 0486 lcd_putchar(b[4]);
	LDD  R26,Y+4
	CALL _lcd_putchar
; 0000 0487 lcd_putchar(b[3]);
	LDD  R26,Y+3
	CALL _lcd_putchar
; 0000 0488 lcd_putchar(b[2]);
	LDD  R26,Y+2
	CALL _lcd_putchar
; 0000 0489 lcd_putchar(b[1]);
	LDD  R26,Y+1
	CALL _lcd_putchar
; 0000 048A lcd_putchar(b[0]);
	LD   R26,Y
	CALL _lcd_putchar
; 0000 048B 
; 0000 048C 
; 0000 048D }
	ADIW R28,9
	RET
; .FEND
;
;void put_message2(unsigned char a)
; 0000 0490 {
_put_message2:
; .FSTART _put_message2
; 0000 0491 char b[2];
; 0000 0492 b[0] = a % 10 + 48;
	ST   -Y,R26
	SBIW R28,2
;	a -> Y+2
;	b -> Y+0
	LDD  R26,Y+2
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   Y,R30
; 0000 0493 a = a/10;
	LDD  R26,Y+2
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+2,R30
; 0000 0494 b[1] = a + 48;
	SUBI R30,-LOW(48)
	STD  Y+1,R30
; 0000 0495 lcd_putchar(b[1]);
	LDD  R26,Y+1
	CALL _lcd_putchar
; 0000 0496 lcd_putchar(b[0]);
	LD   R26,Y
	CALL _lcd_putchar
; 0000 0497 }
	RJMP _0x212000D
; .FEND
;
;void put_message3(unsigned int a)
; 0000 049A {
_put_message3:
; .FSTART _put_message3
; 0000 049B char b[3];
; 0000 049C b[0] = (a %10) + 48;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
;	a -> Y+3
;	b -> Y+0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	ST   Y,R30
; 0000 049D a = a/10;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 049E b[1] = (a %10) + 48;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	STD  Y+1,R30
; 0000 049F a = a/10;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 04A0 b[2] = a + 48;
	LDD  R30,Y+3
	SUBI R30,-LOW(48)
	STD  Y+2,R30
; 0000 04A1 lcd_putchar(b[2]);
	LDD  R26,Y+2
	CALL _lcd_putchar
; 0000 04A2 lcd_putchar(b[1]);
	LDD  R26,Y+1
	CALL _lcd_putchar
; 0000 04A3 lcd_putchar(b[0]);
	LD   R26,Y
	CALL _lcd_putchar
; 0000 04A4 }
_0x212000F:
	ADIW R28,5
	RET
; .FEND
;
;void blink_control(void)
; 0000 04A7 {
_blink_control:
; .FSTART _blink_control
; 0000 04A8 if (blink_fl)
	SBRS R4,2
	RJMP _0x6F
; 0000 04A9 {
; 0000 04AA  blink_count++;
	LDI  R26,LOW(_blink_count)
	LDI  R27,HIGH(_blink_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 04AB  if (blink_count >=200) blink_count =0;
	LDS  R26,_blink_count
	LDS  R27,_blink_count+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0x70
	LDI  R30,LOW(0)
	STS  _blink_count,R30
	STS  _blink_count+1,R30
; 0000 04AC 
; 0000 04AD  if (blink_count >=150)
_0x70:
	LDS  R26,_blink_count
	LDS  R27,_blink_count+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	BRLO _0x71
; 0000 04AE  {
; 0000 04AF  lcd_gotoxy(blink_locx,blink_locy);
	ST   -Y,R12
	LDS  R26,_blink_locy
	CALL _lcd_gotoxy
; 0000 04B0  lcd_putsf("  ");
	__POINTW2FN _0x0,23
	CALL _lcd_putsf
; 0000 04B1  }
; 0000 04B2  else
	RJMP _0x72
_0x71:
; 0000 04B3  {
; 0000 04B4  lcd_gotoxy(blink_locx,blink_locy);
	ST   -Y,R12
	LDS  R26,_blink_locy
	CALL _lcd_gotoxy
; 0000 04B5  put_message2(blink_data);
	LDS  R26,_blink_data
	RCALL _put_message2
; 0000 04B6  }
_0x72:
; 0000 04B7 
; 0000 04B8 
; 0000 04B9 
; 0000 04BA  }
; 0000 04BB  }
_0x6F:
	RET
; .FEND
;
;void display_time(void)
; 0000 04BE {
_display_time:
; .FSTART _display_time
; 0000 04BF       put_message2(hour);
	MOV  R26,R7
	RCALL _put_message2
; 0000 04C0       lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 04C1       put_message2(minute);
	MOV  R26,R6
	RCALL _put_message2
; 0000 04C2       lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 04C3       put_message2(second);
	MOV  R26,R9
	RJMP _0x212000E
; 0000 04C4 }
; .FEND
;
;void display_latlong(signed int l)
; 0000 04C7 {
_display_latlong:
; .FSTART _display_latlong
; 0000 04C8 unsigned int m;
; 0000 04C9 if (l<0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	l -> Y+2
;	m -> R16,R17
	LDD  R26,Y+3
	TST  R26
	BRPL _0x73
; 0000 04CA lcd_putchar('-');
	LDI  R26,LOW(45)
	RJMP _0x27F
; 0000 04CB else
_0x73:
; 0000 04CC lcd_putchar('+');
	LDI  R26,LOW(43)
_0x27F:
	CALL _lcd_putchar
; 0000 04CD m = abs(l);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _abs
	MOVW R16,R30
; 0000 04CE put_message3(m/100);
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	RCALL _put_message3
; 0000 04CF lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0000 04D0 put_message2(m%100);
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOV  R26,R30
	RCALL _put_message2
; 0000 04D1 }
	RJMP _0x212000A
; .FEND
;
;void display_modbus(signed int l)
; 0000 04D4 {
_display_modbus:
; .FSTART _display_modbus
; 0000 04D5 unsigned int m;
; 0000 04D6 lcd_putchar(' ');
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	l -> Y+2
;	m -> R16,R17
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 04D7 m = abs(l);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _abs
	MOVW R16,R30
; 0000 04D8 put_message2(m/100);
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R26,R30
	RCALL _put_message2
; 0000 04D9 put_message2(m%100);
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOV  R26,R30
	RCALL _put_message2
; 0000 04DA }
	RJMP _0x212000A
; .FEND
;
;
;
;/*
;void display_time2(int t)
;{
;    put_message2(t/100);
;    lcd_putchar(':');
;    put_message2((t%100)*6/10);
;}
;*/
;
;void display_date(void)
; 0000 04E8 {
_display_date:
; .FSTART _display_date
; 0000 04E9       put_message2(day);
	MOV  R26,R11
	RCALL _put_message2
; 0000 04EA       lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0000 04EB       put_message2(month);
	MOV  R26,R10
	RCALL _put_message2
; 0000 04EC       lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0000 04ED       lcd_putsf("20");
	__POINTW2FN _0x0,26
	CALL _lcd_putsf
; 0000 04EE       put_message2(year);
	MOV  R26,R13
_0x212000E:
	RCALL _put_message2
; 0000 04EF }
	RET
; .FEND
;
;/*
;void display_day(int data)
;{
;char a;
;a = data /100;
;put_message2(a);
;lcd_putsf(":");
;a = data%100;
;put_message2(a);
;}
;*/
;
;void display_day2(int data)
; 0000 04FE {
_display_day2:
; .FSTART _display_day2
; 0000 04FF char a;
; 0000 0500 a = data /60;
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+1
;	a -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21
	MOV  R17,R30
; 0000 0501 put_message2(a);
	MOV  R26,R17
	RCALL _put_message2
; 0000 0502 lcd_putsf(":");
	__POINTW2FN _0x0,29
	CALL _lcd_putsf
; 0000 0503 a = data%60;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	MOV  R17,R30
; 0000 0504 put_message2(a);
	MOV  R26,R17
	RCALL _put_message2
; 0000 0505 }
	LDD  R17,Y+0
_0x212000D:
	ADIW R28,3
	RET
; .FEND
;
;void display_analog(int a)
; 0000 0508 {
_display_analog:
; .FSTART _display_analog
; 0000 0509     put_message2(a/100);
	ST   -Y,R27
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOV  R26,R30
	RCALL _put_message2
; 0000 050A     lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0000 050B     put_message2(a%100);
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R26,R30
	RCALL _put_message2
; 0000 050C }
_0x212000C:
	ADIW R28,2
	RET
; .FEND
;
;void display_angle(int a)
; 0000 050F {
_display_angle:
; .FSTART _display_angle
; 0000 0510 char x,y;
; 0000 0511 if (a<0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	a -> Y+2
;	x -> R17
;	y -> R16
	LDD  R26,Y+3
	TST  R26
	BRPL _0x75
; 0000 0512 {
; 0000 0513 a = -a;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ANEGW1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0514 lcd_putchar('-');
	LDI  R26,LOW(45)
	RJMP _0x280
; 0000 0515 }
; 0000 0516 else
_0x75:
; 0000 0517 {
; 0000 0518 lcd_putchar(' ');
	LDI  R26,LOW(32)
_0x280:
	CALL _lcd_putchar
; 0000 0519 }
; 0000 051A y = a/10;
	RJMP _0x2120009
; 0000 051B x = y%100;
; 0000 051C y = y/100;
; 0000 051D lcd_putchar(y+48);
; 0000 051E put_message2(x);
; 0000 051F 
; 0000 0520 lcd_putchar('.');
; 0000 0521 x = a%10;
; 0000 0522 
; 0000 0523 lcd_putchar(x+48);
; 0000 0524 lcd_putchar(0);
; 0000 0525 }
; .FEND
;
;void display_angle1(int a)
; 0000 0528 {
_display_angle1:
; .FSTART _display_angle1
; 0000 0529 char x,y;
; 0000 052A if (a<0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	a -> Y+2
;	x -> R17
;	y -> R16
	LDD  R26,Y+3
	TST  R26
	BRPL _0x77
; 0000 052B {
; 0000 052C a = -a;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ANEGW1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 052D lcd_putchar('-');
	LDI  R26,LOW(45)
	RJMP _0x281
; 0000 052E }
; 0000 052F else
_0x77:
; 0000 0530 {
; 0000 0531 lcd_putchar(' ');
	LDI  R26,LOW(32)
_0x281:
	CALL _lcd_putchar
; 0000 0532 }
; 0000 0533 y = a/10;
_0x2120009:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R16,R30
; 0000 0534 x = y%100;
	MOV  R26,R16
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R17,R30
; 0000 0535 y = y/100;
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOV  R16,R30
; 0000 0536 lcd_putchar(y+48);
	MOV  R26,R16
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
; 0000 0537 put_message2(x);
	MOV  R26,R17
	RCALL _put_message2
; 0000 0538 
; 0000 0539 lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
; 0000 053A x = a%10;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R17,R30
; 0000 053B 
; 0000 053C lcd_putchar(x+48);
	MOV  R26,R17
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
; 0000 053D lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 053E }
_0x212000A:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x212000B:
	ADIW R28,4
	RET
; .FEND
;
;
;void check_mode(void)
; 0000 0542 {
_check_mode:
; .FSTART _check_mode
; 0000 0543 //key1 =1;
; 0000 0544 if (!key1)
	SBIC 0x19,0
	RJMP _0x79
; 0000 0545     {
; 0000 0546     bright_cnt =0;
	LDI  R30,LOW(0)
	STS  _bright_cnt,R30
	STS  _bright_cnt+1,R30
; 0000 0547     program_timeout=0;
	STS  _program_timeout,R30
	STS  _program_timeout+1,R30
	STS  _program_timeout+2,R30
	STS  _program_timeout+3,R30
; 0000 0548         mode1_count++;
	LDI  R26,LOW(_mode1_count)
	LDI  R27,HIGH(_mode1_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0549         if (mode1_count >= 1000)
	LDS  R26,_mode1_count
	LDS  R27,_mode1_count+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0x7A
; 0000 054A         {
; 0000 054B             if (mode == 0)
	LDS  R30,_mode
	LDS  R31,_mode+1
	SBIW R30,0
	BRNE _0x7B
; 0000 054C             {
; 0000 054D                 mode1_count=0;
	LDI  R30,LOW(0)
	STS  _mode1_count,R30
	STS  _mode1_count+1,R30
; 0000 054E                 mode =1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _mode,R30
	STS  _mode+1,R31
; 0000 054F                 pgm_fl =1;
	SET
	BLD  R4,1
; 0000 0550 //                lcd_gotoxy(0,0);
; 0000 0551                 lcd_clear();
	CALL _lcd_clear
; 0000 0552                 lcd_putsf("set the time");
	__POINTW2FN _0x0,31
	CALL _lcd_putsf
; 0000 0553                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0554                 display_time();
	RCALL _display_time
; 0000 0555                 blink_data = hour;
	STS  _blink_data,R7
; 0000 0556                 blink_locx =0;
	CLR  R12
; 0000 0557                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 0558                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 0559                 set =0;
	LDI  R30,LOW(0)
	STS  _set,R30
	STS  _set+1,R30
; 0000 055A                 item1 =0;
	STS  _item1,R30
	STS  _item1+1,R30
; 0000 055B             }
; 0000 055C             else
	RJMP _0x7C
_0x7B:
; 0000 055D             {
; 0000 055E                 mode1_count =0;
	LDI  R30,LOW(0)
	STS  _mode1_count,R30
	STS  _mode1_count+1,R30
; 0000 055F                 mode =0;
	STS  _mode,R30
	STS  _mode+1,R30
; 0000 0560                 pgm_fl =0;
	CLT
	BLD  R4,1
; 0000 0561                 blink_fl =0;
	BLD  R4,2
; 0000 0562                 set =0;
	STS  _set,R30
	STS  _set+1,R30
; 0000 0563                 item1 =0;
	STS  _item1,R30
	STS  _item1+1,R30
; 0000 0564                 lcd_clear();
	CALL _lcd_clear
; 0000 0565                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0566             }
_0x7C:
; 0000 0567         }
; 0000 0568     }
_0x7A:
; 0000 0569 else
	RJMP _0x7D
_0x79:
; 0000 056A     mode1_count =0;
	LDI  R30,LOW(0)
	STS  _mode1_count,R30
	STS  _mode1_count+1,R30
; 0000 056B 
; 0000 056C //////manual mode key check
; 0000 056D if (!key4)
_0x7D:
	SBIC 0x19,3
	RJMP _0x7E
; 0000 056E {
; 0000 056F manual_cnt++;
	LDI  R26,LOW(_manual_cnt)
	LDI  R27,HIGH(_manual_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0570 if (manual_cnt > 2000)
	LDS  R26,_manual_cnt
	LDS  R27,_manual_cnt+1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x7F
; 0000 0571         {
; 0000 0572         manual_cnt =0;
	LDI  R30,LOW(0)
	STS  _manual_cnt,R30
	STS  _manual_cnt+1,R30
; 0000 0573         if (!manual_fl)
	SBRC R5,2
	RJMP _0x80
; 0000 0574             {
; 0000 0575             manual_fl =1;
	SET
	BLD  R5,2
; 0000 0576             lcd_clear();
	CALL _lcd_clear
; 0000 0577             lcd_putsf("manual mode");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0578             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0579             lcd_putsf("entering....");
	__POINTW2FN _0x0,44
	RJMP _0x282
; 0000 057A             delay_ms(2000);
; 0000 057B             }
; 0000 057C         else
_0x80:
; 0000 057D             {
; 0000 057E             manual_fl =0;
	CLT
	BLD  R5,2
; 0000 057F             lcd_clear();
	CALL _lcd_clear
; 0000 0580             lcd_putsf("manual mode");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0581             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0582             lcd_putsf("exiting...");
	__POINTW2FN _0x0,12
_0x282:
	CALL _lcd_putsf
; 0000 0583             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0584             }
; 0000 0585 
; 0000 0586         }
; 0000 0587 
; 0000 0588 }
_0x7F:
; 0000 0589 else
	RJMP _0x82
_0x7E:
; 0000 058A {
; 0000 058B manual_cnt =0;
	LDI  R30,LOW(0)
	STS  _manual_cnt,R30
	STS  _manual_cnt+1,R30
; 0000 058C }
_0x82:
; 0000 058D 
; 0000 058E 
; 0000 058F 
; 0000 0590 //////////////////////////
; 0000 0591 
; 0000 0592 
; 0000 0593 
; 0000 0594 }
	RET
; .FEND
;
;void check_increment(void)
; 0000 0597 {
_check_increment:
; .FSTART _check_increment
; 0000 0598 if (key2_fl && pgm_fl)
	SBRS R3,1
	RJMP _0x84
	SBRC R4,1
	RJMP _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 0599 {
; 0000 059A     key2_fl =0;
	CLT
	BLD  R3,1
; 0000 059B         bright_cnt =0;
	LDI  R30,LOW(0)
	STS  _bright_cnt,R30
	STS  _bright_cnt+1,R30
; 0000 059C         program_timeout=0;
	STS  _program_timeout,R30
	STS  _program_timeout+1,R30
	STS  _program_timeout+2,R30
	STS  _program_timeout+3,R30
; 0000 059D 
; 0000 059E     if (mode ==1)
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0x86
; 0000 059F     {
; 0000 05A0 //    while(1);
; 0000 05A1     switch (item1)
	LDS  R30,_item1
	LDS  R31,_item1+1
; 0000 05A2     {
; 0000 05A3         case 0: hour++;
	SBIW R30,0
	BRNE _0x8A
	INC  R7
; 0000 05A4                 if (hour > 24) hour =0;
	LDI  R30,LOW(24)
	CP   R30,R7
	BRSH _0x8B
	CLR  R7
; 0000 05A5                 break;
_0x8B:
	RJMP _0x89
; 0000 05A6         case 1: minute++;
_0x8A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8C
	INC  R6
; 0000 05A7                 if (minute > 59) minute =0;
	LDI  R30,LOW(59)
	CP   R30,R6
	BRSH _0x8D
	CLR  R6
; 0000 05A8                 break;
_0x8D:
	RJMP _0x89
; 0000 05A9         case 2: second++;
_0x8C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8E
	INC  R9
; 0000 05AA                 if (second >59) second =0;
	LDI  R30,LOW(59)
	CP   R30,R9
	BRSH _0x8F
	CLR  R9
; 0000 05AB                 break;
_0x8F:
	RJMP _0x89
; 0000 05AC         case 3: day++;
_0x8E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x90
	INC  R11
; 0000 05AD                 if (day > 31) day =1;
	LDI  R30,LOW(31)
	CP   R30,R11
	BRSH _0x91
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 05AE                 break;
_0x91:
	RJMP _0x89
; 0000 05AF         case 4: month++;
_0x90:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x92
	INC  R10
; 0000 05B0                 if (month > 12) month = 1;
	LDI  R30,LOW(12)
	CP   R30,R10
	BRSH _0x93
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 05B1                 break;
_0x93:
	RJMP _0x89
; 0000 05B2         case 5: year++;
_0x92:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x94
	INC  R13
; 0000 05B3                 if (year >99) year = 13;
	LDI  R30,LOW(99)
	CP   R30,R13
	BRSH _0x95
	LDI  R30,LOW(13)
	MOV  R13,R30
; 0000 05B4                 break;
_0x95:
	RJMP _0x89
; 0000 05B5         case 6: set_latit+=100;
_0x94:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x96
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 05B6                 if (set_latit > 9000) set_latit =9000;
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CPI  R26,LOW(0x2329)
	LDI  R30,HIGH(0x2329)
	CPC  R27,R30
	BRLT _0x97
	LDI  R30,LOW(9000)
	LDI  R31,HIGH(9000)
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 05B7                 char_latitude = blink_data = abs(set_latit)/100;
_0x97:
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 05B8                 break;
	RJMP _0x89
; 0000 05B9         case 7: set_latit+=1;
_0x96:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x98
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	ADIW R30,1
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 05BA                 if (set_latit > 9000) set_latit =9000;
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CPI  R26,LOW(0x2329)
	LDI  R30,HIGH(0x2329)
	CPC  R27,R30
	BRLT _0x99
	LDI  R30,LOW(9000)
	LDI  R31,HIGH(9000)
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 05BB                 char_latitude = blink_data = abs(set_latit)%100;
_0x99:
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 05BC                 break;
	RJMP _0x89
; 0000 05BD         case 8: set_longitude+=100;
_0x98:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x9A
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 05BE                 if (set_longitude > 18000) set_longitude = 18000;
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CPI  R26,LOW(0x4651)
	LDI  R30,HIGH(0x4651)
	CPC  R27,R30
	BRLT _0x9B
	LDI  R30,LOW(18000)
	LDI  R31,HIGH(18000)
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 05BF                 char_longitude = blink_data = (abs(set_longitude)/100)%100;
_0x9B:
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 05C0                 break;
	RJMP _0x89
; 0000 05C1         case 9: set_longitude+=1;
_0x9A:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x9C
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	ADIW R30,1
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 05C2                 if (set_longitude > 18000) set_longitude = 18000;
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CPI  R26,LOW(0x4651)
	LDI  R30,HIGH(0x4651)
	CPC  R27,R30
	BRLT _0x9D
	LDI  R30,LOW(18000)
	LDI  R31,HIGH(18000)
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 05C3                 char_longitude = blink_data = abs(set_longitude)%100;
_0x9D:
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 05C4                 break;
	RJMP _0x89
; 0000 05C5         case 10:time_interval+=5;
_0x9C:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x9E
	LDS  R30,_time_interval
	LDS  R31,_time_interval+1
	ADIW R30,5
	STS  _time_interval,R30
	STS  _time_interval+1,R31
; 0000 05C6                 if (time_interval > 90) time_interval = 5;
	LDS  R26,_time_interval
	LDS  R27,_time_interval+1
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLT _0x9F
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _time_interval,R30
	STS  _time_interval+1,R31
; 0000 05C7                 break;
_0x9F:
	RJMP _0x89
; 0000 05C8         case 11: set_timezone+=100;
_0x9E:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xA0
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 05C9                 if(set_timezone > 1200) set_timezone = 1200;
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRLT _0xA1
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 05CA                 break;
_0xA1:
	RJMP _0x89
; 0000 05CB         case 12: set_timezone+=25;
_0xA0:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xA2
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	ADIW R30,25
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 05CC                 if(set_timezone > 1200) set_timezone = 1200;
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRLT _0xA3
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 05CD                 break;
_0xA3:
	RJMP _0x89
; 0000 05CE         case 13:set_width+=100;
_0xA2:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xA4
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 05CF                 if (set_width > 9999) set_width = 9900;
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLT _0xA5
	LDI  R30,LOW(9900)
	LDI  R31,HIGH(9900)
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 05D0                 break;
_0xA5:
	RJMP _0x89
; 0000 05D1         case 14:set_width+=10;
_0xA4:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xA6
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	ADIW R30,10
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 05D2                 if (set_width > 9999) set_width = 9900;
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLT _0xA7
	LDI  R30,LOW(9900)
	LDI  R31,HIGH(9900)
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 05D3                 break;
_0xA7:
	RJMP _0x89
; 0000 05D4         case 15:set_distance+=100;
_0xA6:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xA8
	LDS  R30,_set_distance
	LDS  R31,_set_distance+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 05D5                 if (set_distance > 9999) set_distance = 9900;
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLT _0xA9
	LDI  R30,LOW(9900)
	LDI  R31,HIGH(9900)
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 05D6                 break;
_0xA9:
	RJMP _0x89
; 0000 05D7         case 16:set_distance+=10;
_0xA8:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xAA
	LDS  R30,_set_distance
	LDS  R31,_set_distance+1
	ADIW R30,10
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 05D8                 if (set_distance > 9999) set_distance = 9900;
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLT _0xAB
	LDI  R30,LOW(9900)
	LDI  R31,HIGH(9900)
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 05D9                 break;
_0xAB:
	RJMP _0x89
; 0000 05DA         case 17:modbus_id+=100;
_0xAA:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xAC
	LDS  R30,_modbus_id
	LDS  R31,_modbus_id+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 05DB                 if (modbus_id > 240) modbus_id = 240;
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CPI  R26,LOW(0xF1)
	LDI  R30,HIGH(0xF1)
	CPC  R27,R30
	BRLT _0xAD
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 05DC                 break;
_0xAD:
	RJMP _0x89
; 0000 05DD         case 18:modbus_id+=1;
_0xAC:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xAE
	LDS  R30,_modbus_id
	LDS  R31,_modbus_id+1
	ADIW R30,1
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 05DE                 if (modbus_id > 240) modbus_id = 240;
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CPI  R26,LOW(0xF1)
	LDI  R30,HIGH(0xF1)
	CPC  R27,R30
	BRLT _0xAF
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 05DF                 break;
_0xAF:
	RJMP _0x89
; 0000 05E0         case 19:modbus_rate+=100;
_0xAE:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xB0
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 05E1                 if (modbus_rate > 5) modbus_rate = 5;
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	SBIW R26,6
	BRLT _0xB1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 05E2                 break;
_0xB1:
	RJMP _0x89
; 0000 05E3         case 20:modbus_rate+=1;
_0xB0:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x89
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
	ADIW R30,1
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 05E4                 if (modbus_rate > 5) modbus_rate = 5;
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	SBIW R26,6
	BRLT _0xB3
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 05E5                 break;
_0xB3:
; 0000 05E6 
; 0000 05E7        }
_0x89:
; 0000 05E8 
; 0000 05E9     }
; 0000 05EA 
; 0000 05EB 
; 0000 05EC }
_0x86:
; 0000 05ED }
_0x83:
	RET
; .FEND
;
;void check_decrement(void)
; 0000 05F0 {
_check_decrement:
; .FSTART _check_decrement
; 0000 05F1 if (key3_fl && pgm_fl)
	SBRS R3,2
	RJMP _0xB5
	SBRC R4,1
	RJMP _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
; 0000 05F2 {
; 0000 05F3     bright_cnt =0;
	LDI  R30,LOW(0)
	STS  _bright_cnt,R30
	STS  _bright_cnt+1,R30
; 0000 05F4     program_timeout=0;
	STS  _program_timeout,R30
	STS  _program_timeout+1,R30
	STS  _program_timeout+2,R30
	STS  _program_timeout+3,R30
; 0000 05F5     key3_fl =0;
	CLT
	BLD  R3,2
; 0000 05F6     if (mode ==1)
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xB7
; 0000 05F7     {
; 0000 05F8     switch (item1)
	LDS  R30,_item1
	LDS  R31,_item1+1
; 0000 05F9     {
; 0000 05FA         case 0: hour--;
	SBIW R30,0
	BRNE _0xBB
	DEC  R7
; 0000 05FB                 if (hour > 23) hour =23;
	LDI  R30,LOW(23)
	CP   R30,R7
	BRSH _0xBC
	MOV  R7,R30
; 0000 05FC                 break;
_0xBC:
	RJMP _0xBA
; 0000 05FD         case 1: minute--;
_0xBB:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBD
	DEC  R6
; 0000 05FE                 if (minute > 59) minute =59;
	LDI  R30,LOW(59)
	CP   R30,R6
	BRSH _0xBE
	MOV  R6,R30
; 0000 05FF                 break;
_0xBE:
	RJMP _0xBA
; 0000 0600         case 2: second--;
_0xBD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBF
	DEC  R9
; 0000 0601                 if (second > 59) second =59;
	LDI  R30,LOW(59)
	CP   R30,R9
	BRSH _0xC0
	MOV  R9,R30
; 0000 0602                 break;
_0xC0:
	RJMP _0xBA
; 0000 0603         case 3: day--;
_0xBF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC1
	DEC  R11
; 0000 0604                 if (day <1) day =31;
	LDI  R30,LOW(1)
	CP   R11,R30
	BRSH _0xC2
	LDI  R30,LOW(31)
	MOV  R11,R30
; 0000 0605                 break;
_0xC2:
	RJMP _0xBA
; 0000 0606         case 4: month--;
_0xC1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC3
	DEC  R10
; 0000 0607                 if (month <1) month = 12;
	LDI  R30,LOW(1)
	CP   R10,R30
	BRSH _0xC4
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 0608                 break;
_0xC4:
	RJMP _0xBA
; 0000 0609         case 5: year--;
_0xC3:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC5
	DEC  R13
; 0000 060A                 if (year >99) year = 99;
	LDI  R30,LOW(99)
	CP   R30,R13
	BRSH _0xC6
	MOV  R13,R30
; 0000 060B                 break;
_0xC6:
	RJMP _0xBA
; 0000 060C         case 6: set_latit-=100;
_0xC5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC7
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 060D                 if (set_latit <-9000) set_latit =-9000;
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CPI  R26,LOW(0xDCD8)
	LDI  R30,HIGH(0xDCD8)
	CPC  R27,R30
	BRGE _0xC8
	LDI  R30,LOW(56536)
	LDI  R31,HIGH(56536)
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 060E                 char_latitude = blink_data = abs(set_latit)/100;
_0xC8:
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 060F                 break;
	RJMP _0xBA
; 0000 0610         case 7: set_latit-=1;
_0xC7:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xC9
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	SBIW R30,1
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 0611                 if (set_latit <-9000) set_latit =-9000;
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CPI  R26,LOW(0xDCD8)
	LDI  R30,HIGH(0xDCD8)
	CPC  R27,R30
	BRGE _0xCA
	LDI  R30,LOW(56536)
	LDI  R31,HIGH(56536)
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 0612                 char_latitude = blink_data = abs(set_latit)%100;
_0xCA:
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 0613                 break;
	RJMP _0xBA
; 0000 0614         case 8: set_longitude-=100;
_0xC9:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xCB
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 0615                 if (set_longitude <-18000) set_longitude =-18000;
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CPI  R26,LOW(0xB9B0)
	LDI  R30,HIGH(0xB9B0)
	CPC  R27,R30
	BRGE _0xCC
	LDI  R30,LOW(47536)
	LDI  R31,HIGH(47536)
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 0616                 char_longitude = blink_data = (abs(set_longitude)/100)%100;
_0xCC:
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 0617                 break;
	RJMP _0xBA
; 0000 0618         case 9: set_longitude-=1;
_0xCB:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xCD
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	SBIW R30,1
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 0619                 if (set_longitude <-18000) set_longitude =-18000;
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CPI  R26,LOW(0xB9B0)
	LDI  R30,HIGH(0xB9B0)
	CPC  R27,R30
	BRGE _0xCE
	LDI  R30,LOW(47536)
	LDI  R31,HIGH(47536)
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 061A                 char_longitude = blink_data = abs(set_longitude)%100;
_0xCE:
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 061B                 break;
	RJMP _0xBA
; 0000 061C         case 10:time_interval-=5;
_0xCD:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xCF
	LDS  R30,_time_interval
	LDS  R31,_time_interval+1
	SBIW R30,5
	STS  _time_interval,R30
	STS  _time_interval+1,R31
; 0000 061D                 if(time_interval<5) time_interval =90;
	LDS  R26,_time_interval
	LDS  R27,_time_interval+1
	SBIW R26,5
	BRGE _0xD0
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _time_interval,R30
	STS  _time_interval+1,R31
; 0000 061E                 break;
_0xD0:
	RJMP _0xBA
; 0000 061F         case 11: set_timezone-=100;
_0xCF:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xD1
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 0620                 if(set_timezone < -1200) set_timezone = -1200;
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CPI  R26,LOW(0xFB50)
	LDI  R30,HIGH(0xFB50)
	CPC  R27,R30
	BRGE _0xD2
	LDI  R30,LOW(64336)
	LDI  R31,HIGH(64336)
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 0621                 break;
_0xD2:
	RJMP _0xBA
; 0000 0622         case 12: set_timezone-=25;
_0xD1:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xD3
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	SBIW R30,25
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 0623                 if(set_timezone < -1200) set_timezone = -1200;
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CPI  R26,LOW(0xFB50)
	LDI  R30,HIGH(0xFB50)
	CPC  R27,R30
	BRGE _0xD4
	LDI  R30,LOW(64336)
	LDI  R31,HIGH(64336)
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 0624                 break;
_0xD4:
	RJMP _0xBA
; 0000 0625         case 13:set_width-=100;
_0xD3:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xD5
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 0626                 if (set_width <1) set_width = 10;
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	SBIW R26,1
	BRGE _0xD6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 0627                 break;
_0xD6:
	RJMP _0xBA
; 0000 0628         case 14:set_width-=10;
_0xD5:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xD7
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	SBIW R30,10
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 0629                 if (set_width <1) set_width = 10;
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	SBIW R26,1
	BRGE _0xD8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 062A                 break;
_0xD8:
	RJMP _0xBA
; 0000 062B         case 15:set_distance-=100;
_0xD7:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xD9
	LDS  R30,_set_distance
	LDS  R31,_set_distance+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 062C                 if (set_distance <1) set_distance = 10;
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	SBIW R26,1
	BRGE _0xDA
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 062D                 break;
_0xDA:
	RJMP _0xBA
; 0000 062E         case 16:set_distance-=10;
_0xD9:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xDB
	LDS  R30,_set_distance
	LDS  R31,_set_distance+1
	SBIW R30,10
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 062F                 if (set_distance <1) set_distance = 10;
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	SBIW R26,1
	BRGE _0xDC
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 0630                 break;
_0xDC:
	RJMP _0xBA
; 0000 0631         case 17:modbus_id-=100;
_0xDB:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xDD
	LDS  R30,_modbus_id
	LDS  R31,_modbus_id+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 0632                 if (modbus_id <1) modbus_id = 1;
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	SBIW R26,1
	BRGE _0xDE
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 0633                 break;
_0xDE:
	RJMP _0xBA
; 0000 0634         case 18:modbus_id-=1;
_0xDD:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xDF
	LDS  R30,_modbus_id
	LDS  R31,_modbus_id+1
	SBIW R30,1
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 0635                 if (modbus_id <1) modbus_id = 1;
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	SBIW R26,1
	BRGE _0xE0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 0636                 break;
_0xE0:
	RJMP _0xBA
; 0000 0637         case 19:modbus_rate-=100;
_0xDF:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xE1
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 0638                 if (modbus_rate <1) modbus_rate = 1;
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	SBIW R26,1
	BRGE _0xE2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 0639                 break;
_0xE2:
	RJMP _0xBA
; 0000 063A         case 20:modbus_rate-=1;
_0xE1:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xBA
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
	SBIW R30,1
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 063B                 if (modbus_rate <1) modbus_rate = 1;
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	SBIW R26,1
	BRGE _0xE4
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 063C                 break;
_0xE4:
; 0000 063D     }
_0xBA:
; 0000 063E 
; 0000 063F     }
; 0000 0640 
; 0000 0641 
; 0000 0642 }
_0xB7:
; 0000 0643 }
_0xB4:
	RET
; .FEND
;
;void check_shift(void)
; 0000 0646 {
_check_shift:
; .FSTART _check_shift
; 0000 0647 if (key4_fl && pgm_fl)
	SBRS R3,3
	RJMP _0xE6
	SBRC R4,1
	RJMP _0xE7
_0xE6:
	RJMP _0xE5
_0xE7:
; 0000 0648 {
; 0000 0649     bright_cnt =0;
	LDI  R30,LOW(0)
	STS  _bright_cnt,R30
	STS  _bright_cnt+1,R30
; 0000 064A     program_timeout=0;
	STS  _program_timeout,R30
	STS  _program_timeout+1,R30
	STS  _program_timeout+2,R30
	STS  _program_timeout+3,R30
; 0000 064B     key4_fl =0;
	CLT
	BLD  R3,3
; 0000 064C     if (mode ==1)
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xE8
; 0000 064D     {
; 0000 064E     item1++;
	LDI  R26,LOW(_item1)
	LDI  R27,HIGH(_item1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 064F     if (set ==0 && item1>2) item1=0;
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,0
	BRNE _0xEA
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,3
	BRGE _0xEB
_0xEA:
	RJMP _0xE9
_0xEB:
	LDI  R30,LOW(0)
	STS  _item1,R30
	STS  _item1+1,R30
; 0000 0650     if (set ==1 && (item1 <3 || item1 >5)) item1 =3;
_0xE9:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,1
	BRNE _0xED
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,3
	BRLT _0xEE
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,6
	BRLT _0xED
_0xEE:
	RJMP _0xF0
_0xED:
	RJMP _0xEC
_0xF0:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0651     if (set ==2 && (item1 <6 || item1 >7)) item1 =6;
_0xEC:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,2
	BRNE _0xF2
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,6
	BRLT _0xF3
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,8
	BRLT _0xF2
_0xF3:
	RJMP _0xF5
_0xF2:
	RJMP _0xF1
_0xF5:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0652     if (set ==3 && (item1 <8 || item1 >9)) item1 =8;
_0xF1:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,3
	BRNE _0xF7
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,8
	BRLT _0xF8
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,10
	BRLT _0xF7
_0xF8:
	RJMP _0xFA
_0xF7:
	RJMP _0xF6
_0xFA:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0653     if (set ==4) item1 =10;
_0xF6:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,4
	BRNE _0xFB
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0654     if (set ==5 && (item1 <11 || item1 >12)) item1 = 11;
_0xFB:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,5
	BRNE _0xFD
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,11
	BRLT _0xFE
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,13
	BRLT _0xFD
_0xFE:
	RJMP _0x100
_0xFD:
	RJMP _0xFC
_0x100:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0655     if (set ==6 && (item1 <13 || item1 >14)) item1 = 13;
_0xFC:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,6
	BRNE _0x102
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,13
	BRLT _0x103
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,15
	BRLT _0x102
_0x103:
	RJMP _0x105
_0x102:
	RJMP _0x101
_0x105:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0656     if (set ==7 && (item1 <15 || item1 >16)) item1 = 15;
_0x101:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,7
	BRNE _0x107
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,15
	BRLT _0x108
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,17
	BRLT _0x107
_0x108:
	RJMP _0x10A
_0x107:
	RJMP _0x106
_0x10A:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0657     if (set ==8 && (item1 <17 || item1 >18)) item1 = 17;
_0x106:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,8
	BRNE _0x10C
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,17
	BRLT _0x10D
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,19
	BRLT _0x10C
_0x10D:
	RJMP _0x10F
_0x10C:
	RJMP _0x10B
_0x10F:
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0658     if (set ==9 && (item1 <20 || item1 >20)) item1 = 20;
_0x10B:
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,9
	BRNE _0x111
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,20
	BRLT _0x112
	LDS  R26,_item1
	LDS  R27,_item1+1
	SBIW R26,21
	BRLT _0x111
_0x112:
	RJMP _0x114
_0x111:
	RJMP _0x110
_0x114:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 0659 
; 0000 065A    }
_0x110:
; 0000 065B 
; 0000 065C }
_0xE8:
; 0000 065D }
_0xE5:
	RET
; .FEND
;
;void check_enter(void)
; 0000 0660 {
_check_enter:
; .FSTART _check_enter
; 0000 0661 
; 0000 0662 
; 0000 0663 
; 0000 0664 if (key1_fl && pgm_fl)
	SBRS R3,0
	RJMP _0x116
	SBRC R4,1
	RJMP _0x117
_0x116:
	RJMP _0x115
_0x117:
; 0000 0665 {
; 0000 0666     bright_cnt =0;
	LDI  R30,LOW(0)
	STS  _bright_cnt,R30
	STS  _bright_cnt+1,R30
; 0000 0667     program_timeout=0;
	STS  _program_timeout,R30
	STS  _program_timeout+1,R30
	STS  _program_timeout+2,R30
	STS  _program_timeout+3,R30
; 0000 0668     key1_fl =0;
	CLT
	BLD  R3,0
; 0000 0669     if (mode ==1)
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0x118
; 0000 066A     {
; 0000 066B     switch(set)
	LDS  R30,_set
	LDS  R31,_set+1
; 0000 066C     {
; 0000 066D     case 0: rtc_set_time(hour,minute,second);
	SBIW R30,0
	BRNE _0x11C
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	CALL _rtc_set_time
; 0000 066E             break;
	RJMP _0x11B
; 0000 066F     case 1: rtc_set_date(week,day,month,year);   // pdi is week day not used.
_0x11C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11D
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	MOV  R26,R13
	CALL _rtc_set_date
; 0000 0670             break;
	RJMP _0x11B
; 0000 0671     case 2: e_set_latit = set_latit;
_0x11D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x11E
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	LDI  R26,LOW(_e_set_latit)
	LDI  R27,HIGH(_e_set_latit)
	RJMP _0x283
; 0000 0672             break;
; 0000 0673     case 3: e_set_longitude = set_longitude;
_0x11E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x11F
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	LDI  R26,LOW(_e_set_longitude)
	LDI  R27,HIGH(_e_set_longitude)
	RJMP _0x283
; 0000 0674             break;
; 0000 0675     case 4: e_time_interval = time_interval;
_0x11F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x120
	LDS  R30,_time_interval
	LDS  R31,_time_interval+1
	LDI  R26,LOW(_e_time_interval)
	LDI  R27,HIGH(_e_time_interval)
	RJMP _0x283
; 0000 0676             break;
; 0000 0677     case 5: e_set_timezone = set_timezone;
_0x120:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x121
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	LDI  R26,LOW(_e_set_timezone)
	LDI  R27,HIGH(_e_set_timezone)
	RJMP _0x283
; 0000 0678             break;
; 0000 0679     case 6: e_set_width = set_width ;
_0x121:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x122
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	LDI  R26,LOW(_e_set_width)
	LDI  R27,HIGH(_e_set_width)
	RJMP _0x283
; 0000 067A             break;
; 0000 067B     case 7: e_set_distance = set_distance;
_0x122:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x123
	LDS  R30,_set_distance
	LDS  R31,_set_distance+1
	LDI  R26,LOW(_e_set_distance)
	LDI  R27,HIGH(_e_set_distance)
	RJMP _0x283
; 0000 067C             break;
; 0000 067D     case 8: e_modbus_id =modbus_id;
_0x123:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x124
	LDS  R30,_modbus_id
	LDS  R31,_modbus_id+1
	LDI  R26,LOW(_e_modbus_id)
	LDI  R27,HIGH(_e_modbus_id)
	RJMP _0x283
; 0000 067E             break;
; 0000 067F     case 9: e_modbus_rate = modbus_rate;
_0x124:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x11B
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
	LDI  R26,LOW(_e_modbus_rate)
	LDI  R27,HIGH(_e_modbus_rate)
_0x283:
	CALL __EEPROMWRW
; 0000 0680             break;
; 0000 0681     }
_0x11B:
; 0000 0682 
; 0000 0683     set++;
	LDI  R26,LOW(_set)
	LDI  R27,HIGH(_set)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0684     if (set>9)  set =0;
	LDS  R26,_set
	LDS  R27,_set+1
	SBIW R26,10
	BRLT _0x126
	LDI  R30,LOW(0)
	STS  _set,R30
	STS  _set+1,R30
; 0000 0685 
; 0000 0686     switch (set)
_0x126:
	LDS  R30,_set
	LDS  R31,_set+1
; 0000 0687     {
; 0000 0688     case 0:     lcd_clear();
	SBIW R30,0
	BRNE _0x12A
	CALL _lcd_clear
; 0000 0689                 lcd_putsf("Set Time");
	__POINTW2FN _0x0,57
	CALL _lcd_putsf
; 0000 068A                 rtc_get_time(&hour,&minute,&second);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL _rtc_get_time
; 0000 068B //                if (hour <0 || hour >24) rtc_err=1;         //added for rtc error
; 0000 068C                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 068D                 display_time();
	RCALL _display_time
; 0000 068E                 blink_data = hour;
	STS  _blink_data,R7
; 0000 068F                 blink_locx =0;
	CLR  R12
; 0000 0690                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 0691                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 0692                 set =0;
	LDI  R30,LOW(0)
	STS  _set,R30
	STS  _set+1,R30
; 0000 0693                 item1 =0;
	STS  _item1,R30
	STS  _item1+1,R30
; 0000 0694                 break;
	RJMP _0x129
; 0000 0695 
; 0000 0696     case 1:     lcd_clear();
_0x12A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12B
	CALL _lcd_clear
; 0000 0697                 lcd_putsf("Set Date");
	__POINTW2FN _0x0,66
	CALL _lcd_putsf
; 0000 0698                 rtc_get_date(&week,&day,&month,&year);   // pdi is weekday not used only for cvavr2.05.
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	CALL _rtc_get_date
; 0000 0699                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 069A                 display_date();
	RCALL _display_date
; 0000 069B                 blink_data = day;
	STS  _blink_data,R11
; 0000 069C                 blink_locx =0;
	CLR  R12
; 0000 069D                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 069E                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 069F                 set =1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06A0                 item1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x284
; 0000 06A1                 break;
; 0000 06A2     case 2:     lcd_clear();
_0x12B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x12C
	CALL _lcd_clear
; 0000 06A3                 lcd_putsf("Set Latitude");
	__POINTW2FN _0x0,75
	CALL _lcd_putsf
; 0000 06A4                 set_latit = e_set_latit;
	LDI  R26,LOW(_e_set_latit)
	LDI  R27,HIGH(_e_set_latit)
	CALL __EEPROMRDW
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 06A5                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06A6                 display_latlong(set_latit);
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _display_latlong
; 0000 06A7                 lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 06A8                 char_latitude = blink_data = (abs(set_latit)/100)%100 ;
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 06A9                 blink_locx =2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 06AA                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06AB                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06AC                 set =2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06AD                 item1 =6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x284
; 0000 06AE                 break;
; 0000 06AF     case 3:     lcd_clear();
_0x12C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x12D
	CALL _lcd_clear
; 0000 06B0                 lcd_putsf("Set Longitude");
	__POINTW2FN _0x0,88
	CALL _lcd_putsf
; 0000 06B1                 set_longitude = e_set_longitude;
	LDI  R26,LOW(_e_set_longitude)
	LDI  R27,HIGH(_e_set_longitude)
	CALL __EEPROMRDW
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 06B2                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06B3                 display_latlong(set_longitude);
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _display_latlong
; 0000 06B4                 lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 06B5                 char_longitude = blink_data = (abs(set_longitude)/100)%100 ;
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 06B6                 blink_locx =2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 06B7                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06B8                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06B9                 set =3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06BA                 item1 =8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x284
; 0000 06BB                 break;
; 0000 06BC     case 4:     lcd_clear();
_0x12D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x12E
	CALL _lcd_clear
; 0000 06BD                 lcd_putsf("Time Interval ");
	__POINTW2FN _0x0,102
	CALL _lcd_putsf
; 0000 06BE                 e_time_interval = time_interval;
	LDS  R30,_time_interval
	LDS  R31,_time_interval+1
	LDI  R26,LOW(_e_time_interval)
	LDI  R27,HIGH(_e_time_interval)
	CALL __EEPROMWRW
; 0000 06BF                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06C0                 put_message2(time_interval);
	LDS  R26,_time_interval
	CALL _put_message2
; 0000 06C1                 lcd_putsf(" minutes");
	__POINTW2FN _0x0,117
	CALL _lcd_putsf
; 0000 06C2                 blink_data = time_interval;
	LDS  R30,_time_interval
	STS  _blink_data,R30
; 0000 06C3                 blink_locx =0;
	CLR  R12
; 0000 06C4                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06C5                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06C6                 set =4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06C7                 item1 =10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0x284
; 0000 06C8                 break;
; 0000 06C9     case 5:     lcd_clear();
_0x12E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x12F
	CALL _lcd_clear
; 0000 06CA                 lcd_putsf("Set Timezone");
	__POINTW2FN _0x0,126
	CALL _lcd_putsf
; 0000 06CB                 set_timezone = e_set_timezone;
	LDI  R26,LOW(_e_set_timezone)
	LDI  R27,HIGH(_e_set_timezone)
	CALL __EEPROMRDW
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 06CC                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06CD                 lcd_putsf("GMT ");
	__POINTW2FN _0x0,139
	CALL _lcd_putsf
; 0000 06CE                 display_latlong(set_timezone);
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CALL _display_latlong
; 0000 06CF                 lcd_putsf("Hrs.");
	__POINTW2FN _0x0,144
	CALL _lcd_putsf
; 0000 06D0                 char_timezone = blink_data = (abs(set_timezone)/100)%100 ;
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_timezone,R30
; 0000 06D1                 blink_locx =6;
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 06D2                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06D3                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06D4                 set =5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06D5                 item1 =11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RJMP _0x284
; 0000 06D6                 break;
; 0000 06D7     case 6:     lcd_clear();
_0x12F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x130
	CALL _lcd_clear
; 0000 06D8                 lcd_putsf("Set Panel Height");
	__POINTW2FN _0x0,149
	CALL _lcd_putsf
; 0000 06D9                 set_width = e_set_width;
	LDI  R26,LOW(_e_set_width)
	LDI  R27,HIGH(_e_set_width)
	CALL __EEPROMRDW
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 06DA                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06DB                 lcd_putsf("    ");
	__POINTW2FN _0x0,166
	CALL _lcd_putsf
; 0000 06DC                 display_latlong(set_width);
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CALL _display_latlong
; 0000 06DD                 lcd_putsf("Mtrs.");
	__POINTW2FN _0x0,171
	CALL _lcd_putsf
; 0000 06DE                 char_width = blink_data = (abs(set_width)/100)%100 ;
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_width,R30
; 0000 06DF                 blink_locx =6;
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 06E0                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06E1                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06E2                 set =6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06E3                 item1 =13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP _0x284
; 0000 06E4                 break;
; 0000 06E5     case 7:     lcd_clear();
_0x130:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x131
	CALL _lcd_clear
; 0000 06E6                 lcd_putsf("Set Distance");
	__POINTW2FN _0x0,177
	CALL _lcd_putsf
; 0000 06E7                 set_distance = e_set_distance;
	LDI  R26,LOW(_e_set_distance)
	LDI  R27,HIGH(_e_set_distance)
	CALL __EEPROMRDW
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 06E8                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06E9                 lcd_putsf("    ");
	__POINTW2FN _0x0,166
	CALL _lcd_putsf
; 0000 06EA                 display_latlong(set_distance);
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CALL _display_latlong
; 0000 06EB                 lcd_putsf("Mtrs.");
	__POINTW2FN _0x0,171
	CALL _lcd_putsf
; 0000 06EC                 char_distance = blink_data = (abs(set_distance)/100)%100 ;
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_distance,R30
; 0000 06ED                 blink_locx =6;
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 06EE                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06EF                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06F0                 set =7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06F1                 item1 =15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RJMP _0x284
; 0000 06F2                 break;
; 0000 06F3    case 8:     lcd_clear();
_0x131:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x132
	CALL _lcd_clear
; 0000 06F4                 lcd_putsf("ModBus ID");
	__POINTW2FN _0x0,190
	CALL _lcd_putsf
; 0000 06F5                 modbus_id = e_modbus_id;
	LDI  R26,LOW(_e_modbus_id)
	LDI  R27,HIGH(_e_modbus_id)
	CALL __EEPROMRDW
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 06F6                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 06F7                 lcd_putsf("    ");
	__POINTW2FN _0x0,166
	CALL _lcd_putsf
; 0000 06F8                 display_modbus(modbus_id);
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CALL _display_modbus
; 0000 06F9                 lcd_putsf(" ");
	__POINTW2FN _0x0,24
	CALL _lcd_putsf
; 0000 06FA                 char_id = blink_data = (abs(modbus_id)/100)%100 ;
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_id,R30
; 0000 06FB                 blink_locx =5;
	LDI  R30,LOW(5)
	MOV  R12,R30
; 0000 06FC                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 06FD                 blink_fl =1;
	SET
	BLD  R4,2
; 0000 06FE                 set =8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _set,R30
	STS  _set+1,R31
; 0000 06FF                 item1 =17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RJMP _0x284
; 0000 0700                 break;
; 0000 0701    case 9:     lcd_clear();
_0x132:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x129
	CALL _lcd_clear
; 0000 0702                 lcd_putsf("Modbus Rate ");
	__POINTW2FN _0x0,200
	CALL _lcd_putsf
; 0000 0703                 modbus_rate = e_modbus_rate;
	LDI  R26,LOW(_e_modbus_rate)
	LDI  R27,HIGH(_e_modbus_rate)
	CALL __EEPROMRDW
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 0704                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0705                 lcd_putsf("   ");
	__POINTW2FN _0x0,167
	CALL _lcd_putsf
; 0000 0706 
; 0000 0707                 switch(modbus_rate)
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
; 0000 0708                     {
; 0000 0709                     case 1: lcd_putsf("  9600");
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x137
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
; 0000 070A                             break;
	RJMP _0x136
; 0000 070B                     case 2: lcd_putsf(" 19200");
_0x137:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x138
	__POINTW2FN _0x0,220
	CALL _lcd_putsf
; 0000 070C                             break;
	RJMP _0x136
; 0000 070D                     case 3: lcd_putsf(" 38400");
_0x138:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x139
	__POINTW2FN _0x0,227
	CALL _lcd_putsf
; 0000 070E                             break;
	RJMP _0x136
; 0000 070F                     case 4: lcd_putsf(" 57600");
_0x139:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x13A
	__POINTW2FN _0x0,234
	CALL _lcd_putsf
; 0000 0710                             break;
	RJMP _0x136
; 0000 0711                     case 5: lcd_putsf("115200");
_0x13A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x13C
	__POINTW2FN _0x0,241
	CALL _lcd_putsf
; 0000 0712                             break;
	RJMP _0x136
; 0000 0713                     default:lcd_putsf("  9600");
_0x13C:
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
; 0000 0714                             e_modbus_rate = modbus_rate =0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
	LDI  R26,LOW(_e_modbus_rate)
	LDI  R27,HIGH(_e_modbus_rate)
	CALL __EEPROMWRW
; 0000 0715                             break;
; 0000 0716                     }
_0x136:
; 0000 0717 //                display_modbus(modbus_rate);
; 0000 0718                 lcd_putsf(" Baud");
	__POINTW2FN _0x0,248
	CALL _lcd_putsf
; 0000 0719                 char_rate = blink_data = (abs(modbus_rate)/100)%100 ;
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_rate,R30
; 0000 071A                 blink_locx =7;
	LDI  R30,LOW(7)
	MOV  R12,R30
; 0000 071B                 blink_locy =1;
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 071C                 blink_fl =0;
	CLT
	BLD  R4,2
; 0000 071D                 set =9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _set,R30
	STS  _set+1,R31
; 0000 071E                 item1 =19;
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
_0x284:
	STS  _item1,R30
	STS  _item1+1,R31
; 0000 071F                 break;
; 0000 0720 
; 0000 0721         }
_0x129:
; 0000 0722 
; 0000 0723     }
; 0000 0724 
; 0000 0725 }
_0x118:
; 0000 0726 }
_0x115:
	RET
; .FEND
;
;void get_key(void)
; 0000 0729 {
_get_key:
; .FSTART _get_key
; 0000 072A if (!key1 && key1_old) key1_fl =1;
	SBIC 0x19,0
	RJMP _0x13E
	SBRC R2,0
	RJMP _0x13F
_0x13E:
	RJMP _0x13D
_0x13F:
	SET
	BLD  R3,0
; 0000 072B if (!key2 && key2_old) key2_fl =1;
_0x13D:
	SBIC 0x19,1
	RJMP _0x141
	SBRC R2,1
	RJMP _0x142
_0x141:
	RJMP _0x140
_0x142:
	SET
	BLD  R3,1
; 0000 072C if (!key3 && key3_old) key3_fl =1;
_0x140:
	SBIC 0x19,2
	RJMP _0x144
	SBRC R2,2
	RJMP _0x145
_0x144:
	RJMP _0x143
_0x145:
	SET
	BLD  R3,2
; 0000 072D if (!key4 && key4_old) key4_fl =1;
_0x143:
	SBIC 0x19,3
	RJMP _0x147
	SBRC R2,3
	RJMP _0x148
_0x147:
	RJMP _0x146
_0x148:
	SET
	BLD  R3,3
; 0000 072E if (!printkey && printkey_old) printkey_fl =1;
_0x146:
	SBIC 0x19,6
	RJMP _0x14A
	SBRC R2,4
	RJMP _0x14B
_0x14A:
	RJMP _0x149
_0x14B:
	SET
	BLD  R3,4
; 0000 072F printkey_old = printkey;
_0x149:
	CLT
	SBIC 0x19,6
	SET
	BLD  R2,4
; 0000 0730 key1_old = key1;
	CLT
	SBIC 0x19,0
	SET
	BLD  R2,0
; 0000 0731 key2_old = key2;
	CLT
	SBIC 0x19,1
	SET
	BLD  R2,1
; 0000 0732 key3_old = key3;
	CLT
	SBIC 0x19,2
	SET
	BLD  R2,2
; 0000 0733 key4_old = key4;
	CLT
	SBIC 0x19,3
	SET
	BLD  R2,3
; 0000 0734 if (!key3 && mode==0 && !manual_fl)
	SBIC 0x19,2
	RJMP _0x14D
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,0
	BRNE _0x14D
	SBRS R5,2
	RJMP _0x14E
_0x14D:
	RJMP _0x14C
_0x14E:
; 0000 0735 {
; 0000 0736 printkeycnt++;
	LDI  R26,LOW(_printkeycnt)
	LDI  R27,HIGH(_printkeycnt)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0737 if (printkeycnt >=4000)
	LDS  R26,_printkeycnt
	LDS  R27,_printkeycnt+1
	LDS  R24,_printkeycnt+2
	LDS  R25,_printkeycnt+3
	__CPD2N 0xFA0
	BRLT _0x14F
; 0000 0738             {
; 0000 0739             printkeycnt=0;
	LDI  R30,LOW(0)
	STS  _printkeycnt,R30
	STS  _printkeycnt+1,R30
	STS  _printkeycnt+2,R30
	STS  _printkeycnt+3,R30
; 0000 073A             printkey_fl =1;
	SET
	BLD  R3,4
; 0000 073B             }
; 0000 073C }
_0x14F:
; 0000 073D else
	RJMP _0x150
_0x14C:
; 0000 073E printkeycnt=0;
	LDI  R30,LOW(0)
	STS  _printkeycnt,R30
	STS  _printkeycnt+1,R30
	STS  _printkeycnt+2,R30
	STS  _printkeycnt+3,R30
; 0000 073F 
; 0000 0740 if (!key2 && !manual_fl)              //calibuser calibration mode enter
_0x150:
	SBIC 0x19,1
	RJMP _0x152
	SBRS R5,2
	RJMP _0x153
_0x152:
	RJMP _0x151
_0x153:
; 0000 0741             {
; 0000 0742             calibusercnt++;
	LDI  R26,LOW(_calibusercnt)
	LDI  R27,HIGH(_calibusercnt)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0743             if(calibusercnt >=2000)
	LDS  R26,_calibusercnt
	LDS  R27,_calibusercnt+1
	LDS  R24,_calibusercnt+2
	LDS  R25,_calibusercnt+3
	__CPD2N 0x7D0
	BRLT _0x154
; 0000 0744                         {
; 0000 0745                         calibusercnt=0;
	LDI  R30,LOW(0)
	STS  _calibusercnt,R30
	STS  _calibusercnt+1,R30
	STS  _calibusercnt+2,R30
	STS  _calibusercnt+3,R30
; 0000 0746                         calibuser=1;            //enter calibration mode for user
	SET
	BLD  R5,0
; 0000 0747                         lcd_clear();
	CALL _lcd_clear
; 0000 0748                         lcd_putsf("Calibration Mode");
	__POINTW2FN _0x0,254
	CALL _lcd_putsf
; 0000 0749                         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 074A                         lcd_putsf("entering");
	__POINTW2FN _0x0,271
	CALL _lcd_putsf
; 0000 074B                         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 074C                         }
; 0000 074D             }
_0x154:
; 0000 074E else
	RJMP _0x155
_0x151:
; 0000 074F calibusercnt=0;
	LDI  R30,LOW(0)
	STS  _calibusercnt,R30
	STS  _calibusercnt+1,R30
	STS  _calibusercnt+2,R30
	STS  _calibusercnt+3,R30
; 0000 0750 }
_0x155:
	RET
; .FEND
;
;
; void mpu6050_init(void)
; 0000 0754 {
_mpu6050_init:
; .FSTART _mpu6050_init
; 0000 0755     delay_ms(150);                                        /* Power up time >100ms */
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0756     i2c_start();
	CALL _i2c_start
; 0000 0757     i2c_write(0xD2);                                /* Start with device write address */
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 0758     i2c_write(SMPLRT_DIV);                                /* Write to sample rate register */
	LDI  R26,LOW(25)
	CALL _i2c_write
; 0000 0759     i2c_write(0x07);                                    /* 1KHz sample rate */
	LDI  R26,LOW(7)
	CALL _i2c_write
; 0000 075A     i2c_stop();
	CALL _i2c_stop
; 0000 075B 
; 0000 075C     i2c_start();
	CALL _i2c_start
; 0000 075D     i2c_write(0xD2);
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 075E     i2c_write(PWR_MGMT_1);                                /* Write to power management register */
	LDI  R26,LOW(107)
	CALL _i2c_write
; 0000 075F     i2c_write(0x01);                                    /* X axis gyroscope reference frequency */
	LDI  R26,LOW(1)
	CALL _i2c_write
; 0000 0760     i2c_stop();
	CALL _i2c_stop
; 0000 0761 
; 0000 0762     i2c_start();
	CALL _i2c_start
; 0000 0763     i2c_write(0xD2);
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 0764     i2c_write(CONFIG);                                    /* Write to Configuration register */
	LDI  R26,LOW(26)
	CALL _i2c_write
; 0000 0765     i2c_write(0x06);                                    /* Fs = 8KHz */
	LDI  R26,LOW(6)
	CALL _i2c_write
; 0000 0766     i2c_stop();
	CALL _i2c_stop
; 0000 0767 
; 0000 0768     i2c_start();
	CALL _i2c_start
; 0000 0769     i2c_write(0xD2);
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 076A     i2c_write(GYRO_CONFIG);                                /* Write to Gyro configuration register */
	LDI  R26,LOW(27)
	CALL _i2c_write
; 0000 076B     i2c_write(0x18);                                    /* Full scale range +/- 2000 degree/C */
	LDI  R26,LOW(24)
	CALL _i2c_write
; 0000 076C     i2c_stop();
	CALL _i2c_stop
; 0000 076D 
; 0000 076E     i2c_start();
	CALL _i2c_start
; 0000 076F     i2c_write(0xD2);
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 0770     i2c_write(INT_ENABLE);                                /* Write to interrupt enable register */
	LDI  R26,LOW(56)
	CALL _i2c_write
; 0000 0771     i2c_write(0x01);
	LDI  R26,LOW(1)
	CALL _i2c_write
; 0000 0772     i2c_stop();
	CALL _i2c_stop
; 0000 0773 }
	RET
; .FEND
;
;/*
;long int adc3421_read18(void)
;{
; unsigned int buffer1;
; unsigned int buffer2,buffer3;
; long int buffer4;
; i2c_start();
; buffer1 = i2c_write(0xd3);
; buffer1 = i2c_read(1);
; buffer2 = i2c_read(1);
; buffer3 = i2c_read(0);
; i2c_stop();
; buffer1 = buffer1 & 0x01;
; buffer4 = (long) (buffer1) * 65536 ;
; buffer4 = buffer4 + ((long)(buffer2) * 256);
; buffer4 = buffer4 + (long)(buffer3);
; return(buffer4);
;}
;*/
;
;int mpu6050_read(void)
; 0000 078A {
_mpu6050_read:
; .FSTART _mpu6050_read
; 0000 078B int pitchacc;
; 0000 078C  // unsigned int buffer2,buffer3;
; 0000 078D     i2c_start();
	ST   -Y,R17
	ST   -Y,R16
;	pitchacc -> R16,R17
	CALL _i2c_start
; 0000 078E     i2c_write(0xD2);                                /* I2C start with device write address */
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 078F     i2c_write(ACCEL_XOUT_H);                            /* Write start location address from where to read */
	LDI  R26,LOW(59)
	CALL _i2c_write
; 0000 0790     i2c_start();
	CALL _i2c_start
; 0000 0791     i2c_write(0xD3);                            /* I2C start with device read address */
	LDI  R26,LOW(211)
	CALL _i2c_write
; 0000 0792     x_angle= (((int)i2c_read(1)<<8) | (int)i2c_read(1));
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	STS  _x_angle,R30
	STS  _x_angle+1,R31
; 0000 0793     y_angle= (((int)i2c_read(1)<<8) | (int)i2c_read(1));
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	STS  _y_angle,R30
	STS  _y_angle+1,R31
; 0000 0794     z_angle= (((int)i2c_read(1)<<8) | (int)i2c_read(0));
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	STS  _z_angle,R30
	STS  _z_angle+1,R31
; 0000 0795     i2c_stop();
	CALL _i2c_stop
; 0000 0796     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0797     i2c_start();
	CALL _i2c_start
; 0000 0798     i2c_write(0xD2);                                /* I2C start with device write address */
	LDI  R26,LOW(210)
	CALL _i2c_write
; 0000 0799     i2c_write(GYRO_XOUT_H);                            /* Write start location address from where to read */
	LDI  R26,LOW(67)
	CALL _i2c_write
; 0000 079A     i2c_start();
	CALL _i2c_start
; 0000 079B     i2c_write(0xD3);                            /* I2C start with device read address */
	LDI  R26,LOW(211)
	CALL _i2c_write
; 0000 079C     Gyrox= (((int)i2c_read(1)<<8) | (int)i2c_read(1))/131;       //131 is the gyro scaling factor in datasheet
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDI  R31,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R30
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	CALL __DIVW21
	STS  _Gyrox,R30
	STS  _Gyrox+1,R31
; 0000 079D     Gyroy= (((int)i2c_read(1)<<8) | (int)i2c_read(1)/131);
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	CALL __DIVW21
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	STS  _Gyroy,R30
	STS  _Gyroy+1,R31
; 0000 079E     Gyroz= (((int)i2c_read(1)<<8) | (int)i2c_read(0)/131);
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	CALL __DIVW21
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	STS  _Gyroz,R30
	STS  _Gyroz+1,R31
; 0000 079F     i2c_stop();
	CALL _i2c_stop
; 0000 07A0 
; 0000 07A1 
; 0000 07A2  //pitch = (atan2(-y_angle,z_angle)*1800.0)/3.1415;
; 0000 07A3  //roll = (atan2(x_angle,sqrt((long)y_angle*(long)y_angle+(long)z_angle*(long)z_angle))*1800.0)/3.1415;
; 0000 07A4 
; 0000 07A5 
; 0000 07A6 roll = -1800.0 * atan ((long)x_angle/sqrt((long)y_angle*(long)y_angle + (long)z_angle*(long)z_angle))/3.141592;
	LDS  R30,_x_angle
	LDS  R31,_x_angle+1
	CALL __CWD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_y_angle
	LDS  R27,_y_angle+1
	CALL __CWD2
	LDS  R30,_y_angle
	LDS  R31,_y_angle+1
	CALL __CWD1
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_z_angle
	LDS  R27,_z_angle+1
	CALL __CWD2
	LDS  R30,_z_angle
	LDS  R31,_z_angle+1
	CALL __CWD1
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CDF2
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan
	__GETD2N 0xC4E10000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FD8
	CALL __DIVF21
	LDI  R26,LOW(_roll)
	LDI  R27,HIGH(_roll)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 07A7 pitchacc =1800.0 * atan ((long)y_angle/sqrt((long)x_angle*(long)x_angle + (long)z_angle*(long)z_angle))/3.141592;
	LDS  R30,_y_angle
	LDS  R31,_y_angle+1
	CALL __CWD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_x_angle
	LDS  R27,_x_angle+1
	CALL __CWD2
	LDS  R30,_x_angle
	LDS  R31,_x_angle+1
	CALL __CWD1
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_z_angle
	LDS  R27,_z_angle+1
	CALL __CWD2
	LDS  R30,_z_angle
	LDS  R31,_z_angle+1
	CALL __CWD1
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CDF2
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan
	__GETD2N 0x44E10000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FD8
	CALL __DIVF21
	CALL __CFD1
	MOVW R16,R30
; 0000 07A8 //pitch = (0.1*((long)pitch+(long)Gyrox)) + (0.9 * (long)pitchacc);
; 0000 07A9 pitch = (long)pitchacc;
	__PUTWMRN _pitch,0,16,17
; 0000 07AA 
; 0000 07AB     return (pitch);
	LDS  R30,_pitch
	LDS  R31,_pitch+1
	RJMP _0x2120008
; 0000 07AC }
; .FEND
;
;
;
;
;
;void read_adc(void)
; 0000 07B3 {
_read_adc:
; .FSTART _read_adc
; 0000 07B4 int offset;
; 0000 07B5 if(adc_fl)
	ST   -Y,R17
	ST   -Y,R16
;	offset -> R16,R17
	SBRS R4,3
	RJMP _0x156
; 0000 07B6         {
; 0000 07B7 //        adc_angle = mpu6050_read();
; 0000 07B8         adc_fl =0;
	CLT
	BLD  R4,3
; 0000 07B9 /*
; 0000 07BA         fil_cnt++;
; 0000 07BB 
; 0000 07BC         if (fil_cnt >=3)
; 0000 07BD             {
; 0000 07BE             fil_cnt =0;
; 0000 07BF             adc_angle = ((long)angle_filt[0]+(long)angle_filt[1]+(long)angle_filt[2])/3;
; 0000 07C0               read_adcfl =1;
; 0000 07C1               angle = adc_angle;
; 0000 07C2             }
; 0000 07C3        angle_filt[fil_cnt] = mpu6050_read();
; 0000 07C4 */
; 0000 07C5 
; 0000 07C6         angle_filt[0] = mpu6050_read();
	RCALL _mpu6050_read
	STS  _angle_filt,R30
	STS  _angle_filt+1,R31
; 0000 07C7         angle = (angle_filt[0]); //+angle_filt[1]+angle_filt[2]+angle_filt[3])/4;
	STS  _angle,R30
	STS  _angle+1,R31
; 0000 07C8         read_adcfl =1;
	SET
	BLD  R4,4
; 0000 07C9        offset = zero_adc;
	__GETWRMN 16,17,0,_zero_adc
; 0000 07CA 
; 0000 07CB         angle = (angle - offset);
	SUB  R30,R16
	SBC  R31,R17
	STS  _angle,R30
	STS  _angle+1,R31
; 0000 07CC         }
; 0000 07CD // adjust offset and span
; 0000 07CE 
; 0000 07CF 
; 0000 07D0 
; 0000 07D1 }
_0x156:
_0x2120008:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;/*
;void get_irkey(void)
;{
;// ir sensing
;if (rcflag)
;{
;rcflag =0;
;ircommand = irsense & 0x0f;
;switch(ircommand)
;    {
;    case 0:     mode =1;
;                pgm_fl =1;
;//                lcd_gotoxy(0,0);
;                lcd_clear();
;                lcd_putsf("set the time");
;                lcd_gotoxy(0,1);
;                display_time();
;                blink_data = hou;
;                blink_locx =0;
;                blink_locy =1;
;                blink_fl =1;
;                set =0;
;                item1 =0;
;                break;
;    case 1:     calibfact = calibuser =0;
;                mode =0;
;                pgm_fl =0;
;                blink_fl =0;
;                set =0;
;                item1 =0;
;                lcd_clear();
;                delay_ms(10);
;                break;
;    case 2:     key1_fl =1;
;                key2_fl = key3_fl = key4_fl =0;
;                break;
;    case 3:     key4_fl=1;
;                key1_fl = key2_fl = key3_fl =0;
;                break;
;    case 4:    key2_fl=1;
;               key1_fl = key4_fl = key3_fl =0;
;
;                break;
;    case 5:    key3_fl=1;
;                    key1_fl = key2_fl = key4_fl =0;
;
;                break;
;    case 6:     calibuser =1;
;                calibfact =0;
;                lcd_putsf("the panel ");
;                lcd_gotoxy(0,1);
;                lcd_putsf("calibration mode");
;                delay_ms(3000);
;                lcd_gotoxy(0,0);
;                lcd_putsf("inc > inch up");
;                lcd_gotoxy(0,1);
;                lcd_putsf("dec > inch down");
;                delay_ms(3000);
;                lcd_gotoxy(0,0);
;                lcd_putsf("set > enter low");
;                lcd_gotoxy(0,1);
;                lcd_putsf("shf-> enter high");
;                delay_ms(3000);
;                break;
;    }
;
;
;
;
;}
;
;
;}
;*/
;
;void display_update(void)
; 0000 0820 {
_display_update:
; .FSTART _display_update
; 0000 0821 
; 0000 0822 if (mode ==0 && !manual_fl)
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,0
	BRNE _0x158
	SBRS R5,2
	RJMP _0x159
_0x158:
	RJMP _0x157
_0x159:
; 0000 0823         {
; 0000 0824         lcd_clear();
	CALL _lcd_clear
; 0000 0825         mode0_seqcnt++;
	LDI  R26,LOW(_mode0_seqcnt)
	LDI  R27,HIGH(_mode0_seqcnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0826         if (mode0_seqcnt > 65) mode0_seqcnt=0;
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	CPI  R26,LOW(0x42)
	LDI  R30,HIGH(0x42)
	CPC  R27,R30
	BRLT _0x15A
	LDI  R30,LOW(0)
	STS  _mode0_seqcnt,R30
	STS  _mode0_seqcnt+1,R30
; 0000 0827         if (mode0_seqcnt>=0 && mode0_seqcnt<=25)                //display date and time
_0x15A:
	LDS  R26,_mode0_seqcnt+1
	TST  R26
	BRMI _0x15C
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	SBIW R26,26
	BRLT _0x15D
_0x15C:
	RJMP _0x15B
_0x15D:
; 0000 0828                 {
; 0000 0829                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 082A //                put_message(Gyrox);
; 0000 082B //                lcd_putsf("|");
; 0000 082C //                put_message(Gyroy);
; 0000 082D 
; 0000 082E                 lcd_putsf("time: ");
	__POINTW2FN _0x0,280
	CALL _lcd_putsf
; 0000 082F                 display_time();
	CALL _display_time
; 0000 0830                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0831                     lcd_putsf("angle: ");
	__POINTW2FN _0x0,287
	CALL _lcd_putsf
; 0000 0832                     display_angle(angle);        //x
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0833 //                    lcd_putsf("|");
; 0000 0834 //                    display_angle(roll);
; 0000 0835 //                    lcd_putsf(" deg.");
; 0000 0836 
; 0000 0837                 }
; 0000 0838 
; 0000 0839 
; 0000 083A 
; 0000 083B         if (mode0_seqcnt>=26 && mode0_seqcnt<=40)            //display sunrise and sunset time
_0x15B:
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	SBIW R26,26
	BRLT _0x15F
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	SBIW R26,41
	BRLT _0x160
_0x15F:
	RJMP _0x15E
_0x160:
; 0000 083C                 {
; 0000 083D                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 083E                 lcd_putsf("sunrise: ");
	__POINTW2FN _0x0,295
	CALL _lcd_putsf
; 0000 083F                 display_day2(sunrise_min);
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	CALL __CFD1
	MOVW R26,R30
	CALL _display_day2
; 0000 0840                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0841                 lcd_putsf("sunset: ");
	__POINTW2FN _0x0,305
	CALL _lcd_putsf
; 0000 0842                 display_day2(sunset_min);
	LDS  R30,_sunset_min
	LDS  R31,_sunset_min+1
	LDS  R22,_sunset_min+2
	LDS  R23,_sunset_min+3
	CALL __CFD1
	MOVW R26,R30
	CALL _display_day2
; 0000 0843                 }
; 0000 0844         if (mode0_seqcnt>=41 && mode0_seqcnt<=55)
_0x15E:
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	SBIW R26,41
	BRLT _0x162
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	SBIW R26,56
	BRLT _0x163
_0x162:
	RJMP _0x161
_0x163:
; 0000 0845                 {                                            //next target angle and time
; 0000 0846                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0847                 lcd_putsf("next time/angle:");
	__POINTW2FN _0x0,314
	CALL _lcd_putsf
; 0000 0848                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0849                 display_day2(target_time);
	LDS  R26,_target_time
	LDS  R27,_target_time+1
	CALL _display_day2
; 0000 084A                 lcd_putchar('/');
	LDI  R26,LOW(47)
	CALL _lcd_putchar
; 0000 084B                 display_angle(target_angle);
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	CALL _display_angle
; 0000 084C                 }
; 0000 084D         if (mode0_seqcnt>=56 && mode0_seqcnt<=65)             //pv volt and current
_0x161:
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	SBIW R26,56
	BRLT _0x165
	LDS  R26,_mode0_seqcnt
	LDS  R27,_mode0_seqcnt+1
	CPI  R26,LOW(0x42)
	LDI  R30,HIGH(0x42)
	CPC  R27,R30
	BRLT _0x166
_0x165:
	RJMP _0x164
_0x166:
; 0000 084E                 {
; 0000 084F //                lcd_gotoxy(0,0);
; 0000 0850 //                lcd_putsf("charge: ");
; 0000 0851 //                if(boost_fl)
; 0000 0852 //                lcd_putsf("boost    ");
; 0000 0853 //                else if (float_fl)
; 0000 0854 //                lcd_putsf("equal..  ");
; 0000 0855 //                else
; 0000 0856 //                lcd_putsf("trickle  ");
; 0000 0857  //               put_message(high_angle);
; 0000 0858 //               display_analog(adc_loadcurrent);
; 0000 0859  //               lcd_putsf(" Amp.");
; 0000 085A                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 085B                  lcd_putsf("date: ");
	__POINTW2FN _0x0,331
	CALL _lcd_putsf
; 0000 085C                 display_date();
	CALL _display_date
; 0000 085D          //display_analog(current);
; 0000 085E                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 085F                 display_angle1(low_angle);
	LDS  R26,_low_angle
	LDS  R27,_low_angle+1
	CALL _display_angle1
; 0000 0860                 lcd_putsf(" / ");
	__POINTW2FN _0x0,338
	CALL _lcd_putsf
; 0000 0861                 display_angle1(high_angle);
	LDS  R26,_high_angle
	LDS  R27,_high_angle+1
	CALL _display_angle1
; 0000 0862 //                lcd_putsf("Degs.");
; 0000 0863                 }
; 0000 0864          lcd_gotoxy(0,2);
_0x164:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 0865 //                lcd_putsf("sunrise: ");
; 0000 0866 //                display_time2(riset*100);
; 0000 0867 //                lcd_gotoxy(0,3);
; 0000 0868 //                lcd_putsf("sunset: ");
; 0000 0869 //                display_time2(settm*100);
; 0000 086A 
; 0000 086B                 lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 086C 
; 0000 086D          display_angle(sun_angle);
	LDS  R26,_sun_angle
	LDS  R27,_sun_angle+1
	CALL _display_angle
; 0000 086E          lcd_putsf(" G:");
	__POINTW2FN _0x0,342
	CALL _lcd_putsf
; 0000 086F          display_angle(gangle);
	LDS  R26,_gangle
	LDS  R27,_gangle+1
	CALL _display_angle
; 0000 0870          lcd_gotoxy(0,3);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
; 0000 0871          display_angle(target_angle);
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	CALL _display_angle
; 0000 0872          lcd_putsf("b:");
	__POINTW2FN _0x0,346
	CALL _lcd_putsf
; 0000 0873 //         display_angle(b_factor);
; 0000 0874 //         display_analog(adc_battery);
; 0000 0875 //         if (boost_fl) lcd_putsf("boost");
; 0000 0876 //         if(float_fl) lcd_putsf("equal.");
; 0000 0877 //         if(trickle_fl) lcd_putsf("trickle");
; 0000 0878 //         lcd_gotoxy(0,3);
; 0000 0879 //         if (shutdown) lcd_putsf(" ON ");
; 0000 087A //         else lcd_putsf("OFF ");
; 0000 087B //         display_analog(adc_chargecurrent);
; 0000 087C //         lcd_putsf(" ");
; 0000 087D          display_analog(OCR1A);
	IN   R30,0x2A
	IN   R31,0x2A+1
	MOVW R26,R30
	CALL _display_analog
; 0000 087E         }
; 0000 087F if (mode == 1 && !manual_fl)
_0x157:
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,1
	BRNE _0x168
	SBRS R5,2
	RJMP _0x169
_0x168:
	RJMP _0x167
_0x169:
; 0000 0880         {
; 0000 0881         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0882         switch(set)
	LDS  R30,_set
	LDS  R31,_set+1
; 0000 0883         {
; 0000 0884         case 0: display_time();
	SBIW R30,0
	BRNE _0x16D
	CALL _display_time
; 0000 0885                 break;
	RJMP _0x16C
; 0000 0886         case 1: display_date();
_0x16D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16E
	CALL _display_date
; 0000 0887                 break;
	RJMP _0x16C
; 0000 0888         case 2: display_latlong(set_latit);
_0x16E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x16F
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _display_latlong
; 0000 0889                 lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 088A                 break;
	RJMP _0x16C
; 0000 088B         case 3: display_latlong(set_longitude);
_0x16F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x170
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _display_latlong
; 0000 088C                 lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 088D                 break;
	RJMP _0x16C
; 0000 088E         case 4: put_message2(time_interval);
_0x170:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x171
	LDS  R26,_time_interval
	CALL _put_message2
; 0000 088F                 lcd_putsf(" minutes  ");
	__POINTW2FN _0x0,349
	CALL _lcd_putsf
; 0000 0890                 break;
	RJMP _0x16C
; 0000 0891         case 5: lcd_putsf("GMT ");
_0x171:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x172
	__POINTW2FN _0x0,139
	CALL _lcd_putsf
; 0000 0892                 display_latlong(set_timezone);
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CALL _display_latlong
; 0000 0893                 break;
	RJMP _0x16C
; 0000 0894         case 6: lcd_putsf("    ");
_0x172:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x173
	__POINTW2FN _0x0,166
	CALL _lcd_putsf
; 0000 0895                 display_latlong(set_width);
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CALL _display_latlong
; 0000 0896                 break;
	RJMP _0x16C
; 0000 0897         case 7: lcd_putsf("    ");
_0x173:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x174
	__POINTW2FN _0x0,166
	CALL _lcd_putsf
; 0000 0898                 display_latlong(set_distance);
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CALL _display_latlong
; 0000 0899                 break;
	RJMP _0x16C
; 0000 089A         case 8: lcd_putsf("    ");
_0x174:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x175
	__POINTW2FN _0x0,166
	CALL _lcd_putsf
; 0000 089B                 display_modbus(modbus_id);
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CALL _display_modbus
; 0000 089C                 break;
	RJMP _0x16C
; 0000 089D         case 9: lcd_putsf("   ");
_0x175:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x16C
	__POINTW2FN _0x0,167
	CALL _lcd_putsf
; 0000 089E                switch(modbus_rate)
	LDS  R30,_modbus_rate
	LDS  R31,_modbus_rate+1
; 0000 089F                     {
; 0000 08A0                     case 1: lcd_putsf("  9600");
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17A
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
; 0000 08A1                             break;
	RJMP _0x179
; 0000 08A2                     case 2: lcd_putsf(" 19200");
_0x17A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x17B
	__POINTW2FN _0x0,220
	CALL _lcd_putsf
; 0000 08A3                             break;
	RJMP _0x179
; 0000 08A4                     case 3: lcd_putsf(" 38400");
_0x17B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x17C
	__POINTW2FN _0x0,227
	CALL _lcd_putsf
; 0000 08A5                             break;
	RJMP _0x179
; 0000 08A6                     case 4: lcd_putsf(" 57600");
_0x17C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x17D
	__POINTW2FN _0x0,234
	CALL _lcd_putsf
; 0000 08A7                             break;
	RJMP _0x179
; 0000 08A8                     case 5: lcd_putsf("115200");
_0x17D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x17F
	__POINTW2FN _0x0,241
	CALL _lcd_putsf
; 0000 08A9                             break;
	RJMP _0x179
; 0000 08AA                     default:lcd_putsf("  9600");
_0x17F:
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
; 0000 08AB                             e_modbus_rate = modbus_rate =0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
	LDI  R26,LOW(_e_modbus_rate)
	LDI  R27,HIGH(_e_modbus_rate)
	CALL __EEPROMWRW
; 0000 08AC                             break;
; 0000 08AD                     }
_0x179:
; 0000 08AE //                display_modbus(modbus_rate);
; 0000 08AF                 break;
; 0000 08B0         }
_0x16C:
; 0000 08B1 
; 0000 08B2 
; 0000 08B3            switch (item1)
	LDS  R30,_item1
	LDS  R31,_item1+1
; 0000 08B4                 {
; 0000 08B5                 case 0: blink_data = hour;
	SBIW R30,0
	BRNE _0x183
	STS  _blink_data,R7
; 0000 08B6                         blink_locx =0;
	CLR  R12
; 0000 08B7                         blink_locy =1;
	RJMP _0x285
; 0000 08B8                         break;
; 0000 08B9                 case 1: blink_data = minute;
_0x183:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x184
	STS  _blink_data,R6
; 0000 08BA                         blink_locx =3;
	LDI  R30,LOW(3)
	RJMP _0x286
; 0000 08BB                         blink_locy =1;
; 0000 08BC                         break;
; 0000 08BD                 case 2: blink_data = second;
_0x184:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x185
	STS  _blink_data,R9
; 0000 08BE                         blink_locx =6;
	LDI  R30,LOW(6)
	RJMP _0x286
; 0000 08BF                         blink_locy =1;
; 0000 08C0                         break;
; 0000 08C1                 case 3: blink_data = day;
_0x185:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x186
	STS  _blink_data,R11
; 0000 08C2                         blink_locx =0;
	CLR  R12
; 0000 08C3                         blink_locy =1;
	RJMP _0x285
; 0000 08C4                         break;
; 0000 08C5                 case 4: blink_data = month;
_0x186:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x187
	STS  _blink_data,R10
; 0000 08C6                         blink_locx =3;
	LDI  R30,LOW(3)
	RJMP _0x286
; 0000 08C7                         blink_locy =1;
; 0000 08C8                         break;
; 0000 08C9                 case 5: blink_data = year;
_0x187:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x188
	STS  _blink_data,R13
; 0000 08CA                         blink_locx =8;
	LDI  R30,LOW(8)
	RJMP _0x286
; 0000 08CB                         blink_locy =1;
; 0000 08CC                         break;
; 0000 08CD                 case 6: char_latitude = blink_data = (abs(set_latit)/100)%100 ;
_0x188:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x189
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 08CE                         blink_locx =2;
	LDI  R30,LOW(2)
	RJMP _0x286
; 0000 08CF                         blink_locy =1;
; 0000 08D0                         break;
; 0000 08D1                 case 7: char_latitude = blink_data = abs(set_latit)%100 ;
_0x189:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x18A
	LDS  R26,_set_latit
	LDS  R27,_set_latit+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_latitude,R30
; 0000 08D2                         blink_locx =5;
	LDI  R30,LOW(5)
	RJMP _0x286
; 0000 08D3                         blink_locy =1;
; 0000 08D4                         break;
; 0000 08D5                 case 8: char_longitude = blink_data = (abs(set_longitude)/100)%100 ;
_0x18A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x18B
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 08D6                         blink_locx =2;
	LDI  R30,LOW(2)
	RJMP _0x286
; 0000 08D7                         blink_locy =1;
; 0000 08D8                         break;
; 0000 08D9                 case 9: char_longitude = blink_data = abs(set_longitude)%100 ;
_0x18B:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x18C
	LDS  R26,_set_longitude
	LDS  R27,_set_longitude+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_longitude,R30
; 0000 08DA                         blink_locx =5;
	LDI  R30,LOW(5)
	RJMP _0x286
; 0000 08DB                         blink_locy =1;
; 0000 08DC                         break;
; 0000 08DD                 case 10:blink_data = time_interval;
_0x18C:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x18D
	LDS  R30,_time_interval
	STS  _blink_data,R30
; 0000 08DE                         blink_locx =0;
	CLR  R12
; 0000 08DF                         blink_locy =1;
	RJMP _0x285
; 0000 08E0                         break;
; 0000 08E1                 case 11:char_timezone = blink_data = (abs(set_timezone)/100)%100 ;
_0x18D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x18E
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_timezone,R30
; 0000 08E2                         blink_locx =6;
	LDI  R30,LOW(6)
	RJMP _0x286
; 0000 08E3                         blink_locy =1;
; 0000 08E4                         break;
; 0000 08E5                 case 12:char_timezone =  blink_data = abs(set_timezone)%100;
_0x18E:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x18F
	LDS  R26,_set_timezone
	LDS  R27,_set_timezone+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_timezone,R30
; 0000 08E6                         blink_locx = 9;
	LDI  R30,LOW(9)
	RJMP _0x286
; 0000 08E7                         blink_locy =1;
; 0000 08E8                         break;
; 0000 08E9                 case 13:char_width = blink_data = (abs(set_width)/100)%100 ;
_0x18F:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x190
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_width,R30
; 0000 08EA                         blink_locx =6;
	LDI  R30,LOW(6)
	RJMP _0x286
; 0000 08EB                         blink_locy =1;
; 0000 08EC                         break;
; 0000 08ED                 case 14:char_width =  blink_data = abs(set_width)%100;
_0x190:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x191
	LDS  R26,_set_width
	LDS  R27,_set_width+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_width,R30
; 0000 08EE                         blink_locx = 9;
	LDI  R30,LOW(9)
	RJMP _0x286
; 0000 08EF                         blink_locy =1;
; 0000 08F0                         break;
; 0000 08F1                 case 15:char_distance = blink_data = (abs(set_distance)/100)%100 ;
_0x191:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x192
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_distance,R30
; 0000 08F2                         blink_locx =6;
	LDI  R30,LOW(6)
	RJMP _0x286
; 0000 08F3                         blink_locy =1;
; 0000 08F4                         break;
; 0000 08F5                 case 16:char_distance =  blink_data = abs(set_distance)%100;
_0x192:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x193
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_distance,R30
; 0000 08F6                         blink_locx = 9;
	LDI  R30,LOW(9)
	RJMP _0x286
; 0000 08F7                         blink_locy =1;
; 0000 08F8                         break;
; 0000 08F9                         break;
; 0000 08FA                 case 17:char_id = blink_data = (abs(modbus_id)/100)%100 ;
_0x193:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x194
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_id,R30
; 0000 08FB                         blink_locx =5;
	LDI  R30,LOW(5)
	RJMP _0x286
; 0000 08FC                         blink_locy =1;
; 0000 08FD                         break;
; 0000 08FE                 case 18:char_id =  blink_data = abs(modbus_id)%100;
_0x194:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x195
	LDS  R26,_modbus_id
	LDS  R27,_modbus_id+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_id,R30
; 0000 08FF                         blink_locx = 7;
	RJMP _0x287
; 0000 0900                         blink_locy =1;
; 0000 0901                         break;
; 0000 0902                         break;
; 0000 0903                 case 19:char_rate = blink_data = (abs(modbus_rate)/100)%100 ;
_0x195:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x196
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_rate,R30
; 0000 0904                         blink_locx =5;
	LDI  R30,LOW(5)
	RJMP _0x286
; 0000 0905                         blink_locy =1;
; 0000 0906                         break;
; 0000 0907                 case 20:char_rate =  blink_data = abs(modbus_rate)%100;
_0x196:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x182
	LDS  R26,_modbus_rate
	LDS  R27,_modbus_rate+1
	CALL _abs
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STS  _blink_data,R30
	STS  _char_rate,R30
; 0000 0908                         blink_locx = 7;
_0x287:
	LDI  R30,LOW(7)
_0x286:
	MOV  R12,R30
; 0000 0909                         blink_locy =1;
_0x285:
	LDI  R30,LOW(1)
	STS  _blink_locy,R30
; 0000 090A                         break;                 }
_0x182:
; 0000 090B         }
; 0000 090C if (manual_fl)
_0x167:
	SBRS R5,2
	RJMP _0x198
; 0000 090D     {
; 0000 090E     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 090F                 lcd_putsf("* Manual Mode * ");
	__POINTW2FN _0x0,360
	CALL _lcd_putsf
; 0000 0910 
; 0000 0911 //    lcd_putsf("manual mode");
; 0000 0912     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0913     lcd_putsf("angle: ");
	__POINTW2FN _0x0,287
	CALL _lcd_putsf
; 0000 0914     display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0915     lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 0916 
; 0000 0917     }
; 0000 0918 
; 0000 0919 
; 0000 091A }
_0x198:
	RET
; .FEND
;
;
;
;
;/*
;void mpu6050_init(void)
;{
;i2c_start();
;i2c_write(0xd2);
;delay_ms(1);
;i2c_write(0x9c);   //18 bit mode 1v/v
; i2c_stop();
;}
;
;long int adc3421_read(void)
;{
; unsigned int buffer1;
; unsigned int buffer2,buffer3;
; long int buffer4;
; i2c_start();
; buffer1 = i2c_write(0xd3);
; buffer1 = i2c_read(1);
; buffer2 = i2c_read(1);
; buffer3 = i2c_read(0);
; i2c_stop();
; buffer1 = buffer1 & 0x01;
; buffer4 = (long) (buffer1) * 65536 ;
; buffer4 = buffer4 + ((long)(buffer2) * 256);
; buffer4 = buffer4 + (long)(buffer3);
; return(buffer4);
;//return ((long)rand()+32000);
;}
;
;void write_2464(unsigned int address,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char d ...
;{
;unsigned int adhi,adlo;
;adhi = address/256;
;adlo = address%256;
;i2c_start();
;i2c_write(0xa0);               // write command
;i2c_write(adhi);
;i2c_write(adlo);
;i2c_write(data1);
;i2c_write(data2);
;i2c_write(data3);
;i2c_write(data4);
;i2c_write(data5);
;i2c_write(data6);
;i2c_write(data7);
;i2c_write(data8);
;i2c_write(data9);
;i2c_write(data10);
;i2c_write(data11);
;i2c_write(data12);
;i2c_write(data13);
;i2c_write(data14);
;delay_ms(1000);
;
;i2c_stop();
;delay_ms(1);
;}
;*/
;
;/*
;
;void read_2464(int addr)
;{
;i2c_start();
;i2c_write(0xa0);               // write command
;i2c_write(addr/256);
;i2c_write(addr%256);
;//i2c_stop();
;i2c_start();
;i2c_write(0xa1);             //read address
;record_buffer[0] = i2c_read(1);
;record_buffer[1] = i2c_read(1);
;record_buffer[2] = i2c_read(1);
;record_buffer[3] = i2c_read(1);
;record_buffer[4] = i2c_read(1);
;record_buffer[5] = i2c_read(1);
;record_buffer[6] = i2c_read(1);
;record_buffer[7] = i2c_read(1);
;record_buffer[8] = i2c_read(1);
;record_buffer[9] = i2c_read(1);
;record_buffer[10] = i2c_read(1);
;record_buffer[11] = i2c_read(1);
;record_buffer[12] = i2c_read(1);
;record_buffer[13] = i2c_read(0);
;i2c_stop();
;}
;
;*/
;
;
;void cal_angle(void)
; 0000 097A {
_cal_angle:
; .FSTART _cal_angle
; 0000 097B //float sensitivity,angle_rad;
; 0000 097C 
; 0000 097D //sensitivity = span_adc - zero_adc;
; 0000 097E //angle_rad = asin(((float)adc_angle - (float)zero_adc) /sensitivity);
; 0000 097F //angle_sum = angle_sum + ((angle_rad * 572.957795) + 900) ;
; 0000 0980 //angle=((angle_rad * 572.957795) + 900) ;
; 0000 0981 if (read_adcfl)
	SBRS R4,4
	RJMP _0x199
; 0000 0982 {
; 0000 0983 read_adcfl =0;
	CLT
	BLD  R4,4
; 0000 0984 //angle = adc_angle;
; 0000 0985 }
; 0000 0986 
; 0000 0987 //angle_cnt++;
; 0000 0988 /*
; 0000 0989 if (angle_cnt >=4)
; 0000 098A {
; 0000 098B angle_cnt =0;
; 0000 098C angle = angle_sum/4;
; 0000 098D angle_sum =0;
; 0000 098E }
; 0000 098F *///angle = (float)adc_buffer - (float)zero_adc /sensitivity ;
; 0000 0990 }
_0x199:
	RET
; .FEND
;
;void target_cal(void)
; 0000 0993 {
_target_cal:
; .FSTART _target_cal
; 0000 0994 long  a;
; 0000 0995 int y=1;
; 0000 0996 time_elap = to_minute(hour,minute);      // convert real time to minutes
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	a -> Y+2
;	y -> R16,R17
	__GETWRN 16,17,1
	ST   -Y,R7
	MOV  R26,R6
	CALL _to_minute
	STS  _time_elap,R30
	STS  _time_elap+1,R31
; 0000 0997 if (time_elap > sunrise_min)
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	LDS  R26,_time_elap
	LDS  R27,_time_elap+1
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x19A
; 0000 0998         {
; 0000 0999         for (y=1;y<=150;y++)
	__GETWRN 16,17,1
_0x19C:
	__CPWRN 16,17,151
	BRLT PC+2
	RJMP _0x19D
; 0000 099A         {
; 0000 099B         if (time_elap <= (sunrise_min +(time_interval*y)))
	MOVW R30,R16
	LDS  R26,_time_interval
	LDS  R27,_time_interval+1
	CALL __MULW12
	LDS  R26,_sunrise_min
	LDS  R27,_sunrise_min+1
	LDS  R24,_sunrise_min+2
	LDS  R25,_sunrise_min+3
	CALL __CWD1
	CALL __CDF1
	CALL __ADDF12
	LDS  R26,_time_elap
	LDS  R27,_time_elap+1
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x19E
; 0000 099C                 {
; 0000 099D                 target_time = sunrise_min +((long)(time_interval)*y);
	LDS  R26,_time_interval
	LDS  R27,_time_interval+1
	CALL __CWD2
	MOVW R30,R16
	CALL __CWD1
	CALL __MULD12
	LDS  R26,_sunrise_min
	LDS  R27,_sunrise_min+1
	LDS  R24,_sunrise_min+2
	LDS  R25,_sunrise_min+3
	CALL __CDF1
	CALL __ADDF12
	LDI  R26,LOW(_target_time)
	LDI  R27,HIGH(_target_time)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 099E                 break;
	RJMP _0x19D
; 0000 099F                 }
; 0000 09A0         }
_0x19E:
	__ADDWRN 16,17,1
	RJMP _0x19C
_0x19D:
; 0000 09A1 
; 0000 09A2         if (target_time > sunset_min) target_time = sunset_min;
	LDS  R30,_sunset_min
	LDS  R31,_sunset_min+1
	LDS  R22,_sunset_min+2
	LDS  R23,_sunset_min+3
	LDS  R26,_target_time
	LDS  R27,_target_time+1
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x19F
	LDS  R30,_sunset_min
	LDS  R31,_sunset_min+1
	LDS  R22,_sunset_min+2
	LDS  R23,_sunset_min+3
	LDI  R26,LOW(_target_time)
	LDI  R27,HIGH(_target_time)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 09A3         if (target_time < sunrise_min) target_time = sunrise_min;
_0x19F:
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	LDS  R26,_target_time
	LDS  R27,_target_time+1
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BRSH _0x1A0
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	LDI  R26,LOW(_target_time)
	LDI  R27,HIGH(_target_time)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 09A4 
; 0000 09A5         a = target_time - sunrise_min;
_0x1A0:
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	LDS  R26,_target_time
	LDS  R27,_target_time+1
	CALL __CWD2
	CALL __CDF2
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R28
	ADIW R26,2
	CALL __CFD1
	CALL __PUTDP1
; 0000 09A6         sun_angle = ((1800 * a)/ (long)daytime)-900;
	__GETD1S 2
	__GETD2N 0x708
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_daytime
	LDS  R31,_daytime+1
	LDS  R22,_daytime+2
	LDS  R23,_daytime+3
	CALL __CFD1
	CALL __DIVD21
	__SUBD1N 900
	STS  _sun_angle,R30
	STS  _sun_angle+1,R31
	STS  _sun_angle+2,R22
	STS  _sun_angle+3,R23
; 0000 09A7         backtrack();                     // routine for backtracking
	RCALL _backtrack
; 0000 09A8         target_angle = new_target;
	LDS  R30,_new_target
	LDS  R31,_new_target+1
	CALL __CWD1
	STS  _target_angle,R30
	STS  _target_angle+1,R31
	STS  _target_angle+2,R22
	STS  _target_angle+3,R23
; 0000 09A9         if (target_angle > high_angle) target_angle = high_angle;
	LDS  R30,_high_angle
	LDS  R31,_high_angle+1
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	LDS  R24,_target_angle+2
	LDS  R25,_target_angle+3
	CALL __CWD1
	CALL __CPD12
	BRGE _0x1A1
	LDS  R30,_high_angle
	LDS  R31,_high_angle+1
	CALL __CWD1
	STS  _target_angle,R30
	STS  _target_angle+1,R31
	STS  _target_angle+2,R22
	STS  _target_angle+3,R23
; 0000 09AA         if (target_angle < low_angle) target_angle = low_angle;
_0x1A1:
	LDS  R30,_low_angle
	LDS  R31,_low_angle+1
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	LDS  R24,_target_angle+2
	LDS  R25,_target_angle+3
	CALL __CWD1
	CALL __CPD21
	BRGE _0x1A2
	LDS  R30,_low_angle
	LDS  R31,_low_angle+1
	CALL __CWD1
	STS  _target_angle,R30
	STS  _target_angle+1,R31
	STS  _target_angle+2,R22
	STS  _target_angle+3,R23
; 0000 09AB // bring the panel to 90 degrees (horizontal position ) 10 minutes after sunset.
; 0000 09AC // added to hardcode limit from 50 to 125 degrees for ravindra energy
; 0000 09AD        if (target_angle > 600) target_angle = 600;
_0x1A2:
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	LDS  R24,_target_angle+2
	LDS  R25,_target_angle+3
	__CPD2N 0x259
	BRLT _0x1A3
	__GETD1N 0x258
	STS  _target_angle,R30
	STS  _target_angle+1,R31
	STS  _target_angle+2,R22
	STS  _target_angle+3,R23
; 0000 09AE        if (target_angle < -600) target_angle = -600;
_0x1A3:
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	LDS  R24,_target_angle+2
	LDS  R25,_target_angle+3
	__CPD2N 0xFFFFFDA8
	BRGE _0x1A4
	__GETD1N 0xFFFFFDA8
	STS  _target_angle,R30
	STS  _target_angle+1,R31
	STS  _target_angle+2,R22
	STS  _target_angle+3,R23
; 0000 09AF /////////////////////remove this for other limits
; 0000 09B0 
; 0000 09B1         if ((time_elap < sunrise_min) || (time_elap>sunset_min))
_0x1A4:
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	LDS  R26,_time_elap
	LDS  R27,_time_elap+1
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BRLO _0x1A6
	LDS  R30,_sunset_min
	LDS  R31,_sunset_min+1
	LDS  R22,_sunset_min+2
	LDS  R23,_sunset_min+3
	LDS  R26,_time_elap
	LDS  R27,_time_elap+1
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x1A6
	RJMP _0x1A5
_0x1A6:
; 0000 09B2             {
; 0000 09B3             target_time = sunset_min+10;
	LDS  R30,_sunset_min
	LDS  R31,_sunset_min+1
	LDS  R22,_sunset_min+2
	LDS  R23,_sunset_min+3
	__GETD2N 0x41200000
	CALL __ADDF12
	LDI  R26,LOW(_target_time)
	LDI  R27,HIGH(_target_time)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 09B4             target_angle = 0;     // target angle is 0 degrees
	LDI  R30,LOW(0)
	STS  _target_angle,R30
	STS  _target_angle+1,R30
	STS  _target_angle+2,R30
	STS  _target_angle+3,R30
; 0000 09B5             }
; 0000 09B6 
; 0000 09B7         if ((time_elap == target_time) && !start_fl && !end_fl)
_0x1A5:
	LDS  R30,_target_time
	LDS  R31,_target_time+1
	LDS  R26,_time_elap
	LDS  R27,_time_elap+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x1A9
	SBRC R2,5
	RJMP _0x1A9
	SBRS R2,6
	RJMP _0x1AA
_0x1A9:
	RJMP _0x1A8
_0x1AA:
; 0000 09B8         {
; 0000 09B9         start_fl =1;
	SET
	BLD  R2,5
; 0000 09BA         }
; 0000 09BB 
; 0000 09BC         }
_0x1A8:
; 0000 09BD }
_0x19A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND
;
;
;/*
;void current_control(int cur,int volt_limit,int PV_limit)
;{
;if (read_adcfl)                 // check if all adc readings over
;{
;read_adcfl =0;
;if (adc_battery < volt_limit && adc_pvolt >= PV_limit)
;{
;
;if (adc_chargecurrent < cur-1)
;{
;        if((adc_battery < volt_limit-50) &&(OCR1A < 500)) ocr_inc =10;
;        else
;        ocr_inc =1;
;OCR1A+=ocr_inc;   //hysterisis of +/- 0.02A
;}
;if (adc_chargecurrent > cur+1 && OCR1A != 0x000)
;{
;        if((adc_battery > volt_limit+50)&&(OCR1A > 20)) ocr_inc =10;
;        else
;        ocr_inc =1;
;OCR1A-=ocr_inc;
;}
;if (OCR1A > 500) OCR1A = 500;
;}
;else if(adc_pvolt<= adc_battery+200)
;{
;OCR1A -=10;
;if (OCR1A < 200) OCR1A =200;
;}
;else
;{
;if ((OCR1A < 0x05) ||((adc_pvolt <=(adc_battery+200)) && trickle_fl && float_fl)) OCR1A -=ocr_inc;
;}
;}
;}
;
;
;void voltage_control(int vol,int cur_limit,int PV_limit)
;{
;if (read_adcfl)                 // check if all adc readings over
;{
;read_adcfl =0;
;
;
;if(adc_chargecurrent < cur_limit && adc_pvolt >= PV_limit)
;{
;if (adc_battery <= vol-1)
;{
;        if((adc_battery < vol-50)&&(OCR1A < 500)) ocr_inc =10;
;        else
;        ocr_inc =1;
;
;OCR1A+=ocr_inc;   //hysterisis of +/- 0.02A
;}
;if (adc_battery > vol+1 && (OCR1A !=0x000))
;{
;        if ((adc_battery > vol+50)&&(OCR1A > 20)) ocr_inc =10;
;        else
;        ocr_inc =1;
;
;
;OCR1A-=ocr_inc;
;}
;if (OCR1A > 500) OCR1A = 500;
;}
;else if(adc_pvolt<= adc_battery + 200)
;{
;OCR1A-=10;
;if (OCR1A < 200) OCR1A =200;
;}
;else
;{
;if ((OCR1A <= 0x05) || ((adc_pvolt <= (adc_battery+200))) && trickle_fl && float_fl) OCR1A-=1;
;}
;}
;}
;
;
;
;void battery_control(void)
;{
;//int a;
;if (boost_fl)
;{
;//a = to_min(set_boost_timeout);
;control_buck_on();
;current_control(boost_current,boost_voltage,adc_battery + 100);
;if ((adc_battery >= boost_voltage) || (boost_time >= boost_timeout))
;{
;boost_fl=0;
;float_fl =1;
;trickle_fl =0;
;}
;}
;
;if (float_fl)
;{
;//a= set_float_timeout;
;control_buck_on();
;voltage_control(boost_voltage,boost_current,adc_battery+100);
;if (((adc_chargecurrent < set_capacity/50) && (adc_battery >=equal_voltage))||(float_time > float_timeout))              ...
;{
;boost_fl =0;
;float_fl =0;
;trickle_fl =1;
;}
;}
;if (trickle_fl)
;{
;control_buck_on();
;voltage_control(equal_voltage,trickle_current,adc_battery+100);
;if (adc_battery < cutoff_voltage)
;{
;boost_fl =1;
;trickle_fl =0;
;float_fl=0;
;}
;}
;}
;*/
;/*
;void check_lowbat(void)
;{
;if (adc_battery < cutoff_voltage)
;bat_cur =1;         // turn off load output
;if (adc_battery > cutoff_voltage+100)
;bat_cur =0;
;}
;*/
;
;void backtrack(void)
; 0000 0A44 {
_backtrack:
; .FSTART _backtrack
; 0000 0A45 float b,gamma,rad;
; 0000 0A46 rad = (sun_angle+900) * pi/1800;
	SBIW R28,12
;	b -> Y+8
;	gamma -> Y+4
;	rad -> Y+0
	LDS  R30,_sun_angle
	LDS  R31,_sun_angle+1
	LDS  R22,_sun_angle+2
	LDS  R23,_sun_angle+3
	__ADDD1N 900
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44E10000
	CALL __DIVF21
	CALL __PUTD1S0
; 0000 0A47 
; 0000 0A48 
; 0000 0A49 b= set_distance * sin(rad)/ set_width;
	CALL __GETD2S0
	CALL _sin
	LDS  R26,_set_distance
	LDS  R27,_set_distance+1
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_set_width
	LDS  R31,_set_width+1
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	__PUTD1S 8
; 0000 0A4A b_factor =b*100;
	__GETD2S 8
	__GETD1N 0x42C80000
	CALL __MULF12
	LDI  R26,LOW(_b_factor)
	LDI  R27,HIGH(_b_factor)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0A4B if (b<1)
	__GETD2S 8
	__GETD1N 0x3F800000
	CALL __CMPF12
	BRLO PC+2
	RJMP _0x1AB
; 0000 0A4C     {
; 0000 0A4D     gamma = asin(b)*1800/pi;
	CALL _asin
	__GETD2N 0x44E10000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pi
	LDS  R31,_pi+1
	LDS  R22,_pi+2
	LDS  R23,_pi+3
	CALL __DIVF21
	__PUTD1S 4
; 0000 0A4E 
; 0000 0A4F     gangle = gamma;
	LDI  R26,LOW(_gangle)
	LDI  R27,HIGH(_gangle)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0A50     if (sun_angle >= 0)         //evening
	LDS  R26,_sun_angle+3
	TST  R26
	BRMI _0x1AC
; 0000 0A51         {
; 0000 0A52         new_target = 0 -(1800 - gamma -sun_angle-900);
	__GETD2S 4
	__GETD1N 0x44E10000
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_sun_angle
	LDS  R31,_sun_angle+1
	LDS  R22,_sun_angle+2
	LDS  R23,_sun_angle+3
	RJMP _0x288
; 0000 0A53         }
; 0000 0A54     else
_0x1AC:
; 0000 0A55         {
; 0000 0A56         new_target =0 -(gamma - sun_angle-900);
	LDS  R30,_sun_angle
	LDS  R31,_sun_angle+1
	LDS  R22,_sun_angle+2
	LDS  R23,_sun_angle+3
	__GETD2S 4
_0x288:
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44610000
	CALL __SWAPD12
	CALL __SUBF12
	__GETD2N 0x0
	CALL __SWAPD12
	CALL __SUBF12
	LDI  R26,LOW(_new_target)
	LDI  R27,HIGH(_new_target)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0A57         }
; 0000 0A58     }
; 0000 0A59 else
	RJMP _0x1AE
_0x1AB:
; 0000 0A5A     {
; 0000 0A5B     new_target = sun_angle;
	LDS  R30,_sun_angle
	LDS  R31,_sun_angle+1
	STS  _new_target,R30
	STS  _new_target+1,R31
; 0000 0A5C     }
_0x1AE:
; 0000 0A5D }
	ADIW R28,12
	RET
; .FEND
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0A61 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
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
; 0000 0A62 int night_time;
; 0000 0A63 //#asm("wdr")
; 0000 0A64 time_cnt1++;
	ST   -Y,R17
	ST   -Y,R16
;	night_time -> R16,R17
	LDI  R26,LOW(_time_cnt1)
	LDI  R27,HIGH(_time_cnt1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0A65 //if(time_cnt1>=10)   //20 seconds record printout
; 0000 0A66 //    {
; 0000 0A67 //    time_cnt1=0;
; 0000 0A68 //    print_fl=1;
; 0000 0A69 //    }
; 0000 0A6A time_cnt++;
	LDI  R26,LOW(_time_cnt)
	LDI  R27,HIGH(_time_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0A6B if (time_cnt>=1800)     //execute every 30minutes to save rtc value for backup
	LDS  R26,_time_cnt
	LDS  R27,_time_cnt+1
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	BRLO _0x1AF
; 0000 0A6C {
; 0000 0A6D time_cnt =0;
	LDI  R30,LOW(0)
	STS  _time_cnt,R30
	STS  _time_cnt+1,R30
; 0000 0A6E e_day = day;
	MOV  R30,R11
	LDI  R26,LOW(_e_day)
	LDI  R27,HIGH(_e_day)
	CALL __EEPROMWRB
; 0000 0A6F e_week =week;
	MOV  R30,R8
	LDI  R26,LOW(_e_week)
	LDI  R27,HIGH(_e_week)
	CALL __EEPROMWRB
; 0000 0A70 e_year = year;
	MOV  R30,R13
	LDI  R26,LOW(_e_year)
	LDI  R27,HIGH(_e_year)
	CALL __EEPROMWRB
; 0000 0A71 e_month =month;
	MOV  R30,R10
	LDI  R26,LOW(_e_month)
	LDI  R27,HIGH(_e_month)
	CALL __EEPROMWRB
; 0000 0A72 e_hour = hour;
	MOV  R30,R7
	LDI  R26,LOW(_e_hour)
	LDI  R27,HIGH(_e_hour)
	CALL __EEPROMWRB
; 0000 0A73 e_minute = minute;
	MOV  R30,R6
	LDI  R26,LOW(_e_minute)
	LDI  R27,HIGH(_e_minute)
	CALL __EEPROMWRB
; 0000 0A74 e_second = second;
	MOV  R30,R9
	LDI  R26,LOW(_e_second)
	LDI  R27,HIGH(_e_second)
	CALL __EEPROMWRB
; 0000 0A75 }
; 0000 0A76 // Place your code here
; 0000 0A77 rise_set((long)(day),(long)(month),(long)year+2000,12,(float)(set_latit)/100,(float)(set_longitude)/100,(float)(set_time ...
_0x1AF:
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTPARD1
	MOV  R30,R10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTPARD1
	MOV  R30,R13
	CLR  R31
	CLR  R22
	CLR  R23
	__ADDD1N 2000
	CALL __CDF1
	CALL __PUTPARD1
	__GETD1N 0x41400000
	CALL __PUTPARD1
	LDS  R30,_set_latit
	LDS  R31,_set_latit+1
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	CALL __PUTPARD1
	LDS  R30,_set_longitude
	LDS  R31,_set_longitude+1
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	CALL __PUTPARD1
	LDS  R30,_set_timezone
	LDS  R31,_set_timezone+1
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL _rise_set
; 0000 0A78 // Place your code here
; 0000 0A79 if (mode ==0)
	LDS  R30,_mode
	LDS  R31,_mode+1
	SBIW R30,0
	BRNE _0x1B0
; 0000 0A7A {
; 0000 0A7B /*log_cnt++;
; 0000 0A7C if(log_cnt >= log_interval)
; 0000 0A7D {
; 0000 0A7E log_cnt =0;
; 0000 0A7F if(log_fl) print_realtime();
; 0000 0A80 }
; 0000 0A81 */
; 0000 0A82 rtc_get_time(&hour,&minute,&second);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL _rtc_get_time
; 0000 0A83  //               if (hour <0 || hour >24) rtc_err=1;         //added for rtc error
; 0000 0A84 
; 0000 0A85 rtc_get_date(&week,&day,&month,&year);   //pdi is weekday not used only for cvavr2.05
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	CALL _rtc_get_date
; 0000 0A86 //adc_buffer = adc_angle = mpu6050_read();
; 0000 0A87 }
; 0000 0A88 //if (boost_fl) boost_time++;
; 0000 0A89 //if (float_fl) float_time++;
; 0000 0A8A adc_fl =1;
_0x1B0:
	SET
	BLD  R4,3
; 0000 0A8B led2=~relay1;
	SBIS 0x12,7
	RJMP _0x1B1
	CBI  0x15,4
	RJMP _0x1B2
_0x1B1:
	SBI  0x15,4
_0x1B2:
; 0000 0A8C led1=~relay2;
	SBIS 0x15,0
	RJMP _0x1B3
	CBI  0x12,3
	RJMP _0x1B4
_0x1B3:
	SBI  0x12,3
_0x1B4:
; 0000 0A8D //led3=~err_fl;
; 0000 0A8E //led4= ~(boost_fl | float_fl) ;
; 0000 0A8F //led5= ~trickle_fl;
; 0000 0A90 //if (adc_battery < cutoff_voltage) led6 =0;
; 0000 0A91 //else led6 =1;
; 0000 0A92 led_blinkfl = ~ led_blinkfl;
	LDI  R30,LOW(64)
	EOR  R3,R30
; 0000 0A93 
; 0000 0A94 //display_update();
; 0000 0A95 bright_cnt++;
	LDI  R26,LOW(_bright_cnt)
	LDI  R27,HIGH(_bright_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0A96 if (bright_cnt > 20) bright_cnt =20;
	LDS  R26,_bright_cnt
	LDS  R27,_bright_cnt+1
	SBIW R26,21
	BRLT _0x1B5
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _bright_cnt,R30
	STS  _bright_cnt+1,R31
; 0000 0A97 if (bright_cnt<20 ) backlight =0;         // not valid for low battery
_0x1B5:
	LDS  R26,_bright_cnt
	LDS  R27,_bright_cnt+1
	SBIW R26,20
; 0000 0A98 else backlight =0;
_0x289:
	CBI  0x18,3
; 0000 0A99 program_timeout++;
	LDI  R26,LOW(_program_timeout)
	LDI  R27,HIGH(_program_timeout)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0A9A if (program_timeout >=30) program_timeout =30;
	LDS  R26,_program_timeout
	LDS  R27,_program_timeout+1
	LDS  R24,_program_timeout+2
	LDS  R25,_program_timeout+3
	__CPD2N 0x1E
	BRLT _0x1BC
	__GETD1N 0x1E
	STS  _program_timeout,R30
	STS  _program_timeout+1,R31
	STS  _program_timeout+2,R22
	STS  _program_timeout+3,R23
; 0000 0A9B if (program_timeout ==29)
_0x1BC:
	LDS  R26,_program_timeout
	LDS  R27,_program_timeout+1
	LDS  R24,_program_timeout+2
	LDS  R25,_program_timeout+3
	__CPD2N 0x1D
	BRNE _0x1BD
; 0000 0A9C clear_to_default();     //reset to normal mode if no key is pressed for more than 29 seconds.
	CALL _clear_to_default
; 0000 0A9D 
; 0000 0A9E if (end_fl)
_0x1BD:
	SBRS R2,6
	RJMP _0x1BE
; 0000 0A9F {
; 0000 0AA0 end_cnt++;
	LDI  R26,LOW(_end_cnt)
	LDI  R27,HIGH(_end_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0AA1 if (end_cnt >=61)
	LDS  R26,_end_cnt
	LDS  R27,_end_cnt+1
	SBIW R26,61
	BRLT _0x1BF
; 0000 0AA2 {
; 0000 0AA3 end_fl =0;
	CLT
	BLD  R2,6
; 0000 0AA4 end_cnt =0;
	LDI  R30,LOW(0)
	STS  _end_cnt,R30
	STS  _end_cnt+1,R30
; 0000 0AA5 }
; 0000 0AA6 }
_0x1BF:
; 0000 0AA7 // added code to check if time is between sunset and sunrise. if yes, invoke sleep
; 0000 0AA8 // sleep/standby mode.
; 0000 0AA9 night_time = to_minute(hour,minute);      // convert real time to minutes
_0x1BE:
	ST   -Y,R7
	MOV  R26,R6
	CALL _to_minute
	MOVW R16,R30
; 0000 0AAA if (((night_time > sunset_min +30)|| (night_time < sunrise_min - 30))&& key1 && key2 && key3 && key4)
	LDS  R30,_sunset_min
	LDS  R31,_sunset_min+1
	LDS  R22,_sunset_min+2
	LDS  R23,_sunset_min+3
	__GETD2N 0x41F00000
	CALL __ADDF12
	MOVW R26,R16
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x1C1
	LDS  R30,_sunrise_min
	LDS  R31,_sunrise_min+1
	LDS  R22,_sunrise_min+2
	LDS  R23,_sunrise_min+3
	__GETD2N 0x41F00000
	CALL __SUBF12
	MOVW R26,R16
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	BRSH _0x1C3
_0x1C1:
	SBIS 0x19,0
	RJMP _0x1C3
	SBIS 0x19,1
	RJMP _0x1C3
	SBIS 0x19,2
	RJMP _0x1C3
	SBIC 0x19,3
	RJMP _0x1C4
_0x1C3:
	RJMP _0x1C0
_0x1C4:
; 0000 0AAB         {
; 0000 0AAC         sleep_counter++;
	LDI  R26,LOW(_sleep_counter)
	LDI  R27,HIGH(_sleep_counter)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0AAD         if (sleep_counter >=30)
	LDS  R26,_sleep_counter
	LDS  R27,_sleep_counter+1
	SBIW R26,30
	BRLT _0x1C5
; 0000 0AAE         {
; 0000 0AAF         sleep_counter =30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _sleep_counter,R30
	STS  _sleep_counter+1,R31
; 0000 0AB0         relay1=relay2=0;        //turn off relay
	CBI  0x15,0
	CBI  0x12,7
; 0000 0AB1         backlight =1;                    //turn backlight off
	SBI  0x18,3
; 0000 0AB2         led1=led2=led3=led4=led5=led6 =1; //turn led off
	SBI  0x15,2
	SBI  0x15,1
	SBI  0x15,3
	SBI  0x12,6
	SBI  0x15,4
	SBI  0x12,3
; 0000 0AB3 //        control_buck_off() ;
; 0000 0AB4         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0AB5         lcd_putsf("  NIGHT MODE  ");
	__POINTW2FN _0x0,377
	CALL _lcd_putsf
; 0000 0AB6         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0AB7         display_time();
	CALL _display_time
; 0000 0AB8         sleep_fl =1;
	SET
	BLD  R3,7
; 0000 0AB9 //        sleep_enable();
; 0000 0ABA //        idle();
; 0000 0ABB         }
; 0000 0ABC         }
_0x1C5:
; 0000 0ABD else
	RJMP _0x1D8
_0x1C0:
; 0000 0ABE {
; 0000 0ABF sleep_counter =0;
	LDI  R30,LOW(0)
	STS  _sleep_counter,R30
	STS  _sleep_counter+1,R30
; 0000 0AC0 sleep_fl=0;
	CLT
	BLD  R3,7
; 0000 0AC1 }
_0x1D8:
; 0000 0AC2 }
	LD   R16,Y+
	LD   R17,Y+
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
;
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;
;
;void eeprom_transfer(void)
; 0000 0AD0 {
_eeprom_transfer:
; .FSTART _eeprom_transfer
; 0000 0AD1 span_adc = e_span_adc;
	LDI  R26,LOW(_e_span_adc)
	LDI  R27,HIGH(_e_span_adc)
	CALL __EEPROMRDD
	STS  _span_adc,R30
	STS  _span_adc+1,R31
	STS  _span_adc+2,R22
	STS  _span_adc+3,R23
; 0000 0AD2 zero_adc = e_zero_adc;
	LDI  R26,LOW(_e_zero_adc)
	LDI  R27,HIGH(_e_zero_adc)
	CALL __EEPROMRDD
	STS  _zero_adc,R30
	STS  _zero_adc+1,R31
	STS  _zero_adc+2,R22
	STS  _zero_adc+3,R23
; 0000 0AD3 time_interval = e_time_interval;
	LDI  R26,LOW(_e_time_interval)
	LDI  R27,HIGH(_e_time_interval)
	CALL __EEPROMRDW
	STS  _time_interval,R30
	STS  _time_interval+1,R31
; 0000 0AD4 low_angle = e_low_angle;
	LDI  R26,LOW(_e_low_angle)
	LDI  R27,HIGH(_e_low_angle)
	CALL __EEPROMRDW
	STS  _low_angle,R30
	STS  _low_angle+1,R31
; 0000 0AD5 high_angle = e_high_angle;
	LDI  R26,LOW(_e_high_angle)
	LDI  R27,HIGH(_e_high_angle)
	CALL __EEPROMRDW
	STS  _high_angle,R30
	STS  _high_angle+1,R31
; 0000 0AD6 set_latit = e_set_latit;
	LDI  R26,LOW(_e_set_latit)
	LDI  R27,HIGH(_e_set_latit)
	CALL __EEPROMRDW
	STS  _set_latit,R30
	STS  _set_latit+1,R31
; 0000 0AD7 set_longitude = e_set_longitude;
	LDI  R26,LOW(_e_set_longitude)
	LDI  R27,HIGH(_e_set_longitude)
	CALL __EEPROMRDW
	STS  _set_longitude,R30
	STS  _set_longitude+1,R31
; 0000 0AD8 set_timezone = e_set_timezone;
	LDI  R26,LOW(_e_set_timezone)
	LDI  R27,HIGH(_e_set_timezone)
	CALL __EEPROMRDW
	STS  _set_timezone,R30
	STS  _set_timezone+1,R31
; 0000 0AD9 set_width = e_set_width;
	LDI  R26,LOW(_e_set_width)
	LDI  R27,HIGH(_e_set_width)
	CALL __EEPROMRDW
	STS  _set_width,R30
	STS  _set_width+1,R31
; 0000 0ADA set_distance = e_set_distance;
	LDI  R26,LOW(_e_set_distance)
	LDI  R27,HIGH(_e_set_distance)
	CALL __EEPROMRDW
	STS  _set_distance,R30
	STS  _set_distance+1,R31
; 0000 0ADB modbus_id = e_modbus_id;
	LDI  R26,LOW(_e_modbus_id)
	LDI  R27,HIGH(_e_modbus_id)
	CALL __EEPROMRDW
	STS  _modbus_id,R30
	STS  _modbus_id+1,R31
; 0000 0ADC modbus_rate = e_modbus_rate;
	LDI  R26,LOW(_e_modbus_rate)
	LDI  R27,HIGH(_e_modbus_rate)
	CALL __EEPROMRDW
	STS  _modbus_rate,R30
	STS  _modbus_rate+1,R31
; 0000 0ADD }
	RET
; .FEND
;
;
;void init(void)
; 0000 0AE1 {// Declare your local variables here
_init:
; .FSTART _init
; 0000 0AE2 
; 0000 0AE3 // Input/Output Ports initialization
; 0000 0AE4 // Port A initialization
; 0000 0AE5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0AE6 // State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P
; 0000 0AE7 PORTA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0AE8 DDRA=0x20;
	LDI  R30,LOW(32)
	OUT  0x1A,R30
; 0000 0AE9 
; 0000 0AEA // Port B initialization
; 0000 0AEB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0AEC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0AED PORTB=0x08;  //pb.3 is bcklight
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 0AEE DDRB=0x08;
	OUT  0x17,R30
; 0000 0AEF 
; 0000 0AF0 // Port C initialization
; 0000 0AF1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0AF2 // State7=0 State6=0 State5=0 State4=1 State3=1 State2=1 State1=1 State0=0
; 0000 0AF3 PORTC=0x1E;
	LDI  R30,LOW(30)
	OUT  0x15,R30
; 0000 0AF4 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0AF5 
; 0000 0AF6 // Port D initialization
; 0000 0AF7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 0AF8 // State7=0 State6=1 State5=0 State4=0 State3=1 State2=T State1=T State0=T
; 0000 0AF9 PORTD=0x4C;
	LDI  R30,LOW(76)
	OUT  0x12,R30
; 0000 0AFA DDRD=0xF8;
	LDI  R30,LOW(248)
	OUT  0x11,R30
; 0000 0AFB 
; 0000 0AFC 
; 0000 0AFD // Timer/Counter 0 initialization
; 0000 0AFE // Clock source: System Clock
; 0000 0AFF // Clock value: Timer 0 Stopped
; 0000 0B00 // Mode: Normal top=FFh
; 0000 0B01 // OC0 output: Disconnected
; 0000 0B02 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0B03 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0B04 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0B05 
; 0000 0B06 // Timer/Counter 1 initialization
; 0000 0B07 // Clock source: System Clock
; 0000 0B08 // Clock value: 11.719 kHz
; 0000 0B09 // Mode: Fast PWM top=0x01FF
; 0000 0B0A // OC1A output: Inverted PWM
; 0000 0B0B // OC1B output: Disconnected
; 0000 0B0C // Noise Canceler: Off
; 0000 0B0D // Input Capture on Falling Edge
; 0000 0B0E // Timer Period: 43.691 ms
; 0000 0B0F // Output Pulse(s):
; 0000 0B10 // OC1A Period: 43.691 ms Width: 21.888 ms
; 0000 0B11 // Timer1 Overflow Interrupt: Off
; 0000 0B12 // Input Capture Interrupt: Off
; 0000 0B13 // Compare A Match Interrupt: Off
; 0000 0B14 // Compare B Match Interrupt: Off
; 0000 0B15 TCCR1A=(1<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(194)
	OUT  0x2F,R30
; 0000 0B16 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 0B17 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0B18 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0B19 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0B1A ICR1L=0x00;
	OUT  0x26,R30
; 0000 0B1B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0B1C OCR1AL=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2A,R30
; 0000 0B1D OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0B1E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0B1F 
; 0000 0B20 // Timer/Counter 2 initialization
; 0000 0B21 // Clock source: System Clock
; 0000 0B22 // Clock value: Timer2 Stopped
; 0000 0B23 // Mode: Normal top=FFh
; 0000 0B24 // OC2 output: Disconnected
; 0000 0B25 ASSR=0x00;
	OUT  0x22,R30
; 0000 0B26 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0B27 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0B28 OCR2=0x00;
	OUT  0x23,R30
; 0000 0B29 
; 0000 0B2A // External Interrupt(s) initialization
; 0000 0B2B // INT0: On
; 0000 0B2C // INT0 Mode: Falling Edge
; 0000 0B2D // INT1: Off
; 0000 0B2E // INT2: Off
; 0000 0B2F GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0B30 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0B31 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0B32 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0B33 
; 0000 0B34 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0B35 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0B36 
; 0000 0B37 
; 0000 0B38 // USART initialization
; 0000 0B39 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0B3A // USART Receiver: On
; 0000 0B3B // USART Transmitter: On
; 0000 0B3C // USART Mode: Asynchronous
; 0000 0B3D // USART Baud Rate: 9600
; 0000 0B3E UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0B3F UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0B40 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0B41 //UBRRH=0x00;    //9600 for 11.0592
; 0000 0B42 //UBRRL=0x47;
; 0000 0B43 
; 0000 0B44 
; 0000 0B45 
; 0000 0B46 //UBRRH=0x00;        //9600 for 12mhz
; 0000 0B47 //UBRRL=0x4D;
; 0000 0B48 
; 0000 0B49 
; 0000 0B4A 
; 0000 0B4B //UBRRH=0x00;    //9600  for 11.0592 baud rate
; 0000 0B4C //UBRRL=0x47;
; 0000 0B4D 
; 0000 0B4E 
; 0000 0B4F //UBRRH=0x00;    //19200  for 11.0592 baud rate
; 0000 0B50 //UBRRL=0x23;
; 0000 0B51 
; 0000 0B52 //UBRRH=0x00;     //38400 for 11.0592 baud rate
; 0000 0B53 //UBRRL=0x11;
; 0000 0B54 
; 0000 0B55 //UBRRH=0x00;     //57600  for 11.0592 baud rate
; 0000 0B56 //UBRRL=0x0B;
; 0000 0B57 
; 0000 0B58 UBRRH=0x00;      //115200 for 11.0592 baud rate
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0B59 UBRRL=0x05;
	LDI  R30,LOW(5)
	OUT  0x9,R30
; 0000 0B5A 
; 0000 0B5B 
; 0000 0B5C 
; 0000 0B5D 
; 0000 0B5E 
; 0000 0B5F // Analog Comparator initialization
; 0000 0B60 // Analog Comparator: Off
; 0000 0B61 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0B62 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0B63 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0B64 
; 0000 0B65 
; 0000 0B66 
; 0000 0B67 // I2C Bus initialization
; 0000 0B68 i2c_init();
	CALL _i2c_init
; 0000 0B69 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0B6A 
; 0000 0B6B // DS1307 Real Time Clock initialization
; 0000 0B6C // Square wave output on pin SQW/OUT: Off
; 0000 0B6D // SQW/OUT pin state: 1
; 0000 0B6E rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rtc_init
; 0000 0B6F 
; 0000 0B70 // LCD module initialization
; 0000 0B71 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0B72 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0B73 mpu6050_init();
	CALL _mpu6050_init
; 0000 0B74 boost_fl =1;
	SET
	BLD  R4,5
; 0000 0B75 float_fl = trickle_fl =0;
	CLT
	BLD  R4,6
	BLD  R4,7
; 0000 0B76 
; 0000 0B77 define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _define_char
; 0000 0B78 // Global enable interrupts
; 0000 0B79 sleep_fl =0;
	CLT
	BLD  R3,7
; 0000 0B7A mb_dir =0;
	CBI  0x12,4
; 0000 0B7B }
	RET
; .FEND
;
;/*
;void WDT_ON()
;{
;
;//    Watchdog timer enables with typical timeout period 2.1
;//    second.
;
;    WDTCR = (1<<WDE)|(1<<WDP2)|(1<<WDP1)|(1<<WDP0);
;}
; */
;void WDT_OFF()
; 0000 0B88 {
_WDT_OFF:
; .FSTART _WDT_OFF
; 0000 0B89     /*
; 0000 0B8A     This function use for disable the watchdog timer.
; 0000 0B8B     */
; 0000 0B8C     WDTCR = (1<<WDTOE)|(1<<WDE);
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 0B8D     WDTCR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x21,R30
; 0000 0B8E }
	RET
; .FEND
;
;
;
;/*
;void check_print(void)
;{
;int i,j=0;
;if(printkey_fl)
;    {
;    lcd_clear();
;    lcd_putsf("printing");
;    lcd_gotoxy(0,1);
;    printkey_fl =0;
;    if (record_cnt>13)
;        {
;            #asm("cli")
;        putchar(0x0a);
;        putchar(0x0d);
;        putsf("angle  target  time     date       PV   chargecur.   batvolt");
;//        putchar(0x0a);
;//        putchar(0x0d);
;        for(i=0;i<=(record_cnt-1);i+=14)
;            {
;            j++;
;            if (j>=15)                                      //lower display printing algo
;                        {
;                        j=0;
;                        lcd_gotoxy(0,1);
;                        lcd_putsf("               ");
;                        lcd_gotoxy(0,1);
;                        }
;            lcd_putchar('.');
;            read_2464(i);
;            delay_ms(200);
;            putchar((record_buffer[0]/10)+48);
;            putchar((record_buffer[0]%10)+48);
;            putchar((record_buffer[1]/10)+48);
;            putchar('.');
;            putchar((record_buffer[1]%10)+48);
;            putchar(' ');
;            putchar(' ');
;
;            putchar((record_buffer[2]/10)+48);
;            putchar((record_buffer[2]%10)+48);
;            putchar((record_buffer[3]/10)+48);
;            putchar('.');
;            putchar((record_buffer[3]%10)+48);
;            putchar(' ');
;            putchar(' ');
;
;            putchar((record_buffer[4]/10)+48);
;            putchar((record_buffer[4]%10)+48);
;            putchar(':');
;            putchar((record_buffer[5]/10)+48);
;            putchar((record_buffer[5]%10)+48);
;            putchar(' ');
;            putchar(' ');
;
;            putchar((record_buffer[6]/10)+48);
;            putchar((record_buffer[6]%10)+48);
;            putchar('-');
;            putchar((record_buffer[7]/10)+48);
;            putchar((record_buffer[7]%10)+48);
;            putchar('-');
;            putchar('2');
;            putchar('0');
;            putchar('1');
;            putchar('3');
;
;            putchar(' ');
;            putchar(' ');
;
;            putchar((record_buffer[8]/10)+48);
;            putchar((record_buffer[8]%10)+48);
;            putchar('.');
;            putchar((record_buffer[9]/10)+48);
;            putchar((record_buffer[9]%10)+48);
;            putchar('V');
;            putchar(' ');
;
;            putchar((record_buffer[10]/10)+48);
;            putchar('.');
;            putchar((record_buffer[10]%10)+48);
;            putchar((record_buffer[11]/10)+48);
;            putchar((record_buffer[11]%10)+48);
;            putchar('A');
;            putchar(' ');
;
;            putchar((record_buffer[12]/10)+48);
;            putchar((record_buffer[12]%10)+48);
;            putchar('.');
;            putchar((record_buffer[13]/10)+48);
;            putchar((record_buffer[13]%10)+48);
;            putchar('V');
;            putchar(' ');
;            putsf(" ");//new line character
;
;            }
;        #asm("sei")
;        lcd_clear();
;//        record_cnt =0;          //reset record count to 00;
;        }
;
;    }
;}
;*/
;
;void print_analog(int a,short int decimal)
; 0000 0BFB {
; 0000 0BFC if (a<0)
;	a -> Y+2
;	decimal -> Y+0
; 0000 0BFD {
; 0000 0BFE putchar('-');
; 0000 0BFF a = -a;
; 0000 0C00 }
; 0000 0C01 else
; 0000 0C02 {
; 0000 0C03 putchar('+');
; 0000 0C04 }
; 0000 0C05 putchar((a/1000)+48);
; 0000 0C06 a =a%1000;
; 0000 0C07 if (decimal == 1) putchar('.');
; 0000 0C08 putchar((a/100)+48);
; 0000 0C09 a = a%100;
; 0000 0C0A if (decimal == 2) putchar('.');
; 0000 0C0B putchar((a/10)+48);
; 0000 0C0C if (decimal ==3) putchar('.');
; 0000 0C0D putchar((a%10)+48);
; 0000 0C0E }
;
;void print_realtime()
; 0000 0C11 {
; 0000 0C12             print_analog(angle,3);
; 0000 0C13  //           putchar('°');
; 0000 0C14             putchar(' ');
; 0000 0C15 
; 0000 0C16             print_analog(target_angle,3);
; 0000 0C17 //            putchar('°');
; 0000 0C18             putchar(' ');
; 0000 0C19 
; 0000 0C1A             print_analog(sun_angle,3);
; 0000 0C1B //            putchar('°');
; 0000 0C1C             putchar(' ');
; 0000 0C1D 
; 0000 0C1E             putchar((hour/10)+48);
; 0000 0C1F             putchar((hour%10)+48);
; 0000 0C20             putchar(':');
; 0000 0C21             putchar((minute/10)+48);
; 0000 0C22             putchar((minute%10)+48);
; 0000 0C23             putchar(' ');
; 0000 0C24             putchar(' ');
; 0000 0C25 
; 0000 0C26             putchar((day/10)+48);
; 0000 0C27             putchar((day%10)+48);
; 0000 0C28             putchar('-');
; 0000 0C29             putchar((month/10)+48);
; 0000 0C2A             putchar((month%10)+48);
; 0000 0C2B             putchar('-');
; 0000 0C2C             putchar('2');
; 0000 0C2D             putchar('0');
; 0000 0C2E             putchar('2');
; 0000 0C2F             putchar('2');
; 0000 0C30 
; 0000 0C31             putchar(' ');
; 0000 0C32             putchar(' ');
; 0000 0C33 
; 0000 0C34 
; 0000 0C35 }
;
;
;void print_data(void)
; 0000 0C39 {
; 0000 0C3A     #asm("cli")
; 0000 0C3B     mb_dir =1;
; 0000 0C3C     delay_ms(100);
; 0000 0C3D     print_realtime();
; 0000 0C3E        putchar(0x0a);
; 0000 0C3F        putchar(0x0d);
; 0000 0C40     #asm("sei")
; 0000 0C41     mb_dir =0;
; 0000 0C42 }
;
;
;
;void panel_movement(void)
; 0000 0C47 {
_panel_movement:
; .FSTART _panel_movement
; 0000 0C48 //int panel_cutoff;
; 0000 0C49 //bit flag_01;
; 0000 0C4A int angle_old;
; 0000 0C4B if(start_fl)
	ST   -Y,R17
	ST   -Y,R16
;	angle_old -> R16,R17
	SBRS R2,5
	RJMP _0x1E4
; 0000 0C4C         {
; 0000 0C4D         OCR1A =20;          // initially set PWM output to zero
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0C4E         pwm_count =0;
	LDI  R30,LOW(0)
	STS  _pwm_count,R30
	STS  _pwm_count+1,R30
; 0000 0C4F         lcd_clear();
	CALL _lcd_clear
; 0000 0C50 if (angle < target_angle)
	LDS  R30,_target_angle
	LDS  R31,_target_angle+1
	LDS  R22,_target_angle+2
	LDS  R23,_target_angle+3
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL __CWD2
	CALL __CPD21
	BRLT PC+2
	RJMP _0x1E5
; 0000 0C51         {
; 0000 0C52         timeout_cnt =0;
	LDI  R30,LOW(0)
	STS  _timeout_cnt,R30
	STS  _timeout_cnt+1,R30
	STS  _timeout_cnt+2,R30
	STS  _timeout_cnt+3,R30
; 0000 0C53         inf_fl =1;
	SET
	BLD  R2,7
; 0000 0C54         angle_old = angle;
	__GETWRMN 16,17,0,_angle
; 0000 0C55 //        panel_cutoff =0;
; 0000 0C56         while(angle < target_angle && inf_fl)
_0x1E6:
	LDS  R30,_target_angle
	LDS  R31,_target_angle+1
	LDS  R22,_target_angle+2
	LDS  R23,_target_angle+3
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL __CWD2
	CALL __CPD21
	BRGE _0x1E9
	SBRC R2,7
	RJMP _0x1EA
_0x1E9:
	RJMP _0x1E8
_0x1EA:
; 0000 0C57                 {
; 0000 0C58 /*
; 0000 0C59   // check routine for low voltage . if battery voltage drops below
; 0000 0C5A   // 10.8V, then display low battery indication. if it recovers within 20 seconds
; 0000 0C5B   // then, get back, else break.
; 0000 0C5C                 if (adc_battery < cutoff_voltage)
; 0000 0C5D                 panel_cutoff++;
; 0000 0C5E                 else
; 0000 0C5F                 panel_cutoff =0;        //reset
; 0000 0C60 
; 0000 0C61                 if (panel_cutoff > 100 && panel_cutoff < 5000) //15 seconds
; 0000 0C62                         {
; 0000 0C63                         lcd_gotoxy(0,1);
; 0000 0C64                         lcd_putsf("!!LOW BATTERY!!");
; 0000 0C65                         flag_01 =1;
; 0000 0C66 //                        delay_ms(500);
; 0000 0C67                         }
; 0000 0C68                         else
; 0000 0C69                         flag_01 =0; // to display low battery only
; 0000 0C6A 
; 0000 0C6B                 if (panel_cutoff > 5000)
; 0000 0C6C                         {
; 0000 0C6D                         lcd_clear();
; 0000 0C6E                         err_fl =1;
; 0000 0C6F 
; 0000 0C70                         lcd_putsf("LOW BATTERY");
; 0000 0C71                         lcd_gotoxy(0,1);
; 0000 0C72                         lcd_putsf("!!!ERROR!!!    ");
; 0000 0C73                         relay1=relay2 =0;
; 0000 0C74                         delay_ms(2000);
; 0000 0C75                         err_fl =0;
; 0000 0C76                         inf_fl =0;  // break while loop
; 0000 0C77                          }
; 0000 0C78 */
; 0000 0C79 /////////////////////////////////////////////////////////////////////
; 0000 0C7A  //               delay_ms(1);
; 0000 0C7B  //               adc_buffer = adc3421_read();
; 0000 0C7C                 #asm("wdr")
	wdr
; 0000 0C7D                 pwm_count++;
	LDI  R26,LOW(_pwm_count)
	LDI  R27,HIGH(_pwm_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0C7E                 if(pwm_count >200)
	LDS  R26,_pwm_count
	LDS  R27,_pwm_count+1
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRLO _0x1EB
; 0000 0C7F                     {
; 0000 0C80                     pwm_count =0;
	LDI  R30,LOW(0)
	STS  _pwm_count,R30
	STS  _pwm_count+1,R30
; 0000 0C81                     OCR1A+=2;
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,2
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0C82                     if (OCR1A >500)
	IN   R30,0x2A
	IN   R31,0x2A+1
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRLO _0x1EC
; 0000 0C83                         {
; 0000 0C84                         OCR1A =500;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0C85                         }
; 0000 0C86                     }
_0x1EC:
; 0000 0C87                 read_adc();
_0x1EB:
	CALL _read_adc
; 0000 0C88                 cal_angle();
	RCALL _cal_angle
; 0000 0C89                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0C8A                 lcd_putsf("ang: ");
	__POINTW2FN _0x0,392
	CALL _lcd_putsf
; 0000 0C8B                 display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0C8C                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0C8D 
; 0000 0C8E                 lcd_putsf("tar: ");
	__POINTW2FN _0x0,398
	CALL _lcd_putsf
; 0000 0C8F                 display_angle(target_angle);
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	CALL _display_angle
; 0000 0C90 
; 0000 0C91                 relay1=0;
	CBI  0x12,7
; 0000 0C92                 relay2=1;
	SBI  0x15,0
; 0000 0C93                 timeout_cnt++;
	LDI  R26,LOW(_timeout_cnt)
	LDI  R27,HIGH(_timeout_cnt)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0C94                 if(timeout_cnt >100000)      //once every 30 seconds
	LDS  R26,_timeout_cnt
	LDS  R27,_timeout_cnt+1
	LDS  R24,_timeout_cnt+2
	LDS  R25,_timeout_cnt+3
	__CPD2N 0x186A1
	BRLT _0x1F1
; 0000 0C95                         {
; 0000 0C96                         timeout_cnt =0;
	LDI  R30,LOW(0)
	STS  _timeout_cnt,R30
	STS  _timeout_cnt+1,R30
	STS  _timeout_cnt+2,R30
	STS  _timeout_cnt+3,R30
; 0000 0C97                         if (!((angle < angle_old - 20) || (angle > angle_old +20)))
	MOVW R30,R16
	SBIW R30,20
	LDS  R26,_angle
	LDS  R27,_angle+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x1F3
	MOVW R30,R16
	ADIW R30,20
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1F4
_0x1F3:
	RJMP _0x1F2
_0x1F4:
; 0000 0C98                             {
; 0000 0C99                             lcd_clear();
	CALL _lcd_clear
; 0000 0C9A                             err_fl =1;
	SET
	BLD  R3,5
; 0000 0C9B                             led3 =0;
	CBI  0x12,6
; 0000 0C9C                             lcd_putsf("mech. error");
	__POINTW2FN _0x0,404
	CALL _lcd_putsf
; 0000 0C9D                             relay1=relay2 =0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0C9E                             delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0C9F                             err_fl =0;
	CLT
	BLD  R3,5
; 0000 0CA0                             led3  =1;
	SBI  0x12,6
; 0000 0CA1                             inf_fl =0;  // break while loop
	BLD  R2,7
; 0000 0CA2                             }
; 0000 0CA3                         else
	RJMP _0x1FD
_0x1F2:
; 0000 0CA4                             {
; 0000 0CA5                             angle_old = angle;
	__GETWRMN 16,17,0,_angle
; 0000 0CA6                             }
_0x1FD:
; 0000 0CA7                         }
; 0000 0CA8 
; 0000 0CA9                 if(!key1)
_0x1F1:
	SBIC 0x19,0
	RJMP _0x1FE
; 0000 0CAA                     {
; 0000 0CAB                     inf_fl =0;        //emergency stop movement by pressing enter key
	CLT
	BLD  R2,7
; 0000 0CAC                     relay1=relay2=0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0CAD                     }
; 0000 0CAE                 }
_0x1FE:
	RJMP _0x1E6
_0x1E8:
; 0000 0CAF         start_fl =0;
	CLT
	BLD  R2,5
; 0000 0CB0         end_fl =1;
	SET
	BLD  R2,6
; 0000 0CB1         relay1=relay2=0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0CB2         }
; 0000 0CB3 else if (angle > target_angle +20)     //hysterisis of 2 degrees before action
	RJMP _0x207
_0x1E5:
	LDS  R30,_target_angle
	LDS  R31,_target_angle+1
	LDS  R22,_target_angle+2
	LDS  R23,_target_angle+3
	__ADDD1N 20
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL __CWD2
	CALL __CPD12
	BRLT PC+2
	RJMP _0x208
; 0000 0CB4         {
; 0000 0CB5         timeout_cnt =0;
	LDI  R30,LOW(0)
	STS  _timeout_cnt,R30
	STS  _timeout_cnt+1,R30
	STS  _timeout_cnt+2,R30
	STS  _timeout_cnt+3,R30
; 0000 0CB6         inf_fl =1;
	SET
	BLD  R2,7
; 0000 0CB7         angle_old = angle;
	__GETWRMN 16,17,0,_angle
; 0000 0CB8  //       panel_cutoff =0;
; 0000 0CB9         while(angle > target_angle && inf_fl)
_0x209:
	LDS  R30,_target_angle
	LDS  R31,_target_angle+1
	LDS  R22,_target_angle+2
	LDS  R23,_target_angle+3
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL __CWD2
	CALL __CPD12
	BRGE _0x20C
	SBRC R2,7
	RJMP _0x20D
_0x20C:
	RJMP _0x20B
_0x20D:
; 0000 0CBA                 {
; 0000 0CBB /*
; 0000 0CBC   // check routine for low voltage . if battery voltage drops below
; 0000 0CBD   // 10.8V, then display low battery indication. if it recovers within 20 seconds
; 0000 0CBE   // then, get back, else break.
; 0000 0CBF                 if (adc_battery < cutoff_voltage)
; 0000 0CC0                 panel_cutoff++;
; 0000 0CC1                 else
; 0000 0CC2                 panel_cutoff =0;        //reset
; 0000 0CC3 
; 0000 0CC4                 if (panel_cutoff > 100 && panel_cutoff < 5000) //15 seconds
; 0000 0CC5                         {
; 0000 0CC6                         lcd_gotoxy(0,1);
; 0000 0CC7                         lcd_putsf("!!LOW BATTERY!!");
; 0000 0CC8                         flag_01 =1;
; 0000 0CC9 //                        delay_ms(500);
; 0000 0CCA                         }
; 0000 0CCB                 else
; 0000 0CCC                         flag_01 =0;
; 0000 0CCD                 if (panel_cutoff > 5000)
; 0000 0CCE                         {
; 0000 0CCF                         panel_cutoff =0;
; 0000 0CD0                         lcd_clear();
; 0000 0CD1                         err_fl =1;
; 0000 0CD2                         lcd_putsf("LOW BATTERY");
; 0000 0CD3                         lcd_gotoxy(0,1);
; 0000 0CD4                         lcd_putsf("!!!ERROR!!!    ");
; 0000 0CD5                         relay1=relay2 =0;
; 0000 0CD6                         delay_ms(2000);
; 0000 0CD7                         err_fl =0;
; 0000 0CD8                         inf_fl =0;  // break while loop
; 0000 0CD9                          }
; 0000 0CDA */
; 0000 0CDB /////////////////////////////////////////////////////////////////////
; 0000 0CDC //                delay_ms(1);
; 0000 0CDD //                adc_buffer = adc3421_read();
; 0000 0CDE                 #asm("wdr")
	wdr
; 0000 0CDF                 pwm_count++;
	LDI  R26,LOW(_pwm_count)
	LDI  R27,HIGH(_pwm_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0CE0                 if(pwm_count >200)
	LDS  R26,_pwm_count
	LDS  R27,_pwm_count+1
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRLO _0x20E
; 0000 0CE1                     {
; 0000 0CE2                     pwm_count =0;
	LDI  R30,LOW(0)
	STS  _pwm_count,R30
	STS  _pwm_count+1,R30
; 0000 0CE3                     OCR1A+=2;
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,2
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0CE4                     if (OCR1A >500)
	IN   R30,0x2A
	IN   R31,0x2A+1
	CPI  R30,LOW(0x1F5)
	LDI  R26,HIGH(0x1F5)
	CPC  R31,R26
	BRLO _0x20F
; 0000 0CE5                         {
; 0000 0CE6                         OCR1A =500;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0CE7                         }
; 0000 0CE8                     }
_0x20F:
; 0000 0CE9                 read_adc();
_0x20E:
	CALL _read_adc
; 0000 0CEA                 cal_angle();
	CALL _cal_angle
; 0000 0CEB                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0CEC                 lcd_putsf("ang: ");
	__POINTW2FN _0x0,392
	CALL _lcd_putsf
; 0000 0CED                 display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0CEE                 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0CEF 
; 0000 0CF0                 lcd_putsf("tar: ");
	__POINTW2FN _0x0,398
	CALL _lcd_putsf
; 0000 0CF1                 display_angle(target_angle);
	LDS  R26,_target_angle
	LDS  R27,_target_angle+1
	CALL _display_angle
; 0000 0CF2 
; 0000 0CF3                 relay1=1;
	SBI  0x12,7
; 0000 0CF4                 relay2=0;
	CBI  0x15,0
; 0000 0CF5                 timeout_cnt++;
	LDI  R26,LOW(_timeout_cnt)
	LDI  R27,HIGH(_timeout_cnt)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0CF6                 if(timeout_cnt >100000)
	LDS  R26,_timeout_cnt
	LDS  R27,_timeout_cnt+1
	LDS  R24,_timeout_cnt+2
	LDS  R25,_timeout_cnt+3
	__CPD2N 0x186A1
	BRLT _0x214
; 0000 0CF7                         {
; 0000 0CF8                         timeout_cnt =0;
	LDI  R30,LOW(0)
	STS  _timeout_cnt,R30
	STS  _timeout_cnt+1,R30
	STS  _timeout_cnt+2,R30
	STS  _timeout_cnt+3,R30
; 0000 0CF9                         if (!((angle < angle_old - 20) || (angle > angle_old +20)))
	MOVW R30,R16
	SBIW R30,20
	LDS  R26,_angle
	LDS  R27,_angle+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x216
	MOVW R30,R16
	ADIW R30,20
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x217
_0x216:
	RJMP _0x215
_0x217:
; 0000 0CFA                             {
; 0000 0CFB                              lcd_clear();
	CALL _lcd_clear
; 0000 0CFC                             err_fl =1;
	SET
	BLD  R3,5
; 0000 0CFD                             led3 =0;
	CBI  0x12,6
; 0000 0CFE                             lcd_putsf("mech. error");
	__POINTW2FN _0x0,404
	CALL _lcd_putsf
; 0000 0CFF                             relay1=relay2 =0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0D00                             delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0D01                             err_fl =0;
	CLT
	BLD  R3,5
; 0000 0D02                             led3 =1;
	SBI  0x12,6
; 0000 0D03                             inf_fl =0;  // break while loop
	BLD  R2,7
; 0000 0D04                             }
; 0000 0D05                         else
	RJMP _0x220
_0x215:
; 0000 0D06                             {
; 0000 0D07                             angle_old = angle;
	__GETWRMN 16,17,0,_angle
; 0000 0D08                             }
_0x220:
; 0000 0D09 
; 0000 0D0A                         }
; 0000 0D0B                 if(!key1)
_0x214:
	SBIC 0x19,0
	RJMP _0x221
; 0000 0D0C                     {
; 0000 0D0D                     inf_fl =0;        //emergency stop movement by pressing enter key
	CLT
	BLD  R2,7
; 0000 0D0E                     relay1=relay2=0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0D0F                     }
; 0000 0D10 
; 0000 0D11 
; 0000 0D12                 }
_0x221:
	RJMP _0x209
_0x20B:
; 0000 0D13         start_fl =0;
	CLT
	BLD  R2,5
; 0000 0D14         end_fl =1;
	SET
	BLD  R2,6
; 0000 0D15         relay1=relay2=0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0D16 //        print_data();
; 0000 0D17         }
; 0000 0D18 else
	RJMP _0x22A
_0x208:
; 0000 0D19         start_fl =0;
	CLT
	BLD  R2,5
; 0000 0D1A 
; 0000 0D1B         end_fl =1;
_0x22A:
_0x207:
	SET
	BLD  R2,6
; 0000 0D1C         relay1=relay2=0;
	CBI  0x15,0
	CBI  0x12,7
; 0000 0D1D //        #asm("cli")
; 0000 0D1E //        write_2464(record_cnt,angle/100,angle%100,target_angle/100,target_angle%100,hour,minute,day,month,adc_pvolt/10 ...
; 0000 0D1F //        #asm("sei")
; 0000 0D20         record_cnt =0;
	LDI  R26,LOW(_record_cnt)
	LDI  R27,HIGH(_record_cnt)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0D21         }
; 0000 0D22 }
_0x1E4:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;/*
;void error_check()
;{
;if (adc_pvolt < 1000 || adc_battery <300)
;err_fl1 = 1;
;else
;err_fl1=0;
;if (adc_battery < cutoff_voltage)
;err_fl2 =1;
;if(err_fl2 && adc_battery > reconnect_voltage)//hysterisis for reconnect
;err_fl2 =0;
;}
;*/
;void led_check()
; 0000 0D33 {
_led_check:
; .FSTART _led_check
; 0000 0D34 led2=~relay1;
	SBIS 0x12,7
	RJMP _0x22F
	CBI  0x15,4
	RJMP _0x230
_0x22F:
	SBI  0x15,4
_0x230:
; 0000 0D35 led1=~relay2;
	SBIS 0x15,0
	RJMP _0x231
	CBI  0x12,3
	RJMP _0x232
_0x231:
	SBI  0x12,3
_0x232:
; 0000 0D36 led4 = led5 = led6 = 1;   // turn battery related leds off
	SBI  0x15,2
	SBI  0x15,1
	SBI  0x15,3
; 0000 0D37 
; 0000 0D38 if (err_fl )
	SBRS R3,5
	RJMP _0x239
; 0000 0D39 led3 =0;
	CBI  0x12,6
; 0000 0D3A else
	RJMP _0x23C
_0x239:
; 0000 0D3B 
; 0000 0D3C led3 =1;
	SBI  0x12,6
; 0000 0D3D /*
; 0000 0D3E         if (!err_fl1)
; 0000 0D3F             {
; 0000 0D40             if (boost_fl)
; 0000 0D41             led4 =0;
; 0000 0D42             else if (float_fl)
; 0000 0D43             led4 = led_blinkfl;
; 0000 0D44             else
; 0000 0D45             led4 =1;
; 0000 0D46             led5= ~trickle_fl;
; 0000 0D47           }
; 0000 0D48         else
; 0000 0D49             {
; 0000 0D4A             led4 = led5 =1;
; 0000 0D4B             }
; 0000 0D4C        if (adc_battery < cutoff_voltage) led6 =0;       //low battery indication
; 0000 0D4D        else led6 =1;
; 0000 0D4E */
; 0000 0D4F }
_0x23C:
	RET
; .FEND
;
;
;
;
;/*
;void print_control()
;{
;char data;
;while (rx_counter)                     //receive buffer is not empty
;{
;data = getchar();
;switch (data)
;            {
;            case 'p':   printkey_fl =1;
;                        delay_ms(100);
;                        break;
;            case 'r':   putsf("no. of records stored :");
;                        print_analog(record_cnt/14,0);
;                        putsf(" ");
;                        break;
;            case 's':   record_cnt =0;
;                        putsf("records reset!!!");
;                        break;
;            case 'v':   putsf("Panel voltage:");
;                        print_analog(adc_pvolt,2);
;                        putchar('V');
;                        putsf(" ");
;                        break;
;            case 'b':   putsf("Battery voltage:");
;                        print_analog(adc_battery,2);
;                        putchar('V');
;                        putsf(" ");
;                        break;
;            case 'c':   putsf("charge current:");
;                        print_analog(adc_chargecurrent,2);
;                        putchar('A');
;                        putsf(" ");
;                        break;
;            case 'l':   log_fl=1;
;                        putsf("angle  target  time     date       PV   current  batvolt");
;                        putsf("logging started...");
;                        break;
;            case 'm':   log_fl=0;
;                        putsf("logging stopped");
;                        break;
;            default:    break;
;              }
;}
;}
;*/
;
;
;
;
;void rtc_reset(void)
; 0000 0D87 {
_rtc_reset:
; .FSTART _rtc_reset
; 0000 0D88 //rtc_get_time(&hour,&minute,&second);
; 0000 0D89 //rtc_get_date(&week,&day,&month,&year);
; 0000 0D8A 
; 0000 0D8B if (hour>23 || second > 59)
	LDI  R30,LOW(23)
	CP   R30,R7
	BRLO _0x240
	LDI  R30,LOW(59)
	CP   R30,R9
	BRSH _0x23F
_0x240:
; 0000 0D8C {
; 0000 0D8D #asm("cli");
	cli
; 0000 0D8E rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rtc_init
; 0000 0D8F delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0D90 rtc_set_date(e_week,e_day,e_month,e_year);
	LDI  R26,LOW(_e_week)
	LDI  R27,HIGH(_e_week)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_e_day)
	LDI  R27,HIGH(_e_day)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_e_month)
	LDI  R27,HIGH(_e_month)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_e_year)
	LDI  R27,HIGH(_e_year)
	CALL __EEPROMRDB
	MOV  R26,R30
	CALL _rtc_set_date
; 0000 0D91 rtc_set_time(e_hour,e_minute,e_second);
	LDI  R26,LOW(_e_hour)
	LDI  R27,HIGH(_e_hour)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_e_minute)
	LDI  R27,HIGH(_e_minute)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_e_second)
	LDI  R27,HIGH(_e_second)
	CALL __EEPROMRDB
	MOV  R26,R30
	CALL _rtc_set_time
; 0000 0D92 #asm("sei");
	sei
; 0000 0D93 }
; 0000 0D94 }
_0x23F:
	RET
; .FEND
;
;/*
;void WDT_off(void)
;{
;// reset WDT
;#asm("wdr")
;// Write logical one to WDTOE and WDE
;WDTCR |= (1<<4) | (1<<3);
;// Turn off WDT
;WDTCR = 0x00;
;}
;*/
;void main(void)
; 0000 0DA2 {
_main:
; .FSTART _main
; 0000 0DA3 // Declare your local variables here
; 0000 0DA4 #asm("cli")
	cli
; 0000 0DA5 WDT_OFF();
	RCALL _WDT_OFF
; 0000 0DA6 //#asm ("sei")
; 0000 0DA7 
; 0000 0DA8 init();
	RCALL _init
; 0000 0DA9 // Global enable interrupts
; 0000 0DAA #asm("sei")
	sei
; 0000 0DAB delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 0DAC rtc_get_time(&hour,&minute,&second);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL _rtc_get_time
; 0000 0DAD rtc_get_date(&week,&day,&month,&year);   //pdi is weekday not used only for cvavr2.05
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	CALL _rtc_get_date
; 0000 0DAE if (hour>24 || second>59)
	LDI  R30,LOW(24)
	CP   R30,R7
	BRLO _0x243
	LDI  R30,LOW(59)
	CP   R30,R9
	BRSH _0x242
_0x243:
; 0000 0DAF {
; 0000 0DB0 rtc_reset();
	RCALL _rtc_reset
; 0000 0DB1 }
; 0000 0DB2 else
	RJMP _0x245
_0x242:
; 0000 0DB3 {
; 0000 0DB4 //if valid rtc data, store the data in eeprom for backup
; 0000 0DB5 e_hour = hour;
	MOV  R30,R7
	LDI  R26,LOW(_e_hour)
	LDI  R27,HIGH(_e_hour)
	CALL __EEPROMWRB
; 0000 0DB6 e_minute = minute;
	MOV  R30,R6
	LDI  R26,LOW(_e_minute)
	LDI  R27,HIGH(_e_minute)
	CALL __EEPROMWRB
; 0000 0DB7 e_second = second;
	MOV  R30,R9
	LDI  R26,LOW(_e_second)
	LDI  R27,HIGH(_e_second)
	CALL __EEPROMWRB
; 0000 0DB8 e_day = day;
	MOV  R30,R11
	LDI  R26,LOW(_e_day)
	LDI  R27,HIGH(_e_day)
	CALL __EEPROMWRB
; 0000 0DB9 e_month = month;
	MOV  R30,R10
	LDI  R26,LOW(_e_month)
	LDI  R27,HIGH(_e_month)
	CALL __EEPROMWRB
; 0000 0DBA e_year = year;
	MOV  R30,R13
	LDI  R26,LOW(_e_year)
	LDI  R27,HIGH(_e_year)
	CALL __EEPROMWRB
; 0000 0DBB }
_0x245:
; 0000 0DBC 
; 0000 0DBD //WDT_ON();
; 0000 0DBE calibuser = calibfact =0;
	CLT
	BLD  R5,1
	BLD  R5,0
; 0000 0DBF //if (!key1 && key2 && key3 && key4) calibuser =1;
; 0000 0DC0 if (key1 && key2 && !key3 && !key4) calibfact =1;
	SBIS 0x19,0
	RJMP _0x247
	SBIS 0x19,1
	RJMP _0x247
	SBIC 0x19,2
	RJMP _0x247
	SBIS 0x19,3
	RJMP _0x248
_0x247:
	RJMP _0x246
_0x248:
	SET
	BLD  R5,1
; 0000 0DC1 lcd_clear();
_0x246:
	CALL _lcd_clear
; 0000 0DC2 if (!calibfact)
	SBRC R5,1
	RJMP _0x249
; 0000 0DC3 {
; 0000 0DC4 lcd_putsf("* SINGLE AXIS  *");
	__POINTW2FN _0x0,416
	CALL _lcd_putsf
; 0000 0DC5 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0DC6 lcd_putsf("*SOLAR TRACKER *");
	__POINTW2FN _0x0,433
	CALL _lcd_putsf
; 0000 0DC7 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0DC8 lcd_clear();
	CALL _lcd_clear
; 0000 0DC9 lcd_putsf("*   PLEASE     *");
	__POINTW2FN _0x0,450
	CALL _lcd_putsf
; 0000 0DCA lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0DCB lcd_putsf("*    WAIT      *");
	__POINTW2FN _0x0,467
	CALL _lcd_putsf
; 0000 0DCC delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0DCD }
; 0000 0DCE if(calibuser)
_0x249:
	SBRS R5,0
	RJMP _0x24A
; 0000 0DCF {
; 0000 0DD0 lcd_putsf("the panel ");
	__POINTW2FN _0x0,484
	CALL _lcd_putsf
; 0000 0DD1 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0DD2 lcd_putsf("calibration mode");
	__POINTW2FN _0x0,495
	CALL _lcd_putsf
; 0000 0DD3 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0DD4 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0DD5 lcd_putsf("inc > inch up");
	__POINTW2FN _0x0,512
	CALL _lcd_putsf
; 0000 0DD6 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0DD7 lcd_putsf("dec > inch down");
	__POINTW2FN _0x0,526
	CALL _lcd_putsf
; 0000 0DD8 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0DD9 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0DDA lcd_putsf("set-> enter low");
	__POINTW2FN _0x0,542
	CALL _lcd_putsf
; 0000 0DDB lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0DDC lcd_putsf("shf-> enter high");
	__POINTW2FN _0x0,558
	CALL _lcd_putsf
; 0000 0DDD delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0DDE }
; 0000 0DDF if(calibfact)
_0x24A:
	SBRS R5,1
	RJMP _0x24B
; 0000 0DE0 {
; 0000 0DE1 lcd_putsf("adc: ");
	__POINTW2FN _0x0,575
	CALL _lcd_putsf
; 0000 0DE2 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0DE3 lcd_putsf("angle:");
	__POINTW2FN _0x0,324
	CALL _lcd_putsf
; 0000 0DE4 }
; 0000 0DE5 
; 0000 0DE6 
; 0000 0DE7 OCR1A = 0x13f;
_0x24B:
	LDI  R30,LOW(319)
	LDI  R31,HIGH(319)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0DE8 //rtc_set_time(12,13,26);
; 0000 0DE9 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0DEA eeprom_transfer();
	RCALL _eeprom_transfer
; 0000 0DEB while (1)
_0x24C:
; 0000 0DEC {
; 0000 0DED #asm("wdr")             //reset watchdog timer
	wdr
; 0000 0DEE 
; 0000 0DEF 
; 0000 0DF0 if (sleep_fl ==1)
	SBRC R3,7
; 0000 0DF1 {
; 0000 0DF2 //sleep_enable();
; 0000 0DF3 //idle();
; 0000 0DF4 //delay_ms(500);
; 0000 0DF5 }
; 0000 0DF6 else
	RJMP _0x250
; 0000 0DF7 {
; 0000 0DF8 sleep_disable();
	CALL _sleep_disable
; 0000 0DF9         get_key();
	CALL _get_key
; 0000 0DFA //        ir_cnt++;
; 0000 0DFB //        if(ir_cnt>500)
; 0000 0DFC //        {
; 0000 0DFD //        ir_cnt =0;
; 0000 0DFE //        get_irkey();
; 0000 0DFF //        }
; 0000 0E00         if (modbus_fl)
	SBRS R5,3
	RJMP _0x251
; 0000 0E01             {
; 0000 0E02             modbus_fl =0;
	CLT
	BLD  R5,3
; 0000 0E03             mb_datatransfer();
	CALL _mb_datatransfer
; 0000 0E04             check_mbreceived();
	CALL _check_mbreceived
; 0000 0E05  //           delay_ms(100);
; 0000 0E06 //            mb_dir =0;      //set to receieve
; 0000 0E07             }
; 0000 0E08 //normal run mode with configuration setting and real time display on power on.
; 0000 0E09     if(!calibuser || !calibfact )
_0x251:
	SBRS R5,0
	RJMP _0x253
	SBRC R5,1
	RJMP _0x252
_0x253:
; 0000 0E0A      {
; 0000 0E0B          rtc_reset();
	RCALL _rtc_reset
; 0000 0E0C         led_check();
	RCALL _led_check
; 0000 0E0D         led2 = ~relay1;
	SBIS 0x12,7
	RJMP _0x255
	CBI  0x15,4
	RJMP _0x256
_0x255:
	SBI  0x15,4
_0x256:
; 0000 0E0E         led1 = ~relay2;
	SBIS 0x15,0
	RJMP _0x257
	CBI  0x12,3
	RJMP _0x258
_0x257:
	SBI  0x12,3
_0x258:
; 0000 0E0F         check_mode();
	CALL _check_mode
; 0000 0E10         read_adc();
	CALL _read_adc
; 0000 0E11         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0E12         target_cal();
	CALL _target_cal
; 0000 0E13         check_increment();
	CALL _check_increment
; 0000 0E14         check_decrement();
	CALL _check_decrement
; 0000 0E15         check_shift();
	CALL _check_shift
; 0000 0E16         check_enter();
	CALL _check_enter
; 0000 0E17         blink_control();
	CALL _blink_control
; 0000 0E18         display_cnt++;
	LDI  R26,LOW(_display_cnt)
	LDI  R27,HIGH(_display_cnt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0E19 //        if(print_fl)
; 0000 0E1A //            {
; 0000 0E1B //            print_fl =0;
; 0000 0E1C //            print_data();
; 0000 0E1D //            }
; 0000 0E1E         if (display_cnt > 100)
	LDS  R26,_display_cnt
	LDS  R27,_display_cnt+1
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLO _0x259
; 0000 0E1F                 {
; 0000 0E20                 display_cnt =0;
	LDI  R30,LOW(0)
	STS  _display_cnt,R30
	STS  _display_cnt+1,R30
; 0000 0E21                 display_update();
	CALL _display_update
; 0000 0E22                 cal_angle();
	CALL _cal_angle
; 0000 0E23                 }
; 0000 0E24 
; 0000 0E25         if (mode==0 && !manual_fl ) panel_movement();
_0x259:
	LDS  R26,_mode
	LDS  R27,_mode+1
	SBIW R26,0
	BRNE _0x25B
	SBRS R5,2
	RJMP _0x25C
_0x25B:
	RJMP _0x25A
_0x25C:
	RCALL _panel_movement
; 0000 0E26         if (manual_fl)
_0x25A:
	SBRS R5,2
	RJMP _0x25D
; 0000 0E27         {
; 0000 0E28             OCR1A = 500;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0E29             relay1 = ~key2;
	SBIS 0x19,1
	RJMP _0x25E
	CBI  0x12,7
	RJMP _0x25F
_0x25E:
	SBI  0x12,7
_0x25F:
; 0000 0E2A             relay2 = ~key3;
	SBIS 0x19,2
	RJMP _0x260
	CBI  0x15,0
	RJMP _0x261
_0x260:
	SBI  0x15,0
_0x261:
; 0000 0E2B         }
; 0000 0E2C      }
_0x25D:
; 0000 0E2D 
; 0000 0E2E 
; 0000 0E2F /////////////////////////////////////////////////////////
; 0000 0E30 
; 0000 0E31 
; 0000 0E32 //calibration mode for user to set start and end angles
; 0000 0E33     if(calibuser)
_0x252:
	SBRS R5,0
	RJMP _0x262
; 0000 0E34     {
; 0000 0E35     lcd_clear();
	CALL _lcd_clear
; 0000 0E36     delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0E37     lcd_putsf("Set Start Angle");
	__POINTW2FN _0x0,581
	CALL _lcd_putsf
; 0000 0E38     while(key4)
_0x263:
	SBIS 0x19,3
	RJMP _0x265
; 0000 0E39     {
; 0000 0E3A //    get_irkey();
; 0000 0E3B     get_key();
	CALL _get_key
; 0000 0E3C     delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0E3D //        error_check();
; 0000 0E3E 
; 0000 0E3F //    lcd_gotoxy(0,0);
; 0000 0E40 //    lcd_putsf("Set Start Angle")
; 0000 0E41 
; 0000 0E42 //    put_message(zero_adc);
; 0000 0E43 //    lcd_putsf("   ");
; 0000 0E44 //    put_message(span_adc);
; 0000 0E45     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E46     lcd_putsf("angle:");
	__POINTW2FN _0x0,324
	CALL _lcd_putsf
; 0000 0E47 //    adc_buffer = adc3421_read();
; 0000 0E48     read_adc();
	CALL _read_adc
; 0000 0E49     relay1 = ~key2;
	SBIS 0x19,1
	RJMP _0x266
	CBI  0x12,7
	RJMP _0x267
_0x266:
	SBI  0x12,7
_0x267:
; 0000 0E4A     relay2 = ~key3;
	SBIS 0x19,2
	RJMP _0x268
	CBI  0x15,0
	RJMP _0x269
_0x268:
	SBI  0x15,0
_0x269:
; 0000 0E4B //    key2_fl = key3_fl =0;
; 0000 0E4C     cal_angle();
	CALL _cal_angle
; 0000 0E4D     display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0E4E     }
	RJMP _0x263
_0x265:
; 0000 0E4F     e_low_angle = low_angle = angle;
	LDS  R30,_angle
	LDS  R31,_angle+1
	STS  _low_angle,R30
	STS  _low_angle+1,R31
	LDI  R26,LOW(_e_low_angle)
	LDI  R27,HIGH(_e_low_angle)
	CALL __EEPROMWRW
; 0000 0E50     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0E51     lcd_putsf("start angle ");
	__POINTW2FN _0x0,597
	CALL _lcd_putsf
; 0000 0E52     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E53     lcd_putsf("accepted!");
	__POINTW2FN _0x0,610
	CALL _lcd_putsf
; 0000 0E54     delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 0E55 
; 0000 0E56     lcd_clear();
	CALL _lcd_clear
; 0000 0E57     lcd_putsf("Set End Angle");
	__POINTW2FN _0x0,620
	CALL _lcd_putsf
; 0000 0E58     while(key1)
_0x26A:
	SBIS 0x19,0
	RJMP _0x26C
; 0000 0E59     {
; 0000 0E5A //    get_irkey();
; 0000 0E5B     get_key();
	CALL _get_key
; 0000 0E5C     delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0E5D //        error_check();
; 0000 0E5E 
; 0000 0E5F     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E60     lcd_putsf("angle:");
	__POINTW2FN _0x0,324
	CALL _lcd_putsf
; 0000 0E61 //    adc_buffer = adc3421_read();
; 0000 0E62     read_adc();
	CALL _read_adc
; 0000 0E63     relay1 = ~key2;
	SBIS 0x19,1
	RJMP _0x26D
	CBI  0x12,7
	RJMP _0x26E
_0x26D:
	SBI  0x12,7
_0x26E:
; 0000 0E64     relay2 = ~key3;
	SBIS 0x19,2
	RJMP _0x26F
	CBI  0x15,0
	RJMP _0x270
_0x26F:
	SBI  0x15,0
_0x270:
; 0000 0E65 //    key2_fl = key3_fl =0;
; 0000 0E66     cal_angle();
	CALL _cal_angle
; 0000 0E67     display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0E68     }
	RJMP _0x26A
_0x26C:
; 0000 0E69     e_high_angle = high_angle = angle;
	LDS  R30,_angle
	LDS  R31,_angle+1
	STS  _high_angle,R30
	STS  _high_angle+1,R31
	LDI  R26,LOW(_e_high_angle)
	LDI  R27,HIGH(_e_high_angle)
	CALL __EEPROMWRW
; 0000 0E6A     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0E6B     lcd_putsf("end angle ");
	__POINTW2FN _0x0,634
	CALL _lcd_putsf
; 0000 0E6C     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E6D     lcd_putsf("accepted! ");
	__POINTW2FN _0x0,645
	CALL _lcd_putsf
; 0000 0E6E     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0E6F     calibuser =0;
	CLT
	BLD  R5,0
; 0000 0E70     lcd_clear();
	CALL _lcd_clear
; 0000 0E71     }
; 0000 0E72 ////////////////////////////////////////////////////////////////////
; 0000 0E73 
; 0000 0E74 
; 0000 0E75 
; 0000 0E76  // factory setting for inclinometer and pv/current input calibration.
; 0000 0E77 
; 0000 0E78    if(calibfact)
_0x262:
	SBRS R5,1
	RJMP _0x271
; 0000 0E79     {
; 0000 0E7A     record_cnt=0;   //reset record count for printing
	LDI  R26,LOW(_record_cnt)
	LDI  R27,HIGH(_record_cnt)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0E7B     lcd_clear();
	CALL _lcd_clear
; 0000 0E7C     mux1 =1;
	SBI  0x15,5
; 0000 0E7D     mux2 =0;
	CBI  0x15,6
; 0000 0E7E     mux3 =1;
	SBI  0x15,7
; 0000 0E7F     delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 0E80     while(key2)
_0x278:
	SBIS 0x19,1
	RJMP _0x27A
; 0000 0E81     {
; 0000 0E82     adc_buffer = mpu6050_read();
	CALL _mpu6050_read
	CALL __CWD1
	STS  _adc_buffer,R30
	STS  _adc_buffer+1,R31
	STS  _adc_buffer+2,R22
	STS  _adc_buffer+3,R23
; 0000 0E83     cal_angle();
	CALL _cal_angle
; 0000 0E84     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0E85     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0E86     lcd_putsf("adc: ");
	__POINTW2FN _0x0,575
	CALL _lcd_putsf
; 0000 0E87     put_message(adc_buffer);
	LDS  R26,_adc_buffer
	LDS  R27,_adc_buffer+1
	LDS  R24,_adc_buffer+2
	LDS  R25,_adc_buffer+3
	CALL _put_message
; 0000 0E88     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E89     lcd_putsf("angle: ");
	__POINTW2FN _0x0,287
	CALL _lcd_putsf
; 0000 0E8A     display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0E8B     }
	RJMP _0x278
_0x27A:
; 0000 0E8C     e_zero_adc = zero_adc = adc_buffer;
	LDS  R30,_adc_buffer
	LDS  R31,_adc_buffer+1
	LDS  R22,_adc_buffer+2
	LDS  R23,_adc_buffer+3
	STS  _zero_adc,R30
	STS  _zero_adc+1,R31
	STS  _zero_adc+2,R22
	STS  _zero_adc+3,R23
	LDI  R26,LOW(_e_zero_adc)
	LDI  R27,HIGH(_e_zero_adc)
	CALL __EEPROMWRD
; 0000 0E8D     lcd_clear();
	CALL _lcd_clear
; 0000 0E8E     lcd_putsf("zero angle ");
	__POINTW2FN _0x0,656
	CALL _lcd_putsf
; 0000 0E8F     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E90     lcd_putsf("accepted! ");
	__POINTW2FN _0x0,645
	CALL _lcd_putsf
; 0000 0E91     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0E92     lcd_clear();
	CALL _lcd_clear
; 0000 0E93     delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 0E94     while(key1)
_0x27B:
	SBIS 0x19,0
	RJMP _0x27D
; 0000 0E95     {
; 0000 0E96     adc_buffer = mpu6050_read();
	CALL _mpu6050_read
	CALL __CWD1
	STS  _adc_buffer,R30
	STS  _adc_buffer+1,R31
	STS  _adc_buffer+2,R22
	STS  _adc_buffer+3,R23
; 0000 0E97     cal_angle();
	CALL _cal_angle
; 0000 0E98     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0E99     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0E9A     lcd_putsf("adc: ");
	__POINTW2FN _0x0,575
	CALL _lcd_putsf
; 0000 0E9B     put_message(adc_buffer);
	LDS  R26,_adc_buffer
	LDS  R27,_adc_buffer+1
	LDS  R24,_adc_buffer+2
	LDS  R25,_adc_buffer+3
	CALL _put_message
; 0000 0E9C     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0E9D     lcd_putsf("angle: ");
	__POINTW2FN _0x0,287
	CALL _lcd_putsf
; 0000 0E9E     display_angle(angle);
	LDS  R26,_angle
	LDS  R27,_angle+1
	CALL _display_angle
; 0000 0E9F     }
	RJMP _0x27B
_0x27D:
; 0000 0EA0     e_span_adc = span_adc = adc_buffer;
	LDS  R30,_adc_buffer
	LDS  R31,_adc_buffer+1
	LDS  R22,_adc_buffer+2
	LDS  R23,_adc_buffer+3
	STS  _span_adc,R30
	STS  _span_adc+1,R31
	STS  _span_adc+2,R22
	STS  _span_adc+3,R23
	LDI  R26,LOW(_e_span_adc)
	LDI  R27,HIGH(_e_span_adc)
	CALL __EEPROMWRD
; 0000 0EA1     lcd_clear();
	CALL _lcd_clear
; 0000 0EA2     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0EA3     lcd_putsf("span angle ");
	__POINTW2FN _0x0,668
	CALL _lcd_putsf
; 0000 0EA4     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0EA5     lcd_putsf("accepted! ");
	__POINTW2FN _0x0,645
	CALL _lcd_putsf
; 0000 0EA6     delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 0EA7     calibfact =0;
	CLT
	BLD  R5,1
; 0000 0EA8     lcd_clear();
	CALL _lcd_clear
; 0000 0EA9     }
; 0000 0EAA ///////////////////////////////////////////////
; 0000 0EAB 
; 0000 0EAC 
; 0000 0EAD     }
_0x271:
_0x250:
; 0000 0EAE     }; //end of while loop
	RJMP _0x24C
; 0000 0EAF 
; 0000 0EB0 }
_0x27E:
	RJMP _0x27E
; .FEND
;

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	JMP  _0x2120004
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	JMP  _0x2120004
; .FEND
_sin:
; .FSTART _sin
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	__GETD1N 0x3E22F983
	CALL __MULF12
	__PUTD1S 5
	__GETD2S 5
	RCALL _floor
	__GETD2S 5
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 5
	__GETD2S 5
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000017
	__GETD1S 5
	__GETD2N 0x3F000000
	CALL __SUBF12
	__PUTD1S 5
	LDI  R17,LOW(1)
_0x2000017:
	__GETD2S 5
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000018
	__GETD1N 0x3F000000
	CALL __SUBF12
	__PUTD1S 5
_0x2000018:
	CPI  R17,0
	BREQ _0x2000019
	__GETD1S 5
	CALL __ANEGF1
	__PUTD1S 5
_0x2000019:
	__GETD1S 5
	__GETD2S 5
	CALL __MULF12
	__PUTD1S 1
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL __SWAPD12
	CALL __SUBF12
	__GETD2S 1
	CALL __MULF12
	__GETD2N 0x4104534C
	CALL __ADDF12
	__GETD2S 5
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	__GETD2S 1
	CALL __MULF12
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x2120007
; .FEND
_cos:
; .FSTART _cos
	CALL __PUTPARD2
	CALL __GETD2S0
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	JMP  _0x2120004
; .FEND
_tan:
; .FSTART _tan
	CALL __PUTPARD2
	SBIW R28,4
	__GETD2S 4
	RCALL _cos
	CALL __PUTD1S0
	CALL __CPD10
	BRNE _0x200001A
	__GETD2S 4
	CALL __CPD02
	BRGE _0x200001B
	__GETD1N 0x7F7FFFFF
	JMP  _0x2120005
_0x200001B:
	__GETD1N 0xFF7FFFFF
	JMP  _0x2120005
_0x200001A:
	__GETD2S 4
	RCALL _sin
	MOVW R26,R30
	MOVW R24,R22
	CALL __GETD1S0
	CALL __DIVF21
	JMP  _0x2120005
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	__GETD1S 4
	__GETD2S 4
	CALL __MULF12
	CALL __PUTD1S0
	__GETD2N 0x40CBD065
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	__GETD2S 4
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL __GETD1S0
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL __GETD2S0
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	JMP  _0x2120005
; .FEND
_yatan:
; .FSTART _yatan
	CALL __PUTPARD2
	CALL __GETD2S0
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2000020
	RCALL _xatan
	JMP  _0x2120004
_0x2000020:
	CALL __GETD2S0
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RCALL _xatan
	__GETD2N 0x3FC90FDB
	CALL __SWAPD12
	CALL __SUBF12
	JMP  _0x2120004
_0x2000021:
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	JMP  _0x2120004
; .FEND
_asin:
; .FSTART _asin
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	__GETD1N 0xBF800000
	CALL __CMPF12
	BRLO _0x2000023
	__GETD1N 0x3F800000
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x2000023
	RJMP _0x2000022
_0x2000023:
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120007
_0x2000022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2000025
	__GETD1S 5
	CALL __ANEGF1
	__PUTD1S 5
	LDI  R17,LOW(1)
_0x2000025:
	__GETD1S 5
	__GETD2S 5
	CALL __MULF12
	__GETD2N 0x3F800000
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _sqrt
	__PUTD1S 1
	__GETD2S 5
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000026
	__GETD1S 5
	__GETD2S 1
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	__GETD2N 0x3FC90FDB
	CALL __SWAPD12
	CALL __SUBF12
	RJMP _0x2000035
_0x2000026:
	__GETD1S 1
	__GETD2S 5
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
_0x2000035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2000028
	CALL __ANEGF1
	RJMP _0x2120007
_0x2000028:
	__GETD1S 1
_0x2120007:
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
_atan:
; .FSTART _atan
	CALL __PUTPARD2
	LDD  R26,Y+3
	TST  R26
	BRMI _0x200002C
	CALL __GETD2S0
	RCALL _yatan
	JMP  _0x2120004
_0x200002C:
	CALL __GETD1S0
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	CALL __ANEGF1
	JMP  _0x2120004
; .FEND
_atan2:
; .FSTART _atan2
	CALL __PUTPARD2
	SBIW R28,4
	__GETD1S 4
	CALL __CPD10
	BRNE _0x200002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x200002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120006
_0x200002E:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x2120006
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x2120006
_0x200002D:
	__GETD1S 4
	__GETD2S 8
	CALL __DIVF21
	CALL __PUTD1S0
	__GETD2S 4
	CALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	CALL __GETD2S0
	RCALL _yatan
	RJMP _0x2120006
_0x2000031:
	CALL __GETD1S0
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	CALL __ANEGF1
	RJMP _0x2120006
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	CALL __GETD1S0
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	__GETD2N 0x40490FDB
	CALL __SWAPD12
	CALL __SUBF12
	RJMP _0x2120006
_0x2000032:
	CALL __GETD2S0
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x2120006:
	ADIW R28,12
	RET
; .FEND

	.CSEG

	.CSEG
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_sleep_disable:
; .FSTART _sleep_disable
   in   r30,power_ctrl_reg
   cbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2080003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2080003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2080004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2080004:
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _i2c_write
	CALL _i2c_stop
	JMP  _0x2120002
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(0)
	CALL _i2c_write
	CALL _i2c_stop
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(0)
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	CALL _i2c_stop
	JMP  _0x2120002
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(3)
	CALL _i2c_write
	CALL _i2c_stop
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	CALL _i2c_stop
_0x2120005:
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	CALL _i2c_write
	CALL _i2c_stop
_0x2120004:
	ADIW R28,4
	RET
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G105:
; .FSTART __lcd_delay_G105
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G105
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G105
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G105
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G105
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G105:
; .FSTART __lcd_write_nibble_G105
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G105
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G105
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G105
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G105
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2120001
; .FEND
_lcd_write_byte:
; .FSTART _lcd_write_byte
	ST   -Y,R26
	CALL __lcd_ready
	LDD  R26,Y+1
	RCALL __lcd_write_data
	CALL __lcd_ready
    sbi   __lcd_port,__lcd_rs     ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
	RJMP _0x2120003
; .FEND
__lcd_read_nibble_G105:
; .FSTART __lcd_read_nibble_G105
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G105
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G105
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G105:
; .FSTART _lcd_read_byte0_G105
	CALL __lcd_delay_G105
	RCALL __lcd_read_nibble_G105
    mov   r26,r30
	RCALL __lcd_read_nibble_G105
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G105)
	SBCI R31,HIGH(-__base_y_G105)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x20A0004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x20A0004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2120001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x20A0008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20A000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x20A0008
_0x20A000A:
	LDD  R17,Y+0
_0x2120002:
	ADIW R28,3
	RET
; .FEND
__long_delay_G105:
; .FSTART __long_delay_G105
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G105:
; .FSTART __lcd_init_write_G105
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G105
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2120001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G105,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G105,3
	RCALL __long_delay_G105
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G105
	RCALL __long_delay_G105
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G105
	RCALL __long_delay_G105
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G105
	RCALL __long_delay_G105
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G105
	RCALL __long_delay_G105
	LDI  R26,LOW(40)
	CALL __lcd_write_data
	RCALL __long_delay_G105
	LDI  R26,LOW(4)
	CALL __lcd_write_data
	RCALL __long_delay_G105
	LDI  R26,LOW(133)
	CALL __lcd_write_data
	RCALL __long_delay_G105
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G105
	CPI  R30,LOW(0x5)
	BREQ _0x20A000B
	LDI  R30,LOW(0)
	RJMP _0x2120001
_0x20A000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2120001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.DSEG
_pi:
	.BYTE 0x4
_degs:
	.BYTE 0x4
_rads:
	.BYTE 0x4
_L:
	.BYTE 0x4
_g:
	.BYTE 0x4
_sundia:
	.BYTE 0x4
_airrefr:
	.BYTE 0x4
_settm:
	.BYTE 0x4
_riset:
	.BYTE 0x4
_daytime:
	.BYTE 0x4
_sunrise_min:
	.BYTE 0x4
_sunset_min:
	.BYTE 0x4
_adc_buffer:
	.BYTE 0x4
_timeout_cnt:
	.BYTE 0x4
_target_angle:
	.BYTE 0x4
_sun_angle:
	.BYTE 0x4
_printkeycnt:
	.BYTE 0x4
_calibusercnt:
	.BYTE 0x4
_program_timeout:
	.BYTE 0x4
_mode:
	.BYTE 0x2
_set:
	.BYTE 0x2
_item1:
	.BYTE 0x2
_bright_cnt:
	.BYTE 0x2
_mode0_seqcnt:
	.BYTE 0x2
_end_cnt:
	.BYTE 0x2
_sleep_counter:
	.BYTE 0x2
_time_cnt:
	.BYTE 0x2
_time_cnt1:
	.BYTE 0x2
_pwm_count:
	.BYTE 0x2
_mode1_count:
	.BYTE 0x2
_blink_count:
	.BYTE 0x2
_display_cnt:
	.BYTE 0x2
_manual_cnt:
	.BYTE 0x2
_blink_locy:
	.BYTE 0x1
_blink_data:
	.BYTE 0x1
_set_latit:
	.BYTE 0x2
_set_longitude:
	.BYTE 0x2
_low_angle:
	.BYTE 0x2
_high_angle:
	.BYTE 0x2
_time_interval:
	.BYTE 0x2
_target_time:
	.BYTE 0x2
_time_elap:
	.BYTE 0x2
_set_timezone:
	.BYTE 0x2
_zero_adc:
	.BYTE 0x4
_span_adc:
	.BYTE 0x4
_char_latitude:
	.BYTE 0x1
_char_longitude:
	.BYTE 0x1
_char_timezone:
	.BYTE 0x1
_char_width:
	.BYTE 0x1
_char_distance:
	.BYTE 0x1
_char_id:
	.BYTE 0x1
_char_rate:
	.BYTE 0x1

	.ESEG
_e_set_latit:
	.DB  0x5A,0xA
_e_set_longitude:
	.DB  0xD4,0x1C
_e_low_angle:
	.DB  0x70,0xFE
_e_high_angle:
	.DB  0x90,0x1
_e_time_interval:
	.DB  0x5,0x0
_e_set_timezone:
	.DB  0x26,0x2
_e_zero_adc:
	.DB  0x0,0x0,0x0,0x0
_e_span_adc:
	.DB  0x20,0x4E,0x0,0x0

	.ORG 0x20
_record_cnt:
	.DB  0x0,0x0

	.ORG 0x14
_e_hour:
	.DB  0xC
_e_minute:
	.DB  0x0
_e_second:
	.DB  0x0
_e_week:
	.DB  0x1
_e_month:
	.DB  0x6
_e_day:
	.DB  0x1
_e_year:
	.DB  0x13

	.DSEG
_x_angle:
	.BYTE 0x2
_y_angle:
	.BYTE 0x2
_z_angle:
	.BYTE 0x2
_pitch:
	.BYTE 0x2
_roll:
	.BYTE 0x2
_angle:
	.BYTE 0x2
_Gyrox:
	.BYTE 0x2
_Gyroy:
	.BYTE 0x2
_Gyroz:
	.BYTE 0x2
_angle_filt:
	.BYTE 0x8
_set_distance:
	.BYTE 0x2
_set_width:
	.BYTE 0x2
_modbus_id:
	.BYTE 0x2
_modbus_rate:
	.BYTE 0x2

	.ESEG
_e_set_width:
	.DB  0xA,0x0
_e_set_distance:
	.DB  0x14,0x0

	.ORG 0x22
_e_modbus_id:
	.DB  0xD,0x0
_e_modbus_rate:
	.DB  0x1,0x0

	.DSEG
_new_target:
	.BYTE 0x2
_b_factor:
	.BYTE 0x2
_gangle:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x14
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_mbreceived_data:
	.BYTE 0xA
_tx_buffer:
	.BYTE 0x30
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
_mb_data:
	.BYTE 0x28
_mb_inputdata:
	.BYTE 0xA
__seed_G102:
	.BYTE 0x4
__base_y_G105:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG

	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	rcall __PUTPARD2
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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

;END OF CODE MARKER
__END_OF_CODE:
