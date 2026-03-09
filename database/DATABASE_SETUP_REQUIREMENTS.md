# Database setup requirements (before development)

Use this as the **single checklist** for what to set up in the database so the live site works correctly. All table and column names match what the API server expects.

---

## 1. Co-curricular activities

**Table:** `co_curricular_activities` (you already have this.)

**Your structure (keep as is):**

| Column           | Type           | Notes                    |
|------------------|----------------|--------------------------|
| id               | int unsigned   | PK, auto_increment       |
| title            | varchar(255)   | NOT NULL                 |
| category         | varchar(64)    | e.g. Sports, Technical, Cultural, Academic, Arts |
| activity_date    | date           | When the activity is     |
| status           | varchar(32)    | Default `upcoming`; use `upcoming` \| `ongoing` \| `completed` |
| description      | text           | Optional                 |
| registrations    | int unsigned   | Default 0                |
| icon             | varchar(32)    | e.g. 🏃, 🔬, 🎭          |
| results_json     | json           | Optional, e.g. `{"winner": "...", "runner_up": "..."}` |
| created_at       | datetime       |                          |
| updated_at       | datetime       |                          |

**What the app will do:**  
- Fetch all activities from this table (or one activity per category if we filter: Sports, Technical, Cultural, Academic, Arts).  
- Map to the UI as: **title**, **description**, **date** (from `activity_date`), **status**, **icon**, **registrations**, **category**.

**Optional – student registrations:**  
If you want “Register student” for an activity to be saved in the DB, add a second table:

- **Table:** `co_curricular_registrations`
- **Suggested columns:** `id`, `activity_id` (FK to co_curricular_activities.id), `student_id` (FK to students.id), `status` (e.g. `registered`), `created_at`.

**What you need to do:**  
- Keep your existing `co_curricular_activities` data and structure.  
- No change required for “fetch one activity per category”; that will be done in the API/frontend.  
- If you want registrations to persist, create `co_curricular_registrations` as above and we’ll wire the API to it.

---

## 2. Students section – attendance (why it shows 0%)

**Table:** `attendance`

**How the API uses it:**  
- It reads **every row** from `attendance`.  
- For each **student_id** it counts: **total** = number of rows, **present** = number of rows where **status = 'present'**.  
- Percentage = (present / total) × 100. If there are **no rows** for a student, total and present are 0, so the UI shows **0%**.

**Required structure:**

| Column     | Type         | Required | Notes                                      |
|------------|--------------|----------|--------------------------------------------|
| id         | int unsigned | PK       | auto_increment                             |
| student_id | int unsigned | YES      | FK to students.id                          |
| status     | varchar(32)  | YES      | Use exactly **'present'** or **'absent'**  |
| date       | date         | Optional | Recommended: one row per student per day  |

**Example – one row per student per day:**

- For **80%** for one student: e.g. 8 rows with `status = 'present'` and 2 with `status = 'absent'` (or 8 present and 2 absent on different dates).  
- So for each student you want to show a non-zero %, insert multiple rows (e.g. one per day/session).

**Example INSERTs (adjust student_id and dates to your data):**

```sql
-- Example: student_id 1 was present on 3 days, absent on 1 day → 75%
INSERT INTO attendance (student_id, status, date) VALUES
(1, 'present', '2026-02-01'),
(1, 'present', '2026-02-02'),
(1, 'present', '2026-02-03'),
(1, 'absent',  '2026-02-04');
-- Repeat for each student and each day/session you track.
```

**What you need to do:**  
1. Ensure the **`attendance`** table exists with at least: **student_id**, **status** (values `'present'` / `'absent'`).  
2. Add a **date** column if you want per-day attendance.  
3. Insert **multiple rows per student** (e.g. one per day or per session). More rows with `status = 'present'` → higher %.  
4. After this, the Students section will show the correct **dynamic** attendance % from the DB.

---

## 3. Chapters and topics (for live site)

**Tables:** `chapters`, `topics`, and optionally `topic_materials`.

**Chapters – required columns:**

| Column               | Type           | Notes                          |
|----------------------|----------------|--------------------------------|
| id                   | int unsigned   | PK, auto_increment             |
| subject_id           | int unsigned   | FK to subjects.id              |
| name                 | varchar(255)   | Chapter name                   |
| grade                | tinyint        | e.g. 6–10                      |
| order_num            | int unsigned   | Order in syllabus (default 1)  |
| chapter_no           | tinyint        | Optional                       |
| month_label          | varchar(128)   | Optional                       |
| periods              | tinyint        | Optional                       |
| teaching_plan_summary | varchar(512)  | Optional                       |
| concepts             | text           | Optional                       |

