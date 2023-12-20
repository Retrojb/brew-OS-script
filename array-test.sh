#!/bin/bash

# Declare your array
my_array=()
read -p "Enter something to add to the array: " input


# Function to add input to the array
add_to_array() {
    my_array+=("$input")
}

this_func() {
if [[ $input == 'foo' ]]; then
    add_to_array
elif [[ $input == 'bar' ]]; then
    echo "this faults"
else
    exit 1
fi
}

# Example usage
this_func  # Call the function to add an item to the array

# Display the array contents
echo "Array contents: ${my_array[*]}"
