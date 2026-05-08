# Arquitetura do Sistema - RM-ODP (Pipeline Olist)

Este documento descreve a arquitetura do pipeline de dados utilizando as cinco visões do padrão RM-ODP, garantindo o rastreamento de requisitos e conformidade com as restrições de infraestrutura.

## 1. Enterprise Viewpoint (Visão de Negócio)
- **Objetivo:** Automatizar a ingestão diária de pedidos para suportar a tomada de decisão via dashboards de alta performance.
- **Stakeholders:** Operações Olist, Time de Dados, SRE.
- **Processo:** Recebimento de CSV (MinIO) -> Ingestão/Orquestração (DBT) -> Carga/Transformação (ClickHouse) -> Visualização (Metabase) -> Monitoramento.
- **Atende:** RF-01, RF-07, RNF-05.

## 2. Information Viewpoint (Visão de Informação)
- **Esquema de Dados:**
    - **Origem (CSV):** Dados brutos armazenados no MinIO.
    - **Destino (ClickHouse):** Tabelas analíticas otimizadas (MergeTree family) com tipos de dados fortes.
- **Estados da Informação:** `Raw` (MinIO), `Staging` (ClickHouse tables), `Analytic` (ClickHouse views/models).
- **Integridade:** Uso de motores de tabela específicos do ClickHouse para garantir unicidade e performance em larga escala.
- **Atende:** RF-02, RF-03, RF-04, RNF-01, RNF-06.

## 3. Computational Viewpoint (Visão Computacional)
- **Componentes:**
    - **Data Lake (MinIO):** Landing zone para arquivos CSV brutos.
    - **Orquestrador/Ingestor (DBT):** Gerencia o fluxo de dados, transformações e integridade referencial. (RF-01, RNF-02)
    - **Engine OLAP (ClickHouse):** Armazenamento e processamento analítico de alto desempenho. (RF-03, RNF-06)
    - **Visualizador (Metabase):** Interface de self-service BI para os stakeholders. (RF-07)
    - **Monitor:** Coleta métricas de execução do pipeline. (RF-06, RNF-08)

## 4. Engineering Viewpoint (Visão de Engenharia)
- **Distribuição:**
    - **Storage Layer:** MinIO rodando em container/instância, servindo como S3-compatible storage.
    - **Processing Layer:** DBT executando modelos para mover dados do MinIO para o ClickHouse.
    - **Database Layer:** ClickHouse (Server) para consultas analíticas rápidas.
    - **Presentation Layer:** Metabase conectado ao ClickHouse.
- **Conectividade:** Comunicação interna otimizada entre containers/serviços na mesma rede VPC/Docker.
- **Atende:** RNF-02, RNF-07, RNF-09.

## 5. Technology Viewpoint (Visão de Tecnologia)
- **Storage:** MinIO.
- **Orquestração/Transformação:** DBT (Data Build Tool).
- **Database:** ClickHouse (OLAP).
- **Visualização:** Metabase.
- **Infra:** Docker / AWS EC2.
- **Monitoramento:** Métricas nativas do ClickHouse e logs do DBT.

---

## Architecture Decision Records (ADRs)

### ADR-01: Uso de ClickHouse como Banco Analítico
- **Contexto:** Necessidade de processar volumes crescentes de dados (100k+ pedidos/dia) com baixa latência de consulta.
- **Decisão:** Substituir PostgreSQL por ClickHouse.
- **Consequência:** Ganho massivo em performance de agregação, mas exige mudança na modelagem de dados para o paradigma orientado a colunas.

### ADR-02: MinIO para Landing Zone de Dados
- **Contexto:** Necessidade de um storage compatível com S3 para desacoplar ingestão de processamento.
- **Decisão:** Utilizar MinIO como camada de persistência de arquivos brutos (Raw Data).
- **Consequência:** Facilita a re-execução de pipelines (idempotência) e provê uma fonte da verdade imutável para os arquivos CSV.

### ADR-03: DBT para Orquestração e Ingestão
- **Contexto:** Padronizar a lógica de transformação e garantir rastreabilidade (linhagem).
- **Decisão:** Utilizar DBT para gerenciar o ciclo de vida dos dados no ClickHouse.
- **Consequência:** Lógica de negócio expressa em SQL, facilidade de testes de dados e documentação integrada.

### ADR-04: Metabase para Visualização
- **Contexto:** Necessidade de uma ferramenta de BI intuitiva e rápida para dashboards.
- **Decisão:** Utilizar Metabase em vez de Grafana.
- **Consequência:** Melhor experiência de exploração de dados para usuários não técnicos, mantendo a capacidade de dashboards em tempo real.
