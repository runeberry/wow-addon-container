# Docker commands

These commands that I used for developing this Docker image on Windows. Not needed for end users, just placed here as a reference for future development.

### Build the image

```
docker build -t dolphinspired/wow-addon-container .
```

The `.` must be the last argument in the command, telling Docker to to use the Dockerfile in the current directory.

The argument `t` accepts values in the `name:tag` format. Or, more specifically, in the format `<repo_name>/<image_name>:<tag_name>`. If you don't specify a tag name (by omitting `:`), then it is automatically tagged as `latest`. Also, you can specify multiple tags on `build`, by simply specifying `t` multiple times.

### Run the image

```
docker run --rm -it --name my-addon-container -v %cd%:/addon dolphinspired/wow-addon-container
```

Runs the `latest` tag of the wow-addon-container image with the parameters specified. The `WORKDIR` and `ENTRYPOINT` of the Dockerfile indicate that a bash shell will be opened at the "/addon" directory when this container starts.

Let's break down the parameters being passed to `docker run`:
  * `--rm` - This container will be removed as soon as it is exited.
  * `-it` - Allows an "interactive terminal" to be opened on this container.
  * `--name my-addon-container` - Gives the container a nice name while it's running, to help you find it if you're doing any troubleshooting.
  * `-v %cd%:/addon` - Creates a [bind-mount](https://docs.docker.com/storage/bind-mounts/) on the container. This means that the "/addon" directory inside the container will point directly to the current directory on your machine that you're running this script from.
    * In order for this to work, you need to explicitly [give Docker access to the drive](https://token2shell.com/howto/docker/sharing-windows-folders-with-containers/) you want to link from your machine.
    * Note that this is truly a reference, not a copy of the directory, so any changes you make on your local machine will immediately be reflected on the container!
    * If you're running this from PowerShell, you must place this command in a `.cmd` file and run that file. Powershell will throw a fit when it sees `%cd%` directly in the terminal, but treats it differently in a `.cmd` file.

Note that is you ever get an error that "my-addon-container is already running" when you try to run it, simply run `docker kill my-addon-container` and try again.

### Add a version tag

```
docker tag dolphinspired/wow-addon-container dolphinspired/wow-addon-container:1.0.1
```

This will tag the `latest` image as `1.0.1` as well.

### Push the image to Docker Hub

```
docker push dolphinspired/wow-addon-container
```

Will push both the `latest` and any other version tags for this image to Docker Hub. They can be seen [here](https://hub.docker.com/repository/docker/dolphinspired/wow-addon-container).