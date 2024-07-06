
	XREF	Main
	XDEF	Task,DosBase,GfxBase,IntBase,IffBase
	XDEF	StdOut,StdIn
	XDEF	StartUp

	CSEG

StartUp:
	move.l	SP,StartUpStack
	movem.l	d0-d7/a0-a6,-(SP)
	move.l	4,a6
	lea	IntLib,a1
	jsr	-408(A6)
	move.l	d0,IntBase
	lea	GfxLib,a1
	jsr	-408(A6)
	move.l	d0,GfxBase
	lea	DosLib,a1
	jsr	-408(A6)
	move.l	d0,DosBase
	lea	IffLib,a1
	jsr	-408(A6)
	clr.l	IffBase
	move.l	d0,IffBase
	sub.l	A1,A1
	jsr	-294(A6)	;FindTask()
	move.l	d0,Task
	move.l	D0,A4
	tst.l	172(A4)
	beq	FromWorkBench
	move.l	DosBase,a6
	jsr	-54(A6)
	move.l	d0,StdIn
	jsr	-60(A6)
	move.l	d0,StdOut
	movem.l	(SP)+,d0-d7/a0-a6
	movem.l	d0-d7/a0-a6,-(SP)
	bsr	Main
	bra	ExitStartUp

FromWorkBench:
	lea	92(A4),A0		;MsgPort
	jsr	-384(A6)		;WaitPort()
	lea	92(A4),A0
	jsr	-372(A6)		;GetMsg()
	move.l	D0,WBMessage	
	move.l	D0,A2
	move.l	36(A2),a0		

	move.l	DosBase,A6
	move.l	(A0),D1			;Lock
	jsr	-126(A6)		;CurrentDir

        move.l	#Con,d1
	move.l	#$3ee,d2
	jsr	-30(A6)
	move.l	d0,ConWindow

;	move.l	d0,StdOut
;	move.l	d0,StdIn	
	movem.l	(A7)+,d0-d7/a0-a6

	movem.l	d0-d7/a0-a6,-(SP)
	bsr	Main
	move.l	4,A6
	jsr	-132(A6)		;Forbid()
	move.l	WBMessage,A1
	jsr	-378(A6)		;ReplyMsg()
ExitStartUp:
	move.l	DosBase,a6
	move.l	ConWindow,d1
	beq	NoClose
	jsr	-36(A6)
NoClose:
	move.l	4,a6
	move.l	IffBase,a1
	move.l	a1,d0
	beq	NoIff
	jsr	-414(A6)
NoIff:
	movem.l	(SP)+,d0-d7/a0-a6
	move.l	StartUpStack,SP
	clr.l	d0
	rts       

	DSEG

	BSS	ConWindow,4
	BSS	StdIn,4
	BSS	StdOut,4
	BSS	StartUpStack,4
	BSS	Task,4
	BSS	StUDosBase,4
	BSS	WBMessage,4
	BSS	DosBase,4
	BSS	IntBase,4
	BSS	GfxBase,4
	BSS	IffBase,4
	
DosLib:
	dc.b	'dos.library',0
IntLib:
	dc.b	'intuition.library',0
GfxLib:
	dc.b	'graphics.library',0
IffLib:
	dc.b	'iff.library',0
Con:
	dc.b	'con:0/0/640/100/-C5-',0
	even

