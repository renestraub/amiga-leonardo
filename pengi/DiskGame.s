
	Include	"h:constants.i"
	Include	"h:relcustom.i"
	Include	"h:copper.i"
	Include	"h:bobcoms.i"
	Include	"macros"

	XDEF	AllocMem,FreeMem,InitAlloc,AvailMem
	XDEF	OutOfMemory,Fin,back,MenuInt

	XDEF	SetAnim,MoveBob,SetBob,AskBob,AddBob,RemBob
	XDEF	DrawSaveBuffer,DrawBobs
	XREF	BitmStr1,BitmStr2,SpeedFlag,FlipFlag,AllocMem,FreeMem
	XDEF	AnzBob,BobList,FirstDefs,CheatFlag

	XDEF	Delay2000,SetMenuSprite,PrintMenuLetter,Scroll
	XDEF	MenuScroll,FadeOut,AddInt,RemInt,CheckColl
	XDEF	CheckDiamond,CheckDrawBlock,CheckDelBlock
	XDEF	YPos,page2,ScrollX2,BMask
	XDEF	FontBase,SchwCopp,SetPlane,CopyPage,GeneratePage
	XDEF	MenuCols,BlackCopper,OldInt,MyInt,SetUpPage
	XDEF	CollList,First,EndFlag,XBlock,YBlock,ActBlock
	XDEF	DrawCnt,XBlock2,YBlock2,DelCnt,MoveBobs,CopyLevel
	XDEF	ClearPages,ClearMenuPage,UpDateRadar,SetWalkAnim,SetBobbyAnim
	XDEF	CopyToBob,copperl,PanelCols,CheckTime,CheckESC
	XDEF	OutOfMemory,HiScoreCopper2,HiColors2
	XDEF	Key,Time,Anim1,Anim4,Bob4,back,BobImage,StopCnt,BitmStr1,BitmStr2
	XDEF	Second,top,panel,Bob1,Bob2,Bob3,Score,AsciiBuffer,FontBreite,BobList,RemBob,MoveBob
	XDEF	Level,FlipFlag,page1,pagel,planel,ScrollText
	XDEF	OldScroll,ScrollPointer,ScrollX,colors,UpFlag,DownFlag,WalkLeft
	XDEF	WalkRight,WalkUp,WalkDown,XPos,UnMove1,UnMove2,PauseFlag
	XDEF	AnzBob,x,y,InitVars,MenuSpr1,MenuSpr2,scrollx,page,PrintHiLetter
	XDEF	PrintText2,GameOverText,WaitButton,ClearHiPage,FadeIn,HiScoreText
	XDEF	GetNameText,PrintText3,GetNameText2,HiTab,WidhtTab,ShowBonus
	XDEF	GetText,GetText2,GetPointer,EndGetText,DelayBlank,ClearBlock
	XDEF	GetPosition,InsertScore,hilist,HiScoreText2,Lives
	XDEF	LivesLeftText,ClearSpr,NextLevelText,HiSprite1,HiSprite2
	XDEF	ShowNextLevel,ShowGameOver,ShowLivesLeft,ShowEndGame,DosBase,StdOut
	XDEF	ConvertHiList,HiScoreCopper,HiColors,HiScore,GetName,HiFile
	XDEF	Level,LevelPtr,LevelEnd,HiPoints,LevelLenght,ShowTimeOut,Bonus
	XDEF	PosX,PosY,MSpr1,MSpr2,MSpr3,MSpr4,Caught,_GetJoy,_SetSprPos
	XDEF	CheckBonus,BPage,EndeOffset,GOOffset,MemoryHeader,GetName2
	XDEF	StartLevel,ActLevel,ShowPerfect,CheckSound,SoundFlag
	XDEF	CheckPause,CheckBobs

	XDEF	SetSound,MusicVBL,LockVoices,SongPtr
	XDEF	Decruncher,Button

	XDEF	InitDiskAndKey,GetKey,KeyBoard
	XDEF	Read,Write,CaughtOffset,HiOffset

	BobLenght:	EQU	60800
	planel:		EQU	19200
	pagel:		EQU	5*planel

	top:		EQU	$7e000
	page1:		EQU	top-pagel
	page2:		EQU	page1-pagel

	back:		EQU	page2-38464
	panel:		EQU	back-6464
	FontBase:	EQU	panel-19064
	BobBase:	EQU	FontBase-BobLenght
	SongBase:	EQU	BobBase-97384

	FontBreite:	EQU	40
	BPage:		EQU	7680

	BigOffset:	EQU	0*512
	MenuOffset:	EQU	333*512
	CaughtOffset:	EQU	412*512
	HiOffset:	EQU	446*512
	EndeOffset:	EQU	447*512
	HelpOffset:	EQU	540*512
	GOOffset:	EQU	606*512

	CSEG

o:		lea		$80000,a7
		clr.l		0
		bclr		#1,$bfe001
		move.l		#BlackCopper,$dff000+cop1lc

		bsr		InitDiskAndKey
		bsr		GetKey

		lea		$dff000,a5
		move		#$83f0,dmacon(A5)

;c4:		LoadCruFile	#Caught,#CaughtBase,#14704
;c5:		LoadCruFile	#Music,#SongBase,#83070
;c6:		LoadCruFile	#Bob,#BobBase,#BobLenght
;c7:		LoadCruFile	#Font,#FontBase,#12762
;c8:		LoadCruFile	#Pan,#panel,#3776
;c9:		LoadCruFile	#Picture,#back,#17506

c4:		LoadCruFile	SongBase,BigOffset,333*512
c11:		LoadFile	hilist,HiOffset,512

		move.l		#SongBase,SongPtr

		move.l		#BobBase,BobDef1+16
		move.l		#BobBase+(640*40),BobDef2+16
		move.l		#BobBase+(640*46),BobDef3+16
		move.l		#BobBase+(640*54),BobDef4+16
		move.l		#BobBase+(640*89),BobDef5+16

		bsr		ConvertHiList

		move.l		#ScrollText,OldScroll
		move.l		#ScrollText,ScrollPointer
		clr		ScrollX
		move		#10,ScrollX2
		clr.b		StopCnt
		clr.b		MenuInt
		bsr		ClearMenuPage
		bsr		AddInt
