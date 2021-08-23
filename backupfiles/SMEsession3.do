log using sme3, append

cd "~/Downloads/LSHTMlearningnote/backupfiles/"

* Q1
use trinmlsh

describe
sum

help trinmlsh

* Q2 

stset timeout, fail(death) origin(timein) enter(timein) scale(365.25) id(id)

sts graph, saving(plot1)




* Q3 

sts list, at(1, 3, 5)


* Q4 

sts graph, ci saving(plot1, replace)

* Q5

tab smokenum
tab smokenum, nolabel


gen smokstatus = smokenum >= 2 if smokenum != .
label define smokstatus 0 "non-smokers" 1 "current smokers"

label value smokstatus smokstatus
sts graph, by(smokstatus)

* Q6

sts test smokstatus

* Q7

use mortality, clear

help mortality

describe

* Q8 

gen hyper = .
replace hyper = 0 if systolic < 140
replace hyper = 1 if systolic >= 140 & systolic != .

* 09


stset exit, failure(died) enter(enter) origin(enter) id(id) scale(365.25)



* Q10 


strate hyper, per(1000)


*Q11

stmh hyper

* Q12-Q13

browse


* Q14

sts list if hyper == 1


* Q15

sts graph, by(hyper)


* Q16

sts graph, by(hyper) ci

* Q17


sts graph, by(hyper) ci failure ylabel(0 0.05 0.10 0.15 0.20)

* Q18

sts test hyper

* Q19


stset exit, failure(died) enter(enter)  id(id) scale(365.25)
strate hyper, per(1000)
stmh hyper

* Q20
sts graph, by(hyper)




log close
