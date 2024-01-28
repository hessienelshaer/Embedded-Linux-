#!/usr/bin/bash
if [ $# -eq 0 ]; then
    echo "Error no input, please enter the directory .."
    exit 1
elif [ $# -eq 1 ]; then
    IFS=$'\n'
    #Get list of files from the input directory with hidden files (-A)
    filenames="$(ls -Ab "$1")"
    declare -a files_array
    #Convert list to array
    files_array=($filenames)
    IFS=" "
    #Debugging the output array
    #declare -p files_array
    #echo "${#files_array[@]}"
    #echo "${files_array[@]}"

    #Organizing files based on its type
    for file_name in "${files_array[@]}"; do
        #Handle non extention files
        if [[ (${file_name} != *"."*) && (-f "$1/${file_name}") ]]; then
            if [ -d "$1/misc" ]; then
                mv "$1/${file_name}" "$1/misc"
            else
                mkdir -p "$1/misc"
                mv "$1/${file_name}" "$1/misc"
            fi
        elif [[ (${file_name} = *"."*) && (-f "$1/${file_name}") ]]; then
            #Extrtact file extention
            file_extention=${file_name##*.}
            case "${file_extention}" in
            sh)
                if [ -d "$1/Bash Codes" ]; then
                    mv "$1/${file_name}" "$1/Bash Codes"
                else
                    mkdir -p "$1/Bash Codes"
                    mv "$1/${file_name}" "$1/Bash Codes"
                fi
                ;;
            txt)
                if [ -d "$1/Text Files" ]; then
                    mv "$1/${file_name}" "$1/Text Files"
                else
                    mkdir -p "$1/Text Files"
                    mv "$1/${file_name}" "$1/Text Files"
                fi
                ;;
            jpg)
                if [ -d "$1/jpg images" ]; then
                    mv "$1/${file_name}" "$1/jpg images"
                else
                    mkdir -p "$1/jpg images"
                    mv "$1/${file_name}" "$1/jpg images"
                fi
                ;;
            cpp)
                if [ -d "$1/Cpp Codes" ]; then
                    mv "$1/${file_name}" "$1/Cpp Codes"
                else
                    mkdir -p "$1/Cpp Codes"
                    mv "$1/${file_name}" "$1/Cpp Codes"
                fi
                ;;
            py)
                if [ -d "$1/Python Codes" ]; then
                    mv "$1/${file_name}" "$1/Python Codes"
                else
                    mkdir -p "$1/Python Codes"
                    mv "$1/${file_name}" "$1/Python Codes"
                fi
                ;;
            pdf)
                if [ -d "$1/Pdf Files" ]; then
                    mv "$1/${file_name}" "$1/Pdf Files"
                else
                    mkdir -p "$1/Pdf Files"
                    mv "$1/${file_name}" "$1/Pdf Files"
                fi
                ;;
            *)
                if [ -d "$1/misc" ]; then
                    mv "$1/${file_name}" "$1/misc"
                else
                    mkdir -p "$1/misc"
                    mv "$1/${file_name}" "$1/misc"
                fi
                ;;
            esac
        #Handle Sub-directories
        elif [ -d "$1/${file_name}" ]; then
            'true'
        fi
    done
else
    echo "Error too many arguments .. please enter one directory .."
    exit 1
fi
