FROM okatsn/my-tex-life
# Docker image https://hub.docker.com/repository/docker/okatsn/my-tex-life/general built from https://github.com/okatsn/MyTeXLife


# KEYNOTE: Please keep the following codes consistent with https://github.com/okatsn/MyJuliaSpace/tree/master/.devcontainer
USER root

# Install quarto
RUN  apt-get update && apt-get -y install gdebi-core
RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

# Install Julia
ARG VARIANT="what.ever.is.ok.since.it.will.be.overwritten.by.that.in.docker-compose.yml"
ARG JULIA_PKG_DEVDIR="this.is.into.which.dev.clones.packages."


# Set enviroment variable
ENV JULIA_PKG_DEVDIR=${JULIA_PKG_DEVDIR}

# it should be defined here, despite it will overwritten by that in docker-compose.yml
RUN mkdir /opt/julia-${VARIANT} \
    && curl -L https://julialang-s3.julialang.org/bin/linux/x64/`echo ${VARIANT} | cut -d. -f 1,2`/julia-${VARIANT}-linux-x86_64.tar.gz | tar zxf - -C /opt/julia-${VARIANT} --strip=1 \
    && ln -fs /opt/julia-${VARIANT}/bin/julia /usr/local/bin/julia

USER $NB_USER
WORKDIR $WORKSPACE_DIR


ENV JULIA_PROJECT=@.

RUN julia -e 'using Pkg; Pkg.update()' \
    && julia -e '\
    using Pkg; \
    Pkg.Registry.add(RegistrySpec(url = "https://github.com/okatsn/OkRegistry.git"))' \
    && julia -e ' \
    using Pkg; \
    Pkg.add(name="IJulia"); \
    Pkg.build("IJulia") \
    '
# For OhMyREPL
RUN mkdir -p $HOME/.julia/config
COPY .devcontainer/startup.jl $HOME/.julia/config/startup.jl


# CHECKPOINT: Remove old .vscode-server
# - since okatsn/my-tex-life already has .vscode-server in /home/jovyan; if I don't delete it, error `rmdir: failed to remove 'home/.../.vscode-server/bin/....' Directory not empty` will occur
# - It seems set your current vscode's "dev.containers.cacheVolume": false, to apply your extensions and settings in .devcontainer/devcontainer.json
# - an alternative way is to use `RUN code-server --install-extension ms-python.python` (suggested by chatgpt)
# - see also: https://github.com/microsoft/vscode-remote-release/issues/7690 and related posts in Dockerfile of MyJuliaSpace
ARG VSCODE_PATH=/home/$NB_USER/.vscode-server
ARG VSCODE_INS_PATH=/home/$NB_USER/.vscode-server-insiders
RUN rm -rf $VSCODE_PATH
RUN mkdir -p $VSCODE_PATH/extensions \
    $VSCODE_INS_PATH/extensions \
    && chown -R $NB_USER \
    $VSCODE_PATH \
    $VSCODE_INS_PATH
