CREATE DATABASE QuanLyKhoThuocBV;
USE QuanLyKhoThuocBV;

-- Bảng quản lý thông tin thuốc
CREATE TABLE Thuoc (
    MaThuoc NVARCHAR(10) PRIMARY KEY,
    TenThuoc NVARCHAR(255) NOT NULL,
    HoatChat NVARCHAR(255),
    DangBaoChe NVARCHAR(100),
    DonViTinh NVARCHAR(50),
    GiaNhap DECIMAL(10,2) CHECK (GiaNhap >= 0),
    GiaBan DECIMAL(10,2) ,
    HanSuDung DATE,
    GhiChu NVARCHAR(MAX)
);
-- Thêm ràng buộc CHECK
ALTER TABLE Thuoc ADD CONSTRAINT CK_GiaBan CHECK (GiaBan >= GiaNhap);

INSERT INTO Thuoc (MaThuoc, TenThuoc, HoatChat, DangBaoChe, DonViTinh, GiaNhap, GiaBan, HanSuDung, GhiChu) VALUES
(N'T001', N'Paracetamol', N'Paracetamol 500mg', N'Viên nén', N'Hộp', 5000, 10000, '2026-12-31', N'Thuốc giảm đau, hạ sốt'),
(N'T002', N'Ibuprofen', N'Ibuprofen 200mg', N'Viên nén', N'Hộp', 7000, 14000, '2026-11-30', N'Giảm đau, chống viêm'),
(N'T003', N'Amoxicillin', N'Amoxicillin 500mg', N'Viên nang', N'Hộp', 8000, 16000, '2026-10-30', N'Kháng sinh'),
(N'T004', N'Cefuroxime', N'Cefuroxime 250mg', N'Viên nén', N'Hộp', 15000, 30000, '2026-09-30', N'Kháng sinh'),
(N'T005', N'Metformin', N'Metformin 500mg', N'Viên nén', N'Hộp', 10000, 20000, '2027-01-15', N'Điều trị tiểu đường'),
(N'T006', N'Atorvastatin', N'Atorvastatin 10mg', N'Viên nén', N'Hộp', 20000, 40000, '2026-08-15', N'Giảm cholesterol'),
(N'T007', N'Losartan', N'Losartan 50mg', N'Viên nén', N'Hộp', 12000, 24000, '2026-07-20', N'Huyết áp'),
(N'T008', N'Omeprazole', N'Omeprazole 20mg', N'Viên nang', N'Hộp', 9000, 18000, '2026-06-30', N'Dạ dày'),
(N'T009', N'Aspirin', N'Aspirin 81mg', N'Viên nén', N'Hộp', 3000, 6000, '2027-05-30', N'Giảm đau, chống đông'),
(N'T010', N'Diazepam', N'Diazepam 5mg', N'Viên nén', N'Hộp', 8000, 16000, '2026-12-10', N'An thần'),
(N'T011', N'Furosemide', N'Furosemide 40mg', N'Viên nén', N'Hộp', 5000, 10000, '2026-09-25', N'Lợi tiểu'),
(N'T012', N'Hydrochlorothiazide', N'Hydrochlorothiazide 25mg', N'Viên nén', N'Hộp', 6000, 12000, '2026-08-30', N'Huyết áp'),
(N'T013', N'Simvastatin', N'Simvastatin 20mg', N'Viên nén', N'Hộp', 11000, 22000, '2026-07-10', N'Cholesterol'),
(N'T014', N'Clopidogrel', N'Clopidogrel 75mg', N'Viên nén', N'Hộp', 15000, 30000, '2027-02-28', N'Chống đông máu'),
(N'T015', N'Nifedipine', N'Nifedipine 10mg', N'Viên nang', N'Hộp', 7000, 14000, '2027-03-15', N'Huyết áp'),
(N'T016', N'Levothyroxine', N'Levothyroxine 50mcg', N'Viên nén', N'Hộp', 13000, 26000, '2027-04-20', N'Tuyến giáp'),
(N'T017', N'Warfarin', N'Warfarin 5mg', N'Viên nén', N'Hộp', 17000, 34000, '2027-06-10', N'Chống đông máu'),
(N'T018', N'Digoxin', N'Digoxin 0.25mg', N'Viên nén', N'Hộp', 19000, 38000, '2026-10-05', N'Tim mạch'),
(N'T019', N'Alprazolam', N'Alprazolam 0.5mg', N'Viên nén', N'Hộp', 14000, 28000, '2027-08-12', N'An thần'),
(N'T020', N'Metoprolol', N'Metoprolol 50mg', N'Viên nén', N'Hộp', 12000, 24000, '2027-09-15', N'Tim mạch'),
(N'T021', N'Ranitidine', N'Ranitidine 150mg', N'Viên nén', N'Hộp', 9000, 18000, '2026-11-22', N'Dạ dày');
SELECT * FROM Thuoc; 

