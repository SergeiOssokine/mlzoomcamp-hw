#!/bin/bash
set -e # Exit on any command failure
echo "Looking for uv"
if ! [ -x "$(command -v uv)" ]; then
    echo 'uv is not installed. Installing'
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "Found uv installation"
fi

echo "Setting up the environment with uv"
uv venv .mlzoomcamp --python 3.13
source .mlzoomcamp/bin/activate
echo "Installing packages"
uv pip install -r setup/requirements.txt
echo "Installing pre-commit"
pre-commit install
echo "Now activate the environment by running source .mlzoomcamp/bin/activate"
