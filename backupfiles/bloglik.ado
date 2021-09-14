*! version 5.0 mh 10/1/1996
* updated November 2014 SC
cap program drop bloglik
program define bloglik
set varabbrev off
version 10.0

preserve

parse "`*'", parse(" ,")
confirm integer number `1'
confirm integer number `2'
local d = `1' 
mac shift
local h = `1'
mac shift
local options "Logodds Cut(real -1.921) Samex"
parse "`*'"


if (`d' == 0 | `h' == 0) {
   di in red "not possible because likelihood is infinite"
   exit
}

if "`samex'"!=""&"`logodds'"!=""{
   di in red "samex not allowed with logodds"
   exit
}

if "`samex'"=="" {
   local xlab ""
}
else {
   local xlab "xlabel(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9)"
}

local t1 "log likelihood ratio for risk parameter: D = `d' , H = `h'"
if "`logodds'"!="" {
   local t1 "log likelihood ratio for logodds parameter: D = `d' , H = `h'"
}

local N=`d'+`h'
local R = 5.0
local length 10001
qui set obs `length'

local max = `d'*ln(`d')+`h'*ln(`h')-(`N')*ln(`N')

local ylab "ylabel(0 -1  -2 -3 -4)"
local yline "yline(`cut')"
  
local M =`d'/`N'
local S=sqrt(`M'*(1-`M')/`N')

* finds exact supported range

scalar r1=.00001
scalar r2 = `M'
local max=`d'*log(`M')+`h'*log(1-`M')
scalar f1=`d'*log(r1)+`h'*log(1-r1)-`max'-`cut'
scalar f2=`d'*log(r2)+`h'*log(1-r2)-`max'-`cut'
scalar f= 1
scalar tol = 0.0001
while abs(f)>tol {
  scalar r=(r1+r2)*0.5
  scalar f=`d'*log(r)+`h'*log(1-r)-`max' -`cut'
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
  scalar f1=`d'*log(r1)+`h'*log(1-r1)-`max' -`cut'
  scalar f2=`d'*log(r2)+`h'*log(1-r2)-`max' -`cut'
  scalar f= 1
  while abs(f)>tol {
    scalar r=(r1+r2)*0.5
    scalar f=`d'*log(r)+`h'*log(1-r)-`max'-`cut'
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

if "`logodds'"=="" {

* displays exact and approx supported range

di in gr "Most likely value for risk parameter    " in ye %7.5f `M'
di ""
di in gr "cut-point " in ye `cut'
di in gr "Likelihood based limits for risk parameter  " in ye %7.5f /*
*/`low' "  " %7.5f `high'
local plow = `M'- sqrt(-`cut'*2)*`S'
local phigh =  `M'+ sqrt(-`cut'*2)*`S'
di in gr "Approx quadratic limits for risk parameter  " in ye %7.5f /*
*/`plow' "  " %7.5f `phigh'

* graphs exact and approx llr

        local start = max(1/`length',`M'-`R'*`S')
        local stop= min(1-1/`length',`M'+`R'*`S')

        qui gen param =`start' + (`stop'-`start')*(_n-1)/`length' 
        qui gen true =`d'*ln(param)+`h'*ln(1-param)-`max' 
        qui gen approx =-0.5*((param-`M')/`S')^2 
                if "`null'"!="" {
                local llr = `d'*ln(`null')+`h'*ln(1-`null') - `max'
                }
}
else {
        
* displays exact and approx supported range on logodds scale

        local M =log(`d'/`h')
        local S=sqrt(1/`d'+1/`h')
        local low=log(`low'/(1-`low'))
        local high=log(`high'/(1-`high'))
di in gr "Most likely value for logodds parameter    " in ye %7.5f `M'
di  ""
di in gr "cut-point " in ye `cut'
di in gr "Likelihood based limits for logodds parameter  " in ye %7.5f /*
*/`low' "  " %7.5f `high'
local plow = `M'- sqrt(-`cut'*2)*`S'
local phigh =  `M'+ sqrt(-`cut'*2)*`S'
di in gr "Approx quadratic limits for logodds parameter  " in ye %7.5f /*
*/`plow' "  " %7.5f `phigh'
*graphs exact and approx llr on logodds scale

        qui gen param =`M' - `R'*`S' + 2*`R'*`S'*(_n-1)/`length' 
        
        qui gen true =`d'*param-`N'*ln(1+exp(param))-`max'
        qui gen approx =-0.5*((param-`M')/`S')^2
                if "`null'"!="" {
                local llr = `d'*`null' - `N'*ln(1+exp(`null')) -`max'
                }
}

format param %4.2f

twoway scatter true approx param if true>-5&approx>-4, msymbol(i i) connect(l l) ///
   lcolor(red blue)`yline' `xline' `xlab' t1("`t1'") `ylab' ///
   l1title("log likelihood ratio")

if "`logodds'"!="" {
di ""
di in gr "Back on original risk scale"
local low=exp(`low')/(1+exp(`low'))
local high=exp(`high')/(1+exp(`high'))
local plow=exp(`plow')/(1+exp(`plow'))
local phigh=exp(`phigh')/(1+exp(`phigh'))
local M=exp(`M')/(1+exp(`M'))
di in gr "Most likely value for risk parameter    " in ye %7.5f `M'
di in gr "Likelihood based limits for risk parameter  " in ye %7.5f /*
*/`low' "  " %7.5f `high'
di in gr "Approx quadratic limits for risk parameter  " in ye %7.5f /*
*/`plow' "  " %7.5f `phigh'
}

end

