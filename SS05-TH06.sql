drop schema if exists protectedView;
create schema protectedView;
use protectedView;
create table classes (
classID int primary key auto_increment,
className nvarchar(6323),
startDate datetime,
status bit(0)
);

create table students (
studentID int primary key auto_increment,
studentName nvarchar(30) not null,
address nvarchar(50),
phone varchar(20),
status bit(0),
classID int
);

create table subjects (
subID int primary key auto_increment,
subName nvarchar(30) not null,
credit tinyint not null default 1,
check(credit >= 1),
status bit(1) default 1);

create table marks (
markID int primary key,
subID int not null unique,
studentID int not null unique,
mark float default 0,
check(mark between 0 and 100),
examTimes tinyint default 1
);

# sử dụng alter table
# thêm ràng buộc khóa ngoại trên cột classID của bảng students tham chiếu đến cột classID trên bảng classes
alter table students
add constraint fk_classid_students foreign key (classID) references classes (classID);

# thêm ràng buộc cho cột startDate của bảng classes là ngày hiện hành
alter table classes
modify startDate datetime default current_timestamp;

# thêm ràng buộc mặc định cho cột status của bảng students là 1
alter table students
modify status bit(1) default 1;

# thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
# subID trên bảng marks tham chiếu đến cột subID trên bảng subjects
alter table marks
add constraint fk_subid_marks foreign key (subID) references subjects (subID);

# studentID trên bảng marks tham chiếu đến cột studentID trên bảng students
alter table marks
add constraint fk_studentid_marks 
foreign key (studentID) references students (studentID);

insert into classes (className, startDate, status)
values
('A1', '2008/12/20', 1),
('A2', '2008/12/22', 1),
('B3', current_timestamp(), 0);

insert into students (studentName, address, phone, status, classID)
values
('Hung', 'Ha noi', 0912113113, 1, 1),
('Hoa', 'Hai phong', null , 1, 1),
('Manh', 'HCM', 0123123123, 0, 2);

insert into subjects (subName, credit, status)
values
('CF', 5, 1),
('C', 6, 1),
('HDJ', 5, 1),
('RDBMS', 10, 1);

insert into marks (subID, studentID, mark, examTimes)
values
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);

# thay đổi mã lớp (classID) của sinh viên có tên 'Hung' là 2

# cập nhật cột phone trên bảng sinh viên là 'No phone' cho những sinh viên chưa có số điện thoại

# nếu trạng thái của lớp 'Status' là 0 thì thêm từ 'New' vào trước tên lớp

# nếu trạng thái của status trên bảng class là 1 và tên lớp bắt đầu là 'New' thì thay thế 'New' bằng 'Old'

# nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0

# cập nhất trạng thái của lớp học (bảng subjects) là 0 nếu môn học đó chưa có sinh viên dự thi

# hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h'

# hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12

# hiển thị giá trị lớn nhất của credit trong bảng subject

# hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất

# hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5

# hiển thị các thông tin bao gồm: classID, className, studentName, address từ hai bảng class, student

# hiển thị các thông tin môn học chưa có sinh viên dự thi

# hiển thị các thông tin môn học có điểm thi lớn nhất

# hiển thị các thông tin sinh viên và điểm trung bình tương ứng

# hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (sử dụng hàm rank)

# hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10

# hiển thị các thông tin: studentName, subName, mark, dữ liệu sắp xếp theo điểm thi giảm dần, nếu trùng sắp theo tên tăng dần

# xóa tất cả các lớp có trạng thái là 0

# xóa tất cả các môn học chưa có sinh viên dự thi

# xóa bỏ cột examTimes trên bảng Mark

# sửa đổi cột status trên bảng classes thành tên classStatus

# đổi tên bảng marks thành subjectTests