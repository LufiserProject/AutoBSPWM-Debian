#!/usr/bin/bash

# Author: Lucifer
# Debian Setup Script with Fixed ZSH Plugins

# Colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Global variables
dir=$(pwd)
fdir="$HOME/.local/share/fonts"
user=$(whoami)
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH_DIR/custom}"

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Exiting...\n${endColour}"
    exit 1
}

function banner(){
    echo -e "\n${turquoiseColour}                                             ${endColour}"
    sleep 0.05
    echo -e "${turquoiseColour},--.                 ,--. ,---.               ${endColour}"
    sleep 0.05
    echo -e "${turquoiseColour}|  |   ,--.,--. ,---.\`--'/  .-' ,---. ,--.--. ${endColour}"
    sleep 0.05
    echo -e "${turquoiseColour}|  |   |  ||  || .--',--.|  \`-,| .-. :|  .--' ${endColour}"
    sleep 0.05
    echo -e "${turquoiseColour}|  '--.'  ''  '\\ \`--.|  ||  .-'\\   --.|  |    ${endColour}"
    sleep 0.05
    echo -e "${turquoiseColour}\`-----' \`----'  \`---'\`--'\`--'   \`----'\`--'    ${endColour}"
    sleep 0.05
    echo -e "${turquoiseColour}                                              ${endColour}${yellowColour}(${endColour}${grayColour}By ${endColour}${purpleColour}Lucifer${endColour}${yellowColour})${endColour}"
}

function install_zsh_plugins() {
    echo -e "\n${purpleColour}[*] Installing ZSH plugins...${endColour}"
    
    # Install zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
        echo -e "${yellowColour}[*] Installing zsh-syntax-highlighting...${endColour}"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    else
        echo -e "${greenColour}[+] zsh-syntax-highlighting already installed${endColour}"
    fi
    
    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        echo -e "${yellowColour}[*] Installing zsh-autosuggestions...${endColour}"
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    else
        echo -e "${greenColour}[+] zsh-autosuggestions already installed${endColour}"
    fi
    
    # Install history-substring-search
    if [ ! -d "${ZSH_CUSTOM}/plugins/history-substring-search" ]; then
        echo -e "${yellowColour}[*] Installing history-substring-search...${endColour}"
        git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM}/plugins/history-substring-search"
    else
        echo -e "${greenColour}[+] history-substring-search already installed${endColour}"
    fi
}

function install_zsh_packages() {
    echo -e "\n${purpleColour}[*] Installing ZSH and related packages for Debian...${endColour}"
    
    # Install ZSH and required packages
    sudo apt-get install -y zsh fonts-powerline
    
    # Set ZSH as default shell (only if not already set)
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        echo -e "${yellowColour}[*] Setting ZSH as default shell...${endColour}"
        chsh -s $(which zsh)
    fi
}

function configure_ohmyzsh() {
    echo -e "\n${purpleColour}[*] Configuring Oh My Zsh...${endColour}"
    
    # Clean previous installation if exists
    if [ -d "$OH_MY_ZSH_DIR" ]; then
        echo -e "${yellowColour}[*] Removing previous Oh My Zsh installation...${endColour}"
        rm -rf "$OH_MY_ZSH_DIR"
    fi
    
    # Install Oh My Zsh
    echo -e "${yellowColour}[*] Installing Oh My Zsh...${endColour}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Verify installation
    if [ ! -f "$OH_MY_ZSH_DIR/oh-my-zsh.sh" ]; then
        echo -e "${redColour}[!] Oh My Zsh installation failed, trying alternative method...${endColour}"
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_DIR"
        cp "$OH_MY_ZSH_DIR/templates/zshrc.zsh-template" "$HOME/.zshrc"
    fi
    
    # Install plugins
    install_zsh_plugins
}

