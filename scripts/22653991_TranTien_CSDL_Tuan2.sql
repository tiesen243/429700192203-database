/*
Họ tên: Trần Tiến
MSSV: 22653991

Bài tập tuần 2
*/

/*
1. Dựa vào mô tả, xây dựng mô hình thực thể kết hợp ERD, sau đó xây dựng
lược đồ cơ sở dữ liệu và xác định các ràng buộc khóa chính và khóa ngoại.

Trả lời:

- Mô hình thực thể kết hợp ERD:
  * Một Nhóm sản phẩm có nhiều Sản phẩm.
  * Một Nhà cung cấp cung cấp nhiều Sản phẩm.
  * Một Khách hàng có thể có nhiều Hóa đơn.
  * Một Hóa đơn được lập cho duy nhất một Khách hàng.
  * Một Hóa đơn có nhiều chi tiết trong Chi tiết hóa đơn.
  * Một Sản phẩm có thể xuất hiện trong nhiều Chi tiết hóa đơn.

- Khóa chính:
  * Nhóm sản phẩm: ma_nhom
  * Sản phẩm: ma_sp
  * Nhà cung cấp: ma_ncc
  * Khách hàng: ma_kh
  * Hóa đơn: ma_hd
  * Chi tiết hóa đơn: (ma_hd, ma_sp)

- Khóa ngoại:
  * Bảng san_pham:
      * ma_ncc tham chiếu đến nha_cung_cap(ma_ncc)
      * ma_nhom tham chiếu đến nhom_san_pham(ma_nhom)
  * Bảng hoa_don:
      * ma_kh tham chiếu đến khach_hang(ma_kh)
  * Bảng ct_hoa_don:
      * ma_hd tham chiếu đến hoa_don(ma_hd)
      * ma_sp tham chiếu đến san_pham(ma_sp)
*/

/*
2. Xác định các qui tắc nghiệp vụ của hệ thống trên.

Trả lời:

* Quy tắc về Sản phẩm và Phân loại:
  1. Mỗi sản phẩm phải thuộc về một và chỉ một nhóm sản phẩm.
  2. Một nhóm sản phẩm có thể có nhiều sản phẩm.
  3. Mỗi sản phẩm phải được cung cấp bởi một và chỉ một nhà cung cấp.
  4. Giá gốc (gia_goc) của sản phẩm phải là một số dương (> 0).
  5. Số lượng tồn kho (sl_ton) của sản phẩm không được là số âm (>= 0).

* Quy tắc về Hóa đơn và Bán hàng:
  1. Ngày giao hàng (ngay_giao) phải sau hoặc bằng ngày lập hóa đơn (ngay_lap_hd).
  2. Ngày lập hóa đơn mặc định là ngày giờ hiện tại của hệ thống.
  3. Mỗi hóa đơn phải được liên kết với một khách hàng.
  4. Loại hóa đơn (loai_hd) phải là một trong các ký tự: 'N' (Nhập), 'X' (Xuất), 'C' (Chuyển), 'T' (Trả). Mặc định là 'N'.

* Quy tắc về Chi tiết hóa đơn:
  1. Số lượng sản phẩm (so_luong) trong một chi tiết hóa đơn phải lớn hơn 0.
  2. Chiết khấu (chiet_khau) không được là số âm (>= 0).

* Quy tắc về Khách hàng:
  1. Loại khách hàng (loai_kh) phải là một trong các giá trị: 'VIP', 'TV' (Thành viên), hoặc 'VL' (Vãng lai).
  2. Điểm tích lũy (diem_tl) của khách hàng không được là số âm (>= 0).
*/

-- 3. Tạo database và các bảng --

USE master;
DROP DATABASE qlbh

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
CREATE TABLE nhom_san_pham (
  ma_nhom INT NOT NULL IDENTITY,
  ten_nhom NVARCHAR(15)
);

-- Bảng sản phẩm
CREATE TABLE san_pham (
  ma_sp INT NOT NULL IDENTITY,
  ma_ncc INT,
  ma_nhom INT,
  ten_sp NVARCHAR(40) NOT NULL,
  mo_ta NVARCHAR(50),
  don_vi_tinh NVARCHAR(20),
  gia_goc MONEY,
  sl_ton INT
);

-- Bảng hóa đơn
CREATE TABLE hoa_don (
  ma_hd INT NOT NULL IDENTITY,
  ma_kh CHAR(5),
  ngay_lap_hd DATETIME,
  ngay_giao DATETIME,
  noi_chuyen NVARCHAR(60) NOT NULL
);

-- Bảng chi tiết hóa đơn
CREATE TABLE ct_hoa_don (
  ma_hd INT NOT NULL,
  ma_sp INT NOT NULL,
  so_luong SMALLINT,
  don_gia MONEY,
  chiet_khau MONEY
);

-- Bảng nhà cung cấp
CREATE TABLE nha_cung_cap (
  ma_ncc INT NOT NULL IDENTITY,
  ten_ncc NVARCHAR(40) NOT NULL,
  dia_chi NVARCHAR(60),
  phone NVARCHAR(24),
  so_fax NVARCHAR(24),
  dc_mail NVARCHAR(50)
);

