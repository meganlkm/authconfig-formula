#!/bin/bash
set -ev

test -z $1 && echo "Usage: ${0} OS_ID" && exit 1
export OS_ID=$1


function docker-run-pytest() {
    docker run --rm \
        -v "$@":/opt/tests \
        --env=STAGE=TEST \
        -h "salt-testing-${OS_ID}" \
        --name "salt-testing-${OS_ID}" \
        -it authconfig:"salt-testing-${OS_ID}" \
        pytest -sv /opt/tests
}


# salt state.apply all tests
docker-run-pytest $(pwd)/pytests/apply-all-tests

# salt state.apply single sls
docker-run-pytest $(pwd)/pytests/apply-single-sls-tests
