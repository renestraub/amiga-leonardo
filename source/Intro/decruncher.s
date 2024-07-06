

	XDEF	Multidecruncher,Decruncher


;============ decruncher ==============================


 
;	DestFileEnd = DeCruncher(PufferMemStart)
;	     d0				a0


;				Achtung !

;   	  	Compactiertes File darf nicht laenger sein
;		als uncompactiertes, sonst stuertzt alles ab!



	;Main Decruncher
	;---------------

Decruncher:	movem.l	d1-d7/a0-a6,-(sp)
		btst	#7,(a0)		;Multi Decruncher Mode ?
		bne	Multidecruncher	;Ja =>


	;Fast Decruncher
	;---------------

		move.l	 (a0),a1	;get Cru File Len
		lea	16(a0,a1.l),a1	;Cru File End

		move.l	4(a0),a2	;get Dest File Len
		lea	8(a0,a2.l),a2	;Dest File End

		move.l	a2,-(a7)

		move.l	a0,a3			;Copy lower part of
		lea	DecrunchPuffer,a4	;crunched file in
						;DecrunchPuffer
		move	#DecrunchPufferLen-1,d0
DLoop0:		move.l	(a3)+,(a4)+
		dbra	d0,DLoop0

		lea	DecrunchPufferLen*4(a0),a3

		lea	DecrunchPuffer,a4
		lea	16(a4),a5	;DataStart in Puffer
		sub.l	a0,a4

		lea	8(a0),a0	;DestFileStart


DLoop2:		move.b	-(a1),d0		;Get mask Byte

		moveq	#7,d1			;8 Bits

DLoop1:		btst	d1,d0			;Bit in Mask ?
		beq.s	SetZeroByte		;0 =>
SetNonZeroByte:
		move.b	-(a1),-(a2)		;Bit was set =
		dbra	d1,DLoop1		;Byte was copied
		bra.s	ByteLoopOut		;to comp file

SetZeroByte:	clr.b	-(a2)			;Bit was cleared =
		dbra	d1,DLoop1		;Byte was left out


ByteLoopOut:	;move	d0,$dff180		;Mark decrunch time

		cmp.l	a3,a1			;Jump Point to Puffer
		blo.s	DGoPuffer		;reached ?   Yes =>

DNoGoPuffer:	cmp.l	a0,a2			;End Adr of Dest
		bhi.s	DLoop2			;reached ?   No =>


		move.l	-(a5),-(a0)		;Ersten 8 Bytes
		move.l	-(a5),-(a0)		;uncompacktiert

		move.l	(a7)+,d0		;DestEnd
		movem.l	(a7)+,d1-d7/a0-a6
		rts


DGoPuffer:	cmp.l	a0,a1			;quell adr already in
		blo.s	DNoGoPuffer		;Puffer => No Jump

		add.l	a4,a1			;Jump To Puffer
		bra.s	DNoGoPuffer




	;Multi Decruncher
	;----------------


Multidecruncher:bclr	#7,(a0)		;Clr MultiFlag

		move.l	 (a0),a1	;get Cru File Len
		lea	20(a0,a1.l),a1	;Cru File End

		move.l	4(a0),a2	;get Dest File Len
		lea	12(a0,a2.l),a2	;Dest File End

		move.l	a2,-(a7)

		move.l	a0,a3			;Copy lower part of
		lea	DecrunchPuffer,a4	;crunched file in
						;DecrunchPuffer
		move	#DecrunchPufferLen-1,d0
MDLoop0:	move.l	(a3)+,(a4)+
		dbra	d0,MDLoop0



		lea	DecrunchPufferLen*4(a0),a3

		lea	DecrunchPuffer,a4
		lea	20(a4),a5	;DataStart in Puffer
		sub.l	a0,a4

		lea	12(a0),a0	;DestFileStart




MDLoop2:	move.b	-(a1),d0		;Get mask Byte

		bmi	MDNonFilterCruncher
		beq	MDEqualBytesCruncher


		moveq	#6,d1			;7 Bits

MDLoop1:	btst	d1,d0			;Bit in Mask ?
		beq.s	MDSetZeroByte		;0 =>
MDSetNonZeroByte:
		move.b	-(a1),-(a2)		;Bit was set =
		dbra	d1,MDLoop1		;Byte was copied
		bra.s	MDByteLoopOut		;to comp file

