CREATE TABLE mart_financial_performance_features_v2 AS
SELECT
    fp.periodo,

    -- DRE
    fp.receita_operacional_liquida,
    fp.receita_operacional_liquida_var_12m,
    fp.margem_operacional,
    fp.margem_liquida,
    fp.perdas_credito_sobre_receita,

    fp.lucro_liquido,
    fp.lucro_liquido_var_12m,
    fp.perdas_em_credito,
    fp.perdas_em_credito_var_12m,

    -- Cash Flow
    fp.caixa_operacional,
    fp.fluxo_caixa_livre,
    fp.caixa_fim_periodo,
    fp.caixa_fim_periodo_var_12m,

    fp.caixa_operacional_sobre_lucro,
    fp.capex_sobre_caixa_operacional,
    fp.fluxo_caixa_livre_sobre_caixa_operacional,

    -- EBITDA
    e.ebitda_total_ajustado,
    e.margem_ebitda_total_ajustado,
    e.ebitda_total_ajustado_var_12m,
    e.margem_ebitda_total_ajustado_delta_12m,

    e.ebitda_ajustado_varejo,
    e.margem_ebitda_ajustado_varejo,
    e.ebitda_ajustado_varejo_var_12m,
    e.margem_ebitda_ajustado_varejo_delta_12m,

    e.ebitda_servicos_financeiros,
    e.servicos_financeiros_sobre_ebitda_ajustado,

    -- Scores anteriores
    fp.score_margem_operacional,
    fp.score_margem_liquida,
    fp.score_perdas_credito_receita,
    fp.score_fluxo_caixa_livre,
    fp.score_queda_caixa,

    -- Novo score de EBITDA
    CASE
        WHEN e.margem_ebitda_total_ajustado >= 0.20 THEN 0
        WHEN e.margem_ebitda_total_ajustado >= 0.15 THEN 1
        ELSE 2
    END AS score_margem_ebitda,

    CASE
        WHEN e.ebitda_total_ajustado_var_12m IS NULL THEN 0
        WHEN e.ebitda_total_ajustado_var_12m >= 0 THEN 0
        WHEN e.ebitda_total_ajustado_var_12m >= -0.10 THEN 1
        ELSE 2
    END AS score_tendencia_ebitda,

    -- Score financeiro PJ atualizado
    (
        fp.score_margem_operacional
        + fp.score_margem_liquida
        + fp.score_perdas_credito_receita
        + fp.score_fluxo_caixa_livre
        + fp.score_queda_caixa
        +
        CASE
            WHEN e.margem_ebitda_total_ajustado >= 0.20 THEN 0
            WHEN e.margem_ebitda_total_ajustado >= 0.15 THEN 1
            ELSE 2
        END
        +
        CASE
            WHEN e.ebitda_total_ajustado_var_12m IS NULL THEN 0
            WHEN e.ebitda_total_ajustado_var_12m >= 0 THEN 0
            WHEN e.ebitda_total_ajustado_var_12m >= -0.10 THEN 1
            ELSE 2
        END
    ) AS score_financeiro_pj_v2

FROM mart_financial_performance_features fp
LEFT JOIN mart_ebitda_indicators_lag e
    ON fp.periodo = e.periodo

ORDER BY fp.periodo;