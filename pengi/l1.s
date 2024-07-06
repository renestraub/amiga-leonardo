
	INCLUDE	"filenames.i"

	XDEF	CheatFlag,ActLevel
	XDEF	Delay2000,SetMenuSprite,PrintMenuLetter,Scroll
	XDEF	MenuScroll,FadeOut,AddInt,RemInt,CheckColl
	XDEF	CheckDiamond,CheckDrawBlock,CheckDelBlock
	XDEF	YPos,page2,ScrollX2,BMask
	XDEF	FontBase,SchwCopp,SetPlane,CopyPage,GeneratePage
	XDEF	MenuCols,BlackCopper,OldInt,MyInt,SetUpPage
	XDEF	First,EndFlag,XBlock,YBlock,ActBlock
	XDEF	DrawCnt,XBlock2,YBlock2,DelCnt,MoveBobs,CopyLevel
	XDEF	ClearPages,ClearMenuPage,UpDateRadar,SetWalkAnim,SetBobbyAnim
	XDEF	CopyToBob,copperl,PanelCols,CheckTime,CheckESC
	XDEF	HiScoreCopper3,HiColors3,GSpr1,GSpr2,GSpr3,GSpr4
	XDEF	OutOfMemory,ClearBlock,HiScoreCopper2,HiColors2
	XDEF	Key,Time,Anim1,Anim4,Bob4,back,BobImage,StopCnt,BitmStr1,BitmStr2
	XDEF	Second,top,panel,Bob1,Bob2,Bob3,Score,AsciiBuffer,FontBreite,BobList,RemBob,MoveBob
	XDEF	Level,FlipFlag,page1,pagel,planel,ScrollText
	XDEF	OldScroll,ScrollPointer,ScrollX,colors,UpFlag,DownFlag,WalkLeft
	XDEF	WalkRight,WalkUp,WalkDown,XPos,UnMove1,UnMove2,PauseFlag
	XDEF	AnzBob,x,y,InitVars,MenuSpr1,MenuSpr2,scrollx,page,PrintHiLetter
	XDEF	PrintText2,GameOverText,WaitButton,ClearHiPage,FadeIn,HiScoreText
	XDEF	GetNameText,PrintText3,GetNameText2,HiTab,WidhtTab
	XDEF	GetText,GetText2,GetPointer,EndGetText,DelayBlank
	XDEF	GetPosition,InsertScore,hilist,PrintText4,HiScoreText2,Lives
	XDEF	LivesLeftText,ClearSpr,NextLevelText,HiSprite1,HiSprite2
	XDEF	ShowNextLevel,ShowGameOver,ShowLivesLeft,ShowEndGame
	XDEF	ConvertHiList,HiScoreCopper,HiColors,HiScore,GetName
	XDEF	Level,LevelPtr,LevelEnd,HiPoints,LevelLenght,ShowTimeOut
	XDEF	Decruncher,PosX,PosY,MSpr1,MSpr2,MSpr3,MSpr4
	XDEF	KeyBoard,Button,MenuInt,GetKey,Read,Write
	XDEF	_GetJoy,_SetSprPos,ShowBonus,Bonus,FirstDefs,CheckBonus
	XDEF	BPage,GetName2,StartLevel,ShowPerfect
	XDEF	SoundFlag,CheckPause,CheckSound,CheckBobs,SetSound,LockVoices
	XDEF	FxBase,FxFlag,MasterVol,FadeOutSong
	XDEF	SetFlag,EndBob3,EndBob4

	Include	"h:relcustom.i"
	Include	"h:copper.i"
	Include	"h:bobcoms.i"

	CSEG

LoadCruFile:	MACRO	(Ziel,Offset,Laenge)
		lea	\1,a0
		move.l	#\2,d6
		move.l	#\3,d7
		bsr	Read
		lea	\1,a0
		bsr	Decruncher
		ENDM

SaveFile:	MACRO  	(Ziel,Offset,Laenge)
		lea	\1,a0		
		move.l	#\2,d6
		move.l	#\3,d7
		bsr	Write
		ENDM

ShowPerfect:	lea	PerfectText,a1
		bra	Show

ShowTimeOut:	lea	TimeOutText,a1
		bra	Show

ShowBonus:	lea	BonusText,a1
		bra	Show

ShowEndGame:	bsr	ClearSpr
		move.l	#HiScoreCopper3,cop1lc(A5)
		LoadCruFile	page2,FN_ENDE,93*512

		lea	HiColors3+2,a0
		lea	page2+31200+20000,a2
		sub.l	a1,a1
		bsr	FadeIn

		bsr	WaitButton

		bsr	FadeOutSong
		lea	HiColors3+2,a3
		sub.l	a4,a4
		bsr	FadeOut
		bra	ShowGameOver2


FadeOutSong:	moveq	#31,d4
1$:		bsr	Delay1000
		sub	#2,MasterVol
		dbf	d4,1$
		move	#0,MasterVol
		rts

ShowNextLevel:	cmp	#10,ActLevel
		bne	1$
		lea	Level10Text,a1
		bra	Show
1$:
		cmp	#20,ActLevel
		bne	2$
		lea	Level20Text,a1
		bra	Show
2$:
		cmp	#30,ActLevel
		bne	3$
		lea	Level30Text,a1
		bra	Show
3$:
		lea	NextLevelText,a1
		bra	Show


ShowGameOver:	moveq	#4,d0
		bsr	SetSound

		bsr	ClearSpr
		LoadCruFile	page2,FN_GAMEOVER,17*512

		bsr	CopyToPage

		clr	FlipFlag
		move.l	Bob1,a0
		move	8(A0),d0
		sub	#160,d0
		
		move	10(A0),d1
		sub	#100,d1
		bsr	SetPlane
		move.l	#copperl,cop1lc(A5)

		lea	colors+2,a0
		lea	back+10000+28400,a2
		lea	PanelCols+2,a1
		lea	panel+6400,a3
		bsr	FadeIn

		bsr	WaitButton

		bsr	FadeOutSong
		lea	colors+2,a3
		lea	PanelCols+2,a4
		bsr	FadeOut


ShowGameOver2:	move.l	Score,d0
		bsr	GetPosition
		tst	d0
		beq	100$

		move.l	d0,YBlock2
		moveq	#5,d0
		bsr	SetSound
		move	#64,MasterVol
		bsr	GetName

		lea	GetText2,a1		; Name
		move.l	YBlock2,d0		; Place
		move.l	Score,d1		; Score
		bsr	InsertScore
		bsr	ConvertHiList
		SaveFile	hilist,FN_HISCORES,512		
		bsr	HiScore
100$:		rts

Show:		bsr	PrintText2		
		bsr	ClearSpr
		move	#$8100,dmacon(A5)
		move.l	#HiScoreCopper,cop1lc(A5)
		move.l	#HiScoreCopper,$160000
		lea	HiColors+2,a0
		lea	FontBase+19000,a2
		sub.l	a1,a1
		bsr	FadeIn

		bsr	WaitButton

		bsr	FadeOutSong
		lea	HiColors+2,a3
		sub.l	a4,a4
		bsr	FadeOut
		rts


ShowLivesLeft:	bsr	ClearSpr
		LoadCruFile	page2,FN_CAUGHT,34*512
c34:
		lea	page2+10,a3
		lea	page2+5064,a4

		moveq	#6,d6
		sub.b	Lives,d6
		tst.b	d6
		bhi.s	444$
		moveq	#0,d0
444$:
98$:
		move.l	a3,a1
		move.l	a4,a2
		moveq	#40,d0
		moveq	#15,d7

99$:		move.b	(A1),(A2)
		move.b	1(A1),1(A2)
		move.b	8000(A1),8000(A2)
		move.b	8001(A1),8001(A2)
		move.b	16000(A1),16000(A2)
		move.b	16001(A1),16001(A2)
		move.b	24000(A1),24000(A2)
		move.b	24001(A1),24001(A2)
		move.b	32000(A1),32000(A2)
		move.b	32001(A1),32001(A2)
		add.l	d0,a1
		add.l	d0,a2
		dbf	d7,99$

		subq.l	#2,a3
		subq.l	#2,a4
		dbf	d6,98$

		lea	page2,a1
		moveq	#15,d7
97$:
		clr.l	(A1)
		clr.l	8000(A1)
		clr.l	16000(A1)
		clr.l	24000(A1)
		clr.l	32000(A1)
		clr.l	4(A1)
		clr.l	8004(A1)
		clr.l	16004(A1)
		clr.l	24004(A1)
		clr.l	32004(A1)
		clr.l	8(A1)
		clr.l	8008(A1)
		clr.l	16008(A1)
		clr.l	24008(A1)
		clr.l	32008(A1)
		add.l	d0,a1
		add.l	d0,a2
		dbf	d7,97$

		bsr	CopyToPage

		clr	FlipFlag
		move.l	Bob1,a0
		move	8(A0),d0
		sub	#160,d0
		move	10(A0),d1
		sub	#100,d1
		bsr	SetPlane
		move.l	#copperl,cop1lc(A5)

		lea	colors+2,a0
		lea	back+10000+28400,a2
		lea	PanelCols+2,a1
		lea	panel+6400,a3
		bsr	FadeIn

		bsr	WaitButton

		moveq	#4,d0
		bsr	SetSound

		lea	colors+2,a3
		lea	PanelCols+2,a4
		bsr	FadeOut

		moveq	#20,d5
678$:		bsr	Delay2000
		dbf	d5,678$
		rts


CheckBobs:	lea	First,a0
		move.l	a0,a1
		move	#149,d0

2$:		cmp.b	#-1,(A1)
		bne	1$
		clr.b	(A1)
1$:
		cmp.b	#-2,(A1)
		bne	3$
		clr.b	(A1)
