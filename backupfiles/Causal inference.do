********************************************************************************
*
*	Do-file:			tuesday_practical_pm.do
*	Programmed by:		Chaochen Wang
*
*	Dataset used:		RFA_cat.do
*	Dataset created:	.
*	Output:				
*
********************************************************************************
*
*	Purpose:	This do-file performs the analyses in 
*			practicals in the LSHTM Causal Inference short course.
*
*			
*
********************************************************************************
cd "/home/ccwang/Documents/LSHTMlearningnote/backupfiles"
log using LSHTMstata.log, append



*********************************************************************
* Practical in Causal inference  Chapter 3***************************
*********************************************************************

use cattaneo2, clear

browse

tab mbsmoke

summ bweight, detail

hist bweight


*1 a) 
regress bweight i.mbsmoke


*b) 

regress bweight i.mbsmoke i.fbaby

// fbaby is negatively confounding the association between mbsmoke and 
// bweight. This can be explained by the observation that there are fewer smokers 
// among the mothers of first born babies. 
// while both first babies and babies of smokers tend to be lighter: 

tab fbaby mbsmoke, row 

tabstat bweight, by(fbaby)

tabstat bweight, by(mbsmoke)

// Remark that comparing the coefficients of these regressions to `detect` 
// confounding only works for collapsible models (and not for logitstic models
// or others).
 
*6*

teffects ra (bweight fbaby) (mbsmoke)


*7*

regress bweight i.mbsmoke##i.fbaby
est store a

*to get the specific effects: 

lincom 1.mbsmoke 

lincom 1.mbsmoke + 1.mbsmoke#1.fbaby


*8* to calculate the marginal effect we need to know P(fbaby) 

tab fbaby 

*now restore model estimates
est restore a 

lincom 0.562*1.mbsmoke  + 0.438*(1.mbsmoke + 1.mbsmoke#1.fbaby)

margins, dydx(mbsmoke)

*10*

regress bweight mbsmoke fbaby mmarried alcohol fedu mage


teffects ra (bweight fbaby mmarried alcohol fedu mage) (mbsmoke)

*11* 

 regress bweight mbsmoke fbaby mmarried alcohol fedu mage if mbsmoke==0
 predict Y0
 
 regress bweight mbsmoke fbaby mmarried alcohol fedu mage if mbsmoke==1
 predict Y1
 
 sum Y0
 gen E0=r(mean) 
 
 sum Y1
 gen E1=r(mean)
 
 gen ACE = E1-E0 
 sum ACE

 tab fedu
 **
 regress bweight i.mbsmoke fbaby mmarried alcohol fedu mage ///
		i.mbsmoke#i.fbaby i.mbsmoke#i.mmarried i.mbsmoke#i.alcohol i.mbsmoke#c.fedu ///
		i.mbsmoke#c.mage
		
		margins, dydx(mbsmoke)



*********************************************************************
* Practical in Causal inference  Chapter 4***************************
*********************************************************************


teffects ra (lbweight mage i.fbaby i.prenatal, logit) (mbsmoke)


teffects ra (lbweight mage i.fbaby i.prenatal, logit) (mbsmoke), atet



use RFA, clear

describe

summarize age

tab gender

tab hospital

summarize maxdia

tab position

tab dodp

* 4.1

logit dodp rfa

glm dodp rfa, family(binomial) link(logit)

logit dodp rfa i.hospital maxdia i.position

// the overall pattern of confounding appears to be that of positive confounding. 
// the unadjusted analysis suggests a strong beneficial effect of RFA compared 
// with standard surgery (nearly a halving of the odds of death of deases progre-
// ssion within 3 years), However, after adjusting for 


















use syndW, clear
