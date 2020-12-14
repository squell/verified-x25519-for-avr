# remove simple let-definitions (i..e 'one-liner'), types, etc
/^let [^=]*=[[:space:]]*[^b[:space:]]/d
/^type/d
/^exception/d

# replace instrumented ld_inc with un-instrumented
s/ld_incqt\(.*\)()/LD_INC \1/

# the pretty printer insists on generating "big ints", which we don't need
s/zero/of_int 0/g
s/one/of_int 1/g
s/Why3extract[.][^ ]*of_int//g

# remove all the prefixes and superfluous whitespace
s/Avrmodel__[^.]*[.]//g
s/[[:space:]]\+/ /g

# simply let-substitution which works for hygienic let-expressions that Why3 generates
s/let o = () in \(.*\) o/\1/g
s/let o = \([^ ]*\) in \([^|]*\) o/\2 \1/g
s/let o1 = \([^ ]*\) in \([^|]*\) o1/\2 \1,/g
s/let o2 = \([^ ]*\) in \([^|]*\) o2/\2 \1,/g

# replace whyml exceptions with labels
s/| Branch res -> begin match res//
s/| _ .*$//
s/| \(.*\) -> ()/\n\l\1:/
s/| \(.*\) -> /\n\l\1:\n/

# remove ocaml noise
s/begin//g
s/end//g
s/with//g
s/try//g
s/(\*[^*]*\*)//g

# translate function calls and labels
s/rjmp \(.*\)/RJMP \l\1/
s/ *tst_brne \([^ ]*\), \(.*\)/ TST \1\n BRNE \l\2/

# replace function headings with labels
s/let \([^ ]*\) (us: unit) = /\1:\n/

# delete empty lines
/^[[:space:]]*$/d

# syntax conversion
s/LD_INC \(.*, [XYZ]\)/LD \1+/
s/ST_INC \([XYZ]\)\(.*\)/ST \1+\2/
s/LDD \(.*\), \(.*\), \(.*\)/LDD \1, \2+\3/
s/STD \(.*\), \(.*\), \(.*\)/STD \1+\2, \3/
s/OUT3 0x\(..\) 0x\(..\) 0x\(..\) \(.*\), \(.*\), \(.*\)/OUT 0x\1, \4\n OUT 0x\2, \5\n OUT 0x\3, \6/
s/\<r/R/g

# replace (module-external) WhyML function calls with "rcall"
s/\<.*[.]/RCALL /

# append a final newline
$a\