3$:
		addq.l	#1,a1
		dbf	d0,2$
	
		moveq	#-2,d7
		move.l	Bob2,a1
		bsr	_CheckBobs
		moveq	#-1,d7
		move.l	Bob3,a1
		bsr	_CheckBobs
		moveq	#-1,d7
		move.l	Bob4,a1
		bsr	_CheckBobs
		rts

_CheckBobs:	move	8(A1),d0
		move	10(A1),d1
		add	#16,d0
		add	#16,d1
		ext.l	d0
		ext.l	d1
		lsr.l	#5,d0
		lsr.l	#5,d1
		mulu	#15,d1
		add.l	d0,d1
		cmp.b	#5,(A0,d1.w)
		beq	1$
		tst.b	(A0,d1.w)
		bne	1$
		move.b	d7,(A0,d1.w)
1$:		rts


CheckPause:	cmp.b	#'P',Key
		bne	1$
		not.b	PauseFlag
		clr.b	Key
1$:		rts


CheckSound:	cmp.b	#'M',Key
		bne	1$
		not.b	SoundFlag
		beq	2$
		move	#$f,$dff000+dmacon
2$:		rts
1$:
		cmp.b	#'S',Key
		bne	3$
		not.b	FxFlag
3$:		rts


CheckBonus:	tst.b	Bonus
		bne	1$
		rts
1$:
		lea	First,a1
		move	#149,d0
2$:		cmp.b	#54,(A1)+
		beq	3$
		dbf	d0,2$
		move.b	#'P',EndFlag
3$:		rts


CopyToPage:	lea	page2,a0		; Source

		move.l	#19200,d0

		lea	page1,a1
		move.l	a1,a2
		add.l	d0,a2
		move.l	a2,a3
		add.l	d0,a3
		move.l	a3,a4
		add.l	d0,a4
		move.l	a4,a6
		add.l	d0,a6

		move	PosX,d0
		lsr	#3,d0
		move	PosY,d1
		add	#10,d1
		mulu	#60,d1
		add	d0,d1
		addq.l	#2,d1
		and	#$FFFC,d1

		add	d1,a1
		add	d1,a2
		add	d1,a3
		add	d1,a4
		add	d1,a6

		move	#199,d6
2$:
		moveq	#9,d7
1$:
		move.l	(A0),d0
		or.l	8000(A0),d0
		or.l	16000(A0),d0
		or.l	24000(A0),d0
		or.l	32000(A0),d0		; Maske

		not.l	d0
		and.l	d0,(A1)
		and.l	d0,(A2)
		and.l	d0,(A3)
		and.l	d0,(A4)
		and.l	d0,(A6)			; Alle Bits loeschen

		move.l	8000(A0),d0
		or.l	d0,(A2)+
		move.l	16000(A0),d0
		or.l	d0,(A3)+
		move.l	24000(A0),d0
		or.l	d0,(A4)+
		move.l	32000(A0),d0
		or.l	d0,(A6)+
		move.l	(A0)+,d0
		or.l	d0,(A1)+		; kopieren
		dbf	d7,1$

		add.l	#20,a1
		add.l	#20,a2
		add.l	#20,a3
		add.l	#20,a4
		add.l	#20,a6
		dbf	d6,2$
		rts

ClearSpr:	clr.l	HiSprite1
		clr.l	HiSprite2
		clr.l	MSpr1
		clr.l	MSpr2
		clr.l	MSpr3
		clr.l	MSpr4
		clr.l	GSpr1
		clr.l	GSpr2
		clr.l	GSpr3
		clr.l	GSpr4
		rts

HiScore:	bsr	ClearSpr
		lea	MenuCols+2,a3
		sub.l	a4,a4
		bsr	FadeOut

		bsr	ClearHiPage
		lea	HiScoreText,a1
		bsr	PrintText2

		lea	HiScoreText2,a1
		bsr	PrintText4

		move.l	#HiScoreCopper,cop1lc(A5)
		lea	HiColors+2,a0
		sub.l	a1,a1
		lea	FontBase+19000,a2
		bsr	FadeIn

		bsr	WaitButton

		lea	HiColors+2,a3
		sub.l	a4,a4
		bsr	FadeOut
		rts

GetName:	lea	MenuCols+2,a3
		sub.l	a4,a4
		bsr	FadeOut

		move.b	#3,MenuInt

		move.l	#GetText2,GetPointer

		lea	HiSprite1,a1
		lea	HiSprite2,a2
		clr.l	(A1)
		clr.l	(A2)

		bsr	ClearHiPage
		lea	GetNameText,a1
		bsr	PrintText2
		lea	GetNameText2,a1
		bsr	PrintText3

		move.l	#HiScoreCopper,cop1lc(A5)
		lea	HiColors+2,a0
		sub.l	a1,a1
		lea	FontBase+19000,a2
		bsr	FadeIn

		clr	XBlock
		clr	YBlock
		move	#20,XBlock2

		bsr	ClearText
		lea	GetText,a1
		bsr	PrintText2

1$:
		move	XBlock,d0
		move	YBlock,d1
		mulu	#29,d0
		mulu	#20,d1
		add	#$93,d0
		add	#$61,d1
		move	d1,d2
		add	#$16,d2
		lea	HiSprite1,a1
		bsr	_SetSprPos
		add	XBlock2,d0
		lea	HiSprite2,a1
		bsr	_SetSprPos

111$:		bsr	GetKey
		tst.b	d0
		beq	998$

		move	d0,d1
		cmp	#$F0,d0
		beq	111$

		and.b	#$F0,d0
		cmp.b	#$E0,d0
		beq	998$

		lea	ScrollX,a2
		move.b	d1,(A2)
		bra	999$

998$:		move	XBlock,d0
		move	YBlock,d1
		mulu	#10,d1
		add	d1,d0

		lea	HiTab,a2
		moveq	#0,d1
		move.b	(A2,d0.w),d1		; AsciiWert		

		lea	WidhtTab,a2
		moveq	#0,d2
		move.b	(A2,d1.w),d2
		sub	#4,d2
		move	d2,XBlock2		; Breite

		tst.b	Button
		bne	7$

		lea	HiTab,a2
		add	d0,a2
999$:
		cmp.b	#1,(A2)
		beq	6$
		cmp.b	#2,(A2)
		bne	8$

		move.l	GetPointer,a1
		cmp.l	#GetText2,a1
		beq	9$

		move.b	#'.',-1(A1)
		subq.l	#1,GetPointer
		bra	9$

8$:
		cmp.b	#3,(A2)
		bne	19$
		move.l	GetPointer,a1
		cmp.l	#EndGetText,a1
		beq	9$
		move.b	#' ',(A1)
		addq.l	#1,GetPointer
		bra	9$
19$:
		move.l	GetPointer,a1
		cmp.l	#EndGetText,a1
		beq	9$
		move.b	(A2),(A1)
		addq.l	#1,GetPointer
9$:
		bsr	ClearText
		lea	GetText,a1
		bsr	PrintText2
10$:
		tst.b	Button
		beq	10$
7$:
		bsr	_GetJoy
		add	d0,XBlock
		add	d1,YBlock
		cmp	#-1,XBlock
		bne	2$
		clr	XBlock
2$:
		cmp	#-1,YBlock
		bne	3$
		clr	YBlock
3$:
		cmp	#10,XBlock
		bne	4$
		move	#9,XBlock
4$:
		cmp	#5,YBlock
		bne	5$
		move	#4,YBlock
5$:
		bsr	DelayBlank
		bsr	DelayBlank

		bra	1$

		bsr	WaitButton
6$:
		lea	HiColors+2,a3
		sub.l	a4,a4
		bsr	FadeOut
		rts

GetName2:	lea	MenuCols+2,a3
		sub.l	a4,a4
		bsr	FadeOut

		move.b	#3,MenuInt

		clr	CheatFlag
		move.l	#CheatText2,CheatPointer
		lea	CheatText2,a1
		moveq	#9,d0
31$:
		move.b	#'.',(A1)+
		dbf	d0,31$
		clr	StartLevel

		lea	HiSprite1,a1
		lea	HiSprite2,a2
		clr.l	(A1)
		clr.l	(A2)

		bsr	ClearHiPage
		lea	GetNameText3,a1
		bsr	PrintText2

		move.l	#HiScoreCopper,cop1lc(A5)
		lea	HiColors+2,a0
		sub.l	a1,a1
		lea	FontBase+19000,a2
		bsr	FadeIn

		bsr	ClearText
		lea	CheatText,a1
		bsr	PrintText2
1$:
		bsr	DelayBlank
		bsr	GetKey
		tst.b	d0
		beq	1$

		cmp.b	#$f0,d0
		beq	1$
		cmp.b	#$d0,d0
		bhi	1$

		cmp.b	#1,d0
		beq	7$

		cmp.b	#2,d0
		bne	8$			; Delete

		move.l	CheatPointer,a1
		cmp.l	#CheatText2,a1
		beq	9$

		move.b	#'.',-1(A1)
		subq.l	#1,CheatPointer
		bra	9$
8$:
		move.l	CheatPointer,a1
		cmp.l	#EndCheatText,a1
		beq	9$
		move.b	d0,(A1)
		addq.l	#1,CheatPointer
9$:
		bsr	ClearText
		lea	CheatText,a1
		bsr	PrintText2
10$:
		bra	1$

7$:		lea	CheatText2,a0
		lea	String1,a1
		moveq	#9,d0
20$:
		cmp.b	(A0)+,(A1)+
		bne	21$
		dbf	d0,20$			 ;Found String 1

		move	#10,StartLevel
		move.b	#'1',Sl2+10
		move.b	#'0',Sl2+11
		bra	26$

21$:		lea	CheatText2,a0
		lea	String2,a1
		moveq	#6,d0
