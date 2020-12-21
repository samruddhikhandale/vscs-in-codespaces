#!/bin/bash

#ERROR_STR=" See /tmp/deploy-custom-agent.log for info"

function check_err {
    if [ $? -ne 0 ]; then
    echo "⚠ Could not $1. Please try this step manually."
    exit 1
    fi
}

if [[ $1 != "--no-build" ]]; then
    echo "🚀 Building your AGENT changes..."
    dotnet build $CASCADE_ROOT/src/VSOnline > /dev/null
    check_err "build agent"

    pushd $VSCLK_ROOT

    echo "🚀 Building your VSCLK-CORE changes..."
    dotnet build $VSCLK_ROOT  > /dev/null
    check_err "build vsclk-core"
fi

echo "🚀 Generating artifacts..."
dotnet $CASCADE_ROOT/bin/Debug/VSOnline.DevTool/DevTool.dll generateArtifacts $CASCADE_ROOT | tee /tmp/gen_artifacts.txt
check_err "generate artifacts"

ARTIFACTS_PATH=`cat /tmp/gen_artifacts.txt | awk '/Artifact located at: /{print $NF}'`
ARTIFACTS_ID=`echo $ARTIFACTS_PATH |grep -o '[0-9]\+'`

echo "########"
echo $ARTIFACTS_PATH
echo $ARTIFACTS_ID
echo "#####"

echo "🚀 Uploading artifacts..."
pushd ~/CEDev
UseSecretFromAppConfig=1
dotnet $VSCLK_ROOT/bin/debug/VsoUtil/VsoUtil.dll preparedevcli -c $ARTIFACTS_PATH -v $ARTIFACTS_ID --secret-from-app-config
check_err "uploading artifacts"

echo "🎊 All done!"
