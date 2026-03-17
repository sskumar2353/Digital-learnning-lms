-- =============================================================================
-- Seed: schools 2-5 and all teacher credentials (no hashing enforced in app yet).
-- Run after railway_core_schema.sql. Teachers use password_hash for storage only;
-- backend is configured to skip password verification for now.
-- =============================================================================

-- Schools 2-5 (school 1 exists from core schema)
INSERT IGNORE INTO schools (id, name, code, district, mandal, active_status, sessions_completed) VALUES
(2, 'School 2', 'SCH002', 'District', NULL, 1, 0),
(3, 'School 3', 'SCH003', 'District', NULL, 1, 0),
(4, 'School 4', 'SCH004', 'District', NULL, 1, 0),
(5, 'School 5', 'SCH005', 'District', NULL, 1, 0);

-- Teachers: t1_s1..t7_s5 (school_id from pattern: s1=1, s2=2, ...), plus santhikumari and teacher@gmail
-- id=1 is already Demo Teacher (teacher@lms.com) from core schema; new rows get auto-increment ids.
INSERT IGNORE INTO teachers (school_id, full_name, email, password_hash) VALUES
(1, 'Teacher t1_s1', 't1_s1@lms.com', '$2a$10$dummy'),
(1, 'Teacher t2_s1', 't2_s1@lms.com', '$2a$10$dummy'),
(1, 'Teacher t3_s1', 't3_s1@lms.com', '$2a$10$dummy'),
(1, 'Teacher t4_s1', 't4_s1@lms.com', '$2a$10$dummy'),
(1, 'Teacher t5_s1', 't5_s1@lms.com', '$2a$10$dummy'),
(1, 'Teacher t6_s1', 't6_s1@lms.com', '$2a$10$dummy'),
(1, 'Teacher t7_s1', 't7_s1@lms.com', '$2a$10$dummy'),
(2, 'Teacher t1_s2', 't1_s2@lms.com', '$2a$10$dummy'),
(2, 'Teacher t2_s2', 't2_s2@lms.com', '$2a$10$dummy'),
(2, 'Teacher t3_s2', 't3_s2@lms.com', '$2a$10$dummy'),
(2, 'Teacher t4_s2', 't4_s2@lms.com', '$2a$10$dummy'),
(2, 'Teacher t5_s2', 't5_s2@lms.com', '$2a$10$dummy'),
(2, 'Teacher t6_s2', 't6_s2@lms.com', '$2a$10$dummy'),
(2, 'Teacher t7_s2', 't7_s2@lms.com', '$2a$10$dummy'),
(3, 'Teacher t1_s3', 't1_s3@lms.com', '$2a$10$dummy'),
(3, 'Teacher t2_s3', 't2_s3@lms.com', '$2a$10$dummy'),
(3, 'Teacher t3_s3', 't3_s3@lms.com', '$2a$10$dummy'),
(3, 'Teacher t4_s3', 't4_s3@lms.com', '$2a$10$dummy'),
(3, 'Teacher t5_s3', 't5_s3@lms.com', '$2a$10$dummy'),
(3, 'Teacher t6_s3', 't6_s3@lms.com', '$2a$10$dummy'),
(3, 'Teacher t7_s3', 't7_s3@lms.com', '$2a$10$dummy'),
(4, 'Teacher t1_s4', 't1_s4@lms.com', '$2a$10$dummy'),
(4, 'Teacher t2_s4', 't2_s4@lms.com', '$2a$10$dummy'),
(4, 'Teacher t3_s4', 't3_s4@lms.com', '$2a$10$dummy'),
(4, 'Teacher t4_s4', 't4_s4@lms.com', '$2a$10$dummy'),
(4, 'Teacher t5_s4', 't5_s4@lms.com', '$2a$10$dummy'),
(4, 'Teacher t6_s4', 't6_s4@lms.com', '$2a$10$dummy'),
(4, 'Teacher t7_s4', 't7_s4@lms.com', '$2a$10$dummy'),
(5, 'Teacher t1_s5', 't1_s5@lms.com', '$2a$10$dummy'),
(5, 'Teacher t2_s5', 't2_s5@lms.com', '$2a$10$dummy'),
(5, 'Teacher t3_s5', 't3_s5@lms.com', '$2a$10$dummy'),
(5, 'Teacher t4_s5', 't4_s5@lms.com', '$2a$10$dummy'),
(5, 'Teacher t5_s5', 't5_s5@lms.com', '$2a$10$dummy'),
(5, 'Teacher t6_s5', 't6_s5@lms.com', '$2a$10$dummy'),
(5, 'Teacher t7_s5', 't7_s5@lms.com', '$2a$10$dummy'),
(1, 'Santhi Kumari', 'santhikumari@gmail.com', '$2b$10$w9PRWuT2bqRfd6zIdLIwfOlIYDDgWkDZwDwDRsTaDe2QkmV1G6yMO'),
(1, 'Teacher Gmail', 'teacher@gmail.com', '$2b$10$SKGKj/aeohuvWGGvshY5Ne8rLg/jLznRjSpwwgXAE567kt7qQeUyi');
