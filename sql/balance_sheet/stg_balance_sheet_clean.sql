DROP TABLE IF EXISTS stg_balance_sheet_clean;

CREATE TABLE stg_balance_sheet_clean AS
WITH base AS (
    SELECT
        ROWID AS row_id_original,

        TRIM(BALANCE_SHEET_CONSOLIDATED_THOUSAND_OF_R) AS conta_en,
        TRIM(BALANÇO_PATRIMONIAL_CONSOLIDADO_R_MIL) AS conta_pt,

        SUBSTR(PERIODO, 1, 10) AS periodo,

        CAST(VALOR AS REAL) AS valor,

        ORIGEM_TABELA AS origem_tabela
    FROM stg_balance_sheet_long
    WHERE
        BALANCE_SHEET_CONSOLIDATED_THOUSAND_OF_R IS NOT NULL
        AND BALANÇO_PATRIMONIAL_CONSOLIDADO_R_MIL IS NOT NULL
        AND VALOR IS NOT NULL
),
ordenado AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY periodo
            ORDER BY row_id_original
        ) AS ordem_conta
    FROM base
)
SELECT *
FROM ordenado;