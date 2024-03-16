<img src="https://raw.githubusercontent.com/Mixtape-Sessions/Regression-Discontinuity/main/img/banner.png" alt="Mixtape Sessions Banner" width="100%"> 


## About

This course covers methods for the analysis and interpretation of the Regression Discontinuity (RD) design, a non-experimental strategy to study treatment effects that can be used when units receive a treatment based on a score and a cutoff. The course covers methods for estimation, inference, and falsification of RD treatment effects using two different approaches: the continuity-based framework, implemented with local polynomials, and the local randomization framework, implemented with standard tools from the analysis of experiments. The focus is on conceptual understanding of the underlying methodological issues and effective empirical implementation. Every topic is illustrated with the analysis of RD examples using real-world data, walking through R and Stata codes that fully implement all the methods discussed. At the end of the course, participants will have acquired the necessary skills to rigorously interpret, visualize, validate, estimate, and characterize the uncertainty of RD treatment effects.


## Overview 

The goal of this workshop is to give an introduction to standard and recent methodological developments in the analysis and interpretation of regression discontinuity (RD) designs. The course focuses on methodology and empirical practice, as well as on conceptual issues, but not on the technical details of the statistical and econometric theory underlying the results. A brief
description of the course, along with references to further readings, is given below.

It is assumed that participants have elementary working knowledge of statistics, econometrics and policy evaluation. It would be useful, but not required, if participants were familiar with basic results from the literature on program evaluation and treatment effects at the level of Wooldridge (2010). The course is nonetheless meant to be self-contained and hence most underlying statistics/econometrics concepts and results are introduced and explained in class

## Schedule

### Day 1 

Introduction to Sharp RD design and graphical illustration. Continuity based framework: estimands, identification assumptions, and point estimation.

- Sharp RD design: introduction and graphical illustration with RD plots.
- Continuity based RD analysis: estimands and identification.
- Estimation of RD effects with local polynomials.
- Optimal bandwidth selection.

#### Readings
[Cattaneo, Idrobo, and Titiunik (2020)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2020-CUP-Foundations-preprint.pdf), Chapters 1, 2, 3, and Sections 4.1 and 4.2 in Chapter 4.

### Day 2

Continuity based framework, continued: robust inference based on local polynomials. Introduction to local randomization framework: estimands, window selection, estimation and inference.

- Continuity based RD analysis, continued:
  – Robust confidence intervals based on local polynomials
- Local Randomization RD analysis
  – Inferences based on Fisherian methods
  – Window selection based on covariates
  – Inferences based on large-sample methods

#### Readings
[Cattaneo, Idrobo, and Titiunik (2020)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2020-CUP-Foundations-preprint.pdf), Chapter 4. [Cattaneo, Idrobo, and Titiunik (2023)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2023-CUP-Extensions.pdf), Chapter 2.

### Day 3
RD local randomization analysis, RD falsification methods, and extensions to canonical RD design.

- Falsification of RD assumptions: density and covariate balance tests
- The RD design under imperfect compliance

#### Readings

[Cattaneo, Idrobo, and Titiunik (2020)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2020-CUP-Foundations-preprint.pdf), Chapter 5; [Cattaneo, Idrobo, and Titiunik (2023)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2023-CUP-Extensions.pdf), Chapter 3.



### Slides

[RD Slides](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Slides/RD.pdf)


### Coding Exercises

[Exercise 1: Meyersson (2014)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/tree/main/Labs/Exercise-1/) 

[Exercise 2: Caughey and Sekhon (2011)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/tree/main/Labs/Exercise-2/) 

