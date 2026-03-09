-- =============================================================================
-- Railway / fresh MySQL: create all core tables the app needs (login, dashboard, assignments).
-- Run this ONCE on an empty database (e.g. Railway MySQL "railway" database).
-- Order matters: tables with foreign keys come after the tables they reference.
-- =============================================================================

-- 1) Admins (for admin login)
CREATE TABLE IF NOT EXISTS admins (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NULL,
  role VARCHAR(64) NOT NULL DEFAULT 'admin',
  password_hash VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_admins_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) Schools
CREATE TABLE IF NOT EXISTS schools (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(64) NOT NULL,
  district VARCHAR(128) NOT NULL,
  mandal VARCHAR(128) NULL,
  active_status TINYINT(1) NOT NULL DEFAULT 1,
  sessions_completed INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_schools_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3) Classes (depends: schools)
CREATE TABLE IF NOT EXISTS classes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  school_id INT UNSIGNED NOT NULL,
  name VARCHAR(128) NOT NULL,
  section VARCHAR(64) NULL DEFAULT NULL,
  grade TINYINT UNSIGNED NOT NULL,
  student_count INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_school (school_id),
  CONSTRAINT fk_classes_school FOREIGN KEY (school_id) REFERENCES schools (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4) Teachers (depends: schools)
CREATE TABLE IF NOT EXISTS teachers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  school_id INT UNSIGNED NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_teachers_email (email),
  KEY idx_school (school_id),
  CONSTRAINT fk_teachers_school FOREIGN KEY (school_id) REFERENCES schools (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5) Subjects
CREATE TABLE IF NOT EXISTS subjects (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  icon VARCHAR(64) NULL DEFAULT '📚',
  grades VARCHAR(64) NULL COMMENT 'e.g. 6,7,8,9,10',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6) Students (depends: schools)
CREATE TABLE IF NOT EXISTS students (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  school_id INT UNSIGNED NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  roll_no INT UNSIGNED NOT NULL DEFAULT 0,
  section VARCHAR(64) NULL,
  password_hash VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_school (school_id),
  CONSTRAINT fk_students_school FOREIGN KEY (school_id) REFERENCES schools (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7) Chapters (depends: subjects)
CREATE TABLE IF NOT EXISTS chapters (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  subject_id INT UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  grade TINYINT UNSIGNED NOT NULL,
  order_num INT UNSIGNED NOT NULL DEFAULT 1,
  chapter_no TINYINT UNSIGNED NULL,
  month_label VARCHAR(128) NULL,
  periods TINYINT UNSIGNED NULL,
  teaching_plan_summary VARCHAR(512) NULL,
  concepts TEXT NULL,
  textbook_chunk_pdf_path VARCHAR(512) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_subject_grade (subject_id, grade),
  CONSTRAINT fk_chapters_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8) Topics (depends: chapters)
CREATE TABLE IF NOT EXISTS topics (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  chapter_id INT UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  order_num INT UNSIGNED NOT NULL DEFAULT 1,
  status VARCHAR(32) NOT NULL DEFAULT 'not_started',
  topic_ppt_path VARCHAR(512) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_chapter (chapter_id),
  CONSTRAINT fk_topics_chapter FOREIGN KEY (chapter_id) REFERENCES chapters (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9) Enrollments (depends: students, classes)
CREATE TABLE IF NOT EXISTS enrollments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  academic_year VARCHAR(16) NOT NULL DEFAULT '2025-26',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_student (student_id),
  KEY idx_class (class_id),
  CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
  CONSTRAINT fk_enroll_class FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10) Teacher assignments (depends: teachers, classes, subjects)
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

-- 11) Teacher leaves (depends: teachers)
CREATE TABLE IF NOT EXISTS teacher_leaves (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT UNSIGNED NOT NULL,
  start_date DATE NOT NULL,
  reason VARCHAR(512) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'pending',
  applied_on DATE NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_teacher (teacher_id),
  CONSTRAINT fk_leaves_teacher FOREIGN KEY (teacher_id) REFERENCES teachers (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12) Optional: tables the app reads (empty is OK)
CREATE TABLE IF NOT EXISTS topic_materials (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  topic_id INT UNSIGNED NOT NULL,
  type VARCHAR(64) NOT NULL,
  title VARCHAR(512) NOT NULL,
  url VARCHAR(1024) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS quizzes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  chapter_id INT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS quiz_results (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  quiz_id INT UNSIGNED NOT NULL,
  score INT UNSIGNED NOT NULL DEFAULT 0,
  total INT UNSIGNED NOT NULL DEFAULT 0,
  submitted_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS attendance (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  date DATE NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'present',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_class_date (class_id, date),
  KEY idx_student (student_id),
  CONSTRAINT fk_att_student FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
  CONSTRAINT fk_att_class FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS activity_logs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  user_role VARCHAR(32) NOT NULL,
  action VARCHAR(255) NOT NULL,
  school_id INT UNSIGNED NULL,
  class_id INT UNSIGNED NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  gps VARCHAR(128) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS class_status (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date DATE NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  status VARCHAR(32) NOT NULL,
  teacher_id INT UNSIGNED NULL,
  reason VARCHAR(512) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS class_recordings (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT UNSIGNED NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  subject VARCHAR(128) NOT NULL,
  chapter VARCHAR(255) NOT NULL,
  date DATE NOT NULL,
  duration VARCHAR(64) NULL,
  size VARCHAR(64) NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'pending',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS homework (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  class_id INT UNSIGNED NOT NULL,
  subject_name VARCHAR(128) NOT NULL,
  chapter_name VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  due_date DATE NULL,
  assigned_date DATE NULL,
  total_students INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS study_materials (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  chapter_id INT UNSIGNED NOT NULL,
  type VARCHAR(64) NOT NULL,
  title VARCHAR(512) NOT NULL,
  url VARCHAR(1024) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS live_sessions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT UNSIGNED NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  chapter_id INT UNSIGNED NOT NULL,
  topic_id INT UNSIGNED NOT NULL,
  topic_name VARCHAR(255) NOT NULL,
  start_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(32) NOT NULL DEFAULT 'active',
  recording_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- Seed: one admin, one school, one teacher. Default password for both: Password123
-- (bcrypt hash below). Change password after first login.
-- =============================================================================
INSERT IGNORE INTO admins (id, email, full_name, role, password_hash) VALUES
(1, 'admin@lms.com', 'Admin', 'admin', '$2b$10$z8GfO68JFuM8/unTyNtL5eVS98YtehJ3BvYbWhXvBY2qT5JJW69fm');

INSERT IGNORE INTO schools (id, name, code, district, mandal, active_status, sessions_completed) VALUES
(1, 'Demo School', 'DEMO001', 'Demo District', NULL, 1, 0);

INSERT IGNORE INTO classes (id, school_id, name, section, grade, student_count) VALUES
(1, 1, 'Class 10', 'A', 10, 0);

INSERT IGNORE INTO subjects (id, name, icon, grades) VALUES
(1, 'Social Studies', '📚', '10'),
(2, 'Mathematics', '📐', '10'),
(3, 'Science', '🔬', '10');

INSERT IGNORE INTO teachers (id, school_id, full_name, email, password_hash) VALUES
(1, 1, 'Demo Teacher', 'teacher@lms.com', '$2b$10$z8GfO68JFuM8/unTyNtL5eVS98YtehJ3BvYbWhXvBY2qT5JJW69fm');

INSERT IGNORE INTO teacher_assignments (teacher_id, class_id, subject_id) VALUES
(1, 1, 1);
