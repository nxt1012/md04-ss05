-- Tạo view lấy ra
-- product_name, price, category_name từ hai bảng
-- category, product

-- Tạo view lấy ra danh sách danh mục và số lượng sản phẩm theo danh mục cache index
-- id, category name, qty_product

-- sử dụng JOIn kết hợp với hàm tính toán COUNT

-- cú pháp tạo view:
-- create view view_name as
-- select...
drop database if exists ss05_db;
create database ss05_db;
use ss05_db;
create table if not exists products (
id int primary key auto_increment,
product_name varchar(255),
price float,
category_id int
);
create table if not exists categories (
id int primary key auto_increment,
category_name varchar(255)
);
alter table products
add constraint fk_products_far_categories
foreign key (category_id) references categories(id);
insert into categories (category_name)
values ('Áo'),('Quần'), ('Áo lót');
insert into products(product_name, price, category_id)
values
('Áo thu đông', 15.5, 1),
('Quần Jean', 20.0, 2),
('Áo ba lỗ', 10.0, 1),
('Quần lửng', 17.5, 2);


create view vw_join as
select products.product_name, products.price, categories.category_name from products join categories on products.category_id = categories.id;

select * from vw_join;

-- Tạo view lấy ra danh sách danh mục và số lượng sản phẩm theo danh mục cache index
-- id, category name, qty_product

-- sử dụng JOIn kết hợp với hàm tính toán COUNT
create view vw_count as
select categories.id, categories.category_name, count(products.id) as qty_product from categories left join products on categories.id = products.category_id group by categories.id;
select * from vw_count;

-- Tạo thủ tục lấy về danh sách sản phẩm
-- Tạo thủ tục sau:
-- 1. Tạo thủ tục trả về danh sách sản phẩm
-- 2. Tạo thủ tục thêm mới sản phẩm
-- 3. Tạo thủ tục cập nhật sản phẩm (yêu cầu truyền vào ID và dữ liệu)
-- 4. Tạo thủ tục xóa sản phẩm (yêu cầu truyền vào ID)
-- 5. Tạo thủ tục phân trang (truyền vào số limit và số trang hiện tại)

-- 1. Tạo thủ tục trả về danh sách sản phẩm
delimiter //
create procedure proc_getAll()
begin
select * from products;
end; //
delimiter ;
call proc_getAll();

-- 2. Tạo thủ tục thêm mới sản phẩm
delimiter //
create procedure proc_insertNewProduct(IN productName varchar(255), IN productPrice float, IN categoryID int)
begin
insert into products (product_name, price, category_id) values (productName, productPrice, categoryID); 
end; //
delimiter ;
call proc_insertNewProduct('Áo Hoodie', 50.0, 1);

-- 3. Tạo thủ tục cập nhật sản phẩm (yêu cầu truyền vào ID và dữ liệu)
delimiter //
create procedure proc_updateProduct(IN productID int, IN productName varchar(255), IN productPrice float, IN categoryID int)
begin
update products
set product_name = productName, price = productPrice, category_id = categoryID
where products.id = productID;
end; //
delimiter ;
call proc_updateProduct(2, 'Áo cánh chuồn', 75, 1);

-- 4. Tạo thủ tục xóa sản phẩm (yêu cầu truyền vào ID)
delimiter //
create procedure proc_deleteProduct(IN productID int)
begin
delete from products
where id = productID;
end; //
delimiter ;
call proc_deleteProduct(5);

-- 5. Tạo thủ tục phân trang (truyền vào số limit và số trang hiện tại)
delimiter //
create procedure proc_getLimitedResult(IN limitNumber int, IN currentPageNumber int)
begin
# 
declare offset_value int;
#
set offset_value = (currentPageNumber - 1) * limitNumber;
#
create temporary table TempResult as
select * from products limit limitNumber offset offset_value;

select * from TempResult;

drop temporary table if exists TempResult;
end; //
delimiter ;
#
call proc_getLimitedResult(1, 1);