# GEMINI.md - Contexto e Instruções do Projeto

Este documento fornece o contexto fundamental e as instruções para trabalhar neste workspace. Serve como um guia para o Gemini CLI entender a estrutura, os objetivos e os requisitos técnicos do projeto.

## Visão Geral do Projeto

**Nome do Projeto:** Pipeline de Dados Olist (Foco em SRE)
**Objetivo:** Construir um pipeline de dados confiável, idempotente e observável para processar aproximadamente 100.000 pedidos diários do marketplace Olist para um banco de dados analítico PostgreSQL para dashboards no Grafana.
**Pilares Centrais:**
- **Integridade:** Processamento "exactly-once" (exatamente uma vez).
- **Atualidade:** Estado refletido do último processamento concluído.
- **Transparência/Observabilidade:** Alerta imediato sobre falhas; sem "sucessos silenciosos".

## Estrutura de Diretórios e Arquivos Chave

O projeto está atualmente na fase de especificação e planejamento.

- **`specs/`**: Contém definições arquiteturais e do problema.
    - **`00_problem.md`**: Define o canvas do problema, stakeholders, fluxos críticos, modos de falha e riscos sistêmicos.
- **`documents/`**: Documentação técnica detalhada (Requisitos, Arquitetura, Planos de Teste).
- **`README.md`**: Ponto de entrada básico do projeto.

## Requisitos Técnicos e Infraestrutura

Com base na especificação do problema (`specs/00_problem.md`), os seguintes componentes são esperados:

- **Fonte de Dados:** Arquivos CSV (Ingestão diária).
- **Banco de Dados Destino:** PostgreSQL (Banco analítico).
- **Computação:** AWS EC2.
- **Visualização:** Grafana.
- **Foco Operacional:**
    - **Idempotência:** Capacidade de re-executar processos sem duplicar dados.
    - **Resiliência:** Tratamento de falhas na EC2 ou indisponibilidade do banco.
    - **Monitoramento:** Acompanhamento de SLO/SLA e alertas.

## Estratégia de Desenvolvimento (Inferida)

1.  **Script de Ingestão:** Python ou similar para parsing de CSV e carga no Postgres.
2.  **Validação:** Implementação de verificações para garantir a integridade dos dados durante o ETL.
3.  **Observabilidade:** Integração com ferramentas de log/monitoramento.
4.  **Infraestrutura como Código (IaC):** Provavelmente necessária para provisionamento de EC2 e Postgres.

## Instruções para o Gemini CLI

- **Mentalidade SRE:** Priorize confiabilidade, observabilidade e idempotência em todas as propostas de código ou mudanças arquiteturais.
- **Validação Primeiro:** Garanta que qualquer lógica de processamento de dados inclua etapas de validação para evitar "falhas silenciosas".
- **Documentação:** Mantenha documentação clara sobre modos de falha e estratégias de mitigação.
- **Testes:** Novos recursos ou correções devem incluir scripts de verificação ou testes unitários, especialmente para casos de borda mencionados em `specs/00_problem.md`.
