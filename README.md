# Trabalho Final - Banco de Dados II
Este repositório contém o projeto final da disciplina de Banco de Dados II, focado em otimização de desempenho em sistemas de banco de dados por meio de views, triggers, functions e indexes.

## Estrutura do Repositório
(1)criarTabelas.sql: Script para a criação das tabelas que fazem parte do sistema.
(2)criarTriggers.sql: Criação de triggers que garantem a integridade dos dados e otimizam operações.
(3)povoarTabelas.sql: Script para povoamento inicial das tabelas com dados fictícios para testes.
(4)criarViews.sql: Definição de views para consultas otimizadas.
(5)criarFunctions.sql: Funções personalizadas usadas em conjunto com as triggers e outros mecanismos do banco.
(6)criarIndexes.sql: Índices criados para melhorar o tempo de execução das consultas.

## Funcionalidades Principais
**Criação de Views Otimizadas:**
As views foram projetadas para agilizar consultas comuns, evitando o acesso desnecessário a múltiplas tabelas.

**Triggers:**
Uso de triggers para garantir consistência nos dados e realizar ações automáticas baseadas em eventos de manipulação de dados.

**Functions:**
Funções que encapsulam a lógica complexa, facilitando a reutilização e manutenção do código.

**Indexes:**
Índices foram aplicados para otimizar a busca e recuperação de dados, acelerando queries frequentes.

## Instruções de Uso
**Criação das Tabelas:**
Execute o script criarTabelas.sql para criar a estrutura do banco de dados.

**Povoamento das Tabelas:**
Após a criação das tabelas, utilize o script povoarTabelas.sql para inserir dados de teste.

**Criação de Views, Triggers e Functions:**
Execute os scripts criarViews.sql, criarTriggers.sql, e criarFunctions.sql para configurar as otimizações.

**Criação de Indexes:**
Por fim, execute o script criarIndexes.sql para adicionar os índices e melhorar o desempenho das queries.

## Relatório
O arquivo Relatório BD2.pdf contém uma análise detalhada das decisões tomadas, incluindo benchmarks de desempenho antes e depois da aplicação das otimizações.

## Conclusão
Este trabalho demonstra como o uso de mecanismos de otimização (views, triggers, functions, e indexes) pode melhorar o desempenho e a manutenção de um banco de dados relacional.
