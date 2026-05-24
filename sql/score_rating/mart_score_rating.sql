CREATE TABLE mart_score_rating AS
WITH scores_base AS (
    SELECT
        f.periodo,

        -- =========================
        -- INDICADORES BASE
        -- =========================
        f.recebiveis_sobre_ativo_pct,
        f.caixa_sobre_ativo_pct,
        f.liquidez_corrente,

        b.bad_ratio_vencidos * 100 AS bad_ratio_vencidos_pct,
        b.bad_ratio_stage_3 * 100 AS bad_ratio_stage_3_pct,
        b.bad_ratio_perdas_liquidas * 100 AS bad_ratio_perdas_liquidas_pct,

        f.vencidos_sobre_carteira_delta_12m_pp,
        f.estagio_3_sobre_vencidos_delta_12m_pp,

        f.qtd_alertas_credito,
        f.classificacao_risco_credito AS classificacao_flags,

        -- =========================
        -- SCORE 1: ESTRUTURA PATRIMONIAL
        -- =========================
        CASE
            WHEN f.caixa_sobre_ativo_pct >= 15 THEN 0
            WHEN f.caixa_sobre_ativo_pct >= 10 THEN 1
            ELSE 2
        END AS score_caixa,

        CASE
            WHEN f.recebiveis_sobre_ativo_pct < 25 THEN 0
            WHEN f.recebiveis_sobre_ativo_pct < 35 THEN 1
            ELSE 2
        END AS score_recebiveis_ativo,

        CASE
            WHEN f.liquidez_corrente >= 1.7 THEN 0
            WHEN f.liquidez_corrente >= 1.3 THEN 1
            ELSE 2
        END AS score_liquidez,

        -- =========================
        -- SCORE 2: BAD RATIO / CARTEIRA
        -- =========================
        CASE
            WHEN b.bad_ratio_vencidos * 100 < 20 THEN 0
            WHEN b.bad_ratio_vencidos * 100 < 25 THEN 1
            ELSE 2
        END AS score_bad_vencidos,

        CASE
            WHEN b.bad_ratio_stage_3 * 100 < 15 THEN 0
            WHEN b.bad_ratio_stage_3 * 100 < 20 THEN 1
            ELSE 2
        END AS score_bad_stage_3,

        CASE
            WHEN b.bad_ratio_perdas_liquidas * 100 < 3 THEN 0
            WHEN b.bad_ratio_perdas_liquidas * 100 < 5 THEN 1
            ELSE 2
        END AS score_perdas_liquidas,

        -- =========================
        -- SCORE 3: TENDÊNCIA
        -- =========================
        CASE
            WHEN f.vencidos_sobre_carteira_delta_12m_pp IS NULL THEN 0
            WHEN f.vencidos_sobre_carteira_delta_12m_pp < 0 THEN 0
            WHEN f.vencidos_sobre_carteira_delta_12m_pp < 5 THEN 1
            ELSE 2
        END AS score_tendencia_vencidos,

        CASE
            WHEN f.estagio_3_sobre_vencidos_delta_12m_pp IS NULL THEN 0
            WHEN f.estagio_3_sobre_vencidos_delta_12m_pp < 0 THEN 0
            WHEN f.estagio_3_sobre_vencidos_delta_12m_pp < 10 THEN 1
            ELSE 2
        END AS score_tendencia_stage_3

    FROM mart_credit_risk_features f
    LEFT JOIN mart_bad_ratio b
        ON f.periodo = b.periodo
),

score_final AS (
    SELECT
        *,

        (
            score_caixa
            + score_recebiveis_ativo
            + score_liquidez
            + score_bad_vencidos
            + score_bad_stage_3
            + score_perdas_liquidas
            + score_tendencia_vencidos
            + score_tendencia_stage_3
        ) AS score_total_risco

    FROM scores_base
)

SELECT
    periodo,

    -- =========================
    -- INDICADORES BASE
    -- =========================
    recebiveis_sobre_ativo_pct,
    caixa_sobre_ativo_pct,
    liquidez_corrente,

    bad_ratio_vencidos_pct,
    bad_ratio_stage_3_pct,
    bad_ratio_perdas_liquidas_pct,

    vencidos_sobre_carteira_delta_12m_pp,
    estagio_3_sobre_vencidos_delta_12m_pp,

    qtd_alertas_credito,
    classificacao_flags,

    -- =========================
    -- SCORES INDIVIDUAIS
    -- =========================
    score_caixa,
    score_recebiveis_ativo,
    score_liquidez,
    score_bad_vencidos,
    score_bad_stage_3,
    score_perdas_liquidas,
    score_tendencia_vencidos,
    score_tendencia_stage_3,

    -- =========================
    -- SCORE FINAL
    -- =========================
    score_total_risco,

    -- =========================
    -- RATING FINAL
    -- =========================
    CASE
        WHEN score_total_risco <= 3 THEN 'A - Baixo risco'
        WHEN score_total_risco <= 7 THEN 'B - Risco moderado'
        WHEN score_total_risco <= 11 THEN 'C - Risco elevado'
        ELSE 'D - Risco crítico'
    END AS rating_credito

FROM score_final
ORDER BY periodo;