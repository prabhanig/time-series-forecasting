
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

Tourists <- read.csv("UKTouristsVisits.csv")
View(Tourists)

###################################################

#Exploratory Data Analysis

class(Tourists)
head(Tourists)
summary(Tourists)


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Creating Time Series object
TSData <- ts(data = Tourists$TouristsVisits, start = c(1980,1), end = c(2020,1), 
             frequency = 4, class = "ts")
TSData

# Plot the time series data
plot(TSData,xlab="Quarter", ylab = "Number of Tourists ('000s)",
     main="Tourist Attraction - UK (1980 to 2020)")

plot(window(TSData,start= 2010),ylab="Tourists ('000s)",main="Number of Tourists ('000s)")
Quarter=c("A","B","C","D")
points(window(TSData, start=c(2010)),pch=Quarter)

boxplot(TSData~cycle(TSData),xlab="Quarter", 
        ylab = "Number of Tourists ('000s)",
        main ="Tourist Attraction - UK (1980 to 2020)")

# Decomposition
decomposeTS <- decompose(TSData,"additive")
autoplot(decomposeTS)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# STATIONARITY CHECK

# ADF
adf.test(TSData)

# Autocorrelation
acf(TSData)
pacf(TSData)

#Taking Difference
TSDatad1 <- diff(TSData)
TSDatad1
plot(TSDatad1, ylab='First DIfference-Tourist Data', xlab='Time')
acf(as.vector(TSDatad1))

#Removing Seasonality - Seasonal DIfference
plot(diff(diff(TSData),lag=4), xlab='Time', ylab='Seasonal DIfference-Tourist Data')

acf(as.vector(diff(diff(TSData),lag=4)))

pacf(as.vector(diff(diff(TSData),lag=4)))

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# MODEL FITTING

# ARIMA Model

m1.tourists<-arima(TSData,order=c(1,1,1), seasonal=list(order=c(1,1,1), period=4))
m1.tourists

m2.tourists<-arima(TSData,order=c(1,1,1), seasonal=list(order=c(0,1,1), period=4))
m2.tourists

m3.tourists<-arima(TSData,order=c(2,1,1), seasonal=list(order=c(1,1,1), period=4))
m3.tourists


#residuals check 

plot(window(rstandard(m1.tourists),start=c(2000)),ylab ="Standardized Residuals ARIMA(1,1,1)",
     type='o')
abline(h=0)

plot(window(rstandard(m2.tourists),start=c(2000)),ylab ="Standardized Residuals ARIMA(1,1,1)(0,1,1)",
     type='o')
abline(h=0)

plot(window(rstandard(m3.tourists),start=c(2000)),ylab ="Standardized Residuals ARIMA(2,1,1)",
     type='o')
abline(h=0)

acf(as.vector(window(rstandard(m1.tourists),start=c(2000))),lag.max = 36)

Box.test(residuals(m1.tourists))
Box.test(residuals(m1.tourists),lag = 49, type='Ljung-Box')

adf.test(residuals(m1.tourists))

#histograms for the residuals
hist(window(rstandard(m1.tourists),start=c(2000)), xlab='Standardized Residuals')

#qq plot of the residuals
qqnorm(window(rstandard(m1.tourists),start=c(2000)))
qqline(window(rstandard(m1.tourists),start=c(2000)))

#test for normality
shapiro.test(rstandard(m1.tourists))
ks.test(rstandard(m1.tourists),pnorm)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#Forecasts and Forecast Limits for UK Tourist Visits Data
plot(m1.tourists,n1=c(2015),n.ahead=16,xlab='Quarter',type='o', ylab='Tourists Arrivals (000s)')

#Predict.Arima:Forecast from ARIMA fits
futurVal <- predict(m1.tourists,n.ahead = 16)

# train and test data
trainTourists <- window(TSData,end=c(2009,4))
trainTourists
testTourists <- window(TSData,start=c(2010))
testTourists

m1.traintourists <- arima(trainTourists,order=c(1,1,1),seasonal=list(order=c(1,1,1), period=4))
m2.traintourists <- arima(trainTourists,order=c(1,1,1),seasonal=list(order=c(0,1,1), period=4))

# predict.Arima: Forecast from ARIMA fits

futurm1 <- predict(m1.traintourists,n.ahead = 16) 
accuracy(futurm1$pred, testTourists)

futurm2 <- predict(m2.traintourists,n.ahead = 16) 
accuracy(futurm2$pred, testTourists)
