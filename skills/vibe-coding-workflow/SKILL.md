---
name: vibe-coding-workflow
description: >-
  Orchestrate an end-to-end "vibe coding" engineering pipeline for building
  non-trivial full-stack features or products with AI agents. Use when: (1)
  starting a new feature/product and wanting a contract-first, design-doc-first,
  multi-agent build; (2) asked to set up monorepo + global schema + shared
  language (CONTEXT.md) + reusable skill "infra"; (3) needing long-running
  harness coding with stacked PRs, real browser-environment regression, systematic
  debugging with root-cause tracing, defense-in-depth, and multi-session parallel
  review as quality gates; (4) user mentions "vibe coding", "tracer bullet",
  "vertical slice", "effective harnesses", "Jev scoring", "CONTEXT.md",
  "shared language", "semantic diffusion", "deep module", or wants to
  operationalize AI-native software engineering. Maps each phase to concrete
  WorkBuddy skills (incl. superpowers set), Expert-Center experts
  (frontend/backend architect, maintainability reviewer, security expert, QA),
  and connectors (github, kdocs, library).
---

# Vibe Coding Workflow（元技能）

## Overview

把《千亿 tokens 得到的 vibe coding 工程实践》的核心理念，叠加
**superpowers 技能集**（Anthropic，把软件工程纪律封装成可调用技能）、
**Matt Pocock 工程技能套件**（已在本机安装：`setup-matt-pocock-skills` 脚手架、`ask-matt` 路由器、`triage`→`to-spec`→`to-tickets` 分诊-规格-工单链、`wayfinder` 巨型项目导航，及其 CONTEXT.md 共享语言 / Deep Module / Vertical Slice / 触发模型 / 四大失败模式纪律），
落地为 WorkBuddy 可执行的 **7 阶段工程流水线**。核心范式一句话：

> **人定契约与方向、AI 长程执行、多会话做质量门禁。**

它不是"甩需求给 AI 一把梭"，而是把软件工程的可维护性纪律（关注点分离、真相源唯一、
契约先行、共享语言、可追溯）与 agent 的长程自主执行能力结合。

## When to use

- 用 AI agent 从零构建中大型全栈功能 / 产品，且要求可维护、可评审、可追溯；
- 用户提到 `vibe coding` / `tracer bullet`（曳光弹）/ `vertical slice`（垂直切片）/ `effective harnesses` /
  `Jev 打分` / `契约先行` / `设计文档优先` / `CONTEXT.md` / `共享语言` / `语义扩散` / `深模块`；
- 需要搭建 monorepo + 全局唯一 schema + 共享语言词典 + 可复用 skill「infra」；
- 需要长程 harness 编码、stacked PR、真实环境浏览器回归、系统化调试/根因追溯、纵深防御、多会话并行评审作为质量门禁。

## 核心理念（速记）

**五层模型**：上下文层 → 设计层 → 执行层 → 验证层 → 质量层。

**四个关键转变**：

| 从 | 到 |
|---|---|
| plan 模式 | 设计文档（带可追溯性与可维护性职责） |
| 重 TDD | 契约先行 + 先写集成测试 + 100% 覆盖（更轻、防漂移） |
| 单 agent 串行 | 多 agent 并行评审（独立视角对抗确认偏差） |
| 自动化 E2E | 人驾 agent 真实环境回归（覆盖更全、顺带测性能） |

**关键纪律**：关注点分离、真相源唯一、契约先行、共享语言（CONTEXT.md）、可追溯。

**共享语言与语义扩散（来自 mattpocock/skills）**：建立项目共享词典（CONTEXT.md / `domain-modeling` 领域词典），
让术语与代码同源；对抗"语义扩散"——一个概念长出多个名字会让词典失效、契约漂移。S0 即要先定义清楚。

**深模块与垂直切片（来自 mattpocock/skills）**：
- *Deep Module（深模块）*：大量行为藏在简单接口后的模块，是良好架构的标志；可维护性评审据此判断模块设计。
- *Vertical Slice（垂直切片）*：一次实现一个完整可用的功能片段 = 本文的 tracer bullet 曳光弹。

**触发模型（来自 mattpocock/skills）**：本工作流即该模型——
- *user-invoked（编排层）* = 本元技能 / 显式编排技能（writing-plans、subagent-driven-development 等），由用户触发，负责串流程；
- *model-invoked（纪律层）* = 专项技能（tdd、diagnosing-bugs、code-review、grilling、domain-modeling 等），由模型按任务匹配自动调用。
- 规则：**编排层可调用纪律层，但编排层之间不互相调用**（避免流程打架）。

