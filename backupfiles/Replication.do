cd "/home/ccwang/Documents/LSHTMlearningnote/backupfiles"
log using LSHTMstata.log, append

*       log:  /home/ccwang/Documents/LSHTMlearningnote/backupfiles/LSHTMstata.log
*  log type:  text
* opened on:  24 Apr 2018, 23:01:40



*********************************************************************
* Practical in Survival Analysis Chapter 2***************************
*********************************************************************

use pbcbase

tab treat d, row

table treat d, c(median time)


stset time, failure(d) 


// or we can use the same command to stset survival data 

stset dateout, failure(d) origin(datein) scale(365.25)

sts graph, by(treat) ci

sts list, by(treat)

sts list if treat==2 & cir0==1

// cumulative hazard functions

sts graph, by(treat) cumhaz

sts test treat, logrank


use whitehall, clear

stset timeout, failure(chd) origin(timein) scale(365.25)

sts graph

sts graph, by(sbpgrp)

sts test sbpgrp, logrank



*********************************************************************
* Practical in Survival Analysis Chapter 3***************************
*********************************************************************

use whitehall, clear

stset timeout, failure(chd) origin(timein) scale(365.25)

tab grade chd, row


table grade chd, c(median _t)


sts graph, by(grade) ci


sts list, by(grade) at(5 10 15)

sts test grade

streg i.grade, d(exp)

streg i.grade, d(exp) nohr

stset timeout, origin(timebth) enter(timein) fail(chd) id(id) scale(365.25)

streg i.grade, d(exp)

// the parameters are the same as before. This is because the hazad for grade
// is constant over time in an exponential model, so the time-scale does not 
// have any impact on the estimates. 

stset timeout, failure(chd) origin(timein) scale(365.25)

gen agecat =1 if agein >= 40 & agein < 50
replace agecat=2 if agein >= 50 & agein < 55
replace agecat=3 if agein >= 55 & agein < 60
replace agecat=4 if agein >= 60 & agein < 65
replace agecat=5 if agein >= 65 & agein < 70

streg i.grade i.agecat, d(exp)

tab agecat grade , col chi

streg i.grade i.agecat, d(weib) nohr

sts graph if agecat == 1, by(grade) cumhaz yscale(log) xscale(log) ci title(Age: 40-50)
sts graph if agecat == 2, by(grade) cumhaz yscale(log) xscale(log) ci title(Age: 50-55)


streg i.grade i.agecat, d(exp)
estimates store A


streg i.grade i.agecat, d(weib)
estimates store B

lrtest A B, force



stset timeout, failure(chd) origin(timein) id(id) scale(365.25)

list id _t0 _t _d if id == 5001
list id _t0 _t _d if id == 5350
stsplit fuband, at(0, 5, 10, 15, 20)
list id _t0 _t _d if id == 5001
list id _t0 _t _d if id == 5350


streg i.grade i.agecat i.fuband, d(exp) nohr

// Extra exercise 

poisson chd i.grade, exp(_t)

poisson chd i.grade, exp(_t) irr



























































































log close







