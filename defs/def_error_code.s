.macro SET_GLOBAL_DEF name, value
  .globl \name
  .type \name @object

  \name:
  .quad \value
.endm

.section .rodata

SET_GLOBAL_DEF NO_ERROR     , 0
SET_GLOBAL_DEF ERROR        , 1

SET_GLOBAL_DEF OPENING_ERROR     , 1
SET_GLOBAL_DEF READING_ERROR     , 2
SET_GLOBAL_DEF CLOSING_ERROR     , 3
SET_GLOBAL_DEF INVALID_BYTE_ERROR, 4
SET_GLOBAL_DEF CLASSIFYING_ERROR , 5
SET_GLOBAL_DEF PARSING_ERROR     , 6