22$:
		cmp.b	(A0)+,(A1)+
		bne	23$
		dbf	d0,22$			; Found String 2

		move	#20,StartLevel
		move.b	#'2',Sl2+10
		move.b	#'0',Sl2+11
		bra	26$

23$:		lea	CheatText2,a0
		lea	String3,a1
		moveq	#9,d0
24$:
		cmp.b	(A0)+,(A1)+
		bne	25$
		dbf	d0,24$			; Found String 3

		move	#30,StartLevel
		move.b	#'3',Sl2+10
		move.b	#'0',Sl2+11
		bra	26$
25$:
		lea	CheatText2,a0
		lea	String4,a1
		moveq	#7,d0
36$:
		cmp.b	(A0)+,(A1)+
		bne	27$
		dbf	d0,36$			; Found String 4

		st	CheatFlag
		bra	28$
27$:
		lea	HiColors+2,a3
		sub.l	a4,a4
		bsr	FadeOut
		rts


28$:		lea	CheatLevelText,a1
		bra	29$

26$:		lea	StartLevelText,a1
29$:		bsr	PrintText2		

		bsr	WaitButton

		lea	HiColors+2,a3
		sub.l	a4,a4
		bsr	FadeOut
		rts


ClearText:	lea	page2+6400,a0
		move	#189,d0
1$:
		clr.l	(A0)
		clr.l	8000(A0)
		clr.l	16000(A0)
		clr.l	24000(A0)
		clr.l	32000(A0)
		addq.l	#4,a0
		dbf	d0,1$
		rts


ConvertHiList:	lea	hilist,a0
		lea	HiScoreText,a1		; Namen
		lea	HiScoreText2,a4		; Scores (ASCII)

		moveq	#9,d7
2$:
		move.l	(A1)+,a2		; Zeiger auf Text
		addq.l	#2,a2	

		move.l	a0,a3
1$:		move.b	(A3)+,(A2)+
		bne	1$			; Namen kopieren

		addq.l	#8,a0
		move.l	(A0)+,d0		; Score

		move.l	(A4)+,a2
		addq.l	#8,a2			; Zeiger auf Namen

		moveq	#5,d6
3$:
		divu	#10,d0
		swap	d0
		add.b	#'0',d0
		move.b	d0,-(A2)
		clr	d0
		swap	d0
		dbf	d6,3$

		dbf	d7,2$

		lea	HiScoreText2,a1
		moveq	#9,d7
6$:		move.l	(A1)+,a0
		addq.l	#2,a0
4$:		cmp.b	#'0',(A0)
		bne	5$
		move.b	#' ',(A0)
		addq.l	#1,A0
		bra	4$
5$:
		dbf	d7,6$
		move.l	hilist+8,HiPoints
		rts


DelayBlank:
1$:		btst	#5,$1f(A5)
		beq	1$
		rts


ClearHiPage:	lea	page2,a1
		move	#9999,d0
1$:		clr.l	(A1)+
		dbf	d0,1$
		rts

WaitButton:	st.b	Button
2$:		bsr	_GetJoy
		tst.b	Button
		bne	2$
3$:
		bsr	Delay2000
		bsr	_GetJoy
		tst.b	Button
		beq	3$
		rts

InitVars:	move.l	#50*150,Time
		cmp.b	#'B',EndFlag
		bne	2$
		move.l	#50*45,Time
2$:
		cmp.b	#'B',EndFlag
		beq	1$
		clr	EndFlag
1$:
		clr.l	XBlock
		clr.l	XBlock2
		clr.l	YBlock2
		clr.l	YBlock
		clr	Bonus
		clr	XPos
		clr	YPos
		clr	ActBlock
		clr	x
		clr	y
		clr	Key
		clr	PauseFlag
		clr	FlipFlag
		clr	DelCnt
		clr	DrawCnt
		
		clr.l	BobList
		clr	AnzBob

		move	#1,UpFlag
		move	#1,DownFlag
		clr	WalkLeft
		move	#11,WalkRight
		move	#22,WalkUp
		move	#30,WalkDown

		move	#1,UpFlag2
		move	#1,DownFlag2
		clr	BobbyLeft
		move	#11,BobbyRight
		move	#29,BobbyUp
		move	#22,BobbyDown
		rts


OutOfMemory:	moveq	#0,d0
4$:		move	d0,$dff180
		addq	#1,d0
		bra	4$


CheckESC:	cmp.b	#$F0,Key
		bne	1$
		move.b	#'E',EndFlag
		clr.b	Key
1$:		rts

CheckTime:	sub.l	#1,Time
		bne	1$

		tst.b	Bonus
		bne	6$

		move.b	#'T',EndFlag
		bra	2$
6$:
		move.b	#'E',EndFlag
		bra	2$

1$:
		cmp.l	#140*50,Time
		bne	2$

		moveq	#0,d0
		moveq	#0,d1
		move	#149,d7

		lea	Second,a1
3$:		cmp.b	#20,(A1)+
		beq	5$

		addq	#1,d0
		cmp	#15,d0
		bne	4$

		moveq	#0,d0
		addq	#1,d1
4$:
		dbf	d7,3$
		bra	2$

5$:		move	FirstDefs+12,d2
		move.b	d2,-(A1)
		move.l	d0,XBlock2
		move.l	d1,YBlock2
2$:		rts


SetWalkAnim:	lea	Anim1,a1
		cmp	#1,d0			(rechts)
		bne	1$

		move	WalkRight,d6
		moveq	#7,d7
100$:		move	d6,(A1)+
		addq	#1,d6
		cmp	#22,d6
		bne	101$
		moveq	#11,d6
101$:
		dbf	d7,100$
		move	d6,WalkRight
		bra	4$

1$:
		cmp	#-1,d0			; links
		bne	2$

		move	WalkLeft,d6
		moveq	#7,d7
200$:		move	d6,(A1)+
		addq	#1,d6
		cmp	#11,d6
		bne	201$
		moveq	#0,d6
201$:
		dbf	d7,200$
		move	d6,WalkLeft
		bra	4$

2$:		cmp	#1,d1			; down
		bne	3$

		move	WalkDown,d6
		moveq	#7,d7
300$:		add	DownFlag,d6
		cmp	#39,d6
		bne	301$
		neg	DownFlag
301$:
		cmp	#30,d6
		bne	302$
		neg	DownFlag
302$:
		move	d6,(A1)+
		dbf	d7,300$
		move	d6,WalkDown
		bra	4$
3$:
		cmp	#-1,d1			; up
		bne	4$

		move	WalkUp,d6
		moveq	#7,d7
400$:		add	UpFlag,d6
		cmp	#29,d6
		bne	401$
		neg	UpFlag
401$:
		cmp	#22,d6
		bne	402$
		neg	UpFlag
402$:
		move	d6,(A1)+
		dbf	d7,400$
		move	d6,WalkUp
4$:
		rts


SetBobbyAnim:	lea	Anim4,a1
		cmp	#1,d0			(rechts)
		bne	1$

		move	BobbyRight,d6
		moveq	#7,d7
100$:		move	d6,(A1)+
		addq	#1,d6
		cmp	#22,d6
		bne	101$
		moveq	#11,d6
101$:
		dbf	d7,100$
		move	d6,BobbyRight
		bra	4$

1$:
		cmp	#-1,d0			; links
		bne	2$

		move	BobbyLeft,d6
		moveq	#7,d7
200$:		move	d6,(A1)+
		addq	#1,d6
		cmp	#11,d6
		bne	201$
		moveq	#0,d6
201$:
		dbf	d7,200$
		move	d6,BobbyLeft
		bra	4$

2$:
		cmp	#1,d1			; down
		bne	3$

		move	BobbyDown,d6
		moveq	#7,d7
300$:		add	DownFlag2,d6
		cmp	#22,d6
		bne	301$
		neg	DownFlag2
301$:
		cmp	#28,d6
		bne	302$
		neg	DownFlag2
302$:
		move	d6,(A1)+
		dbf	d7,300$
		move	d6,BobbyDown
		bra	4$
3$:
		cmp	#-1,d1			; up
		bne	4$

		move	BobbyUp,d6
		moveq	#7,d7
400$:		add	UpFlag2,d6
		cmp	#29,d6
		bne	401$
		neg	UpFlag2
401$:
		cmp	#34,d6
		bne	402$
		neg	UpFlag2
402$:
		move	d6,(A1)+
		dbf	d7,400$
		move	d6,BobbyUp
4$:
		tst	d0
		bne	5$
		tst	d1
		beq	6$
5$:		
		move.l	Bob4,a0
		move.l	#Anim4,54(A0)
		clr	52(A0)
6$:		rts


CopyToBob:	movem.l	d0-d1/a0-a1,-(sp)
		ext.l	d0
		divu	#10,d0
		move	d0,d1
		swap	d0
		lsl	#2,d0
		mulu	#1280,d1
		add	d1,d0
		ext.l	d0			; Source
		lea	back,a0
		add.l	d0,a0
		lea	BobImage,a1

		moveq	#31,d0
1$:		move.l	(A0),(A1)
		move.l	BPage(A0),128(A1)
		move.l	BPage*2(A0),256(A1)
		move.l	BPage*3(A0),384(A1)
		move.l	BPage*4(A0),512(A1)
		addq.l	#4,a1
		add.l	#40,a0
		dbf	d0,1$
		movem.l	(sp)+,d0-d1/a0-a1
		rts


Delay2000:	move	#$4000,d7
1$:		nop
		dbf	d7,1$
		rts

Delay1000:	move	#$2000,d7
1$:		nop
		dbf	d7,1$
		rts

SetMenuSprite:	lea	MenuSpr1,a1
		lea	MenuSpr2,a2
		move	YPos,d0
		lea	YPosList,a3
		lsl	#1,d0
		move	(A3,d0.w),d0
		move.b	d0,(A1)
		move.b	d0,(A2)
		add.b	#8,d0
		move.b	d0,2(A1)
		move.b	d0,2(A2)
		rts

