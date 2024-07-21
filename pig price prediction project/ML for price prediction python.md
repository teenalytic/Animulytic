# Python Machine Learning Workflow Documentation

This document explains a Python script that performs a machine learning workflow for predicting corn prices based on various livestock and agricultural product prices.

## Libraries Used

The script uses the following libraries:

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt
```

## Data Preparation

The script starts by importing a dataset from a CSV file:

```python
df = pd.read_csv("https://raw.githubusercontent.com/teenalytic/Animulytic/main/pig%20price%20prediction%20project/2024/livestockprice_prep.csv")
```


## Data Splitting

The dataset is split into features (X) and target variable (y), then into training (70%) and testing (30%) sets:

```python
X = df.drop('corn', axis=1)
y = df['corn']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
```

## Model Training and Evaluation

A function `evaluate_model` is defined to train and evaluate linear regression models:

```python
def evaluate_model(X, y, feature):
    X_feature = X[[feature]]
    model = LinearRegression()
    
    # Cross-validation
    cv_scores = cross_val_score(model, X_feature, y, cv=5, scoring='neg_mean_squared_error')
    cv_rmse = np.sqrt(-cv_scores.mean())
    
    # Train on full training set
    model.fit(X_feature, y)
    
    # Predictions on test set
    y_pred = model.predict(X_test[[feature]])
    test_rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    
    # Print results
    print(f"Formula: corn ~ {feature}")
    print(f"Coefficient: {model.coef_[0]:.4f}")
    print(f"Intercept: {model.intercept_:.4f}")
    print(f"Cross-validation RMSE: {cv_rmse:.4f}")
    print(f"Test RMSE: {test_rmse:.4f}")
    print("\n")
    
    return model, test_rmse
```

This function:
1. Trains a linear regression model using a single feature
2. Performs 5-fold cross-validation
3. Evaluates the model on the test set
4. Prints out the model details and performance metrics

## Model Evaluation Loop

The script evaluates models for each feature:

```python
features = [col for col in X.columns if col != 'corn']
results = []

for feature in features:
    model, rmse = evaluate_model(X_train, y_train, feature)
    results.append((feature, rmse))

# Sort results by RMSE
results.sort(key=lambda x: x[1])
```

## Visualization

The script creates a bar plot to visualize the RMSE for each predictor:

```python
plt.figure(figsize=(12, 6))
plt.bar([r[0] for r in results], [r[1] for r in results])
plt.title('RMSE for Different Predictors of Corn Price')
plt.xlabel('Predictor')
plt.ylabel('RMSE')
plt.xticks(rotation=90)
plt.tight_layout()
plt.show()
```

## Results

Finally, the script prints out the best predictor:

```python
print(f"Best predictor: {results[0][0]} with RMSE: {results[0][1]:.4f}")
```

## Output

The script will output:
1. For each model:
   - The formula used
   - The coefficient and intercept
   - The cross-validation RMSE
   - The test set RMSE
2. A bar plot visualizing the RMSE for each predictor
3. The best predictor and its RMSE

This output can be used to compare the performance of different predictors in forecasting corn prices.
