CREATE TABLE mart_credit_risk_features AS
SELECT
    br.periodo,

    -- =====================================================
    -- BLOCO 1: BALANÇO / ESTRUTURA PATRIMONIAL
    -- =====================================================
    br.ativo_total,
    br.contas_a_receber_balanco,
    br.contas_receber_total_recebiveis,
    br.caixa_sobre_ativo_pct,
    br.recebiveis_sobre_ativo_pct,
    br.liquidez_corrente,

    br.contas_a_receber_balanco_var_12m_pct,
    br.recebiveis_sobre_ativo_delta_12m_pp,

    -- =====================================================
    -- BLOCO 2: CARTEIRA DE RECEBÍVEIS
    -- =====================================================
    br.carteira_total_cartoes,
    br.vencidos_total,
    br.vencidos_sobre_carteira_pct,
    br.perdas_estimadas_sobre_carteira_pct,
    br.cobertura_vencidos_pct,

    br.vencidos_total_var_12m_pct,
    br.vencidos_sobre_carteira_delta_12m_pp,

    -- =====================================================
    -- BLOCO 3: NPL / FORMAÇÃO DE INADIMPLÊNCIA
    -- =====================================================
    npl.npl_formation,
    npl.npl_formation_stage_3,
    npl.vencidos_total_npl,
    npl.vencidos_estagio_3,
    npl.write_off,
    npl.pdd,
    npl.recuperacoes,
    npl.perdas_credito_liquidas_recuperacoes,

    npl.npl_formation_sobre_carteira,
    npl.npl_formation_stage_3_sobre_carteira,
    npl.write_off_sobre_carteira,
    npl.pdd_sobre_carteira,
    npl.estagio_3_sobre_vencidos,
    npl.pdd_sobre_vencidos,
    npl.recuperacoes_sobre_pdd,
    npl.perdas_liquidas_sobre_carteira,

    -- =====================================================
    -- BLOCO 4: NPL FORMATADO EM PERCENTUAL
    -- =====================================================
    npl.npl_formation_sobre_carteira * 100 AS npl_formation_sobre_carteira_pct,
    npl.npl_formation_stage_3_sobre_carteira * 100 AS npl_formation_stage_3_sobre_carteira_pct,
    npl.write_off_sobre_carteira * 100 AS write_off_sobre_carteira_pct,
    npl.pdd_sobre_carteira * 100 AS pdd_sobre_carteira_pct,
    npl.estagio_3_sobre_vencidos * 100 AS estagio_3_sobre_vencidos_pct,
    npl.pdd_sobre_vencidos * 100 AS pdd_sobre_vencidos_pct,
    npl.recuperacoes_sobre_pdd * 100 AS recuperacoes_sobre_pdd_pct,
    npl.perdas_liquidas_sobre_carteira * 100 AS perdas_liquidas_sobre_carteira_pct,

    -- =====================================================
    -- BLOCO 5: DELTAS 12M DE NPL EM PONTOS PERCENTUAIS
    -- =====================================================
    npl.npl_formation_sobre_carteira_delta_12m * 100 AS npl_formation_sobre_carteira_delta_12m_pp,
    npl.npl_formation_stage_3_sobre_carteira_delta_12m * 100 AS npl_formation_stage_3_sobre_carteira_delta_12m_pp,
    npl.write_off_sobre_carteira_delta_12m * 100 AS write_off_sobre_carteira_delta_12m_pp,
    npl.pdd_sobre_carteira_delta_12m * 100 AS pdd_sobre_carteira_delta_12m_pp,
    npl.estagio_3_sobre_vencidos_delta_12m * 100 AS estagio_3_sobre_vencidos_delta_12m_pp,
    npl.pdd_sobre_vencidos_delta_12m * 100 AS pdd_sobre_vencidos_delta_12m_pp,
    npl.recuperacoes_sobre_pdd_delta_12m * 100 AS recuperacoes_sobre_pdd_delta_12m_pp,
    npl.perdas_liquidas_sobre_carteira_delta_12m * 100 AS perdas_liquidas_sobre_carteira_delta_12m_pp,

    -- =====================================================
    -- BLOCO 6: FLAGS ANALÍTICAS SIMPLES
    -- =====================================================

    CASE
        WHEN br.recebiveis_sobre_ativo_pct >= 30 THEN 1
        ELSE 0
    END AS flag_recebiveis_relevantes_no_ativo,

    CASE
        WHEN br.caixa_sobre_ativo_pct < 15 THEN 1
        ELSE 0
    END AS flag_baixo_caixa_sobre_ativo,

    CASE
        WHEN br.vencidos_sobre_carteira_pct >= 25 THEN 1
        ELSE 0
    END AS flag_vencidos_elevados,

    CASE
        WHEN npl.estagio_3_sobre_vencidos * 100 >= 80 THEN 1
        ELSE 0
    END AS flag_alta_concentracao_stage_3,

    CASE
        WHEN br.vencidos_sobre_carteira_delta_12m_pp >= 5 THEN 1
        ELSE 0
    END AS flag_piora_vencidos_12m,

    CASE
        WHEN npl.estagio_3_sobre_vencidos_delta_12m * 100 >= 10 THEN 1
        ELSE 0
    END AS flag_piora_stage_3_12m,

    -- =====================================================
    -- BLOCO 7: QUANTIDADE TOTAL DE ALERTAS
    -- =====================================================

    (
        CASE
            WHEN br.recebiveis_sobre_ativo_pct >= 30 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN br.caixa_sobre_ativo_pct < 15 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN br.vencidos_sobre_carteira_pct >= 25 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN npl.estagio_3_sobre_vencidos * 100 >= 80 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN br.vencidos_sobre_carteira_delta_12m_pp >= 5 THEN 1
            ELSE 0
        END
        +
        CASE
            WHEN npl.estagio_3_sobre_vencidos_delta_12m * 100 >= 10 THEN 1
            ELSE 0
        END
    ) AS qtd_alertas_credito,

    -- =====================================================
    -- BLOCO 8: CLASSIFICAÇÃO SIMPLES DE RISCO
    -- =====================================================

    CASE
        WHEN (
            CASE WHEN br.recebiveis_sobre_ativo_pct >= 30 THEN 1 ELSE 0 END
            +
            CASE WHEN br.caixa_sobre_ativo_pct < 15 THEN 1 ELSE 0 END
            +
            CASE WHEN br.vencidos_sobre_carteira_pct >= 25 THEN 1 ELSE 0 END
            +
            CASE WHEN npl.estagio_3_sobre_vencidos * 100 >= 80 THEN 1 ELSE 0 END
            +
            CASE WHEN br.vencidos_sobre_carteira_delta_12m_pp >= 5 THEN 1 ELSE 0 END
            +
            CASE WHEN npl.estagio_3_sobre_vencidos_delta_12m * 100 >= 10 THEN 1 ELSE 0 END
        ) <= 1 THEN 'Baixo'

        WHEN (
            CASE WHEN br.recebiveis_sobre_ativo_pct >= 30 THEN 1 ELSE 0 END
            +
            CASE WHEN br.caixa_sobre_ativo_pct < 15 THEN 1 ELSE 0 END
            +
            CASE WHEN br.vencidos_sobre_carteira_pct >= 25 THEN 1 ELSE 0 END
            +
            CASE WHEN npl.estagio_3_sobre_vencidos * 100 >= 80 THEN 1 ELSE 0 END
            +
            CASE WHEN br.vencidos_sobre_carteira_delta_12m_pp >= 5 THEN 1 ELSE 0 END
            +
            CASE WHEN npl.estagio_3_sobre_vencidos_delta_12m * 100 >= 10 THEN 1 ELSE 0 END
        ) BETWEEN 2 AND 3 THEN 'Moderado'

        ELSE 'Elevado'
    END AS classificacao_risco_credito

FROM mart_credit_risk_balance_receivables AS br
LEFT JOIN mart_npl_formation_indicators_lag AS npl
    ON br.periodo = npl.periodo

ORDER BY br.periodo;