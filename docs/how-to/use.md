# HOW TO USE VSCODE DOCKERIZE CLI

This *CLI* for *Visual Studio Code* will allow to run this editor from inside a *Docker Container*.

**VSCode Commands:**

* [Help](#help)
* [Run](#run)
    * [Run with Defaults](#run-with-defaults)
    * [Run With a Specific Profile](#run-with-a-specific-profile)
    * [Run With Custom Developer Workspace](#run-with-custome-developer-workspace)
* [Shell](#shell)
* [Rebuild](#rebuild)


### Help

```bash
vscode -h
```

### Run

Use it to fire a new Visual Studio Code Window.

#### Run with defaults

VSCode will open in current dir, `$PWD`, using the default Profile.

##### Signature

`vscode [run]`

##### Examples

```bash
$ vscode
```

or

```
$ vscode run
```

#### Run with a specific Profile

Use Profiles to create different setups for each programming language.

Also usefull to try new extensions or settings.

##### Signature

`vscode -p <profile-name>`

##### Example

```bash
vscode -p python
```

#### Run with custom developer workspace

By default `$PWD` on Host is mapped to Container `/home/$USER/Developer`, but another HOST workspace can be provided.

##### Signature

`vscode -w </absolute/path/to/developer/workspace> <container-name>`

##### Example

```bash
vscode -w /home/$USER/Documents
```

### Shell

Use to execute a Shell Inside the Docker Container.

##### Signature

`vscode shell <container-name>`.

##### Example

```bash
vscode shell vscode1486504665
```

### Rebuild

This will Rebuild the Docker Image.

##### Signature

`vscode rebuild`

##### Example

```bash
vscode rebuild
```