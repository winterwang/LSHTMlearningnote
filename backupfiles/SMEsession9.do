log using sme9.log, append

cd "~/Downloads/LSHTMlearningnote/backupfiles/"

* Q1


use mortality, clear
describe

summarize



* Q3

tab died

summarize died

tab vimp

tabulate died vimp, col

tabodds died vimp

mhodds died vimp

* Q4
logit died vimp
glm died vimp, family(binomial) link(logit)
glm died vimp, family(binomial) link(logit) eform

* Q6-7

logistic died vimp

logit died vimp, or

* Q8

tab mfgrp died, row

* Q9 

logit died i.mfgrp


list mfgrp i.mfgrp in 1/25


* Q10 


logistic died i.mfgrp, base


* Q13

 if mfgrp!=.
estimates store A

logistic died i.mfgrp
estimates store B

lrtest B A

logistic died
estimates store A

logistic died i.mfgrp
estimates store B

lrtest B A


* Q14

logistic died i.agegrp, base


logistic died i.vimp i.agegrp, base



log close