function configure_powerlevel10k() {
    echo -e "\n${purpleColour}[*] Configuring Powerlevel10k...${endColour}"
    
    # Install Powerlevel10k theme
    if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
    fi
    
    # Create optimized .zshrc configuration
    echo -e "${yellowColour}[*] Creating optimized .zshrc configuration...${endColour}"
    cat > ~/.zshrc << 'EOF'
# Debian-Optimized ZSH Configuration

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    history-substring-search
    sudo
    systemd
    debian
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load plugins manually if they weren't loaded by oh-my-zsh
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
fi

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Debian-specific aliases and functions
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias clean='sudo apt autoremove && sudo apt clean'
alias search='apt search'

# Improved ls commands
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cat='bat'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Fix for Debian terminal issues
export TERM="xterm-256color"

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Key bindings for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
EOF

    # Create default .p10k.zsh if not exists
    if [ ! -f ~/.p10k.zsh ]; then
        echo -e "${yellowColour}[*] Creating default Powerlevel10k configuration...${endColour}"
        cat > ~/.p10k.zsh << 'EOF'
# Powerlevel10k Configuration for Debian

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      os_icon
      dir
      vcs
      newline
      prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status
      command_execution_time
      background_jobs
      context
      time
  )

  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate

  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=39

  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160

  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=66
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''

  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=178
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=196
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=244
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '

  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
EOF
    fi
}

function configure_root_zsh() {
    echo -e "\n${purpleColour}[*] Configuring ZSH for root...${endColour}"
    
    # Install Oh My Zsh for root
    sudo rm -rf /root/.oh-my-zsh
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install Powerlevel10k for root
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
    
    # Install plugins for root
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    
    # Create root .zshrc
    sudo tee /root/.zshrc > /dev/null << 'EOF'
# Root ZSH Configuration for Debian

export ZSH="/root/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    sudo
    systemd
    debian
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Manually load plugins if needed
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Safety aliases for root
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'

# Clear screen shortcut
alias c='clear'

# Colorful ls
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'

# Set prompt color to red for root
PROMPT="%F{red}%n@%m %~ %#%f "

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory
EOF

    # Create minimal .p10k.zsh for root
    sudo tee /root/.p10k.zsh > /dev/null << 'EOF'
# Minimal Powerlevel10k config for root

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir newline prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
  
  typeset -g POWERLEVEL9K_MODE=ascii
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=1
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ROOT_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ROOT_CONTENT_EXPANSION='#'

  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
EOF
}

function setup_terminal_environment() {
    echo -e "\n${blueColour}[*] Setting up terminal environment...${endColour}"
    
    install_zsh_packages
    configure_ohmyzsh
    configure_powerlevel10k
    configure_root_zsh
    
    echo -e "\n${greenColour}[+] Terminal environment configured successfully${endColour}"
    echo -e "${yellowColour}[!] You may need to log out and back in for changes to take effect${endColour}"
}

function create_eth_script(){
    echo -e "\n${purpleColour}[*] Creating ethernet_status.sh script...${endColour}"
    
    mkdir -p ~/.config/polybar/shapes/scripts/
    
    cat > ~/.config/polybar/shapes/scripts/ethernet_status.sh << 'EOF'
#!/bin/bash

COLOR_CONNECTED="#ffffff"
COLOR_DISCONNECTED="#aaaaaa"
ICON_CONNECTED=""
ICON_DISCONNECTED=""

interface=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

if [ -n "$interface" ]; then
    ip=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    
    if [ -n "$ip" ]; then
        echo "%{F$COLOR_CONNECTED}$ICON_CONNECTED %{F$COLOR_CONNECTED}$ip%{F-}"
    else
        echo "%{F$COLOR_DISCONNECTED}$ICON_DISCONNECTED%{F-} No IP"
    fi
else
    echo "%{F$COLOR_DISCONNECTED}$ICON_DISCONNECTED%{F-} Disconnected"
fi
EOF

    chmod +x ~/.config/polybar/shapes/scripts/ethernet_status.sh
}

