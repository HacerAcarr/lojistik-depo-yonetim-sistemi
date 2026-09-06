--GÖREV 6 TRIGGER, FUNCTİON, STORED PROCEDURE
use Grup26
go

--Trigger

--1) Personel tablosundan silinen personeli otomatik olarak eski personel tablosuna aktarır.
--Önce eski personel tablosunu oluşturulur.
create table TabloEskiPersonel (
PersonelID int,
PersonelTC varchar(12),
PersonelAdSoyad nvarchar(100),
SilinmeTarihi date default getdate()--Personelin ne zaman silindiğini gösterir.
);
go
--Sonrasında personeli silince eski personel tablosuna geçmesini sağlayacak trigger yazılır.
create trigger Trg_PersonelSil on TabloPersonel
after delete--Silindikten sonra devreye girer.
as
begin
      insert into dbo.TabloEskiPersonel ( --Silinen kayıtları deleted tablosundan arşiv tablosuna ekler.
      PersonelID, PersonelTC,PersonelAdSoyad)
      select dlt.PersonelID,dlt.PersonelTC,dlt.PersonelAdSoyad
      from deleted as dlt;--Silinen kayıtları içeren sanal tablodur.
      print 'Personel kaydı silindi ve arşivlendi.';--Silme işlemi yapıldığına dair mesaj gönderir.
end;
go
--Çalışıp çalışmadığını kontrol etme:
select * from TabloPersonel where PersonelID=50;--Silmek istenen personel seçilir.
select * from TabloEskiPersonel;--Bu tablo ilk başta boştur.
delete from dbo.TabloPersonel where PersonelID=50;--Personeli siler.
select * from TabloPersonel where PersonelID=50;--Burada artık sonuç yoktur.
select * from TabloEskiPersonel;--Burda silinen personel ve bilgileri gözükür.
go


--2) Bir personelin maaşı yükseltildiğinde eğer eski maaş yeni maaştan düşükse bu işlemi engeller, değilse değişikliği güncelleme tablosuna kaydeder.
--Önce güncelleme tablosu oluşturulur.
create table Guncelleme ( 
GUNCELID int identity(1,1) primary key,
PersonelID int,
EskiMaas decimal(18,2),
YeniMaas decimal(18,2),
GuncellemeTarihi datetime default getdate()--Maaşın ne zaman güncellendiğini gösterir.
);
go
--Sonrasında personelin maaşı yükseltiğinde eğer eski maaşı düşükse işlemi engelleyen, değilse güncelleme tablosuna kaydedecek trigger yazılır.
create trigger Trg_MaasGuncelleme on TabloPersonel
after update --Güncellendikten sonra devreye girer.
as
begin
      if update(PersonelMaas)--Sadece maaş sütunu güncellendiyse çalışır.
      begin 
            declare @EskiMaas decimal(18,2);--Değişken tanımlanır.
            declare @YeniMaas decimal(18,2);
            select @EskiMaas=PersonelMaas from deleted;--Değeri değişkene atar.
            select @YeniMaas=PersonelMaas from inserted;
            if (@YeniMaas<@EskiMaas)--Yeni maaş eski maaştan düşükse ne olacağına karar verir.
            begin
                  print 'Personel eski maaşı yeni maaşından düşük olamaz.';--Mesaj gönderir.
                  rollback transaction;--İşlemi iptal eder.
            end
            else--Yeni maaş eski mmaştan düşük değilse ne olacağına karar verir.
            begin
                  insert into dbo.Guncelleme(PersonelID,EskiMaas,YeniMaas)
                  select PersonelID,@EskiMaas,@YeniMaas from inserted;
                  print 'Maaş güncellemesi başarılı ve arşivlendi.';--Güncelleme ve arşivleme işlemi yapıldığına dair mesaj gönderir.
            end
       end
end;
go
--Çalışıp çalışmadığını kontrol etme:
update dbo.TabloPersonel set PersonelMaas=20000.00 where PersonelID=51;--Nalan Demir adlı personelin maasını 20000TL' ye düşürür.Sonuç olarak'Personel eski maaşı yeni maaşından düşük olamaz.' olarak mesaj gönderir.
select PersonelMaas from TabloPersonel where PersonelID=51;--Maaşın değişmediği görülür.
update dbo.TabloPersonel set PersonelMaas=35000.00 where PersonelId=51;--Nalan Demir adlı personelin maasını 30000TL'ye yükseltir.Sonuç olarak 'Maaş güncellemesi başarılı ve arşivlendi.'olarak mesaj gönderir.
select * from Guncelleme;--Nalanın güncellenmis maası görülür.
go


