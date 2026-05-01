# Skill: Levantamento de Requisitos Não Funcionais (RNF)

Esta skill guia a extração de requisitos de qualidade baseados na ISO 25010, com foco em métricas mensuráveis (SLIs/SLOs) para o pipeline de dados.

## Quando usar
- Quando o usuário solicitar a definição de RNFs e já existir o arquivo `specs/00_problem.md`.
- Pode ser enriquecida se o arquivo `documents/01_functional_requirements.md` também estiver disponível.

## Entrada
- `specs/00_problem.md` (obrigatório)
- `documents/01_functional_requirements.md` (opcional)

## Passos
1. **Análise de Contexto:** Ler stakeholders e fluxos críticos no `specs/00_problem.md`.
2. **Mapeamento ISO 25010:** Mapear cada fluxo crítico aos 8 atributos da norma:
   - Adequação Funcional
   - Eficiência de Performance
   - Compatibilidade
   - Usabilidade
   - Confiabilidade
   - Segurança
   - Manutenibilidade
   - Portabilidade
3. **Definição Mensurável:** Para cada atributo, propor de 1 a 3 RNFs. Cada um deve ter um SLI (Service Level Indicator) claro.
4. **Priorização:** Utilizar o método MoSCoW (Must have, Should have, Could have, Won't have).
5. **Premissas e Fontes:** Listar de onde virão os dados para medição (ex: logs do CloudWatch, métricas do Postgres).

## Saída
Gerar ou atualizar o arquivo `documents/02_non_functional_requirements.md` contendo:
- Uma seção detalhada para cada atributo ISO 25010.
- Identificadores únicos (RNF-01, RNF-02...).
- Tabela de resumo final com as colunas: ID, Atributo, SLI, SLO (Alvo), Fonte de Medição, Prioridade.

## Critérios de Aceitação
- **Cobertura Total:** Todos os 8 atributos da ISO 25010 devem ser mencionados.
- **Especificidade:** Proibido o uso de termos subjetivos como "sistema deve ser rápido" ou "ser confiável".
- **Janela de Tempo:** Todo RNF de performance ou confiabilidade deve definir sua unidade (ms, %, etc.) e janela de medição (diária, mensal).
