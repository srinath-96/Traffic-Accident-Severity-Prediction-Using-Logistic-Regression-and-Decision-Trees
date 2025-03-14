# 🚗 Traffic Accident Severity Prediction Using Logistic Regression and Decision Trees

## 🎯 Project Overview
This project aims to predict the severity of traffic accidents using data-driven analytical models. By applying Logistic Regression and Decision Tree classification techniques, the analysis provides actionable insights to enhance road safety policies, optimize resource allocation, and support informed decision-making for the California Department of Transportation (Caltrans).

---

## 📌 Motivation & Context
In 2022 alone, over 42,000 individuals lost their lives in motor vehicle collisions across the United States. California specifically faces significant challenges related to road safety. This analysis leverages historical accident data from the California Highway Patrol to identify critical patterns and inform policy adjustments that can save lives and improve transportation safety statewide.

---

## 📋 Project Objectives
- Evaluate the effectiveness of current speed limit policies.
- Optimize allocation of law enforcement resources by identifying high-risk areas and times.
- Refine procedures for inclement weather conditions to enhance preparedness and safety.
- Provide Caltrans with actionable, data-driven recommendations for policy enhancements.

---

## 🗃️ Dataset Description
The dataset used in this analysis was sourced from the **Statewide Integrated Traffic Records System (SWITRS)**, focusing specifically on several counties in California:  
- San Mateo  
- San Francisco  
- Alameda  
- Santa Clara  
- Solano  
- Sonoma  
- Amador  

### Key Dataset Attributes:
- **Rows:** 2,690 entries
- **Columns:** 9 categorical features including:
  - `Severity` (Target Variable)
  - `Weekday`
  - `ViolCat` (Violation Category)
  - `Month`
  - `CrashType`
  - `ClearWeather`
  - `Highway`
  - `Daylight`

**Target Variable Distribution:** Balanced dataset with approximately 60% non-severe (`0`) and 40% severe (`1`) accident cases.

---

## 🛠️ Methodology & Analysis
The analytical workflow involved the following key steps:

### Data Preparation:
- Data cleaning (removal of duplicates, handling null values).
- Transformation of categorical variables into binary/dummy variables.
- Splitting dataset into training (70%) and testing (30%) subsets.

### Exploratory Data Analysis (EDA):
Performed visualizations to understand distributions and relationships between features and accident severity.

### Modeling Techniques Used:
1. **Logistic Regression**
   - Chosen for interpretability and efficiency with binary classification tasks.
   - Evaluated using confusion matrix, specificity, sensitivity, accuracy, and AUC metrics.
   - Cross-validation applied to ensure robust performance evaluation.

2. **Decision Tree Classification**
   - Selected for handling complex non-linear relationships within data.
   - Hyperparameter tuning and pruning performed to avoid overfitting.
   - Evaluated similarly using confusion matrix, accuracy metrics, and AUC.

---

## 📊 Results & Insights

| Model                | Specificity | Sensitivity | AUC   |
|----------------------|-------------|-------------|-------|
| Logistic Regression  | 96.6%       | 20.0%       | 0.718 |
| Decision Tree        | 96.8%       | 28.0%       | 0.712 |

**Key Findings:**
- Logistic Regression slightly outperformed Decision Trees in terms of specificity and overall AUC score.
- Decision Trees provided slightly better sensitivity but were more prone to overfitting.

---

## ⚠️ Limitations & Biases
Both models have inherent limitations:
- Logistic regression assumes linear relationships; may miss complex interactions.
- Decision trees risk overfitting if not properly pruned or tuned.
- Models depend heavily on historical data quality; biases may exist due to underrepresented severe incidents.

Potential cognitive biases (confirmation bias, availability heuristic) were mitigated through objective modeling approaches.

---

## 🚀 Recommendations & Future Enhancements
To improve model performance and decision support capabilities:
1. Integrate real-time traffic data streams for dynamic predictions.
2. Enhance feature engineering by incorporating geospatial data.
3. Develop interactive dashboards for policymakers.
4. Continuously update models with new data to maintain accuracy.

---

## 🛣️ Real-world Application
This analysis directly supports Caltrans' strategic goal of reducing traffic fatalities by informing evidence-based decisions on speed limits, police patrol allocation, and weather-related protocols.



