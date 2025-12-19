DO
$$
    DECLARE
        v_account_id INT     := 1; -- ID tài khoản rút tiền
        v_amount     NUMERIC := 500; -- Số tiền muốn rút
        v_balance    NUMERIC;
    BEGIN

        SELECT balance INTO v_balance FROM accounts WHERE account_id = v_account_id FOR UPDATE;

        IF v_balance >= v_amount THEN
            UPDATE accounts
            SET balance = balance - v_amount
            WHERE account_id = v_account_id;

            INSERT INTO transactions (account_id, amount, trans_type)
            VALUES (v_account_id, v_amount, 'WITHDRAW');

            RAISE NOTICE 'Giao dịch thành công!';
        ELSE
            RAISE EXCEPTION 'Giao dịch thất bại: Số dư không đủ (Hiện có: %)', v_balance;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Đang thực hiện ROLLBACK do lỗi: %', SQLERRM;
            ROLLBACK;
    END
$$;


-- Giả sử tài khoản 1 đang có 1000$
-- Bước mô phỏng lỗi: Chèn một account_id không tồn tại (999) vào bảng transactions
BEGIN;

-- Bước 1: Trừ tiền tài khoản 1 (giảm 200$)
UPDATE accounts
SET balance = balance - 200
WHERE account_id = 1;

-- Bước 2: Ghi log với account_id SAI (Cố tình gây lỗi Foreign Key)
-- Giả sử ID 999 không tồn tại trong bảng accounts
INSERT INTO transactions (account_id, amount, trans_type)
VALUES (999, 200, 'WITHDRAW');

-- Khi thực thi dòng INSERT trên, Postgres sẽ báo lỗi:
-- "insert or update on table 'transactions' violates foreign key constraint"

ROLLBACK;
-- Thực hiện hoàn tác

-- Chứng minh: Kiểm tra lại số dư tài khoản 1
SELECT *
FROM accounts
WHERE account_id = 1;
-- Kết quả: Balance vẫn là 1000$, không bị trừ đi 200$.

-- Truy vấn kiểm tra tính nhất quán
-- Tổng số tiền rút trong bảng log phải khớp với số tiền bị hụt đi so với số dư ban đầu
SELECT a.account_id,
       a.customer_name,
       a.balance     AS current_balance,
       SUM(t.amount) AS total_withdrawn
FROM accounts a
         JOIN transactions t ON a.account_id = t.account_id
WHERE t.trans_type = 'WITHDRAW'
GROUP BY a.account_id, a.customer_name, a.balance;
