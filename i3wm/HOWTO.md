The i3 config file has very few scripting abilities, and bindings must be input manually.  The 'i3gen.sh' bash script in this directory automagically creates and adds the required lines to the config, mapping your modes and keybindings, based on information you provide in the i3gen\_setup file.  Fairly straight forward if you're familiar with i3.  If not, then read the [i3 user documentation](https://i3wm.org/docs/userguide.html).
 
### How the Binding Modes Function, Once Active in Your i3 Config

Select your target VM, and then select which command to run.  Depending on your number of VMs, keybind collisions happen pretty often, so I grouped some of them into a "second layer" binding mode (templates, \`sys-', \`dvm-', \`vpn-').  Production daily use VMs are directly accessible from the first mode.  For example, the flow look like this:

1. mod+q enters the first binding mode, where you can either directly select a production VM, or a VM group.  From here:
   * `1` enters the binding mode designated for templates
   * `2` enters the binding mode designated for `sys-___` 
   * `3` enters the binding mode designated for `dvm-___`   
   * `4` enters the binding mode designated for `vpn-___` 
   * `<letter>` is reserved for production VMs... ***v***ault, ***w***ork, ***p***ersonal, ***s***ocialmedia, etc
   * `Enter` and `Escape` keys always bring you back to normal (default) mode regardless of which binding mode you're in. 

2. If you selected a grouped VM, you are now inside the group binding mode.  Hypothetically lets say you selected `1` (templates).  From here:
   * `f` enters the ***f***edora-31 specific mode (where you can select actual command to run). 
   * `d` enters ***d***ebian-10
   * `w` enters whonix-***w***s-15
   * `g` enters whonix-***g***w-15 
   * `k` enters deb-10-***k***de
   * &nbsp;&nbsp;&nbsp; *It might seem trivial or unnecessary to divide the system VMs into grouped modes like this.  Personally, I have many additional sys- , dvm- , vpn- , VMs so it makes sense for me.  Alternatively, you could combine '$mod' with keys like Ctrl and Alt.*

3. You will now be inside a specific VM mode.  The i3-bar shows which mode you're in.  From here, the command you select will be passed to the VM.  If you have a lot of commands/apps, you can again end up with collisions.  Rather than making yet another binding mode, I just set all the system-operation type stuff to numerical keys.  `<key> --\> <command>`
   * `1 --> start` ; `2 --> unpause` ; `3 --> run_terminal` ; `4 --> run_command_in_qube`
   * `5 --> update` ; `6 --> xterm_in_dispvm` ; `9 --> pause` ; `0 --> shutdown`
   * The letters are reserved for actual apps or functions like **b**rowser ; **l**iberoffice ; **k**eepass ; **p**hotos
   * &nbsp;&nbsp;&nbsp; *Press the corresponding letter, and watch your command take off!*

The convenience of controlling Qubes like this grows on you quick.  With this script, you can quickly/easily set your own custom keybinds, VMs, and commands.  You can imagine how much a PITA this would be to crank out by hand.  God forbid you add a VM, change a VM name, add some packages, or want to rearrange keybinds. 

### How to Configure Your Own Custom Bindings

Edit the i3gen\_setup file, run `i3gen.sh`, and then reload the configuration file.    
All of these files go in `/home/user/.config/i3/`

**Columns in the first section (the VM list)**  
1. EXACT VM name
2. GROUP
   * If you want to assign a group the VM to avoid collisions, add a group name
   * If you don't want the VM in a group, ***you MUST write `none`***, or the script won't work correctly
3. BINDSYM TO NEXT MODE (This keypress will take you to the next mode)
   * If the GROUP is `none` this key will take you directly to the individual VM mode
   * If the GROUP is `<whatever>` this key will take you to the group submode
4. BINDSYM FOR SUBMODE
   * If GROUP is `none`, the column is ignored, BUT, ***you MUST put a character***, or the script wont work correctly.  I just put a dash \`-' 
   * If GROUP is `<whatever>` this key press will move you from the group submode, to the individual VM, 
5. COMMAND ALIAS 
   * This of course isn't the exact command to be run, it's an alias, defined in the next section 
   * Comma separated, no spaces, list all of the commands you want for this VM 

**Columns in the second section (the alias-command list)**  
1. ALIAS from the vmlist
2. BINDSYM (keypress) that will cause i3 to exec the command
3. COMMAND 
   * The EXACT command you want i3 to pass to dom0.
   * Notice the substitution of `$vm` for an actual VM name.  The script resolves this when creating the lines.  Use exactly `$vm` if making your own custom commands.

There are commands in 'i3gen\_setup' which aren't part of the Qubes-i3 install.  They do cool things like update the selected template ; take a screenshot of a VM window *from within the VM itself and save it there* ; or my favorite, pass an arbitrary command to a target VM (similar to `Run command in Qube`).  Find them in the "Scripts" directory of this repository.  

## Completing the Config     
1. Ok, so you have all your own VM names added, desired keybinds, and aliased commands.
2. Make sure i3gen.sh and i3gen\_setup are in `/home/user/.config/i3/`
3. Make a backup of your current config!
4. In dom0 terminal run the script , it'll take a few seconds.
5. Open your modified config, scroll down, do a sanity check.
6. Reload the i3 config (default keybinding to do this is `mod+Shift+c`)

If everything went okay, your screen should flicker once, and then your bindings are in effect.  If there was an error, i3 will have a bar at the top informing you.  Unfortunately the error logs are only *kinda* helpful.

On occassion, a mistake can cause erratic behavior after i3 reload, making the system unuseable.  Not to worry!  Linux comes with multiple TTYS.  Press `Ctrl+Alt+F2` (or F3), changing the console (where X and i3 aren't running).  Input your credentials for dom0 then `pkill -15 i3` , restore your backup config, type `exit` , press `Ctrl+Alt+F1` , and login again.  Worst case scenario, delete the config file entirely, and i3 auto-config will launch upon login.

&nbsp;  
**Ok that about does it!  Hope that people find this useful.  If I get some good feedback, maybe I'll ask if the maintainers of the Qubes i3 repository want to add it.** 
