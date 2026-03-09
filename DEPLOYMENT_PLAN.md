# Plan of Action for Deployment

Follow this order. Use **Railway** for app + MySQL (or your chosen platform).

---

## Phase 1: Before you deploy (local)

| Step | Action | Verify |
|------|--------|--------|
| 1.1 | Run full test suite | `npm run test:all` → all pass |
| 1.2 | Install deps and build | `npm ci` then `npm run build` | No errors; `dist/` folder exists at repo root |
| 1.3 | Start server locally | `node backend/server/index.js` | Open http://localhost:3001 → app loads, `/api/health` returns `{"ok":true}` |
| 1.4 | Commit and push | Push to GitHub (or your Git host) | Latest code is on the branch Railway will use |

---

## Phase 2: Railway project setup

| Step | Action | Notes |
|------|--------|--------|
| 2.1 | Create / open project | Railway dashboard → New Project (or use existing) | |
| 2.2 | Add MySQL | In project → **+ New** → **Database** → **MySQL** | Wait until it shows “Active” and has a **Variables** / **Connect** tab |
| 2.3 | Add app service | **+ New** → **GitHub Repo** (or **Empty** and connect later) | Choose this repo; **Root directory** = leave **empty** (repo root) |
| 2.4 | Link MySQL to app | App service → **Variables** → **Add reference** (or copy from MySQL service) | You need: `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` |

---

## Phase 3: App service configuration

| Step | Action | Value |
|------|--------|--------|
| 3.1 | **Build command** | `npm run build` | Or leave default if Nixpacks/Procfile already set it |
| 3.2 | **Start command** | `node backend/server/index.js` | Must be exactly this (not `node server/index.js`) |
| 3.3 | **Root directory** | *(empty)* | Repository root so both `frontend/` and `backend/` exist |
| 3.4 | **Variables** (required) | From MySQL service or manual | `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` |
| 3.5 | **Variables** (optional) | For same-origin API | `VITE_API_URL` = your app’s public URL (e.g. `https://your-app.up.railway.app`) so frontend calls the same host |

---

## Phase 4: Database (one-time)

| Step | Action | Notes |
|------|--------|--------|
| 4.1 | Open MySQL in Railway | MySQL service → **Data** or **Query** (or use connection string in a MySQL client) | |
| 4.2 | Run core schema | Copy **entire** `database/railway_core_schema.sql` → paste in query box → **Run** | Creates tables + seed admin/teacher/school/class |
| 4.3 | (Optional) Extra tables | If you need live quiz / topic recommendations: run `database/topic_recommendations_and_live_quiz.sql` | Only if the app reports missing tables for those features |

**Default logins after schema:**

- **Admin:** `admin@lms.com` / `Password123`
- **Teacher:** `teacher@lms.com` / `Password123`

---

## Phase 5: Deploy and get URL

| Step | Action | Notes |
|------|--------|--------|
| 5.1 | Deploy | Push to connected branch, or **Deploy** in Railway | Build runs (`npm run build`), then start runs (`node backend/server/index.js`) |
| 5.2 | Generate domain | App service → **Settings** → **Networking** → **Generate Domain** | You get a URL like `https://your-app.up.railway.app` |
| 5.3 | (Optional) Set VITE_API_URL | In app **Variables**, add `VITE_API_URL` = that URL | Needed only if frontend and API are on different origins; same domain = often not needed |

---

## Phase 6: After deploy (verify)

| Step | Action | Expected |
|------|--------|----------|
| 6.1 | Open app URL | Visit `https://your-app.up.railway.app` | Login page or homepage loads (no blank screen) |
| 6.2 | Check health | Open `https://your-app.up.railway.app/api/health` | `{"ok":true}` |
| 6.3 | Check DB | Open `https://your-app.up.railway.app/api/db-check` | `{"ok":true,"message":"Database connected"}` or 500 if DB not set up |
| 6.4 | Log in | Admin: `admin@lms.com` / `Password123` | Dashboard loads |
| 6.5 | Change passwords | After first login, change default passwords (when that feature exists) | Security |

---

## Quick reference

- **Build:** `npm run build` (output: root `dist/`)
- **Start:** `node backend/server/index.js`
- **Schema:** Run `database/railway_core_schema.sql` once on Railway MySQL
- **Root dir:** Leave empty (repo root)
- **Seeds:** Admin `admin@lms.com`, Teacher `teacher@lms.com`, password `Password123`

---

## If something fails

| Symptom | Check |
|---------|--------|
| Build fails | Root directory = empty; `package.json` and `frontend/` at repo root; build command = `npm run build` |
| “Cannot find module” / “server/index.js not found” | Start command = `node backend/server/index.js` (with `backend/`) |
| Blank page / 404 on routes | Build succeeded and `dist/` is present; no root directory override to `frontend` |
| “Database connection failed” | MySQL variables set on **app** service; schema run on MySQL (Phase 4) |
| “Table X doesn’t exist” | Run `database/railway_core_schema.sql`; if needed, run `topic_recommendations_and_live_quiz.sql` |
| 413 Payload Too Large | Server allows 100 MB; ensure large files aren’t in deploy (e.g. `uploads/` in `.railwayignore`) |

---

## Summary order

1. **Local:** Tests → build → run server → push code  
2. **Railway:** New project → MySQL + App from repo → link DB variables  
3. **Config:** Build = `npm run build`, Start = `node backend/server/index.js`, root = empty  
4. **DB:** Run `railway_core_schema.sql` on MySQL once  
5. **Deploy:** Push / deploy → generate domain  
6. **Verify:** App URL → `/api/health` → `/api/db-check` → login  

After this plan is done, you’re deployed. If you tell me your platform (e.g. “Railway” or “Docker on a VPS”), we can go step-by-step through the actual deploy next.
