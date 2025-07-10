.extern READ_SYS_CODE
.extern WRITE_SYS_CODE
.extern OPEN_SYS_CODE 
.extern CLOSE_SYS_CODE

.extern NO_FLAGS

.extern NO_ERROR
.extern ERROR

.macro RETURN_CODE return_code
  movq \return_code, %rax
  ret
.endm


.section .rodata
INPUT_FILE_NAME:
  .asciz "build.ccb"

.section .text
.globl _start
_start:
  call open_file
  
open_file:
  movq OPEN_SYS_CODE(%rip), %rax
  leaq INPUT_FILE_NAME(%rip), %rdi
  movq NO_FLAGS(%rip), %rsi

  syscall
  
  test %rax, %rax
  js error_return
  je no_error_return


return_error:
  RETURN_CODE ERROR

return_no_error:
  RETURN_CODE NO_ERROR
  
