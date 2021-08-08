#!/usr/bin/env bash

# Change to the script directory
#cd "$(dirname "$0")"
pip install -r ../lamda/code/my_lambda_function_with_dependencies/requirements.txt -t ../lamda/code/my_lambda_function_with_dependencies/package/ 
