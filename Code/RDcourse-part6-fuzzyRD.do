********************************************************************************
**  Part 5: Fuzzy RD designs
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
clear
clear all
clear matrix
cap log close
set more off

/***********************************

Fuzzy RD Analysis (one-dimensional)

************************************/

*----------------------------------------------------------------------*
** Empirical Illustration: LONDONO-VELEZ, RODRIGUEZ AND SANCHEZ (2020, AEJ Policy)
*-----------------------------------------------------------------------*

* Loading the data
use "spp.dta", clear

* This replication only includes first cohort (keep icfes_per==20142 as in replication files)
tab icfes_per

* Running variables
codebook running_saber11  /* this running variable is discrete:  447  unique values*/

codebook running_sisben   /* this running variable is discrete but number of masspoints is large:  25,375 unique values*/

* Treatment indicator (=1 if the student in fact received the money)
sum beneficiary_spp

* Keep subsample of students with scores above Saber 11 cutoff
sum running_saber11
keep if running_saber11>=0

* Drop observations with missing values in SISBEN running variable:   Students who live in households who don't receive welfare benefits have missing score
drop if running_sisben==.

* Look at repeated values in the final sample for analysis
duplicates report sisben_score
ret list

duplicates tag sisben_score, gen(duplic)

* Rename variables 
rename running_sisben  X  /* score (normalized): distance from Sisben wealth index to cutoff */
rename beneficiary_spp D  /* treatment: indicator for whether student receive SPP subsidy*/ 
rename spadies_any Y1     /* Outcome 1*/   
rename spadies_hq  Y2     /* Outcome 2 */

*-------------  
* First Stage: T on D
*-------------

* Rdplot on D
rdplot D X

* Rdrobust on D
/* Note: because of one-sided non-compliance, no variability on D to the left of cutoff
         when we choose msetwo, the bandwidth on the left of cutoff is the entire support*/
rdrobust D X
rdrobust D X, bwselect(msetwo)

*-------------
* ITT: T on Y
*-------------
rdplot Y1 X

rdrobust Y1 X  /* Bandwidth not exactly same as in published paper, which is h=9.028 */
               /* Two reasons for this : (1) Back then, rdrobust did not adjust for masspoints automatically
			                             (2) They reported bias-corrected point estimators (!)
               */
rdrobust Y1 X, masspoints(off) all /* more similar */

*------------------
* Outcome 1:   Dummy ==1 if student attended any certified HEI immediately after receiving subsidy
*--------------------
* Fuzzy effect
rdrobust Y1 X, fuzzy(D)
global h = e(h_l)
global b = e(b_l)

* equivalent to the two-step estimation below
drop if D==. /* be careful! if you don't drop missing values in D, steps below do not replicate the effect*/
rdrobust Y1 X, h($h) b($b)
global itt =  e(tau_cl)

rdrobust D X, h($h) b($b)
global fs = e(tau_cl)

display $itt/$fs

* Rdrobust (sharp) on Y1
rdrobust Y1 X, vce(cluster X)

* Rdrobust (fuzzy) on Y1
rdrobust Y1 X, fuzzy(D) vce(cluster X)

* Rdplot on Y1
rdplot Y1 X

*------------------
* Outcome 2:  Dummy ==1 if student attended a high-quality certified HEI immediately after receiving subsidy
*-------------------------------
* Rdrobust (sharp) on Y2
rdrobust Y2 X

* Rdrobust (fuzzy) on Y2
rdrobust Y2 X, fuzzy(D)

* Rdplot on Y2
rdplot Y2 X

*-------------
* Falsification
*-------------
*-------------
* Rddensity
*----------
rddensity X

*-------------
* Test on Covariates
*-------------------------
* Sharp rdrobust
global covariates "icfes_female icfes_age icfes_urm icfes_stratum icfes_privatehs icfes_famsize"
foreach y of global covariates {
	rdrobust `y' X, all
}

* Fuzzy rdrobust
foreach y of global covariates {
	rdrobust `y' X, fuzzy(D) all
}

*************************************
* Extra: Local randomization analysis
*-------------------------------
* Window selection
rdwinselect X icfes_female icfes_age icfes_urm icfes_stratum icfes_privatehs icfes_famsize, seed(86543)

global wr = 0.13
global wl = -0.13

* Rdrandinf on D: first stage in this window
rdrandinf D X, wl($wl) wr($wr)

* Rdrandinf (sharp) on Y1
rdrandinf Y1 X, wl($wl) wr($wr)

* Rdrandinf (fuzzy, AR) on Y1
rdrandinf Y1 X, fuzzy(D) wl($wl) wr($wr)

* Rdrandinf (fuzzy, TSLS) on Y1
rdrandinf Y1 X, fuzzy(D tsls) wl($wl) wr($wr)

* Rdrandinf (sharp) on Y2
rdrandinf Y2 X, wl($wl) wr($wr)

* Rdrandinf (fuzzy, AR) on Y2
rdrandinf Y2 X, fuzzy(D) wl($wl) wr($wr)

* Rdrandinf (fuzzy, TSLS) on Y2
rdrandinf Y2 X, fuzzy(D tsls)  wl($wl) wr($wr)

* Additional outcomes
rdrandinf spadies_hq_pri X, wl($wl) wr($wr)
rdrandinf spadies_hq_pub X, wl($wl) wr($wr)

