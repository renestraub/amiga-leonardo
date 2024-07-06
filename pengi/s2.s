
		Include	"h:constants.i"
		Include	"h:relcustom.i"
		Include	"h:copper.i"
		Include	"h:bobcoms.i"

		XDEF	AllocMem,FreeMem,InitAlloc,AvailMem
		XDEF	OutOfMemory,MemoryHeader

		XDEF	SetAnim,MoveBobs,SetBob,AskBob,AddBob,RemBob,CreateAnim,MoveBase
		XDEF	DrawSaveBuffer,DrawBobs,PosX,PosY,MSpr1,MSpr2,MSpr3,MSpr4
		XREF	BitmStr1,BitmStr2,SpeedFlag,FlipFlag,AllocMem,FreeMem
		XDEF	AnzBob,BobList

		XDEF	AddInt,RemInt,MyInt,OldInt
		XDEF	FadeIn,FadeOut,DelayBlank

		XDEF	SetSound,MusicVBL,LockVoices,SongPtr

		XDEF	Decruncher
		XDEF	InitDisk,Read

		XDEF	page,page1,page2,pagel
		XDEF	BlackCopper
		XDEF	CopyPage,SetPlane
		XDEF	Anim1

		BobLenght:	EQU	105*512
		SongLenght:	EQU	123*512
		FxLenght:	EQU	120*512
		planel:		EQU	9600
		pagel:		EQU	5*planel

		top:		EQU	$80000-1000
		page1:		EQU	top-pagel-64
		page2:		EQU	page1-pagel-64
		SongBase:	EQU	page2-SongLenght
		BobBase:	EQU	SongBase-BobLenght
		FxBase:		EQU	BobBase-FxLenght
		MoveBase:	EQU	FxBase-10000
		SaveBuffer:	EQU	MoveBase-$7000

		FS_Anim:	EQU	512*868
		FS_Back:	EQU	512*789
		FS_Fx:		EQU	512*973
		FS_Song:	EQU	512*666


		CSEG

PlayFx:		MACRO
		movem.l	d0-d7/a0-a6,-(sp)
		moveq	#1,d0
		move	#\4,d1
		bsr	LockVoices

		move	#1,$dff096
		bsr	Delay250

		lea	$dff0a0,a4
		move.l	#\1,(a4)
		move	#\3,4(A4)
		move	#\2,6(A4)
		move	#\5,8(A4)

		move	#$8001,$dff096

		IFEQ	\6
		bsr	Delay250
		move.l	#0,(A4)
		move	#1,4(A4)
		ENDC

		movem.l	(sp)+,d0-d7/a0-a6
		ENDM


Load:		MACRO
		lea	\2,a0				; Ziel
		move.l	#\1,d6				; Offset
		move.l	#\3,d7				; Laenge
		bsr	Read
		ENDM


o:		lea	$dff000,a5
		move.l	a7,Stack
		lea	$80000,a7
		clr.l	0
		bset	#1,$bfe001

		move	intenar(A5),IntenaSave

		move.l	#BlackCopper,cop1lc(A5)

		move	#$83f0,dmacon(A5)

		moveq	#1,d1				; 1 Drive
		bsr	InitDisk

		Load	FS_Anim,BobBase,105*512
		Load	FS_Back,page1,79*512

		bsr	ConvertPic

		Load	FS_Song,SongBase,123*512
		move.l	#SongBase,SongPtr

		Load	FS_Fx,FxBase,120*512

		move.l	#SaveBuffer,MemoryHeader
		move.l	#SaveBuffer+$7000,MemoryHeader+4
		bsr	InitAlloc

		bsr	CreateAnim

		move.l	#BobBase,BobDef1+16
		move.l	#BobBase+(76*640),BobDef2+16		; Laterne
		move.l	#BobBase+(77*640),BobDef3+16		; Tuere
		move.l	#BobBase+(78*640),BobDef4+16		; Neon

		lea	BobDef1,a1
		bsr	AddBob
		move.l	d0,Bob1
		move.l	d0,a0
		move.l	#MoveBase,76(A0)
		clr	80(A0)

		lea	BobDef2,a1
		bsr	AddBob
		move.l	d0,Bob2

		lea	BobDef3,a1
		bsr	AddBob
		move.l	d0,Bob3
	
		clr.l	Timer	
		bsr	AddInt

		moveq	#0,d0
		bsr	SetSound

		move.l	#copperl,cop1lc(A5)
		lea	colors+2,a0
		sub.l	a1,a1
		lea	page2+28000+20000,a2
		bsr	FadeIn

