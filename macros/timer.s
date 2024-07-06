
	XDEF	TimerInit,TimerRemove,MusicVBL,Key

	CSEG

TimerInit:	move	#$8,$dff09a
		bsr	InitTimer
		lea	TimerIVeq,a1
		move.l	$68,(A1)
		move.l	#TimerInt,$68
		move	#$8008,$dff09a
		rts

TimerRemove:	move	#$8008,$dff09a
		lea	TimerIVeq,a1
		move.l	(A1),$68
		clr.b	$bfee01
		move.b	#1,$bfed01
		rts

InitTimer:	move.b	#$81,$bfed01
		move.b	#%10000001,$bfee01
		move.b	#129,$bfe401
		move.b	#55,$bfe501
		rts

TimerInt:	movem.l	d0-d7/a0-a6,-(sp)
		move.b	$bfed01,d0
		btst	#0,d0			;Timer Int ?
		beq	1$

		bsr	MusicVBL		; Sound abspielen
1$:
		btst	#3,d0			; KeyInt ?
		beq	2$

		clr.b	Key
		move.b	$bfec01,d0
		ori.b	#$40,$bfee01
		move.b	#$ff,$bfec01
		not.b	d0
		roxr.b	#1,d0
		move.b	d0,Key
	
		move.b	#$bf,$bfee01
2$:
		move	#$8,$dff09c

		movem.l	(sp)+,d0-d7/a0-a6
		dc.w	$4ef9
TimerIVeq:
		dc.l	0
