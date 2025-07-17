.extern NO_ERROR
.extern ERROR

.extern classify_as_section

.extern STRING
.extern NO_SECTION
.extern SRC_SECTION
.extern ASSEMBLE_SECTION
.extern LINK_SECTION
.extern CLEAN_SECTION
.extern EQUALS
.extern OPEN_SECTION
.extern CLOSE_SECTION

.extern current_token_start
.extern current_token_type
.extern current_token_length

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro RET_CODE ret_code
  movq \ret_code, %rax
  ret
.endm

.macro JMP_TO_ON_TYPE label token_type 
  cmpq \token_type, %rdx
  je  \label
.endm

.macro IF_CODE_IS_NOT_JMP_TO code, label
  cmpq \code, %rax
  jne \label
.endm

.macro DEFINE_AS type
  push %rdx

  leaq current_token_type(%rip), %rdx
  movq \type, %r15
  movq %r15, (%rdx)

  pop %rdx
.endm

.section .text

SET_GLOBAL_FUNC classify_token
classify_token:
  movq current_token_type(%rip), %rdx
  movq current_token_start(%rip), %r8
  movzbq (%r8), %r8

  JMP_TO_ON_TYPE classify_word WORD(%rip)
  JMP_TO_ON_TYPE classify_sign SIGN(%rip)
  
  jmp error

classify_word:
  call classify_as_section
  IF_CODE_IS_NOT_JMP_TO NO_SECTION(%rip), section

  jmp string

classify_sign:
  cmpq $1, current_token_length        # if it starts with a sign char but it is longer than 1 char then it is a string
  jne string

  cmpq EQUAL_SIGN(%rip), %r8
  je equal_sign

  cmpq OPENING_BRACE(%rip), %r8
  je opening_brace

  cmpq CLOSING_BRACE(%rip), %r8
  je closing_brace

  jmp error

equal_sign:
  DEFINE_AS EQUALS(%rip)
  jmp no_error

opening_brace:
  DEFINE_AS OPEN_SECTION(%rip)
  jmp no_error

closing_brace:
  DEFINE_AS CLOSE_SECTION(%rip)
  jmp no_error

section:
  DEFINE_AS %rax
  jmp no_error

string:
  DEFINE_AS STRING(%rip)
  jmp no_error

no_error:
  RET_CODE NO_ERROR(%rip)

error:
  RET_CODE ERROR
