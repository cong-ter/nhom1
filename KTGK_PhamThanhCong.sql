--câu 1
create database QLKHO

use QLKHO

create table Ton (
MaVT varchar(50) primary key,
TenVT varchar(255),
SoLuongT int
);

create table Nhap (
SoHDN int primary key,
MaVT varchar(50),
SoLuongN int,
DonGiaN float,
NgayN date,
foreign key (MaVT) references Ton(MaVT)
);

create table Xuat (
SoHDX int primary key,
MaVT varchar(50),
SoLuongX int,
DonGiaX float,
NgayX date,
foreign key (MaVT) references Ton(MaVT)
);

insert into Ton (MaVT, TenVT, SoLuongT)
values ('VT001', 'Cát', 100),
('VT002', 'Đá', 200),
('VT003', 'Xi măng', 300);

insert into Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN)
values (1, 'VT001', 50, 10000, '2020-01-20'),
(2, 'VT002', 100, 20000, '2022-04-10'),
(3, 'VT003', 150, 30000, '2021-04-18');

insert into Xuat (SoHDX, MaVT, SoLuongX, DonGiaX, NgayX)
values (101, 'VT001', 10, 35000, '2023-04-17'),
(102, 'VT002', 50, 15000, '2022-08-16'),
(103, 'VT003', 20, 45000, '2021-07-18');

--Câu 2
create function ThongKeTienBan (@mavt varchar(50))
returns table
as
return
  select X.MaVT, T.TenVT, SUM(X.SoLuongX * X.DonGiaX) as TienBan
  from Xuat X
  INNER JOIN Ton T on X.MaVT = T.MaVT
  where X.MaVT = @mavt
  group by X.MaVT, T.TenVT, X.NgayX;

select * from ThongKeTienBan('VT001');
--Câu 3
create function ThongKeTienNhap (@mavt varchar(50), @ngaynhap date)
returns table
as
return
  select MaVT, SUM(SoLuongN * DonGiaN) as TienNhap
  from Nhap
  where MaVT = @mavt AND NgayN = @ngaynhap
  group by MaVT;

select * from ThongKeTienNhap('VT002', '2022-04-10');
--Câu 4
create trigger UpdateTonAfterInsertNhap
on Nhap
after insert
as
begin
  if EXISTS (select * from Ton where Ton.MaVT = (select MaVT from inserted))
  begin
    UPDATE Ton
    set SoLuongT = SoLuongT + (select SoLuongN from inserted where inserted.MaVT = Ton.MaVT)
    where Ton.MaVT = (select MaVT from inserted);
  end
  else
  begin
    raiserror('Mã VT chưa có mặt trong bảng Ton', 16, 1);
    rollback transaction;
  end
end

insert into Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN)
values (4, 'VT001', 30, 12000, '2023-04-21');

select * from Nhap;