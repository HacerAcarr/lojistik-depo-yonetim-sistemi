USE master
go
create database BirLojistikFirmasininDepoYonetimSistemi
go
use BirLojistikFirmasininDepoYonetimSistemi
go 
--TABLOLARI OLUŞTUR.
--Yöneticilerin bilgilerini gösterir.
create table TabloYonetici(
YoneticiID int primary key,
DeneyimYili int,
YoneticiMaad decimal(18,2)
);
--Ürünlerin kategorisini gösterir.
create table TabloKategori(
KategoriNo int primary key,
KategoriAd nvarchar(50)
);
--Ürünlerin tedarik edildiği yerin bilgilerini gösterir.
create table TabloTedarikci(
TedarikciID varchar(20) primary key,
TedarikciVergiNo varchar(20),
TedarikciSehir nvarchar(50),
TedarikciEposta nvarchar(100),
TedarikciTel varchar(15)
);
--Müşteri bilgilerini gösterir.
create table TabloMusteri(
MusteriID int primary key,
VergiNo varchar(20),
MusteriAdSoyad nvarchar(100),
MusteriDogumGunu date,
MusteriSehir nvarchar(50),
MusteriEposta varchar(100),
MusteriTel varchar(15),
MusteriCinsiyet nvarchar(10)
);
--Firma araç bilgilerini gösterir.
create table TabloFirmaArac(
FirmaAracID int primary key,
Plaka varchar(20),
AracModel nvarchar(50),
AracMarka nvarchar(50)
);
--Ürünleri müşteriye ulaştıran ,araçları kullanan şoförlerin bilgilerini gösterir.
create table  TabloSofor(
EhliyetNo int primary key,
SoforAdSoyad nvarchar(100),
LisansSinifi nvarchar(10),
MusaitlikDurumu nvarchar(50)
);
--Personellerin vardiya bilgilerini gösterir.
create table TabloVardiya(
VardiyaID int primary key,
VardiyaTuru nvarchar(20),
VardiyaTarih date,
VardiyaBaslangicSaat time,
VardiyaBitisSaat time
);
--Ürünlerin tutulduğu depo bilgilerini gösterir.
create table TabloDepo(
DepoID int primary key,
DepoSehir nvarchar(50),
DepoAd nvarchar(100),
DepoDolulukOrani decimal(3,2)
);

go

--Ürün taşıma eylemi ile ilgili bilgileri gösterir.
create table TabloTasima(
TasimaID int primary key,
TakipNo nvarchar(20),
TeslimTarihi date,
FirmaAracID int foreign key references TabloFirmaArac(FirmaAracID),--Hangi araçla türünlerin taşındığını gösterir.
EhliyetNo int foreign key references TabloSofor(EhliyetNo)--Hangi şoförle ürünlerin taşındığını gösterir.
);
--Depoda bulunan stok ile ilgili bilgileri gösterir.
create table TabloStok(
StokID int primary key ,
StokMiktar int,
StokGirisTarihi date,
RafID varchar(20),
DepoID int foreign key references TabloDepo(DepoID)--Hangi depoda stok olduğunu gösterir.
);
--Ürünün siparişi ile ilgili bilgileri gösterir.
create table TabloSiparis(
SiparisID int primary key,
MusteriID int foreign key references TabloMusteri(MusteriID),--Kimin sipariş ettiğini gösterir.
SiparisTarihi date,
TasimaID int foreign key references TabloTasima(TasimaID)--Hangi taşıma ile gittiğini gösterir.
);
--Depoda çalışan personel bilgilerini gösterir.
create table TabloPersonel(
PersonelID int primary key,
PersonelTC varchar(11),
PersoneAdSoyad nvarchar(100),
PersonelTel varchar(15),
PersonelMaas decimal(18,2),
PersonelCinsiyet nvarchar(10),
VardiyaID int foreign key references TabloVardiya(VardiyaID),--Personelin hangi vardiyada olduğunu gösterir.
YoneticiID int foreign key references TabloYonetici(YoneticiID)--Personelin yöneticisini gösterir.
);

go

