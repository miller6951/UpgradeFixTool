winDu () {
		#SET FILE PATHS
		windu_log_location="$wc1_home/Windchill/WinDU/logs"
		#checking if windu was ran before
				echo "Status - WinduLog location : $windu_log_location"
				if [ ! -d $windu_log_location ]
				then
					echo "Status - First time running windu"
				else
					echo "Status - Moving old windu logs to oldlogs folder"
					mkdir $WC_HOME/Windchill/WinDU/oldlogs
					cd $windu_log_location
					mv * $WC_HOME/Windchill/WinDU/oldlogs
					cd $WC_HOME
					rm -rf $windu_log_location/*
					rm -rf $windu_log_location
							
					fi
		echo "STATUS - Starting WinDU"

		cat $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/windu.txt
		readarray windu_tasks < $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/windu.txt

		let j=0
		for dir in "${windu_tasks[@]}"; do
			echo "$((j++)) - $dir"
		done
		windu_xml_list_raw="$(join_by , "${windu_tasks[@]}")"
		#windu_xml_list="$(echo $windu_xml_list_raw | tr -d '\r' | tr -d '\040\011\012\015')"
		windu_xml_list="$(echo $windu_xml_list_raw | tr -d '\r' | tr -d ',')"
		echo "WINDU XML LIST - $windu_xml_list"



		windchill --jap=wt.properties?com.ptc.windchill.upgrade.tools.windu.java.args --cpp=wt.properties?com.ptc.windchill.upgrade.tools.classpath com.ptc.windchill.winruwinducommon.headless.WindruTaskExecutor --user $WCuser --password $WCpass --winduGroup $windu_xml_list
		cd $windu_log_location
		windu_latest_log_folder="$(ls -rt | tail -1)"
		echo "latest_log_folder: $windu_latest_log_folder"
		windu_log_folder_used="$windu_log_location/$windu_latest_log_folder"
		echo "Using THIS LOG folder: $windu_log_folder_used"
		# zipping up latest windu log folder
							cd $windu_log_location
							zip -r latest_windu.zip $windu_latest_log_folder
		curl -F file=@$windu_log_location/latest_windu.zip -F channels=CA0DDV691 -F title=WinDu_Log_Host:$serv_host -F token=xoxb-341447570482-OTnOVzPsYBMdrrC3rqz90V9O https://slack.com/api/files.upload		
}


winRu () {


		#SET FILE PATHS
		winru_log_location="$wc1_home/Windchill/WinRU/logs"
		#checking if winru was ran before
						echo "Status - WinruLog location : $winru_log_location"
						if [ ! -d $winru_log_location ]
						then
								echo "Status - First time running winru"
						else
								echo "Status - Moving old winru logs to oldlogs folder"
								mkdir $WC_HOME/Windchill/WinRU/oldlogs
								cd $windu_log_location
								mv * $WC_HOME/Windchill/WinRU/oldlogs
								cd $WC_HOME
								rm -rf $winru_log_location/*
								rm -rf $winru_log_location

								fi
		echo "STATUS - Starting WinRU"


		cat $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/winru.txt
		readarray winru_tasks < $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/winru.txt

		let j=0
		for dir in "${winru_tasks[@]}"; do
			echo "$((j++)) - $dir"
		done
		winru_xml_list_raw="$(join_by , "${winru_tasks[@]}")"
		#winru_xml_list="$(echo $winru_xml_list_raw | tr -d '\r' | tr -d '\040\011\012\015')"
		winru_xml_list="$(echo $winru_xml_list_raw | tr -d '\r' | tr -d ',')" 
		echo "WINRU XML LIST - $winru_xml_list"
		echo " "
		echo " "

		echo "INFO - USERNAME: $WCuser"
		echo "INFO - PASSWORD: $WCpass"
		echo "INPUT - Press Enter to continue"

		#RUN WINRU

		echo "windchill --jap=wt.properties?com.ptc.windchill.upgrade.tools.winru.java.args --cpp=wt.properties?com.ptc.windchill.upgrade.tools.classpath com.ptc.windchill.winruwinducommon.headless.HeadlessWinruTaskExecutor --user $WCuser --password $WCpass --winruList $winru_xml_list"

		windchill --jap=wt.properties?com.ptc.windchill.upgrade.tools.winru.java.args --cpp=wt.properties?com.ptc.windchill.upgrade.tools.classpath com.ptc.windchill.winruwinducommon.headless.HeadlessWinruTaskExecutor --user $WCuser --password $WCpass --force --winruList $winru_xml_list


		cd $winru_log_location
		winru_latest_log_folder="$(ls -rt | tail -1)"
		echo "latest_log_folder: $winru_latest_log_folder"
		winru_log_folder_used="$winru_log_location/$winru_latest_log_folder"
		echo "Using THIS LOG folder: $winru_log_folder_used"
		# zipping up latest winru log folder
												cd $winru_log_location
												zip -r latest_winru.zip $winru_latest_log_folder
		curl -F file=@$winru_log_location/latest_winru.zip -F channels=CA0DDV691 -F title=WinRu_Log_Host:$serv_host -F token=xoxb-341447570482-OTnOVzPsYBMdrrC3rqz90V9O https://slack.com/api/files.upload
}

customFiles () {
		echo "STATUS - Copying custom files to $wc1_home/Windchill"
		cp $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/customFiles.zip $wc1_home/Windchill/customFiles.zip
		echo "STATUS - Unzipping custom files"
		unzip -o $wc1_home/Windchill/customFiles.zip -d $wc1_home/Windchill/

}

DBMods () {
		echo "Input - Enter target DB hostname"
			read target_db_hostname
			echo "Input - Enter target DB Schema"
			read target_db_schema
			echo "Input - Enter DB password"
			read target_db_password
			echo "Input - Enter target DB service name ex Wind"
			read target_db_service
			echo "Input - Enter DB Port"
			read target_db_port
		#SET GLOBAL VARS
			export target_db_hostname=$target_db_hostname
			export target_db_schema=$target_db_schema
			export target_db_password=$target_db_password
			export target_db_service=$target_db_service
			export target_db_port=$target_db_port

		#Check DB CONNECTION
			echo "STATUS - Checking Database Connection"
		#
		#	echo "exit" | sqlplus "$target_db_schema/$target_db_password@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=$target_db_hostname)(Port=$target_db_port))(CONNECT_DATA=(SID=$target_db_service)))" | grep Connected > /dev/null
		#	if [ $? -eq 0 ] 
		#	then
		#  	echo "STATUS - Connected Successfully to Database"
		#	else
		#  	echo "ALERT - Cannot Connect TO Database please check tnsnames and entered db ifo"
		#  	exit 0
		#	fi

		echo " " >> $script_location/UpgradeFixTool-master/lib/dbMod.sh
		cat "$CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/db_updates.txt" >> $script_location/UpgradeFixTool-master/lib/dbMod.sh
		echo " " >> $script_location/UpgradeFixTool-master/lib/dbMod.sh
		echo "EOF" >> $script_location/UpgradeFixTool-master/lib/dbMod.sh
		chmod +x /$script_location/UpgradeFixTool-master/lib/dbMod.sh
		echo "STATUS - Updating DB"
		# $script_location/UpgradeFixTool-master/lib/dbMod.sh

}


DownloadCustomerInfo () {

		wget "https://github.com/miller6951/UpgradeFixTool/archive/master.zip"
		unzip -o master.zip
		rm -rf master.zip
}

SiteAdditions () {
		echo "STATUS - MODIFY SITE.XCONF"
		cd $wc1_home/Windchill
		sed -i '$d' $wc1_home/Windchill/site.xconf
		cat $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/site_additions.txt >> $wc1_home/Windchill/site.xconf
		echo " " >> $wc1_home/Windchill/site.xconf
		echo '</Configuration>'>> $wc1_home/Windchill/site.xconf
		xconfmanager -p
}

shellCommands () {
		chmod +x $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/shell_commands.sh
		$CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/shell_commands.sh
}


#Downloading from repo
	#echo "STATUS - Downloading Latest customer info"
	#DownloadCustomerInfo
echo " "
echo "*********************************************"
echo " --- Pre-Upgrade Fix Manager --"
echo "Created By: Ron Miller"
echo "*********************************************"
echo " "
echo "ALERT - Please run as root and in windchill shell"
script_location="$(pwd)"
#Join for array outs and xmls
function join_by { local IFS="$1"; shift; echo "$*"; }
serv_host="$(hostname)"
#Location for customer list and fixes
CustomerLocation="$script_location/UpgradeFixTool-master/customer/"
wc1_home="$(echo $WT_HOME | sed "s/\/Windchill\/bin\/..//g")"

#FIND CUSTOMER LIST
echo "STATUS - Scanning Customer List"
echo " "
echo " "
echo "Customer List"
echo "************************************************"
readarray -t customers < <(find $CustomerLocation -maxdepth 1 -type d -printf '%P\n')
let i=0
for dir in "${customers[@]}"; do
    echo "$((i++)) - $dir"
done
echo "************************************************"
echo "  "
echo "INPUT - Enter Cutomer Number"
read customer_number
echo "STATUS - Selected Customer ${customers[$customer_number]}"

#FIND PROJECTS FOR CUSTOMER
echo "STATUS - Scanning Project List for ${customers[$customer_number]}"
echo " "
echo " "
echo "Project List"
echo "************************************************"
readarray -t projects < <(find $CustomerLocation/${customers[$customer_number]} -maxdepth 1 -type d -printf '%P\n')
let e=0

for dir in "${projects[@]}"; do
    echo "$((e++)) - $dir"
done
echo "************************************************"

#join_by , "${customers[@]}"

echo "INPUT - Choice Project Number"
read project_number

#FIND TASK  FOR CUSTOMER
echo "STATUS - Scanning Task List for ${customers[$customer_number]}"
echo " "
echo " "
echo "Task List"
echo "************************************************"
readarray -t tasks < <(find $CustomerLocation/${customers[$customer_number]}/${projects[$project_number]} -maxdepth 1 -type d -printf '%P\n')
let e=0

for dir in "${tasks[@]}"; do
    echo "$((e++)) - $dir"
done
echo "************************************************"

#join_by , "${customers[@]}"

echo "INPUT - Choice Task Number"
read task_number

echo "STATUS - Selected ${customers[$customer_number]} project -  ${projects[$project_number]} Task - ${tasks[$task_number]}"
#FIND Fix Summary
echo "  "
echo "INFO - Below is the Fix Summary for what will be deployed and updated"
echo " "
echo "--------------- Fix Summary ---------------"
cat $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/fixSummary.txt
echo " "
echo "--------------------------------------------- "
echo " "

#Set detection vatiables to false
winRudet="false"
sitedet="false"
dbdet="false"
customdet="false"
winDudet="false"
shellcommandsdet="false"
ugmdet="false"

#CHECK WHAT MODS EXIST
echo "STATUS - SCANNING WHAT MODS EXIST FOR SYSTEM"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo "INFO - Current MODS EXIST IN REPO FOR ${customers[$customer_number]} UNDER THE ${projects[$project_number]} PROJECT"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/windu.txt && echo "- WinDU Tasks" && winDudet="true"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/winru.txt && echo "- WinRU Tasks" && winRudet="true"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/site_additions.txt && echo "- Site.xconf Additions" && sitedet="true"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/db_updates.txt && echo "- Database Updates" && dbdet="true"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/customFiles.zip && echo "- Custom Files" && customdet="true"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/shell_commands.sh && echo "- Shell Commands" && shellcommandsdet="true"
test -f $CustomerLocation${customers[$customer_number]}/${projects[$project_number]}/${tasks[$task_number]}/ugm_properties.sh && echo "- Execute Upgrade Manager" && ugmdet="true"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"

echo " "
#Get WC Creds
        echo "INPUT - Enter Windchill SiteAdmin Username"
        read WCuser
        echo "INPUT - Enter Windchill SiteAdmin Password"
        read WCpass
echo "INPUT - Press Enter to continue or CTRL+C to exit"
read pass

if [ "$winDudet" == "true" ]; then
echo "STATUS - EXECUTING WINDU WITH PRESET TASKS FROM REPO"
winDu
fi

if [ "$winRudet" == "true" ]; then
echo "STATUS - EXECUTING WINRU WITH PRESET FIXES FROM REPO"
winRu
fi

if [ "$sitedet" == "true" ]; then
echo "STATUS - EXECUTING SITE.xconf UPDATES"
SiteAdditions
fi

if [ "$dbdet" == "true" ]; then
echo "STATUS - EXECUTING DB UPDATES FROM REPO"
DBMods
fi

if [ "$customdet" == "true" ]; then
echo "STATUS - DEPLOYING CUSTOM FILES FROM REPO"
customFiles
fi

if [ "$shellcommandsdet" == "true" ]; then
echo "STATUS - EXECUTING SHELL COMMANDS FROM REPO"
shellCommands
fi


