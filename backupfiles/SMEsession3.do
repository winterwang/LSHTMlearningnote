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




log close
