--I. In các bảng
SELECT * FROM Thuoc; 
SELECT * FROM NhaCungCap;
SELECT * FROM NhapKho;
SELECT * FROM KhoaPhong;
SELECT * FROM XuatKho;
SELECT * FROM KhoLuuTru;
SELECT * FROM NhanVien;

--II. View
--2.1. Danh sách thuốc còn hạn sử dụng
CREATE VIEW View_ThuocConHan AS
SELECT * 
FROM Thuoc 
WHERE HanSuDung > GETDATE();
--Sử dụng
SELECT * FROM View_ThuocConHan;
--Xóa
DROP VIEW View_ThuocConHan;

--2.2. Danh sách thuốc sắp hết hạn (trong vòng 80 tháng tới)
CREATE VIEW View_ThuocSapHetHan AS
SELECT * 
FROM Thuoc 
WHERE HanSuDung BETWEEN GETDATE() AND DATEADD(MONTH, 80, GETDATE());
--Sử dụng
SELECT * FROM View_ThuocSapHetHan;
--Xóa
DROP VIEW View_ThuocSapHetHan;

--2.3. Thông tin thuốc và số lượng tồn kho
CREATE VIEW View_TonKho AS
SELECT T.MaThuoc, T.TenThuoc, T.HoatChat, T.DangBaoChe, KLT.SoLuongTon 
FROM Thuoc T
JOIN KhoLuuTru KLT ON T.MaThuoc = KLT.MaThuoc;
--Sử dụng
SELECT * FROM View_TonKho;
--Xóa
DROP VIEW View_TonKho;

--2.4. Lịch sử nhập kho thuốc
CREATE VIEW View_LichSuNhapKho AS
SELECT NK.MaNhap, NK.MaThuoc, T.TenThuoc, NK.SoLuong, NK.NgayNhap, NCC.TenNCC 
FROM NhapKho NK
JOIN Thuoc T ON NK.MaThuoc = T.MaThuoc
JOIN NhaCungCap NCC ON NK.MaNCC = NCC.MaNCC;
--Sử dụng
SELECT * FROM View_LichSuNhapKho;
--Xóa
DROP VIEW View_LichSuNhapKho;

--2.5. Lịch sử xuất kho thuốc
CREATE VIEW View_LichSuXuatKho AS
SELECT XK.MaXuat, XK.MaThuoc, T.TenThuoc, XK.SoLuong, XK.NgayXuat, KP.TenKhoa 
FROM XuatKho XK
JOIN Thuoc T ON XK.MaThuoc = T.MaThuoc
JOIN KhoaPhong KP ON XK.MaKhoa = KP.MaKhoa;
--Sử dụng
SELECT * FROM View_LichSuXuatKho;
--Xóa
DROP VIEW View_LichSuXuatKho;

--2.6. Thống kê tổng số lượng thuốc đã nhập từ mỗi nhà cung cấp
CREATE VIEW View_ThongKeNhapNCC AS
SELECT NK.MaNCC, NCC.TenNCC, SUM(NK.SoLuong) AS TongSoLuongNhap 
FROM NhapKho NK
JOIN NhaCungCap NCC ON NK.MaNCC = NCC.MaNCC
GROUP BY NK.MaNCC, NCC.TenNCC;
--Sử dụng
SELECT * FROM View_ThongKeNhapNCC;
--Xóa
DROP VIEW View_ThongKeNhapNCC;

--2.7. Thống kê số lượng thuốc đã xuất theo từng khoa
CREATE VIEW View_ThongKeXuatKhoa AS
SELECT XK.MaKhoa, KP.TenKhoa, SUM(XK.SoLuong) AS TongSoLuongXuat 
FROM XuatKho XK
JOIN KhoaPhong KP ON XK.MaKhoa = KP.MaKhoa
GROUP BY XK.MaKhoa, KP.TenKhoa;
--Sử dụng
SELECT * FROM View_ThongKeXuatKhoa;
--Xóa
DROP VIEW View_ThongKeXuatKhoa;

--2.8. Danh sách thuốc có số lượng tồn kho dưới mức tối thiểu (100 đơn vị)
CREATE VIEW View_ThuocCanNhap AS
SELECT T.MaThuoc, T.TenThuoc, KLT.SoLuongTon 
FROM KhoLuuTru KLT
JOIN Thuoc T ON KLT.MaThuoc = T.MaThuoc
WHERE KLT.SoLuongTon < 100;
--Sử dụng
SELECT * FROM View_ThuocCanNhap;
--Xóa
DROP VIEW View_ThuocCanNhap;

