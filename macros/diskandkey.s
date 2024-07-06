
	XDEF	ReadDisk,InitDiskAndKey,GetKey,WaitKey,StopDisk
	XDEF	DiskBusy
	XDEF	KeyBoard,Unit0

;Disk and KeyBoard SubRoutines


InitDiskAndKey:
	move.b	#$ff,$bfd300
	move.b	#$ff,$bfd100
	move.l	$68,OldTimerInt
	move.l	$64,OldBlockInt
	move.l	#TimerInt,$68
	move.l	#BlockInt,$64
InitTimer:
	lea	$dff000,a0
	lea	Unit0,a1
	lea	$bfd100,a2
	move.b	#$81,$bfed01
	move.b	#%10001001,$bfee01
	move.b	7(a1),$bfe401
	move.b	6(A1),$bfe501
	move	#$8002,$dff09a
	rts

	DSEG

OldTimerInt:
	dc.l	0
OldBlockInt:
	dc.l	0

	CSEG

StopDisk:
	move	#2,$dff09a
	move.l	OldBlockInt,$64
	move.l	OldTimerInt,$68
	clr.b	$bfed01
	clr.b	$bfee01
	rts




ReadDisk:			;a1=Offset/a0=Dest/d0=Lange
				;D1 > 0 warten bis fertig gelesen
	movem.l	d0-d7/a0-a6,-(SP)
	lea	Unit0,a5

	move.l	a1,118(A5)
	move.l	a0,122(A5)
	move.l	d0,126(A5)
	tst	d1
	beq.s	EndReadDisk
WaitDisk:
	tst.l	126(A5)
	bne.s	WaitDisk
EndReadDisk:
	movem.l	(SP)+,d0-d7/a0-a6
	rts
	


TimerInt:
	movem.l	d0-d7/a0-a6,-(SP)
	move	#$fff,$dff180
	bsr	HandleInts
	movem.l	(SP)+,d0-d7/a0-a6
	rte


HandleInts:
	btst	#3,$dff01f
	beq	NoDeSel
	move	#$0008,$dff09c
	move.b	$bfed01,d0
	btst	#3,d0			;Keyboard Int ?
	bne.s	KeyInt
	btst	#0,d0			;Timer Int ?
	bne.L	DiskInt
	bra	NoDeSel

KeyInt:
	lea	KeyBoard,a1		;Keyboard Int!
	move.b	$bfec01,d1
	or.b	#$40,$bfee01		;HandShake
	not	d1
	roxr	#1,d1			;Keycode
	cmp.b	#$f9,d1			;Last Key Bad ?
	beq.L	KeyAlert
	cmp.b	#$fa,d1			;Buffer full ?
	beq.L	KeyAlert

	move	sr,d0
	bclr	#7,d1

	lea	QualiKeys,a0
NextQuali:
	move.b	(A0),d2			;Key
	move.b	1(A0),d3		;Bit Nr.
	
	cmp.b	#-1,d2			;Ende der Liste ?
	beq.s	NoQuali

	addq	#2,a0
	cmp.b	d1,d2			;ist es Shift etc. ?
	bne.s	NextQuali

	btst	#4,d0			;Key Up?
	bne.s	QualiUp
	bset	d3,18(A1)		;Key down
	bra.s	NoQuali
QualiUp:
	bclr	d3,18(A1)		;Key up

NoQuali:				;Normale Taste!
	btst	#4,d0			;Key Up?
	beq.s	KeyUp			;ja
	clr.b	16(A1)			;Act Rawkey
	clr.b	17(A1)			;Act Ascii Key
	bra.s	EndKeyInt		
KeyUp:
	move.l	(A1),a0			;LowKeyMap
	btst	#0,18(A1)		;Shift dedrueckt ?
	beq.s	NoShift
	move.l	4(A1),a0		;HiKeyMap