--3) Şoförler tablosunda bir şoför silinmek istendiğinde taşıma bilgileri de gideceğinden şoförü silmez.Onun yerine şoförü pasif gösterir.
create trigger Trg_SoforuPasifYapma on TabloSofor 
instead of delete --Silme işlemi yerine aşağıdaki kısım çalışır.
as
begin 
      declare @SoforID int;
      declare @AdSoyad nvarchar(100);--Değişken tanımlanır.
      select @SoforID=EhliyetNo,@AdSoyad=SoforAdSoyad from deleted;--Değeri değişkene atar.
      update TabloSofor set MusaitlikDurumu='PASİF' where EhliyetNo=@SoforID; --Silmek yerine şoförün durumunu günceller.
      print @AdSoyad +' isimli şoför sistemden silinmedi.'
      print 'Durumu "PASİF" olarak güncellendi.';--Mesaj gönderir.
end;
go
--Çalışıp çalışmadığını kontrol etme:
delete from dbo.TabloSofor where EhliyetNo=321;--Ali Toprak isimli şoför siler ama sonuç olarak 'Ali Toprak isimli şoför sistemden silinmedi.' yazar.
select * from TabloSofor where EhliyetNo=321;--Ali Toprak sistemde durur ve sonuç olarak'Durumu "PASİF" olarak güncellendi.' yazar.
go

--4) Sistemden tablo silinmek ya da değiştirilmek istendiğinde uyarı mesajı yazar ve yapılan işlemi geri alır.
create trigger Trg_Koruma on database 
for drop_table,alter_table--Sadece silme ve değiştirme olaylarını içerir.
as
begin
      print 'Bu sistemden tablo silme ve değiştirme işlemi için yetkiniz yoktur.';--Mesaj gönderir.
      print 'Sistem yöneticisi ile iletişime geçin.';
      rollback transaction;--İşlemi iptal eder.
end;
go
--Çalışıp çalışmadığını kontrol etme:
drop table dbo.TabloFirmaArac;--Sistem hata verir ve 'Bu sistemden tablo silme ve değiştirme işlemi için yetkiniz yoktur.','Sistem yöneticisi ile iletişime geçin.' yazar.
alter table dbo.TabloPersonel add Test int;--Yine sistem hata verir ve 'Bu sistemden tablo silme ve değiştirme işlemi için yetkiniz yoktur.', 'Sistem yöneticisi ile iletişime geçin.' yazar.
go

--5) Depo doluluk oranı 100' den büyükse hata verir, değilse doluluk oranına göre durum belirtir.
create trigger  Trg_DepoDolulukOrani on TabloDepo
instead of insert --Kayıt yapılmadan önce araya girer.
as
begin
      declare @DID int,@DSehir nvarchar(50),@DAD nvarchar(100),@DOran decimal(3,2);--Değişken tanımlanır.
      declare @Durum nvarchar(50);
      select @DID=DepoID,@DSehir=DepoSehir,@DAD=DepoAd,@DOran=DepoDolulukOrani--Değeri değişkene atar.
      from inserted;
      if(@DOran>1.00)--Eğer depo doluluk oranı %100'ün üzerindeyse ona göre karar verir.
      begin
            print 'Depo doluluk oranı %100ün üzerinde olamaz.';--Mesaj gönderir.
      end
      else --Eğer depo doluluk oranı %100'ün üzerinde değilse ona göre karar verir.
      begin
            set @Durum=case --Durum belirler.
            when @DOran>=0.90 then 'Kritik doluluk'
            when @DOran>=0.50 then 'Orta seviye doluluk'
            else 'Uygun doluluk'
      end;
      insert into dbo.TabloDepo (DepoID,DepoSehir,DepoAd,DepoDolulukOrani)--İşlemi gerçeleştirir.
            values (@DID,@DSehir,@DAD,@DOran);
      print 'Depo kaydedildi.Durum: '+@Durum;--Mesaj gönderir.
      end
