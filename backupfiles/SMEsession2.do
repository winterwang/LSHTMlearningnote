log using sme2
cd "~/Downloads/LSHTMlearningnote/backupfiles/"
use "whitehal.dta", clear

stset timeout, fail(all) enter(timein) origin(timein) id(id) scale(365.25)
quietly stset timeout, fail(all) enter(timein) origin(timein) id(id) scale(365.25)

tab _st

* 

egen agecat = cut(agein), at(40, 45, 50, 55, 60, 65, 70) label

strate agecat, per(1000)

stptime, by(agecat) per(1000)


* Q4 

stmh agecat, c(1, 0)

stmh agecat, c(2, 0)
stmh agecat, c(3, 0)
stmh agecat, c(4, 0)
stmh agecat, c(5, 0)



* Q5

strate grade, per(1000)
stmh grade

* Q6-Q8

stmh grade, by(agecat)


* Q9

stset timeout, fail(chd) origin(timein) id(id) scale(365.25)


stmh grade
stmh grade, by(smok)

* Q10

quietly stset timeout, fail(chd) origin(timein) id(id) scale(365.25)

strate cholgrp, per(1000)

stmh cholgrp, c(2,1)
stmh cholgrp, c(3,1)
stmh cholgrp, c(4,1)
stmh cholgrp

stmh cholgrp, c(2,1) by(agecat)
stmh cholgrp, c(3,1) by(agecat)
stmh cholgrp, c(4,1) by(agecat)
stmh cholgrp, by(agecat)


table cholgrp


log close

