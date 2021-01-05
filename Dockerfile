# Custom dockerfile to build Tari libwallet for android
FROM quay.io/tarilabs/sqlite-mobile:201911192122 as sqlite
FROM quay.io/tarilabs/openssl:android as ssl
FROM quay.io/tarilabs/rust-ndk:1.46.0_r21b
# Copy the precompiled sqlite binaries
COPY --from=sqlite /platforms /platforms
COPY --from=ssl /platforms /platforms
ADD ./scripts ./scripts/

ARG LEVEL=24
# PF gets replaced by the platform being compiled
#ENV LDEXTRA="-L/platforms/sqlite/PF/lib -I/platforms/ssl/PF/usr/local/lib/ -lc++ -lsqlite3 -lcrypto -lssl"
ENV CFLAGS "-fPIC -I/platforms/sqlite/PF/include -I/platforms/ssl/PF/usr/local/include/ -DMDB_USE_ROBUST=0"
ENV CPPFLAGS "-fPIC -I/platforms/sqlite/PF/include -I/platforms/ssl/PF/usr/local/include"
ENV LDFLAGS "-L/platforms/sqlite/PF/lib -I/platforms/ssl/PF/usr/local/lib/ -lc++ -lsqlite3 -lcrypto -lssl"
ENV RUST_LOG "debug"
ENV RUSTFLAGS "-L/platforms/sqlite/PF/lib -L/platforms/ssl/PF/usr/local/lib/"
ENV CARGO_FLAGS "--package tari_wallet_ffi --lib --release"
ENV PLATFORMS "x86_64-linux-android;aarch64-linux-android;armv7-linux-androideabi;i686-linux-android"
ENV VERSION "latest"

ENTRYPOINT ["/scripts/entrypoint.sh"]
