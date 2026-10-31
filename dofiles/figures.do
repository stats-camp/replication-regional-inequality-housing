use "data/combined_data_cbsa", clear

cap log close
log using "logbooks/figures_log", text replace 

gen inc_growth = log(medinc_2018 )-log(medinc_2000 )
gen loginc_2000 = log(medinc_2000 )

reg inc_growth loginc_2000 [w=pop_2000 ], r

rename inc_growth medinc_growth
gen pop_growth = log(pop_2018)-log(pop_2000)

// growth statistics by deciles of income
xtile medinc_2000_pctile = medinc_2000 [w=pop_2000], n(100)
gen medinc_growth_pct = exp(medinc_growth)*100
sum medinc_growth_pct [w=pop_2000] if inrange(medinc_2000_pctile ,90,100)
sum medinc_growth_pct [w=pop_2000] if inrange(medinc_2000_pctile ,0,50)

// distribution of growth
gen pop_growth_pct = exp(pop_growth)
sum pop_growth_pct [w=pop_2000], det

replace medinc_2000=medinc_2000/1000


local rhsvar medinc_2000


label var pop_growth "Population Growth, 2000-2018"
label var medinc_growth "Income Growth, 2000-2018"
label var rent_growth "Rent Growth, 2000-2018"
label var hpi_growth "House Price Growth, 2000-2018"

sort `rhsvar'

* Initialize the cbsaname variable as empty strings
gen cbsaname = ""

* Assign city names based on the cbsa codes
destring cz, gen(cbsa) force
replace cbsaname = "Houston" if cbsa == 26420
replace cbsaname = "Dallas" if cbsa == 19100
replace cbsaname = "Detroit" if cbsa == 19820
replace cbsaname = "Washington DC" if cbsa == 47900
replace cbsaname = "San Francisco" if cbsa == 41860
replace cbsaname = "Las Vegas" if cbsa == 29820
replace cbsaname = "Austin" if cbsa == 12420
replace cbsaname = "Phoenix" if cbsa == 38060
replace cbsaname = "San Jose" if cbsa == 41940
replace cbsaname = "Los Angeles" if cbsa == 31080

cap graph drop _all
foreach var of varlist pop_growth medinc_growth hpi_growth rent_growth  {
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
	lpoly `var'  `rhsvar' [w=round(pop_2000)], degree(1) bwidth(10) gen(smooth) at(`rhsvar') nograph
	
	cap drop inrange
	gen inrange = inrange(`var',`bottom',`top') & inrange(`rhsvar',`rhstop',`rhsbottom')
	scatter `var'  `rhsvar' if inrange [aw=pop_2000], msize(tiny)  mlstyle(none)  mcolor(blue%65) name(sc1_`var', replace) xlabel(, labsize(large)) ylabel(, labsize(large)) ///
		|| scatter `var'  `rhsvar' if inlist(cz,"12420","31080") [aw=pop_2000], msize(medium)  mlstyle(none)  mcolor(dkgreen)  ///
		|| line smooth  `rhsvar' if inrange, ///
			lcolor(black%50) legend(off)  ytitle(`var', size(large)) xtitle("Median Household Income, 2000 (th)", size(vlarge)) ytitle("`varlab'", size(vlarge)) ///
		|| scatter `var' `rhsvar'  if inlist(cz,"12420"), msymbol(i) mlab(cbsaname) mlabsize(vlarge) mlabposition(2) mlabcolor(dkgreen) mlabsize(medium) ///
		|| scatter `var' `rhsvar'  if inlist(cz,"31080"), msymbol(i) mlab(cbsaname)  mlabgap(12pt) mlabsize(vlarge) mlabposition(1) mlabcolor(dkgreen) mlabsize(medium) 

	graph export "exhibits/`var'_inc.pdf", replace name(sc1_`var')
	
}

// statistics for the discussion
format *_2000 *_2018 *_growth %20.0fc
format *_growth %5.4fc
list medinc_2000 medinc_growth pop_growth hpi_growth if cz=="12420"
list medinc_2000 medinc_growth pop_growth hpi_growth if cz=="31080"
// CPI over this time is about 50% (from FRED CPIAUCSL)
di exp(.426)
di exp(.5007)
di exp(.51)
di exp(.552)
di exp(.072)
di exp(0.8058)-0.5
di exp(.958)-0.5

// calculate how many cities have negative population growth and what their growth is
gen negative_pop_growth = pop_growth<0
sum negative_pop_growth [w=pop_2000 ]
sum pop_growth if negative_pop_growth [w=pop_2000 ], det

// statistics for discussion of population growth
xtile inc_pctile=medinc_2000 [w=pop_2000], n(100)
sum pop_growth if inc_pctile>=80 [w=pop_2000]
sum pop_growth if inrange(inc_pctile,20,40) [w=pop_2000]
sum pop_growth if inrange(inc_pctile,40,60) [w=pop_2000]

log close