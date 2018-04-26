capture program drop ACE_psblock
program define ACE_psblock, rclass
capture drop ps 
capture drop psblock
qui logit rfa i.agecat gender i.smoke i.hospital i.nodcat i.mets i.durcat i.diacat ///
i.primary i.position, asis
qui predict ps
qui xtile psblock=ps, nq(4)
qui regress dodp rfa if psblock==1
qui count if psblock==1
local n1=r(N)
local ACE_1=_b[rfa]
forvalues i=2(1)4 {
	qui regress dodp rfa if psblock==`i'
	qui count if psblock==`i'
	local n`i'=r(N)
	local ACE_`i'=_b[rfa]
}
local ACE=(`n1'*`ACE_1'+`n2'*`ACE_2'+`n3'*`ACE_3'+`n4'*`ACE_4')/(`n1'+`n2'+`n3'+`n4')
drop ps psblock
return scalar ACE=`ACE'
end

bootstrap r(ACE), reps(1000): ACE_psblock
