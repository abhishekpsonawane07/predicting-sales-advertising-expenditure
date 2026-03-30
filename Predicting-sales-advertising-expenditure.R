
# setting working directory of the r file

setwd("D:/Abhi/r project")

#Loading the data from local machine
advertising <- read.csv("advertising.csv")
head(advertising)

# Task 1 

#checking the dimensions of the data 
dim(advertising)

#Checking Attributes in the data
names(advertising)

# EDA process
summary(advertising)

sd(advertising$TV)
sd(advertising$Radio)
sd(advertising$Newspaper)
sd(advertising$Sales)

png("task1_histograms.png", width = 800, height = 600)
par(mfrow = c(2,2))

hist(advertising$TV,
     main = "Distribution of TV Advertising spend ",
     xlab = "TV Budget ($000s)",
     col = "steelblue",
     border = "white",
     )

hist(advertising$Radio,
     main = "Distribution of Radio Advertising spend ",
     xlab = "Radio Budget ($000s)",
     col = "coral",
     border = "white",
)

hist(advertising$Newspaper,
     main = "Distribution of Newspaper Advertising spend ",
     xlab = "Newspaper Budget ($000s)",
     col = "mediumseagreen",
     border = "white",
)

hist(advertising$Sales,
     main = "Distribution of Sales",
     xlab = "Sales (000s Units)",
     col = "mediumpurple",
     border = "white"
)


par(mfrow = c(1,1))
dev.off()

# Boxplots
png("task1_boxplots.png", width = 800, height = 500)
par(mfrow = c(1, 4))

boxplot(advertising$TV, 
        main = "TV", 
        ylab = "Budget ($000s)",
        col = "steelblue")

boxplot(advertising$Radio, 
        main = "Radio", 
        ylab = "Budget ($000s)",
        col = "coral")

boxplot(advertising$Newspaper, 
        main = "Newspaper", 
        ylab = "Budget ($000s)",
        col = "mediumseagreen")

boxplot(advertising$Sales, 
        main = "Sales", 
        ylab = "Units (000s)",
        col = "mediumpurple")

par(mfrow = c(1, 1))
dev.off()


# Task 2

# correlation 
cor(advertising)

png("task2_pairplots.png", width = 800, height = 800)
pairs(advertising,
      main = "Scatterplot of Advertising Data",
      col = "steelblue",
      pch = 19
      )
dev.off()


install.packages("corrplot")
library(corrplot)

cor_matrix <- cor(advertising)

png("task2_corrplot.png", width = 600, height = 600)
corrplot(cor_matrix, 
         method = "color",
         type = "upper",
         addCoef.col = "black",  
         tl.col = "black",      
         tl.srt = 45,            
         title = "Correlation Matrix of Advertising Variables",
         mar = c(0,0,1,0))
dev.off()


# Task 3
# Simple Linear model

model_simple <- lm(Sales ~ TV, data = advertising)
summary(model_simple)

png("task3_simple_regression.png", width = 700, height = 500)
plot(advertising$TV, advertising$Sales,
     main = "Sales vs TV Advertising Spend",
     xlab = "TV Budget ($000s)",
     ylab = "Sales (000s Units)",
     col = "steelblue",
     pch = 19)

abline(model_simple, col = "red", lwd = 2)
dev.off()


# Task 4
# Multiple Linear regression model

model_multiple <- lm(Sales ~ TV + Radio + Newspaper, 
                     data = advertising)

summary(model_multiple)


cat("Simple Model R-squared:", summary(model_simple)$r.squared, "\n")
cat("Multiple Model R-squared:", summary(model_multiple)$r.squared, "\n")
cat("Multiple Model Adj R-squared:", summary(model_multiple)$adj.r.squared, "\n")
cat("Simple Model RSE:", sigma(model_simple), "\n")
cat("Multiple Model RSE:", sigma(model_multiple), "\n")


# Task 5
# Checking the model diagnostics

png("task5_diagnostics.png", width = 800, height = 600)
par(mfrow = c(2, 2))
plot(model_multiple)
par(mfrow = c(1, 1))
dev.off()

std_residuals <- rstandard(model_multiple)
outliers <- which(abs(std_residuals) > 2)
cat("Potential outliers:\n")
print(outliers)

leverage <- hatvalues(model_multiple)
high_leverage <- which(leverage > 2 * mean(leverage))
cat("\nHigh leverage points:\n")
print(high_leverage)


cooks <- cooks.distance(model_multiple)
high_influence <- which(cooks > 4/nrow(advertising))
cat("\nHigh influence points:\n")
print(high_influence)


cat("Row 131:\n")
print(advertising[131,])
cat("\nRow 151:\n")
print(advertising[151,])

# Task 6
# comparing the models

tv_coef <- coef(model_multiple)["TV"]
radio_coef <- coef(model_multiple)["Radio"]

extra_budget <- 10


tv_impact <- extra_budget * tv_coef
radio_impact <- extra_budget * radio_coef

cat("Extra $10k on TV → Sales change:", tv_impact, "thousand units\n")
cat("Extra $10k on Radio → Sales change:", radio_impact, "thousand units\n")
cat("\nRecommendation: Allocate to", 
    ifelse(radio_impact > tv_impact, "RADIO", "TV"), "!\n")

# task 7
# Anova and T-test

median_sales <- median(advertising$Sales)
cat("Median Sales:", median_sales, "\n")

advertising$Sales_split2 <- ifelse(advertising$Sales <= median_sales, 
                                   "Low", "High")
