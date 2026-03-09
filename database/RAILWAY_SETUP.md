# Railway database setup

## Why you see "table doesn't exist" on Railway

- **Locally / previous host:** Your app was using a MySQL database that already had all tables and data (e.g. from an earlier setup or another script).
- **Railway:** The MySQL database is **new and empty** (or was created from a subset of scripts). Any table that was never created will cause errors like `Table 'railway.teachers' doesn't exist` or `Table 'railway.teacher_assignments' doesn't exist`.

So the app behaves the same; the **data and schema** on Railway are just not the same as your previous database.

## Fix: run the full schema once (recommended for empty DB)

If you see **"Table 'railway.teachers' doesn't exist"** or the database is **completely empty**:

1. In **Railway** → your project → **MySQL** service → open **Data** or **Query** (or connect with a MySQL client using the connection string from Variables).
2. **Copy the entire contents** of **`database/railway_core_schema.sql`**.
3. **Paste** into the Railway query box and **run** it.

This creates all core tables (admins, schools, classes, teachers, subjects, students, chapters, topics, enrollments, teacher_assignments, teacher_leaves, etc.) and inserts a **demo admin**, **demo school**, **demo teacher**, and **demo class** so you can log in immediately.

- **Admin login:** email `admin@lms.com` — password **`Password123`** (change after first login).
- **Teacher login:** email `teacher@lms.com` — password **`Password123`** (change after first login).

You can add more schools, teachers, and students from the app after logging in.

### If only one table is missing

If most tables already exist and one table is missing, run the relevant part of **`railway_core_schema.sql`** (e.g. the `CREATE TABLE IF NOT EXISTS` for that table) or run the full script again.

### Other tables the app uses

The full schema in `railway_core_schema.sql` includes the main tables. If you later see "table X doesn't exist", run the matching script from the `database/` folder (e.g. `topic_recommendations_and_live_quiz.sql` for live quiz tables).
