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

1) Proporsi Variabel Sasaran (Satisfaction)
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
![Barplot of satisfaction](https://github.com/vanyarimta/DAP-PROJECT/blob/3d4fac70455b7ee321f86621dd23b5e463aafdb8/Barplot%20of%20satisfaction.png)

Ketidakseimbangan kelas harus diperiksa sebelum membangun model prediktif. Masalah ketidakseimbangan mungkin timbul karena metode pengambilan sampel yang bias atau kesalahan pengukuran/tidak tersedianya kelas. Jika distribusi kelas condong ke satu sisi, model prediksi mungkin bias ke arah memprediksi kelas yang miring. Oleh karena itu, model prediksi tersebut bukanlah model yang baik. Berdasarkan gambar, 57% data berada pada satu kelas dan sisanya 43% berada pada kelas lain. Dengan demikian, dapat dikatakan bahwa proporsi variabel target kita cukup seimbang.

2) Satisfaction By Customer Type
```R
#2. Barplot of customer type vs satisfaction level
ggplot(data, aes(x = Customer.Type, fill = satisfaction)) +
  geom_bar(stat='Count', position='dodge') +
  labs(x = 'Type of Customer')+
  guides(fill = guide_legend(title.position="top", title ="Satisfaction") ) + 
  scale_fill_brewer(palette = "Set1", labels = c("0(Satisfied)", "1(Neutral/Dissastisfied)"))
```

![Satisfaction By Customer Type](isi nanti)

Berdasarkan gambar , pelanggan yang tidak loyal cenderung bersikap tidak puas/netral terhadap layanan maskapai penerbangan dibandingkan dengan pelanggan setia.

3) Satisfaction by Travel Class and Type of Travel

```R
#3. Barplot of travel class vs satisfaction level
ggplot(data, aes(x = Class, fill = satisfaction)) +
  geom_bar(stat='Count', position='dodge') +
  labs(x = 'Travel Class')+
  guides(fill = guide_legend(title.position="top", title ="Satisfaction") ) + 
  scale_fill_brewer(palette = "Set1", labels = c("0(Satisfied)", "1(Neutral/Dissastisfied)"))
#4. Barplot of Type of Travel vs satisfaction level
ggplot(data, aes(x = Type.of.Travel, fill = satisfaction)) +
  geom_bar(stat='Count', position='dodge') +
  labs(x = 'Type of Travel', y = 'No. Of Passengers' )+
  guides(fill = guide_legend(title.position="top", title ="Satisfaction") ) + 
  scale_fill_brewer(palette = "Set1", labels = c("0(Satisfied)", "1(Neutral/Dissastisfied)"))+
  coord_flip()
```

![Barplot of satisfaction by travel class](isi nanti)
Gambar diatas, menunjukkan diagram batang kepuasan berdasarkan kelas perjalanan. Terlihat bahwa pelanggan yang melakukan perjalanan di kelas bisnis cenderung lebih puas dengan pengalaman penerbangan mereka dibandingkan bagi mereka yang bepergian di kelas ekonomi atau ekonomi plus.

![Barplot of satisfaction by type of travel](isi nanti)
Berdasarkan barplot pada gambar 10 penumpang yang melakukan perjalanan untuk keperluan pribadi (kemungkinan besar liburan) memiliki rasio kepuasan yang jauh lebih rendah jika dibandingkan dengan mereka yang bepergian untuk
tujuan bisnis.


## Implementasi Model

### Partisi Data
```R
library(caTools)
set.seed(1234)
split = sample.split(data$satisfaction, SplitRatio = 0.8)
training_set = subset(data, split == TRUE)
test_set = subset(data, split == FALSE)
```

![The training and test set after data partition](isi nanti)
Sebelum melatih model, dataset dibagi menjadi 2 bagian. Karena ukuran data yang sangat besar, dataset dibagi dalam rasio 80:20. 80% data masuk ke set pelatihan dan 20% data masuk ke set pengujian. set.seed() dari paket “caTools” digunakan untuk memastikan dapat direproduksi hasil setiap kali kita melakukan proses pemisahan. Gambar 11 menunjukkan bahwa proses pemisahan telah berhasil diselesaikan.

```R
prop.table(table(data$satisfaction))
prop.table(table(training_set$satisfaction))
prop.table(table(test_set$satisfaction))
```

