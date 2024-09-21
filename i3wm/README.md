### i3gen.conf 
Copy to dom0:  */home/user/.config/i3/i3gen.conf*<br>
Qubes+i3 is a great combo, but you quickly run out of key bindings with numerous VM/command pairs. This automates creation of i3 keybindings/modes, so that you can operate Qubes completely from the keyboard.
- Start/stop any qube
- Run common packages (defined by you) in any qube
- Open terminal or file manager in any qube
- Launch disposable VM based on any qube
- Launch Popup to "Run command in qube"

It might not sound like much, but you can do all these in < 1 sec, as opposed to GUI or d-menu.
Edit the file, and instructions are inside. Relatively straighforward, and highly customizable.

### config_mods
This file is intended to supplement your own i3 config. It has extra workspaces, expanded key bindings, and some improvements (commented). Review and merge with your own config.

### Touchpad tap-to-click
Copy 60-libinput.conf to dom0: */usr/share/X11/xorg.conf.d/60-libinput.conf*

### xorg.conf_sample
Copy to dom0: */etc/X11/xorg.conf*<br>
You need to edit this file with your own monitor arrangement. Instructions inside the file.

### qubes-i3-scripts
Copy scripts to to dom0 */usr/local/bin/* and make them executable `chmod +x`

#### i3gen.sh 
Generates modes and keybindings for all VMs in i3gen.conf. Reload i3 after it finishes to activate the new bindings/modes.

#### qubes-i3-user-terminal
Launches a terminal in the target VM.  It launches the first discovered terminal emulator, in the order contained in the script's 'for loop'.

#### qubes-i3-user-filemgr
Launches file manager in the target VM.  It launches the first discovered file manager, in the order contained in the script's 'for loop'.

#### qubes-i3-user-command
Basically the same as `Run command in qube` from the QubeManager, but a popup xterm window receives the command, then closes.
