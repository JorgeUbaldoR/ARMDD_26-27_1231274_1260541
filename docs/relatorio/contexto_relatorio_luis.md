# Contexto para escrever a parte do Luis no relatório (1.ª parte)

Este ficheiro é o contexto para um assistente de IA ajudar a escrever os capítulos do Luis no relatório da 1.ª parte do trabalho prático de Armazéns de Dados (ARMDD, Mestrado em Engenharia Informática, ISEP, 2026/2027).

- **Grupo:** Jorge Ubaldo (1231274) e Luis (1260541).
- **Docente:** Fábio Santos.
- **Repositório:** `ARMDD_26-27_1231274_1260541`.
- **Prazo:** domingo, 15/11/2026, às 23:59, num único PDF chamado `1231274_1260541.pdf`.

---

## 1. O projeto em poucas palavras

A More Rhythm, SA distribui e comercializa instrumentos musicais. Tem sede no Porto e vende em Portugal e, pontualmente, em Espanha. O objetivo do trabalho é um **data mart de vendas (faturação)** construído a partir da base de dados operacional **MoreRhythm** (SQL Server), seguindo a metodologia de **Kimball**. O processo de ETL será implementado em **SSIS** na 2.ª parte, e as análises serão feitas em **Power BI**.

O enunciado pede, na 1.ª parte:
1. a arquitetura;
2. o modelo dimensional, com os atributos e os tipos de dados;
3. as estruturas da staging area;
4. o mapeamento origem → staging area → data mart, com a estratégia de SCD por atributo;
5. as operações de limpeza e transformação.

Pontos específicos do enunciado:
- **Clientes duplicados**, iguais ou aproximadamente iguais.
- **Custo de expedição** registado ao nível da fatura e não da linha.
- **Datas de auditoria** (criação e alteração) disponíveis para a carga incremental.
- **Registos com problemas não corrigíveis automaticamente** não entram no DM: vão para tabelas de erros na staging area.
- **Expansão para a UE e o Reino Unido**, com o euro como moeda de uniformização.
- **Parametrização** sem caminhos absolutos.

---

## 2. O relatório e a divisão

Ficheiro: `docs/relatorio/1231274_1260541.docx`, feito a partir do template do ISEP.

| Capítulo | Responsável | Estado |
|---|---|---|
| Resumo, 1 Introdução | Jorge | escrito |
| **2 Análise dos dados de origem** + **Anexo A** | **Luis** | por escrever |
| 3 Arquitetura do armazém de dados | Jorge | escrito |
| 4 Modelo dimensional | Jorge | escrito |
| **5 Staging Area** | **Luis** | por escrever |
| **6 Mapeamento de dados e estratégia SCD** + **Anexo B** | **Luis** | por escrever |
| **7 Operações de limpeza e transformação** | **Luis** | por escrever |
| 8 Conclusões, Referências | Jorge | escrito |

Debaixo de cada título do Luis há uma nota a amarelo com o que lá vai e de que ficheiro sai. A nota deve ser apagada quando a secção for escrita.

### O que já está escrito e não deve ser repetido (deve ser referido)

- **Capítulo 3:**
  - arquitetura em 4 camadas (Figura "Arquitetura do armazém de dados");
  - fontes de dados (tabela com as 9 tabelas de origem e os volumes);
  - os 4 pacotes SSIS;
  - a **estratégia de extração e carga incremental por tabela** (secção 3.4), incluindo a opção B, a margem de 1 dia e as faturas e linhas extraídas em conjunto;
  - a parametrização.

  O capítulo 5 deve **referir** a secção 3.4 e não voltar a explicá-la.
- **Capítulo 4:**
  - grão (linha de fatura);
  - requisitos das 10 análises;
  - esquema em estrela (Figura "Esquema em estrela…");
  - **tabelas de atributos e tipos de cada dimensão** (secção 4.4), hierarquias e FactSales (medidas, aditividade, repartição do frete);
  - decisões de modelação.

  O capítulo 6 deve **referir** a secção 4.4 para os tipos de dados e concentrar-se na origem, na transformação e no SCD.

