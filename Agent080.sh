#!/bin/bash
DelTag="MX記錄";
DomainName="testCenter.html"
DomainNamePage="DomainIndexT.txt";
SubDomainIP="SubDomainIP.html";
recordPage="recordPage.html";
storePage="StorePage.txt";
loginID="your ID";
passw="Your Password";

function CheckArg() {
        if [ $# -eq 0 ];then
        echo "
example: sh $0  -W FileName  -D DomainNameBase	      ===>Modify IP of Hostname within   Batch Way
example: sh $0  -A FileName  -D DomainNameBase	      ===>Add  Subdomain and IP  within   Batch Way
example: sh $0  -d subdomainName  -D DomainNameBase   ===>Delete SubdomainName
example: sh $0  -g 				      ===>Gat Data
example: sh $0  -i 				      ===>Rebuild Domain Index
example: sh $0  -h
        ";
        exit 1;
        fi
}


#curl -d "t_username=admin4dns&t_password=Ali7701031!" -D 080DomainAuto.txt -e "http://name.080.net/" -k https://name.080.net/domain/user/login
function loginPass(){
	curl -d "t_username=$loginID&t_password=$passw" -D 080DomainAuto.txt -e "http://name.080.net/" -k https://name.080.net/domain/user/login
}
function logoutPass(){
	curl -b 080DomainAuto.txt  -k https://name.080.net/domain/user/logout &>/dev/null
}

#curl -d "id=81501&domain_id=18614&record_id=32996096&name=ddt&content=50.115.35.28&null=&ttl=360"  -b 080DomainAuto.txt  -k https://name.080.net/domain/member/domain_manager/md_ip_eip/18614/81501

function getStrDomain(){
	echo "$1"|sed -rn 's/^(([0-9a-z]){1,}\.)(.*)/\3/p';
}

function getDomainList(){
	#get web pages for https://name.080.net/domain/member/center
	curl  -b 080DomainAuto.txt  -k https://name.080.net/domain/member/center -o $DomainName &>/dev/null

	#file web page for testCenter.html
	cat $DomainName |sed -rn  's/<a href="\/domain\/member\/domain_manager\/info\/([0-9]{1,})" style="font-size\: 14px\;">(.*)<\/a>/\1 \2/p'|awk '{print $1 "\t" $2}' >$DomainNamePage

}


function getSubIDList(){
	if [ -f $SubDomainIP ];then	
		#cat SubDomainIP.html|sed ''$2','$3'd'|grep -A 2  "$1" --color|sed -rn  's/(^.*)<td>(.*)<\/td>/\2/p'|sed -rn 's/^<a(.*)\/'$4'\/(.*)"><img.*/\2/p';
		cat $SubDomainIP|sed ''$2','$3'd'|grep -A 2  "$1" --color|sed -rn  's/(^.*)<td>(.*)<\/td>/\2/p'|sed -rn 's/^<a(.*)\/'$4'\/(.*)"><img.*/\2/p';
	fi
}

function getrecorID(){
	if [ -f $recordPage.$1 ];then
		#cat recordPage.html |grep -i 'record_id' |sed -rn 's/^<input.* value="(.*)">/\1/p';
		cat $recordPage.$1 |grep -i 'record_id' |sed -rn 's/^<input.* value="(.*)">/\1/p';
	fi
}

function getHostname(){
	if [ -f $recordPage.$1 ];then
		#cat recordPage.html |sed -rn 's/.*<input .* >(.*)<\/td>/\1/p';
		cat $recordPage.$1 |sed -rn 's/.*<input .* >(.*)<\/td>/\1/p';
	fi
}
function getHostIP(){
	if [ -f $recordPage.$1 ];then
		cat $recordPage.$1 |sed -rn 's/.*<input .* name="content" .* value="(.*)"><\/td>/\1/p';
	fi
}
function getTTL(){
	if [ -f $recordPage.$1 ];then
		grep 'selected' $recordPage.$1|sed -rn 's/.*<option.*>(.*)<\/option>/\1/p'
	fi

}
function forkT(){
	curl -b 080DomainAuto.txt -k https://name.080.net/domain/member/domain_manager/md_ip_eip/$2/$3 -o $recordPage.$3 &>/dev/null && echo "$1;$2;$3;$(getrecorID $3);$(getHostname $3);$(getHostIP $3);$(getTTL $3)" >>$storePage;
}
function NameBaseHeader(){
	echo  "DomainName;DomainID;SubDomainID;RecordID;Hostname;HostIP;TTL" >$storePage;
}
function MainGetData(){
	
while read xx yy
 do 
  #echo "" >$SubDomainIP;
  curl -b 080DomainAuto.txt -k https://name.080.net/domain/member/domain_manager/md_ip/$xx -o $SubDomainIP &>/dev/null
  #CountTemp=$(cat SubDomainIP.html|wc -l);
  CountTemp=$(cat $SubDomainIP|wc -l);
  BingTag=$(grep  -n "$DelTag" $SubDomainIP |head -n 1|grep -E -o '^[0-9]{1,}');
  for subid in $(getSubIDList  $yy $BingTag $CountTemp $xx)
   do
	#curl -b 080DomainAuto.txt -k https://name.080.net/domain/member/domain_manager/md_ip_eip/$xx/$subid -o $recordPage &>/dev/null
	#echo "$yy;$xx;$subid;$(getrecorID);$(getHostname);$(getHostIP);$(getTTL)" >>$storePage;
	forkT $yy $xx $subid &
	
   done
 done < $DomainNamePage

}
function ClearTemLog(){
	rm -rf 080DomainAuto.txt $recordPage.*  $SubDomainIP $DomainName
}
function FormatData(){
	cat $storePage|awk -F';' '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}'|column -t
}
function updatDomainBase(){
	sed -i '/'$1'/d' $2 && echo "Update DomainBase OK!" || echo "Not OK";
}
function DeleteSubdomainName(){
  	curl -b 080DomainAuto.txt -k https://name.080.net/domain/member/domain_manager/md_del/$1/$2 -o $SubDomainIP &>/dev/null
}



function modiflyDomain(){
	curl -d "$1"  -b 080DomainAuto.txt  -k https://name.080.net/domain/member/domain_manager/md_ip_eip/$2/$3
}
#loginPass

function modifily(){
#myselfList  DomainList 
while read MathHostname MathHostIP
do
echo "===$MathHostname===";
List=$(awk '{if($5=="'$MathHostname'") print $0}' $2);
DomainID=$(echo $List|awk '{print $2}');
SubDomainID=$(echo $List|awk '{print $3}');
RecordID=$(echo $List|awk '{print $4}');
name=$(echo $List|awk '{print $5}'|cut -d"." -f1);
#echo "id=$SubDomainID&domain_id=$DomainID&record_id=$RecordID&name=$name&content=$MathHostIP&null&ttl=360";
checkStr=$(echo "$List"|awk '{if($1=="'$MathHostname'") print "DomainName"}')
if [ "$checkStr" == "DomainName" ];then name="";fi 
mArg="id=$SubDomainID&domain_id=$DomainID&record_id=$RecordID&name=$name&content=$MathHostIP&null&ttl=360";
#mArg="id=$SubDomainID&domain_id=$DomainID&record_id=$RecordID&name=$name&content=$MathHostIP&null&ttl=60";
echo $mArg
modiflyDomain $mArg $DomainID $SubDomainID
echo ""
done < $1
}


function AddSubDomain2(){
	curl -d "$1"  -b 080DomainAuto.txt  -k https://name.080.net/domain/member/domain_manager/md_ip_eip/$2
}

function AddSubDomain(){
#myselfList  DomainList 
while read AddHostname AddHostIP
do
List="";
echo "===$AddHostname===";
#List=$(awk '{if($5=="'$AddHostname'") print $5}' $2);
List=$(dig +answer +noquestion +nocomments +nostats +nocmd $AddHostname @8.8.8.8|awk '{print $4}');
if [  "$List" != "A" ];then
	DomainID=$(awk '{if($1=="'$(getStrDomain $AddHostname)'") print $2}' $2|uniq)	
	name=$(echo "$AddHostname"|cut -d"." -f1);
   else
	echo "It is exist for $AddHostname";
fi
mArg="id=&domain_id=$DomainID&record_id=&name=$name&content=$AddHostIP&ttl=360";
echo $mArg
AddSubDomain2 $mArg $DomainID
echo ""
done < $1
}

function checkforT(){
        chkArg=$(ps aux|grep -i curl|wc -l);
        if [ $chkArg -gt 1 ];then
                checkforT;
        fi
#       sleep 1

}
function checkFile(){
	
	if [ ! -f $1 ];then
		echo "Error Message: $1  was  not Found .";
		echo "";
		CheckArg;	
	fi

}

CheckArg $@
FileName="noneFile";
ADDFileName="noneFile";
DomainList="noneFile";
SubDomainClear="noneFile";

while getopts "W:A:D:d:gih"  options
do
        case $options in
                "W")
                FileName=$OPTARG
		checkFile $FileName;
                ;;
                "A")
                ADDFileName=$OPTARG
		checkFile $ADDFileName;
                ;;
                "D")
                DomainList=$OPTARG
		checkFile $DomainList;
                ;;
                "d")
                SubDomainClear=$OPTARG
		#chkTmp=$(cat $DomainList|awk '{if($5=="'$SubDomainClear'") print $0}');
		#	if [ -z $chkTmp ];then
		#		echo "$SubDomainClear is not  exist in $DomainList Base. "
		#		CheckArg;	
		#	fi
                ;;
		"g")
		echo "Get Data";
		loginPass
			if [ ! -f $DomainNamePage ];then
				#getDomainList
				echo "The DomainIndex.txt is not exist. Need Rebuild Domain Index. Please Input  Y/N: ";
				read str
					case $str in
        				"Y")
                				echo "Start .. ReBuild Domain Index"
						getDomainList
        				;;
  				        "N")
						logoutPass;
                				exit 1;
        				;;
       					esac
				#exit 1;
			fi 
		NameBaseHeader
		MainGetData	
		checkforT
		sleep 1
		ClearTemLog
		logoutPass
		FormatData
		exit 0;
		;;
		"i")
		echo "Start .. ReBuild Domain Index";
		loginPass
		getDomainList
		logoutPass
		exit 0;
		;;
                "h")
                CheckArg
                exit 1;
                ;;
                ?)
                exit 1;
                ;;


        esac