MDSetZeroByte:	clr.b	-(a2)			;Bit was cleared =
		dbra	d1,MDLoop1		;Byte was left out


MDByteLoopOut:	;move	d0,$dff180		;Mark decrunch time

		cmp.l	a3,a1			;Jump Point to Puffer
		blo.s	MDGoPuffer		;reached ?   Yes =>

MDNoGoPuffer:	cmp.l	a0,a2			;End Adr of Dest
		bhi.s	MDLoop2			;reached ?   No =>


		move.l	-(a5),-(a0)		;Ersten 8 Bytes
		move.l	-(a5),-(a0)		;uncompacktiert
		move.l	-(a5),-(a0)

		move.l	(a7)+,d0		;DestEnd
		movem.l	(a7)+,d1-d7/a0-a6
		rts



MDGoPuffer:	cmp.l	a0,a1			;quell adr already in
		blo.s	MDNoGoPuffer		;Puffer => No Jump

		add.l	a4,a1			;Jump To Puffer
		bra.s	MDNoGoPuffer





MDNonFilterCruncher:
		btst	#6,d0
		beq	MDZeroRangeDecruncher


MDDataRangeDecruncher:
		and	#63,d0			;Clear ModeFlags
		addq	#6,d0			;Counter + 7 - 1(dbra)

MDDRDLoop1:	move.b	-(a1),-(a2)		;Copy uncompacted Bytes
		dbra	d0,MDDRDLoop1
		bra.s	MDByteLoopOut



MDZeroRangeDecruncher:
		and	#63,d0			;Clear ModeFlags
		addq	#6,d0			;Counter + 7 - 1(dbra)
		moveq	#0,d3			;DataByte = 0

MDZRDLoop1:	move.b	d3,-(a2)		;Clear DataRange
		dbra	d0,MDZRDLoop1
		bra.s	MDByteLoopOut



MDEqualBytesCruncher:
		move.b	-(a1),d3		;Get Data Byte
		moveq	#0,d0
		move.b	-(a1),d0		;Get Counter
		addq	#6,d0			;Counter + 7 - 1(dbra)


MDEBCLoop1:	move.b	d3,-(a2)		;Fill DataRange
		dbra	d0,MDEBCLoop1
		bra.s	MDByteLoopOut







DecrunchPufferLen:	EQU	256	;Je Groesser, desdo sicherer ist das
				;decrunching. Wichtig bei schwer
				;compactierbaren Files.


DecrunchPuffer:	dcb.l DecrunchPufferLen,0




;===================== Decruncher End ===========================




;		 Cruncher Format
;		=================


;		Introducer LongWords
;		--------------------

;	$xxxxxxxx + $8000000
;			$xxxxxxx = CruFileLen
;			$8000000 = MultiCruncherFlag
;			$0000000 = FastCruncherFlag

;	$xxxxxxxx
;			$xxxxxxx = QuellFileLen

;	$aaaaaaaa $bbbbbbbb $cccccccc
;			$a $b $c = erste 12 Daten Bytes
;					(da decruncher bis zu)
;					(18 Bytes zu weit arbeitet)


;		DataFormat   (FastCruncher)
;		----------


;	%xxxxxxxx, Bytes (0 bis zu 8)	=  FilterCruncher

;		x = 0 : Entsprechendes Byte im Quellcode
;			war null und wurde ausgelassen


;		DataFormat   (MultiCruncher)
;		----------


;	%0xxxxxxx, Bytes (0 bis zu 7)	=  FilterCruncher

;		x = 0 : Entsprechendes Byte im Quellcode
;			war null und wurde ausgelassen
;			(%0xxxxxxx ist weder $00, noch $7f)


;	%10xxxxxx			= Zero Range Cruncher

;		xxxxxx = Anzahl der ausgelassen NullBytes - 7


;	%11xxxxxx			= Data Range Cruncher

;		xxxxxx = Anzahl der nachfolgenden uncompaktierten
;			Datebytes - 7


;	%00000000, Byte, Anzahl		= Equal Bytes Cruncher

;		`Anzahl` - 7 Bytes von gleichen `Bytes`
;		wurde weggelassen 


;	%01111111			= Future Expansion

