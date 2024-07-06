
	XDEF	AddNTSC,RemNTSC

	Include	"relcustom.i"
	
	NTSCVector:	EQU	$78
	
	CSEG

Main:	move	$dff000+intenar,IntenaSave
	move.l	#Copperl,$dff080

	bsr	AddNTSC

1$:	btst	#6,$bfe001
	bne	1$

	bsr	RemNTSC

	move	IntenaSave,d0
	or	#$c000,d0
	move	d0,$dff09a

	move.l	#$420,$dff080

	moveq	#0,d0
	rts


;-------------------------------------------------------------------
AddNTSC:	movem.l	d0-d7/a0-a6,-(SP)
		lea	custom,a5			; BaseAdress
		move	#$7fff,intena(a5)		; No Int's allowed
		move	#$7fff,intreq(A5)		; Clear all Int's
		move.l	NTSCVector,NTSCSave		; Save Interrupt
		move.l	#NTSCInt,NTSCVector		; Install my Int
		move	#$c000,intena(A5)		; Enable my Int
		movem.l	(SP)+,d0-d7/a0-a6
		rts

;-------------------------------------------------------------------
RemNTSC:	movem.l	d0-d7/a0-a6,-(SP)
		lea	custom,a5			; BaseAddress
		move	#$7fff,intena(A5)		; No Int's allowed
		move	#$7fff,intreq(A5)		; Clear all Int's
		move.l	NTSCSave,NTSCVector		; Restore IntVektor
		movem.l	(SP)+,d0-d7/a0-a6
		rts

;-------------------------------------------------------------------
NTSCInt:	movem.l	d0-d7/a0-a6,-(SP)
		lea	custom,a5
		move	#$0040,dmacon(A5)		; Blitter aus

		move.l	vposr(a5),d0
		move.l	d0,d1
		and.l	#$8001ffff,d0
		cmp.l	#300,d0				; Beam zwischen NTSC-PAL
		blo	1$				; -> Ende NTSC ueberspringen

		move	#$f00,$dff180
		sub.l	#$000034b0,d1			; Beam von 308 auf 256
		move.l	d1,vposw(A5)
		bra	2$

1$:		move	#$0f0,$dff180
		add.l	#$0000052b,d1			; Beam von 260 auf 265 
		move.l	d1,vposw(A5)	
2$:
		move	#$4000,intreq(A5)		; Interrupt loeschen
		move	#$8040,dmacon(A5)		; Blitter ein
		movem.l	(SP)+,d0-d7/a0-a6
		rte


;-------------------------------------------------------------------

	DSEG

		BSS	NTSCSave,4
		BSS	IntenaSave,4

Copperl:
		dc.w	$008e,$2c81
		dc.w	$0090,$f4c1
		dc.w	$0092,$0038
		dc.w	$0094,$00d0
		dc.w	$0100,$1200

		dc.w	$00e0,$0000
		dc.w	$00e2,$0000

		dc.w	$0180,$0000
		dc.w	$0182,$0fff

		dc.w	$ffdf,$fffe
		dc.w	$0421,$fffe			; Zeile 259
		dc.w	$009c,$c000

		dc.w	$4221,$fffe			; Zeile 307
		dc.w	$009c,$c000
	
		dc.w	$ffff,$fffe
	
