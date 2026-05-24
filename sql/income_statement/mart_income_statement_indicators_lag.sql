CREATE TABLE mart_income_statement_indicators_lag AS
WITH base_com_lag AS (
    SELECT
        periodo,

        receita_operacional_liquida,
        receita_liquida_varejo,
        receita_liquida_servicos_financeiros,
        lucro_bruto,
        despesas_operacionais,
        perdas_em_credito,
        lucro_operacional_antes_resultado_financeiro,
        lucro_liquido,

        margem_bruta,
        margem_operacional,
        margem_liquida,
        despesas_operacionais_sobre_receita,
        perdas_credito_sobre_receita,
        resultado_financeiro_sobre_receita,
        varejo_sobre_receita,
        servicos_financeiros_sobre_receita,
        margem_bruta_varejo,
        margem_bruta_servicos_financeiros,

        LAG(receita_operacional_liquida, 1) OVER (ORDER BY periodo) AS receita_operacional_liquida_lag_1t,
        LAG(receita_operacional_liquida, 4) OVER (ORDER BY periodo) AS receita_operacional_liquida_lag_12m,

        LAG(lucro_bruto, 1) OVER (ORDER BY periodo) AS lucro_bruto_lag_1t,
        LAG(lucro_bruto, 4) OVER (ORDER BY periodo) AS lucro_bruto_lag_12m,

        LAG(lucro_operacional_antes_resultado_financeiro, 1) OVER (ORDER BY periodo) AS lucro_operacional_lag_1t,
        LAG(lucro_operacional_antes_resultado_financeiro, 4) OVER (ORDER BY periodo) AS lucro_operacional_lag_12m,

        LAG(lucro_liquido, 1) OVER (ORDER BY periodo) AS lucro_liquido_lag_1t,
        LAG(lucro_liquido, 4) OVER (ORDER BY periodo) AS lucro_liquido_lag_12m,

        LAG(perdas_em_credito, 1) OVER (ORDER BY periodo) AS perdas_em_credito_lag_1t,
        LAG(perdas_em_credito, 4) OVER (ORDER BY periodo) AS perdas_em_credito_lag_12m,

        LAG(margem_bruta, 4) OVER (ORDER BY periodo) AS margem_bruta_lag_12m,
        LAG(margem_operacional, 4) OVER (ORDER BY periodo) AS margem_operacional_lag_12m,
        LAG(margem_liquida, 4) OVER (ORDER BY periodo) AS margem_liquida_lag_12m,
        LAG(perdas_credito_sobre_receita, 4) OVER (ORDER BY periodo) AS perdas_credito_sobre_receita_lag_12m,
        LAG(servicos_financeiros_sobre_receita, 4) OVER (ORDER BY periodo) AS servicos_financeiros_sobre_receita_lag_12m

    FROM mart_income_statement_indicators
)

SELECT
    *,

    CASE
        WHEN receita_operacional_liquida_lag_1t <> 0
        THEN receita_operacional_liquida / receita_operacional_liquida_lag_1t - 1
    END AS receita_operacional_liquida_var_1t,

    CASE
        WHEN receita_operacional_liquida_lag_12m <> 0
        THEN receita_operacional_liquida / receita_operacional_liquida_lag_12m - 1
    END AS receita_operacional_liquida_var_12m,

    CASE
        WHEN lucro_bruto_lag_12m <> 0
        THEN lucro_bruto / lucro_bruto_lag_12m - 1
    END AS lucro_bruto_var_12m,

    CASE
        WHEN lucro_operacional_lag_12m <> 0
        THEN lucro_operacional_antes_resultado_financeiro / lucro_operacional_lag_12m - 1
    END AS lucro_operacional_var_12m,

    CASE
        WHEN lucro_liquido_lag_12m <> 0
        THEN lucro_liquido / lucro_liquido_lag_12m - 1
    END AS lucro_liquido_var_12m,

    CASE
        WHEN perdas_em_credito_lag_12m <> 0
        THEN ABS(perdas_em_credito) / ABS(perdas_em_credito_lag_12m) - 1
    END AS perdas_em_credito_var_12m,

    margem_bruta - margem_bruta_lag_12m AS margem_bruta_delta_12m,
    margem_operacional - margem_operacional_lag_12m AS margem_operacional_delta_12m,
    margem_liquida - margem_liquida_lag_12m AS margem_liquida_delta_12m,
    perdas_credito_sobre_receita - perdas_credito_sobre_receita_lag_12m AS perdas_credito_sobre_receita_delta_12m,
    servicos_financeiros_sobre_receita - servicos_financeiros_sobre_receita_lag_12m AS servicos_financeiros_sobre_receita_delta_12m

FROM base_com_lag
ORDER BY periodo;