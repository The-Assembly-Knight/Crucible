.extern NO_ERROR
.extern ERROR

.extern current_token_start
.extern current_token_length
.extern current_token_type

.extern current_section
.extern expected_type

# Section Types
.extern NO_SECTION
.extern SECTION
.extern SRC_SECTION
.extern ASSEMBLE_SECTION
.extern LINK_SECTION
.extern CLEAN_SECTION

.extern INSIDE
.extern OUTSIDE

.macro RET_CODE ret_code
  movq \ret_code, %rax
  ret
.endm

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro JUMP_TO_ON_SECTION label, section
  movq \section, %rsi                    # use rsi as a temp reg to get the section to compare
  cmpq %rsi, (%r15)                      # check if what section is the current section

  je \label
.endm

.macro DEF_NEXT_EXPEC_TYPE type
  leaq expected_type(%rip), %rsi
  movq \type, (%rsi)
.endm

SET_GLOBAL_FUNC parse_token
parse_token:
  leaq current_token_start(%rip), %rax
  leaq current_token_length(%rip), %rcx
  movq current_token_type(%rip), %rdx

  leaq expected_type(%rip), %r14
  leaq current_section(%rip), %r15

  JUMP_TO_ON_SECTION no_section      , NO_SECTION(%rip)
  JUMP_TO_ON_SECTION src_section     , SRC_SECTION(%rip)
  JUMP_TO_ON_SECTION assemble_section, ASSEMBLE_SECTION(%rip)
  JUMP_TO_ON_SECTION link_section    , LINK_SECTION(%rip)
  JUMP_TO_ON_SECTION clean_section   , CLEAN_SECTION(%rip)
  
no_section:
  cmpq SECTION(%rip), %rdx             # check if current token type is a section or not
  jg found_new_section                 # if it is a section jmp to found_new_section
  jng error                            # if it is not a section take it as an error     

src_section:
  

assemble_section:

link_section:

clean_section:

found_new_section:
  movq OPEN_SECTION(%rip), %rsi        # use rsi as a temporal reg for OPEN_SECTION
  movq %rsi, (%r14)                    # make the next expected type an OPEN_SECTION type

  movq %rdx, (%r15)                    # set current section as current_token_type (since it currently has the type of section)

  jmp no_error

no_error:
  movq $0, (%rcx)                      # reset current token length (for the next token) NOTE: I COULD ALSO HAVE TRIED TO DO THIS ON THE BEGINNING OF THE TOKENIZER!!!
                                       # DO NOT FORGET TO RESET TOKEN_LEN AFTER PARSING THE TOKEN IT
  RET_CODE NO_ERROR(%rip)

error:
  RET_CODE ERROR(%rip)

