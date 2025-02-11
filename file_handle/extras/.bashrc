#
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


export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
eval "$(starship init bash)"

f(){ 
	xdg-open . 
}

alias ci="flatpak run com.visualstudio.code"

#ci(){
 #   flatpak run com.visualstudio.code .
#}

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
