CREATE TABLE mart_company_credit_rating_v2 AS
WITH base AS (
    SELECT
        sr.periodo,

        -- Carteira / crédito
        sr.score_total_risco AS score_carteira_credito,
        sr.rating_credito AS rating_carteira_credito,

        sr.recebiveis_sobre_ativo_pct,
        sr.caixa_sobre_ativo_pct,
        sr.liquidez_corrente,

        sr.bad_ratio_vencidos_pct,
        sr.bad_ratio_stage_3_pct,
        sr.bad_ratio_perdas_liquidas_pct,

        sr.vencidos_sobre_carteira_delta_12m_pp,
        sr.estagio_3_sobre_vencidos_delta_12m_pp,

        -- Financeiro PJ v2
        fp.receita_operacional_liquida,
        fp.receita_operacional_liquida_var_12m,

        fp.margem_operacional,
        fp.margem_liquida,
        fp.perdas_credito_sobre_receita,

        fp.caixa_operacional,
        fp.fluxo_caixa_livre,
        fp.caixa_fim_periodo,
        fp.caixa_fim_periodo_var_12m,

        fp.ebitda_total_ajustado,
        fp.margem_ebitda_total_ajustado,
        fp.ebitda_total_ajustado_var_12m,

        fp.score_margem_operacional,
        fp.score_margem_liquida,
        fp.score_perdas_credito_receita,
        fp.score_fluxo_caixa_livre,
        fp.score_queda_caixa,
        fp.score_margem_ebitda,
        fp.score_tendencia_ebitda,

        fp.score_financeiro_pj_v2 AS score_financeiro_pj

    FROM mart_score_rating AS sr
    LEFT JOIN mart_financial_performance_features_v2 AS fp
        ON sr.periodo = fp.periodo
),

score_consolidado AS (
    SELECT
        *,

        (
            score_carteira_credito
            + COALESCE(score_financeiro_pj, 0)
        ) AS score_total_consolidado

    FROM base
)

SELECT
    *,

    CASE
        WHEN score_financeiro_pj IS NULL THEN 'Sem dados financeiros PJ'
        WHEN score_financeiro_pj <= 3 THEN 'PJ forte'
        WHEN score_financeiro_pj <= 6 THEN 'PJ moderado'
        ELSE 'PJ pressionado'
    END AS classificacao_financeira_pj,

    CASE
        WHEN score_total_consolidado <= 5 THEN 'A - Baixo risco consolidado'
        WHEN score_total_consolidado <= 10 THEN 'B - Risco moderado consolidado'
        WHEN score_total_consolidado <= 15 THEN 'C - Risco elevado consolidado'
        ELSE 'D - Risco crítico consolidado'
    END AS rating_consolidado,

    CASE
        WHEN score_carteira_credito >= 12
             AND COALESCE(score_financeiro_pj, 0) <= 6
        THEN 'Risco concentrado na carteira de crédito'

        WHEN score_carteira_credito < 8
             AND COALESCE(score_financeiro_pj, 0) >= 7
        THEN 'Risco concentrado na performance financeira PJ'

        WHEN score_carteira_credito >= 8
             AND COALESCE(score_financeiro_pj, 0) >= 7
        THEN 'Risco combinado: carteira e financeiro PJ'

        ELSE 'Risco moderado ou distribuído'
    END AS origem_principal_risco

FROM score_consolidado
ORDER BY periodo;