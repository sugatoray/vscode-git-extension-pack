#!/bin/bash

### File: setconda.sh

# To run this script from project root directory:
# RUN: . .vscode/setconda.sh

alias setconda='. ./.vscode/setconda.sh'
alias baseconda='conda activate base'
#alias xmake="make -C ./.vscode"
alias xmake="make -f ./.vscode/Makefile"

PROJECT_NAME="vscode-jinja-extension-pack"
PROJECT_CONDA_ENV="fav_env"

# conda activate $PROJECT_CONDA_ENV
formatsetconda $PROJECT_NAME $PROJECT_CONDA_ENV || conda activate $PROJECT_CONDA_ENV

unset \
    PROJECT_NAME \
    PROJECT_CONDA_ENV
