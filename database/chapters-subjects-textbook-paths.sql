-- =============================================================================
-- TEXTBOOK PDF PATHS: chapter chunks + full textbook (revision) for Class 10
-- =============================================================================
-- Run this after your chapters and subjects are set up.
-- Paths are relative to your project (e.g. where you serve static files from).
-- Adjust folder names if yours differ (e.g. biology_textextbook_10).
-- =============================================================================

-- ----- 1) Add columns (skip if already present) -----
ALTER TABLE chapters
  ADD COLUMN textbook_chunk_pdf_path VARCHAR(512) NULL
  COMMENT 'Path to chapter PDF chunk e.g. Social_textbook_chunks/Chapter-1.pdf';

ALTER TABLE subjects
  ADD COLUMN textbook_revision_pdf_path VARCHAR(512) NULL
  COMMENT 'Path to full textbook for revision e.g. Social_textbook_10 or Social_textbook_10/full.pdf';

-- ----- 2) Social Studies – Grade 10 -----
-- Set chapter chunk paths (Chapter-1.pdf … Chapter-21.pdf); Revision uses subject revision path.
SET @social_id = (SELECT id FROM subjects WHERE name LIKE '%Social%' LIMIT 1);
UPDATE chapters
SET textbook_chunk_pdf_path = CONCAT('Social_textbook_chunks/Chapter-', chapter_no, '.pdf')
WHERE subject_id = @social_id AND grade = 10 AND chapter_no IS NOT NULL;

UPDATE subjects
SET textbook_revision_pdf_path = 'Social_textbook_10'
WHERE id = @social_id;

-- ----- 3) Physics – Grade 10 -----
SET @physics_id = (SELECT id FROM subjects WHERE name LIKE '%Physics%' LIMIT 1);
UPDATE chapters
SET textbook_chunk_pdf_path = CONCAT('physics_textbook_chunks/Chapter-', chapter_no, '.pdf')
WHERE subject_id = @physics_id AND grade = 10 AND chapter_no IS NOT NULL;

UPDATE subjects
SET textbook_revision_pdf_path = 'Physics_textbook_10'
WHERE id = @physics_id;

-- ----- 4) Biology – Grade 10 -----
-- If your folder is named biology_textextbook_10, change the path below.
SET @biology_id = (SELECT id FROM subjects WHERE name LIKE '%Biology%' LIMIT 1);
UPDATE chapters
SET textbook_chunk_pdf_path = CONCAT('biology_textbook_chunks/Chapter-', chapter_no, '.pdf')
WHERE subject_id = @biology_id AND grade = 10 AND chapter_no IS NOT NULL;

UPDATE subjects
SET textbook_revision_pdf_path = 'biology_textbook_10'
WHERE id = @biology_id;

-- =============================================================================
-- Verify (optional):
--   SELECT id, name, grade, chapter_no, textbook_chunk_pdf_path FROM chapters WHERE grade = 10 ORDER BY subject_id, order_num;
--   SELECT id, name, textbook_revision_pdf_path FROM subjects WHERE name LIKE '%Social%' OR name LIKE '%Physics%' OR name LIKE '%Biology%';
-- =============================================================================
