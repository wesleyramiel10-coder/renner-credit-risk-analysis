CREATE TABLE select * from  dim_score_thresholds (
    bloco_score TEXT,
    variavel TEXT,
    regra TEXT,
    pontos INTEGER,
    interpretacao TEXT
);

INSERT INTO dim_score_thresholds (
    bloco_score,
    variavel,
    regra,
    pontos,
    interpretacao
)
VALUES

-- =====================================================
-- BLOCO 1: ESTRUTURA PATRIMONIAL
-- =====================================================

(
    'Estrutura patrimonial',
    'caixa_sobre_ativo_pct',
    '>= 15%',
    0,
    'Caixa e aplicações com boa representatividade no ativo; menor pressão de liquidez imediata.'
),

(
    'Estrutura patrimonial',
    'caixa_sobre_ativo_pct',
    '>= 10% e < 15%',
    1,
    'Caixa e aplicações em nível intermediário; atenção à redução do colchão de liquidez.'
),

(
    'Estrutura patrimonial',
    'caixa_sobre_ativo_pct',
    '< 10%',
    2,
    'Baixa participação de caixa no ativo; maior dependência de recebíveis, estoques e geração futura de caixa.'
),

(
    'Estrutura patrimonial',
    'recebiveis_sobre_ativo_pct',
    '< 25%',
    0,
    'Recebíveis com peso moderado no ativo.'
),

(
    'Estrutura patrimonial',
    'recebiveis_sobre_ativo_pct',
    '>= 25% e < 35%',
    1,
    'Recebíveis relevantes no ativo; maior dependência da conversão da carteira em caixa.'
),

(
    'Estrutura patrimonial',
    'recebiveis_sobre_ativo_pct',
    '>= 35%',
    2,
    'Alta concentração de ativos em recebíveis; maior sensibilidade à inadimplência e provisões.'
),

(
    'Estrutura patrimonial',
    'liquidez_corrente',
    '>= 1.7',
    0,
    'Boa folga entre ativo circulante e passivo circulante.'
),

(
    'Estrutura patrimonial',
    'liquidez_corrente',
    '>= 1.3 e < 1.7',
    1,
    'Liquidez corrente adequada, mas com menor folga.'
),

(
    'Estrutura patrimonial',
    'liquidez_corrente',
    '< 1.3',
    2,
    'Liquidez corrente pressionada; menor margem de segurança no curto prazo.'
),

-- =====================================================
-- BLOCO 2: BAD RATIO / CARTEIRA
-- =====================================================

(
    'Carteira / Bad Ratio',
    'bad_ratio_vencidos_pct',
    '< 20%',
    0,
    'Carteira vencida em patamar mais controlado dentro da série analisada.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_vencidos_pct',
    '>= 20% e < 25%',
    1,
    'Carteira vencida em nível de atenção.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_vencidos_pct',
    '>= 25%',
    2,
    'Carteira vencida elevada; sinal de deterioração da qualidade do crédito.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_stage_3_pct',
    '< 15%',
    0,
    'Baixa concentração da carteira em estágio 3.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_stage_3_pct',
    '>= 15% e < 20%',
    1,
    'Concentração relevante em estágio 3; atenção à severidade dos vencidos.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_stage_3_pct',
    '>= 20%',
    2,
    'Alta concentração em estágio 3; sinal de maior severidade da carteira.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_perdas_liquidas_pct',
    '< 3%',
    0,
    'Perdas líquidas em patamar mais controlado em relação à carteira.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_perdas_liquidas_pct',
    '>= 3% e < 5%',
    1,
    'Perdas líquidas em nível intermediário; atenção ao impacto no resultado.'
),

(
    'Carteira / Bad Ratio',
    'bad_ratio_perdas_liquidas_pct',
    '>= 5%',
    2,
    'Perdas líquidas elevadas; maior impacto financeiro da inadimplência.'
),

-- =====================================================
-- BLOCO 3: TENDÊNCIA
-- =====================================================

(
    'Tendência',
    'vencidos_sobre_carteira_delta_12m_pp',
    '< 0 p.p.',
    0,
    'Melhora anual na proporção de vencidos sobre carteira.'
),

(
    'Tendência',
    'vencidos_sobre_carteira_delta_12m_pp',
    '>= 0 p.p. e < 5 p.p.',
    1,
    'Piora anual moderada na proporção de vencidos.'
),

(
    'Tendência',
    'vencidos_sobre_carteira_delta_12m_pp',
    '>= 5 p.p.',
    2,
    'Piora anual relevante na proporção de vencidos.'
),

(
    'Tendência',
    'estagio_3_sobre_vencidos_delta_12m_pp',
    '< 0 p.p.',
    0,
    'Melhora anual na concentração dos vencidos em estágio 3.'
),

(
    'Tendência',
    'estagio_3_sobre_vencidos_delta_12m_pp',
    '>= 0 p.p. e < 10 p.p.',
    1,
    'Piora anual moderada na severidade dos vencidos.'
),

(
    'Tendência',
    'estagio_3_sobre_vencidos_delta_12m_pp',
    '>= 10 p.p.',
    2,
    'Piora anual relevante na severidade dos vencidos, com maior concentração em estágio 3.'
);