**四条不可删的纪律（来自 mattpocock/skills 三条 + 本文真实回归）**：
1. 先问清需求（grill-me / brainstorming 反向追问）；
2. 先写测试（轻 TDD / Red-Green-Refactor）；
3. 先审查（多会话并行评审 + Jev 八维）；
4. 先真实回归（人驾 agent 真实环境跑通）。

**可裁剪性声明**：本工作流是**可裁剪框架**——项目小可砍阶段、可省略某专家；但上述"先问清 / 先测好 / 先审完 / 先回归"四道门禁不可删（对应 mattpocock"纪律是目的，AI 是手段"）。

---

## 入口路由层（吸收 Matt Pocock `ask-matt` 路由器）

vibe-coding-workflow 不是死板的 S0→S6 直线。动手前先判入口类型，路由到对应子流（与 `ask-matt` 的 idea→ship 主流程 + 三条 on-ramp 同构）：

| 入口类型 | 识别信号 | 路由 |
|---|---|---|
| **新需求 / 想法** | "我要做个 X 功能" | 主流程：S1（grill-with-docs → to-spec → to-tickets）→ S2 → S3 → S4 → S5 → S6 |
| **外部 bug / 请求涌入** | 已有 issue / PR、用户上报缺陷 | on-ramp 1：`triage` 分诊成 agent-ready issue → 进 S2 / S3 实现 |
| **东西坏了** | 复现困难的 bug、间歇性失败、回归 | on-ramp 2：`diagnosing-bugs` 先收紧反馈环 → 修（带防回归测试）→ S4 回归 |
| **巨型 / 模糊项目** | greenfield、超大功能，一次会话装不下 | on-ramp 3：`wayfinder` 画 decision-ticket 决策地图，逐票解锁 fog，清晰后 handoff 到 S1 的 `to-spec` |
| **存量架构优化** | 代码库该"深化"时 | 旁支：`improve-codebase-architecture` 体检 → 产出想法回主流程 S1 |

> 路由由本元技能在开场判定，或用户手动触发。用户也可直接说"问 Matt 该用哪个技能"，由 `ask-matt` 导向具体技能。Matt 套件里 `ask-matt` / `setup-matt-pocock-skills` / `to-spec` / `to-tickets` / `triage` / `wayfinder` 均声明 `disable-model-invocation`，需用户手动触发——本工作流在对应阶段给出调用指引即可。

## 七阶段流水线

### 阶段总览

| 阶段 | 目标 | 主调技能（含 superpowers 映射） | 主调专家 | 连接器 | 关键产出 |
|---|---|---|---|---|---|
| **S0 基础设施** | monorepo + 全局 schema + 共享语言 + infra | `domain-modeling`、`codebase-design`、`skill-creator` | 前端/后端架构师 | github、library | 仓库基线 + 全局 schema + 共享词典 CONTEXT.md + 可复用 skill |
| **S1 设计文档** | 出设计文档（grill-me 澄清不确定项） | `writing-plans`、`brainstorming` / `grilling`（superpowers: brainstorming/writing-plans） | 前端/后端架构师（评审） | kdocs、library | 设计文档（需求/背景/基线/拆分步骤）+ 共享语言锁定 |
| **S2 契约/测试先行** | 锁类型接口 → 集成测试 → 全栈 MVP 垂直切片 | `test-driven-development`、`domain-modeling`（superpowers: tdd、condition-based-waiting、testing-anti-patterns） | 前端/后端架构师 | — | 契约 + 集成测试 + 全栈 MVP 切片 |
| **S3 长程编码** | harness + 小粒度 commit + stacked PR | `subagent-driven-development`、`using-git-worktrees`、`finishing-a-development-branch`（superpowers 同名技能） | — | github | 小粒度 commit + PR 栈 |
| **S4 真实回归 + 调试闭环** | 浏览器 agent 跑真实路径；发现问题走系统化调试→根因→验证 | `playwright-cli`、`agent-browser`、`verification-before-completion`、`systematic-debugging`、`root-cause-tracing`（superpowers 同名技能） | QA 专家 | — | 回归通过 + 性能基线 + 根因与防回归测试 |
| **S5 并行评审 + 门禁** | 多会话评审 + Jev 八维打分 + 纵深防御 | `dispatching-parallel-agents`、`requesting-code-review`、`receiving-code-review`、`code-review`、`defense-in-depth`（superpowers 同名技能） | 可维护性评审师、安全专家、QA 专家 | — | 评审报告 + 八维打分 + 加固清单 |
| **S6 收尾沉淀** | 合并 PR + 经验固化成 skill | `skill-creator`、`writing-skills`（superpowers: executing-plans/组合应用） | — | library、kdocs | 合并 PR + 经验 skill |