1$:		tst	EndFlag
		bne	Quit
		btst	#7,$bfe001
		beq	Quit
		btst	#6,$bfe001
		bne	1$

Quit:		clr	Window1+2
		clr	Window2+2
		clr	Window3+2

		lea	colors+2,a3
		sub.l	a4,a4
		bsr	FadeOut

		move	#$F,$dff096
		bsr	RemInt
Ende:
		lea	$dff000,a5
		move.l	#$420,cop1lc(A5)
		clr	copjmp1(A5)		; CopStrobe very Important !!!

		move	IntenaSave,d0
		or	#$c000,d0
		move	d0,intena(A5)

		move.l	Stack,a7
		moveq	#0,d0
		rts


MyInt:		movem.l	d0-d7/a0-a6,-(sp)
		lea	$dff000,a5
		btst	#5,$1f(A5)
		beq	EndInt
		btst	#4,$1f(A5)
		bne	EndInt
CopperInt:
		addq.l	#1,Timer
		move.l	Timer,$100
		bsr	MusicVBL

		not	FlipFlag
		bsr	SetPlane

		bsr	DrawSaveBuffer
		bsr	HandleTimer
		bsr	MoveBobs
		bsr	DrawBobs

		move	#$20,intreq(a5)
EndInt:
		movem.l	(sp)+,d0-d7/a0-a6
;		rte

		dc.w	$4ef9
OldInt:
		dc.l	0


HandleTimer:	cmp.l	#1700,Timer
		bne	1$
		move.l	Bob3,a0
		move	#Invisible,20(A0)
		move.b	#50,44(A0)
1$:
		cmp.l	#1775,Timer
		bne	2$
		move.l	Bob3,a0
		clr	20(A0)
		PlayFx	FxBase+26056,627,1445,25,35,0		; TuereZU
2$:
		cmp.l	#1675,Timer
		bne	3$
		PlayFx	FxBase,627,13028,225,35,0		; TuereAUF
3$:
		cmp.l	#100,Timer
		bne	4$
		move	#$fb4,Window2+2				; Schlafzimmer ein
4$:		
		cmp.l	#690,Timer
		bne	5$
		move	#$fb4,Window3+2				; WC an
5$:
		cmp.l	#1100,Timer
		bne	6$
		move	#0,Window3+2				; WC aus
6$:
		cmp.l	#1350,Timer
		bne	7$
		move	#0,Window2+2				; Schlafzimmer aus
7$:		
		cmp.l	#2300,Timer
		bne	8$
		move	#$fb4,Window1+2
8$:
		cmp.l	#380,Timer
		bne	9$

		PlayFx	FxBase+28946,445,8454,210,25,1		; Schritte
9$:
		cmp.l	#1150,Timer
		bne	10$

		PlayFx	FxBase+28946,445,8454,210,25,1		; Schritte
10$:
		cmp.l	#1800,Timer
		bne	11$

		PlayFx	FxBase+28946,445,8454,450,20,1		; Schritte LEO
11$:
		cmp.l	#1800,Timer
		bne	12$
		
		move.l	Bob1,a0
		bsr	RemBob
		move.l	Bob2,a0
		bsr	RemBob
12$:
		cmp.l	#11030,Timer
		bne	13$
		st	EndFlag
13$:
		cmp.l	#2400,Timer
		bne	14$
		lea	BobDef4,a1
		bsr	AddBob					; NeonSchrift
14$:
		cmp.l	#1000,Timer
		bne	15$

		PlayFx	FxBase+45854,856,7685,183,64,0		; Schritte LEO
15$:
		rts

ConvertPic:	lea	page1+16000,a0
		lea	page2+19200,a1

		move	#199,d6
2$:
		moveq	#9,d7	