MenuLoop2:
		move.l		#ScrollText,OldScroll
		move.l		#ScrollText,ScrollPointer
		clr		ScrollX
		move		#10,ScrollX2
		clr.b		StopCnt
		bsr		ClearMenuPage
		clr.b		MenuInt

		moveq		#0,d0
		bsr		SetSound

		move.l		#BlackCopper,cop1lc(A5)
c10:		LoadFile	page1,MenuOffset,40448

		move.l		#MenuSpr1,d0
		move.l		#MenuSpr2,d1
		lea		MenuSprites+2,a1
		move		d0,4(A1)
		swap		d0
		move		d0,(A1)
		move		d1,12(A1)
		swap		d1
		move		d1,8(A1)

		move.l		#HiSprite1,d0
		move.l		#HiSprite2,d1
		lea		HiSprites+2,a1
		move		d0,4(A1)
		swap		d0
		move		d0,(A1)	
		move		d1,12(A1)
		swap		d1
		move		d1,8(A1)
MenuLoop3:
		clr		YPos
		bsr		ClearMenuPage
		move.l		#ScrollText,OldScroll
		move.l		#ScrollText,ScrollPointer
		clr		ScrollX
		move		#10,ScrollX2
		clr.b		StopCnt
		move.b		#1,MenuInt

		bsr		SetMenuSprite

		move.l		#MenuCopper,cop1lc(A5)
		lea		MenuCols+2,a0
		lea		FontBase+19000,a2
		sub.l		a1,a1
		bsr		FadeIn

MenuLoop:	bsr		DelayBlank
		bsr		DelayBlank
		bsr		DelayBlank
		bsr		DelayBlank

		GetJoy		()

		cmp.l		#1,d1
		bne		12$
		cmp		#3,YPos
		beq		12$
		addq		#1,YPos
12$:
		cmp.l		#-1,d1
		bne		13$
		tst		YPos
		beq		13$
		subq		#1,YPos
13$:
		bsr		SetMenuSprite

		tst.b		Button
		bne		2$

		cmp		#3,YPos
		bne		14$

		move.b		#2,MenuInt
		bsr		GetName2
		bra		MenuLoop3

14$:		cmp		#2,YPos
		bne		11$

		lea		MenuCols+2,a3
		sub.l		a4,a4
		bsr		FadeOut
		move.b		#2,MenuInt

		move.l		#HiScoreCopper2,cop1lc(A5)
		LoadCruFile	page2,HelpOffset,66*512
		lea		HiColors2+2,a0
		lea		page2+31200+20000,a2
		sub.l		a1,a1
		bsr		FadeIn
		bsr		WaitButton
		lea		HiColors2+2,a3
		sub.l		a4,a4
		bsr		FadeOut
		bra		MenuLoop3

11$:		cmp		#1,YPos
		bne		10$
		move.b		#2,MenuInt
		bsr		HiScore
		bra		MenuLoop3

10$:		tst		YPos
		bne		2$
		move.b		#2,MenuInt
		move		#$F,$96(A5)
		bsr		BeginGame
		bra		MenuLoop2

2$:		btst		#6,$bfe001
		beq		Quit
		bra		MenuLoop


Quit:		lea		$dff000,a5
		move		#$F,$96(A5)

		jmp		$fc00d2

;		bsr		RemInt
;		bsr		RestoreKey

;		move.l		#$420,cop1lc(A5)
;		move		#$c000,$dff09a
;		moveq		#0,d0
;		rts


BeginGame:	lea		MenuCols+2,a3
		sub.l		a4,a4
		bsr		FadeOut

		move.b		#5,Lives

		moveq		#0,d0
		move		StartLevel,d0
		move		d0,ActLevel
		mulu		#126,d0

		add.l		#Level,d0
		move.l		d0,LevelPtr
		clr		StartLevel

		clr.l		Score

Begin2:		moveq		#1,d0
		bsr		SetSound

		move.l		#$10000,MemoryHeader
		move.l		#$10000+$3000,MemoryHeader+4
		bsr		InitAlloc
		bsr		InitVars
		bsr		ClearPages
		bsr		SetColors

		bsr		SetSprites
		bsr		ClearPages
		bsr		CopyLevel
		lea		FirstDefs,a1
		move		4(A1),UnMove1
		move		6(A1),UnMove2

		bsr		GeneratePage
		bsr		SetUpPage
		bsr		CopyPage
		bsr		UpDateRadar

		lea		FirstDefs,a2
		lea		BobDef1,a1
		move		8(A2),4(A1)
		move		10(A2),6(A1)
		bsr		AddBob
		move.l		d0,Bob1
		move.l		d0,a0
		or.b		#$80,80(A0)		; Leonardo

		lea		BobDef2,a1
		bsr		AddBob
		move.l		d0,Bob2
		move.l		d0,a0
		move.l		72(A0),ImageList
		move		#Invisible,20(A0)
		or.b		#$80,80(A0)		; MovingBlock

		lea		FirstDefs,a1
		move		(A1)+,d6
		move		(A1)+,d7

		lea		BobDef3,a1
		move		d6,4(A1)
		move		d7,6(A1)
		bsr		AddBob
		move.l		d0,Bob3
		move.l		d0,a0
		or.b		#$80,80(A0)		; Zombie 1

		lea		BobDef4,a1
		move		d6,4(A1)
		move		d7,6(A1)
		bsr		AddBob
		move.l		d0,Bob4
		move.l		d0,a0
		or.b		#$80,80(A0)		; Zombie 2

;		lea		BobDef5,a1
;		move		d6,4(A1)
;		move		d7,6(A1)
;		bsr		AddBob
;		move.l		d0,Bob5
;		move.l		d0,a0
;		or.b		#1,88(A0)		; GeisterHaus

		clr.l		MSpr1
		move.l		#$80,MSpr2
		clr.l		MSpr3
		move.l		#$80,MSpr4

		move.l		Bob1,a0
		move		8(A0),d0
		sub		#160,d0
		move		10(A0),d1
		sub		#100,d1
		bsr		SetPlane

		move.l		#copperl,cop1lc(A5)

		lea		colors+2,a0
		lea		back+38400,a2
		lea		PanelCols+2,a1
		lea		panel+6400,a3
		bsr		FadeIn

		clr.b		MenuInt

