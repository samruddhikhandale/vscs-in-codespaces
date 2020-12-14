#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e $PALETTE_RED"\n Do not run ./setup-cascade.sh  directly. Run script from ./init_repos.sh \n"$PALETTE_RESET
    exit 1
fi

echo -e $PALETTE_LIGHT_YELLOW"\n ⌬ Fetching the CASCADE repo\n"$PALETTE_RESET
mkdir cascade
pushd ./cascade
export "CASCADE_ROOT=${pwd}"

EMPTY_STRING=""
CLEAN_ORIGIN="${CASCADE_REPO_URL/https\:\/\//$EMPTY_STRING}"

# clone the cascade repo
git clone https://PAT:$ADO_PAT@$CLEAN_ORIGIN .

popd

echo -e $PALETTE_GREEN"\n ⌬ CASCADE Setup Complete.\n"$PALETTE_RESET
