*QubesTricks_Install.sh* automates my basic personal setup. I run it on all new installs. It's the script-ified version of my recommendations in this repo.

**Important security note**:  You should always be careful about transfering files to dom0, and especially executing them (which is what these instructions will do). It's a straightforward script, but never hurts to review it yourself. It will:
- Install i3 to dom0 (if not already installed).
- Start anon-whonix and clone this repo there
- Transfer scripts and sample config files to dom0
- Creates named_disposable qubes: Dispvm1 to Disvpm4 and TorDVM / TorDVM2
- Start Fedora Debian Whonix templates; transfer dpi script; copy ~/.bashrc to /root for color coded terminal
- Creates a new template called fed-40-full , adds repos , installs programs<br>
&nbsp;&nbsp;&nbsp;&nbsp; - rpmfusion-free and nonfree<br>
&nbsp;&nbsp;&nbsp;&nbsp; - librewolf and ungoogled-chromium repos<br>
&nbsp;&nbsp;&nbsp;&nbsp; - Installs: libreoffice librewolf ungoogled-chromium transmission git

#### In whatever qube you're in - Open a terminal and run the following line:
`_url='https://raw.githubusercontent.com/BawdyAnarchist/QubesTricks/refs/heads/master/AutoInstall/QubesTricks_Install.sh' ; command -v whonix > /dev/null && _cmd='scurl-download' || _cmd='curl' ; eval $_cmd -o ~/Downloads/QubesTricks_Install.sh $_url` 

#### Type these commands in dom0 terminal. Substitute {NAME_OF_QUBE} that you ran the command above
`qvm-run -p {NAME_OF_QUBE} 'cat /home/user/Downloads/QubesTricks_Install.sh' > ~/QubesTricks_Install.sh`

`sudo chmod +x ~/QubesTricks_Install.sh`

`sh ~/QubesTricks_Install.sh`

#### AFTER INSTALL
1. Edit `/home/user/.config/i3/i3gen.conf` to define your qube/command pairs
2. Run the command: `i3gen.sh` and then reload i3 to take effect.
3. Add your packages to fed-40-full (stuff like vlc, gimp, gwenview, etc).
4. Change your qube templates to fed-40-full (but leave the sys-qubes on fedora-40-xfce)
5. Change Dispvm1-4 netvms. I like to have one offline, one sys-firewall, and then VPNs.
6. If you need multiple monitors, edit `/home/user/.config/QubesTricks/xorg.conf_sample` in dom0
