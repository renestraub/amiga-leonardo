
	XDEF	Main,CliParse,CheckFile

	Include "h:chrismacros.i"
	
	LoadAddress:	EQU	$100

	CSEG

Main:		bsr	CliParse
		move.l	a0,a5
		cmp	#3,d0
		beq	OkParameters

NoFile:		move.l	(A5),Para
		printf	ErrorText,Para
		moveq	#0,d0
		rts

NoMem:		move.l	(A5),Para
		move.l	d7,Para+4
		printf	MemError,Para
		bra	CleanUp

FileError:	move.l	(A5),Para
		move.l	4(A5),Para+4
		printf	FileErrorText,Para
		bra	CleanUp

FileError2:	move.l	(A5),Para
		move.l	8(A5),Para+4
		printf	FileErrorText,Para
		bra	CleanUp


OkParameters:	move.l	4(A5),d0		; FileName
		bsr	CheckFile		
		move.l	d0,d7			; Laenge
		beq	FileError

		move.l	4,a6
		moveq	#0,d1
		jsr	-198(A6)		; AllocMem ()
		move.l	d0,Mem
		beq	NoMem

		move.l	d7,d0			; Laenge Source
		divu	#768,d0
		mulu	#640,d0
		move.l	d0,Len			; Laenge Ziel
		moveq	#0,d1
		jsr	-198(A6)		; AllocMem ()
		move.l	d0,Mem2
		beq	NoMem
		
		move.l	DosBase,a6
		move.l	4(A5),d1		; FileName
		move.l	#$3ed,d2
		jsr	-30(A6)
		move.l	d0,d6			; Open ()
		move.l	d0,d1
		beq	FileError
		move.l	Mem,d2			; Buffer
		move.l	d7,d3			; Laenge
		jsr	-42(A6)			; Read ()					
		cmp.l	#-1,d0
		beq	FileError
		move.l	d6,d1
		jsr	-36(A6)			; Close ()

		move.l	Mem,a0			; Source
		move.l	Mem2,a1			; Dest
		move.l	d7,d1
		divu	#768,d1
		subq	#1,d1			; Anzahl Bobs -1
2$:
		move	#159,d0
1$:
		move.l	(A0)+,(A1)+
		dbf	d0,1$
		add.l	#128,a0
		dbf	d1,2$

		move.l	DosBase,a6
		move.l	8(A5),d1		; FileName
		move.l	#$3ee,d2
		jsr	-30(A6)
		move.l	d0,d6			; Open ()
		move.l	d0,d1
		beq	FileError2
		move.l	Mem2,d2			; Buffer
		move.l	Len,d3			; Laenge
		jsr	-48(A6)			; Write ()					
		cmp.l	#-1,d0
		beq	FileError2
		move.l	d6,d1
		jsr	-36(A6)			; Close ()

CleanUp:	move.l	4,a6
		tst.l	Mem
		beq	3$
		move.l	Mem,a1			; MemBuffer
		move.l	d7,d0			; Laenge
		jsr	-210(A6)		; FreeMem ()

3$:		tst.l	Mem2
		beq	4$
		move.l	Mem2,a1			; MemBuffer
		move.l	Len,d0			; Laenge
		jsr	-210(A6)		; FreeMem ()
4$:
		moveq	#0,d0
		rts


		DSEG

ErrorText:	dc.b	"USAGE : %s InFile OutFile",10,0
MemError:	dc.b	"%s : Can't allocate %ld bytes",10,0
FileErrorText:	dc.b	"%s : Can't open %s",10,0


Text4:		dc.b	"*** BREAK",10,0

		BSS	Para,20
		BSS	Mem,4
		BSS	Mem2,4
		BSS	Len,4


