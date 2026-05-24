SELECT
    periodo,

    contas_receber_total,
    carteira_total_cartoes,
    vencidos_total,
    perdas_estimadas_total,

    ROUND(vencidos_sobre_carteira * 100, 2) AS vencidos_sobre_carteira_pct,
    ROUND(perdas_estimadas_sobre_carteira * 100, 2) AS perdas_estimadas_sobre_carteira_pct,
    ROUND(cobertura_vencidos * 100, 2) AS cobertura_vencidos_pct,

    ROUND(carteira_total_cartoes_var_12m * 100, 2) AS carteira_total_cartoes_var_12m_pct,
    ROUND(vencidos_total_var_12m * 100, 2) AS vencidos_total_var_12m_pct,
    ROUND(perdas_estimadas_total_var_12m * 100, 2) AS perdas_estimadas_total_var_12m_pct,

    ROUND(vencidos_sobre_carteira_delta_12m * 100, 2) AS vencidos_sobre_carteira_delta_12m_pp,
    ROUND(perdas_estimadas_sobre_carteira_delta_12m * 100, 2) AS perdas_estimadas_sobre_carteira_delta_12m_pp,
    ROUND(cobertura_vencidos_delta_12m * 100, 2) AS cobertura_vencidos_delta_12m_pp

FROM mart_accounts_receivables_indicators_lag
WHERE periodo >= '2021-01-01'
ORDER BY periodo;