### S0 基础设施（Infra 底线，不可省）

- **目标**：建立「完整上下文」——全栈 monorepo + 全局唯一 schema + **共享语言词典（CONTEXT.md）** + 资深工程师定义的基础 infra。
- **调用技能**：
  - `setup-matt-pocock-skills`（Matt 套件前置脚手架，user-invoked，一次性）：为仓库配置三件套——① issue tracker（GitHub / GitLab / 本地 markdown 三选一）② triage 标签词汇（5 个规范角色：`needs-triage` / `needs-info` / `ready-for-agent` / `ready-for-human` / `wontfix`）③ domain docs 布局（`CONTEXT.md` + `docs/adr/` 的单一上下文，或 monorepo 的 `CONTEXT-MAP.md` 多上下文）。**这是后续 `triage` / `to-spec` / `to-tickets` / `wayfinder` 的硬前置**——这些技能都读取它写入的 `docs/agents/issue-tracker.md`、`docs/agents/triage-labels.md`、`docs/agents/domain.md` 与 `CONTEXT.md`。S0 第一步先跑它，再建 schema / 词典。
  - `domain-modeling`：建模全局唯一 schema，**同时产出项目共享词典（CONTEXT.md）**，把核心术语、边界、命名约定钉死，防治语义扩散。
  - `codebase-design`：规划仓库结构、模块与服务拆分、关注点分离；与 `setup-ts-deep-modules`（dependency-cruiser 把每个包做成深模块）配合固定深模块边界。
  - `writing-for-agents`：生成 AGENTS.md / CLAUDE.md，把组织上下文（约束、命令、禁忌）写成 agent 可读的"装配说明"，是 infra 的文档化收口。
  - `improve-codebase-architecture`：对存量代码做"深化机会"体检，输出可视化报告再逐项 grill，作为 S0 重构基线。
  - `skill-creator`：把可复用方法论沉淀为项目/用户级 skill（= 文章说的"资深工程师定义 infra"）。
  - `git-guardrails-claude-code` / `setup-pre-commit`：在仓库装上危险 git 命令护栏（push/reset --hard/clean 等）与 husky 预提交钩子（lint/type/test），把"干净提交"从纪律变成强制。
- **调用专家**：**前端/后端架构师**——定义前端/后端模板、质量门禁、可复用 skill 清单，并主导共享语言（CONTEXT.md）治理。
- **连接器作用与数据流转**：github 连接器初始化 monorepo 并托管；library 连接器归档 schema、CONTEXT.md 与 infra 约定文档。
- **预期产出**：monorepo、全局 schema 文件、共享语言词典 CONTEXT.md、基础模板与 skill、质量门禁清单。

### S1 设计文档（不用 plan 模式，但先出文档）

- **目标**：复杂目标必先出方案设计文档，承担可维护性建设职责。
- **调用技能**：
  - `writing-plans`：产出带「原始需求 / 背景信息 / 当前代码基线 / 合理拆分步骤」的设计文档。
  - `brainstorming` / `grilling`：对自己拿不准的地方用 **grill-me 式反向追问**澄清（文章称其为"最厉害的 skill"；mattpocock 体系里这是 user-invoked 编排入口）——先把需求聊清，再决定怎么写。
  - `grill-with-docs`：在 grill 过程中顺带产出 ADR（架构决策记录）与术语表，直接沉淀进 CONTEXT.md / 共享词典，避免二次返工。
  - `research`：对设计文档涉及的技术选型/外部依赖，先以高可信一手来源调研并落盘 Markdown，作为设计依据。
  - `to-spec`：把 grill 出来的对话线索**合成 spec**（不采访、只综合已知），输出 Problem Statement / User Stories / Implementation Decisions / Testing Decisions / Out-of-Scope，标 `ready-for-agent` 发布到 tracker——是 `to-tickets` 的直接上游。
  - `to-tickets` / `triage` / `wayfinder`：把 spec 或设计拆成带依赖边（blocking edges）的 **tracer-bullet 工单**——每票是一条完整贯穿各层（schema→API→UI→测试）的垂直切片、可独立验证、大小适配单上下文窗口；发布到 issue tracker（本地 `.scratch/<feature>/issues/` 或 GitHub issues），供 S3 按 frontier（无阻塞者优先）有序执行。外部 bug / PR 用 `triage` 分诊成 agent-ready issue（状态机：needs-triage→ready-for-agent/ready-for-human/wontfix）；巨型模糊项目用 `wayfinder` 画 decision-ticket 决策地图（产出决策而非交付物），地图清晰后 handoff 到本流程的 `to-spec`。
  - `prototype`：对拿不准的状态模型/交互，先做一个一次性原型验证手感，再定稿设计。
