# action-buildlibs

To build the FFI libraries:

Assuming you're at the root of the Tari source folder, and you want to tarballs placed in `{target-dir}`, you can run:

`docker run -v ${PWD}:/src/ -v {target-dir}:/tmp/output quay.io/tarilabs/build-libwallet:latest`
