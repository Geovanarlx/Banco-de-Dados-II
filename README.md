# Banco de Dados II

Repositório de atividades acadêmicas desenvolvidas para a disciplina **Manipulação de Dados / Banco de Dados II**, com o professor **Aguinaldo Neto**.

**Turma:** Banco de Dados II

Todos os projetos deste repositório foram desenvolvidos academicamente, com finalidade de estudo e prática dos conteúdos de banco de dados. Os scripts implementam cenários independentes e não formam um único sistema integrado. Os enunciados em PDF foram usados como material de análise e não foram incluídos no repositório.

## Atividades

### Atividade 03 — Contas e transações
Arquivo: [Atividade03.sql](Atividade03.sql)

Cria uma tabela de contas, insere saldos de exemplo e pratica atualizações, transferências entre contas, `COMMIT`, `ROLLBACK`, exclusão e consultas ordenadas e filtradas.

### Atividade 05 — Consultas com funcionários e projetos
Arquivo: [Atividade05.sql](Atividade05.sql)

Cria tabelas para funcionários e projetos e demonstra consultas com `UNION`, `UNION ALL`, filtros de texto e faixa salarial, funções `MIN` e `MAX`, ordenação, limite de resultados e agrupamento com `HAVING`.

### Atividade 63 — Pessoas, clientes e funcionários
Arquivo: [Atividade63.sql](Atividade63.sql)

Modela pessoas relacionadas a cadastros de clientes e funcionários por chaves estrangeiras. Inclui dados de exemplo e consultas com junções, agregações, `GROUP BY`, `HAVING` e filtros de texto.

### Atividade 67 — Clínica
Arquivo: [Atividade67.sql](Atividade67.sql)

Representa unidades de atendimento, pessoas, profissionais e pacientes. Pratica relacionamentos, alteração de tabela, atualização condicional de status de plantão e consultas agregadas de salários e débitos de exames.

### Atividade de Views — Consultório
Arquivo: [Atividade-Views.sql](Atividade-Views.sql)

Cria um banco de consultório com pacientes, médicos, especializações, convênios, consultas e medicamentos. As views oferecem consultas reutilizáveis para indicadores e relatórios sobre atendimentos, faturamento, pacientes, médicos e medicamentos.

### Fábrica de Chocolate
Arquivo: [Atividade-Fabrica-Chocolate.sql](Atividade-Fabrica-Chocolate.sql)

Modela setores, funcionários, fornecedores, ingredientes, produtos, receitas, clientes, pedidos e itens de pedido. Exercita integridade referencial, alterações de estrutura, operações de dados, validações e procedimentos de teste para regras e restrições.

### Missões em Hawkins
Arquivo: [Atividade-Views-Missoes-Hawkins.sql](Atividade-Views-Missoes-Hawkins.sql)

Cria um cenário de missões com personagens, criaturas e equipamentos. As views organizam relatórios de missões, participação de personagens, duração e uso de recursos.

### Stored Procedures — Clientes
Arquivo: [Atividade-Stored-Procedures.sql](Atividade-Stored-Procedures.sql)

Demonstra procedimentos armazenados para cálculo de idade, comparação de valores, cadastro de clientes e geração de relatórios por faixas, usando parâmetros de entrada e saída.

### Triggers — GameStation
Arquivo: [Atividade-Triggers-GameStation.sql](Atividade-Triggers-GameStation.sql)

Modela uma loja de jogos e usa triggers para automatizar ações relacionadas a jogos, clientes e vendas, incluindo histórico de preços, registro de exclusões, cálculo de valores e controle de estoque.

### Escola de Magia de Hogwarts
Arquivo principal: [Atividade-Hogwarts.sql](Atividade-Hogwarts.sql)

Reúne o ciclo de criação e manipulação de um banco relacional para casas, professores, disciplinas, alunos, matrículas, pontos e compras. Inclui restrições, triggers, transações, consultas avançadas, views e controle de acesso.

Scripts auxiliares de controle de acesso:

- [Hogwarts-Testes-DCL.sql](Hogwarts-Testes-DCL.sql) — comandos a executar em conexões separadas para verificar permissões dos usuários.
- [Hogwarts-Limpeza-DCL.sql](Hogwarts-Limpeza-DCL.sql) — revoga a permissão de inserção e remove os usuários e o papel criados para a atividade.

### Operação Leonida — GTA 6
Arquivo: [Atividade-GTA6-Operacao-Leonida.sql](Atividade-GTA6-Operacao-Leonida.sql)

Desenvolve em PostgreSQL um banco para regiões, personagens, veículos, missões e participações. Inclui dados de exemplo, consultas com junções e subconsultas, agregações, views, alterações de estrutura, atualizações e testes de restrições.

## Tecnologias

- MySQL 8.0+ nas atividades de contas, funcionários e projetos, relacionamentos, clínica, consultório, fábrica de chocolate, Hawkins, procedures, triggers e Hogwarts.
- PostgreSQL na atividade Operação Leonida.

Cada script é independente. Confira o SGBD indicado antes da execução. Alguns arquivos criam bancos e tabelas e reinicializam objetos do cenário para permitir a montagem da atividade; execute-os em um ambiente acadêmico de testes.

## Finalidade

O conteúdo foi elaborado como trabalho acadêmico para praticar modelagem relacional, DDL, DML, consultas SQL, junções, agregações, subconsultas, views, procedures, triggers, transações e controle de acesso.

