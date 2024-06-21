# 确保脚本以管理员权限运行
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Write-Host "+----------------------------------------------------------------------------+"
Write-Host "| Burp Suite Professional for Windows Install, Converted from Windows Script |"
Write-Host "+----------------------------------------------------------------------------+"
Write-Host "|       一个在Windows上手动离线激活和安装Burp Suite Professional的工具       |"
Write-Host "+----------------------------------------------------------------------------+"
Write-Host "|      有关更多信息，请访问 https://github.com/zcbxxx1/BrupLinux-crack       |"
Write-Host "+----------------------------------------------------------------------------+"
Write-Host "|   请注意：此脚本仅供学习和研究使用，请于下载后24h内删除。否则与作者无关！  |"
Write-Host "+----------------------------------------------------------------------------+"

# 声明全局变量
$global:BURP_DIR = "C:\Program Files\BurpSuitePro"
$global:BURP = "BurpSuitePro.exe"
$global:BURP_Loader = "burpsuitloader-3.7.17-all.jar" # 修改为您的实际loader文件名

$files = @(
    "CrackFiles\$global:BURP_Loader",
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

function Download-BurpSuite {
    # 获取版本信息
    $VersionInfo = Invoke-RestMethod -Uri 'https://portswigger.net/burp/releases/data?previousLastId=-1&lastId=-1&pageSize=3' -Method Get -Headers @{ 'Accept' = 'application/json' }

    # 提取最新的 Windows x64 版本信息
    $Version = $VersionInfo.ResultSet.Results.builds | Where-Object { $_.ProductPlatformLabel -eq "Windows (x64)" } | Select-Object -ExpandProperty Version -First 1
    
    # 将版本号中的点替换为下划线
    $VersionUnderscore = $Version -replace '\.', '_'
    $Link = "https://portswigger.net/burp/releases/download?product=pro&version=$Version&type=WindowsX64"
    $BpName = "burpsuite_pro_windows_v$VersionUnderscore.exe"

    Write-Host "当前最新版本为 $Version for WindowsX64，正在尝试下载"
    Write-Host "正在请求 $Link 下载最新安装包，大小约330000000字节。请耐心等待"
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
    while (-not (Test-Path (Join-Path $global:BURP_DIR $global:BURP)))
    {
        Write-Host "未检测到 $global:BURP_DIR 下的 BurpSuitePro，请先安装该程序或重新指定安装目录。"
        $global:BURP_DIR = Read-Host "请输入 BurpSuitePro 的安装目录路径"
    }

    Copy-Item "CrackFiles\*" -Destination $global:BURP_DIR -Recurse -Force
    Write-Host "破解补丁准备完成。"
}

function Set-VMOptions
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$Language
    )

    $vmoptions = Join-Path $global:BURP_DIR "BurpSuitePro.vmoptions"
    Remove-Item -Path $vmoptions -Force
    $options = ""

    if ($Language -eq "English")
    {
        $options = @"
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
-javaagent:$global:BURP_Loader=loader
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
-javaagent:$global:BURP_Loader=loader,han
-Xmx2048m
"@
    }

    # 使用 UTF-8 编码写入文件
    $options | Out-File -FilePath $vmoptions -Encoding UTF8
    Write-Host "$Language 版本设置完成。"
}


function Start-Crack {
    # 检查 $global:BURP_DIR 和 $global:BURP 组合的路径是否存在
    if (Test-Path (Join-Path $global:BURP_DIR $global:BURP)) {
        # 启动 Burp Loader
        Write-Host "启动 Burp Loader..."
        Start-Process -FilePath "java" -ArgumentList "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar $(Join-Path $global:BURP_DIR $global:BURP_Loader)" -NoNewWindow

        # 等待 Burp Loader 启动
        Start-Sleep -Seconds 5

        # 启动 Burp Suite 主程序
        $burpPath = Join-Path $global:BURP_DIR $global:BURP
        Write-Host "启动 Burp Suite 主程序: $burpPath"
        if (Test-Path $burpPath) {
            Start-Process -FilePath $burpPath
            Write-Host "Burp Suite启动成功。"
        } else {
            Write-Host "未找到 Burp Suite 主程序: $burpPath"
        }
    } else {
        # 如果路径不存在，提示用户安装程序
        Write-Host "未检测到 $(Join-Path $global:BURP_DIR $global:BURP)，请先安装该程序。"
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
        Remove-Item -Path $global:BURP_DIR -Recurse -Force
        Write-Host "Burp Suite已完全卸载。"
    }
}

# 定义可选操作
$choices = @("官方下载", "官方安装", "准备破解补丁", "设置英文版", "设置汉化版", "开始破解", "完全卸载", "退出安装")

# 循环直到用户选择退出
do {
    # 显示可选操作
    Write-Host "请选择以下操作之一："
    for ($i = 0; $i -lt $choices.Length; $i++) {
        Write-Host "[$i] $($choices[$i])"
    }

    # 获取用户选择
    $choice = Read-Host "输入对应数字 (默认值为7: 退出安装)"

    # 将用户输入的数字转换为整数，如果输入为空，则默认选择7
    if ($choice -eq "") {
        $choice = 7
    } else {
        $choice = [int]$choice
    }

    # 执行对应操作
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
            Write-Host "无效选项 $choice"
        }
    }

} while ($choice -ne 7) # 当选择不为7时继续循环
