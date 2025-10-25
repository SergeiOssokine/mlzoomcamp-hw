import glob
import pickle
from typing import Any

import uvicorn
from fastapi import FastAPI

# Note that we find the pipeline file!
pipeline_file = glob.glob("pipeline*.bin")[0]


with open(pipeline_file, "rb") as f_in:
    pipeline = pickle.load(f_in)


app = FastAPI(title="predict_api_service")


@app.post("/predict")
def predict(input: dict[str, Any]):

    y_pred = pipeline.predict_proba(input)[:, 1]
    result = {
        "conversion_probability": float(y_pred),
    }

    return result


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=9696)