[Additonal code for all covered material](https://github.com/Mixtape-Sessions/Regression-Discontinuity/tree/main/Code/)



### Readings

#### Essential

[Cattaneo, Idrobo, and Titiunik (2020)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2020-CUP-Foundations-preprint.pdf)

[Cattaneo, Idrobo, and Titiunik (2023)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2023-CUP-Extensions.pdf)

#### Background

[Cattaneo, Frandsen, and Titiunik (2015)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoFrandsenTitiunik2015-JCI.pdf)

[Cattaneo and Titiunik (2022)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoTitiunik2022-ARE.pdf)

[Imbens and Lemieux (2008)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/ImbensLemieux2008-JoE.pdf)

[Lee and Lemieux (2010)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/LeeLemieux2010-JEL.pdf)

#### Coding Labs

[Caughey and Sekhon (2011)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CaugheySekhon2011-PA.pdf)

[Meyersson (2014)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/Meyersson2014-ECTA.pdf)


### Computing and Software 

To participate in the hands-on exercises, you are strongly encouraged to secure access to a computer with the most recent version of `Stata` or `R` plus `RStudio` installed.

All functions and packages are available in `Stata`, which is not free, and `R`, a free and open- source statistical software environment. We also have `Python` versions of some of the packages (we are still in the process of creating Python libraries for all the commands).

The workshop will employ several empirical illustrations, which will be analyzed using `Stata` and/or `R`. The following `Stata`/`R`/`Python` modules modules/commands will be used:

- [rdrobust](https://rdpackages.github.io/rdrobust): RD inference employing local polynomial and partitioning methods. See Calonico, Cattaneo and Titiunik ([2014](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1401400413), [2015](https://journal.r-project.org/archive/2015/RJ-2015-004/RJ-2015-004.pdf)) for introductions.

- [rddensity](https://rdpackages.github.io/rddensity): Manipulation testing for RD designs. See [Cattaneo, Jansson and Ma (2018)](https://journals.sagepub.com/doi/10.1177/1536867X1801800115) for an introduction.

- [rdlocrand](https://rdpackages.github.io/rdlocrand): RD inference employing randomization inference methods. See [Cattaneo, Titiunik and Vazquez-Bare (2016)](https://journals.sagepub.com/doi/10.1177/1536867X1601600205) for an introduction.

- [rdmulti](https://rdpackages.github.io/rdmulti): Local polynomial methods for estimation and inference for RD designs with multiple cutoffs.

- [rdpower](https://rdpackages.github.io/rdpower): Power and sample size calculations using robust bias-corrected local polynomial inference methods.

Further details, including how to install the packages in both R and Stata may be found at: https://rdpackages.github.io

Replication files in both `R` and `Stata` for all the empirical analyses in [Cattaneo, Idrobo, and Titiunik (2020)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2020-CUP-Foundations-preprint.pdf) and [Idrobo, and Titiunik (2023)](https://github.com/Mixtape-Sessions/Regression-Discontinuity/raw/main/Readings/CattaneoIdroboTitiunik2023-CUP-Extensions.pdf) may be found at: https://github.com/rdpackages-replication/CIT_2020_CUP

Please make sure you have `Stata` or `R` and the above modules/commands installed and fully functional in your personal computer before the course begins. Datasets, do-files and `R` files will be provided in advance.

<details closed><summary>Software installation instructions</summary>

If you will be using R, I suggest also installing RStudio. To install these programs, follow the
instructions below:

1. Download the most recent version of [R](https://www.r-project.org/) and install it in your computer. R is free and available for Windows, Mac, and Linux operating systems. Download the version of R compatible with your operating system from [CRAN](https://cloud.r-project.org/). If you are running Windows or MacOS, you should choose one of the precompiled binary distributions (i.e., ready-to-run applications) that are linked at the top of the page, not the source codes.

2. Download and install [R Studio](https://www.rstudio.com/products/rstudio/download/). This is an integrated development environment (IDE) that includes a console, a syntax-highlighting editor, and other tools for plotting, history, debug- ging and workspace management for R use. RStudio is free and available for Windows, Mac, and Linux platforms. 

If you are using Stata, you will have to obtain a license from [here](https://www.stata.com/). Stata is licensed through [StataCorp](http://www.stata.com/) and is frequently offered at a significant discount through academic institutions to their employees and students. Seminar participants who are not yet ready to purchase Stata could take advantage of StataCorp’s 30-day software return policy and obtain the latest version of Stata on a trial basis in the weeks immediately preceding this course. Use this link for 30-day trial copy: http://www.stata.com/customer-service/evaluate-stata/



<details closed><summary>Package installation instructions</summary>

You will need to install the following packages: `rdrobust`, `rddensity`, `rdlocrand`, `rdpower` and `rdmulti`. In R, make sure you have an internet connection and then launch R Studio. Copy the following line of text and paste them in to R’s command prompt (located in the window named “Console”):

```r
install.packages("rdrobust")
install.packages("rddensity")
install.packages("rdlocrand")
install.packages("rdpower")
install.packages("rdmulti")
```

In Stata, make sure you have an internet connection and then type:

```stata
net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
net install rdlocrand, from(https://raw.githubusercontent.com/rdpackages/rdlocrand/master/stata) replace
net install rdpower, from(https://raw.githubusercontent.com/rdpackages/rdpower/master/stata) replace
net install rdmulti, from(https://raw.githubusercontent.com/rdpackages/rdmulti/master/stata) replace
```





