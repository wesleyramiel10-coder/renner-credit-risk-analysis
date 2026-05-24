CREATE TABLE mart_credit_macro_features AS
SELECT
    r.periodo,

    -- =========================
    -- RATING / RENNER
    -- =========================
    r.score_carteira_credito,
    r.rating_carteira_credito,

    r.score_financeiro_pj,
    r.classificacao_financeira_pj,

    r.score_total_consolidado,
    r.rating_consolidado,
    r.origem_principal_risco,

    r.bad_ratio_vencidos_pct,
    r.bad_ratio_stage_3_pct,

    r.margem_operacional,
    r.margem_liquida,
    r.margem_ebitda_total_ajustado,
    r.perdas_credito_sobre_receita,

    r.caixa_operacional,
    r.fluxo_caixa_livre,
    r.caixa_fim_periodo,
    r.caixa_fim_periodo_var_12m,

    -- =========================
    -- MACRO
    -- =========================
    m.selic_media_tri,
    m.ipca_tri,
    m.ipca_acum_12m,

    m.inadimplencia_pf_total,
    m.inadimplencia_pf_total_delta_12m,

    m.comprometimento_renda_familias,
    m.comprometimento_renda_familias_delta_12m,

    m.endividamento_familias,
    m.endividamento_familias_delta_12m,

    m.score_pressao_macro,
    m.classificacao_macro,

    -- =========================
    -- LEITURA ANALÍTICA
    -- =========================
    CASE
        WHEN r.score_carteira_credito >= 12
             AND m.score_pressao_macro >= 4
        THEN 'Carteira pressionada em ambiente macro adverso'

        WHEN r.score_carteira_credito >= 12
             AND m.score_pressao_macro < 4
        THEN 'Carteira pressionada sem forte deterioração macro'

        WHEN r.score_carteira_credito < 8
             AND m.score_pressao_macro >= 4
        THEN 'Carteira resiliente apesar da macro pressionada'

        ELSE 'Carteira e macro sem desalinhamento crítico'
    END AS leitura_carteira_vs_macro

FROM mart_company_credit_rating_v2 r
LEFT JOIN mart_macro_features m
    ON r.periodo = m.periodo

ORDER BY r.periodo;