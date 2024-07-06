

o:	lea	$20000,a1
	lea	$44000,a2

	move	#[72960/768]-1,d1
Loop2:
	move	#159,d0
Loop:
	move.l	(A1)+,(A2)+
	dbf	d0,Loop
	add.l	#128,a1
	dbf	d1,Loop2
	rts
