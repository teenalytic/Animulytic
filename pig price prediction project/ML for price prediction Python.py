import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt

# Load data
# Assuming the data is in a CSV file named 'livestockprice.csv'
df = pd.read_csv('livestockprice.csv')

# Data transformation
columns_to_select = ['bone_poultry_avg', 'bovine_tenderlion_avg', 'cabbage_avg', 'catfish_avg',
                     'corn_avg', 'cucumber_avg', 'Doc_hen_avg', 'Doc_poultry_avg', 'egg_avg',
                     'livepig_avg', 'piglet_avg', 'pork_belly_avg', 'pork_hip_avg',
                     'pork_tenderloin_avg', 'pork_shoulder_avg', 'pork_loin_avg', 'sbm_avg', 'tilapia_avg']

df = df[columns_to_select]
df.columns = [col.replace('_avg', '') for col in df.columns]

# Split data
X = df.drop('corn', axis=1)
y = df['corn']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

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

# Evaluate models
features = [col for col in X.columns if col != 'corn']
results = []

for feature in features:
    model, rmse = evaluate_model(X_train, y_train, feature)
    results.append((feature, rmse))

# Sort results by RMSE
results.sort(key=lambda x: x[1])

# Plot results
plt.figure(figsize=(12, 6))
plt.bar([r[0] for r in results], [r[1] for r in results])
plt.title('RMSE for Different Predictors of Corn Price')
plt.xlabel('Predictor')
plt.ylabel('RMSE')
plt.xticks(rotation=90)
plt.tight_layout()
plt.show()

# Print best predictor
print(f"Best predictor: {results[0][0]} with RMSE: {results[0][1]:.4f}")
