CREATE TABLE mart_income_statement_core AS
SELECT
    periodo,

    MAX(CASE WHEN conta_pt = 'Receita Operacional Bruta' THEN valor END) AS receita_operacional_bruta,

    MAX(CASE WHEN conta_pt = 'Receita Operacional Líquida' THEN valor END) AS receita_operacional_liquida,

    MAX(CASE WHEN conta_pt = 'Receita Líquida de Varejo' THEN valor END) AS receita_liquida_varejo,

    MAX(CASE WHEN conta_pt = 'Receita Líquida de Serviços Financeiros' THEN valor END) AS receita_liquida_servicos_financeiros,

    MAX(CASE WHEN conta_pt = 'Custos das Vendas e Serviços' THEN valor END) AS custos_vendas_servicos,

    MAX(CASE WHEN conta_pt = 'Lucro Bruto' THEN valor END) AS lucro_bruto,

    MAX(CASE WHEN conta_pt = 'Lucro bruto de Varejo' THEN valor END) AS lucro_bruto_varejo,

    MAX(CASE WHEN conta_pt = 'Lucro bruto de Serviços Financeiros' THEN valor END) AS lucro_bruto_servicos_financeiros,

    MAX(CASE WHEN conta_pt = 'Despesas Operacionais' THEN valor END) AS despesas_operacionais,

    MAX(CASE WHEN conta_pt = 'Perdas em crédito' THEN valor END) AS perdas_em_credito,

    MAX(CASE WHEN conta_pt = 'Lucro operacional antes do resultado financeiro' THEN valor END) AS lucro_operacional_antes_resultado_financeiro,

    MAX(CASE WHEN conta_pt = 'Resultado Financeiro' THEN valor END) AS resultado_financeiro,

    MAX(CASE WHEN conta_pt = 'Lucro antes do Imposto de Renda, e da Contribuição Social' THEN valor END) AS lucro_antes_ir_cs,

    MAX(CASE WHEN conta_pt = 'Imposto de Renda e Contribuição Social' THEN valor END) AS imposto_renda_contribuicao_social,

    MAX(CASE WHEN conta_pt = 'Lucro Líquido do Período' THEN valor END) AS lucro_liquido

FROM stg_income_statement_long
GROUP BY periodo
ORDER BY periodo;