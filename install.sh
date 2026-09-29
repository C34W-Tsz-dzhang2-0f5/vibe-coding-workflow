#!/usr/bin/env bash
# vibe-coding-workflow 安装脚本（macOS / Linux）
# 用法：bash install.sh
set -e

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WB_HOME="${WB_HOME:-$HOME/.workbuddy}"
MARKET="vibe-coding-experts"

echo "WorkBuddy 主目录：$WB_HOME"

# 1. 安装技能（元技能 + Matt 套件）
mkdir -p "$WB_HOME/skills"
cp -R "$SRC"/skills/* "$WB_HOME/skills/"
echo "[1/3] 技能已安装 -> $WB_HOME/skills"

# 2. 安装四专家文件
MKT_ROOT="$WB_HOME/plugins/marketplaces/$MARKET"
mkdir -p "$MKT_ROOT/plugins"
cp -R "$SRC"/experts/plugins/* "$MKT_ROOT/plugins/"
echo "[2/3] 四专家文件已安装 -> $MKT_ROOT/plugins"

# 3. 写入市场注册文件（存在则先备份）
mkdir -p "$MKT_ROOT/.codebuddy-plugin"
MJ="$MKT_ROOT/.codebuddy-plugin/marketplace.json"
if [ -f "$MJ" ]; then
  cp "$MJ" "$MJ.bak"
  echo "      已备份原 marketplace.json -> marketplace.json.bak"
fi
cp "$SRC/experts/marketplace.json" "$MJ"
echo "[3/3] marketplace.json 已写入 -> $MJ"

echo ""
echo "安装完成。接下来："
echo "  1) 重启 WorkBuddy（或新开会话）"
echo "  2) 专家中心 -> 在 '$MARKET' 市场中找到四专家并启用"
echo "  3) 使用：调用元技能 vibe-coding-workflow，或按阶段召唤 承宇 / 守拙 / 磐石 / 明镜"
