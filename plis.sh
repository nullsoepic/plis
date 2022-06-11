#!bin/bash

YE='\033[1;33m'
NC='\033[0m' 
GR='\033[0;32m'
RE='\033[0;31m'
BL='\033[0;34m'

printf "${BL} *******  **       **  ********
/**////**/**      /** **////// 
/**   /**/**      /**/**       
/******* /**      /**/*********
/**////  /**      /**////////**
/**      /**      /**       /**
/**      /********/** ******** 
//       //////// // ////////  ${NC}

"

printf "${YE} A quick pterodactyl uninstaller\n"
printf "${YE}   Made by MeVibing aka NullDev\n"
printf "${YE}       github.com/nullsoepic\n \n"

printf "${GR} Beginning uninstall process\n \n"
printf "${RE} This process will remove all panel and wings data including servers/backuos(optionally), this is irreversible, do you wish to proceed? [y/N] "
read CONF
case "$CONF" in 
  y|Y ) printf "${GR} Confirmed, continuing..\n";;
  n|N ) printf "${GR} Exiting..\n" exit 0;;
  * ) printf "${GR} Exiting..\n" exit 0;;
esac

printf "${YE} Do you use Nginx or Apache? [n/a]"
read WSS
case "$WSS" in 
  n|N ) printf "${GR} Selected Nginx..\n" WS = "Apache";;
  a|A ) printf "${GR} Selected Apache..\n" WS = "Nginx";;
  * ) printf "${RE} Invalid Option..\n" exit 0;;
esac

printf "${YE} Do you want to remove server files and backups? [y/N]"
read RMSO
case "$RMSO" in 
  y|Y ) printf "${GR} Server files will be removed\n" RMS = true;;
  n|N ) printf "${GR} Server files will NOT be removed\n" RMS = false;;
  * ) printf "${GR} Server files will NOT be removed\n" RMS = false;;
esac

printf "${YE} MySQL/MariaDB panel user? [Default: panel']"
read PDBU
case "$PDBU" in 
  " " ) printf "${GR} Using default user \'panel\'... \n" DBU = 'panel';;
  * ) printf "${GR} Using custom user \'${PDBU}\'... \n" DBU = $PDBU;;
esac

printf "${YE} MySQL/MariaDB panel database? [Default: pterodactyl]"
read PDBD
case "$PDBD" in 
  " " ) printf "${GR} Using default database \'pterodactyl\'... \n" DBD = 'pterodactyl';;
  * ) printf "${GR} Using custom database \'${PDBD}\' \n" DBD = PDBD;;
esac

printf "${GR}   Removing panel files(this may take a bit)..\n"
sudo rm -rf /var/www/pterodactyl
printf "${GR}   Removing queue worker.. \n"
sudo rm /etc/systemd/system/pteroq.service
if [[$WS = "Apache"]]; then
printf "${GR}   Removing apache config link \n"
sudo unlink /etc/apache2/sites-enabled/pterodactyl.conf
elif [[$WS = "Nginx"]]; then
printf "${GR}   Removing nginx config link \n"
sudo unlink /etc/nginx/sites-enabled/pterodactyl.conf
else
printf "${RE}   An error occured? Exiting... \n"
exit 0
fi

printf "${GR}   Stopping wings... \n"
sudo systemctl stop wings
if "$RMS"; then
printf "${GR}   Removing server files and backups... \n"
sudo rm -rf /var/lib/pterodactyl
else
printf "${GR}   Ignoring server files and backups(located in /var/lib/pterodactyl)... \n"
fi
printf "${GR}   Removing wings config... \n"
sudo rm -rf /etc/pterodactyl
printf "${GR}   Removing wings binary... \n"
sudo rm /usr/local/bin/wings
printf "${GR}   Removing wings daemon... \n"
sudo rm /etc/systemd/system/wings.service

printf "${GR}   Removing databases... \n"
sudo mysql -u root -e "DROP DATABASE ${DBD}"
printf "${GR}   Dropped \'${DBD}\' database.. Removing user... \n"
sudo mysql -u root -e "DROP USER '${DBU}'@'127.0.0.1';"
printf "${GR}   Dropped user \'${DBU}\'... \n"

printf "${GR} \n \n \n Pterodactyl Panel has been successfuly removed!"
printf "${BL} **********   **      **       **       ****     **   **   **
/////**///   /**     /**      ****     /**/**   /**  /**  ** 
    /**      /**     /**     **//**    /**//**  /**  /** **  
    /**      /**********    **  //**   /** //** /**  /****   
    /**      /**//////**   **********  /**  //**/**  /**/**  
    /**      /**     /**  /**//////**  /**   //****  /**//** 
    /**      /**     /**  /**     /**  /**    //***  /** //**
    //       //      //   //      //   //      ///   //   // 
 **    **     *******     **     **                          
//**  **     **/////**   /**    /**                          
 //****     **     //**  /**    /**                          
  //**     /**      /**  /**    /**                          
   /**     /**      /**  /**    /**                          
   /**     //**     **   /**    /**                          
   /**      //*******    //*******                           
   //        ///////      ///////                            \n \n \n${NC}"

 exit 0