YPosList:	dc.w	115-17,140-16,165-14,190-12

PrintMenuLetter:	; D0=x,D1=y,D2=Letter
		lea	page2+39,a1

		lea	WidhtTab,a2
		move.b	(A2,d2.w),d0
		ext.w	d0
		lsr	#1,d0
		move	d0,ScrollX2

		lea	AsciiTab,a0
		move.b	(A0,d2.w),d0
		ext.w	d0
		ext.l	d0			; Buchstabe
		lea	FontBase,a0

		divu	#10,d0
		move.l	d0,d1
		swap	d1
		mulu	#4,d1
		add.l	d1,a0
		mulu	#40*19,d0
		add.l	d0,a0			; Source

		moveq	#18,d7
1$:
		move.b	(A0),(A1)
		move.b	3800(A0),1408(A1)
		move.b	7600(A0),2816(A1)
		move.b	11400(A0),4224(A1)
		move.b	15200(A0),5632(A1)

		move.b	1(A0),1(A1)
		move.b	3801(A0),1409(A1)
		move.b	7601(A0),2817(A1)
		move.b	11401(A0),4225(A1)
		move.b	15201(A0),5633(A1)

		move.b	2(A0),2(A1)
		move.b	3802(A0),1410(A1)
		move.b	7602(A0),2818(A1)
		move.b	11402(A0),4226(A1)
		move.b	15202(A0),5634(A1)

		add.l	#40,a0
		add.l	#44,a1
		dbf	d7,1$
		rts

PrintText2:
2$:		move.l	(A1)+,a0
		cmp.l	#0,a0
		beq	1$
		bsr	_PrintHiText
		bra	2$
1$:		rts

PrintText3:
2$:		move.l	(A1)+,a0
		cmp.l	#0,a0
		beq	1$
		bsr	_PrintHiText3
		bra	2$
1$:		rts

PrintText4:
2$:		move.l	(A1)+,a0
		cmp.l	#0,a0
		beq	1$
		bsr	_PrintHiText4
		bra	2$
1$:		rts

_PrintHiText:
		moveq	#0,d1
		moveq	#0,d2
		move.b	(A0)+,d1		; X
		move.b	(A0)+,d2		; Y

2$:		moveq	#0,d0
		move.b	(A0)+,d0		; Letter
		beq	1$
		bsr	PrintHiLetter
		add	Widht,d1		; LetterBreite
		bra	2$
1$:
		rts

_PrintHiText3:
		moveq	#0,d1
		moveq	#0,d2
		move.b	(A0)+,d1		; X
		move.b	(A0)+,d2		; Y

2$:		moveq	#0,d0
		move.b	(A0)+,d0		; Letter
		beq	1$
		bsr	PrintHiLetter
		add	#29,d1			; LetterBreite
		bra	2$
1$:
		rts

_PrintHiText4:
		moveq	#0,d1
		moveq	#0,d2
		move.b	(A0)+,d1		; X
		move.b	(A0)+,d2		; Y

		move.l	a0,a2
		moveq	#0,d3			; Breite		

		lea	WidhtTab,a4
2$:		moveq	#0,d0
		move.b	(A2)+,d0		; Letter
		beq	3$
		add.b	(a4,d0.w),d3		; Breite
		bra	2$
3$:
		add	#$100,d1
		sub	d3,d1			; Neues X
4$:
		moveq	#0,d0
		move.b	(A0)+,d0
		beq	1$
		bsr	PrintHiLetter
		add	Widht,d1		; LetterBreite
		bra	4$
1$:
		rts

PrintHiLetter:	; D0=Letter / D1=X / D2=Y
		movem.l	d0-d6/a0-a1,-(sp)
		lea	page2,a1
		mulu	#40,d2
		add.l	d2,a1

		move	d1,d3
		lsr	#3,d3
		add	d3,a1			; Ziel

		moveq	#12,d6
		move	d1,d4
		and	#$F,d4
		lsl	d6,d4
		move	d4,d5
		or	#$FCA,d4

		lea	WidhtTab,a0
		moveq	#0,d7
		move.b	(A0,d0.w),d7
		move	d7,Widht
			
		lea	AsciiTab,a0
		ext.w	d0
		move.b	(A0,d0.w),d0
		ext.w	d0
		ext.l	d0			; Buchstabe
		lea	FontBase,a0
		divu	#10,d0
		move.l	d0,d1
		swap	d1
		mulu	#4,d1
		mulu	#40*19,d0
		add.l	d1,a0
		add.l	d0,a0			; Source

		moveq	#4,d7
1$:
		bsr	Blit3
		add.l	#3800,a0
		add.l	#8000,a1
		dbf	d7,1$
		movem.l	(sp)+,d0-d6/a0-a1
		rts


Blit3:
1$:		btst	#14,dmaconr(A5)
		btst	#14,dmaconr(A5)
		bne	1$

		move.l	a0,bltapt(A5)		; SourceA
		move.l	a0,bltbpt(A5)		; SourceB
		move.l	a1,bltcpt(A5)		; SourceC
		move.l	a1,bltdpt(A5)		; ZielD

		move	#34,bltamod(A5)
		move	#34,bltbmod(A5)
		move	#34,bltcmod(A5)
		move	#34,bltdmod(A5)
		move.l	#$FFFF0000,bltafwm(A5)
		move	d4,bltcon0(A5)		; D=AB+(A)C
		move	d5,bltcon1(A5)
		move	#%10011000011,bltsize(A5)
		rts


Scroll:		bsr	Schwabbel

		tst.b	StopCnt
		beq	5$
		subq.b	#1,StopCnt
		rts

5$:		add	#1,ScrollX
		move	ScrollX2,d1
		cmp	ScrollX,d1
		bhi	1$

		clr	ScrollX
3$:		move.l	ScrollPointer,a1
		addq.l	#1,ScrollPointer
		move.b	(A1),d2
		bne	2$

		move.l	OldScroll,ScrollPointer
		bra	3$
2$:
		cmp.b	#-1,(A1)
		bne	4$
		move.b	1(A1),StopCnt
		addq.l	#1,ScrollPointer
		bra	3$
4$:
		ext.w	d2
		bsr	PrintMenuLetter
1$:
		bsr	MenuScroll
		rts

Schwabbel:
		lea	SchwCopp+2,a1
		lea	SchwabbelPtr,a3
		move.l	(A3),a2

		moveq	#18,d7
1$:		move.b	(A2)+,d0
		ext.w	d0
		mulu	#$11,d0
		move	d0,(A1)
		addq.l	#8,a1
		dbf	d7,1$

		addq.l	#1,(A3)
		cmp.l	#EndSinTab,(A3)
		bne	2$
		move.l	#SinTab,(A3)
2$:
		rts

MenuScroll:	
		moveq	#4,d0
		lea	page2-2,a2
		lea	page2,a3
1$:		bsr	SubScroll
		add.l	#1408,a2
		add.l	#1408,a3
		dbf	d0,1$
		rts

SubScroll:
1$:		btst	#14,dmaconr(A5)
		btst	#14,dmaconr(A5)
		bne	1$

		move.l	a3,bltapt(A5)
		move.l	a2,bltdpt(A5)
		move	#0,bltamod(A5)
		move	#0,bltdmod(A5)
		move.l	#-1,bltafwm
		move	#$E9F0,bltcon0(A5)
		clr	bltcon1(A5)
		move	#%10011010110,bltsize(A5)		
		rts


FadeOut:	moveq	#16,d6
5$:
		move.l	a3,a1
		move.l	a4,a2

		moveq	#31,d7
4$:		cmp.l	#0,a1
		beq	8$
		move	(A1),d1
		bsr	FadeOneColors
		move	d3,(A1)
		addq.l	#4,a1
8$:
		cmp.l	#0,a2
		beq	9$
		move	(A2),d1
		bsr	FadeOneColors
		move	d3,(A2)
		addq.l	#4,a2
9$:
		dbf	d7,4$
		
		bsr	Delay2000
		bsr	Delay2000
		dbf	d6,5$

		move.l	#BlackCopper,cop1lc(A5)
		rts


;		a0=FirstCopper/a1=SecondCopper/a2=Color1/a3=Color2	

FadeIn:		movem.l	a0-a6,-(sp)

		move.l	a0,a4
		move.l	a1,a5
		move.l	a2,d4
		move.l	a3,d5

		moveq	#31,d7
14$:		cmp.l	#0,a0
		beq	12$
		clr	(A0)
		addq.l	#4,a0	
12$:
		cmp.l	#0,a1
		beq	13$
		clr	(A1)
		addq.l	#4,a1
13$:		dbf	d7,14$	

		moveq	#16,d6
5$:
		move.l	a4,a0
		move.l	a5,a1
		move.l	d4,a2
		move.l	d5,a3

		moveq	#31,d7

4$:		cmp.l	#0,a0
		beq	8$

		move	(A0),d1			; Aktuelle Farbe
		move	(A2)+,d2		; Soll-Farbe
		bsr	FadeInOneColor
		move	d0,(A0)
		addq.l	#4,a0
8$:
		cmp.l	#0,a1
		beq	9$
		move	(A1),d1
		move	(A3)+,d2
		bsr	FadeInOneColor
		move	d0,(A1)
		addq.l	#4,a1
9$:
		dbf	d7,4$

;		bsr	Delay2000
		bsr	Delay2000
		dbf	d6,5$

		movem.l	(sp)+,a0-a6
		rts


FadeInOneColor:
		movem.l	d1-d6,-(sp)
		move	d1,d3
		move	d3,d4

		move	d2,d5
		move	d5,d6

		and	#$00F,d1		; Ist
		and	#$00F,d2		; Soll
		cmp	d2,d1
		beq	1$
		addq	#$001,d1
