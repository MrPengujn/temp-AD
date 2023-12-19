# Wine Quality Prediction Research

## Overview

This repository contains the code and analysis for a research project focused on predicting wine quality based on chemical attributes. Three linear regression models—Simple Linear Regression, Multiple Linear Regression, and a model incorporating All Possible Main Effects—were systematically evaluated using a comprehensive dataset.

## Files

- `src/main.r`: This R Markdown file contains the code and analysis for the research. It covers data preprocessing, model training, evaluation, and visualization of results.

- `src/eda.r`: This R Markdown file contains the code for the EDA part of the research, plots and such...

- `src/WineQuality.csv`: The dataset used in the analysis. It includes columns such as fixed acidity, volatile acidity, citric acid, and others.

## Usage

1. **Clone the Repository:**
   ```
   git clone https://github.com/your-username/wine-quality-prediction.git
   cd wine-quality-prediction
   ```

2. **Open and Run the Analysis:**
   Open `src/main.r` in an R Markdown compatible environment (e.g., RStudio) and run the code chunks sequentially to reproduce the analysis.

3. **Explore Results:**
   Examine the generated plots, metrics, and insights in the analysis to understand the performance of different regression models in predicting wine quality.

## Dependencies

Ensure that you have R and R libraries such as `dplyr`, `ggplot2`, and `caret` installed. You can install them using:

```
install.packages(c("dplyr", "ggplot2", "caret", "rsample", "vip"))
```

## Acknowledgments

This research builds upon the work of various contributors in the field of predictive modeling and wine quality analysis. The dataset used is publicly available and cited within the analysis.
