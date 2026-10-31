// 2000 to 2018 FIPS correspondence
import delimited "data\crosswalks/fips_correspondence.csv", clear 
drop if floor(fips_2000/1000)==72 | floor(fips_2018/1000)==72
collapse (sum) weight, by(fips_2000 fips_2018)
tempfile corr
save `corr'

//
// import 2000 data and turn FIPS into 2018-basis
//

// 2000 rents
import delimited "data\rent\nhgis0075_ds151_2000_county.csv", clear 
gen fips = 1000*statea + countya 
keep fips gbo001 
rename gbo001 rent_2000
tempfile rent2000
save `rent2000'

// 2000 census data population
import delimited "data\populations\nhgis0074_ds146_2000_county.csv", clear 
gen fips = 1000*statea + countya 
keep fips fl5001 
rename fl5001 pop_2000
tempfile pop2000
save `pop2000'

// 2000 census data median income
import delimited "data\census_income\nhgis0078_ds151_2000_county.csv", varnames(1) rowrange(2) clear 
gen fips = 1000*statea + countya 
rename gmy001 medinc_2000
tempfile medinc2000
save `medinc2000'

merge 1:1 fips using `pop2000', nogen
merge 1:1 fips using `rent2000', nogen

// correspondence file
// QCEW data missing from two FIPS (15005 and 5160) which appear in correspondence file.
rename fips fips_2000
merge 1:m fips_2000 using `corr', keep(1 3) nogen
replace pop_2000 = pop_2000*weight
collapse (rawsum) pop_2000 (mean) medinc_2000 rent_2000 /*wage pay */ [w=weight], by(fips_2018)
rename fips_2018 fips
tempfile data_2000
save `data_2000'


//
// import 2018 data
//

infix ///
    int   year        1-4   ///   1969, 1970, …
    str2  state       5-6   ///   AL, AK, …
    byte  stfips      7-8   ///   01 → 1
    int   cofips      9-11  ///   001 → 1
    byte  registry   12-13  ///   99 = "all registries"
    byte  race        14    ///
    byte  origin      15    ///
    byte  sex         16    ///
    byte  age        17-19  ///
    long  population 20-26  ///
	using "data\populations\us.1969_2022.19ages.adjusted.txt", clear
	
gen fips = 1000*stfips +cofips
keep if year==2018
collapse (sum) population, by(fips)
rename population pop_2018
replace fips = 2158 if fips==2270
replace fips = 46102 if fips==46113
replace fips = 51019 if fips==51917
// FIPS 15005 does not appear in the 2018 qcew data
tempfile pop2018
save `pop2018'

// 2016-2020 ACS rent
import delimited "data\rent\nhgis0077_ds249_20205_county.csv", clear 
gen fips = 1000*statea + countya 
keep fips amvze001
rename amvze001 rent_2018
tempfile rent2018
drop if floor(fips/1000)==72
save `rent2018'


// 2016-2020 ACS median income
import delimited "data\census_income\nhgis0078_ds249_20205_county.csv", varnames(1) rowrange(2) clear 
gen fips = 1000*statea + countya 
rename amr8e001  medinc_2018
tempfile medinc2018
save `medinc2018'


// get HPI
import excel "data\hpi\hpi_at_bdl_county.xlsx", sheet("county") cellrange(A7:H100439) firstrow clear
keep FIPScode HPI Year
rename *, lower
destring year fips, replace
keep if inlist(year,2000,2018)
reshape wide hpi, i(fips) j(year)
rename hpi* hpi_*
destring hpi*, replace
rename fipscode fips
tempfile hpi
save `hpi'


// merge 20018 population data
use `pop2018', clear
merge 1:1 fips using `rent2018', nogen
merge 1:1 fips using `medinc2018', nogen

// merge with 2000 data
merge 1:1 fips using `data_2000', keep(3) nogen 
merge 1:1 fips using `hpi', nogen 

aorder _all


save "data/combined_data_county", replace 


// import to CBSAs
import delimited "data\crosswalks/county_map_2010.csv", varnames(1) rowrange(2) clear 

// for 2010 definitions
keep fips out10 pop10 cbsa10
rename cbsa10 cz
replace fips = 2158 if fips==2270
replace fips = 46102 if fips==46113
drop if fips==51515
merge 1:1 fips using "data/combined_data_county"

gen hpi_growth = log(hpi_2018)-log(hpi_2000)
gen rent_growth = log(rent_2018)-log(rent_2000)

egen num_miss = rowmiss(pop_* rent_* /*wage_**/ hpi_* medinc_*)
drop if num_miss>0

collapse ///
	(rawsum) pop_* ///
	(mean) medinc* hpi* rent* ///
	[w=pop_2000 ], by(cz)
	
save  data/combined_data_cbsa, replace

