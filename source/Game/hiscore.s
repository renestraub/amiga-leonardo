
	XDEF	GetPosition,InsertScore,hilist

namenslaenge	EQU	8
max_entry	EQU	10	

		CSEG

;	d0=score
;	d1=result
GetPosition:	
	movem.l	a0/d1/d2,-(a7)
	lea	hilist,a0
	clr	d2
hi_score_loop1:
	addq	#1,d2
	cmp	#max_entry+1,d2
	beq.s	found_entry
	add.l	#namenslaenge,a0
	move.l	(A0)+,d1
	cmp.l	d0,d1
	bhi.s	hi_score_loop1
found_entry:
	move	d2,d0
	cmp	#max_entry+1,d2
	bne.s	end_search_score
	clr	d0
end_search_score: 
	movem.l	(a7)+,a0/d1/d2
	rts

;	d0=Position
;	d1=Score
;	a1=TextBuffer

InsertScore:
	movem.l	d0-d2/a0-a2,-(a7)
	tst	d0			
	beq.s	end_hi			
	subq	#1,d0
	lea	hilist,a0
	move.l	a0,a2
	mulu	#namenslaenge+4,d0
	add.l	d0,a0
	move	#max_entry,d2
	mulu	#namenslaenge+4,d2
	add.l	d2,a2			

	cmp.l	a2,a0			
	beq.s	not_last
hi_score_loop2:
	move	-12(a2),(a2)		
	subq	#2,a2			
	cmp.l	a2,a0
	bne.s	hi_score_loop2
not_last:
	move.l	(A1)+,(a0)+		
	move.l	(A1)+,(A0)+			; Name
	move.l	d1,(a0)				; Score
end_hi:
	movem.l	(a7)+,d0-d2/a0-a2
	rts

	DSEG
	even
	BSS	hilist,512
