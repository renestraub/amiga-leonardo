
	Include	"h:BobComs.i"

	XDEF	SetAnim,MoveBob,SetBob,AskBob,AddBob,RemBob
	XDEF	DrawSaveBuffer,DrawBobs
	XREF	BitmStr1,BitmStr2,SpeedFlag,FlipFlag,AllocMem,FreeMem
	XDEF	AnzBob,BobList
	XDEF	PosX,PosY,MSpr1,MSpr2,MSpr3,MSpr4,GSpr1,GSpr2,GSpr3,GSpr4


	DClip:	EQU	340

	CSEG
;----------------------------------------------------------------------

BlitWait:
	move	#$8400,$96(A6)
BlitWaitLoop:
	btst	#6,2(A6)
	btst	#6,2(A6)
	bne	BlitWaitLoop
	move	#$0400,$96(A6)
	rts
;----------------------------------------------------------------------


SetAnim:			;a0=bob,a1=prg,d1=speed.
	move.l	a1,54(A0)	;prg setzen
	move	d1,48(A0)	;speed setzen
	move	d1,50(A0)	;counter setzen
	subq	#1,50(A0)
	clr	52(A0)		;offset loeschen
	move	(A1),20(A0)
	rts

;----------------------------------------------------------------------
				;a0=bob
MoveBob:			;bob relativ bewegen
	tst	SpeedFlag
	beq.s	NoDoubel
	add	d1,d1
	add	d2,d2
NoDoubel:
	add	d1,8(A0)	;x
	add	d2,10(A0)	;y
	rts

;----------------------------------------------------------------------

				;a0=bob
AskBob:				;bob koords holen
	move	8(A0),d1	;x
	move	10(A0),d2	;y
	rts

;----------------------------------------------------------------------

				;a0=bob
SetBob:				;bob setzen
	move	d1,8(A0)	;x
	move	d2,10(A0)	;y
	rts

;--------------------------------------------------------------


DrawSaveBuffer:				;BobHinterGrund rekonstruieren
	movem.l	d0-d7/a0-a6,-(Sp)
	lea	$dff000,a6		;Custom
	tst.l	BobList			;Bobs vorhanden ?
	beq.s	EndRecLoop		;nein ->
	lea	PriList2+1,a1		;PrioritätenListe
SaveBufferLoop:
	moveq	#0,d0
	move.b	(a1)+,d0		;BobNummer holen
	cmp.b	#-1,d0			;Ende ?
	beq.s	EndRecLoop		;ja ->
	lea	BobPointerList,a0	;Zeiger auf Bobs
	lsl	#2,d0			;BobNummer * 4
	move.l	(A0,d0.w),a0		;BobPointer holen
	bsr.s	BobReconst		;Hintergrund rekonstr.
	bra.s	SaveBufferLoop		;loop ->
EndRecLoop:
	movem.l	(SP)+,d0-d7/a0-a6
	rts

;belegung flags 88 : 0 reconst/1 funfte bitmap/2 zeichnen/3 maske /
;		     7 bob sperren
	
BobReconst:
	move.l	a1,-(SP)
; -C5- Erweiterung fuer Sprites
	btst	#0,89(A0)		;SpriteFlag
	bne	EndReconst		;-> keinen Buffer zeichnen
	btst	#7,88(A0)		;Bob gesperrt ?
	bne	EndReconst
	btst	#0,88(A0)		;muss rekonstuiert werden ?
	bne	EndReconst		;nein ->
	lea	BitmStr1,a2		;Zeiger auf 1. BitmStr.
	move.l	26(a0),a3		;Save Buffer 1
	move.l	a0,a5
	add	#12,a5			;OldXY 1
	tst	FlipFlag		;Flip Flag ?
	beq.s	NoFlip3			;nein ->
	lea	BitmStr2,a2		;sonst 2.BitStr.
	move.l	30(a0),a3		;Save Buffer 2
	addq	#4,a5			;OldXY 2
NoFlip3:
					;a0 Zeiger auf aktuelles Bob
					;a2 Zeiger auf Unsichtbare Bitmstr
					;a3 auf Save Buffer
					;a5 auf Old x,y
	move.l	(A5),d1			;Old X + y Koordinate
	cmp.l	#-1,d1			;Bob gezeichnet ?
	beq	EndReconst		;nein -> kein Hintergrund recons.
	move.l	d1,d0			;nach d0
	swap	d0
	ext.l	d0			;X Koordinate
	ext.l	d1			;Y Koordinate
	lsr	#3,d0			;X/8
	bclr	#0,d0			;abrunden auf gerade Zahl
	mulu	(a2),d1			;Y * Breite des Bildes
	add.l	d1,d0			;X und Y addieren = Offset
	moveq	#0,d1
	move.b	5(a2),d1		;Anzahl Bitmaps
	subq	#1,d1			;fuer dbf
	addq	#8,a2			;Zeiger auf Bitmaps


;Abwaerts Clipping
	movem.l	d0-d6/a0-a6,-(SP)
	move	6(A0),d0		;Hoehe des Bobs
	move	2(A5),d1		;momentane y pos
	move	#DClip,d2		;Begrenzung unten
	move	d0,d3
	add	d0,d1			;untere begrenzung des bobs
	sub	d1,d2			;muss geklippt werden ?
	bpl	NoDownClip3
	move	#DClip,d3
	sub	2(A5),d3
	bpl	NoDownClip3
	clr	d3
NoDownClip3:
	move	22(A0),d0
	and	#%111111,d0
	lsl	#6,d3
	or	d3,d0
	move	d0,d7
	movem.l	(SP)+,d0-d6/a0-a6

