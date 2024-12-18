# DAP-PROJECT

## Overview
This project aims to analyze and predict customer satisfaction in the airline industry using machine learning techniques. The dataset contains various features related to airline customers, including their demographics, travel preferences, and satisfaction levels. By leveraging data analysis and machine learning models, we aim to identify key factors that influence customer satisfaction and build predictive models to forecast satisfaction levels.

## Objectives
- Explore the dataset to understand the distribution of features and the target variable (customer satisfaction).
- Clean and preprocess the data to prepare it for analysis.
- Perform exploratory data analysis (EDA) to visualize relationships between features and customer satisfaction.
- Build and evaluate various machine learning models, including Support Vector Machine (SVM) and Artificial Neural Networks (ANN), to predict customer satisfaction.
- Tune the models to improve their performance and accuracy.

## Dataset
The dataset used in this project is `airlinedata.csv`, which contains the following features:
- **Gender**: Gender of the customer (Male/Female)
- **Customer.Type**: Type of customer (Loyal customer/Disloyal customer)
- **Type.of.Travel**: Purpose of travel (Business/Personal)
- **Class**: Travel class (Economy/Business/First)
- **Inflight.wifi.service**: Rating of inflight wifi service
- **Departure.Arrival.time.convenient**: Rating of departure and arrival time convenience
- **Ease.of.Online.booking**: Rating of ease of online booking
- **Gate.location**: Rating of gate location
- **Food.and.drink**: Rating of food and drink
- **Online.boarding**: Rating of online boarding
- **Seat.comfort**: Rating of seat comfort
- **Inflight.entertainment**: Rating of inflight entertainment
- **On.board.service**: Rating of onboard service
- **Leg.room.service**: Rating of legroom service
- **Baggage.handling**: Rating of baggage handling
- **Checkin.service**: Rating of check-in service
- **Inflight.service**: Rating of inflight service
- **Cleanliness**: Rating of cleanliness
- **Satisfaction**: Customer satisfaction level (Satisfied/Neutral or Dissatisfied)

## Requirements
To run this project, you need to have R installed along with the following packages:
- `dplyr`
- `ggplot2`
- `caret`
- `kernlab`
- `e1071`
- `pROC`
- `h2o`
- `DataExplorer`

You can install the required packages using the following command in R:
```r
install.packages(c("dplyr", "ggplot2", "caret", "kernlab", "e1071", "pROC", "h2o", "DataExplorer"))
