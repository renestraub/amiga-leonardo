
	XDEF	AddInt,RemInt,MyInt,OldInt
	XDEF	SetPlane,DelayBlank,CopyPage
	XDEF	OutOfMemory
	XDEF	FadeIn,FadeOut
	XDEF	MoveBobs,MoveBob,RemBob,BobList
	XDEF	page,page1,page2,pagel,BlackCopper

	XDEF	BitmStr1,BitmStr2,FlipFlag

	Include	"h:relcustom.i"
	Include	"h:bobcoms.i"

	CSEG

DelayBlank:
1$:		btst		#5,$1f(A5)
		beq		1$
		rts

OutOfMemory:	moveq		#0,d0
4$:		move		d0,$dff180
		addq		#1,d0
		bra		4$


FadeOut:	moveq		#16,d6
5$:
		move.l		a3,a1
		move.l		a4,a2

		moveq		#31,d7
4$:		cmp.l		#0,a1
		beq		8$
		move		(A1),d1
		bsr		FadeOneColors
		move		d3,(A1)
		addq.l		#4,a1
8$:
		cmp.l		#0,a2
		beq		9$
		move		(A2),d1
		bsr		FadeOneColors
		move		d3,(A2)
		addq.l		#4,a2
9$:
		dbf		d7,4$

		bsr		Delay2000
		bsr		Delay2000
		dbf		d6,5$

		move.l		#BlackCopper,cop1lc(A5)
		rts


Delay2000:	move.l	d7,-(sp)
		move	#$4000,d7
1$:
		dbf	d7,1$
		move.l	(sp)+,d7
		rts

;		a0=FirstCopper/a1=SecondCopper/a2=Color1/a3=Color2	

FadeIn:		movem.l		d0-d7/a0-a6,-(sp)

		move.l		a0,a4
		move.l		a1,a5
		move.l		a2,d4
		move.l		a3,d5

		moveq		#31,d7
14$:		cmp.l		#0,a0
		beq		12$
		clr		(A0)
		addq.l		#4,a0	
12$:
		cmp.l		#0,a1
		beq		13$
		clr		(A1)
		addq.l		#4,a1
13$:		dbf		d7,14$	

		moveq		#16,d6
5$:
		move.l		a4,a0
		move.l		a5,a1
		move.l		d4,a2
		move.l		d5,a3

		moveq		#31,d7
4$:
		cmp.l		#0,a0
		beq		8$

		move		(A0),d1			; Aktuelle Farbe
		move		(A2)+,d2		; Soll-Farbe
		bsr		FadeInOneColor
		move		d0,(A0)
		addq.l		#4,a0
8$:
		cmp.l		#0,a1
		beq		9$
		move		(A1),d1
		move		(A3)+,d2
		bsr		FadeInOneColor
		move		d0,(A1)
		addq.l		#4,a1
9$:
		dbf		d7,4$

		bsr		Delay2000
		bsr		Delay2000
		dbf		d6,5$

		movem.l		(sp)+,d0-d7/a0-a6
		rts


FadeInOneColor:
		movem.l		d1-d6,-(sp)
		move		d1,d3
		move		d3,d4

		move		d2,d5
		move		d5,d6

		and		#$00F,d1		; Ist
		and		#$00F,d2		; Soll
		cmp		d2,d1
		beq		1$
		addq		#$001,d1
1$:
		and		#$0F0,d3
		and		#$0F0,d5
		cmp		d5,d3
		beq		2$
		add		#$010,d3
2$:
		and		#$F00,d4
		and		#$F00,d6
		cmp		d6,d4
		beq		3$
		add		#$100,d4
3$:
		or		d1,d3
		or		d3,d4
		move		d4,d0
		movem.l		(sp)+,d1-d6
		rts


FadeOneColors:
		move		d1,d2
		move		d2,d3

		and		#$00F,d1
		tst		d1
		beq		1$
		subq		#$001,d1
1$:
		and		#$0F0,d2
		tst		d2
		beq		2$
		sub		#$010,d2
2$:
		and		#$F00,d3
		tst		d3
		beq		3$
		sub		#$100,d3
3$:
		or		d1,d2
		or		d2,d3
		rts


AddInt:		lea		OldInt,a0
		move.l		$6c,(A0)
		move.l		#MyInt,$6c
		move		#$8020,intena(A5)	; interrupt zulassen
		rts

RemInt:		lea		OldInt,a0
		move.l		(A0),$6c
		rts

MoveBobs:	lea		BobList,a0
MoveBobs2:	move.l		(A0),a0
		cmp.l		#0,a0
		beq		EndMoveBobs

		move.l		76(A0),a1		;RelMovePrg
		move.l		a1,d0			;vorhanden ?
		beq.s		EndRelMove
		move		80(A0),d0		;PC holen
		bclr		#15,d0
		addq		#4,80(a0)		;PC erhöhen
		move		(a1,d0.w),d1		;X Move
		move		2(A1,d0.w),d2		;Y Move holen

		cmp		#PrgRelCom,d1		;ist es Kommando ?
		bne.s		RelNoCom		;nein ->

		cmp		#PrgEnde,d2
		beq		RelEnde
		cmp		#PrgLoop,d2		;Prg neu beginnen ?
		beq.s		RelLoop			;ja ->
		cmp		#PrgJump,d2
		beq		RelJump

		bra.s		RelRemove		;wenn unbekannt -> Bob removen

RelJump:
		movem.l		d0-d7/a0-a6,-(sp)
		move.l		4(A1,d0.w),a4
		jsr		(A4)
		movem.l		(sp)+,d0-d7/a0-a6
		addq		#4,80(A0)
		bra		EndRelMove
RelEnde:
		subq		#4,80(a0)
		bset		#7,80(A0)
		bra.s		EndRelMove
RelRemove:
		bsr		RemBob			;Bob removen
		bra.s		EndRelMove
RelLoop:
		clr		80(A0)			;Programm neu starten
		bset		#7,80(A0)
		bra.s		EndRelMove		;PC löschen
RelNoCom:
		bsr		MoveBob			;Bob bewegen
EndRelMove:	
		bra		MoveBobs2
EndMoveBobs:
		rts

SetPlane:	lea		BitmStr1+8,a0
		tst		FlipFlag
		beq		10$

		lea		BitmStr2+8,a0
10$:
		lea		page+2,a1
		moveq		#4,d7
5$:
		move.l		(A0)+,d0
		move		d0,4(A1)
		swap		d0
		move		d0,(A1)
		addq.l		#8,a1
		dbf		d7,5$
		rts


CopyPage:	lea		page2,a1
		lea		page1,a2
		move		#(pagel/4)-1,d0
1$:
		move.l		(A1)+,(A2)+
		dbf		d0,1$
		rts
