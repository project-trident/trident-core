# Download Statistics
File download statistics from the package server. The raw statistics files are contained in this directory, tagged by year/month. 

### These stats do **not** account for things like: 
* Mirror sites which host ISO files
* Mirror sites which host package files

### Notes about stats
* The number of times the repository packagesite.txz file is downloaded is a good estimation of the number of systems which were being actively used/updated
* The number of times that the FreeBSD-runtime-* or trident-core package(s) gets downloaded is a good estimate of how many systems were upgraded to that particular version.

## Version Summaries
| Version | Date Released | #Days Available | ISO Downloads | Update Downloads | Notes
|:-----:|:-----:|:-----:|:-----:|:-----:|:----:|
| 18.06-BETA1 | 8/31/2018 | 7 | - | - | First public version. Pre-download tracking |
| 18.06-BETA2 | 9/6/2018 | 19 | 52676 | 83 | Most of the downloads were from the same users. Working out mirroring solutions |
| 18.06-BETA3 | 9/25/2018 | 13 | 18933 | 0 | Updates from BETA2 via trueos-update were completely broken. |
| 18.06-RC1 | 10/08/2018 | 9 | ? | ? | Download stats from October corrupted/unknown
| 18.06-RC2 | 10/17/2018 | 24 | (1239 in Nov) | ? | Download stats from October corrupted/unknown
| 18.11-RC3 | 11/10/2018 | 13 | 25173 | 79 |
| 18.11-PRERELEASE | 11/23/2018 | 8 | 2958 | ? |
| 18.11-PRERELEASE_2 | 12/1/2018 | 10 | 26317 | ? |
| 18.12-PRERELEASE | 12/11/2018 | 8 | 176432 | ? |
| 18.12-PRERELEASE2 | 12/19/2018 | | (38556 Dec) | ? |
| 18.12-RELEASE | | | | |

## Monthly Summaries
| Month | Days | Number of days | Unique Users | Files Downloaded | Repo Manifest (#Systems) | Notes |
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:---:|
|2018, 09| 5-30 | 27 | 2282 | 336470 | 14798 |
|2018, 10| 1-31 | 31 | ? | ? | ? | logfile empty - nginx was not saving stats. Auto-nginx restart put in place every month to prevent this again.
|2018, 11| 7-30 | 24 | 4946 | 24755 | 4872 | First 6 days of Nov included in the error from last month. Logfiles automatically turn over fine on the 1st of every month now (verified on Dec 1).
|2018, 12| 1-31 | 31 | 3610 | 635864 | 11280 (from 13.0) 481 (from 12.0) |
