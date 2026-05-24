CREATE TABLE stg_accounts_receivables_clean AS

WITH base AS ( 

SELECT 

ROWID AS row_id_original,

TRIM(ACCOUNTS_RECEIVABLES_BY_DUE_DATE_THOUSAND_OF_R) AS conta_en,
TRIM(CONTAS_A_RECEBER_POR_FAIXA_DE_VENCIMENTO_R_MIL) AS conta_pt,
SUBSTR(PERIODO, 1, 10) AS periodo,
CAST(VALOR AS REAL) AS valor,
ORIGEM_TABELA AS origem_tabela

FROM stg_accounts_receivables_long 
WHERE ACCOUNTS_RECEIVABLES_BY_DUE_DATE_THOUSAND_OF_R IS NOT NULL
AND TRIM(ACCOUNTS_RECEIVABLES_BY_DUE_DATE_THOUSAND_OF_R) <> ''

),

ordenado AS

(

SELECT
*,
ROW_NUMBER () OVER(PARTITION BY periodo ORDER BY row_id_original) AS ordem_linha

FROM base

)


SELECT

*

FROM ordenado
ORDER BY periodo, ordem_linha

