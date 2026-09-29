# 开源前自检清单

> 执行日期：2026-09-29　执行人：阿长的助理
> 结论：**全部通过，可推送公开仓库**

## 1. 敏感信息扫描

| 检查项 | 扫描范围 | 结果 |
|---|---|---|
| 本机绝对路径（`C:/Users/Administrator`） | 元技能 / 四专家 / Matt 套件 | ✅ 无残留 |
| 案件敏感词（粤0305、深南劳人仲、李俊华、张颜、案件追踪表、工资表） | 同上 | ✅ 无 |
| 法条引用（民诉法、第85/128/171条、劳动法、仲裁法） | 元技能 SKILL.md | ✅ 无引用（试点仅作方法论示例，不含案件号与当事人） |
| 密钥 / 环境变量 | 全量 + `.gitignore` 已屏蔽 `.env`、`*.key`、`*.pem` | ✅ 无 |

## 2. 第三方版权合规

| 组件 | 上游许可 | 处置 |
|---|---|---|
| `skills/ask-matt/`、`skills/setup-matt-pocock-skills/` | **MIT**（github.com/mattpocock/skills，Copyright 2026 Matt Pocock） | ✅ MIT 允许再分发/修改/二次开源；已补 `NOTICE` 保留完整版权与许可声明 |

## 3. 分发包完整性

| 项 | 结果 |
|---|---|
| 元技能 `skills/vibe-coding-workflow/SKILL.md` | ✅ 33887 B |
| 四专家（含 `plugin.json` + `.codebuddy-plugin/plugin.json` + `agents/*.md` + `avatars/*.png`） | ✅ 4 个专家齐全 |
| Matt 套件 | ✅ ask-matt、setup-matt-pocock-skills |
| 总文件数 | 36 |

## 4. 已修复的问题（发布前）

| 问题 | 严重度 | 处置 |
|---|---|---|
| `marketplace.json` 含无关 entry `personal-workbench-squad`（其目录未纳入分发包，会导致安装后指向不存在的源） | 🔴 高 | ✅ 已剔除，仅保留四专家 |
| 原市场名 `my-experts` 与用户本机既有市场同名，覆盖会污染 | 🟡 中 | ✅ 改为独立市场名 `vibe-coding-experts`，并存不覆盖 |
| Matt 套件文件未自带 LICENSE | 🟡 中 | ✅ 已补 `NOTICE`（MIT 全文 + 上游出处） |

## 5. 推送前置条件

| 项 | 结果 |
|---|---|
| `gh` 登录状态 | ✅ 已登录 github.com（有效 token） |
| 仓库可见性 | 公开（开源） |
