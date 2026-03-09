-- Teacher effectiveness: suggested table for measuring and displaying effectiveness.
-- Create this table, add sample data, then we can wire /api/all to fill teacherEffectiveness.

CREATE TABLE IF NOT EXISTS teacher_effectiveness (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  teacher_id INT UNSIGNED NOT NULL,
  school_id INT UNSIGNED NOT NULL,
  academic_year VARCHAR(16) NOT NULL DEFAULT '2025-26',
  rating TINYINT UNSIGNED NULL COMMENT '1-5 or percentage 0-100',
  lesson_completion_rate DECIMAL(5,2) NULL COMMENT '0-100',
  student_engagement DECIMAL(5,2) NULL COMMENT '0-100',
  quiz_avg_score DECIMAL(5,2) NULL COMMENT '0-100',
  classes_completed INT UNSIGNED NOT NULL DEFAULT 0,
  total_scheduled INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_teacher_school_year (teacher_id, school_id, academic_year),
  CONSTRAINT fk_te_teacher FOREIGN KEY (teacher_id) REFERENCES teachers (id) ON DELETE CASCADE,
  CONSTRAINT fk_te_school FOREIGN KEY (school_id) REFERENCES schools (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Example insert (replace 1, 1 with real teacher_id and school_id):
-- INSERT INTO teacher_effectiveness (teacher_id, school_id, academic_year, rating, lesson_completion_rate, student_engagement, quiz_avg_score, classes_completed, total_scheduled)
-- VALUES (1, 1, '2025-26', 85, 92.5, 78.0, 72.0, 45, 50);
