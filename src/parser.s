.extern current_token_start
.extern current_token_length
.extern current_token_type

.extern current_section

# Section Types
.extern NO_SECTION
.extern SRC_SECTION
.extern ASSEMBLE_SECTION
.extern LINK_SECTION
.extern CLEAN_SECTION

.extern INSIDE
.extern OUTSIDE

parse_token:
  movq current_token_start(%rip), %rax
  movq current_token_length(%rip), %rcx
  movq current_token_type(%rip), %rdx
  movq current_section(%rip), %r15

  # DO NOT FORGET TO RESET TOKEN_LEN AFTER PARSING THE TOKEN IT




