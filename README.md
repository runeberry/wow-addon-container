# Docker: wow-addon-container

This Docker image provides an environment suitable for running Lua unit tests and code coverage tools for a World of Warcraft addon. Even if you have no experience at all with Docker, you can have a Lua environment up and running for your addon code in 30 minutes or less!

See the latest version tags on [Docker Hub](https://hub.docker.com/repository/docker/dolphinspired/wow-addon-container).

## What's in the box?

This image is built on the base container [woahbase/alpine-lua](https://hub.docker.com/r/woahbase/alpine-lua) which is a lightweight Linux installation with Lua and LuaRocks installed. I've added all the utilities necessary for downloading and installing rocks (Lua modules), as well as `make` so you can include Makefiles with your project. The following rocks are included with this image:

* **busted** - for running unit tests
* **luacov** - for generating code coverage info
* **luacov-console** - for writing code coverage results to console
* **luacov-reporter-lcov** - for creating a report that can be turned into detailed HTML output

The container is about 250 MB. It could be made smaller - if anyone wants to take a stab at that, feel free to submit a PR!

## Setup Instructions

**Pre-requisites:** You have WoW addon code on your computer that you want to test locally. If you don't, feel free to `git clone` this repository, as it contains a sample unit test file you can use to test.

### Installing Docker

1. If you don't have a Docker account, go ahead and [create one now](https://hub.docker.com/). You'll need an account to download the wow-addon-container image from Docker Hub.
2. Download and install the latest Docker Desktop application for your operating system. The Community version of Docker is free, but finding the correct version for your OS can be a bit of a hassle. These links should help narrow down your search:
    * [Windows 10 Pro / Enterprise](https://docs.docker.com/docker-for-windows/install/)
    * [Windows 10 Home](https://docs.docker.com/docker-for-windows/install-windows-home/)
    * [Windows 10 2016 LTSB](https://docs.docker.com/docker-for-windows/release-notes/) - download the latest 2.1 release
    * [macOS 10.13+](https://docs.docker.com/docker-for-mac/install/)
3. Open Docker Desktop and sign in with your Docker account.
4. Open a terminal / command prompt. Verify your installation with the following command: `docker version`. You should see some version information in the console.
5. Right click the Docker icon in your System Tray and open Settings. Review the following settings:
    * **Shared Drives**<br/>
      You **must** give Docker access to the drive where your WoW addon code and unit tests are stored in order to run them as outlined in the following instructions.
    * **General > Automatically check for updates**<br/>
      If you're only using Docker for this one image, you may not be worried about always checking for updates. Turn this off if you'd like.
    * **General > Start Docker Desktop when you log in**<br/>
      You may want to leave Docker off when not in use to save on memory usage.

### Adding Unit Tests

If you already have unit tests written for your addon using the [busted](https://olivinelabs.com/busted/) testing framework, you can skip ahead to the next section.

1. Navigate to your WoW addon code's folder and add a new folder named `spec`.
2. Inside this folder, create a new file called `hello-world_spec.lua`.
3. Copy the following contents into that file. It contains two very simple unit tests.

```lua
describe("Hello World", function()
  it("can make words", function()
    local word1, word2 = "Hello", "World"
    local result = word1.." "..word2
    assert.equals("Hello World", result)
  end)
  it("can do math", function()
    local sum = 2 + 2
    assert.equals(4, sum)
  end)
end)
```

### Running your Tests

#### Windows 10

1. Open a command prompt (or powershell) and navigate to your WoW addon code's directory.
    * Run `dir`. If you see the `spec` folder listed, then you're in the right place.
2. Create a script called `docker-run.cmd` and add the following line to it.
```
docker run --rm -it --name my-addon-container -v %cd%:/addon dolphinspired/wow-addon-container
```
3. Run the script with `.\docker-run.cmd`. After it downloads the wow-addon-container image from Docker Hub, you should end up in a bash shell prompt inside the container.
    * Run `ls`. If you still see the `spec` folder listed, then you're in the right place.
    * Note that this large download only needs to happen once. In the future, the image will only be downloaded if it's been updated.
4. Run the command `busted` to execute your unit tests. You should see output indicating that 2/2 tests are passing. Congratulations!
5. When you're done, simply use the command `exit` and you'll return to your host machine's command prompt.

#### macOS or Linux

1. Open a terminal and navigate to your WoW addon code's directory.
    * Run `ls`. If you see the `spec` folder listed, then you're in the right place.
2. Create a script called `docker-run.sh` and add the following line to it.
```
docker run --rm -it --name my-addon-container -v $(pwd):/addon dolphinspired/wow-addon-container
```
3. Make sure the script has execute permissions (`chmod 0755` if needed).
4. Run the script with `sh docker-run.sh`. After it downloads the wow-addon-container image from Docker Hub, you should end up in a bash shell prompt inside the container.
    * Run `ls`. If you still see the `spec` folder listed, then you're in the right place.
    * Note that this large download only needs to happen once. In the future, the image will only be downloaded if it's been updated.
5. Run the command `busted` to execute your unit tests. You should see output indicating that 2/2 tests are passing. Good job!
6. When you're done, simply use the command `exit` and you'll return to your host machine's terminal.

### Generating Code Coverage

I won't get too deep into the details of code coverage here, but you can copy the [Makefile](Makefile) and [.luacov](.luacov) files in this repository to use in any of your WoW addon projects. Add these files to your WoW addon code's directory and run any of the following commands from within the Docker container:

* `make test-coverage` - Prints out your total test coverage to the terminal / command prompt
* `make test-report` - Print out detailed test coverage as an HTML report that you can view in your browser
* `make clean` - Removes all test coverage files

### More Information

* [busted](https://olivinelabs.com/busted/) - Testing framework for Lua
* [Docker notes](DEV.md) - My notes on the commands involved with creating this Docker image
* [PlayerMadeQuests](https://github.com/dolphinspired/PlayerMadeQuests) - The WoW addon that I'm developing which prompted this image's creation. Feel free to use this as an example of how to set up and configure unit tests in your own project.