--Sipariş edilen ürün hakkındaki bilgileri gösterir.
create table TabloUrun(
UrunID int primary key ,
UrunAd nvarchar(100),
KategoriNo int foreign key references TabloKategori(KategoriNo),--Ürünün hangi kategoride olduğunu gösterir.
StokID int foreign key references TabloStok(StokID)--Ürünün hangi stok kaydında olduğunu gösterir.
);
--Müşterinin ödediği fatura bilgilerini gösterir.
create table TabloFatura(
FaturaID int primary key ,
SiparisID int foreign key refErences TabloSiparis(SiparisID),--Hangisipariş hangi faturaya ait olduğunu gösterir.
MusteriID int foreign key references TabloMusteri(MusteriID),--Fatura hangi müşteri için onu gösterir.
FaturaKDV decimal(4,2),
FaturaTarihi date,
FaturaToplamTutar decimal(18,2)
);

go

--Tedarik bilgilerini gösterir.
create table TabloTedarik(
TedarikNo int,
TedarikTarihi date,
TedarikMiktar int,
TedarikciID varchar(20) foreign key references TabloTedarikci(TedarikciID),
UrunID int foreign key references TabloUrun(UrunID),
primary key (TedarikNo,UrunID)
);
--Siparişin detaylarını gösterir.
create table TabloSiparisDetay(
SiparisDetayID int primary key,
SiparisID int foreign key references TabloSiparis(SiparisID),--Hangi siparişe ait olduğunu gösterir.
UrunID int foreign key references TabloUrun(UrunID),--Hangi ürüne ait olduğunu gösterir.
SiparisMiktar int,
SiparisBirimFiyat decimal(18,2)
);
go
 
insert into TabloMusteri 
      values (1,15246798,'Ali VURAL', '2004-07-07','Ankara','alivural2004@gmail.com',5525486235,'ERKEK');
insert into TabloMusteri
      values (2,14315792,'Ömer ALACA','2005-06-26','Ankara','omeralaca@gmail.com',5478529632,'ERKEK');
insert into TabloMusteri
      values (3,14318795,'Ajda ENDER','2004-05-15','Kayseri','aender2004@gmail.com',5147895263,'KADIN');
insert into TabloMusteri
      values (4,14619573,'Gökçe Eda ARSLAN','1982-09-13','İzmir','arslangökceeda@gmail.com',5248523695,'KADIN');
insert into TabloMusteri
      values (5,15124372,'Merve AKYILDIZ','2001-04-27','Kırşehir','akyildiz@gmail.com',5758963215,'KADIN');
insert into TabloMusteri
      values (6,11275462,'Ecrin Tuana SANCAK','2003-10-30','Bursa','sancak30102000@gmail.com',5735879548,'KADIN');
insert into TabloMusteri
      values (7,12451672,'Hatice UYSAL','1996-11-17','İzmir','haticeuysal2020@gmail.com',5987772541,'KADIN');
insert into TabloMusteri
      values (8,19465425,'Neriman SALLAN','1987-03-25','Sivas','sallanneriman1987@gmail.com',5213565445,'KADIN');


insert into TabloKategori
      values (101,'Dış Giyim');
insert into TabloKategori
      values (102,'Üst Giyim');    
insert into TabloKategori
      values (103,'Alt Giyim');
insert into TabloKategori
      values (104,'Ayakkabı');
insert into TabloKategori
      values (105,'Aksesuar');      


insert into TabloFirmaArac
      values (1,'38 TKS 001','Doblo','Fiat');
insert into TabloFirmaArac
      values (2,'38 TKS 003','Doblo','Fiat');
insert into TabloFirmaArac
      values (3,'06 TMS 201','Transit Courier','Ford');
insert into TabloFirmaArac
      values (4,'38 AKB 701','Partner','Peugeot');
insert into TabloFirmaArac
      values (5,'38 TKS 801','Kangoo','Renault');
insert into TabloFirmaArac
      values (6,'06 TZC 451','Transit Courier','Ford');
insert into TabloFirmaArac
      values (7,'06 AKB 814','Transit Courier','Ford');
insert into TabloFirmaArac
      values (8,'06 EBB 951','Combo','Opel');
insert into TabloFirmaArac
      values (9,'38 HNS 017','Transit Courier','Ford');
insert into TabloFirmaArac
      values (10,'38 BBC 177','Transit Courier','Ford');
insert into TabloFirmaArac
      values (11,'06 LKS 687','Transit Courier','Ford');


insert into TabloDepo
      values (1,'Kayseri','KayDepo',0.30);
insert into TabloDepo
      values (2,'Ankara','AnkaDepo',0.45);
insert into TabloDepo
      values (3,'İzmir','İzDepo',0.60);


insert into TabloTasima
      values (910,86520,'2025-09-19',4,387);
insert into TabloTasima
      values (923,80321,'2025-09-15',5,354);
