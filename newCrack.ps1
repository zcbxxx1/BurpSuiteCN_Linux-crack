# 确保脚本以管理员权限运行
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Write-Host "+--------------------------------------------------------------------------+"
Write-Host "| Burp Suite Professional for Windows Install, Converted from Linux Script |"
Write-Host "+--------------------------------------------------------------------------+"
Write-Host "|       一个在Windows上手动离线激活和安装Burp Suite Professional的工具           |"
Write-Host "+--------------------------------------------------------------------------+"
Write-Host "|      有关更多信息，请访问 https://github.com/zcbxxx1/BrupLinux-crack         |"
Write-Host "+--------------------------------------------------------------------------+"
Write-Host "|   请注意：此脚本仅供学习和研究使用，请于下载后24h内删除。否则与作者无关！              |"
Write-Host "+--------------------------------------------------------------------------+"

$BURP_DIR = "C:\Program Files\BurpSuitePro\"
$BURP = "BurpSuitePro.exe"
$BURP_Loader = "burpsuitloader-3.7.17-all.jar" # 修改为您的实际loader文件名

$files = @(
    "CrackFiles\$BURP_Loader",
    "CrackFiles\javassist.jar"
)

foreach ($file in $files)
{
    if (-not (Test-Path $file))
    {
        Write-Host "$file 不存在。破解文件不完整，程序退出..."
        exit 1
    }
}

function Download-BurpSuite
{
    $VersionInfo = Invoke-RestMethod -Uri 'https://portswigger.net/burp/releases/data?previousLastId=-1&lastId=-1&pageSize=3' -Method Get -Headers @{ 'Accept' = 'application/json' }
    $Version = $VersionInfo | Where-Object { $_.ProductPlatformLabel -eq "Windows x64" } | Select-Object -ExpandProperty Version -First 1
    $Version = $Version -replace '\.', '_'
    $Link = "https://portswigger.net/burp/releases/download?product=pro&version=$Version&type=Windows"
    $BpName = "burpsuite_pro_windows_v$Version.exe"

    Write-Host "当前最新版本为 $Version，正在尝试下载"
    Invoke-WebRequest -Uri $Link -OutFile $BpName
    Write-Host "下载完成，文件名为 $BpName"
}

function Install-BurpSuite
{
    $BpName = Get-ChildItem -Path ".\" -Filter "burpsuite_pro_windows_v*.exe"
    if ($BpName -ne $null)
    {
        $INSTALL_CHOICE = Read-Host "检测到安装包 $BpName，是否立即安装？[Y/n]"
        if ($INSTALL_CHOICE -eq "n" -or $INSTALL_CHOICE -eq "N")
        {
            Write-Host "取消安装！"
            return
        }
        Start-Process -FilePath $BpName.FullName -Wait
        Write-Host "安装完成。"
    }
    else
    {
        Write-Host "未检测到安装包，请先下载。"
    }
}

function Prepare-CrackPatch
{
    if (Test-Path "${BURP_DIR}${BURP}")
    {
        Copy-Item "CrackFiles\*" -Destination $BURP_DIR -Recurse -Force
        Write-Host "破解补丁准备完成。"
    }
    else
    {
        Write-Host "未检测到 ${BURP_DIR}下的BurpSuitePro，请先安装该程序。"
    }
}

function Set-VMOptions
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$Language
    )

    $vmoptions = "${BURP_DIR}BurpSuitePro.vmoptions"
    Remove-Item -Path $vmoptions -Force
    $options = ""

    if ($Language -eq "English")
    {
        $options = @"
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
-javaagent:$BURP_DIR$BURP_Loader=loader
-Xmx2048m
"@
    }
    elseif ($Language -eq "Chinese")
    {
        $options = @"
--add-opens=java.desktop/javax.swing=ALL-UNNAMED
--add-opens=java.base/java.lang=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED
-javaagent:$BURP_DIR$BURP_Loader=loader,han
-Xmx2048m
"@
    }

    $options | Out-File -FilePath $vmoptions -Encoding ASCII
    Write-Host "$Language 版本设置完成。"
}

function Start-Crack
{
    if (Test-Path "${BURP_DIR}${BURP}")
    {
        Start-Process -FilePath "java" -ArgumentList "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar `${BURP_DIR}${BURP_Loader}` -r" -NoNewWindow -Wait
        Start-Process -FilePath "${BURP_DIR}${BURP}"
        Write-Host "Burp Suite启动成功。"
    }
    else
    {
        Write-Host "未检测到 ${BURP_DIR}下的BurpSuitePro，请先安装该程序。"
    }
}

function Uninstall-BurpSuite
{
    $UNINSTALL_CHOICE = Read-Host "是否卸载 Burp (包括插件、个人配置等，将会被完全清除) [Y/n]"
    if ($UNINSTALL_CHOICE -eq "n" -or $UNINSTALL_CHOICE -eq "N")
    {
        Write-Host "取消卸载！"
    }
    elseif ($UNINSTALL_CHOICE -eq "" -or $UNINSTALL_CHOICE -eq "Y" -or $UNINSTALL_CHOICE -eq "y")
    {
        Remove-Item -Path $BURP_DIR -Recurse -Force
        Write-Host "Burp Suite已完全卸载。"
    }
}

# 脚本主要交互部分
$choices = @("官方下载", "官方安装", "准备破解补丁", "设置英文版", "设置汉化版", "开始破解", "完全卸载", "退出安装")
$choice = $host.ui.PromptForChoice("选择操作", "请选择以下操作之一：", $choices, 7)

switch ($choice)
{
    0 {
        Download-BurpSuite
    }
    1 {
        Install-BurpSuite
    }
    2 {
        Prepare-CrackPatch
    }
    3 {
        Set-VMOptions -Language "English"
    }
    4 {
        Set-VMOptions -Language "Chinese"
    }
    5 {
        Start-Crack
    }
    6 {
        Uninstall-BurpSuite
    }
    7 {
        Write-Host "退出安装。"
    }
    default {
        Write-Host "无效选项 $REPLY"
    }
}