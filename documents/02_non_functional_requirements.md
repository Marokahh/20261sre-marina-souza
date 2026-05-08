# Requisitos Não Funcionais (RNF) - Pipeline Olist (ISO 25010)

Este documento define os critérios de qualidade e níveis de serviço (SLO) para o pipeline de dados, garantindo a confiança do negócio nos dashboards do Metabase.

## 1. Adequação Funcional
### RNF-01: Completude da Ingestão
- **Descrição:** O pipeline deve garantir que todos os registros válidos do CSV de origem sejam persistidos no ClickHouse.
- **SLI:** Razão entre linhas no ClickHouse e linhas válidas no CSV de origem.
- **Prioridade:** Must Have.

## 2. Eficiência de Performance
### RNF-02: Janela de Processamento (Latência)
- **Descrição:** O processamento total (da detecção do arquivo no MinIO à carga final) deve ocorrer dentro da janela operacional antes do horário comercial.
- **SLI:** Tempo total de execução (E2E) por lote de 100k registros via DBT.
- **Prioridade:** Must Have.

## 3. Compatibilidade
### RNF-03: Coexistência de Esquemas
- **Descrição:** O pipeline deve suportar a escrita no ClickHouse sem degradar a performance de leitura das consultas do Metabase.
- **SLI:** Variação no tempo de resposta das queries do Metabase durante o processo de carga.
- **Prioridade:** Should Have.

## 4. Usabilidade
### RNF-04: Operabilidade do Operador
- **Descrição:** Um engenheiro de dados deve ser capaz de identificar a causa raiz de uma falha de carga em menos de 10 minutos através dos logs do DBT.
- **SLI:** Tempo médio para diagnóstico (MTTD) baseado em logs estruturados do dbt.
- **Prioridade:** Should Have.

## 5. Confiabilidade
### RNF-05: Disponibilidade da Carga Diária
- **Descrição:** O pipeline deve completar com sucesso pelo menos uma vez por ciclo de 24h.
- **SLI:** Taxa de sucesso das execuções diárias na janela de 00:00 às 06:00.
- **Prioridade:** Must Have.

### RNF-06: Maturidade (Idempotência)
- **Descrição:** Re-execuções do mesmo arquivo não devem resultar em erro ou dados duplicados no ClickHouse.
- **SLI:** Quantidade de registros duplicados por `order_id` após re-processamento (validado por dbt tests).
- **Prioridade:** Must Have.

## 6. Segurança
### RNF-07: Proteção de Dados em Repouso
- **Descrição:** O acesso ao ClickHouse e MinIO deve ser restrito via rede e autenticação forte, sem exposição pública.
- **SLI:** Auditoria mensal de tentativas de acesso externo bloqueadas.
- **Prioridade:** Must Have.

## 7. Manutenibilidade
### RNF-08: Analisabilidade (Observabilidade)
- **Descrição:** O sistema deve emitir telemetria (métricas e logs) para cada etapa do fluxo gerenciado pelo DBT.
- **SLI:** Porcentagem de execuções com logs completos de telemetria disponíveis.
- **Prioridade:** Should Have.

## 8. Portabilidade
### RNF-09: Adaptabilidade de Infraestrutura
- **Descrição:** O código do pipeline deve ser containerizado para facilitar a portabilidade entre ambientes.
- **SLI:** Tempo para subir o stack completo via Docker Compose.
- **Prioridade:** Could Have.

## Tabela de Resumo (SLOs)

| ID | Atributo ISO 25010 | SLI (Indicador) | SLO (Alvo) | Fonte de Medição | Prioridade |
|:---|:---|:---|:---|:---|:---|
| RNF-01 | Adequação Func. | % de linhas carregadas vs origem | 100% | dbt tests / Count DB | Must Have |
| RNF-02 | Eficiência Perf. | Tempo de execução (100k linhas) | < 15 min | dbt logs | Must Have |
| RNF-05 | Confiabilidade | Sucesso da carga na janela | 99.9% (30 dias) | Monitoramento DBT | Must Have |
| RNF-06 | Confiabilidade | Registros duplicados | 0 | dbt unique tests | Must Have |
| RNF-07 | Segurança | Acessos externos não autorizados | 0 | Firewall Logs | Must Have |
| RNF-08 | Manutenibilidade | Cobertura de telemetria | 100% | Verificação de logs | Should Have |
| RNF-04 | Usabilidade | Tempo de diagnóstico (MTTD) | < 10 min | dbt failure logs | Should Have |
| RNF-09 | Portabilidade | Tempo de setup do ambiente | < 15 min | Docker setup time | Could Have |

## Premissas e Fontes
- **Infra:** Docker containers rodando MinIO, ClickHouse, Metabase e DBT.
- **Monitoramento:** Métricas nativas do ClickHouse e logs do DBT.
- **Métricas:** dbt tests executados pós-carga para validação de integridade.
