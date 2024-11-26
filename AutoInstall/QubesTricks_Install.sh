#!/bin/sh

def_variables() {
	# DIRECTORIES AND LINKS
	_qtlink="https://github.com/BawdyAnarchist/QubesTricks/archive/refs/heads/master.zip"
	_qtdir="/home/user/QubesTricks-master"
	_qti3="${_qtdir}/i3wm"
	_qtdom0="/home/user/.config/QubesTricks"
	_i3dom0="/home/user/.config/i3"
	
	# TEMPLATES
	_fed="fedora-40-xfce"
	_fedfull="fed-40-full"
	_deb="debian-12-xfce"
	_debfull="deb-12-full"
	_whonix="whonix-workstation-17"
}

intro() {
	# INFORMATION
	echo -e "\nTHIS SCRIPT AUTOMATES A NUMBER OF FUNCTIONS RELATED TO i3wm AND GENERAL SETUP" 
	echo    "THE FOLLOWING ACTIONS WILL BE PERFORMED:"
	echo "  i3wm will be installed to dom0"
	echo "  QubesTricks i3wm scripts copied to dom0:  $_i3dom0 and /usr/local/bin/"
	echo "  QubesTricks sample/extra files copied to dom0:  $_qtdom0"
	echo "  DPI and Screenshot scripts copied to the templates" 
	echo "  bashrc copied to root in the templates (enables colors and env when root in VMs)"
	echo "  A new template called $_fedfull will be created with multiple repos enabled and pkgs installed:"
	echo "    rpmfusion free/nonfree, librewolf, ungoogled-chromium, libreoffice, transmission, git"

	# USER OPTIONS AND FINAL CONFIRMATION BEFORE PROCEEDING
	echo -e "\nAre you on a laptop and would you like to enable tapping on the touchpad? (Y/n): \c"
	read _tapping 
	echo -e "\nPROCEED WITH INSTALL? (Y/n): \c"
	read _proceed
	! [ "$_proceed" = "Y" -o "$_proceed" = "y" ] && echo "Aborting. No changes were made." && exit 1

	clear
}

files_to_dom0() {
	# START anon-whonix AND DOWNLOAD THE QubesTricks REPO
	echo "DOWNLOADING FILES VIA anon-whonix"
	qvm-start --skip-if-running anon-whonix
	qvm-run -p anon-whonix "scurl-download $_qtlink /home/user"
	qvm-run -p anon-whonix "unzip /home/user/master.zip"

	# CREATE i3 DIRECTORY IN dom0
	mkdir -p $_qtdom0 
	mkdir -p $_i3dom0
	mv /home/user/QubesTricks_Install.sh ${_qtdom0}/QubesTricks_Install.sh

	# BRING FILES FROM THE REPO INTO dom0
	qvm-run -p anon-whonix "cat ${_qtdir}/QubesSetup/dpi"         > ${_qtdom0}/dpi 
	qvm-run -p anon-whonix "cat ${_qtdir}/QubesSetup/xscreenshot" > ${_qtdom0}/xscreenshot 
	qvm-run -p anon-whonix "cat ${_qti3}/i3gen.conf"              > ${_i3dom0}/i3gen.conf
	qvm-run -p anon-whonix "cat ${_qti3}/config_mods"             > ${_i3dom0}/config_mods
	qvm-run -p anon-whonix "cat ${_qti3}/qubes-i3-user-command"   > ${_qtdom0}/qubes-i3-user-command
	qvm-run -p anon-whonix "cat ${_qti3}/qubes-i3-user-filemgr"   > ${_qtdom0}/qubes-i3-user-filemgr
	qvm-run -p anon-whonix "cat ${_qti3}/qubes-i3-user-terminal"  > ${_qtdom0}/qubes-i3-user-terminal
	qvm-run -p anon-whonix "cat ${_qti3}/i3gen.sh"                > ${_qtdom0}/i3gen.sh
	qvm-run -p anon-whonix "cat ${_qti3}/QubesSetup/xorg.conf_sample" > ${_qtdom0}/xorg.conf_sample
	qvm-run -p anon-whonix "cat ${_qtdir}/QubesSetup/60-libinput.conf" > ${_qtdom0}/60-libinput.conf

	# MUST MANUALLY MOVE FILES TO /usr/local/bin, COZ SUDO WITH qvm-run WONT WORK
	sudo cp ${_qtdom0}/qubes-i3-user-command /usr/local/bin/
	sudo cp ${_qtdom0}/qubes-i3-user-filemgr /usr/local/bin/
	sudo cp ${_qtdom0}/qubes-i3-user-terminal /usr/local/bin/
	sudo cp ${_qtdom0}/i3gen.sh /usr/local/bin/

	echo -e "FILES COPIED TO:\n  $_qtdom0\n  $_i3dom0\n  /usr/local/bin"

	# MAKE SCRIPTS EXECUTABLE
	sudo chmod +x /usr/local/bin/qubes-i3-user-command /usr/local/bin/qubes-i3-user-filemgr \
		/usr/local/bin/qubes-i3-user-terminal /usr/local/bin/i3gen.sh

	# BASED ON USER INPUT COPY 60-libinput.conf
	[ "$_tapping" = "Y" -o "$_tapping" = "y" ] \
		&& sudo cp ${_qtdom0}/60-libinput.conf /usr/share/X11/xorg.conf.d/ \
		&& echo -e "\nTAPPING ENABLED. TOUCHPAD ACCEL CAN BE CHANGED VIA: /usr/share/X11/xorg.conf.d/60-libinput.conf" \
		&& echo "   RELOAD i3 TO TAKE EFFECT" 
}

