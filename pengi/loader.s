
	XDEF	LoadFile,ChangeDir
	XDEF	Main,CliParse,DetachFlag

	INCLUDE "h:chrismacros.i"
	INCLUDE "h:exec.i"
	
	LoadAddress:	EQU	$100

	CSEG

Main:		bsr	CliParse
		cmp	#1,d0
		beq	OkParameter

		move.l	(a0),Para
		Printf	ErrorText,Para
		rts


OkParameter:	move.l	#FileName,Para
		move.l	#LoadAddress,Para+4
		Printf	LoaderText,Para

o2:		btst	#6,$bfe001
		beq	Start

		btst	#10,$dff016
		bne	o2
		rts

Start:		move.l	4,a6
		jsr	Disable(A6)		; Disable()
		lea	super,a5
		jmp	-30(a6)
super:
		addq.l	#8,a7
		move	#$7fff,$dff09a
		move	#$7fff,$dff096

		lea	LoadAddress,a0
		move.l	#131008,d0
1$:
		clr.l	(A0)+
		subq.l	#1,d0
		bne	1$

		lea	DirName,a4
		bsr	ChangeDir
		lea	FileName,a4
		lea	$100,a5
		bsr	LoadFile

		jmp	LoadAddress
		rts


		DSEG

		BSS	Para,8
		BSS	DetachFlag,2

DirName:	dc.b	'pengi',0
FileName:	dc.b    'a.out',0
LoaderText:	dc.b	'Loading '
		C3
		dc.b	'%s'
		C1	
		dc.b	' at $%lx',10
		dc.b	'Press left mousebutton to start',10
		dc.b	'right mousebutton to exit',10,0

ErrorText:	dc.b	"*** ERROR : "
		C3
		dc.b	"%s"
			C1
		dc.b	" need's no parameters !",10,0

