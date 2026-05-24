CREATE TABLE mart_balance_sheet_indicators_lag AS

WITH base_com_lag AS (

SELECT

periodo, 
ativo_total,
caixa_mais_aplicacoes,
contas_a_receber,
estoques,
passivo_circulante,
patrimonio_liquido,
liquidez_corrente,
recebiveis_sobre_ativo,
estoques_sobre_ativo,
caixa_sobre_ativo,
passivo_sobre_pl,

LAG(caixa_mais_aplicacoes, 1) OVER (ORDER BY periodo) AS caixa_mais_aplicacoes_lag_1t,

LAG(caixa_mais_aplicacoes, 4) OVER (ORDER BY periodo) AS caixa_mais_aplicacoes_lag_12m,

LAG(contas_a_receber, 1) OVER (ORDER BY periodo) AS contas_a_receber_lag_1t,

LAG(contas_a_receber, 4) OVER (ORDER BY periodo) as contas_a_receber_lag_12m,

LAG(estoques,1) OVER (ORDER BY periodo) AS estoques_lag_1t,

LAG(estoques,4) OVER (ORDER BY periodo) as estoques_lag_12m,

LAG (passivo_circulante, 1) OVER (ORDER BY periodo) AS passivo_circulante_lag_1t,

LAG(passivo_circulante, 4) OVER (ORDER BY periodo) AS passivo_circulante_lag_12m,

LAG(liquidez_corrente, 1) OVER (ORDER BY periodo) AS liquidez_corrente_lag_1t,

LAG(liquidez_corrente, 4) OVER (ORDER BY periodo) AS liquidez_corrente_lag_12m,

LAG(recebiveis_sobre_ativo, 1) OVER (ORDER BY periodo) AS recebiveis_sobre_ativo_lag_1t,

LAG(recebiveis_sobre_ativo, 1) OVER (ORDER BY periodo) AS recebiveis_sobre_ativo_lag_12m

FROM mart_balance_sheet_indicators

)


SELECT 

periodo,
ativo_total,
caixa_mais_aplicacoes,
contas_a_receber,
estoques,
passivo_circulante,
patrimonio_liquido,
liquidez_corrente,
recebiveis_sobre_ativo,
estoques_sobre_ativo,
caixa_sobre_ativo,
passivo_sobre_pl,
caixa_mais_aplicacoes_lag_1t,
caixa_mais_aplicacoes_lag_12m,
estoques_lag_1t,
estoques_lag_12m,
passivo_circulante_lag_1t,
passivo_circulante_lag_12m,
liquidez_corrente_lag_1t,
liquidez_corrente_lag_12m,
recebiveis_sobre_ativo_lag_1t,
recebiveis_sobre_ativo_lag_12m,

caixa_mais_aplicacoes/caixa_mais_aplicacoes_lag_1t - 1 AS caixa_mais_aplicacoes_var_1t,

caixa_mais_aplicacoes/caixa_mais_aplicacoes_lag_12m - 1 AS caixa_mais_aplicacoes_var_12m,

contas_a_receber/contas_a_receber_lag_1t - 1 AS contas_a_receber_var_1t,

contas_a_receber/contas_a_receber_lag_12m - 1 AS contas_a_receber_var_12m,

estoques/estoques_lag_1t - 1 AS estoques_var_1t,

estoques/estoques_lag_12m - 1 AS estoques_var_12m,

passivo_circulante/passivo_circulante_lag_1t - 1 AS passivo_circulante_var_1t,

passivo_circulante/passivo_circulante_lag_12m - 1 AS passivo_circulante_var_12m,

recebiveis_sobre_ativo - recebiveis_sobre_ativo_lag_1t AS recebiveis_sobre_ativo_delta_1t,

recebiveis_sobre_ativo - recebiveis_sobre_ativo_lag_12m AS recebiveis_sobre_ativo_delta_12m


FROM base_com_lag
ORDER BY periodo
