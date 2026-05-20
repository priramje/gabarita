-- =============================================================================
-- GABARITA — Tabela de Progresso de Fases (Níveis)
-- Execute este script no SQL Editor do Supabase
-- =============================================================================

create table if not exists public.user_progress (
  id                uuid default gen_random_uuid() primary key,
  user_id           uuid references public.profiles(id) on delete cascade not null,
  disciplina        text not null,
  topico            text not null,
  nivel_desbloqueado text default 'facil' not null,
  created_at        timestamptz default now(),
  updated_at        timestamptz default now(),
  unique (user_id, disciplina, topico)
);

-- Habilitar RLS
alter table public.user_progress enable row level security;

-- Trigger para updated_at
drop trigger if exists trg_user_progress_updated_at on public.user_progress;
create trigger trg_user_progress_updated_at
  before update on public.user_progress
  for each row execute procedure public.handle_updated_at();

-- Leitura: usuário vê apenas o próprio progresso
drop policy if exists "user_progress: leitura propria" on public.user_progress;
create policy "user_progress: leitura propria"
  on public.user_progress for select
  using (auth.uid() = user_id);

-- Insert: usuário insere apenas o próprio progresso
drop policy if exists "user_progress: insert proprio" on public.user_progress;
create policy "user_progress: insert proprio"
  on public.user_progress for insert
  with check (auth.uid() = user_id);

-- Update: usuário atualiza apenas o próprio progresso
drop policy if exists "user_progress: update proprio" on public.user_progress;
create policy "user_progress: update proprio"
  on public.user_progress for update
  using (auth.uid() = user_id);
