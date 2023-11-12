#!/bin/bash
ver="1.0.0"
changeLog=""
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
    rm -f tutool.sh
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

	if [[ -f "$HOME/tutool.sh" ]] && [[ -d "/etc/tutool" ]] && grep <"$HOME/tutool.sh" -q "作者:HuTuTu"; then
		mv "$HOME/tutool.sh" /etc/tutool/tutool.sh
		local installedN=
		if [[ -d "/usr/bin/" ]]; then
			if [[ ! -f "/usr/bin/tutool" ]]; then
				ln -s /etc/tutool/tutool.sh /usr/bin/tutool
				chmod 700 /usr/bin/tutool
				installedN=true
			fi

			rm -rf "$HOME/tutool.sh"
		elif [[ -d "/usr/sbin" ]]; then
			if [[ ! -f "/usr/sbin/tutool" ]]; then
				ln -s /etc/tutool/tutool.sh /usr/sbin/tutool
				chmod 700 /usr/sbin/tutool
				installedN=true
			fi
			rm -rf "$HOME/tutool.sh"
		fi
		if [[ "${installedN}" == "true" ]]; then
			echoContent green "快捷方式创建成功，可执行[tutool]重新打开脚本"
		fi
	fi
}
# ==============Install=============


# ==============updateScript=============
function updateScript(){
    wget -P /root -N https://raw.githubusercontent.com/HuTuTuOnO/TuTool/main/tutool.sh && chmod +x tutool.sh && ./tutool.sh
}
# ==============updateScript=============


# startMenu
function startMenu(){
    clear
    green "============================="
    echo "                             "
    green "            TuTool          "
    green "      https://tutool.xyz    "
    echo "                             "
    green "============================="
    echo "                        "
    yellow "当前版本(Version): $ver"
    yellow "更新(Updates): $changeLog"
    echo "                        "
    yellow "======检测到VPS信息如下======"
    green "ip地址：$getIpAddress"
	green "主机名：$hostnameVariable"
    green "处理器架构：$arch"
    green "虚拟化架构：$virt"
    green "操作系统：$release"
    green "内核版本：$kernelVer"
    echo "                        "
    echo "3. 科学上网"
    echo "9. 更新脚本"
    echo "0. 退出脚本"
    echo "                        "
    echo "快捷方式创建成功，可执行[tutool]快捷重新打开脚本"
    read -p "请输入选项:" menuNumberInput
    case "$menuNumberInput" in
        3 ) proxyRelated ;;
        9 ) updateScript ;;
        0 ) exit 0 ;;
    esac
}

GetIpAddress
mkdir -p /etc/tutool
aliasInstall
startMenu
