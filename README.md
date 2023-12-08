# Detecting hysteresis in psychological processes with the hysteretic threshold autoregressive (HysTAR) model

Repository with all materials to (re)produce the paper "Detecting hysteresis in psychological processes with the hysteretic threshold autoregressive (HysTAR) model".

## Required software (all free and open-source)

To redo the data simulations and analyses, you need to install the statistical programming language $\textsf{R}$ on your computer, which can be downloaded on [CRAN](https://cran.r-project.org). It is recommended to use $\textsf{R}$ in the [RStudio IDE](https://posit.co/products/open-source/rstudio/) (integrated development environment) app.
Additionally, for producing the manuscript itself, you need the typesetting program [LaTeX](https://www.latex-project.org/get/) installed on your computer. You can use this in a LaTeX-editor on your computer (I use [TeXmaker](https://www.xm1math.net/texmaker/download.html)) or in an online LaTeX-editor like [Overleaf](https://www.overleaf.com).

## Contents

The top folder consists of the following folders and files:

* The first step is to open `hysteresis_paper.Rproj` in RStudio.

* Then, you need to install the $\textsf{R}$-packages [`hystar`](https://daandejongen.github.io/hystar/),  [`foreign`](https://cran.r-project.org/web/packages/foreign/index.html) and [`xtable`](https://cran.r-project.org/web/packages/xtable/index.html). You can do this with the script `install_dependencies.R`. Here, it is also checked if your versions of these packages are not older than the versions I used in my study, if you already have installed the packages before. Load `session_info.RDS` for the detailed information about the software I used (open it manually in RStudio, or run `readRDS(file = "session_info.RDS")` in RStudio).

* The actual manuscript `hysteresis_manuscript.pdf` is produced by `hysteresis_manuscript.tex` (only file you need to run/compile in the TeX-editor), which imports
  
  - the `.tex` files in `tables/`, 
  
  - the `.pdf` files in `images/` and 
  
  - `references.bib`.
  
* The tables and images are produced by the $\textsf{R}$-scripts in the folders `simulation_studies/`, `major_depression/` and `speed_accuracy_trade_off/`. In these folders, you will find all code to reproduce the analyses I did for the current project. These folders have their own README file.
