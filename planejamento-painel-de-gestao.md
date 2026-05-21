# Planejamento: Painel de Gestão de Conteúdo — Gabarita

**Data de criação:** 21/05/2026  
**Objetivo:** Criar um painel administrativo para gerenciar todo o conteúdo da plataforma (aulas, vídeos, textos, avisos e questões) sem precisar editar código.

---

## Diagnóstico Atual

| O que é | Onde fica hoje | Problema |
|---|---|---|
| Disciplinas e tópicos | Objeto `DISCIPLINES` hardcoded no `index.html` (linha ~2961) | Qualquer mudança exige editar código |
| Conteúdo das aulas | HTML dentro de strings JavaScript (`texto`, `videoUrl`, `sugeridos`) | Impossível gerenciar sem dev |
| Questões | Tabela `questions` no Supabase | OK, mas só inseríveis via SQL bruto |
| Avisos | Não existem | Não tem como comunicar com os alunos |

---

## Visão Geral da Solução

Três entregas independentes que se complementam:

```
[1] SQL — Novas tabelas no Supabase
      ↓
[2] admin.html — Painel de gestão (protegido por is_admin)
      ↓
[3] index.html — Carrega conteúdo dinamicamente do banco
```

---

## ENTREGA 1 — SQL: Novas Tabelas (`setup_conteudo.sql`)

### Tabela `topics`
Substitui o array `topicos` do objeto DISCIPLINES.

```sql
create table public.topics (
  id           uuid default gen_random_uuid() primary key,
  disciplina   text not null,           -- 'lingua-portuguesa' | 'matematica' | 'nocoes-informatica'
  titulo       text not null,
  ordem        integer default 0,       -- define a sequência na sidebar
  ativo        boolean default true,
  created_at   timestamptz default now()
);
```

### Tabela `topic_content`
O conteúdo (texto e vídeo principal) de cada tópico.

```sql
create table public.topic_content (
  id           uuid default gen_random_uuid() primary key,
  topic_id     uuid references public.topics(id) on delete cascade not null,
  texto_html   text,                    -- HTML rico do conteúdo da aula
  video_url    text,                    -- URL do YouTube embed (ex: https://www.youtube.com/embed/XXXXX)
  updated_at   timestamptz default now()
);
```

### Tabela `topic_videos`
Vídeos sugeridos de cada tópico.

```sql
create table public.topic_videos (
  id           uuid default gen_random_uuid() primary key,
  topic_id     uuid references public.topics(id) on delete cascade not null,
  titulo       text not null,
  canal        text,
  youtube_id   text not null,           -- só o ID do vídeo (ex: h0CKy8IFxh4)
  ordem        integer default 0,
  ativo        boolean default true,
  created_at   timestamptz default now()
);
-- thumb gerada automaticamente: https://img.youtube.com/vi/{youtube_id}/mqdefault.jpg
-- link: https://www.youtube.com/watch?v={youtube_id}
-- embed: https://www.youtube.com/embed/{youtube_id}
```

### Tabela `announcements`
Avisos exibidos no dashboard do aluno.

```sql
create table public.announcements (
  id           uuid default gen_random_uuid() primary key,
  titulo       text not null,
  corpo        text not null,
  tipo         text default 'info',     -- 'info' | 'aviso' | 'conquista' | 'urgente'
  ativo        boolean default true,
  fixado       boolean default false,   -- aparece sempre no topo
  expira_em    timestamptz,             -- null = não expira
  created_at   timestamptz default now()
);
```

### RLS das novas tabelas
- `topics`, `topic_content`, `topic_videos`, `announcements`:
  - **SELECT:** qualquer autenticado
  - **INSERT / UPDATE / DELETE:** somente `is_admin = true`

---

## ENTREGA 2 — `admin.html`: O Painel de Gestão

Arquivo separado do `index.html`. Protegido: se o usuário não for admin, redireciona para o `index.html`.

### Estrutura do painel

```
┌─────────────────────────────────────────────┐
│  🎓 Gabarita Admin           [Sair]          │
├───────────┬─────────────────────────────────┤
│           │                                 │
│  📚 Aulas │   [ Área de conteúdo da aba ]   │
│  🎬 Vídeos│                                 │
│  📝 Textos│                                 │
│  📢 Avisos│                                 │
│  ❓ Quest.│                                 │
│           │                                 │
└───────────┴─────────────────────────────────┘
```

### Aba 1 — Aulas (Tópicos)

**Funcionalidades:**
- Listar todos os tópicos, agrupados por disciplina
- Reordenar arrastando (drag-and-drop simples via botões ▲▼)
- Criar novo tópico: escolher disciplina + digitar título
- Ativar/desativar tópico (toggle)
- Deletar tópico (com confirmação)

**Layout:**
```
[ + Novo tópico ]

▼ Língua Portuguesa
  ▲▼  Interpretação de textos    [ativo ✓]  [editar] [deletar]
  ▲▼  Significação das palavras  [ativo ✓]  [editar] [deletar]
  ▲▼  Fonologia                  [ativo ✓]  [editar] [deletar]
  ...

▼ Matemática
  ...
```

### Aba 2 — Conteúdo de Texto das Aulas

**Funcionalidades:**
- Selecionar disciplina → selecionar tópico
- Editor de texto rico (usando `contenteditable` simples com barra de formatação: negrito, itálico, lista)
- Campo separado para o vídeo principal (colar URL do YouTube → extrai o ID automaticamente)
- Botão "Salvar" → faz upsert na tabela `topic_content`
- Preview do conteúdo à direita

