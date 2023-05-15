********************************************************************************
**  Part 4: Local Polynomial RD Analysis
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

clear all

********************************************************
**** Head Start ****************************************
********************************************************

use "headstart.dta", clear

gen Y = mort_age59_related_postHS 
gen X = povrate60 - 59.1984

gen T=.
replace T=0 if X<0 & X!=.
replace T=1 if X>=0 & X!=.

order X Y T

*  Descriptive Statistics
su
duplicates report Y 
tab Y
duplicates report X

*-----------------------------------------*
* Continuity-Based RD Approach *
*-----------------------------------------*
*** optimal bw
rdbwselect Y X,  p(0)

** rdrobust: MSE data-driven bandwidth - local constant regression
rdrobust Y X,  p(0)

** rdrobust: parametric bandwidth - local constant regression
rdrobust Y X, p(0) h(9)

** rdrobust: MSE data-driven bandwidth - local linear regression
rdrobust Y X, p(1)

** rdrobust: parametric bandwidth - local linear regression
rdrobust Y X,  p(1) h(9)

* Output from rdrobust
rdrobust Y X, h(10) kernel(uniform)

* Output from regressions on both sides
reg Y X if X<0 & X>=-10
matrix coef_left=e(b)
local intercept_left=coef_left[1,2]
reg Y X if X>=0 & X<=10
matrix coef_right=e(b)
local intercept_right=coef_right[1,2]
local difference=`intercept_right'-`intercept_left'
display "The RD estimator is `difference'"

* Output from joint regression
gen T_X=X*T
reg Y X T T_X if abs(X)<=10

* Matching standard errors
reg Y X T T_X if abs(X)<=10, robust
rdrobust Y X, h(10) kernel(uniform) vce(hc1)

* For other kernels besides uniform
gen weights=.
replace weights=(1-abs(X/10)) if abs(X)<10

* Code snippet 4 (regression with weights)
reg Y X [aw=weights] if X<0 & X>=-10
matrix coef_left=e(b)
local intercept_left=coef_left[1,2]
reg Y X [aw=weights] if X>=0 & X<=10
matrix coef_right=e(b)
local intercept_right=coef_right[1,2]
local difference=`intercept_right'-`intercept_left'
display "The RD estimator is `difference'"

rdrobust Y X,  h(10) kernel(uniform)

rdrobust Y X, kernel(triangular) p(1) h(10)  

rdrobust Y X, kernel(triangular) p(2) h(10)  

rdbwselect Y X, kernel(triangular) p(1) bwselect(mserd) 

rdbwselect Y X, kernel(triangular) p(1) bwselect(msetwo) 

rdrobust Y X
ereturn list

* showing the associated rdplot)
rdrobust Y X, p(1) kernel(triangular) bwselect(mserd)
local bandwidth=e(h_l)
rdplot Y X if abs(X)<=`bandwidth', p(1) h(`bandwidth') kernel(triangular)

* (using rdrobust without regularization term)
rdrobust Y X, kernel(triangular) p(1) bwselect(mserd) scaleregul(0)

* (using rdrobust default options)
rdrobust Y X, kernel(triangular) p(1) bwselect(mserd)  

* (using rdrobust default options)
rdrobust Y X, kernel(triangular) p(1) bwselect(cerrd)  


* (using rdrobust default options and showing all the output)
rdrobust Y X, kernel(triangular) p(1) bwselect(mserd) all

** Placebo Outcome Variables
foreach y of varlist mort_age59_injury_postHS mort_age59_related_preHS {
   rdrobust `y' X, p(0)
   rdrobust `y' X, p(0) h(9)
   rdrobust `y' X, p(1)
   rdrobust `y' X, p(1) h(9)
}



********************************************************************************
** Head Start Data
********************************************************************************
use "headstart.dta", clear

gl y mort_age59_related_postHS
gl x povrate60
gl z census1960_pop census1960_pctsch1417 census1960_pctsch534 ///
     census1960_pctsch25plus census1960_pop1417 census1960_pop534 ///
	 census1960_pop25plus census1960_pcturban census1960_pctblack

