### config_mods

Review the config_mods file, and merge it with your i3 config. There's extra workspaces, expanded key bindings, and a couple fixes/improvements (commented). 

### i3gen

Qubes + i3 is a great combo. However, there's a problem -- you're likely to run out of keyboard space for key bindings, with numerous VM/command pairs. You can hobble along with the D-menu ... Or you can use i3gen to auto-generate these pairs.  Edit `i3gen.conf` to specify VM/command pairs, then run i3gen.sh to apply to your main config. 

*!!IMPORTANT!! i3gen.sh will append at the bottom of your config. DO NOT put any configs below the auto-generated lines. Place them *ABOVE* these lines, or they'll end up getting deleted.*

#### How It Works

1. In `i3gen.conf`, specify a $mod+key by which you will enter VM-Select mode.
2. Inside VM-Select mode, choose a VM in which to run a command. 
3. This takes you to the VM-Command mode, where you make a final command selection.
4. dom0 then uses qvm-run to execute the command inside the VM

I recommend using the number keys for commands common to all VMs: start, stop, restart, xterm, popup command, GUI file manager, and others. 

There's a slight nuance with VM groupings. I had too many VMs with similar names, and couldn't fit them all in the VM-Select mode. So there's an intermediate mode, as defined by the column: GROUP. In the VM-Command mode, you'll first select the GROUP, and *then* you select the VM. If you don't want a VM to be under a group, put "-" or "none" in the GROUP column.


### qubes-i3-scripts

These scripts are an expansion on `/usr/bin/qubes-i3-sensible-terminal` . They simplify the launch of generic programs common to all VMs. Described below. 

They also need to be copied to dom0, which requires a special command, since files can't be directly copied to dom0: 

``````````````` 
qvm-run --pass-io <VM-source> 'cat /path/to/qubes-i3-user-terminal' > /usr/local/bin/qubes-i3-user-terminal
``````````````` 

#### qubes-i3-user-terminal
Launches a terminal in the target VM.  It launches the first discovered terminal emulator, in the order contained in the script's 'for loop'.

#### qubes-i3-user-browser
Launches web browser in the target VM.  It launches the first discovered web browser, in the order contained in the script's 'for loop'.

#### qubes-i3-user-filemgr
Launches file manager in the target VM.  It launches the first discovered file manager, in the order contained in the script's 'for loop'.

#### qubes-i3-user-command
Basically the same as `Run command in qube` , but designed for use as an i3 quick key. An popup xterm window accepts the command, then closes. Useful for changing DPI, or running a command inside a VM that isn't in the D-menu.

#### qubes-i3-user-update
Launches an xterm window in the VM, and runs the standard update command, depending on which template OS it is.