--2.9. Danh sách thuốc có giá bán cao hơn giá nhập gấp 2 lần
CREATE VIEW View_ThuocGiaCao AS
SELECT MaThuoc, TenThuoc, GiaNhap, GiaBan 
FROM Thuoc 
WHERE GiaBan >= 2 * GiaNhap;
--Sử dụng
SELECT * FROM View_ThuocGiaCao;
--Xóa
DROP VIEW View_ThuocGiaCao;

--2.10. Tổng hợp doanh thu từ xuất kho thuốc
CREATE VIEW View_DoanhThuThuoc AS
SELECT XK.MaThuoc, T.TenThuoc, SUM(XK.SoLuong * T.GiaBan) AS TongDoanhThu 
FROM XuatKho XK
JOIN Thuoc T ON XK.MaThuoc = T.MaThuoc
GROUP BY XK.MaThuoc, T.TenThuoc;
--Sử dụng
SELECT * FROM View_DoanhThuThuoc;
--Xóa
DROP VIEW View_DoanhThuThuoc;

--III.  Procedure
--3.1. Thêm thuốc mới vào bảng Thuoc
CREATE PROCEDURE sp_ThemThuoc
    @MaThuoc NVARCHAR(10),
    @TenThuoc NVARCHAR(255),
    @HoatChat NVARCHAR(255),
    @DangBaoChe NVARCHAR(100),
    @DonViTinh NVARCHAR(50),
    @GiaNhap DECIMAL(10,2),
    @GiaBan DECIMAL(10,2),
    @HanSuDung DATE,
    @GhiChu NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Thuoc (MaThuoc, TenThuoc, HoatChat, DangBaoChe, DonViTinh, GiaNhap, GiaBan, HanSuDung, GhiChu)
    VALUES (@MaThuoc, @TenThuoc, @HoatChat, @DangBaoChe, @DonViTinh, @GiaNhap, @GiaBan, @HanSuDung, @GhiChu);
END;
--Sử dụng
EXEC sp_ThemThuoc 'T022', 'Paracetamol', 'Acetaminophen', N'Viên nén', N'Hộp', 5000, 7000, '2026-12-31', N'Giảm đau, hạ sốt';

SELECT * FROM Thuoc
--Xóa
DROP PROCEDURE sp_ThemThuoc;

--3.2. Cập nhật thông tin thuốc
CREATE PROCEDURE sp_CapNhatThuoc
    @MaThuoc NVARCHAR(10),
    @TenThuoc NVARCHAR(255),
    @GiaBan DECIMAL(10,2)
AS
BEGIN
    UPDATE Thuoc
    SET TenThuoc = @TenThuoc, GiaBan = @GiaBan
    WHERE MaThuoc = @MaThuoc;
END;
--Sử dụng
EXEC sp_CapNhatThuoc 'T001', 'Paracetamol 500mg', 7500;

SELECT * FROM Thuoc
--Xóa
DROP PROCEDURE sp_CapNhatThuoc;

--3.3. Xóa thuốc theo mã
CREATE PROCEDURE sp_XoaThuoc
    @MaThuoc NVARCHAR(10)
AS
BEGIN
    DELETE FROM Thuoc WHERE MaThuoc = @MaThuoc;
END;
--Sử dụng
EXEC sp_XoaThuoc 'T022';

SELECT * FROM Thuoc
--Xóa
DROP PROCEDURE sp_XoaThuoc;

--3.4. Lấy danh sách thuốc sắp hết hạn trong vòng 60 tháng
CREATE PROCEDURE sp_ThuocSapHetHan
AS
BEGIN
    SELECT * FROM Thuoc WHERE HanSuDung <= DATEADD(MONTH, 60, GETDATE());
END;
--Sử dụng
EXEC sp_ThuocSapHetHan;
--Xóa
DROP PROCEDURE sp_ThuocSapHetHan;

--3.5. Thêm nhà cung cấp mới
CREATE PROCEDURE sp_ThemNhaCungCap
    @MaNCC NVARCHAR(10),
    @TenNCC NVARCHAR(255),
    @DiaChi NVARCHAR(255),
    @SoDienThoai NVARCHAR(20),
    @Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChi, SoDienThoai, Email)
    VALUES (@MaNCC, @TenNCC, @DiaChi, @SoDienThoai, @Email);