create_dispvms() {
	# Create disposable template for fed-full. Note that the volume size isnt a problem since it's for dispvms
	qvm-create --class AppVM -t $_fedfull -l red --prop netvm='' --prop template_for_dispvms=True \
		--prop memory=4000 --prop maxmem=8000 dvm-fed-full
	sudo qvm-volume resize dvm-fed-full:private 50G

	# Create disposable template for whonix-ws 
	qvm-create --class AppVM -t $_whonix -l red --prop netvm='' --prop template_for_dispvms=True \
		--prop memory=4000 --prop maxmem=8000 dvm-whonix-ws
	sudo qvm-volume resize dvm-fed-full:private 50G

	# Create clearnet Dispvm 1 to 4
	for _num in 1 2 3 4 ; do
		qvm-create --class DispVM -t dvm-fed-full -l orange "Dispvm${_num}" 
	done
	
	# Create whonix TorDVMs 
	qvm-create --class DispVM -t dvm-whonix-ws -l purple --prop netvm='sys-whonix' "TorDVM"
	qvm-create --class DispVM -t dvm-whonix-ws -l purple --prop netvm='sys-whonix' "TorDVM2"
}

templates_modification() {
	# CHANGE FEDORA 
	if qvm-ls $_fed > /dev/null 2>&1 ; then 
		echo -e "\nMODIFYING TEMPLATE: $_fed"
		qvm-start --skip-if-running $_fed
		qvm-run -p $_fed 'sudo cp /home/user/.bashrc /root/'
		qvm-copy-to-vm $_fed ${_qtdom0}/xscreenshot
		qvm-copy-to-vm $_fed ${_qtdom0}/dpi
		qvm-run -p $_fed 'sudo mv /home/user/QubesIncoming/dom0/xscreenshot /usr/bin && sudo chmod +x /usr/bin/xscreenshot'
		qvm-run -p $_fed 'sudo mv /home/user/QubesIncoming/dom0/dpi /usr/bin && sudo chmod +x /usr/bin/dpi'
		qvm-shutdown --wait $_fed
	else
		echo "TEMPLATE:  $_fed does not exist. Skipping"	
	fi

	# CHANGE DEBIAN 
	if qvm-ls $_deb > /dev/null 2>&1 ; then 
		echo "MODIFYING TEMPLATE: $_deb"
		qvm-start --skip-if-running $_deb
		qvm-run -p $_deb 'sudo cp /home/user/.bashrc /root/'
		qvm-copy-to-vm $_deb ${_qtdom0}/xscreenshot
		qvm-copy-to-vm $_deb ${_qtdom0}/dpi
		qvm-run -p $_deb 'sudo mv /home/user/QubesIncoming/dom0/xscreenshot /usr/bin && sudo chmod +x /usr/bin/xscreenshot'
		qvm-run -p $_deb 'sudo mv /home/user/QubesIncoming/dom0/dpi /usr/bin && sudo chmod +x /usr/bin/dpi'
		qvm-shutdown $_deb
	else
		echo "TEMPLATE:  $_deb does not exist. Skipping"	
	fi
	
	# CHANGE WHONIX 
	if qvm-ls $_whonix > /dev/null 2>&1 ; then 
		echo "MODIFYING TEMPLATE: $_whonix"
		qvm-start --skip-if-running $_whonix
		qvm-run -p $_whonix 'sudo cp /home/user/.bashrc.whonix /root/'
		qvm-run -p $_whonix 'sudo rm /root/.bashrc'
		qvm-run -p $_whonix 'sudo ln -s /root/.bashrc.whonix /root/.bashrc'
		qvm-copy-to-vm $_whonix ${_qtdom0}/xscreenshot
		qvm-copy-to-vm $_whonix ${_qtdom0}/dpi
		qvm-run -p $_whonix 'sudo mv /home/user/QubesIncoming/dom0/xscreenshot /usr/bin && sudo chmod +x /usr/bin/xscreenshot'
		qvm-run -p $_whonix 'sudo mv /home/user/QubesIncoming/dom0/dpi /usr/bin && sudo chmod +x /usr/bin/dpi'
		qvm-shutdown $_whonix
	else
		echo "TEMPLATE:  $_whonix does not exist. Skipping"	
	fi
}
	
