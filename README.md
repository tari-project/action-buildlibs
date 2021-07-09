# action-buildlibs

Build the Tari FFI libraries as part of a github action

## Using the github action

### Inputs

####  platforms

**Optional.** An array of platforms for which to build libwallet. Separate multiple platforms by a semicolon

If omitted, libraries are built for the following architectures by default:

* x86_64-linux-android (x64 Android emulators)
* aarch64-linux-android (64 bit ARM chips; most modern phones)
* i686-linux-android (32-bit emulators)
* armv7-linux-androideabi (32-bit ARM chips, found on older devices)

#### level

**Optional.** `level` specifies the minimum android version to target.The default is '24'.

### Example usage

```yml
name: Build libwallet

# Build a new set of libraries when a new tag containing 'libwallet' is pushed
on:
  push:
    tags:
      - "libwallet-*"
jobs:
  build_libs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: tari-project/action-buildlibs@v0.0.1
        with:
          platforms: "x86_64-linux-android;aarch64-linux-android"
          level: "24"
      - name: Create Release
          id: create_release
          uses: actions/create-release@v1
          env:
            GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          with:
            tag_name: ${{ github.ref }}
            release_name: Release ${{ github.ref }}
            draft: false
            prerelease: true
```

## Building the docker image for github action
```
docker build -t quay.io/tarilabs/build-libwallet .
```

Note that if you update the rust toolchain you will also need to build dependant images locally first as well.

To test the build works on the image, change directory to the root of the tari repository and execute the following command:
```
docker run -v ${PWD}:/source quay.io/tarilabs/build-libwallet "x86_64-linux-android;aarch64-linux-android" 24 /source refs/heads/development
```

## Using the Dockerfile as a standalone builder

You can use the `Dockerfile` in this repo to as a build engine to build the FFI libraries locally.

First pull the Docker image:

`docker pull quay.io/tarilabs/build-libwallet`

Then checkout the Tari base node source code

```
$ cd src  
$ git checkout git@github.com:tari-project/tari.git
$ cd tari
```

Assuming you're at the root of the Tari source folder (`~/src/tari` in this example), and you want to tarballs placed  
in `{target-dir}`, you can run:

```
docker run -v ${PWD}:/github/workspace -v /tmp/jniLibs:/github/home -e SRC_DIR=/github/workspace -e VERSION="0.x.y" -e PLATFORMS="platform1;platform2" -e LEVEL=45 quay.io/tarilabs/build-libwallet
```

It takes 45 min to an hour to build libraries for the four default android platforms.