-- Bảng quản lý nhà cung cấp thuốc
CREATE TABLE NhaCungCap (
    MaNCC NVARCHAR(10) PRIMARY KEY,
    TenNCC NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE
);
INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChi, SoDienThoai, Email) VALUES
(N'NCC001', N'Dược Phẩm Trung Nam', N'Hà Nội', N'0987654321', N'trungnam@gmail.com'),
(N'NCC002', N'An Phát Pharma', N'TPHCM', N'0977654322', N'anphatpharma@gmail.com'),
(N'NCC003', N'Hoàng Long Dược', N'Đà Nẵng', N'0967654323', N'hoanglongduoc@gmail.com'),
(N'NCC004', N'Minh Tâm Dược', N'Hải Phòng', N'0957654324', N'minhtamduoc@gmail.com'),
(N'NCC005', N'Vạn Phúc Pharma', N'Cần Thơ', N'0947654325', N'vanphucpharma@gmail.com'),
(N'NCC006', N'Đông Á Dược', N'Hà Nội', N'0937654326', N'dongaduoc@gmail.com'),
(N'NCC007', N'Trường An Pharma', N'TPHCM', N'0927654327', N'truonganpharma@gmail.com'),
(N'NCC008', N'Ngọc Bảo Dược', N'Đà Nẵng', N'0917654328', N'ngocbaoduoc@gmail.com'),
(N'NCC009', N'Nam Việt Pharma', N'Hải Phòng', N'0907654329', N'namvietpharma@gmail.com'),
(N'NCC010', N'Hoàn Mỹ Dược', N'Cần Thơ', N'0897654330', N'hoanmyduoc@gmail.com'),
(N'NCC011', N'Thịnh Vượng Pharma', N'Hà Nội', N'0887654331', N'thinhvuongpharma@gmail.com'),
(N'NCC012', N'Phúc An Dược', N'TPHCM', N'0877654332', N'phucanduoc@gmail.com'),
(N'NCC013', N'Bình Minh Pharma', N'Đà Nẵng', N'0867654333', N'binhminhpharma@gmail.com'),
(N'NCC014', N'Kim Ngân Dược', N'Hải Phòng', N'0857654334', N'kimnganduoc@gmail.com'),
(N'NCC015', N'Hòa Bình Pharma', N'Cần Thơ', N'0847654335', N'hoabinhpharma@gmail.com'),
(N'NCC016', N'An Khang Dược', N'Hà Nội', N'0837654336', N'ankhangduoc@gmail.com');
SELECT * FROM NhaCungCap;

-- Bảng nhập kho thuốc
CREATE TABLE NhapKho (
    MaNhap NVARCHAR(10) PRIMARY KEY,
    MaThuoc NVARCHAR(10) NOT NULL,
    MaNCC NVARCHAR(10) NOT NULL,
    SoLuong INT CHECK (SoLuong > 0),
    NgayNhap DATE NOT NULL,
    HanSuDung DATE,
    GiaNhap DECIMAL(10,2) CHECK (GiaNhap >= 0),
    FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);
