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
    echo "${SHELL_FLAG}${YELLOW}	${RESET}${BG_BLACK}${ITALIC}$ $1 ${RESET}"
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

write_hf() {
	launching_command "find . -name "*.c" -exec basename {} \; | tr '\n' ' '"
	find . -name "*.c" -exec basename {} \; | tr '\n' ' '
	printf "\n"
	information "Here is the list of all your .c"

	TYPE_VAR=("void" "char" "signed char" "unsigned char" \
	"short" "short int" "signed short" "signed short int" \
	"unsigned short" "unsigned short int" \
	"int" "signed int" "unsigned int" \
	"long" "long int" "signed long" "signed long int" \
	"unsigned long" "unsigned long int" \
	"long long" "long long int" "signed long long" "signed long long int" \
	"unsigned long long" "unsigned long long int" \
	"float" "double double float", "long double long", "double float" )

	information "I will write in your new HEADER FILE"
	TOTAL=${#TYPE_VAR[*]}

	for (( i=0; i<=$(( $TOTAL -1 )); i++ ))
	do 
		cat *.c | grep "^${TYPE_VAR[$i]}\t.*[)]$" | sed s'/.$/);/' >> ${HF_NAME}
	done

	TYPE_VAR_STRUCT=("size_t" "t_list")

	TOTAL=${#TYPE_VAR_STRUCT[*]}

	for (( i=0; i<=$(( $TOTAL -1 )); i++ ))
	do 
		cat *.c | grep "^${TYPE_VAR_STRUCT[$i]}\t.*[)]$" | sed s'/.$/);/' >> ${HF_NAME}
	done

	TOTAL_LINE=$(cat ${HF_NAME} | wc -l | tr -d ' ')
	information "I write ${TOTAL_LINE} function(s) in your ${HF_NAME}"
	information "I will open ${HF_NAME} and add the 42 header"
	launching_command "vim -c ":Stdheader" ${HF_NAME}"
	vim -c ":Stdheader" ${HF_NAME}
}

check_hf_exist() {
	if [[ -f ./"${HF_NAME}" ]]; then
		warning_text "${HF_NAME} already exist"
		information "I will create a backup of your HEADER FILE"
		hf_backup
		information "I will create your new HEADER FILE"
		hf_create
	else
		information "${HF_NAME} not exist"
		information "I will create your new HEADER FILE"
		hf_create
	fi
}

hf_create() {
	launching_command "touch ${HF_NAME}"
	touch ${HF_NAME}
	information "Your HEADER FILE is now create : ${HF_NAME}"
}

hf_backup() {
	HF_BACKUP_NAME="${HF_NAME}_OLD-$(date +"%F %T")"
	launching_command "mv "${HF_NAME}" "${HF_BACKUP_NAME}""
	mv "${HF_NAME}" "${HF_BACKUP_NAME}"
	information "I backup your HEADER FILE with the name ${HF_BACKUP_NAME}"
}

ask_hf_name() {
	HF_NAME=
	while true ; do
		read -p "What is the name of the Header File you want to create ? : " HF_NAME
		if [[ "$HF_NAME" == *.h ]]; then
			## HF_NAME="${HF_NAME//.h}"
			information "HEADER FILE NAME = ${HF_NAME}"
			break
		else
			HF_NAME="${HF_NAME}.h"
			information "HEADER FILE NAME = ${HF_NAME}"
			break
		fi
	done
	export HF_NAME
}

message_exit() {
    echo "${YELLOW}#######################################################${RESET}"
    echo ""
    echo "${RED}${BOLD}Thank you for using this script to the end${RESET}"
    echo "${RED}${BOLD}If you love my work you can buy me coffee${RESET}"
	printf "\n"
    echo "${YELLOW}${BOLD}URL : https://www.buymeacoffee.com/LinkPhoenix${RESET}"
    echo ""
    echo "${YELLOW}#######################################################${RESET}"
}

main() {
	setup_color
	setup_emoji

	ask_hf_name
	check_hf_exist
	write_hf
	message_exit
}

main