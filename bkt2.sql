create table vattu(
mavt nvarchar(20) primary key,
tenvt varchar(20),
dvtinh nvarchar(20),
slcon int
)

create table hdban(
mahd nvarchar(20) primary key,
ngayxuat date,
hotenkh nvarchar(20)
)

create table hangxuat(
mahd nvarchar(20),
mavt nvarchar(20),
dongia int,
slban int
foreign key (mahd) references hdban(mahd),
foreign key (mavt) references vattu(mavt)
)

insert into vattu(mavt,tenvt,dvtinh,slcon)
values ('abc','abc','lon',200),
 ('bcd','bcd','lon',200)

 insert into hdban(mahd ,ngayxuat,hotenkh)
values ('01','2000/12/10','nhat bon'),
 ('02','2005/05/20','cong anh')

 insert into hangxuat(mahd,mavt,dongia,slban)
values ('01','abc',10000,2000),
 ('02','bcd',20000,1000)
 --2
 select top 1 (slban* dongia) as 'tong tien ', mahd 
 from  hangxuat
 order by [tong tien]
 go
--3
CREATE FUNCTION f_ngaythu (@mahd varchar(10))
RETURNS TABLE
AS
RETURN
    SELECT hx.mahd,hd.ngayxuat,hd.mahd,hx.dongia,hx.slban, 
        CASE
            WHEN WEEKDAY(hd.ngayxuat) = 0 THEN N'Th? hai'           
            WHEN WEEKDAY(hd.ngayxuat) = 1 THEN N'Th? ba'
            WHEN WEEKDAY(hd.ngayxuat) = 2 THEN N'Th? t?'
            WHEN WEEKDAY(hd.ngayxuat) = 3 THEN N'Th? n?m'
            WHEN WEEKDAY(hd.ngayxuat) = 4 THEN N'Th? sáu'
            WHEN WEEKDAY(hd.ngayxuat) = 5 THEN N'Th? b?y'
            ELSE N'Ch? nh?t'
        END AS NgayThu
		FROM hangxuat hx
    INNER JOIN hdban hd ON hx.mahd = hd.mahd
    WHERE hx.mahd = @mahd;
	--cau 4--
create proc p4 
@thang int, @nam int 
as
select
sum(slban * dongia)
from hangxuat hx
inner join hdban hd on hx.mahd = hd.mahd
where month(hd.ngayxuat) = @thang and year(hd.ngayxuat) = @nam;