# Deployment checklist (Railway / Docker)

**The folder structure is fit for real-world deployment.** Use this checklist when deploying.

## Folder structure (deployment-ready)

- **Repo root** = app root (where `package.json`, `vite.config.ts`, `Dockerfile`, `Procfile` live).
- **frontend/** = Vite app (source in `frontend/src`, `frontend/index.html`, `frontend/public/`).
- **backend/server/** = Node API (`backend/server/index.js`); all paths use `process.cwd()` = repo root.
- **backend/ai_model/** = Python AI (optional; not required for Node server).
- **database/** = SQL schemas and seeds (run manually on your DB).
- **dist/** = created by `npm run build` at repo root; server serves it when present.

## Build and start (all platforms)

- **Build:** `npm run build` — runs Vite with `root: "frontend"`, outputs to **root `dist/`**.
- **Start:** `node backend/server/index.js` — serves API + static files from `dist/` and `uploads/` (created at runtime if missing).

All paths in the server use `process.cwd()` (app root), so **always run the start command from the repository root**.

## Docker

- **Dockerfile** copies `backend/` and `dist/` (from builder), runs `docker-entrypoint.sh` → `node backend/server/index.js`.
- **Build context** must be the **repo root** (so `frontend/`, `backend/`, `package.json`, `vite.config.ts` are present).
- **.dockerignore** excludes `/ai_model` (root only); `backend/ai_model` is still included when copying `backend/`.

```bash
docker build -t lms .
docker run -p 3001:3001 -e MYSQL_HOST=... lms
```

## Railway

1. **Root directory:** Leave empty or set to **repository root** (do not set to `frontend` or `backend`).
2. **Build command:** `npm run build` (default from railpack/nixpacks).
3. **Start command:** `node backend/server/index.js` (set in **Procfile**, **railpack.json**, or **nixpacks.toml**; override in Railway dashboard if needed).
4. **Variables:** Set `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` (and optionally `VITE_API_URL` for the frontend; same as the app URL in production).
5. **Database:** Run `database/railway_core_schema.sql` on the Railway MySQL instance once (see `database/RAILWAY_SETUP.md`).

**.railwayignore** excludes `ai_model`, `uploads`, `node_modules`, etc. The deployed app only needs `backend/server/` and the built `dist/`; the Python AI in `backend/ai_model/` is not required for the Node service.

## Nixpacks (if Railway uses it)

- **nixpacks.toml** already sets `build`: `npm run build`, `start`: `node backend/server/index.js`.
- No root directory override; Nixpacks runs from repo root.

## Common failures to avoid

| Issue | Fix |
|-------|-----|
| "Cannot find module" or "server/index.js not found" | Start command must be `node backend/server/index.js`, not `node server/index.js`. |
| Blank page or 404 for routes | Ensure `npm run build` ran and `dist/` exists at root; server serves from `process.cwd()/dist`. |
| Root directory set to `frontend` | Set to repo root so both `frontend/` and `backend/` are available for build and run. |
| 413 Payload Too Large | Already handled (100 MB limit in server). If needed, exclude large `uploads/` from deploy. |
| Database connection failed | Set MySQL variables and run `railway_core_schema.sql`; see `database/RAILWAY_SETUP.md`. |

## Cleanup (pre-deploy)

- **Removed:** Root `src/` (legacy duplicate), root `ai_model/` (duplicate of `backend/ai_model`). Use `frontend/` and `backend/ai_model` only.
- **Removed:** `build:dev` script; use `npm run build` for production.
- **Kept:** `frontend/src/data/demo-data.ts` as fallback when API is unavailable.

## Quick verify before deploy

From repo root:

```bash
npm ci
npm run build
node backend/server/index.js
```

Then open http://localhost:3001 — you should see the app and `/api/health` should return `{"ok":true}`.
