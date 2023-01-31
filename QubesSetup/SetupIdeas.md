This file doubles as my setup recommendations, and personal notes for things to remember when installing Qubes.

My hardware:  Pursim Laptop 15v4  

### General Notes and Advice

Here's a copy of the PGP fingerprint for the Qubes Master Signing Key. Never hurts to ~~double~~ triple check it, from multiple devices over multiple networks on multiple websites.    
- 427F 11FD 0FAA 4B08 0123  F01C DDFA 1A3E 3687 9494

Always experiment inside a DVM for packages, setup, and learning, *BEFORE* modifying a template.

If you have a HiDPI screen, you can change the DPI setting here:
- Settings Manager > Appearance > Fonts > Custom DPI setting    

Graphical apps can often be buggy. I find there are often differences between Gnome/GTK and KDE/Qt. Try switching between these two, using separate templates, if/when you have trouble. 

### System Setup 

Maintain fedora-36 as a pristine, unmodified template. Run all your system VMs off of it, and keep the DVM template for it as well. 

Get your VPN up and running. You should prefer Wireguard, if for no other reason than best practices and simplicty. *HOWEVER* if you connect a VPN before Tor, Wireguard UDP doesn't mesh with Tor's TCP. You'll need to resort to TCP on openvpn.    
- https://github.com/hkbakke/qubes-wireguard/   (Wireguard)   
- https://github.com/tasket/Qubes-vpn-support   (openvpn)   
- IVPN.net , and *read their docs*. Pay with Monero.   

If you connect a VPN before Tor, just be careful that you're entrance node is not geographically close to your VPN server. Read the Whonix documentation to better understand the risks of doing this. 

We're now going to make 2 templates for daily driving activities. One Fedora, one Debian.   

**FEDORA**    
- Clone the default and name it:  fed-36-full (or whatever fedora-XY is latest)    
- This will be Gnome/GTK only. Do *NOT* install Qt apps!    
- [Enable rpmfusion](https://www.qubes-os.org/doc/how-to-install-software/). Cheat sheet below:  
```
sudo dnf config-manager --set-enabled rpmfusion-free
sudo dnf config-manager --set-enabled rpmfusion-free-updates
sudo dnf config-manager --set-enabled rpmfusion-nonfree
sudo dnf config-manager --set-enabled rpmfusion-nonfree-updates
sudo dnf upgrade --refresh
```
- Packages I like   
  - falkon ungoogled-chormium libreoffice hexchat vlc obs gwenview transmission 

**DEBIAN**
- Clone the default and name it:  deb-11-full (Or whatever debian-XY is latest)
- This will be KDE/Qt only. WE WILL REMOVE EVERYTHING GNOME
  - `sudo apt-get remove gnome`	  
- Install the full KDE desktop suite, instead    
```
sudo aptitude install ~t^desktop$ ~t^kde-desktop$
sudo apt-get install gnome-icon-theme    
```

Now you can make 2 new DVM templates on the basis of your new "full" templates. Use these as your daily drivers. I typically prefer Fedora, and then stray over to Debian as necessary. Technically Whonix is debian so there's that too. 

[Here's a way to run a Monero node in isolation from the wallet](https://www.whonix.org/wiki/Monero_Wallet_Isolation). It works for Bitcoin too with some light modificaiton. 

\<RANT\> Firefox is probably not the best browser anymore. They make lots of calls back to Mozilla servers (Mozilla who is 95% funded by Google). Sandboxing and security features are well behind Chromium at this point. Sources:   
  - https://madaidans-insecurities.github.io/firefox-chromium.html
  - https://grapheneos.org/usage#web-browsing

For this reason, I think ungoogled-chormium is worth a shot. They've kept up over the years. The one major benefit of Firefox still, is that it's very customizable. That still doesn't fix being behind in security in other areas, but at least it's something. \</RANT\>   

At any rate install these addons to your browser:
  - ublock
  - decentraleyes
  - And disable various types of fingerprinting in the settings


### i3wm - Not recommended anymore until Qubes fixes the integration. 

A tiling wm like i3, with loads of defined quick keys really *was* the most ideal way to navigate Qubes. Sadly, [Qubes now regularly hard freezes with i3](https://github.com/QubesOS/qubes-issues/issues/7902) and forced me to go back to xfce.

I hope to one day re-write this section again. As much as I appreciate the free code Qubes has given us, the reality is that Qubes does suffer from ticks and glitches. Price of security I guess. 
### Quirks and Gotchas - Only for i3wm, otherwise ignore

**Touchpad:** This is only for i3wm. 

```
vi /usr/share/X11/xorg.conf.d/60-libinput.conf

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

