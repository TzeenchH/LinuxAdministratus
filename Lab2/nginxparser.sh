##!/bin/bash
##
##Created by Evgeniy A. Vasilenko
##
## This script parses nginx logs and takes required info
## exit 0 - successfull end of the script;
## error codes:
##	1 - script already running;
##	2 - not all required paremeters specified;
##	3 - file empty or invalid;
##	3 - empty file name;
## check if script already running

count=$( ps aux | grep $0 | wc -l )
if [[ $count -gt 3 ]]
then
	echo "script already running"
	exit 1
fi
##check if all required parameters specified 
if [[ $# -lt 2 ]]
then
	echo "not all required parameters specified"
	exit 2
fi
## check that filename is not empty
if [[ -z $1 ]]
then
	echo "logfile name is empty"
	exit 2
fi
## check that transferred file is valid and not empty
if [[ ! -f $1 && ! -s $1 ]]
then	
	echo "file empty or invalid"
	exit 3
fi
FILE_TO_EXPLORE=$1
##if rowcount is not set, return first 15 rows by default
if [[ -z $3 ]]
then 
	CNT=15
fi
CNT=$3
## check if options parameter ist`t empty
if [[ -n $2 ]]
then
else
	echo "searcting option required"
	exit 4
fi

## functions block
top_links {
tmp_top_l=$( cat ${FILE_TO_EXPLORE} | awk '{print $1}' | sort -n | uniq -c | sort -nr | head -$CNT )

printf "Top" "$CNT" "links\n"
printf "====================\n"
printf "$tmp_top_l"
exit 0
}

low_links {
tmp_low_l=$( cat ${FILE_TO_EXPLORE} | awk '{print $1}' | sort -n | uniq -c | sort -nr | tail -$CNT )
                                                                                                                 
printf "Low" "$CNT" "links\n"
printf "====================\n"
printf "$tmp_low_l"
exit 0
}

top_routes {
tmp_top_r=$( cat ${FILE_TO_EXLORE} | awk '{print $7}' | sort -n | uniq -c | sort -nr | head -$CNT )

printf "Top" "$CNT" "routes\n"
printf "=====================\n"
printf "$tmp_top_r"
exit 0
}

low_routes {
tmp_low_r=$( cat ${FILE_TO_EXLORE} | awk '{print $7}' | sort -n | uniq -c | sort -nr | tail -$CNT )

printf "Low" "$CNT" "routes\n"
printf "=====================\n"
printf "$tmp_low_r"
exit 0
}

error_list {
tmp_err_l=$( cat ${FILE_TO_EXPLORE} | awk ' $9 ~ /^[54]/ {print $9}' | sort -n | uniq -c | sort -nr )

printf "Error List"
printf "============"
printf "$tmp_err_l"
exit 0
}
## end of functions-block
case $2 in
	toplinks)
	top_links
	;;
	lowlinks)
	low_links
	;;
	toproutes)
	top_routes
	;;
	lowroutes)
	low_routes
	;;
	errors)
	error_list
	;;
	*)
	echo "option name not found"
	exit 6
	;;
esac

