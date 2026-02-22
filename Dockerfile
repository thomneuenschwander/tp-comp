# Usa a imagem oficial do Ubuntu 16.04 como base
FROM ubuntu:16.04

# Evita prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza os repositórios e instala as dependências necessárias
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    csh \
    sharutils \
    flex \
    bison \
    default-jdk \
    sharutils \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Cria o diretório obrigatório para o compilador Cool
RUN mkdir -p /var/tmp/cool

# Define o diretório de trabalho
WORKDIR /var/tmp/cool

# Copia o arquivo x86_64.u para o diretório de trabalho
COPY cool/x86_64.u /var/tmp/cool/

# Decodifica, descompacta e instala localmente
RUN uudecode x86_64.u && \
    tar xvpf x86_64.tar.gz && \
    make install

# Define o diretório inicial ao entrar no container
WORKDIR /root
CMD ["/bin/bash"]