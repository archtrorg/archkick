#!/usr/bin/env bash
if [ "$1" = "inchroot" ]
then
    echo "If you see this text, you are now in your system (or chrooted)!"
    echo "Getting timezones ready..."
    sleep 1
    while true
    do
	clear
	echo "Listing all Zones"
	ls /usr/share/zoneinfo/
	echo -n "Please type your zone [EX America]: "
	# dia
	read zonein
	if [ ! -d "/usr/share/zoneinfo/$zonein" ]
	then
		echo "ERROR: Please enter a valid zone"
		echo "Make sure you include the capital letters!"
		sleep 2
	else
		break
	fi
    done

    while true
    do
	clear
	echo "Listing all Zones"
	ls "/usr/share/zoneinfo/$zonein"
	echo -n "Please type your Subzone [EX New_York]: "
	read subin
	if [ ! -f "/usr/share/zoneinfo/$zonein/$subin" ]
	then
	    echo "ERROR: Please enter a valid subzone"
	    echo "Make sure you include the capital letters!"
	    # why does commenting extst dialog
	    sleep 2
	else
	    break
	fi
    done
    ln -sf /usr/share/zoneinfo/$zonein/$subin /etc/localtime
    echo ">>> Using hardware clock to generate..."
    hwclock --systohc
    echo "We are going to use nano again to edit the locale file!"
    echo "All you need to do is uncomment the line that contains your locale!"
    echo "For example: '#text', will become 'text' instead!"
    echo "Would you like to edit that file? [y/n]"
    # e is a whole me
    read -rsn1 chck
    if [ "$chck" = "y" ]
    then
	nano /etc/locale.gen
    else
	echo "Skipping then... [not recommended]"
    fi
    echo "Generating the locale!"
    locale-gen
    clear
    echo "Note, use A-Z,'-' characters only."
    echo "Example hostname: archlinux-pc"
    echo ""
    echo -n "Please type your system hostname: "
    read hostnm
    echo "$hostnm" >> /etc/hostname
    echo ">>> Installing wifi drivers... [if you use ethernet it wont matter]"
    pacman -S dialog wpa_supplicant iw
    clear
    echo ">>> Setting root password"
    passwd
    echo ">>> Installing grub [please accept install]"
    pacman -S grub
    echo ">>> Installing grub onto $2"
    grub-install /dev/$2
    echo ">>> Generating grub file..."
    grub-mkconfig -o /boot/grub/grub.cfg
    clear
    # you know what needs to be done here saderror
    echo "Hooray! You made it! :D. Your system is all ready for use... but, not entirely."
    echo "Now it is time for a post-install."
    echo "You are safe to reboot without doing a post install, which means"
    echo "You have to manually install your desktop environment, tools, and many more.."
    echo ""
    echo "The post install will:"
    echo "- Let you setup your user account"
    echo "- Install your favorite tools"
    echo "- Install a desktop environment/window manager"
    echo "- Some other post install thingies..."
    echo ""
    echo "A post install is totally recommended! Meaning you should do it"
    echo "-------------------------------------------"
    echo "  Press any key to enter the post install"
    read -rsn1
    clear
    echo "- Create your account -"
    # dialog this bit will need decision
    echo "Please use characters a-z, A-Z, 1-9, and '-'."
    echo "Good username: bobthe-Cat0123"
    echo "BAD username: Bobby The Cat 42"
    echo ""
    echo -n "Please enter your username: "
    read usname
    useradd -m -s /bin/bash $usname
    passwd $usname
    echo "User $usname has been created!"
    echo "Putting user in sudoers file"
    echo "$usname ALL=(ALL) ALL" >> /etc/sudoers
    echo "User creation done..."
    clear
    echo "Desktop environments and window managers"
    echo "To select: Simply press the letter that you install, for example:"
    echo "Pressing 'g' installs the Gnome desktop environment"
    echo ""
    # me want dialog here
    echo "a = Awesome"
    echo "b = Budgie (Will also install GNOME)"
    echo "d = Deepin"
    echo "f = Fluxbox"
    echo "g = GNOME"
    echo "i = i3wm"
    echo "k = KDE Plasma"
    echo "l = LXDE"
    echo "m = MATE"
    echo "o = Openbox"
    echo "p = Pantheon"
    echo "w = Bspwm"
    echo "x = Xfce"
    echo "[a/b/d/f/g/i/k/l/m/o/p/w/x]?"
    read -rsn1 da
    if [ "$da" = "g" ]
    then
	echo "Installing GNOME..."
	echo "Continue pressing enter to accept all dependencies"
	sleep 1
	pacman -S gnome gnome-extra gdm tilix
	echo "Note: Gnome-terminal is broken... use tilix"
	sleep 2
    elif [ "$da" = "k" ]
    then
	echo "Installing KDE Plasma..."
	echo "Continue pressing enter to accept all dependencies"
	sleep 1
	pacman -S plasma sddm kde-applications
    elif [ "$da" = "x" ]
    then
	echo "Installing Xfce..."
	echo "Continue pressing enter to accept all dependencies"
	sleep 1
	pacman -S xfce4 xfce4-goodies
    elif [ "$da" = "l" ]
    then
	echo "Installing LXDE..."
	echo "Continue pressing enter to accept all dependencies"
	sleep 1
	pacman -S lxde lxde-common
    elif [ "$da" = "b" ]
    then
	echo "Installing Budgie..."
	echo "Continue pressing enter to accept all dependencies"
	sleep 1
	pacman -S budgie-desktop gnome gnome-extra tilix
	echo "Note: Gnome-terminal is broken... use tilix"
    elif [ "$da" = "m" ]
    then
	echo "Installing Mate..."
	echo "Continue pressing enter to accept all dependencies"
	sleep 1
	pacman -S mate mate-extra lightdm
    elif [ "$da" = "o" ]
    then
	echo "Note: Installing a window manager requires some experience..."
	sleep 1
	pacman -S openbox
    elif [ "$da" = "i" ]
    then
	echo "Note: Installing a window manager requires some experience..."
	sleep 1
	pacman -S i3-gaps i3lock i3block i3status imagemagick
    elif [ "$da" = "f" ]
    then
	echo "Note: Installing a window manager requires some experience..."
	sleep 1
	pacman -S fluxbox
    elif [ "$da" = "w" ]
    then
	echo "Note: Installing a window manager requires some experience..."
	sleep 1
	pacman -S bspwm
    elif [ "$da" = "a" ]
    then
	pacman -S awesome
	elif [ "$da" = "d" ]
    then
	pacman -S deepin deepin-extra
	elif [ "$da" = "p" ]
    then
	pacman -S pantheon
    else
	echo "You did not choose a valid de/wm, skipping!"
    fi
    echo "Installing extra stuff"
    pacman -S networkmanager
    pacman -S xorg xorg-server
    if [ "$da" = "g" ]
    then
	systemctl enable gdm.service
    elif [ "$da" = "k" ]
    then
	systemctl enable sddm.service
    else
	echo "Installing your display manager..."
	pacman -S lightdm
	systemctl enable lightdm
    fi
    systemctl enable NetworkManager
    pacman -S network-manager-applet
    systemctl enable nm-applet
    echo "Installing pulseaudio so you can hear the ocean... :D"
    pacman -S pulseaudio
    systemctl enable pulseaudio.socket
    pacman -S pa-applet
    systemctl enable pa-applet
    clear
    # hey dialog me
    echo "Tool installation"
    echo "------------------"
    echo "Do you want firefox? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S firefox
    fi
    echo "Do you want chromium? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S chromium
    fi
    echo "Do you want kdenlive? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S kdenlive
    fi
    echo "Do you want Geany? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S geany
    fi
    echo "Do you want Geary for email? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S geary
    fi
    echo "Do you want yaourt for AUR [recommended]? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	echo "Yaourt is broken, sorry for the inconvience."
    fi
    echo "Do you want emacs? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S emacs
    fi
    echo "Do you want telegram? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S telegram-desktop
    fi
    echo "Do you want riot messenger? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S riot-desktop
    fi
    echo "Do you want libreoffice? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
	   pacman -S libreoffice-fresh
    fi
    echo "Do you want hexchat? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
	   pacman -S hexchat
    fi
    echo "Do you want simplescreenrecorder? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
	   pacman -S simplescreenrecorder
    fi
    echo "Do you want OBS Studio? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
	   pacman -S obs-studio
    fi
    echo "Do you want lmms? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S lmms
    fi
    echo "Do you want gimp? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
	   pacman -S gimp
    fi
    echo "Do you want vlc? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S vlc
    fi
    echo "Do you want htop [term]? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S htop
    fi
    echo "Do you want lxappearance? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S lxappearance
    fi
    echo "Do you want Polybar? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S polybar
    fi
    echo "Do you want Dunst? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
	   pacman -S dunst
    fi
    echo "Do you want rofi? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S rofi
    fi
    echo "Do you want git? [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S git
    fi
    echo "Do you want vim? [term] [y/n]"
    read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	pacman -S vim
    fi
        echo "Do you want a pet cat? [joke] [y/n]"
        read -rsn1 chc
    if [ "$chc" = "y" ]
    then
    	echo "MEOW!!! MEOW!!! MEOW!!! MEOW!!! MEOW!!! MEOW!!! MEOW!!! MEOW!!!"
    fi
    echo "You are at the end of the line for packages."
    sleep 1
    echo "Removing post installer..."
    rm -rf /usr/bin/archkick
    clear
    echo "Hooray! :D"
    sleep 1
    echo "Your setup is done!"
    sleep 1
    echo "You have successfully installed arch linux onto your system!"
    sleep 1
    echo ""
    echo "Getting ready to reboot in 5 seconds!"
    sleep 1
    echo "4"
    sleep 1
    echo "3"
    sleep 1
    echo "2"
    sleep 1
    echo "1"
    sleep 1
    exit
