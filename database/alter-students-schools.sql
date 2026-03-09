-- Add section to students, mandal to schools
-- Run this after your students and schools tables exist.
-- If a column already exists, skip that ALTER or run one by one.

-- Students: add section (e.g. 'A', 'B', '1')
ALTER TABLE students ADD COLUMN section VARCHAR(64) NULL DEFAULT NULL AFTER roll_no;

-- Schools: add mandal
ALTER TABLE schools ADD COLUMN mandal VARCHAR(128) NULL DEFAULT NULL AFTER district;

-- Optional: for admin login (POST /api/auth/login) to verify password, add password_hash to admins:
-- ALTER TABLE admins ADD COLUMN password_hash VARCHAR(255) NULL DEFAULT NULL;
-- Then set hashed passwords for each admin (e.g. via your app or bcrypt in SQL).
