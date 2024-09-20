### config_mods
dom0: */home/user/.config/i3/config_mods*
Extra workspaces, expanded key bindings, and a couple improvements (commented). Review and merge with your own config.

### i3gen.conf 
dom0: */home/user/.config/i3/i3gen.conf*
Qubes+i3 is a great combo, but you quickly run out of key bindings with numerous VM/command pairs. This automates creation of i3 modes and keybindings so that you can: 
- Start/stop any qube
- Open terminal or file manager in any qube
- Launch disposable VM based on any qube
- Launch Popup to "Run command in qube"
- Run common packages (defined by you) in any qube

It might not sound like much, but you can do all these in < 1 sec, as opposed to GUI or d-menu.

#### How to use it 

1. Specify a $mod+key by which you will enter VM-Select mode.
2. Each VM is listed and has a quick key - which takes you to the specific VM mode
  - Notice the grouping modes for VMs with a common purpose (templates, system).
  - This is because there's still too much overlap in VM names. 
  - This is optional, you dont have use GROUP. Put a dash '-' if not using GROUP.
3. The COMMAND_ALIAS column specifies which commands you want to run in each VM.
4. The bottom section defines explicitly how the command alias should be run in dom0.
  - Notice again the keybinding 
5. In a dom0 terminal, run `i3gen.sh` to generate the keybindings/modes, then reload i3.

### qubes-i3-scripts

These scripts all need to be copied to dom0 */usr/local/bin/* and made executable `chmod +x`

#### i3gen.sh 
Generates modes and keybindings for all VMs in i3gen.conf. Reload i3 after it finishes.

#### qubes-i3-user-terminal
Launches a terminal in the target VM.  It launches the first discovered terminal emulator, in the order contained in the script's 'for loop'.

#### qubes-i3-user-filemgr
Launches file manager in the target VM.  It launches the first discovered file manager, in the order contained in the script's 'for loop'.

#### qubes-i3-user-command
Basically the same as `Run command in qube` , but a popup xterm window receives the command, then closes.

