/**********************************************************************
* Howard and Liebersohn (2025)
* Description: Main do file, calls other do files
**********************************************************************/

// create a 2000-2018 county correspondence file
do "dofiles/fips_2000_2018_correspondence"

// merge main datasets and save as a county and cbsa level file with populations, incomes, rents
do "dofiles/merge_data.do"

// add elasticities and save msa-level file
do "dofiles/import_elast_cbsa.do"

// create fig 1 
do "dofiles/figures.do"

// create fig 3
do "dofiles/elast_figures.do"



do "dofiles/inequality_and_rent_cbsa" //Generate Figure 4, "inequality_and_rent_robust.pdf"