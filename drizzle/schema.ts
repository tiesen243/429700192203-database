import { sql } from 'drizzle-orm'
import {
  mssqlTable,
  int,
  nvarchar,
  customType,
  char,
  datetime,
  smallint,
  foreignKey,
  primaryKey,
  check,
} from 'drizzle-orm/mssql-core'

export const ctHoaDon = mssqlTable(
  'ct_hoa_don',
  {
    maHd: int('ma_hd')
      .notNull()
      .references(() => hoaDon.maHd),
    maSp: int('ma_sp')
      .notNull()
      .references(() => sanPham.maSp),
    soLuong: smallint('so_luong'),
    donGia: customType({ dataType: () => 'money' })('don_gia').default(
      sql`null`,
    ),
    chietKhau: customType({ dataType: () => 'money' })('chiet_khau').default(
      sql`null`,
    ),
  },
  (table) => [
    primaryKey({ columns: [table.maHd, table.maSp], name: 'ct_hoa_don_pk' }),
    check('ct_hoa_don_chiet_khau_ck', sql`([chiet_khau]>=(0))`),
    check('ct_hoa_don_so_luong_ck', sql`([so_luong]>(0))`),
  ],
)

export const hoaDon = mssqlTable(
  'hoa_don',
  {
    maHd: int('ma_hd').identity({ seed: 1, increment: 1 }),
    maKh: char('ma_kh', { length: 5 }).references(() => khachHang.maKh),
    ngayLapHd: datetime('ngay_lap_hd', { mode: 'string' }).defaultGetDate(),
    ngayGiao: datetime('ngay_giao', { mode: 'string' }),
    noiChuyen: nvarchar('noi_chuyen', { length: 60 }).notNull(),
    loaiHd: char('loai_hd', { length: 1 }).default('N'),
  },
  (table) => [
    primaryKey({ columns: [table.maHd], name: 'hoa_don_pk' }),
    check(
      'hoa_don_loai_hd_ck',
      sql`([loai_hd]='T' OR [loai_hd]='C' OR [loai_hd]='X' OR [loai_hd]='N')`,
    ),
    check('hoa_don_ngay_giao_ck', sql`([ngay_giao]>=[ngay_lap_hd])`),
    check('hoa_don_ngay_lap_hd_ck', sql`([ngay_lap_hd]>=getdate())`),
  ],
)

export const khachHang = mssqlTable(
  'khach_hang',
  {
    maKh: char('ma_kh', { length: 5 }),
    tenKh: nvarchar('ten_kh', { length: 40 }).notNull(),
    loaiKh: nvarchar('loai_kh', { length: 3 }),
    diaChi: nvarchar('dia_chi', { length: 60 }),
    phone: nvarchar({ length: 24 }),
    dcMail: nvarchar('dc_mail', { length: 50 }),
    diemTl: int('diem_tl'),
  },
  (table) => [
    primaryKey({ columns: [table.maKh], name: 'khach_hang_pk' }),
    check('khach_hang_diem_tl_ck', sql`([diem_tl]>=(0))`),
    check(
      'khach_hang_loai_kh_ck',
      sql`([loai_kh]='VL' OR [loai_kh]='TV' OR [loai_kh]='VIP')`,
    ),
  ],
)

export const nhaCungCap = mssqlTable(
  'nha_cung_cap',
  {
    maNcc: int('ma_ncc').identity({ seed: 1, increment: 1 }),
    tenNcc: nvarchar('ten_ncc', { length: 40 }).notNull(),
    diaChi: nvarchar('dia_chi', { length: 60 }),
    phone: nvarchar({ length: 24 }),
    soFax: nvarchar('so_fax', { length: 24 }),
    dcMail: nvarchar('dc_mail', { length: 50 }),
  },
  (table) => [primaryKey({ columns: [table.maNcc], name: 'nha_cung_cap_pk' })],
)

export const nhomSanPham = mssqlTable(
  'nhom_san_pham',
  {
    maNhom: int('ma_nhom').identity({ seed: 1, increment: 1 }),
    tenNhom: nvarchar('ten_nhom', { length: 15 }),
  },
  (table) => [
    primaryKey({ columns: [table.maNhom], name: 'nhom_san_pham_pk' }),
  ],
)

export const sanPham = mssqlTable(
  'san_pham',
  {
    maSp: int('ma_sp').identity({ seed: 1, increment: 1 }),
    maNcc: int('ma_ncc').references(() => nhaCungCap.maNcc),
    maNhom: int('ma_nhom').references(() => nhomSanPham.maNhom),
    tenSp: nvarchar('ten_sp', { length: 40 }).notNull(),
    moTa: nvarchar('mo_ta', { length: 50 }),
    donViTinh: nvarchar('don_vi_tinh', { length: 20 }),
    giaGoc: customType({ dataType: () => 'money' })('gia_goc').default(
      sql`null`,
    ),
    slTon: int('sl_ton'),
  },
  (table) => [
    primaryKey({ columns: [table.maSp], name: 'san_pham_pk' }),
    check('san_pham_gia_goc_ck', sql`([gia_goc]>(0))`),
    check('san_pham_sl_ton_ck', sql`([sl_ton]>=(0))`),
  ],
)
