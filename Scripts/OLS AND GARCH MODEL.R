#
library(rugarch)    # For GARCH model 
library(car)        # For Variance Inflation Factor (VIF)
library(lmtest)     # Breusch-Pagan and Durbin-Watson
library(sandwich)   #  covariance matrix estimators
library(robustbase) 
library(broom)      # For tidying model outputs
library(readxl) 
library(ggplot2)

#DATAFRAME 
path <- "C:/Users/Dom3n/Downloads/Final.xlsx"
df1 <- read_excel(path)



#LEAST SQUARE----
#Make sure that the date is in the correct format 
df1$date <- as.Date(df1$date)
# Order the dataframe by date
df1 <- df1[order(df1$date), ]

# Lineal regression 

model <- lm(interpolated_returns ~ `Sentiment Score` + 
               VIX_inter + bond_inter + `OFR FSI_inter` + EPU_inter, data = df1)
# Resumen del modelo
summary(model)

#Tests for robustness of estimators----

# VIF to check for multicollinearity
vif(model)
#  Breusch-Pagan test  heteroscedasticity
bptest(model)  #there is heteroscedasticity

#  Durbin-Watson for autocorrelation of the residuals
dwtest(model)

# Q-Q plot for OLS residuals
qqnorm(model$residuals, main = "Q-Q Plot of OLS Residuals")
qqline(model$residuals, col = "blue")  # Add a reference line for normality

# Scatter plot (Residuals vs Sentiment Score) for OLS model
ggplot(df1, aes(x = `Sentiment Score`, y = model$residuals)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = "",
       x = "Sentiment Score",
       y = "Residuals") +
  theme_minimal()


#-GARCH MODEL-----

# GARCH model specification 
garch_spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(1, 1), include.mean = TRUE),
  distribution.model = "norm"
)
# Fit GARCH model to interpolated returns
garch_fit <- ugarchfit(spec = garch_spec, data = df1$interpolated_returns)
# GARCH summary 
summary(garch_fit)

# Extract the fitted residuals from the GARCH model
garch_residuals <- residuals(garch_fit, standardize = TRUE)

# Add the adjusted residuals to the original dataframe
df1$garch_residuals <- garch_residuals

# Regression model using the fitted residuals
modelo_garch_adjusted <- lm(garch_residuals ~ `Sentiment Score` + VIX_inter + bond_inter + `OFR FSI_inter` + EPU_inter, data = df1)

#summary model
summary(modelo_garch_adjusted)

# Histogram with normal distribution curve
ggplot(df1, aes(x = garch_residuals)) +

  stat_function(fun = dnorm, args = list(mean = mean(df1$garch_residuals), sd = sd(df1$garch_residuals)), 
                color = "blue", lwd = 1) +
  labs(title = "Histogram of GARCH Residuals with Normal Distribution Curve",
       x = "Residuals", 
       y = "Density") +
  theme_minimal()

# Q-Q plot for checking normality of observations
qqnorm(df1$garch_residuals, main = "")
qqline(df1$garch_residuals, col = "blue")  # Add a reference line


# GARCH model t-student distribution----
garch_spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(1, 1), include.mean = TRUE),
  distribution.model = "std"  # Use Student's t-distribution
)

#  GARCH model to the interpolated returns
garch_fit <- ugarchfit(spec = garch_spec, data = df1$interpolated_returns)

# GARCH summary
print(garch_fit)

# Extract standardized residuals from the GARCH model
garch_residuals <- residuals(garch_fit, standardize = TRUE)

# Add the residuals to the original dataframe
df1$garch_residuals <- garch_residuals

# Regression model using GARCH residuals
garch_adjusted_model <- lm(garch_residuals ~ `Sentiment Score` + VIX_inter + bond_inter + `OFR FSI_inter` + EPU_inter, data = df1)

# Model summary for the adjusted regression
summary(garch_adjusted_model)

# Plot  the residuals with a normal distribution curve
ggplot(df1, aes(x = garch_residuals)) +
  stat_function(fun = dnorm, args = list(mean = mean(df1$garch_residuals), sd = sd(df1$garch_residuals)), 
                color = "blue", lwd = 1) +
  labs(title = "Histogram of GARCH Residuals with t-Student Distribution",
       x = "Residuals", y = "Density") +
  theme_minimal()


