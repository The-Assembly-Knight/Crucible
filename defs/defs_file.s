.macro SET_GLOBAL_DEF name, value
  .globl \name
  .type \name, @object

  \name:
  .quad \value
.endm

.macro SET_GLOBAL_STR_DEF name, string
  .globl \name
  .type \name, @object
  
  \name:
  .asciz "\string"
.endm

.macro SET_GLOBAL_OBJ name
  .globl \name
  .type \name, @object

  \name:
  .quad 0
.endm

.section .rodata

SET_GLOBAL_DEF MAX_FILE_SIZE, 65536
SET_GLOBAL_STR_DEF FILE_NAME, build.ccb


.section .bss
SET_GLOBAL_OBJ FILE_DESCRIPTOR
SET_GLOBAL_OBJ input_buffer
SET_GLOBAL_OBJ current_offset

SET_GLOBAL_OBJ current_token_start
SET_GLOBAL_OBJ current_token_length
SET_GLOBAL_OBJ current_token_type

SET_GLOBAL_OBJ current_section
SET_GLOBAL_OBJ expected_type

SET_GLOBAL_OBJ src_file_list_offset
