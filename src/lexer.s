.extern NO_ERROR
.extern ERROR

.extern BYTES_TABLE
.extern WORD
.extern DELIMITER

.extern input_buffer
.extern current_offset
.extern current_token_start
.extern current_token_length
.extern current_token_type

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro RET_CODE ret_code
  movq \ret_code, %rax
  ret
.endm

.section .text

SET_GLOBAL_FUNC find_next_token
find_next_token:
  jmp continue_scanning

continue_scanning:
  leaq input_buffer(%rip), %rdi        # get input_buffer
  addq current_offset(%rip), %rdi      # add offset

  movb (%rdi), %al

  leaq current_token_start(%rip), %rdx # point to current_token_start with rdx

  cmpq $0, current_token_length        # if the length of the token is 0, set this byte as the beginning of the current token
  je set_current_token_start

  jmp scan_byte

set_current_token_start:
  leaq BYTES_TABLE(%rip), %rdx         # get BYTES_TABLE in rdx
  movzbq (%rdx, %rax, 1), %rdx         # get type based on the look-up table BYTES_TABLE

  movq %rdx, current_token_type(%rip)  # set current_token_type based on the prefix of the current token

  movq %rdi, current_token_start(%rip) # set current byte as the beginning of the current token
  jmp scan_byte

scan_byte:
  leaq BYTES_TABLE(%rip), %rdx
  movzbq (%rdx, %rax, 1), %rdx

  cmpq WORD(%rip), %rdx
  jge regular_byte_scanned

  cmpq DELIMITER(%rip), %rdx
  je delimiter_byte_scanned

  jmp invalid_byte_scanned

regular_byte_scanned:
  incq current_offset(%rip)
  incq current_token_length(%rip)

  jmp continue_scanning

delimiter_byte_scanned:
  incq current_offset(%rip)
  RET_CODE NO_ERROR(%rip)              # since it is the end of the current token, go back without any errors

invalid_byte_scanned:
  RET_CODE ERROR(%rip)                 # since an invalid character was found, go back to main.s as an error
