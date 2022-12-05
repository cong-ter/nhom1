--cau 1a:
create function FN_Tuoi(@MaNV nvarchar(9))
	returns int
as
begin 
	return(
		select DATEDIFF(year, NGSINH , GETDATE())+ 1 from NHANVIEN where MANV =@MaNV);
end;


--cau 1b:
create function FN_TongDeAn(@MaNV nvarchar(9)
	return int
as
begin
	return (select count(mada) from PHANCONG where MA_NVIEN=@MaNV);
end;


--cau 1c:
create function FN_ThongKePhai(@Phai nvarchar(3))
	returns int
as
begin
	return(select count(manv) from NHANVIEN where PHAI =@Phai;
end


--cau 1d
create function FN_TTDA
	(@MaPhg int)
	return @List table (TenPhong nvarchar(15),TenTruongPhong nvarchar(30),SoLuongDeAn int)
as 
begin
	insert into @List 
		select a.TENPHG,b.HONV+' '+b.TENLOT+' '+b.TENNV,
			(select count(c.MADA) from DEAN c where c.PHONG =a.MAPHG)
			from PHONGBAN a inner join NHANVIEN b on a.TRPHG = b.MANV
	return;
end;


--cau 1e:
create function fn_SoLuongDeAnTheoPB (@MaPB int)
returns @tbListPB table (TenPB nvarchar(20),MaTP nvarchar (10), TenTP nvarchar(50), soLuong int)

as
begin
	insert into @tbListPB
	select TENPHG, TRPHG, HONV+' '+TENLOT+' '+TENNV as 'Ten Truong Phong',COUNT(MADA)as 'SoLuongDeAn'
		from PHONGBAN
		inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
		inner join NHANVIEN on NHANVIEN.MANV = PHONGBAN.TRPHG
		where PHONGBAN.MAPHG = @MaPB
		group by TENPHG, TRPHG, TENNV, HONV, TENLOT
	return
end


--cau 2a:
SELECT TOP (1000) [HONV]
		,[TENNV]
		,[TENPHG]
		,[DIADIEM]
	FROM [QLDA].[dbo].[ThongTinNVPhong]


--cau 2b:
SELECT TOP (1000) [TENNV]
		,[LUONG]
		,[Tuoi]
	FROM [QLDA].[dbo].[NhanVienLuongTuoi]


--cau 2c:
CREATE VIEW PhongBanDongNhat
as
	select a.TENPHG,
	b.HONV+' '+b.TENLOT+' '+b.TENNV as 'TenTruongPhong'
	from PHONGBAN a inner join NHANVIEN b on a.TRPHG = b.MANV
	where a.MAPHG in (
		select PHG from NHANVIEN
		group by phg
		having count (manv)=
			(select top 1 count (manv) as NVCount from NHANVIEN
				group by phg
				order by NVCount desc)
				)