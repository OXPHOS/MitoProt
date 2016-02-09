
DST=/opt/local/bin
CC=gcc
OPT=-O4

all: mitoprot

type_specifications.ali: type_specifications.ads
	$(CC) -c $(OPT) type_specifications.ads

strlib.ali: strlib.ads strlib.adb
	$(CC) -c $(OPT) strlib.adb

mito_parameters.ali: mito_parameters.ads type_specifications.ads
	$(CC) -c $(OPT) mito_parameters.ads

sequence_package.ali: sequence_package.ads sequence_package.adb type_specifications.ads
	$(CC) -c $(OPT) sequence_package.adb

sequence_io.ali: sequence_io.ads sequence_io.adb sequence_package.ads type_specifications.ads
	$(CC) -c $(OPT) sequence_io.adb

mitoprot.ali: mitoprot.adb sequence_io.ads sequence_package.ads mito_parameters.ads type_specifications.ads
	$(CC) -c $(OPT) mitoprot.adb

mitoprot: mitoprot.ali sequence_package.ali sequence_io.ali strlib.ali type_specifications.ali mito_parameters.ali
	gnatbl $(OPT) -o mitoprot mitoprot.ali 

clean:
	-rm *.o *.ali b_*.c

install: mitoprot
	strip mitoprot
	cp mitoprot $(DST) 
