This directory contains some handy little scripts to make Qubes more convenient.  Some are intended for use with i3 custom binding modes, and aren't very useful outside of i3.  They have the form `qubes-i3-user-<program>`.  The others are for Qubes in general.  


### General Qubes Scripts

**dpi**  
Changes DPI inside of VMs based on user input ("Dots Per Inch" or rather "Pixels Per Inch").  High DPI monitors can have tiny fonts/icons, and DPI is typically the best, often the only way to fix it.  If you're fortunate enough to have this problem, you'll notice that each VM needs adjusted in turn.  

Add it to `/usr/bin/` in the templates so it's available for all AppVMs.  In the Xresources file, it sets `Xft.dpi: <xyz>` ... or in the case of Fedora `gsettings set org.gnome.desktop.interface text-scaling-factor <x>` [rolls eyes at Gnome and Fedora].  They enjoy breaking basic functionality used by the rest of the ecosystem, and creating their own special way of doing things, caz reasons.

USAGE:  In a terminal, type `dpi xyz` (where "xyz") is the desired setting, OR, you can just type `dpi` and it will query you for a value.  Fedora gsettings requires a *scaling* factor (1, 1.5, 2.3, 2.9, etc), whereas non-Fedora uses a raw DPI value, typically between 96 and 288.  On a positive note, Gnome-Fedora VMs will scale immediately, whereas non-Fedora VMs, require application restart to take effect. 

   - *Just-a-Tip:  In the template VM, `sudo vi /etc/X11/Xresources/x11-common/` change `Xft.dpi:  <xyz>` to the desired value.  AppVMs based on the template will inherit this setting, which can be persistently overriden in the AppVM with the `dpi` script.  Although this doesn't apply to Gnome-Fedora.  They're cultivating a unique ecosystem, where attempting to customize your environment is kind of an insult to their various shades of perfection.*

&nbsp;
**xscreenshot**  
Designed to be run inside a VM (dom0 already has a screenshot tool).  When run, it waits for the next mouse click (only for windows inside the VM), captures a screenshot of the clicked window, and saves it *inside the VM home folder*.  Avoids the hassle of using dom0 screenshot.  Even more awesome when used with an i3 keybind.  Place in the template VMs `/usr/bin/` directory. 
   - *Just-a-Tip: use in conjunction with fullscreen to get better screencaptures.*

&nbsp;
**vpnselect**  
Quickly change VPN servers (if using OpenVPN).  Good security practices often require connecting through various geo-locations, depending on what you're doing.  I have a few static vpn-VMs, but also a variable vpn-VM (vpn-var), where this script is useful.  It lists all available VPN '.conf' files, accepts user selection, and then sym-links `/rw/config/vpn/vpn-client.conf` to the selected file.  Put in `/usr/local/bin` of any vpn-VMs you want.  Save your VPN provider conf files to `/rw/config/vpn/confiles/` 


### i3-Qubes Specific Scripts

All of these go in `/usr/local/bin/` in dom0.

Why make generic scripts to "run browser" or "run filemgr" when you could just "qvm-run TorBrowser" ?  I dunno.  `qubes-i3-sensible-terminal` was already in the stock Qubes-i3 setup, which does a similar thing with terminal (but only for windows with the current focus), so I expanded on that idea.  I do like having ONE alias for "terminal" instead of 2 or 3 in the i3gen\_setup.

**i3gen.sh**  
Autogenerates all of the lines required by the i3 config file, to create VM-command combinations to run just about any command in any Qube with literally just a few keystrokes.  It requires inputting your correct data to the i3gen\_setup file.  It's friggin amazing.  See the 'i3wm/' directory in this repo for details.

&nbsp;
**qubes-i3-user-terminal**  
Launches a terminal in the target VM.  It launches the first discovered terminal emulator, in the order contained in the script's 'for loop'.

&nbsp;
**qubes-i3-user-browser**  
Launches web browser, in the target VM.  It launches the first discovered web browser, in the order contained in the script's 'for loop'.

&nbsp;
**qubes-i3-user-filemgr**  
Launches file manager in the target VM.  It launches the first discovered file manager, in the order contained in the script's 'for loop'.

&nbsp;
**qubes-i3-user-command**  
Similar to the `Run command in qube` option in QubeManager.  It launches an instance of xterm in dom0, accepts your input, and passes that input as a command to the target VM.  I find this useful in a number of cases: quickly changing the dpi, launching a less used program not coded into the bindsyms, and avoiding the d-menu, conserving precious seconds of life.

&nbsp;
**qubes-i3-user-update**  
Launches an instance of xterm in the target VM, and runs the standard update commands, depending on the template OS.

