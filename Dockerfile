FROM ubuntu:22.04
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y vim git python3-pip python3-dbus \
    && apt-get install -y fzf bc curl \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get install -y man-db sudo bash-completion \
    && yes | unminimize \
    && echo 'done'

RUN adduser nicolas \
    && adduser nicolas --add_extra_groups sudo
# Disable password for sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER nicolas
RUN pip install pre-commit && \
    pip install ruamel.yaml

WORKDIR /home/nicolas
RUN git clone https://nicovince@github.com/nicovince/bin.git && \
    git clone --recurse-submodules https://nicovince@github.com/nicovince/vimrc.git .vim && \
    echo 'source $HOME/.vim/vimrc.vim' > /home/nicolas/.vimrc && \
    cd .vim && \
    find pack -name "doc" -exec vim -u NONE -c "helptags {}" -c q \; && \
    cd && \
    git clone https://nicovince@github.com/nicovince/dotfiles.git .dotfiles && \
    cd .dotfiles && ./init_config.sh

CMD /bin/bash
