/*
Họ tên: Trần Tiến
MSSV: 22653991

Bài tập tuần 1
*/


-- a. Tao CSDL

USE master;
DROP DATABASE qlbh;

CREATE DATABASE qlbh
ON (
  NAME = qlbh_data,
  FILENAME = '/var/opt/mssql/data/qlbh_data.mdf',
  SIZE = 20MB,
  MAXSIZE = 40MB,
  FILEGROWTH = 1MB
)
LOG ON (
  NAME = qlbh_log,
  FILENAME = '/var/opt/mssql/data/qlbh_log.ldf',
  SIZE = 6MB,
  MAXSIZE = 8MB,
  FILEGROWTH = 1MB
);

USE qlbh;

-- b. Xem thuoc tinh cua CSDL
EXEC sp_helpdb qlbh;
EXEC sp_spaceused;
EXEC sp_helpfile;

-- c. Them 1 filegroup
ALTER DATABASE qlbh ADD FILEGROUP du_lieu_qlbh;

-- d. Them secondary data file
ALTER DATABASE qlbh ADD FILE (
  NAME = qlbh_data_2,
  FILENAME = '/var/opt/mssql/data/qlbh_data_2.ndf',
  SIZE = 10MB,
  MAXSIZE = 20MB,
  FILEGROWTH = 1MB
) TO FILEGROUP du_lieu_qlbh;

-- e. Xem filegroup da co
EXEC sp_helpfilegroup;

-- f. Cau hinh Read Only
ALTER DATABASE qlbh SET READ_ONLY;
ALTER DATABASE qlbh SET READ_WRITE;

EXEC sp_helpdb qlbh;

-- g. Tang size
ALTER DATABASE qlbh MODIFY FILE (
  NAME = qlbh_data,
  SIZE = 50MB
);

ALTER DATABASE qlbh MODIFY FILE (
  NAME = qlbh_log,
  SIZE = 10MB
);

EXEC sp_helpdb qlbh;

/* 
Để thay đổi SIZE của các tập tin bằng công cụ Design bạn làm như thế
nào? Bạn hãy thực hiện thay đổi kích thước của tập tin QLBH_log với
kích thước là 15MB. Nếu thay đổi kích cỡ nhỏ hơn ban đầu có được
không? Nếu thay đổi kích cỡ MAXSIZE nhỏ hơn kích cỡ SIZE thì có
được không? Giải thích.

Trả lời:
- Để thay đổi SIZE bằng công cụ Design:
  1. Chuột phải vào CSDL `qlbh` và chọn `Properties`.
  2. Chọn trang `Files`.
  3. Trong lưới `Database files`, tìm đến file `qlbh_log`.
  4. Thay đổi giá trị trong cột `Initial Size (MB)` thành 15.
  5. Nhấn `OK`.
- Nếu thay đổi kích cỡ nhỏ hơn ban đầu có được không?
  Không thể giảm kích thước file nhỏ hơn kích thước dữ liệu hiện có trong file đó.
  Hệ thống sẽ báo lỗi. Bạn chỉ có thể giảm kích thước file về mức tối thiểu cần thiết
  để chứa dữ liệu hiện tại (bằng cách sử dụng DBCC SHRINKFILE).
- Nếu thay đổi kích cỡ MAXSIZE nhỏ hơn kích cỡ SIZE thì có được không? Giải thích.
  Không được. Hệ thống sẽ báo lỗi. MAXSIZE là giới hạn kích thước tối đa mà file
  có thể phát triển đến, vì vậy nó phải luôn lớn hơn hoặc bằng kích thước hiện tại (SIZE).
*/
