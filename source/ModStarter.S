**************************************************************************
**                                                                      **
**   ModStarter.S - Init Disk, lädt Leonardo-Demo und Game etc.         **
**                                                                      **
**************************************************************************
**                                                                      **
**   Modification History                                               **
**   --------------------                                               **
**                                                                      **
**   25-Aug-88   Created this file!                                     **
**   19-Oct-88   Changed from Dugger to RingSide                        **
**   28-Jan-89   Changed from RingSide to Leonardo                      **
**   29-Jan-89   Last update                                            **
**                                                                      **
**************************************************************************
		INCLUDE	"exec.i"
		INCLUDE	"execbase.i"
		INCLUDE	"copper.i"
		INCLUDE	"relcustom.i"
		INCLUDE	"filenames.i"
		XREF	_InitDisk,_ReadFile
BOOTPICADDR:	EQU	$68000
PLANESIZE:	EQU	8000
DEPTH:		EQU	5		; 6=Halfbrite
INTROADDR:	EQU	$c0
GAMEADDR:	EQU	$100
		dc.b	"CHW!"

; ******* START OF MIXED BLOCK #1 *******

	JMP     B01L000
B01L03d:
		bne	Reset
	BRA     B01L03e
	DC.W    $735a
	DC.W    $17b8
	DC.W    $23f7
B01L004:
		move.w	#$7fff,intena(a4)	; ALLE Interrupts off
	JMP     B01L005
	DC.W    $23f2
B01L060:
		move.w	(a1),d0 	; 1. Farbe holen
	JMP     B01L061
	DC.W    $92ed
	DC.W    $23f5
B01L069:
		move.w	(a0)+,d1	; Endzustand
	JMP     B01L06a
B01L038:
		lea	$1000,a0
	BRA     B01L039
	DC.W    $23f7
B01L00e:
		moveq	#1,d1			; 1 Drive
	BRA     B01L00f
	DC.W    $429b
	DC.W    $23f7
B01L05e:
		addi.w	#$100,d2
	BRA     B01L05f
	DC.W    $26cd
	DC.W    $914e
	DC.W    $7306
	DC.W    $0f42
B01L06d:
		beq	blueok		; ja, nichts ändern
	JMP     B01L06e
B01L020:
NoIntro:
	BRA     B01L021
	DC.W    $95e0
	DC.W    $23f1
B01L04e:
		move.w	#0,(a1)+
	JMP     B01L04f
B01L030:
		move.l	#$4ed04ed0,d0		; 2x JMP (a0)
	JMP     B01L031
	DC.W    $9c63
	DC.W    $23fc
B01L035:
**************************************************************************
	JMP     B01L036
	DC.W    $3ad6
	DC.W    $ce18
B01L047:
		clr.l	spr+sprdata(a4)
	BRA     B01L048
	DC.W    $1737
	DC.W    $23f1
B01L034:
TrackDiskName:	dc.b	"trackdisk.device",0
	JMP     B01L035
	DC.W    $4528
	DC.W    $9e21
	DC.W    $7b8f
B01L042:
	*** Lade-Bild anzeigen
	BRA     B01L043
	DC.W    $23ff
B01L044:
		move.l	#FN_BOOTBILD,d0
	JMP     B01L045
B01L07c:
		bne	vsync
	BRA     B01L07d
	DC.W    $7007
B01L073:
		lea	ColorPalette,a0
	JMP     B01L074
	DC.W    $281f
	DC.W    $23f3
B01L072:
		bsr	vsync
	BRA     B01L073
	DC.W    $23f3
B01L076:
.colloop2:	move.w	(a0)+,(a1)+
	BRA     B01L077
	DC.W    $4796
	DC.W    $23f3
B01L066:
		addi.w	#$010,d0
	JMP     B01L067
	DC.W    $d0ab
B01L04c:
		moveq	#31,d0
	JMP     B01L04d
	DC.W    $94aa
	DC.W    $6e9f
