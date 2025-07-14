.macro SET_GLOBAL_DEF name, value
  .globl \name
  .type \name @object

  \name:
  .quad \value
.endm

# Section Types
SET_GLOBAL_DEF NO_SECTION      , 0
SET_GLOBAL_DEF SRC_SECTION     , 1
SET_GLOBAL_DEF ASSEMBLE_SECTION, 2
SET_GLOBAL_DEF LINK_SECTION    , 3
SET_GLOBAL_DEF CLEAN_SECTION   , 4

# Section States
SET_GLOBAL_DEF OUTSIDE               , 0
SET_GLOBAL_DEF INSIDE                , 1
