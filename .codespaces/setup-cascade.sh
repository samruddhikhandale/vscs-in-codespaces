#!/bin/bash

echo "Setup cascade..."
mkdir cascade
pushd ./cascade
export "CASCADE_ROOT=${pwd}"

EMPTY_STRING=""
CLEAN_ORIGIN="${CASCADE_REPO_URL/https\:\/\//$EMPTY_STRING}"

echo "do cascade stuff...."

popd

echo "cascade setup complete."
