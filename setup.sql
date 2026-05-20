-- =============================================================================
-- SETUP COMPLETO — Plataforma de Estudos para Concurso Público
-- Executar inteiramente no SQL Editor do Supabase
-- =============================================================================


-- =============================================================================
-- TABELAS
-- =============================================================================

-- Perfis dos usuários (espelha auth.users)
create table if not exists public.profiles (
  id          uuid references auth.users on delete cascade primary key,
  nome        text,
  email       text,
  tokens      integer default 0,
  xp          integer default 0,
  nivel       integer default 1,
  is_admin    boolean default false,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- Banco de questões
create table if not exists public.questions (
  id                uuid default gen_random_uuid() primary key,
  disciplina        text not null,  -- 'portugues' | 'matematica' | 'informatica'
  topico            text not null,
  enunciado         text not null,
  opcao_a           text not null,
  opcao_b           text not null,
  opcao_c           text not null,
  opcao_d           text not null,
  gabarito          text not null,  -- 'a' | 'b' | 'c' | 'd'
  explicacao        text,
  nivel_dificuldade text default 'medio',  -- 'facil' | 'medio' | 'dificil'
  ativo             boolean default true,
  created_at        timestamptz default now()
);

-- Respostas dos usuários
create table if not exists public.answers (
  id          uuid default gen_random_uuid() primary key,
  user_id     uuid references public.profiles(id) on delete cascade not null,
  question_id uuid references public.questions(id) on delete cascade not null,
  acertou     boolean not null,
  created_at  timestamptz default now()
);

-- Catálogo de conquistas
create table if not exists public.achievements (
  id          uuid default gen_random_uuid() primary key,
  slug        text unique not null,
  nome        text not null,
  descricao   text not null,
  icone       text,       -- emoji ou nome do ícone
  criterio    jsonb,      -- ex: {"tipo": "total_acertos", "valor": 10}
  created_at  timestamptz default now()
);

-- Conquistas desbloqueadas por usuário
create table if not exists public.user_achievements (
  id               uuid default gen_random_uuid() primary key,
  user_id          uuid references public.profiles(id) on delete cascade not null,
  achievement_id   uuid references public.achievements(id) on delete cascade not null,
  desbloqueado_em  timestamptz default now(),
  unique (user_id, achievement_id)
);


-- =============================================================================
-- ÍNDICES
-- =============================================================================

create index if not exists idx_answers_user_id      on public.answers(user_id);
create index if not exists idx_answers_question_id  on public.answers(question_id);
create index if not exists idx_questions_disciplina on public.questions(disciplina);
create index if not exists idx_questions_topico     on public.questions(topico);


-- =============================================================================
-- TRIGGERS
-- =============================================================================

-- Função genérica para atualizar updated_at automaticamente
create or replace function public.handle_updated_at()
returns trigger
language plpgsql
security definer
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Trigger de updated_at na tabela profiles
drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.handle_updated_at();

-- Função para auto-criar perfil quando usuário se cadastra no Auth
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, nome, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'nome', new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

-- Trigger no auth.users para chamar a função acima
drop trigger if exists trg_on_auth_user_created on auth.users;
create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- =============================================================================
-- RLS (Row Level Security)
-- =============================================================================

-- Habilitar RLS em todas as tabelas
alter table public.profiles         enable row level security;
alter table public.questions        enable row level security;
alter table public.answers          enable row level security;
alter table public.achievements     enable row level security;
alter table public.user_achievements enable row level security;

-- ----- profiles -----

-- Leitura: usuário vê apenas o próprio perfil
drop policy if exists "profiles: leitura proprio" on public.profiles;
create policy "profiles: leitura proprio"
  on public.profiles for select
  using (auth.uid() = id);

-- Insert: permitido ao criar conta (usado pelo trigger e pelo próprio usuário)
drop policy if exists "profiles: insert proprio" on public.profiles;
create policy "profiles: insert proprio"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Update: usuário edita apenas o próprio perfil
drop policy if exists "profiles: update proprio" on public.profiles;
create policy "profiles: update proprio"
  on public.profiles for update
  using (auth.uid() = id);

-- ----- questions -----

-- Leitura: qualquer usuário autenticado
drop policy if exists "questions: leitura autenticados" on public.questions;
create policy "questions: leitura autenticados"
  on public.questions for select
  using (auth.role() = 'authenticated');

-- Insert / Update / Delete: somente admins
drop policy if exists "questions: escrita admin" on public.questions;
create policy "questions: escrita admin"
  on public.questions for all
  using (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and is_admin = true
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and is_admin = true
    )
  );

