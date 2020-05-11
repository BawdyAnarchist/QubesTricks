#!/bin/bash

## This script creates and adds the lines required by i3 config for modes and keybindings
## Edit the i3gen_setup file to change modes, bindings, VMs, and commands.

config='/home/user/.config/i3/config'
vmlist=$(sed '/END OF VM LIST/, $d' i3gen_setup | sed '/^$/d' | grep -v "#")
dom0_commands=$(sed '1,/END OF VM LIST/d' i3gen_setup | sed '/^$/d' | grep -v "#")
qubeselect=$(grep -oe '^bindsym [^(\s|\t)]* mode "qubeselect"' i3gen_setup)
wc=$(echo "$vmlist" | wc -l)

initialize_config() {				## Initialize config by deleting old lines, creating new 
	sed -i '/QUBES i3gen USER CONFIGURED MODES AND EXEC KEY BINDINGS/,$d' "$config"
	printf "%b" "##  QUBES i3gen USER CONFIGURED MODES AND EXEC KEY BINDINGS  ##\n" \
	       "##  EDIT THE i3gen_setup FILE TO MAKE CHANGES  ##\n\n\n"  >> "$config"
}

qubeselect() { 					## Creates the first level binding mode
	printf "%b" "##  FIRST LEVEL BINDING MODE  ##" "\n"  >> "$config"
	printf "%b" "\n" "$qubeselect" "\n\n"  >> "$config"
	printf "%b" "mode \"qubeselect\" {"  >>  "$config"

   for ((loop=1; loop <= "$wc"; loop++)); do 		
	local vm=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $1}')
        local sym=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $3}')
        local group=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $2}')
	local check=$(grep "bindsym $sym mode \"$group\"" "$config")
	
	if [ "$group" = "none" ]; then			## VMs without a grouped bindsym get directly mapped at the first level
                printf "%b" "\n\t" "bindsym ${sym} mode \"${vm}\""  >> "$config"
	elif [ -z "$check" ] ; then 			## If not existing, create bindsym for second level group binding mode
                printf "%b" "\n\t" "bindsym ${sym} mode \"${group}\""  >> "$config"
	fi
   done
	printf "%b" "\n\t" "bindsym Return mode \"default\"" "\n\t" \
	       "bindsym Escape mode \"default\"" "\n" "}\n\n"  >> "$config"
}

groupmode() {					## Prints the header, close, and escapes for each 2nd level binding mode group
	printf "%b" "##  SECOND LEVEL, GROUPED MODE KEYBINDINGS  ##" "\n\n"  >> "$config"
   for ((loop=1; loop <= "$wc"; loop++)); do
	local group=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $2}')
	local check=$(grep "mode \"$group\" {" ""$config"")

	if [ "$group" != "none" -a -z "$check" ]; then   	
			printf "%b" "\t" "mode \"$group\" {" "\n"  >> "$config"
			printf "%b" "\t\t" "bindsym Return mode \"default\"" "\n"   >> "$config"
			printf "%b" "\t\t" "bindsym Escape mode \"default\"" "\n}\n\n"   >> "$config"
	fi		
   done
}

group_populate() {				## Populates the body of each group mode with VM mode mappings
   for ((loop=1; loop <= "$wc"; loop++)); do
        local vm=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $1}')
        local sym=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $4}')
        local group=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $2}')
	local check=$(grep "mode \"$group\" {" ""$config"")

	if [ "$group" != "none" ]; then	
		sed -i "/$check/ a \\\t\tbindsym $sym mode \"$vm\"" "$config"	
	fi
   done
}

vmgen() {					## Generates the actual exec command lines for each VM mode
	printf "%b" "##  VM KEYBINDINGS FOR EXEC COMMANDS  ##" "\n\n"  >> "$config"

   for ((loop=1; loop <= "$wc"; loop++)); do
	local vm=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $1}')
	local progs=$(sed -n ${loop}p <<<"$vmlist" | awk '{print $5}' | sed 's/,/ /g')
	printf "%b" "mode \"$vm\" {"  >>  "$config"

	for p in $progs; do			## Searches for alias, and replaces with full command
		sym=$(grep -P "^${p}" <<<"$dom0_commands" | awk '{print $2}')
		passed_command=$(grep -P "^${p}" <<<"$dom0_commands" | sed 's,^[^( |\t)]*[ |\t]*[^( |\t)]*[ |\t]*,,' | sed "s,\$vm,${vm},")
		if [ -n "$sym" ]; then	
			printf "%b" "\n\t bindsym $sym exec $passed_command , mode \"default\"" >> "$config"; else
			printf "%b" "\n\t\t## COMMAND \"$p\" NOT FOUND IN i3gen_setup file"  >> "$config"
		fi
	done
	printf "%b" "\n\tbindsym Return mode \"default\"" \
          "\n\tbindsym Escape mode \"default\"" "\n}\n\n"  >> "$config"
   done
}

main() {
initialize_config
qubeselect
groupmode	
group_populate
vmgen
}

main
