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
1. Ensure you are on the `codespaces-extension` branch of the repo page at https://github.com/vsls-contrib/vscs-in-codespaces/tree/codespaces-extension. If you are using a fork, start from your fork's repo page, not the `vsls-contrib/vscs-in-codespaces` repo.
1. Click Code > Open with Codespaces
![image](https://user-images.githubusercontent.com/746020/101094979-16ccda80-3572-11eb-874b-c971014203af.png)
1. The codespace will load and automatically clone the ADO repo with the extension source code, and then run `yarn` and build the extension
1. Wait for the configuration to complete. You can track this in the `Creation Log`, such as by running the `Codespaces: View Creation Log` command. When the `Configure Codespace` step is finished, you're ready to run the extension.
![image](https://user-images.githubusercontent.com/746020/101095940-99a26500-3573-11eb-8bf1-1ae14d2d8dd1.png)
1. Open the `vscode/codespaces/codespaces.workspace` workspace

### Build and run
1. After opening the Codespaces workspace, you can build and run the extension
1. `F5` to build and debug the extension. You might see a prompt in your browser saying popups were blocked. Allow popups and click the link to open the new tab:
![image](https://user-images.githubusercontent.com/746020/101096261-28af7d00-3574-11eb-9f80-8ab363d2c833.png)
1. If you ever want to manually build, you can run `yarn compile` from the `vscode/codespaces` directory

### Test
1. Run `yarn test` in the `vscode/codespaces` directory.

### Miscellaneous
1. Before committing changes, ensure there are no ESLint errors. You can run `yarn eslint-fix` to automatically fix any linting errors. If you do not fix these errors, it will fail the PR build and block your PR from merging.
  
## Issues/Feedback

Feedback appreciated, create issues on this repo if you have any questions or run into issues 🤗