BlitWait2:
	bsr	BlitWait

	move.l	(A2)+,d3		;Zeiger auf Bitmap
	add.l	d0,d3			;+Offset
	move.l	d3,$54(a6)		;Ziel D
	move.l	a3,$50(a6)		;Quelle A
	clr	$42(A6)			;BltCon1
	move	#$9f0,$40(A6)		;BltCon0 (A=D)
	move.l	#-1,$44(A6)		;Mask
	clr	$64(A6)			;Modulo A
	move	24(a0),$66(a6)		;Modulo D
	clr.l	d3
	move	d7,d6
	and	#~%111111,d6
	tst	d6
	beq	NoCBlit3
	move	d7,$58(A6)		;BltSize (Blitter starten)
NoCBlit3:
	move	6(a0),d3		;BobHöhe
	lsl.l	#1,d3			;*2
	add.l	36(A0),a3		;Länge einer BobPlane addieren
	add.l	d3,a3			;+rechter leerer Rand
	dbf	d1,BlitWait2		;nächste Plane
BlitWait4:
	bsr	BlitWait
EndReconst:
	move.l	(SP)+,a1
	rts				;Ende!
	
DrawBobs:
	movem.l	d0-d7/a0-a6,-(SP)
	tst.l	BobList			;hat es Bobs ?
	beq.L	EndDrawBobs		;nein ->

	bsr	MakePriList		;Prioritätenliste erstellen
	bsr	SortPriList		;und sortieren
	lea	$dff000,a6
	lea	PriList2+1,a1
SearchMin:
	cmp.b	#-1,(A1)+		;ende der Pri-List
	bne.s	SearchMin		;suchen
	subq	#1,a1
SaveLoop:
	moveq	#0,d0
	move.b	-(A1),d0		;BobNummer holen
	cmp.b	#-1,d0
	beq.s	EndSaveBuf
	lsl.w	#2,d0			;*4
	lea	BobPointerList,a0
	move.l	(A0,d0.w),a0		;entsprechende Zeiger holen

	bsr.s	BufDraw			;Hintergrund retten
	bra.s	SaveLoop		;loop ->

EndSaveBuf:
	lea	PriList2+1,a1
SearchMin2:
	cmp.b	#-1,(A1)+		;letzten Eintrag
	bne.s	SearchMin2		;suchen
	subq	#1,a1
DrawBobLoop:
	moveq	#0,d0
	move.b	-(A1),d0		;BobNummer holen
	cmp.b	#-1,d0			;wenn letztes -> exit
	beq.s	EndDrawBobs
	lsl	#2,d0			;BobNr. * 4
	lea	BobPointerList,a0	;entsprechenden
	move.l	(a0,d0.w),a0		;Zeiger holen
	bsr	DrawBob			;Bob zeichnen
	bra.s	DrawBobLoop

EndDrawBobs:
	movem.l	(a7)+,d0-d7/a0-a6
	rts


BufDraw:				;HinterGrund retten!
	move.l	a1,-(SP)
	move	10(A0),102(A0)
	btst	#7,88(a0)		;bob gesperrt ?
	bne	NoAnimate2
	btst	#0,89(A0)		;SpriteFlag
	bne	NoAnimate2		;-> keinen Buffer retten
	btst	#0,88(A0)		;rekonstruieren ?
	bne	NoAnimate2
	lea	12(A0),a5		;Old X,Y 1
	tst	FlipFlag		;FlipFlag ?
	beq.s	NoAddO			;nein ->
	addq	#4,a5			;Old X,Y 2
NoAddO:
	move.l	#-1,(A5)		;OldX,Y löschen
	cmp	#Invisible,20(A0)	;Bob zeichnen ?
	beq	NoAnimate2		;nein ->
	move	8(A0),d0		;wenn x oder y
	bpl	XKoordOk		;Koordinate
	clr	8(A0)			;in Negativem Breich
	tst.l	58(A0)			;dann x oder y Koordinate
	bne.s	XBad			;auf null setzen
	tst.l	76(A0)
	beq	XKoordOk
XBad:	bsr	RemBob			;Wenn ein 'Move Prg'
XKoordOk:				;gesetzt ist, Bob removen.
	move	10(A0),d0		;(Dragon Slayer spezifisch)
	bpl	YKoordOk
	clr	10(A0)
	tst.l	58(A0)
	beq.s	YKoordOk
	;bsr	RemBob
YKoordOk:
	move.l	8(a0),(A5)		;Aktuell x,y Koord. in OldX,Y

	moveq	#0,d0
	move	20(a0),d0		;BobImageNummer holen
	lsl	#2,d0			;*4
	move.l	72(A0),a1		;BobImageList

	move.l	(a1,d0.l),a1		;a1 = zeiger auf BobGrafik
	move.l	a1,a4
	add.l	40(A0),a4		;a4 Zeiger auf Maske

	lea	BitmStr1,a2
	move.l	26(A0),a3		;a3 = save1
	tst	FlipFlag		;Flip Flag ?
	beq.s	NoFlip2			;nein ->
	lea	BitmStr2,a2
	move.l	30(A0),a3		;Save 2

;a1 Zeiger auf Bob, a2 Zeiger auf unsichtbare Bitmapstr
;a3 Zeiger auf Hintergrundbuffer, a4 Zeiger auf Maske

NoFlip2:
	clr.l	d0
	move	8(a0),d0		;x Koord.
	lsr	#3,d0			;X/8

	move	10(A0),d1		;YKoord
	mulu	(A2),d1			;Y*BildBreite
	add	d1,d0			;d0 = Offset auf Dest.

	movem.l	a2-a3,-(a7)
	moveq	#0,d7
	move.b	5(A2),d7		;Anzahl Bitmaps
	subq	#1,d7			;fuer dbf
	addq	#8,a2			;Zeiger auf Maps