END;
--Sử dụng
EXEC sp_ThemNhaCungCap 'NCC018', N'Công ty Dược Phẩm Nam Tien', N'123 Nguyễn Văn Trỗi, HCM', '0909123456', 'NamTien@duocpham.com';

SELECT * FROM NhaCungCap
--Xóa
DROP PROCEDURE sp_ThemNhaCungCap;

--3.6. Nhập kho thuốc mới
CREATE PROCEDURE sp_NhapKho
    @MaNhap NVARCHAR(10),
    @MaThuoc NVARCHAR(10),
    @MaNCC NVARCHAR(10),
    @SoLuong INT,
    @NgayNhap DATE,
    @HanSuDung DATE,
    @GiaNhap DECIMAL(10,2)
AS
BEGIN
    INSERT INTO NhapKho (MaNhap, MaThuoc, MaNCC, SoLuong, NgayNhap, HanSuDung, GiaNhap)
    VALUES (@MaNhap, @MaThuoc, @MaNCC, @SoLuong, @NgayNhap, @HanSuDung, @GiaNhap);
END;
--Sử dụng
EXEC sp_NhapKho 'NK018', 'T001', 'NCC001', 500, '2025-03-01', '2027-12-31', 5000;

SELECT * FROM NhapKho
--Xóa
DROP PROCEDURE sp_NhapKho;

--3.7. Xuất kho thuốc cho khoa phòng
CREATE PROCEDURE sp_XuatKho
    @MaXuat NVARCHAR(10),
    @MaThuoc NVARCHAR(10),
    @MaKhoa NVARCHAR(10),
    @SoLuong INT,
    @NgayXuat DATE
AS
BEGIN
    INSERT INTO XuatKho (MaXuat, MaThuoc, MaKhoa, SoLuong, NgayXuat)
    VALUES (@MaXuat, @MaThuoc, @MaKhoa, @SoLuong, @NgayXuat);
    
    UPDATE KhoLuuTru
    SET SoLuongTon = SoLuongTon - @SoLuong
    WHERE MaThuoc = @MaThuoc;
END;
--Sử dụng
EXEC sp_XuatKho 'XK018', 'T001', 'K001', 100, '2025-03-10';
--Xóa
DROP PROCEDURE sp_XuatKho;

--3.8. Lấy tổng số lượng thuốc hiện có trong kho
CREATE PROCEDURE sp_TongSoLuongKho
AS
BEGIN
    SELECT MaThuoc, SUM(SoLuongTon) AS TongSoLuong
    FROM KhoLuuTru
    GROUP BY MaThuoc;
END;
--Sử dụng
EXEC sp_TongSoLuongKho;
--Xóa
DROP PROCEDURE sp_TongSoLuongKho;

--3.9. Kiểm tra tồn kho trước khi xuất thuốc
CREATE PROCEDURE sp_KiemTraTonKho
    @MaThuoc NVARCHAR(10),
    @SoLuong INT
AS
BEGIN
    DECLARE @SoLuongTon INT;
    
    SELECT @SoLuongTon = SoLuongTon FROM KhoLuuTru WHERE MaThuoc = @MaThuoc;
    
    IF @SoLuongTon >= @SoLuong
        PRINT N'Đủ số lượng để xuất kho.';
    ELSE
        PRINT N'Không đủ số lượng trong kho.';
END;
--Sử dụng
EXEC sp_KiemTraTonKho 'T001', 200;
--Xóa
DROP PROCEDURE sp_KiemTraTonKho;

--3.10. Lấy danh sách thuốc nhập kho từ ngày X đến ngày Y
CREATE PROCEDURE sp_ThuocNhapTheoNgay
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SELECT * FROM NhapKho WHERE NgayNhap BETWEEN @TuNgay AND @DenNgay;
END;
--Sử dụng
EXEC sp_ThuocNhapTheoNgay '2025-01-01', '2025-12-31';
--Xóa
DROP PROCEDURE sp_ThuocNhapTheoNgay;

--IV. Trigger
--4.1. Tự động cập nhật số lượng tồn kho khi nhập thuốc
CREATE TRIGGER trg_CapNhatTonKho_Nhap 
ON NhapKho
AFTER INSERT 
AS
BEGIN
    UPDATE KhoLuuTru
    SET SoLuongTon = SoLuongTon + i.SoLuong
    FROM KhoLuuTru k
    INNER JOIN inserted i ON k.MaThuoc = i.MaThuoc;
END;
--Kiểm tra
SELECT * FROM KhoLuuTru WHERE MaThuoc = 'T001';

