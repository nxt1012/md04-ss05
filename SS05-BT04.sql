drop database if exists qlbh_hp;
create database qlbh_hp;
use qlbh_hp;
create table if not exists Customers (
cID int primary key auto_increment,
cName varchar(25),
cAge tinyint
);
create table if not exists Orders (
oID int primary key auto_increment,
cID int,
foreign key (cID) references Customers(cID),
oDate datetime,
oTotalPrice int default null
);
create table if not exists Products (
oID int,
foreign key (oID) references Orders(oID),
pID int primary key auto_increment,
pName varchar(25),
pPrice int
);
create table if not exists OrderDetails (
oID int,
foreign key (oID) references Orders(oID),
pID int,
foreign key (pID) references Products(pID),
odQTY int
);
insert into Customers (cName, cAge)
values
('Minh Quan', 10),
('Ngoc Oanh', 20),
('Hong Ha', 50);
insert into Orders (cID, oDate)
values
(1, '2006-03-21'),
(2, '2006-03-26'),
(1, '2006-03-16');
insert into Products (pName, pPrice)
values
('May Giat', 3),
('Tu Lanh', 5),
('Dieu Hoa', 7),
('Quat', 1),
('Bep Dien', 2);
insert into OrderDetails (oID, pID, odQTY)
values
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

# tạo một view có tên là Sales để hiển thị tổng doanh thu của siêu thị:
create view Sales as
select sum(OrderDetails.odQTY * Products.pPrice) as Sales from OrderDetails join Products on OrderDetails.pID = Products.pID;

select * from Sales;


# NGHIÊN CỨU THÊM PHẦN NÀY
# xóa tất cả ràng buộc khóa ngoại, khóa chính của tất cả các bảng
# xóa tất cả ràng buộc khóa ngoại
# lấy danh sách các bảng có ràng buộc khóa ngoại
select table_name, constraint_name
from information_schema.key_column_usage
where constraint_schema = 'qlbh_hp' and referenced_table_name is not null;
# xóa ràng buộc khóa ngoại cho mỗi bảng
set session foreign_key_checks = 0;
# lặp qua danh sách và xóa ràng buộc khóa ngoại cho từng bảng
alter table table_name
drop foreign key constraint_name;
set session foreign_key_checks = 1;

# lấy danh sách các bảng có khóa chính
select table_name, constraint_name
from information_schema.key_column_usage
where constraint_schema = 'qlbh_hp' and constraint_name = 'primary';
# xóa khóa chính cho mỗi bảng

# lặp qua danh sách và xóa khóa chính cho từng bảng
alter table table_name
drop primary key;