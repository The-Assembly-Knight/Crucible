.file "def_parsing.s"

.macro SET_GLOBAL_OBJ name
  .globl \name
  .type \name, @object
.endm

.macro SET_GLOBAL_DEF name, value
  .globl \name
  .type \name @object

  \name:
  .quad \value
.endm

.section .rodata
  SET_GLOBAL_DEF MAX_FILES_AMOUNT , 100
  SET_GLOBAL_DEF TOKEN_START_SIZE , 8
  SET_GLOBAL_DEF TOKEN_LENGTH_SIZE, 8
  

  .set vMAX_FILES_AMOUNT, 100
  .set vFILE_STRUCT_SIZE, 16
  .set TOTAL_BYTES_OF_FILE_LIST, vMAX_FILES_AMOUNT * vFILE_STRUCT_SIZE

.section .bss

SET_GLOBAL_OBJ src_file_list
src_file_list:
  .skip TOTAL_BYTES_OF_FILE_LIST       # 8 byte for the address of the beginning of the string, and 8 bytes for the length of the string.
