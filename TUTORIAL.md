# Airline Passenger Satisfaction Prediction Using Supervised Learning Algorithms

## Dataset

```R
getwd()
data = read.csv('/Users/promac/Downloads/Predicting-Satisfaction-Of-Airline-Customers-master/airlinedata.csv')
```

## Data Cleaning and Pre-processing

1) Menghapus variabel yang tidak berguna

```R
library(dplyr)
data= data%>%select(-'X', -'id')
str(data)
```
2) Konversi variabel ordinal dan kategorikal ke variabel faktor

```R
data = data%>%
  mutate(Gender = factor(Gender),
         Customer.Type = factor(Customer.Type),
         Type.of.Travel = factor(Type.of.Travel),
         Class = factor(Class),
         Inflight.wifi.service = factor(Inflight.wifi.service),
         Departure.Arrival.time.convenient = factor(Departure.Arrival.time.convenient),
         Ease.of.Online.booking = factor(Ease.of.Online.booking),
         Gate.location = factor(Gate.location),
         Food.and.drink = factor(Food.and.drink),
         Online.boarding = factor(Online.boarding),
         Seat.comfort = factor(Seat.comfort),
         Inflight.entertainment = factor(Inflight.entertainment),
         On.board.service = factor(On.board.service),
         Leg.room.service = factor(Leg.room.service),
         Baggage.handling = factor(Baggage.handling),
         Checkin.service = factor(Checkin.service),
         Inflight.service = factor(Inflight.service),
         Cleanliness = factor(Cleanliness))
```

3) Mengode ulang “Satisfaction” menjadi “0” dan “1”
   Variabel “Satisfaction” sekarang dikode ulang menjadi “0” dan “1”. “0” akan mewakili puas sedangkan “1” mewakili netral/tidak puas.

```R
data = data%>%mutate(satisfaction = factor(satisfaction, levels=c('satisfied','neutral or dissatisfied'), 
                                           labels=c("0", "1")))
```

4) Nilai yang Hilang

```R
library(DataExplorer)
plot_missing(data)
colSums(is.na(data))
```


Berdasarkan Gambar, hanya variabel “Arrival.Delay.In.Minutes” yang memiliki nilai yang hilang.
sekitar 0,3% data yang hilang pada variabel tertentu.
