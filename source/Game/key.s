
	XDEF	InitKey,RestoreKey,GetKey,KeyBoard,Button

	Include	"h:relcustom.i"

	KeyIntVector:	EQU	$68

InitKey:
	movem.l	d0-d7/a0-a6,-(SP)
	lea	custom,a5
	lea	OldKeyIntVector,a0
	move.l	KeyIntVector,(A0)
	move.l	#KeyInt,KeyIntVector
	move	#$8008,intena(a5)
	movem.l	(SP)+,d0-d7/a0-a6
	rts

;-----------------------------------------------------------------

RestoreKey:
	lea	OldKeyIntVector,a0
	move.l	(a0),KeyIntVector
	rts

;-----------------------------------------------------------------

GetKey:	movem.l	d1/a0/a1/a5,-(SP)
	lea	custom,a5
	move	#$4000,intena(A5)
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
	move	#$c000,intena(A5)
	movem.l	(SP)+,d1/a0/a1/a5
	rts
	
;-----------------------------------------------------------------

KeyInt:
	movem.l	d0-d7/a0-a6,-(SP)
	btst	#3,$dff01f
	beq	EndKeyInt
	move	#$0008,$dff09c
	move.b	$bfed01,d0
	btst	#3,d0			;Keyboard Int ?
	beq	EndKeyInt
OkKeyInt:
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
	move.b	#-1,17(A1)		;Act Ascii Key
	;move	#-1,fn_key
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
	;move	#0,fn_key
	;move.b	17(A1),fn_key+1
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
	movem.l	(SP)+,d0-d7/a0-a6,-(SP)
	rte

	dc.w	$4ef9
OldKeyIntVector:
	dc.l	0


KeyAlert:				;wenn extra Code
	or.b	#$40,$bfee01		;Handshake
	move	#900,d0
AlertDelay:
	move	d0,$dff180
	dbf	d0,AlertDelay
	bra.s	EndKeyInt


;-----------------------------------------------------------------

SetMap:
	move.l	a0,KeyBoard
	move.l	a0,KeyBoard+4
	rts

;-----------------------------------------------------------------


	DSEG

KeyBoard:
	dc.l	KeyMap				;LowKeyMap	0
	dc.l	KeyMap				;HiKeyMap	4
	dc.l	KeyBuffer			;Buffer		8
	dc.w	0				;ActOffset	12
	dc.w	10				;max Groesse	14
	dc.b	0				;ActRawKey	16
	dc.b	0				;ActASCIIKey	17
	dc.w	0				;Qualifier	18

KeyBuffer:
	ds.b	12,0

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
