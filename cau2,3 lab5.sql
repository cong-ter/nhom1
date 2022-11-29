---câu 2:
---Nh?p vào @Manv, xu?t thông tin các nhân viên theo @Manv.---
create procedure sp_thongtin
@manv varchar (10)
as 
begin 
	select * from NHANVIEN
	where MANV=@manv
end
exec sp_thongtin @manv='003'

-----Nh?p vào @MaDa (mã ?? án), cho bi?t s? l??ng nhân viên tham gia ?? án ?ó
 create procedure sp_soluong 
 @mada varchar(10)
 as 
 begin
  select count(MANV),TENPHG,MADA from NHANVIEN
  inner join PHONGBAN on NHANVIEN.PHG=PHONGBAN.MAPHG
   inner join DEAN on PHONGBAN.MAPHG=DEAN.PHONG
   where MADA=@mada
   group by TENPHG,MADA
   
 end
 exec sp_soluong @mada=1
--b2. Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
create proc sp_ThongkenvDEAN
	@MADA INT,@DDIEM_DA NVARCHAR(15)
AS
BEGIN
		SELECT COUNT(B.MA_NVIEN) AS 'Số Lượng'
		FROM DEAN A INNER JOIN PHANCONG B ON A.MADA=B.MADA
		WHERE A.MADA = @MADA AND A.DDIEM_DA=@DDIEM_DA;
END;
EXEC sp_ThongkenvDEAN 1, N'Vũng Tàu';

select * from DEAN;

--b2. Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là @Trphg và các nhân viên này không có thân nhân.
create proc sp_TimnvtheoTRP
	@TRPHG NVARCHAR(9)
AS
BEGIN
	SELECT B.* FROM PHONGBAN A INNER JOIN NHANVIEN B ON A.MAPHG =B.PHG
		WHERE A.TRPHG=@TRPHG AND
			NOT EXISTS( SELECT * FROM THANNHAN WHERE MANV =B.MANV)
END;
EXEC sp_TimnvtheoTRP '005' ;

SELECT * FROM PHONGBAN

--b2. Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có mã @Mapb hay không
create proc sp_KTNVTHUOCPHONG
	@MANV NVARCHAR(9), @MAPB INT
AS
BEGIN
	DECLARE @DEM INT;
	SELECT @DEM = COUNT(MANV) FROM NHANVIEN WHERE MANV =@MANV AND PHG = @MAPB

	RETURN @DEM ;
END;

DECLARE @RESULT INT;
EXEC  @RESULT = sp_KTNVTHUOCPHONG '005',5 ;
SELECT @RESULT;

SELECT * FROM NHANVIEN
---cau 3
--b3. Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
create proc sp_THEMPBMOI
	@TENPHG nvarchar (15) ,
	@MAPHG int ,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
AS
BEGIN
	IF EXISTS (SELECT * FROM PHONGBAN WHERE MAPHG = @MAPHG)
	BEGIN
		PRINT N'Mã phòng ban đã tồn tại';
		return;
	END
	INSERT INTO [dbo].[PHONGBAN]
           ([TENPHG]
           ,[MAPHG]
           ,[TRPHG]
           ,[NG_NHANCHUC])
     VALUES
           (@TENPHG,@MAPHG,@TRPHG,@NG_NHANCHUC);
END;
EXEC sp_THEMPBMOI N'Công Nghệ Thông Tin', 10,'005','12-12-2020' ;
select * FROM PHONGBAN;

--b3. Cập nhật phòng ban có tên CNTT thành phòng IT.
create proc sp_CapNhatPhongBan
	@OldTENPHG nvarchar (15),
	@TENPHG nvarchar (15),
	@MAPHG int ,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
AS
BEGIN
	UPDATE [dbo].[PHONGBAN]
    SET [TENPHG] = @TENPHG
      ,[MAPHG] = @MAPHG
      ,[TRPHG] = @TRPHG
      ,[NG_NHANCHUC] = @NG_NHANCHUC
    WHERE TENPHG = @OldTENPHG ;
END;
EXEC sp_CapNhatPhongBan N'Công Nghệ Thông Tin', 'IT',10,'005','12-12-2020' ;
select * FROM PHONGBAN;

--b3. Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu vào với điều kiện:
-- nhân viên này trực thuộc phòng IT
--Nhận @luong làm tham số đầu vào cho cột Luong, nếu @luong<25000 thì nhân viên này do nhân viên có mã 009 quản lý, ngươc lại do nhân viên có mã 005 quản lý
--Nếu là nhân viên nam thi nhân viên phải nằm trong độ tuổi 18-65, nếu là nhân viên nữ thì độ tuổi phải từ 18-60.
CREATE proc sp_ThemNV
	@HONV nvarchar (15) ,
	@TENLOT nvarchar(15) ,
	@TENNV nvarchar(15) ,
	@MANV nvarchar(9) ,
	@NGSINH date ,
	@DCHI nvarchar(30) ,
	@PHAI nvarchar(3) ,
	@LUONG float ,
	@PHG int 
as
begin
	if exists (select * from PHONGBAN WHERE TENPHG ='IT')
	BEGIN
		PRINT N'Phòng phải là phòng IT';
		RETURN;
	END;
	DECLARE @MA_NQL NVARCHAR (9);
	IF @LUONG >25000
		SET @MA_NQL ='005';
	ELSE
		SET @MA_NQL ='009';

	DECLARE @AGE INT;
	SELECT @AGE = DATEDIFF(YEAR,@NGSINH,GETDATE())+1;

	IF @PHAI = 'Nam' and (@AGE <18 AND @AGE >60)
	BEGIN
		PRINT N'Nam phải có độ tuổi từ 18-65';
		return;
	END
	else if @PHAI = N'Nữ' and (@AGE <18 AND @AGE >60)
	 BEGIN
		PRINT N'Nữ phải có độ tuổi từ 18-60';
		return;
	 END

	INSERT INTO NHANVIEN
           (HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
     VALUES
           (@HONV,@TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,@MA_NQL,@PHG)
end;
EXEC sp_ThemNV N'Nguyễn', N'Quang', N'Minh','030','1-12-1977',N'Đà Nẵng','Nam',30000,10;
selecT * from NHANVIEN


---câu 3:
create proc Thamphongban 
@maphg int ,@tenphg nvarchar (20), @trphg nvarchar (10),@tg_nhanchuc date 
as 
begin 
	print ('Mã phòng ban t?n t?i ');
	return;

end
