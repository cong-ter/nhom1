-- Câu 1
SELECT * FROM Sanpham;
SELECT * FROM Hangsx;
SELECT * FROM Nhanvien;
SELECT * FROM Nhap;
SELECT * FROM Xuat;

-- Câu 2
SELECT sp.masp, sp.tensp, hs.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota FROM Sanpham AS sp
INNER JOIN Hangsx AS hs
ON sp.mahangsx = hs.mahangsx
ORDER BY sp.giaban DESC;

-- Câu 3
SELECT sp.masp, sp.tensp, hs.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota FROM Sanpham AS sp
INNER JOIN Hangsx AS hs
ON sp.mahangsx = hs.mahangsx
WHERE hs.tenhang = 'samsung';

-- Câu 4
SELECT * FROM Nhanvien
WHERE gioitinh = N'N?' AND phong = N'K? toán';

-- Câu 5
SELECT n.sohdn, n.masp, sp.tensp, hs.tenhang, n.soluongN, n.dongiaN, n.soluongN*n.dongiaN AS tiennhap, sp.mausac, sp.donvitinh, n.ngaynhap, nv.tennv, nv.phong FROM Nhap AS n
INNER JOIN Sanpham AS sp
ON n.masp = sp.masp
INNER JOIN Hangsx AS hs
ON sp.mahangsx = hs.mahangsx
INNER JOIN Nhanvien AS nv
ON n.manv = nv.manv
ORDER BY n.sohdn ASC;


-- Câu 6
SELECT Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, Nhanvien.tennv, Nhanvien.phong FROM Xuat
JOIN Sanpham ON Xuat.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE MONTH(Xuat.ngayxuat) = 10 AND YEAR(Xuat.ngayxuat) = 2018
ORDER BY Xuat.sohdx ASC;

-- Câu 7
SELECT Nhap.sohdn, Sanpham.masp, Sanpham.tensp, Nhap.soluongN, Nhap.dongiaN, Nhap.ngaynhap, Nhanvien.tennv, Nhanvien.phong FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE YEAR(Nhap.ngaynhap) = 2017 AND Hangsx.tenhang = 'samsung';

-- Câu 8

SELECT TOP 10 Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, Nhanvien.tennv, Nhanvien.phong FROM Xuat
JOIN Sanpham ON Xuat.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE YEAR(Xuat.ngayxuat) = 

-- Câu 9

SELECT TOP 10 * FROM Sanpham
ORDER BY giaban DESC;

-- Câu 10

SELECT Sanpham.* FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND giaban BETWEEN 100000 AND 500000;


-- Câu 13

SELECT TOP 1 sohdn, ngaynhap FROM Nhap
WHERE YEAR(ngaynhap) = 2018
ORDER BY soluongN*dongiaN DESC;

-- Câu 14

SELECT TOP 10 masp, SUM(soluongN) as TongSoLuongN FROM Nhap
WHERE YEAR(ngaynhap) = 2019
GROUP BY masp
ORDER BY TongSoLuongN DESC;

-- Câu 15

SELECT Sanpham.masp, tensp FROM Sanpham 
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE Hangsx.tenhang = 'Samsung' AND Nhap.manv = 'NV01';

-- Câu 16

SELECT sohdn, Nhap.masp, soluongN, ngaynhap FROM Nhap
JOIN Xuat ON Nhap.sohdn = Xuat.sohdx
WHERE Nhap.masp = 'SP02' AND Xuat.manv = 'NV02';

-- Câu 17

SELECT manv, tennv FROM Nhanvien
JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Xuat.masp = 'SP02' AND Xuat.ngayxuat = '2020-02-03';


