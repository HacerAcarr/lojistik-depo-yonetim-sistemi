use Grup26
go
--GÖREV 5 SQL Sorguları (Temel+DML+Gelismis)
--Temel Sorgular

--1) Her bir siparişin toplam ürün miktarını hesaplar.En az ürüne sahip siparişten en çok ürüne sahip siparişe doğru sıralar.
select SiparisID,
sum(SiparisMiktar) as ToplamSiparisMiktar
from TabloSiparisDetay
group by SiparisID
order by ToplamSiparisMiktar ASC;

--2) Deneyimi 5 yıldan fazla olan yöneticileri her bir deneyim yılına göre gruplar ve bu gruplardaki ortalama maaşı hesaplar.
--   Sonuçları da ortalama maaşa göre en düşükten yükseğe doğru sıralar.
select DeneyimYili,
avg(YoneticiMaas) as OrtalamaYoneticiMaas
from TabloYonetici
where DeneyimYili>5
group by DeneyimYili
order by OrtalamaYoneticiMaas ASC;

--3) Müşteriye ürün götüren şoförleri lisans sınıfına göre gruplayarakher bir lisans sınıfındakaç farklı şoför olduğunu sayar.
--   Sonuçları sayılan şoför sayısına göre çoktan aza doğru sıralar ve sadece müsait olan şoförleri dahil eder.
select LisansSinifi,
count(EhliyetNo) as SoforSayisi
from TabloSofor
where MusaitlikDurumu ='Müsait'
group by LisansSinifi
order by SoforSayisi DESC;

--4) Ankara şehrinden gelen tüm müşterilerin adlarını, soyadlarını ve doğum günlerini listeler.Sonuçları müşterilerin doğum günlerine 
--   göre yeniden eskiye doğru sıralar.
select MusteriAdSoyad,MusteriDogumGunu
from TabloMusteri
where MusteriSehir='Ankara'
order by MusteriDogumGunu DESC;

--5) Firma araçlarını markaya göre gruplayarak her markada kaç adet araç olduğunu sayar. Sonuçları en çoktan aza doğru sıralar.
select AracMarka,
count(FirmaAracID) as AracAdedi
from TabloFirmaArac
where Plaka is not null
group by AracMarka
order by AracAdedi DESC;

--6) Sadece DepoID=1 olan depoya ait stok kayıtlarını listeler.Her bir RafID'sine göre gruplayarak o raftaki toplam stok 
--   miktarını bulur ve sonuçları toplam miktara göre düşükten yükseğe doğru sıralar.
select RafID,
sum(StokMiktar) as ToplamMiktar
from TabloStok
where DepoID=1
group by RafID
order by ToplamMiktar ASC;

--7) Fatura toplam tutarı 500 TL'den fazla olan faturaları dahil eder ve bu faturaları fatura tarihinin yıllarına göre gruplayarak
--   her yıl için toplam ciroyu (Fatura toplam tutar) hesaplar.Sonuçları yıllık ciroya göre düşükten yükseğe doğru sıralar.
select year(FaturaTarihi) as FaturaYili,
sum(FaturaToplamTutar) as YillikCiro
from TabloFatura
where FaturaToplamTutar>500
group by year(FaturaTarihi)
order by YillikCiro ASC;

--8) Adana şehrinde bulunmayan tedarikçileri dahil eder ve bu tedarikçileri şehirlere göre gruplayarak her şehirde
--   kaç farklı tedarikçi olduğunu sayar. Sonuçları tedarikçi sayısına göre  azdan çoğa doğru sıralar.
select TedarikciSehir,
count(TedarikciID) as TedarikciAdedi
from TabloTedarikci
where TedarikciSehir <> 'Adana'
group by TedarikciSehir
order by TedarikciAdedi ASC;

--9) Kadın cinsiyetine sahip müşterileri dahil eder ve bu müşterileri şehire göre gruplayarak her şehirde kaç adet
--   kadın müşteri olduğunu sayar. Sonuçları müşteri sayısına göre azdan çoğa doğru sıralar.
select MusteriSehir,
count(MusteriID) as KadinMusteriAdedi
from TabloMusteri
where MusteriCinsiyet='KADIN'
group by MusteriSehir
order by KadinMusteriAdedi ASC;  

