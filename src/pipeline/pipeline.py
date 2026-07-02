import pandas as pd
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

class PipelineConnector:

    def __init__(self,input_data: Path)->None:
        self.input_data = input_data


        if not(self.input_data):
            logger.info("There is no input data")


    def run(self) -> None:
        pass