---

## 3. Regras de formatação (para manter o padrão)

- **Texto:** estilo **Normal** (Calibri 11, justificado, espaçamento 1,5). Português de Portugal, impessoal ("foi definido", "apresenta-se"), frases curtas.
- **Termos em inglês em itálico:** *data mart*, *staging area*, *data profiling*, *surrogate key*, *lookup*, etc. Os nomes de tabelas e colunas ficam sem itálico (EXT_customers, TRF_Sales, CustomerKey).
- **Listas:** estilo **"Lista com marcas 41"**.
- **Legendas:** com Inserir → Legenda (estilo **Caption**, rótulos "Tabela" e "Figura"). A legenda da **tabela vai por cima** e a da **figura vai por baixo**. Formato: `Tabela N - Descrição`.
- **Referências no texto a tabelas e figuras:** com Inserir → Referência cruzada, **nunca** escrevendo o número à mão. O capítulo 2 vem antes dos do Jorge, por isso a numeração muda e os campos atualizam-na sozinhos.
- **Formato das tabelas** (igual às do Jorge):
  - cabeçalho com fundo **preto** e texto **branco a negrito**, centrado;
  - corpo com letra de 9 pt, margens pequenas, bordas finas pretas;
  - primeira coluna a negrito quando é o nome da tabela ou do atributo;
  - tabela centrada com a largura da página.
- **Figuras:** centradas, estilo **Imagem**, com a largura do texto. As que são muito largas podem ir numa página na horizontal, como a Figura da arquitetura.
- **Antes de entregar:** selecionar tudo (Ctrl+A) → F9 para atualizar índices, legendas e referências cruzadas.
- **Fontes citadas no texto:** "(Kimball & Ross, 2013)" e "(Kimball & Caserta, 2004)". Já estão nas Referências.

---

## 4. Ficheiros de onde sai o conteúdo

| Ficheiro | O que tem |
|---|---|
| `docs/ERDBase.vsdx` | Separadores: **BD-Racional** (ERD da origem), Data Mart, Arquitetura, **Staging Area** (diagrama da SA) |
| `docs/profiling/problemas_qualidade.xlsx` | **Problemas** (71 problemas, IDs 1–71), **Operações** (O01–O18), Resumo, Notas |
| `docs/profiling/MoreRhythm_Profile.xml` | Resultado da Data Profiling Task do SSIS |
| `docs/profiling/SQLQuery*.sql` | Consultas SQL de verificação por tabela |
| `docs/staging_area.xlsx` | **Resumo**, **EXT**, **TRF**, **ERR**, **MAP**, **CTL**, **Mapeamento** (90 atributos), **Códigos de erro** (E01–E08), **Decisões** |
| `docs/perguntas_professor.md` | Dúvidas pendentes para o docente |

---

## 5. Conteúdo de cada capítulo do Luis

### Capítulo 2 – Análise dos dados de origem

**2.1 Base de dados MoreRhythm**
- Base de dados SQL Server do sistema operacional, que suporta faturação, compras e stocks. Usam-se as 9 tabelas do processo de faturação: invoices (37), invoices_lines (93), customers (26), products (67), families (17), categories (11), suplliers (14), employees (6) e zones (5). Os dados são uma amostra representativa.
- Figura com o ERD (ERDBase.vsdx, separador BD-Racional).
- **FK declaradas:**
  - Invoices → Customers e Employees;
  - Lines → Invoices e Products;
  - Products → Families, Categories e Suppliers;
  - Customers e Suppliers → Zones;
  - Employees → Employees (chefia).
- **Particularidades da origem:**
  - a tabela de fornecedores chama-se `suplliers` e a coluna do fornecedor no produto chama-se `supplyer`;
  - identificadores `char` com espaços à direita;
  - preços guardados ×10^6 e stock ×10^3;
  - `categories` e `zones` não têm datas de auditoria;
  - `customers.seller` não tem FK.

