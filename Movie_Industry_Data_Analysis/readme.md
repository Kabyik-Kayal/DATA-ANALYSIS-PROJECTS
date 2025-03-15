# 🎬 Movie Industry Data Analysis

[![Python](https://img.shields.io/badge/Python-3.12-blue.svg)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-Latest-green.svg)](https://pandas.pydata.org/)
[![Matplotlib](https://img.shields.io/badge/Matplotlib-Latest-orange.svg)](https://matplotlib.org/)
[![Seaborn](https://img.shields.io/badge/Seaborn-Latest-red.svg)](https://seaborn.pydata.org/)

An exploratory data analysis of the movie industry to understand key factors influencing box office performance.

## 📊 Project Overview

This project analyzes a comprehensive dataset of movies to uncover insights about what drives commercial success in the film industry. By examining relationships between budget, gross earnings, ratings, and other factors, we aim to understand patterns that lead to profitable movies.

## 🔍 Key Findings

- **Budget-Profit Correlation**: Higher budget films tend to generate higher gross earnings (correlation coefficient: 0.7)
- **Audience Engagement**: Movie ratings (votes) show significant correlation with gross earnings
- **Director-Company Partnerships**: Identified 162 strong director-production company collaborations (3+ films)
- **Missing Data Analysis**: Implemented strategic approaches to handle incomplete data points

## 🛠️ Techniques Used

- Data cleaning and preprocessing
- Missing value imputation
- Correlation analysis
- Regression analysis
- Data visualization

## 📈 Visualizations

The project includes several visualizations:
- Budget vs. Gross Earnings scatter plot with regression line
- Correlation heatmaps for numeric and encoded features
- Director-company collaboration analysis

## 🗂️ Project Structure

```
├── data/
│   ├── movies.csv
│   └── movies.csv.zip
├── eda.ipynb
└── readme.md
```

## 🚀 Getting Started

1. Clone this repository
2. Install dependencies:
    ```bash
    pip install pandas numpy matplotlib seaborn
    ```
3. Run the Jupyter notebook:
    ```bash
    jupyter notebook eda.ipynb
    ```

## 📝 License

This project is open source and available under the [MIT License](../License).

---