#------------------------------------------------------------------------------#
#  Part 5: Fuzzy RD
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

# Application by LONDONO-VELEZ, RODRIGUEZ AND SANCHEZ: Ser Pilo Paga (SSP) program
# Fuzzy RD analysis (using only one dimension) 

data = read.dta13("spp.dta")
dim(data)
names(data)

# This replication file only includes first cohort (icfes_per == 20142), as in original replication files
table(data$icfes_per)
dim(data)

# Running variables
summary(data$running_saber11)  #/* this running variable is discrete:  447  unique values*/
  
summary(data$running_sisben)   #/* this running variable is discrete but number of masspoints is large:  25,375 unique values*/
  
#  treatment indicator (=1 if the student in fact received the money)
summary(data$beneficiary_spp)

# Keep subsample of students with scores above Saber 11 cutoff
summary(data$running_saber11)
data=data[data$running_saber11>=0,]
dim(data)

# Students who live in households who don't receive welfare benefits have missing score ==> drop missing scores
sum(is.na(data$running_sisben))
data = data[!is.na(data$running_sisben),]
dim(data)
    
    
# Create variables
X = data$running_sisben
D = data$beneficiary_spp
Y1 = data$ spadies_any
Y2 = data$spadies_hq

# First Stage: T on D
#-------------
# Rdrobust on D
out = rdrobust(D,X)
summary(out)

# Rdplot on D
rdplot(D,X, x.label="SISBEN wealth index", y.label="Received SPP subsidy")

# ITT: T on Y
#-------------
rdplot(Y1,X, x.label="SISBEN wealth index", y.label="Attended any HEI")

out = rdrobust(Y1,X)
summary(out)

# Rddensity
#----------
out = rddensity(X)
summary(out)

# Outcome 1: Student Attended any high education institution (HEI) immediately after receiving subsidy
#--------------------

# Fuzzy effect
fout = rdrobust(Y1, X, fuzzy = D)
h = fout$bws[1,1]
b = fout$bws[2,1]

# equivalent to the two-step estimation below
# be careful! if there are missing values in D, you may fail to replicate the fuzzy effect by hand
sum(is.na(D))

out = rdrobust(Y1, X, h = h, b=b)
itt = out$Estimate[1]

out = rdrobust(D, X, h=h, b=b)
fs = out$Estimate[1]

itt/fs

# Rdrobust (sharp) on Y1: cluster by mass point in running variable
out = rdrobust(Y1, X, vce = "nn", cluster = X)
summary(out)

# Rdrobust (fuzzy) on Y1
out = rdrobust(Y1, X, fuzzy = D, vce = "nn", cluster= X)
summary(out)

# Rdplot on Y1
rdplot(Y1, X)


# Outcome 1: Student Attended high-quality HEI immediately after receiving subsidy
#-------------------------------
# Rdrobust (sharp) on Y2
rdrobust(Y2, X)

# Rdrobust (fuzzy) on Y2
rdrobust(Y2, X, fuzzy =D)

# Rdplot on Y2
rdplot(Y2, X, fuzzy = D)

# Validation on Covariates
#-------------------------
# Sharp rdrobust
covs = cbind(data$icfes_per, data$icfes_female, data$icfes_urm, data$icfes_stratum, data$icfes_privatehs, data$icfes_famsize)
for(i in 1:ncol(covs)){ 
	summary(rdrobust(covs[,i], X))
}

# Fuzzy rdrobust
for(i in 1:ncol(covs)){ 
  summary(rdrobust(covs[,i], X, fuzzy=D))
}


# Local randomization Fuzzy RD analysis

rdwinselect(X, covs, seed=86543)
wr = 0.13
wl = -0.13
rdrandinf(D, X, wl=wl, wr=wr)
rdrandinf(Y1, X, wl=wl, wr=wr)
rdrandinf(Y2, X, wl=wl, wr=wr)
rdrandinf(Y2, X, wl=wl, wr=wr, fuzzy=D)

          