#!/bin/bash

echo -e "Start assembling\n"

as -o defs.o defs/defs.s
as -o defs_error.o defs/def_error_code.s
as -o defs_file.o defs/defs_file.s
as -o defs_par.o defs/def_parsing.s

as -o main.o src/main.s
as -o opener.o src/basic_processes/opener.s
as -o reader.o src/basic_processes/reader.s
as -o closer.o src/basic_processes/closer.s
as -o lexer.o src/lexer.s
as -o tokc.o src/token_classification/token_classifier.s
as -o secc.o src/token_classification/section_classifier.s
as -o pars.o src/token_parsing/parser.s
as -o src_pars.o src/token_parsing/src_parser.s
as -o exit.o src/exit.s

as -o bytes_table.o tables/bytes_table.s
as -o sections_table.o tables/sections_table.s

echo -e "Start linking\n"

ld -o crucible *.o -e _start

echo -e "Start cleaning\n"

rm *.o