INSERT INTO NhapKho (MaNhap, MaThuoc, MaNCC, SoLuong, NgayNhap, HanSuDung, GiaNhap) VALUES
(N'NK029', N'T001', N'NCC001', 100, '2025-02-01', '2026-12-31', 5000);
-- Kiểm tra số lượng tồn kho sau khi nhập
SELECT * FROM KhoLuuTru WHERE MaThuoc = 'T001';

--Xóa
DROP TRIGGER trg_CapNhatTonKho_Nhap;

--4.2. Tự động giảm số lượng tồn kho khi xuất thuốc
CREATE TRIGGER trg_CapNhatTonKho_Xuat 
ON XuatKho
AFTER INSERT 
AS
BEGIN
    UPDATE KhoLuuTru
    SET SoLuongTon = SoLuongTon - i.SoLuong
    FROM KhoLuuTru k
    INNER JOIN inserted i ON k.MaThuoc = i.MaThuoc;
END;
--Kiểm tra
SELECT * FROM KhoLuuTru WHERE MaThuoc = 'T001';

-- Xuất kho 50 đơn vị thuốc T001
INSERT INTO XuatKho (MaXuat, MaThuoc, MaKhoa, SoLuong, NgayXuat) VALUES
(N'XK019', N'T001', N'K001', 50, '2025-02-10');

-- Kiểm tra số lượng tồn kho sau khi xuất
SELECT * FROM KhoLuuTru WHERE MaThuoc = 'T001';
--Xóa
DROP TRIGGER trg_CapNhatTonKho_Xuat;

--4.3. Ngăn chặn nhập số lượng thuốc âm
CREATE TRIGGER trg_KiemTraSoLuongNhap
ON NhapKho
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra nếu có số lượng nhập <= 0 thì báo lỗi
    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuong <= 0)
    BEGIN
        RAISERROR(N'Số lượng nhập phải lớn hơn 0!', 16, 1);
        RETURN; -- Dừng thao tác INSERT
    END;

    -- Nếu hợp lệ, chèn dữ liệu vào bảng NhapKho
    INSERT INTO NhapKho (MaThuoc, SoLuong, NgayNhap)
    SELECT MaThuoc, SoLuong, NgayNhap FROM inserted;
END;
--Kiểm tra
INSERT INTO NhapKho (MaNhap, MaThuoc, MaNCC, SoLuong, NgayNhap, HanSuDung, GiaNhap) VALUES
(N'NK094', N'T001', N'NCC001', -100, '2025-02-01', '2026-12-31', 5000);
--Xóa
DROP TRIGGER trg_KiemTraSoLuongNhap;

--4.4. Ngăn chặn xuất kho nếu số lượng không đủ
CREATE TRIGGER trg_KiemTraTonKho
ON XuatKho
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra số lượng tồn kho trước khi cho phép INSERT
    IF EXISTS (
        SELECT 1 
        FROM inserted i 
        JOIN KhoLuuTru k ON i.MaThuoc = k.MaThuoc 
        WHERE k.SoLuongTon < i.SoLuong
    )
    BEGIN
        RAISERROR(N'Số lượng thuốc trong kho không đủ để xuất!', 16, 1);
        RETURN; -- Ngăn chặn INSERT nếu không đủ hàng
    END;

    -- Nếu hợp lệ, chèn dữ liệu vào bảng XuatKho
    INSERT INTO XuatKho (MaThuoc, SoLuong, NgayXuat)
    SELECT MaThuoc, SoLuong, NgayXuat FROM inserted;
END;

--Kiểm tra
INSERT INTO XuatKho (MaXuat, MaThuoc, MaKhoa, SoLuong, NgayXuat) VALUES
(N'XK078', N'T001', N'K001', 500, '2025-02-10');
--Xóa
DROP TRIGGER trg_KiemTraTonKho;

--4.5. Ghi nhật ký khi có thuốc mới được thêm vào hệ thống
--Tạo bảng nhật ký
CREATE TABLE NhatKy (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ThoiGian DATETIME DEFAULT GETDATE(),
    HanhDong NVARCHAR(50),
    NoiDung NVARCHAR(255)
);
--Tạo trigger
CREATE TRIGGER trg_GhiNhatKy_ThuocMoi
ON Thuoc
AFTER INSERT
AS
BEGIN
    INSERT INTO NhatKy (ThoiGian, HanhDong, NoiDung)
    SELECT GETDATE(), N'Thêm thuốc', CONCAT(N'Mã: ', MaThuoc, N', Tên: ', TenThuoc)
    FROM inserted;