end;
go
--Çalışıp çalışmadığını kontrol etme:
insert into dbo.TabloDepo(DepoID,DepoSehir,DepoAd,DepoDolulukOrani)--Depo doluluk oranı %150 olan depo ekler ama sistem hata verir.
      values(4,'İstanbul','İstDepo',1.50);--Sonuç olarak 'Depo doluluk oranı %100ün üzerinde olamaz.' yazar.
insert into dbo.TabloDepo(DepoID,DepoSehir,DepoAd,DepoDolulukOrani)--Depo doluluk oranı %95 olan depo ekler.
      values(5,'Aydın','AydınlıkDepo',0.95);--Sonuç olarak eklenir ve 'Depo kaydedildi.Durum:Kritik doluluk' yazar.
go


--6) Yeni ürün tedarik edildiğinde tedarik edilen ürünlerin sayaç olarak rafa yerleştiğini belirtir.
create trigger Trg_UrunRafaYerlesme on TabloTedarik
after insert--Kayıt eklendikten sonra devreye girer.
as
begin
      declare @Miktar int;--Değişken tanımlanır.
      declare @Sayac int =1;--Sayaç başangıcı 1'dir.
      select @Miktar =TedarikMiktar from inserted;--Değeri değişkene atar.
      while (@Sayac<=@Miktar)--Sayacın sayısı miktara eşitleninceye kadar döngü döner.
      begin
            if(@Sayac %20=0)--Her 20 üründe bir sisteme bildirir.
            begin
                  print 'Tedarik Kontrolü: '+cast(@Sayac as varchar)+'. ürün rafa yerleştirildi.';--Mesaj gönderir.
            end
            set @Sayac=@Sayac+1;--Sayacı bir bir arttırır.
      end
      print 'Toplam '+cast(@Miktar as varchar)+' tane ürün rafa yerleştirildi.'--Mesaj gönderir.
end;
go
--Çalışıp çalışmadığını kontrol etme:
insert into dbo.TabloTedarik(TedarikNo,TedarikTarihi,TedarikMiktar,TedariciID,UrunID)--220 tane ürünü her 20'de bir mesaj yazarak sisteme kaydeder.
      values(48,'2025-09-11',220,423698520,2354);
go


--7) Tedarik edilen ürünün numarasını, miktarını ve işlemin başarıyla sisteme kaydedilmesini mesaj olarak yazdırır.
create trigger Trg_TedarikBilgi on TabloTedarik
after insert--Kayıt eklendikten sonra devreye girer.
as
begin
      declare @UrunID int;--Değişken tanımlanır.
      declare @Miktar int;
      select @UrunID=UrunID,@Miktar=TedarikMiktar from inserted;--Değeri değişkene atar.
      print 'YENİ TEDARİK KAYDI';--Mesaj gönderir.
      print 'ÜrünID: '+cast(@UrunID as varchar);
      print 'Gelen Miktar: '+cast(@Miktar as varchar);
      print 'İşlem başarıyla tamamlanmıştır.';
end;
go
--Çalışıp çalışmadığını kontrol etme:
insert into dbo.TabloTedarik(TedarikNo,TedarikTarihi,TedarikMiktar,TedariciID,UrunID)--Tedarik edilen ürün bilgilerini kaydeder ve ekrana bu bilgiler yazılır.
      values(49,'2023-04-25',248,423698520,2354);
go


--Function

--1) Alınan tedarikçi ID'sine göre o tedarikçiden gelen ürünlerin adını ve miktarını bir tablo olarak döndürür.
create function dbo.TedarikciUrunleri
(@TedarikciID varchar(20))
returns table
as
return (--Select sorgusunun sonucunu döndürür.
         select U.UrunAd,T.TedarikMiktar,T.TedarikTarihi
         from TabloTedarik as T
             inner join TabloUrun as U on T.UrunID=U.UrunID
         where T.TedariciID=@TedarikciID
       );
go;
--Çalışıp çalışmadığını kontrol etme:
select * from dbo.TedarikciUrunleri(423698520);--Bursa tedarikten gelen ürünleri gösterir.
go

