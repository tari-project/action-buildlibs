# Custom dockerfile to build Tari libwallet for android
FROM quay.io/tarilabs/sqlite-mobile:201911192122 as sqlite
FROM quay.io/tarilabs/rust-ndk:1.43.0_r21b
# Copy the precompiled sqlite binaries
COPY --from=sqlite / /sqlite

ENV SRC_DIR=${GTIHUB_WORKSPACE}
ENV CFLAGS="-DMDB_USE_ROBUST=0"
ENV CPPFLAGS="-fPIC -I${SQLITE}/include"
ENV CARGO_FLAGS="-p tari_wallet_ffi"