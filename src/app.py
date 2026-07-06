from pipeline.pipeline import ConnectorPipeline
from logger import setup_logger

if __name__ == "__main__":
    setup_logger()
    
    pipeline = ConnectorPipeline()
    pipeline.run()

