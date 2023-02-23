#!/bin/bash

echo "************************  RCA TOOL v2  ************************"

echo "Server Information :"
ip=$(curl -s icanhazip.com)

echo "The hostname of this instance is ${HOSTNAME} and its IP address is ${ip}."

echo "Checking for RCA, please be patient...."

echo "Do not be worried if the console stops working-- the script is running and will take time according to your filesystem."


#function blocks start here

check_larger_logs()
{
        Large_Logs=large_logs_$(date "+%Y.%m.%d")
	ip=$(curl -s icanhazip.com)
        touch $Large_Logs
	printf "************************  RCA TOOL v2  ************************\n\n" >> $Large_Logs
	printf "The hostname of this instance is ${HOSTNAME} and its IP address is ${ip}.\n\n" >> $Large_Logs
        find /var/log/ -ignore_readdir_race -xdev -type f -size +100M -exec du -shx --time {} \;  |  sort -h >> $Large_Logs
}

check_older_logs()
{
        Old_Logs=old_logs_$(date "+%Y.%m.%d")
        touch $Old_Logs
	ip=$(curl -s icanhazip.com)
	printf "************************  RCA TOOL v2  ************************\n\n" >> $Old_Logs
        printf "The hostname of this instance is ${HOSTNAME} and its IP address is ${ip}.\n\n" >> $Old_Logs
	#cd /var/log/
        find /var/log/ -ignore_readdir_race -xdev -type f -mtime +30 -exec du -shx --time {} \;  |  sort -h >> $Old_Logs

}

check_larger_files()
{
        Large_Files=large_files_$(date "+%Y.%m.%d")
        touch $Large_Files
	ip=$(curl -s icanhazip.com)
	printf "************************  RCA TOOL v2  ************************\n\n" >> $Large_Files
        printf "The hostname of this instance is ${HOSTNAME} and its IP address is ${ip}.\n\n" >> $Large_Files
	#cd /
        find / -ignore_readdir_race -xdev -type f -size +100M -exec du -shx --time {} \;  |  sort -h >> $Large_Files
}

check_home_folder()
{
	home_files=home_files_$(date "+%Y.%m.%d")
	touch $home_files
	ip=$(curl -s icanhazip.com)
        printf "************************  RCA TOOL v2  ************************\n\n" >> $home_files
        printf "The hostname of this instance is ${HOSTNAME} and its IP address is ${ip}.\n\n" >> $home_files
	printf "The files taking high disk in /home/ are as follows: \n" >> $home_files
	
	find /home/ -ignore_readdir_race -xdev -type f -size +100M -exec du -shx --time {} \;  |  sort -h >> $home_files

}

zip_results()
{
	dnf install zip -y -q
	yum install zip -y -q
	zip rca_result.zip home_files* large_files* large_logs* old_logs* 
}

# execution block 

check_larger_logs
check_older_logs
check_larger_files
check_home_folder
sleep 10s
zip_results
echo "The script has finished executing. The required files can be found in the same directory where this bash file is present."