table(advertising$Sales_split2)


t_tv <- t.test(TV ~ Sales_split2, data = advertising)
t_radio <- t.test(Radio ~ Sales_split2, data = advertising)
t_newspaper <- t.test(Newspaper ~ Sales_split2, data = advertising)

cat("TV t-test p-value:", t_tv$p.value, "\n")
cat("Radio t-test p-value:", t_radio$p.value, "\n")
cat("Newspaper t-test p-value:", t_newspaper$p.value, "\n")


png("task7_2group_boxplots.png", width = 900, height = 500)
par(mfrow = c(1, 3))

boxplot(TV ~ Sales_split2, data = advertising,
        main = "TV Spend by Sales Group",
        xlab = "Sales Group", ylab = "TV Budget ($000s)",
        col = c("coral", "steelblue"))

boxplot(Radio ~ Sales_split2, data = advertising,
        main = "Radio Spend by Sales Group",
        xlab = "Sales Group", ylab = "Radio Budget ($000s)",
        col = c("coral", "steelblue"))

boxplot(Newspaper ~ Sales_split2, data = advertising,
        main = "Newspaper Spend by Sales Group",
        xlab = "Sales Group", ylab = "Newspaper Budget ($000s)",
        col = c("coral", "steelblue"))

par(mfrow = c(1, 1))
dev.off()


# 7-part2

advertising$Sales_split4 <- cut(advertising$Sales,
                                breaks = quantile(advertising$Sales, 
                                                  probs = c(0, 0.25, 0.5, 0.75, 1)),
                                labels = c("Low", "Medium", "High", "Extreme"),
                                include.lowest = TRUE)

# Check groups
table(advertising$Sales_split4)

# ANOVA for each channel
anova_tv <- aov(TV ~ Sales_split4, data = advertising)
anova_radio <- aov(Radio ~ Sales_split4, data = advertising)
anova_newspaper <- aov(Newspaper ~ Sales_split4, data = advertising)

cat("TV ANOVA p-value:", summary(anova_tv)[[1]][["Pr(>F)"]][1], "\n")
cat("Radio ANOVA p-value:", summary(anova_radio)[[1]][["Pr(>F)"]][1], "\n")
cat("Newspaper ANOVA p-value:", summary(anova_newspaper)[[1]][["Pr(>F)"]][1], "\n")


tukey_tv <- TukeyHSD(anova_tv)
tukey_radio <- TukeyHSD(anova_radio)

cat("=== TV Post-hoc Results ===\n")
print(tukey_tv)

cat("\n=== Radio Post-hoc Results ===\n")
print(tukey_radio)

print(tukey_tv)

png("task7_4group_boxplots.png", width = 900, height = 500)
par(mfrow = c(1, 3))

boxplot(TV ~ Sales_split4, data = advertising,
        main = "TV Spend by Sales Group",
        xlab = "Sales Group", ylab = "TV Budget ($000s)",
        col = c("lightblue", "steelblue", "coral", "darkred"),
        names = c("Low", "Med", "High", "Ext"))  # shortened names!

boxplot(Radio ~ Sales_split4, data = advertising,
        main = "Radio Spend by Sales Group", 
        xlab = "Sales Group", ylab = "Radio Budget ($000s)",
        col = c("lightblue", "steelblue", "coral", "darkred"),
        names = c("Low", "Med", "High", "Ext"))

boxplot(Newspaper ~ Sales_split4, data = advertising,
        main = "Newspaper Spend by Sales Group",
        xlab = "Sales Group", ylab = "Newspaper Budget ($000s)",
        col = c("lightblue", "steelblue", "coral", "darkred"),
        names = c("Low", "Med", "High", "Ext"))

par(mfrow = c(1, 1))
dev.off()


# task 8
#PCA (Principle Component Analysis)

ad_spend <- advertising[, c("TV", "Radio", "Newspaper")]

ad_scaled <- scale(ad_spend)

pca_result <- prcomp(ad_scaled, center = TRUE, scale. = TRUE)

summary(pca_result)


print(pca_result$rotation)

png("task8_screeplot.png", width = 600, height = 500)
screeplot(pca_result, 
          type = "lines",
          main = "PCA Scree Plot")
dev.off()

png("task8_biplot.png", width = 700, height = 600)
biplot(pca_result, 
       main = "PCA Biplot",
       col = c("steelblue", "red"))
dev.off()

dist_matrix <- dist(ad_scaled)
hclust_result <- hclust(dist_matrix, method = "ward.D2")

#png("task8_dendrogram.png", width = 800, height = 500)
plot(hclust_result,
     main = "Hierarchical Clustering of Markets",
     xlab = "Markets",
     ylab = "Distance",
     labels = FALSE)
rect.hclust(hclust_result, k = 3, border = "red")
#dev.off()


#Hierarchical Clustering
clusters <- cutree(hclust_result, k = 3)
advertising$cluster <- clusters

# See average spending per cluster
cluster_summary <- aggregate(
  cbind(TV, Radio, Newspaper, Sales) ~ cluster,
  data = advertising,
  FUN = mean)

print(cluster_summary)


# Random forest 
install.packages("randomForest")
library(randomForest)

# Fit random forest
rf_model <- randomForest(Sales ~ TV + Radio + Newspaper, 
                         data = advertising,
                         importance = TRUE,
                         ntree = 500)
print(rf_model)

png("task8_randomforest.png", width = 600, height = 500)
varImpPlot(rf_model,
           main = "Variable Importance - Random Forest")

dev.off()



