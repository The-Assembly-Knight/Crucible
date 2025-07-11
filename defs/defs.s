.macro SET_GLOBAL_DEF name, value
  .globl \name
  .type \name @object

  \name:
  .quad \value
.endm

.section .rodata

SET_GLOBAL_DEF READ_SYS_CODE , 0
SET_GLOBAL_DEF WRITE_SYS_CODE, 1
SET_GLOBAL_DEF OPEN_SYS_CODE , 2
SET_GLOBAL_DEF CLOSE_SYS_CODE, 3
SET_GLOBAL_DEF EXIT_SYS_CODE , 60

SET_GLOBAL_DEF NO_FLAGS, 0
