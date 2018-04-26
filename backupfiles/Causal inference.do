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


regress bweight i.mbsmoke mage i.fbaby i.prenatal


gen mage2=mage^2
regress bweight i.mbsmoke mage mage2 i.fbaby##i.prenatal

regress bweight i.mbsmoke##i.fbaby i.prenatal mage mage2


teffects ra (bweight mage mage2) (mbsmoke)
