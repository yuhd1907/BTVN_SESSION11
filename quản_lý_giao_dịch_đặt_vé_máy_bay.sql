-- a. Bắt đầu transaction
BEGIN;

-- b. Giảm số ghế của chuyến bay 'VN123' đi 1
UPDATE flights
SET available_seats = available_seats - 1
WHERE flight_name = 'VN123';

-- c. Thêm bản ghi đặt vé của khách hàng 'Nguyen Van A'
-- Giả sử flight_id của VN123 là 1
INSERT INTO bookings (flight_id, customer_name)
VALUES (1, 'Nguyen Van A');

-- d. Kết thúc bằng COMMIT
COMMIT;

-- e. Kiểm tra lại dữ liệu
SELECT * FROM flights;
SELECT * FROM bookings;

-- a. Thực hiện lại các bước nhưng nhập sai flight_id (ví dụ: flight_id = 999 không tồn tại)
BEGIN;

-- Giảm số ghế (Thao tác này vẫn chạy đúng)
UPDATE flights
SET available_seats = available_seats - 1
WHERE flight_name = 'VN123';

-- Thêm bản ghi đặt vé với flight_id sai (Gây lỗi Foreign Key hoặc logic)
INSERT INTO bookings (flight_id, customer_name)
VALUES (999, 'Nguyen Van B');

-- b. Gọi ROLLBACK để hủy toàn bộ thay đổi
ROLLBACK;

-- c. Kiểm tra lại dữ liệu và chứng minh số ghế KHÔNG thay đổi
SELECT * FROM flights;
SELECT * FROM bookings;