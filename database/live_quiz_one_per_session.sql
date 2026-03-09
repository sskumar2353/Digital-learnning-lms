-- One quiz per live session: link live_quiz_sessions to live_sessions.
-- Run after live_quiz_sessions and live_sessions exist.

-- Add column (nullable for existing rows)
ALTER TABLE live_quiz_sessions
  ADD COLUMN live_session_id INT UNSIGNED NULL AFTER subject_id;

-- One quiz per live session (unique so we can "get or create" by live_session_id)
ALTER TABLE live_quiz_sessions
  ADD UNIQUE KEY uq_live_session (live_session_id);

ALTER TABLE live_quiz_sessions
  ADD CONSTRAINT fk_lqs_live_session
  FOREIGN KEY (live_session_id) REFERENCES live_sessions (id) ON DELETE SET NULL;
