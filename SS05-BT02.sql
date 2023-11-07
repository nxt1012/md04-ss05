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

# hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, danh sách sắp xếp theo thứ tự ngày sáng, hóa đơn mới hơn nằm ở trên
select Orders.oID, Orders.oDate, Orders.oTotalPrice from Orders order by Orders.oDate desc;

# hiển thị tên và giá của các sản phẩm có giá cao nhất
select Products.pName, Products.pPrice as pPrice from Products order by Products.pPrice desc limit 1;

# hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
# lấy ra 2 cột cần thiết là cName và pName từ bảng tổng hợp (bảng sau khi nối)
# nối các bảng với nhau bằng các khớp nối (join) giữa chúng Customers với Orders, Orders với OrderDetails, OrderDetails với Products
select Customers.cName, Products.pName from Customers join Orders on Customers.cID = Orders.cID join OrderDetails on Orders.oID = OrderDetails.oID join Products on OrderDetails.pID = Products.pID;

# hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
# khách hàng đã từng mua sản phẩm sẽ có tên trong danh sách Orders (khách đã mua hàng, chỉ cần distinct ra là đủ)
# tìm khách có ID không nằm trong danh sách đó sẽ là khách đã không mua hàng
select Customers.cName from Customers where Customers.cID not in (select distinct Orders.cID from Orders);

# hiển thị chi tiết cuar từng hóa đơn
select Orders.oID, Orders.oDate, OrderDetails.odQTY, Products.pName, Products.pPrice from Orders join OrderDetails on Orders.oID = OrderDetails.oID join Products on OrderDetails.pID = Products.pID;

# hiện thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn
# tổng hợp bảng tương tự như khi nối 3 bảng lại phía trên
# tổng hợp lại theo oID bằng group by
# để cộng tổng các mục con lại sử dụng hàm sum
select Orders.oID, Orders.oDate, sum(OrderDetails.odQTY * Products.pPrice) as Total from Orders join OrderDetails on Orders.oID = OrderDetails.oID join Products on OrderDetails.pID = Products.pID group by Orders.oID;