--10) Cinsiyet erkek olmayan personelleri dahil eder ve bu personelleri VardiyaID'sine göre gruplayarak her 
--    vardiyanın ortalama maaşını bulur. Sonuçları ortalama maaşa göre yüksekten düşüğe sıralar.
select VardiyaID,
avg(PersonelMaas) as OrtalamaMaas
from TabloPersonel
where PersonelCinsiyet<>'ERKEK'
group by VardiyaID
order by OrtalamaMaas DESC;

--11) Depo doluluk oranı %50'den az veya eşit olan depoları dahil eder ve bu depoları depo şehrine göre gruplayarak her 
--    şehirdeki en düşük doluluk oranını bulur. Sonuçları en düşük doluluk oranına göre en çoktan aza doğru sıralar.
select DepoSehir,
min(DepoDolulukOrani) as EnDusukDoluluk
from TabloDepo
where DepoDolulukOrani<=0.50
group by DepoSehir
order by EnDusukDoluluk DESC;

--12) Cinsiyeti kadın olan veya VardiyaID'si 703 olan personeli dahil eder ve bu personelleri VardiyaID'sine göre gruplayarak
--    her vardiyadaki toplam maaşı bulur. Sonuçları toplam maaşa göre düşükten yükseğe doğru sıralar.
select VardiyaID,
sum(PersonelMaas) as ToplamMaas
from TabloPersonel
where PersonelCinsiyet='KADIN' or VardiyaID=703
group by VardiyaID
order by ToplamMaas ASC;

--13) Tedarik miktarı 100'den fazla olan kayıtları dahil eder ve bu kayıtları tedarik tarihi yılına göre gruplayarak
--    her yıldaki en yüksek tedarik miktarını bulur. Sonuçları maksimum miktara göre düşükten yükseğe sıralar.
select year(TedarikTarihi) as TedarikYili,
max(TedarikMiktar) as MaxMiktar
from TabloTedarik
where TedarikMiktar>100
group by year(TedarikTarihi)
order by MaxMiktar ASC;

--14) Tedarik miktarı 100 ile 160 arasında olan kayıtları dahil eder ve bu kayıtları tedarik tarihinin ayına göre gruplayarak her bir
--    ayda gerçekleşen toplam tedarik miktarını bulur.Sonuçları aylık toplam miktara göre azdan çoğa doğru sıralar.
select month(TedarikTarihi) as TedarikAyi,
sum(TedarikMiktar) as AylikToplamMiktar
from TabloTedarik
where TedarikMiktar between 100 and 160
group by month(TedarikTarihi)
order by AylikToplamMiktar ASC;

--15) Vardiya başlangıç saati 8'den büyük veya vardiya bitiş saati 17'den küçük olan kayıtları dahil eder ve bu kayıtları vardiya
--    türüne göre gruplayarak her bir vardiya türünde gerçekleşen toplam vardiya adedinibulur. Sonuçları toplam adede göre azdan
--    çoğa doğru sıralar.
select VardiyaTuru, 
count(VardiyaID) as ToplamVardiyaAdedi
from TabloVardiya
where VardiyaBaslangicSaat>'08:00:00' or VardiyaBitisSaat<'17:00:00'
group by VardiyaTuru
order by ToplamVardiyaAdedi ASC;


--DML

--1) Yeni işe başlayan bir personeli, personel tablosuna ekler.
insert into dbo.TabloPersonel(PersonelID,PersonelAdSoyad,PersonelCinsiyet,PersonelTel,PersonelTC,PersonelMaas,VardiyaID,YoneticiID,DepoID)
       values(60,'Şeyma ARAR', 'KADIN',5525486521,12546985412,25000.00,704,10003,2);
select * from TabloPersonel;

--2) Yeni açılan depoyu, depo tablosuna ekler.
insert into dbo.TabloDepo(DepoID,DepoAd,DepoSehir,DepoDolulukOrani)
       values(4,'BursaDepo','Bursa',0.00);
select * from TabloDepo;

--3) VardiyaID=4 olan ve maaşı 28000 TL'den az olan tüm personellerin maaşını 10000 TL arttırır.
update dbo.TabloPersonel
set PersonelMaas=PersonelMaas+10000
where VardiyaID=4 and PersonelMaas<28000;
select * from TabloPersonel;