![Proportion of the target variable in original, training, and test dataset](isi nanti)
Gambar diatas, menunjukkan bahwa proporsi variabel target, “kepuasan” adalah sama untuk pelatihan, pengujian dan dataset asli.

### SVM

```R
library(kernlab)
library(e1071)
library(caret)
classifier = ksvm(satisfaction~., data = training_set, kernel = "vanilladot")
classifier

#predicting the model with training data
predict_train = predict(classifier, training_set)

#evaluating model prediction with confusion matrix
cm_vanilladot = table(predict_train, training_set$satisfaction)
confusionMatrix(cm_vanilladot)

#predicting the model with test data
predict_test = predict(classifier, test_set)

#evaluating model prediction with confusion matrix
cm = table(predict_test, test_set$satisfaction)
confusionMatrix(cm)

#building svm model with rbf kernel 
classifier_rbf = ksvm(satisfaction~., data = training_set,
                  kernel = 'rbfdot')  
classifier_rbf

#predicting the model with training data
predict_train_rbf = predict(classifier_rbf, training_set)

#evaluating model prediction with confusion matrix
cm_train_rbf = table(predict_train_rbf, training_set$satisfaction)
confusionMatrix(cm_train_rbf)

#predicting the model with test data
predict_test_rbf = predict(classifier_rbf, test_set)

#evaluating model prediction with confusion matrix
cm_rbf = table(predict_test_rbf, test_set$satisfaction)
confusionMatrix(cm_rbf)

#building svm model with tanhdot
classifier_tanhdot = ksvm(satisfaction~., data = training_set,
                      kernel = 'tanhdot')  
classifier_tanhdot

#predicting the model with training data
predict_train_tanhdot = predict(classifier_tanhdot, training_set)

#evaluating model prediction with confusion matrix
cm_tanhdot_train = table(predict_train_tanhdot, training_set$satisfaction)
confusionMatrix(cm_tanhdot_train)

#predicting the model with test data
predict_test_tanhdot = predict(classifier_tanhdot, test_set)

#evaluating model prediction with confusion matrix
cm_tanhdot = table(predict_test_tanhdot, test_set$satisfaction)
confusionMatrix(cm_tanhdot)

#building svm model with polydot
classifier_polydot = ksvm(satisfaction~., data = training_set,
                          kernel = 'polydot')  
classifier_polydot

#predicting the model with training data
predict_train_polydot = predict(classifier_polydot, training_set)

#evaluating model prediction with confusion matrix
cm_polydot_train = table(predict_train_polydot, training_set$satisfaction)
confusionMatrix(cm_polydot_train)

#predicting the model with test data
predict_test_polydot = predict(classifier_polydot, test_set)

#evaluating model prediction with confusion matrix
cm_polydot = table(predict_test_polydot, test_set$satisfaction)
confusionMatrix(cm_polydot)
```

1) SVM Model (Gaussian RBF)

![SVM Model (Gaussian RBF)](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/SVM%20Model%20(Gaussian%20RBF).png)
Gambar diatas, menunjukkan model SVM yang dibangun dengan fungsi kernel Gaussian RBF dengan kesalahan pelatihan sebesar 0,037811.

![Confusion Matrix Results of Training & Test Set](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/Confusion%20Matrix%20Results%20of%20Training%20%26%20Test%20Set.png)
Gambar diatas, menunjukkan perbandingan hasil matriks kebingungan antara set pelatihan dan set pengujian menggunakan fungsi kernel Gaussian RBF. Akurasi set pelatihan adalah 96,2% sedangkan set pengujian akurasinya sedikit lebih rendah, 95,9%.

2) SVM Model (Linear)

![SVM Model (Linear)](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/SVM%20Model%20(Linear).png)
Gambar diatas, menunjukkan model SVM yang dibangun dengan fungsi kernel linier dengan kesalahan pelatihan sebesar 0,063893.

![Confusion Matrix Results of Training & Test Set](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/Confusion%20Matrix%20Results%20of%20Training%20%26%20Test%20Set2.png)
Gambar diatas, menunjukkan perbandingan hasil matriks kebingungan antara set pelatihan dan set pengujian menggunakan fungsi kernel Linear. Akurasi set pelatihan adalah 93,6% sedangkan akurasi set pengujian adalah sedikit lebih tinggi, 93,7%

3) SVM Model (Hyperbolic Tangent Sigmoid)

