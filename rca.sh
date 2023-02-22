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

cpu_mem_usage()
{
	cpu_mem=cpu_mem_$(date "+%Y.%m.%d")
	touch $cpu_mem
	ip=$(curl -s icanhazip.com)
        printf "************************  RCA TOOL v2  ************************\n\n" >> $cpu_mem
        printf "The hostname of this instance is ${HOSTNAME} and its IP address is ${ip}.\n\n" >> $cpu_mem

	printf "The processes taking high CPU usage are as follows: \n\n" >> $cpu_mem

	#CPU Usage block starts here

	found=false

	# Get the PID and CPU usage for each process and filter out the header line
	while read pid cpu name; do
	# Check if the CPU usage is above the threshold (10.0% in this example)
   	if [ "$(echo "scale=2; $cpu > 10.0" | bc)" -eq 1 ]; then
        echo "Process name: $name, PID: $pid, CPU usage: $cpu%" >> $cpu_mem
        found=true
   	fi
	done < <(ps -eo pid,%cpu,comm --sort=-%cpu | awk '{print $1, $2, $3}' | sed 1d)

	# If no processes were found, print a message indicating so
	if [ "${found}" = false ]; then
	    echo "No processes are taking more than 10% CPU usage.\n\n" >> $cpu_mem
	fi

	# CPU Block ends here

	printf "The processes taking high memory usage are as follows: \n" >> $cpu_mem

	# Memory block starts here

	processes=`ps aux --sort=-%mem | awk '{print $1, $2, $4, $11}'`
	echo "$processes" | head -n 11 >> $cpu_mem

	#memory block ends here

# function blocks end here
}

# execution block 

check_larger_logs
check_older_logs
check_larger_files
cpu_mem_usage
echo "The script has finished executing. The required files can be found in the same directory where this bash file is present."
