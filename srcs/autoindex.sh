#!/bin/bash
cancel=0
echo "Do you want to turn the autoindex:"
PS3='Select nbr: '
options=("On" "Off" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "On")
            sed -i '25 s/off/on/g' /etc/nginx/sites-available/localhost
			echo "Autoindex is turned on"
			break
            ;;
        "Off")
            sed -i '25 s/on/off/g' /etc/nginx/sites-available/localhost
			echo "Autoindex is turned off"
			break
            ;;
        "Cancel")
			cancel=1
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done
if [ $cancel = 0 ]; then
	echo "Do you want to restart nginx now:"
	PS2='Select nbr: '
	options=("Yes" "No")
	select opt in "${options[@]}"
	do
		case $opt in
			"Yes")
				service nginx restart
				break
				;;
			"No")
				break
				;;
			*) echo "Invalid option $REPLY";;
		esac
	done
fi