done

if [ $FileName != "noneFile" -a $DomainList != "noneFile" ];then
	loginPass	
	modifily $FileName $DomainList
	#sleep 1
	logoutPass
	exit 0
#	echo "$FileName :  $DomainList";

fi

if [ $ADDFileName != "noneFile" -a $DomainList != "noneFile" ];then
	loginPass	
	AddSubDomain $ADDFileName $DomainList
	#sleep 1
	logoutPass
	exit 0
#	echo "$FileName :  $DomainList";

fi

if [ $SubDomainClear != "noneFile" -a $DomainList != "noneFile" ];then
#echo $SubDomainClear 
	#chkTmp=$(cat $DomainList|awk '{if($5=="'$SubDomainClear'") print $5}');
	ArryTmp=($(cat $DomainList|awk '{if($5=="'$SubDomainClear'") print $0}'));
	if [ -z ${ArryTmp[4]} ];then
			echo "$SubDomainClear is not  exist in $DomainList Base. "
			CheckArg;	
	fi
	read -p "Are you Sure to Delete $SubDomainClear. Please Input  a  Y/N :" argtmp
	case $argtmp in
     		"Y")
        		echo "Start .. Delete $SubDomainClear: DomainID: ${ArryTmp[1]} SubDomainID : ${ArryTmp[2]}";
			loginPass
			DeleteSubdomainName ${ArryTmp[1]} ${ArryTmp[2]}
			logoutPass
			echo "Start ..Update DomainBase..";
			updatDomainBase ${ArryTmp[2]} $DomainList;
			exit 0;
     		;;
     		"N")
			CheckArg;
    		;;    				
	esac
fi


CheckArg
