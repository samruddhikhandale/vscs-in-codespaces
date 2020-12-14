#!/bin/bash

echo "Setup vsclk..."

EMPTY_STRING=""
CLEAN_ADO_ORIGIN="${VSCLK_REPO_URL/https\:\/\//$EMPTY_STRING}"

git remote remove github-origin &>/dev/null
git remote rename origin github-origin &>/dev/null

#git remote remove origin
git remote add origin https://PAT:$ADO_PAT@$CLEAN_ADO_ORIGIN

GIT_DEFAULT_BRANCH_NAME=$(git remote show origin | grep "HEAD branch\: " | sed 's/HEAD branch\: //g' | xargs)

echo -e $PALETTE_LIGHT_YELLOW"\n ⌬ Fetching the repo\n"$PALETTE_RESET

git reset --hard
git checkout main

git branch --track github-main

# clone the ADO repo
git pull origin $GIT_DEFAULT_BRANCH_NAME:$GIT_DEFAULT_BRANCH_NAME --force --no-tags

git checkout $GIT_DEFAULT_BRANCH_NAME &>/dev/null

export ADO_PAT_BASE64=$(echo -n $ADO_PAT | base64)
# replace env variable reference in the .npmrc
sed -i -E "s/_password=.+$/_password=$ADO_PAT_BASE64/g" ~/.npmrc
# write the token to the env file
echo -e "export ADO_PAT=$ADO_PAT" >> ~/.cs-environment

if [ ! -d $CODESPACE_DEFAULT_PATH ]; then
    echo -e $PALETTE_RED"\n ❗ Cannot find the \`$CODESPACE_DEFAULT_PATH\` path, failed clone the repo or the \$ADO_REPO_DEFAULT_PATH not correct?\n"$PALETTE_RESET
    exit 1
fi

mkdir -p ~/.nuget/NuGet/

# get the NuGet.Config file path
unset NUGET_FILE_PATH
# 1. check the NUGET_CONFIG_FILE_PATH variable set by the uer first
if ! [ -z $NUGET_CONFIG_FILE_PATH ] 2> /dev/null && [ -f $NUGET_CONFIG_FILE_PATH ];
then
    NUGET_FILE_PATH=$NUGET_CONFIG_FILE_PATH
# 2. check the repo root next
elif [ -f $CODESPACE_ROOT/NuGet.config ]
then
    NUGET_FILE_PATH=$CODESPACE_ROOT/NuGet.config
# 3. check the default workspace folder next
elif [ -f $CODESPACE_DEFAULT_PATH/NuGet.config ]
then
  NUGET_FILE_PATH=$CODESPACE_DEFAULT_PATH/NuGet.config
fi


if ! [ -z $NUGET_FILE_PATH ] 2> /dev/null && [ -f $NUGET_FILE_PATH ]; then
  echo -e "Generating nuget config file.."
  NAMES=$(cat $NUGET_FILE_PATH | sed -n 's/<add.*key="\([^"]*\).*/\1/p')
  names_array=($NAMES)

  URLS=$(cat $NUGET_FILE_PATH | sed -n '/<add.*key="\(.*\)"/s/.*value="\(.*\)"[^\n]*/\1/p')
  urls_array=($URLS)

  FEEDS=""
  i=0
  for FEED_NAME in "${names_array[@]}"
  do
      FEED_URL=(${urls_array[$i]})
      FEEDS="$FEEDS\n\t\t<add key=\"$FEED_NAME\" value=\"$FEED_URL\" />"
      i=$((i+1))
  done

  CREDENTIALS=""
  for FEED_NAME in "${names_array[@]}"
  do
      CREDENTIAL="<$FEED_NAME>
      <add key=\"Username\" value=\"devdiv\" />
      <add key=\"ClearTextPassword\" value=\"%ADO_PAT%\" />
  </$FEED_NAME>"

      CREDENTIALS="$CREDENTIALS\n$CREDENTIAL"
  done

  echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>
  <configuration>
  \t<packageSources>$FEEDS
  \t</packageSources>
  \t<packageSourceCredentials>$CREDENTIALS
  \t</packageSourceCredentials>
  </configuration>
  " > ~/.nuget/NuGet/NuGet.Config
fi

# get the .npmrc file path
unset NPMRC_FILE_PATH
# 1. check the NPMRC_CONFIG_FILE_PATH variable set by the uer first
if ! [ -z $NPMRC_CONFIG_FILE_PATH ] 2> /dev/null && [ -f $NPMRC_CONFIG_FILE_PATH ];
then
    NPMRC_FILE_PATH=$NPMRC_CONFIG_FILE_PATH
# 2. check the repo root next
elif [ -f $CODESPACE_ROOT/.npmrc ]
then
    NPMRC_FILE_PATH=$CODESPACE_ROOT/.npmrc
# 3. check the default workspace folder next
elif [ -f $CODESPACE_DEFAULT_PATH/.npmrc ]
then
  NPMRC_FILE_PATH=$CODESPACE_DEFAULT_PATH/.npmrc
fi

if ! [ -z $NPMRC_FILE_PATH ] 2> /dev/null && [ -f $NPMRC_FILE_PATH ]; then
  echo -e "Generating npmrc config file.. "
  FEEDS=$(cat $NPMRC_FILE_PATH | sed -n 's/.*registry=https:\([^\n]*\).*/\1/p')
  feeds_array=($FEEDS)

  i=0
  FEEDS_STRING=""
  for FEED_URL in "${feeds_array[@]}"
  do
    CLEAN_FEED_URL=${FEED_URL%"registry/"}
    FEEDS_STRING="$FEEDS_STRING
; begin auth token\n
$FEED_URL:username=uname\n
$FEED_URL:_password=$ADO_PAT_BASE64\n
$FEED_URL:email=npm requires email to be set but doesn't use the value\n
$CLEAN_FEED_URL:username=uname\n
$CLEAN_FEED_URL:_password=$ADO_PAT_BASE64\n
$CLEAN_FEED_URL:email=npm requires email to be set but doesn't use the value\n
; end auth token\n
\n\n"
    i=$((i+1))
  done
fi

echo -e $FEEDS_STRING >> ~/.npmrc

cd $CODESPACE_DEFAULT_PATH

USER_POST_CREATE_COMMAND_FILE=~/ado-in-codespaces/.devcontainer/post-create-command.sh
if [ -f $USER_POST_CREATE_COMMAND_FILE ]; then
    echo -e $PALETTE_CYAN"\n Executing the post create command..\n"$PALETTE_RESET

    source ~/.cs-environment

    . $USER_POST_CREATE_COMMAND_FILE
fi

exec bash