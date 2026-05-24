CREATE TABLE mart_accounts_receivables_indicators AS 
SELECT 
    periodo,

    cartao_renner_a_vencer,
    cartao_renner_vencidos,
    cartao_renner_carteira_total,
    cartao_renner_perdas_estimadas,
    cartao_renner_carteira_liquida,

    meu_cartao_a_vencer,
    meu_cartao_vencidos,
    meu_cartao_carteira_total,
    meu_cartao_perdas_estimadas,
    meu_cartao_carteira_liquida,

    cartoes_terceiros_vpl,
    outras_recebiveis,
    contas_receber_total,

    COALESCE(cartao_renner_vencidos, 0) 
        + COALESCE(meu_cartao_vencidos, 0) AS vencidos_total,

    COALESCE(cartao_renner_a_vencer, 0) 
        + COALESCE(meu_cartao_a_vencer, 0) AS a_vencer_total,

    COALESCE(cartao_renner_carteira_total, 0) 
        + COALESCE(meu_cartao_carteira_total, 0) AS carteira_total_cartoes,

    COALESCE(cartao_renner_perdas_estimadas, 0) 
        + COALESCE(meu_cartao_perdas_estimadas, 0) AS perdas_estimadas_total,

    CASE
        WHEN (
            COALESCE(cartao_renner_carteira_total, 0) 
            + COALESCE(meu_cartao_carteira_total, 0)
        ) <> 0
        THEN (
            COALESCE(cartao_renner_vencidos, 0) 
            + COALESCE(meu_cartao_vencidos, 0)
        ) / (
            COALESCE(cartao_renner_carteira_total, 0) 
            + COALESCE(meu_cartao_carteira_total, 0)
        )
    END AS vencidos_sobre_carteira,

    CASE 
        WHEN (
            COALESCE(cartao_renner_carteira_total, 0) 
            + COALESCE(meu_cartao_carteira_total, 0)
        ) <> 0
        THEN ABS(
            COALESCE(cartao_renner_perdas_estimadas, 0) 
            + COALESCE(meu_cartao_perdas_estimadas, 0)
        ) / (
            COALESCE(cartao_renner_carteira_total, 0) 
            + COALESCE(meu_cartao_carteira_total, 0)
        )
    END AS perdas_estimadas_sobre_carteira,

    CASE
        WHEN (
            COALESCE(cartao_renner_vencidos, 0) 
            + COALESCE(meu_cartao_vencidos, 0)
        ) <> 0 
        THEN ABS(
            COALESCE(cartao_renner_perdas_estimadas, 0) 
            + COALESCE(meu_cartao_perdas_estimadas, 0)
        ) / (
            COALESCE(cartao_renner_vencidos, 0) 
            + COALESCE(meu_cartao_vencidos, 0)
        )
    END AS cobertura_vencidos

FROM mart_accounts_receivables_core
ORDER BY periodo