**2.2 Metodologia de data profiling**
- A **Data Profiling Task** do SSIS (com uma ligação ADO.NET) foi executada sobre todas as tabelas, e os resultados foram analisados no Data Profile Viewer.
- Perfis usados: Column Null Ratio, Column Length Distribution, Column Pattern, Column Statistics, Column Value Distribution e Candidate Key.
- **Limitação:** o perfil Candidate Key não aceita colunas `numeric`, por isso a unicidade dessas chaves foi verificada por SQL.
- O perfil foi complementado com **consultas SQL** (ficheiros `SQLQuery*.sql`) para validar regras de negócio, entre elas:
  - `shipping_cost` = 2,5% de `products_total`;
  - IVA de 23% só sobre os produtos;
  - `final_total` = `total_for_vat` + `vat_value`;
  - `total_for_vat` = `products_total` + `shipping_cost`.

  As mesmas consultas verificaram também a integridade referencial e as datas de auditoria.
- Cada problema foi registado no `problemas_qualidade.xlsx` com: tabela/coluna, perfil de origem, descrição, exemplo, n.º de registos, tipo, gravidade, se é automatizável, ação proposta e destino.

**2.3 Problemas de qualidade identificados**
- **71 problemas no total.**
  - **Por tabela:** customers 21, suplliers 18, invoices 8, invoices_lines 7, products 7, families 4, employees 4, categories 1, zones 1.
  - **Por gravidade:** Alta 11, Média 20, Baixa 40.
  - **Por tipo:** valor em falta 19, inconsistência entre atributos 14, formato inválido 12, violação de domínio 9, grafia inconsistente 8, duplicado aproximado 3, regra de negócio 3, integridade referencial 2, duplicado exato 1.
  - **Por destino:** corrigir no ETL 50, manter/sem ação 19, tabela de erros 2 (ID 28, faturas com products_total diferente da soma das linhas; ID 43, produtos Z001 e CORSR sem atributos).
- Destacar os mais relevantes:
  - clientes duplicados 10/18, 8/22 e 5/26 (IDs 1–3) e fornecedores 8/14 com o mesmo NIF (ID 55);
  - cidade embutida no zip_code (IDs 5 e 59) e códigos postais estrangeiros (IDs 7 e 60);
  - quantidades e preços negativos (IDs 21–22);
  - frete inconsistente (ID 29);
  - datas de auditoria pouco fiáveis (IDs 24, 33, 49 e 66);
  - grafias inconsistentes (IDs 8, 39, 40 e 48);
  - zona incoerente com a localização (IDs 42 e 51).
- Uma tabela-resumo (por tabela × gravidade, ou por tipo) e remeter a lista completa para o **Anexo A**.

### Capítulo 5 – Staging Area

- **5.1 Organização:**
  - base de dados `MoreRhythm_SA`, no mesmo servidor do DM;
  - 5 grupos identificados por prefixo, cada um com o seu ciclo de vida:
    - **EXT_** (extração): cópia da origem com os mesmos nomes e tipos, sem chaves; esvaziada a cada execução, exceto EXT_zones, EXT_categories e EXT_families, que são persistentes para detetar alterações;
    - **TRF_** (transformação): dados limpos com os nomes e tipos do DM e a chave natural como PK; esvaziada a cada execução;
    - **ERR_** (erros): acumulam;
    - **MAP_** (mapeamento e referência): carregadas de CSV;
    - **CTL_** (controlo): atualizada no fim de cada execução.
  - Justificar as duas camadas EXT/TRF: permitem comparar o antes e o depois, recomeçar sem voltar à origem e tornar explícito o mapeamento.
  - Figura com o diagrama (ERDBase.vsdx, separador Staging Area).
