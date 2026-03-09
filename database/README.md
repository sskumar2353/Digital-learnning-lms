# Database scripts

- **railway_core_schema.sql** – Run this **first** on an empty Railway (or fresh) MySQL database. It creates all core tables and seed data for login. See **RAILWAY_SETUP.md** for details.
- **DATABASE_REQUIREMENTS.md** – What data the app reads and what to insert for each feature.

## Run order (if adding scripts individually)

Run **railway_core_schema.sql** first. Then:

1. **alter-students-schools.sql**  
   Adds `section` (VARCHAR 64, nullable) to `students` and `mandal` (VARCHAR 128, nullable) to `schools`. Run after the base tables exist. If a column already exists, skip that ALTER.

2. **teacher_effectiveness-table.sql**  
   Creates the `teacher_effectiveness` table. Create it, then add rows (one per teacher per school per academic year). The app will load this and show Teacher Effectiveness in the dashboard.

3. **chapters-topics-syllabus.sql**  
   - Adds columns to `chapters`: `chapter_no`, `month_label`, `periods`, `teaching_plan_summary`, `concepts`.  
   - Inserts Social Studies chapters (grade 10) and their topics (micro lesson plan P1, P2, …).  
   - **Before running:** set `@subject_id = 1` to your actual Social Studies `subject_id` from the `subjects` table.  
   - If your MySQL version errors on `ADD COLUMN` (e.g. column already exists), run each `ALTER TABLE` line separately and skip any that fail.

**Teacher assignment logic**  
Teachers are linked to **schools** via `teachers.school_id` (primary school). Which **subject(s)** they teach in which **class(es)** and **school(s)** is stored in `teacher_assignments`: each row is (teacher_id, school_id, class_id, subject_id). So one teacher can have multiple rows (e.g. Maths in Class 8-A at School X, Science in Class 9-B at School X). The admin can change a teacher's school (updates `teachers.school_id`) and their class–subject assignments (updates `teacher_assignments` for that teacher) from the dashboard (Teachers → Manage Teachers → Edit).

After running these and adding data (e.g. teacher_effectiveness rows), restart the API server and refresh the dashboard.
