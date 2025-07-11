#!/bin/bash

echo -e "Start assembling\n"

as -o defs.o defs/defs.s
as -o defs_error.o defs/def_error_code.s
as -o defs_file.o defs/defs_file.s

as -o main.o src/main.s
as -o opener.o src/basic_processes/opener.s
as -o reader.o src/basic_processes/reader.s
as -o closer.o src/basic_processes/closer.s
as -o lexer.o src/lexer.s
as -o exit.o src/exit.s

as -o bytes_table.o tables/bytes_table.s

echo -e "Start linking\n"

ld -o crucible defs.o defs_error.o defs_file.o main.o opener.o reader.o closer.o lexer.o exit.o bytes_table.o -e _start

echo -e "Start cleaning\n"

rm *.o
