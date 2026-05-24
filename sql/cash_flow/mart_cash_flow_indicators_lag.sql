CREATE TABLE mart_cash_flow_indicators_lag AS
WITH base_com_lag AS (
    SELECT
        periodo,

        lucro_liquido_periodo,
        caixa_operacional,
        capex,
        fluxo_caixa_livre,
        caixa_financiamentos,
        variacao_caixa_equivalentes,
        caixa_fim_periodo,

        caixa_operacional_sobre_lucro,
        capex_sobre_caixa_operacional,
        fluxo_caixa_livre_sobre_caixa_operacional,
        dividendos_sobre_caixa_operacional,
        recompra_sobre_caixa_operacional,
        caixa_financiamentos_sobre_caixa_operacional,

        LAG(caixa_operacional, 4) OVER (ORDER BY periodo) AS caixa_operacional_lag_12m,
        LAG(fluxo_caixa_livre, 4) OVER (ORDER BY periodo) AS fluxo_caixa_livre_lag_12m,
        LAG(capex, 4) OVER (ORDER BY periodo) AS capex_lag_12m,
        LAG(caixa_financiamentos, 4) OVER (ORDER BY periodo) AS caixa_financiamentos_lag_12m,
        LAG(caixa_fim_periodo, 4) OVER (ORDER BY periodo) AS caixa_fim_periodo_lag_12m,

        LAG(caixa_operacional_sobre_lucro, 4) OVER (ORDER BY periodo) AS caixa_operacional_sobre_lucro_lag_12m,
        LAG(fluxo_caixa_livre_sobre_caixa_operacional, 4) OVER (ORDER BY periodo) AS fluxo_caixa_livre_sobre_caixa_operacional_lag_12m,
        LAG(capex_sobre_caixa_operacional, 4) OVER (ORDER BY periodo) AS capex_sobre_caixa_operacional_lag_12m

    FROM mart_cash_flow_indicators
)

SELECT
    *,

    CASE
        WHEN caixa_operacional_lag_12m <> 0
        THEN caixa_operacional / caixa_operacional_lag_12m - 1
    END AS caixa_operacional_var_12m,

    CASE
        WHEN fluxo_caixa_livre_lag_12m <> 0
        THEN fluxo_caixa_livre / fluxo_caixa_livre_lag_12m - 1
    END AS fluxo_caixa_livre_var_12m,

    CASE
        WHEN capex_lag_12m <> 0
        THEN ABS(capex) / ABS(capex_lag_12m) - 1
    END AS capex_var_12m,

    CASE
        WHEN caixa_fim_periodo_lag_12m <> 0
        THEN caixa_fim_periodo / caixa_fim_periodo_lag_12m - 1
    END AS caixa_fim_periodo_var_12m,

    caixa_operacional_sobre_lucro - caixa_operacional_sobre_lucro_lag_12m AS caixa_operacional_sobre_lucro_delta_12m,

    fluxo_caixa_livre_sobre_caixa_operacional - fluxo_caixa_livre_sobre_caixa_operacional_lag_12m AS fluxo_caixa_livre_sobre_caixa_operacional_delta_12m,

    capex_sobre_caixa_operacional - capex_sobre_caixa_operacional_lag_12m AS capex_sobre_caixa_operacional_delta_12m

FROM base_com_lag
ORDER BY periodo;