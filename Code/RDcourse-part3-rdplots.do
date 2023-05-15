********************************************************************************
**  Part 3: Graphical Illustration of RD designs
** Author: Rocio Titiunik, Matias Cattaneo, Sebastian Calonico
** Last update: May 2023
********************************************************************************
** RDROBUST:  net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
** RDLOCRAND: net install rdlocrand, from(https://raw.githubusercontent.com/rdpackages/rdlocrand/master/stata) replace
** RDDENSITY: net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
** RDPOWER:   net install rdpower, from(https://raw.githubusercontent.com/rdpackages/rdpower/master/stata) replace
********************************************************************************


********************************************************************************
clear all
set more off
set linesize 200

********************************************************************************
** Example 1 : Head Start
********************************************************************************
use headstart, clear
gl y mort_age59_related_postHS
gl x povrate60
gl c = 59.1984


** Basic Scatter Plot
scatter $y $x
scatter $y $x, xline($c, lcolor(red))

********************************************************************************
** RD Plots
********************************************************************************

** Quick RD plots (default: mimicking variance)
rdplot $y $x, c($c)

** Add title 
rdplot $y $x , c($c) graph_options(title(RD Plot - Head Start) ///
                            ytitle(Child Mortality 5 to 9 years old) ///
                            xtitle(Poverty Rate))
			    

** Evenly-spaced
rdplot $y $x, c($c) binselect(es)

** Quantile-spaced
rdplot $y $x, c($c) binselect(qs)

** Global 2nd order polynomial
rdplot $y $x, c($c) p(2) 

** Select manually number of bins
rdplot $y $x, c($c) nbins(10)  

** Add confidence intervals
rdplot $y $x, c($c) nbins(10) ci(95) 

** Add confidence intervals w/shade
rdplot $y $x, c($c) nbins(10) ci(95) shade

** Generate variables
rdplot $y $x, c($c) p(2) ci(95) shade genvars

** Stored output
ereturn list

*******************************************************************************
** Example 2 : U.S. Senate
********************************************************************************
use senate, clear
global x demmv
global y demvoteshfor2
global c = 0
********************************************************************************
** Summary Stats & Diff-in-means
********************************************************************************
sum $y $x demvoteshlag1 demvoteshlag2 dopen
gen T= ($x>=0)
ttest $y, by(T)


********************************************************************************
** RD Plots
********************************************************************************

** Quick RD plots (default: mimicking variance)
rdplot $y $x

rdplot $y $x, graph_options(name(Rdplot1))

rdplot $y $x if abs($x)<=40, graph_options(name(Rdplot2))

graph drop Rdplot1
graph drop Rdplot2

** Add title 
rdplot $y $x , graph_options(title(RD Plot - Senate Elections Data) ///
                            ytitle(Vote Share in Election t+1) ///
                            xtitle(Margin of Victory in Election t))


** Evenly-spaced
rdplot $y $x, c($c) binselect(esmv)

** Quantile-spaced
rdplot $y $x, c($c) binselect(qsmv)

** Global 2nd order polynomial
rdplot $y $x, c($c) p(2) 

** Select manually number of bins
rdplot $y $x, c($c) nbins(10)  

** Add confidence intervals
rdplot $y $x, c($c) nbins(10) ci(95) 

** Add confidence intervals w/shade
rdplot $y $x, c($c) nbins(10) ci(95) shade

** Generate variables
rdplot $y $x, c($c) p(2) ci(95) shade genvars

** Use support option
rdplot $y $x, nbins(20) support(-100 100)

** Stored output
ereturn list			    
			    
********************************************************************************
** Example 3 : U.S. House
********************************************************************************
use house, clear
global x difdemshare
global y demsharenext

** Quick RD plot  (default: mimicking variance)
rdplot $y $x , graph_options(title(RD Plot - House Elections Data) ///
                            ytitle(Vote Share in Election at time t+1) ///
                            xtitle(Margin of Victory at time t))