function create_vpn_script(){
    echo -e "\n${purpleColour}[*] Creating vpn_status.sh script...${endColour}"
    
    mkdir -p ~/.config/polybar/shapes/scripts/
    
    cat > ~/.config/polybar/shapes/scripts/vpn_status.sh << 'EOF'
#!/bin/bash

COLOR_CONNECTED="#ffffff"
COLOR_DISCONNECTED="#aaaaaa"
ICON_CONNECTED=""
ICON_DISCONNECTED=""

if ip a | grep -q tun0; then
    vpn_ip=$(ip -4 addr show tun0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    echo "%{F$COLOR_CONNECTED}$ICON_CONNECTED %{F$COLOR_CONNECTED}$vpn_ip%{F-}"
else
    echo "%{F$COLOR_DISCONNECTED}$ICON_DISCONNECTED%{F-} Disconnected"
fi
EOF

    chmod +x ~/.config/polybar/shapes/scripts/vpn_status.sh
}

function create_htb_script(){
    echo -e "\n${purpleColour}[*] Creating htb_target.sh script...${endColour}"
    
    mkdir -p ~/.config/polybar/shapes/scripts/
    touch ~/.config/polybar/shapes/scripts/target
    
    cat > ~/.config/polybar/shapes/scripts/htb_target.sh << 'EOF'
#!/bin/bash

COLOR_ACTIVE="#ffffff"
COLOR_INACTIVE="#aaaaaa"
ICON_TARGET="什"

target_file="$HOME/.config/polybar/shapes/scripts/target"

if [ -f "$target_file" ]; then
    ip_target=$(awk '{print $1}' "$target_file" 2>/dev/null)
    name_target=$(awk '{print $2}' "$target_file" 2>/dev/null)

    if [ -n "$ip_target" ] && [ -n "$name_target" ]; then
        echo "%{F$COLOR_ACTIVE}$ICON_TARGET %{F$COLOR_ACTIVE}$ip_target - $name_target%{F-}"
    elif [ -n "$ip_target" ]; then
        echo "%{F$COLOR_ACTIVE}$ICON_TARGET %{F$COLOR_ACTIVE}$ip_target%{F-}"
    else
        echo "%{F$COLOR_INACTIVE}$ICON_TARGET%{F-} No target"
    fi
else
    echo "%{F$COLOR_INACTIVE}$ICON_TARGET%{F-} No target"
fi
EOF

    chmod +x ~/.config/polybar/shapes/scripts/htb_target.sh
}

function configure_rofi() {
    echo -e "\n${purpleColour}[*] Configuring Rofi with ThinkPad theme...${endColour}"
    
    mkdir -p ~/.config/rofi
    
    cat > ~/.config/rofi/config.rasi << 'EOF'
/* Tema Rofi ThinkPad - Colores rojizos */
configuration {
    modi:           "drun,run,window";
    show-icons:     true;
    icon-theme:     "Papirus-Dark";
    font:           "Hack Nerd Font 12";
}

* {
    /* Colores base */
    background:     #2a1a1aFF;
    foreground:     #e0a0a0FF;
    border-color:   #c05050FF;
    selected:       #c05050FF;
    
    /* Elementos activos/inactivos */
    active-background: #3a2020FF;
    active-foreground: #ff9090FF;
    urgent-background: #5a3030FF;
    urgent-foreground: #e07070FF;
    
    /* Componentes */
    background-color:   @background;
    text-color:         @foreground;
    button-background:  #3a2020FF;
    button-foreground:  #d0b0b0FF;
    
    /* Listado */
    list-background:    @background;
    list-foreground:    @foreground;
    
    /* Modo ventana */
    window-background:  @background;
    window-foreground:  @foreground;
}

#window {
    background-color: @background;
    border:           2px;
    border-color:     @border-color;
    border-radius:    8px;
    padding:          20px;
}

#inputbar {
    children:         [prompt, entry];
    background-color: #3a2020FF;
    border-radius:    6px;
    padding:          8px;
}

#entry {
    text-color:       @foreground;
}

#listview {
    lines:            8;
    padding:          8px;
    spacing:          4px;
}

#element {
    padding:          6px;
    text-color:       @foreground;
}

#element.selected {
    background-color: @selected;
    text-color:       #ffffffFF;
    border-radius:    6px;
}

#element-text {
    text-color:       inherit;
}
EOF

    # Configure Windows+D shortcut in sxhkd
    if [ -f ~/.config/sxhkd/sxhkdrc ]; then
        echo -e "\n${yellowColour}[*] Configuring Windows+D shortcut for Rofi in sxhkd...${endColour}"
        if ! grep -q "super + d" ~/.config/sxhkd/sxhkdrc; then
            echo -e "\n# Launch Rofi" >> ~/.config/sxhkd/sxhkdrc
            echo "super + d" >> ~/.config/sxhkd/sxhkdrc
            echo "    rofi -show drun" >> ~/.config/sxhkd/sxhkdrc
        else
            echo -e "${greenColour}[+] Windows+D shortcut already configured in sxhkd${endColour}"
        fi
    else
        echo -e "${yellowColour}[!] sxhkd config file not found, cannot configure Windows+D shortcut${endColour}"
    fi
}

