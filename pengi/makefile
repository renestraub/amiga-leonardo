#### Allgemeine Flags für den Assembler:

AFLAGS	= -cdv -ih:


#### Flags für den Linker: mit Symbols linken

LFLAGS	= -w 


#### Regeln:

.s.o:
	as $(AFLAGS) -o $@ $*.S

#### Module:

MODS=s.o SchwertHandler.o BogenHandler.o AxtHandler.o ScrollHandler.o \ 
	 AxtPfeilHandler.o DiskAndKey.o ElemHandler.o Line.o CopyMem.o \
	 AllocMem.o DrawBob.o List.o   DivData.o BobDefs.o \
	 Schnoerkel.o ScoreHandler.o Decruncher.o Hiscore.o Fin.o 

#### Loader:

Drag:		$(MODS)
		ln $(LFLAGS) -o Drag  $(MODS) 
		absload -a0 drag



BobDefs.o:	h:BobAdresses.i

