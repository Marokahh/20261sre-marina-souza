# Requisitos Funcionais (RF) - Pipeline de Dados Olist

Este documento descreve as funcionalidades que o sistema deve executar, derivadas da especificação do problema.

## 1. Ingestão de Dados
### RF-01: Extração de Pedidos Diários
- **Descrição:** O sistema deve ser capaz de ler arquivos CSV contendo aproximadamente 100 mil pedidos diariamente.
- **Prioridade:** Alta.
- **Observação:** O processo deve ser agendado para garantir a atualidade do dashboard.

### RF-02: Validação de Integridade do Arquivo
- **Descrição:** O sistema deve validar se o arquivo CSV não está corrompido ou parcial antes de iniciar o processamento.
- **Prioridade:** Alta.

## 2. Processamento e Carga (ETL)
### RF-03: Carga Idempotente no ClickHouse
- **Descrição:** O sistema deve carregar os dados no banco analítico ClickHouse garantindo que, em caso de reprocessamento, não haja duplicidade de registros.
- **Prioridade:** Alta.
- **Mecanismo:** Uso de motores de tabela do ClickHouse (ex: ReplacingMergeTree) ou limpeza de estado via staging no DBT.

### RF-04: Transformação e Linhagem de Dados (DBT)
- **Descrição:** O sistema deve realizar transformações e normalizações no ClickHouse utilizando DBT, garantindo a rastreabilidade (linhagem) dos dados.
- **Prioridade:** Alta.

## 3. Observabilidade e Resiliência
### RF-05: Alerta de Falha Crítica
- **Descrição:** Qualquer erro que impeça o processamento completo (falha no MinIO, ClickHouse indisponível, falha no dbt run) deve disparar um alarme imediato.
- **Prioridade:** Alta.
- **Evidência:** Não deve haver "sucesso silencioso".

### RF-06: Log de Heartbeat e Status do DBT
- **Descrição:** O sistema deve registrar o início, progresso e fim de cada execução do dbt para permitir o monitoramento do SLA de tempo de processamento.
- **Prioridade:** Alta.

## 4. Visualização
### RF-07: Disponibilização para Metabase
- **Descrição:** Os dados devem ser estruturados no ClickHouse de forma a permitir consultas eficientes pelo Metabase para exibição de métricas de vendas.
- **Prioridade:** Alta.
