# BRIEFING — Plataforma de Preparação para Concurso Público
## Cargo: Assistente Administrativo | Organizador: COTEC | Município: Ponto Chique – MG

---

## 1. VISÃO GERAL DO PROJETO

Plataforma web de estudos gamificada voltada para adultos que se preparam para o concurso público da Prefeitura de Ponto Chique, organizado pela COTEC, para o cargo de **Assistente Administrativo**.

O sistema deve funcionar como um app de preparação progressiva: o candidato entra, estuda por disciplina, responde exercícios de múltipla escolha e acumula pontos na plataforma. Sem missões, sem envio de tarefas, sem prêmios em dinheiro.

---

## 2. REFERÊNCIA TÉCNICA

Baseado no projeto VORTEX (`/index.html`). Replicar a arquitetura com as adaptações abaixo:

- **Stack:** HTML único (`index.html`) + CSS inline + JavaScript vanilla
- **Backend:** Supabase (auth por e-mail/senha + banco de dados)
- **Dependência externa:** `@supabase/supabase-js@2` via CDN
- **Tipografia:** Google Fonts — definir na implementação
- **Estrutura de telas:** login → dashboard → navegação por disciplina → exercícios
- **Sem build, sem framework, sem dependências de bundler**

---

## 3. PROVA — ESTRUTURA OFICIAL

**Formato:** 30 questões de múltipla escolha (4 alternativas: A, B, C, D)

| Disciplina              | Qtd. Questões | Peso | Pontuação máx. |
|------------------------|---------------|------|----------------|
| Língua Portuguesa       | 10            | 5    | 50 pts         |
| Matemática              | 10            | 3    | 30 pts         |
| Noções de Informática   | 10            | 2    | 20 pts         |
| **TOTAL**              | **30**        | —    | **100 pts**    |

---

## 4. CONTEÚDO PROGRAMÁTICO

### 4.1 Língua Portuguesa (peso 5)
- Leitura e interpretação de textos (descritivo, narrativo, dissertativo; gêneros: poemas, textos jornalísticos, propagandas, charges, cartuns, tirinhas, gráficos)
- Significação das palavras: sinônimos, antônimos, homônimos, parônimos, polissemia, sentido próprio e figurado
- Fonologia: letra, fonema, encontros vocálicos e consonantais, dígrafos, divisão silábica, acentuação tônica e gráfica (Acordo Ortográfico vigente), sinais gráficos
- Ortografia (Acordo Ortográfico vigente)
- Estrutura e formação de palavras
- Emprego dos sinais de pontuação
- Classes de palavras variáveis e invariáveis (identificação, flexão, função sintática, semântica e discursiva)
- Conjugação verbal: verbos regulares, irregulares e auxiliares (ser, ter, haver, estar) — todos os modos e tempos simples e compostos e formas nominais
- Sintaxe de concordância verbal e nominal
- Sintaxe de regência verbal e nominal
- Sintaxe de colocação pronominal
- Usos do sinal indicativo de crase
- Figuras de linguagem
- Funções da linguagem
- Registro formal e informal, marcas de coloquialidade, variações linguísticas

### 4.2 Matemática (peso 3)
- Sistemas de numeração, número primo, algoritmo da divisão, critérios de divisibilidade, MDC e MMC
- Conjuntos numéricos: operações (adição, subtração, multiplicação, divisão, potenciação, radiciação), médias, módulo, desigualdades, intervalos, sistemas de medida
- Proporcionalidade: razões, proporções, regra de três simples e composta, porcentagem, juros simples
- Relações e funções: domínio, contradomínio, imagem, gráficos, funções (afins, lineares, quadráticas, exponenciais, logarítmicas), equações e inequações
- Trigonometria: funções trigonométricas, propriedades, gráficos, equações
- Sequências: progressões aritméticas e geométricas
- Análise combinatória: princípio fundamental da contagem, arranjos, permutações, combinações, binômio de Newton, triângulo de Pascal
- Matrizes e sistemas lineares
- Geometria plana e espacial: ângulos, triângulos, quadriláteros, polígonos, áreas, perímetros, volumes, poliedros, relação de Euler
- Geometria analítica: coordenadas cartesianas, equações, gráficos, distância entre pontos, estudo da reta, circunferências
- Números complexos
- Polinômios
- Estatística básica: coleta de dados, gráficos, tabelas, média, moda, mediana, desvio padrão
- Probabilidades

### 4.3 Noções de Informática (peso 2)
- Sistemas operacionais (Windows e Linux): conceitos, características, ferramentas, configurações, acessórios, procedimentos
- Aplicativos de escritório (Microsoft Office e LibreOffice): editor de texto, planilhas, apresentações
- Internet: protocolos, computação em nuvem, equipamentos de conexão, intranet, extranet, navegadores
- Utilização e ferramentas de e-mail e redes sociais
- Segurança e proteção de computadores: conceitos, princípios básicos, ameaças, antivírus, vírus, firewall

---

## 5. TELAS / SEÇÕES DO APP

### 5.1 Login
- Campo e-mail + senha
- Botão entrar
- Visual sóbrio, sem animações excessivas

### 5.2 Dashboard (página inicial após login)
- Saudação com nome do usuário
- Resumo do progresso: moedas acumuladas, exercícios respondidos, taxa de acerto geral
- Acesso rápido às 3 disciplinas
- Conquistas recentes

