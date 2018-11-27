# Download Statistics
File download statistics from the package server. The raw statistics files are contained in this directory, tagged by year/month. 

### These stats do **not** account for things like: 
* Mirror sites which host ISO files
* Mirror sites which host package files

### Notes about stats
* The number of times the repository packagesite.txz file is downloaded is a good estimation of the number of systems which were installed
* The number of times that the FreeBSD-runtime-* or trident-core package(s) gets downloaded is a good estimate of how many systems were upgraded to that particular version.

## Version Summaries
| Version | Date Released | #Days Available | ISO Downloads | Update Downloads | Notes
|:-----:|:-----:|:-----:|:-----:|:-----:|:----:|
| 18.06-BETA1 | 8/31/2018 | 7 | - | - | First public version. Pre-download tracking |
| 18.06-BETA2 | 9/6/2018 | 19 | 52676 | 83 | Most of the downloads were from the same users. Working out mirroring solutions |
| 18.06-BETA3 | 9/25/2018 | 13 | 18933 | 0 | Updates from BETA2 via trueos-update were completely broken. |
| 18.06-RC1 | 10/08/2018 | 9 | ? | ? | Download stats from October corrupted/unknown
| 18.06-RC2 | 10/17/2018 | 24 | ? | ? | Download stats from October corrupted/unknown
| 18.11-RC3 | 11/10/2018 | 13 | | |
| 18.11-PRERELEASE | 11/23/2018 | | | |

## Monthly Summaries
| Month | Days | Number of days | Unique Users | Files Downloaded | Repo Manifest (#Systems) | Notes |
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:---:|
|2018, 09| 5-30 | 27 | 2282 | 336470 | 14798 |
|2018, 10| 1-31 | 31 | ? | ? | ? | logfile empty - nginx was not saving stats. Auto-nginx restart put in place every month to prevent this again.