--4) TedarikciID=412365009 olan tedarikçinin e-posta adresini AtedarikQgmail.com ve telefon numarasını 5542653215 olarak günceller.
update dbo.TabloTedarikci
set TedarikciEposta='Atedarik@gmail.com', TedarikciTel=5542653215
where TedarikciID=412365009;
select * from TabloTedarikci ;

--5) Firmada yeni işe başlayan üç şoförün bilgilerini, şoför tablosuna ekler.
insert into TabloSofor(EhliyetNo,SoforAdSoyad,LisansSinifi,MusaitlikDurumu,FirmaAracID)
       values(398,'Kemal ERMEZ','B','Müsait',12),
             (397,'Şaziye PARLAK','A','Müsait',13),
             (396,'Ilgaz ANADOLU','A','Müsait',14);
select * from TabloSofor;

--6) Tedarik tablosundai, tedarik miktarı 100 olan kayıtları siler.
delete from TabloTedarik
where TedarikMiktar=100;
select * from TabloTedarik;


--GELİŞMİŞ SORGULAR

--1) Tüm yöneticileri listeler ve her yöneticinin altında çalışan personel sayısını gösterir.
select Yntc.YoneticiID, Yntc.DeneyimYili, Yntc.YoneticiMaas,
count(Prs.PersonelID)as YonetilenPersonelSayisi
from TabloYonetici as Yntc
    left outer join TabloPersonel as Prs on Yntc.YoneticiID=Prs.YoneticiID
group by Yntc.YoneticiID ,Yntc.DeneyimYili, Yntc.YoneticiMaas
order by YonetilenPersonelSayisi DESC, Yntc.YoneticiID;

--2) Hangi şoförlerin en az iki farklı araçla taşıma yaptığını bulur ve bu şoförlerin sayısını listeler.
select Sfr.EhliyetNo, Sfr.SoforAdSoyad,
count(distinct Tsm.FirmaAracID) as KullanılanFarkliAracSayisi
from TabloSofor as Sfr
    inner join TabloTasima as Tsm on Sfr.EhliyetNo=Tsm.EhliyetNo
group by Sfr.SoforAdSoyad,Sfr.EhliyetNo
having count (distinct Tsm.FirmaAracID)>=2
order by KullanılanFarkliAracSayisi ASC;

--3) Sipariş edilmiş ürünlerin ait olduğu kategori adlarını ve bu ürünlerin tüm siparişlerdeki ortalama birim fiyatını hesaplar.
select distinct Ktgr.KategoriAd,
avg(SD.SiparisBirimFiyat) as OrtalamaSiparisBirimFiyati
from TabloKategori as Ktgr
    inner join TabloUrun as Urn on Ktgr.KategoriNo=Urn.KategoriNo
    inner join TabloSiparisDetay as SD on Urn.UrunID=SD.UrunID
where exists (
              select *
              from TabloSiparis as Sprs
                  inner join TabloFatura as Ftr on Sprs.SiparisID=Ftr.SiparisID
              where Sprs.SiparisID=SD.SiparisID
             )
group by Ktgr.KategoriAd
order by Ktgr.KategoriAd;

--4) Sadece depoyla aynı şehirde müşterisi olan depoları listeler ve o depolarda bulunan toplam stok miktarını hesaplar.
select distinct Dp.DepoID,Dp.DepoAd,Dp.DepoSehir,
sum(Stk.StokMiktar) as ToplamMevcutStok
from TabloStok as Stk
    right outer join TabloDepo as Dp on Stk.DepoID=Dp.DepoID
where exists (
              select * 
              from TabloMusteri as Mstr
              where Mstr.MusteriSehir=Dp.DepoSehir
             )
group by Dp.DepoID, Dp.DepoAd, Dp.DepoSehir
order by ToplamMevcutStok ASC , Dp.DepoAd;

--5) En az iki farklı ürün sipariş etmiş olan müşterileri bulur. Sonrasında bu müşterilerin verdikleri siparişlerin
--   ortalama toplam tutarını hesaplar.
select distinct Mstr.MusteriID,Mstr.MusteriAdSoyad,Mstr.MusteriSehir,
avg(Ftr.FaturaToplamTutar) as OrtalamaSiparisFaturaTutari
from TabloMusteri as Mstr
    left outer join TabloFatura as Ftr on Mstr.MusteriID=Ftr.MusteriID
