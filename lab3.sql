
--- Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.
select TENDEAN,cast(SUM(THOIGIAN) as decimal (6,2)) as 'Tổng giờ' from DEAN
inner join CONGVIEC on CONGVIEC.MADA= DEAN.MADA
inner join PHANCONG on PHANCONG.MADA= CONGVIEC.MADA
group by TENDEAN

select TENDEAN,convert(  decimal(6,2),SUM(THOIGIAN) ) as 'Tổng giờ' from DEAN
inner join CONGVIEC on CONGVIEC.MADA= DEAN.MADA
inner join PHANCONG on PHANCONG.MADA= CONGVIEC.MADA
group by TENDEAN
--- Xuất định dạng “tổng số giờ làm việc” kiểu varchar
select TENDEAN,cast(SUM(THOIGIAN) as varchar(10) ) as 'Tổng giờ' from DEAN
inner join CONGVIEC on CONGVIEC.MADA= DEAN.MADA
inner join PHANCONG on PHANCONG.MADA= CONGVIEC.MADA
group by TENDEAN

 
select TENDEAN,convert(  varchar(10),SUM(THOIGIAN) ) as 'Tổng giờ' from DEAN
inner join CONGVIEC on CONGVIEC.MADA= DEAN.MADA
inner join PHANCONG on PHANCONG.MADA= CONGVIEC.MADA
group by TENDEAN

---o Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu phẩy để phân biệt phần nguyên và phần thập phân.
select TENPHG,cast(avg(LUONG)as decimal(10,2)) as 'Lương trung bình ' from PHONGBAN
inner join NHANVIEN on PHONGBAN.MAPHG=NHANVIEN.PHG
group by TENPHG
 
select TENPHG,convert( decimal(10,2),avg(LUONG)) as 'Lương trung bình ' from PHONGBAN
inner join NHANVIEN on PHONGBAN.MAPHG=NHANVIEN.PHG
group by TENPHG

 
---o Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3 chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace
select TENPHG,cast(avg(LUONG)as decimal(10,2)) as 'Lương trung bình ',
LEFT(cast(avg(LUONG)as decimal(10,2)) ,3)+
REPLACE(cast(avg(LUONG)as decimal(10,2)),LEFT(cast(avg(LUONG)as decimal(10,2)) ,3),',')
from PHONGBAN
inner join NHANVIEN on PHONGBAN.MAPHG=NHANVIEN.PHG
group by TENPHG

 

select TENPHG,convert( decimal(10,2),avg(LUONG)) as 'Lương trung bình ',
LEFT(convert( decimal(10,2),avg(LUONG)) ,3)+
REPLACE(convert( decimal(10,2),avg(LUONG)),LEFT(convert( decimal(10,2),avg(LUONG)) ,3),',')
from PHONGBAN
inner join NHANVIEN on PHONGBAN.MAPHG=NHANVIEN.PHG
group by TENPHG

---o Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
select TENDEAN, floor (sum(THOIGIAN))as 'Tổng thời gian' from DEAN
inner join CONGVIEC on DEAN.MADA=CONGVIEC.MADA
inner join PHANCONG on DEAN.MADA=PHANCONG.MADA
group by TENDEAN


---o Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
select TENDEAN, round (sum(THOIGIAN),2)as 'Tổng thời gian' from DEAN
inner join CONGVIEC on DEAN.MADA=CONGVIEC.MADA
inner join PHANCONG on DEAN.MADA=PHANCONG.MADA
group by TENDEAN


----Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương  trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
select  HONV+''+TENLOT+''+TENNV as 'họ và tên ',round (avg(LUONG),2) as 'lương trung bình ' from NHANVIEN
inner join PHONGBAN on NHANVIEN.PHG=PHONGBAN.MAPHG
where PHONGBAN.TENPHG= N'nghiên cứu '
group by HONV+''+TENLOT+''+TENNV 
--- Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân,  thỏa các yêu cầu
-- Dữ liệu cột HONV được viết in hoa toàn bộ
select upper( HONV)+''+TENLOT+''+TENNV as 'họ và tên ', DCHI,count (MA_NVIEN) as 'nhân thân ' from NHANVIEN
inner join THANNHAN on NHANVIEN.MANV= THANNHAN.MA_NVIEN
where MA_NQL>2
group by upper (HONV)+''+TENLOT+''+TENNV,DCHI

--- Dữ liệu cột TENLOT được viết chữ thường toàn bộ
select  HONV+' '+  upper (TENLOT)+' '+TENNV as 'họ và tên ', DCHI,count (MA_NVIEN) as 'nhân thân ' from NHANVIEN
inner join THANNHAN on NHANVIEN.MANV= THANNHAN.MA_NVIEN
where MA_NQL>2
group by HONV+' '+ upper (TENLOT)+' '+TENNV,DCHI
---o Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết thường( ví dụ: kHanh)

select nv.HONV + ' ' + nv.TENLOT + ' ' + 
left(nv.TENNV, 1) +
UPPER(right(left(nv.TENNV, 2), 1)) +
right(nv.TENNV, LEN(nv.TENNV) - 2)
as hoten, nv.DCHI, 
nv.TENNV,
count(nt.TENTN) as sonhanthan from NHANVIEN nv 
inner join THANNHAN nt on nv.MANV = nt.MA_NVIEN
group by nv.HONV, nv.TENLOT, nv.TENNV, nv.DCHI
having count(nt.TENTN) > 2

--- Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác như số nhà hay thành phố.

select nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV as hoten,  
SUBSTRING(nv.DCHI, PATINDEX('% %',nv.DCHI), PATINDEX('%,%',nv.DCHI) - PATINDEX('% %',nv.DCHI))
as tenduong, 
count(nt.TENTN) as sonhanthan from NHANVIEN nv 
inner join THANNHAN nt on nv.MANV = nt.MA_NVIEN
group by nv.HONV, nv.TENLOT, nv.TENNV, nv.DCHI
having count(nt.TENTN) > 2