- **调用专家**：**前端/后端架构师**评审文档的模块拆分、真相源唯一性与共享语言一致性。
- **连接器作用与数据流转**：kdocs / library 连接器承载并版本化管理设计文档，便于日后追溯改动目的。
- **预期产出**：可追溯的设计文档（含背景、基线、拆分步骤、关注点分离说明）+ 锁定的共享语言词条 + ADR/术语表。
- **退出标准**：不确定项已澄清（grill-me 跑完），拆分粒度合理，可维护性要求写入文档。

### S2 契约 / 测试先行（避免契约漂移）

- **目标**：先锁死契约，再编码；先写集成测试把主链路定下来。
- **调用技能**：
  - `domain-modeling`：先定义类型与接口（契约）。
  - `test-driven-development`：以 **Red-Green-Refactor** 为内核（先写失败测试 → 最小实现 → 重构），先写集成测试（轻量、非重 TDD），主链路确定后要求 100% 覆盖；配合 `condition-based-waiting`（条件等待，别让测试睡大觉）与规避 `testing-anti-patterns`。
- **调用专家**：**前端/后端架构师**校验前后端契约同源、无漂移、与 CONTEXT.md 词条一致。
- **Vertical Slice（垂直切片 / tracer bullet 曳光弹）**：先定义完成全栈 MVP 的步骤，打通一条贯穿 UI→API→逻辑→DB→测试的
  最薄纵向切片并验证，再向 MVP 一点点补充分支特性，每次补充仍是完整全栈链路。
- **预期产出**：锁定的类型/接口、集成测试套件、可运行的全栈 MVP 切片。

### S3 长程编码（harness + 小粒度 commit + stacked PR）

- **目标**：方案确定后进入长程执行，逐步推进并留干净提交。
- **调用技能**：
  - `subagent-driven-development`：把设计步骤派发给子代理长程执行（对应 Anthropic effective-harnesses 的 initializer + coding agent 架构；superpowers 同名技能"请 AI 当项目经理"）。
  - `using-git-worktrees`：用 worktree 隔离并行开发。
  - `finishing-a-development-branch`：完成后安全收口合回主线（superpowers 同名技能）。
  - `karpathy-guidelines`：**编码纪律贯穿 S3**——不做过度设计、做外科手术式改动、不臆测、能读现有代码就别重写；直接降低 LLM 编码常见错误，减少 S4 回归失败率。
  - `fullstack-developer__skillhub`：全栈实现覆盖（前端 React/Next/Vue + 后端 Node/Python/FastAPI/Django/Express + 数据库），在需要端到端实现时作为能力底座。
  - `frontend-inline-css-pitfalls`：复刻/改造 Web 前端时规避内联 `<style>` 与 `<link>` 优先级、hidden 被 display 覆盖、缺失 viewport 等高频致命坑。
  - `implement` / `implement-spec`：按 spec/工单落地实现（与 subagent 长程执行互补）。
  - `leader`：把一句话目标拆成 agent 能独立跑完的目标任务书，在需要多 agent 分工时编排。
- **调用连接器**：github 连接器每完成一个编码步骤创建一个 **stacked PR**（PR 栈），降低单 PR 评审压力。
- **关键纪律**：积极做小粒度 git commit，记录基线、减少回滚与评审压力；遵循 `karpathy-guidelines` 做最小必要改动。
- **预期产出**：一串小粒度 commit + 有序的 stacked PR + 符合编码纪律的实现。
- **上下文管理纪律（来自 Matt Pocock `ask-matt` / PHASE-BOUNDARIES）**：长程 harness 中，每个"阶段边界"（grilling 结束、实现结束、QA 开始之间）做一次五选一决策，按序判断：
  1. **Continue**：下一阶段把本阶段当**主源**（如 grilling→实现要原样推理），且 smart zone（~150k token）够用 → 留在同一会话，成本最低；
  2. **`/clear`**：本会话内容对下一步全无用 → 清空窗口（最省事，但不可回退）；
  3. **`/handoff`**：切换新 harness / 新目录 / 交同事 / 阶段中不偏离主线地 fork 旁路任务 → 写可移植 markdown 文件；
  4. **Subagent**：任务可 AFK 独立完成（如自动 review）→ 派子代理，本会话不动；
  5. **`/compact`**（默认兜底）：相关上下文、同 harness、同目录、需继续在环内 → 压缩并播种新会话，传"下一步要做什么"的指令。
  > 核心：永远先排除 Continue；只有"留下来比压平更贵"时才 compact / handoff。mid-phase 不 compact（会丢主线）。

