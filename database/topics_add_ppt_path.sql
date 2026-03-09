-- Add PPT path column to topics table (one PPT per topic; admin replace on re-upload)
-- Run this before using Admin Materials → Add PPT per topic.
-- Table structure: id, chapter_id, name, order_num, status, created_at, updated_at

ALTER TABLE topics
  ADD COLUMN topic_ppt_path VARCHAR(512) NULL AFTER status;
