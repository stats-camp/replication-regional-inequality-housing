# Replication: How Regional Inequality and Migration Drive Housing Prices and Rents

Gregory Howard and Jack Liebersohn — *Journal of Economic Perspectives (2025)*.

This [stats.camp](https://stats.camp) repository preserves official AEA deposit
**230944, version V1**, for replication and engine compatibility testing.
**Status: executed on 2026-10-16 and again on 2026-10-17 with the native stats.camp engine from scratch copies; the package runs end to end.** The analysis do-files retain their original commands, paths, whitespace, encoding, and line endings.

## The study

Connects rising regional income inequality and migration to national and local housing rents and prices, using US county and metropolitan-area data.

## Contents and entry points

The complete archive is retained, including source shapefiles and the 454 MB SEER population text file. A later audit may run the figure scripts directly on supplied analysis data, but doing so must be reported as analysis-only replication rather than a complete preprocessing run.

The original archive contains **52 original files** totaling
**501,837,730 bytes**. The source ZIP is
102,132,199 bytes. Research data and code are retained. Accompanying notes are adapted for stats.camp;
source documentation and preparation records are maintained separately.

Entry points for inspection:

- [main.do](main.do)
- [dofiles/figures.do](dofiles/figures.do)
- [dofiles/elast_figures.do](dofiles/elast_figures.do)
- [dofiles/inequality_and_rent_cbsa.do](dofiles/inequality_and_rent_cbsa.do)

Package documentation adapted for stats.camp:

- [Readme.txt](Readme.txt)

## Setup and current scope

The master uses relative paths and should be launched from the repository root. Its first stage regenerates county crosswalks using embedded Python/geopandas; the authors specify Python 3.13.3. The deposit also includes the crosswalks, combined analysis data, reference figures, and logs. Those outputs are preserved and have not been regenerated.

The 2026-10-16 runs used scratch copies, so the figures, logs and intermediate
datasets in this repository are still the authors' deposited reference material.

Large raw source files are stored with **Git LFS**: `data/populations/us.1969_2022.19ages.adjusted.txt`. After cloning, run `git lfs install --local` and `git lfs pull` to materialize them. GitHub source ZIPs may contain pointers rather than these payloads.

## Inspect in stats.camp

These links open the deposited files for inspection. They do not establish
that the preserved paths, dependencies, or commands are executable in the browser.

- [main.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-regional-inequality-housing.git&file=main.do)
- [dofiles/figures.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-regional-inequality-housing.git&file=dofiles%2Ffigures.do)
- [dofiles/elast_figures.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-regional-inequality-housing.git&file=dofiles%2Felast_figures.do)
- [dofiles/inequality_and_rent_cbsa.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-regional-inequality-housing.git&file=dofiles%2Finequality_and_rent_cbsa.do)

## Source integrity and attribution

- [Official deposit](https://www.openicpsr.org/openicpsr/project/230944/version/V1/view)
- [Deposit DOI](https://doi.org/10.3886/E230944V1)

Archive: `230944-V1.zip`. SHA-256:
`06f71230ade59c1dbe7411c465c382ed947e500059b7d25072069826bcbc5158`.

All original file hashes were checked after extraction. `.gitattributes` disables
Git line-ending normalization to preserve deposited bytes. Empty folders are
represented by `.gitkeep` files. The root README and Git attributes are stats-camp additions.

The archive contains no separate LICENSE file. The authors’ rights and provenance statements are retained in the adapted notes; this mirror does not add a license or replace those terms.

The study, code, and data remain credited to Gregory Howard and Jack Liebersohn; stats-camp maintains
this mirror and its preparation documentation.
