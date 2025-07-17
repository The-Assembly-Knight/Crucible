.file "sections_table.s"

.macro SET_GLOBAL_OBJ name
  .globl \name
  .type \name, @object
.endm

.section .rodata

SET_GLOBAL_OBJ SECTIONS_TABLE

SECTIONS_TABLE:
  .ascii "src"
  .ascii "assemble"
  .ascii "link"
  .ascii "clean"

SET_GLOBAL_OBJ SECTIONS_LENGTH
SECTIONS_LENGTH:
  .byte 3
  .byte 8
  .byte 4
  .byte 5

SET_GLOBAL_OBJ SECTIONS_AMOUNT
SECTIONS_AMOUNT:
  .quad 4
