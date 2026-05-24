CREATE TABLE mart_credit_risk_balance_receivables AS 

SELECT 

b.periodo,

---- BLOCO 1: BALANÇO ----

b.ativo_total,
b.caixa_mais_aplicacoes,
b.contas_a_receber AS contas_a_receber_balanco,
b.estoques,
b.passivo_circulante,
b.patrimonio_liquido,
b.liquidez_corrente,
b.recebiveis_sobre_ativo,
b.caixa_sobre_ativo,
b.passivo_sobre_pl,
b.contas_a_receber_var_1t AS contas_a_receber_balanco_var_1t,
b.contas_a_receber_var_12m AS contas_a_receber_balanco_var_12m,
b.caixa_mais_aplicacoes_var_1t,
b.caixa_mais_aplicacoes_var_12m,
b.recebiveis_sobre_ativo_delta_1t,
b.recebiveis_sobre_ativo_delta_12m,

---- BLOCO 2: Recebíveis / Carteira ----

r.contas_receber_total AS contas_receber_total_recebiveis,
r.carteira_total_cartoes,
r.vencidos_total,
r.a_vencer_total,
r.perdas_estimadas_total,
r.vencidos_sobre_carteira,
r.perdas_estimadas_sobre_carteira,
r.cobertura_vencidos,
r.contas_receber_total_var_1t,
r.contas_receber_total_var_12m,
r.carteira_total_cartoes_var_1t,
r.carteira_total_cartoes_var_12m,
r.vencidos_total_var_1t,
r.vencidos_total_var_12m,
r.perdas_estimadas_total_var_1t,
r.perdas_estimadas_total_var_12m,
r.vencidos_sobre_carteira_delta_1t,
r.vencidos_sobre_carteira_delta_12m,
r.perdas_estimadas_sobre_carteira_delta_1t,
r.perdas_estimadas_sobre_carteira_delta_12m,
r.cobertura_vencidos_delta_1t,
r.cobertura_vencidos_delta_12m,

---- BLOCO 3: Campos Formatados para Análise ----

b.recebiveis_sobre_ativo * 100 AS recebiveis_sobre_ativo_pct,
b.caixa_sobre_ativo * 100 As caixa_sobre_ativo_pct,
b.estoques_sobre_ativo * 100 As estoques_sobre_ativo_pct,

r.vencidos_sobre_carteira * 100 AS vencidos_sobre_carteira_pct,
r.perdas_estimadas_sobre_carteira * 100 AS perdas_estimadas_sobre_carteira_pct,
r.cobertura_vencidos * 100 AS cobertura_vencidos_pct,

b.contas_a_receber_var_12m * 100 AS contas_a_receber_balanco_var_12m_pct,
r.carteira_total_cartoes_var_12m * 100 AS carteira_total_cartoes_var_12m_pct,
r.vencidos_total_var_12m * 100 AS vencidos_total_var_12m_pct,
r.perdas_estimadas_total_var_12m * 100 AS perdas_estimadas_total_var_12m_pct,
b.recebiveis_sobre_ativo_delta_12m * 100 AS recebiveis_sobre_ativo_delta_12m_pp,
r.vencidos_sobre_carteira_delta_12m * 100 AS vencidos_sobre_carteira_delta_12m_pp,
r.perdas_estimadas_sobre_carteira_delta_12m * 100 AS perdas_estimadas_sobre_carteira_delta_12m_pp,
r.cobertura_vencidos_delta_12m * 100 AS cobertura_vencidos_delta_12m_pp

FROM mart_balance_sheet_indicators_lag as b 
LEFT JOIN mart_accounts_receivables_indicators_lag as r
ON b.periodo = r.periodo
ORDER BY b.periodo


