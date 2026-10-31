/**********************************************************************
* Howard and Liebersohn (2025)
* Description: Generate Figure 4, "inequality_and_rent_robust.pdf"
**********************************************************************/

// Load and adjust Crone et al. rent series
clear 
import excel "data/inequality_and_rent/croneetal", firstrow
gen adjustment = crone / BLS
summ adjustment if year == 2000
replace adjustment = adjustment / r(mean)
tempfile croneetal
save `croneetal'

// Load historical housing project rent index
clear
import excel "data/inequality_and_rent/hhp-national-indices", firstrow
tempfile rent_history
save `rent_history'

// Load county-to-CBSA crosswalk
clear 
import delimited "data/crosswalks/geocorr2018_2420707162", rowr(3)
keep county14 cbsa10
rename county14 county
tempfile crosswalk
save `crosswalk'

// Load and normalize FRED rent series
clear
import delimited "data/inequality_and_rent/fredgraph"
gen year = substr(date, 1, 4)
destring year, replace force
collapse cuur, by(year)
keep if year >= 1969
sort year
summ cuur if year == 1969
replace cuur = cuur / r(mean)
tempfile rent
save `rent'

// Load BEA income data
clear
import delimited "data/inequality_and_rent/CAINC1__ALL_AREAS_1969_2022"
destring v*, replace force

// Reshape income data to long form
reshape long v, i(geofips geoname region tablename linecode industryclassification description unit) j(year)
replace year = year + 1960

// Keep personal income (linecode 3) and population (linecode 2)
keep if linecode == 3 | linecode == 2

// Extract county codes and clean
gen county = substr(geofips, 3, 5)
destring county, replace force
drop if county > 57000 | county < 1000
drop if mod(county, 1000) == 0

drop description unit
reshape wide v, i(county year) j(linecode)
rename v2 pop
rename v3 pcpi

// Merge with CBSA crosswalk and collapse to CBSA-year
merge m:1 county using `crosswalk'
replace cbsa10 = county * 1000 if cbsa10 == .
collapse (mean) pcpi (sum) pop, by(cbsa10 year)

// Generate smoothed log PCPI series
gen logpcpi = log(pcpi)
xtset cbsa10 year
local window = 2
tssmooth ma moving_average = logpcpi, window(`window' 1 0)
replace moving_average = . if year < 1969 + `window'

// Quick visual check of raw trends
//scatter logpcpi year [w=pop], msize(.01) jitter(2)

// Collapse to annual cross-sectional std dev
collapse (sd) sd_logpcpi = moving_average [w=pop], by(year)

// Merge in rent series and set panel
merge 1:1 year using `rent'
tset year

label var cuur "Real CPI Rent Index (left axis)"
label var sd_logpcpi "Std. Dev. of Log Per Capita Personal Income (right axis)"

// Merge alternative rent series
merge 1:1 year using `rent_history', gen(_merge2)
merge 1:1 year using `croneetal', gen(_merge3)

// Construct comparable indices
replace adjustment = 1 if year > 2001
summ rl_pw_rpi_b_1890 if year == 2006
local hist_mean = r(mean)
summ cuur if year == 2006
local rent_mean = r(mean)

gen history_rent = rl_pw_rpi_b_1890 * `rent_mean' / `hist_mean'
gen crone_rent = cuur * adjustment
label var crone_rent "Rent Index with Crone et al. (2010) Adjustment (left axis)"
label var history_rent "Rent Index from Historical Housing Prices Project (left axis)"

// Final plot combining all rent measures with inequality
line cuur year if year > 1968 || ///
     line sd_logpcpi year if year > 1968, yaxis(2) yscale(range(.2) axis(2)) || ///
     line history_rent year if year > 1968, lcolor(dkgreen) lpattern(dot) || ///
     line crone_rent year if year > 1968, lcolor(dkgreen) lpattern(dash) ///
     legend(col(1)) ytitle("", axis(1)) ytitle("", axis(2)) ///
     yscale(range(.16 .2) axis(2)) ylabel(#5, axis(2))

graph export "exhibits/inequality_and_rent_robust.pdf", as(pdf) replace
