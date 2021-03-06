
library(MASS)  # Package needed to generate correlated precictors
library(glmnet)  # Package to fit ridge/lasso/elastic net models
## Loading required package: Matrix


# Generate data
set.seed(19875)  # Set seed for reproducibility
n <- 1000  # Number of observations
p <- 5000  # Number of predictors included in model
real_p <- 15  # Number of true predictors
x <- matrix(rnorm(n*p), nrow=n, ncol=p)
y <- apply(x[,1:real_p], 1, sum) + rnorm(n)

dim(x)


# Split data into train (2/3) and test (1/3) sets
train_rows <- sample(1:n, .66*n)
x.train <- x[train_rows, ]
x.test <- x[-train_rows, ]

y.train <- y[train_rows]
y.test <- y[-train_rows]

# Fit models 
# (For plots on left):
fit.lasso <- glmnet(x.train, y.train, family="gaussian", alpha=1)


summary(fit.lasso)

fit.ridge <- glmnet(x.train, y.train, family="gaussian", alpha=0)


summary(fit.ridge)

fit.elnet <- glmnet(x.train, y.train, family="gaussian", alpha=.5)

summary(fit.elnet)

# 10-fold Cross validation for each alpha = 0, 0.1, ... , 0.9, 1.0
# (For plots on Right)
for (i in 0:10) {
    assign(paste("fit", i, sep=""), 
           cv.glmnet(x.train, y.train, 
                 type.measure="mse", 
                 alpha=i/10,
                 family="gaussian"))
}

# Plot solution paths:
par(mfrow=c(1,2))
# For plotting options, type '?plot.glmnet' in R console
plot(fit.lasso, xvar="lambda")
plot(fit10, main="LASSO")




par(mfrow=c(1,2))
plot(fit.ridge, xvar="lambda")
plot(fit0, main="Ridge")



par(mfrow=c(1,2))
plot(fit.elnet, xvar="lambda")
plot(fit5, main="Elastic Net")