BlitWait3:
	bsr	BlitWait
	move.l	(A2)+,d3		;Zeiger auf Dest.
	add.l	d0,d3			;+Offset
	move.l	a3,$54(a6)		;Dest D
	move.l	d3,$50(a6)		;Quelle A
	clr	$42(a6)			;BltCon1
	move	#$9f0,$40(A6)		;BltCon0 (A=D)
	move	24(a0),$64(A6)		;Modulo Source
	clr	$66(a6)			;Modulo D
	move.l	#-1,$44(a6)		;Mask
	move	22(a0),$58(a6)		;BltSize
	moveq	#0,d3
	move	6(A0),d3		;BobHoehe
	lsl.l	#1,d3			;*2
	add.l	36(A0),a3		;nachste Plane
	add	d3,a3			;+rechter Rand
	dbf	d7,BlitWait3
	movem.l	(a7)+,a2-a3
NoAnimate2:
	move.l	(SP)+,a1
	rts				;Ende


;Jetzt das Bob mit Maske in das Bild kopiert

DrawBob:
	move.l	a1,-(SP)
	tst.b	45(A0)		;removing ?
	beq.L	NoRemoveBob	;wenn nicht -> Bob zeichnen

	subq.b	#1,45(A0)	;Zaehler erniedrigen
	bne.s	EndRemove	;wenn nicht 0 -> ende
	subq	#1,AnzBob
	move.l	BobList,a2	;Zeiger auf erstes Bob
	cmp.l	a2,a0		;sind WIR erstes Bob ?
	bne.s	NoFirstRemove	;nein ->
	move.l	(A0),BobList	;zeiger auf next bob = 1.Bob
	bra.s	BobRemoved
NoFirstRemove:
	move.l	a2,a3
	move.l	(A2),a2		;Nächstes Bob in der Liste
	move.l	a2,d0		;wenn nicht gefunden
	beq.s	EndRemove	 ;-> exit (sollte nicht sein)
	cmp.l	a2,a0		;haben wir uns gefunden ?
	bne.s	NoFirstRemove	;nein -> loop
	move.l	(A0),(a3)	;zeiger auf unser nächstes Bob
				;in vorhergehendes Bob eintragen

BobRemoved:			;Bob ist nun aus der Liste
				;enfernt

	lea	BobPointerList,a2
	moveq	#100,d7
BobRemoveFindLoop:
	cmp.l	(A2)+,a0
	beq.s	RemoveBobFound
	dbf	d7,BobRemoveFindLoop
	bra.s	RemoveBobNotFound
RemoveBobFound:
	moveq	#100,d7
MoveBobPointerList:
	move.l	(A2),-4(A2)
	addq	#4,a2
	dbf	d7,MoveBobPointerList

RemoveBobNotFound:
	move.l	72(A0),a1	;ImageList
	bsr	FreeMem
	move.l	26(A0),a1	;Save 1
	bsr	FreeMem
	tst.b	34(A0)
	beq.s	NoFreeMask
	move.l	40(A0),a1
NoFreeMask:
	bsr	FreeMem
	move.l	a0,a1		;Bob
	bsr	FreeMem
	bsr	MakePriList
	bsr	SortPriList
EndRemove:
	move.l	(SP)+,a1
	rts

NoRemoveBob:
	btst	#7,88(A0)
	bne	EndRelMove		;ja ->

	btst	#2,88(A0)		;Bob zeichnen
	bne	NoAnimate		;Nein ->
	btst	#5,88(A0)
	beq	NoCFlag
	move.b	21(A0),d0		;aktuelles bild
	cmp.b	35(A0),d0		;=altes bild ?
	beq	BobDrawed		;ja ->
NoCFlag:
	cmp	#Invisible,20(A0)  	;Bob zeichnen ?
	beq.L	NoAnimate		;nein ->

	lea	12(A0),a5		;OldX,Y 1
	tst	FlipFlag		;FlipFlag ?
	beq.s	NoAddO2			;ja ->
	addq	#4,a5			;OldX,Y 2
NoAddO2:
	move.l	8(a0),(A5)		;aktuelle Koord. = alte Koord.

	moveq	#0,d0
	move	20(a0),d0		;BobImageNummer holen
	lsl	#2,d0			;*4
	move.l	72(A0),a1		;BobList
	move.l	(a1,d0.l),a1		;a1 = zeiger auf BobGrafik

	btst	#0,89(A0)		;SpriteFlag
	bne	DrawSpr			;Image ins Sprite kopieren

	tst.b	34(a0)			;MaskFlag
	bne.s	NoMakeOffset
	move.l	a1,a4
	add.l	84(A0),a4
	move.l	a4,40(A0)

NoMakeOffset:
	move.l	40(A0),a4		;Zeiger auf Maske

	lea	BitmStr1,a2
	move.l	26(A0),a3		;a3 = Save1
	tst	FlipFlag		;FlipFlag ?
	beq.s	NoFlip22
	lea	BitmStr2,a2
	move.l	30(A0),a3		;Save 2

;a1 Zeiger auf BobGrafik, a2 Zeiger auf unsichtbare Bitmapstr.
;a3 Zeiger auf Hintergrundbuffer, a4 Zeiger auf Maske

