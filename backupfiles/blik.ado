*! version 5 mh 10/1/1996
*  updated November 2014 SC
cap program drop blik
program define blik
set varabbrev off
set trace off
version 10.0

preserve

parse "`*'", parse(" ,")
confirm integer number `1'
confirm integer number `2'
local d = `1' 
mac shift
local h = `1'
mac shift
local options " Cut(real 0.1465) Null(string) SAMEX Pval"
parse "`*'"


if "`null'"!="" {
  local nval=`null'
}

***************************************
*Checks that D and H not both zero
*Exchanges D and H if H zero
***************************************

if `h'==0 & `d'==0 {
 di in re "No data"
 exit
}
if `h'==0 {
   local h = `d'
   local d = 0
   if "`null'"!="" {
      local nval=1-`nval'
   }
   di in bl "D and H have been interchanged"
}

********************************
*Headings etc.
********************************

local t1 "likelihood ratio for risk parameter: D = `d' , H = `h'"
local N=`d'+`h'
local R = 6.0
local length 10001
local M =`d'/`N'
qui set obs `length'

if "`samex'"=="" {
  local xlab ""
  }
else {
  local xlab "xlabel(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0)"
  local xline "xline(`M')"
}

if "`null'"=="" {
  local yline "yline(`cut')"
}  
else {
  local yline ""
  local xline "xline(`M' `nval')"
}

local ylab "ylabel(0 0.2 0.4 0.6 0.8 1.0)"

gen pi=(_n-0.5)/`length'

qui gen double lik =  `d'*log(pi/`M') + `h'*log((1-pi)/(1-`M'))
qui replace lik=exp(lik)

format pi %3.2f

*The supported range

if "`null'"=="" {

   if `d'==0 {
      qui replace lik=(1-pi)^`h'
      local low=0
	  local high=1-exp(log(`cut')/`h')
   }
   
   else {
   scalar r1=.00001
   scalar r2 = `M'
   local max=`d'*log(`M')+`h'*log(1-`M')
   scalar f1=`d'*log(r1)+`h'*log(1-r1)-`max'-log(`cut')
   scalar f2=`d'*log(r2)+`h'*log(1-r2)-`max'-log(`cut')
   scalar f= 1
   scalar tol = 0.0001
   while abs(f)>tol {
     scalar r=(r1+r2)*0.5
     scalar f=`d'*log(r)+`h'*log(1-r)-`max' -log(`cut')

     if f*f1>0 {
       scalar r1=r
       scalar f1=f
     }
     else {
       scalar r2=r
       scalar f2=f
     }
   }

   local low=r

   scalar r1=.99999
   scalar r2 = `M'
   scalar f1=`d'*log(r1)+`h'*log(1-r1)-`max'-log(`cut')
   scalar f2=`d'*log(r2)+`h'*log(1-r2)-`max'-log(`cut')
   scalar f= 1
   while abs(f)>tol {
      scalar r=(r1+r2)*0.5
      scalar f=`d'*log(r)+`h'*log(1-r)-`max'-log(`cut')

      if f*f1>0 {
         scalar r1=r
         scalar f1=f
      }
      else {
         scalar r2=r
         scalar f2=f
      }

   }

   local high=r
   }
   di in gr "Most likely value for pi    " in ye %7.5f `M'
   di in gr "Likelihood based limits for pi  " in ye %7.5f /*
       */`low' "  " %7.5f `high'
   di in gr "cut-point " in ye `cut'

}

*The likelihood for the null value

else {
   if `d'==0 {
      qui replace lik=(1-pi)^`h'
      local lrnull=(1-`nval')^`h'
   }
   else {
      local M=`d'/`N'
      local lrnull = `d'*log(`nval'/`M') + `h'*log((1-`nval')/(1-`M'))
      local lrnull = exp(`lrnull')
   }
   
   di in gr "Most likely value for pi  " in ye %7.5f `M'
   di in gr "Null value for pi         " in ye %7.5f `nval'
   di in gr "Lik ratio for null value          " in ye %7.5f `lrnull'
   
   local yline "yline(`lrnull', lpattern(dash))"

   if "`pval'"!="" {
      local pval = chiprob(1,-2*log(`lrnull'))
      di in gr "Approx pvalue   " in ye %5.4f `pval'
   }

}

twoway scatter lik pi if lik>0.001, msymbol(i) connect(l) ///
  lcolor (blue) `yline' `xline' `xlab' t1("`t1'") `ylab' ytitle("likelihood ratio") 

end

