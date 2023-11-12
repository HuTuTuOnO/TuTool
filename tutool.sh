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
