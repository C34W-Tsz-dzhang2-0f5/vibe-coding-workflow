# vibe-coding-workflow

把「vibe coding（凭感觉写码）」改造成 **可复现、可门禁、可收尾** 的 AI 编码工作流：一套元技能 + 四位专家 + Jev 八维门禁。

## 它解决什么

AI 辅助编码最常见的三种失控：

1. **需求没问清就开写** → 意图模糊，返工。
2. **写完了没真实回归** → 行为正确性缺失，"看起来能跑"就算完。
3. **越写越乱** → 文档和代码长出两个名字（语义扩散），模块边界腐烂。

本仓库把流程固化为 **S0 → S6 七阶段**，每阶段有明确产出与门禁。

## 七阶段

| 阶段 | 作用 | 关键产出 |
|---|---|---|
| S0 基础设施 | 钉死共享语言 + 单一真相源 schema | `CONTEXT.md` / issue-tracker / triage-labels |
| S1 设计文档 | 澄清需求、拆模块 | 设计文档（含 grill 反向追问） |
| S2 契约/测试先行 | 先写失败测试，锁函数签名 | 测试用例（红） |
| S3 长程编码 | 按契约实现，最小改动 | 源码 + 小粒度 commit |
| S4 真实回归 | 真实环境跑通，非"看代码觉得对" | 实跑结果与验证记录 |
| S5 并行评审 | 四专家透镜 + Jev 八维打分 | 评审报告 + 加固清单 |
| S6 收尾沉淀 | 复盘，经验反哺红线 | 复盘文档 |

## 四位专家

| 专家 | 负责维度 | 主要介入 |
|---|---|---|
| **承宇**（架构师） | 基础设施与模块边界 | S0 / S1 / S2 |
| **守拙**（可维护性） | 关注点分离、真相源唯一、文件组织 | S5 |
| **磐石**（安全） | 安全与数据边界、纵深防御 | S5 |
| **明镜**（QA） | 行为正确性、真实回归 | S4 / S5 |

## Jev 八维门禁

1. PR 粒度　2. 意图与方案明确性　3. 方案对齐完整性　4. 工程验证质量
5. 文件组织　6. 关注点分离与真相源唯一　7. 行为正确性　8. 安全与数据边界

任一维度 ≤ 2 分即**打回重改**；3 分及以上可放行（轻修）。

## 已固化的三条实战红线

来自 2026-09-29 最小闭环试点（S0→S6 真跑）的「评审→修复→复验」验证：

1. 🔴 **日期/时区零点坑**：本地零点 `Date` 用 `toISOString()` 比较会吐出**前一天**，跨月/跨季系统性差一天。
2. 🔴 **语义扩散**：文档与代码必须同名（以 `CONTEXT.md` 为单一真相源），评审阶段必查。
3. 🟡 **全局可变状态 + 并发测试串扰**：测试改全局状态会与并发用例互污染，导致"单独跑对、并发跑错"。

## 目录结构

```
skills/
  vibe-coding-workflow/SKILL.md   # 元技能（编排层）
  enterprise-agent-scaffolding/    # 企业级 agent 生产脚手架（S-前置，管多租户/审计/成本熔断/HITL）
  ask-matt/                        # 第三方（Matt Pocock，MIT）
  setup-matt-pocock-skills/        # 第三方（Matt Pocock，MIT）
experts/
  marketplace.json                 # 市场注册（市场名 vibe-coding-experts）
  plugins/
    frontend-backend-architect/
    maintainability-reviewer/
    security-expert/
    qa-expert/
install.sh      # macOS / Linux
install.ps1     # Windows PowerShell
```

## 安装

```bash
git clone <本仓库地址>
cd vibe-coding-workflow

# macOS / Linux
bash install.sh

# Windows（PowerShell）
.\install.ps1
```

安装脚本会把技能拷到 `~/.workbuddy/skills/`、四专家拷到 `~/.workbuddy/plugins/marketplaces/vibe-coding-experts/`（**独立市场名，不会覆盖你已有的其他专家市场**）。

安装后：

1. **重启 WorkBuddy**（或新开会话）；
2. 专家中心 → 在 `vibe-coding-experts` 市场找到四专家 → 启用；
3. 使用时调用元技能 `vibe-coding-workflow`，或按阶段召唤：承宇 / 守拙 / 磐石 / 明镜。

> 若目标已存在同名 `marketplace.json`，脚本会先备份为 `.bak` 再覆盖。

## 企业级 agent 扩展（enterprise-agent-scaffolding）

本职 `vibe-coding-workflow` 管的是**写代码**（agent loop、工具 schema、编排、状态机）。当你要交付的是**企业级 agent**（生产环境、多租户、有合规与成本约束），光跑通 S0-S6 不够——还差一层**生产脚手架**。

`enterprise-agent-scaffolding` 与本职权**串行互补**，作为 S0 之前的 S-前置：

- 多租户隔离 / IAM / OAuth-SSO
- 不可篡改审计日志 + 可观测（tracing / metrics / 每步留痕）
- 成本控制 / 熔断 / 步数与超时硬上限（防 agent 失控循环）
- HITL 审批流 / 不可逆动作拦截
- 行为评测集（对抗 / 越权 / 注入场景，不止功能单测）
- 上线前架构审查清单（Katory ARB + Artefact non-negotiables）

详见该技能 `SKILL.md` 与 `references/checklist.md`、`references/scaffold.ts`（最小可运行骨架）。

## 版权

- **自产部分**（元技能、四专家、脚本、文档）：MIT，见 `LICENSE`。
- **第三方部分**（`skills/ask-matt/`、`skills/setup-matt-pocock-skills/`）：来自 [mattpocock/skills](https://github.com/mattpocock/skills)，MIT License，版权归 Matt Pocock。详见 `NOTICE`。

## 免责声明

本仓库是**工程方法论**，不构成法律意见。元技能 S5/S6 涉及"期限计算""合规校验"等示例场景时，相关**法律条文、司法解释与地方司法口径的现行效力，须由具备资质的专业人士核验后方可对外使用**。
