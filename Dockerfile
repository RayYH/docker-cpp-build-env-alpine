FROM alpine:latest

LABEL maintainer="rayyh <rayyounghong@gmail.com>"

ENV VCPKG_FORCE_SYSTEM_BINARIES=1

# Install necessary build tools, debugging utilities, and dependencies
RUN apk add --no-cache \
      build-base \
      git \
      gcc \
      g++ \
      gdb \
      clang \
      lldb \
      strace \
      make \
      ninja \
      cmake \
      autoconf \
      automake \
      libtool \
      valgrind \
      tzdata \
      bash \
      musl-locales \
      dos2unix \
      rsync \
      tar \
      curl \
      zip \
      unzip

# Set timezone and locale
ENV TZ=Etc/UTC \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Add a non-root user
RUN adduser -D -s /bin/bash builder \
    && mkdir -p /workspace \
    && chown builder:builder /workspace

USER builder
WORKDIR /workspace

# Install vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git /home/builder/vcpkg \
    && /home/builder/vcpkg/bootstrap-vcpkg.sh -disableMetrics

# Preconfigure environment variables for vcpkg
ENV PATH="/home/builder/vcpkg:${PATH}" \
    VCPKG_ROOT="/home/builder/vcpkg"
