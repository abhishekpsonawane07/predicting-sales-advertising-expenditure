# 📊 Predicting Sales from Advertising Expenditure

A comprehensive statistical analysis investigating the relationship between advertising expenditure across TV, Radio and Newspaper channels and product sales across 200 markets.



---

## 📌 Project Overview

This project analyses the [Advertising Dataset]((https://www.kaggle.com/datasets/bumba5341/advertisingcsv)) to answer a key business question:

> **Which advertising channels most effectively drive product sales, and how should a marketing manager allocate budget to maximise returns?**


---

## 📦 Dataset

- **Source:** [Kaggle - Advertising Dataset]([https://www.kaggle.com/datasets/bumba5341/advertisingcsv])
- **Size:** 200 observations, 4 variables
- **Variables:**
  - `TV` — Advertising budget spent on TV ($000s)
  - `Radio` — Advertising budget spent on Radio ($000s)
  - `Newspaper` — Advertising budget spent on Newspaper ($000s)
  - `Sales` — Product sales in thousands of units

---

## 🔬 Methodology

| Task | Method | Key Finding |
|------|--------|-------------|
| Exploratory Data Analysis | Summary statistics, histograms, boxplots | TV has highest variance (SD=$85k) |
| Correlation Analysis | Pearson correlation matrix, heatmap | TV-Sales correlation = 0.90 |
| Simple Linear Regression | OLS regression (TV → Sales) | R² = 0.812 |
| Multiple Linear Regression | OLS regression (TV+Radio+Newspaper → Sales) | R² = 0.903 |
| Model Diagnostics | Residual plots, Q-Q plot, Cook's distance | Minor heteroscedasticity, 2 outliers |
| Model Comparison | R², Adjusted R², RSE | Multiple model reduces error by 27.6% |
| Hypothesis Testing | T-tests, One-way ANOVA, Tukey post-hoc | TV and Radio significant, Newspaper not |
| PCA | Principal Component Analysis | TV independent from Radio/Newspaper |
| Clustering | Hierarchical clustering (Ward's method) | 3 distinct market types identified |
| Machine Learning | Random Forest (500 trees) | 90.25% variance explained |

---

## 📈 Key Findings

- **TV advertising** is the strongest predictor of sales (r = 0.90, R² = 0.812 alone)
- **Radio advertising** delivers **double** the sales return per $1,000 compared to TV
  - Radio: +107 units per $1,000 spent
  - TV: +55 units per $1,000 spent
- **Newspaper advertising** shows no statistically significant effect on sales across any analysis (p = 0.954)
- Random Forest independently confirmed regression findings (90.25% accuracy)

---

## 💡 Business Recommendation

> For a marketing manager with an additional **$10,000** budget:
> - Allocating to **Radio** → +1,070 units additional sales
> - Allocating to **TV** → +544 units additional sales
>
> **Recommendation: Allocate to Radio for maximum ROI**

---

## 🛠️ Technologies Used

```r
# Core packages used
library(corrplot)      # Correlation visualisation
library(randomForest)  # Random Forest modelling
```

- **Language:** R (v4.x)
- **IDE:** RStudio
- **Key Packages:** corrplot, randomForest, base R stats

---

## 📊 Sample Visualisations

| Correlation Heatmap | Variable Importance |
|---------------------|---------------------|
| TV dominates with r=0.90 | TV highest in Random Forest |

---

## 📚 References

- James, G., Witten, D., Hastie, T. and Tibshirani, R. (2021) *An Introduction to Statistical Learning*. 2nd ed. Springer.
- Ashydv (2020) *Advertising Dataset*. Kaggle.
- R Core Team (2024) *R: A Language and Environment for Statistical Computing*.

---

## 👤 Author

**Abhishek Sonawane**  

