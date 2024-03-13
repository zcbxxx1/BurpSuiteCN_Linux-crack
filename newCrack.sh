#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8

lines=78

if [ "$(id -u)" != "0" ]; then
    echo "$(tput setaf 1)请使用sudo权限执行改脚本！"
    exit 1
fi

echo "+------------------------------------------------------------------------+"
echo "| Burp Suite Professional for Linux (64-bit) Install, Written by zcbxxx1 |"
echo "+------------------------------------------------------------------------+"
echo "|      一个在Linux上手动离线激活和安装Burp Suite Professional的工具      |" # 不知道为什么偏移
echo "+------------------------------------------------------------------------+"
echo "|       有关更多信息，请访问 https://github.com/zcbxxx1/BrupLinux-crack  |"
echo "+------------------------------------------------------------------------+"
echo "|   请注意：此脚本仅供学习和研究使用，请于下载后24h删除。否则与作者无关！|"
echo "+------------------------------------------------------------------------+"

# 初始化Burp Suite Pro的安装目录和文件名
BURP_DIR="/opt/BurpSuitePro/"
BURP="BurpSuitePro"
BURP_Loder="burpsuitloader-3.7.17-all.jar"

# 使用循环检测BurpSuitePro文件是否存在
while true; do
    if [ -f "${BURP_DIR}${BURP}" ]; then
        echo "已检测到 ${BURP_DIR}${BURP}"
        break # 如果找到文件，则退出循环
    else
        echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 安装。"
        echo "请输入你的安装路径，如 ~/BurpSuitePro (留空即为没有安装):"
        read -r USER_INPUT
        # echo $BURP_DIR
        if [ -z "$USER_INPUT" ]; then
            echo "目前没有安装"
            break
        else
            BURP_DIR="${USER_INPUT%/}/" # 删除末尾的斜杠（如果有），然后再添加一个斜杠
        fi
    fi
done

Version=$(curl -L -s -H 'Accept: application/json' "https://portswigger.net/burp/releases/data?previousLastId=-1&lastId=-1&pageSize=3" | sed -n 's/.*"ProductPlatformLabel":"Linux (x64)".*"Version":"\([^"]*\)".*/\1/p')
Link="https://portswigger-cdn.net/burp/releases/download?product=pro&version=$Version&type=Linux"
# echo ${Link}
Version=${Version//./_}
BpName="burpsuite_pro_linux_v$Version.sh"

PS3='输入您的选择: '
foods=("官方下载" "官方安装" "准备破解补丁" "设置英文版" "设置汉化版" "开始破解" "完全卸载" "退出安装..")
while true; do
    select fav in "${foods[@]}"; do
        case $fav in
        "官方下载")
            echo "$fav ...."
            echo "当前最新版本为 $Version，正在尝试下载"
            curl "$Link" -o "$BpName"
            echo "下载完成，文件名为 $BpName"
            sleep 2
            ;;
        "官方安装")
            echo "$fav ...."
            if [ -f "$BpName" ]; then
                echo "检测到安装包，是否立即安装？[Y/n]"
                read -r INSTALL_CHOICE
                if [ "$INSTALL_CHOICE" = "n" ] || [ "$INSTALL_CHOICE" = "N" ]; then
                    echo "取消安装！"
                    break
                fi
                if [ -z "$INSTALL_CHOICE" ] || [ "$INSTALL_CHOICE" = "Y" ] || [ "$INSTALL_CHOICE" = "y" ]; then
                    chmod +x "$BpName"
                    sudo ./"$BpName"
                    break
                fi
            else
                echo "未检测到安装包，请先下载。（如已有安装包但未检测到请更改文件名为${BpName}）"
                break
            fi
            ;;
        "准备破解补丁")
            echo "$fav ...."
            if [ -f "${BURP_DIR}${BURP}" ]; then
                sudo cp -r CrackFiles/* "${BURP_DIR}"
                sudo chmod 644 "${BURP_DIR}${BURP_Loder}"
                # sudo chmod 755 /opt/BurpSuitePro/plugins
                # sudo chmod 755 /opt/BurpSuitePro/config
                # sudo rm -rf CrackFiles
                ls -lah "${BURP_DIR}"
            else
                echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 请先安装该程序。"
                break
            fi
            ;;
        "设置英文版")
            echo "$fav ...."
            if [ -f "${BURP_DIR}${BURP}" ]; then
                sudo sed -i '10,25d' "${BURP_DIR}"BurpSuitePro.vmoptions
                sudo echo -e "\n--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED\n-javaagent:${BURP_Loder}=loader\n-Xmx2048m" | sudo tee -a "${BURP_DIR}"BurpSuitePro.vmoptions
            else
                echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 请先安装该程序。"
                break
            fi
            ;;
        "设置汉化版")
            echo "$fav ...."
            if [ -f "${BURP_DIR}${BURP}" ]; then
                sudo sed -i '10，25d' "${BURP_DIR}"BurpSuitePro.vmoptions
                sudo echo -e "--add-opens=java.desktop/javax.swing=ALL-UNNAMED\n--add-opens=java.base/java.lang=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED\n-javaagent:${BURP_Loder}=loader,han\n-Xmx2048m" | sudo tee -a "${BURP_DIR}"BurpSuitePro.vmoptions
            else
                echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 请先安装该程序。"
                break
            fi
            ;;
        "开始破解")
            echo "$fav ...."
            if [ -f "${BURP_DIR}${BURP}" ]; then
                ("${BURP_DIR}"jre/bin/java --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar "${BURP_DIR}${BURP_Loder}" -r) >/dev/null 2>&1 &
                sleep 1s
                "${BURP_DIR}${BURP}"
            else
                echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 请先安装该程序。"
                break
            fi
            ;;
        "完全卸载")
            echo "$fav ...."
            if [ -f "${BURP_DIR}${BURP}" ]; then
                echo "是否卸载 Burp (包括插件、个人配置等，将会被完全清除) [Y/n]"
                read -r INSTALL_CHOICE
                if [ "$INSTALL_CHOICE" = "n" ] || [ "$INSTALL_CHOICE" = "N" ]; then
                    echo "取消卸载！"
                    break
                fi
                if [ -z "$INSTALL_CHOICE" ] || [ "$INSTALL_CHOICE" = "Y" ] || [ "$INSTALL_CHOICE" = "y" ]; then
                    sudo "${BURP_DIR}"uninstall
                    sudo rm -rf "${BURP_DIR}"
                    break
                fi
            else
                echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 请先安装该程序。"
                break
            fi
            ;;
        "退出安装..")
            echo "$fav ...."
            exit
            ;;
        *) echo "无效选项 $REPLY" ;;
        esac
    done
    :
done
exit 0