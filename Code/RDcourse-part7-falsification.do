********************************************************************************
**  Part 7: RD Falsification Analysis
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

use "headstart.dta", clear

gen Y = mort_age59_related_postHS 
gen X = povrate60 - 59.1984


* Using rddensity
rddensity X

* Figure
rddensity X
local bandwidth_left=e(h_l)
local bandwidth_right=e(h_r)
twoway (histogram X if X>=-`bandwidth_left' & X<0, freq width(1) color(blue)) ///
	(histogram X if X>=0 & X<=`bandwidth_right', freq width(1) color(red)), xlabel(-20(10)30) ///
	graphregion(color(white)) xtitle(Score) ytitle(Number of Observations) legend(off)

rddensity X, plot
	
	
** Placebo Outcome Variables
foreach y of varlist mort_age59_injury_postHS mort_age59_related_preHS {
   rdplot `y' X
   rdrobust `y' X
}


foreach y of varlist census1960_pop census1960_pctsch1417 census1960_pctsch534 ///
     census1960_pctsch25plus census1960_pop1417 census1960_pop534 ///
	 census1960_pop25plus census1960_pcturban census1960_pctblack {
	 
	rdplot `y' X
	rdrobust `y' X
}

	 
	 
	 
	 
********************************************************************************
use "senate.dta", clear

rename demmv X
rename demvoteshfor2 Y

gen Z=.
replace Z=0 if X<0 & X!=.
replace Z=1 if X>=0 & X!=.
label var Z "Democratic Win at t"

order X Y Z

*-----------------------------------------*
* Section 6: Validation and Falsification *
*-----------------------------------------*
* Code snippet 1, Using rddensity
rddensity X

* Figure 6.2a
rddensity X
local bandwidth_left=e(h_l)
local bandwidth_right=e(h_r)
twoway (histogram X if X>=-`bandwidth_left' & X<0, freq width(1) color(blue)) ///
	(histogram X if X>=0 & X<=`bandwidth_right', freq width(1) color(red)), xlabel(-20(10)30) ///
	graphregion(color(white)) xtitle(Score) ytitle(Number of Observations) legend(off)

rddensity X, plot
	
* Code snippet 2, Binomial Test with rdwinselect
rdwinselect X, wmin(0.75) nwindows(1) 

* Code snippet 3, Binomial Test by Hand
bitesti 39 15 1/2

* Code snippet 4, Using rdrobust on demvoteshlag1
rdrobust demvoteshlag1 X

* Table 6.1 (rdrobust on all the covariates)
global covariates "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
matrix define R=J(8,8,.)
local k=1
foreach y of global covariates {
	rdrobust `y' X
}


* Code snippet 5, Using rdplot to Show the rdrobust Effect for demvoteshlag1
rdrobust demvoteshlag1 X
local bandwidth=e(h_l)
rdplot demvoteshlag1 X if abs(X)<=`bandwidth', h(`bandwidth') p(1) kernel(triangular)

* Code snippet 6, Using rdrandinf on dopen
rdrandinf dopen X, wl(-.75) wr(.75)

* Table 6.2, rdrandinf on All Covariates
global covariates "presdemvoteshlag1 demvoteshlag1 demvoteshlag2 demwinprv1 demwinprv2 dmidterm dpresdem dopen"
local window=0.75
matrix define R=J(8,5,.)
local k=1
foreach y of global covariates {
	ttest `y' if abs(X)<=`window', by(Z)

	rdrandinf `y' X, wl(-`window') wr(`window')
}

* Code snippet 7, Using rdplot to Show the rdrobust Effect for dopen
rdplot dopen X if abs(X)<=.75, h(.75) p(0) kernel(uniform)

* Code snippet 8, Using rdrobust with the Cutoff Equal to 1
rdrobust Y X if X>=0, c(1)

* Table 6.3 (rdrobust all cutoffs from -5 to 5 in increments of 1)
matrix define R=J(11,10,.)
local k=1
forvalues x=-5(1)5 {
	if `x'>0 {
		local condition="if X>=0"
	}
	else if `x'<0 {
		local condition="if X<0"
	}
	else {
		local condition=""
	}
	
	rdrobust Y X `condition', c(`x')

}


