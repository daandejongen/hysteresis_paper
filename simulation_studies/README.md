# Simulation studies

The current study consists of two simulation studies, one on model selection and one on parameter estimation. Both simulation studies are contained in the main script `simulation_studies.R`. In this script, all other helper scripts are `source`d:

* `compute_unique_z.R` computes the number of unique values of the control variable (80% inner range) given $n_t$ and $n_switches$.

* `create_table.R` to collect finite-sample performance measures (bias, variance, etc.) of estimator(s) into an R-matrix. This is for a single setting of the hysteresis zone $r \in \{(0, 0], (-0.25, 0.25], (-0.5, 0.5]\}$. The other settings, number of time points $n_t$, number of switches $n_switches$ and $\phi$-values, are distributed over the rows and columns.

* `generate_example_plots.R` defines a function to create the figure in the paper with three examples of simulated time series from the HysTAR model.

* `outcome_measures.R` defines functions to compute finite-sample performance of the estimators, like bias, variance, mean squared error, confidence interval coverage rate. Additionally, it contains functions to select the model (TAR vs. HysTAR) based on information criteria or the Ljung-Box test for no autocorrelation on the predictive residuals.

* `plot_simulation_results.R` defines a function to visualize performance measures for certain estimators. Conditions are distinguished by rows, columns, and line color.

* `setup.R` creates the conditions for the simulations. 

* `workers.R` contains a function that does the real work: `get_estimates()`. Here, the data are generated, the HysTAR and TAR model are fitted and the relevant estimates are extracted and stored. 