NoShift:
	move.b	d1,16(A1)		;ActRawKey

	and	#$ff,d1
	move.b	(a0,d1.w),d0		;Ascii aus Tabelle holen
	cmp.b	#-1,d0			;ungültig?
	beq.s	EndKeyInt

	move.b	d0,17(A1)		;ActAsciiKey
	move.l	8(A1),a0		;KeyBuffer
	move	12(A1),d2		;offset
	move	14(A1),d3		;max offset
	cmp	d2,d3			;buffer full ?
	beq.s	EndKeyInt		;ja
	addq	#1,12(A1)		;offsset+1
	ext.l	d2
	move.b	d0,(a0,d2.w)		;in buffer
EndKeyInt:
	move	#900,d0
KeyDelay:
	dbf	d0,KeyDelay		;Delay fuer Handshake
	and.b	#$bf,$bfee01		;Handshake Ende
	bra.L	NoDeSel

KeyAlert:				;wenn extra Code
	or.b	#$40,$bfee01		;Handshake
	move	#900,d0
AlertDelay:
	move	d0,$dff180
	dbf	d0,AlertDelay
	bra.s	EndKeyInt		



WaitKey:
	bsr	GetKey
	tst	d0
	beq.s	WaitKey
	rts
	

	nop

GetKey:
	move	#$4000,$dff09a
	movem.l	d1/a0/a1,-(SP)
	lea	KeyBoard,a1
	move.l	8(A1),a0		;KeyBuffer
	moveq	#0,d0
	tst	12(A1)			;Kein Zeichen im Buffer?
	beq.s	EndGetKey
	move.b	(A0),d0			;KeyCode
	subq	#1,12(A1)		;offset
	move	14(A1),d1		;grösse
	subq	#2,d1
GetLoop:
	move.b	1(A0),(A0)
	addq	#1,a0
	dbf	d1,GetLoop
EndGetKey:
	movem.l	(SP)+,d1/a0/a1
	move	#$c000,$dff09a
	rts
	


DiskInt:
	lea	$dff000,a0
	lea	Unit0,a1
	lea	$bfd100,a2
	cmp.b	#2,13(A1)		;sind wir am lesen ?
	beq	EndDiskInt
	bclr	#7,(A2)			;motor on

	move	(a1),d1			;unit nr
	addq	#3,d1			;Bit Nr bilden
	bclr	d1,(A2)			;select
	bset	#1,(a2)			;disk dir. (Step)

	moveq	#-1,d2
	move	2(A1),d1		;track ist
	cmp	4(A1),d1		;track soll
	beq	StepOk			;identisch ?
	bhi	UpStep
	bclr	#1,(a2)			;disk dir
	moveq	#1,d2
UpStep:
	bclr	#0,(a2)			;step low

	
	move.l	d1,-(A7)
	mulu	d1,d1			;delay
	move.l	(A7)+,d1

	bset	#0,(a2)			;step high
	add	d2,2(A1)		;track soll
	btst	#4,$bfe001		;Track 0 ?
	bne	NoStep
	clr	2(A1)			;track ist = 0 !
NoStep:
	move.b	#1,13(a1)		;status (stepping)
	bra	EndDiskInt

StepOk:
	clr.b	13(A1)			;status
	tst.l	126(A1)			;laenge = 0 ?
	beq	EndDiskInt		;nichts lesen !

	bsr	CalcTrack		;track und sektor
	cmp	2(A1),d0		;kopf ueber dieser spur?
	beq	ReadTrack		;ja
	move	d0,4(A1)		;Track soll
	bra	EndDiskInt

ReadTrack:
	cmp.b	114(A1),d2		;richtige seite im puffer ?
	bne	ReadIt			;nein -> spur lesen
	cmp	14(A1),d0		;ist spur schon in puffer?
	beq	NoRead
ReadIt:
	bsr	WaitReady		;auf DiskReady warten
	bsr	CalcTrack
	move.b	d2,114(A1)
	bset	#2,(a2)			;side 0
	tst.b	114(a1)			
	beq	Side0
	bclr	#2,(A2)			;side 1
