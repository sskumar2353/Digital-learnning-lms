# Optional Data to Add to Your LMS Database

Your **lms.sql** already has everything needed for the site to run dynamically:

- **Schools, classes, teachers, students** – with enrollments and teacher_assignments  
- **Subjects, chapters, topics** – full curriculum for Class 10  
- **Quizzes and quiz_results** – so quiz scores and chapter results show correctly  
- **Attendance, activity_logs, class_status, class_recordings**  
- **lesson_content** – for topic-level lesson text  
- **co_curricular_activities, student_badges, student_certificates**, etc.

You **do not need** to add anything for the main admin dashboard (schools → classes → subjects → chapters → students, teachers, activity, etc.) to work.

---

## Optional: Add these if you want more features to show real data

These tables exist but are **empty** in your dump. The app will still work without them; adding rows just makes those sections show real content.

### 1. **quiz_questions** (so chapter quizzes show actual questions)

If you add rows here, the “Chapter quizzes” / practice quiz UI can show real questions.

| Column          | Example value / notes                                      |
|-----------------|------------------------------------------------------------|
| quiz_id         | Use an existing `id` from `quizzes` (e.g. 1, 2, 13, 41)   |
| question_text   | The question string                                        |
| options_json    | JSON array, e.g. `["A. Option 1","B. Option 2","C. Option 3","D. Option 4"]` |
| correct_answer  | One letter, e.g. `"B"`                                     |
| order_num       | 1, 2, 3, …                                                 |

**Example (run in MySQL after your dump):**

```sql
INSERT INTO quiz_questions (quiz_id, question_text, options_json, correct_answer, order_num) VALUES
(1, 'What is the central theme of the lesson?', '["A. Option 1","B. Option 2","C. Option 3","D. Option 4"]', 'B', 1),
(1, 'Second question text here?', '["A. Yes","B. No","C. Maybe","D. None"]', 'A', 2);
```

Use different `quiz_id` values from your `quizzes` table for different chapters.

---

### 2. **topic_materials** (PPT, notes, video links per topic)

Makes the “Study materials” / micro-lesson view show real links (PPT, notes, video, etc.) under each topic.

| Column   | Example / notes                                      |
|----------|------------------------------------------------------|
| topic_id | Use an existing `id` from `topics` (e.g. 1–250+)    |
| type     | One of: `ppt`, `notes`, `doc`, `video`, `ai_video`, `simulation`, `vr`, `image`, `recording` |
| title    | Display name, e.g. "Introduction PPT"               |
| url      | Link or path, e.g. `"#"` or `"https://..."`          |

**Example:**

```sql
INSERT INTO topic_materials (topic_id, type, title, url) VALUES
(1, 'ppt', 'కవి పరిచయం - PPT', '#'),
(1, 'notes', 'Topic 1 Notes', '#'),
(2, 'video', 'Video Lesson', 'https://www.youtube.com/embed/...');
```

Use your real `topic_id` values from the `topics` table.

---

### 3. **study_materials** (chapter-level materials)

For chapter-level materials (one list per chapter, not per topic).

| Column     | Example / notes                    |
|------------|------------------------------------|
| chapter_id | Use `id` from `chapters` (1–90)   |
| type       | e.g. `ppt`, `pdf`, `video`, `doc` |
| title      | Display name                       |
| url        | Link or `"#"`                     |

**Example:**

```sql
INSERT INTO study_materials (chapter_id, type, title, url) VALUES
(1, 'ppt', 'దానశీలము - PPT', '#'),
(1, 'pdf', 'Chapter 1 Notes', '#'),
(41, 'video', 'Real Numbers - Video', 'https://www.youtube.com/embed/...');
```

---

### 4. **homework** (assignments per class)

So the homework section shows real assignments and due dates.

| Column         | Example / notes                          |
|----------------|------------------------------------------|
| class_id       | Use `id` from `classes` (1–15)          |
| subject_name   | e.g. "Mathematics", "Telugu"            |
| chapter_name   | e.g. "Real Numbers"                     |
| title          | Assignment title                         |
| due_date       | DATE, e.g. `'2026-03-15'`               |
| assigned_date  | DATE, e.g. `'2026-03-01'`               |
| submissions    | Number (e.g. 0)                         |
| total_students | Number (e.g. 10)                        |

**Example:**

```sql
INSERT INTO homework (class_id, subject_name, chapter_name, title, due_date, assigned_date, submissions, total_students) VALUES
(1, 'Mathematics', 'Real Numbers', 'Ex 1.1 Problems 1-5', '2026-03-10', '2026-03-02', 0, 10),
(1, 'Telugu', 'దానశీలము', 'Write summary of lesson', '2026-03-12', '2026-03-02', 0, 10);
```

---

### 5. **live_sessions** (optional – usually created by the app)

This table is normally filled when a teacher **starts a live class** in the app. You can leave it empty; the “Live” tab will then show no sessions until someone starts one.  
If you want to show sample live sessions for testing, you can insert rows with `teacher_id`, `class_id`, `subject_id`, `start_time`, `status` (`'active'` or `'ended'`), etc., matching your `teachers`, `classes`, and `subjects` IDs.

---

## Summary

| Table            | Status in lms.sql | Action if you want it in the UI        |
|------------------|------------------|----------------------------------------|
| quiz_questions   | Empty            | Add questions linked to `quizzes.id`   |
| topic_materials  | Empty            | Add rows linked to `topics.id`         |
| study_materials  | Empty            | Add rows linked to `chapters.id`      |
| homework         | Empty            | Add rows linked to `classes.id`       |
| live_sessions    | Empty            | Optional; app can create them at runtime |

You don’t need to add anything for the main dashboard to work with **lms.sql**; the above are optional for richer content.
