// Supabase-ready auth helper.
// Install @supabase/supabase-js in a real app and provide your project URL/key
// through your build system. Never expose a service-role key.
export const SUPABASE_URL = window.__SUPABASE_URL__ || "";
export const SUPABASE_PUBLISHABLE_KEY = window.__SUPABASE_PUBLISHABLE_KEY__ || "";

export function requireSupabaseConfig() {
  if (!SUPABASE_URL || !SUPABASE_PUBLISHABLE_KEY) {
    console.info("Supabase is not configured yet. Demo mode remains local-only.");
    return false;
  }
  return true;
}