1$:
		and	#$0F0,d3
		and	#$0F0,d5
		cmp	d5,d3
		beq	2$
		add	#$010,d3
2$:
		and	#$F00,d4
		and	#$F00,d6
		cmp	d6,d4
		beq	3$
		add	#$100,d4
3$:
		or	d1,d3
		or	d3,d4
		move	d4,d0
		movem.l	(sp)+,d1-d6
		rts


FadeOneColors:
		move	d1,d2
		move	d2,d3

		and	#$00F,d1
		tst	d1
		beq	1$
		subq	#$001,d1
1$:
		and	#$0F0,d2
		tst	d2
		beq	2$
		sub	#$010,d2
2$:
		and	#$F00,d3
		tst	d3
		beq	3$
		sub	#$100,d3
3$:
		or	d1,d2
		or	d2,d3
		rts

AddInt:		lea	OldInt,a0
		move.l	$6c,(A0)
		move.l	#MyInt,$6c
		move	#$8020,intena(A5)	; interrupt zulassen
		rts

RemInt:		lea	OldInt,a0
		move.l	(A0),$6c
		rts


CheckColl:	lea	CollList,a0
1$:		move.l	(A0)+,a1		; 1.Bob
		move.l	(A0)+,a2		; 2.Bob
		move.l	(A0)+,a3

		move.l	(A1),a1
		move.l	(A2),a2
		cmp.l	#0,a1
		beq	2$
		cmp.l	#0,a2
		beq	2$
	
		move	8(A1),d0
		beq	2$
		move	10(A1),d1
		beq	2$
		move	8(A2),d2
		beq	2$
		move	10(A2),d3
		beq	2$

		moveq	#16,d4
		add	d4,d0
		add	d4,d1
		add	d4,d2
		add	d4,d3

		lsr	#5,d0
		lsr	#5,d1
		lsr	#5,d2
		lsr	#5,d3
		
		cmp	d0,d2
		bne	3$
		cmp	d1,d3
		bne	3$

		movem.l	d0-d7/a0-a6,-(sp)
		jsr	(A3)
		movem.l	(sp)+,d0-d7/a0-a6
3$:

2$:		tst.l	(A0)
		bne	1$

		lea	CollList2,a0
5$:		move.l	(A0)+,a1		; 1.Bob
		move.l	(A0)+,a2		; 2.Bob
		move.l	(A0)+,a3		; CollRoutine

		move.l	(A1),a1
		move.l	(A2),a2
		cmp.l	#0,a1
		beq	4$
		cmp.l	#0,a2
		beq	4$
	
		move	8(A1),d0
		beq	4$
		move	10(A1),d1
		beq	4$
		move	8(A2),d4
		beq	4$
		move	10(A2),d5
		beq	4$

		move	d0,d2			; D2=X UR
		add	#32,d2
		move	d1,d3			; D3=Y UR
		add	#32,d3

		add	#2,d4
		add	#2,d5
		bsr	TestBounds

		move	8(A2),d4
		move	10(A2),d5
		add	#2,d5
		add	#30,d4
		bsr	TestBounds

		move	8(A2),d4
		move	10(A2),d5
		add	#2,d4
		add	#30,d5
		bsr	TestBounds

		move	8(A2),d4
		move	10(A2),d5
		add	#30,d4
		add	#30,d5
		bsr	TestBounds

4$:		tst.l	(A0)
		bne	5$
		rts

TestBounds:	cmp	d4,d0
		bhi	Out
		cmp	d4,d2
		blo	Out
		cmp	d5,d1
		bhi	Out
		cmp	d5,d3
		blo	Out
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	(A3)
		movem.l	(sp)+,d0-d7/a0-a6
Out:
		rts


CheckDiamond:	tst.b	Bonus
		beq	100$
		rts

100$:		lea	First,a1
		lea	First+149,a2

1$:		cmp.b	#2,(A1)+
		bne	1$			; 1. Diamanten suchen

		cmp.b	#2,(A1)
		bne	2$
		cmp.b	#2,1(A1)
		beq	4$			; Found

2$:		cmp.b	#2,14(A1)
		bne	5$
		cmp.b	#2,29(A1)
		bne	5$
4$:		move.b	#'C',EndFlag
		rts

5$:		rts



CheckDrawBlock:	movem.l	d0-d7/a0-a6,-(sp)
		move.l	XBlock,d0
		beq	1$
		move.l	YBlock,d1
		beq	1$
		moveq	#0,d2
		move.b	ActBlock,d2
		bsr	DrawBlock

		addq	#1,DrawCnt
		cmp	#2,DrawCnt
		bne	1$

		clr.b	ActBlock
		clr	DrawCnt
		clr.l	XBlock
1$:
		movem.l	(sp)+,d0-d7/a0-a6
		rts

CheckDelBlock:	movem.l	d0-d7/a0-a6,-(sp)
		move.l	XBlock2,d0
		beq	1$
		move.l	YBlock2,d1
		beq	1$

		bsr	ClearBlock

		add	#1,DelCnt
		cmp	#2,DelCnt
		bne	1$

		clr.l	XBlock2
		clr	DelCnt
1$:
		movem.l	(sp)+,d0-d7/a0-a6
		rts

DrawBlock: 		; (X,Y,Nr)
		movem.l	d0-d2/a0-a3,-(sp)
		ext.l	d1
		ext.l	d0
		lsl.l	#2,d0			; Breite * 4

		mulu	#1920,d1		; Hoehe * (32*60)
		add.l	d0,d1

		divu	#10,d2
		move	d2,d3
		swap	d2
		ext.l	d2
		lsl	#2,d2
		mulu	#1280,d3		; 32*40
		add.l	d3,d2

		lea	BitmStr1+8,a1
		lea	BitmStr2+8,a3
		lea	back,a2
		add.l	d2,a2			; Source

		movem.l	d1/a0-a6,-(sp)
		lea	BMask,a6

		move.l	a2,a0
		move.l	a0,a1
		add.l	#BPage,a1
		move.l	a1,a2
		add.l	#BPage,a2
		move.l	a2,a3
		add.l	#BPage,a3
		move.l	a3,a4
		add.l	#BPage,a4
		
		moveq	#0,d2
		moveq	#31,d7
10$:
		move.l	(A0,d2.w),d1
		or.l	(A1,d2.w),d1
		or.l	(A2,d2.w),d1
		or.l	(A3,d2.w),d1
		or.l	(A4,d2.w),d1
		move.l	d1,(A6)+
		add.l	#40,d2
		dbf	d7,10$

		movem.l	(sp)+,d1/a0-a6

		moveq	#4,d7
1$:
		move.l	(A1)+,a0
		bsr	Blit
		move.l	(A3)+,a0
		bsr	Blit
		add.l	#BPage,a2
		dbf	d7,1$
		movem.l	(sp)+,d0-d2/a0-a3
		rts


Blit:
		add.l	d1,a0			; Ziel
1$:		btst	#14,dmaconr(A5)
		btst	#14,dmaconr(A5)
		bne	1$

		move.l	#BMask,bltapt(A5)	; Maske
		move.l	a2,bltbpt(A5)		; Source
		move.l	a0,bltcpt(A5)		; Ziel2
		move.l	a0,bltdpt(A5)		; Ziel1
		clr	bltamod(A5)
		move	#36,bltbmod(A5)
		move	#56,bltcmod(A5)
		move	#56,bltdmod(A5)
		move.l	#-1,bltafwm(A5)
		move	#$FCA,bltcon0(A5)	; D=AB+(A)C		bltcon1(A5)
		clr	bltcon1(A5)
		move	#%100000000010,bltsize(A5)
		rts


CopyBlock: 		; (Nr,Nr)
		movem.l	d0-d3/d7/a0-a3,-(sp)
		divu	#10,d0
		move	d0,d3
		swap	d0
		ext.l	d0
		lsl	#2,d0
		mulu	#1280,d3
		add.l	d3,d0
		lea	back,a2
		add.l	d0,a2			; Source

		divu	#10,d1
		move	d1,d3
		swap	d1
		ext.l	d1
		lsl	#2,d1
		mulu	#1280,d3
		add.l	d3,d1
		lea	back,a0
		add.l	d1,a0			; Ziel

		moveq	#4,d7
1$:
		bsr	Blit4
		add.l	#BPage,a2
		add.l	#BPage,a0
		dbf	d7,1$
		movem.l	(sp)+,d0-d3/d7/a0-a3
		rts

Blit4:
1$:		btst	#14,dmaconr(A5)
		btst	#14,dmaconr(A5)
		bne	1$

		move.l	a2,bltapt(A5)		; Source
		move.l	a0,bltdpt(A5)		; Ziel1
		move	#36,bltamod(A5)
		move	#36,bltdmod(A5)
		move.l	#-1,bltafwm(A5)
		move	#$9F0,bltcon0(A5)		; D=AB+(A)C		bltcon1(A5)
		clr	bltcon1(A5)
		move	#%100000000010,bltsize(A5)
		rts

CopyBlock2:	movem.l	d0-d3/d7/a0-a3,-(sp)
		divu	#10,d0
		move	d0,d3
		swap	d0
		ext.l	d0
		lsl	#2,d0
		mulu	#1280,d3
		add.l	d3,d0
		lea	back,a2
		add.l	d0,a2			; Source

		divu	#10,d1
		move	d1,d3
		swap	d1
		ext.l	d1
		lsl	#2,d1
		mulu	#1280,d3
		add.l	d3,d1
		lea	back,a0
		add.l	d1,a0			; Ziel

		movem.l	d1/a0-a6,-(sp)
		lea	BMask,a6
		move.l	a2,a0
		move.l	a0,a1
		add.l	#BPage,a1
		move.l	a1,a2
		add.l	#BPage,a2
		move.l	a2,a3
		add.l	#BPage,a3
		move.l	a3,a4
		add.l	#BPage,a4
		
		moveq	#0,d2
		moveq	#31,d7
