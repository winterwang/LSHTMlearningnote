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

use 