WaitMouse:	bsr		Delay2000
		bsr		UpDateRadar

		tst		EndFlag
		bne		Ende

		btst		#6,$bfe001
		bne		1$
		move.b		#'Q',EndFlag
1$:
		tst		CheatFlag
		beq		2$
		btst		#10,$dff016
		bne		2$
		move.b		#'N',EndFlag
2$:		bra		WaitMouse

Ende:		move.b		#2,MenuInt

		lea		PanelCols+2,a3
		lea		colors+2,a4
		bsr		FadeOut

		bsr		ClearHiPage

;		cmp.b		#'O',EndFlag
;		beq		EndGame

		cmp.b		#'C',EndFlag
		beq		Completed
		cmp.b		#'P',EndFlag
		beq		Perfect
		cmp.b		#'B',EndFlag
		beq		BonusLevel
		cmp.b		#'T',EndFlag
		beq		TimeOut
		cmp.b		#'Q',EndFlag
		beq		GameOver
		cmp.b		#'N',EndFlag
		beq		NextLevel

SubLives:	tst.b		Bonus
		bne		NextLevel

		tst		CheatFlag
		bne		NoLivesSub
		sub.b		#1,Lives
		beq		GameOver
NoLivesSub:
		bsr		ShowLivesLeft
		bra		Begin2

TimeOut:	bsr		ShowTimeOut
		bra		SubLives

BonusLevel:	bsr		ShowBonus
		bra		Begin2
		
GameOver:	bra		ShowGameOver

NextLevel:	moveq		#2,d0
		bsr		SetSound

		add.l		#2500,Score
		add		#1,ActLevel
		add.l		#126,LevelPtr
		cmp.l		#LevelEnd,LevelPtr
		beq		EndGame

		bsr		ShowNextLevel
		bra		Begin2


Completed:	lea		First,a0
		moveq		#0,d0
		moveq		#0,d1

2$:		cmp.b		#2,(A0)+
		beq		1$

		addq		#1,d0
		cmp		#15,d0
		bne		2$

		moveq		#0,d0
		addq		#1,d1
		bra		2$

1$:		mulu		#15,d0
		mulu		#15,d1

		bsr		ClearSpr

		clr		FlipFlag
		bsr		SetPlane
		move.l		#copperl,cop1lc(A5)

		lea		colors+2,a0
		lea		back+10000+28400,a2
		lea		PanelCols+2,a1
		lea		panel+6400,a3
		bsr		FadeIn

		bsr		WaitButton

		lea		colors+2,a3
		lea		PanelCols+2,a4
		bsr		FadeOut

		bra		NextLevel


Perfect:	bsr		ShowPerfect
		bsr		ClearHiPage
		bra		NextLevel
		

EndGame:	moveq		#3,d0
		bsr		SetSound
		bsr		ShowEndGame
		rts

SetSprites:	lea		SprList,a1
		lea		CGSpr+2,a2
		moveq		#7,d7
1$:
		move.l		(A1)+,d0			; Zeiger auf Sprite
		move		d0,4(A2)
		swap		d0
		move		d0,(A2)
		addq.l		#8,A2
		dbf		d7,1$
		rts

SprList:	dc.l		MSpr1,MSpr2,MSpr3,MSpr4,0,0,0,0

SetColors:	lea		back+38400,a1
		lea		colors+2,a2
		lea		colors2+2,a3

		moveq		#31,d7
1$:		clr		(A2)
		move		(A1)+,(A3)
		addq.l		#4,a2
		addq.l		#4,a3
		dbf		d7,1$

		lea		panel+6400,a1
		lea		PanelCols+2,a2
		lea		PanelCols2+2,a3
	
		moveq		#31,d7
2$:		clr		(A2)
		move		(A1)+,(A3)
		addq.l		#4,a2
		addq.l		#4,a3
		dbf		d7,2$
		rts

MyInt:		movem.l		d0-d7/a0-a6,-(sp)
		lea		$dff000,a5
		btst		#5,$1f(A5)
		beq		EndInt
		btst		#4,$1f(A5)
		bne		EndInt
CopperInt:
		move		#$000,$dff180
		tst		SoundFlag
		beq		708$
		move		#$F,dmacon(A5)
		bra		707$
708$:
		bsr		MusicVBL
707$:
		cmp.b		#3,MenuInt
		beq		703$

		bsr		GetKey
		move.b		d0,Key
		bsr		CheckSound
703$:
		st.b		Button
		btst		#7,$bfe001
		bne		701$			; nein
		clr.b		Button			; Gedrueckt
701$:
		cmp.b		#' ',Key
		bne		702$
		move		#$ff0,$dff180
		clr.b		Button
702$:
		btst		#6,$bfe001
		beq		EndInt2

		cmp.b		#3,MenuInt
		beq		EndInt2
		cmp.b		#2,MenuInt
		beq		EndInt2
		cmp.b		#1,MenuInt
		bne		NoMenuInt

		bsr		Scroll
		bra		EndInt2
NoMenuInt:
		tst		EndFlag
		bne		EndInt2

		not		FlipFlag
		tst		PauseFlag
		bne		1$

		move.l		Bob1,a0
		move		8(A0),d0
		sub		#160,d0
		move		10(A0),d1
		sub		#100,d1
		bsr		SetPlane
1$:
		bsr		CheckPause

		tst		PauseFlag
		bne		EndInt4

		bsr		DrawSaveBuffer
;		move		#$00f,$dff180
		bsr		CheckBobs
;		move		#$0f0,$dff180
		bsr		MoveBobs
;		move		#$0ff,$dff180
		bsr		MoveMyBob
;		move		#$f00,$dff180

		bsr		MoveEnemy
;		move		#$f0f,$dff180
		bsr		CheckDiamond
;		move		#$00f,$dff180
		bsr		CheckColl
;		move		#$0f0,$dff180

		bsr		CheckBonus
		bsr		CheckTime
;		move		#$f00,$dff180
		bsr		CheckDelBlock
;		move		#$f0f,$dff180
		bsr		CheckDrawBlock
;		move		#$ff0,$dff180

		bsr		DrawBobs
