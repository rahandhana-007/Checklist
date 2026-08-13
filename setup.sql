-- EUDR Issue — jalankan SEMUA skrip ini di SQL Editor (boleh di-Run ulang)

create table if not exists public.eudr_progress (
  sh_id text primary key,
  done boolean not null default false,
  note text not null default '',
  done_at timestamptz,
  updated_at timestamptz not null default now()
);

alter table public.eudr_progress add column if not exists ha_after numeric;

alter table public.eudr_progress enable row level security;

drop policy if exists "eudr_select" on public.eudr_progress;
drop policy if exists "eudr_insert" on public.eudr_progress;
drop policy if exists "eudr_update" on public.eudr_progress;
drop policy if exists "eudr_delete" on public.eudr_progress;

create policy "eudr_select" on public.eudr_progress
  for select to anon, authenticated using (true);
create policy "eudr_insert" on public.eudr_progress
  for insert to anon, authenticated with check (true);
create policy "eudr_update" on public.eudr_progress
  for update to anon, authenticated using (true) with check (true);
create policy "eudr_delete" on public.eudr_progress
  for delete to anon, authenticated using (true);

create table if not exists public.eudr_files (
  id uuid primary key default gen_random_uuid(),
  sh_id text not null,
  kind text not null check (kind in ('geojson', 'photo')),
  path text not null unique,
  name text not null,
  size_bytes bigint,
  created_at timestamptz not null default now()
);

create index if not exists eudr_files_sh_id_idx on public.eudr_files (sh_id);

alter table public.eudr_files enable row level security;

drop policy if exists "eudr_files_select" on public.eudr_files;
drop policy if exists "eudr_files_insert" on public.eudr_files;
drop policy if exists "eudr_files_update" on public.eudr_files;
drop policy if exists "eudr_files_delete" on public.eudr_files;

create policy "eudr_files_select" on public.eudr_files
  for select to anon, authenticated using (true);
create policy "eudr_files_insert" on public.eudr_files
  for insert to anon, authenticated with check (true);
create policy "eudr_files_update" on public.eudr_files
  for update to anon, authenticated using (true) with check (true);
create policy "eudr_files_delete" on public.eudr_files
  for delete to anon, authenticated using (true);

insert into storage.buckets (id, name, public, file_size_limit)
values ('eudr-files', 'eudr-files', true, 15728640)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit;

drop policy if exists "eudr_obj_select" on storage.objects;
drop policy if exists "eudr_obj_insert" on storage.objects;
drop policy if exists "eudr_obj_update" on storage.objects;
drop policy if exists "eudr_obj_delete" on storage.objects;

create policy "eudr_obj_select" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'eudr-files');
create policy "eudr_obj_insert" on storage.objects
  for insert to anon, authenticated
  with check (bucket_id = 'eudr-files');
create policy "eudr_obj_update" on storage.objects
  for update to anon, authenticated
  using (bucket_id = 'eudr-files')
  with check (bucket_id = 'eudr-files');
create policy "eudr_obj_delete" on storage.objects
  for delete to anon, authenticated
  using (bucket_id = 'eudr-files');

do $$
begin
  begin
    alter publication supabase_realtime add table public.eudr_progress;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.eudr_files;
  exception when duplicate_object then null;
  end;
end $$;
