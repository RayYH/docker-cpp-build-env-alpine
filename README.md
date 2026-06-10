# docker-cpp-build-env-alpine

A lightweight Alpine-based Docker image for C/C++ development, debugging, and CI builds, with [vcpkg](https://github.com/microsoft/vcpkg) preinstalled.

Image: [`rayyounghong/cpp-build-env-alpine`](https://hub.docker.com/r/rayyounghong/cpp-build-env-alpine) — built nightly for `linux/amd64` and `linux/arm64`.

## Features

- **Base**: `alpine:latest` (small footprint, musl libc).
- **Toolchains**: GCC (`gcc`, `g++`, `build-base`) and Clang (`clang`, `lldb`).
- **Build systems**: `make`, `ninja`, `cmake`, `autoconf`, `automake`, `libtool`.
- **Debugging / profiling**: `gdb`, `lldb`, `strace`, `valgrind`.
- **Package manager**: [vcpkg](https://github.com/microsoft/vcpkg) preinstalled at `/home/builder/vcpkg`, on `PATH`, with `VCPKG_ROOT` set. Bootstrapped with metrics disabled and `VCPKG_FORCE_SYSTEM_BINARIES=1` (required on Alpine/musl).
- **Utilities**: `git`, `curl`, `tar`, `zip`, `unzip`, `rsync`, `dos2unix`, `bash`.
- **Locale & time**: `tzdata` + `musl-locales`, configured to `en_US.UTF-8` / `Etc/UTC`.
- **Non-root user**: runs as `builder` (uid from `adduser -D`) with `/workspace` as the working directory.
- **Multi-arch**: published for `linux/amd64` and `linux/arm64`.

## Usage

Pull the image:

```sh
docker pull rayyounghong/cpp-build-env-alpine:latest
```

Drop into a shell with your project mounted at `/workspace`:

```sh
docker run --rm -it -v "$PWD":/workspace rayyounghong/cpp-build-env-alpine:latest bash
```

Use it as a CI build environment, e.g. in GitHub Actions:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: rayyounghong/cpp-build-env-alpine:latest
    steps:
      - uses: actions/checkout@v4
      - run: cmake -S . -B build -G Ninja
      - run: cmake --build build
```

Install dependencies with vcpkg (manifest mode):

```sh
vcpkg install
```

## Notes

- Compiling with vcpkg on Alpine requires `VCPKG_FORCE_SYSTEM_BINARIES=1` (already set in the image) because vcpkg's prebuilt tool binaries are not musl-compatible.
- The image is rebuilt nightly against `alpine:latest`, so `latest` follows upstream Alpine and vcpkg `HEAD`. Pin by digest if you need reproducible builds.
