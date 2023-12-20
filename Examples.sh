#!/bin/bash

# Quick set of examples of how to do different things in bash


####################################################################################
### Select
####################################################################################

# Setting a dependency manager from a list of choices

set_dep_manager() {
choices=("NPM" "Yarn" "PNPM")
echo "Please select a Package Manager: "
select choice in "${choices[@]}"; do
    case $choice in
        "NPM")
            echo "$choice"
            break
            ;;
        "Yarn")
            echo "$choice"
            break
            ;;
        "PNPM")
            echo "$choice"
            break
            ;;
        *)
            echo "Invalid Choice"
            ;;
    esac
done

DEP_MANAGER=$choice
}

####################################################################################
### Multiselect
####################################################################################

choices=("Option 1" "Option 2" "Option 3" "Done")

    # Array to store user selections
selected_choices=()

echo "Please select your choices (enter the number). Choose 'Done' when finished:"

    # Function to check if an item is in the array
contains_element () {
  local element
  for element in "${@:2}"; do
    [[ "$element" == "$1" ]] && return 0
  done
  return 1
}

    # Show options and get user input in a loop
while true; do
    select choice in "${choices[@]}"; do
        if [[ "$choice" == "Done" ]]; then
            break 2
        elif contains_element "$choice" "${selected_choices[@]}"; then
            echo "You have already selected '$choice'"
            break
        else
            selected_choices+=("$choice")
            echo "Selected: $choice"
            break
        fi
    done
done

    # Display the selected choices
echo "You have selected the following choices:"
printf ' - %s\n' "${selected_choices[@]}"

####################################################################################

####################################################################################
### INPUT
####################################################################################

# Single line user input -p=print and store it to a variable

read -p "Script E monorepo builder: " PROJECT_NAME


####################################################################################
### CONDITIONALS
####################################################################################

####################################################################################
### IF CONDITIONALS
####################################################################################

####################################################################################
### FOR CONDITIONALS
####################################################################################

####################################################################################
### DO / WHILE CONDITIONALS
####################################################################################