;		move		#$fff,$dff180

;		move		#$0ff,$dff180
		bsr		CheckESC

		move.l		Score,d0
		cmp.l		HiPoints,d0
		blo		2$
		move.l		Score,HiPoints
2$:
EndInt4:	;move		#$f00,$dff180
EndInt2:
		move		#$20,intreq(a5)
EndInt:
		movem.l		(sp)+,d0-d7/a0-a6
		rte

		dc.w		$4ef9
OldInt:
		dc.l		0


SetFlag:	;move		#$0cd,$dff180
		move.b		#'E',EndFlag			; EndeFeuer
		rts


EndBob3:	move.l		Bob3,a4
		lea		FirstDefs,a1
		move		(A1),8(A4)
		move		2(A1),10(A4)
		move		4(A1),UnMove1

		move.l		#LeerMove,76(A4)
		clr		80(A4)
		add.l		#1000,Score
		rts



EndBob4:	move.l		Bob4,a4
		lea		FirstDefs,a1
		move		(A1),8(A4)
		move		2(A1),10(A4)
		move		6(A1),UnMove2

		move.l		#LeerMove,76(a4)
		clr		80(A4)
		add.l		#1000,Score
		rts

EndBob5:	move.l		Bob2,a4
		clr.l		8(A4)
		rts

MoveEnemy:	move.l		Bob3,a0
		lea		Move3,a4
		moveq		#0,d7
		bsr		MoveEnemySub

		move.l		Bob4,a0
		lea		Move4,a4
		moveq		#1,d7
		bsr		MoveEnemySub

		tst		UnMove1
		beq		3$
		subq		#1,UnMove1
3$:
		tst		UnMove2
		beq		4$
		subq		#1,UnMove2
4$:
		rts

MoveEnemySub:	cmp		#128,80(a0)
		beq		1$

		btst		#7,80(A0)
		beq		2$
1$:
		move.l		Bob1,a1
		move		8(A1),d2		; BobX
		move		10(A1),d3		; BobY
		move		8(A0),d4		; GegX
		move		10(A0),d5		; GegY

		moveq		#0,d0
		moveq		#0,d1

		cmp.l		Bob3,a0
		bne		15$

		tst		UnMove1
		bne		9$
		bra		16$
15$:
		tst		UnMove2
		bne		9$
16$:
		cmp		d2,d4
		ble		3$
		moveq		#-1,d0
		bra		4$
3$:		cmp		d4,d2
		ble		4$
		moveq		#1,d0

4$:		cmp		d3,d5
		ble		5$
		moveq		#-1,d1
		bra		6$
5$:		cmp		d5,d3
		ble		6$
		moveq		#1,d1
6$:		
		ext.l		d4
		ext.l		d5
		lea		First,a2
		add		#16,d4
		add		#16,d5
		lsr.l		#5,d4
		lsr.l		#5,d5
		mulu		#15,d5
		add.l		d5,d4
		add.l		d4,a2			; Aktuelle Position

		move.l		d1,d3
		muls		#15,d3

		btst		#1,$dff007
		bne		11$

		tst		d0
		beq		8$
		tst.b		Bonus
		beq		800$
;		cmp.b		#54,(A2,d0.w)
;		beq		10$
800$:		tst.b		(A2,d0.w)
		beq		10$

		moveq		#0,d0
8$:
		tst.b		Bonus
		beq		801$
;		cmp.b		#54,(A2,d3.w)
;		beq		9$
801$:		tst.b		(A2,d3.w)
		beq		9$
10$:		moveq		#0,d1
		bra		9$

11$:
		tst		d1
		beq		18$
		tst.b		Bonus
		beq		802$
;		cmp.b		#54,(A2,d3.w)
;		beq		20$
802$:		tst.b		(A2,d3.w)
		beq		20$
		moveq		#0,d1
18$:
		tst.b		Bonus
		beq		803$
;		cmp.b		#54,(A2,d0.w)
;		beq		9$
803$:		tst.b		(A2,d0.w)
		beq		9$
20$:		moveq		#0,d0

9$:		move.l		a4,a3
		moveq		#31,d7

7$:		move		d0,(A4)+
		move		d1,(A4)+

		dbf		d7,7$
		move.l		a3,76(A0)
		clr		80(A0)

		cmp.l		Bob4,a0
		bne		2$

		bsr		SetBobbyAnim

2$:		rts


MoveMyBob:	move.l		Bob1,a0
		cmp		#64,80(A0)
		beq		22$

		btst		#7,80(A0)
		beq		NoMove

22$:		GetJoy		()
		move		d0,x
		move		d1,y

		move.l		Bob1,a0
		lea		Anim1,a1
		clr		52(A0)
		move		#PrgEnde,(A1)

		lea		Second,a3
		move		8(A0),d2
		move		10(A0),d3
		ext.l		d2
		ext.l		d3
		lsr.l		#5,d2
		lsr.l		#5,d3
		mulu		#15,d3
		add		d2,d3
		move.b		(A3,d3.w),d7

		cmp.b		#21,d7
		bne		500$

		lea		Second,a3
		moveq.l		#0,d0
		moveq.l		#0,d1
501$:
		cmp.b		#22,(A3)+
		beq		511$

		addq.l		#1,d0
		cmp.l		#15,d0
		bne		512$

		moveq.l		#0,d0
		addq.l		#1,d1
512$:
		bra		501$

511$:		move.l		Bob1,a0
		lsl.l		#5,d0
		lsl.l		#5,d1
		move		d0,8(A0)
		move		d1,10(A0)
		bra		NoMove2

500$:		cmp.b		#23,d7
		bne		502$
		move.b		#'E',EndFlag
		bra		510$
502$:
		cmp.b		#20,d7
		bne		503$
		move.b		#'B',EndFlag
		bra		NoSpezMove
503$:
		cmp.b		#17,d7
		bne		504$

		move.l		Bob3,a4
		lea		FirstDefs,a1
		move		(A1),8(A4)
		move		2(A1),10(A4)
		move		4(A1),UnMove1
		move.l		#LeerMove,76(A4)
		clr		80(A4)

		move.l		Bob4,a4
		lea		FirstDefs,a1
		move		(A1),8(A4)
		move		2(A1),10(A4)
		move		6(A1),UnMove2
		move.l		#LeerMove,76(A4)
		clr		80(A4)
		add.l		#2500,Score

		lea		Second,a3
		moveq.l		#0,d0
		moveq.l		#0,d1
