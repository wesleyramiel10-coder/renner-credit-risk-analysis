CREATE TABLE mart_ebitda_indicators_lag AS
WITH base_com_lag AS (
    SELECT
        periodo,

        ebitda_total,
        ebitda_total_ajustado,
        margem_ebitda_total_ajustado,

        ebitda_ajustado_varejo,
        margem_ebitda_ajustado_varejo,

        ebitda_servicos_financeiros,
        servicos_financeiros_sobre_ebitda_ajustado,

        ebitda_total_ajustado_pre_ifrs16,
        margem_ebitda_total_ajustado_pre_ifrs16,

        ebitda_ajustado_varejo_pre_ifrs16,
        margem_ebitda_ajustado_varejo_pre_ifrs16,

        LAG(ebitda_total, 4) OVER (ORDER BY periodo) AS ebitda_total_lag_12m,
        LAG(ebitda_total_ajustado, 4) OVER (ORDER BY periodo) AS ebitda_total_ajustado_lag_12m,
        LAG(margem_ebitda_total_ajustado, 4) OVER (ORDER BY periodo) AS margem_ebitda_total_ajustado_lag_12m,

        LAG(ebitda_ajustado_varejo, 4) OVER (ORDER BY periodo) AS ebitda_ajustado_varejo_lag_12m,
        LAG(margem_ebitda_ajustado_varejo, 4) OVER (ORDER BY periodo) AS margem_ebitda_ajustado_varejo_lag_12m,

        LAG(ebitda_servicos_financeiros, 4) OVER (ORDER BY periodo) AS ebitda_servicos_financeiros_lag_12m,
        LAG(servicos_financeiros_sobre_ebitda_ajustado, 4) OVER (ORDER BY periodo) AS servicos_financeiros_sobre_ebitda_ajustado_lag_12m,

        LAG(ebitda_total_ajustado_pre_ifrs16, 4) OVER (ORDER BY periodo) AS ebitda_total_ajustado_pre_ifrs16_lag_12m,
        LAG(margem_ebitda_total_ajustado_pre_ifrs16, 4) OVER (ORDER BY periodo) AS margem_ebitda_total_ajustado_pre_ifrs16_lag_12m

    FROM mart_ebitda_core
)

SELECT
    *,

    CASE
        WHEN ebitda_total_lag_12m <> 0
        THEN ebitda_total / ebitda_total_lag_12m - 1
    END AS ebitda_total_var_12m,

    CASE
        WHEN ebitda_total_ajustado_lag_12m <> 0
        THEN ebitda_total_ajustado / ebitda_total_ajustado_lag_12m - 1
    END AS ebitda_total_ajustado_var_12m,

    margem_ebitda_total_ajustado - margem_ebitda_total_ajustado_lag_12m AS margem_ebitda_total_ajustado_delta_12m,

    CASE
        WHEN ebitda_ajustado_varejo_lag_12m <> 0
        THEN ebitda_ajustado_varejo / ebitda_ajustado_varejo_lag_12m - 1
    END AS ebitda_ajustado_varejo_var_12m,

    margem_ebitda_ajustado_varejo - margem_ebitda_ajustado_varejo_lag_12m AS margem_ebitda_ajustado_varejo_delta_12m,

    CASE
        WHEN ebitda_servicos_financeiros_lag_12m <> 0
        THEN ebitda_servicos_financeiros / ebitda_servicos_financeiros_lag_12m - 1
    END AS ebitda_servicos_financeiros_var_12m,

    servicos_financeiros_sobre_ebitda_ajustado - servicos_financeiros_sobre_ebitda_ajustado_lag_12m AS servicos_financeiros_sobre_ebitda_ajustado_delta_12m,

    CASE
        WHEN ebitda_total_ajustado_pre_ifrs16_lag_12m <> 0
        THEN ebitda_total_ajustado_pre_ifrs16 / ebitda_total_ajustado_pre_ifrs16_lag_12m - 1
    END AS ebitda_total_ajustado_pre_ifrs16_var_12m,

    margem_ebitda_total_ajustado_pre_ifrs16 - margem_ebitda_total_ajustado_pre_ifrs16_lag_12m AS margem_ebitda_total_ajustado_pre_ifrs16_delta_12m

FROM base_com_lag
ORDER BY periodo;