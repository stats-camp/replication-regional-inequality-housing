Package documentation adapted for stats.camp.

Overview

The code in this replication file produces the figures in Howard and Liebersohn (2025), “How Regional Inequality and Migration Drive Housing Prices and Rents.” It uses data from Crone et al. (2006), the historical housing prices project, the 2000 Decennial Census, 2016-2020 American Community Survey, the Consumer Price Index, the FHFA House Price Index, and the BEA’s Regional Accounts. The analysis .do files create the three figures in the paper and can be opened in stats.camp. It runs in less than 1 minute on a desktop computer with 16GB of RAM.

Data Availability and Statement of Rights

All data are publicly available, and the details on each one can be found below.

I certify that the authors of the manuscript have documented permission to redistribute/publish the data contained within this replication package.

Dataset List

All data sources are provided in this replication file.

Name | Data file | Source | Citation | Notes
2016-2020 ACS Median Income | Census_income/nhgis0078_ds249_20205_county | NHGIS | Manson et al. (2025) | Codebook in folder, Downloaded from https://www.nhgis.org/
2000 Census Median Income | Census_income/nhgis0078_ds151_2000_county | NHGIS | Manson et al. (2025) | Codebook in folder, Downloaded from https://www.nhgis.org/
County-to-CBSA correspondence | Crosswalks/county_map_2010 | Penn State Commuting Zones / Labor Markets data repository | Fowler & Jensen (2020) | Downloaded from https://sites.psu.edu/psucz/data/
2000 counties to 2018 counties crosswalk | Crosswalks/fips_correspondence | Created by program |  |
2000 county FIPS shapefile | Crosswalks/co99_d00.* | US Census Bureau | U.S. Census Bureau. (2025a) | Downloaded from https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.2000.html#list-tab-1556094155
2018 county FIPS shapefile | Crosswalks/cb_2018_us_county_500k.* | US Census Bureau | U.S. Census Bureau. (2025b) | Downloaded from https://www.census.gov/geographies/mapping-files/2018/geo/carto-boundary-file.html
County-to-MSA crosswalk | Crosswalks/geocorr2000_05AUG1703192 | Missouri Census Data Center GEOCORR | Missouri Census Data Center (2025) | Downloaded from https://mcdc.missouri.edu/applications/geocorr2000.html
County-to-CBSA crosswalk | Crosswalks/geocorr2018_2420707162 | Missouri Census Data Center GEOCORR | Missouri Census Data Center (2025) | Downloaded from https://mcdc.missouri.edu/applications/geocorr2018.html
Land Area | Elast/geocorr2000_landareas | Missouri Census Data Center GEOCORR | Missouri Census Data Center (2025) | Downloaded from https://mcdc.missouri.edu/applications/geocorr2000.html
Housing Supply | Elast/HOUSING_SUPPLY.dta | Saiz (2010) | Saiz (2010) | Downloaded from https://urbaneconomics.mit.edu/research/data
FHFA House Price Index | Hpi/hpi_at_bdl_county.xls | FHFA | Federal Housing Finance Agency (2025) | Downloaded from https://www.fhfa.gov/data/hpi/datasets
BEA Regional GDP and Personal Income | Inequality_and_rent/CAINC__ALL_AREAS_1969_2022 | BEA | U.S. Bureau of Economic Analysis (2023) | Downloaded from https://www.bea.gov/itable/regional-gdp-and-personal-income
Crone et al. (2006) rent series | Inequality_and_rent/croneetal.xls | Crone et al. (2006) | Crone et al. (2006) | Copied by hand from Crone et al. (2006) Table 7
CPI Rent Series | Inequality_and_rent/fredgraph.csv | FRED | Bureau of Labor Statistics (2024) | See instructions below.*
Historical House Price Project Rent Series | Inequality_and_rent/hhp-national-indices | Historical House Price Project | Lyons et al. (2024) | https://www.philadelphiafed.org/-/media/frbp/assets/data-visualizations/historical-housing-prices/hhp-national-indices.xlsx
2000 population data | Populations/nhgis0074_ds146_2000_county | NHGIS | Manson et al. (2025) | Downloaded from https://www.nhgis.org/
2018 population data | Populations/popdata.dta | SEER | National Cancer Institute,  (2025) | Downloaded from https://seer.cancer.gov/popdata/2025
2000 Census Rent | Rent/nhgis0075_ds51_2000_county.csv | NHGIS | Manson et al. (2025) | Downloaded from https://www.nhgis.org/
2016-2020 ACS Median Rent | Rent/nhgis0077_ds249_20205_county.csv | NHGIS | Manson et al. (2025) | Downloaded from https://www.nhgis.org/
 | Combined_data_cbsa.dta | Created by program |  |
 | Combined_data_county.dta | Created by program |  |

*CPI Rent Series Additional Instructions

To download the data in Inequality_and_rent/fredgraph.csv, go to https://fred.stlouisfed.org/series/CUUR0000SEHA, the “Consumer Price Index for All Urban Consumers: Rent of Primary Residence in U.S. City Average.” Click “Edit Graph.” Under “Customize Data,” enter “CPIAUCSL” and click the “Add” button. In the formula box, type “a/b” and click “Apply Formula.” Click “Download” and choose “CSV (data)”

