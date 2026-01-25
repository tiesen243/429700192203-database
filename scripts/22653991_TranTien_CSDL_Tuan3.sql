/*
Họ tên: Trần Tiến
MSSV: 22653991

Bài tập tuần 3 - Quản lý bán hàng
*/

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

-- Bảng nhóm sản phẩm
CREATE TABLE nhom_san_pham
(
  ma_nhom INT NOT NULL IDENTITY PRIMARY KEY,
  ten_nhom NVARCHAR(15)
);

-- Bảng nhà cung cấp
CREATE TABLE nha_cung_cap
(
  ma_ncc INT NOT NULL IDENTITY PRIMARY KEY,
  ten_ncc NVARCHAR(40) NOT NULL,
  dia_chi NVARCHAR(60),
  phone NVARCHAR(24),
  so_fax NVARCHAR(24),
  dc_mail NVARCHAR(50)
);

-- Bảng sản phẩm
CREATE TABLE san_pham
(
  ma_sp INT NOT NULL IDENTITY PRIMARY KEY,
  ma_ncc INT REFERENCES nha_cung_cap(ma_ncc),
  ma_nhom INT REFERENCES nhom_san_pham(ma_nhom),
  ten_sp NVARCHAR(40) NOT NULL,
  mo_ta NVARCHAR(50),
  don_vi_tinh NVARCHAR(20),
  gia_goc MONEY CHECK (gia_goc > 0),
  sl_ton INT CHECK (sl_ton >= 0)
);

-- Bảng khách hàng
CREATE TABLE khach_hang
(
  ma_kh CHAR(5) PRIMARY KEY,
  ten_kh NVARCHAR(40) NOT NULL,
  loai_kh NVARCHAR(3) CHECK (loai_kh IN ('VIP', 'TV', 'VL')),
  dia_chi NVARCHAR(60),
  phone NVARCHAR(24),
  dc_mail NVARCHAR(50),
  diem_tl INT CHECK (diem_tl >= 0)
);

-- Bảng hóa đơn
CREATE TABLE hoa_don
(
  ma_hd INT NOT NULL IDENTITY PRIMARY KEY,
  ma_kh CHAR(5) REFERENCES khach_hang(ma_kh),
  ngay_lap_hd DATETIME DEFAULT GETDATE() CHECK (ngay_lap_hd >= GETDATE()),
  ngay_giao DATETIME,
  noi_chuyen NVARCHAR(60) NOT NULL
);

-- Bảng chi tiết hóa đơn
CREATE TABLE ct_hoa_don
(
  ma_hd INT NOT NULL REFERENCES hoa_don(ma_hd),
  ma_sp INT NOT NULL REFERENCES san_pham(ma_sp),
  so_luong SMALLINT CHECK (so_luong > 0),
  don_gia MONEY,
  chiet_khau MONEY CHECK (chiet_khau >= 0),

  CONSTRAINT ct_hoa_don_pk PRIMARY KEY (ma_hd, ma_sp)
);

-- 4. Viết lệnh thực hiện --

-- a. Thêm cột LoaiHD vào bảng HoaDon

ALTER TABLE hoa_don
ADD loai_hd CHAR(1);

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_loai_hd_ck CHECK (loai_hd IN ('N', 'X', 'C', 'T'));

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_loai_hd_df DEFAULT 'N' FOR loai_hd;

-- b. Tạo thêm ràng buộc trên bảng HoaDon: ngay_giao >= ngay_lap_hd

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ngay_giao_ck CHECK (ngay_giao >= ngay_lap_hd);