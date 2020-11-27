#!/bin/bash

# go to extension workspace folder and
# install all yarn dependencies
cd $CODESPACE_ROOT/vscode
yarn install

# build the codespaces extension
cd $CODESPACE_ROOT/vscode/codespaces
yarn compile

## done, ask to open the [codespaces.code-workspace] file 🎉

WORKSPACE_FILE_NAME="codespaces.code-workspace"
WORKSPACE_FILE_PATH=$CODESPACE_ROOT/vscode/codespaces/codespaces.code-workspace")

OPEN_WP="code -r \"$WORKSPACE_FILE_PATH\""
echo -e "\nalias code:wp='$OPEN_WP'" >> ~/.bashrc

echo -e "$PALETTE_CYAN\n💡  All done, type$PALETTE_PURPLE code:wp$PALETTE_CYAN to open $PALETTE_PURPLE$WORKSPACE_FILE_PATH$PALETTE_CYAN file $PALETTE_RESET\n"

source ~/.bashrc
