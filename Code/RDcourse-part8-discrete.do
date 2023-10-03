********************************************************************************
**  Part 8: RD Designs with Discrete Running Variables
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
clear
clear all
clear matrix
cap log close
set more off

cd C:\Users\titiunik\Dropbox\teaching\workshops\2022-08-RD-StatisticalHorizons\slides-and-codes\data-and-codes

* A folder called "outputs" needs to be created in order to store 
* all of the figures, logs and tables. If the folder already exists,
* the user will get an error message but the code will not stop.
capture noisily mkdir "outputs"

* Loading the data
use "education.dta", clear

*----------------------------------------------*
* Example of RD With Discrete Score *
*----------------------------------------------*

* Histogram
twoway (histogram X if X<0, width(0.1) freq color(blue) xline(0)) ///
	(histogram X if X>=0, width(0.1) freq color(red)), graphregion(color(white)) legend(off) ///
	xtitle(Score) ytitle(Number of Observations)

* Counting the Number of Observations with X Different from Missing
count if X!=.

* Code snippet 2, Counting the Unique Values of X
codebook X

duplicates report X

preserve
gen obs=1
collapse (sum) obs, by(X)
list X obs
restore

* Using rddensity
rddensity X

* Using rdrobust on hsgrade_pct
rdrobust hsgrade_pct X 

* Using rdplot on hsgrade_pct
rdplot hsgrade_pct X 

* rdrobust on All Covariates
global covariates "hsgrade_pct totcredits_year1 age_at_entry male bpl_north_america english loc_campus1 loc_campus2 loc_campus3"
matrix define R=J(9,8,.)
local k=1
foreach y of global covariates {
	rdrobust `y' X, all
	local label_`k': variable label `y'
	matrix R[`k',1]=e(h_l)
	matrix R[`k',2]=e(tau_cl)
	matrix R[`k',3]=e(tau_bc)
	matrix R[`k',4]=e(se_tau_rb)
	matrix R[`k',5]=2*normal(-abs(R[`k',3]/R[`k',4]))
	matrix R[`k',6]=R[`k',3]-invnormal(0.975)*R[`k',4]
	matrix R[`k',7]=R[`k',3]+invnormal(0.975)*R[`k',4]
	matrix R[`k',8]=e(N_h_l)+e(N_h_r)
	
	local k=`k'+1
}
matlist R

preserve
	clear
	local t=`k'-1
	svmat R
	gen R0=""
	forvalues k=1/`t' {
		replace R0="`label_`k''" if _n==`k'
	}
	order R0
	save "outputs/section7_rdrobust_allcovariates.dta", replace
restore

* Using rdplot on the Outcome
rdplot nextGPA_nonorm X, binselect(esmv) ///
	graph_options(graphregion(color(white)) ///
	xtitle(Running Variable) ytitle(Outcome))

* Using rdrobust on the Outcome
rdrobust nextGPA_nonorm X, kernel(triangular) p(1) bwselect(mserd)  

* Using rdrobust and Showing the Objects it Returns
rdrobust nextGPA_nonorm X
ereturn list

* Using rdrobust with Clustered Standard Errors
cap drop clustervar
gen clustervar=X
rdrobust nextGPA_nonorm X, kernel(triangular) p(1) bwselect(mserd) vce(cluster clustervar)

* Using rdrobust on the Collapsed Data
preserve
	collapse (mean) nextGPA_nonorm, by(X)
	rdrobust nextGPA_nonorm X
restore

* Binomial Test with rdwinselect
rdwinselect X, wmin(0.01) nwindows(1) cutoff(0.000005)

* Binomial Test by Hand
bitesti 305 77 1/2

* Using rdrandinf on hsgrade_pct
rdrandinf hsgrade_pct X , seed(50) wl(-.005) wr(.01)

* rdrandinf on All Covariates
global covariates "hsgrade_pct totcredits_year1 age_at_entry male bpl_north_america english loc_campus1 loc_campus2 loc_campus3"
matrix define R=J(9,5,.)
local k=1
foreach y of global covariates {
	ttest `y' if X>=-0.005 & X<=0.01, by(Z)
	matrix R[`k',1]=r(mu_1)
	matrix R[`k',2]=r(mu_2)

	rdrandinf `y' X, wl(-0.005) wr(0.01) seed(50)
	local label_`k': variable label `y'
	matrix R[`k',3]=r(obs_stat)
	matrix R[`k',4]=r(randpval)
	matrix R[`k',5]=r(N)
	
	local k=`k'+1
}

mat list R
preserve
	clear
	local t=`k'-1
	svmat R
	gen R0=""
	forvalues k=1/`t' {
		replace R0="`label_`k''" if _n==`k'
	}
	order R0
	save "outputs/section7_rdrandinf_allcovariates.dta", replace
restore

* Using rdwinselect with Covariates and Windows with Equal Number of Mass Points
* to Each Side of the Cutoff
global covariates "hsgrade_pct totcredits_year1 age_at_entry male bpl_north_america english loc_campus1 loc_campus2 loc_campus3"
rdwinselect X $covariates, cutoff(0.00005) wmin(0.01) wstep(0.01)

rdwinselect X $covariates if loc_campus3==1, cutoff(0.00005) wmin(0.01) wstep(0.01)

* Using rdrandinf on the Outcome
rdrandinf nextGPA_nonorm X, seed(50) wl(-0.005) wr(0.01) 

*-------------------------------------------------------------------------------------------------------------*
clear all