601$:
		cmp.b		#17,(A3)+
		beq		611$

		addq.l		#1,d0
		cmp.l		#15,d0
		bne		612$

		moveq.l		#0,d0
		addq.l		#1,d1
612$:
		bra		601$

611$:		move		FirstDefs+12,d2
		move.b		d2,-(A3)
		move.l		d0,XBlock2
		move.l		d1,YBlock2
		bra		NoMove2

504$:
		cmp.b		#57,d7
		bne		505$

		add.l		#1000,Score

		lea		Second,a3
		moveq.l		#0,d0
		moveq.l		#0,d1
701$:
		cmp.b		(A3)+,d7
		beq		711$

		addq.l		#1,d0
		cmp.l		#15,d0
		bne		712$

		moveq.l		#0,d0
		addq.l		#1,d1
712$:
		bra		701$

711$:		move		FirstDefs+12,d2
		move.b		d2,-(A3)
		move.l		d0,XBlock2
		move.l		d1,YBlock2
		bra		NoMove2

505$:
510$:		lea		First,a3
		move		8(A0),d2
		move		10(A0),d3
		ext.l		d2
		ext.l		d3
		lsr.l		#5,d2
		lsr.l		#5,d3

		add.l		d0,d2
		add.l		d1,d3
		move.l		d2,d4
		move.l		d3,d5
		muls		#15,d3
		add.l		d3,a3
		add.l		d2,a3

		tst.b		Bonus
		beq		532$

		cmp.b		#54,(A3)
		bne		532$
		clr.b		(A3)
		move.l		d4,XBlock2
		move.l		d5,YBlock2
		add.l		#250,Score
		bra		NoSpezMove
532$:
		cmp.b		#-2,(A3)
		beq		NoSpezMove
		cmp.b		#3,(A3)			; Rand -> Ende
		beq		NoMove
		cmp.b		#5,(A3)			; GeisterHaus -> Ende
		beq		NoMove
		tst.b		(a3)
		beq		NoSpezMove		; Nichts im Weg

		tst.b		Button
		bne		NoMove2			; Kein Fire gedrueckt

		move.l		Bob2,a2
		cmp.b		#4,(A3)			; Freezer
		bne		11$		
		cmp.b		#-1,(A3)
		beq		NoMove2

		move.l		Bob2,a2
		tst.l		8(A2)
		bne		11$
		tst.b		ActBlock
		bne		11$

		move.l		a1,-(sp)
		lea		FirstDefs,a1
		move		4(A1),UnMove1
		move		6(A1),UnMove2
		move.l		(sp)+,a1
		clr.b		(A3)
		move.l		d4,XBlock2
		move.l		d5,YBlock2

		lsl		#5,d4
		lsl		#5,d5
		move		d4,8(A2)
		move		d5,10(A2)
		move.l		#Anim6,54(A2)		; AnimPrg
		move.l		#Move5,76(A2)		; MovePrg
		move.l		ImageList,72(A2)	; neue Images
		clr		80(A2)
		clr		52(A2)			; Offsets auf NULL
		add.l		#250,Score
		bra		NoMove

11$:		move.l		a3,a4
		add		d0,a4
		muls		#15,d1
		add.l		d1,a4

;		cmp.b		#32,(A4)
;		beq		NoSpezMove

		cmp.b		#-1,(A4)
		beq		12$
		tst.b		(A4)
		beq		12$
102$:
		cmp.b		#-1,(A3)
		beq		NoMove2
		cmp.b		#2,(A3)
		beq		NoMove2			; Diamant

		tst.l		8(A2)
		bne		NoMove2
		tst.b		ActBlock
		bne		NoMove2

		clr.b		(A3)
		move.l		d4,XBlock2
		move.l		d5,YBlock2

		lsl		#5,d4
		lsl		#5,d5
		move		d4,8(A2)
		move		d5,10(A2)
		move.l		#Anim5,54(A2)		; AnimPrg
		move.l		#Move5,76(A2)		; MovePrg
		move.l		ImageList,72(A2)	; neue Images
		clr		80(A2)
		clr		52(A2)			; Offsets auf NULL
		add.l		#100,Score
		bra		NoMove

12$:
		tst.l		8(A2)
		bne		NoMove2			; Schon ein Block da
		tst.b		ActBlock
		bne		NoMove2

		cmp.b		#-1,(A3)
		beq		NoMove2
		move.b		(A3),ActBlock
		clr.b		(A3)
	
		move.l		Bob2,a2
		move.l		Bob1,a1
		move		8(A1),d0
		move		10(A1),d1
		move		x,d2
		move		y,d3
		lsl		#5,d2
		lsl		#5,d3
		add		d2,d0
		add		d3,d1
		move		d0,8(A2)
		move		d1,10(A2)

		lea		Move2,a1
		move		x,d0
		move		y,d1
		muls		#15,d1
		ext.l		d0
		ext.l		d1
		add.l		d0,d1
		move		x,d6
		move		y,d7
		lsl		#2,d6
		lsl		#2,d7

		move.l		d4,XBlock2
		move.l		d5,YBlock2

Find:		add.l		d1,a3
		cmp.b		#-1,(A3)
		beq		109$

		tst.b		(A3)
		bne		EndFind
109$:
		moveq		#7,d0
9$:		move		d6,(A1)+
		move		d7,(A1)+
		dbf		d0,9$
		bra		Find
EndFind:
		move		#PrgRelCom,(A1)+
		move		#PrgJump,(A1)+
		move.l		#EndMoveBob,(A1)+
		move		#PrgRelCom,(A1)+
		move		#PrgEnde,(A1)

		moveq		#0,d0
		move.b		ActBlock,d0
		bsr		CopyToBob

		clr		20(A2)
		clr.l		54(A2)
		move.l		#BobPointer,72(A2)
		move.l		#Move2,76(A2)
		clr		80(A2)
		move.l		#-1,12(A2)
		move.l		#-1,16(A2)
		bra		NoMove

