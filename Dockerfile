###############################################################################
# Rizin + rz-ghidra +  rz-jsdec  – Dockerfile v6 (CMake fix)
###############################################################################

############################ 1. Builder #######################################
FROM debian:12-slim AS builder
ARG RZ_PIPE_PY_VERSION=master
ARG RZ_GHIDRA_VERSION=dev
ARG RZ_PM_VERSION=dev
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ninja-build cmake git pkg-config meson \
    python3 python3-pip python3-setuptools python3-wheel python3-tomli \
    libmagic-dev zlib1g-dev libcapstone-dev && \
    rm -rf /var/lib/apt/lists/*

# 1. Rizin (Meson)
WORKDIR /opt
RUN git clone https://github.com/rizinorg/rizin.git rizin-src
WORKDIR /opt/rizin-src
RUN meson setup build --prefix=/usr -Dinstall_sigdb=true && \
    ninja -C build && \
    ninja -C build install && \
    DESTDIR=/opt/install ninja -C build install

# 2. rz-pipe (Python)
WORKDIR /tmp
RUN git clone -b "$RZ_PIPE_PY_VERSION" https://github.com/rizinorg/rz-pipe && \
    pip install --root=/opt/install /tmp/rz-pipe/python

# 3. rz-ghidra (CMake)
WORKDIR /opt
RUN git clone --recurse-submodules -b "$RZ_GHIDRA_VERSION" https://github.com/rizinorg/rz-ghidra
WORKDIR /opt/rz-ghidra
RUN mkdir build && cd build && \
    cmake -G Ninja \
          -DCMAKE_INSTALL_PREFIX=/usr \
          -DCMAKE_PREFIX_PATH=/opt/install/usr \
          .. && \
    ninja && \
    DESTDIR=/opt/install ninja install

# 4. rz-jsdec (Meson)
WORKDIR /opt
RUN git clone --recurse-submodules -b "$RZ_PM_VERSION" https://github.com/rizinorg/jsdec
WORKDIR /opt/jsdec
RUN meson setup build --prefix=/usr && \
    ninja -C build && \
    DESTDIR=/opt/install ninja -C build install

############################ 2. Runtime #######################################

FROM debian:12-slim
LABEL maintainer="Rizin Community" \
      description="Rizin framework with Ghidra decompiler plugin"

# 1. Instala dependências do sistema, incluindo venv
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    python3 \
    python3-pip \
    python3-venv \
    git less nano vim-tiny curl wget && \
    rm -rf /var/lib/apt/lists/*

# Copia os binários do Rizin
COPY --from=builder /opt/install/ / 

# 2. Cria e configura o ambiente virtual
# Criamos o venv em /opt/ para que fique disponível para todos os usuários
ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH

# 3. Adiciona o binário do venv ao PATH
# Isso garante que `python` e `pip` chamem as versões do ambiente virtual
ENV PATH="$VENV_PATH/bin:$PATH"

# ---- Instalação de pacotes Python no VENV ----
WORKDIR /app
# COPY requirements.txt .

# 4. Instala os pacotes usando o pip do ambiente virtual
# RUN pip install --no-cache-dir -r requirements.txt

# Cria e muda para o usuário não-root
RUN useradd -m -s /bin/bash rizin
USER rizin
WORKDIR /home/rizin

CMD ["/bin/bash"]
