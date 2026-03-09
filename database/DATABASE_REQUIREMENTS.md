# Database requirements for Teacher Dashboard & app features

This document lists **what data the app reads from the database** and **what you need to insert** for each feature to work. Table names and column expectations are taken from the API server (`server/index.js`).

---

## 1. Marks / quiz results (do you have them in the DB?)

**Yes.** Marks (scores) come from the **`quiz_results`** table. The app does **not** let teachers “enter marks” in the UI; it only **reads** from the DB.

- **Table:** `quiz_results`
- **Expected columns:** `id`, `student_id`, `quiz_id`, `score`, `total`, `submitted_at` (optional)
- **How it’s used:**
  - **Students ranked** in Overview and Students tab: ranking is by total score % from `quiz_results` for that class and subject chapters.
  - **Student detail modal:** subject-wise scores and “weak areas” are computed from `quiz_results` (by chapter).
  - **Overview “Quizzes” card:** completed vs total quizzes uses `quiz_results` for the selected class/chapters.

**What you need to do:**  
Insert rows into `quiz_results` when students take quizzes (e.g. from a quiz submission flow, or manually for testing). Each row = one student’s attempt for one quiz: `student_id`, `quiz_id`, `score`, `total`, optionally `submitted_at`. Without data here, “Students ranked”, “Quizzes” counts, and performance/weak areas will be empty or zero.

---

## 2. Syllabus progress

**Source:** `chapters`, `topics`, and (optional) `chapter_syllabus`.

- **chapters:** `id`, `subject_id`, `name`, `grade`, `order_num`, plus optional `chapter_no`, `month_label`, `periods`, `teaching_plan_summary`, `concepts`.
- **topics:** `id`, `chapter_id`, `name`, `order_num`, `status` (`not_started` | `in_progress` | `completed`).
- **chapter_syllabus (optional):** used for “current week” in admin weak-topic heatmap; expects `chapter_id`, `is_current_week` (or similar). If the table is missing, the app still runs; syllabus progress in Teacher Dashboard does **not** depend on it.

**Progress calculation:**  
For the selected class and subject, the app uses chapters for that subject+grade and each chapter’s topics. “Syllabus progress %” = (chapters with at least one topic in `completed` or local state) / total chapters. So you need:

- **chapters** for each subject and grade.
- **topics** per chapter with `status` set (e.g. `completed` for done topics).

**What to insert:**  
Chapters and topics for all subjects/grades you use (e.g. from `chapters-topics-syllabus.sql`). Update `topics.status` when a topic is completed (today this can be local state in the app; persisting topic status to DB would require an API).

---

## 3. Quizzes

**Source:** `quizzes`, `quiz_results`.

- **quizzes:** `id`, `chapter_id` (links quiz to chapter). Other columns (e.g. questions) can exist but the API only uses this for mapping “which chapter this quiz belongs to”.
- **quiz_results:** see **Marks** above.

**What to insert:**
- One or more rows in `quizzes` per chapter (e.g. `chapter_id` = that chapter’s `id`).
- Rows in `quiz_results` when students attempt quizzes (`student_id`, `quiz_id`, `score`, `total`).

Without `quizzes`: “Quizzes” count and “completed quizzes” will be 0. Without `quiz_results`: no marks, no ranking, no performance data.

---

## 4. Sessions (class status)

**Source:** `class_status`.

- **Expected columns:** `id`, `date`, `class_id`, `status` (`conducted` | `cancelled`), `teacher_id`, `reason` (optional).

**What to insert:**  
One row per session (e.g. per day per class): `date`, `class_id`, `status`, `teacher_id`, and optionally `reason`. The Teacher Dashboard shows “Sessions conducted/scheduled” from this table for the selected class. When a teacher “ends” a live session, the app can add a row locally; to persist that to the DB you’d need a **POST** (or similar) API for `class_status` (not implemented yet).

**What you need to do:**  
Insert `class_status` rows for past/planned sessions so “Sessions” and “Class status” tab show real data. If you add an API to create/update class status from the app, then the app can insert/update these rows when a teacher marks a session as conducted/cancelled.

---

## 5. Students ranked

**Source:** Same as **Marks** – `quiz_results` plus `quizzes` (for chapter) and `enrollments` (for class).

