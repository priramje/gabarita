-- =============================================================================
-- GABARITA — 10 Exercícios Adicionais de Interpretação de Textos
-- Foco na banca COTEC
-- Execute no SQL Editor do Supabase
-- =============================================================================

insert into public.questions (disciplina, topico, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, gabarito, explicacao, nivel_dificuldade) values
(
  'lingua-portuguesa', 
  'Interpretação de textos',
  'Leia o trecho: "O avanço das tecnologias digitais não apenas encurtou distâncias geográficas, mas também criou bolhas sociais onde o debate de ideias frequentemente cede espaço à confirmação de crenças." <br><br>Com base no texto, é correto afirmar que o autor sugere que:',
  'As tecnologias melhoraram o debate público ao conectar mais pessoas.',
  'O encurtamento das distâncias eliminou as diferenças de opinião.',
  'As bolhas sociais facilitam a troca de ideias divergentes.',
  'A tecnologia favorece ambientes onde opiniões contrárias são evitadas.',
  'd',
  'O texto afirma que as bolhas sociais fazem com que o debate ceda espaço à "confirmação de crenças", ou seja, as pessoas buscam apenas opiniões que confirmem as suas próprias (evitando o contraditório).',
  'medio'
),
(
  'lingua-portuguesa', 
  'Interpretação de textos',
  'Em um edital de licitação da prefeitura, lê-se: "A proposta deve ser apresentada impreterivelmente até as 18h do dia útil subsequente à publicação". <br><br>A palavra "impreterivelmente" confere à frase o sentido de:',
  'Sugestão ou recomendação de prazo.',
  'Obrigatoriedade e prazo inadiável.',
  'Flexibilidade, permitindo entrega no dia seguinte.',
  'Dúvida quanto à necessidade de cumprimento do horário.',
  'b',
  '"Impreterivelmente" significa "que não se pode preterir (adiar)", conferindo caráter obrigatório e inadiável ao prazo estipulado.',
  'facil'
),
(
  'lingua-portuguesa', 
  'Interpretação de textos',
  'Leia a charge mentalmente: Um funcionário diz ao chefe: "Chefe, eu corto um dobrado para manter meus arquivos organizados". O chefe responde: "Então comece a usar a tesoura no papel correto". <br><br>O efeito de humor decorre de qual fenômeno da linguagem?',
  'Compreensão literal de uma expressão idiomática pelo chefe.',
  'Uso de vocabulário técnico inadequado pelo funcionário.',
  'Ambiguidade proposital gerada pelo funcionário.',
  'Ironia agressiva direcionada à empresa.',
  'a',
  'A expressão "cortar um dobrado" significa enfrentar grandes dificuldades. O chefe interpreta a frase ao pé da letra (literalmente) como o ato de "cortar com tesoura", gerando humor.',
  'medio'
);