INSERT INTO NhapKho (MaNhap, MaThuoc, MaNCC, SoLuong, NgayNhap, HanSuDung, GiaNhap) VALUES
(N'NK001', N'T001', N'NCC001', 100, '2025-02-01', '2026-12-31', 5000),
(N'NK002', N'T002', N'NCC002', 200, '2025-02-02', '2026-11-30', 7000),
(N'NK003', N'T003', N'NCC003', 150, '2025-02-03', '2026-10-30', 8000),
(N'NK004', N'T004', N'NCC004', 180, '2025-02-04', '2026-09-30', 15000),
(N'NK005', N'T005', N'NCC005', 120, '2025-02-05', '2027-01-15', 10000),
(N'NK006', N'T006', N'NCC006', 250, '2025-02-06', '2026-08-15', 20000),
(N'NK007', N'T007', N'NCC007', 300, '2025-02-07', '2026-07-20', 12000),
(N'NK008', N'T008', N'NCC008', 220, '2025-02-08', '2026-06-30', 9000),
(N'NK009', N'T009', N'NCC009', 170, '2025-02-09', '2027-05-30', 3000),
(N'NK010', N'T010', N'NCC010', 140, '2025-02-10', '2026-12-10', 8000),
(N'NK011', N'T011', N'NCC011', 160, '2025-02-11', '2026-09-25', 5000),
(N'NK012', N'T012', N'NCC012', 130, '2025-02-12', '2026-08-10', 11000),
(N'NK013', N'T013', N'NCC013', 210, '2025-02-13', '2026-07-15', 6000),
(N'NK014', N'T014', N'NCC014', 190, '2025-02-14', '2027-03-20', 7500),
(N'NK015', N'T015', N'NCC015', 175, '2025-02-15', '2026-10-05', 9500),
(N'NK016', N'T016', N'NCC016', 280, '2025-02-16', '2027-02-28', 12500);
SELECT * FROM NhapKho;

-- Bảng khoa/phòng sử dụng thuốc
CREATE TABLE KhoaPhong (
    MaKhoa NVARCHAR(10) PRIMARY KEY,
    TenKhoa NVARCHAR(255) NOT NULL
);
INSERT INTO KhoaPhong (MaKhoa, TenKhoa) VALUES
(N'K001', N'Khoa Nội'),
(N'K002', N'Khoa Ngoại'),
(N'K003', N'Khoa Nhi'),
(N'K004', N'Khoa Sản'),
(N'K005', N'Khoa Hồi sức cấp cứu'),
(N'K006', N'Khoa Truyền nhiễm'),
(N'K007', N'Khoa Thần kinh'),
(N'K008', N'Khoa Da liễu'),
(N'K009', N'Khoa Tim mạch'),
(N'K010', N'Khoa Mắt'),
(N'K011', N'Khoa Tai Mũi Họng'),
(N'K012', N'Khoa Chấn thương chỉnh hình'),
(N'K013', N'Khoa Răng Hàm Mặt'),
(N'K014', N'Khoa Ung bướu'),
(N'K015', N'Khoa Y học cổ truyền');
SELECT * FROM KhoaPhong;

-- Bảng xuất kho thuốc
CREATE TABLE XuatKho (
    MaXuat NVARCHAR(10) PRIMARY KEY,
    MaThuoc NVARCHAR(10) NOT NULL,
    MaKhoa NVARCHAR(10) NOT NULL,
    SoLuong INT CHECK (SoLuong > 0),
    NgayXuat DATE NOT NULL,
    FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc),
    FOREIGN KEY (MaKhoa) REFERENCES KhoaPhong(MaKhoa)
);
INSERT INTO XuatKho (MaXuat, MaThuoc, MaKhoa, SoLuong, NgayXuat) VALUES
(N'XK001', N'T001', N'K001', 50, '2025-02-10'),
(N'XK002', N'T002', N'K002', 80, '2025-02-11'),
(N'XK003', N'T003', N'K003', 60, '2025-02-12'),
(N'XK004', N'T004', N'K004', 90, '2025-02-13'),
(N'XK005', N'T005', N'K005', 70, '2025-02-14'),
(N'XK006', N'T006', N'K006', 100, '2025-02-15'),
(N'XK007', N'T007', N'K007', 85, '2025-02-16'),
(N'XK008', N'T008', N'K008', 75, '2025-02-17'),
(N'XK009', N'T009', N'K009', 95, '2025-02-18'),
(N'XK010', N'T010', N'K010', 65, '2025-02-19'),
(N'XK011', N'T011', N'K011', 55, '2025-02-20'),
(N'XK012', N'T005', N'K012', 78, '2025-02-21'),
(N'XK013', N'T003', N'K013', 82, '2025-02-22'),
(N'XK014', N'T007', N'K014', 60, '2025-02-23'),
(N'XK015', N'T009', N'K015', 90, '2025-02-24');
SELECT * FROM XuatKho;

