import json
import logging
import pickle
from typing import Any

import typer
from rich.logging import RichHandler
from sklearn.pipeline import Pipeline
from typing_extensions import Annotated

logger = logging.getLogger(__name__)
logger.addHandler(RichHandler(rich_tracebacks=True, markup=True))
logger.setLevel("INFO")


def score(input: dict[str, Any], pipeline):

    pred = pipeline.predict_proba(input)[:, 1]
    return pred


def main(
    payload: Annotated[str, typer.Option(help="The paylod, in json format")],
    pipeline_file: Annotated[
        str, typer.Option(help="The pipeline file")
    ] = "pipeline_v1.bin",
):

    with open(pipeline_file, "rb") as f_in:
        pipeline = pickle.load(f_in)

    input = json.loads(payload)

    pred = score(input, pipeline)
    logger.info(f"The predicted probabilitiy is {pred}")


if __name__ == "__main__":
    typer.run(main)
