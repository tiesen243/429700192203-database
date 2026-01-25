/*
Họ tên: Trần Tiến
MSSV: 22653991

Bài tập tuần 3 - Quản lý Dự án
*/

USE master;
DROP DATABASE qlduan;

CREATE DATABASE qlduan
ON (
  NAME = qlduan_data,
  FILENAME = '/var/opt/mssql/data/qlduan_data.mdf',
  SIZE = 20MB,
  MAXSIZE = 40MB,
  FILEGROWTH = 1MB
)
LOG ON (
  NAME = qlduan_log,
  FILENAME = '/var/opt/mssql/data/qlduan_log.ldf',
  SIZE = 6MB,
  MAXSIZE = 8MB,
  FILEGROWTH = 1MB
);

USE qlduan;

-- Tạo bảng

CREATE TABLE phong_ban
(
  ma_pb INT PRIMARY KEY,
  ma_truong_phong INT NOT NULL,
  ten_pb NVARCHAR(100) NOT NULL,
);

CREATE TABLE nhan_vien
(
  ma_nv INT PRIMARY KEY,
  ma_pb INT,
  nhom_truong INT,
  ho_ten NVARCHAR(100) NOT NULL,
  phai SMALLINT CHECK (phai IN (0, 1)),
  ngay_sinh DATE
);

CREATE TABLE du_an
(
  ma_da INT PRIMARY KEY,
  ten_da NVARCHAR(100) NOT NULL,
);

CREATE TABLE cong_viec
(
  ma_cv INT PRIMARY KEY,
  ten_cv NVARCHAR(100) NOT NULL,
);

CREATE TABLE nhan_vien_du_an
(
  ma_nv INT NOT NULL,
  ma_da INT NOT NULL,
  ma_cv INT NOT NULL,
  thoi_gian DATE NOT NULL,
);

-- Thiết lập khóa ngoại

ALTER TABLE phong_ban
ADD CONSTRAINT phong_ban_ma_truong_phong_fk FOREIGN KEY (ma_truong_phong)
REFERENCES nhan_vien(ma_nv);

ALTER TABLE nhan_vien
ADD CONSTRAINT nhan_vien_ma_pb_fk FOREIGN KEY (ma_pb)
REFERENCES phong_ban(ma_pb);

ALTER TABLE nhan_vien
ADD CONSTRAINT nhan_vien_nhom_truong_fk FOREIGN KEY (nhom_truong)
REFERENCES nhan_vien(ma_nv);

ALTER TABLE nhan_vien_du_an
ADD CONSTRAINT nhan_vien_du_an_ma_nv_fk FOREIGN KEY (ma_nv)
REFERENCES nhan_vien(ma_nv);

ALTER TABLE nhan_vien_du_an
ADD CONSTRAINT nhan_vien_du_an_ma_da_fk FOREIGN KEY (ma_da)
REFERENCES du_an(ma_da);

ALTER TABLE nhan_vien_du_an
ADD CONSTRAINT nhan_vien_du_an_ma_cv_fk FOREIGN KEY (ma_cv)
REFERENCES cong_viec(ma_cv);

-- Nhập dữ liệu mẫu

INSERT INTO nhan_vien
  (ma_nv, ho_ten)
VALUES
  (1, 'Nguyễn Năm');

INSERT INTO phong_ban
  (ma_pb, ma_truong_phong, ten_pb)
VALUES
  (1, 1, 'Triển khai & bảo trì');

UPDATE nhan_vien
SET ma_pb = 1
WHERE ma_nv = 1;

INSERT INTO nhan_vien
  (ma_nv, ma_pb, nhom_truong, ho_ten)
VALUES
  (2, 1, NULL, 'An'),
  (3, 1, 2, 'Minh'),
  (4, 1, 2, 'Tuấn'),
  (5, 1, NULL, 'Lan'),
  (6, 1, 5, 'Hùng'),
  (7, 1, 5, 'Vân'),
  (8, 1, NULL, 'Mai'),
  (9, 1, 8, 'Hà'),
  (10, 1, 8, 'Việt');

INSERT INTO du_an
  (ma_da, ten_da)
VALUES
  (1, 'Alpha B1 SAP'),
  (2, 'Delta B1 SAP');

INSERT INTO cong_viec
  (ma_cv, ten_cv)
VALUES
  (1, 'triển khai vòng 1'),
  (2, 'triển khai tổng thể');

INSERT INTO nhan_vien_du_an
  (ma_nv, ma_da, ma_cv, thoi_gian)
VALUES
  (2, 1, 1, '2026-01-25'),
  (2, 2, 2, '2026-02-10');
