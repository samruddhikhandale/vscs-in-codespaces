#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e $PALETTE_RED"\n Do not run ./setup-vsclk.sh directly. Run script from ./init_repos.sh \n"$PALETTE_RESET
    exit 1
fi

echo -e $PALETTE_LIGHT_YELLOW"\n ⌬ Fetching the VSCLK repo\n"$PALETTE_RESET
mkdir vsclk-core
pushd ./vsclk-core
export VSCLK_ROOT=`pwd`
echo -e "export VSCLK_ROOT=$VSCLK_ROOT" >> ~/.cs-environment


EMPTY_STRING=""
CLEAN_ORIGIN="${VSCLK_REPO_URL/https\:\/\//$EMPTY_STRING}"


# clone the vsclk repo
git clone https://PAT:$ADO_PAT@$CLEAN_ORIGIN .

mkdir -p ~/.nuget/NuGet/

# get the NuGet.Config file path
unset NUGET_FILE_PATH
# 1. check the NUGET_CONFIG_FILE_PATH variable set by the user first
if ! [ -z $NUGET_CONFIG_FILE_PATH ] 2> /dev/null && [ -f $NUGET_CONFIG_FILE_PATH ];
then
    NUGET_FILE_PATH=$NUGET_CONFIG_FILE_PATH
# 2. check the repo root next
elif [ -f $VSCLK_ROOT/NuGet.config ]
then
    NUGET_FILE_PATH=$VSCLK_ROOT/NuGet.config
# 3. check the user folder finally
elif [ -f ~/.nuget/NuGet/NuGet.Config ]
then
  NUGET_FILE_PATH=~/.nuget/NuGet/NuGet.Config
fi

if [[ -z "$VSCLK_ROOT" ]]; then
  echo -e $PALETTE_RED"\n ERROR: VSCLK_ROOT env variable not set.\n"$PALETTE_RESET
  exit -1
fi

if ! [ -z $NUGET_FILE_PATH ] 2> /dev/null && [ -f $NUGET_FILE_PATH ]; then
  echo -e "!! Generating nuget config file.."
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

if [[ -z "$ADO_PAT_BASE64" ]]; then
  echo -e $PALETTE_RED"\n ERROR: ADO_PAT_BASE64 env variable not set.\n"$PALETTE_RESET
  exit -1
fi

# get the .npmrc file path
unset NPMRC_FILE_PATH
# 1. check the NPMRC_CONFIG_FILE_PATH variable set by the uer first
if ! [ -z $NPMRC_CONFIG_FILE_PATH ] 2> /dev/null && [ -f $NPMRC_CONFIG_FILE_PATH ];
then
    NPMRC_FILE_PATH=$NPMRC_CONFIG_FILE_PATH
# 2. check the repo root next
elif [ -f $VSCLK_ROOT/.npmrc ]
then
    NPMRC_FILE_PATH=$VSCLK_ROOT/.npmrc
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

echo -e $PALETTE_BLUE"\n ⌬ Restoring VSCLK Packages\n"$PALETTE_RESET
dotnet restore

popd

echo -e $PALETTE_GREEN"\n ⌬ VSCLK Setup Complete.\n"$PALETTE_RESET

# exec bash