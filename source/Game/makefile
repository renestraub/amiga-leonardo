##########################################################################
##                                                                      ##
##  Makefile to build Leonardo (Game only)                              ##
##                                                                      ##
##  Created :  28-Jan-89                      Last update :  28-Jan-89  ##
##                                                                      ##
##########################################################################


#### Allgemeine Flags f�r den Assembler:

AFLAGS	= -cdv -EDISKVERSION


#### Flags f�r den Linker

LFLAGS	= -w +ccdb


#### Regeln:

.s.o:
	as $(AFLAGS) -o $@ $*.S


#### Module:

MODS = s.o l1.o level.o allocmem.o drawbob2.o hiscore.o\
 sndplayer.o decruncher.o dh.o key.o


#### Programme:

Game:		$(MODS)
		ln $(LFLAGS) -o Game $(MODS) a:lib2/cdisk.o
		AbsLoad -qa100 -oGame.abs Game


#### Abh�ngigkeiten:

s.o:	/filenames.i
l1.o:	/filenames.i

