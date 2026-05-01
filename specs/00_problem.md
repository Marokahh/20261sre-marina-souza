# Problema: Pipeline de Dados Olist (SRE focus)

## 1. Contexto
O negócio Olist precisa processar aproximadamente 100 mil pedidos do marketplace diariamente, carregando-os em um banco analítico (Postgres) para alimentar dashboards no Grafana. A confiabilidade é o pilar central: o processo deve ser idempotente, observável e resiliente.

**Pergunta Orientadora:** O que o sistema precisa garantir para que o negócio confie nos números do dashboard?
*   **Integridade:** Cada pedido deve ser processado exatamente uma vez.
*   **Atualidade:** O dashboard deve refletir o estado do último processamento concluído.
*   **Transparência:** Qualquer falha deve ser alarmada imediatamente, sem "sucesso silencioso".

## 2. Canvas do Problema

### 1. Stakeholders
*   **Operação Olist (Negócio):** Decisores que dependem dos números de vendas.
*   **Time de Dados:** Engenheiros responsáveis pela manutenção do ETL.
*   **Clientes Internos do Dashboard:** Analistas que consomem os dados via Grafana.
*   **Plataforma / SRE:** Responsáveis pela infraestrutura (EC2/Postgres) e SLOs de disponibilidade.

### 2. Fluxos Críticos
*   **Ingestão Diária (CSV → Postgres):** O "heartbeat" do sistema. Extração, validação e carga.
*   **Consulta de Dashboards (Grafana):** A interface final de valor para o negócio.
*   **Observação de SLA:** Monitoramento se o processamento terminou dentro da janela esperada.

### 3. Modos de Falha
*   **Arquivo corrompido ou parcial:** Dados malformados que quebram o parser.
*   **Reprocesso duplicando linhas:** Executar o script duas vezes sem limpar o estado anterior ou sem chaves únicas.
*   **Queda de EC2 durante o run:** Interrupção abrupta deixando o banco em estado inconsistente ("zombie data").
*   **Banco indisponível:** Postgres fora do ar ou recusando conexões por exaustão de recursos.

### 4. Riscos Sistêmicos
*   **Perda silenciosa de linhas:** O processo termina com código 0, mas apenas 90% dos dados foram carregados.
*   **Dashboard mostrando dado stale:** Falha na ingestão passa despercebida e o usuário vê dados de ontem como se fossem atuais.
*   **Custo AWS explodindo:** Loop infinito de reprocessamento ou instâncias superdimensionadas.
*   **Dívida técnica de IA mal revisada:** Implementação de lógica de ETL via LLM sem testes unitários ou validação de borda.
