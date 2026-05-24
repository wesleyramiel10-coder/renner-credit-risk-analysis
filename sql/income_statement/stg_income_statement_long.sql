

CREATE TABLE stg_income_statement_long AS
WITH base AS (
    SELECT
        ROWID AS row_id_original,
        TRIM(INCOME_STATEMENT_CONSOLIDATED_THOUSAND_OF_R) AS conta_en,
        TRIM(DEMONSTRAÇÃO_DO_RESULTADO_CONSOLIDADO_R_MIL) AS conta_pt,

        "1Q21", "2Q21", "3Q21", "4Q21",
        "1Q22", "2Q22", "3Q22", "4Q22",
        "1Q23", "2Q23", "3Q23", "4Q23",
        "1Q24", "2Q24", "3Q24", "4Q24",
        "1Q25", "2Q25", "3Q25", "4Q25"

    FROM raw_income_statement
    WHERE
        INCOME_STATEMENT_CONSOLIDATED_THOUSAND_OF_R IS NOT NULL
        AND TRIM(INCOME_STATEMENT_CONSOLIDATED_THOUSAND_OF_R) <> ''
),

long_base AS (
    SELECT row_id_original, conta_en, conta_pt, '2021-03-31' AS periodo, "1Q21" AS valor_original FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2021-06-30', "2Q21" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2021-09-30', "3Q21" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2021-12-31', "4Q21" FROM base

    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2022-03-31', "1Q22" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2022-06-30', "2Q22" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2022-09-30', "3Q22" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2022-12-31', "4Q22" FROM base

    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2023-03-31', "1Q23" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2023-06-30', "2Q23" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2023-09-30', "3Q23" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2023-12-31', "4Q23" FROM base

    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2024-03-31', "1Q24" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2024-06-30', "2Q24" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2024-09-30', "3Q24" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2024-12-31', "4Q24" FROM base

    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2025-03-31', "1Q25" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2025-06-30', "2Q25" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2025-09-30', "3Q25" FROM base
    UNION ALL SELECT row_id_original, conta_en, conta_pt, '2025-12-31', "4Q25" FROM base
),

tratado AS (
    SELECT
        row_id_original,
        conta_en,
        conta_pt,
        periodo,

        CASE
            WHEN valor_original IS NULL THEN NULL
            WHEN TRIM(CAST(valor_original AS TEXT)) = '' THEN NULL
            WHEN UPPER(TRIM(CAST(valor_original AS TEXT))) = 'ND' THEN NULL

            -- Se já veio como número no SQLite, usa direto
            WHEN typeof(valor_original) IN ('real', 'integer')
            THEN CAST(valor_original AS REAL)

            -- Se vier como percentual com %, transforma em decimal
            WHEN CAST(valor_original AS TEXT) LIKE '%\%%' ESCAPE '\'
            THEN CAST(
                REPLACE(
                    REPLACE(
                        REPLACE(CAST(valor_original AS TEXT), '%', ''),
                    ',', '.'),
                ' ', '')
            AS REAL) / 100.0

            -- Se vier como texto com vírgula decimal e sem ponto de milhar
            WHEN CAST(valor_original AS TEXT) LIKE '%,%'
                 AND CAST(valor_original AS TEXT) NOT LIKE '%.%'
            THEN CAST(
                REPLACE(
                    REPLACE(CAST(valor_original AS TEXT), ',', '.'),
                ' ', '')
            AS REAL)

            -- Se vier como texto monetário brasileiro: 4.840.846 ou -1.884.324
            ELSE CAST(
                REPLACE(
                    REPLACE(
                        REPLACE(CAST(valor_original AS TEXT), '.', ''),
                    ',', '.'),
                ' ', '')
            AS REAL)
        END AS valor,

        CASE
            WHEN conta_en LIKE '%(%)%'
              OR conta_pt LIKE '%Margem%'
              OR conta_pt LIKE '%Mesmas Lojas%'
              OR CAST(valor_original AS TEXT) LIKE '%\%%' ESCAPE '\'
            THEN 'percentual'
            ELSE 'monetario'
        END AS tipo_valor,

        'income_statement' AS origem_tabela

    FROM long_base
),

ordenado AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY periodo
            ORDER BY row_id_original
        ) AS ordem_conta
    FROM tratado
    WHERE valor IS NOT NULL
)

SELECT *
FROM ordenado
ORDER BY periodo, ordem_conta;