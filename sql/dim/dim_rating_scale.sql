CREATE TABLE dim_rating_scale (
    rating_credito TEXT,
    score_min INTEGER,
    score_max INTEGER,
    interpretacao TEXT
);

INSERT INTO dim_rating_scale (
    rating_credito,
    score_min,
    score_max,
    interpretacao
)
VALUES
(
    'A - Baixo risco',
    0,
    3,
    'Baixa quantidade de sinais de alerta; estrutura patrimonial e carteira em condição mais confortável.'
),

(
    'B - Risco moderado',
    4,
    7,
    'Alguns sinais de atenção, mas sem deterioração generalizada.'
),

(
    'C - Risco elevado',
    8,
    11,
    'Deterioração relevante em múltiplas dimensões de risco.'
),

(
    'D - Risco crítico',
    12,
    16,
    'Acúmulo elevado de sinais de risco; combinação de pressão patrimonial, carteira vencida e severidade.'
);