NoSpezMove:	move		d0,d5
		move		d1,d6
		lsl		#1,d5
		lsl		#1,d6
NoSpezMove2:
		lea		Move1,a1
		moveq		#15,d7
CreateLoop:	move		d5,(A1)+
		move		d6,(A1)+
		dbf		d7,CreateLoop

		bsr		SetWalkAnim
		move.l		Bob1,a0
		move.l		#Move1,76(A0)
		clr		80(A0)
NoMove:
		rts


NoMove2:	moveq		#0,d5
		moveq		#0,d6
		bra		NoSpezMove2


EndMoveBob:	move.l		Bob2,a0
		move		8(A0),d0
		move		10(A0),d1
		ext.l		d0
		ext.l		d1
		lsr		#5,d0
		lsr		#5,d1
		move.l		d0,d5
		move.l		d1,d6

		move.l		d1,d2
		lea		First,a2
		ext.l		d0
		add.l		d0,a2
		mulu		#15,d2
		add.l		d2,a2
		move.b		ActBlock,(A2)

		move.l		d5,XBlock
		move.l		d6,YBlock

		move.l		Bob2,a0
		clr.l		8(A0)
		move		#Invisible,20(A0)
		rts

		DSEG

FadeOutCopper:	cmove	$2c81,diwstrt
		cmove	$2dc1,diwstop
		cmove	$30,ddfstrt
		cmove	$d0,ddfstop
		cmove	$5200,bplcon0
scrollx2:	cmove	0,bplcon1
		cmove	0,bplcon2
		cmove	18,bpl1mod
		cmove	18,bpl2mod

		cmovel	0,sprpt
		cmovel	0,sprpt+4
		cmovel	0,sprpt+8
		cmovel	0,sprpt+12
		cmovel	0,sprpt+16
		cmovel	0,sprpt+20
		cmovel	0,sprpt+24
		cmovel	0,sprpt+28
colors2:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62
		cmove	$000,color+00

		cwait	$0c00,$fffe
		cmove	$0100,dmacon
PanelCols2:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62

		cmove	$0000,bpl1mod
		cmove	$0000,bpl2mod
		cmovel	panel,bpl1pt
		cmovel	panel+1280,bpl2pt
		cmovel	panel+2560,bpl3pt
		cmovel	panel+3840,bpl4pt
		cmove	$5200,bplcon0
		cmove	$0000,bplcon1
		cmove	$0038,ddfstrt
		cmove	$00d0,ddfstop

		cwait	$0d00,$fffe
		cmove	$8100,dmacon
		cend

HiScoreCopper:	cmove	$2c81,diwstrt
		cmove	$f4c1,diwstop
		cmove	$38,ddfstrt
		cmove	$d0,ddfstop
		cmove	$5200,bplcon0
		cmove	0,bplcon1
		cmove	%100100,bplcon2
		cmove	0,bpl1mod
		cmove	0,bpl2mod
		cmovel	page2,bpl1pt
		cmovel	page2+(1*8000),bpl2pt
		cmovel	page2+(2*8000),bpl3pt
		cmovel	page2+(3*8000),bpl4pt
		cmovel	page2+(4*8000),bpl5pt
HiColors:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62

HiSprites:	cmovel	HiSprite1,sprpt
		cmovel	HiSprite2,sprpt+4
		cmovel	0,sprpt+8
		cmovel	0,sprpt+12
		cmovel	0,sprpt+16
		cmovel	0,sprpt+20
		cmovel	0,sprpt+24	
		cmovel	0,sprpt+28
		cend


HiScoreCopper2:	cmove	$2c81,diwstrt
		cmove	$2cc1,diwstop
		cmove	$38,ddfstrt
		cmove	$d0,ddfstop
		cmove	$5200,bplcon0
		cmove	0,bplcon1
		cmove	0,bplcon2
		cmove	0,bpl1mod
		cmove	0,bpl2mod
		cmovel	page2,bpl1pt
		cmovel	page2+(1*10240),bpl2pt
		cmovel	page2+(2*10240),bpl3pt
		cmovel	page2+(3*10240),bpl4pt
		cmovel	page2+(4*10240),bpl5pt
HiColors2:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62
		cmovel	0,sprpt
		cmovel	0,sprpt+4
		cmovel	0,sprpt+8
		cmovel	0,sprpt+12
		cmovel	0,sprpt+16
		cmovel	0,sprpt+20
		cmovel	0,sprpt+24	
		cmovel	0,sprpt+28
		cend

MenuCopper:	cmove	$2c81,diwstrt
		cmove	$12c1,diwstop
		cmove	$38,ddfstrt
		cmove	$d0,ddfstop
		cmove	$5200,bplcon0
		cmove	0,bplcon1
		cmove	%100100,bplcon2
		cmove	0,bpl1mod
		cmove	0,bpl2mod
		cmovel	page1,bpl1pt
		cmovel	page1+(1*8000),bpl2pt
		cmovel	page1+(2*8000),bpl3pt
		cmovel	page1+(3*8000),bpl4pt
		cmovel	page1+(4*8000),bpl5pt

MenuSprites:	cmovel	MenuSpr1,sprpt
		cmovel	MenuSpr2,sprpt+4
		cmovel	0,sprpt+8
		cmovel	0,sprpt+12
		cmovel	0,sprpt+16
		cmovel	0,sprpt+20
		cmovel	0,sprpt+24
		cmovel	0,sprpt+28

MenuCols:	cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62

		cwait	$f400,$fffe

		cmove	$0002,bpl1mod
		cmove	$0002,bpl2mod

		cmove	$5200,bplcon0
		cmove	$0088,bplcon1
		cmove	$0030,ddfstrt
		cmove	$00d0,ddfstop
		cmove	$2c84,diwstrt
		cmove	$14bc,diwstop

		cmove	$0100,dmacon
		cmovel	page2-1,bpl1pt
		cmovel	page2+1408-1,bpl2pt
		cmovel	page2+2816-1,bpl3pt
		cmovel	page2+4224-1,bpl4pt
		cmovel	page2+5632-1,bpl5pt

		cwait	$ffdf,$fffe
		cwait	$0000,$fffe
		cmove	$8100,dmacon

