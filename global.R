library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(rmarkdown)

odds <- read.csv("./data/schmidt_odds.csv")

# expand odds df into full risk df

risk_mat <- matrix(NA, nrow=nrow(odds)*4, ncol=5)

for (i in 1:nrow(odds)){
     for (j in 1:4){
          if (i * j == 1){
               current <- 1
          } else {
               current <- current + 1
          }
          risk_mat[current, 1] <- odds[i, 1]
          risk_mat[current, 2] <- j - 1
          risk_mat[current, 3] <- odds$base_rate[i] + odds$base_rate[i] * (j - 1) * (odds$lcl95[i] - 1)
          risk_mat[current, 4] <- odds$base_rate[i] + odds$base_rate[i] * (j - 1) * (odds$odds[i] - 1)
          risk_mat[current, 5] <- odds$base_rate[i] + odds$base_rate[i] * (j - 1) * (odds$ucl95[i] - 1)
     }
}

# rescale prevalence to percentages
risk_mat[, 3] <- as.numeric(risk_mat[, 3]) * 100
risk_mat[, 4] <- as.numeric(risk_mat[, 4]) * 100
risk_mat[, 5] <- as.numeric(risk_mat[, 5]) * 100

risk_df <- as.data.frame(risk_mat)

colnames(risk_df) <- c("outcome", "n_morbid", "lower", "avg_odds", "upper")

risk_df$lower <- as.numeric(risk_df$lower)
risk_df$avg_odds <- as.numeric(risk_df$avg_odds)
risk_df$upper <- as.numeric(risk_df$upper)