Side0:
	move	#$4000,$24(A0)		;DMA off
	move.l	16(A1),$20(A0)		;DestAdress
	move	#$7fff,$9e(A0)
	move	10(A1),$9e(A0)		;adcon
	move	#2,$9c(a0)		;clr interrupt
	move	8(a1),$7e(A0)		;Sync
	move.l	108(a1),d0		;länge
	or	#$8000,d0		;Set or Clear
	move	d0,$24(A0)		;länge
	move	d0,$24(A0)		;DMA starten
	move.b	#2,13(a1)		;status (reading)
	bra.L	EndDiskInt

NoRead:
	bsr	CalcTrack		;track und sektor
	cmp	14(A1),d0		;spur in puffer?
	beq	OkDec			;ja
	move	d0,4(A1)		;track soll (kopf neu setzen)
	bra	EndDiskInt
OkDec:
	cmp.b	114(A1),d2
	bne	EndDiskInt

	move	d1,d2			;sektornummer
	move	d1,d5
	move.l	a1,a3
	add.l	#20,a3			;sektorenzeiger
	lsl	#2,d2			;*4
	move.l	(A3,d2.w),a4		;sektoradresse holen
	move.l	a0,a5			;a0 retten
	move.l	a4,a0			;sectorzeiger nach a0
	bsr	DecodeLong		;header decodieren
	move.l	a5,a0			;altes a0 zureueck
	lsr	#8,d0			;sektornummer verschieben
No2:
	cmp.b	d5,d0			;ist es richtiger Block ?
	beq	CorectBlock		;ja
	
	move	#-1,14(A1)		;nein, nochmals lesen
	;move	#-1,2(A1)		;kopf auf spur 0	
	bra	EndDiskInt

CorectBlock:
	tst.l	126(A1)
	beq	EndRead
	bmi	EndRead

	bsr	DecodeBlock		;Block decodieren
	add.l	#512,118(A1)		;offset
	add.l	#512,122(A1)		;ziel
	sub.l	#512,126(A1)		;laenge
	tst.l	126(A1)			;laenge 0 ?
	bne	NoRead			;wenn nicht -> nächster Block
	move.l	FlagDef,a0		;Zeiger auf bobdef
	move.l	a0,d0			;vorhanden ?
	beq	EndDiskInt		;nein ->
	st	47(A0)			;flag fuer bob geladen
EndDiskInt:
	tst.b	13(A1)			;status ?
	bne	NoDeSel			;beschäftigt
	move	(A1),d1			;unit
	addq	#3,d1
	bset	d1,(A2)			;Drive DeSelect
NoDeSel:
EndTimerInt:
	bsr	InitTimer
	rts

EndRead:
	clr.l	126(A1)
	bra	EndTimerInt



BlockInt:			;disk block finished int.
	movem.l	d0-d7/a0-a6,-(SP)
	bsr	HandleBlockInt
	movem.l	(SP)+,d0-d7/a0-a6
	rte


HandleBlockInt:
	btst	#1,$dff01f		;block finished ?
	beq	EndBlockInt
	move	#$a,$dff09a
	lea	Unit0,a1
	move	#2,$dff09c
	move	#$4000,$dff024		;dma off
	move.l	16(A1),a0		;mfmbuffer
	bsr	CheckBlock		;Read Error ?
	tst	d0
	bne	Error2			;ja!
	bsr	DecodeLong		;header decodieren
	move.l	d0,d4
	rol.l	#8,d4
	cmp.b	#$ff,d4
	beq	1$
	moveq	#-1,d0
	bra	Error2
1$:
	swap	d0
	move.l	d0,d1
	and.l	#$ff,d0
	lsr	#1,d0			;tracknummer
	cmp	2(A1),d0		;ist es richtiger track?
	beq	TrackOk			;ja
Error:	move	d0,2(A1)		;sonst neu setzen
Error2:	move	d0,14(A1)		;track in buffer
	clr.b	13(A1)			;status
	bra.L	EndBlockInt

TrackOk:
	move	d0,14(a1)		;gelesene spur
	move.l	a1,a2
	add.l	#20,a2			;alte sektorzeiger
	moveq	#21,d7
ClearLoop:
	clr.l	(a2)+			;löschen
	dbf	d7,ClearLoop

	move.l	16(A1),a0		;mfm buffer
	move.l	a1,a2
	add.l	#20,a2			;sektorenzeiger
	move	112(A1),d1		;secs
	subq	#1,d1
	