### S4 真实环境回归 + 调试闭环（而非自动化 E2E）

- **目标**：在真实页面跑完整用户路径，覆盖 E2E 范围且做得更好，顺带捕捉性能；发现问题走系统化调试闭环。
- **调用技能**：
  - `playwright-cli` / `agent-browser`：具备 browser-use / computer-use 能力的 agent 在真实页面操作（⚠️ 需确认这两个内置缓存技能已启用；未启用则 S4 浏览器回归降级为手动）。
  - `verification-before-completion`：完成前强制验证，循环回归直到通过。
  - `research`：调试 / 核验遇到需要外部一手资料（第三方 API、文档、知识库）才能下结论时，派 background agent 读 **primary sources** 并落盘引用 Markdown，主线程继续推进。
  - `systematic-debugging` + `diagnosing-bugs` + `root-cause-tracing`（superpowers 同名技能）：回归发现 bug 时，按
    **复现 → 假设 → 验证 → 根因** 流程步步有证据地定位（顺着因果链追到根因，而非边修边猜）；修完后回"复现"验证 + 加防回归测试，才宣布完成。
- **调用专家**：**QA 专家**——设计真实用户路径、校验行为正确性、捕捉性能指标，并在调试闭环中确认防回归测试覆盖。
- **数据流转**：agent 在真实环境发现问题即进入系统化调试，修复后完整回归，循环至通过；记录页面指标一并优化。
- **预期产出**：回归通过的真实环境 + 性能基线报告 + 根因说明与防回归测试。
- **复盘**：`retro` 在编码会话结束后做回顾，把踩坑与模式沉淀进 S6 资产化。

### S5 并行评审 + Jev 八维门禁 + 纵深防御（质量层）

- **目标**：多会话独立评审对抗确认偏差，Jev 八维打分作质量门禁，安全侧叠加纵深防御。
- **调用技能**：
  - `dispatching-parallel-agents`：并行拉起多个评审会话。
  - `requesting-code-review` / `receiving-code-review` / `code-review`：独立评审 stacked PR，结果交回实现会话复审（superpowers 同名技能）；`pr` 技能负责生成规范的 PR 描述。
  - `executing-plans`：在独立会话按 review checkpoint 执行修改，保持评审与实现分离。
  - `defense-in-depth`（superpowers 同名技能）：给 API / 关键路径多上几道保障，作为安全评审的纵深防线。
- **调用专家**（需在专家中心启用本技能配套的四类专家）：
  - **可维护性评审师**：按设计文档的可维护性纪律审查（关注点分离、真相源唯一、文件组织、PR 粒度），
    重点排查 agent loop 过程概念泄漏进代码；并依据 **Deep Module（深模块）** 判读模块设计优劣、检查**语义扩散**（同一概念多个命名）。
  - **安全专家**：聚焦 Jev「安全与数据边界」维度 + `defense-in-depth` 纵深防御，查越权、注入、数据暴露、单点失效。
  - **QA 专家**：聚焦 Jev「行为正确性」维度，确认真实回归覆盖与防回归测试到位。
- **Jev 八维打分**（见下方 rubric）作为门禁：打分结果交 agent 复审；上下文不足的误判补充 Jev 上下文重打；
  最终由 agent 结合打分给出 code review 报告。该链路仍半自动——**人必须读报告、盘问低分项**。
- **预期产出**：多会话评审意见 + 八维打分表 + 加固清单 + 最终 code review 报告。

### S6 收尾沉淀（资产化）

- **目标**：合并 PR，把本次经验固化成可复用 skill。
- **调用技能**：`skill-creator` / `writing-skills` 把踩过的坑、稳定的模式沉淀为技能资产（superpowers 称"从一句话到一期功能上线"的组合应用）；`workbuddy-expert-packaging` 把专家包打包/注册的经验固化下来，便于跨实例复用。
- **调用连接器**：library / kdocs 归档设计文档、评审报告、复盘笔记与共享语言修订。
- **预期产出**：合并后的主分支 + 新增/迭代的 skill + 知识库归档 + 更新后的 CONTEXT.md。

