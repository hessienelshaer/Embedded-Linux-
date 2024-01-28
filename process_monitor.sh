#!/usr/bin/bash -i
RED='\033[0;31m'
#GREEN='\033[0;32m'
#YELLOW='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

options=("Process Information" "Kill a Process" "Process Statistics" "Real-time Monitoring" "Search and Filter" "Set Configuration Options" "Exit")
# Display a menu and prompt the user to choose an option
select choice in "${options[@]}"; do
    case $REPLY in
    1)
        read -p "Please enter process command or ID: " input_process
        output=$(ps -eo "%c %p %P %U %C %t" | grep "${input_process}")
        if [[ -n ${output} ]]; then
            echo -e "${BOLD}${RED}COMMAND             PID    PPID USER     %CPU     ELAPSED${RESET}"
            ps -eo "%c %p %P %U %C %t" | grep "${input_process}"
        fi
        ;;
    2)
        read -p "Please enter process ID(PID) you want to kill: " input_pid
        # Check if the process is running
        if ps -p "$input_pid" >/dev/null; then
            #Logging terminated process to file
            process_data=$(ps -eo "%p %P %U %C %t %c" | grep "${input_pid}")
            date_time=$(date "+%A, %B %d, %Y %H:%M:%S")
            echo -e "Process wit id ${input_pid}is terminated at ${date_time} \ntha latest data of it:\n" >>terminated_process.txt
            echo "   PID     PPID USER     %CPU     ELAPSED COMMAND      " >>terminated_process.txt
            echo -e "${process_data}\n\n" >>terminated_process.txt
        fi
        kill -9 "${input_pid}"
        ;;
    3)
        # Display total number of processes
        processes=$(ps aux --no-heading | wc -l)
        echo "${choice}"
        echo -e "${RED}Total number of processes: ${processes} ${RESET} \n"
        #cpu load & memory usage
        (ps auxc --sort=-%cpu | head -n 20) | awk '{print $3, $4,$2 ,$11}'
        ;;
    4)
        #gnome-terminal --window --title="Process Moniter" -- /usr/bin/bash -c ls $SHELL
        #terminal -e top
        #gnome-terminal -- bash -c "ls; exec bash"
        #terminator -e " htop;" &
        gnome-terminal --title="Process live Moniter" -- bash -c "/usr/bin/htop; exec bash"
        ;;
    5)
        #select between search options
        echo "Please select your options to search or filter process"
        echo -e "1- Search by username\n2- Search by PID\n3- Search by Process name\n4- Search by most usage CPU\n5- Search by most usage Memory"
        read -rp "Your select: " select
        case "${select}" in
        1)
            read -rp "Enter the Username: " username
            ps -u "${username}"
            ;;
        2)
            read -rp "Enter the PID: " PID
            ps -P "${PID}"
            ;;
        3)
            read -rp "Enter the Process Name: " PName
            PIDs=$(pidof "${PName}")
            echo "Process ${PName} ID is ${PIDs}"

            ;;
        4)
            top_3processes_usingcpu=$(ps aux --sort=-%cpu | head -n 3)
            echo "Top processes by CPU usage:"
            echo "$top_3processes_usingcpu"
            ;;
        5)
            top_5processes_memory=$(ps aux --sort=-%mem | head -n 5)
            echo "Top processes by CPU usage:"
            echo "$top_5processes_memory"
            ;;
        *)
            echo "Error .. Please select between 1 .. 5"
            ;;
        esac
        ;;
    6)
        #set configruation file
        ;;
    7)
        exit 0
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and ${#options[@]}."
        ;;
    esac
done

#7. Resource Usage Alerts:
#Set up alerts for processes exceeding predefined resource usage thresholds.

#9. Configuration Options:
#Allow users to configure the script through a configuration file. For example, users might specify the update interval, alert thresholds, etc.