-- Bảng khách hàng
CREATE TABLE khach_hang (
  ma_kh CHAR(5) NOT NULL,
  ten_kh NVARCHAR(40) NOT NULL,
  loai_kh NVARCHAR(3),
  dia_chi NVARCHAR(60),
  phone NVARCHAR(24),
  dc_mail NVARCHAR(50),
  diem_tl INT
);

-- Thêm ràng buộc khóa chính --

-- Bảng nhóm sản phẩm
ALTER TABLE nhom_san_pham
ADD CONSTRAINT nhom_san_pham_pk PRIMARY KEY (ma_nhom);

-- Bảng sản phẩm
ALTER TABLE san_pham
ADD CONSTRAINT san_pham_pk PRIMARY KEY (ma_sp);

-- Bảng hóa đơn
ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_pk PRIMARY KEY (ma_hd);

-- Bảng chi tiết hóa đơn
ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_pk PRIMARY KEY (ma_hd, ma_sp);

-- Bảng nhà cung cấp
ALTER TABLE nha_cung_cap
ADD CONSTRAINT nha_cung_cap_pk PRIMARY KEY (ma_ncc);

-- Bảng khách hàng
ALTER TABLE khach_hang
ADD CONSTRAINT khach_hang_pk PRIMARY KEY (ma_kh);

-- Thêm ràng buộc khóa ngoại --

-- Bảng sản phẩm

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_ma_ncc_fk FOREIGN KEY (ma_ncc)
REFERENCES nha_cung_cap (ma_ncc);

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_ma_nhom_fk FOREIGN KEY (ma_nhom)
REFERENCES nhom_san_pham (ma_nhom);

-- Bảng hóa đơn

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ma_kh_fk FOREIGN KEY (ma_kh)
REFERENCES khach_hang (ma_kh);

-- Bảng chi tiết hóa đơn

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_ma_hd_fk FOREIGN KEY (ma_hd)
REFERENCES hoa_don (ma_hd);

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_ma_sp_fk FOREIGN KEY (ma_sp)
REFERENCES san_pham (ma_sp);

-- Thêm ràng buộc kiểm tra và giá trị mặc định --

-- Bảng sản phẩm

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_gia_goc_ck CHECK (gia_goc > 0);

ALTER TABLE san_pham
ADD CONSTRAINT san_pham_sl_ton_ck CHECK (sl_ton >= 0);

-- Bảng hóa đơn

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ngay_lap_hd_df DEFAULT GETDATE() FOR ngay_lap_hd;

ALTER TABLE hoa_don
ADD CONSTRAINT hoa_don_ngay_lap_hd_ck CHECK (ngay_lap_hd >= GETDATE());

-- Bảng chi tiết hóa đơn

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_so_luong_ck CHECK (so_luong > 0);

ALTER TABLE ct_hoa_don
ADD CONSTRAINT ct_hoa_don_chiet_khau_ck CHECK (chiet_khau >= 0);

-- Bảng khách hàng

ALTER TABLE khach_hang
ADD CONSTRAINT khach_hang_loai_kh_ck CHECK (loai_kh IN ('VIP', 'TV', 'VL'));

ALTER TABLE khach_hang
ADD CONSTRAINT khach_hang_diem_tl_ck CHECK (diem_tl >= 0);

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

/*
5. Tạo diagram cho CSDL QLBH? Khóa chính và khóa ngoại giữa các
table được biểu diễn trên Diagram, hãy quan sát và nhận diện?

Trả lời:

* nha_cung_cap và san_pham:
    * Một đường nối từ cột ma_ncc của bảng san_pham đến cột ma_ncc của bảng nha_cung_cap.
    * Ý nghĩa: Một nhà cung cấp có thể cung cấp nhiều sản phẩm.
* nhom_san_pham và san_pham:
    * Một đường nối từ cột ma_nhom của bảng san_pham đến cột ma_nhom của bảng nhom_san_pham.
    * Ý nghĩa: Một nhóm sản phẩm có thể có nhiều sản phẩm.
* khach_hang và hoa_don:
    * Một đường nối từ cột ma_kh của bảng hoa_don đến cột ma_kh của bảng khach_hang.
    * Ý nghĩa: Một khách hàng có thể có nhiều hóa đơn.
* hoa_don và ct_hoa_don:
    * Một đường nối từ cột ma_hd của bảng ct_hoa_don đến cột ma_hd của bảng hoa_don.
    * Ý nghĩa: Một hóa đơn có nhiều dòng chi tiết hóa đơn.
* san_pham và ct_hoa_don:
    * Một đường nối từ cột ma_sp của bảng ct_hoa_don đến cột ma_sp của bảng san_pham.
    * Ý nghĩa: Một sản phẩm có thể xuất hiện trong nhiều chi tiết hóa đơn khác nhau.
*/

/*
6. Thực hiện phát sinh tập tin script cho toàn bộ CSDL QLBH. Đọc hiểu
các lệnh trong file script. Lưu lại file script.
*/

