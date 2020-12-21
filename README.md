# Cascade/Agent CLI in Codespaces

> ⚠⚠ Branch is under construction.  Contact [jospicer](josh.spicer@microsoft.com) with questions. 

## Getting Started

### Setup

Please follow the [README on the codespaces-service branch](https://github.com/vsls-contrib/vscs-in-codespaces/blob/codespaces-service/README.md) to complete the individual developer setup.

Specifically, make sure to complete the [one-time setup section](https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-service#one-time-setup) **before creating the codespace**. 

After the init-repo script completes (You can check its status with the `Codespaces: View Creation Log` vscode command), Open `agent-development.code-workspace` from the file explorer and select `OPEN WORKSPACE`.  

This will give you a clean workspace organized like:

```
.
├── Cascade
    ├── bin
    ├── ...
└── vsclk-core
    ├── bin
    ├── ...
```

Use each project's directory like you would normally. Git commands, etc will work as normal.

The `.codespaces` directory cloned from vscs-in-codespaces is not deleted, and can still be accessed via your terminal at `~/workspace/vscs-in-codespaces/.codespaces`.  The `.codespaces` directory is added to your `$PATH`, letting you run any scripts in that directory from any directory.

## How to...

### Run Frontend + Backend Services

Please check the README on the `codespaces-service` branch, found [here](https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-service#running-the-frontend-and-backend-services).

### Deploy a Custom Agent

You can run the `deploy-custom-agent.sh` script (on your `$PATH`, source [here](https://github.com/vsls-contrib/vscs-in-codespaces/blob/cascade-agent-cli/.codespaces/deploy-custom-agent.sh)) which will:

1. Build Cascade
2. Build Vsclk-Core
3. Generate the agent artifacts with Cacade's `DevTool.dll`
4. Upload to Azure to be used in your personal devstamp with vsclk-core's `VsoUtil.dll`.

You may specify the `--no-build` flag to skip steps 1 and 2, although you'll need to have built at some point to have the `DevTool` and `VsoUtil` dlls present.
