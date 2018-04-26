capture program drop ACE_psadjust
program define ACE_psadjust, rclass
capture drop ps 
capture drop POdiff 
capture drop inter
qui logit rfa i.agecat gender i.smoke i.hospital i.nodcat i.mets i.durcat i.diacat i.primary i.position, asis
qui predict ps
gen inter=rfa*ps
qui logit dodp rfa ps inter
gen POdiff=exp(_b[_cons]+_b[rfa]+_b[ps]*ps+_b[inter]*ps)/(1+exp(_b[_cons]+_b[rfa]+_b[ps]*ps+_b[inter]*ps))-exp(_b[_cons]+_b[ps]*ps)/(1+exp(_b[_cons]+_b[ps]*ps))
qui summ POdiff
local ACE=r(mean)
drop ps POdiff
return scalar ACE=`ACE'
end

bootstrap r(ACE), reps(100): ACE_psadjust
