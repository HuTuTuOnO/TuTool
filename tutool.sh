#!/bin/bash
ver="1.2.10"
changeLog="添加了回程检测脚本，优化了部分脚本，修复了一些bug"
arch=`uname -m`
virt=`systemd-detect-virt`
kernelVer=`uname -r`
hostnameVariable=`hostname`

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}


if [[ -f /etc/redhat-release ]]; then
    release="Centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
    release="Debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="Ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="Centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
    release="Debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="Ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="Centos"
else 
    red "不支持你当前系统，请使用Ubuntu,Debian,Centos系统"
    rm -f ednovastool.sh
    exit 1
fi

if ! type curl >/dev/null 2>&1; then 
	yellow "检测到curl未安装，安装中 "
		if [ $release = "Centos" ]; then
		    yum -y update && yum install curl -y
		else
		    apt-get update -y && apt-get install curl -y
		fi	   
else
    green "curl已安装"
fi

if ! type wget >/dev/null 2>&1; then 
	yellow "检测到wget未安装，安装中 "
	if [ $release = "Centos" ]; then
	    yum -y update && yum install wget -y
	else
	    apt-get update -y && apt-get install wget -y
	fi	   
else
    green "wget已安装"
fi

if ! type sudo >/dev/null 2>&1; then 
	yellow "检测到sudo未安装，安装中 "
	if [ $release = "Centos" ]; then
	    yum -y update && yum install sudo -y
	else
	    apt-get update -y && apt-get install sudo -y
	fi	   
else
    green "sudo已安装"
fi

# ==============Func=============

function GetIpAddress(){
	IpAddress=$(curl ip.p3terx.com)
}

# ==============Func=============

# ==============Install=============
function aliasInstall() {

	if [[ -f "$HOME/tutool.sh" ]] && [[ -d "/etc/tutool" ]] && grep <"$HOME/tutool.sh" -q "作者:EdNovas"; then
		mv "$HOME/ednovastool.sh" /etc/ednovastool/ednovastool.sh
		local installedN=
		if [[ -d "/usr/bin/" ]]; then
			if [[ ! -f "/usr/bin/tutool" ]]; then
				ln -s /etc/tutool/tutool.sh /usr/bin/tutool
				chmod 700 /usr/bin/tutool
				installedN=true
			fi

			rm -rf "$HOME/ednovastool.sh"
		elif [[ -d "/usr/sbin" ]]; then
			if [[ ! -f "/usr/sbin/ednovas" ]]; then
				ln -s /etc/ednovastool/ednovastool.sh /usr/sbin/ednovas
				chmod 700 /usr/sbin/ednovas
				installedN=true
			fi
			rm -rf "$HOME/ednovastool.sh"
		fi
		if [[ "${installedN}" == "true" ]]; then
			echoContent green "快捷方式创建成功，可执行[ednovas]重新打开脚本"
		fi
	fi
}
# ==============Install=============
GetIpAddress
