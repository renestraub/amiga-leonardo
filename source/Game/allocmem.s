	CSEG

	XDEF	AllocMem,FreeMem,AvailMem,InitAlloc
	XREF	OutOfMemory,MemoryHeader

;Speicherverwaltungsroutinen

AvailMem:
	movem.l	d1-d7/a0-a6,-(SP)
	move.l	MemoryPointer,a0
	move.l	(A0),a0
	moveq	#0,d0
AvailMemLoop:
	add.l	8(A0),d0
	move.l	4(A0),a0
	move.l	a0,d1
	bne.s	AvailMemLoop
	movem.l	(Sp)+,d1-d7/a0-a6
	rts

GarbageCollection:
	movem.l	d0-d7/a0-a6,-(SP)
GarbageLoop:
	move.l	MemoryPointer,a0
	move.l	4(A0),a5
	move.l	(a0),a0	

GarbageSearch:
	move.l	a0,a1
	move.l	4(A0),a0
	move.l	a0,d0		;kein Node mehr ?
	beq.s	EndGarbageCollection
	tst.l	8(A0)		;ist dieser Node frei ?
	beq.s	GarbageSearch	;nein -> loop
	tst.l	8(A1)		;war letzter Node frei ?
	beq.s	GarbageSearch
	move.l	4(A0),4(A1)	;NextZeiger in letzten Node
	move.l	4(A0),a2
	move.l	a1,(A2)

	move.l	a2,d0		;Letzter Node ?	
	bne.s	NoLastGarbage	;nein
	move.l	a5,a2
NoLastGarbage:
	sub.l	a1,a2
	sub	#12,a2
	move.l	a2,8(A1)
	bra	GarbageLoop

EndGarbageCollection:
	movem.l	(SP)+,d0-d7/a0-a6
	rts


FreeMem:
	bsr	FreeMemIt
	bsr	GarbageCollection
	;bsr	PrintAvail
	rts




FreeMemIt:
	movem.l	d0-d7/a0-a6,-(SP)
	move.l	a1,d0
	beq.s	EndFreeMem
	sub	#12,a1
	move.l	MemoryPointer,a0
	move.l	4(A0),a0		;Speicherschluss
	move.l	a0,a5
	move.l	4(A1),a2		;Zeiger auf nächsten Node
	move.l	a2,d0
	bne.s	NoLastNode
	sub.l	a1,a0
	sub	#12,a0
	move.l	a0,8(A1)
	movem.l	(Sp)+,d0-d7/a0-a6
	rts




NoLastNode:
	sub.l	a1,a2
	sub	#12,a2
	move.l	a2,8(A1)
EndFreeMem:
	movem.l	(SP)+,d0-d7/a0-a6
	rts





AllocMem:
	bsr	AllocIt
	;bsr	PrintAvail
	rts



AllocIt:
	movem.l	d1-d7/a0-a6,-(SP)
	add.l	#12,d0
	move.l	MemoryPointer,a0
	move.l	(A0),a0
AllocMemLoop:
	cmp.l	8(A0),d0		;genug freier Speicher ?
	ble.s	MemNodeFound
	move.l	4(A0),a0		;Zeiger auf nächsten Node
	move.l	a0,d1			;nach d1
	bne.s	AllocMemLoop		;wenn nicht 0 -> testen
	moveq	#0,d0			;sonst -> not enough Memory
	jmp	OutOfMemory
	movem.l	(SP)+,d1-d7/a0-a6
	rts



MemNodeFound:
	cmp.l	8(A0),d0		;free Mem = gewünschtes Mem?
	bne.s	MakeNewNode		;Nein
	clr.l	8(A0)			;kein freier Platz mehr
	add	#12,a0			;Zeiger hinter den Node
	move.l	a0,d0			;Adresse nach d0
	movem.l	(SP)+,d1-d7/a0-a6	;Ende
	rts



MakeNewNode:
	move.l	a0,a2			;zeiger auf node
	add.l	d0,a2			;gewueschtes Me dazu
	move.l	a0,(A2)			;letzer Node in neuen Node
	move.l	4(A0),4(A2)		;nächster Node in neuen Node
	move.l	a2,4(A0)		;neuer Node in alten Node
	move.l	8(A0),d1		;alte groesse holen
	clr.l	8(A0)			;loeschen
	sub.l	d0,d1			;neue groesse subtrahieren
	move.l	d1,8(A2)		;groesse des neuen nodes
	add	#12,a0
	move.l	a0,d0
	movem.l	(SP)+,d1-d7/a0-a6
	rts




InitAlloc:
	movem.l	d0-d7/a0-a6,-(SP)
	lea	MemoryPointer,a1
AllocInitLoop:
	move.l	(a1)+,a0		;MemoryHeader
	move.l	a0,d0
	beq.s	EndInitAlloc
	move.l	(a0),a2			;start
	move.l	4(A0),a3		;Ende
	clr.l	(A2)
	clr.l	4(A2)
	sub.l	a2,a3
	sub	#12,a3
	move.l	a3,8(A2)
	bra.s	AllocInitLoop
EndInitAlloc:
	movem.l	(SP)+,d0-d7/a0-a6
	bsr	AvailMem
	rts


	DSEG
	even

MemoryPointer:
	dc.l	MemoryHeader
	dc.l	0

MemoryHeader:
	dc.l	$14000
	dc.l	$17e60

 ;MemoryNode:
 ;	dc.l	0	;LastNode
 ;	dc.l	0	;NextNode
 ;	dc.l	0	;FreeMemory