- **5.2 Tabelas de extração:** 9 tabelas EXT_ (folha EXT). Referir a secção 3.4 para os critérios de extração.
- **5.3 Tabelas de transformação:** TRF_Customer, TRF_Product, TRF_Supplier, TRF_Employee e TRF_Sales (folha TRF).
- **5.4 Tabelas de erros:**
  - ERR_invoices, ERR_invoices_lines e ERR_products, cada uma com ErrorID (PK, IDENTITY) + as colunas da EXT correspondente + ErrorCode, ErrorDescription e ErrorDate;
  - acumulam e voltam a ser processadas quando o registo é corrigido na origem (folhas ERR e Códigos de erro).
- **5.5 Tabelas de mapeamento e referência:** MAP_DuplicateCustomer, MAP_DuplicateSupplier, MAP_Correction, MAP_Currency, MAP_ZoneCountry, MAP_SupplierEntityType e SA_ExchangeRate (taxas do BCE). Explicar porque estão em CSV: podem ser alteradas sem mexer nos pacotes, o que é parametrizável (folha MAP).
- **5.6 Tabela de controlo:** CTL_LoadControl, com TableName (PK), LastExtractionDate (só avança se a execução correr bem, e guarda a hora de **início** da extração), LastRunDate, RowsExtracted e Status (folha CTL).
- Sugestão: uma tabela-resumo das tabelas (folha Resumo) e, para cada grupo, as colunas principais. A lista exaustiva de colunas pode ir para o Anexo B ou ficar resumida.

### Capítulo 6 – Mapeamento de dados e estratégia SCD

- **6.1 Fontes → SA:** de onde vem cada coluna das TRF_ (tabela.coluna da origem) e a transformação aplicada, ligada ao ID do profiling (folhas EXT e TRF).
- **6.2 SA → DM:**
  - cada atributo do DM com origem, coluna da SA e transformação (folha **Mapeamento**, 90 linhas). No corpo do relatório, uma tabela por dimensão e outra para a FactSales; a tabela completa vai para o **Anexo B**;
  - **na FactSales:** as chaves são obtidas por Lookup às dimensões; as linhas sem correspondência vão para os erros (E04–E07); SupplierKey NULL → -1; PaymentDate NULL → -1.
- **6.3 Estratégia SCD:**
  - **Regra:** **tipo 1** para atributos cuja alteração é uma correção (nomes, NIF, designação, código, PaymentTermDays, EntityType, CurrencyName, Symbol, **ManagerName**); **tipo 2** para os que mudam o agrupamento das vendas (tipo, segmento, código postal, cidade, localidade, zona, país, família, classificação, categoria, VatRate, grupo, departamento, **ManagerNumber**).
  - A DimDate é estática.
  - **Colunas de controlo:** StartDate, EndDate e IsCurrent. A 1.ª versão tem StartDate = **1900-01-01** e EndDate = **9999-12-31**. Uma nova versão começa na data da carga e a anterior termina na véspera.
  - **Carga dos factos:** usa a **versão em vigor na data da fatura** (StartDate ≤ InvoiceDate ≤ EndDate).
  - **ManagerName é tipo 1** e ManagerNumber é tipo 2: se o ManagerName fosse tipo 2, uma correção do nome do chefe criava versões novas de todos os subordinados.
  - **FactSales:** insere as linhas novas (InvoiceLineNumber inexistente) e atualiza as que mudaram (por exemplo, a PaymentDateKey quando a fatura é paga).
  - Fonte: folhas Mapeamento e Decisões.

### Capítulo 7 – Operações de limpeza e transformação

