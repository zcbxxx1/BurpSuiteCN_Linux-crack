#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8



lines=78

if [ $(id -u) != "0" ]; then
    echo "$(tput setaf 1)请使用sudo权限执行安装命令！"
    exit 1
fi

echo "+------------------------------------------------------------------------+"
echo "| Burp Suite Professional for Linux (64-bit) Install, Written by kiss238 |"
echo "+------------------------------------------------------------------------+"
echo "|      一个在Linux上手动离线激活和安装Burp Suite Professional的工具      |"
echo "+------------------------------------------------------------------------+"
echo "|       有关更多信息，请访问 https://kiss238-burpsuite.taobao.com/       |"
echo "+------------------------------------------------------------------------+"

PS3='输入您的选择: '
foods=("官方下载" "官方安装" "网盘安装" "破解补丁" "运行注册机" "设置英文版" "设置汉化版" "退出安装..")
select fav in "${foods[@]}"; do
    case $fav in
        "官方下载")
            echo "$fav ...."
			Version=$(curl -L -s -H 'Accept: application/json' "https://portswigger.net/burp/releases/data?previousLastId=-1&lastId=-1&pageSize=1" | sed -e 's/.*"version":"\([^"]*\)".*/\1/')
			Link="https://portswigger-cdn.net/burp/releases/download?product=pro&version=$Version&type=Linux"
			wget "$Link" -O burpsuite_pro_linux.sh --quiet --show-progress
			sleep 2
            ;;
        "官方安装")
            echo "$fav ...."
				chmod +x burpsuite_pro_linux.sh
				sudo ./burpsuite_pro_linux.sh
            ;;
        "网盘安装")
            echo "$fav ...."
				chmod +x burpsuite_pro_linux_v2022_11.sh
				sudo ./burpsuite_pro_linux_v2022_11.sh
            ;;
        "破解补丁")
            echo "$fav ...."
				tail -n +$lines $0 >/tmp/sfx_archive.tar.gz
				tar zxf /tmp/sfx_archive.tar.gz
				sudo cp -r sfx_archive/* /opt/BurpSuitePro/
				sudo chmod 644 /opt/BurpSuitePro/ja-netfilter.jar
				sudo chmod 755 /opt/BurpSuitePro/plugins
				sudo chmod 755 /opt/BurpSuitePro/config
				sudo rm -rf /tmp/sfx_archive.tar.gz sfx_archive
				ls -lah /opt/BurpSuitePro/
            ;;
        "运行注册机")
            echo "$fav ...."
				(/opt/BurpSuitePro/jre/bin/java --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar /opt/BurpSuitePro/ja-netfilter.jar -r) > /dev/null 2>&1 &
			sleep 1s
            ;;
        "设置英文版")
            echo "$fav ...."
				sudo sed -i '10,18d' /opt/BurpSuitePro/BurpSuitePro.vmoptions
				sudo echo -e "\n--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED\n-javaagent:ja-netfilter.jar"|sudo tee -a /opt/BurpSuitePro/BurpSuitePro.vmoptions
            ;;
        "设置汉化版")
            echo "$fav ...."
				sudo sed -i '10,18d' /opt/BurpSuitePro/BurpSuitePro.vmoptions
				sudo echo -e "--add-opens=java.desktop/javax.swing=ALL-UNNAMED\n--add-opens=java.base/java.lang=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED\n-javaagent:burpsuitloader-3.7.17-all.jar=loader,han\n-Xmx2048m"|sudo tee -a /opt/BurpSuitePro/BurpSuitePro.vmoptions
            ;;
	"退出安装..")
	    echo "$fav ...."
	    exit
	    ;;
        *) echo "无效选项 $REPLY";;
    esac
done
exit 0
