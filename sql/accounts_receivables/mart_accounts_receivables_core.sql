CREATE TABLE mart_accounts_receivables_core AS

SELECT 

periodo,

MAX(CASE WHEN ordem_linha = 2  THEN valor END) AS cartao_renner_a_vencer,
MAX(CASE WHEN ordem_linha = 6  THEN valor END) AS cartao_renner_vencidos,
MAX(CASE WHEN ordem_linha = 10 THEN valor END) AS cartao_renner_carteira_total,
MAX(CASE WHEN ordem_linha = 11 THEN valor END) AS cartao_renner_ajuste_valor_presente,
MAX(CASE WHEN ordem_linha = 12 THEN valor END) AS cartao_renner_perdas_estimadas,
MAX(CASE WHEN ordem_linha = 13 THEN valor END) AS cartao_renner_carteira_liquida,
MAX(CASE WHEN ordem_linha = 15 THEN valor END) AS meu_cartao_a_vencer,
MAX(CASE WHEN ordem_linha = 19 THEN valor END) AS meu_cartao_vencidos,
MAX(CASE WHEN ordem_linha = 23 THEN valor END) AS meu_cartao_carteira_total,
MAX(CASE WHEN ordem_linha = 24 THEN valor END) AS meu_cartao_ajuste_valor_presente,
MAX(CASE WHEN ordem_linha = 25 THEN valor END) AS meu_cartao_perdas_estimadas,
MAX(CASE WHEN ordem_linha = 26 THEN valor END) AS meu_cartao_carteira_liquida,
MAX(CASE WHEN ordem_linha = 27 THEN valor END) AS cartoes_terceiros_vpl,
MAX(CASE WHEN ordem_linha = 28 THEN valor END) AS outras_recebiveis,
MAX(CASE WHEN ordem_linha = 29 THEN valor END) AS contas_receber_total

FROM stg_accounts_receivables_clean
GROUP BY periodo
ORDER BY periodo