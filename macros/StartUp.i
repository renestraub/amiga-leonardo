

		XDEF	StartUp,OpenGfx,OpenDos,OpenInt,DosBase,ConWindow,StdOut

                CSEG

StartUp:
		move.l	4,a6
		lea	GfxText,a1
		jsr	-408(A6)
		move.l	d0,GfxBase

		lea	IntText,a1
		jsr	-408(A6)
		move.l	d0,IntBase

		lea	DosText,a1
		jsr	-408(A6)
		move.l	d0,DosBase

		sub.l	a1,a1
		jsr	-294(a6)		; eigenen Task suchen
		move.l	d0,a4
		tst.l	$ac(A4)			; Start vom CLI oder Workbench
		bne.s	FromCLI			; Es war das CLI
		lea	$5c(A4),a0		; MSGPort holen
		jsr	-384(a6)		; WaitPort
		lea	$5c(A4),a0
		jsr	-372(a6)		; GetMsg

		move.l	DosBase,a6
                move.l	#Con,d1
		move.l	#$3ee,d2
		jsr	-30(A6)
		move.l	d0,ConWindow
		bra     FromWb
FromCLI:
		move.l	DosBase,a6
		jsr	-60(A6)
FromWb:
		move.l	d0,StdOut
		rts

                DSEG

GfxBase:        dc.l	0
DosBase:	dc.l	0
IntBase:	dc.l	0

GfxText:	dc.b	'graphics.library',0
DosText:	dc.b	'dos.library',0
IntText:        dc.b	'intuition.library',0
Con:		dc.b	'CON:0/0/640/80/Startup-Window',0

		even
