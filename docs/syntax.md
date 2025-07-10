# Crucible Basic Syntax

## Key Sections

### Source (src)

This section is designed to provide Crucible with a list of the files desired to be compiled together into one final output file.

**Example:** 

    src {
        main.s
        test.s
        my_file.s
    } 

### Assemble 

This section will instruct Crucible of what to do for each individual src file from the src section list.

**Example:**

    assemble {
        as -o %o %i
    }

**Note:** The use of % is explained in the Special Prefixes section.

### Link
This section will instruct Crucible of what to do after the assemble process has been finalized.

**Example:**

    link {
        ld -o %d %O -e _start
    }

### Clean

This section will instruct Crucible how to clean the files that are no longer necessary after linking them into one final file. (This last section is completely optional) as long as !clean = true is not set.

**Example:**

    clean {
        rm *.o
    }

    

## Special Prefixes

The following characters serve as prefixes for Crucible.

**!** -> Tells Crucible to change the value of an execution option.

**Example:**

    ; This would tell Crucible to always execute the clean section after the linking process (if there is not a clean section,  
    then an error will pop up)
    
    !clean = true

**%** -> Access internal variables and constants, allowing to change their value as long as they are not constant.

**Example:**
    
    ; This would change the value of variable output to ".current_input_variable.o" which would make every instance of %o
    have said condition
    
    %o = .%i.o

**;** -> Convert the rest of the line in a comment, which has none effect in the behavior of the program.

**Example:**

    src {       ; This is the beginning of the src section.
        main.s  ; This is the first argument of the src section.
        test.s  ; This is the last argument of the src section.
    }           ; This is the end of the src section.

## Internals

### Options

- clean -> Determines whether Crucible will automatically execute the code in the clean section or not. (Default: false)

### Variables

- o     -> Stores an output for each input file in the src section.
- d     -> Stores the destination file.

### Constants

- i     -> Stores an instance of each input file in the src section.
- O     -> Stores all the output files created after the assemble section.


