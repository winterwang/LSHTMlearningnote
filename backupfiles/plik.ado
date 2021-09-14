*! version 5.0 mh 10/1/1996
*  updated November 2014 SC
cap program drop plik
program define plik
set varabbrev off
version 10.0

preserve
parse "`*'", parse(" ,")

confirm integer number `1'
confirm integer number `2'

local d = `1' 
mac shift
local y = `1'
mac shift

local options "Null(string) Cut(real 0.1465) Pval PER(real 1000)"
parse "`*'"


if  `y' == 0 {
  di in red "needs person-years"
  exit
}

local length  10001
qui set obs  `length'

local t1 "likelihood ratio for rate parameter: D = `d' , Y = `y'"
local xlab "xlab"
local M=`d'/`y'

if "`null'"=="" {
  local yline "yline(`cut')"
}  
else {
  local yline ""
  local nval=`null'
  local Mper=`M'*`per'
  local xline "xline(`Mper' `nval')"
}
local ylab "ylabel(0 0.2 0.4 0.6 0.8 1.0)"

di ""
di in gr "ALL RATES PER " in ye %7.0f `per'


*********************************
*special case where D is zero
*********************************

if `d'==0 {
  gen lambda=(_n-1)*5/(`y'*`length')
  gen double lik = exp(-lambda *`y')

  *The likelihood graph
  qui replace lambda=lambda*`per'
  
  *The supported range and area

  if "`null'"=="" {
    local low 0
    local high=-log(`cut')/`y'
    
    di in gr "Most likely value for lambda    " in ye %7.1f `M'*`per'
   
    di in gr "Likelihood based limits for lambda  " in ye %7.1f ///
       `low'*`per' "  " %7.5f `high'*`per'
    di in gr "cut-point " in ye `cut'
    
  }
  else {
    local nval=`nval'/`per'
    local lrnull = exp(-`nval'*`y')
    di in gr "Most likely value for lambda  " in ye %7.1f `M'*`per'
    di in gr "Null value for lambda         " in ye %7.1f `nval'*`per'
    di in gr "Lik ratio for null value     " in ye %7.5f `lrnull'
 
    local yline "yline(`lrnull', lpattern(dash))"
 
    if "`pval'"!="" {
      local pval = chiprob(1,-2*log(`lrnull'))
      di in gr "Approx pvalue  " in ye %5.3f `pval'
    }
  }
  twoway scatter lik lambda if lik>0.01, msymbol(i) connect(l) ///
     lcolor(blue) `yline' `xline' t1("`t1'") `ylab' ytitle("likelihood ratio")
}
*************
*general case
*************
else {
  local R = 4.0
  local S=sqrt(1/`d')
  local start = `M'/exp(`R'*`S')
  local stop= `M'* exp(`R'*`S')
  qui gen lambda =`start' + (`stop'-`start')*(_n-1)/`length'

  local max=`d'*log(`M') - `d'
  qui gen double lik =`d'*log(lambda)-`y'*lambda -`max' 
  qui replace lik=exp(lik)

  qui replace lambda=lambda*`per'
    
  *The supported range

  if "`null'"=="" {
    scalar r1=0.01*`M'
    scalar r2 = `M'
    scalar f1=`d'*log(r1)-r1*`y' -`max'-log(`cut')
    scalar f2=`d'*log(r2)-r2*`y' -`max'-log(`cut')
    scalar f= 1
    scalar tol = 0.0001
    while abs(f)>tol {
      scalar r=(r1+r2)*0.5
      scalar f=`d'*log(r)-r*`y'-`max'-log(`cut')
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

    scalar r1=10*`M'
    scalar r2 = `M'
    scalar f1=`d'*log(r1)-r1*`y'-`max'-log(`cut')
    scalar f2=`d'*log(r2)-r2*`y'-`max'-log(`cut')
    scalar f= 1
    while abs(f)>tol {
      scalar r=(r1+r2)*0.5
      scalar f=`d'*log(r)-r*`y'-`max'-log(`cut')
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
  di in gr "Most likely value for lambda    " in ye %7.1f `M'*`per'
  di in gr "Likelihood based limits for lambda  " in ye %7.1f /*
     */`low'*`per' "  " %7.1f `high'*`per'
  di in gr "cut-point " in ye `cut'
  }
  
  *The likelihood for the null value

  else {
    local nval=`nval'/`per'
    local lrnull =`d'*log(`nval')-`y'*`nval' -`max' 
    local lrnull=exp(`lrnull')
    di in gr "Most likely value for lambda  " in ye %7.1f `M'*`per'
    di in gr "Null value for lamda         " in ye %7.1f `nval'*`per'
    di in gr "Lik ratio for null value     " in ye %7.5f `lrnull'

    local yline "yline(`lrnull', lpattern(dash))"

    
	if "`pval'"!="" {
      local pval = chiprob(1,-2*log(`lrnull'))
      di in gr "Approx pvalue  " in ye %5.3f `pval'
    }
  
  }
  twoway scatter lik lambda if lik > 0.01 , symbol(i) connect(s) /// 
     lcolor(blue) `yline' `xline' t1("`t1'") `ylab' ytitle("likelihood ratio") 
}
end