END;
--Kiểm tra
INSERT INTO Thuoc (MaThuoc, TenThuoc, HoatChat, DangBaoChe, DonViTinh, GiaNhap, GiaBan, HanSuDung, GhiChu) VALUES
(N'T025', N'Parhhetghamol', N'Paracetamol 500mg', N'Viên nén', N'Hộp', 5000, 10000, '2026-12-31', N'Thuốc giảm đau, hạ sốt');
-- Kiểm tra nhật ký
SELECT * FROM NhatKy ORDER BY ThoiGian DESC;
--Xóa
DROP TRIGGER trg_GhiNhatKy_ThuocMoi;

--4.6. Trigger cảnh báo khi số lượng tồn dưới 50
CREATE TRIGGER trg_CanhBaoSoLuongTon
ON KhoLuuTru
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM INSERTED WHERE SoLuongTon < 50)
    BEGIN
        THROW 50001, N'Cảnh báo: Số lượng thuốc trong kho đã dưới 50!', 1;
    END
END;
--kiểm tra
UPDATE KhoLuuTru SET SoLuongTon = 30 WHERE MaThuoc = 'T001';
--xóa
DROP TRIGGER trg_CanhBaoSoLuongTon;

--4.7. Ngăn chặn xuất thuốc có hạn sử dụng dưới 100 tháng
CREATE TRIGGER trg_KiemTraHanSuDung
ON XuatKho
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i 
        JOIN Thuoc t ON i.MaThuoc = t.MaThuoc 
        WHERE DATEDIFF(MONTH, GETDATE(), t.HanSuDung) < 100
    )
    BEGIN
        RAISERROR(N'Thuốc có hạn sử dụng dưới 100 tháng không thể xuất kho!', 16, 1);
        RETURN;
    END;

    INSERT INTO XuatKho (MaXuat, MaThuoc, SoLuong, NgayXuat)
    SELECT MaXuat, MaThuoc, SoLuong, NgayXuat FROM inserted;
END;
--Kiểm tra
INSERT INTO XuatKho (MaXuat, MaThuoc, MaKhoa, SoLuong, NgayXuat) VALUES
(N'XK043', N'T001', N'K001', 50, '2025-03-10');
--Xóa
DROP TRIGGER trg_KiemTraHanSuDung;
--4.8. Ngăn chặn nhập thuốc trùng mã đã có trong hệ thống
CREATE TRIGGER trg_NganChanThuocTrung
ON Thuoc
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i JOIN Thuoc t ON i.MaThuoc = t.MaThuoc)
    BEGIN
        RAISERROR(N'Thuốc đã tồn tại trong hệ thống!', 16, 1);
        RETURN;
    END;
    
    INSERT INTO Thuoc (MaThuoc, TenThuoc, HoatChat, DangBaoChe, DonViTinh, GiaNhap, GiaBan, HanSuDung, GhiChu)
    SELECT MaThuoc, TenThuoc, HoatChat, DangBaoChe, DonViTinh, GiaNhap, GiaBan, HanSuDung, GhiChu FROM inserted;
END;
--Kiểm tra
INSERT INTO Thuoc (MaThuoc, TenThuoc, HoatChat, DangBaoChe, DonViTinh, GiaNhap, GiaBan, HanSuDung, GhiChu) VALUES
(N'T001', N'Paracetamol', N'Paracetamol 500mg', N'Viên nén', N'Hộp', 5000, 10000, '2026-12-31', N'Thuốc giảm đau, hạ sốt');
--Xóa
DROP TRIGGER trg_NganChanThuocTrung;

--4.9. Trigger tự động ghi nhật ký khi cập nhật giá bán thuốc
--Tạo bảng cật nhật giá bán
CREATE TABLE LichSuGiaBan (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaThuoc NVARCHAR(50),
    GiaCu DECIMAL(18,2),
    GiaMoi DECIMAL(18,2),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);
--tạo trigger
CREATE TRIGGER trg_GhiLichSuGiaBan
ON Thuoc
AFTER UPDATE
AS
BEGIN
    INSERT INTO LichSuGiaBan (MaThuoc, GiaCu, GiaMoi, NgayCapNhat)
    SELECT i.MaThuoc, d.GiaBan, i.GiaBan, GETDATE()
    FROM inserted i
    JOIN deleted d ON i.MaThuoc = d.MaThuoc
    WHERE i.GiaBan <> d.GiaBan; -- Chỉ ghi lại nếu giá thay đổi
