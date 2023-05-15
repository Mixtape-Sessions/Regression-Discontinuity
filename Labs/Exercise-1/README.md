
# Exercise 1: Continuity-based analysis of the Meyersson application

In this exercise, you will re-analyze the data in [Meyersson (2014)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/Meyersson2014-ECTA.pdf). The Meyersson application is described and replicated in Section 1 of [Cattaneo, Idrobo and Titiunik (2020)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2020-CUP-Foundations-preprint.pdf). The data is in the file `polecon.dta` (Stata format) and `polecon.csv` (comma separated values format). 

Meyersson is broadly interested in the effect of Islamic parties’ control of local governments on women’s rights, in particular on the educational attainment of young women. To study this ques- tion, he uses an RD design focused exclusively on the 1994 Turkish mayoral elections. Specifically, the unit of analysis is the municipality, and the score (variable `X` in the dataset) is the Islamic margin of victory—defined as the difference between the vote share obtained by the largest Islamic party, and the vote share obtained by the largest secular party opponent. The main outcome of interest (variable `Y` in the dataset) is the school attainment for women who were (potentially) in high school during the period 1994-2000, measured with variables extracted from the 2000 census. The particular outcome we re-analyze is the share of the cohort of women ages 15 to 20 in 2000 who had completed high school by 2000.

## Part 1: Continuity-Based Analysis

1. Explore the range and density of the running variable. Is this a continuous random variable?

2. Always plot the data first!
  - Produce RD plots using rdplot for the outcome variable.
  - Do not forget to vary the number of bins used, and look at the difference between quantile bins and evenly-spaced bins.
  - Re-explore the effects of varying the polynomial order for the global fit.

3. Compute optimal bandwidth choices using rdbwselect for the outcome variable.
  - Consider the same and different bandwidths for each side of the cutoff, and MSE versus CER optimal bandwidths.
  - Is the estimated bandwidth sensitive to these choices?

4. Explore the influence of tuning parameters for bandwidth selection.
  - How do estimated bandwidth change when you restrict the support of the running variable?
  - How do estimated bandwidth change when you change the order of local polynomials?

5. Use rdrobust to estimate the RD treatment effects using local polynomials with optimal bandwidth selection.

6. Produce RD estimates and confidence intervals using rdrobust for each outcome variable.
  - Obtain the same results for all three approaches: conventional, bias-corrected & robust.
  - What happens if you change the kernel shape?
  - What happens if you change the standard error estimation method?
  - What happens if you change the bandwidth selection method?
  - What happens if you change the order of polynomials used?

