#!/bin/sed -f

# this script translates avr assembler files to whyml; it requires GNU sed

# remove assembler directives
/^\s*[.]/d

# remove carriage returns
s///g

# translate assembly comments into whyml comments
s/ *; *\(.*\)$/; (* \1 *)/

# add statement separators (except after comments)
s/[^)]$/&;/

# convert mnemonics into lowercase
s/.*/\L&/

# remove leading whitespace
s/^ *;//g

# translate X,Y,Z registers in st/ld opcodes
/\<\(ld\|st\)d\?\>/s/[xyz]/r\U&/

# translate load-and-increment mnemonics
s/ld \(\w\+\), \(r[XY-Z]\)+/ld_inc \1, \2/
s/st \(r[XY-Z]\)+, \(\w\+\)/st_inc \1, \2/

# replace syntax that functions to separate arguments with juxtaposition
s/[,+-] \?/ /g

# replace labels with function entry points (only works on branchfree code)
/^\(.*\):;$/s//let \1 () =/
