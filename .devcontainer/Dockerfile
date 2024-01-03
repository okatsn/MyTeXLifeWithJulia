FROM okatsn/my-typst-space AS build0

FROM okatsn/my-julia-build:latest as build-julia

FROM okatsn/my-tex-life
# Docker image https://hub.docker.com/repository/docker/okatsn/my-tex-life/general built from https://github.com/okatsn/MyTeXLife


# KEYNOTE: Please keep the following codes consistent with https://github.com/okatsn/MyJuliaSpace/tree/master/.devcontainer
USER root

RUN apt-get update && apt-get -y install \
    gdebi-core


# # Install quarto (failed)
# # - Noted that gdebi-core is required.

RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

# Install Julia
ARG JULIA_PKG_DEVDIR="this.is.into.which.dev.clones.packages."


# Set enviroment variable
ENV JULIA_PKG_DEVDIR=${JULIA_PKG_DEVDIR}

# it should be defined here, despite it will overwritten by that in docker-compose.yml

USER $NB_USER
WORKDIR $WORKSPACE_DIR

# For OhMyREPL
# KEYNOTE: use $HOME instead of /home/$NB_USER will fail! Since $HOME is not recognized as absolute directory!
# RUN mkdir -p /home/$NB_USER/.julia/config
# COPY .devcontainer/startup.jl /home/$NB_USER/.julia/config/startup.jl


# CHECKPOINT: Multi stage build; Merge these keynotes to the README of my-julia-space
# https://cindyliu923.com/2021/05/23/What-is-docker-multi-stage/
# - Explanation: What are inside an image?  layers!
# - Keypoints: Middle images won't presents as layers in the final image.
# - All files and folders not `COPY`ed won't survive in the final stage. (?!)
# - Application: Thus you can have some secrets inside the middle image!

# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#use-multi-stage-builds
# - Only the instructions RUN, COPY, ADD create layers.


# # For Typst
# # # Install Rust
# # # Please refers https://www.rust-lang.org/learn/get-started. `-s -- -y` is suggested by ChatGPT in order to install using default settings without interrupt.
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# # Julia part (Please refer the Dockerfile in okatsn/my-julia-build)
COPY --from=build-julia /home/okatsn/.julia /home/$NB_USER/.julia
COPY --from=build-julia /opt/julia-okatsn /opt/julia-okatsn
# Create link in the new machine (based on that /usr/local/bin/ is already in PATH)
RUN sudo ln -fs /opt/julia-okatsn/bin/julia /usr/local/bin/julia
RUN julia --project=@okatsn -e 'using Pkg; Pkg.update()' \
    && julia -e ' \
    Pkg.instantiate(); \
    Pkg.build("IJulia"); \
    '

COPY --from=build0 /bin/typst /bin
# Please refer: https://github.com/my-typst-space