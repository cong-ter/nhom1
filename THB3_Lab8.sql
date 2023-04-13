--Cau 1
CREATE PROCEDURE sp_ThemMoiNhanVien
    @manv INT,
    @tennv NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @diachi NVARCHAR(100),
    @sodt VARCHAR(20),
    @email VARCHAR(50),
    @phong NVARCHAR(50),
    @Flag INT
AS
BEGIN
    SET NOCOUNT ON;
    

    IF @gioitinh NOT IN ('Nam', 'Nữ')
    BEGIN
        RETURN 1;
    END
    

    IF @Flag = 0 
    BEGIN
        INSERT INTO Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong)
        VALUES(@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong);
    END
    ELSE
    BEGIN
        UPDATE Nhanvien
        SET tennv = @tennv,
            gioitinh = @gioitinh,
            diachi = @diachi,
            sodt = @sodt,
            email = @email,
            phong = @phong
        WHERE manv = @manv;
    END
    
    RETURN 0;
END
--Cau 2
CREATE PROCEDURE ThemMoiSanPham @masp int, @tenhang varchar(50), @tensp varchar(50), @soluong int, @mausac varchar(20), @giaban float, @donvitinh varchar(20), @mota varchar(100), @Flag int
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS(SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        SELECT 1 AS 'MaLoi', 'Không tìm thấy tên hãng sản xuất' AS 'MoTaLoi'
        RETURN
    END


    IF @soluong < 0
    BEGIN
        SELECT 2 AS 'MaLoi', 'Số lượng sản phẩm phải lớn hơn hoặc bằng 0' AS 'MoTaLoi'
        RETURN
    END

  
    IF @Flag = 0
    BEGIN
        INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)

        SELECT 0 AS 'MaLoi', 'Thêm mới sản phẩm thành công' AS 'MoTaLoi'
    END
    ELSE 
    BEGIN
        UPDATE Sanpham
        SET mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), 
            tensp = @tensp, 
            soluong = @soluong, 
            mausac = @mausac, 
            giaban = @giaban, 
            donvitinh = @donvitinh, 
            mota = @mota
        WHERE masp = @masp

        SELECT 0 AS 'MaLoi', 'Cập nhật sản phẩm thành công' AS 'MoTaLoi'
    END
END
--Cau 3
CREATE PROCEDURE XoaNhanVien 
    @manv int
AS
BEGIN

    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        RETURN 1; 
    END
    BEGIN TRANSACTION; 
    DELETE FROM Nhap WHERE manv = @manv;
    DELETE FROM Xuat WHERE manv = @manv;
    DELETE FROM nhanvien WHERE manv = @manv;
    COMMIT TRANSACTION; 
    RETURN 0; 
END
--Cau 4
CREATE PROCEDURE XoaSanPham
    @masp varchar(10),
    @errorCode int OUTPUT
AS
BEGIN
  
    IF NOT EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        SET @errorCode = 1;
        RETURN;
    END
  
    DELETE FROM sanpham WHERE masp = @masp;
    
   
    DELETE FROM Nhap WHERE masp = @masp;
    DELETE FROM Xuat WHERE masp = @masp;
    
    SET @errorCode = 0;
END
--Cau 5
CREATE PROCEDURE sp_ThemMoiHangsx 
    @mahangsx INT,
    @tenhang NVARCHAR(50),
    @diachi NVARCHAR(100),
    @sodt NVARCHAR(20),
    @email NVARCHAR(50)
AS
BEGIN
  
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        RETURN 1; 
    END


    INSERT INTO Hangsx(mahangsx, tenhang, diachi, sodt, email)
    VALUES(@mahangsx, @tenhang, @diachi, @sodt, @email)

    RETURN 0; 
END
--Cau 6
CREATE PROCEDURE sp_NhapXuat_Xuat
    @sohdx INT,
    @masp INT,
    @manv INT,
    @ngayxuat DATE,
    @soluongX INT
AS
BEGIN
    
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 1 
    END
    
    
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RETURN 2 
		END
    
    
    IF @soluongX > (SELECT soluong FROM Sanpham WHERE masp = @masp)
    BEGIN
        RETURN 3 
    END
    
    
    IF EXISTS(SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        
        INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX)
        VALUES(@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
    
    
    RETURN 0
END
--Cau 7
CREATE PROCEDURE sp_XuatHangHoa
    @sohdx nvarchar(10),
    @masp nvarchar(10),
    @manv nvarchar(10),
    @ngayxuat date,
    @soluongX int
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp) 
    BEGIN
      
        RETURN 1
    END
    
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv) 
    BEGIN
       
        RETURN 2
    END
    
    DECLARE @SoluongS int
    SELECT @SoluongS = soluong FROM Sanpham WHERE masp = @masp 
    
    IF @soluongX <= @SoluongS 
    BEGIN
        IF EXISTS(SELECT * FROM Xuat WHERE sohdx = @sohdx) 
        BEGIN
          
            UPDATE Xuat SET masp = @masp, manv = @manv, ngayxuat = @ngayxuat, soluongX = @soluongX WHERE sohdx = @sohdx
        END
        ELSE
        BEGIN
            
            INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX) 
            VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
        END

       
        UPDATE Sanpham SET soluong = @SoluongS - @soluongX WHERE masp = @masp

        RETURN 0
    END
    ELSE
    BEGIN
       
        RETURN 3
    END
END

DECLARE @errorCode int
EXEC @errorCode = sp_XuatHangHoa @sohdx = 'HDX001', @masp = 'SP001', @manv = 'NV001', @ngayxuat = '2023-04-09', @soluongX = 5

IF (@errorCode = 0)
BEGIN
    PRINT 'Thành công'
END
ELSE IF (@errorCode = 1)
BEGIN
    PRINT 'Mã sản phẩm không tồn tại'
END
ELSE IF (@errorCode = 2)
BEGIN
    PRINT 'Mã nhân viên không tồn tại'
END
ELSE IF (@errorCode = 3)
BEGIN
    PRINT 'Số lượng sản phẩm không đủ để xuất'
END