Computational Requirements

Run the analysis .do files with stats.camp; preprocessing uses Python 3.13.3. It does not require the installation of any additional packages.

The entire folder is under 500 MB.

All the code ran in about 1 minute on a Windows desktop with 16GB of RAM.

Description of Programs

Five .do files can be found in the folder dofiles.  A brief description of each follows:

merge_data: cleans data and creates data/combined_data_cbsa and data/combined_data_county

import_elast_cbsa: cleans the elasticity data and creates data/elast/elast_by_cbsa

figures: creates Figure 1a-d (exhibits/medinc_growth_inc, hpi_growth_inc, rent_growth_inc, pop_growth_inc).

elast_figures: creates Figure 3a-b (exhibits/WRLURI_inc, logpopdensity_inc)

inequality_and_rent_cbsa: cleans time series data and creates Figure 5 (exhibits/inequality_and_rent_robust)

Instructions to Replicators

Set the working directory to the repository root in stats.camp.

Run main.do.

Note to Replicators

Figures 1a and 1c may include 55 on the x-axis label when replicating those graphs. The actual content of the graphs will be the same as in the published version.

List of tables and programs

Figure | Name and location of figure | Do file that creates figure
Figure 1 | exhibits/medinc_growth_inc.pdf, exhibits/hpi_growth_inc.pdf, exhibits/rent_growth_inc.pdf, exhibits/pop_growth_inc.pdf | figures.do
Figure 3 | exhibits/WRLURI_inc.pdf, exhibits/logpopdensity_inc.pdf | elast_figures.do
Figure 5 | exhibits/inequality_and_rent_robust.pdf | Inequality_and_rent_cbsa.do

Note that Figures 2 and 4 do not use data.

References

Crone, Theodore M, Leonard I Nakamura, and Richard Voith, Data for: “Rents have been rising, not falling, in the postwar period,” The Review of Economics and Statistics, 2010, 92 (3), 628–642.

Federal Housing Finance Agency, “County House Price Index (HPI),” https://www.fhfa.gov/DataTools/Downloads/Pages/House-Price-Index-Datasets.aspx 2025. Accessed May 2025.

Fowler, C. S., & Jensen, L. (2020). Data for: “Bridging the gap between geographic concept and the data we have: The case of labor markets in the USA. Environment and Planning A: Economy and Space”, 52(7), 1395–1414. https://doi.org/10.1177/0308518X20906154

Lyons, Ronan C, Allison Shertzer, Rowena Gray, and David N Agorastos, Data for: “The Price of Housing in the United States, 1890-2006,” Technical Report, National Bureau of Economic Research 2024. https://www.philadelphiafed.org/-/media/frbp/assets/data-visualizations/historical-housing-prices/hhp-national-indices.xlsx

Manson, Steven, Jonathan Schroeder, David Van Riper, Katherine Knowles, Tracy Kugler, Finn Roberts, and Steven Ruggles, “IPUMS National Historical Geographic Information System: Version 19.0,” 2025. [dataset].

Missouri Census Data Center, “Geographic Correspondence Engine and Files,” https://mcdc.missouri.edu/applications/geocorr.html 2025. Accessed May 2025.

National Cancer Institute Surveillance, Epidemiology, and End Results (SEER) Program. 1969–2022. U.S. County Population Estimates: 19 Age Groups, White | Black | Other (Adjusted) — All States Combined. Bethesda, MD: National Cancer Institute, Division of Cancer Control and Population Sciences. https://seer.cancer.gov/popdata.thru.2022/yr1969_2022.19ages/us.1969_2022.19ages.adjusted.txt.gz (accessed July 8 2025).

Saiz, Albert, Data for: “The geographic determinants of housing supply,” The Quarterly Journal of Economics, 2010, 125 (3), 1253–1296.

U.S. Bureau of Economic Analysis, “Regional GDP and Personal Income,” 2023. Accessed: 2023-10-31.

U.S. Bureau of Labor Statistics. 2024a. Consumer Price Index for All Urban Consumers: Rent of Primary Residence (CUUR0000SEHA). Distributed by Federal Reserve Bank of St. Louis. https://fred.stlouisfed. org/series/CUUR0000SEHA (accessed June 3, 2024).Federal Reserve Bank of St. Louis, “FRED Economic Data,” https://fred.stlouisfed.org/graph/?g=1IZBh 2024. Accessed May 2025.

U.S. Census Bureau. (2025). Cartographic Boundary Shapefiles – 2000 [Shapefile]. U.S. Census Bureau. Retrieved May 21, 2025, from U.S. Census Bureau Cartographic Boundary Files website: Cartographic Boundary Shapefiles – 2000 webpage

U.S. Census Bureau. (2025). Cartographic Boundary Shapefiles – 2018 [Shapefile]. U.S. Census Bureau. Retrieved May 21, 2025, from U.S. Census Bureau Cartographic Boundary Files website: Cartographic Boundary Shapefiles – 2018 webpage
