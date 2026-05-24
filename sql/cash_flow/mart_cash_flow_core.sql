CREATE TABLE mart_cash_flow_core AS
SELECT
    periodo,

    MAX(CASE WHEN conta_pt = 'Lucro líquido do período' THEN valor END) AS lucro_liquido_periodo,

    MAX(CASE WHEN conta_pt = 'Depreciações e amortizações' THEN valor END) AS depreciacao_amortizacao,

    MAX(CASE WHEN conta_pt = 'Juros e custos de estruturação sobre empréstimos, financiamentos e arrendamento' THEN valor END) AS juros_emprestimos_financiamentos_arrendamento,

    MAX(CASE WHEN conta_pt = 'Imposto de renda e contribuição social' THEN valor END) AS imposto_renda_contribuicao_social,

    MAX(CASE WHEN conta_pt = 'Perdas estimadas em ativos, líquidas' THEN valor END) AS perdas_estimadas_ativos_liquidas,

    MAX(CASE WHEN conta_pt = 'Lucro líquido ajustado' THEN valor END) AS lucro_liquido_ajustado,

    MAX(CASE WHEN conta_pt = 'Contas a receber de clientes' THEN valor END) AS variacao_contas_receber_clientes,

    MAX(CASE WHEN conta_pt = 'Estoques' THEN valor END) AS variacao_estoques,

    MAX(CASE WHEN conta_pt = 'Fornecedores' THEN valor END) AS variacao_fornecedores,

    MAX(CASE WHEN conta_pt = 'Caixa líquido gerado pelas atividades operacionais, antes das aplic. financeiras' THEN valor END) AS caixa_operacional_antes_aplicacoes_financeiras,

    MAX(CASE WHEN conta_pt = 'Aplicações financeiras' THEN valor END) AS aplicacoes_financeiras,

    MAX(CASE WHEN conta_pt = 'Caixa líquido gerado pelas atividades operacionais' THEN valor END) AS caixa_operacional,

    MAX(CASE WHEN conta_pt = 'Aquisições de imobilizado e intangível' THEN valor END) AS capex,

    MAX(CASE WHEN conta_pt = 'Caixa líquido consumido pelas atividades de investimentos' THEN valor END) AS caixa_investimentos,

    MAX(CASE WHEN conta_pt = 'Recompra de ações' THEN valor END) AS recompra_acoes,

    MAX(CASE WHEN conta_pt = 'Captações e amortizações de empréstimos e debêntures' THEN valor END) AS captacoes_amortizacoes_emprestimos_debentures,

    MAX(CASE WHEN conta_pt = 'Contraprestação de arrendamentos a pagar' THEN valor END) AS arrendamentos_pagos,

    MAX(CASE WHEN conta_pt = 'Juros sobre capital próprio e dividendos pagos' THEN valor END) AS dividendos_jcp_pagos,

    MAX(CASE WHEN conta_pt = 'Fluxos de caixa das atividades de financiamentos' THEN valor END) AS caixa_financiamentos,

    MAX(CASE WHEN conta_pt = '(Redução) no caixa e equivalentes de caixa' THEN valor END) AS variacao_caixa_equivalentes,

    MAX(CASE WHEN conta_pt = 'Caixa e equivalentes de caixa no início do período' THEN valor END) AS caixa_inicio_periodo,

    MAX(CASE WHEN conta_pt = 'Caixa e equivalentes de caixa no fim do período' THEN valor END) AS caixa_fim_periodo

FROM stg_cash_flow_long
GROUP BY periodo
ORDER BY periodo;
