# ARMDD_26-27_1231274_1260541

Trabalho prático da unidade curricular **Armazéns de Dados (ARMDD)** do Mestrado em Engenharia Informática do ISEP, 1.º semestre de 2026/2027.

## Grupo

| Número  | Nome         |
|---------|--------------|
| 1231274 | Jorge Ubaldo |
| 1260541 | Luis         |

## Contexto

A **More Rhythm, SA** é uma empresa líder nacional na distribuição e comercialização de instrumentos musicais. Tem sede no Porto e vende em todo o território nacional e, pontualmente, em Espanha. A médio prazo, prevê expandir-se para outros países da União Europeia e abrir uma sucursal no Reino Unido.

O objetivo do projeto é desenvolver um **data mart de vendas (faturação) a clientes**, construído a partir da base de dados do sistema operacional da empresa (`MoreRhythm`), que permita realizar análises históricas às vendas ao nível de granularidade mais elementar.

## Âmbito do projeto

- Análise e modelação dimensional seguindo a metodologia de **Kimball**
- Processo de **ETL** (extração, integração, transformação, limpeza e carregamento) em **SQL Server Integration Services (SSIS)**
  - Data profiling e tratamento de problemas de qualidade dos dados
  - Eliminação de registos duplicados (iguais ou aproximadamente iguais)
  - Carregamento incremental das dimensões e da tabela de factos
  - Uniformização de moedas em Euro
  - Parametrização completa, sem caminhos absolutos (servidores, bases de dados e ficheiros configuráveis)
- **20 análises multidimensionais** em **Power BI**

## Tecnologias

- Microsoft SQL Server / SQL Server Management Studio
- Visual Studio com Integration Services Project (SSIS)
- Power BI
- Git / GitHub

## Estrutura do repositório

```
docs/      Relatórios, diagramas e documentação do projeto
sql/       Scripts SQL (staging area e data mart)
ssis/      Integration Services Project
powerbi/   Ficheiros Power BI com as análises
```

## Entregas

| Fase | Conteúdo | Prazo |
|------|----------|-------|
| 1.ª parte | Relatório: arquitetura, modelo dimensional, staging area, mapeamento de dados e estratégias SCD | 15/11/2026 |
| 2.ª parte | Relatório final + Integration Services Project | 13/12/2026 |

> A base de dados de origem (`MoreRhythm.mdf` / `.ldf`) não está incluída no repositório por questões de confidencialidade.
