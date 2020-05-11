Such a bold claim from a script kiddie.  People use different machines for different use cases, with varying levels of knowledge.  So yeah, my claim is specific to me, on a Purism 15v4, which I use for secure computing, web browsing, and light media editing.  Qubes isn't typically the best choice for a workhorse, rendering, compiling, ... training multi dimensional neural networks to predict the price action of [insert fav shitcoin].  Now for someone as overconfident as implied by the title of this doc, it just wouldn't be improper unless I began with some outlandish claims on a divisive topic.    

&nbsp;  
### KDE (Qt) vs GNOME (GTK)

If you hope for a versatile Qubes machine, but unfamiliar with these terms, you're gonna have a bad time.  Qt and GTK are *GUI libraries* which underpin nearly all Linux GUI applications.  KDE and GNOME are *desktop environments* (DE), based on Qt and GTK respectively.  Mostly, a DE is just a fancy GUI application to run programs, manage files, and use widgets without having to touch an icky terminal.  It does other crucial stuff, like system management and background wallpaper.  Qubes dom0 uses Fedora, with a DE called "Xfce", which is just a lightweight "spin" off Gnome.

For years, Gnome has been "encouraging" users to see the light and stop wandering off the reservation (using outside applications), by being progressively less accomodating for cross-platform devs and apps not inside the sanctified Gnome ecosystem.  My experience, first on a Lenovo and then Purism laptop, is that non-gnome packages often present poorly and have unresolvable useability issues.  I tried running my production VMs on a "fedora-30-full" template, where I installed all things rpm and rpm-fusion, even flatpak.  But it simply didnt' cut it.

&nbsp;  
### After much experimentation and conspiracy-speculation fueled research, I now have the uncontentested, absolute best setup for a Purism v4 with Qubes
&nbsp;&nbsp;&nbsp; *Uncontested because no one, except myself, has actually reviewed it*

1.  Fedora-31 template, updated, no additional packages (stock).  Use this template for system vms (sys-net, sys-usb, sys-vpn, and a dvm for experimentation).  Either drop my `dpi` script in `/usr/bin/` or at least write your own 1-liner: `gsettings set org.gnome.desktop.interface text-scaling-factor $1` to quickly set zoom in VMs as you run them.  Don't forget `sudo chmod +x /usr/bin/dpi` after creating the script.  See the 'Scripts/' directory of this repo. 

2.  Clone the debian-10 template, and then REMOVE GNOME ENTIRELY.  `sudo apt-get remove gnome*`  If you choose to run `autoremove` (you don't have to), be careful not to remove the qubes-core-agent packages. Requies `sudo apt-mark manual <package>` all packages beforehand.  After that, install the full KDE desktop suite, `sudo aptitude install ~t^desktop$ ~t^kde-desktop$` and also `sudo apt-get install gnome-icon-theme`.  I also installed transmission-qt, git, kdenlive, krita, and wine.  

   - *Side note.  `sudo vi /etc/X11/Xresources/X11-common` and add `Xft.dpi: 192` will make all appvms based on this template start with dpi of 192 (or whatever you want).  Again, you can add my script which sets a persistent dpi for the VM in which it's run, or add your own 1-liner `echo "Xft.dpi: xxx" | xrdb -merge` to the template `/usr/bin/` directory.  New DPI in Debian doesn't take effect until restarting the application.  I also recommend forcing fonts DPI in `systemsettings5` or KDE System Settings (from GUI), where you also can set dark mode options.*

3.  I ALWAYS recommend experimenting with configurations and installing first time trial of new packages in a dvm.  Create a debian-10-kde DispVM for this purpose, before installing trial packages to the template.  It will keep the debian-10-kde template clear of junk/problems that result from repeated install/remove, purge, autoremove, and troubleshooting and mistakes you're likely to encounter. 

4.  For good measure, I also installed KDE to dom0 `sudo qubes-dom0-update @kde-desktop-qubes` BUT DON'T ACTUALLY CHANGE THE LOGIN MANAGER.  You want to stay in xfce (or better, i3), because I found that actually running KDE desktop in dom0 made my computer super glitchy, nigh unuseable.  The idea is that I DO want the Qt packages in dom0, so that my Qt (KDE) based AppVMs can easily render in dom0 which controls the GUI, but I DON'T want to actually run KDE desktop.  *I'm not actually sure if this is necessary*, but I don't think it hurts.

5.  i3 Window Manager (i3wm).  If you can switch to it, do so.  `sudo qubes-dom0-update i3 i3-settings-qubes`  It's not a desktop environment, it's a tiling window manager with a few added tools (look it up).  If you can reasonably run a terminal and have some time to learn, this will significantly improve your organization and workflow.  You can still run GUI applications.  In fact, I think this is at least a partial factor in fixing my problem of not being able to play fullscreen videos at max screenresolution.   See the 'i3wm/' directory of this repository for details.  

&nbsp;  
### FINAL NOTES  

I still have problems with Firefox crashing regularly, and graphical heavy applications consuming like 50-90% of my CPU.  I think this is unavoidable because of the lack of OpenGL (graphics libraries) in dom0, which Qubes devs say is a big security vulnerability, please let me know if you have a solution for this.  

Also, [warning, unpopular opinion ahead] ... Firefox is fully open source spyware, with deep connections to Google.  They even (accidentally?) murdered addons for a period of time last year, despite being warned repeatedly that such a thing could happen.  It affected TorBrowser too.  They keep adding obscure, opt-out-spying features buried in about:config, while pretending to include "anti-fingerprinting" options in the normie preferences.  I tested it Aug last year, and my browser was generating a unique canvas hash until I manually set `resist.fingerprinting` in about:config.  At minimum, install uBlock and decentraleyes.  uMatrix and user.ghacks are good, but break a lot of sites.  I'm in the market for a better browser (no not Brave or Opera).  Maybe ungoogled Chromium, or PaleMoon?  

Qubes is in full swing developing 4.1, which will see the introduction of the GUI domain, which should hopefully solve a lot of these GUI related issues.  I will very likely be sticking with Debian, KDE, Qt for my production environment, and i3wm for sure. 
 
