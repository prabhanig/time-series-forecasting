# Time Series Analysis Project

## Description
This project explores and analyzes time series data using ARIMA, SARIMA, and ARMA models. Two datasets were analyzed to demonstrate the application of statistical modeling and forecasting techniques:

1. **UK Tourist Visits (1980–2020):** Quarterly data of tourists visiting the UK.
2. **Sunspots (1749–2021):** Monthly mean sunspots data.

The project includes Exploratory Data Analysis (EDA), stationarity checks, model fitting, residual diagnostics, and forecasting for both datasets.

---

## Datasets
### UK Tourist Visits
- **Source:** Office for National Statistics
- **Period:** Q1 1980 to Q1 2020
- **Key Features:**
  - Clear trend and seasonal patterns.
  - Analyzed using seasonal ARIMA models.

### Sunspots
- **Source:** [Kaggle Sunspots Dataset](https://www.kaggle.com/robervalt/sunspots)
- **Period:** January 1749 to January 2021
- **Key Features:**
  - Stationary data after transformations.
  - Analyzed using ARMA models.

---

## Requirements
To reproduce the results, ensure the following software and libraries are installed:

- **Software:** R (version 4.1 or higher)
- **R Libraries:**
  - `forecast`
  - `ggplot2`
  - `tseries`
  - `TSA`
  - `fpp2`
  - `readr`
  - `magrittr`

---

## Project Structure
The repository is organized as follows:
```
Time-Series-Analysis/
├── README.md            # Project documentation
├── data/                # Datasets used for analysis
│   ├── UKTouristsVisits.csv
│   └── Sunspots.csv
├── scripts/             # R scripts for analysis
│   ├── Time_Series_CW_TS1.R
│   ├── Time_Series_CW_TS2.R
├── report/              # Final report
│   └── MS4S09_CW2_30050079.pdf
├── results/             # Plots and outputs
```

---

## Usage
### Clone the Repository
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/your-username/time-series-analysis.git
   ```

2. Navigate to the project folder:
   ```bash
   cd time-series-analysis
   ```

### Run the Scripts
To execute the analysis:

1. Open RStudio or your preferred R environment.
2. Run the scripts in the `scripts/` folder:
   - For **UK Tourist Visits**:
     ```r
     source("scripts/Time_Series_CW_TS1.R")
     ```
   - For **Sunspots**:
     ```r
     source("scripts/Time_Series_CW_TS2.R")
     ```

### Outputs
- Plots and forecasts will be generated for each time series.
- Residual diagnostics and model evaluation will be printed in the R console.

---

## Results
### Key Findings
#### UK Tourist Visits
- **Best Model:** ARIMA(1,1,1)(1,1,1)[4]
- Seasonal trends were identified and successfully modeled.
- Forecasts aligned closely with observed values, with residuals following white noise.

#### Sunspots
- **Best Model:** ARMA(1,9)
- The data was stationary after necessary transformations.
- Predictions captured the cyclical nature of sunspot activity but showed some deviations.

### Forecast Accuracy
Forecast accuracy for both datasets was evaluated using Mean Squared Error (MSE) and Root Mean Squared Error (RMSE). Detailed results can be found in the report (`report/MS4S09_CW2_30050079.pdf`).

---

## References
1. Office for National Statistics. (2020). UK Tourist Visits.
2. Kaggle. (n.d.). [Sunspots Dataset](https://www.kaggle.com/robervalt/sunspots).

---

## License
This project is for educational purposes and follows academic integrity guidelines. If reusing any content, please provide proper attribution.

---

## Author
- **Student ID:** 30050079
- For questions or collaborations, contact via GitHub.