10$:
		move.l	(A0,d2.w),d1
		or.l	(A1,d2.w),d1
		or.l	(A2,d2.w),d1
		or.l	(A3,d2.w),d1
		or.l	(A4,d2.w),d1

		move.l	d1,(A6)+
		add.l	#40,d2
		dbf	d7,10$
		movem.l	(sp)+,d1/a0-a6

		moveq	#4,d7
1$:
		bsr	Blit5
		add.l	#BPage,a2
		add.l	#BPage,a0
		dbf	d7,1$
		movem.l	(sp)+,d0-d3/d7/a0-a3
		rts

Blit5:
1$:		btst	#14,dmaconr(A5)
		btst	#14,dmaconr(A5)
		bne	1$

		move.l	#BMask,bltapt(A5)	; Maske
		move.l	a2,bltbpt(A5)		; Source
		move.l	a0,bltcpt(A5)		; Ziel2
		move.l	a0,bltdpt(A5)		; Ziel1
		clr	bltamod(A5)
		move	#36,bltbmod(A5)
		move	#36,bltcmod(A5)
		move	#36,bltdmod(A5)
		move.l	#-1,bltafwm(A5)
		move	#$FCA,bltcon0(A5)	; D=AB+(A)C		bltcon1(A5)
		clr	bltcon1(A5)
		move	#%100000000010,bltsize(A5)
		rts

ClearBlock:	movem.l	d0-d2/a0-a3,-(sp)
		move.l	d0,d2
		move.l	d1,d3

		ext.l	d1
		ext.l	d0
		lsl.l	#2,d0			; Breite * 2
		mulu	#1920,d1		; Hoehe * (16*60)
		add.l	d0,d1

		mulu	#15,d3
		add	d3,d2
		lea	Second,a2
		moveq	#0,d5
		move.b	(A2,d2.w),d5
		divu	#10,d5
		move.l	d5,d6
		swap	d5
		lsl.l	#2,d5
		mulu	#1280,d6
		add.l	d6,d5
		ext.l	d5			; Source

		lea	back,a2
		add.l	d5,a2

		lea	BitmStr2+8,a3
		lea	BitmStr1+8,a1
		moveq	#4,d7
1$:
		move.l	(A1)+,a0
		bsr	Blit2
		move.l	(A3)+,a0
		bsr	Blit2
		add.l	#BPage,a2
		dbf	d7,1$
		movem.l	(sp)+,d0-d2/a0-a3
		rts

Blit2:		add.l	d1,a0			; Ziel
1$:		btst	#14,dmaconr(A5)
		btst	#14,dmaconr(A5)
		bne	1$

		move.l	a2,bltapt(A5)		; Source
		move.l	a0,bltdpt(A5)		; Ziel1
		move	#36,bltamod(A5)
		move	#56,bltdmod(A5)
		move.l	#-1,bltafwm(A5)
		move	#$9F0,bltcon0(A5)		; D=AB+(A)C		bltcon1(A5)
		clr	bltcon1(A5)
		move	#%100000000010,bltsize(A5)
		rts


ClearPages:	lea	page2,a1
		move	#(top-page2)/4-1,d7
1$:		clr.l	(A1)+
		dbf	d7,1$
		rts

ClearMenuPage:	lea	page2,a1
		move	#4000,d7
1$:		clr.l	(A1)+
		dbf	d7,1$
		rts


UpDateRadar:	cmp.l	#50*30,Time
		bhi	RadarOk

		lea	panel+142,a1
		not	RadarFlag
		beq	1$

		lea	Radar1,a2
		bra	2$
1$:
		lea	Radar2,a2
2$:
		moveq	#17,d0
3$:
		move.l	72(A2),1280(A1)
		move.l	144(A2),2560(A1)
		move.l	216(A2),3840(A1)
		move.l	288(A2),5120(A1)
		move.l	(A2)+,(A1)
		add	#40,a1
		dbf	d0,3$
		bra	RadarIt


RadarOk:	lea	panel+142,a1
		moveq	#17,d0
4$:
		and.b	#%11111100,0(A1)
		clr.b	1(A1)
		clr.b	2(A1)
		clr.b	3(A1)
		and.b	#%00111111,4(A1)
		and.b	#%11111100,1280(A1)
		clr.b	1281(A1)
		clr.b	1282(A1)
		clr.b	1283(A1)
		and.b	#%00111111,1284(A1)
		and.b	#%11111100,2560(A1)
		clr.b	2561(A1)
		clr.b	2562(A1)
		clr.b	2563(A1)
		and.b	#%00111111,2564(A1)
		and.b	#%11111100,3840(A1)
		clr.b	3841(A1)
		clr.b	3842(A1)
		clr.b	3843(A1)
		and.b	#%00111111,3844(A1)
		and.b	#%11111100,5120(A1)
		clr.b	5121(A1)
		clr.b	5122(A1)
		clr.b	5123(A1)
		and.b	#%00111111,5124(A1)
		add.l	#40,a1
		dbf	d0,4$

		moveq	#0,d5
		moveq	#0,d6
		lea	First,a1

3$:		cmp.b	#2,(A1)+
		bne	1$

		move.l	d5,d0
		move.l	d6,d1
		add.l	#182,d0
		add.l	#3,d1
		moveq	#25,d7			; Rot
		bsr	WritePixel

1$:		addq	#2,d5
		cmp	#30,d5
		bne	3$
		clr	d5
		addq	#2,d6
		cmp	#20,d6
		bne	3$

		move.l	Bob1,a0
		move	8(A0),d0
		move	10(A0),d1
		moveq	#28,d7
		bsr	SetPixel2		; Leonardo
		move.l	Bob3,a0
		move	8(A0),d0
		move	10(A0),d1
		moveq	#16,d7
		bsr	SetPixel2		; Gegner1
		move.l	Bob4,a0
		move	8(A0),d0
		move	10(A0),d1
		moveq	#16,d7
		bsr	SetPixel2		; Gegner2
		cmp.b	#2,ActBlock
		bne	2$

		move.l	Bob2,a0
		move	8(A0),d0
		move	10(A0),d1
		moveq	#25,d7
		bsr	SetPixel2		; Gegner2
2$:
RadarIt:	bsr	PrintLevel
		bsr	PrintTime
		bsr	PrintScore
		rts

SetPixel2:	lsr	#4,d0
		lsr	#4,d1
		add.l	#182,d0
		add.l	#3,d1
		bra	WritePixel

WritePixel:	movem.l	d0-d7/a1,-(sp)
		lea	panel,a1
		mulu	#40,d1
		move.l	d0,d4
		lsr.l	#3,d4
		add.l	d4,d1
		add.l	d1,a1
		
		and	#7,d0
		moveq	#7,d3
		sub	d0,d3

		moveq	#4,d6
2$:
		btst	#0,d7
		beq	1$
		bset	d3,(A1)
1$:
		add.l	#1280,a1
		lsr	#1,d7
		dbf	d6,2$		
		movem.l	(sp)+,d0-d7/a1		
		rts


PrintLevel:	moveq	#0,d0
		move	ActLevel,d0
		addq	#1,d0

		moveq	#2,d1
		lea	AsciiBuffer+2,a0
		bsr	ToDez

		lea	AsciiBuffer,a0
		moveq	#34,d1
		moveq	#6,d2
		bra	PrintText

PrintScore:	move.l	Score,d0
		moveq	#7,d1
		lea	AsciiBuffer+7,a0
		bsr	ToDez
		lea	AsciiBuffer,a0
		moveq	#14,d1
		moveq	#6,d2
		bsr	PrintText

		move.l	HiPoints,d0
		moveq	#7,d1
		lea	AsciiBuffer+7,a0
		bsr	ToDez
		lea	AsciiBuffer,a0
		moveq	#4,d1
		moveq	#6,d2
		bra	PrintText
		
PrintTime:	move.l	Time,d0
		divu	#50,d0
		ext.l	d0
		moveq	#3,d1
		lea	AsciiBuffer+3,a0
		bsr	ToDez
		lea	AsciiBuffer,a0
		moveq	#28,d1
		moveq	#6,d2
		bra	PrintText


ToDez:		subq	#1,d1
		move.b	#-1,(A0)
1$:
		divu	#10,d0
		swap	d0
		move.b	d0,-(A0)
		clr	d0
		swap	d0
		dbf	d1,1$
		rts


PrintText:	; a0=TextBuffer /d1=x/d2=y
2$:		moveq	#0,d0
		move.b	(A0)+,d0
		cmp.b	#-1,d0
		beq	1$
		bsr	PrintLetter
		addq	#1,d1
		bra	2$
1$:		rts


PrintLetter:	; d0=Buchstabe/d1=x/d2=y
		movem.l	d0-d2/a1-a2,-(sp)
		lea	FontBase+(76*40)+20,a1
		add.l	d0,a1			; Source

		lea	panel,a2
		mulu	#40,d2
		add	d1,a2
		add.l	d2,a2			; Ziel
		moveq	#8,d7
1$:		
		move.b	(A1),(A2)
		move.b	3800(A1),1280(A2)
		move.b	2*3800(A1),2*1280(A2)
		move.b	3*3800(A1),3*1280(A2)
		move.b	4*3800(A1),4*1280(A2)
		add.l	#FontBreite,a1
		add.l	#40,a2
		dbf	d7,1$

		movem.l	(sp)+,d0-d2/a1-a2
		rts


MoveBobs:
		lea	BobList,a0