---

## Jev 八维打分 Rubric（S5 质量门禁）

| 维度 | 检查要点 | 建议评分 |
|---|---|---|
| 1. PR 粒度 | 单 PR 是否足够小、可独立评审 | 1–5 |
| 2. 意图与方案说明明确性 | PR/commit 是否讲清"为什么改" | 1–5 |
| 3. 方案对齐与完整性 | 实现是否对齐设计文档、无遗漏 | 1–5 |
| 4. 工程与验证质量 | 测试/回归是否充分、可复现（含防回归测试） | 1–5 |
| 5. 文件组织方式 | 文件/目录划分是否合理、深模块得当 | 1–5 |
| 6. 关注点分离与真相源唯一 | 是否单一真相源、无重复逻辑、无语义扩散 | 1–5 |
| 7. 行为正确性 | 真实环境回归是否通过、边界与防回归覆盖 | 1–5 |
| 8. 安全与数据边界 | 越权/注入/数据暴露/边界校验/纵深防御 | 1–5 |

**门禁规则**：任一维度 ≤ 2 必须返回改进；任一维度出现语义扩散或 agent-loop 泄漏直接打回；上下文不足导致的误判，把结论补入 Jev 上下文重打。

---

## 四大失败模式 → 门禁映射（来自 mattpocock/skills）

| 失败模式 | 表现 | 对应门禁 / 技能 |
|---|---|---|
| 需求不清 | AI 理解偏、做错方向 | S1 grill-me / brainstorming 反向追问澄清 |
| 过于啰嗦 | 一个概念多个名字、契约漂移 | S0 建 CONTEXT.md 共享语言、防治语义扩散 |
| 代码不工作 | 实现闭眼飞、无验证 | S2 轻 TDD + S4 真实回归 + systematic-debugging |
| 架构腐化 | 模块混乱、热点膨胀 | S5 可维护性评审（深模块/关注点分离）+ improve-codebase-architecture 体检 |

## 反模式（红线，禁止）

- ❌ 没有完整上下文（无 monorepo / 全局 schema / 共享语言）就开干；
- ❌ 让 AI 边写边补契约（导致契约重复与漂移）；
- ❌ 把 agent loop 过程概念（"迭代了几个版本""分了几个阶段"）泄漏进交付代码；
- ❌ 出现**语义扩散**（同一概念多个命名）而不统一到 CONTEXT.md；
- ❌ 跳过真实环境回归直接合并；
- ❌ 用自动化 E2E 替代真实环境回归（覆盖不全）；
- ❌ 只靠单 agent 自评（确认偏差）；
- ❌ 调试靠"边修边猜"，不走 systematic-debugging 的复现→假设→验证→根因闭环；
  - ❌ 安全只做单点校验，不叠加 defense-in-depth。

---

### 实战踩坑沉淀（来自 2026-09-29 最小闭环试点，须纳入红线）

> 以下三条由最小闭环试点（案件程序节点期限计算器，S0→S6 真跑）触发的「评审→修复→复验」闭环验证，列为硬性红线，后续任何 pilot 直接套用。

1. **🔴 日期/时区零点坑（测试反模式）**：本地时区下 `new Date(y, m-1, d)` 为本地零点（如 UTC+8 的 00:00），若用 `toISOString().slice(0, 10)` 做"本地日期"比较，会吐出**前一天**，在跨月/跨季月份系统性差一天（试点中三月序列差 1 天，CLI 同输入却正确，定位耗时）。
   - ❌ 红线：测试中用 `toISOString()` 做本地日期显示/断言比较。
   - ✅ 强制：日期格式化一律用本地分量（`getFullYear/getMonth/getDate` 或本地 `YYYY-MM-DD` 构造）；`toISOString` 仅用于传 UTC 时间戳，不用于显示/断言。跨时区部署需显式 UTC 模式开关。

2. **🔴 语义扩散（已有红线，强化「以 CONTEXT.md 为准单一真相源」）**：试点中设计文档写 `calcDeadline`、代码实叫 `calcDueDate`，S5 并行评审才抓出——正是「文档与代码长出两个名字」。
   - ❌ 红线：代码命名与 CONTEXT.md / 设计文档术语不一致；导出面暴露内部命名。
   - ✅ 强制：S2 写完即 `grep -rn` 全局确认无旧名残留；公共 API 命名严格对齐 CONTEXT.md 词条；导出面收窄到仅公共 API。

