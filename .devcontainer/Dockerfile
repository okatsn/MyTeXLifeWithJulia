FROM okatsn/my-tex-life
# Docker image https://hub.docker.com/repository/docker/okatsn/my-tex-life/general built from https://github.com/okatsn/MyTeXLife

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
    # CHECKPOINT: OkRegistry will be added, but these packages disappears.
    # try to fix this problem by moving it to the front


RUN julia -e 'using Pkg; Pkg.update()' \
    && julia -e '\
        using Pkg; \
        Pkg.Registry.add(RegistrySpec(url = "https://github.com/okatsn/OkRegistry.git"))' \
    && julia -e ' \
        using Pkg; \
        Pkg.add(name="IJulia"); \
        Pkg.build("IJulia") \
    '
