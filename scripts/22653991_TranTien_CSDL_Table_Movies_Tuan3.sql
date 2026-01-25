/*
Họ tên: Trần Tiến
MSSV: 22653991

Bài tập tuần 3 - Quản lý Movies
*/

USE master;
DROP DATABASE qlmv;

-- 1. Dùng T-SQL tạo CSDL Movies --

CREATE DATABASE qlmv
ON (
  NAME = movies_data,
  FILENAME = '/var/opt/mssql/data/movies_data.mdf',
  SIZE = 25MB,
  MAXSIZE = 40MB,
  FILEGROWTH = 1MB
)
LOG ON (
  NAME = movies_log,
  FILENAME = '/var/opt/mssql/data/movies_log.ldf',
  SIZE = 6MB,
  MAXSIZE = 8MB,
  FILEGROWTH = 1MB
);

USE qlmv;


-- 2. Thực hiện và kiểm tra kết quả các yêu cầu sau: --

---- Thêm một Data file thứ 2
ALTER DATABASE qlmv
ADD FILE (
  NAME = movies_data2,
  FILENAME = '/var/opt/mssql/data/movies_data2.ndf',
  SIZE = 10MB
);
EXEC sp_helpdb 'qlmv';

---- Cấu hình CSDL Movies với chế độ:

------ single_user
ALTER DATABASE qlmv
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
EXEC sp_helpdb 'qlmv';

------ restricted_user
ALTER DATABASE qlmv
SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE;
EXEC sp_helpdb 'qlmv';

------ multi_user
ALTER DATABASE qlmv
SET MULTI_USER;
EXEC sp_helpdb 'qlmv';

---- Tăng kích cỡ của data file thứ 2 từ 10 MB lên 15 MB
ALTER DATABASE qlmv
MODIFY FILE (
  NAME = movies_data2,
  SIZE = 15MB
);
EXEC sp_helpdb 'qlmv';

---- Cấu hình CSDL về chế độ tự động SHRINK
ALTER DATABASE qlmv
SET AUTO_SHRINK ON;
EXEC sp_helpdb 'qlmv';

---- Xoá CSDL Movies
-- DROP DATABASE qlmv;


-- 3. Mở tập tin Movies.sql, thực hiện: --

---- Bổ sung thêm câu lệnh tạo một filegroup tên là DataGroup
ALTER DATABASE qlmv
ADD FILEGROUP DataGroup;
EXEC sp_helpfilegroup;

---- Hiệu chỉnh maxsize của tập tin transaction log thành 10 MB
ALTER DATABASE qlmv
MODIFY FILE (
  NAME = movies_log,
  MAXSIZE = 10MB
);
EXEC sp_helpdb 'qlmv';

---- Size của tập tin data file thứ 2 thành 10 MB.
DBCC SHRINKFILE (N'movies_data2', 10);
EXEC sp_helpdb 'qlmv';

---- Thêm data file thứ 3 thuộc filegroup DataGroup
ALTER DATABASE qlmv
ADD FILE (
  NAME = movies_data3,
  FILENAME = '/var/opt/mssql/data/movies_data3.ndf',
  SIZE = 5MB
) TO FILEGROUP DataGroup;
EXEC sp_helpdb 'qlmv';


-- 5. Thực hiện định nghĩa các user-defined datatype sau trong CSDL Movies. Kiểm tra sau khi tạo.

EXEC sp_addtype 'movie_num', 'INT', 'NOT NULL';
EXEC sp_help 'movie_num';

EXEC sp_addtype 'category_num', 'INT', 'NOT NULL';
EXEC sp_help 'category_num';

EXEC sp_addtype 'cust_num', 'INT', 'NOT NULL';
EXEC sp_help 'cust_num';

EXEC sp_addtype 'invoice_num', 'INT', 'NOT NULL';
EXEC sp_help 'invoice_num';


-- 6. Thực hiện tạo các bảng vào CSDL Movies, kiểm tra kết quả bằng sp_help

---- Customer
CREATE TABLE customers
(
  cust_num cust_num IDENTITY(300, 1) NOT NULL,
  lname VARCHAR(20) NOT NULL,
  fname VARCHAR(20) NOT NULL,
  address1 VARCHAR(30),
  address2 VARCHAR(20),
  city VARCHAR(20),
  state CHAR(2),
  zip CHAR(10),
  phone VARCHAR(10) NOT NULL,
  join_date SMALLDATETIME NOT NULL
);

