drop schema if exists TicketFilm;
create schema TicketFilm;
use TicketFilm;

create table tblPhim (
phimID int primary key auto_increment,
tenPhim nvarchar(30),
loaiPhim nvarchar(25),
thoiGian int
);

insert into tblPhim (tenPhim, loaiPhim, thoiGian)
values
('Em bé Hà Nội', 'Tâm lý', 90),
('Nhiệm vụ bất khả thi', 'Hành động', 100),
('Dị nhân', 'Viễn tưởng', 90),
('Cuốn theo chiều gió', 'Tình cảm', 120);

create table tblPhong (
phongID int primary key auto_increment,
tenPhong nvarchar(20),
trang_thai tinyint
);

insert into tblPhong (tenPhong, trang_thai)
values
('Phòng chiếu 1', 1),
('Phòng chiếu 2', 1),
('Phòng chiếu 3', 0);

create table tblGhe (
gheID int primary key auto_increment,
phongID int,
foreign key (phongID) references tblPhong (phongID),
soGhe varchar(10)
);

insert into tblGhe (phongID, soGhe)
values
(1, 'A3'),
(1, 'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

create table tblVe(
phimID int,
foreign key (phimID) references tblPhim (phimID),
gheID int,
foreign key (gheID) references tblGhe (gheID),
ngayChieu datetime,
trangThai nvarchar(20)
);

insert into tblVe (phimID, gheID, ngayChieu, trangThai)
values
(1, 1, '2008/10/20', 'Đã bán'),
(1, 3, '2008/11/20', 'Đã bán'),
(1, 4, '2008/12/23', 'Đã bán'),
(2, 1, '2009/02/14', 'Đã bán'),
(3, 1, '2009/02/14', 'Đã bán'),
(2, 5, '2009/03/08', 'Chưa bán'),
(2, 3, '2009/03/08', 'Chưa bán')
;

# hiển thị danh sách các phim (theo trường thời gian)
select tblPhim.tenPhim as 'Tên phim', tblPhim.loaiPhim as 'Loại phim', tblPhim.thoiGian as 'Thời gian' from tblPhim order by tblPhim.thoigian;

# hiển thị tên phim có thời gian chiếu dài nhất
select tblPhim.tenPhim as 'Tên phim có thời gian chiếu dài nhất', tblPhim.loaiPhim as 'Loại phim', tblPhim.thoiGian as 'Thời gian' from tblPhim order by tblPhim.thoigian desc limit 1;

# hiển thị tên phim có thời gian chiếu ngắn nhất
select tblPhim.tenPhim as 'Tên phim có thời gian chiếu ngắn nhất', tblPhim.loaiPhim as 'Loại phim', tblPhim.thoiGian as 'Thời gian' from tblPhim order by tblPhim.thoigian limit 1;

# hiển thị danh sách soGhe bắt đầu bằng chữ 'A'
select tblGhe.soGhe from tblGhe where tblGhe.soGhe like 'A%';

# sửa cột trang_thai của bảng tblPhong sagn kiểu nvarchar(25)
alter table tblPhong
modify trang_thai nvarchar(25);

# cập nhật giá trị cột trang_thai của tbl Phong:
update tblPhong
set trang_thai = case
when trang_thai = 0 then 'Đang sửa'
when trang_thai = 1 then 'Đang sử dụng'
else 'Unknown'
end;

select * from tblPhong;

# hiển thị danh sách tên phim có độ dài > 15 và < 25 ký tự
select tblPhim.tenPhim from tblPhim where length(tblPhim.tenPhim) between 15 and 25;

# hiển thị tenPhong và trangThai trong bảng tblPhong trong một cột với tiêu đề 'Trạng thái phòng chiếu'
select concat(tblPhong.tenPhong, ' ', tblPhong.trang_thai) as 'Trạng thái phòng chiếu' from tblPhong;

# Tạo bảng mới có tên tblRank với các cột: STT (thứ tự sắp xếp theo tên phim, Tên phim, Thời gian)
create table tblRank as
select @row_number:=@row_number+1 as STT,
tenPhim as 'Tên phim', thoiGian as'Thời gian' from tblPhim, (select @row_number:=0) as t order by tenPhim;

select * from tblRank;

# trong bảng tblPhim
# thêm trường moTa kiểu nvarchar(max)
alter table tblPhim
add column moTa nvarchar(6323);
# cập nhật trường moTa
update tblPhim
set moTa = concat('Đây là bộ phim thể loại ', LoaiPhim);

# cập nhật trường moTa
update tblPhim
set mota = replace(moTa, 'bộ phim', 'film');

# hiển thị bảng tblPhim sau khi cập nhật
select * from tblPhim;

# xóa tất cả các khóa ngoại trong các bảng
delimiter //
create procedure dropAllForeignKeys()
begin
declare done int default false;
declare tableName varchar(100);
declare constraintName varchar(100);

declare cur cursor for
select table_name, constraint_name
from information_schema.key_column_usage
where table_name is not null;

declare continue handler for not found set done = true;
open cur;

read_loop: loop
fetch cur into tableName, constraintName;
if done then
leave read_loop;
end if;

set @sql = concat('alter table', tableName, 'drop foreign key', constraintName);
prepare stmt from @sql;
execute stmt;
deallocate prepare stmt;
end loop;

close cur;

end //
delimiter ;

call dropAllForeignKeys();
# xóa dữ liệu ở bảng tblGhe
delete from tblGhe;

# hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút
select now() as 'Ngày giờ hiện tại', date_add(now(), interval 5000 minute) as 'Ngày giờ hiện tại cộng thêm 5000 phút';