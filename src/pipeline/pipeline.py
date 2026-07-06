import pandas as pd
from pathlib import Path
import logging
from .reports import REPORTS
from .reports import ReportBase

logger = logging.getLogger(__name__)

class ConnectorPipeline:
    table = []
    def __init__(self)->None:
        
        self.table = [report.report_name for report in REPORTS]


    def run(self) -> None:
        for report_name in REPORTS:
            try:
                report = report_name()
                logger.info(f"Running pipeline for table: {report.report_name}")
                report.insertDataIntoPostgres(report.addCreatedTime(),report_name.report_name)
            except Exception as e:
                logger.error(f"Error processing {report_name.__name__}: {e}")
