#------------------------------------------------------------------------------#
#  Part 6: Local Randomization RD analysis
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

################################################################################
## US Senate data
################################################################################
data = read.dta13("senate.dta")
names(data)

X = data$demmv
Y = data$demvoteshfor2

# Create "Democratic Win at t"
Z = rep(NA, length(X))
Z[X<0  & !is.na(X)]=0
Z[X>=0 & !is.na(X)]=1

#*--------------------------------------------*
#  * Local Randomization RD Approach *
#  *--------------------------------------------*
rdrandinf(Y, X, wl=-0.7652, wr=0.7652, seed=50, ci=TRUE) 

#Using rdrandinf in the Ad-hoc Window with the Bernoulli Option
bernpr=rep(NA, length(X))
bernpr[abs(X)<=0.75]=1/2
rdrandinf(Y,  X, wl=-0.75, wr=0.75, seed=50, bernoulli =bernpr)

# Code snippet 3, Using rdrandinf in the Ad-hoc Window with the Kolmogorov-Smirnov Statistic
rdrandinf(Y,  X, wl=-0.75, wr=0.75, seed=50, statistic = "ksmirnov")

# Code snippet 4, Using rdrandinf in the Ad-hoc Window with the Confidence Interval Option
rdrandinf(Y,  X, wl=-0.75, wr=0.75, seed=50, ci = c(0.05, seq(from=-10, to=10, by=0.25)))

# Code snippet 5, Using rdwinselect with the wobs Option
covs = cbind(data$presdemvoteshlag1, data$demvoteshlag1, data$demvoteshlag2, data$demwinprv1, data$demwinprv2, data$dmidterm, data$dpresdem, data$dopen)
rdwinselect(X, c = 0 , covs, seed = 50, wobs=2, nwindows=200 , approx=TRUE, plot=TRUE)

# Code snippet 6, Using rdwinselect with the wobs, nwindows and plot Options
rdwinselect(X, covs, seed = 50, wobs=2, nwindows =50, plot=TRUE) 

#Code snippet 7, Using rdwinselect with the wstep and nwindows Options
rdwinselect(X, covs, seed = 50, wstep=0.1, nwindows=25)

# Code snippet 8, Using rdrandinf with the Confidence Interval Option
rdrandinf(Y, X, wl=-0.75, wr=0.75, seed=50, ci = c(0.05, seq(from=-10, to=10, by=0.10)))

# Code snippet 9, Using rdrandinf with the Alternative Power Option
out = rdrandinf(Y, X, covariates = covs, seed=50, d = 7.416) 
names(out)
out$window
