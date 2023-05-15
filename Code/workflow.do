



* (1) Establish whether the RD assumptions are plausible
[TOMORROW]

* (2) rdPLOT
rdplot Y X

* (3) If using local polynomial
rdrobust Y X, p(1)

* (4) Explore robustness of the result
rdrobust Y X, p(1) h(5)
rdrobust Y X, p(1) h(5) kernel(uniform)
rdrobust Y X, p(1) bwselect(cerrd)