# Custom dockerfile to build Tari libwallet for android
FROM quay.io/tarilabs/sqlite-mobile:201911192122 as sqlite
FROM quay.io/tarilabs/rust-ndk:1.43.0_r21b
# Copy the precompiled sqlite binaries
COPY --from=sqlite / /platforms

# PF gets replaced by the platform being compiled
#ENV LDEXTRA="-L/platforms/sqlite/PF/lib -lc++ -lsqlite3"
ENV CFLAGS="-DMDB_USE_ROBUST=0"
ENV CPPFLAGS="-fPIC -I/platforms/sqlite/PF/include"
ENV RUST_LOG="debug"
ENV RUSTFLAGS="-L/platforms/sqlite/PF/lib -lc++ -lsqlite3"
ENV CARGO_FLAGS="--release -p tari_wallet_ffi"