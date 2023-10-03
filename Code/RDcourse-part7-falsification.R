#------------------------------------------------------------------------------#
#  Part 7: Falsification Analysis for RD designs
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
library(ggplot2)

data = read.dta13("headstart.dta")
names(data)

Y = data$mort_age59_related_postHS 
X = data$povrate60 - 59.1984

# Using rddensity
out = rddensity(X)
plot1 = rdplotdensity(out, X)
plot1 = rdplotdensity(out, X, plotRange = c(-20, 20), plotN = 25)

# Histogram
out = rddensity(X)
bw_left =  as.numeric(out$h$left) 
bw_right = as.numeric(out$h$right)
tempdata = as.data.frame(X); colnames(tempdata) = c("v1");
plot2 = ggplot(data=tempdata, aes(tempdata$v1)) +
  geom_histogram(data = tempdata, aes(x = v1, y= ..count..), breaks = seq(-bw_left, 0, 1), fill = "blue", col = "black", alpha = 1) +
  geom_histogram(data = tempdata, aes(x = v1, y= ..count..), breaks = seq(0, bw_right, 1), fill = "red", col = "black", alpha = 1) +
  labs(x = "Score", y = "Number of Observations") + geom_vline(xintercept = 0, color = "black") +
  theme_bw()
plot2

	
#** Placebo Outcome Variables
placebos =  cbind(data$mort_age59_injury_postHS, data$mort_age59_related_preHS)
for(i in 1:ncol(placebos)) {
   rdplot(placebos[,i], X)
   rdrobust(placebos[,i], X)
}

covariates = cbind(data$census1960_pop, data$census1960_pctsch1417, data$census1960_pctsch534, 
                   data$census1960_pctsch25plus, data$census1960_pop1417, data$census1960_pop534,
	                 data$census1960_pop25plus, data$census1960_pcturban, data$census1960_pctblack)
	 
for(i in 1:ncol(covariates)) {
   rdplot(covariates[,i], X)
   rdrobust(covariates[,i], X)
}

# Estimating the RD effect at alternative cutoffs (true cutoff is zero)
summary(rdrobust(Y, X)) # true cutoff
summary(rdrobust(Y[X>0], X[X>0], c=5))
	   
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

# RDdensity
# Using rddensity
out = rddensity(X)
summary(out)
plot1 = rdplotdensity(out, X)
plot1 = rdplotdensity(out, X, plotRange = c(-20, 20), plotN = 25)

# Histogram
out = rddensity(X)
bw_left =  as.numeric(out$h$left) 
bw_right = as.numeric(out$h$right)
tempdata = as.data.frame(X); colnames(tempdata) = c("v1");
plot2 = ggplot(data=tempdata, aes(tempdata$v1)) +
  geom_histogram(data = tempdata, aes(x = v1, y= ..count..), breaks = seq(-bw_left, 0, 1), fill = "blue", col = "black", alpha = 1) +
  geom_histogram(data = tempdata, aes(x = v1, y= ..count..), breaks = seq(0, bw_right, 1), fill = "red", col = "black", alpha = 1) +
  labs(x = "Score", y = "Number of Observations") + geom_vline(xintercept = 0, color = "black") +
  theme_bw()
plot2


# Binomial Test with rdwinselect
rdwinselect(X, wmin = 0.75, nwindows=1)

# Code snippet 3, Binomial Test by Hand
binom.test(x = 15, n = 39, p = 0.5)

# Code snippet 4, Using rdrobust on demvoteshlag1
summary(rdrobust(data$demvoteshlag1, X))
rdplot(data$demvoteshlag1, X)

# Table 6.1 (rdrobust on all the covariates)
covs = cbind(data$presdemvoteshlag1, data$demvoteshlag1, data$demvoteshlag2, data$demwinprv1, data$demwinprv2, data$dmidterm, data$dpresdem, data$dopen)
for(i in 1:ncol(covariates)) {
  rdplot(covariates[,i], X)
  rdrobust(covariates[,i], X)
}

# Code snippet 5, Using rdplot to Show the rdrobust Effect for demvoteshlag1
out = rdrobust(data$demvoteshlag1,X)
bandwidth=out$bws[1,1]
ii = abs(X)<=bandwidth 
rdplot(data$demvoteshlag1[ii],X[ii], p=1, kernel = "triangular", h = bandwidth)

# Code snippet 6, Using rdrandinf on dopen
rdrandinf(data$dopen, X, wl=-.75, wr=.75)

#* Table 6.2, rdrandinf on All Covariates
covs = cbind(data$presdemvoteshlag1, data$demvoteshlag1, data$demvoteshlag2, data$demwinprv1, data$demwinprv2, data$dmidterm, data$dpresdem, data$dopen)
window=0.75
for(i in 1:ncol(covariates)) {
  ttest(covariates[,i][abs(X) < window & Z==1], covariates[,i][abs(X) < window & Z==0])
	rdrandinf(covariates[,i], X, wl=-window, wr=window)
}

#* Code snippet 7, Using rdplot to Show the rdrobust Effect for dopen
ii = (abs(X)<=.75)
rdplot(data$dopen[ii], X[ii], h=0.75, p=0, kernel='uniform')

# Code snippet 8, Using rdrobust with the Cutoff Equal to 1
rdrobust(Y[X>=0], X[X>=0], c=1)
