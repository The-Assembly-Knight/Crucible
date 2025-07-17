.file "section_classifier.s"

.extern NO_SECTION
.extern SRC_SECTION
.extern ASSEMBLE_SECTION
.extern LINK_SECTION
.extern CLEAN_SECTION

.extern SECTIONS_TABLE
.extern SECTIONS_AMOUNT
.extern SECTIONS_LENGTH

.extern current_token_start
.extern current_token_length

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro RET_CODE ret_code
  movq \ret_code, %rax
  ret
.endm

.macro UPDATE_CURRENT_TOKEN_START 
  leaq current_token_start(%rip), %r10 # point to the address of the beginning of the current token
  movq (%r10), %r10                    # point to the beginning of the current token

  movb (%r10), %al                    # get character r10 points to
.endm

SET_GLOBAL_FUNC classify_as_section
classify_as_section:
  xorq %rcx, %rcx                      # amount of sections checked
  
  leaq SECTIONS_TABLE(%rip), %r8       # point to sections table with r8
  leaq SECTIONS_LENGTH(%rip),%r9       # point to a list of the length of each section

  UPDATE_CURRENT_TOKEN_START

  movq current_token_length(%rip), %r11# get the length of the current token
  movzbq %r11b, %r11                   # zero extent except for last byte

  xorq %r14, %r14                      # clean to use it as a counter of byte_matches
  xorq %r15, %r15                      # clean to use it as offset in bytes

compare_strings:
  movzbq (%r9), %rsi
  cmpq %rsi, %r11                     # compare section length with token length
  jne next_section
  
  jmp compare_bytes

compare_bytes:
  cmpb (%r8), %al                     # compare the byte on SECTION_TABLE with the correspondent byte of current_token
  je byte_match
  jne byte_did_not_match

byte_match:
  incb %r14b                           # increase amount of byte matches

  cmpb (%r9), %r14b                    # if the amount of byte_matches matches the amount of bytes, then it is a section
  je a_section

  incq %r8                             # point to next byte of SECTIONS_TABLE
  incq %r10                            # point to next byte of current_token
  movb (%r10), %al                     # save the char r10 points to in al

  jne compare_bytes

byte_did_not_match:
  xorq %r14, %r14                      # reset byte_matches
  jmp next_section

next_section:
  incq %rcx                            # increase amount of scanned sections

  cmpq SECTIONS_AMOUNT(%rip), %rcx     # if all sections had been scanned it is not a section, otherwise check next section
  je not_a_section

  leaq SECTIONS_TABLE(%rip) , %r8       # point to the beginning of sections_table
  movzbq (%r9), %rsi                    # load section length to a temp register
  addq %rsi, %r15                       # add offset of sections_length

  addq %r15, %r8                        # add offset to point to the beginning of the next string

  incq %r9                              # point to the next section's length in SECTION_LENGTH      

  UPDATE_CURRENT_TOKEN_START

  jmp compare_strings

a_section:
  cmpq $0, %rcx                        # if it only scanned the first section (src) then it is a token SRC_SECTION type
  je src_section
  
  cmpq $1, %rcx                        # the same as above but with assemble section
  je assemble_section

  cmpq $2, %rcx                        # the same as above but with link section
  je link_section

  cmpq $3, %rcx                        # the same as above but with the clean section
  je clean_section

  jmp not_a_section                       # in case the above comparations fail this will prevet the error from silently break everything

src_section:
  RET_CODE SRC_SECTION(%rip)

assemble_section:
  RET_CODE ASSEMBLE_SECTION(%rip)

link_section:
  RET_CODE LINK_SECTION(%rip)

clean_section:
  RET_CODE CLEAN_SECTION(%rip)

not_a_section:
  RET_CODE NO_SECTION(%rip)
