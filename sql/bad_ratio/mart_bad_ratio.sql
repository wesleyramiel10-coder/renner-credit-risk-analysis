CREATE TABLE mart_bad_ratio AS

SELECT
    periodo,

    -- =========================
    -- BASE DA CARTEIRA
    -- =========================
    carteira_total_cartoes,
    vencidos_total,
    vencidos_estagio_3,
    perdas_credito_liquidas_recuperacoes,

    -- =========================
    -- BAD RATIO 1: VENCIDOS
    -- =========================
    CASE
        WHEN carteira_total_cartoes <> 0
        THEN vencidos_total / carteira_total_cartoes
    END AS bad_ratio_vencidos,

    -- =========================
    -- BAD RATIO 2: STAGE 3
    -- =========================
    CASE
        WHEN carteira_total_cartoes <> 0
        THEN vencidos_estagio_3 / carteira_total_cartoes
    END AS bad_ratio_stage_3,

    -- =========================
    -- BAD RATIO 3: PERDAS LÍQUIDAS
    -- =========================
    CASE
        WHEN carteira_total_cartoes <> 0
        THEN ABS(perdas_credito_liquidas_recuperacoes) / carteira_total_cartoes
    END AS bad_ratio_perdas_liquidas,

    -- =========================
    -- VARIÁVEIS DE APOIO
    -- =========================
    vencidos_sobre_carteira_pct,
    estagio_3_sobre_vencidos_pct,
    perdas_liquidas_sobre_carteira_pct,

    vencidos_sobre_carteira_delta_12m_pp,
    estagio_3_sobre_vencidos_delta_12m_pp,
    perdas_liquidas_sobre_carteira_delta_12m_pp,

    qtd_alertas_credito,
    classificacao_risco_credito

FROM mart_credit_risk_features
ORDER BY periodo