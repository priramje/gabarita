# Memória do Projeto: Plataforma Gabarita (Foco COTEC)
*Última atualização: Fim da Sessão de Gamificação e Questões Avançadas*

## 🎯 Onde Estamos
Transformamos a plataforma de uma simples lista de aulas em um **Ambiente de Estudo Imersivo e Gamificado**, totalmente focado nas características de cobrança da banca COTEC. O layout de tela dividida e o sistema de "Desbloqueio de Fases" estão operacionais.

---

## ✅ O Que Foi Feito Até Agora

### 1. Interface e Layout (Sala de Aula)
- **Tela Dividida (Split-Screen):** O layout da Sala de Aula (`index.html`) foi refeito para exibir o conteúdo/vídeo do lado esquerdo e o Bloco de Notas do lado direito, permitindo estudo e anotação simultâneos.
- **Menu Inteligente:** A barra lateral (sidebar) agora se recolhe automaticamente ao entrar na Sala de Aula, otimizando o espaço, e volta ao normal ao sair.
- **Vídeos e Curadoria:** Substituímos links quebrados por vídeos reais e relevantes do YouTube (focados em Interpretação de Textos para Concursos). Criamos uma seção de "Vídeos Sugeridos" abaixo da aula principal. Ao clicar neles, o vídeo carrega no player principal e a tela rola automaticamente para o topo.

### 2. Gamificação: Sistema de Fases (Mapa de Exercícios)
- **Lógica de Desbloqueio:** Criamos a mecânica de fases (Fácil, Médio, Difícil). O aluno só consegue acessar a próxima fase se acertar pelo menos 70% (7 de 10) das questões da fase atual.
- **Interface do Mapa:** Adicionamos o "Mapa de Fases" na aba de exercícios, com design de botões de bloqueio (cadeados 🔒 e 🔓) e animação de confetes ao passar de fase.
- **Banco de Progresso:** Criamos a tabela `user_progress` no Supabase através do arquivo `setup_fases.sql`, que garante que a plataforma lembre qual fase o aluno já desbloqueou.

### 3. Banco de Questões Avançado (Padrão COTEC)
- **Problema Resolvido:** Corrigimos o bug das questões repetidas e das fases com "15 perguntas" criando um comando de limpeza (DELETE) que reseta as questões daquele tópico antes de inserir as novas.
- **Novo Arquivo SQL:** Criamos o `30_questoes_cotec_reais.sql`.
- **Textos Reais e Longos:** Abandonamos frases curtas. Agora as questões contêm textos autênticos (legislação, crônicas, charges).
- **Rigor da COTEC:** As 30 questões foram desenhadas com foco em semântica, conectivos ("destarte", "posto que"), pronomes anafóricos e figuras de linguagem, exatamente como a COTEC cobra.

---

## 🚀 Como Retomar o Trabalho Amanhã

Para que tudo o que construímos hoje funcione perfeitamente quando você voltar, **certifique-se de ter executado os dois passos abaixo no Supabase**:

1. **Rodar o `setup_fases.sql`:** 
   - Copie todo o código deste arquivo e rode no SQL Editor do Supabase. Isso criará a tabela de progresso. (Se já rodou hoje, não precisa rodar de novo).
2. **Rodar o `30_questoes_cotec_reais.sql`:**
   - Copie todo o código deste arquivo e rode no SQL Editor do Supabase. Ele vai apagar a bagunça antiga e instalar as 30 questões perfeitas.

### Próximos Passos Sugeridos
*   **Testar a Jornada do Aluno:** Entrar na aula de Interpretação, abrir os exercícios, fazer a Fase Fácil (acertar 7), ver a Fase Média ser desbloqueada e conferir se o cadeado sumiu.
*   **Expandir para Outras Disciplinas:** Uma vez que o modelo de Interpretação de Textos foi validado, podemos replicar esse mesmo formato (vídeos + bloco de notas + 30 questões em fases) para Matemática e Informática.
*   **Ajustes Finos:** Se necessário, podemos ajustar o layout responsivo para celular (caso o split-screen fique muito apertado em telas menores).
