#!/bin/bash

clear

cp -Ru . ~/ado-in-codespaces

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CACHE_FILE_PATH=~/.ado-in-codespaces-cache

if [ -f $CACHE_FILE_PATH ]; then
    source $CACHE_FILE_PATH
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

source "$SCRIPT_DIR/lib/colors.sh"

if [ -f ~/.cs-environment ]; then
    source ~/.cs-environment
fi

if [ -n $ADO_PAT ]; then
    NONINTERACTIVE=true
fi

GREETINGS=("Bonjour" "Hello" "Salam" "Привет" "Вітаю" "Hola" "Zdravo" "Ciao" "Salut" "Hallo" "Nǐ hǎo" "Xin chào" "Yeoboseyo" "Aloha" "Namaskaram" "Wannakam" "Dzień dobry")
GREETING=${GREETINGS[$RANDOM % ${#GREETINGS[@]} ]}

echo -e $PALETTE_WHITE"\n
        ~+

                 *       +
           '                  |
         +   .-.,=\"\`\`\"=.    - o -
             '=/_       \     |
          *   |  '=._    |   
               \     \`=./\`,        '
            .   '=.__.=' \`='      *
   +                         +
        O      *        '       .
"$PALETTE_RESET

echo -e $PALETTE_GREEN"\n\n     🖖 👽  $GREETING, Codespacer 👽 🖖\n"$PALETTE_RESET

if [ -z "$NONINTERACTIVE" ]; then
    sleep 1s
fi

echo -e $PALETTE_PURPLE"\n🏃 Lets setup the Codespace"$PALETTE_RESET

if [ -z "$NONINTERACTIVE" ]; then
    sleep 0.25s
fi

if [ -z "$VSCLK_CORE_URL" ]; then

    unset VSCLK_CORE_URL_SUFFIX;
    if [ -z "$VSCLK_CORE_URL" ]; then
        VSCLK_CORE_URL_SUFFIX=""
    else
        VSCLK_CORE_URL_SUFFIX=$PALETTE_CYAN"(➥ to reuse *$VSCLK_CORE_URL*)"$PALETTE_RESET
    fi

    echo -e $PALETTE_CYAN"\n- Please provide your ADO repo URL\n"$PALETTE_RESET

    printf " ↳ ADO repo URL$VSCLK_CORE_URL_SUFFIX: $PALETTE_PURPLE"

    read VSCLK_CORE_URL_INPUT

    echo -e " $PALETTE_RESET"

    if [ -z "$VSCLK_CORE_URL_INPUT" ]; then
        if [ -z "$VSCLK_CORE_URL" ]; then
            echo -e $PALETTE_RED"  🧱 No link - no {tbd}"$PALETTE_RESET
            exit 1
        else
            VSCLK_CORE_URL_INPUT=$VSCLK_CORE_URL
            echo -e $PALETTE_DIM"  * reusing *$VSCLK_CORE_URL_INPUT* as ADO repo URL.\n"$PALETTE_RESET
        fi
    fi

    if [ "$VSCLK_CORE_URL" != "$VSCLK_CORE_URL_INPUT" ]; then
        export VSCLK_CORE_URL=$VSCLK_CORE_URL_INPUT

        echo "export VSCLK_CORE_URL=$VSCLK_CORE_URL" >> $CACHE_FILE_PATH
    fi

fi

if [ -z "$ADO_PAT" ]; then
    echo -e $PALETTE_CYAN"Please provide your ADO PAT\n"$PALETTE_RESET

    # reading the PAT
    unset CHARCOUNT
    unset ADO_PAT_INPUT
    PROMPT=" ↳ PAT code[R/W] + packaging[R]: "

    stty -echo

    CHARCOUNT=0
    while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
    do
        # Enter - accept password
        if [[ $CHAR == $'\0' ]] ; then
            break
        fi

        # Backspace
        if [[ $CHAR == $'\177' ]] ; then
            if [ $CHARCOUNT -gt 0 ] ; then
                CHARCOUNT=$((CHARCOUNT-1))
                PROMPT=$'\b \b'
                ADO_PAT_INPUT="${PASSWORD%?}"
            else
                PROMPT=''
            fi
        else
            CHARCOUNT=$((CHARCOUNT+1))
            PROMPT='*'
            ADO_PAT_INPUT+="$CHAR"
        fi
    done

    stty echo
    echo -e " "$PALETTE_RESET

    # check if PAT set
    if [ -z ${ADO_PAT_INPUT} ]; then
        echo -e $PALETTE_RED"\n  🐢  No PAT - Zero FLOPS per watt\n"$PALETTE_RESET
        exit 1
    fi

    export ADO_PAT=$ADO_PAT_INPUT

    # VSclk
    ./.codespaces/setup-vsclk.sh

    # Cascade
    ./.codespaces/setup-cascade.sh
fi