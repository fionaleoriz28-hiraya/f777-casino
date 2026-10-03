# F777 Provider Game Integration

F777 now has a provider-launch entry point for JILI, PG SOFT, and FC.

## What is built
- Provider buttons in the lobby.
- Server-side /api/provider-launch adapter.
- Provider allow-list: JILI, PG, FC.
- Server-side environment configuration.
- No provider secret is placed in browser code.
- Unconfigured providers remain in demo mode.

## What is still required for actual provider games
Actual proprietary games must be supplied through an authorized provider account or licensed aggregator. The provider/aggregator must supply approved integration documentation, operator credentials, game IDs, player/session parameters, callback requirements, and permitted deployment domains.

JILI and PG SOFT use provider-controlled integration mechanisms; their proprietary game files should not be copied into this repository.

## Configuration
Set these as server-side environment variables:
- JILI_LAUNCH_URL
- PG_LAUNCH_URL
- FC_LAUNCH_URL

Never put API keys, secret keys, merchant tokens, or wallet credentials in index.html.

## Deployment note
The current F777 GitHub Pages deployment is static. GitHub Pages cannot execute api/provider-launch.js. Deploy that adapter on a serverless runtime or replace it with a Supabase Edge Function, then point the browser to that backend.

Until authorized provider endpoints are configured, F777 remains a virtual-credit demo.