**Topics – required columns:**

| Column     | Type           | Notes                                      |
|------------|----------------|--------------------------------------------|
| id         | int unsigned   | PK, auto_increment                         |
| chapter_id | int unsigned   | FK to chapters.id                          |
| name       | varchar(255)   | Topic name                                 |
| order_num  | int unsigned   | Order within chapter (default 1)           |
| status     | varchar(32)    | **'not_started'** \| **'in_progress'** \| **'completed'** |

**What you need to do:**  
1. **chapters:** Insert one row per chapter, with correct **subject_id**, **grade**, **name**, **order_num**.  
2. **topics:** Insert one row per topic with **chapter_id**, **name**, **order_num**, **status**.  
3. Use **topics.status** to drive “syllabus progress” (e.g. set to `'completed'` when a topic is done).  
4. If you use **topic_materials** (for materials per topic), ensure that table has at least: **topic_id**, **type**, **title**, **url**.

The live site will then show the correct chapters and topics per subject/class and progress based on topic status.

---

## 4. Overview section – what to update in the DB

Overview uses:

- **Syllabus progress %**  
- **Quizzes (completed / total)**  
- **Sessions (conducted / scheduled)**  
- **Students ranked**

All of this must come from the database. Here is what to update.

### 4.1 Syllabus progress

- **Source:** `chapters` + `topics` for the selected subject and grade.  
- **Logic:** Progress = (chapters that have at least one topic with **status = 'completed'**) / total chapters (for that subject+grade).  
- **What to update:**  
  - Ensure **chapters** and **topics** are filled (see section 3).  
  - Set **topics.status** to `'completed'` (or `'in_progress'`) as lessons are done.  
- No extra table is required; the API already reads `chapters` and `topics`.

### 4.2 Quizzes (completed / total)

- **Source:** `quizzes`, `quiz_results`.  
- **quizzes:** At least **id**, **chapter_id** (links to chapters). One row per quiz per chapter.  
- **quiz_results:** **student_id**, **quiz_id**, **score**, **total**, optionally **submitted_at**.  
- **What to update:**  
  - Insert rows in **quizzes** (one per chapter if you have one quiz per chapter).  
  - Insert rows in **quiz_results** when students attempt quizzes.  
- Without **quiz_results**, “completed quizzes” and “students ranked” will be 0 or empty.

### 4.3 Sessions (conducted / scheduled)

- **Source:** `class_status`.  
- **Columns:** **id**, **date**, **class_id**, **status** (`'conducted'` or `'cancelled'`), **teacher_id**, **reason** (optional).  
- **What to update:**  
  - Insert one row per session (e.g. per day per class): **date**, **class_id**, **status**, **teacher_id**.  
- Then “Sessions” in the Overview and the “Class status” tab will show the correct counts.

### 4.4 Students ranked

- **Source:** Same as marks – **quiz_results** (and **quizzes** for chapter, **enrollments** for class).  
- **What to update:**  
  - Same as **4.2**: ensure **quiz_results** (and **quizzes**) are populated.  
- Ranking is by total (score/total)×100 for that class and subject chapters.

---

## 5. Summary checklist

| Area              | Table(s) to use / update                    | What to do |
|-------------------|---------------------------------------------|------------|
| **Co-curricular** | `co_curricular_activities`                 | Keep your table and data; app will fetch (e.g. one per category). Optional: add `co_curricular_registrations` for “Register student”. |
| **Attendance %**  | `attendance`                                | Ensure table has **student_id**, **status** (`'present'`/`'absent'`). Insert **multiple rows per student** (e.g. one per day). |
| **Chapters/Topics** | `chapters`, `topics` (and `topic_materials`) | Fill chapters per subject+grade; fill topics per chapter with **status**; set status to completed when done. |
| **Overview – syllabus** | `chapters`, `topics`                   | Same as above; progress comes from **topics.status**. |
| **Overview – quizzes** | `quizzes`, `quiz_results`               | Insert **quizzes** (chapter_id); insert **quiz_results** (student_id, quiz_id, score, total). |
| **Overview – sessions** | `class_status`                         | Insert one row per session: **date**, **class_id**, **status**, **teacher_id**. |
| **Overview – ranked** | `quiz_results`, `quizzes`, `enrollments` | Same as quizzes; ensure **quiz_results** and **enrollments** are populated. |

Once these are set, the development side can assume this structure and wire the live site to the database end-to-end.
