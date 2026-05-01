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
### RF-03: Carga Idempotente no PostgreSQL
- **Descrição:** O sistema deve carregar os dados no banco analítico garantindo que, em caso de reprocessamento, não haja duplicidade de registros.
- **Prioridade:** Alta.
- **Mecanismo:** Uso de chaves únicas (ex: order_id) ou limpeza de estado anterior (staging).

### RF-04: Transformação e Normalização
- **Descrição:** O sistema deve converter os tipos de dados do CSV para os tipos compatíveis com o esquema do Postgres (datas, decimais, etc.).
- **Prioridade:** Média.

## 3. Observabilidade e Resiliência
### RF-05: Alerta de Falha Crítica
- **Descrição:** Qualquer erro que impeça o processamento completo (falha de rede, banco indisponível, arquivo malformado) deve disparar um alarme imediato.
- **Prioridade:** Alta.
- **Evidência:** Não deve haver "sucesso silencioso".

### RF-06: Log de Heartbeat e Status
- **Descrição:** O sistema deve registrar o início, progresso e fim de cada execução para permitir o monitoramento do SLA de tempo de processamento.
- **Prioridade:** Alta.

## 4. Visualização
### RF-07: Disponibilização para Grafana
- **Descrição:** Os dados devem ser estruturados no PostgreSQL de forma a permitir consultas eficientes pelo Grafana para exibição de métricas de vendas.
- **Prioridade:** Alta.
