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
![Correlation heatmap of all variables](https://github.com/vanyarimta/DAP-PROJECT/blob/b76ef9402eda25ca6ab36468c47b9d8c5f6b8236/Correlation%20heatmap%20of%20all%20variables.png)

Berdasarkan peta panas korelasi, terdapat korelasi yang kuat antara keterlambatan kedatangan dan keterlambatan keberangkatan (korelasi Pearson = 0,97). Karena ada beberapa nilai yang hilang dalam “Arrival.Delay.In.Minutes”, mereka akan diperhitungkan dengan data dari “Departure.Delay.In.Minutes”. Ini sangat masuk akal karena jika waktu keberangkatan pesawat tertunda 5 menit, waktu kedatangan juga harus tertunda sekitar 5 menit. 

Menariknya, keterlambatan keberangkatan pesawat tidak mempengaruhi tingkat kepuasan pelanggan karena koefisien korelasinya mendekati 0. Sebaliknya, variabel seperti kenyamanan tempat duduk, pembelian online Layanan boarding dan layanan wifi dalam pesawat memiliki pengaruh yang lebih besar dalam mempengaruhi keputusan tingkat kepuasan pelanggan.
  
Selain itu, kebersihan tampaknya berkorelasi dengan makanan dan minuman, kenyamanan tempat duduk, dan hiburan penerbangan. Selain itu, “ease of booking” sangat berkorelasi dengan layanan wifi dalam pesawat dengan nilai korelasi pearson sebesar 0,72. Hal ini mungkin menunjukkan bahwa jika layanan wifi dalam pesawat sangat baik, Pelanggan akan memiliki koneksi yang stabil dan cepat untuk melakukan pemesanan online dan dengan demikian memberikan peluang yang tinggi peringkat untuk “Ease.of.Online.Booking”.


6) Imputasi Nilai yang Hilang

```R
data = data %>%
  mutate(Arrival.Delay.in.Minutes= coalesce(Arrival.Delay.in.Minutes ,Departure.Delay.in.Minutes))
colSums(is.na(data))
```
Setelah memasukkan data “Arrival.Delay.in.Minutes” dengan nilai dari
“Departure.Delay.in.Minutes”, kumpulan data sekarang sempurna dan bebas dari nilai yang hilang.

7) Penghapusan variabel yang sangat berkorelasi

```R
data= data%>%select(-'Arrival.Delay.in.Minutes')
```

Diketahui bahwa keterlambatan kedatangan dan keterlambatan keberangkatan mempunyai korelasi yang sangat tinggi yaitu sebesar 0,97.
alasannya, variabel keterlambatan kedatangan dihilangkan dari dataset karena fitur yang sangat berkorelasi
tidak akan memberikan informasi tambahan saat membangun model, tetapi akan meningkatkan
kompleksitas algoritma dan risiko kesalahan. Sekarang hanya ada 22 variabel yang tersisa di
kumpulan data.

## Analisis Data Eksploratif

a) Proporsi Variabel Sasaran (Satisfaction)
```R
#1. Barplot of target variable 
satisfaction_plot = as.data.frame(table(data$satisfaction))
print(satisfaction_plot)
names(satisfaction_plot) = c('col1', 'col2')

satisfaction_plot %>% 
  count(Satisfaction = factor(col1), Frequency = col2) %>% 
  mutate(Percentage = prop.table(Frequency)) %>% 
  ggplot(aes(x = Satisfaction, y = Percentage, fill = Frequency, label = scales::percent(Percentage))) + 
  geom_col(position = 'dodge') + 
  geom_text( vjust = 0) + 
  scale_y_continuous(labels = scales::percent)
```



