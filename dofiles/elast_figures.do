
// calculate data on basis of FIPS codes
use "data\elast\elast_by_cbsa", clear

cap log close
log using "logbooks/elast_figures_log", text replace

gen logpop = log(pop_2000)

gen logpopdensity = log(popdensity)
label var logpopdensity "Log 2000 Population per Sq Mi"
label var logpop "Log 2000 Population"

label var elast "Elasticity"
label var unaval "Unavailable Land Share"
label var WRLURI "Wharton Regulatory Index"

replace medinc_2000=medinc_2000/1000

local rhsvar medinc_2000
sort `rhsvar'


// put the areas without an elasticity at the 10th most inelastic in the distribution
qui sum elast, det
replace elast = `=r(p90)' if msanecma==9999
qui sum unaval, det
replace unaval = `=r(p10)' if msanecma==9999
qui sum WRLURI, det
replace WRLURI = `=r(p10)' if msanecma==9999

cap graph drop _all
foreach var of varlist logpopdensity WRLURI {
	reg `var' `rhsvar' [w=pop_2000], r
*	pause
	local variance = e(V)[1,1]
	local sd = sqrt(`variance')
	local beta = strofreal(`=_b[`rhsvar']',"%5.4f")
	local t = strofreal(`=`beta'/`sd'',"%5.4f")
	local sd = strofreal(`sd',"%5.4f")
	
	local varlab : var label `var'
	
	qui sum `var' [w=pop_2000], det
	local bottom = r(p5)
	local top = r(p95)
	
	qui sum `rhsvar' [w=pop_2000], det
	local rhstop = r(p5)
	local rhsbottom = r(p95)
	
	cap drop smooth
	lpoly `var'  `rhsvar' [w=round(pop_2000)] if msanecma!=9999, degree(1) bwidth(10) gen(smooth) at(`rhsvar') nograph
	
	cap drop inrange
	gen inrange = inrange(`var',`bottom',`top') & inrange(`rhsvar',`rhstop',`rhsbottom') 
	
		
	scatter `var'  `rhsvar' if inrange & msanecma!=9999 [aw=pop_2000] , msize(tiny)  mlstyle(none)  mcolor(blue%65) name(sc1_`var', replace) ///
		|| line smooth  `rhsvar' if inrange, xlabel(, labsize(large)) ylabel(, labsize(large))  ///
			lcolor(black%50) legend(off)   xtitle("Median Household Income, 2000 (th)", size(vlarge)) ytitle("`varlab'", size(vlarge))
	local namelist "`namelist' sc1_`var'"
*	graph export data/`var'_inc.png, replace name(sc1_`var')
	graph export "exhibits/`var'_inc.pdf", replace name(sc1_`var')
}


// fit line slopes
reg logpopdensity medinc_2000 [w=pop_2000]
reg WRLURI medinc_2000 [w=pop_2000]
reg WRLURI medinc_2000 [w=pop_2000], beta
sum WRLURI[w=pop_2000], det

log close