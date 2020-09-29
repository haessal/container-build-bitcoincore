# Bitcoin Core builder

The Dockerfile in this project is to assemble the container image for building [Bitcoin Core](https://github.com/bitcoin/bitcoin) v0.20.1. In the container, the required tools and libraries are installed according to [UNIX BUILD NOTES](https://github.com/bitcoin/bitcoin/blob/v0.20.1/doc/build-unix.md).

This container is designed to build command-line only bitcoin node, so libraries for GUI are not installed. To compile Berkeley DB 4.8 from source code and install it, [this script](https://github.com/bitcoin/bitcoin/blob/v0.20.1/contrib/install_db4.sh) is used.

## To build Bitcoin Core:

### Assemble the container image

```
$ docker image build -t builder .
```

In this description, *builder* is used as the name of the image.

### Clone Bitcoin Core source code

The builder assume that the target version of Bitcoin Core is v0.20.1.

```
$ cd /path/to/workdir
$ git clone git@github.com:bitcoin/bitcoin.git
$ cd bitcoin
$ git checkout -b v0.20.1 v0.20.1
```

### Run the container with the cloned Bitcoin Core source code

```
$ docker container run --rm -it -v `pwd`:/workspace builder
```

### Build Bitcoin Core (In the container)

```
# cd /workspace
# ./autogen.sh
# CXXFLAGS="-g -O0" CFLAGS="-g -O0" ./configure --without-gui
# make
```

The `CXXFLAGS="-g -O0" CFLAGS="-g -O0"` is not strictly necessary to build, but I offten run the configure script with these option because I want debug info to be included.

When the make complete, you can find `src/bitcoind` in workdir.
