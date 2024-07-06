
	XDEF	CreateAnim,MoveBase
	XDEF	Anim1

	Include	"h:bobcoms.i"

Enter:	MACRO
	move	#\3,d0
	subq	#1,d0
1$:
	move	#\1,(A1)+
	move	#\2,(A1)+
	dbf	d0,1$
	ENDM

CreateAnim:
	lea	MoveBase,a1
l0:	Enter	-1,0,96			; Reinlaufen
l1:	Enter	0,0,331			; Zig. anzuenden
l2:	Enter	-3,0,1			; Bobs verschoben
l3:	Enter	0,0,900			; Rauchen
l4:	Enter	-1,0,134		; bis Tuere gehen
l5:	Enter	0,0,220			; Taschenkramen

	clr	(A1)+
	move	#-1,(A1)+
	clr.l	(A1)+
	clr	(A1)+
	move	#-1,(A1)+
	clr.l	(A1)+
	clr	(A1)+
	move	#-1,(A1)+
	clr.l	(A1)+
	clr	(A1)+
	move	#-1,(A1)+
	clr.l	(A1)+
	clr	(A1)+
	move	#-1,(A1)+
	clr.l	(A1)+
	
	move	#PrgRelCom,(A1)+
	move	#PrgEnde,(A1)+
	rts


Anim1:	dc.w	15,17,19
	dc.w	0,2,4,6,8,10,12,14,16,18,20
	dc.w	1,3,5,7,9,11,13,15,17,19
	dc.w	0,2,4,6,8,10,12,14			; HereinLaufen

	dc.w	SetSpeed,20
	dc.w	68,69,68,68,69,70,69,68			; Blinzeln

	dc.w	SetSpeed,6
	dc.w	21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
	dc.w	37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52	; Zig. anzuenden
			
	dc.w	SetSpeed,10
	dc.w	53,53,53,53,53,53,53,53,53,53,53,53,53	; Zug
	dc.w	53,54,55,56,57,58,59,60,61,62,63,64,65	; Ausatmen
	dc.w	53,53,53,53,53,53,53,53,53			; Zug
	dc.w	53,54,55,56,57,58,59,60,61,62,63,64,65	; Ausatmen
	dc.w	53,53,53,53,53,53,53,53,53,53		; Zug
	dc.w	53,54,55,56,57,58,59,60,61,62,63,64,65	; Ausatmen
	dc.w	53,53,53,53,53,53,53
	dc.w	53,54,55,56,57,58,59,60,61,62,63,64,65	; Ausatmen
		
	dc.w	SetSpeed,3
	dc.w	14,16,18,20
	dc.w	1,3,5,7,9,11,13,15,17,19
	dc.w	0,2,4,6,8,10,12,14,16,18,20
	dc.w	1,3,5,7,9,11,13,15,17,19
	dc.w	0,2,4,6,8,10,12,14,16,18,20
	dc.w	1

	dc.w	SetSpeed,8
	dc.w	21,22,23,24,25,26,27,28,29,30,31,32,33,34,35		; Taschen fummeln
	dc.w	34,33,32,31,32,33,34,35
	dc.w	75
	dc.w	PrgEnde
