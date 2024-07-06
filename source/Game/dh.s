
	XDEF	Read,Write,InitDisk

 IFD DISKVERSION

	XREF	_InitDisk,_ReadFile,_WriteFile

InitDisk:	bra	_InitDisk


Read:		move.l	d0,-(SP)
		move.l	d6,d0		; Filename
		bsr	_ReadFile
		move.l	(SP)+,d0
		rts

Write:		move.l	d0,-(SP)
		move.l	d6,d0		; Filename
		bsr	_WriteFile
		move.l	(SP)+,d0
		rts

 ELSE

;--- Hardware --------------------------------------------------------

HdBase	EQU	$800000
DataOut	EQU	$641
DataIn	EQU	$641
Status	EQU	$643
Config	EQU	$645
Select	EQU	$645
Mask	EQU	$647

;--- Various ---------------------------------------------------------

Flags	EQU	%00000011

;--- Commands --------------------------------------------------------

CmdRead	 EQU	$8
CmdWrite EQU	$A
CmdInit	 EQU	$C
CmdSeek	 EQU	$B

;--- Drive -----------------------------------------------------------

Secs	EQU	17
Cyls	EQU	615
Heads	EQU	4
Precomp	EQU	256
Reduce	EQU	$FFFF
ParkHd	EQU	0

;---------------------------------------------------- End of Equates -

	CSEG



o:	lea	$40000,a0
	move.l	#0,d6
        move.l	#333*512,d7
	bsr	Write
	rts


InitDisk:	
	rts


; A0=Ziel | D6=Offset | D7=Lenght  (alles in Bytes)

Read:	movem.l	d0-d7/a0-a6,-(sp)
	move.l	d6,d0
	move.l	d7,d1
	move.l	a0,a2			; Ziel
1$:	bsr	HdRead
	tst.l	RSect
	beq	2$
	move.l	RSect,d1		; neue Laenge
	move.l	ROffs,d0		; neuer Offset
	move.l	RAddr,a2
	bra	1$

2$:	movem.l	(Sp)+,d0-d7/a0-a6
	rts


; A0=Ziel | D6=Offset | D7=Lenght  (alles in Bytes)

Write:	movem.l	d0-d7/a0-a6,-(sp)
	move.l	d6,d0
	move.l	d7,d1
	move.l	a0,a2			; Ziel
1$:	bsr	HdWrite
	tst.l	RSect
	beq	2$
	move.l	RSect,d1		; neue Laenge
	move.l	ROffs,d0		; neuer Offset
	move.l	RAddr,a2
	bra	1$

2$:	movem.l	(Sp)+,d0-d7/a0-a6
	rts



;--- Sektoren lesen --------------------------------------------------
; A2=Ziel
; D0=Offset
; D1=Laenge

HdRead:	movem.l	d0-d7/a0-a6,-(sp)
	cmp.l	#$20000,d1
	blo	1$

	move.l	d1,d2		; zu lesende Sektoren
	move.l	#$20000,d1
	sub.l	d1,d2		; Restliche Sektoren
	move.l	d2,RSect
	move.l	d0,d3		; Aktueller Offset
	add.l	d1,d3		; neuer Offset am Schluss
	move.l	d3,ROffs
	move.l	a2,a3
	add.l	d1,a3
	move.l	a3,RAddr
	bra	2$
1$:
	clr.l	RSect
	clr.l	ROffs
2$:
	move.l	d1,d7		; Laenge
	lsr.l	#8,d0
	lsr.l	#1,d0
	bsr	ConvertSector

	lea	HdBase,a5
	clr.b	Select(A5)
	bsr	Ready

	move.b	#CmdRead,DataOut(A5)
	move.b	d0,DataOut(A5)
	move.b	d1,DataOut(A5)
	move.b	d2,DataOut(A5)
	move.l	d7,d6
	lsr.l	#8,d6
	lsr.l	#1,d6
	move.b	d6,DataOut(A5)
	move.b	#Flags,DataOut(A5)

	subq	#1,d6
	lea	DataIn(a5),a0
