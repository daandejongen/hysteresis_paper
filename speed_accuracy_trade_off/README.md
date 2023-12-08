The main script is `data_analysis_SAT.R`. It `source`s functions from these scripts:

* `fit.R`, to fit the HysTAR or TAR model to SAT data

* `ljung-box-tests.R`, to evaluate model fit using the Ljung-Box test on the predictive residuals

* `plot_SAT.R`, to save plots of the data to `manuscript/images/`

The original data are in SPSS format (`.sav`), in the folder `data_raw/`. The script `process_data.R` takes these data as an input and makes it ready for analysis, and stores the processed data in `data_processed/`