B01L007:
		lea	supie(PC),a5
	BRA     B01L008
B01L04b:
		lea	color(a4),a1
	JMP     B01L04c
	DC.W    $6a66
	DC.W    $5b5a
B01L07e:
DoDelay:	move.w	#5000,d0
	JMP     B01L07f
B01L040:
		jmp	(a1)			; Programm-Modul starten
	JMP     B01L041
	DC.W    $e92c
	DC.W    $7c10
	DC.W    $23ff
B01L008:
		jsr	-30(a6)
	JMP     B01L009
	DC.W    $2424
B01L054:
		lea	BOOTPICADDR+DEPTH*PLANESIZE,a2	; Farbtabelle
	BRA     B01L055
	DC.W    $6507
	DC.W    $26b6
	DC.W    $b7c2
B01L02e:
		lea	$fc00d0,a0		; Reset-Routine
	JMP     B01L02f
	DC.W    $121c
	DC.W    $b448
	DC.W    $23f4
B01L016:
		or.l	eb_WarmCapture(a6),d0
	JMP     B01L017
	DC.W    $23fb
B01L000:
		lea	custom,a4		; A4 :  Custom (global!)
	BRA     B01L001
	DC.W    $748e
	DC.W    $23f0
B01L029:
Reset:		move.w	#$7fff,$dff09a		; Interrupts off
	JMP     B01L02a
B01L04d:
.clearloop:	clr.w	(a0)+			; 32 Farben löschen
	BRA     B01L04e
	DC.W    $23f9
B01L019:
		bne	Reset
	JMP     B01L01a
	DC.W    $70ef
	DC.W    $329c
B01L02a:
		move.w	#$7fff,$dff096		; DMA off
	BRA     B01L02b
B01L006:
		movea.l	(a6),a6			; A6 :  ExecBase
	JMP     B01L007
	DC.W    $3efe
	DC.W    $d5e9
	DC.W    $6acd
B01L06b:
		andi.w	#$00f,d1	; -"-
	JMP     B01L06c
	DC.W    $85ff
B01L03e:
		move.l	#$10293847,d0		; Magic für A0 gültig
	BRA     B01L03f
	DC.W    $474e
	DC.W    $23f8
B01L049:
		move.w	copjmp1(a4),d0
	BRA     B01L04a
	DC.W    $414a
	DC.W    $e28c
B01L067:
greenok:	or.w	d0,d2		; sichern
	JMP     B01L068
	DC.W    $1690
	DC.W    $b536
	DC.W    $23fb
B01L014:
		move.l	eb_ColdCapture(a6),d0
	JMP     B01L015
	DC.W    $23fa
B01L011:
	*** Ladebild anzeigen
	BRA     B01L012
	DC.W    $0ef9
	DC.W    $23f6
B01L048:
		move.l	#CopperList,cop1lc(a4)
	JMP     B01L049
	DC.W    $00ad
	DC.W    $36b6
B01L01c:
		beq.s	NoIntro				; ja ---> Kein Intro
	JMP     B01L01d
	DC.W    $e235
	DC.W    $b28e
	DC.W    $37ad
	DC.W    $23f6
B01L023:
		move.l	#FN_GAME.ABS,d1
	BRA     B01L024
	DC.W    $1a0c
B01L06c:
		cmp.w	d0,d1		; schon erreicht?
	BRA     B01L06d
	DC.W    $185a
	DC.W    $1c06
	DC.W    $0dcb
	DC.W    $68de
B01L02c:
		Exec	Supervisor
	BRA     B01L02d
	DC.W    $23ff
B01L07d:
		rts
	BRA     B01L07e
	DC.W    $5b06
	DC.W    $dc7f
B01L03a:
		movea.l	a1,a0			; Ladeadresse
	JMP     B01L03b
B01L013:
	*** Testen ob Resetvektoren verbogen, ggf. COLD-Reset
	BRA     B01L014
	DC.W    $82e7
