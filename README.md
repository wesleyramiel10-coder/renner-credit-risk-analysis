# Renner Credit Risk Analysis
## Projeto de Análise Integrada de Crédito Corporativo

Projeto completo de análise integrada de crédito corporativo da **Renner S.A.**, combinando demonstrações financeiras, carteira de crédito, inadimplência, indicadores macroeconômicos do Banco Central e dashboard executivo em Power BI.

---

## Visão Geral do Projeto

Este projeto foi desenvolvido com foco em **análise de crédito, analytics, business intelligence e monitoramento de risco corporativo**.

A proposta foi construir um pipeline analítico completo e auditável, desde a ingestão dos dados até a camada executiva de visualização.

Pergunta central do projeto:

> A Renner segue operacionalmente resiliente mesmo diante da deterioração da carteira de crédito e de um ambiente macroeconômico adverso?

---

## Tecnologias Utilizadas

- Power BI
- SQL
- SQLite
- Python
- Pandas
- Jupyter Notebook
- API SGS do Banco Central
- GitHub

---

## Arquitetura dos Dados

Pipeline analítico estruturado em camadas:

```text
Fontes de Dados
    ↓
RAW (dados brutos)
    ↓
STG (tratamento e padronização)
    ↓
MART (features e indicadores)
    ↓
MASTER (base consolidada)
    ↓
Power BI Dashboard Executivo
```

---

## Estrutura do Projeto

```text
renner-credit-risk-analysis/
│
├── dashboard/
│   ├── renner_credit_dashboard.pbix
│   └── renner_credit_dashboard.pdf
│
├── database/
│   └── analise_lren3.db
│
├── python/
│   ├── import_pandas.py
│   └── bcb_macro_pipeline.ipynb
│
├── sql/
│   ├── accounts_receivables/
│   ├── bad_ratio/
│   ├── balance_sheet/
│   ├── cash_flow/
│   ├── company/
│   ├── dim/
│   ├── doc/
│   ├── ebitda/
│   ├── income_statement/
│   ├── macro/
│   ├── master/
│   ├── npl_formation/
│   └── score_rating/
│
├── docs/
│   ├── arquitetura_dados.md
│   ├── conceitos_credito.md
│   ├── metodologia_score_rating.md
│   └── conclusoes.md
│
├── assets/
│   ├── icons/
│   ├── logos/
│   ├── screenshots/
│   └── cover/
│
└── README.md
```

---

## Componentes Analíticos

## 1. Performance Financeira (Empresa / PJ)

Indicadores desenvolvidos:

- Liquidez Corrente
- Caixa sobre Ativo
- Recebíveis sobre Ativo
- Passivo sobre Patrimônio Líquido
- Margem Operacional
- Margem EBITDA
- Margem Líquida
- Fluxo Caixa Livre
- Conversão Lucro em Caixa
- Caixa Operacional
- Estrutura de Capital

---

## 2. Carteira de Crédito

Indicadores desenvolvidos:

- Carteira Total
- Vencidos Totais
- Vencidos sobre Carteira
- Bad Ratio Vencidos
- Bad Ratio Stage 3
- Stage 3 sobre Vencidos
- Cobertura de Vencidos
- Perdas Estimadas
- Formação de NPL
- Severidade da Carteira

---

## 3. Macroeconomia

Dados consumidos via API oficial do Banco Central:

- Selic
- IPCA
- IPCA acumulado 12 meses
- Inadimplência Pessoa Física
- Endividamento das Famílias
- Comprometimento de Renda
- Pressão Financeira das Famílias

---

## 4. Modelo de Score e Rating

Framework analítico desenvolvido no projeto.

### Score Carteira

Considera:

- Vencidos
- Bad Ratio
- Stage 3
- Severidade
- Perdas estimadas

### Score Financeiro PJ

Considera:

- Liquidez
- Estrutura de capital
- Margens
- Geração de caixa
- Conversão lucro em caixa

### Score Macro

Considera:

- Juros
- Inflação
- Inadimplência
- Endividamento
- Pressão financeira do consumidor

### Rating Consolidado

Combinação dos pilares:

- Carteira
- Empresa / PJ
- Macro

---

## Principais Insights

### Resiliência Operacional

A Renner manteve:

- margens operacionais positivas;
- geração consistente de caixa;
- EBITDA resiliente;
- estrutura financeira controlada.

---

### Deterioração da Carteira

A carteira apresentou piora relevante em:

- vencidos;
- Bad Ratio;
- Stage 3;
- perdas estimadas;
- severidade dos atrasos.

---

### Pressão Macroeconômica

O ambiente econômico mostrou:

- juros elevados;
- inadimplência PF crescente;
- maior comprometimento de renda;
- endividamento elevado das famílias.

---

## Interpretação Final

A empresa segue operacionalmente resiliente.

Porém, a carteira de crédito exige monitoramento relevante.

---

## Reprodutibilidade

Projeto totalmente auditável.

Inclui:

- banco SQLite consolidado;
- scripts SQL completos;
- pipeline Python;
- integração com API do Banco Central;
- dashboard Power BI;
- documentação técnica;
- glossário de indicadores.

---

## Como Executar

### Clonar repositório

```bash
git clone https://github.com/wesleyramiel10-coder/renner-credit-risk-analysis.git
```

### Abrir banco SQLite

```text
database/analise_lren3.db
```

### Executar pipeline Python

```bash
python python/import_pandas.py
```

Notebook macro:

```text
python/bcb_macro_pipeline.ipynb
```

### Abrir dashboard

```text
dashboard/renner_credit_dashboard.pbix
```

ou

```text
dashboard/renner_credit_dashboard.pdf
```

---

## Diferenciais Técnicos

Demonstra experiência prática em:

- SQL analítico
- modelagem de dados
- marts
- ETL
- indicadores financeiros
- análise de crédito
- consumo de APIs
- Python
- SQLite
- Power BI executivo
- documentação técnica
- storytelling analítico

---

## Autor

**Wesley Ramiel**

Power BI | SQL | Python | Analytics | Credit Risk

LinkedIn: [*(Wesley Ramiel)*](https://www.linkedin.com/in/wesleyramiel/)

---

## Disclaimer

Projeto educacional e analítico.

Não representa recomendação de investimento nem rating oficial da companhia.
