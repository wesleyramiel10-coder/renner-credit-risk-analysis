CREATE TABLE mart_npl_formation_indicators_lag AS
WITH base_com_lag AS (
    SELECT
        periodo,

        write_off,
        npl_formation,
        npl_formation_stage_3,
        npl_stage_3_sobre_carteira_media,
        vencidos_total_npl,
        vencidos_estagio_1,
        vencidos_estagio_2,
        vencidos_estagio_3,
        perdas_credito_liquidas_recuperacoes,
        pdd,
        recuperacoes,
        carteira_total_cartoes,

        npl_formation_sobre_carteira,
        npl_formation_stage_3_sobre_carteira,
        write_off_sobre_carteira,
        pdd_sobre_carteira,
        estagio_3_sobre_vencidos,
        pdd_sobre_vencidos,
        recuperacoes_sobre_pdd,
        perdas_liquidas_sobre_carteira,

        LAG(npl_formation, 1) OVER (ORDER BY periodo) AS npl_formation_lag_1t,
        LAG(npl_formation, 4) OVER (ORDER BY periodo) AS npl_formation_lag_12m,

        LAG(npl_formation_stage_3, 1) OVER (ORDER BY periodo) AS npl_formation_stage_3_lag_1t,
        LAG(npl_formation_stage_3, 4) OVER (ORDER BY periodo) AS npl_formation_stage_3_lag_12m,

        LAG(vencidos_total_npl, 1) OVER (ORDER BY periodo) AS vencidos_total_npl_lag_1t,
        LAG(vencidos_total_npl, 4) OVER (ORDER BY periodo) AS vencidos_total_npl_lag_12m,

        LAG(vencidos_estagio_3, 1) OVER (ORDER BY periodo) AS vencidos_estagio_3_lag_1t,
        LAG(vencidos_estagio_3, 4) OVER (ORDER BY periodo) AS vencidos_estagio_3_lag_12m,

        LAG(write_off, 1) OVER (ORDER BY periodo) AS write_off_lag_1t,
        LAG(write_off, 4) OVER (ORDER BY periodo) AS write_off_lag_12m,

        LAG(pdd, 1) OVER (ORDER BY periodo) AS pdd_lag_1t,
        LAG(pdd, 4) OVER (ORDER BY periodo) AS pdd_lag_12m,

        LAG(recuperacoes, 1) OVER (ORDER BY periodo) AS recuperacoes_lag_1t,
        LAG(recuperacoes, 4) OVER (ORDER BY periodo) AS recuperacoes_lag_12m,

        LAG(perdas_credito_liquidas_recuperacoes, 1) OVER (ORDER BY periodo) AS perdas_credito_liquidas_lag_1t,
        LAG(perdas_credito_liquidas_recuperacoes, 4) OVER (ORDER BY periodo) AS perdas_credito_liquidas_lag_12m,

        LAG(npl_formation_sobre_carteira, 1) OVER (ORDER BY periodo) AS npl_formation_sobre_carteira_lag_1t,
        LAG(npl_formation_sobre_carteira, 4) OVER (ORDER BY periodo) AS npl_formation_sobre_carteira_lag_12m,

        LAG(npl_formation_stage_3_sobre_carteira, 1) OVER (ORDER BY periodo) AS npl_formation_stage_3_sobre_carteira_lag_1t,
        LAG(npl_formation_stage_3_sobre_carteira, 4) OVER (ORDER BY periodo) AS npl_formation_stage_3_sobre_carteira_lag_12m,

        LAG(write_off_sobre_carteira, 1) OVER (ORDER BY periodo) AS write_off_sobre_carteira_lag_1t,
        LAG(write_off_sobre_carteira, 4) OVER (ORDER BY periodo) AS write_off_sobre_carteira_lag_12m,

        LAG(pdd_sobre_carteira, 1) OVER (ORDER BY periodo) AS pdd_sobre_carteira_lag_1t,
        LAG(pdd_sobre_carteira, 4) OVER (ORDER BY periodo) AS pdd_sobre_carteira_lag_12m,

        LAG(estagio_3_sobre_vencidos, 1) OVER (ORDER BY periodo) AS estagio_3_sobre_vencidos_lag_1t,
        LAG(estagio_3_sobre_vencidos, 4) OVER (ORDER BY periodo) AS estagio_3_sobre_vencidos_lag_12m,

        LAG(pdd_sobre_vencidos, 1) OVER (ORDER BY periodo) AS pdd_sobre_vencidos_lag_1t,
        LAG(pdd_sobre_vencidos, 4) OVER (ORDER BY periodo) AS pdd_sobre_vencidos_lag_12m,

        LAG(recuperacoes_sobre_pdd, 1) OVER (ORDER BY periodo) AS recuperacoes_sobre_pdd_lag_1t,
        LAG(recuperacoes_sobre_pdd, 4) OVER (ORDER BY periodo) AS recuperacoes_sobre_pdd_lag_12m,

        LAG(perdas_liquidas_sobre_carteira, 1) OVER (ORDER BY periodo) AS perdas_liquidas_sobre_carteira_lag_1t,
        LAG(perdas_liquidas_sobre_carteira, 4) OVER (ORDER BY periodo) AS perdas_liquidas_sobre_carteira_lag_12m

    FROM mart_npl_formation_indicators
)

