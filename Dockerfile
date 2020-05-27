# Custom dockerfile to build Tari libwallet for android
FROM quay.io/tarilabs/sqlite-mobile:201911192122 as sqlite
FROM quay.io/tarilabs/rust-ndk:1.43.0_r21b
# Copy the precompiled sqlite binaries
COPY --from=sqlite /platforms /platforms
ADD ./scripts ./scripts/

ARG LEVEL=24
# PF gets replaced by the platform being compiled
#ENV LDEXTRA="-L/platforms/sqlite/PF/lib -lc++ -lsqlite3"
ENV CFLAGS "-fPIC -I/platforms/sqlite/PF/include -DMDB_USE_ROBUST=0"
ENV CPPFLAGS "-fPIC -I/platforms/sqlite/PF/include"
ENV LDFLAGS "-L/platforms/sqlite/PF/lib -lc++ -lsqlite3"
ENV RUST_LOG "debug"
ENV RUSTFLAGS "-L/platforms/sqlite/PF/lib -lc++ -lsqlite3"
ENV CARGO_FLAGS " -p tari_wallet_ffi --lib --release"
ENV PLATFORMS "x86_64-linux-android;aarch64-linux-android;armv7-linux-androideabi"
ENV VERSION "latest"

ENTRYPOINT ./scripts/entrypoint.sh "${PLATFORMS}" "${LEVEL}" "${SRC_DIR}" "${VERSION}"
