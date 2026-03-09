# Database requirements for Admin Dashboard

Use this as a checklist. Provide table structures or sample data for any item you want wired end-to-end.

---

## 1. Weak Chapter Heatmap (Overview) – “that week only”

The heatmap can show only chapters for **the current week** when the syllabus table marks which week is current.

**What we need from you:**

- **Option A:** A table or column that defines “current week” (e.g. `chapter_syllabus.is_current_week = 1` for the active week). The app already filters by `chapter_syllabus.is_current_week` when building `currentWeekChapterIds`. So:
  - Ensure `chapter_syllabus` exists and has an `is_current_week` (TINYINT) column.
  - Set `is_current_week = 1` for the rows that belong to the **current week** (and 0 for others). You can do this manually or with a small script/cron.
- **Option B:** If you prefer “current week” to be computed from **today’s date** (e.g. week number of the academic year), tell us:
  - Academic year start date (e.g. 1 June).
  - We can then add backend logic to compute “current week” and filter heatmap by it.

Once we know which option you use, we can document or adjust the logic accordingly.

---

## 2. Live sessions – “Do they work?”

- **What works today:** The dashboard reads `live_sessions` from the DB and shows:
  - Count of “live” sessions and a “Watch Live” button per class.
  - A simple “Live Class Monitoring” view (placeholder for stream).

- **What is not implemented:** Actual **video/audio streaming** (e.g. WebRTC, HLS, or a third‑party embed). So “Watch Live” only opens the monitoring layout; there is no real stream yet.

**To make live sessions “work” end-to-end we need:**

- How you plan to stream (e.g. Zoom link, YouTube Live, custom WebRTC, etc.).
- If stream URLs are stored in DB: table/column name (e.g. `live_sessions.stream_url` or `meeting_link`). Then we can open that URL or embed it in the monitoring view.

---

## 3. Schools – CRUD

- **Add School** and **Edit School** use: `name`, `code`, `district`, `sessions_completed`, `active_status`.
- The backend expects a `schools` table with at least:
  - `id` (PK, auto increment)
  - `name` (VARCHAR)
  - `code` (VARCHAR)
  - `district` (VARCHAR)
  - `sessions_completed` (INT, optional, default 0)
  - `active_status` (TINYINT/BOOLEAN, optional, default 1)

If your `schools` table has different or fewer columns, send the exact schema and we’ll align the API and UI.

---

## 4. Teacher effectiveness

Teacher effectiveness is already loaded from the API as `teacherEffectiveness` and shown in the Teachers tab when data exists.

**What we need from you:**

- Table name and columns that hold “teacher effectiveness” (e.g. ratings, completion %, attendance, etc.). For example:
  - `teacher_effectiveness` with columns like: `teacher_id`, `school_id`, `rating`, `lesson_completion_rate`, `student_engagement`, etc.
- Or the same data in an existing table (e.g. `teachers` with extra columns, or a view).
- Sample rows (or a short description) so we can map fields to the UI (e.g. “Quiz avg”, “Engagement %”, “Lessons completed”).

Once we have that, we’ll add the query in `/api/all` and map the result to the existing Teacher Effectiveness cards.

---

## 5. Students and teachers – registration and CRUD

- **Students:** App uses `school_id`, `roll_no`, `full_name`, optional `password_hash`, and optional enrollment in a class via `enrollments`.
- **Teachers:** App uses `school_id`, `email`, `full_name`, optional `password_hash`.

**Note:** Passwords are currently sent and stored as plain text in `password_hash`. For production you should hash them (e.g. bcrypt) on the server before saving; we can add that once you confirm.

CRUD is implemented: Create (registration forms), Update/Put and Delete via API (and can be wired in the UI for list views if you want).

---

## 6. Materials – syllabus and “current week”

- Materials flow: **Class (6–10) → Subject → Chapter → Topic-wise micro plan** is implemented. Syllabus text comes from `chapter_syllabus` (e.g. `month_label`, `week_label`, `periods`, `teaching_plan`).
- **Textbook** and **Whole year micro lesson plan** open a dialog with filters: **Month**, **Week**, **Chapter**. The filtered content can be driven by the same `chapter_syllabus` (and related) data once we know the exact columns and how you want to filter (e.g. by date range or by week number).

If you have another table for “textbook” or “whole year plan” (e.g. PDF links or long text), share the schema and we’ll plug it into the dialog.

---

## Summary – what to send

1. **Weak chapter heatmap:** Confirm Option A (current week in `chapter_syllabus`) or Option B (date-based week), and if B: academic year start date.
2. **Live sessions:** How you’ll provide the stream (e.g. URL column name or integration type).
3. **Schools:** Exact `schools` table schema if it differs from above.
4. **Teacher effectiveness:** Table name + column list (+ sample row or short description).
5. **Password hashing:** Confirm if we should add bcrypt (or your chosen method) on the server for `students.password_hash` and `teachers.password_hash`.
6. **Textbook / Whole year plan:** Table or columns for filtered content, if different from `chapter_syllabus`.

Once you provide these, we can wire everything to your database and adjust the UI copy (e.g. “Showing data for current week”) where needed.
