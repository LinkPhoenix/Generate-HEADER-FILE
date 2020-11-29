setup_color() {
    # Only use colors if connected to a terminal
    # Thank your Oh My ZSH
    if [ -t 1 ]; then
        # https://gist.github.com/vratiu/9780109
        # https://misc.flogisoft.com/bash/tip_colors_and_formatting
        #RESET
        RESET=$(printf '\033[m')

        # Regular Colors
        BLACK=$(printf '\033[30m')
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        MAGENTA=$(printf '\033[35m')
        CYAN=$(printf '\033[36m')
        WHITE=$(printf '\033[37m')

        #BACKGROUND
        BG_BLACK=$(printf '\033[40m')
        BG_RED=$(printf '\033[41m')
        BG_GREEN=$(printf '\033[42m')
        BG_YELLOW=$(printf '\033[43m')
        BG_BLUE=$(printf '\033[44m')
        BG_MAGENTA=$(printf '\033[45m')
        BG_CYAN=$(printf '\033[46m')
        BG_WHITE=$(printf '\033[47m')

        # Formatting
        BOLD=$(printf '\033[1m')
        DIM=$(printf '\033[2m')
        ITALIC=$(printf '\033[3m')
        UNDERLINE=$(printf '\033[4m')
        BLINK=$(printf '\033[5m')
        REVERSE=$(printf '\033[7m')

    else
        RESET=""

        # Regular Colors
        BLACK=""
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        MAGENTA=""
        CYAN=""
        WHITE=""

        #BACKGROUND
        BG_BLACK=""
        BG_RED=""
        BG_GREEN=""
        BG_YELLOW=""
        BG_BLUE=""
        BG_MAGENTA=""
        BG_CYAN=""
        BG_WHITE=""

        # Formatting
        BOLD=""
        DIM=""
        ITALIC=""
        UNDERLINE=""
        BLINK=""
        REVERSE=""
    fi
}


setup_emoji(){
	CHECK_FLAG=✅
	ERROR_FLAG=❌
	SHELL_FLAG=🐚
	WARNING_FLAG=🚨
	INFORMATION_FLAG=ℹ️

	export CHECK_FLAG
	export ERROR_FLAG
	export SHELL_FLAG
	export WARNING_FLAG
	export INFORMATION_FLAG
}

launching_command() {
    echo "${SHELL_FLAG}${YELLOW}	${RESET}${BG_BLACK}${ITALIC}$ $1 $2 $3 $4 ${RESET}"
}

warning_text() {
    echo "${WARNING_FLAG} ${RED}${BOLD}$1${RESET}"
}

detect_text() {
    echo "${CHECK_FLAG} ${GREEN}${BOLD}$1${RESET}"
}

information() {
    echo "${INFORMATION_FLAG}	${YELLOW}${BOLD}$1${RESET}"
    press_any_key_to_continue
}

press_any_key_to_continue() {
    read -n 1 -s -r -p "${GREEN}${BOLD}Press any key to continue${RESET}"
    printf "\n\n"
}

ask_install_alias() {
    set -- $(locale LC_MESSAGES)
    yesptrn="$1"
    noptrn="$2"
    yesword="$3"
    noword="$4"
    while true; do

        echo ""
        read -p "${YELLOW} Do you want install alias \"$ALIAS_NAME\" in your ZSHRC ? [${yesword}/${noword}]? ${RESET}" yn
        case $yn in
        ${yesptrn##^})
			launching_command "echo alias ${ALIAS_NAME}=${ALIAS_CMD} >> ~/.zshrc"
            echo "alias ${ALIAS_NAME}=${ALIAS_CMD}" >> ~/.zshrc
            break
            ;;
        ${yesword##^})
			launching_command "echo alias ${ALIAS_CMD} >> ~/.zshrc"
            echo "alias ${ALIAS_NAME}=${ALIAS_CMD}" >> ~/.zshrc
            break
            ;;
        ${noptrn##^}) break ;;
        ${noword##^}) break ;;
        *) echo "Answer ${yesword} / ${noword}." ;;
        esac
    done
}

main() {
	setup_color
	setup_emoji
	
	PATH_SCRIPT="$HOME/.generate_header"
	export PATH_SCRIPT
	NAME_SCRIPT="generate_headerfile.sh"
	export NAME_SCRIPT
	if [ -f ${PATH_SCRIPT}/${NAME_SCRIPT} ]; then
		echo ${PATH_SCRIPT}/${NAME_SCRIPT}
		warning_text "${PATH_SCRIPT}/${NAME_SCRIPT} already exist"
	else
		launching_command "wget https://raw.githubusercontent.com/LinkPhoenix/Generate-HEADER-FILE/main/${NAME_SCRIPT} -P ${PATH_SCRIPT}"
		wget https://raw.githubusercontent.com/LinkPhoenix/Generate-HEADER-FILE/main/${NAME_SCRIPT} -P ${PATH_SCRIPT}
	fi

	ALIAS_NAME="gh"
	export ALIAS_NAME
	ALIAS_CMD="\"bash $PATH_SCRIPT/$NAME_SCRIPT\""
	export ALIAS_CMD

	ask_install_alias
	launching_command "source $HOME/.zshrc >/dev/null 2>&1"
}

main
source $HOME/.zshrc >/dev/null 2>&1