END;
--Kiểm tra
UPDATE Thuoc SET GiaBan = 8000 WHERE MaThuoc = 'T001';

SELECT * FROM LichSuGiaBan WHERE MaThuoc = 'T001';
--Xóa
DROP TRIGGER trg_GhiLichSuGiaBan;

--4.10. Ngăn chặn cập nhật giá thuốc nếu giá mới thấp hơn 80% giá nhập ban đầu
CREATE TRIGGER trg_NganChanCapNhatGiaThuoc
ON Thuoc
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i 
        JOIN Thuoc t ON i.MaThuoc = t.MaThuoc
        WHERE i.GiaBan < (t.GiaNhap * 0.8)
    )
    BEGIN
        RAISERROR(N'Giá bán không được thấp hơn 80%% giá nhập ban đầu!', 16, 1);
        RETURN;
    END;

    UPDATE Thuoc
    SET GiaBan = i.GiaBan
    FROM Thuoc t
    INNER JOIN inserted i ON t.MaThuoc = i.MaThuoc;
END;
--Kiểm tra
UPDATE Thuoc SET GiaBan = 3000 WHERE MaThuoc = 'T002'; 
--Xóa
DROP TRIGGER trg_NganChanCapNhatGiaThuoc;

--V. Phân quyền và bảo vệ cơ sở dữ liệu
--5.1. Tạo người dùng mới trong SQL Server
CREATE LOGIN NamTien WITH PASSWORD = '123';
CREATE USER NamTien FOR LOGIN NamTien;

--5.2. Cấp quyền SELECT trên bảng cho người dùng
GRANT SELECT ON Thuoc TO NamTien;

--5.3. Cấp quyền INSERT và UPDATE nhưng không được DELETE
GRANT INSERT, UPDATE ON KhoLuuTru TO NamTien;

--5.4. Tạo vai trò (Role) và cấp quyền cho vai trò
CREATE ROLE NhanVienKho;
GRANT SELECT, INSERT, UPDATE ON NhapKho TO NhanVienKho;

--5.5. Gán người dùng vào vai trò
ALTER ROLE NhanVienKho ADD MEMBER NamTien;

--5.6. Thu hồi quyền của người dùng
REVOKE UPDATE ON Thuoc FROM NamTien;

--5.7. Ngăn người dùng xóa dữ liệu
DENY DELETE ON KhoLuuTru TO NamTien;

--5.8. Bảo vệ dữ liệu bằng mã hóa cột (Column Encryption)
ALTER TABLE NhaCungCap 
ADD CONSTRAINT DF_SDT DEFAULT '********' FOR SoDienThoai;

--5.9. Xóa người dùng và vai trò
DROP USER NamTien;
DROP ROLE NhanVienKho;
DROP LOGIN NamTien;

--5.10. Mã hóa cột dữ liệu nhạy cảm (SĐT, Email của nhà cung cấp)
-- Bật tính năng mã hóa cột
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123@';
CREATE CERTIFICATE Cert_NhaCungCap WITH SUBJECT = N'Mã hóa dữ liệu nhà cung cấp';
CREATE SYMMETRIC KEY Key_NCC WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Cert_NhaCungCap;

-- Thêm cột mã hóa vào bảng NhaCungCap
ALTER TABLE NhaCungCap ADD SDT_MaHoa VARBINARY(MAX), Email_MaHoa VARBINARY(MAX);

-- Mã hóa dữ liệu khi nhập vào
OPEN SYMMETRIC KEY Key_NCC DECRYPTION BY CERTIFICATE Cert_NhaCungCap;
UPDATE NhaCungCap 
SET SDT_MaHoa = EncryptByKey(Key_GUID('Key_NCC'), SoDienThoai),
    Email_MaHoa = EncryptByKey(Key_GUID('Key_NCC'), Email);
CLOSE SYMMETRIC KEY Key_NCC;

-- Giải mã khi cần xem dữ liệu
OPEN SYMMETRIC KEY Key_NCC DECRYPTION BY CERTIFICATE Cert_NhaCungCap;
SELECT MaNCC, 
       CONVERT(NVARCHAR, DecryptByKey(SDT_MaHoa)) AS SDT_GiaiMa, 
       CONVERT(NVARCHAR, DecryptByKey(Email_MaHoa)) AS Email_GiaiMa
FROM NhaCungCap;
CLOSE SYMMETRIC KEY Key_NCC;

--kiểm tra
SELECT MaNCC, SoDienThoai, Email, SDT_MaHoa, Email_MaHoa FROM NhaCungCap;
