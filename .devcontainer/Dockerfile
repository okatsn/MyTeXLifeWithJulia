FROM okatsn/my-tex-life
# Docker image https://hub.docker.com/repository/docker/okatsn/my-tex-life/general built from https://github.com/okatsn/MyTeXLife


# KEYNOTE: Please keep the following codes consistent with https://github.com/okatsn/MyJuliaSpace/tree/master/.devcontainer
USER root

RUN apt-get update && apt-get -y install \\
    # gdebi-core \\
    fontconfig \\ 
    # Install Fonts
    # in order to use `fc-cache -f -v` and `fc-list :lang=zh`
    # - `fc-cache -f -v`: (copy font files to /usr/share/fonts/ and Update Font Cache)
    # - `fc-list :lang=zh`: List all chinese font available
    fonts-noto-cjk \\
    fonts-arphic-uming \\
    fonts-arphic-ukai

# # Install quarto
# # - Noted that gdebi-core is required.

# RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
# RUN gdebi --non-interactive quarto-linux-amd64.deb

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
# Noted that Pkg.build("IJulia") might be effortless if built here.

# For OhMyREPL
# KEYNOTE: use $HOME instead of /home/$NB_USER will fail! Since $HOME is not recognized as absolute directory!
RUN mkdir -p /home/$NB_USER/.julia/config
COPY .devcontainer/startup.jl /home/$NB_USER/.julia/config/startup.jl


# CHECKPOINT: Multi stage build; Merge these keynotes to the README of my-julia-space
# https://cindyliu923.com/2021/05/23/What-is-docker-multi-stage/
# - Explanation: What are inside an image?  layers!
# - Keypoints: Middle images won't presents as layers in the final image.
# - All files and folders not `COPY`ed won't survive in the final stage. (?!)
# - Application: Thus you can have some secrets inside the middle image!

# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#use-multi-stage-builds
# - Only the instructions RUN, COPY, ADD create layers.