B01L064:
		cmp.w	d0,d1		; schon erreicht?
	BRA     B01L065
	DC.W    $7765
	DC.W    $23f1
B01L05d:
		beq	redok		; ja, nichts ändern
	JMP     B01L05e
	DC.W    $23f4
B01L00d:
		move.w	#PRODUCT,d0
	BRA     B01L00e
	DC.W    $c0a8
	DC.W    $929f
	DC.W    $6e52
	DC.W    $23f5
B01L01b:
		btst.b	#6,$bfe001			; Linke Maustaste ?
	BRA     B01L01c
	DC.W    $2383
	DC.W    $23f9
B01L061:
		move.w	(a0),d1 	; Endzustand
	BRA     B01L062
	DC.W    $12df
B01L00a:
		move.w	#$8200,dmacon(a4)	; MASTER DMA on
	JMP     B01L00b
	DC.W    $847e
	DC.W    $0c82
	DC.W    $23f0
B01L080:
		dbeq	d0,DoDe1		; Wie dbf, Verarschung
	BRA     B01L081
B01L027:
		bra	gugg
	BRA     B01L028
	DC.W    $cc93
	DC.W    $23f2
B01L015:
		or.l	eb_CoolCapture(a6),d0
	JMP     B01L016
	DC.W    $23f5
B01L078:
		dbf	d3,inloop1
	BRA     B01L079
B01L036:
	*** D0 bytes ab A1 reservieren, Modul laden und starten, freigeben
	BRA     B01L037
	DC.W    $23fc
B01L001:
		suba.l	a6,a6
	JMP     B01L002
	DC.W    $68f3
	DC.W    $61cf
B01L00b:
		bsr	DoDelay
	BRA     B01L00c
B01L03f:
		lea	MFMBuffer,a0		; MFM-Buffer
	JMP     B01L040
	DC.W    $01f4
	DC.W    $66c5
	DC.W    $23f4
B01L003:
		jsr	DoDelay(PC)
	BRA     B01L004
	DC.W    $23fd
B01L03b:
		move.l	d1,d0			; Filename
	BRA     B01L03c
	DC.W    $bde2
	DC.W    $09d0
	DC.W    $7134
B01L056:
		lea	ColorPalette,a1		; Ziel-Palette
	JMP     B01L057
B01L062:
		andi.w	#$0f0,d0	; mittleren Schieber isolieren
	BRA     B01L063
	DC.W    $8ca0
	DC.W    $23f8
B01L052:
	*** Bild langsam einblenden mit Farbtabelle (A0)
	BRA     B01L053
	DC.W    $5f66
	DC.W    $cfeb
	DC.W    $8049
B01L005:
		move.w	#$7fff,dmacon(a4)	; PLANE|COPER|SPRITE|AUDIO OFF
	JMP     B01L006
	DC.W    $23fe
B01L065:
		beq	greenok		; ja, nichts ändern
	JMP     B01L066
	DC.W    $12b2
B01L03c:
		jsr	_ReadFile(PC)
	JMP     B01L03d
B01L070:
		move.w	d2,(a1)+	; abspeichern
	BRA     B01L071
	DC.W    $23a6
	DC.W    $23fc
B01L074:
		lea	color(a4),a1
	BRA     B01L075
	DC.W    $02b9
B01L06e:
		addq.w	#$001,d0
	BRA     B01L06f
	DC.W    $23fc
B01L07f:
DoDe1:		tst.l	(a6)
	BRA     B01L080
	DC.W    $c4a1
	DC.W    $04a0
B01L037:
DoMod:		move.l	#(BOOTPICADDR-$1000)/4-1,d0
	JMP     B01L038
	DC.W    $23f3
B01L010:
		bsr	_InitDisk
	JMP     B01L011
B01L053:
		moveq	#15,d3			; Anzahl mögliche Grauwerte
	JMP     B01L054
	DC.W    $23f7
B01L075:
		moveq	#31,d0		; 32 Farben
	BRA     B01L076
	DC.W    $5fd9
	DC.W    $e84a
	DC.W    $23fb