NoFlip22:
	tst.b	34(a0)
	beq.L	NoMakeMask
	btst	#3,88(A0)		;maske frisch bilden ?
	bne	NoMakeMask
	btst	#6,88(a0)		;wird maske gebraucht ?
	bne	NoMakeMask		;nein ->

	movem.l	d0-d7/a0-a6,-(SP)
	moveq	#0,d0
	move	6(A0),d0		;Bobhoehe
	moveq	#6,d1
	lsl	d1,d0
	move	4(A0),d1		;BobBreite
	add	#15,d1
	and	#~15,d1
	lsr	#4,d1
	or	d1,d0
	move	22(A0),d0
	move.l	a4,a5			;Zeiger auf Maske (D)
	move.l	36(A0),d7		;Länge einer Plane
	move.l	a1,a2			;1.Map
	add.l	d7,a2			;2.Map
	move.l	a2,a3
	add.l	d7,a3			;3.Map
	move.l	a3,a4
	add.l	d7,a4			;4.Map
	move.l  a4,d4
	add.l	d7,d4                   ;5.Map
MaskBlitWait1:
	bsr	BlitWait

	move.l	a1,$50(A6)		;Source A	; 1.Map
	move.l	a2,$4c(a6)		;Source B       ; 2.Map
	move.l	a3,$48(A6)		;Source C       ; 3.Map
	move.l	a5,$54(A6)		;Dest D
	clr	$42(A6)			;BltCon1
	move	#$ffe,$40(A6)		;BltCon0
	clr.l	$60(A6)			;Modulo c+b
	clr.l	$64(A6)			;Modulo a+d
	move.l	#-1,$44(a6)		;Mask
	move	d0,$58(A6)		;BltSize
MaskBlitWait2:
	bsr	BlitWait

	move.l	a4,$50(A6)		;Source A       ; 4.Map
	move.l	d4,$4c(a6)		;Source B       ; 5.Map
        move.l	a5,$48(A6)		;Source C	; Maske nochmal
	move.l	a5,$54(a6)		;Dest D
	move	#$ffe,$40(A6)		;BltCon0
	move	d0,$58(A6)		;BltSize
NoMakeMask4:
	movem.l	(SP)+,d0-d7/a0-a6

NoMakeMask:
;Abwaerts Clipping
	movem.l	d0-d6/a0-a6,-(SP)
	move	6(A0),d0		;Hoehe des Bobs
	move	10(A0),d1		;momentane y pos
	move	#DClip,d2		;Begrenzung unten
	move	d0,d3
	add	d0,d1			;untere begrenzung des bobs
	sub	d1,d2			;muss geklippt werden ?
	bpl	NoDownClip
	move	#DClip,d3
	sub	10(A0),d3
	bpl	NoDownClip
	clr	d3
NoDownClip:
	move	22(A0),d0
	and	#%111111,d0
	lsl	#6,d3
	or	d3,d0
	move	d0,d7
	movem.l	(SP)+,d0-d6/a0-a6
	move	d7,d6			;geclipptes BltSize

	clr.l	d0
	move	8(a0),d0		;X Koord.
	move	d0,d2			;nach d2
	and	#15,d2			;Shift heraus'anden'
	moveq	#12,d3			;12 Bits nach links (für BltCon0)
	lsl	d3,d2			;d2 = shift
	lsr	#3,d0			;x/8
	move	10(A0),d1		;Y Koord.
	mulu	(A2),d1			;Y*BildBreite
	add	d1,d0			;d0 = Offset auf Dest.

	clr	d7
	move.b	5(A2),d7		;Anzahl Bitmaps
	subq	#1,d7			;für dbf
	addq	#8,a2			;Zeiger auf BitMaps
BlitWait12:
	bsr	BlitWait
	move.l	(A2)+,a3		;Zeiger auf Bitmap
;	btst	#0,46(a0)		;3PlaneFlag?
;	beq.s	SamePlanes		;nein ->
;	cmp.b	#1,d7			;Plane4 ?
;	beq.s	DrawNOTMask		;ja ->
SamePlanes:
;	tst.b	d7
;	bne.s	NoLast
;	btst	#1,88(A0)		;5. bitmap loeschen ?
;	bne	ClearFive		;ja ->
;	move.l	a4,a1
NoLast:
	add.l	d0,a3
	move	#-1,$74(A6)		;Data A
	move.l	a3,$48(a6)		;Source c (background)
	move.l	a1,$4c(A6)		;Source b (data)
	move.l	a4,$50(a6)		;Source a (Maske)
	move.l	a3,$54(a6)		;Dest C
	move	d2,$42(a6)		;BltCon1
	move	#$fca,d3
	btst	#6,88(A0)		;Maske benutzen
	beq	1$			;ja ->
	move	#$7ca,d3
1$:
	or	d2,d3
	move	d3,$40(a6)		;BltCon0

	move	24(a0),$60(a6)		;Modulo c
	move	24(a0),$66(A6)
					;Modulo Dest
	clr	$64(a6)			;Modulo
	clr	$62(A6)			;Modulo
	move	#-2,$64(A6)		;Modulo
	move	#-2,$62(A6)		;Modulo
	move.l	#$ffff0000,$44(a6)	;Mask
	move	d6,d5
	and	#~%111111,d5
	tst	d5
	beq	NoCBlit1
	move	d6,$58(A6)		;BltSize
NoCBlit1:
	add.l	36(A0),a1		;nächste Plane
	dbf	d7,BlitWait12
	bra.s	BobDrawed

ClearFive:


