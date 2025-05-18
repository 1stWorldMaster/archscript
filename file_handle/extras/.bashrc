# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# In your .bashrc
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/cmdline-tools/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"

export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
eval "$(starship init bash)"

f(){ 
	xdg-open . 
}
cat ~/to_do

alias ci="flatpak run com.visualstudio.code"
alias notebook="code --enable-proposed-api ms-toolsai.jupyter ."
alias ff='fzf --preview="cat {}"'
alias cls="clear"
alias sml="source ~/projects/ml/venv/bin/activate"

##############################
#  Commands to get into dir
##############################
# Define the variable to store the temporary file path
VARTMP_FILE="$HOME/.vartmp"

# Function to register the current directory path
rgpt() {
    CURRENT_PATH=$(pwd)
    echo "$CURRENT_PATH" > "$VARTMP_FILE"
    echo "The current path is registered in $VARTMP_FILE as: $CURRENT_PATH"

}

# Function to navigate to the directory stored in the .vartmp file
cdpt() {
    if [ ! -f "$VARTMP_FILE" ]; then
        echo "No path registered. Please run rgpt first."
        return 1
    fi

    CURRENT_PATH=$(<"$VARTMP_FILE")
    echo "Navigating to the registered path: $CURRENT_PATH"
    cd "$CURRENT_PATH" || { echo "Failed to navigate to $CURRENT_PATH"; return 1; }
    echo "You are now in: $(pwd)"
}

mcd(){
    mkdir "$1"
    cd "$1"
}


notebook_here() {
    local  envname="$1"
    source "$envname"/bin/activate
    pip install jupyter
    touch main.ipynb
    python3 -m ipykernel install --name "$envname" --user
    code --enable-proposed-api ms-toolsai.jupyter .
    code main.ipynb
}

# The following alias are added so that a person just can copy things is temp variable easily
tmp="$HOME/temp"
alias ctmp="cat \"$tmp\""

search(){
    grep -ir "$1"
}
swap(){
	free -h
	sudo swapoff /swapfile
	sudo fallocate -l "$1"G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
}
swapoff(){
	free -h
	sudo swapoff /swapfile
	sudo rm -f /swapfile
}


notify() {
    "$@" 
    EXIT_STATUS=$? 
    source ~/.config/bash/venv/bin/activate 
    python ~/.config/bash/notify.py "$@" "$EXIT_STATUS"
    deactivate
}

runcpp() {
    if [ -z "$1" ]; then
        echo "Usage: runcpp <file.cpp>"
        return 1
    fi

    filename="${1%.cpp}"  # Remove .cpp extension
    g++ "$1" -o "$filename" && ./"$filename"
}

###########################################################
#    TMUX
###########################################################

ttmux(){
	tmux new-session -d -s my_session
	tmux split-window -h
	tmux attach-session -t my_session
}

cl() {
    cd "$1" || return  # Change to the specified directory or exit if it fails
    dir=$(pwd)  # Store the current working directory in a variable
    tmux select-pane -t 0  # Switch to pane 0
    tmux send-keys "cd '$dir' && ls" Enter  # Change to the directory in tmux and list contents
    tmux select-pane -t 1  # Switch back to pane 1
}
branch() {
  local branches new_branch
  # Add "new" option to the branch list
  branches=$(echo -e "new\n$(git branch --format='%(refname:short)')" | fzf)

  if [[ "$branches" == "new" ]]; then
    read -rp "Enter new branch name: " new_branch
    git checkout -b "$new_branch"
  elif [[ -n "$branches" ]]; then
    git checkout "$branches"
  fi
}
upgrade(){
	sudo pacman --noconfirm -Syu
	sudo pacman --noconfirm -Scc
	yay --noconfirm -Syu
	yay --noconfirm -Scc
}