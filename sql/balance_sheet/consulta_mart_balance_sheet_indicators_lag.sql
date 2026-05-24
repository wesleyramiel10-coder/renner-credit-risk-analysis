select 

periodo,
ativo_total,
caixa_mais_aplicacoes,
contas_a_receber,
estoques,
passivo_circulante,
patrimonio_liquido,

ROUND(liquidez_corrente, 2) AS liquidez_corrente,
ROUND(recebiveis_sobre_ativo * 100, 2) AS recebiveis_sobre_ativo_pct,
ROUND(estoques_sobre_ativo *100, 2) as estoques_sobre_ativo_pct,
ROUND(caixa_sobre_ativo * 100, 2) AS caixa_sobre_ativo_pct,
ROUND(passivo_sobre_pl, 2 ) AS passivo_sobre_pl,
ROUND(contas_a_receber_var_1t * 100,2) as contas_a_receber_var_1t_pct,
ROUND(contas_a_receber_var_12m * 100,2) as contas_a_receber_var_12m_pct,
ROUND(caixa_mais_aplicacoes_var_1t * 100, 2 ) AS caixa_var_1t_pct,
ROUND(caixa_mais_aplicacoes_var_12m * 100, 2) AS caixa_var_12m_pct,
ROUND(recebiveis_sobre_ativo_delta_12m * 100, 2) AS recebiveis_sobre_ativo_delta_12m_pp

FROM  mart_balance_sheet_indicators_lag
WHERE periodo >= '2021-01-01'
ORDER BY periodo