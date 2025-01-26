
# Required packages

library(tseries)
library(forecast)
library(magrittr)
library(fpp2)
library(readr)
library(ggplot2)
library(TSA)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Import time series dataset

Sunspots <- read.csv("Sunspots")
View(Sunspots)

###################################################

#Exploratory Data Analysis

class(Sunspots)
head(Sunspots)
summary(Sunspots)


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Creating Time Series object
TSData1 <- ts(data = Sunspots$MonthlyMeanSunspots, start = c(1749,1), end = c(2021,1), 
             frequency = 12, class = "ts")
TSData1

# Plot the time series data
plot(TSData1,xlab="Month", ylab = "Number of Sunspots",
     main="Monthly Mean Sunspots")

boxplot(TSData1~cycle(TSData1),xlab="Month", 
        ylab = "Number of Sunspots",
        main ="Monthly Mean Sunspots")

# Decomposition
decomposeTS <- decompose(TSData1,"additive")
autoplot(decomposeTS)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# STATIONARITY CHECK

# ADF
adf.test(TSData1)

# Autocorrelation
acf(TSData1)
pacf(TSData1)
eacf(TSData1)



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MODEL FITTING

# ARIMA Model

m1.sunspots<-arima(TSData1,order=c(1,0,9))

m2.sunspots<-arima(TSData1,order=c(1,0,2))

m3.sunspots<-arima(TSData1,order=c(3,0,10))

AIC(m1.sunspots)
AIC(m2.sunspots)
AIC(m3.sunspots)

#residuals check 

plot(window(rstandard(m3.sunspots),start=c(2010)),ylab ="Standardized Residuals ARMA(3,10)",
     type='o')
abline(h=0)

plot(window(rstandard(m2.sunspots),start=c(2010)),ylab ="Standardized Residuals ARMA(1,2)",
     type='o')
abline(h=0)

plot(window(rstandard(m1.sunspots),start=c(2010)),ylab ="Standardized Residuals ARIMA(1,9)",
     type='o')
abline(h=0)

acf(as.vector(window(rstandard(m3.sunspots),start=c(2010))),lag.max = 36)

Box.test(residuals(m3.sunspots))
Box.test(residuals(m3.sunspots),lag = 49, type='Ljung-Box')

adf.test(residuals(m3.sunspots))

#histograms for the residuals
hist(window(rstandard(m3.sunspots),start=c(2010)), xlab='Standardized Residuals')

#qq plot of the residuals
qqnorm(window(rstandard(m3.sunspots),start=c(2010)))
qqline(window(rstandard(m3.sunspots),start=c(2010)))

#test for normality
shapiro.test(rstandard(m3.sunspots))
ks.test(rstandard(m3.sunspots),pnorm)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#Forecasts and Forecast Limits for Sunspots Data
plot(m3.sunspots,n1=c(2019,1),n.ahead=24,xlab='Month',type='o', ylab='Number of Mean Sunspots')

#Predict.Arima:Forecast from ARIMA fits
futurValue <- predict(m3.sunspots,n.ahead = 24)

# train and test data
trainSunspots <- window(TSData1,end=c(2014,12))
trainSunspots
testSunspots <- window(TSData1,start=c(2015,1))
testSunspots

m1.trainSunspots <- arima(trainSunspots,order=c(3,0,10))
m2.trainSunspots <- arima(trainSunspots,order=c(1,0,9))

# predict.Arima: Forecast from ARIMA fits

futurem1 <- predict(m1.trainSunspots,n.ahead = 24) 
accuracy(futurem1$pred, testSunspots)

futurem2 <- predict(m2.trainSunspots,n.ahead = 24) 
accuracy(futurem2$pred, testSunspots)