B01L02d:
Supie:		move	#$2700,sr
	BRA     B01L02e
B01L068:
		move.w	(a1),d0 	; 1. Farbe holen
	BRA     B01L069
B01L06f:
blueok:		or.w	d0,d2		; sichern
	JMP     B01L070
B01L022:
		lea	GAMEADDR,a1
	JMP     B01L023
	DC.W    $23f6
B01L031:
		move.l	#$22c060fc,0		; l:move.l d0,(a1)+, bra.s l
	BRA     B01L032
	DC.W    $5f34
	DC.W    $0e79
B01L01f:
		bsr	DoMod
	JMP     B01L020
	DC.W    $94fa
	DC.W    $083e
	DC.W    $23fd
B01L059:
		move.w	(a0),d1 	; Endzustand
	BRA     B01L05a
B01L043:
ShowLoadPic:	movem.l	d1-d7/a0-a6,-(SP)
	BRA     B01L044
B01L046:
		bsr	_ReadFile
	BRA     B01L047
	DC.W    $dc85
B01L05b:
		andi.w	#$f00,d1	; -"-
	JMP     B01L05c
B01L01d:
		lea	INTROADDR,a1
	BRA     B01L01e
	DC.W    $23f8
B01L033:
		jmp	0
	BRA     B01L034
	DC.W    $1407
B01L039:
		bsr	DoClear			; GANZEN Speicher löschen
	BRA     B01L03a
	DC.W    $c00a
	DC.W    $23f6
B01L009:
supie:		lea	$80000,SP
	JMP     B01L00a
	DC.W    $e545
	DC.W    $6371
	DC.W    $e996
	DC.W    $7038
B01L028:
	*** Resetten (hellgrün), bei 68020er mit Cache Total-Alles-Absturz
	JMP     B01L029
	DC.W    $23fd
B01L018:
		tst.l	d0
	BRA     B01L019
	DC.W    $3024
B01L077:
		dbf	d0,.colloop2
	JMP     B01L078
	DC.W    $0b65
	DC.W    $23f6
B01L04f:
		dbf	d0,.clearloop
	JMP     B01L050
	DC.W    $23f6
B01L025:
gugg:		move.w	d0,$dff180
	JMP     B01L026
	DC.W    $51a1
	DC.W    $95cb
B01L045:
		lea	BOOTPICADDR,a0
	JMP     B01L046
	DC.W    $e8c2
	DC.W    $cbac
	DC.W    $80c0
B01L01a:
	*** Intro aufrufen
	JMP     B01L01b
	DC.W    $60bb
	DC.W    $e569
B01L079:
		movem.l	(SP)+,d1-d7/a0-a6
	BRA     B01L07a
	DC.W    $23f6
B01L05c:
		cmp.w	d2,d1		; schon erreicht?
	BRA     B01L05d
	DC.W    $d127
	DC.W    $23f2
B01L071:
		dbf	d4,inloop2	; Alle 32 Farben
	JMP     B01L072
B01L00f:
		lea	MFMBuffer,a0		; MFM-Buffer
	JMP     B01L010
	DC.W    $07ff
	DC.W    $055b
B01L05a:
		andi.w	#$f00,d2	; obersten Schieber isolieren
	BRA     B01L05b
	DC.W    $0dbf
B01L05f:
redok:
	BRA     B01L060
	DC.W    $3494
B01L04a:
		lea	ColorPalette,a0
	JMP     B01L04b
B01L041:
**************************************************************************
	JMP     B01L042
	DC.W    $23f8
B01L07b:
vsync:		cmpi.b	#200,vhposr(a4)
	BRA     B01L07c
	DC.W    $23f0
B01L002:
		clr.l	(a6)+
	BRA     B01L003
B01L02b:
		lea	Supie(PC),a5
	JMP     B01L02c
	DC.W    $5961
	DC.W    $e939
	DC.W    $23fb
