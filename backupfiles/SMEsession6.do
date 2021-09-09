log using sme6, append

cd "~/Downloads/LSHTMlearningnote/backupfiles/"


* Q1

use mwanza, replace

help mwanza


generate ed2 = ed
recode ed2 3/4 = 2
label define ed2label 1 "none/adult only" 2 ">=1 years"
label val ed2 ed2label
label var ed2 "education"


tabulate ed2 ed

generate age2 = age1
recode age2 2 = 1 3/4 = 2 5/6 = 3
label define age2label 1 "15-24" 2 "25-34" 3 "35+"
label val age2 age2label
label var age2 "Age"
tabulate age2 age1



* Q2

 tabulate case ed2, row

 mhodds case ed2, c(1, 2)

 mhodds case ed2, c(2, 1)



tab case ed2, chi exact


* Q3 

bysort age2: tab case ed2, row

mhodds case ed2, by(age2)


* Q4 

recode rel 9=.

tabulate case rel, chi row



log close


