SchwCopp:	cmove	$0000,bplcon1
		cwait	$0100,$fffe
		cmove	$0000,bplcon1
		cwait	$0200,$fffe
		cmove	$0000,bplcon1
		cwait	$0300,$fffe
		cmove	$0000,bplcon1
		cwait	$0400,$fffe
		cmove	$0000,bplcon1
		cwait	$0500,$fffe
		cmove	$0000,bplcon1
		cwait	$0600,$fffe
		cmove	$0000,bplcon1
		cwait	$0700,$fffe
		cmove	$0000,bplcon1
		cwait	$0800,$fffe
		cmove	$0000,bplcon1
		cwait	$0900,$fffe
		cmove	$0000,bplcon1
		cwait	$0a00,$fffe
		cmove	$0000,bplcon1
		cwait	$0b00,$fffe
		cmove	$0000,bplcon1
		cwait	$0c00,$fffe
		cmove	$0000,bplcon1
		cwait	$0d00,$fffe
		cmove	$0000,bplcon1
		cwait	$0e00,$fffe
		cmove	$0000,bplcon1
		cwait	$0f00,$fffe
		cmove	$0000,bplcon1
		cwait	$1000,$fffe
		cmove	$0000,bplcon1
		cwait	$1100,$fffe
		cmove	$0000,bplcon1
		cwait	$1200,$fffe
		cmove	$0000,bplcon1
		cwait	$1300,$fffe
		cmove	$0000,bplcon1
		cend


BlackCopper:	cmove	$0000,bplcon0
		cmove	$0000,color
		cend

copperl:	cmove	$2c81,diwstrt
		cmove	$2dc1,diwstop
		cmove	$30,ddfstrt
		cmove	$d0,ddfstop
		cmove	$5200,bplcon0
scrollx:	cmove	0,bplcon1
		cmove	%100100,bplcon2
		cmove	18,bpl1mod
		cmove	18,bpl2mod
page:		cmovel	page1,bpl1pt
		cmovel	page1+(1*planel),bpl2pt
		cmovel	page1+(2*planel),bpl3pt
		cmovel	page1+(3*planel),bpl4pt
		cmovel	page1+(4*planel),bpl5pt

CGSpr:		cmovel	0,sprpt
		cmovel	0,sprpt+4
		cmovel	0,sprpt+8
		cmovel	0,sprpt+12
		cmovel	0,sprpt+16
		cmovel	0,sprpt+20
		cmovel	0,sprpt+24
		cmovel	0,sprpt+28
colors:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62

		cwait	$2000,$fffe
		cmove	$8020,dmacon
		cwait	$ffdf,$fffe

		cwait	$0c00,$fffe
		cmove	$0120,dmacon
PanelCols:
		cmove	$000,color
		cmove	$000,color+2
		cmove	$000,color+4
		cmove	$000,color+6
		cmove	$000,color+8
		cmove	$000,color+10
		cmove	$000,color+12
		cmove	$000,color+14
		cmove	$000,color+16
		cmove	$000,color+18
		cmove	$000,color+20
		cmove	$000,color+22
		cmove	$000,color+24
		cmove	$000,color+26
		cmove	$000,color+28
		cmove	$000,color+30
		cmove	$000,color+32
		cmove	$000,color+34
		cmove	$000,color+36
		cmove	$000,color+38
		cmove	$000,color+40
		cmove	$000,color+42
		cmove	$000,color+44
		cmove	$000,color+46
		cmove	$000,color+48
		cmove	$000,color+50
		cmove	$000,color+52
		cmove	$000,color+54
		cmove	$000,color+56
		cmove	$000,color+58
		cmove	$000,color+60
		cmove	$000,color+62

		cmove	$0000,bpl1mod
		cmove	$0000,bpl2mod
		cmovel	panel,bpl1pt
		cmovel	panel+1280,bpl2pt
		cmovel	panel+2560,bpl3pt
		cmovel	panel+3840,bpl4pt
		cmovel	panel+5120,bpl5pt

		cmove	$2c81,diwstrt
		cmove	$2dc1,diwstop
		cmove	$0000,bplcon1
		cmove	$0000,bplcon2
		cmove	$0038,ddfstrt
		cmove	$00d0,ddfstop
		cmove	$5200,bplcon0

		cmove	$0000,$0144
		cmove	$0000,$0146
		cmove	$0000,$014c
		cmove	$0000,$014e
		cmove	$0000,$0154
		cmove	$0000,$0156
		cmove	$0000,$015c
		cmove	$0000,$015e

		cwait	$0d00,$fffe
		cmove	$8100,dmacon

		cwait	$2c00,$fffe
		cmove	$8020,dmacon
		cend

GfxText:	dc.b	'graphics.library',0
DosText:	dc.b	'dos.library',0
IntText:	dc.b	'intuition.library',0
Con:		dc.b	'CON:0/0/640/100/-C5- StartUp Window',0
Picture:	dc.b	'pic.c',0
Bob:		dc.b	'gfx/WalkAnim3.c',0
Pan:		dc.b	'panel.c',0
Font:		dc.b	'font2.c',0
Menu:		dc.b	'menu',0
HiFile:		dc.b	'HiScores',0
Music:		dc.b	'Music.c',0
Caught:		dc.b	'caught.c',0
BigFile:	dc.b	'bigfile.c',0

		even

Key:		dc.b	0,0
StopCnt:	dc.b	0,0
Lives:		dc.b	0
MenuInt:	dc.b	0
Button:		dc.b	0

		even
PauseFlag:	dc.w	1

		BSS	Window,4
		BSS	StdOut,4
		BSS	ConWindow,4

		BSS	XPos,2
		BSS	YPos,2
		BSS	XBlock,4
		BSS	YBlock,4
		BSS	XBlock2,4
		BSS	YBlock2,4
		BSS	ActBlock,2
		BSS	x,2
		BSS	y,2
		BSS	GfxBase,4
		BSS	DosBase,4
		BSS	IntBase,4

		BSS	Shift,2
		BSS	EndFlag,2
		BSS	Bonus,2

		BSS	DelMem,4
		BSS	PosX,2
		BSS	PosY,2
		BSS	FlipFlag,2

		BSS	SoundFlag,2
		BSS	SpeedFlag,2
		BSS	DelCnt,2
		BSS	DrawCnt,2	
		BSS	Bob1,4		
		BSS	Bob2,4		
		BSS	Bob3,4		
		BSS	Bob4,4		
		BSS	Bob5,4		
		BSS	Score,4		
		BSS	HiPoints,4	
		BSS	Time,4		
		BSS	ImageList,4	
		BSS	UnMove1,2	
		BSS	UnMove2,2	
		BSS	PauseBob,2