insert into TabloTasima
      values (930,89652,'2025-09-20',8,327);
insert into TabloTasima
      values (940,87410,'2025-09-20',6,329);
insert into TabloTasima
      values (956,85462,'2025-09-15',1,369);
insert into TabloTasima
      values (960,84520,'2025-09-18',9,347);
insert into TabloTasima
      values (975,87520,'2025-09-22',3,331);
insert into TabloTasima
      values (987,84521,'2025-09-16',2,321);
insert into TabloTasima
      values (993,84245,'2025-09-21',9,354);
insert into TabloTasima
      values (994,86325,'2025-09-16',10,331);
insert into TabloTasima
      values (996,87452,'2025-09-18',7,369);
insert into TabloTasima
      values (997,89541,'2025-09-04',11,369);


insert into TabloTedarikci
      values (412365009,2013,'Adana','Adanatedarik@gmail.com',5154567895);
insert into TabloTedarikci
      values (423698520,5712,'Bursa','Bursatedarik@gmail.com',5521698745);
insert into TabloTedarikci
      values (451258784,7456,'Ankara','ankatedarik@gmail.com',5475219874);
insert into TabloTedarikci
      values (458545667,8546,'Ankara','ankaratedarik@gmail.com',5565415263);


insert into TabloStok
      values (103,10,'2023-07-20',10,1);
insert into TabloStok
      values (110,8,'2025-07-20',11,2);
insert into TabloStok
      values (203,30,'2024-07-10',21,1);
insert into TabloStok
      values (209,10,'2025-07-10',20,1);
insert into TabloStok
      values (210,100,'2023-07-10',20,1);
insert into TabloStok
      values (215,40,'2025-07-20',22,3);
insert into TabloStok
      values (305,50,'2024-07-15',30,1);
insert into TabloStok
      values (310,15,'2022-07-15',31,2);
insert into TabloStok
      values (320,30,'2025-07-15',32,1);
insert into TabloStok
      values (406,20,'2024-07-05',40,1);
insert into TabloStok
      values (506,150,'2023-07-30',50,3);


insert into TabloSofor
      values (321,'Ali TOPRAK','B','Müsait Değil');
insert into TabloSofor
      values (327,'Kemal ULU','A','Müsait');
insert into TabloSofor
      values (329,'Rıza KÜÇÜK','B','Müsait');
insert into TabloSofor
      values (331,'Mert SAĞLAM','B','Müsait Değil');
insert into TabloSofor
      values (347,'Can YAMAN','A','Müsait Değil');
insert into TabloSofor
      values (354,'Abdullah GÜLEÇ','B','Müsait');
insert into TabloSofor
      values (369,'Ahmet USLU','A','Müsait');
insert into TabloSofor
      values (387,'Kenan SAKLI','B','Müsait Değil');


insert into TabloTedarik 
      values (35,'2025-07-09',100,423698520,4512);
insert into TabloTedarik 
      values (35,'2024-07-09',150,412365009,2147);
insert into TabloTedarik 
      values (36,'2025-07-04',190,423698520,2354);
insert into TabloTedarik 
      values (37,'2023-07-09',110,458545667,3652);
insert into TabloTedarik 
      values (37,'2025-07-09',190,412365009,1785);
insert into TabloTedarik 
      values (38,'2023-08-14',160,412365009,2123);
insert into TabloTedarik 
      values (39,'2024-07-14',150,423698520,3475);
insert into TabloTedarik 
      values (40,'2025-07-19',192,458545667,1985);
insert into TabloTedarik 
      values (40,'2024-07-09',112,451258784,1985);
insert into TabloTedarik 
      values (41,'2024-06-19',172,458545667,1985);
insert into TabloTedarik 
      values (42,'2024-06-19',195,451258784,1985);


insert into TabloSiparis
      values (10,1,'2025-06-10',956);
insert into TabloSiparis
      values (11,2,'2025-06-10',987);
insert into TabloSiparis
      values (12,3,'2025-06-10',923);
insert into TabloSiparis
      values (13,4,'2025-06-10',910);
insert into TabloSiparis
      values (14,5,'2025-06-11',940);
insert into TabloSiparis
      values (15,6,'2025-06-11',960);
insert into TabloSiparis
      values (16,7,'2025-06-12',975);
insert into TabloSiparis
      values (19,8,'2025-06-14',930);


insert into TabloYonetici
      values (10003,19,250000.00);
insert into TabloYonetici
      values (10004,15,100000.00);
insert into TabloYonetici
      values (10005,5,150000.00);
