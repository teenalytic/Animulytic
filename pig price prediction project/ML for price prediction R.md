# R Machine Learning Workflow Documentation

This document explains an R script that performs a machine learning workflow for predicting corn prices based on various livestock and agricultural product prices.

## Libraries Used

The script uses the `caret` library for machine learning tasks.

```R
library(caret)
```

## Data Preparation

1. The script starts by importing a dataset named `livestockprice` into a dataframe `df`.

2. Data transformation is performed using dplyr-like syntax:
   - Selects columns containing 'avg' in their names
   - Renames selected columns for easier reference

```R
df <- df %>%
      select(contains('avg')) %>%
      select(bone_poultry = 1,
             bovine_tenderlion = 2,
             cabbage = 3,
             # ... other variables ...
             tilapia = 18)
```

## Data Splitting

The dataset is split into training (70%) and testing (30%) sets:

```R
set.seed(42)
n <- nrow(df)
id <- sample(n, size = n*0.70)
train_df <- df[id,]
test_df <- df[-id,]
```

## Model Training and Evaluation

A function `evaluate_model` is defined to train and evaluate linear regression models:

```R
evaluate_model <- function(formula) {
  ctrl <- trainControl(method = "cv", number = 5, verboseIter = TRUE)
  model <- train(formula, data = train_df, method = "lm", trControl = ctrl)
  predictions <- predict(model, newdata = test_df)
  rmse <- RMSE(predictions, test_df$egg)
  cat("Formula:", deparse(formula), "\n")
  print(summary(model))
  cat("RMSE:", rmse, "\n\n")
}
```

This function:
1. Sets up 5-fold cross-validation
2. Trains a linear regression model
3. Makes predictions on the test set
4. Calculates and prints the Root Mean Square Error (RMSE)
5. Prints the model summary

## Model Formulas

The script defines a list of formulas to evaluate different predictors for corn prices:

```R
formulas <- list(corn ~ bone_poultry, corn ~ cabbage,
                 # ... other formulas ...
                 corn ~ bovine_tenderlion)
```

## Model Evaluation

Finally, the script applies the `evaluate_model` function to each formula:

```R
lapply(formulas, evaluate_model)
```

This will train and evaluate multiple linear regression models, each using a different predictor variable to forecast corn prices.

## Output

The script will output:
1. The formula used for each model
2. A summary of each fitted model, including coefficients and statistical measures
3. The RMSE for each model on the test set

This output can be used to compare the performance of different predictors in forecasting corn prices.
