CREATE TABLE mart_macro_features AS
WITH base_macro AS (
    SELECT
        periodo,

        -- =========================
        -- VARIÁVEIS MACRO PRINCIPAIS
        -- =========================
        selic_meta AS selic_media_tri,
        ipca AS ipca_tri,
        ipca_acum_12m,

        inadimplencia_pf_total,
        inadimplencia_pf_total_delta_12m,

        comprometimento_renda_familias,
        comprometimento_renda_familias_delta_12m,

        endividamento_familias,
        endividamento_familias_delta_12m,

        -- =========================
        -- FLAGS MACRO SIMPLES
        -- =========================
        CASE
            WHEN selic_meta >= 13 THEN 1
            ELSE 0
        END AS flag_selic_alta,

        CASE
            WHEN ipca_acum_12m >= 5 THEN 1
            ELSE 0
        END AS flag_ipca_acima_meta_aprox,

        CASE
            WHEN inadimplencia_pf_total >= 4 THEN 1
            ELSE 0
        END AS flag_inadimplencia_pf_alta,

        CASE
            WHEN inadimplencia_pf_total_delta_12m >= 0.5 THEN 1
            ELSE 0
        END AS flag_piora_inadimplencia_pf_12m,

        CASE
            WHEN comprometimento_renda_familias >= 28 THEN 1
            ELSE 0
        END AS flag_comprometimento_renda_alto,

        CASE
            WHEN endividamento_familias >= 49 THEN 1
            ELSE 0
        END AS flag_endividamento_alto

    FROM stg_macro_quarterly
),

score_macro AS (
    SELECT
        *,

        (
            flag_selic_alta
            + flag_ipca_acima_meta_aprox
            + flag_inadimplencia_pf_alta
            + flag_piora_inadimplencia_pf_12m
            + flag_comprometimento_renda_alto
            + flag_endividamento_alto
        ) AS score_pressao_macro

    FROM base_macro
)

SELECT
    *,

    CASE
        WHEN score_pressao_macro <= 1 THEN 'Macro favorável ou neutra'
        WHEN score_pressao_macro <= 3 THEN 'Macro em atenção'
        ELSE 'Macro pressionada'
    END AS classificacao_macro

FROM score_macro
ORDER BY periodo;