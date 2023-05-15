
# Exercise 2: Caughey and Sekhon Application

In this exercise, you will re-analyze the data in [Caughey and Sekhon (2011)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CaugheySekhon2011-PA.pdf). The data is in the file `CaugheySekhon2011.dta` (Stata format) and `CaugheySekhon2011.csv` (comma separated values format). 

The authors are interested in estimating the incumbency advantage at the party level. To study this question, they use an RD design focused exclusively on U.S. House elections. Specifically, the unit of analysis is the U.S. congressional district, and the score (variable `DifDPct` in the dataset) is the margin of victory of the Democratic party—defined as the difference between the vote share obtained by the Democratic party and the vote share obtained by the Democratic party’s strongest opponent. The main outcome of interest (variable `DWinNxt` in the dataset) is the Democratic party’s victory in the following election.

## Part 1: Continuity-based Falsification

1. Try to validate the RD design.
  - Plot the histogram of the running variable.
  - Conduct a binomial test for counts and a density test.
  - Look at covariate balance, both graphically and formally.
  - Do not forget to plot with the rdbinselect command!

2. Do you think this design is credible under a continuity assumption?

## Part 2: Local randomization Falsification

1. Select a window based on the two covariates given

2. Try to provide empirical evidence supporting the local-randomization assumption in the window you chose.

3. Do you think this design is credible under a local randomization assumption?

## Part 3: Compare both approaches

1. Do you reach different conclusions from the two approaches? Is this RD design valid? Why/Why not?
