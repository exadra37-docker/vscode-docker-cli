#  Docker Image For Visual Studio Code

This Docker image will allow us to run the amazing [Visual Studio Code](https://code.visualstudio.com) without the need to
install it in our computers.

The motivation to create this package come from the burn of reinstalling my Development environment across several computers each time I install/upgrade an OS or change computer.

So this package is the second of a series of other packages to make my Development environment very portable, easy and fast to
install in any computer.


## How to Install Visual Studio Code With a Docker Image

#### Using CURL in command line:

```bash
bash -c "$(curl -fsSL https://gitlab.com/exadra37-dockerize/visual-studio-code/raw/master/setup/install.sh)"
```

#### Using WGET in Command Line:

```bash
bash -c "$(wget  https://gitlab.com/exadra37-dockerize/visual-studio-code/raw/master/setup/install.sh -O -)"
```

## How to Use Visual Studio Code from a Docker Image

The default Host dir shared with the VSC Container is `/home/$USER/Developer/Workspace`, that we can override at any time.


#### Run With Defaults

```bash
vsc
```

#### See Help

Check how to use it at any time...

```bash
vsc -h
```

#### Run With Custom Developer Workspace

By default `/home/$USER/Developer/Workspace` on Host is mapped to Container `/home/$USER/Developer`, but we can change the path
 in the Host we want to map into the Container, like:

```bash
vsc -d /absolute/path/in/host
```

#### Rebuild Docker Image

To have the Ubuntu inside the Docker Image up to date we should rebuild the image every week.

```bash
vsc -r
```

#### How to Debug Docker Container for Visual Studio Code

For trouble shouting Visual Studio Code installation we may need to go inside the docker container.

To help us on that, when starting the container, the exact command will be printed and should look like:

```bash
sudo docker exec -it VSC_1486504665 bash
```
