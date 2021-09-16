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

* Q6

logistic died vimp


log close
