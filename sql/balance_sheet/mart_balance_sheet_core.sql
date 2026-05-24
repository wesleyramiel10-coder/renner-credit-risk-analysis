CREATE TABLE mart_balance_sheet_core AS

SELECT 

periodo,

MAX(CASE WHEN conta_pt = "Ativo Total" THEN valor END) AS ativo_total,

MAX(CASE WHEN conta_pt = "Circulante" AND ordem_conta = 2 THEN valor END) AS ativo_circulante,

MAX(CASE WHEN conta_pt = "Caixa e equivalentes de caixa" THEN valor END) AS caixa,

MAX(CASE WHEN conta_pt = "Aplicações financeiras" THEN valor END) AS aplicacoes_financeiras,

MAX(CASE WHEN conta_pt = "Contas a receber" THEN valor END) AS contas_a_receber,

MAX(CASE WHEN conta_pt = "Estoques" THEN valor END) AS estoques,

MAX(CASE WHEN conta_pt = "Passivo Total" THEN valor END) AS passivo_total,

MAX(CASE WHEN conta_pt = "Circulante" and ordem_conta = 27 THEN valor END) AS passivo_circulante,

MAX(CASE WHEN conta_pt = "Patrimônio Líquido" THEN valor END) AS patrimonio_liquido,

MAX(CASE WHEN conta_pt = "Empréstimos, financiamentos e debêntures" AND ordem_conta = 28 THEN valor END) AS divida_cp,

MAX(CASE WHEN conta_pt = "Empréstimos, financiamentos e debêntures" AND ordem_conta = 42 THEN valor END) AS divida_lp,

MAX(CASE WHEN conta_pt = "Financiamentos - Operações Serviços Financeiros" AND ordem_conta = 29 THEN valor END) AS funding_servicos_financeiros_cp,

MAX(CASE WHEN conta_pt = "Financimentos - Operações Serviços Financeiros" AND ordem_conta = 43 THEN valor END) as funding_servicos_financeiros_lp,

MAX(CASE WHEN conta_pt = "Fornecedores" AND ordem_conta = 32 THEN valor END) AS fornecedores_cp

FROM stg_balance_sheet_clean
GROUP BY periodo
ORDER BY periodo;