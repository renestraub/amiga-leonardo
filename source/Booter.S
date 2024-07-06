**************************************************************************
*                                                                        *
*             T H E   B O O T B L O C K   (PC-relativ!)                  *
*                                                                        *
*  Last update: 28-Jan-89  CHW  Adapted from RingSide booter             *
*                                                                        *
**************************************************************************
ADDRESS:	EQU	$72000			; Adresse vom ModStarter
SIZE:		EQU	$1000			; muß durch 512 aufgehen
		org	$50000
		load	$50000
		blk.l	256,'CHW!'
		org	$50000
		load	$50000
block:		dc.b	'DOS',0			; Identification
		dc.l	0			; Bootblock-Checksum
		dc.l	880			; Pointer to root-block
o:		movem.l	d1-d7/a1-a6,-(SP)
		move.l	a1,a4			; A4 :  IO-Request
		move.l	4.w,a6			; A6 :  AbsExecBase
	; *** Bootblock nach ORG verschieben damit LineMixer's JMPs gehen
CopyBlock:	lea	block(PC),a0
		lea	$50000,a1
		moveq	#1024/16,d0		; Lattice C lässt grüßen
		lsl.l	#4,d0
		jsr	-624(a6)		; CopyMem()

; ******* START OF MIXED BLOCK #1 *******

	JMP     B01L000
B01L009:
		move.l	d0,546(a6)		; KickMemPtr
	JMP     B01L00a
	DC.W    $23f0
B01L01a:
		rts
	JMP     B01L01b
B01L00f:
		jsr	-204(a6)		; AllocAbs()
	JMP     B01L010
	DC.W    $cf6f
	DC.W    $23f5
B01L017:
		lea	4(a2),a0		; Einsprung
	JMP     B01L018
	DC.W    $1c97
	DC.W    $7276
B01L010:
		tst.l	d0
	JMP     B01L011
	DC.W    $23ff
B01L015:
		move.l	a4,a1			; IO-Request
	JMP     B01L016
B01L014:
		movem.l	d2/a2/a3,36(a4)		; Länge, Adresse, Offset
	JMP     B01L015
B01L00d:
		move.l	a2,a1			; Adresse
	BRA     B01L00e
	DC.W    $23fe
B01L00a:
		move.l	d0,550(a6)		; KickTagPtr
	JMP     B01L00b
	DC.W    $c259
	DC.W    $1daf
B01L00b:
		move.l	d0,554(a6)		; KickCheckSum
	BRA     B01L00c
B01L01d:
		move.w	#$41f,$dff180		; blau
	BRA     B01L01e
	DC.W    $23fd
B01L012:
	; *** ModStarterer einlesen
	JMP     B01L013
	DC.W    $9265
B01L006:
		move.l	d0,42(a6)		; ColdCapture
	JMP     B01L007
	DC.W    $23f5
B01L011:
		beq	error			; No Mem --->
	BRA     B01L012
	DC.W    $dbd3
B01L004:
		move.l	d0,$180(a5)		; Farben 0 & 1
	JMP     B01L005
	DC.W    $dc71
	DC.W    $82a9
	DC.W    $c68e
	DC.W    $23f4
B01L001:
		movem.l	regs(PC),d2/a2/a3/a5
	JMP     B01L002
B01L01e:
		lea	$fc00d0,a5
	BRA     B01L01f
	DC.W    $23f2
B01L01f:
		move.l	d0,38(a6)		; ChkBase
	JMP     B01L020
	DC.W    $23fe
B01L005:
	; *** Alle Captures und Residentmodule rauswerfen
	JMP     B01L006
	DC.W    $6834
	DC.W    $23f8
B01L018:
		moveq	#0,d0			; Success
	BRA     B01L019
	DC.W    $23f4
B01L019:
		movem.l	(SP)+,d1-d7/a1-a6
	JMP     B01L01a
	DC.W    $74d0
	DC.W    $23f8
B01L00c:
	; *** Speicher für ModStarter reservieren
	JMP     B01L00d
	DC.W    $23f2
B01L008:
		move.l	d0,50(a6)		; WarmCapture
	JMP     B01L009
B01L00e:
		move.l	d2,d0			; Size
	BRA     B01L00f
	DC.W    $23fd
B01L021:
		jsr	-30(a6)			; Supervisor()
	BRA     B01L022
B01L016:
		jsr	-456(a6)		; DoIO()
	JMP     B01L017
B01L020:
		move.w	d0,82(a6)		; CheckSum
	BRA     B01L021
	DC.W    $3efe
	DC.W    $d5e9
	DC.W    $6acd
B01L002:
		move.w	#$018f,$096(a5)		; BitPlane & Audio DMA off
	BRA     B01L003
	DC.W    $37f6
	DC.W    $23f4
B01L003:
		moveq	#0,d0
	BRA     B01L004
	DC.W    $23f8
B01L007:
		move.l	d0,46(a6)		; CoolCapture
	BRA     B01L008
	DC.W    $c430
	DC.W    $739b
B01L01b:
	; *** Fehler-Einsprung
	BRA     B01L01c
	DC.W    $de33
	DC.W    $8ab3
	DC.W    $3e3b
	DC.W    $018d
B01L013:
		move.w	#2,28(a4)		; CMD_Read
	BRA     B01L014
	DC.W    $75b7
	DC.W    $39a1
	DC.W    $23f5
B01L01c:
error:		move.l	4.w,a6
	JMP     B01L01d
	DC.W    $d29e
	DC.W    $23fa
B01L000:
	; *** Register initialisieren, Bildschirm schwarz
	BRA     B01L001
	DC.W    $d553
	DC.W    $23fe
B01L022:

; ******* END OF MIXED BLOCK #1 *******

regs:		dc.l	SIZE			; D2 :  Size
		dc.l	ADDRESS			; A2 :  Adresse des Laders
		dc.l	1024			; A3 :  Disk-Offset
		dc.l	$dff000			; A5 :  Custom
		dc.l	65530,19536		; Kennung,Product-Code
DiskName:	dc.b	"disk.resource",0
		dc.b	"romboot.library",0
		dc.b	"mathieee.resource",0,0,0
		dc.b	"AMIGA HIGH DENSITY DISK FORMAT. "
		dc.b	"(C) 1988 BY CHRISTIAN A. WEBER, "
		dc.b	"THE MEGA-MIGHTY AMIGA WIZARD !! ",0,0
		dc.b	"HEY, PIRATE! IF YOU CRACK THIS G"
		dc.b	"AME, PLEASE SEND ME A COPY OF TH"
		dc.b	"E CRACKED VERSION! (IF YOU'RE A "
		dc.b	"REAL INSIDER, YOU KNOW MY ADDRES"
		dc.b	"S...) BUT ANYWAY, THIS PROTECTIO"
		dc.b	"N IS MUCH TOO SOPHISTICATED FOR "
		dc.b	"YOU!",0,0
		dc.b	"GREETINGS -chw",0
		dc.b	0,0,0,0,0,0,0,0
