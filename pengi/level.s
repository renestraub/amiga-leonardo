
	XDEF	Level,LevelPtr,LevelEnd,LevelLenght

	LevelLenght:	EQU	Level1-Level
	
	EI:		EQU	21
	AU:		EQU	22
	TO:		EQU	23
	NB:		EQU	1
	ST:		EQU	3
	DI:		EQU	2
	LA:		EQU	4
	GH:		EQU	5
	KE:		EQU	20
	TN:		EQU	17
	BO:		EQU	57

;	NormalBlock = 1	  Stein      = 3   Diamant = 2
;	Laehmer     = 4   GhostHouse = 5
; 	Tod	    = 23  Entry      = 21  Ausgang = 22

	CSEG

Color1:		dc.w	$ccd,$aab,$695,$474,$252,$440,$330,$220
Color2:		dc.w	$531,$420,$320,$ccd,$aab,$695,$474,$252
Color3:		dc.w	$6bf,$48d,$25b,$12a,$008,$c0f,$90d,$60b
Color4:		dc.w	$f0b,$c0d,$90c,$408,$08f,$08b,$077,$054
Color5:		dc.w	$ff8,$fc6,$da0,$a80,$760,$440,$330,$220
Color6:		dc.w	$abe,$89c,$67a,$458,$d00,$074,$052,$031
Color36:	dc.w	$a9c,$98b,$87a,$769,$658,$547,$436,$325
Color37:	dc.w	$a98,$987,$876,$765,$654,$543,$432,$321
Color38:	dc.w	$893,$782,$672,$561,$351,$340,$230,$120
Color39:	dc.w	$c98,$b87,$a76,$965,$854,$743,$632,$531
Color40:	dc.w	$faf,$e8d,$d6b,$c49,$a36,$924,$812,$700
Color41:	dc.w	$889,$778,$667,$556,$445,$334,$223,$112
Color42:	dc.w	$b00,$a02,$904,$805,$706,$606,$405,$204
Color43:	dc.w	$c80,$b70,$a60,$850,$740,$630,$530,$420
Color44:	dc.w	$6b9,$5a8,$4a7,$396,$285,$174,$063,$052
Color45:	dc.w	$6b9,$5a8,$4a7,$396,$285,$174,$063,$052
Color46:	dc.w	$a00,$900,$800,$700,$600,$500,$400,$300
Color47:	dc.w	$90a,$908,$806,$704,$603,$501,$401,$300
Color48:	dc.w	$a70,$c50,$d00,$a00,$800,$c00,$f00,$f70
Color49:	dc.w	$090,$c00,$070,$046,$050,$820,$030,$807
Color50:	dc.w	$600,$800,$805,$807,$708,$529,$53a,$530
Color51:	dc.w	$7cd,$5ac,$49a,$379,$268,$257,$146,$035
Color52:	dc.w	$033,$054,$376,$588,$747,$b9a,$dbb,$fcc
Color53:	dc.w	$25a,$24a,$239,$228,$217,$216,$205,$204
Color54:	dc.w	$111,$333,$555,$777,$999,$bbb,$ddd,$fff

Level:
	dc.b	0,1,0,0,BO,1,0,0,0,1,0,0,5
	dc.b	0,1,0,1,0,1,0,1,0,1,0,1,0
	dc.b	0,1,21,1,0,1,0,1,0,1,2,1,0
	dc.b	0,1,0,1,2,1,0,1,0,1,4,1,0
	dc.b	0,1,0,1,0,1,0,1,22,1,0,1,0
	dc.b	0,1,0,1,0,1,BO,1,0,1,0,1,0
	dc.b	0,1,0,1,0,1,0,1,0,1,0,1,0
	dc.b	0,0,0,1,0,0,0,1,0,0,0,1,2
	dc.w	32*13,32*1				; GhostHouse (X/Y)
	dc.w	300,260					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	52					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	8					; Diamant
	dc.l	Color52					; ColorTable

