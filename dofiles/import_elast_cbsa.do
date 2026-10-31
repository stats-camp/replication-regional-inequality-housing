
// elasticities and WRLURI
use "data\elast\HOUSING_SUPPLY.dta", clear
// fix codes for necmas
replace msanecma=msanecma-3 if mod(msanecma,10)==3
replace msanecma = 1305 if msanecma==1300
rename population saiz_population
rename msaname name
tempfile elast
save `elast'

// get land area from geocorr
import delimited "data\elast\geocorr2000_landareas.csv", varnames(1) rowrange(3) clear
keep msacmsa pmsa landsqmi
tempfile land
save `land'

// other data is in county format, which we need to merge to msa/pmsa
import delimited "data\crosswalks/geocorr2000_05AUG1703192.csv", varnames(1) rowrange(3) clear // import correspondence file
merge m:1 msacmsa pmsa using `land', nogen
destring afact* county* msacmsa pmsa, replace
gen msanecma = msacmsa
replace msanecma = pmsa if !missing(pmsa)
merge m:1 msanecma using  `elast', nogen

// merge with other (county-level) data
preserve 
use "data/combined_data_county", clear
keep pop_2000 medinc_2000 fips county
rename county countyname
destring _all, replace
tempfile county_data
save `county_data'
restore
rename county02 fips
replace fips = 2158 if fips==2270
replace fips = 46102 if fips==46113
replace fips = 2195 if fips==2201
replace fips = 2275 if fips==2280
drop if fips==51515
merge m:1 fips using `county_data'
drop if fips==2198

// all areas without an elasticity get put in a single MSA
replace msanecma = 9999 if missing(elast)

replace pop_2000 = pop_2000*afact2

collapse (first) landsqm name (rawsum) pop_2000 (mean) medinc*  (first) unaval lu* WRLURI FLAT_SHARE_50_15 S_LAND_50 elasticity [w=afact], by(msanecma)

destring landsqmi pop_2000, replace
gen popdensity = pop_2000/landsqmi

gsort -popdensity

save data\elast\elast_by_cbsa, replace