SELECT
    periodo,

    write_off,
    npl_formation,
    npl_formation_stage_3,
    npl_stage_3_sobre_carteira_media,
    vencidos_total_npl,
    vencidos_estagio_1,
    vencidos_estagio_2,
    vencidos_estagio_3,
    perdas_credito_liquidas_recuperacoes,
    pdd,
    recuperacoes,
    carteira_total_cartoes,

    npl_formation_sobre_carteira,
    npl_formation_stage_3_sobre_carteira,
    write_off_sobre_carteira,
    pdd_sobre_carteira,
    estagio_3_sobre_vencidos,
    pdd_sobre_vencidos,
    recuperacoes_sobre_pdd,
    perdas_liquidas_sobre_carteira,

    npl_formation_lag_1t,
    npl_formation_lag_12m,
    npl_formation_stage_3_lag_1t,
    npl_formation_stage_3_lag_12m,
    vencidos_total_npl_lag_1t,
    vencidos_total_npl_lag_12m,
    vencidos_estagio_3_lag_1t,
    vencidos_estagio_3_lag_12m,
    write_off_lag_1t,
    write_off_lag_12m,
    pdd_lag_1t,
    pdd_lag_12m,
    recuperacoes_lag_1t,
    recuperacoes_lag_12m,
    perdas_credito_liquidas_lag_1t,
    perdas_credito_liquidas_lag_12m,

    CASE
        WHEN npl_formation_lag_1t <> 0
        THEN npl_formation / npl_formation_lag_1t - 1
    END AS npl_formation_var_1t,

    CASE
        WHEN npl_formation_lag_12m <> 0
        THEN npl_formation / npl_formation_lag_12m - 1
    END AS npl_formation_var_12m,

    CASE
        WHEN npl_formation_stage_3_lag_1t <> 0
        THEN npl_formation_stage_3 / npl_formation_stage_3_lag_1t - 1
    END AS npl_formation_stage_3_var_1t,

    CASE
        WHEN npl_formation_stage_3_lag_12m <> 0
        THEN npl_formation_stage_3 / npl_formation_stage_3_lag_12m - 1
    END AS npl_formation_stage_3_var_12m,

    CASE
        WHEN vencidos_total_npl_lag_1t <> 0
        THEN vencidos_total_npl / vencidos_total_npl_lag_1t - 1
    END AS vencidos_total_npl_var_1t,

    CASE
        WHEN vencidos_total_npl_lag_12m <> 0
        THEN vencidos_total_npl / vencidos_total_npl_lag_12m - 1
    END AS vencidos_total_npl_var_12m,

    CASE
        WHEN vencidos_estagio_3_lag_1t <> 0
        THEN vencidos_estagio_3 / vencidos_estagio_3_lag_1t - 1
    END AS vencidos_estagio_3_var_1t,

    CASE
        WHEN vencidos_estagio_3_lag_12m <> 0
        THEN vencidos_estagio_3 / vencidos_estagio_3_lag_12m - 1
    END AS vencidos_estagio_3_var_12m,

    CASE
        WHEN write_off_lag_1t <> 0
        THEN ABS(write_off) / ABS(write_off_lag_1t) - 1
    END AS write_off_var_1t,

    CASE
        WHEN write_off_lag_12m <> 0
        THEN ABS(write_off) / ABS(write_off_lag_12m) - 1
    END AS write_off_var_12m,

    CASE
        WHEN pdd_lag_1t <> 0
        THEN ABS(pdd) / ABS(pdd_lag_1t) - 1
    END AS pdd_var_1t,

    CASE
        WHEN pdd_lag_12m <> 0
        THEN ABS(pdd) / ABS(pdd_lag_12m) - 1
    END AS pdd_var_12m,

    CASE
        WHEN recuperacoes_lag_1t <> 0
        THEN recuperacoes / recuperacoes_lag_1t - 1
    END AS recuperacoes_var_1t,

    CASE
        WHEN recuperacoes_lag_12m <> 0
        THEN recuperacoes / recuperacoes_lag_12m - 1
    END AS recuperacoes_var_12m,

    npl_formation_sobre_carteira - npl_formation_sobre_carteira_lag_1t AS npl_formation_sobre_carteira_delta_1t,
    npl_formation_sobre_carteira - npl_formation_sobre_carteira_lag_12m AS npl_formation_sobre_carteira_delta_12m,

    npl_formation_stage_3_sobre_carteira - npl_formation_stage_3_sobre_carteira_lag_1t AS npl_formation_stage_3_sobre_carteira_delta_1t,
    npl_formation_stage_3_sobre_carteira - npl_formation_stage_3_sobre_carteira_lag_12m AS npl_formation_stage_3_sobre_carteira_delta_12m,

    write_off_sobre_carteira - write_off_sobre_carteira_lag_1t AS write_off_sobre_carteira_delta_1t,
    write_off_sobre_carteira - write_off_sobre_carteira_lag_12m AS write_off_sobre_carteira_delta_12m,

    pdd_sobre_carteira - pdd_sobre_carteira_lag_1t AS pdd_sobre_carteira_delta_1t,
    pdd_sobre_carteira - pdd_sobre_carteira_lag_12m AS pdd_sobre_carteira_delta_12m,

    estagio_3_sobre_vencidos - estagio_3_sobre_vencidos_lag_1t AS estagio_3_sobre_vencidos_delta_1t,
    estagio_3_sobre_vencidos - estagio_3_sobre_vencidos_lag_12m AS estagio_3_sobre_vencidos_delta_12m,

    pdd_sobre_vencidos - pdd_sobre_vencidos_lag_1t AS pdd_sobre_vencidos_delta_1t,
    pdd_sobre_vencidos - pdd_sobre_vencidos_lag_12m AS pdd_sobre_vencidos_delta_12m,

    recuperacoes_sobre_pdd - recuperacoes_sobre_pdd_lag_1t AS recuperacoes_sobre_pdd_delta_1t,
    recuperacoes_sobre_pdd - recuperacoes_sobre_pdd_lag_12m AS recuperacoes_sobre_pdd_delta_12m,

    perdas_liquidas_sobre_carteira - perdas_liquidas_sobre_carteira_lag_1t AS perdas_liquidas_sobre_carteira_delta_1t,
    perdas_liquidas_sobre_carteira - perdas_liquidas_sobre_carteira_lag_12m AS perdas_liquidas_sobre_carteira_delta_12m

FROM base_com_lag
ORDER BY periodo