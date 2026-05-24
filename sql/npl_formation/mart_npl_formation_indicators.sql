CREATE TABLE mart_npl_formation_indicators AS

SELECT

n.periodo,
n.write_off,
n.npl_formation,
n.npl_formation_stage_3,
n.npl_stage_3_sobre_carteira_media,
n.vencidos_total_npl,
n.vencidos_estagio_1,
n.vencidos_estagio_2,
n.vencidos_estagio_3,
n.vencidos_estagio_3_acima_360,
n.vencidos_estagio_3_juros,
n.perdas_credito_liquidas_recuperacoes,
n.pdd,
n.recuperacoes,

r.carteira_total_cartoes,
r.vencidos_total AS vencidos_total_receivables,
r.perdas_estimadas_total,
r.vencidos_sobre_carteira,
r.perdas_estimadas_sobre_carteira,
r.cobertura_vencidos,

CASE 
	WHEN r.carteira_total_cartoes <> 0
	THEN n.npl_formation / r.carteira_total_cartoes
END AS npl_formation_sobre_carteira,

CASE 
	WHEN r.carteira_total_cartoes <> 0
	THEN n.npl_formation_stage_3 / r.carteira_total_cartoes
END As npl_formation_stage_3_sobre_carteira,

CASE 
	WHEN r.carteira_total_cartoes <> 0
	THEN ABS(n.write_off) / r.carteira_total_cartoes
END AS write_off_sobre_carteira,

CASE
	WHEN r.carteira_total_cartoes <> 0
	THEN ABS(n.pdd) / r.carteira_total_cartoes
END AS pdd_sobre_carteira,

CASE
	WHEN n.vencidos_total_npl <> 0
	THEN n.vencidos_estagio_3 / n.vencidos_total_npl
END AS estagio_3_sobre_vencidos,

CASE 
	WHEN n.vencidos_total_npl <> 0
	THEN ABS (n.pdd) / n.vencidos_total_npl
END AS pdd_sobre_vencidos,

CASE 
	WHEN ABS (n.pdd) <> 0
	THEN n.recuperacoes / ABS(n.pdd)
END AS recuperacoes_sobre_pdd,

CASE
	WHEN r.carteira_total_cartoes <> 0
	THEN ABS(n.perdas_credito_liquidas_recuperacoes) / r.carteira_total_cartoes
END perdas_liquidas_sobre_carteira

FROM mart_npl_formation_core n
LEFT JOIN mart_accounts_receivables_indicators r
ON n.periodo = r.periodo 
ORDER BY n.periodo