3. **🟡 全局可变状态 + 并发测试串扰（测试反模式）**：`node --test` 默认并发执行子测试；若测试改动全局可变状态（如全局 `HOLIDAYS` Set、全局 config），会与并发用例相互污染，导致「单独跑对、并发跑错」的幽灵失败（试点初版正是此因）。
   - ❌ 红线：测试依赖/修改全局可变状态；依赖测试执行顺序。
   - ✅ 强制：所有可变依赖（节假日表、配置、mock）改为**可注入参数**，测试之间零共享状态；本地/CI 跑测试设 `NODE_TEST_CONCURRENCY=1`（串行）兜底，杜绝时序竞态。

---

## 与其他技能的协同

- 本技能是**元技能 / 编排层（user-invoked）**，串联各专项技能（model-invoked 纪律层）；遇到具体子任务时，专项技能优先于本技能。
- **`using-superpowers`（元纪律层，P0）**：作为本工作流的总纪律——任何响应前先找并调用合适技能，不裸答。它把 superpowers 13 个子技能（已以用户级技能安装）串成可调用底座，与本文理念同源。
- superpowers 技能与 WorkBuddy 对应清单（多数已内置，可直接调用）：brainstorming、writing-plans、executing-plans、subagent-driven-development、using-git-worktrees、finishing-a-development-branch、dispatching-parallel-agents、requesting-code-review、receiving-code-review、test-driven-development、condition-based-waiting、testing-anti-patterns、systematic-debugging、root-cause-tracing、verification-before-completion、defense-in-depth。
- **`karpathy-guidelines`（编码纪律，P0）**：S3 写码 / S5 评审时强制遵循，直接降 LLM 编码错误；与 `code-simplifier`/`improve-codebase-architecture`（事后重构）分工明确，不冲突。
- **`personal-workbench-squad`（可选增强 squad，P1）**：大型项目可在 S0–S6 并行调度其 9 角色（需求架构师/技术选型/UX/建造/自动化编排/数据治理/复盘优化等）。**分工约定**：该 squad 偏"工作台/工具链搭建"场景，本工作流偏"功能开发"；二者可并存，但不对同一份代码做重复架构/QA 评审（避免与承宇/守拙/明镜冲突）。
- 专家中心四类专家需在专家中心启用后，由本技能在对应阶段（S0/S1/S2 架构师、S4 QA、S5 三类专家）调用。
- 知识库来源：《千亿 tokens 得到的 vibe coding 工程实践》+《superpowers 全系列速查》+《mattpocock/skills 全系列速查》研读存档（均见 library 连接器）。
- **Matt Pocock 工程技能套件（整组，user-invoked 为主）**：`setup-matt-pocock-skills`（S0 前置脚手架）、`ask-matt`（入口路由器，可选）、`triage`（S1 on-ramp：外部 issue / PR 分诊）、`to-spec`（S1：对话合成 spec）、`to-tickets`（S1：拆 tracer-bullet 工单）、`wayfinder`（巨型模糊项目导航）、`grill-me` / `grill-with-docs` / `grilling`（S1 压力测试）、`prototype`（设计问题验证）、`research`（background agent 读 primary sources）、`resolving-merge-conflicts`（意图级解冲突，绝不 `--abort`）、`wizard`（把只有人能做的步骤脚本化：配密钥 / CI / 迁移）、`wait-what`（纠正没传达的信息）、`to-questionnaire`（问第三方填问卷）、`teach`（多会话学概念）。其中 `setup-matt-pocock-skills` / `ask-matt` / `to-spec` / `to-tickets` / `triage` / `wayfinder` 声明 `disable-model-invocation`，需用户手动触发（本工作流在 S0 / S1 给出调用指引即可，不强行自动调）。

---

## 已安装可用技能清单（按阶段，P0 已落地融合）

> 以下均为本机**已确认安装（用户级 `~/.workbuddy/skills/`）**的技能，可直接在对话中由本工作流路由调用。详尽的"全部 186 个用户级技能 + 37 个跨市场专家"全量清单见配套文档 `vibe-coding-skill-expert-inventory.md`。

