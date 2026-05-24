CREATE TABLE mart_income_statement_indicators AS
SELECT
    periodo,

    receita_operacional_bruta,
    receita_operacional_liquida,
    receita_liquida_varejo,
    receita_liquida_servicos_financeiros,
    custos_vendas_servicos,
    lucro_bruto,
    lucro_bruto_varejo,
    lucro_bruto_servicos_financeiros,
    despesas_operacionais,
    perdas_em_credito,
    lucro_operacional_antes_resultado_financeiro,
    resultado_financeiro,
    lucro_antes_ir_cs,
    imposto_renda_contribuicao_social,
    lucro_liquido,

    -- Margens principais
    CASE
        WHEN receita_operacional_liquida <> 0
        THEN lucro_bruto / receita_operacional_liquida
    END AS margem_bruta,

    CASE
        WHEN receita_operacional_liquida <> 0
        THEN lucro_operacional_antes_resultado_financeiro / receita_operacional_liquida
    END AS margem_operacional,

    CASE
        WHEN receita_operacional_liquida <> 0
        THEN lucro_liquido / receita_operacional_liquida
    END AS margem_liquida,

    -- Peso das despesas e perdas
    CASE
        WHEN receita_operacional_liquida <> 0
        THEN ABS(despesas_operacionais) / receita_operacional_liquida
    END AS despesas_operacionais_sobre_receita,

    CASE
        WHEN receita_operacional_liquida <> 0
        THEN ABS(perdas_em_credito) / receita_operacional_liquida
    END AS perdas_credito_sobre_receita,

    CASE
        WHEN receita_operacional_liquida <> 0
        THEN resultado_financeiro / receita_operacional_liquida
    END AS resultado_financeiro_sobre_receita,

    -- Composição da receita
    CASE
        WHEN receita_operacional_liquida <> 0
        THEN receita_liquida_varejo / receita_operacional_liquida
    END AS varejo_sobre_receita,

    CASE
        WHEN receita_operacional_liquida <> 0
        THEN receita_liquida_servicos_financeiros / receita_operacional_liquida
    END AS servicos_financeiros_sobre_receita,

    -- Rentabilidade dos blocos
    CASE
        WHEN receita_liquida_varejo <> 0
        THEN lucro_bruto_varejo / receita_liquida_varejo
    END AS margem_bruta_varejo,

    CASE
        WHEN receita_liquida_servicos_financeiros <> 0
        THEN lucro_bruto_servicos_financeiros / receita_liquida_servicos_financeiros
    END AS margem_bruta_servicos_financeiros

FROM mart_income_statement_core
ORDER BY periodo;