BlockLoop1:
	bsr	DecodeLong
	lsr	#8,d0
	and.l	#$ff,d0			;sektornummer
	lsl.l	#2,d0			;*4
	move.l	a0,(a2,d0.w)		;in tabelle
	add.l	#$440,a0		;nächster Block
	move	8(A1),d2		;sync
	cmp	(A0),d2			;schon Header?
	beq.s	BlockOk
SearchSync:
	cmp	(A0)+,d2		;nächstes Sync suchen
	bne.s	SearchSync
	subq.l	#2,a0
	move	d2,d3
	swap	d3
	move	d2,d3
	cmp.l	(a0),d3			;ist es doppelsync ?
	bne.s	BlockOk
	addq.l	#2,a0			;korrigieren
BlockOk:
	dbf	d1,BlockLoop1		;nächster Block

	move.l	a1,a2
	add.w	#20,a2
	moveq	#10,d7			;11 Bloecke
CheckLoop:	
	move.l	(A2)+,a0		;auf read Error
	bsr	DecodeLong
	rol.l	#8,d0
	cmp.b	#$ff,d0
	bne	BlockCheckError
	bsr	CheckBlock
	tst	d0			;prüfen
	bne	BlockCheckError
	dbf	d7,CheckLoop
	bra.s	NoError

BlockCheckError:
	;move	#-1,2(a1)
	move	#-1,14(A1)
NoError:
	clr.b	13(A1)			;status
EndBlockInt:
	move	#$800a,$dff09a
	rts


WaitReady:
	btst	#5,$bfe001
	bne	WaitReady
	rts
	
	
CalcTrack:				;berechnet aus diskoffset
	lea	Unit0,a1		;track und sektornummer
	move.l	118(A1),d0
	moveq	#9,d1
	lsr.l	d1,d0
	divu	#22,d0
	move.l	d0,d1
	swap	d1
	ext.l	d1
	ext.l	d0
	moveq	#0,d2
	cmp	#11,d1
	blt	LSec
	sub	#11,d1
	moveq	#1,d2
LSec:
	rts
	



CheckBlock:   ;prüft block header und daten / in a0 zeiger auf mfmblock
	movem.l	d1-d7/a0-a6,-(SP)
	move.l	a0,a4
	lea	HeaderBuffer,a2
	moveq	#6,d7
HeaderLoop:
	bsr	DecodeLong
	move.l	d0,(a2)+
	add	#8,a0
	dbf	d7,HeaderLoop

	move.l	a4,a2			;mfm-buffer
	addq	#2,a2			;sync ueberspringen
	moveq	#4,d7
	clr.l	d1
MakeHeaderSum:
	move.l	(A2)+,d0
	eor.l	d0,d1			;cheksumme bilden
	dbf	d7,MakeHeaderSum
	and.l	#$55555555,d1
	lea	HeaderBuffer,a2
	cmp.l	20(A2),d1
	bne	BlockError	

	move.l	a4,a2
	add	#58,a2
	clr.l	d1
	move	#255,d7
MakeDataSum:
	move.l	(A2)+,d0
	eor.l	d0,d1
	dbf	d7,MakeDataSum
	and.l	#$55555555,d1
	lea	HeaderBuffer,a2
	cmp.l	24(A2),d1
	bne.s	BlockError
	moveq	#0,d0
	;move.l	#'END1',$370000
	movem.l	(SP)+,d1-d7/a0-a6
	rts
	

BlockError:
	moveq	#-1,d0
	;move.l	#'END2',$370000
	movem.l	(SP)+,d1-d7/a0-a6
	rts
	
	
	DSEG

HeaderBuffer:
	ds.l	7,0	

	CSEG

DecodeLong:
	move.l	d1,-(SP)
	move.l	2(A0),d0
	move.l	6(A0),d1
	and.l	#$55555555,d0
	and.l	#$55555555,d1
	lsl.l	#1,d0
	or.l	d1,d0
	move.l	(SP)+,d1
	rts