**Layout:**
```
Disciplina: [ Língua Portuguesa ▼ ]   Tópico: [ Interpretação de textos ▼ ]

Vídeo principal:
[ URL do YouTube _______________________________ ]  [ Extrair ID ]
Preview: ▶ https://youtube.com/embed/ibwf_X3498c

Texto da aula:
┌─────────────────────────────────────────────┐
│ [B] [I] [U] [Lista] [H3]                    │
├─────────────────────────────────────────────┤
│                                             │
│  (editor de texto)                          │
│                                             │
└─────────────────────────────────────────────┘

[ Salvar conteúdo ]
```

### Aba 3 — Vídeos Sugeridos

**Funcionalidades:**
- Selecionar disciplina → tópico
- Listar vídeos sugeridos existentes com thumb preview
- Adicionar novo vídeo: título + canal + URL do YouTube
- Reordenar (▲▼)
- Deletar

**Layout:**
```
Tópico: [ Interpretação de textos ▼ ]

[ + Adicionar vídeo ]

┌────┬──────────────────────────────────────┬──────────┐
│THUMB│ Interpretação de Textos p/ Concursos │ [▲][▼][x]│
│    │ Canal: YouTube                        │          │
├────┼──────────────────────────────────────┼──────────┤
│THUMB│ Compreensão e Interpretação          │ [▲][▼][x]│
└────┴──────────────────────────────────────┴──────────┘
```

### Aba 4 — Avisos

**Funcionalidades:**
- Listar avisos ativos/inativos
- Criar aviso: título + corpo + tipo (info/aviso/urgente) + data de expiração opcional + toggle fixado
- Ativar/desativar
- Deletar

**Layout:**
```
[ + Novo aviso ]

┌─────────────────────────────────────────────────────────┐
│ 📢 Provas da fase 2 disponíveis!          [ativo] [x]   │
│ tipo: info | fixado: sim | expira: nunca                │
└─────────────────────────────────────────────────────────┘
```

### Aba 5 — Questões

**Funcionalidades:**
- Filtrar por disciplina + tópico + nível
- Listar questões com enunciado resumido
- Criar nova questão (form com todos os campos)
- Editar questão existente
- Ativar/desativar questão

**Campos da questão:**
- Disciplina (select)
- Tópico (select, carregado dinamicamente)
- Nível de dificuldade (fácil / médio / difícil)
- Enunciado (textarea longa)
- Alternativas A, B, C, D
- Gabarito (radio A/B/C/D)
- Explicação (textarea)

---

## ENTREGA 3 — Atualização do `index.html`

Substituir o objeto `DISCIPLINES` hardcoded por carregamento dinâmico do Supabase.

### O que muda

**Antes (hardcoded):**
```javascript
const DISCIPLINES = { 'lingua-portuguesa': { topicos: [...] }, ... }
```

**Depois (dinâmico):**
```javascript
async function loadDisciplines() {
  const { data: topics } = await supabase
    .from('topics')
    .select('*, topic_content(*), topic_videos(*)')
    .eq('ativo', true)
    .order('ordem');
  // monta o objeto DISCIPLINES a partir dos dados
}
```

### Carregamento de avisos
No dashboard do aluno, buscar avisos ativos e exibir em um banner/card no topo.

```javascript
async function loadAnnouncements() {
  const { data } = await supabase
    .from('announcements')
    .select('*')
    .eq('ativo', true)
    .or('expira_em.is.null,expira_em.gt.' + new Date().toISOString())
    .order('fixado', { ascending: false })
    .order('created_at', { ascending: false });
}
```

---

## Ordem de Implementação Recomendada

```
Sessão 1 (amanhã):
  [x] 1. Criar setup_conteudo.sql e rodar no Supabase
  [x] 2. Criar admin.html — estrutura base + login/proteção admin
  [x] 3. Admin — Aba Aulas (CRUD de tópicos) ← mais urgente

Sessão 2:
  [x] 4. Admin — Aba Conteúdo de Texto (editor + vídeo principal)
  [x] 5. Admin — Aba Vídeos Sugeridos

Sessão 3:
  [x] 6. Admin — Aba Avisos
  [x] 7. Admin — Aba Questões
  [x] 8. Atualizar index.html para carregar tudo do Supabase

```

---

## Arquivos que serão criados/modificados

| Arquivo | Tipo | Descrição |
|---|---|---|
| `setup_conteudo.sql` | **NOVO** | Cria tabelas `topics`, `topic_content`, `topic_videos`, `announcements` com RLS |
| `admin.html` | **NOVO** | Painel completo de gestão — arquivo standalone |
| `index.html` | **MODIFICADO** | Substitui DISCIPLINES hardcoded por fetch do Supabase; adiciona painel de avisos |

---

## Notas Técnicas

- O `admin.html` vai usar o mesmo Supabase client do `index.html` (mesmo script CDN)
- A proteção admin é feita checando `profiles.is_admin` logo na inicialização — se falso, `window.location = 'index.html'`
- Para o editor de texto da aula, **não usar biblioteca externa** — usar `contenteditable` + `execCommand` ou um textarea simples com preview. Mantém zero dependências.
- O ID do YouTube é extraído da URL por regex: `/(?:v=|embed\/|youtu\.be\/)([a-zA-Z0-9_-]{11})/`
- Drag-and-drop de reordenação: usar botões ▲▼ simples (sem biblioteca), que trocam os valores de `ordem`
