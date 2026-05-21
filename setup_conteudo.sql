-- =============================================================================
-- SETUP CONTEÚDO — Tabelas para o Painel de Gestão
-- Executar no SQL Editor do Supabase
-- =============================================================================

-- Tópicos de cada disciplina (substitui o array hardcoded no index.html)
create table if not exists public.topics (
  id          uuid default gen_random_uuid() primary key,
  disciplina  text not null,
  titulo      text not null,
  ordem       integer default 0,
  ativo       boolean default true,
  created_at  timestamptz default now()
);

-- Conteúdo de cada tópico (texto HTML + vídeo principal)
create table if not exists public.topic_content (
  id          uuid default gen_random_uuid() primary key,
  topic_id    uuid references public.topics(id) on delete cascade not null unique,
  texto_html  text,
  video_url   text,
  updated_at  timestamptz default now()
);

-- Vídeos sugeridos de cada tópico
create table if not exists public.topic_videos (
  id          uuid default gen_random_uuid() primary key,
  topic_id    uuid references public.topics(id) on delete cascade not null,
  titulo      text not null,
  canal       text,
  youtube_id  text not null,
  ordem       integer default 0,
  ativo       boolean default true,
  created_at  timestamptz default now()
);

-- Avisos para os alunos
create table if not exists public.announcements (
  id          uuid default gen_random_uuid() primary key,
  titulo      text not null,
  corpo       text not null,
  tipo        text default 'info',
  fixado      boolean default false,
  ativo       boolean default true,
  expira_em   timestamptz,
  created_at  timestamptz default now()
);

-- =============================================================================
-- ÍNDICES
-- =============================================================================

create index if not exists idx_topics_disciplina on public.topics(disciplina);
create index if not exists idx_topics_ordem       on public.topics(ordem);
create index if not exists idx_topic_videos_topic on public.topic_videos(topic_id);

-- =============================================================================
-- RLS
-- =============================================================================

alter table public.topics         enable row level security;
alter table public.topic_content  enable row level security;
alter table public.topic_videos   enable row level security;
alter table public.announcements  enable row level security;

-- Leitura: qualquer autenticado
drop policy if exists "topics: leitura autenticados"        on public.topics;
drop policy if exists "topic_content: leitura autenticados" on public.topic_content;
drop policy if exists "topic_videos: leitura autenticados"  on public.topic_videos;
drop policy if exists "announcements: leitura autenticados" on public.announcements;

create policy "topics: leitura autenticados"
  on public.topics for select using (auth.role() = 'authenticated');

create policy "topic_content: leitura autenticados"
  on public.topic_content for select using (auth.role() = 'authenticated');

create policy "topic_videos: leitura autenticados"
  on public.topic_videos for select using (auth.role() = 'authenticated');

create policy "announcements: leitura autenticados"
  on public.announcements for select using (auth.role() = 'authenticated');

-- Escrita: somente admins
drop policy if exists "topics: escrita admin"        on public.topics;
drop policy if exists "topic_content: escrita admin" on public.topic_content;
drop policy if exists "topic_videos: escrita admin"  on public.topic_videos;
drop policy if exists "announcements: escrita admin" on public.announcements;

create policy "topics: escrita admin"
  on public.topics for all
  using (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true));

create policy "topic_content: escrita admin"
  on public.topic_content for all
  using (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true));

create policy "topic_videos: escrita admin"
  on public.topic_videos for all
  using (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true));

create policy "announcements: escrita admin"
  on public.announcements for all
  using (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from public.profiles where id = auth.uid() and is_admin = true));

-- =============================================================================
-- MIGRAÇÃO: importa os tópicos que já existem no index.html
-- =============================================================================

insert into public.topics (disciplina, titulo, ordem) values
  -- Língua Portuguesa
  ('lingua-portuguesa', 'Interpretação de textos',           1),
  ('lingua-portuguesa', 'Significação das palavras',         2),
  ('lingua-portuguesa', 'Fonologia',                         3),
  ('lingua-portuguesa', 'Ortografia',                        4),
  ('lingua-portuguesa', 'Formação de palavras',              5),
  ('lingua-portuguesa', 'Pontuação',                         6),
  ('lingua-portuguesa', 'Classes de palavras',               7),
  ('lingua-portuguesa', 'Conjugação verbal',                 8),
  ('lingua-portuguesa', 'Concordância',                      9),
  ('lingua-portuguesa', 'Regência',                         10),
  ('lingua-portuguesa', 'Colocação pronominal',             11),
  ('lingua-portuguesa', 'Crase',                            12),
  ('lingua-portuguesa', 'Figuras de linguagem',             13),
  ('lingua-portuguesa', 'Funções da linguagem',             14),
  ('lingua-portuguesa', 'Variações linguísticas',           15),
  -- Matemática
  ('matematica', 'Sistemas de numeração, divisibilidade, MDC e MMC',  1),
  ('matematica', 'Conjuntos numéricos e operações',                    2),
  ('matematica', 'Proporcionalidade e porcentagem',                    3),
  ('matematica', 'Funções e equações',                                 4),
  ('matematica', 'Trigonometria',                                      5),
  ('matematica', 'Progressões',                                        6),
  ('matematica', 'Análise combinatória',                               7),
  ('matematica', 'Matrizes e sistemas lineares',                       8),
  ('matematica', 'Geometria plana e espacial',                         9),
  ('matematica', 'Geometria analítica',                               10),
  ('matematica', 'Números complexos',                                 11),
  ('matematica', 'Polinômios',                                        12),
  ('matematica', 'Estatística básica',                                13),
  ('matematica', 'Probabilidades',                                    14),
  -- Noções de Informática
  ('nocoes-informatica', 'Sistemas operacionais (Windows e Linux)',    1),
  ('nocoes-informatica', 'Aplicativos de escritório (Office e LibreOffice)', 2),
  ('nocoes-informatica', 'Internet e computação em nuvem',            3),
  ('nocoes-informatica', 'E-mail e redes sociais',                    4),
  ('nocoes-informatica', 'Segurança e proteção de computadores',      5)
on conflict do nothing;
