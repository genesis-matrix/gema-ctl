#!/bin/bash
## from https://github.com/filisko/vagrant-simple-manager ##

declare -r TITLE="Vagrant simple manager v1.0"

if ! which vagrant >/dev/null; then
    zenity --warning --title="$TITLE" --text="Vagrant is not installed! Install it first please."
    exit
fi

# Get machines
function get_machines() {
    vagrant global-status | tail -n+3 | head -n -7
}

# Refresh machines to later get them
function refresh_machines() {
    # refresh cached machines
    for machine_id in $(get_machines | awk '{print $1}')
    do
        vagrant status $machine_id
    done
}

# Get machine path (used for SSH)
function get_machine_path() {
    get_machines | grep "$1" | awk '{print $5}'
}

# Get machine status (used to detect which actions are possible)
function get_machine_status() {
    get_machines | grep "$1" | awk '{print $4}'
}

# Check whether a machine is running or not
function is_machine_on() {
    if [ $(get_machine_status "$1") = 'running' ]; then
        echo '1'
    fi
}

# Variables
declare machines
declare loaded

while true; do
    # refresh vagrant machines list only first time
    if [ -z "$loaded" ]; then
        (
            refresh_machines
        ) |
        zenity --progress \
          --title="$TITLE" \
          --text="Loading fresh list of vagrant machines ..." \
          --pulsate \
          --no-cancel \
          --auto-close

        loaded="1"
        machines=$(get_machines)

        if [ -z "$machines" ]; then
            zenity --warning --title="$TITLE" --text="You don't have any vagrant machine!"
            exit
        fi
    fi

	id=$(zenity --list \
		--title="$TITLE" \
		--text="List of your current vagrant machines." \
		--column="ID" \
		--column="Name" \
		--column="Engine" \
		--column="State" \
		--column="Path" \
		--hide-column=3 \
		--width="650" --height="250" \
        --extra-button="About" \
        --extra-button="Vagrant version" \
		--cancel-label="Exit" \
		--ok-label="Manage" \
		$machines)

      case $? in
        0)
            if ! [ -z $id ]; then
              while true; do
                    declare -a actions
                    if [ $(is_machine_on "$id") ]; then
                        actions=("Stop" "Restart" "SSH")
                    else
                        actions=("Start")
                    fi

                    action=$(zenity --list --height="220" --width="300" \
                        --title="$TITLE" \
                        --text="Select an action." \
                        --column="Action" \
                        --cancel-label="Go back" \
                        --extra-button="Exit" \
                        --ok-label="Execute" \
                        ${actions[*]})

                    case $? in
                        0)
                            if ! [ -z $action ]; then
                                case $action in
                                    'Start')
                                        (
                                            vagrant up "$id"
                                            echo "# Machine successfully started!" ;
                                            echo "100"
                                        ) |
                                        zenity --progress --width="230" \
                                          --title="Start Vagrant machine" \
                                          --text="Starting machine ..." \
                                          --pulsate --no-cancel

                                        if [ "$?" = -1 ] ; then
                                            zenity --error \
                                              --text="Update canceled."
                                        fi
                                    ;;
                                    'Stop')
                                        (
                                            vagrant halt "$id"
                                            echo "# Machine successfully stopped!" ;
                                            echo "100"
                                        ) |
                                        zenity --progress --width="230" \
                                          --title="Stop Vagrant machine" \
                                          --text="Stopping machine ..." \
                                          --pulsate --no-cancel
                                    ;;
                                    'Restart')
                                        (
                                            vagrant reload "$id"
                                            echo "# Machine successfully restarted!" ;
                                            echo "100"
                                        ) |
                                        zenity --progress --width="230" \
                                          --title="Restart Vagrant machine" \
                                          --text="Restarting machine ..." \
                                          --pulsate --no-cancel
                                    ;;
                                    'SSH')
                                        path="$(get_machine_path $id)"
                                        cd "$path"
                                        x-terminal-emulator -e "vagrant ssh -- -t '/bin/bash'" &
                                    ;;
                                esac
                            else
                                zenity --info --title="$TITLE" --text="Please select an action."
                            fi
                        ;;

                        1)
                            if [ "$action" = 'Exit' ]; then
                                exit
                            else
                                break
                            fi
                        ;;
                    esac
              done
          else
              zenity --info --title="$TITLE" --text="Please select a vagrant machine."
          fi
        ;;
        1)
            case $id in
                'Vagrant version')
                    version=$(vagrant version | grep -P '([0-9]+\.[0-9]+\.[0-9]+)' -o --color=never)
                    zenity --info --title="$TITLE" --text="Vagrant version: <b>$version</b>"
                ;;
                'About')
                    zenity --info --ellipsize --title="$TITLE" --text="This project is hosted on GitHub. Ideas, suggestions, etc. see:\nhttps://github.com/filisko/vagrant-simple-manager"
                ;;
                *)
                    exit
                ;;
            esac
        ;;
      esac
done
