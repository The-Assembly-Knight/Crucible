.file "def_parsing.s"

.macro SET_GLOBAL_OBJ name
  .globl \name
  .type \name, @object
.endm

.section .rodata
  .set MAX_FILES_AMOUNT, 100
  .set FILE_STRUCT_SIZE, 12
  .set TOTAL_BYTES_OF_FILE_LIST, MAX_FILES_AMOUNT * FILE_STRUCT_SIZE

.section .bss

SET_GLOBAL_OBJ src_file_list
src_file_list:
  .skip TOTAL_BYTES_OF_FILE_LIST       # 8 byte for the address of the beginning of the string, and 4 bytes for the length of the string.
