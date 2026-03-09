-- Optional: creates chapter_syllabus so admin weak-topic heatmap can show "current week" chapters.
-- Run this in MySQL if you want to use syllabus/current-week features. The API works without it (returns empty).

CREATE TABLE IF NOT EXISTS chapter_syllabus (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  chapter_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  grade TINYINT UNSIGNED NOT NULL,
  month_label VARCHAR(128) NULL,
  week_label VARCHAR(128) NULL,
  periods TINYINT UNSIGNED NULL,
  teaching_plan TEXT NULL,
  is_current_week TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_chapter (chapter_id),
  KEY idx_current_week (is_current_week)
);
