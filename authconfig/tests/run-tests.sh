#!/bin/bash
set -ev

test -z $1 && echo "Usage: ${0} OS_ID" && exit 1
export OS_ID=$1
cd ..

# salt state.apply all tests
docker run --rm \
  -v $(pwd)/tests/pytests/apply-all-tests:/opt/tests \
  -h "salt-testing-${OS_ID}" \
  --name "salt-testing-${OS_ID}" \
  -it authconfig:"salt-testing-${OS_ID}" \
  pytest -s /opt/tests

# salt state.apply single sls
docker run --rm \
  -v $(pwd)/tests/pytests/apply-single-sls-tests:/opt/tests \
  -h "salt-testing-${OS_ID}" \
  --name "salt-testing-${OS_ID}" \
  -it authconfig:"salt-testing-${OS_ID}" \
  pytest -s /opt/tests
