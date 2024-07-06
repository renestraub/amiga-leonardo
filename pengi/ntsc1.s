
	XDEF	SetInt,ResetInt,BeamCounter,PenPos
	XREF	MusicVBL,NTSCFlag,VisierHandler

	Include	"Equates.i"
	Include	"relcustom.i"
	
	CSEG

;-------------------------------------------------------------------
SetInt:
	movem.l	d0-d7/a0-a6,-(SP)
	lea	custom,a5
	move	intenar(A5),IntenaSave
	move	#$7fff,intena(a5)
	move	#$7fff,intreq(A5)
	move.l	IntVekt,IntSave
	move.l	#CopperInt,IntVekt
	move	#$7fff,intreq(A5)
	move	#$c030,intena(a5)
	movem.l	(SP)+,d0-d7/a0-a6
	bsr	SetNTSC
	rts

;-------------------------------------------------------------------
ResetInt:
	bsr	RestoreNTSC
	movem.l	d0-d7/a0-a6,-(SP)
	lea	custom,a5
	move	#$7fff,intena(A5)
	move	#$7fff,intreq(A5)
	move.l	IntSave,IntVekt
	move	IntenaSave,d0
	bset	#15,d0
	move	d0,intena(a5)
	movem.l	(SP)+,d0-d7/a0-a6
	rts
;-------------------------------------------------------------------
CopperInt:
	movem.l	d0-d7/a0-a6,-(SP)
	clr.l	0
	lea	custom,a5
	btst	#5,intreqr+1(a5)
	bne	VBInt
	bsr	MusicVBL
	bsr	VisierHandler
	addq	#1,BeamCounter
	move	#$0010,intreq(A5)
	movem.l	(SP)+,d0-d7/a0-a6
	rte
;-------------------------------------------------------------------
VBInt:
	bra	1$
	move.l	vposr(a5),d0
	and.l	#$1ffff,d0
	cmp.l	#$10500,d0
	bhi	1$
	move	d0,$dff180
	;move.w	d0,PenPos
1$:	
	move	#$0020,intreq(a5)
	movem.l	(SP)+,d0-d7/a0-a6
	rte

	BSS	PenPos,2

;-------------------------------------------------------------------
SetNTSC:
	movem.l	d0-d7/a0-a6,-(SP)
	lea	custom,a5
	move.l	NTSCVector,NTSCSave
	move.l	#NTSCInt,NTSCVector
	move	#$c000,intena(A5)
	movem.l	(SP)+,d0-d7/a0-a6
	rts

;-------------------------------------------------------------------
RestoreNTSC:
	movem.l	d0-d7/a0-a6,-(SP)
	lea	custom,a5
	move	#$4000,intena(A5)
	move.l	NTSCSave,NTSCVector
	movem.l	(SP)+,d0-d7/a0-a6
	rts

;-------------------------------------------------------------------
NTSCInt:
	move	#$0040,$dff096
	movem.l	d0-d7/a0-a6,-(SP)
	lea	custom,a5
	move	#$4000,intreq(A5)
	move.w	vhposr(a5),d0
	add	#$2818,d0
	tst	NTSCFlag
	beq	1$
	move	d0,vhposw(a5)
1$:	movem.l	(SP)+,d0-d7/a0-a6
	move	#$8040,$dff096
	rte

;-------------------------------------------------------------------
	movem.l	d0-d7/a0-a6,-(SP)

	movem.l	(SP)+,d0-d7/a0-a6
	rts
;-------------------------------------------------------------------


	DSEG

	BSS	BeamCounter,2
	BSS	IntenaSave,2
	BSS	IntSave,4
	BSS	NTSCSave,4

