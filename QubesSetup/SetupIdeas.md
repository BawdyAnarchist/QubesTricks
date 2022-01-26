This file doubles as my setup recommendations, and personal notes for things to remember when installing Qubes.

My hardware:  Pursim Laptop 15v4  


### i3wm Shilling - Reasons to Switch to i3

Since we're dealing with multiple VMs, a tiling window manager designed around quick keys just makes sense. Combined with the i3gen script, should improve your workflow. 

Qubes is heavy on system resources, so you should get a performance boost vs xfce.  

On Qubes 4.0; i3wm resolved issues I had with full screen video playback on my hidpi screen. 

You'll also get some hacker cred with normies. Your screen will look cool, and your snooping girlfriend won't know how to navegate your system!  Just kidding. No one running Qubes+i3wm has a girlfriend.


### System Setup Ideas

Always experiment inside a DVM for packages, setup, and learning.

DPI can be tricky. Start with dom0 DPI at: 
- Settings Manager > Appearance > Fonts > Custom DPI setting    

Then copy the `dpi` script to all of your template VMs under:  /usr/bin/
- Fedora VMs change dpi immediately; Debian VMs must re-launch the app/window
- Run the command: `dpi -h` for more details

GUI apps can sometimes be buggy; but often can be solved by switching between Gnome/GTK and Qt/KDE. So I recommend 2 separate templates:

Make a clone of the Fedora template, call it:  fed-34-full
- Install GTK and everything gnome, *but don't install Qt/KDE pkgs*
- Add all your personal extra pkgs

Make a clone of the Debian template, call it: deb-11-full 
- REMOVE GNOME ENTIRELY!     
   - `sudo apt-get remove gnome`	  
- Install the full KDE desktop suite, instead    
   - `sudo aptitude install ~t^desktop$ ~t^kde-desktop$`     
   - `sudo apt-get install gnome-icon-theme`    
- Add all your personal extra pkgs
   - Consider using Falkon as your browser. Often superior to Firefox.

\<RANT\> 
FF is open source spyware, now funded primarily by google. Every new release has new default-on spyware settings that have to be manually turned off, buried in about:config. Check out ghacks user.js for help in hardening FF. Also, umatrix is a powerful addon. 
\</RANT\>

Colorcoding.  I prefer to colorcode based on both the security and anonymity of the VM in question. Gray for templates, red for system level VMs, green for publicly known identities, and purple for anon/Tor. 

I also rename my disposable and Whonix VMs, as you will notice if you use the i3gen.conf (i3 script). 


### VPN Qube Setup

Wireguard is a superior VPN implementation, and now available in the Linux kernel.

I recommend using this repo/guide for configuring VPN Qubes:
https://github.com/hkbakke/qubes-wireguard

     
### Quirks and Gotchas 

Inside your i3wm config, remove `-d` options from `i3lock`
It's deprecated, and might've been causing screen freezes.

Sometimes a pop-up window will be blank.  Toggling fullscreen usually fixes that

**Touchpad:** I prefer to enable tapping (instead of click-pressing). Make persistent:
`vi /usr/share/X11/xorg.conf.d/60-libinput.conf`

```
Section "InputClass"  
	Identifier "libinput touchpad catchall"  
	MatchIsTouchpad "on"  
	MatchDevicePath "/dev/input/event*"  
	Driver "libinput"  
	Option "Tapping" "True"  
	Option "Accel Speed" "0.7"  
EndSection  
```

**DPMS**: Manages standby/suspend. It can interrupt lengthy operations, so recommend
toggling if you're doing a backup/restore, or copying large amounts of data.
`xset q`
`xset -dpms` 
`xset dpms x y z`  , where x y z are the time in minutes for: standby suspend shutdown


### xscreenshot

This script takes a screenshot *from within a running VM*. It waits for the next mouse click on a window inside the VM, and saves to the home directory.  Copy the script to your template VM and place in /usr/bin/ 

Tip: use in conjunction with fullscreen to get better captures.