function main_install(){
    banner
    
    if [ "$user" == "root" ]; then
        echo -e "\n\n${redColour}[!] You shouldn't run this script as root!\n${endColour}"
        exit 1
    fi

    echo -e "\n\n${blueColour}[*] Installing required packages...\n${endColour}"
    sudo apt-get update
    sudo apt-get install -y kitty rofi feh xclip ranger i3lock scrot scrub wmname imagemagick cmatrix htop neofetch python3-pip procps tty-clock fzf lsd bat pamixer flameshot fonts-font-awesome fonts-noto-color-emoji
    
    echo -e "\n${blueColour}[*] Installing dependencies for bspwm, polybar and picom...\n${endColour}"
    sudo apt-get install -y build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libuv1-dev cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

    echo -e "\n${blueColour}[*] Installing and configuring tools...\n${endColour}"
    mkdir -p ~/tools && cd ~/tools
    
    # Install bspwm
    git clone https://github.com/baskerville/bspwm.git && cd bspwm && make -j$(nproc) && sudo make install && sudo apt-get install -y bspwm && cd ..
    
    # Install sxhkd
    git clone https://github.com/baskerville/sxhkd.git && cd sxhkd && make -j$(nproc) && sudo make install && cd ..
    
    # Install polybar
    git clone --recursive https://github.com/polybar/polybar && cd polybar && mkdir build && cd build && cmake .. && make -j$(nproc) && sudo make install && cd ../../
    
    # Install picom
    git clone https://github.com/ibhagwan/picom.git && cd picom && git submodule update --init --recursive && meson --buildtype=release . build && ninja -C build && sudo ninja -C build install && cd ..

    # Setup terminal environment
    setup_terminal_environment
    
    # Configure Rofi
    configure_rofi
    
    echo -e "\n${blueColour}[*] Setting up files and permissions...\n${endColour}"
    mkdir -p "$fdir" && cp -rv $dir/fonts/* "$fdir" 2>/dev/null || echo -e "${yellowColour}[!] Fonts directory not found${endColour}"
    mkdir -p ~/Wallpapers && cp -rv $dir/wallpapers/* ~/Wallpapers 2>/dev/null || echo -e "${yellowColour}[!] Wallpapers directory not found${endColour}"
    cp -rv $dir/config/* ~/.config/ 2>/dev/null || echo -e "${yellowColour}[!] Config directory not found${endColour}"
    
    # Create Polybar scripts
    create_eth_script
    create_vpn_script
    create_htb_script
    
    # Set permissions
    chmod -R +x ~/.config/bspwm/ 2>/dev/null
    chmod +x ~/.config/polybar/launch.sh 2>/dev/null
    chmod +x ~/.config/polybar/shapes/scripts/* 2>/dev/null
    
    # Install whichSystem.py if exists
    if [ -f "$dir/scripts/whichSystem.py" ]; then
        sudo cp -v $dir/scripts/whichSystem.py /usr/local/bin/
        sudo chmod +x /usr/local/bin/whichSystem.py
    fi
    
    # Update font cache
    fc-cache -fv
    
    echo -e "\n${greenColour}[+] Environment fully configured :D\n${endColour}"
    
    # Cleanup
    rm -rfv ~/tools
    rm -rfv $dir
    
    # Ask for reboot
    while true; do
        echo -en "\n${yellowColour}[?] A reboot is required. Reboot now? ([y]/n) ${endColour}"
        read -r
        REPLY=${REPLY:-"y"}
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "\n\n${greenColour}[+] Rebooting system...\n${endColour}"
            sleep 1
            sudo reboot
        elif [[ $REPLY =~ ^[Nn]$ ]]; then
            exit 0
        else
            echo -e "\n${redColour}[!] Invalid answer, please try again\n${endColour}"
        fi
    done
}

# Execute main installation
main_install