-- Bảng kho lưu trữ thuốc
CREATE TABLE KhoLuuTru (
    MaKho NVARCHAR(10) PRIMARY KEY,
    MaThuoc NVARCHAR(10) NOT NULL,
    SoLuongTon INT CHECK (SoLuongTon >= 0),
    FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc)
);

INSERT INTO KhoLuuTru (MaKho, MaThuoc, SoLuongTon) VALUES
(N'KLT001', N'T001', 100),
(N'KLT002', N'T002', 120),
(N'KLT003', N'T003', 80),
(N'KLT004', N'T004', 90),
(N'KLT005', N'T005', 110),
(N'KLT006', N'T006', 130),
(N'KLT007', N'T007', 150),
(N'KLT008', N'T008', 70),
(N'KLT009', N'T009', 95),
(N'KLT010', N'T010', 105),
(N'KLT011', N'T011', 85),
(N'KLT012', N'T012', 115),
(N'KLT013', N'T013', 140),
(N'KLT014', N'T014', 125),
(N'KLT015', N'T015', 135),
(N'KLT016', N'T016', 160),
(N'KLT017', N'T017', 145),
(N'KLT018', N'T018', 155),
(N'KLT019', N'T019', 175),
(N'KLT020', N'T020', 165),
(N'KLT021', N'T021', 185);
SELECT * FROM KhoLuuTru;

-- Bảng nhân viên quản lý kho thuốc
CREATE TABLE NhanVien (
    MaNV NVARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    ChucVu NVARCHAR(100),
    SoDienThoai NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE
);
INSERT INTO NhanVien (MaNV, HoTen, ChucVu, SoDienThoai, Email) VALUES
(N'NV001', N'Nguyễn Văn Hưng', N'Quản lý kho', N'0912345678', N'hungnv@gmail.com'),
(N'NV002', N'Trần Thị Lan', N'Nhân viên kho', N'0923456789', N'lantran@gmail.com'),
(N'NV003', N'Lê Văn Minh', N'Nhân viên kho', N'0934567890', N'minhle@gmail.com'),
(N'NV004', N'Phạm Thị Hương', N'Nhân viên kho', N'0945678901', N'huongpham@gmail.com'),
(N'NV005', N'Hoàng Văn Đức', N'Nhân viên kho', N'0956789012', N'duchoang@gmail.com'),
(N'NV006', N'Bùi Thị Mai', N'Nhân viên kho', N'0967890123', N'maibui@gmail.com'),
(N'NV007', N'Ngô Văn Phát', N'Nhân viên kho', N'0978901234', N'phatngo@gmail.com'),
(N'NV008', N'Doãn Thị Hạnh', N'Nhân viên kho', N'0989012345', N'hanhdoan@gmail.com'),
(N'NV009', N'Tạ Văn Long', N'Nhân viên kho', N'0990123456', N'longta@gmail.com'),
(N'NV010', N'Vũ Thị Hoa', N'Nhân viên kho', N'0901234567', N'hoavu@gmail.com'),
(N'NV011', N'Đặng Văn Sơn', N'Nhân viên kho', N'0892345678', N'sondang@gmail.com'),
(N'NV012', N'Phan Thị Ngọc', N'Nhân viên kho', N'0883456789', N'ngocphan@gmail.com'),
(N'NV013', N'Trương Minh Quân', N'Nhân viên kho', N'0874567890', N'quantruong@gmail.com'),
(N'NV014', N'Đinh Thị Thanh', N'Nhân viên kho', N'0865678901', N'thanhdinh@gmail.com'),
(N'NV015', N'Lâm Văn Hải', N'Nhân viên kho', N'0856789012', N'hailam@gmail.com');
SELECT * FROM NhanVien;