Ranking = students in the selected class, ordered by total (score/total)*100 across all quiz results for that class and for the chapters of the selected subject. So you only need the same data as in **Marks** and **Quizzes**: `quiz_results` (and `quizzes`, `chapters`) populated.

---

## 6. Leave applications (CRUD)

**Source:** `teacher_leaves`.

- **Expected columns:** `id`, `teacher_id`, `start_date`, `reason`, `status` (e.g. `pending`), `applied_on` (date applied). The API also expects this table for **GET /api/all** (leave list) and **POST /api/teachers/leave** (create).

**Create (already implemented):**  
When a teacher submits a leave application in the app, the frontend calls **POST /api/teachers/leave** with `teacher_id`, `start_date`, `reason`. The server inserts into `teacher_leaves` and returns the new row. So **submitted leave is stored in the DB** and appears in “Your leave applications” after refetch.

**What you need to do:**  
- Ensure the **`teacher_leaves`** table exists with at least: `id` (PK), `teacher_id`, `start_date`, `reason`, `status`, `applied_on`.
- No need to manually insert leave data for “submit” to work; the app does it via the API.
- For **Update/Delete** (e.g. cancel leave, approve/reject): those APIs are not implemented yet. You would add PUT and DELETE for `teacher_leaves` and then wire the UI (e.g. “Cancel” button, admin “Approve/Reject”).

---

## 7. Co-curricular activities

**Current state:**  
The Teacher Dashboard has a “Co-Curricular” tab, but the app does **not** read co-curricular data from the database. It uses an empty list in code. So nothing is loaded from the DB for activities or registrations.

**To make it DB-driven you would:**

1. **Tables (example):**
   - `co_curricular_activities`: e.g. `id`, `title`, `description`, `date`, `status` (`upcoming` | `ongoing` | `completed`), `icon`, `created_at`.
   - `co_curricular_registrations`: e.g. `id`, `activity_id`, `student_id`, `status` (`registered` | `cancelled`), `created_at`.

2. **API:**  
   - In **GET /api/all** (or a dedicated endpoint), query these tables and return activities and registrations.  
   - Add **POST** (and optionally PUT/DELETE) for creating/updating activities and for registering/cancelling students.

3. **Frontend:**  
   - Replace the empty `activities` / `registrations` in Teacher Dashboard with data from the API (and call the new APIs on “Register student” / “Create activity”, etc.).

Until you add these tables and APIs, the Co-Curricular tab will stay empty and any “Register student” there will only update local state (lost on refresh).

---

## 8. Summary – what to insert for each feature

| Feature              | Tables involved           | What to insert / do |
|----------------------|---------------------------|----------------------|
| **Marks**            | `quiz_results`, `quizzes` | Insert quiz attempts: `student_id`, `quiz_id`, `score`, `total` (and optionally `submitted_at`). |
| **Syllabus progress**| `chapters`, `topics`      | Insert chapters and topics; set `topics.status` for progress. Optional: `chapter_syllabus` for current week. |
| **Quizzes**          | `quizzes`, `quiz_results`  | Insert `quizzes` per chapter; insert `quiz_results` when students take quizzes. |
| **Sessions**         | `class_status`             | Insert one row per session (date, class_id, status, teacher_id). Optionally add API to create/update from app. |
| **Students ranked**  | Same as Marks             | Same as **Marks** – fill `quiz_results` (and `quizzes`). |
| **Leave**            | `teacher_leaves`          | Table must exist. Submitting leave in the app inserts via **POST /api/teachers/leave**. For full CRUD, add PUT/DELETE and UI. |
| **Co-curricular**    | None yet                  | Add tables (e.g. `co_curricular_activities`, `co_curricular_registrations`) and APIs, then wire the tab to API data. |

---

## 9. Teacher_leaves table (reference for leave CRUD)

If you don’t have `teacher_leaves` yet, create it, for example:

```sql
CREATE TABLE teacher_leaves (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT UNSIGNED NOT NULL,
  start_date DATE NOT NULL,
  reason VARCHAR(512) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'pending',
  applied_on DATE NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);
```

Then teachers can submit leave from the dashboard and it will be stored and listed from the database.
