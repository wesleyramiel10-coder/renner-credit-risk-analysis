CREATE TABLE mart_npl_formation_core AS 

SELECT 

periodo,

MAX(CASE WHEN conta_pt = 'Baixas' THEN valor END) AS write_off,
MAX(CASE WHEN conta_pt = 'Formação de vencidos' THEN valor END) as npl_formation,
MAX(CASE WHEN conta_pt = 'Formação de vencidos (estágio 3)' THEN valor END) as npl_formation_stage_3,
MAX(CASE WHEN conta_pt = '% sobre a carteira média' THEN valor END) AS npl_stage_3_sobre_carteira_media,
MAX(CASE WHEN conta_pt = 'Vencidos' THEN valor END) AS vencidos_total_npl,
MAX(CASE WHEN conta_pt = 'Estágio 1' THEN valor END) AS vencidos_estagio_1,
MAX(CASE WHEN conta_pt = 'Estágio 2' THEN valor END) AS vencidos_estagio_2,
MAX(CASE WHEN conta_pt = 'Estágio 3' THEN valor END) AS vencidos_estagio_3,
MAX(CASE WHEN conta_pt = 'Estágio 3 - Acima 360 dias' THEN valor END) AS vencidos_estagio_3_acima_360,
MAX(CASE WHEN conta_pt = 'Estágio 3 - Reconhecimento adicional de juros' THEN valor END) AS vencidos_estagio_3_juros,
MAX(CASE WHEN conta_pt = 'Perdas em Créditos, Líquidas das Recuperações' THEN valor END) AS perdas_credito_liquidas_recuperacoes,
MAX(CASE WHEN conta_pt = 'PDD' THEN valor END) AS pdd,
MAX(CASE WHEN conta_pt = 'Recuperações' THEN valor END) as recuperacoes

FROM stg_npl_formation_clean
GROUP BY periodo
ORDER BY periodo