B01L01e:
		move.l	#FN_INTRO.ABS,d1
	BRA     B01L01f
	DC.W    $23fc
B01L017:
		or.l	eb_KickTagPtr(a6),d0
	JMP     B01L018
B01L012:
		bsr	ShowLoadPic
	JMP     B01L013
	DC.W    $ed92
B01L07a:
		rts
	JMP     B01L07b
	DC.W    $1fd6
	DC.W    $5804
	DC.W    $ef97
	DC.W    $5430
B01L051:
		move.w	#$8080,dmacon(a4)	; COPPER DMA on
	BRA     B01L052
	DC.W    $23f6
B01L06a:
		andi.w	#$00f,d0	; untersten Schieber isolieren
	BRA     B01L06b
	DC.W    $9e4b
	DC.W    $23f4
B01L024:
		bsr	DoMod
	JMP     B01L025
	DC.W    $9fac
	DC.W    $23f0
B01L063:
		andi.w	#$0f0,d1	; -"-
	JMP     B01L064
	DC.W    $9725
B01L00c:
	*** CDisk initialisieren
	JMP     B01L00d
	DC.W    $62ff
	DC.W    $c086
B01L02f:
		lea	4,a1			; von hier an löschen
	BRA     B01L030
B01L058:
inloop2:	move.w	(a1),d2 	; 1. Farbe holen
	JMP     B01L059
	DC.W    $2002
	DC.W    $23f7
B01L057:
		moveq	#31,d4		; 32 Farben
	BRA     B01L058
	DC.W    $23f1
B01L055:
inloop1:	movea.l	a2,a0			; Source-Palette
	BRA     B01L056
	DC.W    $b224
	DC.W    $23fb
B01L032:
		move.w	#$cfb,$dff180		; hellgrün
	JMP     B01L033
	DC.W    $657f
B01L081:
		rts
	JMP     B01L082
	DC.W    $91e3
	DC.W    $8fdc
	DC.W    $71f3
B01L021:
	*** Game aufrufen
	BRA     B01L022
	DC.W    $23f3
B01L026:
		addq.w	#1,d0
	BRA     B01L027
	DC.W    $d0fc
	DC.W    $9f27
	DC.W    $166c
B01L050:
		bsr	DoDelay
	BRA     B01L051
	DC.W    $dfb3
	DC.W    $bcbc
B01L082:

; ******* END OF MIXED BLOCK #1 *******

**************************************************************************
.clr1:		clr.l	(a0)+
DoClear:	subq.l	#1,d0
		bpl.s	.clr1
		rts
**************************************************************************
		DSEG
CopperList:	cmovel	BOOTPICADDR+0*PLANESIZE,bpl1pt
		cmovel	BOOTPICADDR+1*PLANESIZE,bpl2pt
		cmovel	BOOTPICADDR+2*PLANESIZE,bpl3pt
		cmovel	BOOTPICADDR+3*PLANESIZE,bpl4pt
		cmovel	BOOTPICADDR+4*PLANESIZE,bpl5pt
		cmovel	BOOTPICADDR+5*PLANESIZE,bpl6pt
		cmove	$2c81,diwstrt
		cmove	$f4c1,diwstop
		cmove	$0038,ddfstrt	
		cmove	$00d0,ddfstop	
		cmove	$1000*DEPTH+$200,bplcon0	; DEPTH Planes
		cmove	$0000,bplcon1
		cmove	$0000,bplcon2
		cmove	$0000,bpl1mod
		cmove	$0000,bpl2mod
		cmovel	0,sprpt+0*4
		cmovel	0,sprpt+1*4
		cmovel	0,sprpt+2*4
		cmovel	0,sprpt+3*4
		cmovel	0,sprpt+4*4
		cmovel	0,sprpt+5*4
		cmovel	0,sprpt+6*4
		cmovel	0,sprpt+7*4
		cmove	$8100,dmacon		; PLANE DMA on
		cend
		BSS	ColorPalette,2*32
		BSS	MFMBuffer,16384
