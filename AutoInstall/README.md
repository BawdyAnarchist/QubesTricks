*QubesTricks_Install.sh* automates my basic personal setup. I run it anytime I do a new install.

**Important security note**:  You should always be careful about transfering files dom0, and especially executing scripts (which is what these instructions will do). It's a straightforward script, but it never hurts to review it yourself. It will:
- Install i3 to dom0
- Start anon-whonix and clone this repo there
- Transfer key files to dom0 (i3wm scripts, dpi and xscreenshot scripts, xorg.conf_sample)
- Start Fedora, Debian, Whonix templates to tranfer dpi and xscreenshot scripts
- Copy .bashrc to /root, for color coded terminal when root in VMs 
- Creates a new template called fed-40-full ; adds repos ; installs programs
  -- rpmfusion-free and nonfree
  -- librewolf and ungoogled-chromium repos
  -- Installs: libreoffice librewolf ungoogled-chromium transmission git

#### Open a terminal and run the following line in whatever VM you're currently in:
`_url='https://raw.githubusercontent.com/BawdyAnarchist/QubesTricks/master/QubesTricks_Install.sh' ; command -v whonix > /dev/null && _cmd='scurl-download' || _cmd='curl' ; eval $_cmd -o ~/Downloads/QubesTricks_Install.sh $_url` 

#### Run the 3 commands below in a dom0 terminal, substituting the name of your VM:
`qvm-run -p {name_of_the_vm} 'cat /home/user/Downloads/QubesTricks_Install.sh' > ~/QubesTricks_Install.sh`

`sudo chmod +x ~/QubesTricks_Install.sh`

`sh ~/QubesTricks_Install.sh`
