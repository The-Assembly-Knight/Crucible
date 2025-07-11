.extern OPEN_SYS_CODE
.extern FILE_NAME
.extern NO_FLAGS

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

SET_GLOBAL_FUNC open_file
open_file:
  movq OPEN_SYS_CODE(%rip), %rax
  leaq FILE_NAME(%rip), %rdi
  movq NO_FLAGS(%rip), %rsi
  syscall
  
  movq %rax, FILE_DESCRIPTOR(%rip)     # assign fd to FILE_DESCRIPTOR

  test %rax, %rax
  js error
  jmp no_error

error:
  RET_CODE ERROR

no_error:
  RET_CODE NO_ERROR
