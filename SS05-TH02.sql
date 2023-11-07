DELIMITER //
drop procedure if exists `findAllCustomer`//
create procedure findAllCustomer()
begin 
select * from customers where customerNumber = 175;
end //
DELIMITER ;