![SVM Model (Hyperbolic Tangent Sigmoid)](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/SVM%20Model%20(Hyperbolic%20Tangent%20Sigmoid).png)
Gambar diatas, menunjukkan model SVM yang dibangun dengan fungsi kernel sigmoid tangen hiperbolik dengan kesalahan pelatihan 0,431529.

![Confusion Matrix Results of Training & Test Set](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/Confusion%20Matrix%20Results%20of%20Training%20%26%20Test%20Set3.png)
Gambar diatas, menunjukkan perbandingan hasil matriks kebingungan antara set pelatihan dan set pengujian menggunakan fungsi kernel sigmoid hiperbolik tangen. Akurasi set pelatihan adalah 56,9% sedangkan akurasi set pengujian sedikit lebih tinggi, 57,8%.

4) SVM Model (Polynomial)

![SVM Model (Polynomial)](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/SVM%20Model%20(Polynomial).png)
Gambar diatas, menunjukkan model SVM yang dibangun dengan fungsi kernel polinomial dengan pelatihan kesalahan sebesar 0,063917.

![Confusion Matrix Results of Training & Test Set](https://github.com/vanyarimta/DAP-PROJECT/blob/e2a8cb0373c6befdeb10422227830e6282436783/Confusion%20Matrix%20Results%20of%20Training%20%26%20Test%20Set4.png)
Gambar xx menunjukkan perbandingan hasil matriks kebingungan antara set pelatihan dan set pengujian menggunakan fungsi kernel polinomial. Akurasi set pelatihan adalah 93,6% sedangkan set pengujian akurasinya sedikit lebih tinggi, 93,7%.

### Model Tuning

```R
#building svm model with rbf kernel + increase Cost parameter to 3
classifier_rbf_cost3= ksvm(satisfaction~., data = training_set,
                      kernel = 'rbfdot', C = 3)  
classifier_rbf_cost3

#Tuned Model Testing
#predicting the model with training data
predict_train_rbf_cost3 = predict(classifier_rbf_cost3, training_set)

#evaluating model prediction with confusion matrix
cm_train_rbf_cost3 = table(predict_train_rbf_cost3, training_set$satisfaction)
confusionMatrix(cm_train_rbf_cost3)

#predicting the model with test data
predict_test_rbf_cost3 = predict(classifier_rbf_cost3, test_set)

#evaluating model prediction with confusion matrix
cm_rbf_cost3 = table(predict_test_rbf_cost3, test_set$satisfaction)
confusionMatrix(cm_rbf_cost3)

#ROC Curve + AUC Score 
library(pROC)
roc(training_set$satisfaction, classifier_rbf_cost3$votes[,1], plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#4daf4a", lwd=4, print.auc=TRUE)

roc_svm_test = roc(training_set$satisfaction, predictor =as.numeric(classifier_rbf_cost3))
plot(roc_svm_test, add = TRUE,col = "red", print.auc=TRUE, print.auc.x = 0.5, print.auc.y = 0.3)
legend(0.3, 0.2, legend = c("test-svm"), lty = c(1), col = c("blue"))

pred_ROCR <- prediction(training_set$satisfaction, classifier_rbf_cost3)
```
![Model Tuning](isi nanti)
Karena kernel Gaussian RBF memberikan hasil terbaik, maka kernel ini dipilih sebagai pilihan fungsi dalam fase penyetelan model. Selama fase penyetelan model, parameter biaya, C ditingkatkan dari 1 ke 3. Hal ini mengakibatkan peningkatan minimal dalam akurasi set pengujian dan pelatihan.

### Results
![Results](isi nanti)
Tabel di atas menunjukkan hasil keseluruhan dari berbagai model SVM yang dibangun menggunakan berbagai fungsi kernel. Fungsi kernel menentukan pemetaan nonlinier seperti basis radial, polinomial, hiperbolik tangen sigmoid atau linier. Fungsi ksvm() akan menggunakan kernel Gaussian RBF secara default. Pada dataset ini, model SVM yang dibangun menggunakan fungsi kernel Gaussian RBF mengungguli model lainnya model yang dibangun menggunakan fungsi yang berbeda. Hasil ini diharapkan sebagai fungsi kernel Gaussian RBF adalah fungsi yang populer karena kinerjanya yang baik yang ditunjukkan di masa lalu untuk banyak jenis data (Lantz,2019)