;Wenn Bob 3 und Background 4 Planes hat muss in die 4. Plane die
;'genottete' Maske!
;wenn das bob die unteren 16 farben benutzt genottete maske in die 5.Pl.
DrawNOTMask:
	add.l	d0,a3
	move	#-1,$74(a6)
	move.l	a3,$4c(a6)		;SourceB
	move.l	a3,$54(A6)		;DestD
	move.l	a4,$50(A6)		;Source A
	move	24(a0),$62(a6)		;ModuloB
	move	24(A0),$66(a6)		;ModuloD
	move	#-2,$64(A6)		;ModuloA

	clr	$42(A6)
	move	#$d0c,d3		;Use D+A+B/Minterm=AB
	btst	#6,88(A0)		;maske benutzen ?
	beq	1$
	move	#$50c,d3
1$:
	or	d2,d3			;+Shift
	move	d3,$40(A6)		;BltCon0
	move.l	#$ffff0000,$44(a6)	;MaskA
	move	d6,d5
	and	#~%111111,d5
	tst	d5
	beq	NoCBlit2
	move	d6,$58(A6)		;BltSize
NoCBlit2:
	dbf	d7,BlitWait12
	bra	BobDrawed

;SpriteVerwaltung
;A1=Zeiger auf Image

DrawSpr:	
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	104(A0),a2		;Zeiger auf Sprites
	move.l	(A2)+,a3		;Sprite1
	move.l	(A2)+,a4		;Sprite2
	move.l	(A2)+,a5		;Sprite3
	move.l	(A2)+,a6		;Sprite4

	moveq	#31,d7	
	moveq	#4,d4
	add.l	d4,a3
	add.l	d4,a4
	add.l	d4,a5
	add.l	d4,a6

CopyOneLine:
	move	(A1),(A3)		;(1.Word/2.Plane) -> (2.Sprite/2.Plane)
	move	128(A1),2(A3)		;(1.Word/3.Plane) -> (2.Sprite/1.Plane)
	move	256(A1),(A4)		;(1.Word/4.Plane) -> (1.Sprite/2.Plane)
	move	384(A1),2(A4)		;(1.Word/5.Plane) -> (1.Sprite/1.Plane)
	move	2(A1),(A5)		;(2.Word/2.Plane) -> (4.Sprite/2.Plane)
	move	130(A1),2(A5)		;(2.Word/3.Plane) -> (4.Sprite/1.Plane)
	move	258(A1),(A6)		;(2.Word/4.Plane) -> (3.Sprite/2.Plane)
	move	386(A1),2(A6)		;(2.Word/5.Plane) -> (3.Sprite/1.Plane)
	add.l	d4,a3
	add.l	d4,a4
	add.l	d4,a5
	add.l	d4,a6
	add.l	d4,a1
	dbf	d7,CopyOneLine

	moveq	#0,d6
	sub	PosX,d6		; X
	moveq	#0,d7
	sub	PosY,d7		; Y
	add	#$7f+16,d6
	add	#$20,d7

	add	8(A0),d6
	add	10(A0),d7
	move	d7,d5
	add	#31,d5

	move.l	104(A0),a2		;Zeiger auf Sprites
	move.l	(A2)+,a3		;Sprite1
	move.l	(A2)+,a4		;Sprite2
	move.l	(A2)+,a5		;Sprite3
	move.l	(A2)+,a6		;Sprite4

	move.l	a3,a1
	move	d6,d0
	move	d7,d1
	move	d5,d2
	bsr	SetSpr

	move.l	a4,a1
	move	d6,d0
	move	d7,d1
	move	d5,d2
	bsr	SetSpr

	add	#16,d6
	move.l	a5,a1
	move	d6,d0
	move	d7,d1
	move	d5,d2
	bsr	SetSpr

	move.l	a6,a1
	move	d6,d0
	move	d7,d1
	move	d5,d2
	bsr	SetSpr
	movem.l	(sp)+,d0-d7/a0-a6

;nun folgen Animations + Bewegungsroutinen

BobDrawed:
	move.b	21(a0),35(A0)		;old img = akt. image
	moveq	#0,d7
NoAnimate:
	addq	#1,50(A0)		;Speedcounter
	move	50(A0),d0
	cmp	48(a0),d0		;Limite erreicht?
	beq.s	OkAnim			;ja -> animieren
	tst	SpeedFlag		;SpeedFlag ?
	beq.L	NoAnim			;nein ->
	addq	#1,50(A0)		;Speedcounter
	move	50(A0),d0		;nochmals probieren
	cmp	48(a0),d0		;Limite erreicht?
	beq.s	OkAnim			;ja ->
	bra	NoAnim			;nicht animieren

OkAnim:
	clr	50(A0)			;Zähler löschen
AnimLoop:
	tst.l	54(A0)			;Animation zugelassen ?
	beq	NoAnim			;nein ->
	move.l	54(A0),a1		;AniPrg.
	move	52(a0),d0		;Offset
	bclr	#15,d0
	add	d0,a1			;Offset adieeren zu PrgStart
	move	(A1),d0			;Neue BobImageNummer holen
	cmp	#PrgEnde,d0		;Ende ?
	bne.s	NoEndAnim		;nein ->
	bset	#7,52(A0)		;Flag setzen
	bra	NoAnim
NoEndAnim:
	cmp	#Priority,d0		;Priorität andern ?
	bne.s	NoSetPrio		;nein ->
	move	2(A1),d1		;neue Priorität holen
	move.b	d1,44(A0)		;In Bob eintragen
	add	#4,52(A0)		;Anim PC erhöhen
	bra.s	AnimLoop		;nächstes Kommando hoolen

NoSetPrio:
	cmp	#PrgLoop,d0		;Ende aber Loop ?
	bne.s	NoAnimLoop		;nein ->
	clr	52(A0)			;Anim PC auf 0
	bra	AnimLoop		;1 Kommando holen
