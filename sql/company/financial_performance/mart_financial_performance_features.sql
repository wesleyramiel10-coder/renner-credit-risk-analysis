CREATE TABLE mart_financial_performance_features AS
SELECT
    dre.periodo,

    -- =========================
    -- DRE / RESULTADO
    -- =========================
    dre.receita_operacional_liquida,
    dre.lucro_bruto,
    dre.lucro_operacional_antes_resultado_financeiro,
    dre.lucro_liquido,
    dre.perdas_em_credito,

    dre.margem_bruta,]
    dre.margem_operacional,
    dre.margem_liquida,
    dre.perdas_credito_sobre_receita,

    dre.receita_operacional_liquida_var_12m,
    dre.lucro_bruto_var_12m,
    dre.lucro_operacional_var_12m,
    dre.lucro_liquido_var_12m,
    dre.perdas_em_credito_var_12m,

    dre.margem_bruta_delta_12m,
    dre.margem_operacional_delta_12m,
    dre.margem_liquida_delta_12m,
    dre.perdas_credito_sobre_receita_delta_12m,

    -- =========================
    -- FLUXO DE CAIXA
    -- =========================
    cf.caixa_operacional,
    cf.capex,
    cf.fluxo_caixa_livre,
    cf.caixa_financiamentos,
    cf.variacao_caixa_equivalentes,
    cf.caixa_fim_periodo,

    cf.caixa_operacional_sobre_lucro,
    cf.capex_sobre_caixa_operacional,
    cf.fluxo_caixa_livre_sobre_caixa_operacional,

    cf.caixa_operacional_var_12m,
    cf.fluxo_caixa_livre_var_12m,
    cf.caixa_fim_periodo_var_12m,

    -- =========================
    -- FLAGS FINANCEIRAS SIMPLES
    -- =========================
    CASE
        WHEN dre.margem_operacional >= 0.10 THEN 0
        WHEN dre.margem_operacional >= 0.05 THEN 1
        ELSE 2
    END AS score_margem_operacional,

    CASE
        WHEN dre.margem_liquida >= 0.08 THEN 0
        WHEN dre.margem_liquida >= 0.04 THEN 1
        ELSE 2
    END AS score_margem_liquida,

    CASE
        WHEN dre.perdas_credito_sobre_receita < 0.05 THEN 0
        WHEN dre.perdas_credito_sobre_receita < 0.08 THEN 1
        ELSE 2
    END AS score_perdas_credito_receita,

    CASE
        WHEN cf.fluxo_caixa_livre > 0 THEN 0
        ELSE 2
    END AS score_fluxo_caixa_livre,

    CASE
        WHEN cf.caixa_fim_periodo_var_12m IS NULL THEN 0
        WHEN cf.caixa_fim_periodo_var_12m >= 0 THEN 0
        WHEN cf.caixa_fim_periodo_var_12m >= -0.25 THEN 1
        ELSE 2
    END AS score_queda_caixa

FROM mart_income_statement_indicators_lag AS dre
LEFT JOIN mart_cash_flow_indicators_lag AS cf
    ON dre.periodo = cf.periodo

ORDER BY dre.periodo;