create_fedfull() {
	# MAKE SURE FEDORA EXISTS, THEN CLONE/START IT
	qvm-ls $_fed > /dev/null 2>&1 || return 1
	echo -e "\nCLONING $_fed into $_fedfull"
	qvm-clone $_fed $_fedfull
	qvm-start $_fedfull

	# ENABLE REPOS
	echo -e "\nMODIFYING $_fedfull WITH USEFUL REPOS: rpmfusion free/nonfree , librewolf, ungoogled-chromium"
	qvm-run -p $_fedfull 'sudo dnf config-manager -y --set-enabled rpmfusion-free'
	qvm-run -p $_fedfull 'sudo dnf config-manager -y --set-enabled rpmfusion-free-updates'
	qvm-run -p $_fedfull 'sudo dnf config-manager -y --set-enabled rpmfusion-nonfree'
	qvm-run -p $_fedfull 'sudo dnf config-manager -y --set-enabled rpmfusion-nonfree-updates'
	qvm-run -p $_fedfull 'sudo dnf config-manager -y --add-repo https://rpm.librewolf.net/librewolf-repo.repo' 
	
	# COPR AND CURL CANNOT RESOLVE DNS IN THE TEMPLATE UNLESS CONNECTED TO A NETVM
	qvm-prefs $_fedfull netvm sys-firewall
	qvm-run -p $_fedfull 'sudo dnf copr -y enable wojnilowicz/ungoogled-chromium'
	qvm-run -p $_fedfull 'sudo fsSL https://repo.librewolf.net/librewolf.repo | pkexec tee /etc/yum.repos.d/librewolf.repo'
	qvm-prefs $_fedfull netvm None

	# UPDATE REPOS AND INSTALL PROGRAMS TO FED-FULL
	qvm-run -p $_fedfull 'sudo dnf upgrade -y --refresh'
	echo -e "\nINSTALLING PACKAGES TO $_fedfull: libreoffice librewolf ungoogled-chromium transmission git"
	qvm-run -p $_fedfull 'sudo dnf install -y libreoffice librewolf ungoogled-chromium transmission git'
}

main() {
	def_variables	
	intro

	# INSTALL i3wm
	command -v i3 || sudo qubes-dom0-update -y i3 i3-settings-qubes

	files_to_dom0
	create_dispvms
	templates_modification
	create_fedfull

	echo -e "\nQUBES TRICKS INSTALLATION COMPLETE."
	echo "LEAVING $_fedfull RUNNING SO USER CAN INSTALL ADDITIONAL PACKAGES"
}

main
