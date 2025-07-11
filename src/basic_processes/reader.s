.extern READ_SYS_CODE
.extern FILE_DESCRIPTOR
.extern input_buffer
.extern MAX_FILE_SIZE

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

SET_GLOBAL_FUNC read_file
read_file:
  movq READ_SYS_CODE(%rip), %rax
  movq FILE_DESCRIPTOR(%rip), %rdi
  leaq input_buffer(%rip), %rsi
  movq MAX_FILE_SIZE(%rip), %rdx
  syscall
  
  jmp no_error

error:
  RET_CODE ERROR

no_error:
  RET_CODE NO_ERROR
