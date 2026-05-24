CREATE TABLE stg_cash_flow_long AS
WITH base AS (
    SELECT
        ROWID AS row_id_original,
        TRIM(CASH_FLOW_STATEMENT_THOUSAND_OF_R) AS conta_en,
        TRIM(DEMONSTRAÇÃO_DOS_FLUXOS_DE_CAIXA_R_MIL) AS conta_pt,

        "1Q22", "2Q22", "3Q22", "4Q22",
        "1Q23", "2Q23", "3Q23", "4Q23",
        "1Q24", "2Q24", "3Q24", "4Q24",
        "1Q25", "2Q25", "3Q25", "4Q25"

    FROM raw_cash_flow
    WHERE
        CASH_FLOW_STATEMENT_THOUSAND_OF_R IS NOT NULL
        AND TRIM(CASH_FLOW_STATEMENT_THOUSAND_OF_R) <> ''
),

long_base AS (
    SELECT row_id_original, conta_en, conta_pt, '2022-03-31' AS periodo, "1Q22" AS valor_original FROM base
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

            WHEN typeof(valor_original) IN ('real', 'integer')
            THEN CAST(valor_original AS REAL)

            ELSE CAST(
                REPLACE(
                    REPLACE(
                        REPLACE(CAST(valor_original AS TEXT), '.', ''),
                    ',', '.'),
                ' ', '')
            AS REAL)
        END AS valor,

        'cash_flow' AS origem_tabela

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
