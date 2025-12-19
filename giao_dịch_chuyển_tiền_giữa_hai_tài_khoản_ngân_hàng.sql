-- a. Bắt đầu transaction
BEGIN;

-- b. Cập nhật giảm số dư của A (100.00)
UPDATE accounts
SET balance = balance - 100.00
WHERE account_id = 1;

-- Cập nhật tăng số dư của B (100.00)
UPDATE accounts
SET balance = balance + 100.00
WHERE account_id = 2;

-- c. Hoàn tất giao dịch
COMMIT;

-- d. Kiểm tra số dư mới
SELECT * FROM accounts;

-- a. Bắt đầu transaction mới
BEGIN;

-- Giảm số dư của A
UPDATE accounts
SET balance = balance - 100.00
WHERE account_id = 1;

-- Cố ý nhập sai account_id của người nhận (ví dụ: id = 999)
UPDATE accounts
SET balance = balance + 100.00
WHERE account_id = 999;

-- b. Giả sử ta nhận ra lỗi hoặc hệ thống báo lỗi, gọi ROLLBACK
ROLLBACK;

-- c. Kiểm tra lại số dư
SELECT * FROM accounts;