insert into TabloYonetici
      values (10006,4,85000.00);
insert into TabloYonetici
      values (10007,16,120000.00);


insert into TabloVardiya
      values (701,'Gece','2022-09-20','00:00:00','08:00:00');
insert into TabloVardiya
      values (702,'Gece','2022-09-20','00:00:00','08:00:00');
insert into TabloVardiya
      values (703,'Gece','2023-09-21','00:00:00','08:00:00');
insert into TabloVardiya
      values (704,'Gece','2025-09-21','00:00:00','08:00:00');
insert into TabloVardiya
      values (801,'Gündüz','2024-09-20','08:00:00','23:00:00');
insert into TabloVardiya
      values (802,'Gündüz','2024-09-20','08:00:00','23:00:00');
insert into TabloVardiya
      values (803,'Gündüz','2023-09-211','08:00:00','23:00:00');
insert into TabloVardiya
      values (804,'Gündüz','2023-09-21','08:00:00','23:00:00');


insert into TabloUrun
      values (1785,'Ceket',101,103);
insert into TabloUrun
      values (1985,'Kaban',101,103);
insert into TabloUrun
      values (2123,'Kazak',101,103);
insert into TabloUrun
      values (2147,'Bluz',101,103);
insert into TabloUrun
      values (2354,'Tişört',101,103);
insert into TabloUrun
      values (2564,'Tişört',101,103);
insert into TabloUrun
      values (3475,'Şort',101,103);
insert into TabloUrun
      values (3524,'Jean',101,103);
insert into TabloUrun
      values (3652,'Etek',101,103);
insert into TabloUrun
      values (4512,'Bot',101,103);
insert into TabloUrun
      values (5624,'Kemer',101,103);


insert into TabloSiparisDetay
      values (1234,10,2564,2,850.00);
insert into TabloSiparisDetay
      values (1236,12,2147,2,450.00);
insert into TabloSiparisDetay
      values (1247,12,2354,3,385.00);
insert into TabloSiparisDetay
      values (1253,11,4512,2,1950.00);
insert into TabloSiparisDetay
      values (1365,13,3652,2,1085.00);
insert into TabloSiparisDetay
      values (1425,10,3524,1,1050.00);
insert into TabloSiparisDetay
      values (1456,19,1985,1,2400.00);
insert into TabloSiparisDetay
      values (1524,15,2123,3,275.00);
insert into TabloSiparisDetay
      values (1756,16,5624,3,1080.00);
insert into TabloSiparisDetay
      values (1825,14,1785,1,2950.00);
insert into TabloSiparisDetay
      values (1965,15,3475,1,1650.00);


insert into TabloFatura
      values (601,10,1,20.00,'2024-09-10',3300.00);
insert into TabloFatura
      values (602,11,2,70.00,'2025-09-10',6630.00);
insert into TabloFatura
      values (603,12,3,40.00,'2025-09-10',2877.00);
insert into TabloFatura
      values (604,13,4,20.00,'2023-09-10',2604.00);
insert into TabloFatura
      values (605,14,5,50.00,'2025-09-11',4425.00);
insert into TabloFatura
      values (606,15,6,20.00,'2024-09-11',2970.00);
insert into TabloFatura
      values (607,16,7,30.00,'2025-09-12',4212.00);
insert into TabloFatura
      values (608,19,8,20.00,'2023-09-14',2880.00);


insert into TabloPersonel 
      values (50,12365412345,'Selim KARA',5216485623,25000.00,'ERKEK',801,10004);
insert into TabloPersonel 
      values (51,12365478963,'Nalan DEMİR',5236547891,30000.00,'KADIN',802,10003);
insert into TabloPersonel 
      values (52,12365478574,'Ferhat ACAR',5321475146,25000.00,'ERKEK',803,10006);
insert into TabloPersonel 
      values (53,12457896385,'Elif YAMAN',5231658741,25000.00,'KADIN',804,10003);
insert into TabloPersonel 
      values (54,14587961247,'Melis KORAL',5462188533,30000.00,'KADIN',701,10005);
insert into TabloPersonel 
      values (55,25416387952,'Tamer AKAL',5147952344,25000.00,'ERKEK',702,10005);
insert into TabloPersonel 
      values (56,36541258792,'Cemal EREN',5621478512,30000.00,'ERKEK',703,10007);
insert into TabloPersonel 
      values (57,52135995458,'Sibel ARAS',5552631553,30000.00,'KADIN',704,10005);
GO