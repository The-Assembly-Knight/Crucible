.extern EXIT_SYS_CODE

.extern NO_ERROR
.extern OPENING_ERROR
.extern READING_ERROR
.extern CLOSING_ERROR
.extern INVALID_BYTE_ERROR

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro EXIT exit_code
  movq EXIT_SYS_CODE(%rip), %rax
  movq \exit_code, %rdi
  syscall
.endm

SET_GLOBAL_FUNC error_opening_file
error_opening_file:
  EXIT OPENING_ERROR(%rip)

SET_GLOBAL_FUNC error_reading_file
error_reading_file:
  EXIT READING_ERROR(%rip)

SET_GLOBAL_FUNC error_closing_file
error_closing_file:
  EXIT CLOSING_ERROR(%rip)

SET_GLOBAL_FUNC error_invalid_byte_scanned
error_invalid_byte_scanned:
  EXIT INVALID_BYTE_ERROR(%rip)

SET_GLOBAL_FUNC no_error_exit
no_error_exit:
  EXIT NO_ERROR(%rip)
