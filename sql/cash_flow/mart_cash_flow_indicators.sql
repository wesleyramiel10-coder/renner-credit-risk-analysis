CREATE TABLE mart_cash_flow_indicators AS
SELECT
    periodo,

    lucro_liquido_periodo,
    depreciacao_amortizacao,
    perdas_estimadas_ativos_liquidas,
    lucro_liquido_ajustado,

    variacao_contas_receber_clientes,
    variacao_estoques,
    variacao_fornecedores,

    caixa_operacional_antes_aplicacoes_financeiras,
    aplicacoes_financeiras,
    caixa_operacional,

    capex,
    caixa_investimentos,

    recompra_acoes,
    captacoes_amortizacoes_emprestimos_debentures,
    arrendamentos_pagos,
    dividendos_jcp_pagos,
    caixa_financiamentos,

    variacao_caixa_equivalentes,
    caixa_inicio_periodo,
    caixa_fim_periodo,

    -- Fluxo de caixa livre simples
    caixa_operacional + capex AS fluxo_caixa_livre,

    -- Conversão de lucro em caixa operacional
    CASE
        WHEN lucro_liquido_periodo <> 0
        THEN caixa_operacional / lucro_liquido_periodo
    END AS caixa_operacional_sobre_lucro,

    -- CAPEX sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN ABS(capex) / caixa_operacional
    END AS capex_sobre_caixa_operacional,

    -- Fluxo de caixa livre sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN (caixa_operacional + capex) / caixa_operacional
    END AS fluxo_caixa_livre_sobre_caixa_operacional,

    -- Dividendos/JCP sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN ABS(dividendos_jcp_pagos) / caixa_operacional
    END AS dividendos_sobre_caixa_operacional,

    -- Recompra sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN ABS(recompra_acoes) / caixa_operacional
    END AS recompra_sobre_caixa_operacional,

    -- Financiamentos sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN caixa_financiamentos / caixa_operacional
    END AS caixa_financiamentos_sobre_caixa_operacional,

    -- Variação de contas a receber sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN variacao_contas_receber_clientes / caixa_operacional
    END AS variacao_contas_receber_sobre_caixa_operacional,

    -- Estoques sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN variacao_estoques / caixa_operacional
    END AS variacao_estoques_sobre_caixa_operacional,

    -- Fornecedores sobre caixa operacional
    CASE
        WHEN caixa_operacional <> 0
        THEN variacao_fornecedores / caixa_operacional
    END AS variacao_fornecedores_sobre_caixa_operacional

FROM mart_cash_flow_core
ORDER BY periodo;
