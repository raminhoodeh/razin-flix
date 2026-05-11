-- RazinFlix — Supabase Database Setup
-- Run this SQL in your Supabase SQL Editor to initialise the database.

-- ============================================
-- 1. Main Films Table
-- ============================================
create table if not exists razinflix_films (
    id          bigint primary key generated always as identity,
    title       text not null,
    year        text,
    director    text,
    rating      text,                -- e.g. "8.5/10"
    poster      text,                -- TMDB URL or Supabase Storage public link
    description text,                -- Gemini-generated atmospheric plot summary
    trailer_key text,                -- 11-character YouTube video ID
    categories  text[]               -- Postgres array, enforced by AI taxonomy
);

-- ============================================
-- 2. Storage Bucket for Custom Posters
-- ============================================
-- Create a public bucket called "razinflix_posters".
-- The API route auto-provisions this if it doesn't exist,
-- but you can create it manually here too:
--
-- insert into storage.buckets (id, name, public)
-- values ('razinflix_posters', 'razinflix_posters', true);

-- ============================================
-- 3. Row-Level Security (Optional but Recommended)
-- ============================================
-- Allow public read access to the films table:
alter table razinflix_films enable row level security;

create policy "Public read access"
    on razinflix_films
    for select
    using (true);

-- For write operations, the API routes use the SUPABASE_SERVICE_ROLE_KEY
-- which bypasses RLS entirely, so no insert/update/delete policies are needed.
