-- Teacher assignments: which teacher teaches which subject in which class.
-- Required by GET /api/all and GET/PUT /api/teachers/:id/assignments.
-- Run after: schools, classes, teachers, subjects exist.

CREATE TABLE IF NOT EXISTS teacher_assignments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT UNSIGNED NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_teacher (teacher_id),
  KEY idx_class (class_id),
  CONSTRAINT fk_ta_teacher FOREIGN KEY (teacher_id) REFERENCES teachers (id) ON DELETE CASCADE,
  CONSTRAINT fk_ta_class FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE,
  CONSTRAINT fk_ta_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