- **7.1 Operações por atributo:** as **18 operações O01–O18** da folha Operações do `problemas_qualidade.xlsx`, que cobrem os 71 problemas:
  - O01 TRIM;
  - O02 vazio → NULL;
  - O03 membro "Desconhecido";
  - O04 validação de domínio (NIF);
  - O05 separação do zip_code em código postal e cidade;
  - O06 correção de grafia por MAP_Correction;
  - O07 normalização de maiúsculas;
  - O08 deduplicação (Fuzzy Grouping + MAP_Duplicate*; fica o número mais baixo);
  - O09 derivação de atributos (país, EntityType, classificação, ManagerName);
  - O10 correção de sinal (ABS quando \|qty\| × \|price\| = line_total);
  - O11 recálculo e repartição do frete;
  - O12 uniformização de moeda (ISO 4217 + conversão para EUR);
  - O13 validação e tabelas de erros;
  - O14 tipos de dados;
  - O15 escolha da fonte correta;
  - O16 deteção de alterações;
  - O17 sem tratamento, porque o atributo fica fora do DM;
  - O18 sem tratamento, anomalia apenas registada.

  Cada operação tem o componente SSIS previsto. Uma tabela com código, operação, IDs, onde é aplicada e componente SSIS.
- **7.2 Tratamento de erros:**
  - **Regra geral:** corrige-se quando há forma inequívoca de reconstruir o valor a partir de outros campos; caso contrário, o registo vai para a tabela de erros e não entra no DM.
  - **Códigos:**
    - E01 – products_total diferente da soma das linhas;
    - E02 – linha cuja fatura foi rejeitada;
    - E03 – sinal negativo não corrigível;
    - E04 – produto inexistente **ou rejeitado (ERR_products)**;
    - E05 – cliente inexistente;
    - E06 – funcionário inexistente;
    - E07 – moeda ou taxa de câmbio em falta;
    - E08 – produto sem atributos (Z001, CORSR).

### Anexo A – Problemas de qualidade dos dados
A tabela completa da folha Problemas (71 linhas). Colunas sugeridas: ID, tabela, coluna, problema, n.º de registos, tipo, gravidade e destino. Convém usar letra pequena ou uma página na horizontal.

### Anexo B – Mapeamento completo dos atributos
A tabela completa da folha Mapeamento: tabela do DM, atributo, tipo, origem, staging area, SCD (e uma versão curta da transformação).

---

## 6. Decisões já tomadas (para não as contradizer)

- **Extração:**
  - **opção B**, incremental pelas datas de auditoria com 1 dia de margem;
  - families, categories e zones extraídas por inteiro e comparadas com a versão anterior;
  - quando uma zona, família ou categoria muda, extraem-se também os registos dependentes;
  - faturas e linhas extraídas em conjunto;
  - produtos referidos pelas linhas extraídas;
  - chefe e subordinados dos funcionários extraídos.
- **Sobrevivente nos duplicados:** o número mais baixo (clientes 10, 8, 5; fornecedor 8), completado com os atributos do duplicado.
- **País:** vem da zona (MAP_ZoneCountry), exceto quando o código postal é estrangeiro, caso em que é o país do código postal. A regra é igual para clientes e fornecedores. **Zona e País não formam hierarquia** (o fornecedor italiano 10 está na zona "Centro").
- **Z001 e CORSR:** vão para ERR_products (E08) e não entram na DimProduct.
- **EntityType** dos fornecedores: 3 = Genérico ("Compras a Dinheiro"), 13 = Interno ("MaisRitmo (interno)") e os restantes Externo.
- **Atributos fora do DM:** contactos, emails, telefones, moradas, BBAN, seller, nationality, preços de catálogo e stocks.
- **Câmbios:** taxas diárias do BCE, a da data da fatura (ou a última anterior); RateToEUR = 1 / taxa publicada.
- **Nomes do DM** em inglês, em PascalCase (por exemplo, clity → Locality, days_pay_invoices → PaymentTermDays, zip_code → PostalCode + City).

---

## 7. Cuidados práticos

- Fazer **pull** antes de começar e **fechar o Word** antes do commit: o OneDrive tem estado a repor versões antigas dos ficheiros que estão abertos.
- O `.docx` não se junta no Git. Só uma pessoa deve editar o ficheiro de cada vez.
- No fim, atualizar todos os campos (Ctrl+A → F9) e confirmar os índices antes de exportar para PDF.