where Mstr.MusteriID in (
                         select Spr.MusteriID
                         from TabloSiparis as Spr 
                         inner join TabloSiparisDetay as SD on Spr.SiparisID=SD.SiparisID
                         group by Spr.MusteriID
                         having count(distinct SD.UrunID)>=2
                        )
group by Mstr.MusteriID,Mstr.MusteriAdSoyad,Mstr.MusteriSehir
order by OrtalamaSiparisFaturaTutari DESC;

--6) Ortalama ödediği KDV oranı, genel KDV oranından daha yüksek olan müşterilerin ödediğien yüksek fatura tutarını bulur.
select distinct Mstr.MusteriID , Mstr.MusteriAdSoyad, Mstr.MusteriSehir,
max(Ftr.FaturaToplamTutar) as EnYuksekFaturaTutari
from TabloMusteri as Mstr
    left outer join TabloFatura as Ftr on Mstr.MusteriID=Ftr.MusteriID
where Mstr.MusteriID in (
                         select F.MusteriID
                         from TabloFatura as F
                         group by F.MusteriID
                         having avg(F.FaturaKDV)>(select avg(FR.FaturaKDV) from TabloFatura as FR)
                        )
group by Mstr.MusteriID, Mstr.MusteriAdSoyad, Mstr.MusteriSehir
order by EnYuksekFaturaTutari ASC;

--7) Depo doluluk oranı %45'ın üzerinde  olan ve bu depolarda stoğu bulunan ürünlerin adlarını listeler.
select Urn.UrunAd , Stk.StokGirisTarihi
from TabloUrun as Urn 
    inner join TabloStok as Stk on Urn.StokID=Stk.StokID
where exists (
              select *
              from TabloDepo as Dp
              where Dp.DepoID=Stk.DepoID and Dp.DepoDolulukOrani>0.45
             );

--8) En yüksek fiyattan sipariş edilen birim fiyata sahip olan ürünlerin adlarını ve kategorilerini listeler.
select Urn.UrunAd, Ktgr.KategoriAd
from TabloUrun as Urn
    inner join TabloKategori as Ktgr on Urn.KategoriNo=Ktgr.KategoriNo
where Urn.UrunID in (
                     select UrunID
                     from TabloSiparisDetay 
                     where SiparisBirimFiyat=(select max(SiparisBirimFiyat) from TabloSiparisDetay)
                    );
                         
--9) Üst giyim kategorisine ait olan ürünleri içeren siparişlerin ID'lerini getirir.
select distinct Sprs.SiparisID
from TabloSiparis as Sprs
where Sprs.SiparisID in (
                         select SD.SiparisID
                         from TabloSiparisDetay as SD
                             inner join TabloUrun as Urn on SD.UrunID=Urn.UrunID
                             inner join TabloKategori as Ktgr on Urn.KategoriNo=Ktgr.KategoriNo
                         where Ktgr.KategoriAd='Üst Giyim'
                        );

--10) Fatura tutarı , tüm müşterilerin ortalama fatura tutarından yüksek olan şehirleri bulur.
select M.MusteriSehir,
count(F.FaturaID) as FaturaSayisi,
avg(F.FaturaToplamTutar) as SehirOrtalamaFaturaTutar
from TabloMusteri as M
    inner join TabloFatura as F on M.MusteriID=F.MusteriID
where F.FaturaTarihi between'2023-09-10' and '2025-09-12'
group by M.MusteriSehir
having avg(FaturaToplamTutar)>(
                               select avg(FaturaToplamTutar) from TabloFatura
                              );

--11) Lisans sınıfı A olmayan tüm şoförlerden daha fazla taşıma gerçekleştirmiş şoförü bulur.
select S.EhliyetNo,S.SoforAdSoyad,
count(T.TasimaID) as ToplamTasimaSayisi
from TabloSofor as S 
    inner join TabloTasima as T on S.EhliyetNo=T.EhliyetNo
group by S.EhliyetNo,S.SoforAdSoyad
having count(T.TasimaID)> all(
                              select count(TasimaID)
                              from TabloTasima as Ts
                                  inner join TabloSofor as Sf on Ts.EhliyetNo=Sf.EhliyetNo
                              where Sf.LisansSinifi<>'A' and Ts.TasimaID is not null
                              group by Sf.EhliyetNo
                             );

