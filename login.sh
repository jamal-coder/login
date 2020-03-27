#!/bin/bash

# ---------------------- Variables
myFile=".pass.bat"
pass1="a"
pass2="b"
name=""
pass=""
sname=""
spass=""

# ---------------------- Functions
function asking {
	if [[ $1 == "name" ]]; then
		read -p "$2" val
	fi
	if [[ $1 == "pass" ]]; then
		#echo -n "$2 :"
		read -sp "$2" val
	fi
	echo "$val"
}

# --------------------- Search Record
function searchRecord {
	if [[ $1 == "N" ]]; then
		sterm=$(grep "$2" $myFile | awk -F : '{print $1}')
	fi
	if [[ $1 == "P" ]]; then
		sterm=$(grep "$2" $myFile | awk -F : '{print $2}')
	fi
	echo "$sterm"
}
# --------------------- Loggedin
function Loggedin {
	clear
	echo "You are logged In!"
	exit
}
# --------------------- Create files if not exsists
if [[ ! -e $myFile ]]; then
	touch $myFile
fi


clear
# Asking User for User Name
name=$(asking "name" "Enter Your User Name : ")

# Search for the entered user name in the database
sname=$(searchRecord "N" "$name")
# Stores the password for reference and record
spass=$(searchRecord "P" "$name")


# Check if the user name exists in database then ask for the password
# Otherwise ask the user for creating new user
if [[ "$name" == "$sname" ]]; then
	# If user exists then asking for the password
	pass=$(asking "pass" "Enter your Password : ")
	
	# If user name and password are valid then login
	if [[ "$sname" == "$name" && "$spass" == "$pass" ]]; then
		Loggedin
	else
		for count in {1..3}; do
			echo
			echo "Invalid Password, try again"
			pass=$(asking "pass" "Enter Your Password : ")
			if [[ "$sname" == "$name" && "$spass" == "$pass" ]]; then
				Loggedin
			fi
		done
	fi
elif [[ "${#name}" -eq 0 ]]; then
	echo "You didn't enter User Name"
	exit
else
	echo "Invalid User Name"
	choice=$(asking "name" "Do you want to create a new User [Y-N] : ")
	if [[ $choice == [Yy] ]]; then
		# If Username already exists then ask for new User name
		if [[ $name == $sname ]]; then
			while [[ $name != "$sname" ]]; do
				echo "User already exists : $name"
				# Ask for new User name
				name=$(asking "name" "Enter New User Name : ")
				sname=$(searchRecord "N" "$name")
			done
		else
			while [[ $pass1 != $pass2 ]]; do
				pass1=$(asking "pass" "Enter New Password : ")
				echo
				pass2=$(asking "pass" "Type again your password for confirmation : ")
				echo
				if [[ $pass1 == $pass2 ]]; then
					echo "$name:$pass1:" >> $myFile
					echo "Information Saved in database"
					exit
				else
					echo "Your password could not confirmed, try again"
					asking "pass" "Press Enter"
				fi
			done
		fi
	else
		echo "Goodbye, Take Care!"
	fi
fi



