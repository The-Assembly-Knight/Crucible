.file "src_parser.s"

.extern NO_ERROR
.extern ERROR

.extern NO_SECTION
.extern current_section

.extern OPEN_SECTION
.extern STRING
.extern CLOSE_SECTION

.extern src_file_list
.extern src_file_list_offset

.extern MAX_FILES_AMOUNT
.extern TOKEN_START_SIZE
.extern TOKEN_LENGTH_SIZE

.macro RET_CODE ret_code
  movq \ret_code, %rax
  ret
.endm

.macro SET_GLOBAL_FUNC name
  .globl \name
  .type \name, @function
.endm

.macro DEF_NEXT_EXPEC_TYPE type
  leaq expected_type(%rip), %rsi
  movq \type, (%rsi)
.endm

.section .text

SET_GLOBAL_FUNC process_src_section
process_src_section:
  movq (%r14), %rsi                    # use rsi as a temporal register for the expected type

  cmpq OPEN_SECTION(%rip), %rsi
  je expected_open_section_in_src

  cmpq STRING(%rip), %rsi
  je expected_string_in_src

  jmp error                            # if neither open_section nor string were expected an error ocurred

expected_open_section_in_src:
  cmpq OPEN_SECTION(%rip), %rdx        # if current type isnt open section then take it as an error if it is then just continue by returning
 
  movq STRING(%rip), %rsi              # use rsi as a temp reg for type STRING
  movq %rsi, expected_type(%rip)

  je no_error
  jne error

expected_string_in_src:
  cmpq STRING(%rip), %rdx              # if current token type is string add it to the src string's list, if not then check if it is a close_section type (the end of src)
  je add_string_to_src_list
  jne expected_close_section_in_src

expected_close_section_in_src:
  cmpq CLOSE_SECTION(%rip), %rdx
  je end_src_section
  jne error

add_string_to_src_list:
  #************* ADD A COMPARE TO PREVENT OVERFLOW (ADD A GLOBAL CONST FOR THE MAX AMOUNT OF FILES IN SRC, PUT THE DEF IN defs.s)
  # AND ADD STRING TO SRC LIST BUT FIRST TEST IF THE PROGRAM CAN REACH THIS POINT  
  jmp no_error

end_src_section:
  movq NO_SECTION(%rip), %rsi          # use rsi as a temp reg for no_section
  movq %rsi, current_section(%rip)     # since it is the end of the section the current section will be no_section
  jmp no_error

no_error:
  RET_CODE NO_ERROR(%rip)

error:
  RET_CODE ERROR(%rip)
