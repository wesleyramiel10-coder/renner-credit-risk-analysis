CREATE TABLE mart_master_renner_credit_analysis AS
SELECT
    r.periodo,

    CAST(strftime('%Y', r.periodo) AS INTEGER) AS ano,

    CASE
        WHEN strftime('%m', r.periodo) = '03' THEN '1T'
        WHEN strftime('%m', r.periodo) = '06' THEN '2T'
        WHEN strftime('%m', r.periodo) = '09' THEN '3T'
        WHEN strftime('%m', r.periodo) = '12' THEN '4T'
    END AS trimestre,

    -- =========================
    -- 1. RATINGS E SCORES
    -- =========================
    r.score_carteira_credito,
    r.rating_carteira_credito,

    r.score_financeiro_pj,
    r.classificacao_financeira_pj,

    r.score_total_consolidado,
    r.rating_consolidado,
    r.origem_principal_risco,

    m.score_pressao_macro,
    m.classificacao_macro,
    cm.leitura_carteira_vs_macro,

    -- =========================
    -- 2. BALANÇO / CRÉDITO PJ
    -- =========================
    bs.ativo_total,
    bs.caixa_mais_aplicacoes,
    bs.contas_a_receber AS contas_a_receber_balanco,
    bs.estoques,
    bs.passivo_circulante,
    bs.patrimonio_liquido,

    bs.liquidez_corrente,
    bs.caixa_sobre_ativo,
    bs.recebiveis_sobre_ativo,
    bs.estoques_sobre_ativo,
    bs.passivo_sobre_pl,

    bs.caixa_mais_aplicacoes_var_12m,
    bs.contas_a_receber_var_12m,
    bs.recebiveis_sobre_ativo_delta_12m,

    -- =========================
    -- 3. DRE / MARGENS
    -- =========================
    dre.receita_operacional_liquida,
    dre.receita_operacional_liquida_var_12m,

    dre.lucro_bruto,
    dre.lucro_operacional_antes_resultado_financeiro,
    dre.lucro_liquido,
    dre.lucro_liquido_var_12m,

    dre.margem_bruta,
    dre.margem_operacional,
    dre.margem_liquida,

    dre.perdas_em_credito,
    dre.perdas_em_credito_var_12m,
    dre.perdas_credito_sobre_receita,
    dre.perdas_credito_sobre_receita_delta_12m,

    -- =========================
    -- 4. EBITDA
    -- =========================
    e.ebitda_total_ajustado,
    e.ebitda_total_ajustado_var_12m,
    e.margem_ebitda_total_ajustado,
    e.margem_ebitda_total_ajustado_delta_12m,

    e.ebitda_ajustado_varejo,
    e.ebitda_ajustado_varejo_var_12m,
    e.margem_ebitda_ajustado_varejo,

    e.ebitda_servicos_financeiros,
    e.servicos_financeiros_sobre_ebitda_ajustado,

    -- =========================
    -- 5. FLUXO DE CAIXA
    -- =========================
    cf.caixa_operacional,
    cf.caixa_operacional_var_12m,

    cf.capex,
    cf.fluxo_caixa_livre,
    cf.fluxo_caixa_livre_var_12m,

    cf.caixa_fim_periodo,
    cf.caixa_fim_periodo_var_12m,

    cf.caixa_operacional_sobre_lucro,
    cf.capex_sobre_caixa_operacional,
    cf.fluxo_caixa_livre_sobre_caixa_operacional,

    -- =========================
    -- 6. CARTEIRA / RECEBÍVEIS
    -- =========================
    ar.contas_receber_total,
    ar.carteira_total_cartoes,
    ar.vencidos_total,
    ar.a_vencer_total,
    ar.perdas_estimadas_total,

    ar.vencidos_sobre_carteira,
    ar.perdas_estimadas_sobre_carteira,
    ar.cobertura_vencidos,

    ar.contas_receber_total_var_12m,
    ar.carteira_total_cartoes_var_12m,
    ar.vencidos_total_var_12m,
    ar.perdas_estimadas_total_var_12m,

    ar.vencidos_sobre_carteira_delta_12m,
    ar.perdas_estimadas_sobre_carteira_delta_12m,
    ar.cobertura_vencidos_delta_12m,

    -- =========================
    -- 7. NPL / SEVERIDADE
    -- =========================
    npl.write_off,
    npl.npl_formation,
    npl.npl_formation_stage_3,
    npl.npl_stage_3_sobre_carteira_media,

    npl.vencidos_total_npl,
    npl.vencidos_estagio_1,
    npl.vencidos_estagio_2,
    npl.vencidos_estagio_3,

    npl.perdas_credito_liquidas_recuperacoes,
    npl.pdd,
    npl.recuperacoes,

    npl.npl_formation_sobre_carteira,
    npl.npl_formation_stage_3_sobre_carteira,
    npl.write_off_sobre_carteira,
    npl.pdd_sobre_carteira,

    npl.estagio_3_sobre_vencidos,
    npl.pdd_sobre_vencidos,
    npl.recuperacoes_sobre_pdd,
    npl.perdas_liquidas_sobre_carteira,

    npl.npl_formation_var_12m,
    npl.npl_formation_stage_3_var_12m,
    npl.vencidos_total_npl_var_12m,
    npl.vencidos_estagio_3_var_12m,
    npl.write_off_var_12m,
    npl.pdd_var_12m,
    npl.recuperacoes_var_12m,

    npl.npl_formation_sobre_carteira_delta_12m,
    npl.npl_formation_stage_3_sobre_carteira_delta_12m,
    npl.write_off_sobre_carteira_delta_12m,
    npl.pdd_sobre_carteira_delta_12m,
    npl.estagio_3_sobre_vencidos_delta_12m,
    npl.pdd_sobre_vencidos_delta_12m,
    npl.recuperacoes_sobre_pdd_delta_12m,
    npl.perdas_liquidas_sobre_carteira_delta_12m,

    -- =========================
    -- 8. BAD RATIO
    -- =========================
    br.bad_ratio_vencidos,
    br.bad_ratio_stage_3,
    br.bad_ratio_perdas_liquidas,

    -- =========================
    -- 9. MACRO
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

    -- =========================
    -- 10. FLAGS INTERPRETATIVAS
    -- =========================
    CASE
        WHEN r.score_carteira_credito >= 12 THEN 1
        ELSE 0
    END AS flag_carteira_critica,

    CASE
        WHEN m.score_pressao_macro >= 4 THEN 1
        ELSE 0
    END AS flag_macro_pressao,

    CASE
        WHEN r.score_financeiro_pj <= 3 THEN 1
        ELSE 0
    END AS flag_pj_forte,

    CASE
        WHEN br.bad_ratio_stage_3 >= 0.20 THEN 1
        ELSE 0
    END AS flag_stage_3_alto,

    CASE
        WHEN ar.vencidos_sobre_carteira_delta_12m > 0 THEN 1
        ELSE 0
    END AS flag_vencidos_piorando_12m,

    CASE
        WHEN m.inadimplencia_pf_total_delta_12m > 0 THEN 1
        ELSE 0
    END AS flag_macro_inadimplencia_piorando_12m,

    CASE
        WHEN cf.caixa_fim_periodo_var_12m < -0.25 THEN 1
        ELSE 0
    END AS flag_queda_relevante_caixa,

    -- =========================
    -- 11. LEITURA FINAL DO PERÍODO
    -- =========================
    CASE
        WHEN r.score_carteira_credito >= 12
             AND m.score_pressao_macro >= 4
             AND r.score_financeiro_pj <= 6
        THEN 'Carteira crítica, PJ ainda resiliente, macro adversa'

        WHEN r.score_carteira_credito >= 12
             AND m.score_pressao_macro < 4
        THEN 'Carteira crítica com pouca explicação macro'

        WHEN r.score_carteira_credito < 8
             AND r.score_financeiro_pj <= 3
             AND m.score_pressao_macro <= 1
        THEN 'Empresa forte, carteira controlada e macro favorável'

        WHEN r.score_financeiro_pj >= 7
             AND r.score_carteira_credito >= 8
        THEN 'Pressão combinada entre empresa e carteira'

        ELSE 'Cenário intermediário ou em transição'
    END AS leitura_executiva_periodo

FROM mart_company_credit_rating_v2 r

LEFT JOIN mart_credit_macro_features cm
    ON r.periodo = cm.periodo

LEFT JOIN mart_macro_features m
    ON r.periodo = m.periodo

LEFT JOIN mart_balance_sheet_indicators_lag bs
    ON r.periodo = bs.periodo

LEFT JOIN mart_income_statement_indicators_lag dre
    ON r.periodo = dre.periodo

LEFT JOIN mart_cash_flow_indicators_lag cf
    ON r.periodo = cf.periodo

LEFT JOIN mart_ebitda_indicators_lag e
    ON r.periodo = e.periodo

LEFT JOIN mart_accounts_receivables_indicators_lag ar
    ON r.periodo = ar.periodo

LEFT JOIN mart_npl_formation_indicators_lag npl
    ON r.periodo = npl.periodo

LEFT JOIN mart_bad_ratio br
    ON r.periodo = br.periodo

ORDER BY r.periodo;