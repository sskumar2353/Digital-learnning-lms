-- =============================================================================
-- CHAPTERS / TOPICS / SYLLABUS – Social Studies (Grade 10)
-- =============================================================================
-- STEP 0: Get your Social Studies subject id:
--   SELECT id, name FROM subjects WHERE name LIKE '%Social%';
--
-- STEP 1: Set the variable below to that id (e.g. 5).
-- STEP 2: Run the whole script in MySQL (Workbench or CLI).
--         If any ALTER fails with "duplicate column", skip that line and continue.
-- =============================================================================

-- ----- 1) Add new columns to chapters (ignore error if column already exists) -----
ALTER TABLE chapters ADD COLUMN chapter_no TINYINT UNSIGNED NULL;
ALTER TABLE chapters ADD COLUMN month_label VARCHAR(128) NULL;
ALTER TABLE chapters ADD COLUMN periods TINYINT UNSIGNED NULL;
ALTER TABLE chapters ADD COLUMN teaching_plan_summary VARCHAR(512) NULL;
ALTER TABLE chapters ADD COLUMN concepts TEXT NULL;

-- ----- 2) Set your Social Studies subject_id and grade -----
SET @subject_id = 1;   -- CHANGE THIS to your Social Studies subject id
SET @grade = 10;

-- ----- 3) Insert Social Studies chapters (22 rows) -----

INSERT INTO chapters (subject_id, name, grade, order_num, chapter_no, month_label, periods, teaching_plan_summary) VALUES
(@subject_id, 'India: Relief Features', @grade, 1, 1, 'June (Week 1–2)', 8, 'Location, relief divisions'),
(@subject_id, 'Ideas of Development', @grade, 2, 2, 'June (Week 3–4)', 7, 'Development concepts'),
(@subject_id, 'Production and Employment', @grade, 3, 3, 'July (Week 1–2)', 8, 'Sectors, employment'),
(@subject_id, 'Climate of India', @grade, 4, 4, 'July (Week 3–4)', 8, 'Climate & monsoon'),
(@subject_id, 'Rivers & Water Resources', @grade, 5, 5, 'August (Week 1–2)', 7, 'River systems'),
(@subject_id, 'Population', @grade, 6, 6, 'August (Week 3–4)', 6, 'Demographics'),
(@subject_id, 'Settlements & Migration', @grade, 7, 7, 'September (Week 1–2)', 7, 'Migration'),
(@subject_id, 'Rampur Village Economy', @grade, 8, 8, 'September (Week 3–4)', 6, 'Rural economy'),
(@subject_id, 'Globalisation', @grade, 9, 9, 'October (Week 1–2)', 6, 'MNCs'),
(@subject_id, 'Food Security', @grade, 10, 10, 'October (Week 3–4)', 6, 'PDS'),
(@subject_id, 'Sustainable Development', @grade, 11, 11, 'November (Week 1–2)', 7, 'Sustainability'),
(@subject_id, 'World Wars', @grade, 12, 12, 'November (Week 3–4)', 8, 'WW1 & WW2'),
(@subject_id, 'National Liberation', @grade, 13, 13, 'December (Week 1)', 5, 'Colonial struggles'),
(@subject_id, 'National Movement in India', @grade, 14, 14, 'December (Week 2–3)', 6, 'Freedom struggle'),
(@subject_id, 'Indian Constitution', @grade, 15, 15, 'December (Week 4)', 5, 'Rights'),
(@subject_id, 'Election Process', @grade, 16, 16, 'January (Week 1–2)', 5, 'Elections'),
(@subject_id, 'Independent India', @grade, 17, 17, 'January (Week 3)', 5, 'Nation building'),
(@subject_id, 'Political Trends', @grade, 18, 18, 'January (Week 4)', 5, 'Reforms'),
(@subject_id, 'Post-War World', @grade, 19, 19, 'February (Week 1)', 5, 'Cold War'),
(@subject_id, 'Social Movements', @grade, 20, 20, 'February (Week 2)', 5, 'Movements'),
(@subject_id, 'Telangana Movement', @grade, 21, 21, 'February (Week 3)', 6, 'State formation'),
(@subject_id, 'Revision', @grade, 22, NULL, 'February (Week 4)', NULL, 'Full syllabus');

