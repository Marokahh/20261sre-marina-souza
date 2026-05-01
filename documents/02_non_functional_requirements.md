# Requisitos Não Funcionais (RNF) - Pipeline Olist (ISO 25010)

Este documento define os critérios de qualidade e níveis de serviço (SLO) para o pipeline de dados, garantindo a confiança do negócio nos dashboards do Grafana.

## 1. Adequação Funcional
### RNF-01: Completude da Ingestão
- **Descrição:** O pipeline deve garantir que todos os registros válidos do CSV de origem sejam persistidos no Postgres.
- **SLI:** Razão entre linhas no Postgres e linhas válidas no CSV de origem.
- **Prioridade:** Must Have.

## 2. Eficiência de Performance
### RNF-02: Janela de Processamento (Latência)
- **Descrição:** O processamento total (da detecção do arquivo à carga final) deve ocorrer dentro da janela operacional antes do horário comercial.
- **SLI:** Tempo total de execução (E2E) por lote de 100k registros.
- **Prioridade:** Must Have.

## 3. Compatibilidade
### RNF-03: Coexistência de Esquemas
- **Descrição:** O pipeline deve suportar a escrita no banco analítico sem degradar a performance de leitura das consultas do Grafana.
- **SLI:** Variação no tempo de resposta das queries do Grafana durante o processo de carga.
- **Prioridade:** Should Have.

## 4. Usabilidade
### RNF-04: Operabilidade do Operador
- **Descrição:** Um engenheiro de dados deve ser capaz de identificar a causa raiz de uma falha de carga em menos de 10 minutos através dos logs.
- **SLI:** Tempo médio para diagnóstico (MTTD) baseado em logs estruturados.
- **Prioridade:** Should Have.

## 5. Confiabilidade
### RNF-05: Disponibilidade da Carga Diária
- **Descrição:** O pipeline deve completar com sucesso pelo menos uma vez por ciclo de 24h.
- **SLI:** Taxa de sucesso das execuções diárias na janela de 00:00 às 06:00.
- **Prioridade:** Must Have.

### RNF-06: Maturidade (Idempotência)
- **Descrição:** Re-execuções do mesmo arquivo não devem resultar em erro ou dados duplicados.
- **SLI:** Quantidade de registros duplicados por `order_id` após re-processamento.
- **Prioridade:** Must Have.

## 6. Segurança
### RNF-07: Proteção de Dados em Repouso
- **Descrição:** O acesso ao banco PostgreSQL deve ser restrito via VPC e autenticação forte, sem exposição pública.
- **SLI:** Auditoria mensal de tentativas de acesso externo bloqueadas.
- **Prioridade:** Must Have.

## 7. Manutenibilidade
### RNF-08: Analisabilidade (Observabilidade)
- **Descrição:** O sistema deve emitir telemetria (métricas e logs) para cada etapa do fluxo (extração, validação, carga).
- **SLI:** Porcentagem de execuções com logs completos de telemetria disponíveis.
- **Prioridade:** Should Have.

## 8. Portabilidade
### RNF-09: Adaptabilidade de Infraestrutura
- **Descrição:** O código do pipeline deve ser agnóstico ao SO da EC2, utilizando ambientes isolados (ex: venv ou Docker).
- **SLI:** Tempo para subir o pipeline em uma nova instância limpa.
- **Prioridade:** Could Have.

## Tabela de Resumo (SLOs)

| ID | Atributo ISO 25010 | SLI (Indicador) | SLO (Alvo) | Fonte de Medição | Prioridade |
|:---|:---|:---|:---|:---|:---|
| RNF-01 | Adequação Func. | % de linhas carregadas vs origem | 100% | Logs de Auditoria / Count DB | Must Have |
| RNF-02 | Eficiência Perf. | Tempo de execução (100k linhas) | < 30 min | CloudWatch Logs | Must Have |
| RNF-05 | Confiabilidade | Sucesso da carga na janela | 99.9% (30 dias) | Dashboard SRE | Must Have |
| RNF-06 | Confiabilidade | Registros duplicados | 0 | Query de Unicidade DB | Must Have |
| RNF-07 | Segurança | Acessos externos não autorizados | 0 | VPC Flow Logs | Must Have |
| RNF-08 | Manutenibilidade | Cobertura de telemetria | 100% | Verificação de logs | Should Have |
| RNF-04 | Usabilidade | Tempo de diagnóstico (MTTD) | < 10 min | Logs do sistema | Should Have |
| RNF-09 | Portabilidade | Tempo de setup do ambiente | < 15 min | Script de Deploy | Could Have |

## Premissas e Fontes
- **Infra:** AWS EC2 e RDS Postgres.
- **Monitoramento:** AWS CloudWatch para logs e alarmes.
- **Métricas:** Consultas SQL de validação executadas pós-carga.