-- ----- answers -----

-- Leitura: usuário vê apenas as próprias respostas
drop policy if exists "answers: leitura propria" on public.answers;
create policy "answers: leitura propria"
  on public.answers for select
  using (auth.uid() = user_id);

-- Insert: usuário insere apenas as próprias respostas
drop policy if exists "answers: insert proprio" on public.answers;
create policy "answers: insert proprio"
  on public.answers for insert
  with check (auth.uid() = user_id);

-- ----- achievements -----

-- Leitura pública para autenticados
drop policy if exists "achievements: leitura autenticados" on public.achievements;
create policy "achievements: leitura autenticados"
  on public.achievements for select
  using (auth.role() = 'authenticated');

-- Escrita: somente admins
drop policy if exists "achievements: escrita admin" on public.achievements;
create policy "achievements: escrita admin"
  on public.achievements for all
  using (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and is_admin = true
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and is_admin = true
    )
  );

-- ----- user_achievements -----

-- Leitura: usuário vê apenas as próprias conquistas
drop policy if exists "user_achievements: leitura propria" on public.user_achievements;
create policy "user_achievements: leitura propria"
  on public.user_achievements for select
  using (auth.uid() = user_id);

-- Insert: usuário insere apenas as próprias conquistas
drop policy if exists "user_achievements: insert proprio" on public.user_achievements;
create policy "user_achievements: insert proprio"
  on public.user_achievements for insert
  with check (auth.uid() = user_id);


-- =============================================================================
-- DADOS INICIAIS — Conquistas base
-- =============================================================================

insert into public.achievements (slug, nome, descricao, icone, criterio) values
  (
    'primeiro_acerto',
    'Primeira Resposta Certa',
    'Acertou a primeira questão da plataforma.',
    '🎯',
    '{"tipo": "total_acertos", "valor": 1}'
  ),
  (
    '10_acertos',
    'Dez Acertos',
    'Acumulou 10 acertos ao longo dos estudos.',
    '🔟',
    '{"tipo": "total_acertos", "valor": 10}'
  ),
  (
    '50_acertos',
    'Cinquenta Acertos',
    'Chegou a 50 questões respondidas corretamente.',
    '⭐',
    '{"tipo": "total_acertos", "valor": 50}'
  ),
  (
    '100_respondidas',
    'Centena Respondida',
    'Respondeu 100 questões no total, certo ou errado.',
    '💯',
    '{"tipo": "total_respondidas", "valor": 100}'
  ),
  (
    'disciplina_completa',
    'Mestre da Disciplina',
    'Completou todos os tópicos disponíveis de uma disciplina.',
    '🏆',
    '{"tipo": "topicos_completos_disciplina", "valor": 1}'
  ),
  (
    'streak_5',
    'Sequência de Fogo',
    'Acertou 5 questões consecutivas sem errar.',
    '🔥',
    '{"tipo": "streak_acertos", "valor": 5}'
  ),
  (
    'primeiro_login',
    'Bem-vindo!',
    'Fez o primeiro acesso à plataforma.',
    '👋',
    '{"tipo": "primeiro_login", "valor": 1}'
  )
on conflict (slug) do nothing;
