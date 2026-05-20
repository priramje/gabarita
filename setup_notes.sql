-- =============================================================================
-- GABARITA — Tabela de Anotações dos Usuários
-- Execute este script no SQL Editor do Supabase
-- =============================================================================

create table if not exists public.user_notes (
  id          uuid default gen_random_uuid() primary key,
  user_id     uuid references public.profiles(id) on delete cascade not null,
  disciplina  text not null,
  topico      text not null,
  conteudo    text default '',
  created_at  timestamptz default now(),
  updated_at  timestamptz default now(),
  unique (user_id, disciplina, topico)
);

-- Habilitar RLS
alter table public.user_notes enable row level security;

-- Trigger para updated_at (usa a mesma função já criada no setup.sql)
drop trigger if exists trg_user_notes_updated_at on public.user_notes;
create trigger trg_user_notes_updated_at
  before update on public.user_notes
  for each row execute procedure public.handle_updated_at();

-- Leitura: usuário vê apenas as próprias anotações
drop policy if exists "user_notes: leitura propria" on public.user_notes;
create policy "user_notes: leitura propria"
  on public.user_notes for select
  using (auth.uid() = user_id);

-- Insert: usuário insere apenas as próprias anotações
drop policy if exists "user_notes: insert proprio" on public.user_notes;
create policy "user_notes: insert proprio"
  on public.user_notes for insert
  with check (auth.uid() = user_id);

-- Update: usuário atualiza apenas as próprias anotações
drop policy if exists "user_notes: update proprio" on public.user_notes;
create policy "user_notes: update proprio"
  on public.user_notes for update
  using (auth.uid() = user_id);

-- Delete: usuário apaga apenas as próprias anotações
drop policy if exists "user_notes: delete proprio" on public.user_notes;
create policy "user_notes: delete proprio"
  on public.user_notes for delete
  using (auth.uid() = user_id);