NoAnimLoop:
	cmp	#PrgRemove,d0		;Bob removen ?
	bne.s	NoPrgRemove		;nein ->
	move.b	#2,45(A0)		;remove!
	clr	52(A0)
	bra.s	NoAnim

NoPrgRemove:
	cmp	#PrgJump,d0		;Programm ausführen ?
	bne.s	LetsAnim		;nein ->
	movem.l	d0-d7/a0-a6,-(SP)	;Register retten
	move.l	2(a1),a4		;Adresse holen
	jsr	(a4)			;anspringen
	movem.l	(SP)+,d0-d7/a0-a6	;Register holen
	addq	#6,52(A0)		;Anim PC erhöhen
	bra.s	AnimLoop		;nächstes Kommando holen

LetsAnim:				;Wenn kein Kommand0
	move	d0,20(A0)		;BobImageNummer eintragen
	addq	#2,52(a0)		;Anim PC erhoehen

NoAnim:
	tst.l	58(A0)			;MovePrg ?
	beq	NoMove			;nein ->

	addq	#1,66(A0)		;Zähler erhöhen
	move	64(A0),d0		;Soll Wert
	cmp	66(A0),d0		;Geschwindigkeit?
	beq.s	DMoveIt			;nein ->
	tst	SpeedFlag		;SpeedFlag ?
	beq	NoMove			;nein ->
	addq	#1,66(A0)		;nochmals probieren
	move	64(A0),d0
	cmp	66(A0),d0		;Geschwindigkeit?
	bne	NoMove
DMoveIt:
	clr	66(A0)			;Zahler löschen
	tst	70(A0)			;Kommando Zahler = 0 ?
	bne.s	NoNextCommand		;nein ->
MoveIt:
	move	62(A0),d0		;MovePrg PC
	move.l	58(A0),a1		;Zeiger auf Tabelle
	addq	#4,62(a0)		;PC erhöhen
	move	(a1,d0.w),d1		;Anzahl Kommand

	cmp	#PrgLoop,d1		;Ende des Programms?
	bne.s	NoEndPrg		;nein ->
	clr	62(A0)			;Offset loeschen
	bra.L	NoMove			;Ende

NoEndPrg:
        cmp	#PrgEnde,d1

	cmp	#PrgRemove,d1		;Bob removen ?
	bne.s	NoRemove		;nein ->
	clr	62(A0)			;PC löschen
	move.b	#2,45(A0)		;Remove Flag setzen
	bra.L	NoMove			;Ende

NoRemove:
	cmp	#SetSpeed,d1		;Step setzen ?
	bne.s	NoSetSpeed		;nein ->
	clr	66(A0)			;
	move	2(a1,d0.w),d2		;Speed holen
	move.b	d2,47(A0)		;neu setzen
	bra.s	MoveIt			;nächstes Kommado holen

NoSetSpeed:
	cmp	#PrgJump,d1		;Prg ausführen ?
	bne.s	NoMoveJump		;nein ->
	movem.l	d0-d7/a0-a6,-(SP)
	move.l	2(A1,d0.w),a4		;Adresse holen
	jsr	(A4)			;Anspringen
	movem.l	(SP)+,d0-d7/a0-a6
	addq	#2,62(A0)		;PC erhöhen
	bra.s	MoveIt

NoMoveJump:				;Wenn kein Kommand0

	move	d1,70(A0)		;Neue Anzahl Kommandos
	move	2(A1,d0.w),68(A0)	;Neues Kommando

NoNextCommand:
	moveq	#0,d3
	move.b	47(A0),d3		;MoveStep

	subq	#1,70(A0)		;KommandoZaehler minus
	cmp	#1,64(A0)
	bne.s	NoMCor
	tst	SpeedFlag
	beq	NoMCor
	lsl	#1,d3
	tst	70(A0)
	beq.s	NoMCor
	subq	#1,70(A0)

NoMCor:
	move	68(A0),d0		;Aktuelles Kommando
	btst	#0,d0			;nach rechts ?
	beq.s	NoXadd
	add	d3,8(A0)
NoXadd:
	btst	#1,d0			;nach links ?
	beq.s	NoXsub
	sub	d3,8(A0)
NoXsub:
	btst	#2,d0			;nach unten ?
	beq.s	NoYadd
	add	d3,10(A0)
NoYadd:
	btst	#3,d0			;nach oben ?
	beq.s	NoYsub
	sub	d3,10(A0)
NoYsub:
NoMove:
EndRelMove:
	move.l	(SP)+,a1
	rts				;Ende !

InitBob:				;Bob initalisieren
	movem.l	d0-d3/a0-a1,-(A7)
BobInitLoop:
	lea	BitmStr1,a1
	move	(a1),d1			;BildBreite
	move	4(a0),d0		;BobBreite
	move	d0,d2
	lsr	#4,d0			;BobBreite/16
	and	#15,d2			;BobBreite
	tst	d2			;auf Words aufrunde
	beq.s	BobEven
	addq	#1,d0
BobEven:
	move.l	d0,d7
	moveq	#0,d2
	move	6(a0),d2		;BobHöhe
	moveq	#6,d3			;6 Bits nach
	lsl	d3,d2			;links schieben
	addq	#1,d0			;BobBreite + 1 Word
	or	d0,d2			;mit Höhe anden
	move	d2,22(a0)	 	;BltSize
	lsl	#1,d0		 	;Breite in Bytes
	sub	d0,d1			;BildBreite-BobBreite
	subq	#2,d0
	move	d1,24(a0)	 	;Modulo
	mulu 	6(a0),d0		;BobHöhe * BobBreite
	move.l	d0,36(a0)		;Länge einer Plane
	moveq	#0,d1
	move.b	5(A1),d1		;Anzahl Bitmaps
	mulu	d1,d0			;* Länge
	move.l	d0,84(a0)		;Offset auf Maske
	movem.l	(a7)+,d0-d3/a0-a1
	rts

	


 ;-----------------------------------------------------------------------

	CSEG