-- =============================================================================
-- PART 2: Micro lesson plan – topics (P1, P2, …) for each chapter
-- =============================================================================
SET @ch1 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 1 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch1, 'P1 → Location & Map', 1, 'completed'), (@ch1, 'P2 → Latitudes & Longitudes', 2, 'completed'),
(@ch1, 'P3 → Geological History', 3, 'completed'), (@ch1, 'P4 → Himalayas', 4, 'completed'),
(@ch1, 'P5 → Plains', 5, 'completed'), (@ch1, 'P6 → Plateau', 6, 'completed'),
(@ch1, 'P7 → Desert & Coast', 7, 'completed'), (@ch1, 'P8 → Revision', 8, 'completed');

SET @ch2 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 2 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch2, 'P1 → Introduction', 1, 'completed'), (@ch2, 'P2 → Goals', 2, 'completed'),
(@ch2, 'P3 → Conflicts', 3, 'completed'), (@ch2, 'P4 → Income', 4, 'completed'),
(@ch2, 'P5 → Public Facilities', 5, 'completed'), (@ch2, 'P6 → HDI', 6, 'completed'),
(@ch2, 'P7 → Revision', 7, 'completed');

SET @ch3 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 3 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch3, 'P1 → Introduction', 1, 'completed'), (@ch3, 'P2 → Primary Sector', 2, 'completed'),
(@ch3, 'P3 → Secondary', 3, 'completed'), (@ch3, 'P4 → Tertiary', 4, 'completed'),
(@ch3, 'P5 → Employment Types', 5, 'completed'), (@ch3, 'P6 → Organized/Unorganized', 6, 'completed'),
(@ch3, 'P7 → Case Study', 7, 'completed'), (@ch3, 'P8 → Revision', 8, 'completed');

SET @ch4 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 4 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch4, 'P1 → Climate Basics', 1, 'completed'), (@ch4, 'P2 → Factors', 2, 'completed'),
(@ch4, 'P3 → Monsoon', 3, 'completed'), (@ch4, 'P4 → Seasons', 4, 'completed'),
(@ch4, 'P5 → Rainfall', 5, 'completed'), (@ch4, 'P6 → Regions', 6, 'completed'),
(@ch4, 'P7 → Map Work', 7, 'completed'), (@ch4, 'P8 → Revision', 8, 'completed');

SET @ch5 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 5 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch5, 'P1 → Introduction', 1, 'completed'), (@ch5, 'P2 → Himalayan Rivers', 2, 'completed'),
(@ch5, 'P3 → Peninsular Rivers', 3, 'completed'), (@ch5, 'P4 → Irrigation', 4, 'completed'),
(@ch5, 'P5 → Conservation', 5, 'completed'), (@ch5, 'P6 → Issues', 6, 'completed'),
(@ch5, 'P7 → Revision', 7, 'completed');

SET @ch6 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 6 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch6, 'P1 → Introduction', 1, 'completed'), (@ch6, 'P2 → Growth', 2, 'completed'),
(@ch6, 'P3 → Density', 3, 'completed'), (@ch6, 'P4 → Literacy', 4, 'completed'),
(@ch6, 'P5 → Migration', 5, 'completed'), (@ch6, 'P6 → Revision', 6, 'completed');

SET @ch7 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 7 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch7, 'P1 → Types', 1, 'completed'), (@ch7, 'P2 → Rural', 2, 'completed'),
(@ch7, 'P3 → Urban', 3, 'completed'), (@ch7, 'P4 → Migration Types', 4, 'completed'),
(@ch7, 'P5 → Causes', 5, 'completed'), (@ch7, 'P6 → Effects', 6, 'completed'),
(@ch7, 'P7 → Revision', 7, 'completed');

