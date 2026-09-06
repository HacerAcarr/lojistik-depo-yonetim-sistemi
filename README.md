# 📦 Bir Lojistik Firmasının Depo Yönetim Sistemi (Warehouse Management System - WMS)

[![C#](https://img.shields.io/badge/C%23-.NET%20Framework%204.7.2-239120?style=for-the-badge&logo=c-sharp)](https://docs.microsoft.com/en-us/dotnet/csharp/)
[![MS SQL Server](https://img.shields.io/badge/MS%20SQL%20Server-2019%2B-CC292B?style=for-the-badge&logo=microsoftsqlserver)](https://www.microsoft.com/sql-server)
[![MongoDB](https://img.shields.io/badge/MongoDB-NoSQL%20Database-47A248?style=for-the-badge&logo=mongodb)](https://www.mongodb.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Bu proje; modern lojistik operasyonlarında depolama, sevkiyat, envanter, filo ve personel süreçlerinin uçtan uca dijitalleştirilmesi, ilişkisel (RDBMS) ve doküman tabanlı (NoSQL) veritabanı mimarileri üzerinde modellenmesi ve masaüstü arayüzü ile yönetilmesi amacıyla geliştirilmiş kapsamlı bir **Depo Yönetim Sistemi (WMS)** mühendislik çalışmasıdır.

---

## 👥 Proje Sahibi

* **Hacer Acar** - [GitHub Profili](https://github.com/HacerAcarr) (Öğrenci No: 1030310713)

---

## 🎯 Projenin Amacı ve Kapsamı

Tedarik zinciri ve lojistik sektöründeki en kritik darboğazlar; envanter kayıpları, verimsiz filo/şoför rotalaması, mükerrer veri girişleri ve yavaş operasyonel raporlamadır. Bu projenin temel hedefleri şunlardır:

1. **Süreç Modelleme:** Depo girdi-çıktı, sipariş karşılama, sevkiyat ve tedarik döngülerinin kurumsal ölçekte modellenmesi.
2. **İlişkisel Veri Bütünlüğü (RDBMS):** Ham verilerin 3NF (Üçüncü Normal Form) seviyesine kadar normalizasyonu ve sıfır veri anormalliği ile MS SQL Server mimarisinde kurgulanması.
3. **İş Mantığının Veritabanında Otomasyonu:** Tetikleyiciler (Triggers), Prosedürler (Stored Procedures) ve Fonksiyonlar (User-Defined Functions) aracılığıyla operasyonel kuralların veritabanı motoruna gömülmesi.
4. **Hibrit Veri Modeli (SQL & NoSQL):** Hızlı analitik, esnek şema ve yatay ölçeklenebilirlik gerektiren senaryolar için verilerin MongoDB ortamına taşınarak Aggregation Pipeline ile analizi.
5. **Kullanıcı Dostu Masaüstü Deneyimi:** C# Windows Forms üzerinden şoför ve filo operasyonlarının tam fonksiyonel CRUD modülleri ile yönetilmesi.

---

## 🛠 Kullanılan Teknolojiler ve Mimari

* **Geliştirme Ortamı:** Microsoft Visual Studio, SQL Server Management Studio (SSMS), MongoDB Compass & Mongosh
* **Programlama Dili:** C# (.NET Framework 4.7.2, Windows Forms, ADO.NET)
* **İlişkisel Veritabanı:** Microsoft SQL Server (T-SQL, Triggers, Functions, Stored Procedures, DDL/DML)
* **Doküman Tabanlı Veritabanı:** MongoDB (BSON/JSON, Aggregation Framework: `$lookup`, `$unwind`, `$match`, `$group`)
* **Tasarım & Modelleme:** ER Diyagramı (Chen Notasyonu), UML Sınıf Diyagramları

---

## 🚀 Proje Geliştirme Aşamaları (8 Görev)

### 📌 Görev 1: Varlık-İlişki (ER) Diyagramı
Sistem bünyesindeki 15 temel varlık (`Müşteri`, `Sipariş`, `Sipariş Detayı`, `Fatura`, `Taşıma`, `Firma Aracı`, `Şoför`, `Depo`, `Stok`, `Ürün`, `Kategori`, `Personel`, `Yönetici`, `Vardiya`, `Tedarikçi`, `Tedarik`) ve aralarındaki 1:1, 1:N ve M:N cardinalite ilişkileri detaylıca kurgulanmıştır.

### 📌 Görev 2: UML Sınıf Diyagramı (Object-Oriented Design)
Nesne yönelimli programlama standartlarına uygun olarak sınıfların nitelikleri (attributes), erişim belirteçleri, metotları (methods) ve kalıtım yapıları (`Yönetici` sınıfının `Personel` sınıfından kalıtım alması) modellenmiştir.

### 📌 Görev 3: Veritabanı Normalizasyonu (1NF, 2NF, 3NF)
* **Ham Tablo Analizi:** Çok değerli (multivalued) nitelikler içeren ve anormallik barındıran tek parça ham tablonun analizi.
* **1NF:** Hücrelerdeki birden çok veri atomik hale getirilmiş, her satır benzersizleştirilmiştir.
* **2NF:** Kısmi fonksiyonel bağımlılıklar (partial dependencies) elenerek ilişkisel alt tablolar oluşturulmuştur.
* **3NF:** Geçişli bağımlılıklar (transitive dependencies) kaldırılmıştır (`KategoriNo -> KategoriAd` ilişkisi `Ürün` tablosundan ayrıştırılmış, `AraToplam` ve `DolulukOranı` gibi hesaplanabilir türetilmiş sütunlar optimize edilmiştir).

### 📌 Görev 4: MS SQL Server Şema Tasarımı & Veri Yükleme
Normalizasyon sonucu elde edilen ilişkisel tablolar, `PRIMARY KEY` ve `FOREIGN KEY` referans kısıtları ile oluşturulmuş, ardından gerçekçi test veri setleri `INSERT INTO` betikleri ile veritabanına aktarılmıştır.

### 📌 Görev 5: SQL Sorguları (Temel, DML, Gelişmiş Analitik)
* **15 Temel Sorgu:** `GROUP BY`, `HAVING`, `ORDER BY`, `SUM`, `AVG`, `COUNT`, `MIN`, `MAX` fonksiyonları ile operasyonel metrik çıkarımları.
* **6 DML Sorgusu:** Dinamik koşullu `INSERT`, `UPDATE` ve `DELETE` operasyonları.
* **11 Gelişmiş Sorgu:** Çoklu `INNER JOIN`, `LEFT/RIGHT OUTER JOIN`, `EXISTS`, `IN` ve ilişkili alt sorgular (Correlated Subqueries).

### 📌 Görev 6: Programlanabilir SQL Nesneleri
* **7 Trigger (Tetikleyici):**
  * `Trg_PersonelSil`: Silinen personelleri `TabloEskiPersonel` tablosuna arşivleme.
  * `Trg_MaasGuncelleme`: Maaş düşürmeyi engelleyip artışları `Guncelleme` tablosuna loglama.
  * `Trg_SoforuPasifYapma`: Silinen şoförü silmek yerine ilişkileri korumak için `PASİF` durumuna alma (`INSTEAD OF DELETE`).
  * `Trg_Koruma`: Veritabanı seviyesinde tablo silme/değiştirmeyi önleme (`FOR DROP_TABLE, ALTER_TABLE`).
  * `Trg_DepoDolulukOrani`: Kapasite aşımını (%100) kontrol eden ve doluluk sınıfı belirleyen kural motoru.
  * `Trg_UrunRafaYerlesme` & `Trg_TedarikBilgi`: Tedarik kabulü ve raflama süreçlerini otomatize eden tetikleyiciler.
* **7 User-Defined Function (UDF):** Tablo değerli fonksiyonlar (`TedarikciUrunleri`, `UrunBilgisi`) ve skaler fonksiyonlar (ehliyet sınıfı yetki denetimi, doğum yılından yaş hesabı, filo müsaitlik sorguları).
* **5 Stored Procedure:** Cursor kullanarak şoför sevkiyat atamaları (`SoforGorevAta`), dinamik prim dağıtımı (`PersonelePrim`), fatura indirim kuralları (`Indirim`) ve depo envanter özetleri (`DepoBilgi`).

### 📌 Görev 7: JSON Dönüşümü ve MongoDB (NoSQL) Pipeline
* İlişkisel veriler `FOR JSON AUTO` ile JSON formatına dönüştürülmüştür.
* MongoDB üzerinde 11 koleksiyon oluşturularak veriler BSON formatında indekslenmiştir.
* MongoDB Aggregation Pipeline ile `$lookup` ve `$unwind` kullanılarak NoSQL üzerinde JOIN işlemleri gerçekleştirilmiş; `$group` ve `$match` operatörleriyle analitik raporlamalar üretilmiştir.

### 📌 Görev 8: C# Windows Forms Yönetim Paneli
* `MenuStrip` mimarisiyle tasarlanmış kurumsal ana dashboard.
* **Firma Araçları Yönetimi:** Yeni araç ekleme, silme, plaka/model güncelleme ve `DataGridView` ile dinamik listeleme.
* **Şoför Yönetimi:** Şoför kaydı, lisans ve müsaitlik durumu takibi, güvenli silme ve anlık listeleme.
* Parametrik SQL komutları (`SqlParameter`) ile SQL Injection risklerine karşı tam koruma.

---

## 📂 Proje Dizin Yapısı

## 📂 Proje Dizin Yapısı

```plaintext
📦 Lojistik-Depo-Yonetim-Sistemi
├── 📁 docs
│   ├── final-raporu.pdf             # Akademik Proje Final Raporu
│   ├── normalizasyon-detaylari.pdf  # 1NF, 2NF, 3NF Normalizasyon Süreçleri
│   └── vize-raporu.pdf              # Vize Dönemi Veritabanı Raporu
├── 📁 diagrams
│   ├── er-diyagrami.pdf             # Varlık-İlişki Diyagramı (Görev 1)
│   ├── uml-diyagrami.pdf            # UML Sınıf Diyagramı (Görev 2)
│   └── varlik-iliski-diyagrami.dwg  # AutoCAD Çizimi
├── 📁 mongodb
│   ├── 📁 data                      # Dışa aktarılan JSON koleksiyonları
│   └── mongodb-aktarim-sorgulari.sql # Mongosh ve Compass sorguları (Görev 7)
├── 📁 sql
│   ├── 00-init-database.sql         # Veritabanı ve Tablo Oluşturma Şeması
│   ├── 01-data-seed.sql             # Test Verileri ve INSERT İşlemleri
│   ├── gorev-5-sorgular.sql         # Temel ve Gelişmiş Sorgular
│   └── gorev-6-trigger-fonksiyon.sql # Trigger, Procedure, Function
├── 📁 src
│   └── 📁 DepoYonetimApp            # C# Windows Forms Proje Kaynak Kodları
│       ├── DepoYonetimApp.sln       # Visual Studio Çözüm Dosyası
│       ├── App.config               # Veritabanı Connection String
│       └── ...                      # Formlar ve C# Sınıfları
└── README.md                        # Proje Dokümantasyonu
```

---

## ⚙️ Kurulum ve Çalıştırma Adımları

### 1. Veritabanının Kurulumu (MS SQL Server)
1. SQL Server Management Studio (SSMS) uygulamasını açın ve sunucunuza bağlanın.
2. sql/00-init-database.sql ve sql/01-data-seed.sql dosyalarını sırasıyla açıp çalıştırın (Execute). Bu işlem BirLojistikFirmasininDepoYonetimSistemi (veya Grup26) veritabanını, tabloları ve örnek kayıtları oluşturacaktır.
3. sql/gorev-6-trigger-fonksiyon.sql dosyasını çalıştırarak trigger, fonksiyon ve prosedürleri yükleyin.

### 2. NoSQL Ortamının Hazırlanması (MongoDB)
1. MongoDB Compass veya Mongosh uygulamasını açarak yerel sunucunuza (mongodb://localhost:27017/) bağlanın.
2. use Grup26 komutu ile yeni bir veritabanı alanı oluşturun.
3. mongodb/data/ dizinindeki JSON dosyalarını ilgili koleksiyonlara (depo, musteri, personel, vb.) aktarın (Import Data).
4. mongodb/mongodb-aktarim-sorgulari.sql dosyasındaki aggregate sorgularını çalıştırabilirsiniz.

### 3. C# Arayüzünün Çalıştırılması
1. src/DepoYonetimApp/DepoYonetimApp.sln dosyasını Visual Studio ile açın.
2. App.config ve form sınıfları içerisindeki connectionString alanını kendi yerel SQL Server örneğinize göre doğrulayın:
   ```csharp
   SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog=Grup26;Integrated Security=True");
   ```
3. Projeyi derleyin (`Build Solution`) ve `F5` tuşuna basarak başlatın.

---

## 📜 Lisans

Bu proje akademik ve eğitim amaçlı geliştirilmiş olup **MIT Lisansı** kapsamında açık kaynak olarak paylaşılmıştır. Detaylar için `LICENSE` dosyasına göz atabilirsiniz.