RemBob:					;Bob removen
	movem.l	a0/a1/d0,-(SP)
RemBobLoop:
	move.l	a0,d0
	beq.s	EndRemBob
	move.b	#4,45(A0)
	move.l	90(A0),a1		;Zeiger auf Bobdef
	subq.b	#1,46(A1)		;Counter erniedrigen
	tst.b	46(A1)			;schon im minus ?
	bpl	NoMinRem		;nein ->
	clr.b	46(A1)
NoMinRem:
	move.l	94(A0),a0
	bra	RemBobLoop
EndRemBob:
	movem.l	(SP)+,a0/a1/d0
	rts



;a1=str/d0=result
AddBob:
	movem.l	d1-d7/a0-a6,-(SP)
AddBobLoop:
	addq	#1,AnzBob
	moveq	#108,d0			;Speicher für neues
	bsr	AllocMem		;Bob reservieren
	addq.b	#1,46(a1)		;Counter erhoehen
	move.l	BobList,a0		;Zeiger auf alte Bobs
	move.l	a0,d1			;nock keine Bobs ?
	bne.s	OldBobsOk		;wenn doch ->
	move.l	d0,BobList		;sonst neues Bob = BobList
	move.l	d0,a0
	bra.s	CreateBob
OldBobsOk:
	tst.l	(A0)			;ist es letztes Bob in der Liste?
	beq.s	LastBobOk		;wenn ja ->
	move.l	(A0),a0			;zeiger auf nächstes Bob
	bra.s	OldBobsOk		;Loop ->
LastBobOk:
	move.l	d0,(A0)			;Zeiger auf neues Bob eintragen
	move.l	d0,a0

CreateBob:
	clr.l	(A0)			;NextBob
	move.l	(A1),4(A0)		;Breite,Hoehe
	move.l	4(A1),8(A0)		;x,y
	move.l	#-1,12(A0)
	move.l	12(A0),16(a0)

	clr.l	20(A0)			;imagenr,bltsize
	clr	24(A0)			;Modulo
	moveq	#0,d0
	move	4(A0),d0		;Breite
	move	d0,d2
	lsr	#4,d0			;/16
	and	#15,d2			;rest = 0 ?
	tst	d2
	beq.s	BobBreiteOk
	addq	#1,d0
BobBreiteOk:
	addq	#1,d0			;Breite=Breite+16
	lsl	#1,d0			;*2 = Breite in Bytes
	mulu	2(A1),d0		;*Hoehe
	mulu	#5,d0			;*5 Bitmaps
	move.l	d0,d3
	lsl.l	#1,d0
	bsr	AllocMem
	move.l	d0,26(A0)		;save1
	add.l	d3,d0
	move.l	d0,30(a0)		;save2
	move.b	45(A1),34(A0)		;MaskFlag
	clr.b	35(a0)			;fut
	clr.l	36(a0)			;PlaneLaenge
	clr.l	40(A0)			;Offset to Mask
	move.b	28(A1),44(A0)		;Priority
	clr.b	45(a0)			;RemCounter
	clr.b	46(A0)			;3PlaneFlag
	move.b	#1,47(A0)		;MoveStep
	clr.b	48(A0)			;Speed hi-byte
	move.b	29(a1),49(a0)		;Speed lo-byte
	clr.l	50(A0)
	move.l	8(A1),54(A0)
	move.l	12(A1),58(A0)
	clr.w	62(A0)
	move	#1,64(A0)		;MoveAnimSpeed
	clr	66(A0)
	clr.l	68(A0)
	move.b	60(A1),89(A0)		;SpriteFlag
	move.l	56(A1),104(A0)		;SpriteListPointer

	bsr	InitBob
	move.l	36(A0),d0		;Länge einer Plane
	tst.b	44(A1)			;3PlaneFlag
	beq.s	No3Plane
	bset	#0,46(A0)		;Flag in Bobstruktur
	sub.l	d0,40(A0)		;Offset to Mask korrigieren
	sub.l	d0,84(A0)
No3Plane:
	tst.b	34(A0)			;MaskFlag
	beq.s	NoAllocSave
	addq	#1,d7			;Breite in Words+1
	lsl	#1,d7
	ext.l	d7
	mulu	6(a0),d7		;Hoeh*Breite
	move.l	d7,d0
	bsr	AllocMem
	move.l	d0,40(a0)		;Zeiger auf Maske
NoAllocSave:
	moveq	#0,d0
	move	30(A1),d0		;Anzahl Anim.
	beq.s	NoAnims
	move	d0,d3
	subq	#1,d3
	lsl.l	#2,d0			;Speicher fuer Zeiger
	bsr	AllocMem		;reservieren
	move.l	d0,72(A0)		;Zeiger auf Tabelle
	move.l	d0,a2
	move.l	36(A0),d1		;Laenge einer Plane
	moveq	#6,d2
	tst.b	44(a1)			;3PlaneFlag ?
	beq.s	No3Plane2
	moveq	#6,d2
No3Plane2:
	tst.b	34(A0)			;MaskFlag
	beq.s	NoMaskList
	subq	#1,d2
NoMaskList:
	mulu	d2,d1			;5 Bitmaps+Maske
	move.l	16(A1),a3
MakePointerListLoop:
	move.l	a3,(A2)+
	add	d1,a3			;Laenge eines Bobs
	dbf	d3,MakePointerListLoop
