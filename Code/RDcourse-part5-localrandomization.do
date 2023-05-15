********************************************************************************
**  Part 6: Local Randomization RD Analysis
** Author: Rocio Titiunik, Matias Cattaneo, Sebastian Calonico
** Last update: May 2023
********************************************************************************
** RDROBUST:  net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
** RDLOCRAND: net install rdlocrand, from(https://raw.githubusercontent.com/rdpackages/rdlocrand/master/stata) replace
** RDDENSITY: net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
** RDPOWER:   net install rdpower, from(https://raw.githubusercontent.com/rdpackages/rdpower/master/stata) replace
*********************************************************************************
*-------------------------------------------------------------------------------------------------------------*
** SOFTWARE WEBSITE: https://rdpackages.github.io/rdrobust/
*-------------------------------------------------------------------------------------------------------------*
cd C:\Users\titiunik\Dropbox\teaching\workshops\2022-08-RD-StatisticalHorizons\slides-and-codes\data-and-codes
clear
clear all
clear matrix
cap log close
set more off

use "senate.dta", clear

rename demmv X
rename demvoteshfor2 Y

gen Z=.
replace Z=0 if X<0 & X!=.
replace Z=1 if X>=0 & X!=.
label var Z "Democratic Win at t"

order X Y Z

*--------------------------------------------*
* Local Randomization RD Approach *
*--------------------------------------------*
* Code snippet 1, Using rdrandinf in the Ad-hoc Window
rdrandinf Y X, wl(-0.75) wr(0.75) seed(50)

* Code snippet 2, Using rdrandinf in the Ad-hoc Window with the Bernoulli Option
gen bern_prob=1/2 if abs(X)<=0.75
rdrandinf Y X, wl(-0.75) wr(0.75) seed(50) bernoulli(bern_prob)

* Code snippet 3, Using rdrandinf in the Ad-hoc Window with the Kolmogorov-Smirnov Statistic
rdrandinf Y X, wl(-0.75) wr(0.75) seed(50) statistic(ksmirnov)

* Code snippet 4, Using rdrandinf in the Ad-hoc Window with the Confidence Interval Option
rdrandinf Y X, wl(-0.75) wr(0.75) seed(50) ci(0.05 -10(0.25)10)

* Code snippet 5, Using rdwinselect with the wobs Option
global covs "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
rdwinselect X $covs, seed(50) wobs(2) 

* Code snippet 6, Using rdwinselect with the wobs, nwindows and plot Options
global covs "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
rdwinselect X $covs, seed(50) wobs(2) nwindows(100) plot approximate 

* Code snippet 7, Using rdwinselect with the wstep and nwindows Options
global covs "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
rdwinselect X $covs, seed(50) wstep(0.1) nwindows(25) 

* Code snippet 8, Using rdrandinf with the Confidence Interval Option
rdrandinf Y X, wl(-0.75) wr(0.75) seed(50) ci(0.05 -10(0.1)10)

* Code snippet 9, Using rdrandinf with the Alternative Power Option
global covs "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
rdrandinf Y X, covariates($covs) seed(50) d(7.416) 

