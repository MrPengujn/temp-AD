# NOTE: Lib import ---------------------------------------
library(dplyr)
library(ggplot2)

library(caret)
library(rsample)

library(vip)

# NOTE: Dataset preparation ---------------------------------------
wine_df <- read.csv("./src/WineQuality.csv")
wine_df <- wine_df %>% select(-Id)

# NOTE: Removing outliers with the IQR method
outlier_threshold <- 1.5

summary(wine_df)
for (col in names(wine_df)) {
  if (is.numeric(wine_df[[col]])) {
    q1 <- quantile(wine_df[[col]], 0.25)
    q3 <- quantile(wine_df[[col]], 0.75)
    iqr_val <- q3 - q1
    lower_bound <- q1 - outlier_threshold * iqr_val
    upper_bound <- q3 + outlier_threshold * iqr_val
    wine_df <- wine_df[
      wine_df[[col]] >= lower_bound & wine_df[[col]] <= upper_bound,
    ]
  }
}
summary(wine_df)

# NOTE: Data Splitting ---------------------------------------
set.seed(123)
split <- initial_split(wine_df, prop = 0.7, strata = "quality")
wine_train <- training(split)
wine_test <- training(split)


# NOTE: Simple linear regression ---------------------------------------
slr_model <- lm(quality ~ alcohol, data = wine_train)
sigma(slr_model) # RMSE
sigma(slr_model) # MSE
summary(slr_model)


# NOTE: multiple linear regression ---------------------------------------
mlr_model <- lm(quality ~ alcohol + volatile_acidity, data = wine_train)
summary(mlr_model)


# NOTE: all possible main effects ---------------------------------------
aplr_model <- lm(quality ~ ., data = wine_train)
# print estimated coefficients in a tidy data frame
summary(aplr_model)
tidy(aplr_model)



# NOTE: Model accuracy ---------------------------------------

# NOTE: cv - model 1
set.seed(123)
cv_slr_model <- train(
  form = quality ~ alcohol,
  data = wine_train,
  method = "lm",
  trControl = trainControl(method = "cv", number = 10)
)
cv_slr_model



# NOTE: cv -  model 2
set.seed(123)
cv_mlr_model <- train(
  quality ~ alcohol + volatile_acidity,
  data = wine_train,
  method = "lm",
  trControl = trainControl(method = "cv", number = 10)
)
cv_mlr_model


# NOTE: cv - model 3
set.seed(123)
cv_aplr_model <- train(
  quality ~ .,
  data = wine_train,
  method = "lm",
  trControl = trainControl(method = "cv", number = 10)
)
cv_aplr_model
cv_aplr_model$results


# sample performamce measures
summary(resamples(list(
  slr_model = cv_slr_model,
  mlr_model = cv_mlr_model,
  aplr_model = cv_aplr_model
)))


# VIP
vip(cv_aplr_model, num_features = 10)


# NOTE: Others
p1 <- ggplot(wine_train, aes(alcohol, quality)) +
  geom_point(size = 1, alpha = .4) +
  geom_smooth(se = F) +
  scale_y_continuous("Quality", labels = scales::dollar) +
  xlab("Alcohol") +
  ggtitle(paste(
    "Non-transformed variables with a\n",
    "non-linear relationshop"
  ))
p1


p2 <- ggplot(wine_train, aes(alcohol, quality)) +
  geom_point(size = 1, alpha = .4) +
  geom_smooth(method = "lm", se = F) +
  scale_y_log10("Quality",
    labels = scales::dollar,
    breaks = seq(0, 400000, by = 100000)
  ) +
  xlab("Alcohol") +
  ggtitle(paste(
    "Transforming variables can provide a\n",
    "near-linear relationship"
  ))
p2


df1 <- broom::augment(cv_slr_model$finalModel, data = wine_df)
glimpse(df1)
p1 <- ggplot(df1, aes(.fitted, .std.resid)) +
  geom_point(size = 1, alpha = .4) +
  xlab("Predicted values") +
  ylab("Residuals") +
  ggtitle("cv_slr model")
p1


df2 <- broom::augment(cv_aplr_model$finalModel, data = wine_df)
glimpse(df2)
p2 <- ggplot(df2, aes(.fitted, .std.resid)) +
  geom_point(size = 1, alpha = .4) +
  xlab("Predicted values") +
  ylab("Residuals") +
  ggtitle("Model 3")
p2

df1 <- mutate(df1, id = row_number())
glimpse(df1)

df2 <- mutate(df2, id = row_number())
glimpse(df2)

p1 <- ggplot(df1, aes(id, .std.resid)) +
  geom_point(size = 1, alpha = .4) +
  xlab("Row ID") +
  ylab("Residuals") +
  ggtitle("Model 1", subtitle = "Correlated residuals.")
p1

p2 <- ggplot(df2, aes(id, .std.resid)) +
  geom_point(size = 1, alpha = .4) +
  xlab("Row ID") +
  ylab("Residuals") +
  ggtitle("Model 3", subtitle = "Uncorrelated residuals.")
p2
