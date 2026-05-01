# Arquitetura do Sistema - RM-ODP (Pipeline Olist)

Este documento descreve a arquitetura do pipeline de dados utilizando as cinco visões do padrão RM-ODP, garantindo o rastreamento de requisitos e conformidade com as restrições de infraestrutura.

## 1. Enterprise Viewpoint (Visão de Negócio)
- **Objetivo:** Automatizar a ingestão diária de pedidos para suportar a tomada de decisão via dashboards.
- **Stakeholders:** Operações Olist, Time de Dados, SRE.
- **Processo:** Recebimento de CSV -> Validação -> Transformação -> Carga -> Monitoramento.
- **Atende:** RF-01, RF-07, RNF-05.

## 2. Information Viewpoint (Visão de Informação)
- **Esquema de Dados:**
    - **Origem (CSV):** Dados brutos (strings).
    - **Destino (PostgreSQL):** Tabelas normalizadas com tipos de dados fortes (`orders`, `order_items`).
- **Estados da Informação:** `Raw` (S3/EC2 local), `Validated` (Em memória), `Persisted` (Postgres).
- **Integridade:** Uso de `order_id` como PK para garantir unicidade.
- **Atende:** RF-02, RF-03, RF-04, RNF-01, RNF-06.

## 3. Computational Viewpoint (Visão Computacional)
- **Componentes:**
    - **Ingestor:** Módulo de leitura e bufferização do CSV. (RF-01, RNF-02)
    - **Validador:** Verifica schema e integridade do arquivo. (RF-02)
    - **Loader:** Realiza o `UPSERT` ou carga via `staging` no Postgres. (RF-03, RNF-06)
    - **Monitor:** Coleta métricas de execução e envia ao CloudWatch. (RF-06, RNF-08)
- **Interface:** Scripts Python interagindo via `psycopg2` e `boto3`.

## 4. Engineering Viewpoint (Visão de Engenharia)
- **Distribuição:**
    - **Compute Node:** Instância EC2 (t3.medium) executando o script Python via Cron.
    - **Storage Node:** Instância RDS PostgreSQL em sub-rede privada.
    - **Observability Hub:** CloudWatch Logs e Alarms para métricas de falha.
- **Conectividade:** VPC com Security Groups restringindo porta 5432 apenas para a EC2.
- **Atende:** RNF-02, RNF-07, RNF-09.

## 5. Technology Viewpoint (Visão de Tecnologia)
- **Linguagem:** Python 3.9+.
- **Database:** PostgreSQL 13+ (RDS).
- **Infra:** AWS EC2, VPC, IAM Roles.
- **Monitoramento:** AWS CloudWatch, Grafana (conectado ao RDS).
- **Restrições Aplicadas:** Uso exclusivo de serviços disponíveis no AWS Academy Learner Lab. Sem Glue/Redshift.

---

## Architecture Decision Records (ADRs)

### ADR-01: Carga via EC2 com Python em vez de Glue
- **Contexto:** Necessidade de processar 100k linhas diariamente em ambiente AWS Academy.
- **Decisão:** Utilizar um script Python customizado em uma instância EC2.
- **Consequência:** Maior controle sobre a lógica de validação e idempotência, mas exige gestão manual da instância e agendamento (cron).

### ADR-02: Estratégia de Idempotência via UPSERT (ON CONFLICT)
- **Contexto:** Garantir que re-processamentos não dupliquem dados (RNF-06).
- **Decisão:** Utilizar a cláusula `INSERT ... ON CONFLICT (order_id) DO UPDATE`.
- **Consequência:** Garante integridade atômica no banco, simplifica a lógica de re-run, mas exige chaves primárias bem definidas.

### ADR-03: Observabilidade via CloudWatch Logs Estruturados
- **Contexto:** Necessidade de diagnóstico rápido e alertas (RF-05, RNF-04).
- **Decisão:** Emitir logs em formato JSON para o CloudWatch com campos específicos (JobID, Status, RowsProcessed).
- **Consequência:** Facilita a criação de Metric Filters e Dashboards, atendendo ao requisito de transparência sem ferramentas externas complexas.