--2) Bir şoförün lisans sınıfına göre hangi araç tiplerini kullanabşleceğini döndürür.
create function dbo_SoforLisans
(@EhliyetSinifi nvarchar(10))
returns nvarchar(100)
as
begin
      declare @YetkiMesaji nvarchar(100);--Değişken tanımlar.
      if(@EhliyetSinifi='A')
        set @YetkiMesaji='Belirli bir motor hacmi ile sınırlı olan motosikletleri yasal olarak kullanabilirler.';--Mesaj gönderir.
      else if(@EhliyetSinifi='B')
        set @YetkiMesaji='Otomobil, minibüs, kamyonet ya da küçük kamyon gibi motorlu taşıtları yasal olarak kullanabilirler.';--Mesaj gönderir.
      else 
        set @YetkiMesaji='Tanımsız ehliyet sınıfı';
      return @YetkiMesaji;--Sonucu döndürür.
end;
go
--Çalışıp çalışmadığını kontrol etme:
select SoforAdSoyad,LisansSinifi,dbo.dbo_SoforLisans(LisansSinifi) as AracKullanmaYetkisi
from TabloSofor;--Şoförlerin ne tür yetkisi olduğunu gösterir.
go
     
--3) Tüm depoların depo doluluk oranlarını toplayıp toplam depo sayısına bölerek depoların ortalama doluluk oranını hesaplar.
create function dbo.DepolarınOrtalamaDoluluk()
returns decimal(3,2)--Geriye 0.00 ile 1.00 arasında bir oran döner.
as
begin
      declare @ToplamOran decimal(18,2);--Değişken tanımlanır.
      declare @DepoSayisi int;
      declare @Ortalama decimal(3,2);
      select @ToplamOran=sum(DepoDolulukOrani) from TabloDepo;--Değeri değişkene atar.
      select @DepoSayisi=count(DepoID) from TabloDepo;
      if(@DepoSayisi>0)--Depo varsa bölme işlemini yapar.
       begin
             set @Ortalama=@ToplamOran/@DepoSayisi;--Ortalama hesaplar.
       end
       else
       begin
             set @Ortalama=0; 
       end
       return @Ortalama;--Sonucu döndürür.
end;
go
--Çalışıp çalışmadığını kontrol etme:
select dbo.DepolarınOrtalamaDoluluk() as GenelDolulukOrani;--Depoların ortalama doluluk oranını gösterir.
go

--4) Müşterilerin doğum tarihine göre yaşlarını hesaplar.
create function dbo.MusteriYasHesapla
(@MusteriID int)
returns int
as
begin
      declare @DogumGunu date;--Değişken tanımlanır.
      declare @Yas int;
      select @DogumGunu=MusteriDogumGunu from TabloMusteri where MusteriID=@MusteriID;--Değeri değişkene atar.
      set @Yas =Datediff(year,@DogumGunu,getdate());
      return @Yas;--Sonucu döndürür.
end;
go
--Çalışıp çalışmadığını kontrol etme:
select dbo.MusteriYasHesapla(1) as [Müşterinin yaşı: ];--ID'si 1 olan müşterinin yaşını gösterir.
select MusteriID,MusteriAdSoyad,MusteriDogumGunu,dbo.MusteriYasHesapla(MusteriID) as [Hesaplanan Yaş] 
from TabloMusteri;--Tüm müşterilerin yaşını gösterir.
go

--5) Şoförün müsaitlik durumundan göreve hazır olup olmadığını bildirir.
create function dbo.SoforMusait
(@EhliyetNo int)
returns nvarchar(50)
as 
begin
      declare @Durum nvarchar(50);--Değişken tanımlanır.
      declare @Musaitlik nvarchar(50);
      select @Musaitlik=MusaitlikDurumu from TabloSofor where EhliyetNo=@EhliyetNo;--Değeri değişkene atar.
      if(@Musaitlik='Müsait')--Müsaitlik durumuna göre göreve hazır olup olmadığını belirler.
        set @Durum='Şoför göreve hazır.';--Mesaj gönderir.
      else 
        set @Durum='Şoför şuan başka bir görevde.';--Mesaj gönderir.
      return @Durum;--Sonucu döndürür.
