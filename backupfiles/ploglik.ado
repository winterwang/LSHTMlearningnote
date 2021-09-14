*! version 5.0 mh 10/1/1996
* updated November 2014 SC
cap program drop ploglik
program define ploglik
set varabbrev off
version 10.0

preserve

parse "`*'", parse(" ,")
confirm integer number `1'
local d `1' 
mac shift
local y `1'
mac shift
local options "Lograte Cut(real -1.921) PER(real 1000) *"
parse "`*'"


* checks on zero values

if  (`d' == 0) {
        di in red "not possible because likelihood is infinite"
        exit
}
if  (`y' == 0) {
di in red "needs person-years"
exit
}

local t1 "log likelihood for rate parameter: D = `d' , Y = `y'"
if "`lograte'"!="" {
   local t1 "log likelihood for lograte parameter: D = `d' , Y = `y'"
}

local length  10001
qui set obs `length'
local R = 3.0

local max=`d'*ln(`d'/`y') - `d'

local ylab "ylabel(0 -1  -2 -3 -4 -5 -6)"
local yline "yline(`cut')"
  
if "`xlab'"=="" {
   local xlab=""
}

di ""
di in gr "ALL RATES PER " in ye %7.0f `per'

local M =`d'/`y'
local S=sqrt(`d')/`y'

* finds exact supported range

    scalar r1=0.01*`M'
    scalar r2 = `M'
    scalar f1=`d'*log(r1)-r1*`y' -`max'-`cut'
    scalar f2=`d'*log(r2)-r2*`y' -`max'-`cut'
    scalar f= 1
    scalar tol = 0.0001
    while abs(f)>tol {
      scalar r=(r1+r2)*0.5
      scalar f=`d'*log(r)-r*`y'-`max'  -`cut'
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
    scalar f1=`d'*log(r1)-r1*`y'-`max'-`cut'
    scalar f2=`d'*log(r2)-r2*`y'-`max'-`cut'
    scalar f= 1
    while abs(f)>tol {
      scalar r=(r1+r2)*0.5
      scalar f=`d'*log(r)-r*`y'-`max'-`cut'
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

if "`lograte'"=="" {

* displays exact and approx supported range

di in gr "Most likely value for rate parameter    " in ye %7.2f `M'*`per'
di ""
di in gr "cut-point " in ye `cut'
di in gr "Likelihood based limits for rate parameter  " in ye %7.2f /*
*/`low'*`per' "  " %7.2f `high'*`per'
local plow = `M'- sqrt(-`cut'*2)*`S'
local phigh =  `M'+ sqrt(-`cut'*2)*`S'
di in gr "Approx quadratic limits for rate parameter  " in ye %7.2f /*
*/`plow'*`per' "  " %7.2f `phigh'*`per'

* sets up ready to graph exact and approx llr

  local start = `M'-`R'*`S'
  local stop= `M'+`R'*`S'
  gen param =`start' + (`stop'-`start')*(_n-1)/`length' 
  qui gen true =`d'*ln(param)-`y'*param -`max'
  qui gen approx =-0.5*((param-`M')/`S')^2 
}

else {
        
* displays exact and approx supported range on log scale
local M =log(`d'/`y')
local S=sqrt(1/`d')
local low=log(`low')
local high=log(`high')
di in gr "Most likely value for log rate parameter    " in ye %7.2f `M'+log(`per')
di  ""
di in gr "cut-point " in ye `cut'
di in gr "Likelihood based limits for log rate parameter  " in ye %7.2f /*
   */`low'+log(`per') "  " %7.2f `high'+log(`per')
local plow = `M'- sqrt(-`cut'*2)*`S'
local phigh =  `M'+ sqrt(-`cut'*2)*`S'
di in gr "Approx quadratic limits for log rate parameter  " in ye %7.2f /*
   */`plow'+log(`per') "  " %7.2f `phigh'+log(`per')
        
*sets up ready to graph exact and approx llr on log scale

        qui gen param =`M' - `R'*`S' + 2*`R'*`S'*(_n-1)/`length' 
        qui gen true =`d'*param-`y'*exp(param)-`max'
        qui gen approx =-0.5*((param-`M')/`S')^2
}

format param %7.2f
if "`lograte'"=="" {
   qui replace param=param*`per'
}
else {
   qui replace param=param + log(`per') 
}

twoway scatter true approx param if approx>-2.0 , symbol(i i) connect(l l) /// 
   lcolor(red blue)`yline' `xline' `xlab' t1("`t1'") `ylab' ///
   l1title("log likelihood ratio")

if "`lograte'"!="" {
   di ""
   di in gr "Back on original rate scale"
   local low=exp(`low')
   local high=exp(`high')
   local plow=exp(`plow')
   local phigh=exp(`phigh')
   local M=exp(`M')
   di in gr "Most likely value for rate parameter    " in ye %7.2f `M'*`per'
   di in gr "Likelihood based limits for rate parameter  " in ye %7.2f /*
      */`low'*`per' "  " %7.2f `high'*`per'
   di in gr "Approx quadratic limits for rate parameter  " in ye %7.2f /*
      */`plow'*`per' "  " %7.2f `phigh'*`per'
}

end