1$:
		move.l	-16000(A0),-19200(A1)
		move.l	-8000(A0),-9600(A1)
		move.l	8000(A0),9600(A1)
		move.l	16000(A0),19200(A1)
		move.l	(A0)+,(A1)+
		dbf	d7,1$

		addq.l	#8,A1
		dbf	d6,2$

		add.l	#16000,a0
		add.l	#19200,a1
		moveq	#15,d0
3$:		move.l	(A0)+,(A1)+
		dbf	d0,3$

		bsr	CopyPage
		rts

Delay250:	move	#250,d0
1$:		dbf	d0,1$
		rts

		DSEG

BlackCopper:	cmove	$0000,bplcon0
		cmove	$0000,color
		cwait	$ffdf,$fffe
		cwait	$0421,$fffe
		cmove	$c000,intreq
		cwait	$3421,$fffe
		cmove	$c000,intreq
		cend


copperl:	cmove	$2c81,diwstrt
		cmove	$f4c1,diwstop
		cmove	$38,ddfstrt
		cmove	$d0,ddfstop
		cmove	$5200,bplcon0
scrollx:	cmove	0,bplcon1
		cmove	0,bplcon2
		cmove	8,bpl1mod
		cmove	8,bpl2mod
page:
		cmovel	page1,bpl1pt
		cmovel	page1+(1*planel),bpl2pt
		cmovel	page1+(2*planel),bpl3pt
		cmovel	page1+(3*planel),bpl4pt
		cmovel	page1+(4*planel),bpl5pt

CGSpr:		cmovel	0,sprpt
		cmovel	0,sprpt+4
		cmovel	0,sprpt+8
		cmovel	0,sprpt+12
		cmovel	0,sprpt+16
		cmovel	0,sprpt+20
		cmovel	0,sprpt+24
		cmovel	0,sprpt+28
colors:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62

		cwait	$4000,$fffe
Window1:	cmove	$000,color+32

		cwait	$8000,$fffe
Window2:	cmove	$000,color+32

		cwait	$a800,$fffe
Window3:	cmove	$000,color+32

		cwait	$ff00,$fffe
		cmove	$000,color+32

		cend


BitmStr1:	dc.w	48,320
		dc.b	0,5
		dc.w	0
		dc.l	page1
		dc.l	page1+(1*planel)
		dc.l	page1+(2*planel)
		dc.l	page1+(3*planel)
		dc.l	page1+(4*planel)

BitmStr2:	dc.w	48,320
		dc.b	0,5
		dc.w	0
		dc.l	page2
		dc.l	page2+(1*planel)
		dc.l	page2+(2*planel)
		dc.l	page2+(3*planel)
		dc.l	page2+(4*planel)

BobDef1:	dc.w	32,32			;Breite,Hoehe 	0
		dc.w	320,153			;x,y Pos	4
		dc.l	Anim1			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	20			;Priority	28
		dc.b	3			;AnimSpeed	29
		dc.w	77			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

		even

BobDef2:	dc.w	32,32			;Breite,Hoehe 	0
		dc.w	278,153			;x,y Pos	4
		dc.l	0			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	40			;Priority	28
		dc.b	3			;AnimSpeed	29
		dc.w	1			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

BobDef3:	dc.w	32,32			;Breite,Hoehe 	0
		dc.w	93,146			;x,y Pos	4
		dc.l	0			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	10			;Priority	28
		dc.b	3			;AnimSpeed	29
		dc.w	1			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

BobDef4:	dc.w	128,21			;Breite,Hoehe 	0
		dc.w	72,6			;x,y Pos	4
		dc.l	Anim4			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	10			;Priority	28
		dc.b	20			;AnimSpeed	29
		dc.w	2			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

Anim4:		dc.w	0,0,1,PrgLoop
		even

		even

		BSS	FlipFlag,2
		BSS	SpeedFlag,2	
		BSS	PosX,2
		BSS	PosY,2
		BSS	MSpr1,4
		BSS	MSpr2,4
		BSS	MSpr3,4
		BSS	MSpr4,4
		BSS	Stack,4
		BSS	Timer,4
		BSS	Bob1,4
		BSS	Bob2,4
		BSS	Bob3,4
		BSS	EndFlag,2
		BSS	IntenaSave,2
