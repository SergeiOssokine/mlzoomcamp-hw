FROM agrigorev/zoomcamp-model:2025
RUN pip install uv
COPY ["pyproject.toml","uv.lock","./"]
RUN uv sync --frozen --no-dev --no-install-project
COPY ["predict_service.py","./"]
CMD ["uv", "run", "uvicorn", "predict_service:app", "--host", "0.0.0.0", "--port", "9696"]
EXPOSE 9696