end;
go
--Çalışıp çalışmadığını kontrol etme:
select SoforAdSoyad,MusaitlikDurumu as [Durum:],dbo.SoforMusait(EhliyetNo) as [Görev Durumu:]--Şoförlerin göreve hazır olup olmadığını gösterir.
from TabloSofor;
go

--6) DepoID girildiğinde o depodaki tüm ürünlerin adını ve miktarını tablo olarak döndürür.
create function dbo.UrunBilgisi
(@DepoID int)
returns table
as
return ( --Select sorgusunun sonucunu döndürür.
         select Dp.DepoAd,Urn.UrunAd,St.StokMiktar
         from TabloDepo as Dp
             inner join TabloStok as St on Dp.DepoID=St.DepoID
             inner join TabloUrun as Urn on St.StokID=Urn.StokID
         where Dp.DepoID=@DepoID
        );
go
--Çalışıp çalışmadığını kontrol etme:
select * from dbo.UrunBilgisi(2);--2 numaralı depodaki ürün adlarını ve miktarlarını gösterir.
go

--7) Deponun doluluk oranına göre deponun durumunu belirler.
create function dbo.DurumDepo
(@Doluluk decimal(3,2))
returns nvarchar(50)
as
begin
      declare @Durum nvarchar(50);--Değişken tanımlanır.
      set @Durum=case--Case yapısı ile doluluk oranına göre durumunu belirler.
         when @Doluluk>=0.90 then 'Kritik doluluk'--Mesaj gönderir.
         when @Doluluk>=0.50 then 'Orta seviye doluluk'--Mesaj gönderir.
         when @Doluluk>=0.00 then 'Uygun seviyede doluluk'--Mesaj gönderir.
         else 'Hatalı doluluk oranı'--Mesaj gönderir.
      end;
      return @Durum ;--Sonucu döndürür.
end;
go
--Çalışıp çalışmadığını kontrol etme:
select DepoID,DepoAd,DepoDolulukOrani,dbo.DurumDepo(DepoDolulukOrani) as DepoDurum--Deponun durumunu gösterir.
from TabloDepo;
go

--Stored Procedure

--1) Alınan personelID ye göre personelin maaşını kontrol edecek ve eğer maaşı belli bir tutarın altındaysa ona prim ekleyecek.
create procedure PersonelePrim
@DID int --Girdi parametresi
as
begin 
      declare @MevcutMaas decimal(18,2);--Değişken tanımlanır.
      declare @PrimMiktarı decimal(18,2);
      select @MevcutMaas=PersonelMaas from TabloPersonel where PersonelID=@DID;--Değeri değişkene atar.
      if(@MevcutMaas<28000.00)--Eğer maaş 28000'den küçükse 2000TL, değilse 1000TL prim ver.
        set @PrimMiktarı=2000.00;
      else
        set @PrimMiktarı=1000.00;
      update TabloPersonel set PersonelMaas=PersonelMaas+@PrimMiktarı where PersonelID=@DID;--Maaşı günceller.
      print 'İşlem başarıyla gerçekleşti:Personele '+cast(@PrimMiktarı as varchar)+' TL prim ekllendi.';--Mesaj gönderir.
end;
go
--Çalışıp çalışmadığını kontrol etme:
exec PersonelePrim @DID=52;--Prosedürü çalıştırır.
select PersonelID,PersonelAdSoyad,PersonelMaas--Personel 52'nin primli maaşını gösterir.
from TabloPersonel where PersonelID=52;
go

--2) İstenen kadar personeli maaş sırasına göre listeler.
create procedure SiralaPesonel
@KisiSayisi int--Kaç kişi çekileceği parametre olarak alınır.
as
begin
      create table GeciciPersonel (--Geçici tabloyu oluşturur.
      AdSoyad nvarchar(100),
      Maas decimal(18,2)
      );
      declare @Sorgu varchar(500);--Değişken tanımlanır.
      --Sorguyu metin olarak birleştirelim.
      set @Sorgu = 'insert into dbo.GeciciPersonel 
                    select top'+STR(@KisiSayisi)+' PersonelAdSoyad,PersonelMaas
                    from TabloPersonel
                    order by PersonelMaas DESC';
      exec(@Sorgu);--Sorguyu çalıştırır.
      select * from GeciciPersonel;--Sonucu geçici tablodad gösterir.
