#------------------------------------------------------------------------------#
#  Part 3: RD plots
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
T = (X>=0)

summary(data)
length(X)
length(unique(X))
length(Y)
length(unique(Y))


# Figure 3.1, Scatter plot
plot(X, Y, xlab = "Running Variable", ylab = "Outcome", col=1, pch=20)
abline(v=0)

# Figure 3.2, RD Plot Using 40 Bins of Equal Length
out = rdplot(Y, X, nbins = c(20,20), binselect = 'esmv')

# Figure 3.4, 40 Evenly-Spaced Bins
out = rdplot(Y, X, nbins = c(20,20), binselect = 'es')

# Figure 3.5, 40 Quantile-Spaced Bins
out = rdplot(Y, X, nbins = c(20,20), binselect = 'qs')

# Figure 3.7, IMSE RD PLot with Evenly-Spaced Bins
out = rdplot(Y, X,  binselect = 'es')

# Figure 3.8, IMSE RD Plot with Quantile-Spaced Bins
out = rdplot(Y, X,  binselect = 'qs')

# Figure 3.10, Mimicking Variance RD Plot with Evenly-Spaced Bins
out = rdplot(Y, X,  binselect = 'esmv')

# Figure 3.11, Mimicking Variance RD Plot with Quantile-Spaced Bins
out = rdplot(Y, X,  binselect = 'qsmv')

out = rdplot(Y, X,  binselect = 'qsmv', kernel = 'uniform', support = c(-150,150))
