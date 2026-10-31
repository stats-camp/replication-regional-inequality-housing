
* --------------------------------------------------------------------
* (Optional) install required Python packages in the linked environment
* --------------------------------------------------------------------
* Comment the following block if geopandas/pyproj are there.

python:
import sys, subprocess
subprocess.check_call([sys.executable, "-m", "pip", "install", "geopandas", "pyproj"])
end

* --------------------------------------------------------------------
* Create correspondence file
* --------------------------------------------------------------------


python:
import geopandas as gpd
import pandas as pd
from pathlib import Path

shp2000 = Path(r"data\crosswalks\co99_d00.shp")
shp2018 = Path(r"data\crosswalks\cb_2018_us_county_500k.shp")
outcsv  = Path(r"data\crosswalks\fips_correspondence.csv")

gdf_2000 = gpd.read_file(shp2000)
gdf_2018 = gpd.read_file(shp2018)


if gdf_2000.crs is None: \
	gdf_2000.set_crs('EPSG:4269', inplace=True)
if gdf_2018.crs is None: \
	gdf_2018.set_crs('EPSG:4269', inplace=True)

gdf_2000 = gdf_2000.to_crs(epsg=4326)
gdf_2018 = gdf_2018.to_crs(epsg=4326)


gdf_2000['FIPS'] = gdf_2000['STATE'].astype(str).str.zfill(2) + gdf_2000['COUNTY'].astype(str).str.zfill(3)
gdf_2018['FIPS'] = gdf_2018['STATEFP'].astype(str).str.zfill(2) + gdf_2018['COUNTYFP'].astype(str).str.zfill(3)

overlap_gdf = gpd.sjoin(gdf_2000, gdf_2018, how='inner')

overlap_gdf['overlap_area'] = overlap_gdf.apply( \
	lambda row: row['geometry'].intersection(gdf_2018.loc[row['index_right'], 'geometry']).area, \
	axis=1 \
)

total_overlap = overlap_gdf.groupby('FIPS_right')['overlap_area'].sum().reset_index()
overlap_gdf = overlap_gdf.merge(total_overlap, on='FIPS_right', suffixes=('', '_total'))
overlap_gdf['Weight'] = overlap_gdf['overlap_area'] / overlap_gdf['overlap_area_total']

corr = overlap_gdf[['FIPS_left', 'FIPS_right', 'Weight']].rename( \
	columns={'FIPS_left':'FIPS_2000','FIPS_right':'FIPS_2018'} \
)

corr.to_csv(outcsv, index=False)
print(f"Saved correspondence to {outcsv}")
end
