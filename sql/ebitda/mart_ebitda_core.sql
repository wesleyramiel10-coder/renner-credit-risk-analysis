CREATE TABLE mart_ebitda_core AS
SELECT
    periodo,

    -- Reconciliação básica do EBITDA
    MAX(CASE WHEN conta_pt = 'Lucro Líquido do Período' THEN valor END) AS lucro_liquido,
    MAX(CASE WHEN conta_pt = 'Imposto de Renda e Contribuição Social' THEN valor END) AS imposto_renda_contribuicao_social,
    MAX(CASE WHEN conta_pt = 'Resultado Financeiro, Líquido' THEN valor END) AS resultado_financeiro_liquido,
    MAX(CASE WHEN conta_pt = 'Depreciações e amortizações' THEN valor END) AS depreciacoes_amortizacoes,
    MAX(CASE WHEN conta_pt = 'EBITDA Total' THEN valor END) AS ebitda_total,

    -- Ajustes do EBITDA
    MAX(CASE WHEN conta_pt = 'Plano de Opção de Compra de Ações' THEN valor END) AS plano_opcao_acoes,
    MAX(CASE WHEN conta_pt = 'Participações Estatutárias' THEN valor END) AS participacoes_estatutarias,
    MAX(CASE WHEN conta_pt = 'Resultado da Venda ou Baixa de Ativos' THEN valor END) AS resultado_venda_baixa_ativos,

    -- EBITDA ajustado pós-IFRS 16
    MAX(CASE WHEN conta_pt = 'EBITDA Total Ajustado' AND ordem_conta = 9 THEN valor END) AS ebitda_total_ajustado,
    MAX(CASE WHEN conta_pt = 'EBITDA Ajustado da Operação de Varejo' THEN valor END) AS ebitda_ajustado_varejo,
    MAX(CASE WHEN conta_pt = 'EBITDA de Serviços Financeiros' THEN valor END) AS ebitda_servicos_financeiros,

    MAX(CASE WHEN conta_pt = '% da Receita Líquida da Operação de Varejo' AND ordem_conta = 10 THEN valor END) AS margem_ebitda_total_ajustado,
    MAX(CASE WHEN conta_pt = '% da Receita Líquida da Operação de Varejo' AND ordem_conta = 12 THEN valor END) AS margem_ebitda_ajustado_varejo,
    MAX(CASE WHEN conta_pt = '% do EBITDA Total Ajustado' THEN valor END) AS servicos_financeiros_sobre_ebitda_ajustado,

    -- EBITDA pré-IFRS 16
    MAX(CASE WHEN conta_pt = 'Depreciação de Arrendamento (IFRS 16)' THEN valor END) AS depreciacao_arrendamento_ifrs16,
    MAX(CASE WHEN conta_pt = 'Despesa Financeira de Arrendamento (IFRS 16)' THEN valor END) AS despesa_financeira_arrendamento_ifrs16,
    MAX(CASE WHEN conta_pt = 'Outras despesas' THEN valor END) AS outras_despesas_ifrs16,

    MAX(CASE WHEN conta_pt = 'EBITDA Total Ajustado (pré IFRS 16)' THEN valor END) AS ebitda_total_ajustado_pre_ifrs16,
    MAX(CASE WHEN conta_pt = 'EBITDA Ajustado da Operação de Varejo (pré IFRS 16)' THEN valor END) AS ebitda_ajustado_varejo_pre_ifrs16,
    MAX(CASE WHEN conta_pt = 'EBITDA de Serviços Financeiros (pré IFRS 16)' THEN valor END) AS ebitda_servicos_financeiros_pre_ifrs16,

    MAX(CASE WHEN conta_pt = '% da Receita Líquida da Operação de Varejo' AND ordem_conta = 20 THEN valor END) AS margem_ebitda_total_ajustado_pre_ifrs16,
    MAX(CASE WHEN conta_pt = '% da Receita Líquida da Operação de Varejo' AND ordem_conta = 22 THEN valor END) AS margem_ebitda_ajustado_varejo_pre_ifrs16,
    MAX(CASE WHEN conta_pt = '% do EBITDA Total Ajustado (pré IFRS16)' THEN valor END) AS servicos_financeiros_sobre_ebitda_ajustado_pre_ifrs16

FROM stg_ebitda_long
GROUP BY periodo
ORDER BY periodo;