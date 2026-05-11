# 🎬 RazinFlix

> A self-maintaining, AI-enriched personal streaming platform — converted from a spreadsheet into a Netflix-fidelity experience.

![RazinFlix — AI-enriched personal streaming library](https://raw.githubusercontent.com/raminhoodeh/razinflix/main/docs/razinflix-screenshot.png)

**Live:** [nsso.me/film/razinflix](https://nsso.me/film/razinflix)

---

## Overview

RazinFlix transforms a personal film library — originally maintained as a spreadsheet — into a production-grade streaming UI indistinguishable from Netflix. It is not a UI skin over an existing service. Every film is autonomously ingested, enriched, validated, and maintained by a multi-API AI pipeline, with zero manual data entry required beyond typing a film title.

Built as a feature within the [nsso](https://nsso.me) platform, RazinFlix is a showcase of what happens when a personal passion project is engineered with production-level discipline.

---

## What Makes It Impressive

### 1. Spreadsheet → Streaming Platform Migration

The entire library originated as a flat spreadsheet of film titles. Getting that data to production involved:

- A **bulk migration pipeline** (`migrate-razinflix.ts`) to ingest raw records into Supabase Postgres
- A **duplicate resolver** (`resolve_dups.py`) using Levenshtein distance fuzzing and token overlap scoring to detect near-identical entries (e.g. `Bladerunner 2049` vs `Blade Runner 2049`) and automatically scrub the lower-quality record based on data completeness scoring

---

### 2. 4-API Zero-Effort Ingestion Engine

When an admin types a film title, four APIs fire in parallel to fully enrich the record:

| API | Role |
|---|---|
| **TMDB API** | Fetches metadata: poster, release year, director, IMDb rating |
| **YouTube Data API v3** | Resolves the official trailer using a query engineered to exclude reviews and reaction videos |
| **Google Cloud Vision OCR** | Validates the poster at the pixel level — scans the `.jpg` image matrix to confirm the English-language title physically appears in the artwork, rejecting blank or foreign-language TMDB placeholders |
| **Gemini 2.5 Flash** | Generates a 2-sentence atmospheric plot summary and taxonomically assigns the film to one of 14 curated categories — overriding TMDB's generic genre tags entirely |

**The result:** One text input → a fully enriched, categorised, trailer-linked, poster-validated film entry. No manual data entry.

---

### 3. Self-Healing Database Architecture

RazinFlix doesn't just ingest data — it actively maintains its own integrity:

- **Update Mode** — A dedicated admin view that programmatically surfaces films with missing posters or trailers to the top of the grid, making data gaps immediately visible
- **Live poster health checks** — On entering Update Mode, the frontend batch-validates every poster URL against a 4-second timeout and flags broken links in real time
- **Autonomous category repair** (`cleanup-categories.mjs`) — A Gemini-powered Node pipeline that reads malformed or orphaned category strings and re-maps them to the correct taxonomy, patching the database without human intervention
- **Trailer recovery** — Maintenance scripts auto-harvest missing `trailer_key` IDs via YouTube API string permutations when a null value is detected

---

### 4. Netflix-Fidelity Frontend

- **Cinematic Hero Billboard** with autoplay YouTube trailer, volume toggle, and mobile swipe gestures
- **Algorithmic category carousels** — derived dynamically from the database. Zero hardcoded assumptions. Categories with fewer than 5 films dissolve automatically, folding their entries into a catch-all master row
- **iOS-native UX** — bottom safe-area padding, bottom-sheet modal physics, and body scroll locking on modal open
- **Desktop mute binding** — clicking anywhere on the hero background toggles volume, mirroring native Netflix behaviour

---

### 5. Contextual Recommendations Engine

Clicking any film opens a detail modal that surfaces **similar titles** from the same category — functionally equivalent to Netflix's "More Like This" row. Navigation between films is supported inline without closing the modal.

---

### 6. Secure Admin Layer

- Password-gated write access before any add, edit, or delete operation can be triggered
- Edit modal exposes a constrained category selector — only the 14 approved taxonomy values are available; the API independently rejects non-conforming payloads at the backend
- Destructive deletions execute recursive client-side state-tree sweeps for instant UI removal, no page reload required

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js (App Router), TypeScript |
| Styling | Tailwind CSS |
| Database | Supabase Postgres |
| Storage | Supabase Storage (poster images) |
| AI Enrichment | Google Gemini 2.5 Flash |
| Poster Validation | Google Cloud Vision API |
| Trailer Resolution | YouTube Data API v3 |
| Metadata | TMDB API |

---

## Database Schema

```sql
create table razinflix_films (
    id          bigint primary key generated always as identity,
    title       text not null,
    year        text,
    director    text,
    rating      text,                -- IMDb rating string
    poster      text,                -- TMDB URL or Supabase storage link
    description text,                -- Gemini-generated 2-sentence atmospheric plot
    trailer_key text,                -- 11-character YouTube video ID
    categories  text[]               -- Postgres array, enforced by LLM taxonomy
);
```

---

## In One Sentence

> *RazinFlix converts a personal film spreadsheet into a self-maintaining Netflix clone — a 4-API AI pipeline validates posters at the pixel level, writes descriptions, resolves trailers, and enforces a curated taxonomy, while autonomous scripts continuously repair and re-classify the database without human intervention.*

---

© 2026 RazinFlix.
