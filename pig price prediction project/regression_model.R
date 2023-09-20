##Created Machine learning model

#import essensial library
library(tidyverse)
library(caret)

# import csv file to Dataframe
df <- read_csv("livestockprice_cleaned.csv")

# Split data
set.seed(42)
n <- nrow(df)
id <- sample(n, size = n*0.70)
train_df <- df[id,]
test_df <- df[-id,]

#train linear regession model 1 : pork_belly
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_pork_belly <- train(finished_pig ~ pork_belly,
                   data = train_df,
                   method = "lm",
                   trControl = ctrl)

#test linear regession model 1 : pork_belly
p_lm <- predict(lm_model_pork_belly, newdata = test_df)


#evaluated linear regession model 1 : pork_belly
RMSE(p_lm, test_df$finished_pig)
summary(lm_model_pork_belly)

#plot1 linear regession model 1 : pork_belly
df %>%
  ggplot(aes(pork_belly,finished_pig)) +
  geom_point(color = "blue")+
  geom_smooth(color = "salmon",method = "glm", alpha = 0.5)



#train logistic regession model 2 :pork_shoulder
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_shoulder <- train( finished_pig ~ pork_shoulder ,
                            data = train_df,
                            method = "lm",
                            trControl = ctrl)

#test model logistic regession model 2 :pork_shoulder
p_lm_shoulder <- predict(lm_model_shoulder, newdata = test_df)


#evaluated logistic regession model 2 :pork_shoulder
RMSE(p_lm_shoulder, test_df$finished_pig)
summary(lm_model_shoulder)

#plot2 logistic regession model 2 :pork_shoulder
df %>%
  ggplot(aes(pork_shoulder,finished_pig)) +
  geom_point(color = "#e072b4")+
  geom_smooth(color = "salmon",method = "glm", alpha = 0.5)



#train logistic regession model 3 :piglet
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_piglet <- train( finished_pig ~ piglet ,
                            data = train_df,
                            method = "lm",
                            trControl = ctrl)

#test model logistic regession model 3 :piglet
p_lm_piglet <- predict(lm_model_piglet, newdata = test_df)


#evaluated logistic regession model 3 :piglet
RMSE(p_lm_piglet, test_df$finished_pig)
summary(lm_model_piglet)

#plot3 logistic regession model 3 :piglet
piglet <- df %>%
  ggplot(aes(piglet,finished_pig)) +
  geom_point(color = "#7a8f93")+
  geom_smooth(color = "salmon",method = "glm", alpha = 0.5)


#train logistic regession model 4 :egg
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_egg <- train( finished_pig ~ egg ,
                          data = train_df,
                          method = "lm",
                          trControl = ctrl)

#test logistic regession model 4 :egg
p_lm_egg <- predict(lm_model_egg, newdata = test_df)


#evaluated logistic regession model 4 :egg
RMSE(p_lm_egg, test_df$finished_pig)
summary(lm_model_egg)

#plot4 logistic regession model 4 :egg
egg <- df %>%
  ggplot(aes(egg,finished_pig)) +
  geom_point(color = "#e3ac17")+
  geom_smooth(color = "salmon",method = "glm", alpha = 0.5)


#train logistic regession model 5 :bone_poultry
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_bone_poultry <- train( finished_pig ~ bone_poultry ,
                       data = train_df,
                       method = "lm",
                       trControl = ctrl)

#test logistic regession model 5 :bone_poultry
p_lm_bone_poultry <- predict(lm_model_bone_poultry, newdata = test_df)


#evaluated logistic regession model 5 :bone_poultry
RMSE(p_lm_bone_poultry, test_df$finished_pig)
summary(lm_model_bone_poultry)

#plot5 logistic regession model 5 :bone_poultry
bone_poultry <- df %>%
  ggplot(aes(bone_poultry,finished_pig)) +
  geom_point(color = "#11a6a1")+
  geom_smooth(color = "salmon",method = "glm", alpha = 0.5)


#train logistic regession model 6 :mixed pork_belly+piglet+ pork_shoulder
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_mix <- train( finished_pig ~ pork_belly+piglet+ pork_shoulder,
                   data = train_df,
                   method = "lm",
                   trControl = ctrl)

#test logistic regession model 6 :mixed pork_belly+piglet+ pork_shoulder
p_lm_mix <- predict(lm_model_mix, newdata = test_df)


##Evaluated
RMSE(p_lm_mix, test_df$finished_pig)
summary(lm_model_mix)
