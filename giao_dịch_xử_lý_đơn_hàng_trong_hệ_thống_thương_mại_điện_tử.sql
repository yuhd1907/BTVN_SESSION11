-- a. Bắt đầu transaction
BEGIN;

-- b. Cập nhật giảm số dư của A đi 100.00
UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

-- Cập nhật tăng số dư của B thêm 100.00
UPDATE accounts
SET balance = balance + 100.00
WHERE owner_name = 'B';

-- c. Hoàn tất giao dịch
COMMIT;

-- d. Kiểm tra số dư mới của cả hai tài khoản
SELECT * FROM accounts;

-- a. Lặp lại quy trình, bắt đầu transaction
BEGIN;

-- Giảm số dư của A đi 100.00
UPDATE accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';

-- Cố ý nhập sai account_id của người nhận (ví dụ: ID không tồn tại)
UPDATE accounts
SET balance = balance + 100.00
WHERE account_id = 999;

-- b. Gọi ROLLBACK khi xảy ra lỗi (vì tài khoản người nhận không tồn tại)
ROLLBACK;

-- c. Kiểm tra lại số dư để đảm bảo không có thay đổi nào được lưu
SELECT * FROM accounts;