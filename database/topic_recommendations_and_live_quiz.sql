-- =============================================================================
-- 1) Topic recommendations (YouTube + E-resources stored per topic for student corner)
-- =============================================================================

CREATE TABLE IF NOT EXISTS topic_recommendations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  topic_id INT UNSIGNED NOT NULL,
  chapter_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  grade TINYINT UNSIGNED NOT NULL,
  topic_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_topic (topic_id),
  KEY idx_chapter_grade (chapter_id, grade),
  KEY idx_subject_grade (subject_id, grade),
  CONSTRAINT fk_topic_reco_topic FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE,
  CONSTRAINT fk_topic_reco_chapter FOREIGN KEY (chapter_id) REFERENCES chapters (id) ON DELETE CASCADE,
  CONSTRAINT fk_topic_reco_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS topic_recommendation_links (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  topic_recommendation_id INT UNSIGNED NOT NULL,
  type ENUM('youtube','e_resource') NOT NULL,
  title VARCHAR(512) NOT NULL,
  url VARCHAR(1024) NOT NULL,
  description TEXT NULL,
  order_num TINYINT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_topic_reco (topic_recommendation_id),
  CONSTRAINT fk_link_topic_reco FOREIGN KEY (topic_recommendation_id) REFERENCES topic_recommendations (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- 2) Live quiz (AI-generated MCQs per session; student answers; top 5 leaderboard)
-- =============================================================================

CREATE TABLE IF NOT EXISTS live_quiz_sessions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT UNSIGNED NOT NULL,
  class_id INT UNSIGNED NOT NULL,
  chapter_id INT UNSIGNED NOT NULL,
  topic_id INT UNSIGNED NOT NULL,
  topic_name VARCHAR(255) NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  status ENUM('active','ended') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_class_teacher (class_id, teacher_id),
  KEY idx_topic (topic_id),
  CONSTRAINT fk_lqs_teacher FOREIGN KEY (teacher_id) REFERENCES teachers (id) ON DELETE CASCADE,
  CONSTRAINT fk_lqs_class FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE,
  CONSTRAINT fk_lqs_chapter FOREIGN KEY (chapter_id) REFERENCES chapters (id) ON DELETE CASCADE,
  CONSTRAINT fk_lqs_topic FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE,
  CONSTRAINT fk_lqs_subject FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS live_quiz_questions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  live_quiz_session_id INT UNSIGNED NOT NULL,
  question_text TEXT NOT NULL,
  option_a VARCHAR(512) NOT NULL,
  option_b VARCHAR(512) NOT NULL,
  option_c VARCHAR(512) NOT NULL,
  option_d VARCHAR(512) NOT NULL,
  correct_option CHAR(1) NOT NULL COMMENT 'A,B,C or D',
  explanation TEXT NULL,
  order_num TINYINT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_session (live_quiz_session_id),
  CONSTRAINT fk_lqq_session FOREIGN KEY (live_quiz_session_id) REFERENCES live_quiz_sessions (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS live_quiz_answers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  live_quiz_session_id INT UNSIGNED NOT NULL,
  student_id INT UNSIGNED NOT NULL,
  question_id INT UNSIGNED NOT NULL,
  selected_option CHAR(1) NOT NULL COMMENT 'A,B,C or D',
  is_correct TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_student_question (live_quiz_session_id, student_id, question_id),
  KEY idx_session_student (live_quiz_session_id, student_id),
  KEY idx_session (live_quiz_session_id),
  CONSTRAINT fk_lqa_session FOREIGN KEY (live_quiz_session_id) REFERENCES live_quiz_sessions (id) ON DELETE CASCADE,
  CONSTRAINT fk_lqa_student FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
  CONSTRAINT fk_lqa_question FOREIGN KEY (question_id) REFERENCES live_quiz_questions (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
