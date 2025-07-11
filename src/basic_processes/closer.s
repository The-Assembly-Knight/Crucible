.extern CLOSE_SYS_CODE
.extern FILE_DESCRIPTOR

.extern NO_ERROR
.extern ERROR

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro RET_CODE ret_code
  movq \ret_code, %rax
  ret
.endm

.section .text

SET_GLOBAL_FUNC close_file
close_file:
  movq CLOSE_SYS_CODE(%rip), %rax
  movq FILE_DESCRIPTOR(%rip), %rdi
  syscall
  
  test %rax, %rax
  js error
  jmp no_error

error:
  RET_CODE ERROR

no_error:
  RET_CODE NO_ERROR
