#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# RD Designs with Discrete Running Variables
# Authors: Matias D. Cattaneo, Nicolas Idrobo and Rocio Titiunik
# Last update: May 2023
#------------------------------------------------------------------------------#
# SOFTWARE WEBSITE: https://rdpackages.github.io/rdrobust/
#------------------------------------------------------------------------------#
# TO INSTALL/DOWNLOAD R PACKAGES/FUNCTIONS:
# FOREIGN: install.packages('foreign')
# GGPLOT2: install.packages('ggplot2')
# GRID: install.packages('grid')
# LPDENSITY: install.packages('lpdensity')
# RDDENSITY: install.packages('rddensity')
# RDLOCRAND: install.packages('rdlocrand')
# RDROBUST: install.packages('rdrobust')
# TEACHINGDEMOS: install.packages('TeachingDemos')
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
rm(list=ls()) 

library(foreign)
library(ggplot2)
library(lpdensity)
library(rddensity)
library(rdrobust)
library(rdlocrand)
library(readstata13)

# Loading the data and defining the main variables
data = read.dta13("education.dta")
nextGPA = data$nextGPA
left_school = data$left_school
nextGPA_nonorm = data$nextGPA_nonorm
X = data$X
T = data$T
T_X = T*X

#--------------------------------------------#
# Example of RD With Discrete Score          #
#--------------------------------------------#

# Figure 3.1
# Histogram
tempdata = as.data.frame(X); colnames(tempdata) = c("v1");
p = ggplot(data=tempdata, aes(tempdata$v1))+
  geom_histogram(breaks=seq(-2.8, 0, by = 0.1), col="black", fill="blue", alpha = 1)+
  geom_histogram(breaks=seq(0, 1.6, by = 0.1), col="black", fill="red", alpha = 1)+
  labs(x="Score", y="Number of Observations")+geom_vline(xintercept=0, color="black")+
  theme_bw()
p

# Counting the number of observations with X different from missing
length(X)

# Counting the unique values of X
length(unique(X))

# Using rddensity
out = rddensity(X)
summary(out)

# Using rdrobust on hsgrade_pct
out = rdrobust(data$hsgrade_pct, X)
summary(out)

# Using rdplot on hsgrade_pct
rdplot(data$hsgrade_pct, X, x.label = "Running Variable", y.label = "", title="")

rdplot(data$hsgrade_pct, X, x.label = "Running Variable", y.label = "", title="")

# Table 3.3
summary(rdrobust(data$hsgrade_pct, X))
summary(rdrobust(data$totcredits_year1, X))
summary(rdrobust(data$age_at_entry, X))
summary(rdrobust(data$male, X))
summary(rdrobust(data$bpl_north_america, X))
summary(rdrobust(data$english, X))
summary(rdrobust(data$loc_campus1, X))
summary(rdrobust(data$loc_campus2, X))
summary(rdrobust(data$loc_campus3, X))

# Figure 3.3
rdplot(data$hsgrade_pct,       X, x.label = "Running Variable", y.label = "", title="")
rdplot(data$totcredits_year1,  X, x.label = "Running Variable", y.label = "", title="")
rdplot(data$age_at_entry,      X, x.label = "Running Variable", y.label = "", title="")
rdplot(data$english,           X, x.label = "Running Variable", y.label = "", title="")
rdplot(data$male,              X, x.label = "Running Variable", y.label = "", title="")
rdplot(data$bpl_north_america, X, x.label = "Running Variable", y.label = "", title="")

# Using rdplot on the outcome
out = rdplot(nextGPA_nonorm, X,  binselect = 'esmv')
summary(out)

rdplot(nextGPA_nonorm, X,  binselect = 'esmv', x.label = 'Running Variable', y.label = 'Outcome', title = '')

# Using rdrobust on the outcome
out = rdrobust(nextGPA_nonorm, X, kernel = 'triangular',  p = 1, bwselect = 'mserd')
summary(out)

# Using rdrobust and showing the objects it returns
rdout = rdrobust(nextGPA_nonorm, X, kernel = 'triangular', p = 1, bwselect = 'mserd')
print(names(rdout))
print(rdout$beta_p_r)
print(rdout$beta_p_l)

# Using rdrobust with clustered standard errors
clustervar = X
out = rdrobust(nextGPA_nonorm, X, kernel = 'triangular', p = 1, bwselect = 'mserd', vce = 'hc0', cluster = clustervar)
summary(out)

# Using rdrobust on the collapsed data
data2 = data.frame(nextGPA_nonorm, X)
dim(data2)
collapsed = aggregate(nextGPA_nonorm ~ X, data = data2, mean)
dim(collapsed)
out = rdrobust(collapsed$nextGPA_nonorm, collapsed$X)
summary(out)

# Binomial test with rdwinselect
out = rdwinselect(X, wmin = 0.01, nwindows = 1, cutoff = 5.00000000000e-06)

# Binomial Test by Hand
binom.test(77, 305, 1/2)

# Using rdrandinf on hsgrade_pct
out = rdrandinf(data$hsgrade_pct, X, wl = -0.005, wr = 0.01, seed = 50)

# Using rdwinselect with covariates and windows with equal number of mass points to each side of the cutoff
Z = cbind(data$hsgrade_pct, data$totcredits_year1, data$age_at_entry, data$male,
          data$bpl_north_america, data$english, data$loc_campus1, data$loc_campus2, 
          data$loc_campus3)
colnames(Z) = c("hsgrade_pct", "totcredits_year1", "age_at_entry", "male",
                "bpl_north_america", "english", "loc_campus1", "loc_campus2",
                "loc_campus3")
out = rdwinselect(X, Z, p = 1, seed = 50, wmin = 0.01, wstep = 0.01, cutoff = 5.00000000000e-06)

# Using rdrandinf on the Outcome
out = rdrandinf(nextGPA_nonorm, X, wl = -0.005, wr = 0.01, seed = 50)