WaitRead:
	btst	#0,Status(A5)
	beq.s	WaitRead

	btst	#2,Status(A5)
	bne.L	Tschau
	
	moveq	#15,d5
Read2:	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	move.b	(A0),(A2)+
	dbf	d5,Read2
	dbf	d6,WaitRead
	bsr	WaitEnd
EndeLesen:
	movem.l	(sp)+,d0-d7/a0-a6
	rts

Tschau:
	move.b	DataIn(A5),d0
	move.b	#20,31(A1)
	movem.l	(sp)+,d0-d7/a0-a6
        rts


;--- Sektoren schreiben ----------------------------------------------
; A2=Ziel
; D0=Offset
; D1=Laenge

HdWrite:
	movem.l	d0-d7/a0-a6,-(sp)
	cmp.l	#$20000,d1
	blo	1$

	move.l	d1,d2		; zu lesende Sektoren
	move.l	#$20000,d1
	sub.l	d1,d2		; Restliche Sektoren
	move.l	d2,RSect
	move.l	d0,d3		; Aktueller Offset
	add.l	d1,d3		; neuer Offset am Schluss
	move.l	d3,ROffs
	move.l	a2,a3
	add.l	d1,a3
	move.l	a3,RAddr
	bra	2$
1$:
	clr.l	RSect
	clr.l	ROffs
2$:
	move.l	d1,d7
	lsr.l	#8,d0
	lsr.l	#1,d0
	bsr	ConvertSector

	lea	HdBase,a5
	clr.b	Select(A5)
	bsr	Ready

	move.b	#CmdWrite,DataOut(A5)
	move.b	d0,DataOut(A5)
	move.b	d1,DataOut(A5)
	move.b	d2,DataOut(A5)

	move.l	d7,d6
	lsr.l	#8,d6
	lsr.l	#1,d6
	move.b	d6,DataOut(A5)			; Anzahl Sektoren
	move.b	#Flags,DataOut(A5)

	lea	DataOut(A5),a3

	subq	#1,d6
	lea	DataIn(a5),a0
WaitWrite:
	btst	#0,Status(A5)
	beq.s	WaitWrite

	btst	#2,Status(A5)
	bne	Tschau

	moveq	#15,d5
Write2:	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	move.b	(A2)+,(A3)
	dbf	d5,Write2
	dbf	d6,WaitWrite
	bsr	WaitEnd
	movem.l	(sp)+,d0-d7/a0-a6
        rts


;--- Wandelt Sektor in D0 in Sektoren/Spuren/Koepfe um ---------------

ConvertSector:
	movem.l	d6/d7,-(SP)

	divu	#Heads*Secs,d0		; D4=Spur
	move	d0,d4
	swap	d0
	ext.l	d0
	divu	#Secs,d0
	move	d0,d3			; D3=Head
	swap	d0
	ext.l	d0
	move	d0,d2			; D2=Sektor

	move.b	d3,d0			; C10/0/LUN/HEAD
	move	d4,d1
	and	#$300,d1		; C9/C8 ausfiltern
	lsr	#2,d1
	or.b	d2,d1
	move.b	d4,d2			; C0-C7
	movem.l	(SP)+,d6-d7
	rts


;--- Befehlsende abwarten und StatusByte lesen -----------------------

WaitEnd:
	move.b	DataIn(a5),d0
	btst	#3,Status(A5)
	bne.s	WaitEnd
	rts

;--- Warten bis Controller ein Byte erwartet -------------------------

Ready:
	btst	#0,Status(A5)
	beq.s	Ready
	rts

	DSEG

	BSS	Buffer,512
	BSS	RSect,4
	BSS	ROffs,4
	BSS	RAddr,4

 ENDC ; IFD DISKVERSION