LevelEnd:
Level1:	dc.b	1,0,0,0,0,0,0,0,0,0,0,0,1
	dc.b	0,3,0,3,0,0,3,0,0,3,0,3,0
	dc.b	0,3,0,3,0,0,3,0,2,3,0,3,0
	dc.b	0,3,0,3,0,0,5,0,0,3,0,3,0
	dc.b	0,3,0,3,0,0,3,2,0,3,0,3,0
	dc.b	0,3,0,3,0,0,3,BO,0,3,0,3,2
	dc.b	0,3,0,3,0,0,3,0,0,3,0,3,0
	dc.b	1,0,0,0,0,0,0,0,0,0,0,BO,1
	dc.w	32*7,32*4				; GhostHouse (X/Y)
	dc.w	100,160					; MonsterDelay1,2
	dc.w	32*7,32*8				; StartPoint
	dc.w	53					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	27					; Diamant
	dc.l	Color53					; ColorTable

	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,3,0,3,0,3,0,3,0,3,0,3,0
	dc.b	0,0,2,0,0,0,0,0,0,0,2,0,0
	dc.b	0,3,1,0,0,0,4,0,0,0,1,3,0
	dc.b	0,3,1,0,0,0,5,0,0,0,1,3,0
	dc.b	0,0,2,0,0,0,0,0,0,0,0,0,0
	dc.b	0,3,0,3,0,3,0,3,0,3,0,3,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	32*7,32*5				; GhostHouse (X/Y)
	dc.w	134,260					; MonsterDelay1,2
	dc.w	32*7,32*8				; StartPoint
	dc.w	18					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	24					; Diamant
	dc.l	Color4					; ColorTable

	dc.b	BO,0,2,0,0,0,0,0,0,0,0,0,BO
	dc.b	0,1,1,1,1,1,1,1,1,1,1,1,0
	dc.b	0,0,2,0,0,0,0,0,0,0,0,1,0
	dc.b	0,1,1,1,1,1,1,1,1,1,0,1,0
	dc.b	0,1,2,0,0,0,0,0,0,1,0,1,0
	dc.b	0,1,5,0,0,0,0,0,0,0,0,1,0
	dc.b	0,1,1,1,1,1,1,1,1,1,1,1,0
	dc.b	BO,0,4,0,0,0,0,0,0,0,0,0,BO
	dc.w	32*3,32*6				; GhostHouse (X/Y)
	dc.w	124,160					; MonsterDelay1,2
	dc.w	32*1,32*1				; StartPoint
	dc.w	19					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	6					; Diamant
	dc.l	Color4					; ColorTable

	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,3,1,3,1,3,1,3,1,3,1,3,0
	dc.b	0,1,BO,0,0,0,0,0,0,0,0,1,0
	dc.b	0,3,0,2,0,0,2,0,0,0,0,3,0
	dc.b	0,3,0,0,0,0,TN,0,0,0,0,3,0
	dc.b	0,1,0,0,0,0,5,0,2,0,0,1,0
	dc.b	0,3,1,3,1,3,1,3,1,3,1,3,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	32*7,32*6				; GhostHouse (X/Y)
	dc.w	85,121					; MonsterDelay1,2
	dc.w	32*7,32*3				; StartPoint
	dc.w	10					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	27					; Diamant
	dc.l	Color5					; ColorTable

	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,KE
	dc.b	0,1,1,1,0,1,1,1,0,1,1,1,0
	dc.b	0,1,0,0,0,1,BO,0,0,1,0,2,0
	dc.b	0,1,0,0,0,1,0,0,0,1,0,0,0
	dc.b	0,1,2,1,0,1,2,1,0,1,0,0,0
	dc.b	0,1,0,1,0,1,0,1,0,1,0,5,0
	dc.b	0,1,1,1,0,1,1,1,0,1,1,1,0
	dc.b	TN,0,0,0,0,0,0,0,0,0,0,0,4
	dc.w	32*12,32*6				; GhostHouse (X/Y)
	dc.w	253,129					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	12					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	26					; Diamant
	dc.l	Color4					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,LA,NB,NB,TO,TO,TO,TO,TO,NB,NB,EI,00
	DC.B	00,NB,00,BO,00,00,DI,00,00,TN,00,NB,00
	DC.B	00,NB,00,00,00,DI,00,DI,00,00,00,NB,00
	DC.B	00,NB,00,00,00,00,GH,00,00,00,00,NB,00
	DC.B	00,NB,00,00,BO,00,00,00,00,00,00,NB,00
	DC.B	00,AU,NB,NB,TO,TO,TO,TO,TO,NB,NB,LA,00
	DC.B	BO,00,00,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*5				; GhostHouse (X/Y)
	dc.w	350,450					; MonsterDelay1,2
	dc.w	32*7,32*4				; StartPoint
	dc.w	48					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	26					; Diamant
	dc.l	Color48					; ColorTable

	dc.b	0,4,0,0,1,0,0,1,0,0,1,0,0
	dc.b	0,0,0,1,0,0,1,0,0,2,0,0,1
	dc.b	0,0,1,0,0,1,0,0,1,0,0,1,0
	dc.b	0,1,0,0,2,0,0,1,0,0,1,0,0
	dc.b	1,0,0,1,0,BO,1,0,0,1,0,0,1
	dc.b	0,0,1,0,0,1,0,0,1,0,0,1,0
	dc.b	0,1,0,0,1,0,0,2,0,0,1,TN,0
	dc.b	1,0,0,1,0,0,1,0,0,1,0,0,5
	dc.w	32*13,32*8				; GhostHouse (X/Y)
	dc.w	53,250					; MonsterDelay1,2
	dc.w	32*1,32*2				; StartPoint
	dc.w	43					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	29					; Diamant
	dc.l	Color43					; ColorTable

	dc.b	0,0,0,0,0,0,0,1,0,0,0,0,0
	dc.b	2,3,3,3,0,3,0,1,0,0,0,2,0
	dc.b	0,0,0,3,5,3,0,1,0,0,0,0,0
	dc.b	0,0,0,3,3,3,0,1,1,1,1,0,0
	dc.b	0,BO,0,0,0,0,0,0,0,0,1,0,0
	dc.b	1,1,1,1,1,2,1,1,1,0,1,0,0
	dc.b	0,0,0,0,0,0,0,0,1,0,1,0,0
	dc.b	0,0,0,TN,0,0,0,0,1,0,1,0,0
	dc.w	32*5,32*3				; GhostHouse (X/Y)
	dc.w	206,161					; MonsterDelay1,2
	dc.w	32*13,32*1				; StartPoint
	dc.w	51					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	9					; Diamant
	dc.l	Color51					; ColorTable

	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,DI,NB,NB,NB
	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	DC.B	NB,NB,DI,NB,GH,00,NB,NB,NB,NB,NB,NB,NB
	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,DI,NB,NB,NB,NB
	DC.B	NB,BO,BO,BO,BO,BO,BO,BO,BO,BO,BO,BO,NB
	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	dc.w	32*5,32*4				; GhostHouse (X/Y)
	dc.w	255,133					; MonsterDelay1,2
	dc.w	32*6,32*4				; StartPoint
	dc.w	45					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	24					; Diamant
	dc.l	Color45					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,NB,00
	DC.B	TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO
	DC.B	BO,00,00,00,00,00,00,00,00,00,00,NB,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,DI,00
	DC.B	00,00,00,00,TN,00,00,00,00,00,00,NB,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,NB,00
	DC.B	DI,GH,00,00,00,00,00,00,00,00,00,NB,00
	DC.B	00,DI,00,00,00,00,00,00,00,00,00,NB,00
	dc.w	32*2,32*7				; GhostHouse (X/Y)
	dc.w	234,432					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	13					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	27					; Diamant
	dc.l	Color2					; ColorTable

	dc.b	5,0,0,3,3,3,3,3,3,3,0,0,0
	dc.b	0,3,0,3,0,TN,0,0,0,3,0,3,0
	dc.b	0,3,0,3,0,2,0,0,2,3,0,3,0
	dc.b	0,3,0,3,0,0,BO,0,0,3,0,3,0
	dc.b	0,3,0,3,3,3,2,3,3,3,0,3,0
	dc.b	0,3,0,0,0,3,0,3,0,0,0,3,0
	dc.b	0,3,3,3,3,3,0,3,3,3,3,3,0
	dc.b	0,0,0,0,0,0,0,0,BO,0,0,0,0
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	209,181					; MonsterDelay1,2
	dc.w	32*13,32*1				; StartPoint
	dc.w	16					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	7					; Diamant
	dc.l	Color3					; ColorTable

	DC.B	00,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,GH
	DC.B	TO,00,00,00,00,00,00,DI,00,00,00,00,TO
	DC.B	TO,00,00,DI,00,00,00,00,00,00,00,00,TO
	DC.B	TO,00,00,00,00,00,00,00,00,00,00,00,TO
	DC.B	TO,00,00,00,00,00,00,00,00,00,00,00,TO
	DC.B	TO,00,00,00,00,00,00,00,00,00,00,00,TO
	DC.B	TO,00,00,00,DI,00,BO,00,00,00,00,00,TO
	DC.B	LA,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,LA
	dc.w	32*13,32*1				; GhostHouse (X/Y)
	dc.w	150,245					; MonsterDelay1,2
	dc.w	32*1,32*1				; StartPoint
	dc.w	40					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	9					; Diamant
	dc.l	Color40					; ColorTable

	dc.b	5,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,3,3,3,3,3,1,3,3,3,3,3,0
	dc.b	0,3,1,1,1,1,1,1,1,1,1,3,0
	dc.b	0,3,1,1,1,2,1,1,1,2,1,3,0
	dc.b	0,3,2,1,1,1,1,1,1,1,1,3,0
	dc.b	0,3,1,1,1,1,1,1,1,1,1,3,0
	dc.b	0,3,3,3,3,3,1,3,3,3,3,3,0
	dc.b	TN,0,0,0,0,0,0,0,0,0,0,0,BO
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	55,136					; MonsterDelay1,2
	dc.w	32*13,32*8				; StartPoint
	dc.w	39					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	8					; Diamant
	dc.l	Color39					; ColorTable

	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,3,1,1,1,0,2,0,1,1,1,3,0
	dc.b	0,3,0,0,0,0,0,0,0,0,TN,3,0
	dc.b	0,3,2,0,0,0,5,0,0,0,0,3,0
	dc.b	0,3,0,0,BO,0,4,0,0,0,0,3,0
	dc.b	0,3,0,0,0,0,0,0,0,0,0,3,0
	dc.b	0,3,1,1,1,0,2,0,1,1,1,3,0
	dc.b	0,0,0,0,0,0,KE,0,0,0,0,0,0
	dc.w	32*7,32*4				; GhostHouse (X/Y)
	dc.w	230,278					; MonsterDelay1,2
	dc.w	32*7,32*1				; StartPoint
	dc.w	33					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	7					; Diamant
	dc.l	Color6					; ColorTable

	DC.B	00,00,00,00,NB,00,00,00,00,00,00,NB,00
	DC.B	NB,NB,NB,NB,NB,00,GH,NB,NB,00,00,NB,00
	DC.B	NB,00,00,00,00,00,NB,00,NB,NB,NB,NB,00
	DC.B	NB,00,NB,NB,DI,00,NB,00,00,00,00,00,00
	DC.B	NB,00,NB,00,NB,00,DI,NB,NB,NB,NB,NB,00
	DC.B	NB,00,NB,00,NB,00,00,00,00,00,00,NB,00
	DC.B	NB,00,NB,00,NB,NB,NB,NB,NB,NB,NB,NB,00
	DC.B	NB,NB,DI,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*2				; GhostHouse (X/Y)
	dc.w	342,231					; MonsterDelay1,2
	dc.w	32*13,32*1				; StartPoint
	dc.w	49					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	8					; Diamant
	dc.l	Color49					; ColorTable

	DC.B	00,NB,NB,NB,NB,00,ST,00,NB,NB,NB,NB,00
	DC.B	00,NB,NB,NB,NB,00,ST,00,NB,NB,DI,NB,00
	DC.B	00,NB,NB,DI,NB,00,ST,00,NB,NB,NB,NB,00
	DC.B	00,NB,NB,NB,NB,00,TO,00,NB,NB,NB,NB,AU
	DC.B	EI,NB,NB,BO,NB,00,TO,00,NB,NB,NB,NB,GH
	DC.B	00,NB,NB,NB,NB,00,ST,00,NB,NB,NB,NB,00
	DC.B	00,NB,NB,NB,NB,00,ST,00,NB,DI,NB,NB,00
	DC.B	00,NB,NB,NB,NB,00,ST,BO,NB,NB,NB,NB,00
	dc.w	32*13,32*5				; GhostHouse (X/Y)
	dc.w	167,123					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	38					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color38					; ColorTable

	dc.b	0,2,0,0,0,0,0,0,0,2,5,0,0
	dc.b	0,0,3,0,0,0,0,0,3,0,0,0,0
	dc.b	0,0,0,3,TN,0,0,3,0,0,0,0,4
	dc.b	0,3,0,0,2,0,3,0,0,3,0,3,0
	dc.b	3,0,3,0,0,3,0,0,3,0,3,0,0
	dc.b	0,0,0,3,0,0,0,3,0,0,0,0,0
	dc.b	0,0,0,0,3,0,3,0,0,0,0,0,0
	dc.b	0,0,0,0,0,3,0,0,0,BO,0,0,0
	dc.w	32*11,32*1				; GhostHouse (X/Y)
	dc.w	180,144					; MonsterDelay1,2
	dc.w	32*13,32*8				; StartPoint
	dc.w	19					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	6					; Diamant
	dc.l	Color5					; ColorTable

	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,2,0,1,0,1,0,1,0,1,0,1,0
	dc.b	0,3,0,5,0,1,0,1,0,1,0,1,0
	dc.b	0,3,0,1,0,2,0,1,0,1,BO,1,0
	dc.b	0,3,TN,1,0,1,0,0,0,1,0,1,0
	dc.b	0,3,0,1,0,1,0,1,0,2,0,1,0
	dc.b	0,3,0,1,0,1,0,1,0,1,0,4,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	32*4,32*3				; GhostHouse (X/Y)
	dc.w	200,50					; MonsterDelay1,2
	dc.w	32*8,32*5				; StartPoint
	dc.w	48					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	6					; Diamant
	dc.l	Color48					; ColorTable

	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,1,0,0,0,0,1,0,0,0,0,1,0
	dc.b	0,5,0,0,0,1,1,0,0,0,1,1,0
	dc.b	0,1,0,0,2,TN,1,0,0,1,0,0,0
	dc.b	0,1,0,1,0,0,2,0,1,0,0,1,0
	dc.b	0,1,1,0,0,0,1,1,0,0,0,2,0
	dc.b	0,1,0,0,0,0,1,0,0,0,0,1,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	32*2,32*3				; GhostHouse (X/Y)
	dc.w	100,160					; MonsterDelay1,2
	dc.w	32*12,32*4				; StartPoint
	dc.w	36					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	27					; Diamant
	dc.l	Color36					; ColorTable

	DC.B	00,00,NB,00,00,00,00,00,00,00,00,00,BO
	DC.B	00,00,NB,00,TO,TO,TO,TO,TO,TO,TO,TO,00
	DC.B	00,00,NB,00,TO,TO,TO,TO,TO,TO,TO,TO,00
	DC.B	00,00,NB,00,TO,TO,TO,TO,TO,TO,TO,TO,00
	DC.B	00,00,NB,00,00,00,00,00,00,00,00,00,00
	DC.B	NB,NB,00,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	DC.B	00,00,NB,00,DI,00,00,00,00,00,DI,00,00
	DC.B	BO,00,NB,00,00,00,00,DI,00,00,00,00,GH
	dc.w	32*13,32*8				; GhostHouse (X/Y)
	dc.w	231,124					; MonsterDelay1,2
	dc.w	32*3,32*6				; StartPoint
	dc.w	39					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color39					; ColorTable

	dc.b	5,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,1,1,1,1,1,1,1,1,1,1,1,0
	dc.b	0,1,1,1,1,1,2,1,1,1,1,1,0
	dc.b	0,1,1,1,1,1,1,1,1,1,1,1,0
	dc.b	0,1,1,2,1,1,TN,1,1,1,1,1,0
	dc.b	0,1,1,1,1,1,1,1,1,2,1,1,0
	dc.b	0,1,1,1,1,1,1,1,1,1,1,1,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	167,240					; MonsterDelay1,2
	dc.w	32*13,32*8				; StartPoint
	dc.w	46					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	6					; Diamant
	dc.l	Color46					; ColorTable

	DC.B	00,NB,00,NB,00,ST,00,NB,00,00,ST,00,GH
	DC.B	00,NB,ST,00,DI,NB,00,ST,ST,00,NB,00,00
	DC.B	00,ST,NB,00,NB,00,ST,00,NB,ST,NB,00,00
	DC.B	00,00,ST,ST,ST,NB,00,BO,DI,NB,ST,00,00
	DC.B	00,ST,00,NB,DI,00,ST,00,NB,NB,NB,00,00
	DC.B	00,NB,ST,NB,ST,BO,NB,00,ST,ST,ST,ST,00
	DC.B	00,ST,NB,00,NB,00,ST,00,ST,BO,NB,NB,00
	DC.B	00,00,ST,BO,ST,00,00,00,NB,00,ST,ST,00
	dc.w	32*13,32*1				; GhostHouse (X/Y)
	dc.w	431,321					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	52					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	6					; Diamant
	dc.l	Color52					; ColorTable

	dc.b	3,0,0,0,0,0,0,0,0,0,0,0,3
	dc.b	0,2,0,0,0,0,1,0,0,0,0,2,0
	dc.b	0,0,3,0,0,1,0,1,0,0,3,0,0
	dc.b	0,0,0,3,1,0,BO,0,1,3,0,0,0
	dc.b	0,0,0,1,3,0,0,0,3,1,0,0,0
	dc.b	0,0,1,0,0,3,5,3,0,0,1,0,0
	dc.b	0,1,0,0,0,0,2,0,0,0,0,1,0
	dc.b	1,0,0,0,0,0,TN,0,0,0,0,0,1
	dc.w	32*7,32*6				; GhostHouse (X/Y)
	dc.w	123,187					; MonsterDelay1,2
	dc.w	32*7,32*8				; StartPoint
	dc.w	13					; Hintergrund
	dc.w	15					; Unzerstoerbarer Stein
	dc.w	8					; Diamant
	dc.l	Color2					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,00
	DC.B	00,NB,NB,NB,NB,DI,NB,NB,NB,NB,NB,NB,00
	DC.B	00,NB,DI,NB,NB,NB,EI,NB,NB,00,NB,NB,00
	DC.B	00,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,00
	DC.B	00,00,BO,00,00,00,00,00,00,00,BO,00,00
	DC.B	TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO
	DC.B	00,00,00,AU,00,00,00,00,DI,00,00,00,GH
	dc.w	32*13,32*8				; GhostHouse (X/Y)
	dc.w	250,350					; MonsterDelay1,2
	dc.w	32*10,32*4				; StartPoint
	dc.w	49					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	29					; Diamant
	dc.l	Color49					; ColorTable

	DC.B	00,NB,00,00,00,00,00,00,ST,00,00,00,00
	DC.B	00,NB,00,BO,00,00,DI,00,ST,00,00,00,00
	DC.B	00,NB,00,00,00,00,ST,00,ST,00,DI,00,00
	DC.B	00,NB,00,00,00,00,ST,00,ST,00,ST,GH,ST
	DC.B	00,NB,00,00,00,TN,ST,00,ST,00,00,00,00
	DC.B	00,NB,00,00,00,00,ST,00,ST,00,ST,DI,ST
	DC.B	00,NB,00,BO,00,00,ST,00,00,00,00,00,00
	DC.B	00,NB,00,00,00,00,ST,NB,NB,NB,NB,NB,NB
	dc.w	32*12,32*4				; GhostHouse (X/Y)
	dc.w	123,234					; MonsterDelay1,2
	dc.w	32*1,32*2				; StartPoint
	dc.w	37					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	9					; Diamant
	dc.l	Color37					; ColorTable

	DC.B	ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST
	DC.B	ST,NB,NB,ST,ST,ST,ST,NB,GH,ST,ST,ST,ST
	DC.B	ST,DI,TO,TO,ST,TO,TO,TO,TO,TO,ST,ST,ST
	DC.B	ST,ST,DI,NB,NB,NB,NB,NB,NB,NB,EI,ST,ST
	DC.B	ST,ST,00,DI,TO,TO,ST,TO,TO,TO,TO,TO,ST
	DC.B	ST,ST,ST,NB,AU,ST,ST,ST,NB,NB,NB,NB,ST
	DC.B	ST,ST,ST,ST,ST,ST,ST,ST,ST,TO,TO,ST,ST
	DC.B	ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST
	dc.w	32*9,32*2				; GhostHouse (X/Y)
	dc.w	121,80					; MonsterDelay1,2
	dc.w	32*3,32*5				; StartPoint
	dc.w	39					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	27					; Diamant
	dc.l	Color39					; ColorTable

	dc.b	GH,00,00,00,00,00,00,00,00,00,00,00,00
	dc.b	00,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,00
	dc.b	00,TO,00,00,00,00,TN,00,00,00,00,TO,00
	dc.b	00,TO,00,NB,NB,NB,DI,NB,NB,NB,00,TO,00
	dc.b	00,TO,00,NB,DI,NB,NB,NB,DI,NB,00,TO,00
	dc.b	00,TO,BO,00,00,00,AU,00,00,00,00,TO,00
	dc.b	00,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,00
	dc.b	00,00,00,00,00,00,EI,00,00,00,00,00,00
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	198,145					; MonsterDelay1,2
	dc.w	32*13,32*1				; StartPoint
	dc.w	40					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	6					; Diamant
	dc.l	Color40					; ColorTable

	dc.b	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,AU
	dc.b	EI,TO,NB,NB,NB,NB,TO,NB,NB,NB,NB,NB,NB
	dc.b	00,00,ST,NB,NB,NB,NB,ST,NB,NB,NB,NB,NB
	dc.b	00,00,00,TO,BO,NB,NB,NB,TO,NB,DI,NB,NB
	dc.b	00,00,00,00,ST,NB,NB,NB,DI,ST,NB,NB,NB
	dc.b	DI,00,00,00,00,TO,NB,NB,NB,NB,TO,NB,NB
	dc.b	00,00,00,00,00,00,ST,NB,NB,NB,NB,ST,NB
	dc.b	00,GH,00,00,00,00,00,LA,NB,NB,NB,NB,TO
	dc.w	32*2,32*8				; GhostHouse (X/Y)
	dc.w	199,287					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	41					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color41					; ColorTable

	DC.B	GH,00,00,00,00,00,LA,00,00,00,00,00,00
	DC.B	00,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,00
	DC.B	00,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,00
	DC.B	00,00,00,00,00,TN,00,00,00,00,00,00,00
	DC.B	00,00,DI,00,00,00,00,DI,00,00,00,00,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,00,00,00,00,00,BO,00,00,00,00,00,00
	DC.B	00,23,23,23,23,23,23,23,23,DI,23,23,00
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	325,254					; MonsterDelay1,2
	dc.w	32*13,32*1				; StartPoint
	dc.w	42					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	8					; Diamant
	dc.l	Color42					; ColorTable

	DC.B	00,ST,00,00,00,00,00,TO,TO,TO,TO,TO,EI
	DC.B	00,ST,00,NB,NB,00,00,00,TO,TO,TO,TO,GH
	DC.B	00,ST,00,NB,NB,00,00,00,00,TO,TO,TO,TO
	DC.B	00,ST,00,00,00,00,00,00,00,00,TO,TO,TO
	DC.B	00,ST,00,00,00,00,00,00,00,00,00,TO,TO
	DC.B	00,ST,00,00,00,00,00,00,00,00,00,DI,AU
	DC.B	00,ST,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,ST,00,00,00,00,DI,00,00,00,00,00,DI
	dc.w	32*13,32*2				; GhostHouse (X/Y)
	dc.w	99,199					; MonsterDelay1,2
	dc.w	32*13,32*1				; StartPoint
	dc.w	43					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	29					; Diamant
	dc.l	Color43					; ColorTable

	DC.B	00,NB,NB,NB,00,00,ST,00,00,NB,NB,NB,BO
	DC.B	00,NB,NB,NB,00,00,ST,00,00,NB,DI,NB,00
	DC.B	00,NB,DI,NB,00,00,00,00,00,NB,NB,NB,00
	DC.B	00,NB,NB,NB,00,00,ST,00,00,NB,NB,NB,00
	DC.B	00,NB,NB,NB,00,00,ST,00,00,NB,NB,NB,00
	DC.B	00,NB,NB,NB,00,00,GH,00,00,NB,NB,NB,00
	DC.B	00,NB,NB,NB,00,00,ST,00,00,NB,DI,NB,00
	DC.B	00,NB,NB,NB,00,00,ST,00,00,NB,NB,NB,KE
	dc.w	32*7,32*6				; GhostHouse (X/Y)
	dc.w	50,421					; MonsterDelay1,2
	dc.w	32*7,32*3				; StartPoint
	dc.w	44					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color44					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,TO,DI,ST,ST,ST,NB,ST,ST,ST,00,TO,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,ST,00,00,00,00,DI,00,TN,00,00,ST,00
	DC.B	00,ST,00,00,00,00,00,00,00,00,00,ST,00
	DC.B	00,00,00,00,00,00,GH,00,00,00,DI,00,00
	DC.B	00,TO,00,ST,ST,ST,NB,ST,ST,ST,00,TO,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*6				; GhostHouse (X/Y)
	dc.w	231,155					; MonsterDelay1,2
	dc.w	32*7,32*5				; StartPoint
	dc.w	45					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	9					; Diamant
	dc.l	Color45					; ColorTable

	DC.B	00,NB,00,NB,00,NB,TO,NB,00,NB,00,NB,00
	DC.B	00,NB,EI,NB,00,NB,DI,NB,00,NB,DI,NB,00
	DC.B	00,NB,00,NB,00,NB,00,NB,00,NB,00,NB,00
	DC.B	00,NB,00,NB,00,NB,GH,NB,00,NB,00,NB,00
	DC.B	00,NB,00,NB,00,NB,BO,NB,00,NB,00,NB,00
	DC.B	00,NB,00,NB,00,NB,00,NB,00,NB,00,NB,00
	DC.B	00,NB,00,NB,00,NB,DI,NB,00,NB,AU,NB,00
	DC.B	00,NB,00,NB,00,NB,00,NB,00,NB,00,NB,00
	dc.w	32*7,32*4				; GhostHouse (X/Y)
	dc.w	256,128					; MonsterDelay1,2
	dc.w	32*7,32*8				; StartPoint
	dc.w	46					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	24					; Diamant
	dc.l	Color46					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,00
	DC.B	00,ST,00,TO,00,00,TO,00,00,TO,00,ST,00
	DC.B	00,EI,00,00,DI,00,00,00,00,00,00,AU,00
	DC.B	00,00,DI,00,00,00,TN,DI,00,00,00,LA,00
	DC.B	00,ST,00,00,00,00,00,00,00,00,00,ST,00
	DC.B	00,ST,ST,ST,ST,ST,GH,ST,ST,ST,ST,ST,00
	DC.B	00,00,00,00,00,00,BO,00,00,00,00,00,00
	dc.w	32*7,32*7				; GhostHouse (X/Y)
	dc.w	111,222					; MonsterDelay1,2
	dc.w	32*2,32*5				; StartPoint
	dc.w	47					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	6					; Diamant
	dc.l	Color47					; ColorTable

	DC.B	NB,00,NB,00,NB,00,TO,00,NB,00,NB,00,NB
	DC.B	EI,00,LA,00,00,00,GH,00,00,00,DI,00,00
	DC.B	NB,00,NB,00,NB,00,TO,00,NB,00,NB,00,NB
	DC.B	NB,00,NB,00,NB,00,TO,00,NB,00,NB,00,NB
	DC.B	NB,00,NB,00,NB,00,TO,00,NB,00,NB,00,NB
	DC.B	NB,00,NB,00,NB,00,TO,00,NB,00,NB,00,NB
	DC.B	KE,00,DI,00,00,00,TN,00,DI,00,00,00,AU
	DC.B	NB,00,NB,BO,NB,00,TO,00,NB,BO,NB,00,NB
	dc.w	32*7,32*2				; GhostHouse (X/Y)
	dc.w	77,111					; MonsterDelay1,2
	dc.w	32*7,32*7				; StartPoint
	dc.w	48					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	25					; Diamant
	dc.l	Color48					; ColorTable

	DC.B	00,00,00,00,00,00,GH,00,00,00,00,00,00
	DC.B	00,NB,NB,NB,NB,00,ST,00,NB,NB,NB,NB,00
	DC.B	00,NB,TO,TO,NB,00,ST,00,NB,TO,TO,NB,00
	DC.B	00,NB,TO,TO,NB,00,ST,00,NB,TO,TO,NB,00
	DC.B	00,NB,NB,NB,NB,00,ST,00,NB,NB,NB,NB,00
	DC.B	00,00,00,00,00,00,DI,00,00,00,00,00,00
	DC.B	EI,DI,ST,ST,ST,ST,ST,ST,ST,ST,ST,DI,AU
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*1				; GhostHouse (X/Y)
	dc.w	231,122					; MonsterDelay1,2
	dc.w	32*7,32*8				; StartPoint
	dc.w	49					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	6					; Diamant
	dc.l	Color49					; ColorTable

	DC.B	GH,ST,00,00,00,ST,00,00,NB,NB,NB,NB,NB
	DC.B	00,ST,00,TO,00,ST,00,00,NB,NB,NB,NB,NB
	DC.B	00,ST,00,TO,00,ST,00,00,NB,DI,NB,NB,NB
	DC.B	00,ST,00,TO,00,ST,00,00,NB,NB,NB,NB,NB
	DC.B	00,ST,00,TO,00,ST,00,BO,NB,NB,NB,DI,TN
	DC.B	00,ST,00,TO,00,ST,00,00,NB,NB,NB,NB,NB
	DC.B	00,ST,00,TO,00,ST,00,00,NB,NB,NB,NB,NB
	DC.B	EI,ST,AU,TO,00,DI,00,00,NB,NB,NB,NB,NB
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	231,70					; MonsterDelay1,2
	dc.w	32*1,32*3				; StartPoint
	dc.w	51					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	8					; Diamant
	dc.l	Color51					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,ST,ST,ST,ST,ST,GH,ST,ST,ST,ST,ST,00
	DC.B	00,NB,00,00,00,00,TO,00,00,00,00,NB,00
	DC.B	00,NB,00,DI,00,00,TO,00,00,00,00,NB,00
	DC.B	00,NB,00,00,00,DI,TO,00,DI,00,00,NB,00
	DC.B	00,NB,00,00,00,00,TO,00,00,00,00,NB,00
	DC.B	00,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*2				; GhostHouse (X/Y)
	dc.w	321,162					; MonsterDelay1,2
	dc.w	32*7,32*1				; StartPoint
	dc.w	32					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color6					; ColorTable

	DC.B	00,DI,00,00,00,00,00,00,DI,ST,TO,ST,GH
	DC.B	00,00,TN,00,00,ST,ST,ST,ST,ST,TO,ST,00
	DC.B	00,ST,ST,ST,00,ST,TO,TO,TO,TO,TO,ST,00
	DC.B	00,ST,TO,ST,00,ST,TO,ST,ST,ST,ST,ST,00
	DC.B	00,ST,TO,ST,DI,ST,ST,ST,BO,00,00,00,00
	DC.B	00,ST,TO,ST,00,00,00,00,00,ST,ST,ST,ST
	DC.B	00,ST,TO,ST,ST,ST,ST,ST,ST,ST,TO,TO,TO
	DC.B	00,ST,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO,TO
	dc.w	32*13,32*1				; GhostHouse (X/Y)
	dc.w	100,124					; MonsterDelay1,2
	dc.w	32*13,32*3				; StartPoint
	dc.w	50					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color50					; ColorTable

	DC.B	00,TO,00,TO,00,00,TO,00,00,NB,00,TO,00
	DC.B	00,TO,00,NB,00,00,00,00,00,TO,00,TO,00
	DC.B	00,TO,00,NB,00,DI,GH,EI,00,NB,00,TO,00
	DC.B	00,TO,00,TO,00,00,00,00,00,NB,00,TO,00
	DC.B	00,TO,00,NB,00,00,00,00,00,TO,00,TO,00
	DC.B	00,TO,00,DI,00,00,00,00,00,NB,00,TO,00
	DC.B	00,TO,00,TO,00,BO,00,00,00,NB,00,TO,DI
	DC.B	00,TO,00,NB,00,00,00,AU,00,TO,00,TO,00
	dc.w	32*7,32*3				; GhostHouse (X/Y)
	dc.w	373,245					; MonsterDelay1,2
	dc.w	32*7,32*2				; StartPoint
	dc.w	52					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	27					; Diamant
	dc.l	Color54					; ColorTable

	DC.B	ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST,ST
	DC.B	00,00,ST,ST,ST,ST,ST,ST,ST,ST,ST,00,00
	DC.B	TO,00,00,DI,ST,ST,ST,ST,ST,00,00,00,TO
	DC.B	TO,TO,00,00,00,BO,GH,BO,00,00,00,TO,TO
	DC.B	TO,TO,00,00,00,BO,LA,BO,00,00,00,TO,TO
	DC.B	TO,00,00,DI,NB,NB,NB,NB,NB,DI,00,00,TO
	DC.B	00,00,NB,NB,NB,NB,NB,NB,NB,NB,NB,00,00
	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	dc.w	32*7,32*4				; GhostHouse (X/Y)
	dc.w	321,123					; MonsterDelay1,2
	dc.w	32*13,32*7				; StartPoint
	dc.w	19					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	29					; Diamant
	dc.l	Color5					; ColorTable

	DC.B	00,GH,ST,00,NB,DI,00,00,00,00,00,TO,00
	DC.B	00,00,ST,00,ST,00,00,00,00,DI,00,TO,00
	DC.B	00,EI,ST,00,ST,00,00,00,00,00,00,TO,00
	DC.B	00,00,ST,00,ST,00,00,00,00,00,00,TO,00
	DC.B	00,00,ST,00,ST,00,00,00,BO,00,00,TO,00
	DC.B	00,00,ST,00,ST,00,00,00,00,00,00,TO,DI
	DC.B	00,00,ST,00,ST,00,TN,00,00,00,00,TO,00
	DC.B	00,00,NB,00,ST,00,00,00,00,00,KE,TO,AU
	dc.w	32*2,32*1				; GhostHouse (X/Y)
	dc.w	167,286					; MonsterDelay1,2
	dc.w	32*2,32*2				; StartPoint
	dc.w	36					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	6					; Diamant
	dc.l	Color36					; ColorTable

	DC.B	00,00,00,00,00,00,GH,00,00,00,00,00,00
	DC.B	00,LA,NB,NB,NB,DI,NB,NB,NB,NB,NB,LA,00
	DC.B	00,NB,00,00,00,00,00,00,00,00,00,NB,00
	DC.B	00,NB,00,TO,TO,TO,DI,TO,TO,TO,00,NB,00
	DC.B	00,NB,00,TO,TO,TO,DI,TO,TO,TO,00,NB,00
	DC.B	00,NB,00,00,00,00,00,00,00,00,00,NB,00
	DC.B	00,LA,NB,NB,NB,NB,NB,NB,NB,NB,NB,LA,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*1				; GhostHouse (X/Y)
	dc.w	343,233					; MonsterDelay1,2
	dc.w	32*7,32*8				; StartPoint
	dc.w	47					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	6					; Diamant
	dc.l	Color47					; ColorTable

	DC.B	EI,00,ST,00,AU,00,00,DI,00,00,00,00,GH
	DC.B	00,00,00,ST,00,00,00,00,00,00,00,00,00
	DC.B	00,00,NB,00,ST,00,00,00,TO,00,00,00,00
	DC.B	00,00,00,00,00,ST,00,ST,00,ST,00,00,00
	DC.B	00,DI,00,NB,00,00,TO,00,00,00,ST,00,00
	DC.B	00,00,00,00,NB,00,00,00,NB,00,NB,ST,00
	DC.B	00,00,NB,DI,00,00,NB,00,NB,00,00,00,ST
	DC.B	BO,00,00,00,NB,00,00,00,BO,NB,00,NB,00
	dc.w	32*13,32*1				; GhostHouse (X/Y)
	dc.w	111,234					; MonsterDelay1,2
	dc.w	32*1,32*8				; StartPoint
	dc.w	33					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	7					; Diamant
	dc.l	Color6					; ColorTable

	DC.B	NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB,NB
	DC.B	GH,NB,NB,NB,NB,NB,NB,NB,00,NB,NB,NB,NB
	DC.B	00,NB,NB,NB,NB,NB,NB,00,00,00,NB,NB,00
	DC.B	00,00,NB,00,NB,NB,00,NB,00,00,NB,00,00
	DC.B	00,00,DI,00,NB,00,00,00,00,00,DI,00,00
	DC.B	00,NB,00,TN,DI,00,00,00,NB,00,00,00,00
	DC.B	00,00,00,NB,00,00,00,NB,00,00,00,00,00
	DC.B	KE,NB,00,00,00,00,00,BO,00,00,00,00,00
	dc.w	32*1,32*2				; GhostHouse (X/Y)
	dc.w	123,234					; MonsterDelay1,2
	dc.w	32*13,32*8				; StartPoint
	dc.w	49					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	24					; Diamant
	dc.l	Color49					; ColorTable

	DC.B	00,00,00,00,00,00,GH,00,00,00,00,00,00
	DC.B	00,00,00,00,00,LA,00,LA,00,00,00,00,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,NB,00,NB,00,NB,DI,NB,00,NB,00,NB,00
	DC.B	00,ST,NB,DI,NB,00,NB,00,NB,DI,NB,ST,00
	DC.B	00,00,ST,TO,TO,TO,TO,TO,TO,TO,ST,00,00
	DC.B	00,00,00,ST,ST,ST,ST,ST,ST,ST,00,00,00
	DC.B	00,00,00,00,00,00,BO,00,00,00,00,00,00
	dc.w	32*7,32*1				; GhostHouse (X/Y)
	dc.w	231,133					; MonsterDelay1,2
	dc.w	32*7,32*2				; StartPoint
	dc.w	52					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	8					; Diamant
	dc.l	Color52					; ColorTable

	DC.B	GH,TO,00,00,00,TO,00,00,00,00,00,00,00
	DC.B	00,TO,00,TO,00,TO,00,TO,TO,TO,TO,00,00
	DC.B	00,TO,00,TO,00,TO,00,TO,00,DI,TO,00,00
	DC.B	00,TO,00,TO,00,TO,00,TO,00,00,TO,00,00
	DC.B	00,TO,00,TO,00,TO,00,TO,TO,00,TO,00,00
	DC.B	00,TO,00,TO,00,TO,00,00,LA,DI,TO,00,00
	DC.B	00,TO,00,TO,00,TO,TO,TO,TO,TO,TO,00,00
	DC.B	00,DI,00,TO,00,00,00,00,00,00,00,00,00
	dc.w	32*1,32*1				; GhostHouse (X/Y)
	dc.w	999,888					; MonsterDelay1,2
	dc.w	32*1,32*2				; StartPoint
	dc.w	11					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	8					; Diamant
	dc.l	Color2					; ColorTable

	DC.B	00,DI,00,TO,00,00,00,00,00,00,00,00,00
	DC.B	EI,00,00,TO,00,00,00,00,00,00,00,00,00
	DC.B	00,00,DI,TO,00,00,00,00,00,00,00,00,00
	DC.B	BO,00,00,TO,00,00,00,00,00,00,00,00,00
	DC.B	00,LA,DI,TO,00,00,00,00,00,00,00,00,00
	DC.B	00,00,00,TO,00,00,00,00,00,00,00,00,00
	DC.B	TO,TO,TO,GH,TO,TO,TO,TO,TO,TO,TO,TO,TO
	DC.B	AU,00,00,TO,00,00,00,00,00,00,00,00,00
	dc.w	32*4,32*7				; GhostHouse (X/Y)
	dc.w	253,321					; MonsterDelay1,2
	dc.w	32*1,32*1				; StartPoint
	dc.w	40					; Hintergrund
	dc.w	15					; Unzerstoerbar
	dc.w	26					; Diamant
	dc.l	Color40					; ColorTable

	DC.B	00,00,BO,00,00,00,00,00,00,00,00,00,00
	DC.B	00,NB,NB,NB,NB,00,DI,00,NB,NB,NB,NB,00
	DC.B	00,TO,NB,NB,TO,00,GH,00,TO,NB,NB,TO,00
	DC.B	00,TO,NB,NB,TO,BO,LA,00,TO,NB,NB,TO,00
	DC.B	00,TO,NB,NB,TO,00,DI,BO,TO,NB,NB,TO,00
	DC.B	00,TO,NB,NB,TO,00,00,00,TO,NB,NB,TO,00
	DC.B	00,NB,NB,NB,NB,00,DI,00,NB,NB,NB,NB,00
	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	dc.w	32*7,32*3				; GhostHouse (X/Y)
	dc.w	243,345					; MonsterDelay1,2
	dc.w	32*7,32*6				; StartPoint
	dc.w	43					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	29					; Diamant
	dc.l	Color43					; ColorTable

	
	DC.B	ST,00,NB,00,NB,00,00,00,NB,00,00,TO,ST
	DC.B	TO,ST,00,00,00,NB,00,BO,00,TO,TO,ST,ST
	DC.B	TO,TO,ST,00,NB,00,DI,00,TO,ST,ST,ST,ST
	DC.B	TO,ST,DI,00,00,NB,00,00,00,TO,ST,ST,ST
	DC.B	TO,TO,ST,ST,00,00,TN,NB,00,TO,ST,ST,ST
	DC.B	TO,TO,TO,TO,ST,DI,NB,00,TO,ST,ST,ST,ST
	DC.B	TO,TO,ST,ST,00,NB,00,00,00,TO,ST,ST,ST
	DC.B	TO,ST,GH,00,00,00,00,NB,00,00,ST,ST,ST
	dc.w	32*3,32*8				; GhostHouse (X/Y)
	dc.w	145,178					; MonsterDelay1,2
	dc.w	32*10,32*8				; StartPoint
	dc.w	14					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	8					; Diamant
	dc.l	Color2					; ColorTable

	DC.B	00,00,00,00,00,00,00,00,00,00,00,00,00
	DC.B	00,NB,NB,TO,NB,NB,NB,TO,NB,NB,NB,TO,00
	DC.B	00,TO,NB,NB,NB,TO,NB,NB,NB,TO,NB,DI,00
	DC.B	00,NB,NB,TO,NB,DI,NB,TO,NB,NB,NB,TO,00
	DC.B	00,TO,NB,NB,NB,TO,NB,NB,NB,TO,NB,NB,00
	DC.B	00,DI,NB,TO,NB,NB,NB,TO,NB,NB,NB,TO,00
	DC.B	00,TO,NB,NB,NB,TO,NB,NB,NB,TO,NB,NB,00
	DC.B	00,00,00,00,00,00,GH,00,00,00,00,00,00
	dc.w	32*7,32*8				; GhostHouse (X/Y)
	dc.w	234,123					; MonsterDelay1,2
	dc.w	32*7,32*1				; StartPoint
	dc.w	38					; Hintergrund
	dc.w	3					; Unzerstoerbar
	dc.w	24					; Diamant
	dc.l	Color38					; ColorTable