MoveBobs2:	move.l	(A0),a0
		cmp.l	#0,a0
		beq	EndMoveBobs

		move.l	76(A0),a1		;RelMovePrg
		move.l	a1,d0			;vorhanden ?
		beq.s	EndRelMove
		move	80(A0),d0		;PC holen
		bclr	#15,d0
		addq	#4,80(a0)		;PC erhöhen
		move	(a1,d0.w),d1		;X Move
		move	2(A1,d0.w),d2		;Y Move holen

		cmp	#PrgRelCom,d1		;ist es Kommando ?
		bne.s	RelNoCom		;nein ->

		cmp	#PrgEnde,d2
		beq	RelEnde
		cmp	#PrgLoop,d2		;Prg neu beginnen ?
		beq.s	RelLoop			;ja ->
		cmp	#PrgJump,d2
		beq	RelJump

		bra.s	RelRemove		;wenn unbekannt -> Bob removen

RelJump:
		movem.l	d0-d7/a0-a6,-(sp)
		move.l	4(A1,d0.w),a4
		jsr	(A4)
		movem.l	(sp)+,d0-d7/a0-a6
		addq	#4,80(A0)
		bra	EndRelMove
RelEnde:
		subq	#4,80(a0)
		bset	#7,80(A0)
		bra.s	EndRelMove
RelRemove:
		bsr	RemBob			;Bob removen
		bra.s	EndRelMove
RelLoop:
		clr	80(A0)			;Programm neu starten
		bset	#7,80(A0)
		bra.s	EndRelMove		;PC löschen
RelNoCom:
		bsr	MoveBob			;Bob bewegen
EndRelMove:	
		bra	MoveBobs2
EndMoveBobs:
		rts

CopyLevel:	move.l	LevelPtr,a1
		lea	First,a2
		lea	Second,a3
		move	#149,d0
10$:
		clr.b	(A2)+
		clr.b	(A3)+
		dbf	d0,10$

		lea	First,a2
		lea	Second,a3

		moveq	#14,d7
1$:		move.b	#3,(A2)+
		addq.l	#1,a3
		dbf	d7,1$			; 1.Zeile

		moveq	#7,d6

4$:		move.b	#3,(A2)+
		addq.l	#1,a3
		moveq	#12,d7
3$:
		move.b	(A1)+,d0
		cmp.b	#17,d0
		beq	6$
		cmp.b	#20,d0
		beq	6$
		cmp.b	#21,d0
		beq	6$
		cmp.b	#22,d0
		beq	6$
		cmp.b	#23,d0
		beq	6$
		cmp.b	#57,d0
		beq	6$

		move.b	d0,(A2)
		bra	7$
6$:
		move.b	d0,(A3)		
7$:
		addq.l	#1,a2
		addq.l	#1,a3
		dbf	d7,3$

		move.b	#3,(A2)+
		addq.l	#1,a3
		dbf	d6,4$

		moveq	#14,d7
2$:		move.b	#3,(A2)+
		dbf	d7,2$			; Letzte Zeile

		move.l	(A1)+,(A2)+
		move.l	(A1)+,(A2)+
		move.l	(A1)+,(A2)+
		move	(A1),d0			; Background
		move	d0,d7
		move	(A1)+,(A2)+
		moveq	#23,d1
		bsr	CopyBlock		; TodesStein
		moveq	#28,d0
		moveq	#23,d1
		bsr	CopyBlock2	

		move	d7,d0
		moveq	#20,d1
		bsr	CopyBlock
		moveq	#35,d0
		moveq	#20,d1
		bsr	CopyBlock2

		move	d7,d0
		moveq	#17,d1
		bsr	CopyBlock
		moveq	#30,d0
		moveq	#17,d1
		bsr	CopyBlock2

		move	d7,d0
		moveq	#21,d1
		bsr	CopyBlock
		moveq	#55,d0
		moveq	#21,d1
		bsr	CopyBlock2

		move	d7,d0
		moveq	#22,d1
		bsr	CopyBlock
		moveq	#56,d0
		moveq	#22,d1
		bsr	CopyBlock2

		move	d7,d0
		moveq	#57,d1
		bsr	CopyBlock
		moveq	#31,d0
		moveq	#57,d1
		bsr	CopyBlock2

		move	d7,d0
		lea	Second,a2
		move	#149,d7
5$:		cmp.b	#17,(A2)
		beq	9$
		cmp.b	#20,(A2)
		beq	9$
		cmp.b	#21,(A2)
		beq	9$
		cmp.b	#22,(A2)
		beq	9$
		cmp.b	#23,(A2)
		beq	9$
		cmp.b	#57,(A2)
		beq	9$

		move.b	d0,(A2)			; Second auffuellen
9$:		addq.l	#1,a2
		dbf	d7,5$
	
		moveq	#0,d0
		move	(A1)+,d0
		moveq	#3,d1			; Unzerstoerbar
		bsr	CopyBlock

		moveq	#0,d0
		move	(A1)+,d0
		moveq	#2,d1			; Diamant
		bsr	CopyBlock

		move.l	(A1),a1
		lea	back+20000+18416,a0
		move.l	(A1)+,(A0)+		; 2
		move.l	(A1)+,(A0)+		; 2
		move.l	(A1)+,(A0)+		; 1
		move.l	(A1)+,(A0)+		; 1

		cmp.b	#'B',EndFlag
		beq	20$
		rts

20$:		move	FirstDefs+12,d2
		lea	Second,a2
		lea	First,a1
		move	#149,d7
13$:		cmp.b	#2,(A1)
		bne	15$
		clr.b	(A1)

15$:		cmp.b	#20,(A2)
		bne	14$
		move.b	d2,(A2)
14$:
		addq.l	#1,a1
		addq.l	#1,a2
		dbf	d7,13$

		lea	First,a1
		lea	Second,a2
		move	FirstDefs+12,d1
		move	#149,d7
11$:
		cmp.b	(A2)+,d1
		bne	12$
		tst.b	(A1)
		bne	12$
		move.b	#54,(A1)
12$:
		addq.l	#1,a1
		dbf	d7,11$
	
		st.b	Bonus
		clr.b	EndFlag		
		rts


SetPlane:		;d0=x,d1=y
		tst	d0
		bpl	1$
		moveq	#0,d0
1$:
		cmp	#160+32,d0
		blo	2$
		move	#159+32,d0
2$:
		tst	d1
		bpl	3$
		moveq	#0,d1
3$:
		cmp	#97+32,d1
		blo	4$
		move	#96+32,d1
4$:
		move	d0,PosX
		move	d1,PosY

		move	d0,d2
		and	#$F,d0
		moveq	#$F,d3
		sub	d0,d3
		mulu	#$11,d3
		move	d3,scrollx+2
		lsr	#3,d2

		lea	BitmStr1+8,a0

		tst	FlipFlag
		beq	10$

		lea	BitmStr2+8,a0
10$:		mulu	#60,d1
		ext.l	d1
		ext.l	d2

		lea	page+2,a1
		moveq	#4,d7
5$:
		move.l	(A0)+,d0
		add.l	d1,d0
		add.l	d2,d0

		move	d0,4(A1)
		swap	d0
		move	d0,(A1)
		addq.l	#8,a1
		dbf	d7,5$
		rts

String4:	dc.b	'FREIBIER'

CopyPage:	lea	page1,a1
		lea	page2,a2
		move	#(pagel/4)-1,d0
1$:
		move.l	(A1)+,(A2)+
		dbf	d0,1$
		rts


SetUpPage:	lea	First,a4
SetUp2:		moveq	#0,d0
		moveq	#0,d1
2$:
		moveq	#0,d2
		move.b	(A4)+,d2
		beq	3$
		bsr	DrawBlock
3$:		addq	#1,d0
		cmp	#15,d0
		bne	1$

		moveq	#0,d0
		addq	#1,d1
1$:
		cmp	#10,d1
		bne	2$
		rts

GeneratePage:	lea	Second,a4
		bra	SetUp2


	DSEG

CollList:	dc.l	Bob1,Bob3,SetFlag
		dc.l	Bob1,Bob4,SetFlag
		dc.l	0

CollList2:	dc.l	Bob2,Bob3,EndBob3
		dc.l	Bob2,Bob4,EndBob4
		dc.l	0

WalkRight:	dc.w	21
WalkLeft:	dc.w	0
WalkUp:		dc.w	42
WalkDown:	dc.w	57
DownFlag:	dc.w	1
UpFlag:		dc.w	1

BobbyRight:	dc.w	21
BobbyLeft:	dc.w	0
BobbyUp:	dc.w	56
BobbyDown:	dc.w	42
DownFlag2:	dc.w	1
UpFlag2:	dc.w	1
StartLevel:	dc.w	0

AsciiTab:	dc.b	0,42,43,44,4,5,6,7,8,9,11,11,12,13,14,15,16,17,18,19,20
		dc.b	21,22,23,24,25,26,27,28,29,30,31,41,39,34,35,36,37,38
		dc.b	39,40,41,42,43,44,40,37,47,35,26,27,28,29,30,31,32,33
		dc.b	34,36,59,60,61,62,38,64,0,1,2,3,4,5,6,7,8,9
		dc.b	10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,91,92
		dc.b	93,94,95,96,97,98,99,100,101,102,103,104,105,106,107

String3:	dc.b	'MATTERHORN'

WidhtTab:	dc.b	0,29,28,29,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
		dc.b	21,22,23,24,25,26,27,28,29,30,31,16,11,34,35,36,37,38
		dc.b	39,40,41,42,43,44,17,11,47,18,11,19,19,18,18,19,19,18
		dc.b	18,11,59,60,61,62,20,64,22,20,18,20,18,18,19,21,11,16
		dc.b	21,18,22,21,18,20,21,21,19,21,21,21,23,21,20,19,91,92
		dc.b	93,94,95,96,97,98,99,100,101,102,103,104,105,106,107

		even

HiScoreText:		dc.l	Hi1,Hi2,Hi3,Hi4,Hi5,Hi6,Hi7,Hi8,Hi9,Hi10
			dc.l	Hi11,Hi12,Hi13,Hi14,Hi15,Hi16,Hi17,Hi18,Hi19,Hi20,0
