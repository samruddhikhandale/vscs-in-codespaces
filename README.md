# Cascade/Agent CLI in Codespaces

> ⚠⚠ Branch is under construction.  Contact [jospicer](josh.spicer@microsoft.com) with questions. 

## Getting Started

### VSCLK Setup

Please follow the [README on the codespaces-service branch](https://github.com/vsls-contrib/vscs-in-codespaces/blob/codespaces-service/README.md) to complete the individual developer setup.

### Cacasde Setup

...

...

### Deploying a Custom Agent

You can run the `deploy-custom-agent.sh` script (on your path, source [here](https://github.com/vsls-contrib/vscs-in-codespaces/blob/cascade-agent-cli/.codespaces/deploy-custom-agent.sh)) which will:

<<<<<<< HEAD
1. Build Cascade
2. Build Vsclk-Core
3. Generate the agent artifacts with Cacade's `DevTool.dll`
4. Upload to Azure to be used in your personal devstamp with vsclk-core's `VsoUtil.dll`.

=======
>>>>>>> 16b4c71b3ff97547753e783e4b85504cfc26c1ee
You may specify the `--no-build` flag to skip steps 1 and 2, although you'll need to have built at some point to have the `DevTool` and `VsoUtil` dlls present.
