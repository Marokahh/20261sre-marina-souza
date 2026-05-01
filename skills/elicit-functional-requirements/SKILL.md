---
name: elicit-functional-requirements
description: Elicits and documents functional requirements for the data pipeline project. Use this when defining new system behaviors, ingestion rules, or stakeholder needs.
---

# Elicit Functional Requirements

This skill guides the process of identifying, defining, and documenting functional requirements (FRs) for the Olist data pipeline.

## Workflow

1.  **Analyze Context:** Review `specs/00_problem.md` and any existing documentation in `documents/`.
2.  **Stakeholder Interview (Simulated or Real):** Identify needs related to data ingestion, processing, and visualization.
3.  **Draft Requirements:** Use the provided template to draft requirements.
4.  **Review:** Ensure requirements are SMART (Specific, Measurable, Achievable, Relevant, Time-bound).
5.  **Document:** Save the finalized requirements in `documents/01_functional_requirements.md`.

## Resources

- **Template:** Use [references/template.md](references/template.md) for a standardized format.

## Key Areas to Cover

- **Data Ingestion:** How CSVs are read, frequency, and source locations.
- **Data Transformation:** Specific business rules for processing order data.
- **Data Storage:** Schema requirements for the PostgreSQL analytical database.
- **Observability Functions:** How the system reports success, failure, and metrics.
- **Idempotency Logic:** How the system handles re-runs of the same data.
