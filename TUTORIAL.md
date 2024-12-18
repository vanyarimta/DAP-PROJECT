# Airline Passenger Satisfaction Prediction Using Supervised Learning Algorithms

## Dataset

```R
getwd()
data = read.csv('')
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

![Plot of missing data](https://github.com/vanyarimta/DAP-PROJECT/blob/5a11f0851237a51ad20db4b9f80e945ce7f44d4d/Plot%20of%20missing%20data.png)

Berdasarkan Gambar diatas, hanya variabel “Arrival.Delay.In.Minutes” yang memiliki nilai yang hilang.
sekitar 0,3% data yang hilang pada variabel tertentu.

5) Analisis Korelasi Variabel

```R
library(ggplot2)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile(color = 'white')+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  geom_text(aes(Var2, Var1, label = sprintf(value, fmt = '%#.2f') ), color = "black", size = 3.8) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank())+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  theme(axis.text.y = element_text(size = 12))
```

