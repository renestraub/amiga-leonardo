##########################################################################
##                                                                      ##
##  Makefile to build Leonardo-Intro                                    ##
##                                                                      ##
##  Created :  28-Jan-89                      Last update :  28-Jan-89  ##
##                                                                      ##
##########################################################################


#### Allgemeine Flags f�r den Assembler:

AFLAGS	= -cdv -EDISKVERSION


#### Flags f�r den Linker

LFLAGS	= -w +ccdd


#### Regeln:

.s.o:
	as $(AFLAGS) -o $@ $*.S


#### Module:

MODS = s2.o drawbob3.o sndplayer2.o allocmem.o l2.o anim.o dh.o decruncher.o


#### Programme:

Intro:		$(MODS)
		ln $(LFLAGS) -o Intro $(MODS) a:lib2/cdiskreadonly.o
		AbsLoad -qac0 -oIntro.abs Intro


#### Abh�ngigkeiten:

s2.o:	/filenames.i