---- Category
CREATE TABLE categories
(
  category_num category_num IDENTITY(1, 1) NOT NULL,
  description VARCHAR(20) NOT NULL
);

---- Movie
CREATE TABLE movies
(
  movie_num movie_num NOT NULL,
  title cust_num NOT NULL,
  category_num category_num NOT NULL,
  date_purch SMALLDATETIME,
  rental_price INT,
  rating CHAR(5)
);

---- Rental
CREATE TABLE rentals
(
  invoice_num invoice_num NOT NULL,
  cust_num cust_num NOT NULL,
  rental_date SMALLDATETIME NOT NULL,
  due_date SMALLDATETIME NOT NULL
);

---- Rental Details
CREATE TABLE rental_details
(
  invoice_num invoice_num ,
  line_num INT NOT NULL,
  movie_num movie_num NOT NULL,
  rental_price SMALLMONEY NOT NULL
);


/*
7. Thực hiện phát sinh tập tin script cho CSDL Movies với các lựa chọn sau, lưu tên Movies.sql:
- All Tables, All user-defined data types
- Generate the CREATE <object> command for each object
- Generate the DROP <object> command for each object
*/


-- 8. Thực hiện tạo Diagram cho CSDL Movies. Lưu diagram với tên là Movies.


-- 9. Thực hiện định nghĩa các khoá chính

ALTER TABLE movies
ADD CONSTRAINT pk_movie PRIMARY KEY (movie_num);

ALTER TABLE customers
ADD CONSTRAINT pk_customer PRIMARY KEY (cust_num);

ALTER TABLE categories
ADD CONSTRAINT pk_category PRIMARY KEY (category_num);

ALTER TABLE rentals
ADD CONSTRAINT pk_rental PRIMARY KEY (invoice_num);


-- 10. Thực hiện định nghĩa các khoá ngoại

ALTER TABLE movies
ADD CONSTRAINT fk_movie FOREIGN KEY (category_num)
REFERENCES categories(category_num);

ALTER TABLE rentals
ADD CONSTRAINT fk_rental FOREIGN KEY (cust_num)
REFERENCES customers(cust_num);

ALTER TABLE rental_details
ADD CONSTRAINT fk_detail_invoice FOREIGN KEY (invoice_num)
REFERENCES rentals(invoice_num)
ON DELETE CASCADE;

ALTER TABLE rental_details
ADD CONSTRAINT fk_detail_movie FOREIGN KEY (movie_num)
REFERENCES movies(movie_num);


-- 11. Mở lại Diagram có tên Movie, xem khóa chính, mối quan hệ giữa các bảng.


-- 12. Thực hiện định nghĩa các giá trị mặc định

ALTER TABLE movies
ADD CONSTRAINT dk_movie_date_purch DEFAULT GETDATE() FOR date_purch;
EXEC sp_helpconstraint 'movies';

ALTER TABLE customers
ADD CONSTRAINT dk_customer_join_date DEFAULT GETDATE() FOR join_date;
EXEC sp_helpconstraint 'customers';

ALTER TABLE rentals
ADD CONSTRAINT dk_rental_rental_date DEFAULT GETDATE() FOR rental_date;
EXEC sp_helpconstraint 'rentals';

ALTER TABLE rentals
ADD CONSTRAINT dk_rental_due_date DEFAULT DATEADD(DAY, 2, GETDATE()) FOR due_date;
EXEC sp_helpconstraint 'rentals';

-- 13. Thực hiện định nghĩa các ràng buộc

ALTER TABLE movies
ADD CONSTRAINT ck_movie CHECK (rating IN ('G', 'PG', 'R', 'NC-17', 'NR'));
EXEC sp_helpconstraint 'movies';

ALTER TABLE rentals
ADD CONSTRAINT ck_rental CHECK (due_date >= rental_date);
EXEC sp_helpconstraint 'rentals';


-- 14. Thực hiện phát sinh tập tin script cho các đối tượng trong CSDL Movie. Tên của tập tin là ConstraintsMovies.sql. Với lựa chọn Script Primary Keys, Foreign Keys, Default, and Check Constraints.