NoAnims:
	clr.l	76(A0)			;RelMovePrg
	clr	80(a0)			;RelMoveOffset
	clr	82(A0)			;RelMoveFlags
	clr.b	88(A0)			;Flags
	move.l	a1,90(A0)		;Zeiger auf Bobdef
	clr.l	94(A0)
	lea	BobPointerList,a2
SearchNullBob:
	tst.l	(A2)+			;leeren Eintrag suchen
	bne.s	SearchNullBob
	move.l	a0,-4(A2)		;Bob in PointerListe
	move.l	a0,d0

	move.l	LastPart,a2
	move.l	a2,d1
	beq	FirstPart
	move.l	d0,94(a2)		;next pointer eintragen
FirstPart:
	move.l	a2,98(a0)		;last pointer eintragen

	tst.l	FirstBob
	bne	NoFirst
	move.l	d0,FirstBob
NoFirst:
	move.l	d0,LastPart
	move.l	48(A1),a1
	move.l	a1,d1
	bne	AddBobLoop

	movem.l	(Sp)+,d1-d7/a0-a6
	move.l	FirstBob,d0
	clr.l	FirstBob
	clr.l	LastPart
	clr.l	NextPart
	rts

	DSEG


FirstBob:
	dc.l	0
LastPart:
	dc.l	0

NextPart:
	dc.l	0



;Bobstruktur wie sie von 'AddBob()' erzeugt wird
;HeroBob:
;	dc.l	GeierBob	;Next Bob		0
;	dc.w	48,50		;Breite,Hoehe		4
;	dc.w	0,143		;New x,y Pos		8
;	dc.w	-1,-1		;Old x,y Pos1		12
;	dc.w	-1,-1		;Old x,y Pos2		16
;	dc.w	0		;BobImageNumber		20
;	dc.w	0		;BltSize		22
;	dc.w	0		;Modulo			24
;	dc.l	save1		;save1			26
;	dc.l	save2		;save2			30
;	dc.b	0		;MaskFlag		34
;	dc.b	0		;fut			35
;	dc.l	0		;Laenge	einer Plane	36
;	dc.l	0		;Pointer to Mask	40
;	dc.b	41		;Priority		44
;	dc.b	0		;RemCounter		45
;	dc.b	0		;3PlaneFlag		46
;	dc.b	1		;MoveStep		47
;	dc.w	1		;AnimSpeed		48	
;	dc.w	0		;SpeedCounter		50
;	dc.w	0		;AnimOffset		52
;	dc.l	0		;AnimProgramm		54
;	dc.l	0		;BewgungPrg		58
;	dc.w	0		;BewegungsOffset	62
;	dc.w	1		;Speed			64
;	dc.w	0		;SpeedCounter		66	
;	dc.w	0		;Aktuelles Komando	68
;	dc.w	0		;CommandCounter		70
;	dc.l	0		;BobList		72
;	dc.l	0		;RelMovePrg		76
;	dc.w	0		;RelMoveOffset		80
;	dc.w	0		;RelMoveFlags		82
;	dc.l	0		;Offset to Mask		84
;	dc.b	0		;ReconstFlags		88
;	dc.b	0		;fut			89
;	dc.l	0		;Zeiger auf Bobdef	90
;	dc.l	0		;next part		94
;	dc.l	0		;last part		98
;	dc.w	0		;ysave			102
;	dc.l	0		;SprListPointer		104
	
	CSEG


SortPriList:
	lea	PriList2,a3
	move.b	#-1,(A3)+
PriLoop:
	bsr.s	SearchNextPri
	cmp.b	#-1,d0
	beq.s	EndPri
	move.b	d1,(A3)+
	bra.s	PriLoop


EndPri:
	move.b	#-1,(A3)
	rts

SearchNextPri:
	lea	PriList,a0
NextPri:
	move.b	(A0)+,d0
	move.l	a0,a1
	subq	#1,a1
	tst.b	d0
	beq.s	NextPri
FirstPri:
	move.b	(A0)+,d1
	tst.b	d1
	beq.s	FirstPri
	cmp.b	#-1,d1
	beq.s	PriFound
	cmp.b	d0,d1
	bhi.s	Higher
	bra.s	FirstPri

Higher:
	move.l	a0,a1
	subq	#1,a1
	move.b	d1,d0
	bra.s	FirstPri
PriFound:
	clr.b	(A1)
	lea	PriList,a0
	sub.l	a0,a1
	move.l	a1,d1
	rts

MakePriList:
	move.l	BobList,a0
	lea	PriList,a1
MakeLoop:
	move.b	44(a0),(A1)+
	move.l	a0,a2
	move.l	(a0),a0
	cmp.l	#0,a0
	bne.s	MakeLoop
	move.b	#-1,(A1)+
	move.b	#-1,(A1)+
	move.b	#-1,(A1)+
	rts

SetSpr:	movem.l	d0-d2,-(sp)
	and.b	#%11111000,3(A1)

	btst	#0,d0
	beq.s	1$

	or.b	#1,3(A1)
1$:
	lsr	#1,d0
	move.b	d0,1(A1)

	cmp	#256,d1
	blo	2$

	sub.b	#256,d1
	or.b	#4,3(A1)
2$:
	move.b	d1,(A1)

	cmp	#256,d2
	blo	3$

	sub.b	#256,d2
	or.b	#2,3(A1)
3$:
	move.b	d2,2(A1)
	movem.l	(sp)+,d0-d2
	rts


	DSEG

PriList:
	ds.b	40,0
PriList2:
	dcb.b	40,-1
AnzBob:
	dc.w	0
BobList:
	dc.l	0
BobPointerList:
	ds.l	200,0

	

