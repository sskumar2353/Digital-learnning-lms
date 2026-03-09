-- Student QR codes: one row per QR type (A, B, C, D) per student.
-- Run after students table exists. QR images are stored on disk; this table stores paths only.

CREATE TABLE IF NOT EXISTS student_qr_codes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  qr_type ENUM('A','B','C','D') NOT NULL,
  qr_code_value VARCHAR(100) NOT NULL COMMENT 'e.g. STU_101_A',
  qr_image_path VARCHAR(255) NOT NULL COMMENT 'e.g. qrcodes/101_A.png',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_student_qr_type (student_id, qr_type),
  KEY idx_student_id (student_id),
  CONSTRAINT fk_student_qr_student FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
