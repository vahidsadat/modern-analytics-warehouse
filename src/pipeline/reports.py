import psycopg2
import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()


class ReportBase:
    pathBase : str

    def insertDataIntoPostgres(self,data: pd.DataFrame, table: str):
        host = "127.0.0.1"
        database = "warehouse"
        port = 5432
        user = os.getenv("PG_USER")
        password = os.getenv("PG_PASSWORD")


        database_url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
        engine = create_engine(database_url)
        data.to_sql(
            name= table,
            schema="warehouse",
            con=engine,
            if_exists='replace',
            chunksize=1000,
            index=False
        )