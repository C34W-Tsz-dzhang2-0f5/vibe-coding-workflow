# vibe-coding-workflow 安装脚本（Windows / PowerShell）
# 用法：右键「使用 PowerShell 运行」，或在 PowerShell 中执行 .\install.ps1
$ErrorActionPreference = "Stop"

$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$wbHome = if ($env:WB_HOME) { $env:WB_HOME } else { Join-Path $HOME ".workbuddy" }
$market = "vibe-coding-experts"

Write-Host "WorkBuddy 主目录：$wbHome"

# 1. 安装技能（元技能 + Matt 套件）
$skillsDest = Join-Path $wbHome "skills"
New-Item -ItemType Directory -Force -Path $skillsDest | Out-Null
Copy-Item -Path (Join-Path $src "skills\*") -Destination $skillsDest -Recurse -Force
Write-Host "[1/3] 技能已安装 -> $skillsDest"

# 2. 安装四专家文件
$mktRoot = Join-Path $wbHome "plugins\marketplaces\$market"
$pluginsDest = Join-Path $mktRoot "plugins"
New-Item -ItemType Directory -Force -Path $pluginsDest | Out-Null
Copy-Item -Path (Join-Path $src "experts\plugins\*") -Destination $pluginsDest -Recurse -Force
Write-Host "[2/3] 四专家文件已安装 -> $pluginsDest"

# 3. 写入市场注册文件（存在则先备份）
$mjDir = Join-Path $mktRoot ".codebuddy-plugin"
New-Item -ItemType Directory -Force -Path $mjDir | Out-Null
$mjDest = Join-Path $mjDir "marketplace.json"
if (Test-Path $mjDest) {
    Copy-Item $mjDest "$mjDest.bak" -Force
    Write-Host "      已备份原 marketplace.json -> marketplace.json.bak"
}
Copy-Item -Path (Join-Path $src "experts\marketplace.json") -Destination $mjDest -Force
Write-Host "[3/3] marketplace.json 已写入 -> $mjDest"

Write-Host ""
Write-Host "安装完成。接下来："
Write-Host "  1) 重启 WorkBuddy（或新开会话）"
Write-Host "  2) 专家中心 -> 在 '$market' 市场中找到四专家并启用"
Write-Host "  3) 使用：调用元技能 vibe-coding-workflow，或按阶段召唤 承宇 / 守拙 / 磐石 / 明镜"
