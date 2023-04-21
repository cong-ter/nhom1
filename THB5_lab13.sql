create database QLBH
go
use QLBH
create table Mathang(
	mahang varchar(10) primary key,
	tenhang nvarchar(50),
	soluong int
)
go
create table Nhatkybanhang(
	stt int primary key,
	ngay date,
	nguoimua nvarchar(50),
	mahang varchar(10),
	soluong int,
	giaban int

	foreign key (mahang) references Mathang(mahang)
)
go
insert into Mathang(mahang,tenhang,soluong)
values('1','Keo',100),('2','Banh',200),('3','Thuoc',100)
go
insert into Nhatkybanhang(stt,ngay,nguoimua,mahang,soluong,giaban)
values(1,'1999-02-09','ab','2',230,50000)
go
--câu 3.a
CREATE TRIGGER trg_nhatkybanhang_insert
ON NHATKYBANHANG
AFTER INSERT
AS
BEGIN
	UPDATE MATHANG
	SET soluong = MATHANG.soluong - inserted.soluong
	FROM MATHANG
	INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
END
go
--câu 3.b
create trigger trg_nhatkybanhang_update
on NHATKYBANHANG
after UPDATE
as
begin
	if UPDATE(soluong)
	begin
		UPDATE MATHANG
		set soluong = MATHANG.soluong + deleted.soluong - inserted.soluong
		from MATHANG
		INNER JOIN deleted ON MATHANG.mahang = deleted.mahang
		INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	end
end
go
--Câu 3.c
create trigger trg_nhatkybanhang_insertt
on NHATKYBANHANG
for insert
as
begin
	declare @mahang int, @soluong int, @soluong_hien_co int

	select @mahang = mahang, @soluong = soluong
	from inserted

	select @soluong_hien_co = soluong
	from MATHANG
	where mahang = @mahang

	if @soluong <= @soluong_hien_co
	begin
		UPDATE MATHANG
		set soluong = soluong - @soluong
		where mahang = @mahang
		end
		else
		begin
		raiserror('Số lượng hàng bán ra phải nhỏ hơn hoặc bằng số lượng hàng hiện có!', 16, 1)
		rollback transaction
	end
end
--Câu 3.d
create trigger trg_nhatkybanhang_updatee
on NHATKYBANHANG
for UPDATE
as
begin
if (select COUNT(*) from inserted) > 1
begin
	raiserror('Chỉ được cập nhật 1 bản ghi tại một thời điểm!', 16, 1)
	rollback transaction
	end
	else
	begin
		declare @mahang int, @soluong int, @soluong_hien_co int
		select @mahang = mahang, @soluong = soluong
		from inserted

		select @soluong_hien_co = soluong
		from MATHANG
		where mahang = @mahang

		UPDATE MATHANG
		set soluong = soluong + (select soluong from deleted) - @soluong
		where mahang = @mahang
	end
end
--Câu 3.e
create trigger trg_nhatkybanhang_delete
on NHATKYBANHANG
for delete
as
begin
	if (select COUNT(*) from deleted) > 1
	begin
		raiserror('Chỉ được xóa 1 bản ghi tại một thời điểm!', 16, 1)
		rollback transaction
		end
		else
		begin
		declare @mahang int, @soluong int
		select @mahang = mahang, @soluong = soluong
		from deleted
		UPDATE MATHANG
		set soluong = soluong + @soluong
		where mahang = @mahang
	end
end
-- câu 3.e
create trigger trg_nhatkybanhang_updateee
on NHATKYBANHANG
for UPDATE
as
begin
	declare @mahang int, @soluong int, @soluong_hien_co int

	select @mahang = mahang, @soluong = soluong
	from inserted

	select @soluong_hien_co = soluong
	from MATHANG
	where mahang = @mahang

	if @soluong > @soluong_hien_co
	begin
		raiserror('Số lượng cập nhật không được vượt quá số lượng hiện có!', 16, 1)
		rollback transaction
	end
	else if @soluong = @soluong_hien_co
	begin
		raiserror('Không cần cập nhật số lượng!', 16, 1)
		rollback transaction
	end
	else
	begin
		UPDATE MATHANG
		set soluong = soluong + (select soluong from deleted) - @soluong
		where mahang = @mahang
	end
end
--Câu 3.g
CREATE PROCEDURE sp_xoa_mathang
@mahang INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM MATHANG WHERE mahang = @mahang)
BEGIN
PRINT 'Mã hàng không tồn tại!'
RETURN
END

BEGIN TRANSACTION

DELETE FROM NHATKYBANHANG WHERE mahang = @mahang
DELETE FROM MATHANG WHERE mahang = @mahang

COMMIT TRANSACTION

PRINT 'Xóa mặt hàng thành công!'
END
--Câu 3.h
CREATE FUNCTION fn_tongtien_hang
(@tenhang NVARCHAR(50))
RETURNS MONEY
AS
BEGIN
DECLARE @tongtien MONEY

SELECT @tongtien = SUM(nk.soluong * nk.giaban)
FROM NHATKYBANHANG nk
JOIN MATHANG mh ON nk.mahang = mh.mahang
WHERE mh.tenhang = @tenhang

RETURN @tongtien
END

-- Test cho câu 2
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- Test cho câu 3a
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES (6, '2022-04-22', 'Nguyễn Thị F', 1, 3, 15000)
SELECT * FROM MATHANG
-- Test cho câu 3b
UPDATE NHATKYBANHANG SET soluong = 2 WHERE stt = 2
SELECT * FROM MATHANG
-- Test cho câu 3c
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(7, '2022-04-23', 'Trương Văn G', 2, 10, 12000)
SELECT * FROM MATHANG
-- Test cho câu 3d
UPDATE NHATKYBANHANG SET soluong = 1 WHERE stt = 3
SELECT * FROM MATHANG
-- Test cho câu 3e
DELETE FROM NHATKYBANHANG WHERE stt = 4
SELECT * FROM MATHANG
-- Test cho câu 3f
UPDATE NHATKYBANHANG SET soluong = 7 WHERE stt = 5
SELECT * FROM MATHANG
-- Test cho câu 3g
EXEC sp_xoa_mathang 3
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
-- Test cho câu 3h
SELECT dbo.fn_tongtien_hang('Sữa tươi Vinamilk') AS 'Tổng tiền Sữa tươi Vinamilk'
SELECT dbo.fn_tongtien_hang('Bánh mì phô mai') AS 'Tổng tiền Bánh mì phô mai'

