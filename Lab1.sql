---1.	Tìm các nhân viên làm việc ở phòng số 4--
select * from NHANVIEN
where PHG=4
---2.	Tìm các nhân viên có mức lương trên 30000
select * from NHANVIEN
where LUONG > 30000
---3.	Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân
-- có mức lương trên 30,000 ở phòng 5
select * from NHANVIEN
where (LUONG>25000 and PHG=4) or (LUONG>30000 and PHG=5)
----4.	Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
select HONV+' '+ TENLOT+' '+TENNV+' ' as 'họ và tên ' from NHANVIEN
where DCHI like '%hcm%'
---5.	Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự
---'N’
select HONV+' '+ TENLOT+' '+TENNV+' ' as 'họ và tên ' from NHANVIEN
where TENNV like 'n%'
---6.	Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien.
select NGSINH, DCHI from NHANVIEN where TENNV like '%%tiên'
