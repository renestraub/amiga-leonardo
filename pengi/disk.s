
		XDEF	Read,Write
		XDEF	LoadFile,ChangeDir

		NoError:	EQU	0
		FileNotFound:	EQU	-1
		DirNotFound:	EQU	-2
		NoFile:		EQU	-3
		NoDirectory:	EQU	-4

		CSEG


; A4 = Name
; A5 = Ziel

LoadFile:	bsr	ReadDir
		move.l	a4,a1
		bsr	CalcHash
		tst     d0
		beq	1$

                lea	Buffer,a0
		move.l	(A0,d0),d6		; FileHeaderBlock
5$:
		lea	Buffer,a0
		move.l	#512,d7
		bsr	ReadBlock		; FileHeaderBlock lesen

		move.l	a4,a1
		lea	Buffer+432,a2
		moveq	#0,d7
		move.b	(A2)+,d7
		subq	#1,d7
		move.b	#$DF,d2
3$:
		move.b	(A2)+,d0
		move.b	(A1)+,d1
		and.b	d2,d0
		and.b	d2,d1
		cmp.b	d0,d1
		bne	4$			; Falscher Name
		dbf	d7,3$

		cmp.l	#-3,Buffer+508
		bne	16$

		move.l	Buffer+324,d3		; Laenge
		divu	#512,d3
		swap	d3			; Rest=Laenge des letzten Blockes

9$:		lea	Buffer+312,a3

8$:		cmp.l	#Buffer+24,a3
		beq	7$			; Extension suchen

		move.l	#512,d7
		tst.l	-8(A3)
		beq	14$
		move.l	-(A3),d6
		tst.l	d6
		beq	6$			; Keine Bloecke mehr

		move.l	a3,a2
		move.l	d6,d5			; zu lesender Block

11$:		addq.l	#1,d5			; naechster Block
		tst.l	-8(A2)
		beq	13$			; letzten Block nicht lesen
		cmp.l	-(A2),d5
		bne	12$			; kein aufeinanderfolgender
						; Block mehr
		add.l	#512,d7
		bra	11$
12$:		
		addq.l	#4,a2
13$:
		move.l	a2,a3
10$:
		move.l	a5,a0
		add.l	d7,a5			; Neues Ziel
		bsr	ReadBlock
		bra	8$

7$:		move.l	Buffer+504,d6
		move.l	#512,d7
		lea	Buffer,a0
		bsr	ReadBlock		; Extension laden
		bra	9$			; weiter laden

14$:		move.l	-(A3),d6
		move.l	#512,d7
		lea	Buffer,a0
		bsr	ReadBlock		; letzten Block lesen

		lea	Buffer,a0
		subq	#1,d3
15$:
		move.b	(A0)+,(A5)+
		dbf	d3,15$
		bra	6$

4$:		move.l	Buffer+496,d6		; NextHash
		bne	5$			; Load NextHash

1$:		moveq	#FileNotFound,d0
		rts

6$:		moveq	#NoError,d0
		rts

16$:		moveq	#NoFile,d0
		rts

ReadDir:        lea     Buffer,a0
		move.l	CurrentDir,d6
		add.l	LowBlock,d6
		move.l  #512,d7
		bsr	Read
		rts


; A4=Zeiger auf Name

ChangeDir:	bsr	ReadDir
		move.l	a4,a1
		bsr	CalcHash
		tst     d0
		beq	1$

                lea	Buffer,a0
		move.l	(A0,d0),d6		; FileHeaderBlock
5$:
		lea	Buffer,a0
		move.l	#512,d7
		bsr	ReadBlock		; FileHeaderBlock lesen

		move.l  a4,a1
		lea	Buffer+432,a2
		moveq	#0,d7
		move.b	(A2)+,d7
		subq	#1,d7
		move.b	#$DF,d2
3$:
		move.b	(A2)+,d0
		move.b	(A1)+,d1
		and.b	d2,d0
		and.b	d2,d1
		cmp.b	d0,d1
		bne	4$			; Falscher Name
		dbf	d7,3$

		cmp.l	#2,Buffer+508
		bne	6$

		sub.l	LowBlock,d6
		move.l	d6,CurrentDir
		moveq	#NoError,d0
		rts

4$:		move.l	Buffer+496,d6		; NextHash
		bne	5$			; Load NextHash

1$:		moveq	#DirNotFound,d0
		rts

6$:		moveq	#NoDirectory,d0
		rts


CalcHash:	tst.b	(A1)
		beq	5$

                move.l	a1,a2
		moveq	#0,d0
1$:		addq	#1,d0
		tst.b	(A2)+
		bne	1$
		subq	#1,d0			; Hash=Laenge

		move.l	d0,d7
		subq	#1,d7
2$:
		mulu	#13,d0                  ; Hash=Hash*13
		moveq	#0,d1
		move.b	(A1)+,d1

		cmp	#'a',d1
		blo     3$
		cmp	#'z',d1
		bhi	3$
		and	#$df,d1
3$:
		add.l	d1,d0                   ; Hash=Hash+Ascii
		and.l	#$7FF,d0		; Hash=Hash&$7FF
		dbf	d7,2$

                divu	#72,d0
		swap	d0
                ext.l	d0
		addq.l	#6,d0
		lsl.l	#2,d0
4$:		rts

5$:        	moveq	#0,d0
		bra	4$


ReadBlock:	lsl.l	#8,d6
		lsl.l	#1,d6
		add.l	LowBlock,d6
		bra	Read

		DSEG

LowBlock:	dc.l	1360*512
CurrentDir:	dc.l	20230*512

                BSS	Buffer,512

