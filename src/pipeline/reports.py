import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
from pathlib import Path
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

load_dotenv()


class ReportBase:
    pathBase : str = "project_2_modern_analytics_warehouse/input_data"
    schema_name: str = "warehouse"
    def __init__(self):
        self.engine = self.create_postgresql_engine()

    def create_postgresql_engine(self)->Engine:
        host = os.getenv("PG_HOST","127.0.0.1")
        database = os.getenv("PG_DB","warehouse")
        port = os.getenv("PG_PORT",5432)
        user = os.getenv("PG_USER")
        password = os.getenv("PG_PASSWORD")
        
        
        if not user or not password:
            raise ValueError("PG_USER and PG_PASSWORD must be defined in your .env file")

        database_url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"

        return create_engine(database_url)
    

    def checkExistanceSchema(self):
        with self.engine.begin() as connection:
            connection.execute(text(f"CREATE SCHEMA IF NOT EXISTS {self.schema_name}"))
    def insertDataIntoPostgres(self,data: pd.DataFrame, table: str):
        self.checkExistanceSchema()

        data.to_sql(
            name= table,
            schema="warehouse",
            con=self.engine,
            if_exists='replace',
            chunksize=1000,
            index=True
        )
    
    def getReport(self):
        raise NotImplementedError("Subclasses must implement getReport()")

    def addCreatedTime(self):
        data = self.getReport().copy()
        data["createdTime"] = pd.Timestamp.now()
        return data

    

class ReportCustomer(ReportBase):
    report_name = "customers"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["customer_id"], inplace=True)
        return report

class ReportMarketingSpend(ReportBase):
    report_name = "marketing_spend"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["spend_date","channel","campaign_name"], inplace=True)
        return report


class ReportOrderItems(ReportBase):
    report_name = "order_items"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["order_item_id"], inplace=True)
        return report


class ReportOrders(ReportBase):
    report_name = "orders"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["order_id","customer_id"], inplace=True)
        return report

class ReportPayments(ReportBase):
    report_name = "payments"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["payment_id"], inplace=True)
        return report


class ReportProducts(ReportBase):
    report_name = "products"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["product_id"], inplace=True)
        return report

class ReportWebSessions(ReportBase):
    report_name = "web_sessions"

    def getReport(self):
        path = f'{self.pathBase}/{self.report_name}.csv'
        
        if not Path(path).exists():
            raise FileNotFoundError(f"File is not found: {path}")
        
        report = pd.read_csv(path)
        report.set_index(["session_id"], inplace=True)
        return report
REPORTS = [
    ReportCustomer,
    ReportMarketingSpend,
    ReportOrderItems,
    ReportOrders,
    ReportPayments,
    ReportProducts,
    ReportWebSessions
]