DecodeBlock:
	movem.l	d0-d4/a1,-(SP)
	move.l	122(a1),a1
	moveq	#$7f,d4
	add	#58,a4
	move.l	#$55555555,d2
DecodeBlockLoop:
	move.l	(A4)+,d0
	move.l	512-4(A4),d1
	and.l	d2,d1
	and.l	d2,d0
	lsl.l	#1,d0
	or.l	d1,d0
	move.l	d0,(A1)+
	dbf	d4,DecodeBlockLoop
	movem.l	(SP)+,d0-d4/a1
	rts
	
	


	DSEG



Unit0:
	dc.w	0		;unit			0
	dc.w	-1		;track ist		2
	dc.w	0		;track soll		4
	dc.w	60000		;step delay		6
	dc.w	$4489		;sync			8
	dc.w	$9500		;adcon			10
	dc.b	$00		;MotStat		12
	dc.b	0		;Status			13
	dc.w	-1		;track in buffer	14
	dc.l	MFMBuffer	;MFM-Buffer		16
	ds.l	22,0		;Zeiger auf Sektoren	20
	dc.l	7500		;laenge			108
	dc.w	11		;Secs			112
	dc.b	0		;side			114
	dc.b	0		;fut			115
	dc.w	0		;fut			116

	dc.l	0		;DiskOffset		118
	dc.l	0		;ZielAdresse		122
DiskBusy:
	dc.l	0		;Laenge			126

	

DiskList:
	dc.l	0
FlagDef:
	dc.l	0



KeyBoard:
	dc.l	KeyMap				;LowKeyMap	0
	dc.l	KeyMap				;HiKeyMap	4
	dc.l	KeyBuffer			;Buffer		8
	dc.w	0				;ActOffset	12
	dc.w	80				;max Groesse	14
	dc.b	0				;ActRawKey	16
	dc.b	0				;ActASCIIKey	17
	dc.w	0				;Qualifier	18

KeyBuffer:
	ds.b	100,0

;Tabelle für nicht geshiftete Tasten. Sondertasten (Backspace etc.)
;sind noch nicht belegt. Alle ungültigen Tasten geben ein -1 zurück!


KeyMap:
	dc.b	-1,'1','2','3','4','5','6','7','8'	;$00-
	dc.b	'9','0','-',-1,-1			;$0d

	dc.b	-1,'0','Q','W','E','R','T','Y','U'	;$0e-
	dc.b	'I','O','P',-1,-1			;$1b

	dc.b	-1,'1','2','3','A','S','D','F','G'	;$1c-
	dc.b	'H','J','K','L',':',-1			;$2a

	dc.b	-1,-1,'4','5','6',-1,'Z','X','C'	;$2b-
	dc.b	'V','B','N','M',-1,'.','?'		;$3a

	dc.b	-1,'.','7','8','9'

	dc.b	' '					;Space
	dc.b	2					;backspace
	dc.b	-1					;tab
	dc.b	1					;enter
	dc.b	1					;return
	dc.b	$f0					;Esc
	dc.b	2					;del
	dc.b	-1,-1,-1				;$47-$49
	dc.b	'-'					;NumPad($4a)
	dc.b	-1					;$4b
	dc.b	$E0					;Up
	dc.b	$E1					;down
	dc.b	$E2					;right
	dc.b	$E3					;left
	dc.b	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1		;f1-f10
	dc.b	-1,-1,-1,-1,-1				;$5a-$5e
	dc.b	-1					;help
	dc.b	-1,-1					;shift l+r
	dc.b	-1					;CapsLock
	dc.b	-1					;Ctrl
	dc.b	-1,-1					;alt l+r
	dc.b	-1,-1					;Amiga l+r

QualiKeys:
	dc.b	$60,0					;shift l
	dc.b	$61,0					;shift r
	dc.b	$62,0					;capslock
	dc.b	$63,1					;ctrl
	dc.b	$64,2					;alt l
	dc.b	$65,2					;alt r
	dc.b	$66,3					;amiga l
	dc.b	$67,3					;amiga r
	dc.b	$5f,4					;help
	dc.b	-1,-1

	even

	BSS	MFMBuffer,16000
