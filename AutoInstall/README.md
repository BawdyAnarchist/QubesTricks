### AUTOMATIC INSTALL

*An important security note*:  You should always be careful about transfering code to dom0 and running it (which is what these instructions will do). If you're uncomfortable with this, then I recommend reviewing the script (it's clear and well commented), or manually configuring this setup yourself. 

Here's a top-level overview of what this script does:
- Will install i3 to dom0 if not already installed
- Starts anon-whonix and clones this repo there
- Transfers key files to dom0 (i3wm scripts, dpi and xscreenshot scripts, xorg.conf_sample)
- Starts the Fedora, Debian, and Whonix templates to tranfer dpi and xscreenshot scripts
- Copies .bashrc to /root, so that you get color coded files as root in all VMs now. 
- Creates a new template called fed-40-full ; adds repos ; installs programs
  -- rpmfusion-free and nonfree
  -- librewolf and ungoogled-chromium repos
  -- Installs: libreoffice librewolf ungoogled-chromium transmission git

### COMMANDS TO RUN
Open a terminal and run the following line in whatever VM you're currently in:
`_url='https://raw.githubusercontent.com/BawdyAnarchist/QubesTricks/master/QubesTricks_Install.sh' ; command -v whonix > /dev/null && _cmd='scurl-download' || _cmd='curl' ; eval $_cmd -o ~/Downloads/QubesTricks_Install.sh $_url` 

Run the 3 commands below in a dom0 terminal, substituting the name of your VM:
`qvm-run -p {name_of_the_vm} 'cat /home/user/Downloads/QubesTricks_Install.sh' > ~/QubesTricks_Install.sh`
`sudo chmod +x ~/QubesTricks_Install.sh`
`sh ~/QubesTricks_Install.sh`
