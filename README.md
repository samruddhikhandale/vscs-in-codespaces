# GitHub Codespaces extension in Codespaces

Build and debug the GitHub Codespaces extension in GitHub Codespaces

## Getting Started

### One-time setup
1. If you do not have write-access to the `vsls-contrib/vscs-in-codespaces` repo, go ahead and fork it now
1. Go to https://dev.azure.com/devdiv/_usersSettings/tokens and generate a Personal Access Token that will be used to clone the repo where the Codespaces extension lives
1. Click `New Token` and select the following settings:
    * `Organization: All accessible organizations`
    * `Scope: Code Read & Write`
    * `Scope: Packaging Read`
1. Copy the token
1. Go to https://github.com/settings/codespaces and click `New secret`
    * Name: `ADO_PAT` _:warning: Warning: the name must be called `ADO_PAT` for the init scripts to work!_
    * Value: Paste in the generated PAT
    * Repository access: `vsls-contrib/vscs-in-codespaces` (or if you are using a fork, select your fork)
    
That's it, you're ready to start creating Codespaces! :rocket:

### Create a Codespace
1. Ensure you are on the `vsclk-core` branch of the repo page at https://github.com/vsls-contrib/vscs-in-codespaces/tree/vsclk-core. If you are using a fork, start from your fork's repo page, not the `vsls-contrib/vscs-in-codespaces` repo.
1. Click Code > Open with Codespaces
![image](https://user-images.githubusercontent.com/746020/101094979-16ccda80-3572-11eb-874b-c971014203af.png)
1. The codespace will load and automatically clone the vsclk-core ADO repo.
1. Wait for the configuration to complete. You can track this in the `Creation Log`, such as by running the `Codespaces: View Creation Log` and viewing `Configure Codespace`.
![image](https://user-images.githubusercontent.com/746020/101095940-99a26500-3573-11eb-8bf1-1ae14d2d8dd1.png)
1. In the C# extension settings, ensure that Omnisharp: Project Load Timeout is > 200.
1. Run a dotnet restore on the project/solution on which you want to work. Codespaces.sln has many of the most frequently used projects and is a good place to start; run `dotnet restore /home/codespace/workspace/vscs-in-codespaces/src/Codespaces/Codespaces.sln`.
1. Run the command `Omnisharp: Select Project` and select Codespaces.sln. Wait until all projects are loaded in the Omnisharp logs.
![image](https://user-images.githubusercontent.com/33612256/101835693-01672b80-3af1-11eb-97d7-a5bda056f9d3.png)
1. Begin coding with Intellisense!

## Issues/Feedback

Feedback appreciated, create issues on this repo if you have any questions or run into issues 🤗
