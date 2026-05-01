# Skill: Levantamento de Requisitos Funcionais (RF)

Esta skill guia o processo de identificação e documentação de requisitos funcionais para o pipeline de dados.

## Guia de Execução

1.  **Analise a Fonte:** Leia o arquivo de problemas (`specs/00_problem.md`) para entender os fluxos críticos.
2.  **Identifique Ações:** Procure por verbos e ações que o sistema deve realizar (ex: "carregar pedidos", "validar dados", "disparar alarmes").
3.  **Formate o Requisito:** Utilize o padrão:
    - **ID:** RF-XX
    - **Nome:** Título curto.
    - **Descrição:** O que o sistema deve fazer.
    - **Prioridade:** Alta/Média/Baixa.
4.  **Verifique a Idempotência:** Todo requisito de carga deve prever como evitar duplicidade.
5.  **Verifique a Observabilidade:** Todo requisito de fluxo deve prever como o sucesso ou falha será reportado.

## Exemplos de RF para este projeto:
- **RF-01:** O sistema deve ler arquivos CSV de pedidos diariamente.
- **RF-02:** O sistema deve validar se o arquivo CSV está íntegro antes da carga.
- **RF-03:** O sistema deve carregar os dados no PostgreSQL de forma idempotente.
