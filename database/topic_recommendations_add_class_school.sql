-- Scope topic_recommendations by class and school so only students of that class/school see them.
-- Run this after topic_recommendations_and_live_quiz.sql

-- 1) Drop the FK on topic_id (it uses uq_topic; we'll re-add it after changing the unique key)
ALTER TABLE topic_recommendations DROP FOREIGN KEY fk_topic_reco_topic;

-- 2) Drop the old unique key (one recommendation per topic globally)
ALTER TABLE topic_recommendations DROP INDEX uq_topic;

-- 3) Add class_id and school_id (nullable for existing rows)
ALTER TABLE topic_recommendations
  ADD COLUMN class_id INT UNSIGNED NULL AFTER grade,
  ADD COLUMN school_id INT UNSIGNED NULL AFTER class_id;

-- 4) New unique: one recommendation per topic per class (index on topic_id will support re-adding FK)
ALTER TABLE topic_recommendations
  ADD UNIQUE KEY uq_topic_class (topic_id, class_id),
  ADD KEY idx_class_school (class_id, school_id);

-- 5) Re-add the foreign key on topic_id
ALTER TABLE topic_recommendations
  ADD CONSTRAINT fk_topic_reco_topic FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE;
