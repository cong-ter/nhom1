-- Câu 1
create view v_Sanpham
as
SELECT * FROM Sanpham;
go
create view v_Hangsx
as
SELECT * FROM Hangsx;
go
create view v_Nhanvien
as
SELECT * FROM Nhanvien;
go
create view v_Nhap
as
SELECT * FROM Nhap;
go
create view v_Xuat
as
SELECT * FROM Xuat;
go

-- Câu 2
create view v_Lap2_2
as
SELECT sp.masp, sp.tensp, hs.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota FROM Sanpham AS sp
INNER JOIN Hangsx AS hs
ON sp.mahangsx = hs.mahangsx

-- Câu 3
create view v_Lap2_3
as
SELECT sp.masp, sp.tensp, hs.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota FROM Sanpham AS sp
INNER JOIN Hangsx AS hs
ON sp.mahangsx = hs.mahangsx
WHERE hs.tenhang = 'samsung';

-- Câu 4
create view v_Lap2_4
as
SELECT * FROM Nhanvien
WHERE gioitinh = N'N?' AND phong = N'K? toán';

-- Câu 5
create view v_Lap2_5
as
SELECT n.sohdn, n.masp, sp.tensp, hs.tenhang, n.soluongN, n.dongiaN, n.soluongN*n.dongiaN
AS tiennhap, sp.mausac, sp.donvitinh, n.ngaynhap, nv.tennv, nv.phong FROM Nhap AS n
INNER JOIN Sanpham AS sp
ON n.masp = sp.masp
INNER JOIN Hangsx AS hs
ON sp.mahangsx = hs.mahangsx
INNER JOIN Nhanvien AS nv
ON n.manv = nv.manv


-- Câu 6
create view v_Lap2_6
as
SELECT Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, Xuat.soluongX*Sanpham.giaban
AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, Nhanvien.tennv, Nhanvien.phong FROM Xuat
JOIN Sanpham ON Xuat.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE MONTH(Xuat.ngayxuat) = 10 AND YEAR(Xuat.ngayxuat) = 2018

-- Câu 7
create view v_Lap2_7
as
SELECT Nhap.sohdn, Sanpham.masp, Sanpham.tensp, Nhap.soluongN, Nhap.dongiaN, Nhap.ngaynhap, Nhanvien.tennv, Nhanvien.phong FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE YEAR(Nhap.ngaynhap) = 2017 AND Hangsx.tenhang = 'samsung';

-- Câu 8
create view v_Lap2_8
as
SELECT TOP 10 Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, Nhanvien.tennv, Nhanvien.phong 
FROM Xuat
JOIN Sanpham ON Xuat.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE Xuat.sohdx IN (
    SELECT TOP 10 Xuat.sohdx
    FROM Xuat
    WHERE YEAR(Xuat.ngayxuat) = 2018
    GROUP BY Xuat.sohdx
    ORDER BY SUM(Xuat.soluongX) DESC
)
ORDER BY Xuat.sohdx, Sanpham.masp;

-- Câu 9
create view v_Lap2_9
as
SELECT TOP 10 * FROM Sanpham
ORDER BY giaban DESC;

-- Câu 10
create view v_Lap2_10
as
SELECT Sanpham.* FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND giaban BETWEEN 100000 AND 500000;


-- Câu 13
create view v_Lap2_13
as
SELECT TOP 1 sohdn, ngaynhap FROM Nhap
WHERE YEAR(ngaynhap) = 2018
ORDER BY soluongN*dongiaN DESC;

-- Câu 14
create view v_Lap2_14
as
SELECT TOP 10 masp, SUM(soluongN) as TongSoLuongN FROM Nhap
WHERE YEAR(ngaynhap) = 2019
GROUP BY masp
ORDER BY TongSoLuongN DESC;

-- Câu 15
create view v_Lap2_15
as
SELECT Sanpham.masp, tensp FROM Sanpham 
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE Hangsx.tenhang = 'Samsung' AND Nhap.manv = 'NV01';

-- Câu 16
create view v_Lap2_16
as
SELECT sohdn, Nhap.masp, soluongN, ngaynhap FROM Nhap
JOIN Xuat ON Nhap.sohdn = Xuat.sohdx
WHERE Nhap.masp = 'SP02' AND Xuat.manv = 'NV02';

-- Câu 17
create view v_Lap2_17
as
SELECT manv, tennv FROM Nhanvien
JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Xuat.masp = 'SP02' AND Xuat.ngayxuat = '2020-02-03';

