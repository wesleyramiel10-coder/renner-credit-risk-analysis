CREATE TABLE mart_accounts_receivables_indicators_lag AS 

WITH base_com_lag AS (

SELECT

periodo,
contas_receber_total,
carteira_total_cartoes,
vencidos_total,
a_vencer_total,
perdas_estimadas_total,
vencidos_sobre_carteira,
perdas_estimadas_sobre_carteira,
cobertura_vencidos,

LAG(contas_receber_total, 1)   OVER (ORDER BY periodo) AS contas_receber_total_lag_1t,
LAG(contas_receber_total, 4)   OVER (ORDER BY periodo) AS contas_receber_total_lag_12m,
LAG(carteira_total_cartoes, 1) OVER (ORDER BY periodo) AS carteira_total_cartoes_lag_1t,
LAG(carteira_total_cartoes, 4) OVER (ORDER BY periodo) AS carteira_total_cartoes_lag_12m,
LAG(vencidos_total, 1)         OVER (ORDER BY periodo) AS vencidos_total_lag_1t,
LAG(vencidos_total, 4)         OVER (ORDER BY periodo) AS vencidos_total_lag_12m,
LAG(a_vencer_total, 1)         OVER (ORDER BY periodo) AS a_vencer_total_lag_1t,
LAG(a_vencer_total, 4)         OVER (ORDER BY periodo) AS a_vencer_total_lag_12m,
LAG(perdas_estimadas_total, 1) OVER (ORDER BY periodo) AS perdas_estimadas_total_lag_1t,
LAG(perdas_estimadas_total, 4) OVER (ORDER BY periodo) AS perdas_estimadas_total_lag_12m,
LAG(vencidos_sobre_carteira,1) OVER (ORDER BY periodo) AS vencidos_sobre_carteira_lag_1t,
LAG(vencidos_sobre_carteira,4) OVER (ORDER BY periodo) AS vencidos_sobre_carteira_lag_12m,
LAG(perdas_estimadas_sobre_carteira, 1) OVER (ORDER BY periodo) AS perdas_estimadas_sobre_carteira_lag_1t,
LAG(perdas_estimadas_sobre_carteira, 4) OVER (ORDER BY periodo) AS perdas_estimadas_sobre_carteira_lag_12m,
LAG(cobertura_vencidos, 1)     OVER (ORDER BY periodo) AS cobertura_vencidos_lag_1t,
LAG(cobertura_vencidos, 4)     OVER (ORDER BY periodo) AS cobertura_vencidos_lag_12m

FROM mart_accounts_receivables_indicators

)


SELECT

periodo,
contas_receber_total,
carteira_total_cartoes,
vencidos_total,
a_vencer_total,
perdas_estimadas_total,
vencidos_sobre_carteira,
perdas_estimadas_sobre_carteira,
cobertura_vencidos,
contas_receber_total_lag_1t,
contas_receber_total_lag_12m,
carteira_total_cartoes_lag_1t,
carteira_total_cartoes_lag_12m,
vencidos_total_lag_1t,
vencidos_total_lag_12m,
a_vencer_total_lag_1t,
a_vencer_total_lag_12m,
perdas_estimadas_total_lag_1t,
perdas_estimadas_total_lag_12m,
vencidos_sobre_carteira_lag_1t,
vencidos_sobre_carteira_lag_12m,
cobertura_vencidos_lag_1t,
cobertura_vencidos_lag_12m,

CASE 
	WHEN contas_receber_total_lag_1t <> 0
	THEN contas_receber_total / contas_receber_total_lag_1t -1
END AS contas_receber_total_var_1t,

CASE 
	WHEN contas_receber_total_lag_12m <> 0
	THEN contas_receber_total / contas_receber_total_lag_12m - 1
END AS contas_receber_total_var_12m,

CASE
	WHEN carteira_total_cartoes_lag_1t <> 0
	THEN carteira_total_cartoes / carteira_total_cartoes_lag_1t - 1
END AS carteira_total_cartoes_var_1t,

CASE
	WHEN carteira_total_cartoes_lag_12m <> 0
	THEN carteira_total_cartoes / carteira_total_cartoes_lag_12m - 1
END AS carteira_total_cartoes_var_12m,

CASE
	WHEN vencidos_total_lag_1t <> 0
	THEN vencidos_total / vencidos_total_lag_1t - 1
END AS vencidos_total_var_1t,

CASE 
	WHEN vencidos_total_lag_12m <> 0
	THEN vencidos_total / vencidos_total_lag_12m -1
END AS vencidos_total_var_12m,

CASE
	WHEN a_vencer_total_lag_1t <> 0
	THEN a_vencer_total / a_vencer_total_lag_1t - 1
END a_vencer_total_var_1t,

CASE 
	WHEN a_vencer_total_lag_12m <> 0
	THEN a_vencer_total / a_vencer_total_lag_12m - 1 
END a_vencer_total_var_12m,

CASE
	WHEN perdas_estimadas_total_lag_1t <> 0
	THEN ABS(perdas_estimadas_total) / ABS(perdas_estimadas_total_lag_1t) -1
END AS perdas_estimadas_total_var_1t,

CASE
	WHEN perdas_estimadas_total_lag_12m <> 0
	THEN ABS(perdas_estimadas_total) / ABS(perdas_estimadas_total_lag_12m) - 1
END perdas_estimadas_total_var_12m,

vencidos_sobre_carteira - vencidos_sobre_carteira_lag_1t AS vencidos_sobre_carteira_delta_1t,
vencidos_sobre_carteira - vencidos_sobre_carteira_lag_12m AS vencidos_sobre_carteira_delta_12m,

perdas_estimadas_sobre_carteira - perdas_estimadas_sobre_carteira_lag_1t AS perdas_estimadas_sobre_carteira_delta_1t,
perdas_estimadas_sobre_carteira - perdas_estimadas_sobre_carteira_lag_12m AS perdas_estimadas_sobre_carteira_delta_12m,

cobertura_vencidos - cobertura_vencidos_lag_1t AS cobertura_vencidos_delta_1t,
cobertura_vencidos - cobertura_vencidos_lag_12m AS cobertura_vencidos_delta_12m

FROM base_com_lag
ORDER BY periodo











