.extern ERROR
.extern NO_ERROR
.extern FILE_END_CODE

.extern open_file
.extern read_file
.extern close_file
.extern find_next_token
.extern classify_token
.extern parse_token

.extern error_opening_file
.extern error_reading_file
.extern error_closing_file 
.extern error_invalid_byte_scanned
.extern error_classifying_token
.extern error_parsing
.extern no_error_exit

.macro IF_CODE_IS_JMP_TO code, label
  cmpq \code, %rax
  je \label
.endm

.macro IF_CODE_IS_NOT_JMP_TO code, label
  cmpq \code, %rax
  jne \label
.endm

.globl _start
.section .text

_start:
  call open_file
  IF_CODE_IS_JMP_TO ERROR(%rip), error_opening_file

  call read_file
  IF_CODE_IS_JMP_TO ERROR(%rip), error_reading_file

  call close_file
  IF_CODE_IS_JMP_TO ERROR(%rip), error_closing_file

processing_file_loop:
  call find_next_token
  IF_CODE_IS_JMP_TO ERROR(%rip), error_invalid_byte_scanned

  call classify_token
  IF_CODE_IS_JMP_TO ERROR(%rip), error_classifying_token

  call parse_token
  IF_CODE_IS_JMP_TO ERROR(%rip), error_parsing_token

  IF_CODE_IS_NOT_JMP_TO FILE_END_CODE(%rip), processing_file_loop         # if the end of the file hasn't been reached then repeat until you find it

  # ADD A LOOP FOR processing_file_loop WHERE EVERY TOKEN IS GONNA BE SCANNED
  # WHEN REACHED THE END OF FILE STOP LOOP
  # NOTE: PROB I'LL TO CHECK find_next_token JUST IN CASE IT DOES SOMETHING UNAPROPERLY BECAUSE IT IS SUPPOSED TO WORK FOR MULTIPLE ITERATIONS BUT I HAVENT TEST IT 

  # GOTTA ADD A FILE_END_TYPE OR SOMETHING LIKE THAT BECAUSE FILE_END AND NO_ERROR HAVE THE SAME VALUE WHICH CAUSED A WEIRD BEHAVIOR BECAUSE OF A COMPARISION

encoding:
  jmp no_error_exit
