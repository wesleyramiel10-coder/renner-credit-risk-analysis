
CREATE TABLE stg_npl_formation_clean AS
SELECT
    ROWID AS row_id_original,

    TRIM(PRIVATE_LABEL__CO_BRANDED_THOUSAND_OF_R) AS conta_en,

    TRIM(CARTÃO_RENNER__MEU_CARTÃO_R_MIL) AS conta_pt,

    SUBSTR(PERIODO, 1, 10) AS periodo,

    CAST(VALOR AS REAL) AS valor,

    ORIGEM_TABELA AS origem_tabela

FROM stg_npl_formation_long
WHERE
    (
        PRIVATE_LABEL__CO_BRANDED_THOUSAND_OF_R IS NOT NULL
        AND TRIM(PRIVATE_LABEL__CO_BRANDED_THOUSAND_OF_R) <> ''
    )
    OR
    (
        CARTÃO_RENNER__MEU_CARTÃO_R_MIL IS NOT NULL
        AND TRIM(CARTÃO_RENNER__MEU_CARTÃO_R_MIL) <> ''
    )

ORDER BY periodo, row_id_original