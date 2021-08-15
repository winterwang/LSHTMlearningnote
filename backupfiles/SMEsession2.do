log using sme2
cd "~/Downloads/LSHTMlearningnote/backupfiles/"
use "whitehal.dta", clear

stset timeout, fail(all) enter(timein) origin(timein) id(id) scale(365.25)

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
