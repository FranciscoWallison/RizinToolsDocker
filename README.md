
-----

## English Version (en-US)

# Docker Image for Reverse Engineering with Rizin, rz-ghidra, and rz-jsdec

This Docker image provides a complete and modern reverse engineering environment built on Debian 12 "Slim". It integrates the **Rizin** framework with the powerful **rz-ghidra** (for native binaries) and **rz-jsdec** (for JavaScript) decompiler plugins, compiled directly from their latest sources.

The environment is designed to be secure, isolated, and ready-to-use, making it ideal for malware analysts, security researchers, and reverse engineering enthusiasts.

### Key Features

  * **Complete Environment:** Includes the Rizin framework, the Ghidra decompiler (`rz-ghidra`), and the JavaScript decompiler (`rz-jsdec`).
  * **Always Up-to-Date:** Builds the tools from the `dev`/`master` branches of the official repositories, ensuring access to the latest features.
  * **Multi-Stage Build:** Utilizes a multi-stage design to create a lean final image by discarding all build-time dependencies (`cmake`, `gcc`, `ninja`, etc.).
  * **Secure by Default:** The container runs as a non-root user (`rizin`) for enhanced security.
  * **Isolated Python Environment:** Sets up a Python virtual environment (`venv`) in `/opt/venv`, ensuring that Python script dependencies do not interfere with system packages.
  * **Stable Base:** Built on the robust and recent `debian:12-slim` image.
  * **Easy to Customize:** Allows for the easy installation of additional Python tools via a `requirements.txt` file.