SET @ch8 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 8 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch8, 'P1 → Village Intro', 1, 'completed'), (@ch8, 'P2 → Farming', 2, 'completed'),
(@ch8, 'P3 → Non-farm', 3, 'completed'), (@ch8, 'P4 → Credit', 4, 'completed'),
(@ch8, 'P5 → Issues', 5, 'completed'), (@ch8, 'P6 → Revision', 6, 'completed');

SET @ch9 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 9 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch9, 'P1 → Meaning', 1, 'completed'), (@ch9, 'P2 → Liberalisation', 2, 'completed'),
(@ch9, 'P3 → MNCs', 3, 'completed'), (@ch9, 'P4 → Impact', 4, 'completed'),
(@ch9, 'P5 → Pros/Cons', 5, 'completed'), (@ch9, 'P6 → Revision', 6, 'completed');

SET @ch10 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 10 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch10, 'P1 → Meaning', 1, 'completed'), (@ch10, 'P2 → PDS', 2, 'completed'),
(@ch10, 'P3 → Buffer Stock', 3, 'completed'), (@ch10, 'P4 → Programs', 4, 'completed'),
(@ch10, 'P5 → Issues', 5, 'completed'), (@ch10, 'P6 → Revision', 6, 'completed');

SET @ch11 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 11 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch11, 'P1 → Meaning', 1, 'completed'), (@ch11, 'P2 → Resources', 2, 'completed'),
(@ch11, 'P3 → Issues', 3, 'completed'), (@ch11, 'P4 → Conservation', 4, 'completed'),
(@ch11, 'P5 → Equity', 5, 'completed'), (@ch11, 'P6 → Case Study', 6, 'completed'),
(@ch11, 'P7 → Revision', 7, 'completed');

SET @ch12 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 12 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch12, 'P1 → Causes WW1', 1, 'completed'), (@ch12, 'P2 → WW1 Events', 2, 'completed'),
(@ch12, 'P3 → Aftermath', 3, 'completed'), (@ch12, 'P4 → Causes WW2', 4, 'completed'),
(@ch12, 'P5 → WW2 Events', 5, 'completed'), (@ch12, 'P6 → Impact', 6, 'completed'),
(@ch12, 'P7 → Comparison', 7, 'completed'), (@ch12, 'P8 → Revision', 8, 'completed');

-- Chapters 13–21: compact 5–6 periods each
SET @ch13 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 13 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch13, 'P1–P4 → Movements', 1, 'completed'), (@ch13, 'P5 → Revision', 2, 'completed');
SET @ch14 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 14 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch14, 'P1–P5 → Freedom Struggle', 1, 'completed'), (@ch14, 'P6 → Revision', 2, 'completed');
SET @ch15 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 15 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch15, 'P1–P4 → Features', 1, 'completed'), (@ch15, 'P5 → Revision', 2, 'completed');
SET @ch16 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 16 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch16, 'P1–P4 → Process', 1, 'completed'), (@ch16, 'P5 → Revision', 2, 'completed');
SET @ch17 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 17 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch17, 'P1–P4 → Development', 1, 'completed'), (@ch17, 'P5 → Revision', 2, 'completed');
SET @ch18 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 18 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch18, 'P1–P4 → Changes', 1, 'completed'), (@ch18, 'P5 → Revision', 2, 'completed');
SET @ch19 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 19 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch19, 'P1–P4 → Cold War', 1, 'completed'), (@ch19, 'P5 → Revision', 2, 'completed');
SET @ch20 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 20 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch20, 'P1–P4 → Types', 1, 'completed'), (@ch20, 'P5 → Revision', 2, 'completed');
SET @ch21 = (SELECT id FROM chapters WHERE subject_id = @subject_id AND grade = @grade AND order_num = 21 LIMIT 1);
INSERT INTO topics (chapter_id, name, order_num, status) VALUES
(@ch21, 'P1–P5 → Movement', 1, 'completed'), (@ch21, 'P6 → Revision', 2, 'completed');