| 阶段 | 技能 | 角色 |
|---|---|---|
| S0 | `setup-matt-pocock-skills`（Matt 套件前置：issue tracker/triage labels/CONTEXT.md 布局）、`domain-modeling`、`codebase-design`、`writing-for-agents`、`improve-codebase-architecture`、`setup-ts-deep-modules`、`skill-creator`、`git-guardrails-claude-code`、`setup-pre-commit` | 定义 infra / 共享语言 / 提交护栏 |
| S1 | `ask-matt`（入口路由，可选）、`brainstorming`、`writing-plans`、`grill-me`、`grill-with-docs`、`to-spec`、`research`、`to-tickets`、`triage`、`wayfinder`、`prototype` | 入口路由 + 出设计文档 + 压力测试 + 拆工单 |
| S2 | `tdd`、`test-driven-development`、`implement-spec`、`implement` | 契约/测试先行 |
| S3 | `subagent-driven-development`、`using-git-worktrees`、`finishing-a-development-branch`、`karpathy-guidelines`、`fullstack-developer__skillhub`、`frontend-inline-css-pitfalls`、`leader`、`github` | 长程编码 + 纪律 + 提交 |
| S4 | `systematic-debugging`、`diagnosing-bugs`、`root-cause-tracing`、`verification-before-completion`、`playwright-cli`、`agent-browser`、`retro` | 真实回归 + 调试闭环 |
| S5 | `dispatching-parallel-agents`、`code-review`、`receiving-code-review`、`requesting-code-review`、`pr`、`executing-plans`、`defense-in-depth` + 四专家 | 并行评审 + 八维门禁 |
| S6 | `skill-creator`、`writing-skills`、`workbuddy-expert-packaging`、`handoff` | 资产化 + 跨会话交接 |
| 元/纪律 | `using-superpowers`、`karpathy-guidelines` | 总纪律 + 编码纪律 |
| Matt 工具箱 | `resolving-merge-conflicts`、`wizard`、`wait-what`、`to-questionnaire`、`teach` | 解冲突 / 人步骤脚本化 / 沟通修正 / 问第三方 / 多会话学习 |

---

## 集成与冲突声明（兼容性 / 依赖 / 仲裁）

本工作流扫描了本机全部已装技能与专家后，按"是否填补阶段空白 / 是否与核心理念一致 / 冲突风险"三维度做了融合裁定：

- **P0 立即融入（已装、零冲突）**：上表全部 P0 技能 + 四专家 + superpowers 13 子技能。已落地到本文各阶段。
- **P1 融入并增强专家 MD**：`personal-workbench-squad`（可选 squad 引用）、`frontend-inline-css-pitfalls`（并入前端陷阱检查）。
- **P2 按需启用（声明为可选依赖，需先安装/启用）**：
  - `security-scan`（腾讯云鼎代码安全审计，Fast/Light/Deep 三模式）—— 与磐石（人工专家）**互补非冲突**：磐石定维度+读报告，security-scan 供深度扫描证据；
  - `pr-review-toolkit`（PR 审查代理集：注释/测试覆盖/错误处理/类型/质量）—— 与 `code-review`/明镜互补；
  - `code-simplifier`、`requirements-driven-workflow`、`hookify`（钩子防不当行为）。
  - ⚠️ 上述仅停留在 `codebuddy-plugins-official` 缓存、**未注册进市场**，使用前需先启用/安装；启用后由对应阶段引用。
- **P3 不融入、仅登记（避免门禁冲突）**：`feature-dev`、`agent-team-agile-workflow`、`oh-my-codebuddy` 同为"完整工作流/总编排"型，与本工作流**同层冲突**（两套门禁会打架）。**仲裁规则：vibe-coding-workflow 为唯一主编排**，其余同类工作流仅作备选、不并行主用。
- **`agent-browser`/`playwright-cli` 启用状态**：S4 真实回归依赖二者。若未启用，须在插件/技能管理中启用，否则 S4 降级为手动浏览器回归。

---



## 来源与参考

- 微信公众号「AI 原生之路」，《千亿 tokens 得到的 vibe coding 工程实践》（2026-09-28）。
- 微信公众号「超级奶爸老谭」，《superpowers 全系列回顾与速查合集》（2026-09-23）。
- 微信公众号「超级奶爸老谭」，《mattpocock/skills 全系列回顾与速查合集》（2026-08-19）。
- Anthropic《effective-harnesses-for-long-running-agents》—— initializer + coding agent 两代理长程架构。
- 《The Pragmatic Programmer》—— Tracer Bullet（曳光弹）模式。
- Matt Pocock 工程技能套件（本机已装）—— `setup-matt-pocock-skills` / `ask-matt` / `triage` / `to-spec` / `to-tickets` / `wayfinder` 及配套 standalone 工具，CONTEXT.md 共享语言、Deep Module、Vertical Slice、Red-Green-Refactor、触发模型、Phase boundaries 上下文管理。