** MSE-optimal bandwidths w/o covs; RD w/o covs
rdrobust $y $x, c(59.1968)
local h = e(h_l)
local b = e(b_l)
local IL =  e(ci_r_rb) - e(ci_l_rb)

** MSE-optimal bandwidths w/o covs; RD w/ covs
rdrobust $y $x, c(59.1968) covs($z) h(`h') b(`b')
local ILch = round((((`e(ci_r_rb)' - `e(ci_l_rb)')/`IL') - 1)* 100, 0.001)

** MSE-optimal bandwidths w/ covs; RD w/ covs
rdrobust $y $x, c(59.1968) covs($z)
local ILch = round((((`e(ci_r_rb)' - `e(ci_l_rb)')/`IL') - 1)* 100, 0.001)


********************************************************
**** Incumbency US Senate ******************************
********************************************************

use "senate.dta", clear

rename demmv X
rename demvoteshfor2 Y

gen T=.
replace T=0 if X<0 & X!=.
replace T=1 if X>=0 & X!=.
label var T "Democratic Win at t"

order X Y T

*  Descriptive Statistics
su
duplicates report Y 
tab Y
duplicates report X
	

* Output from rdrobust
rdrobust Y X, h(10) kernel(uniform)

* Output from regressions on both sides
reg Y X if X<0 & X>=-10
matrix coef_left=e(b)
local intercept_left=coef_left[1,2]
reg Y X if X>=0 & X<=10
matrix coef_right=e(b)
local intercept_right=coef_right[1,2]
local difference=`intercept_right'-`intercept_left'
display "The RD estimator is `difference'"

* Output from joint regression
gen T_X=X*T
reg Y X T T_X if abs(X)<=10

* Matching standard errors
reg Y X T T_X if abs(X)<=10, robust
rdrobust Y X, h(10) kernel(uniform) vce(hc1)

* For other kernels besides uniform
gen weights=.
replace weights=(1-abs(X/10)) if abs(X)<10

* Code snippet 4 (regression with weights)
reg Y X [aw=weights] if X<0 & X>=-10
matrix coef_left=e(b)
local intercept_left=coef_left[1,2]
reg Y X [aw=weights] if X>=0 & X<=10
matrix coef_right=e(b)
local intercept_right=coef_right[1,2]
local difference=`intercept_right'-`intercept_left'
display "The RD estimator is `difference'"

rdrobust Y X,  h(10)  

rdrobust Y X, kernel(triangular) p(1) h(10)  

rdrobust Y X, kernel(triangular) p(2) h(10)  

rdbwselect Y X, kernel(triangular) p(1) bwselect(mserd) 

rdbwselect Y X, kernel(triangular) p(1) bwselect(msetwo) 

rdrobust Y X
ereturn list

* showing the associated rdplot)
rdrobust Y X, p(1) kernel(triangular) bwselect(mserd)
local bandwidth=e(h_l)
rdplot Y X if abs(X)<=`bandwidth', p(1) h(`bandwidth') kernel(triangular)

* (using rdrobust without regularization term)
rdrobust Y X, kernel(triangular) p(1) bwselect(mserd) scaleregul(0)

* (using rdrobust default options)
rdrobust Y X, kernel(triangular) p(1) bwselect(mserd)  

* (using rdrobust default options)
rdrobust Y X, kernel(triangular) p(1) bwselect(cerrd)  


* (using rdrobust default options and showing all the output)
rdrobust Y X, kernel(triangular) p(1) bwselect(mserd) all

* (rdbwselect with covariates)
global covariates "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
rdbwselect Y X, covs($covariates) p(1) kernel(triangular) bwselect(mserd) scaleregul(1)

* (rdrobust with covariates)
global covariates "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
rdrobust Y X, covs($covariates) p(1) kernel(triangular) bwselect(mserd) scaleregul(1)