HiScoreText2:
			dc.l	Hi21,Hi22,Hi23,Hi24,Hi25,Hi26,Hi27,Hi28,Hi29,Hi30
			dc.l	0

PerfectText:		dc.l	Per1,Per2,0
StartLevelText:		dc.l	Sl1,Sl2,0
BonusText:		dc.l	Bo1,Bo2,0
GameOverText:		dc.l	Go1,0
GetNameText:		dc.l	Get1,Get2,0
GetNameText2:		dc.l	Get3,Get4,Get5,Get6,Get7,0
GetNameText3:		dc.l	Get8,Get9,0
LivesLeftText:		dc.l	Li1,0
NextLevelText:		dc.l	Nl1,0
TimeOutText:		dc.l	To1,0
CheatLevelText:		dc.l	Ch1,Ch2,Ch3,0
Level10Text:		dc.l	Le11,Le12,Le13,0
Level20Text:		dc.l	Le21,Le22,Le23,0
Level30Text:		dc.l	Le31,Le32,Le33,0

Per1:			dc.b	100,100,'PERFECT',0
Per2:			dc.b	70,125,'BONUS 5000',0

Le11:			dc.b	40,50,'PASSWORD FOR',0
Le12:			dc.b	65,75,'LEVEL 10 :',0
Le13:			dc.b	60,120,'EMMENTALER',0

Le21:			dc.b	40,50,'PASSWORD FOR',0
Le22:			dc.b	65,75,'LEVEL 20 :',0
Le23:			dc.b	80,120,'ALPHORN',0

Le31:			dc.b	40,50,'PASSWORD FOR',0
Le32:			dc.b	65,75,'LEVEL 30 :',0
Le33:			dc.b	60,120,'MATTERHORN',0

Sl1:			dc.b	40,100,'STARTING AT',0
Sl2:			dc.b	40,125,'LEVEL : 10',0

Ch1:			dc.b	25,80,'YOU HAVE FOUND',0
Ch2:			dc.b	40,105,'THE SECRET OF',0
Ch3:			dc.b	80,130,'LEONARDO',0

Hi1:			dc.b	50,0,'RENE',0,0,0,0
Hi2:			dc.b	50,20,'RETO',0,0,0,0

String2:		dc.b	'ALPHORN'

Hi3:			dc.b	50,40,'CHRIS',0,0,0
Hi4:			dc.b	50,60,'ORLANDO',0
Hi5:			dc.b	50,80,'ERICH',0,0,0
Hi6:			dc.b	50,100,'CHRIS A.',0
Hi7:			dc.b	50,120,'HEINZ',0,0,0
Hi8:			dc.b	50,140,'THOMAS',0,0
Hi9:			dc.b	50,160,'FEIBI',0,0,0
Hi10:			dc.b	50,180,'MARKUS',0,0

Hi11:			dc.b	19,0,'1.',0
Hi12:			dc.b	11,20,'2.',0
Hi13:			dc.b	11,40,'3.',0
Hi14:			dc.b	11,60,'4.',0
Hi15:			dc.b	11,80,'5.',0
Hi16:			dc.b	11,100,'6.',0
Hi17:			dc.b	11,120,'7.',0
Hi18:			dc.b	11,140,'8.',0
Hi19:			dc.b	11,160,'9.',0
Hi20:			dc.b	0,180,'10.',0

Hi21:			dc.b	64,0,'100000',0
Hi22:			dc.b	64,20,' 90000',0
Hi23:			dc.b	64,40,' 80000',0
Hi24:			dc.b	64,60,' 70000',0
Hi25:			dc.b	64,80,' 60000',0
Hi26:			dc.b	64,100,' 50000',0
Hi27:			dc.b	64,120,' 40000',0
Hi28:			dc.b	64,140,' 30000',0
Hi29:			dc.b	64,160,' 20000',0
Hi30:			dc.b	64,180,' 10000',0

Go1:			dc.b	70,100,'GAME OVER',0

Get1:			dc.b	70,5,'ENTER YOUR',0
Get2:			dc.b	120,25,'NAME',0

Get3:			dc.b	20,55,'ABCDEFGHIJ',0
Get4:			dc.b	20,75,'KLMNOPQRST',0
Get5:			dc.b	20,95,'UVWXYZ0123',0
Get6:			dc.b	20,115,'456789:.?!',0
Get7:			dc.b	20,135,'-',3,32,2,32,1,0

Get8:			dc.b	40,20,'PLEASE ENTER',0
Get9:			dc.b	70,45,'PASSWORD',0

Li1:			dc.b	60,170,'3 LIVES LEFT',0

Nl1:			dc.b	65,80,'NEXT LEVEL',0

To1:			dc.b	65,80,'OUT OF TIME',0

Bo1:			dc.b	95,70,'ENTERING',0
Bo2:			dc.b	65,90,'BONUS-LEVEL',0

HiTab:			dc.b	'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:.?!-',3,32,2,32,1,32,32,32,32
		
			even
GetText:		dc.l	GetText1,0
GetPointer:		dc.l	GetText2+2
GetText1:		dc.b	50,160
GetText2:		dc.b	'.......'
EndGetText:		dc.b	0

			even
CheatText:		dc.l	CheatText1,0
CheatPointer:		dc.l	CheatText2+2
CheatText1:		dc.b	50,160
CheatText2:		dc.b	'..........'
EndCheatText:		dc.b	0

			even
ScrollPointer:		dc.l	ScrollText
OldScroll:		dc.l	ScrollText
SchwabbelPtr:		dc.l	SinTab
SchwabbelTime:		dc.b	0,0

String1:		dc.b	'EMMENTALER'

		BSS	Widht,2
		BSS	ScrollX,2
		BSS	ScrollX2,2
		BSS	CheatFlag,2
		BSS	RadarFlag,2

		Include	"SinTab.s"

		even


Radar1:	dc.l	$B0000000,$2010545C,$B0501060,$2041A160
	dc.l	$B5402103,$24014485,$B4830906,$25081200
	dc.l	$B0120408,$60303424,$F0005050,$60D0D041
	dc.l	$F48101A0,$65404541,$F4850286,$E1181309
	dc.l	$F0141C36,$60000000,$FC000000,$6C10545C
	dc.l	$6C501060,$FC41A160,$F9402103,$68014485
	dc.l	$68830906,$F9081200,$F8120408,$28303424
	dc.l	$28005050,$B8D0D041,$BC8101A0,$BD404541
	dc.l	$2C850286,$AD181309,$AC141C36,$BC000000
	dc.l	$00000000,$90000000,$90000000,$90000000
	dc.l	$90000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$90000000,$90000000,$90000000
	dc.l	$94000000,$94000000,$94000000,$14000000
	dc.l	$14000000,$94000000,$44000000,$44000000
	dc.l	$44000000,$44000000,$44000000,$D4000000
	dc.l	$D4000000,$D4000000,$D4000000,$D4000000
	dc.l	$D4000000,$D4000000,$D0000000,$D0000000
	dc.l	$D0000000,$40000000,$40000000,$40000000
	dc.l	$F4000000,$F4000000,$F4000000,$F4000000
	dc.l	$F4000000,$F4000000,$F4000000,$F4000000
	dc.l	$F4000000,$F4000000,$F4000000,$F4000000
	dc.l	$F4000000,$F4000000,$F4000000,$64000000
	dc.l	$64000000,$64000000,$00000009,$00050FBF
	dc.l	$0F9F0F7F,$0F5F0F3F,$0E0F0007,$0A0F080F
	dc.l	$060F040F,$000D000B,$0FFF0C0F,$0FDF0305
	dc.l	$05050704,$09030B02,$0D000F00,$0F600F90
	dc.l	$0FB00CC8,$09C900C8

Radar2:	dc.l	$B0000000,$21024545,$B1450005,$20030608
	dc.l	$B514380A,$240850B4,$B4500120,$242042A0
	dc.l	$B0428541,$60828505,$F1051214,$60141005
	dc.l	$F41C142C,$64604048,$F4811090,$E1404321
	dc.l	$F08584A2,$60000000,$FC000000,$6D024545
	dc.l	$6D450005,$FC030608,$F914380A,$680850B4
	dc.l	$68500120,$F82042A0,$F8428541,$28828505
	dc.l	$29051214,$B8141005,$BC1C142C,$BC604048
	dc.l	$2C811090,$AD404321,$AC8584A2,$BC000000
	dc.l	$00000000,$90000000,$90000000,$90000000
	dc.l	$90000000,$00000000,$00000000,$00000000
	dc.l	$00000000,$90000000,$90000000,$90000000
	dc.l	$94000000,$94000000,$94000000,$14000000
	dc.l	$14000000,$94000000,$44000000,$44000000
	dc.l	$44000000,$44000000,$44000000,$D4000000
	dc.l	$D4000000,$D4000000,$D4000000,$D4000000
	dc.l	$D4000000,$D4000000,$D0000000,$D0000000
	dc.l	$D0000000,$40000000,$40000000,$40000000
	dc.l	$F4000000,$F4000000,$F4000000,$F4000000
	dc.l	$F4000000,$F4000000,$F4000000,$F4000000
	dc.l	$F4000000,$F4000000,$F4000000,$F4000000
	dc.l	$F4000000,$F4000000,$F4000000,$64000000
	dc.l	$64000000,$64000000,$00000009,$00050FBF
	dc.l	$0F9F0F7F,$0F5F0F3F,$0E0F0007,$0A0F080F
	dc.l	$060F040F,$000D000B,$0FFF0C0F,$0FDF0305
	dc.l	$05050704,$09030B02,$0D000F00,$0F600F90
	dc.l	$0FB00CC8,$09C900C8