BitmStr1:	dc.w	60,320
		dc.b	0,5
		dc.w	0
		dc.l	page1
		dc.l	page1+(1*planel)
		dc.l	page1+(2*planel)
		dc.l	page1+(3*planel)
		dc.l	page1+(4*planel)

BitmStr2:	dc.w	60,320
		dc.b	0,5
		dc.w	0
		dc.l	page2
		dc.l	page2+(1*planel)
		dc.l	page2+(2*planel)
		dc.l	page2+(3*planel)
		dc.l	page2+(4*planel)

CollList:	dc.l	Bob1,Bob3,SetFlag
		dc.l	Bob1,Bob4,SetFlag

		dc.l	Bob2,Bob3,EndBob3
		dc.l	Bob2,Bob4,EndBob4
		dc.l	0,0,0

Move1:		dcb.b	64,0
		dc.w	PrgRelCom,PrgEnde
Move3:		dcb.b	256,0
		dc.w	PrgRelCom,PrgEnde
Move4:		dcb.b	256,0
		dc.w	PrgRelCom,PrgEnde
LeerMove:	dcb.b	256,0
		dc.w	PrgRelCom,PrgEnde

Anim1:		dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,PrgEnde

BobDef1:
		dc.w	32,32			;Breite,Hoehe 	0
		dc.w	32,32			;x,y Pos	4
		dc.l	Anim1			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	50			;Priority	28
		dc.b	2			;AnimSpeed	29
		dc.w	82			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

		even

BobDef2:
		dc.w	32,32			;Breite,Hoehe 	0
		dc.w	0,0			;x,y Pos	4
		dc.l	0			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	BobImage		;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	40			;Priority	28
		dc.b	3			;AnimSpeed	29
		dc.w	100			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

		even

Anim2:		dc.w	0,PrgEnde

BobDef3:
		dc.w	32,32			;Breite,Hoehe 	0
		dc.w	224,160			;x,y Pos	4
		dc.l	Anim3			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	19			;Priority	28
		dc.b	3			;AnimSpeed	29
		dc.w	16			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	SprList			;user data	56
		dc.b	1			;SpriteFlag	60

		even

Anim3:		dc.w	0,1,2,3,4,5,6,7
		dc.w	6,5,4,3,2,1,PrgLoop

BobDef4:
		dc.w	32,32			;Breite,Hoehe 	0
		dc.w	224,160			;x,y Pos	4
		dc.l	Anim4			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	20			;Priority	28
		dc.b	4			;AnimSpeed	29
		dc.w	68			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SpriteFlag	60

		even

BobDef5:	dc.w	32,32			;Breite,Hoehe 	0
		dc.w	0,0			;x,y Pos	4
		dc.l	0			;AnimPrg	8
		dc.l	0			;MovePrg	12
		dc.l	0			;Adresse im Speicher 16
		dc.l	0			;Adresse auf Disk    20
		dc.l	0			;LaengenListe	24
		dc.b	100			;Priority	28
		dc.b	100			;AnimSpeed	29
		dc.w	1			;Anzahl Animat. 30
		dc.l	0			;Länge		32
		dc.l	0			;ColorMap	36
		dc.l	0			;FlipSource	40
		dc.b	0			;3PlaneFlag	44
		dc.b	1			;Mask		45
		dc.b	0			;AddCounter	46
		dc.b	0			;LoadFlag	47
		dc.l	0			;next def	48
		dc.l	0			;last def	52
		dc.l	0			;user data	56
		dc.b	0			;SriteFlag	60

		even

Anim4:		dc.w	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,PrgEnde
Anim5:		dc.w	0,1,2,3,4,5,Invisible,PrgEnde		; Stein zerbroeseln
Anim6:		dc.w	50,51,52,53,54,Invisible,PrgEnde	; Stein 
Move5:		dcb.l	28,0					; zerbroeckeln
		dc.w	PrgRelCom,PrgJump
		dc.l	EndBob5
		dc.w	PrgRelCom,PrgEnde

		even

	even

BobPointer:	dc.l	BobImage

		BSS	First,150
		BSS	FirstDefs,16
		BSS	Second,150
		BSS	Move2,512
		BSS	Move31,512
		BSS	Move41,512
		BSS	BMask,128
		BSS	BobImage,640
		BSS	AsciiBuffer,40
		BSS	ActLevel,2

		even

		Include	"MenuSpr.s"
		Include	"HiSpr.s"
		Include	"sprite2"

ScrollText:	DC.B	'    LEONARDO    ',-1,200
		DC.B	'          '
		DC.B	'PRODUCED BY THE        '
		DC.B	' GOLDEN     ',-1,80
		DC.B	'          '
		dc.b	'GATE       ',-1,80
		DC.B	'          '
		dc.b	'CREW       ',-1,80
		DC.B	'          '
		DC.B	'SWITZERLAND   ',-1,120
		DC.B	'          '
		DC.B	'COPYRIGHT BY    '
		DC.B	'  ????????    ',-1,120
		DC.B	'          '

		DC.B	'PROGRAMMING :     RENE STRAUB   ',-1,100
		DC.B	'          '
		DC.B	'GRAPHICS :         ORLANDO     ',-1,100
		DC.B	'          '
		DC.B	'SOUND EFFECTS :  ROMAN WERNER   ',-1,100
		DC.B	'    '
		DC.B	'USING SOUND FX          '
		DC.B	'ADDITIONAL PROGRAMMING :   CHRIS HALLER   ',-1,100
		DC.B	'          '
		DC.B	'   CHRISTIAN WEBER  ',-1,100
		DC.B	'          '
		DC.B	'LEVEL DESIGN :    RETO STRAUB   ',-1,100
		DC.B	'          '

		DC.B	0

		even	
LevelPtr:	dc.l	Level
Fin:
