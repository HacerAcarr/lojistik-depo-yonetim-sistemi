--TABLOLARI OLUŞTURMA

--Yöneticilerin kim olduğunu belirtir.
create table TabloYonetici (
YoneticiID int primary key,
DeneyimYili int, 
YoneticiMaas decimal(18,2)
);

--Ürünlerin kategorisini belirtir.
create table TabloKategori (
KategoriNo int primary key , 
KategoriAd nvarchar(50)
);

--Ürünlerin tedarik edildiği yerin bilgileri vardır.
create table TabloTedarikci (
TedarikciID varchar(20) primary key,
TedarikciVergiNo varchar(20),
TedarikciSehir nvarchar(50),
TedarikciEposta nvarchar(100),
TedarikciTel varchar(15) 
);

--Müşterilerin bilgilerini belirtir.
create table TabloMusteri (
MusteriID int primary key,
VergiNo varchar(20),
MusteriAdSoyad nvarchar(100),
MusteriDogumGunu date,
MusteriSehir nvarchar(50),
MusteriEposta varchar(100),
MusteriTel varchar(15),
MusteriCinsiyet nvarchar(10)
);

--Kargo firmasının kullandığı araç bilgilerini belirtir.
create table TabloArac (
AracID int primary key,
Plaka varchar(20),
AracModel nvarchar(50),
AracMarka nvarchar(50)
);

--Ürünleri müşteriye ulaştıran kargo firmalarının bilgilerini belirtir.
create table TabloKargoFirma (
KargoFirmaNo int primary key,
KargoFirmaTel varchar(15),
KargoFirmaEposta varchar(100),
KargoFirmaSehir nvarchar(50)
);

--Personellerin vardiyalarını belirtir.
create table TabloVardiya (
VardiyaID int primary key,
VardiyaTuru nvarchar(20),
VardiyaTarih  date,
VardiyaBaslangicSaat time,
VardiyaBitisSaat time
);

--Ürünlerin tutuulduğu depo bilgilerini belirtir.
create table TabloDepo (
DepoID int primary key,
DepoSehir nvarchar(50),
DepoAd nvarchar(100),
DepoDolulukOrani decimal(3,2)
);

go

--Kargo firmaları ile yapılan sözleşmeyi belirtir.
create table TabloSozlesme (
SozlesmeNo int primary key ,
KargoFirmaNo int foreign key references TabloKargoFirma(KargoFirmaNo)
);

--Ürün taşıma eylemi ile ilgili bilgiler gösterir.
create table TabloTasima (
TasimaID int primary key ,
TakipNo varchar(20),
TeslimTarihi date,
AradcID int foreign key references TabloArac(AracID),-- Hangi araçla gittiğini gösterir.
KargoFirmaNo int foreign key references TabloKargoFirma(KargoFirmaNo) --Hangi firmayla gittiğini gösterir.
);

--Depoda bulunan stok ile ilgili bilgileri gösterir.
create table TabloStok (
StokID int primary key,
StokMiktar int ,  
StokGirisTarihi date,
RafID varchar(20),
DepoID int foreign key references TabloDepo(DepoID) -- Hangi depoda olduğunu gösterir.
);

--Ürünün siparişi ile ilgili bilgileri gösterir.
create table TabloSiparis (
SiparisID int primary key ,
MusteriID int foreign key references TabloMusteri(MusteriID), -- Kimin sipariş ettiğini gösterir.
SiparisTarihi date,
TasimaID int foreign key references TabloTasima(TasimaID) -- Hangi taşıma ile gittiğini gösterir.
);
 
--Depoda çalışan personel bilgilerini belirtir.
create table TabloPersonel (
PersonelID int primary key , 
PersonelTC varchar(11),
PersonelAdSoyad nvarchar(100),
PersonelTel varchar(15),
PersonelMaas decimal(18,2),
PersonelCinsiyet nvarchar(10),
VardiyaID int foreign key references TabloVardiya(VardiyaID) ,-- Personelin hangi vardiyada olduğunu gösterir.
YoneticiID int foreign key references TabloYonetici(YoneticiID) -- Personelin yöneticisini gösterir.
);

go

--Sipariş edilen ürün hakkındaki bilgileri gösterir.
create table TabloUrun (
UrunId int primary key ,
UrunAd nvarchar(100) , 
KategoriNo int foreign key references TabloKategori(KategoriNo), --Ürün hangi kategoride olduğunu gösterir.
StokID int foreign key references TabloStok(StokID) -- Ürünün stoktaki kaydını gösterir.
);

--Müşterinin ödediği fatura bilgilerini gösterir.
create table TabloFatura (
FaturaID int primary key,
SiparisID int foreign key references TabloSiparis(SiparisID), --Hangi sipariş için fatura olduğunu gösterir.
MusteriID int foreign key references TabloMusteri(MusteriID) , --Fatura hangi müşteri için olduğunu gösterir.
FaturaKDV decimal(4,2),
FaturaTarihi date,
FaturaToplamTutar decimal(18,2)
);

go

--Tedarik bilgilerini gösterir.
create table TabloTedarik (
TedarikNo int ,
TedarikTarihi date,
TedarikMiktar int,
TedarikciID varchar(20) foreign key references TabloTedarikci(TedarikciID),
UrunID int foreign key references TabloUrun(UrunID),
primary key (TedarikNo,UrunID)
);

--Siparişin detaylarını içerir.
create table TabloSiparişDetay (
SiparisDetayID int primary key,
SiparisID int foreign key references TabloSiparis(SiparisID),--Hangi siparişe ait olduğunu gösterir.
UrunID int foreign key references TabloUrun(UrunID) ,--Hangi ürüne ait olduğunu gösterir.
SiparisMiktar int,
SiparisBirimFiyat decimal(18,2)
);

 go