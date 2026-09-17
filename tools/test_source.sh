#!/bin/bash

set -e
set -x

python -m venv test_env
source test_env/bin/activate

python -m pip install dist/*.tar.gz
python -m pip install -r requirements/test_requirements.txt

# Run the tests on the installed source distribution
mkdir tmp_for_test
cd tmp_for_test

if pip show -qq pytest-xdist; then
    XDIST_WORKERS=$(python -c "import joblib; print(joblib.cpu_count(only_physical_cores=True))")
    pytest --pyargs sklearn -n $XDIST_WORKERS
else
    pytest --pyargs sklearn
fi