end;
go
--Çalışıp çalışmadığını kontrol etme:
exec SiralaPesonel @KisiSayisi=3;--En yüksek maaşlı ilk 3 personeli gösterir.
go

--3) Alınan depoID'ye göre o depoya ait mevcut doluluk oranını ve içerisindeki ürün miktarını verir.
create procedure DepoBilgi
@DEPO int
as
begin
      declare @DolulukOrani decimal(3,2);--Değişken tanımlanır.
      declare @ToplamStok int;
      select @DolulukOrani =DepoDolulukOrani from TabloDepo where DepoID=@DEPO --Değeri değişkene atar.
      select @ToplamStok =sum(StokMiktar) from TabloStok where DepoID=@DEPO
      select DepoID,DepoAd,DepoDolulukOrani as [Mevcut Doluluk],@ToplamStok as [Toplam Ürün Adedi]
      from TabloDepo where DepoID=@DEPO 
end;
go
--Çalışıp çalışmadığını kontrol etme:
exec DepoBilgi @DEPO=1;--Prosedürü çalıştırır.
go

--4) Tüm şoförleri döner ve şoför müsait ise ona göre ataması yapar.
create procedure SoforGorevAta
as
begin
      declare @AdSoyad nvarchar(100);--Değişken tanımlanır.
      declare @Durum nvarchar(50);
      declare @EhliyetNo int;
      declare SoforCursor cursor for --Şoför tablosundaki bilgileri çeker.
      select EhliyetNo,SoforAdSoyad,MusaitlikDurumu from TabloSofor;
      open SoforCursor;--cursoru açar.
      fetch next from SoforCursor into @EhliyetNo,@AdSoyad,@Durum;--İlk kaydı çeker.
      while @@FETCH_STATUS=0--Başarılı olduğu sürece döner.
      begin
            if(@Durum='Müsait')--Müsaitliğine göre görev atar.
            begin
                 print 'Sayın '+@AdSoyad+' (Ehliyet No: '+cast(@EhliyetNo as varchar)+') YENİ SEVKİYAT İÇİN BEKLENİYORSUNUZ.';--Mesaj gönderir.
            end
            else
            begin
                 print @AdSoyad+' ŞU ANDA GÖREVDEDİR.';--Mesaj gönderir.
            end
            fetch next from SoforCursor into @EhliyetNo,@AdSoyad,@Durum;--Bir sonraki kayda gider.
      end
      close SoforCursor;--Cursoru kapar.
      deallocate SoforCursor;--cursor nesnesini tamamen siler.
end;
go
--Çalışıp çalışmadığını kontrol etme:
exec SoforGorevAta;--Prosedürü çalıştırır.
go

--5) Müşterinin fatura tutarı belli bir limit üzerindeyse müşteriye indirim tanımlar.
create procedure Indirim
as
begin
      declare @FaturaID int;
      declare @MusteriID int;
      declare @ToplamTutar decimal(18,2);
      declare @Mesaj nvarchar(100);
      declare faturacursor cursor for
      select FaturaID,MusteriID,FaturaToplamTutar from TabloFatura;
      open faturacursor;--cursoru açar.
      fetch next from faturacursor into @FaturaID,@MusteriID,@ToplamTutar;--İlk kaydı çeker.
      while @@FETCH_STATUS=0--Başarılı olduğu sürece döner.
      begin
            if(@ToplamTutar>4000.00)
            begin 
                 set @Mesaj='Fatura No: '+cast(@FaturaID as varchar)+
                            ' - Müşteri '+cast(@MusteriID as varchar)+
                            ':İndirim uygulandı.';
            end
            else
            begin
                 set @Mesaj='Fatura No: '+cast(@FaturaID as varchar)+
                            ' - Müşteri '+cast(@MusteriID as varchar)+
                            ':İndirim uygulanamadı.'
            end
            print @Mesaj;--Mesaj gönderir.
            fetch next from faturacursor into @FaturaID,@MusteriID,@ToplamTutar;--Bir sonraki kayda gider.
      end
      close faturacursor;--Cursoru kapar.
      deallocate faturacursor;--cursor nesnesini tamamen siler.
end;
go
--Çalışıp çalışmadığını kontrol etme:
exec Indirim;--Prosedürü çalıştırır.
