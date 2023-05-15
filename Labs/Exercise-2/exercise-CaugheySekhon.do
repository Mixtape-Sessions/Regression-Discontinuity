/********************************************

In class exercise: Caughey and Sekhon example

Party incumbency advantage in the U.S. House
Unit of observation: house district
Period: 1942-2010

Running variable/score		: Democratic Party's Margin of Victory at Election t ==> DifDPct
Outcome of interest		: Democratic Party's Victory at Election t+1 ==> DWinNxt
Pre-determined covariate 1	: Democratic Party's Victory at Election t-1 (DWinPrv) 
Pre-determined covariate 2	: Democratic Party's Vote Share at Election t-1 (DPctPrv) 

*********************************************/

use CaugheySekhon2011.dta, clear
global x DifDPct  /* score */
global y DWinNxt  /* outcome*/
global z1 DWinPrv /* covariate 1*/
global z2 DPctPrv /* covariate 2*/
	
/* Step 1 : Analyze this RD using a local polinomial approach */
* Do RD plot, falsification on density and covariates, and local polynomial estimation with optimal bandwidth selection	

/* Step 2 : Analyze this RD using a local randomization approach */
* Select a window based on the two covariates and peform inference inside chosen window

/* Step 3: Compare results from both approaches */
* Do you reach different conclusions from the two approaches? Is this RD design valid? Why/Why not?
