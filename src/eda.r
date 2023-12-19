library(dplyr)
library(ggplot2)

wine_data <- read.csv("./src/WineQuality.csv")
wine_data <- wine_data %>% select(-Id)

#NOTE: Outlier repr
numerical_variables <- wine_data[, c("free_sulfur_dioxide", "total_sulfur_dioxide")]

melted_data <- gather(data = numerical_variables, key = "Variable", value = "Value")

ggplot(melted_data, aes(x = Variable, y = Value)) +
  geom_boxplot() +
  labs(title = "Boxplots of Numerical Variables in Wine Dataset",
       x = "Variable",
       y = "Value")

numerical_variables <- wine_data[, c("fixed_acidity", "volatile_acidity", "citric_acid", "residual_sugar", "chlorides", "free_sulfur_dioxide", "total_sulfur_dioxide", "density", "pH", "sulphates", "alcohol", "quality")]
ggplot(numerical_variables, aes(color = factor(quality))) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "Scatter Plot Matrix of Numerical Variables by Wine Quality",
       x = "Variable Value",
       y = "Variable Value")


# NOTE: Correlation heatmap
cor_matrix <- cor(wine_data[, c("fixed_acidity", "volatile_acidity", "citric_acid", "residual_sugar", "chlorides", "free_sulfur_dioxide", "total_sulfur_dioxide", "density", "pH", "sulphates", "alcohol", "quality")])

cor_melted <- reshape2::melt(cor_matrix)

ggplot(data = cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white", size = 0.1) +
  geom_text(aes(label = round(value, 2)), vjust = 1) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, na.value = "grey50") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom") +
  labs(title = "Correlation Heatmap for Wine Dataset",
       x = "Variables",
       y = "Variables",
       fill = "Correlation")
