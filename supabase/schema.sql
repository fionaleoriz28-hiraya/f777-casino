create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.demo_wallets (
  user_id uuid primary key references auth.users(id) on delete cascade,
  credits integer not null default 10000 check (credits >= 0),
  updated_at timestamptz not null default now()
);

create table if not exists public.demo_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  game text not null check (game in ('slots','roulette','blackjack')),
  credits_before integer not null,
  credits_after integer not null,
  result jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.demo_wallets enable row level security;
alter table public.demo_sessions enable row level security;

create policy "profiles own row" on public.profiles
for all to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

create policy "wallet own row" on public.demo_wallets
for select to authenticated using ((select auth.uid()) = user_id);

create policy "sessions own rows" on public.demo_sessions
for select to authenticated using ((select auth.uid()) = user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  insert into public.profiles(id, display_name) values (new.id, coalesce(new.raw_user_meta_data->>'display_name', 'Player'))
  on conflict (id) do nothing;
  insert into public.demo_wallets(user_id, credits) values (new.id, 10000)
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
