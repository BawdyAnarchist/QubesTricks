This file doubles as my setup recommendations and personal notes when installing Qubes.

### GENERAL NOTES
Here's a copy of the PGP fingerprint for the Qubes Master Signing Key. Never hurts to ~~double~~ triple check it, from multiple devices over multiple networks on multiple websites.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `427F 11FD 0FAA 4B08 0123  F01C DDFA 1A3E 3687 9494`

Always experiment inside a DVM for packages, setup, learning, *BEFORE* modifying a template.

If you have a HiDPI screen, text/windows/titles can appear very small. Adjusting DPI can help<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `Settings Manager > Appearance > Fonts > Custom DPI setting`

For i3wm DPI, edit ~/.Xresources  with the following line<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `Xft.dpi: 96` and then in a terminal, run: `xrdb -merge .Xresources`

### VPN
Wireguard: https://github.com/hkbakke/qubes-wireguard/<br>
OpenVPN: https://github.com/tasket/Qubes-vpn-support<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *Wireguard is preferred for it's small codebase, simplicity, and best practices.*

There's a good case for connecting to a VPN before Tor. If you do:
- Make sure your VPN server is not geographically co-located with your Tor entrance node.
- Use OpenVPN and select TCP, because Wireguard UDP doesnt work with Tor. 

My preferred VPN is [IVPN](ivpn.net). They accept [Monero](getmonero.org), don't require an email, and have fantastic documentation regarding VPNs, Tor, and anonymity networks.

### FEDORA TEMPLATES
Keep `fedora-XY-xfce` as an unmodified template and use it for all sys-qubes.<br>
Clone `fedora-XY-xfce to --> `fed-XY-full` .. This template will have all our useful packages.

**REPOSITORIES** - Default Fedora repos are somewhat limited. Enable these for useful packages:<br>
```
sudo dnf config-manager --set-enabled rpmfusion-free
sudo dnf config-manager --set-enabled rpmfusion-free-updates
sudo dnf config-manager --set-enabled rpmfusion-nonfree
sudo dnf config-manager --set-enabled rpmfusion-nonfree-updates
sudo dnf config-manager -y --add-repo https://rpm.librewolf.net/librewolf-repo.repo
sudo dnf copr -y enable wojnilowicz/ungoogled-chromium
sudo dnf upgrade --refresh
```

**Packages I like**<br>
`sudo dnf install -y librewolf ungoogled-chormium libreoffice hexchat vlc obs gwenview transmission`

### DEBIAN TEMPLATES
Sometimes GUI packages are written natively in KDE/Qt, and dont present well on Gnome/GTK. We'll configure a Debian template with GTK removed, and KDE installed instead.<br>
- Clone `deb-XY-xfce` to --> `deb-XY-full` .. and run the following commands<br>
```
sudo apt-get remove gnome
sudo aptitude install ~t^desktop$ ~t^kde-desktop$
sudo apt-get install gnome-icon-theme    
```
If you have problems with a GUI application, try changing to deb-XY-full and see if that helps. 

### BROWSERS

\<RANT\><br>
Firefox is opensource spyware that makes numerous calls to Mozilla (who is 95% funded by Google) and regularly creates new default surveillance options buried in about:config that have to be disabled. Sandboxing and security features are behind Chromium. Its one redeeming feature is that it's still open source, and thus configurable. Sources:  https://madaidans-insecurities.github.io/firefox-chromium.html ..  https://grapheneos.org/usage#web-browsing<br>
\</RANT\>   

Thus, I recommend a tagteam strategy of librewolf and ungoogled-chromium. A few years ago these projects were still nascent, but have proven diligent and vigilant over the years. If one is having trouble with a particular web page, try the other. Good addons: 
  - ublock
  - decentraleyes
  - umatrix 

### ODDS AND ENDS
**DPMS** Manages standby/suspend. You might want to toggle this on occasion
`xset q`    
`xset -dpms`     
`xset dpms x y z`  , where x y z are the time in minutes for: standby suspend shutdown

[Here's a way to run a Monero node in isolation from the wallet](https://www.whonix.org/wiki/Monero_Wallet_Isolation). It works for Bitcoin too with some light modificaiton, altho the reasons for running a Bitcoin node these days are dubious.
