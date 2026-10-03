// F777 provider-launch adapter
// Server-side only. Do NOT expose provider secrets in index.html or client JS.
export default async function handler(req, res) {
  const provider = String(req.query?.provider || "").toUpperCase();
  const allowed = new Set(["JILI", "PG", "FC"]);
  if (!allowed.has(provider)) return res.status(400).json({ error: "Unsupported provider." });
  const key = provider + "_LAUNCH_URL";
  const baseUrl = process.env[key];
  if (!baseUrl) return res.status(503).json({ error: provider + " provider is not configured.", next: "Add the provider-issued launch endpoint as a server-side secret." });
  const gameId = String(req.query?.gameId || "");
  const playerId = String(req.query?.playerId || "demo-player");
  const url = new URL(baseUrl);
  if (gameId) url.searchParams.set("gameId", gameId);
  url.searchParams.set("playerId", playerId);
  return res.status(200).json({ provider, launchUrl: url.toString() });
}