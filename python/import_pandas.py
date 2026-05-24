import pandas as pd
import sqlite3
import os
from pathlib import Path


# Use o 'r' antes do caminho para o Windows não confundir as barras
BASE_DIR = Path.cwd().parents[0]
CAMINHO_DB = BASE_DIR / "database" / "renner_credit_analysis.db"

# Verificação de segurança:
if not os.path.exists(caminho_fixo):
    print(f"Erro: O arquivo não foi encontrado em: {caminho_fixo}")
else:
    banco_dados = 'analise_lren3.db'
    conn = sqlite3.connect(banco_dados)

    # Lendo o Excel
    abas = pd.read_excel(caminho_fixo, sheet_name=None)

    for nome_aba, df in abas.items():
        # Limpa os nomes das colunas (remove espaços, bota em maiúsculo e tira caracteres especiais)
        df.columns = [str(c).strip().replace(' ', '_').upper() for c in df.columns]
        
        # Cria a tabela no banco
        df.to_sql(nome_aba.upper(), conn, if_exists='replace', index=False)
        print(f"Tabela {nome_aba.upper()} carregada com sucesso!")

    conn.close()
    print("\nProcesso finalizado! Agora você pode abrir o 'analise_lren3.db' no DBeaver.")