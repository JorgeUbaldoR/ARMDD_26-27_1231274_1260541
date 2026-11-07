# Perguntas para o professor

Dúvidas a esclarecer com o docente, com o contexto e a decisão provisória do grupo.

## 1. Atributos descritivos nas dimensões (DimCustomer / DimSupplier)

**Pergunta:** Devemos incluir nas dimensões os atributos de contacto e identificação que não servem para filtrar ou agrupar vendas (morada, email, telefone, telemóvel, pessoa de contacto, BBAN), ou podemos deixá-los de fora?

**Contexto:**
- Os atributos de uma dimensão servem para filtrar e agrupar as vendas ("vendas por zona", "por tipo de cliente"). Ninguém analisa vendas por telefone ou BBAN.
- O BBAN é um dado bancário sensível, e o data mart vai ser consultado no Power BI.
- Estes campos têm muitos valores em falta (IDs 12 a 18 do `problemas_qualidade.xlsx`).
- O `seller` dos clientes não tem FK, tem valores 0 e não corresponde ao funcionário da fatura (que vem de `invoices.employee`).

**Decisão provisória:** Ficam de fora BBAN, phone, mobile, email, contact, address e seller. Se o professor preferir dimensões mais completas, acrescentamos Address, Email e Phone como SCD tipo 1. O BBAN fica sempre de fora.

## 2. Renomear e separar colunas da origem na dimensão

**Pergunta:** Podemos dar novos nomes às colunas na dimensão e separar uma coluna da origem em duas?

**Contexto:**
- `clity` (com erro ortográfico e que contém o bairro e não a cidade) passa a `Locality`.
- `zip_code` passa a `PostalCode` + `City`, porque a cidade vem dentro do código postal e as análises 2 e 8 pedem a cidade do cliente.
- `type` passa a `CustomerType` (palavra reservada e ambígua ao lado de `SupplierType`).
- `days_pay_invoices` passa a `PaymentTermDays`.
- `zone` guarda o nome da zona e não o código.
- `Country` é um atributo novo, derivado do código postal.

**Decisão provisória:** Renomear e separar, documentando a correspondência origem → data mart na tabela de mapeamento.
