/**
 * Quick AI stack verification for recommendations/chat endpoints.
 * Usage: npm run verify:ai
 */
import { readFileSync, existsSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, "..");

function loadEnv() {
  const envPath = resolve(root, ".env");
  if (!existsSync(envPath)) return;
  const text = readFileSync(envPath, "utf8");
  for (const line of text.split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$/);
    if (!m) continue;
    const key = m[1];
    let val = m[2].replace(/\s+$/, "");
    if ((val.startsWith("\"") && val.endsWith("\"")) || (val.startsWith("'") && val.endsWith("'"))) val = val.slice(1, -1);
    if (process.env[key] === undefined) process.env[key] = val;
  }
}

async function tryFetch(url, options) {
  try {
    const r = await fetch(url, { ...options, signal: AbortSignal.timeout(12000) });
    const text = await r.text();
    let body;
    try { body = JSON.parse(text); } catch { body = { raw: text.slice(0, 200) }; }
    return { ok: r.ok, status: r.status, body };
  } catch (e) {
    return { ok: false, status: 0, body: { error: e instanceof Error ? e.message : String(e) } };
  }
}

loadEnv();
const configured = (process.env.VITE_AI_API_URL || "").trim().replace(/\/$/, "");
const bases = Array.from(new Set([configured, "http://127.0.0.1:8000", "http://localhost:8000"].filter(Boolean)));

console.log("\n=== AI stack verification ===\n");
let baseHit = "";
for (const b of bases) {
  const h = await tryFetch(`${b}/health`);
  if (h.ok && h.body?.ok) {
    baseHit = b;
    break;
  }
}

if (!baseHit) {
  console.log("[FAIL] Could not reach AI /health on any candidate base:");
  for (const b of bases) console.log(`       - ${b}`);
  process.exit(1);
}
console.log(`[OK] AI health reachable at ${baseHit}`);

const reco = await tryFetch(`${baseHit}/recommend`, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ topic: "Location and map", subject: "Social Studies", grade: 10 }),
});
if (!reco.ok) {
  console.log("[FAIL] POST /recommend failed");
  console.log("       ", reco.body?.error || reco.body);
  process.exit(1);
}
const vCount = Array.isArray(reco.body?.videos) ? reco.body.videos.length : 0;
const rCount = Array.isArray(reco.body?.resources) ? reco.body.resources.length : 0;
console.log(`[OK] /recommend returned videos=${vCount}, resources=${rCount}`);

const ask = await tryFetch(`${baseHit}/ask`, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ question: "What are relief features?" }),
});
if (!ask.ok || !ask.body?.answer) {
  console.log("[FAIL] POST /ask failed");
  console.log("       ", ask.body?.error || ask.body);
  process.exit(1);
}
console.log("[OK] /ask returned answer text");
console.log("\nResult: AI stack ready.\n");
