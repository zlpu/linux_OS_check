#!/bin/bash
# -*- coding:utf-8 -*-
echo -e "\033[31m
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>巡检开始
=================================开始时间：$(date)
请输入巡检人的姓名：\033[0m"
read name

echo -e "\033[32m==============服务器基本信息\033[0m"
echo -e "\033[33m当前登录的用户：\033[0m
$(who|awk 'NR==1{print}')"
echo -e "\033[33mIP：\033[0m $(ip a|grep eth0|awk 'NR==2{print $2}')"
echo -e "\033[33m主机名：\033[0m $(hostname)"
echo -e "\033[33m运行时长：\033[0m $(uptime|awk '{print $3}')"
echo -e "\033[33m时区：\033[0m $(ls -l /etc/localtime |awk 'BEGIN{FS="/"}{print $7"/",$8}')"
echo -e "\033[33m系统版本：\033[0m$(cat /etc/redhat-release)
\033[33m--------\033[0m$(cat /proc/version)"
echo -e "\033[33mCPU数量：\033[20m
\033[33m--------物理CPU：\033[0m$(cat /proc/cpuinfo|grep "physical id"|uniq|sort|wc -l)
\033[33m--------逻辑CPU：\033[0m$(lscpu |grep "CPU(s)"|awk 'NR==1{print $2}')
"

echo -e "\033[32m-------------------------------------【1】文件系统巡检$(date)-------------------------------------------\033[0m"
echo -e "\033[33m$(df -h|awk 'NR==1{print}')\033[0m
$(df -h|awk 'NR!=1{print $0}')
"
echo -e "\033[32m---------------------------------------【2】内存巡检$(date)---------------------------------------------\033[0m"
echo -e "\033[33m-类型-       -总内存-     -已用-      -空闲-    -共享内存-   -缓存内存-   -可用-\033[0m
$(free -th|awk 'NR!=1{print}')
"
echo -e "\033[32m-----------------------------------【3】服务器负载巡检$(date)-----------------------------------------\033[0m"
echo -e "$(top -n 1 |awk 'NR<6{print}')
"
echo -e "\033[32m----------------------------------【4】正在运行的容器清单$(date)------------------------------------\033[0m"
echo -e "\033[33m$(docker ps|awk 'NR==1{print}')\033[0m
$(docker ps -f status=running|awk 'NR>1{print}')
"
echo -e "\033[32m--------------------------------------------------------【5】top前10的进程$(date)----------------------------------------------------------------------\033[0m"
echo -e "\033[33mPID      用户   优先级  NICE值  虚拟内存总量(kb) 占用物理内存大小(kb)  共享内存大小(kb) 进程状态  CPU使用时间%  物理内存使用% 总计使用CPU时间       命令\033[0m
$(top -n 1|awk 'NR==8,NR==17{print $2"\t",$3"\t",$4"\t",$5"\t\t",$6"\t\t",$7"\t\t",$8"\t\t",$9"\t\t",$10"\t\t",$11"\t",$12"\t",$13}')
"
echo -e "\033[32m--------------------------------------------------------【6】系统登录记录-last-10$(date)------------------------------------------------------------------\033[0m"
echo -e "\033[33m用户    登录终端         登录ip              登陆时间    退出登录时间(在线时长)\033[0m
$(last |awk 'GEGIN{FS="\t\t"}NR<10{print}')
"
echo -e "\033[32m-------------------------------------------------------【7】防火墙放行端口$(date)-----------------------------------------------------------------------------------\033[0m"
echo -e "\033[33m端口  协议类型\033[0m
$(firewall-cmd --list-port |awk '{print $1"\n" $2}'|awk 'BEGIN{FS=r"/"}{print $1"\t",$2}')
"
echo -e "\033[32m-------------------------------------------------------【8】端口监听列表$(date)-------------------------------------------------------------------------------------\033[0m"
echo -e "\033[33m类型      接收   发送 监听本地地址         外部通信地址             状态         相关进程|PID\033[0m
$(netstat -nltp|awk 'NR>2{print}')
"
echo -e "\033[31m巡检完成<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
巡检人：$name
巡检结束时间：$(date)
\033[0m"

