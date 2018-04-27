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

tabstat bweight, by(


 
*6*

teffects ra (bweight fbaby) (mbsmoke)


*7*

regress bweight i.mbsmoke##i.fbaby
est store a

*to get the C speficic effects: 

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



use syndW, clear
