CREATE TABLE mart_balance_sheet_indicators AS

SELECT

periodo,
ativo_total,
caixa,
aplicacoes_financeiras,
contas_a_receber,
estoques,
passivo_total,
passivo_circulante,
patrimonio_liquido,
divida_cp,
divida_lp,
funding_servicos_financeiros_cp,
funding_servicos_financeiros_lp,
fornecedores_cp,

caixa + aplicacoes_financeiras AS caixa_mais_aplicacoes,

divida_cp + divida_lp as divida_bancaria_total,

funding_servicos_financeiros_cp + funding_servicos_financeiros_lp as funding_servicos_financeiros_total,

CASE 
	WHEN passivo_circulante <> 0
	THen ativo_circulante/passivo_circulante
	END as liquidez_corrente,
	
CASE 
	WHEN ativo_total  <> 0
	THEN contas_a_receber/ativo_total
	END AS recebiveis_sobre_ativo,

CASE
	WHEN ativo_total <> 0
	THEN estoques/ativo_total
    END AS estoques_sobre_ativo,
  
CASE
	WHEN ativo_total <> 0
	THEN (caixa + aplicacoes_financeiras) / ativo_total
	END AS caixa_sobre_ativo,
	
CASE 
	WHEN patrimonio_liquido <> 0
	THEN passivo_total / patrimonio_liquido
	END AS passivo_sobre_pl,
	
CASE 
	WHEN ativo_total <> 0 
	THEN patrimonio_liquido/ ativo_total
	END AS pl_sobre_ativo
	
FROM mart_balance_sheet_core
ORDER BY periodo;

