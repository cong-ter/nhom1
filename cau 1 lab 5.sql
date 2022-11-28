---- In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của bạn.
create procedure  sp_lab5_a  @ten nvarchar(10)
 as
	begin
		print 'xin chào'+ @ten
	end
exec sp_lab5_a N' Văn Tú'

------Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2---------

create procedure  sp_lab5_b  @so1 int , @so2 int
 as
 begin 
	declare @tong int
	set @tong= @so1+ @so2
	print N'Tổng là:' + cast(@tong as varchar(10))
 end
 exec sp_lab5_b 3,4
 
 ----Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n----- create procedure  sp_lab5_c  @n int 
 as
 begin 
	declare @sum int=0 , @i int =0
	while @i < @n
		begin 
			set @sum = @sum + @i
			set @i=@i+2
		end
			print N' Tổng là: ' + cast(@sum as nvarchar(10))

 end
exec sp_lab5_c 10
  ----  Nhập vào 2 số. In ra ước chung lớn nhất --- create procedure  sp_lab5_d  @a int , @b int 
 as
 begin 
	
	while @a != @b
		begin 
			if(@a>@b)
				set @a = @a - @b
			else
			set @b=@b-@a
		end
			return @a

 end
declare @c int
exec @c= sp_lab5_d 30 ,40 
print @c