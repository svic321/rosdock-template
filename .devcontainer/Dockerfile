ARG ROS_DISTRO=rolling
FROM ros:${ROS_DISTRO}
ARG ROS_DISTRO
ARG USERNAME=USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip
RUN apt-get install -y zsh git curl openssh-client command-not-found
RUN apt-get install -y bat ripgrep fd-find zoxide eza lf starship tmux git-delta

# Install oh-my-zsh for the user and make zsh the default login shell
RUN chsh -s $(which zsh) $USERNAME
USER $USERNAME
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
        && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
        && git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions \
        && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.oh-my-zsh/custom/plugins/you-should-use \
        && git clone https://github.com/butakus/ros2-env ~/.oh-my-zsh/custom/plugins/ros2-env \
        && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
        && git clone https://github.com/hlissner/zsh-autopair ~/.oh-my-zsh/custom/plugins/zsh-autopair \
        && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
        && ~/.fzf/install --all \
        && sed -i '/^plugins=(git)$/c\plugins=(\
    git\
    vi-mode\
    command-not-found\
    colored-man-pages\
    zsh-syntax-highlighting\
    zsh-autosuggestions\
    zsh-autopair\
    you-should-use\
    ros2-env\
) ' ~/.zshrc
RUN sed -i '74i fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src' ~/.zshrc \
                && sed -i '75i autoload -U compinit && compinit' ~/.zshrc
RUN mkdir -p ~/.local/bin \
        && curl https://raw.githubusercontent.com/thimc/lfimg/refs/heads/master/lfrun -o ~/.local/bin/lfrun \
        && chmod +x ~/.local/bin/lfrun \
        && ln -s /usr/bin/batcat ~/.local/bin/bat

USER root
ENV SHELL /usr/bin/zsh

# Install latest neovim release
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
        && rm -rf /opt/nvim-linux-x86_64 \
        && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
        && rm nvim-linux-x86_64.tar.gz
USER $USERNAME
RUN echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
RUN printf '%s\n' \
        "if [[ -f /opt/ros/${ROS_DISTRO}/setup.zsh ]]; then" \
        "  source /opt/ros/${ROS_DISTRO}/setup.zsh" \
        "fi" \
        'if [[ -f ~/.svic321/zshrc.zsh ]]; then' \
        '  source ~/.svic321/zshrc.zsh' \
        'fi' \
        'if [[ -d ~/.local/bin ]]; then' \
        '  export PATH=$PATH:~/.local/bin' \
        'fi' \
        'eval "$(register-python-argcomplete ros2)"' \
        'eval "$(register-python-argcomplete colcon)"' \
        'eval "$(zoxide init zsh)"' \
        'eval "$(starship init zsh)"' >> ~/.zshrc
USER root

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/ws
CMD ["/bin/zsh"]