### Included Components

  * **[Rizin](https://rizin.re/)**: An open-source, binary-focused reverse engineering framework that offers a rich set of tools for static and dynamic analysis.
  * **[rz-ghidra](https://github.com/rizinorg/rz-ghidra)**: A plugin that integrates the Ghidra decompiler into Rizin, allowing the use of the `pdg` command to obtain high-quality C code from machine code.
  * **[rz-jsdec](https://github.com/rizinorg/jsdec)**: A decompiler plugin focused on JavaScript, useful for analyzing obfuscation and complex logic in scripts.
  * **[rz-pipe](https://github.com/rizinorg/rz-pipe)**: Python libraries for interacting with and automating Rizin from scripts.

### How to Use

#### Prerequisites

  * [Docker](https://www.docker.com/get-started) installed on your system.

#### 1\. Build the Image

Clone or download the `Dockerfile` to a local directory. Then, run the command below to build the image.

```bash
docker build -t rizin-dev-env .
```

#### 2\. Run the Container

To start an interactive shell inside the container, use the following command. It is highly recommended to mount a volume to analyze your local files without copying them into the image.

The command below mounts the `projects` subdirectory from your current host directory to the `/home/rizin/work` directory inside the container.

```bash
# Create a local directory for your projects if you don't have one
mkdir -p projects

# Run the container
docker run -it --rm -v "$(pwd)"/projects:/home/rizin/work rizin-dev-env
```

  * `-it`: Allocates an interactive terminal.
  * `--rm`: Automatically removes the container when you exit.
  * `-v "$(pwd)"/projects:/home/rizin/work`: Mounts the local `projects` directory into the container.

#### 3\. Inside the Container

You will be greeted with a bash prompt as the `rizin` user. The environment is ready to use.

```bash
# Start analyzing a binary
rizin /bin/ls

# Inside Rizin, analyze and use the Ghidra decompiler
[0x00005590]> aa
[0x00005590]> pdg @ main
```

The Python virtual environment is already activated. You can run `python` or `pip` directly.

### Customization (Adding Python Tools)

You can easily add your own Python tools (like `angr`, `claripy`, `pwntools`, etc.) to the environment.

1.  **Create a `requirements.txt` file** in the same directory as the `Dockerfile` with your list of desired packages.

    ```txt
    # requirements.txt
    pwntools
    z3-solver
    ```

2.  **Uncomment the following lines** in the `Dockerfile`:

    ```dockerfile
    # ---- Instalação de pacotes Python no VENV ----
    WORKDIR /app
    COPY requirements.txt .  # <-- Uncomment this line

    # 4. Instala os pacotes usando o pip do ambiente virtual
    RUN pip install --no-cache-dir -r requirements.txt # <-- Uncomment this line
    ```

3.  **Rebuild the image** with the `docker build` command shown earlier. The new image will contain all your custom tools.
-----

## Versão em Português (pt-BR)

# Imagem Docker para Análise de Reversa com Rizin, rz-ghidra e rz-jsdec

Esta imagem Docker fornece um ambiente de engenharia reversa completo e moderno, construído sobre o Debian 12 "Slim". Ela integra o framework **Rizin** com os poderosos plugins de descompilação **rz-ghidra** (para binários nativos) e **rz-jsdec** (para JavaScript), compilados diretamente a partir de suas fontes mais recentes.

O ambiente é projetado para ser seguro, isolado e pronto para uso, ideal para analistas de malware, pesquisadores de segurança e entusiastas de engenharia reversa.

### Principais Características

  * **Ambiente Completo:** Inclui o framework Rizin, o descompilador Ghidra (`rz-ghidra`), e o descompilador JavaScript (`rz-jsdec`).
  * **Sempre Atualizado:** Constrói as ferramentas a partir dos branches `dev`/`master` dos repositórios oficiais, garantindo acesso às funcionalidades mais recentes.
  * **Construção Multi-Stage:** Utiliza um design de múltiplos estágios para criar uma imagem final enxuta, descartando todas as dependências de compilação (`cmake`, `gcc`, `ninja`, etc.).
  * **Segurança por Padrão:** O contêiner é executado como um usuário não-root (`rizin`) para maior segurança.
  * **Ambiente Python Isolado:** Configura um ambiente virtual Python (`venv`) em `/opt/venv`, garantindo que as dependências de scripts Python não interfiram com os pacotes do sistema.
  * **Base Estável:** Construído sobre a robusta e recente imagem `debian:12-slim`.
  * **Fácil de Customizar:** Permite a fácil instalação de ferramentas Python adicionais através de um arquivo `requirements.txt`.

### Componentes Inclusos

  * **[Rizin](https://rizin.re/)**: Um framework de engenharia reversa de código aberto, com foco em binários, que oferece um conjunto rico de ferramentas para análise estática e dinâmica.
  * **[rz-ghidra](https://github.com/rizinorg/rz-ghidra)**: Um plugin que integra o descompilador do Ghidra ao Rizin, permitindo usar o comando `pdg` para obter código C de alta qualidade a partir de código de máquina.
  * **[rz-jsdec](https://github.com/rizinorg/jsdec)**: Um plugin de descompilação focado em JavaScript, útil para analisar ofuscações e lógicas complexas em scripts.
  * **[rz-pipe](https://github.com/rizinorg/rz-pipe)**: Bibliotecas Python para interagir e automatizar o Rizin a partir de scripts.

### Como Usar

#### Pré-requisitos

  * [Docker](https://www.docker.com/get-started) instalado em seu sistema.

#### 1\. Construir a Imagem

Clone ou baixe o `Dockerfile` para um diretório local. Em seguida, execute o comando abaixo para construir a imagem.

```bash
docker build -t rizin-dev-env .
```

#### 2\. Executar o Contêiner

Para iniciar um shell interativo dentro do contêiner, use o seguinte comando. É altamente recomendável montar um volume para analisar seus arquivos locais sem copiá-los para dentro da imagem.

O comando abaixo monta o subdiretório `projetos` do seu diretório atual para o diretório `/home/rizin/work` dentro do contêiner.

```bash
# Crie um diretório local para seus projetos, se ainda não tiver um
mkdir -p projetos

# Execute o contêiner
docker run -it --rm -v "$(pwd)"/projetos:/home/rizin/work rizin-dev-env
```

  * `-it`: Aloca um terminal interativo.
  * `--rm`: Remove o contêiner automaticamente ao sair.
  * `-v "$(pwd)"/projetos:/home/rizin/work`: Monta o diretório local `projetos` no contêiner.

#### 3\. Dentro do Contêiner

Você será recebido por um prompt de bash como o usuário `rizin`. O ambiente está pronto para uso.

```bash
# Iniciar a análise de um binário
rizin /bin/ls

# Dentro do Rizin, analise e use o descompilador Ghidra
[0x00005590]> aa
[0x00005590]> pdg @ main
```

O ambiente virtual Python já está ativado. Você pode executar `python` ou `pip` diretamente.

### Customização (Adicionar Ferramentas Python)

Você pode facilmente adicionar suas próprias ferramentas Python (como `angr`, `claripy`, `pwntools`, etc.) ao ambiente.

1.  **Crie um arquivo `requirements.txt`** no mesmo diretório do `Dockerfile` com a lista de pacotes desejados.

    ```txt
    # requirements.txt
    pwntools
    z3-solver
    ```

2.  **Descomente as seguintes linhas** no `Dockerfile`:

    ```dockerfile
    # ---- Instalação de pacotes Python no VENV ----
    WORKDIR /app
    COPY requirements.txt .  # <-- Descomente esta linha

    # 4. Instala os pacotes usando o pip do ambiente virtual
    RUN pip install --no-cache-dir -r requirements.txt # <-- Descomente esta linha
    ```

3.  **Reconstrua a imagem** com o comando `docker build` visto anteriormente. A nova imagem conterá todas as suas ferramentas personalizadas.

-----
