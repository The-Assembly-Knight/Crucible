.extern ERROR
.extern NO_ERROR

.extern open_file
.extern read_file
.extern close_file

.extern error_opening_file
.extern error_reading_file
.extern error_closing_file
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
  If_CODE_IS_JMP_TO ERROR(%rip), error_closing_file

  jmp no_error_exit


