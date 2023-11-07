drop database if exists studenttest_hp;
create database studenttest_hp;
use studenttest_hp;
create table if not exists Students (
rn int primary key auto_increment,
sName varchar(20),
sAge tinyint
);

insert into Students (sName, sAge)
values
('Nguyen Hong Ha', 20),
('Truong Ngoc Anh',30),
('Tuan Minh', 25),
('Dan Truong', 22);

create table if not exists Tests (
testID int primary key auto_increment,
tName varchar(20)
);

insert into Tests (tName)
values
('EPC'), ('DWMX'), ('SQL1'), ('SQL2');

create table if not exists StudentTests (
rn int,
foreign key (rn) references Students(rn),
testID int,
foreign key (testID) references Tests(testID),
tDate datetime,
mark float
);

insert into StudentTests (rn, testID, tDate, mark)
values
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

# thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng 15-55
alter table Students
add constraint chk_age check(sAge between 15 and 55);

# thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
alter table StudentTests
alter mark set default 0;

# thêm khóa chính cho bảng StudentTest là (rn, testID)
alter table StudentTests
add constraint pk_stt_rn_testid primary key (rn, testID);

# thêm ràng buộc duy nhất cho cột name trên bảng test
alter table Tests
add constraint ut_name unique (tName);

# xóa ràng buộc duy nhất cho cột name trên bảng test
alter table Tests
drop constraint ut_name;

# hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, có điểm thi và ngày thi
select Students.sName as 'Student Name', Tests.tName as 'Test Name', StudentTests.mark as 'Mark', StudentTests.tDate as 'Date' from Students join StudentTests on Students.rn = StudentTests.rn join Tests on StudentTests.testID = Tests.testID;

# hiển thị danh sách các bạn học viên chưa thi môn nào
select Students.rn as 'RN', Students.sName as 'Name', Students.sAge as 'Age' from Students where Students.rn not in (select distinct StudentTests.rn from StudentTests);

# hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi (điểm phải thi lại là điểm nhỏ hơn 5)
select Students.sName as 'Student Name', Tests.tName as 'Test Name', StudentTests.mark as 'Mark', StudentTests.tDate as 'Date' from Students join StudentTests on Students.rn = StudentTests.rn join Tests on StudentTests.testID = Tests.TestID where StudentTests.mark < 5;

# hiển thị danh sách học viên và điểm trung bình của các môn đã thi, danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần
select Students.sName as 'Student Name', avg(StudentTests.mark) as 'Average' from Students join StudentTests on Students.rn = StudentTests.rn group by StudentTests.rn order by avg(StudentTests.mark) desc;

# hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất
select Students.sName as 'Student Name', avg(StudentTests.mark) as 'Average' from Students join StudentTests on Students.rn = StudentTests.rn group by StudentTests.rn order by avg(StudentTests.mark) desc limit 1;

# hiển thị điểm cao nhất của từng môn học, danh sách sắp xếp theo tên môn học
select Tests.tName as 'Test Name', max(StudentTests.mark) as 'Max Mark' from Tests join StudentTests on Tests.testID = StudentTests.testID group by(Tests.testID) order by Tests.tName;

# hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi, nếu học viên chưa thi môn nào thì phần tên môn học để null
# để hiện được null ở kết quả cuối cùng thì phải left join 2 lần
select Students.sName as 'Student Name', Tests.tName as 'Test Name' from Students left join StudentTests on Students.rn = StudentTests.rn left join Tests on StudentTests.testID = Tests.testID;

# sửa tuổi của tất cả các học viên mỗi người lên một tuổi
update Students
set sAge = sAge + 1;

# thêm trường tên là status có kiểu varchar(10) vào bảng Students
alter table Students
add column sStatus varchar(10);

# cập nhật trường status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị 'Young', trường hợp còn lại nhận giá trị 'Old' sau đó hiển thị toàn bộ nội dung bảng Student lên
# case when chỉ trả về 1 giá trị => cần phải để ở vế phải của mệnh đề set
update Students
set sStatus = case
when sAge < 30 then 'Young'
else 'Old'
end;
select * from Students;

# hiển thị danh sách học viên và điểm thi, danh sách sắp xếp tăng dần theo ngày thi (đề sai)
select Students.sName as 'Student Name', Tests.tName as 'Test Name', StudentTests.mark as 'Mark', StudentTests.tDate as 'Date' from Students join StudentTests on Students.rn = StudentTests.rn join Tests on StudentTests.testID = Tests.testID order by StudentTests.tDate;

# hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự 'T' và điểm thi trung bình > 4.5. Thông tin bao gồm: Tên sinh viên, tuổi, điểm trung bình
select Students.sName, Students.sAge, avg(StudentTests.mark) from Students join StudentTests on Students.rn = StudentTests.rn group by StudentTests.rn having Students.sName like 'T%' and avg(StudentTests.mark) > 4.5;

# Hiển thị các thông tin sinh viên (mã, tên, tuổi, điểm trung bình, xếp hạng. Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1
select Students.rn , Students.sName, Students.sAge, avg(StudentTests.mark), dense_rank() over (order by avg(StudentTests.mark) desc) as 'Xếp hạng' from Students left join StudentTests on Students.rn = StudentTests.rn group by Students.rn, Students.sName, Students.sAge order by avg(StudentTests.mark);

# Sửa đổi kiểu dữ liệu cột name trong bảng Students thành nvarchar(max) => không làm được
alter table Students
modify sName nvarchar(6323);

# cập nhật (sử dụng phương thức write) cột name trong bảng Students với yêu cầu sau:
# nếu tuổi > 20 => thêm 'Old' vào trước tên (cột name)
# nếu tuổi nhỏ hơn hoặc bằng 20 thì thêm 'Young' vào trước tên (cột name)

update Students
set sName = case when sAge > 20 then concat('Old ', sName) else concat('Young ', sName) end;

# Xóa tất cả các môn học chưa có bát kỳ sinh viên nào thi
delete from Tests where testID not in (select distinct testID from StudentTests);

# Xóa thông tin điểm thi của sinh viên có điểm < 5
delete from StudentTests where mark < 5;