else
    dialog --backtitle "ArchKick v2.0" --msgbox "Archkick is made for making arch easier to install! It reduces the pain and time of installing arch linux with a simplified installer, it also provides extra settings like picking a desktop environment/window manager so you dont have to spend hours configuring things!" 13 40
    dialog --backtitle "ArchKick v2.0" --msgbox "Notice:\nArchkick isnt perfect, so just note these, PS, these are temporary and will be added in the future.\n  - You are to be using a legacy bios, not UEFI.\n  - Only english keymap support, a fork would be needed for multiple version\n  - May not work for nvidia drivers\n  - May not work on all machine\nA try is worth of course, just be careful not to break your whole system. This guy may nuke." 16 60
    dialog --backtitle "ArchKick v2.0" --yes-label "Wifi" --no-label "Ethernet" --yesno "Do you use wifi or ethernet?" 6 50
    chc=$?
    if [ $chc = 0 ]
    then
    	echo "Wifi selected. Running wifi-menu tool"
        wifi-menu
    	break
    elif [ $chc = 1 ]
    then
        echo "Ethernet selected, no problem since it works out of the box!"
        break
    else
        break
    fi
    echo ">>> Updating system clock"
    timedatectl set-ntp true
    clear
    echo "= Partitioning ="
    # Could probably dialog this bit up here
    echo "Showing all devices"
    lsblk
    echo "Please format your answer like this, sda, sdb, sdc, and so on..."
    echo "DO NOT INCLUDE THE /dev/ PART IN IT!"
    echo ""
    echo -n "Please enter your host system to install on [ex: sda, sdb, sdc]: "
    read partname
    echo -n "What number for /dev/$partname are you putting root on? [ex: 1, 2, 3]: "
    read partnum
    while true
    do
	echo "Are you going to use swap? [y/n]"
	# dialog this bit as well
	read -rsn1 swapa
	if [ "$swapa" = "y" ]
	then
	    echo -n "What number for /dev/$partname are you putting SWAP on? [ex: 1, 2, 3]: "
	    read swapnum
	    swap="on"
	    break
	elif [ "$swapa" = "n" ]
	then
	    echo "Swap will NOT be selected"
	    swap="off"
	    break
	else
	    clear
	fi
    done
    dialog --backtitle "ArchKick v2.0" --msgbox "Opening cfdisk for ease of use. If you are unsure how to use it, you can always pull up a second device and see how to use it. Remember to write the changes to disk once done.\n\nSummary\n- Root will be on $partname$partnum\n- Swap will be on $partname$swapnum" 13 50
    cfdisk /dev/$partname
    echo "Formatting root as ext4..."
    mkfs.ext4 /dev/$partname$partnum
    if [ "$swap" = "on" ]
    then
	echo "Creating swap..."
	mkswap /dev/$partname$swapnum
	swapon /dev/$partname$swapnum
    fi
    mount /dev/$partname$partnum /mnt
    dialog --backtitle "ArchKick v2.0" --yesno "Do you want to edit the mirrorlist file? You probably should." 7 50
    rchc=$?
    if [ $rchc = 0 ]
    then
	nano /etc/pacman.d/mirrorlist
    elif [ $rchc = 0 ]
    then
	echo "Skipping then..."
    else
	echo "Skipping then..."
    fi
    clear
    dialog --backtitle "ArchKick v2.0" --yes-label "Full" --no-label "Base" --yesno "Getting ready to install the full system.\n\nIf you want base and base-devel, select full.\nIf you want base only, select base.\n\nIf you are confused, please select full." 10 50
    chcc=$?
    if [ $chcc = 0 ]
    then
	echo "Installing the base and base-devel!"
	pacstrap /mnt base base-devel
    elif [ $chcc = 1 ]
    then
	echo "Ok, installing base only. [Not recommended]"
	pacstrap /mnt base
    else
	echo "Non valid option selected. Installing base-devel..."
	pacstrap /mnt base base-devel
    fi
    genfstab -U /mnt >> /mnt/etc/fstab
    chmod +x archkick.sh
    cp archkick.sh /mnt/usr/bin/archkick
    arch-chroot /mnt archkick inchroot $partname
    reboot
fi
