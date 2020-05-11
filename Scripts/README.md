This directory contains some handy little scripts that make life in Qubes more convenient.  Some of these are specifically to be used in conjunction with i3 custom binding modes, to run specific functions/commands inside your VMs.  If they're specifically written for i3, they have the form `qubes-i3-user-<program>`.  The others are generically for Qubes.  


## General Qubes Scripts

**dpi**
Changes the DPI inside of VMs based on user input.  DPI is "Dots Per Inch", or rather, Pixels Per Inch.  High DPI monitors tend to have tiny fonts/icons, and forcing DPI is typically the best, often the only way to fix it.  If you're fortunate enough to have this problem, you'll notice that each VM needs adjusted, which is why I wrote this script.  

I recommend adding it to `/usr/bin/` in all the templates as one of the first actions on a clean install, which makes it available for all AppVMs.  It sets `Xft.dpi: <xyz>` in your Xresources file ... Or in the case of Fedora, `gsettings set org.gnome.desktop.interface text-scaling-factor <x>` [rolls eyes at Gnome and Fedora].  Caz reasons, they like to break basic functionality used by most others in the ecosystem, and force their special way of doing things.  

USAGE:  In a terminal, type `dpi xyz` (where "xyz") is the desired setting, OR, you can just type `dpi` and it will query you for a value.  Note that, Fedora gsettings requires a *scaling* factor (for example: 1, 1.5, 2.3, 2.9, etc), whereas non-Fedora templates use a raw DPI value, typically between 96 and 288.  On a positive note, Gnome-Fedora VMs will scale immediately, whereas non-Fedora VMs, you will have to restart the application to take effect. 

  - Just-a-Tip:  In the template VM, `sudo vi /etc/X11/Xresources/x11-common/` change `Xft.dpi:  <xyz>` to your desired value.  All AppVMs based on the template will inherit this setting, unless/until you run the dpi script, which overrides it persistently across reboot (but only for that VM).  Also, you can't do this in Gnome-Fedora.  They're cultivating a unique ecosystem, where attempting to customize your environment is kind of an insult to their various shades of perfection.


**xscreenshot**
Designed to be run inside a VM (dom0 already has a screenshot tool).  When run, it waits for the next mouse click (only for windows inside the VM), captures a screenshot of the clicked window, and saves it *inside the VM home folder*.  Avoids the hassle of using dom0 screenshot.  Even more awesome when used with an i3 keybind.  Place in the template VMs `/usr/bin/` directory. 
  - Just-a-Tip: use in conjunction with fullscreen to get better screencaptures.


**vpnselect**
Quick way of changing VPN servers.  Good security practices often require connecting through various geo-locations, depending on what you're doing.  I have a few static vpn-VMs, but also a variable vpn-VM (vpn-var), where this script is useful.  It lists all available VPN '.conf' files, accepts user selection, and then sym-links `/rw/config/vpn/vpn-client.conf` to the selected file.  Put in `/usr/local/bin` of any vpn-VMs you want.  Save your VPN provider's conf files to `/rw/config/vpn/confiles/` 


## i3wm Specific Scripts

All of these go in `/usr/local/bin/` in dom0.

You might wonder why I made generic scripts to "run browser" or "run filemgr" when I could just "qvm-run TorBrowser" or whatever.  I dunno.  The, qubes-i3-sensible-terminal was already there in the stock Qubes i3 setup, which does a similar thing with terminal (but only for windows with the current focus), so I just ran with it.  In the i3gen\_setup, I do like having ONE alias for "terminal" instead of 2 or 3. 

**i3gen.sh**
This is my script which autogenerates all of the lines required by the i3 config file, to create VM-command combinations to run just about any command in any Qube with literally just a few keystrokes.  It requires inputting your correct data to the i3gen\_setup file.  It's friggin amazing.  See the 'i3wm/' directory in this repo for details.


**qubes-i3-user-terminal**
Launches a terminal in the target VM.  It launches the first discovered terminal emulator, in the order contained in the script's 'for loop'.


**qubes-i3-user-browser**
Launches web browser, in the target VM.  It launches the first discovered web browser, in the order contained in the script's 'for loop'.


**qubes-i3-user-filemgr**
Launches file manager in the target VM.  It launches the first discovered file manager, in the order contained in the script's 'for loop'.


**qubes-i3-user-command**
Similar to the `Run command in qube` option in QubeManager.  It launches an instance of xterm in dom0, accepts your input, and passes that input as a command to the target VM.  I find this useful in a number of cases: quickly changing the dpi, launching a less used program not coded into the bindsyms, and avoiding the d-menu, (which only shows shortcuts already added in QubeManager, in addition to consuming precious seconds of life.


**qubes-i3-user-update**
Launches an instance of xterm in the target VM, and runs the standard update commands, depending on the template OS.

