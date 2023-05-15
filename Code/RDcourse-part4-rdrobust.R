#------------------------------------------------------------------------------#
#  Part 4: Local Polynomial RD Analysis
# Authors: Matias Cattaneo, Sebastian Calonico, Rocio Titiunik
# Last update: May 2023
#------------------------------------------------------------------------------#
# SOFTWARE WEBSITE: https://rdpackages.github.io/rdrobust/
#------------------------------------------------------------------------------#
# TO INSTALL/DOWNLOAD R PACKAGES/FUNCTIONS:
# FOREIGN: install.packages('foreign')
# GGPLOT2: install.packages('ggplot2')
# LPDENSITY: install.packages('lpdensity')
# RDDENSITY: install.packages('rddensity')
# RDLOCRAND: install.packages('rdlocrand')
# RDROBUST: install.packages('rdrobust')
#------------------------------------------------------------------------------#
rm(list=ls())

library(foreign)
library(lpdensity)
library(rddensity)
library(rdrobust)
library(rdlocrand)
library(readstata13)

data = read.dta13("headstart.dta")
Y = data$mort_age59_related_postHS 
X = data$povrate60 - 59.1984
c = 59.1984
Xraw = data$povrate60
T = (X>=0)

summary(data)
length(X)
length(unique(X))
length(Y)
length(unique(Y))

#-----------------------------------------#
# Local polynomial analysis (Continuity-Based RD Approach)
#-----------------------------------------#
# Code snippet 1 (two regressions)
out = lm(Y~X,subset=X<0 & X>=-10)
left_intercept = out$coefficients[1]
print(left_intercept)
out = lm(Y~X, subset=X>=0 & X<10)
right_intercept = out$coefficients[1]
print(right_intercept)
difference = right_intercept - left_intercept
print(paste("The RD estimator is", difference, sep = " "))

# Code snippet 2 (one regression)
T_X = X*T
out = lm(Y~X+T+T_X, subset=abs(X)<=10)
print(out)

# Code snippet 3 (generation of weights)
w = NA
w = 1-abs(X)/10

# Code snippet 4 (regression with weights)
rdrobust(Y, X, h = 10)

out = lm(Y~X+T+T_X, weight=w, subset=abs(X)<=10)
print(out)

# Code snippet 5 (using rdrobust with uniform weights)
rdrobust(Y, X, kernel = 'uniform',  p = 1, h = 10)

# Code snippet 6 (using rdrobust with triangular weights)
rdrobust(Y, X, kernel = 'triangular',  p = 1, h = 10)

# Code snippet 7 (using rdrobust with triangular weights and p=2)
rdrobust(Y, X, kernel = 'triangular',  p = 2, h = 10)

# Code snippet 8 (using rdbwselect, mserd)
rdbwselect(Y, X, kernel = 'triangular',  p = 1, bwselect = 'mserd')

# Code snippet 9 (using rdbwselect, msetwo)
rdbwselect(Y, X, kernel = 'triangular',  p = 1, bwselect = 'msetwo')

# Code snippet 10 (using rdrobust, mserd)
rdrobust(Y, X, kernel = 'triangular',  p = 1, bwselect = 'mserd')

# Code snippet 12 (using rdrobust and showing the associated rdplot)
bandwidth = rdrobust(Y, X, kernel = 'triangular', p = 1, bwselect = 'mserd')$h_l
out = rdplot(Y, X, p = 1, kernel = 'triangular', h = bandwidth)
print(out)

# Code snippet 11 (using rdrobust and showing the objects it returns)
rdout = rdrobust(Y, X, kernel = 'triangular', p = 1, bwselect = 'mserd')
print(names(rdout))
print(rdout$beta_p_r)
print(rdout$beta_p_l)

# Code snippet 13 (using rdrobust without regularization term)
rdrobust(Y, X, kernel = 'triangular', scaleregul = 0,  p = 1, bwselect = 'mserd')

# Code snippet 14 (using rdrobust default options)
rdrobust(Y, X, kernel = 'triangular',  p = 1, bwselect = 'mserd')

# Code snippet 15 (using rdrobust default options and showing all the output)
rdrobust(Y, X, kernel = 'triangular',  p = 1, bwselect = 'mserd', all = TRUE)

#############################################################
## Additional Empirical Analysis
#############################################################
# 1960 Census covariates
X60 = cbind(data$census1960_pop,
            data$census1960_pctsch1417,
            data$census1960_pctsch534, 
            data$census1960_pctsch25plus,
            data$census1960_pop1417,
            data$census1960_pop534,
            data$census1960_pop25plus,
            data$census1960_pcturban,
            data$census1960_pctblack)

# 1990 Census covariates
X90 = cbind(data$census1990_pop,
            data$census1990_pop1824,
            data$census1990_pop2534,
            data$census1990_pop3554,
            data$census1990_pop55plus,
            data$census1990_pcturban,
            data$census1990_pctblack,
            data$census1990_percapinc)


# Placebo outcomes
Plac = cbind(data$mort_age59_injury_postHS,data$mort_age59_related_preHS)

tmp = rdrobust(Plac[,1],X)
summary(tmp)

tmp = rdrobust(Plac[,2],X)
summary(tmp)


###################################################################
## Table 2: Nonparametric Density Continuity Tests
###################################################################

tmp = rddensity(Xraw,c=c)
summary(tmp)

## Robust Nonparametric Method with Covariates
rdrobust(Y,X,covs=X60)

##  Robust Nonparametric Method: Different Bandwdiths at Each Side
rdrobust(Y,X,bwselect='msetwo')


################################################################################
## Head Start Data using covariates
################################################################################
data = read.dta13("headstart.dta")
attach(data)

y <- mort_age59_related_postHS
x <- povrate60
z <- cbind(census1960_pop, census1960_pctsch1417, census1960_pctsch534,
           census1960_pctsch25plus, census1960_pop1417, census1960_pop534,
           census1960_pop25plus, census1960_pcturban, census1960_pctblack)

## rho unrestricted; MSE-optimal bandwidths w/o covs; RD w/o covs
rd <- rdrobust(y, x, c=59.1968)
h  <- rd$h_l
b  <- rd$b_l
IL <- rd$ci[3,2] - rd$ci[3,1]


## rho unrestricted; MSE-optimal bandwidths w/o covs; RD w/ covs
rd <- rdrobust(y, x, c=59.1968, covs=z, h=h, b=b)
ILch <- ((rd$ci[3,2] - rd$ci[3,1])/IL - 1)* 100


## rho unrestricted; MSE-optimal bandwidths w/ covs; RD w/ covs
rd <- rdrobust(y, x, c=59.1968, covs=z)
ILch <- ((rd$ci[3,2] - rd$ci[3,1])/IL - 1)* 100