### 5.3 Disciplina (1 tela por disciplina)
- Lista de tópicos do conteúdo programático
- Indicador de progresso por tópico (quantos exercícios respondidos / disponíveis)
- Status visual: não iniciado / em andamento / concluído

### 5.4 Exercícios (tela principal de estudo)
- 1 questão por vez, múltipla escolha (A/B/C/D)
- Feedback imediato: resposta certa (verde) / errada (vermelho + gabarito correto)
- Explicação curta após cada resposta
- Barra de progresso da sessão
- Ao acertar: ganhar moedas da plataforma
- Botão "próxima questão"

### 5.5 Perfil / Histórico
- Total de moedas acumuladas
- Histórico de sessões
- Desempenho por disciplina (% de acerto)
- Conquistas desbloqueadas

### 5.6 Ranking (opcional / fase 2)
- Placar entre usuários cadastrados (por moedas ou % de acerto)

---

## 6. GAMIFICAÇÃO

| Elemento           | Descrição                                                              |
|--------------------|------------------------------------------------------------------------|
| **Moeda**          | Definir nome na implementação (ex: "Pontos", "Fichas", "Selos")       |
| **Acertar questão**| +10 moedas                                                             |
| **Sequência (streak)** | Bônus por acertos consecutivos (ex: 3 seguidos = +5 extra)         |
| **Completar tópico**| Bônus ao responder todos os exercícios de um tópico                  |
| **Conquistas**     | Badges por marcos: primeiro acerto, 10 acertos, 100 questões, etc.   |
| **Sem prêmio real**| Nenhuma referência a dinheiro, gift card ou premiação externa         |
| **Sem missões**    | O modelo de missão do VORTEX não existe aqui                          |
| **XP / nível**     | Pode ser mantido como sistema de progressão paralelo às moedas        |

---

## 7. IDENTIDADE VISUAL

### Direção
- **Tom:** sóbrio, profissional, digital — voltado para adultos
- **Sem:** elementos infantis, cores neon saturadas, referências a games juvenis
- **Com:** clareza, hierarquia visual limpa, feedback de progresso motivador mas contido

### Paleta sugerida (a definir na implementação)
- Fundo: tons escuros de azul-marinho ou cinza-escuro (não preto puro)
- Acento primário: azul institucional ou verde-teal
- Acento secundário: dourado/âmbar (para moedas e conquistas)
- Texto: branco/creme sobre fundo escuro, cinza médio para secundário

### Tipografia sugerida
- Interface: Inter ou Outfit (clean, legível)
- Sem fontes decorativas ou com personalidade excessiva

### Ícones / Símbolos
- Usar emojis com moderação ou substituir por ícones SVG simples
- Disciplinas podem ter ícone representativo (livro, calculadora, monitor)

---

## 8. O QUE HERDAR DO VORTEX

| Componente              | Herdar?       | Observação                                   |
|------------------------|---------------|----------------------------------------------|
| Estrutura HTML única   | Sim           | Mesma abordagem de tela única com JS         |
| Supabase auth          | Sim           | E-mail + senha                               |
| Sistema de XP/nível    | Sim           | Renomear se necessário                       |
| Sistema de conquistas  | Sim           | Adaptar gatilhos para exercícios             |
| Sidebar de navegação   | Sim           | Adaptar itens para as 3 disciplinas          |
| Header com progresso   | Sim           | Mostrar moedas + nível                       |
| Tela de aula/conteúdo  | Não           | Substituir por tela de exercício             |
| Sistema de missões     | Não           | Removido completamente                       |
| Envio de tarefa        | Não           | Removido completamente                       |
| Vídeos salvos          | Não           | Fora do escopo atual                         |
| Notas pessoais         | Opcional      | Pode entrar em fase 2                        |
| Admin panel            | Sim           | Adaptar para gestão de questões              |

---

## 9. BANCO DE DADOS (Supabase)

### Tabelas necessárias
- `profiles` — dados do usuário (nome, e-mail, moedas, xp, nível)
- `questions` — banco de questões (disciplina, tópico, enunciado, alternativas, gabarito, explicação)
- `answers` — respostas do usuário (questão respondida, acertou, data)
- `achievements` — conquistas do sistema
- `user_achievements` — conquistas desbloqueadas por usuário

### Estrutura mínima de `questions`
```
id, disciplina, topico, enunciado, opcao_a, opcao_b, opcao_c, opcao_d, gabarito, explicacao, nivel_dificuldade, created_at
```

---

## 10. FORA DO ESCOPO (por enquanto)

- Simulado cronometrado (prova completa com tempo)
- Notificações / lembretes de estudo
- Versão mobile nativa
- Integração com edital oficial
- Questões de provas anteriores (copyright)
- Pagamento / acesso premium

---

## 11. PRÓXIMOS PASSOS

1. Validar este briefing com a equipe
2. Definir paleta e nome da moeda
3. Criar o `index.html` base (estrutura de telas, sem conteúdo)
4. Criar o SQL de setup do Supabase
5. Popular banco com primeiras questões por disciplina
6. Testar fluxo completo de login → exercício → feedback

---

*Briefing gerado em 19/05/2026 — Studio Solise*
